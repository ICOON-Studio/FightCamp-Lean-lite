"""agent_router.py (S214) - decides which agent seat takes a task, from live meters + roles + who is free.

Operator S214: "can it show meters for codex too and the other paid agents and take decisions ?"

Rules it applies (each from an operator ruling, CLAUDE.md s8 / memory):
  - ROLE first (roster roles, S178): pure module+tests -> Arena (cloud, free, first choice); big multi-file/tools -> Codex;
    Godot UI/gameplay -> Cursor; small pure -> Qwen; research -> John/Dola; design -> Kalli; art -> Maria.
  - BUSY seats are skipped (live_runs.json status running); at most 3 shell agents on the PC at once.
  - PC seats need the watchdog not RED; cloud seats ignore it.
  - METERS: a seat whose plan window is >= 90% used is skipped; Codex plan quota is lost if unused, so Codex is preferred
    for code while it has headroom (S201); a money meter (GitHub $ budget) >= 90% blocks GitHub-runner work.

    python Tools/agent_router.py "add a pure module for X with tests"
    python Tools/agent_router.py --kind ui "the profile header bar"
    python Tools/agent_router.py --json --kind research "..."
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "Tools"))
import agent_meters  # noqa: E402

SHELL_CAP = 3
FULL = 90.0
# kind -> seats in preference order; (seat, where, meter)
SEATS: dict[str, list[tuple[str, str, str | None]]] = {
    "pure": [("arena", "cloud", None), ("codex", "pc", "codex"), ("qwen", "pc", None), ("cursor", "pc", None)],
    "code": [("codex", "pc", "codex"), ("arena", "cloud", None), ("cursor", "pc", None)],
    "ui": [("cursor", "pc", None), ("codex", "pc", "codex")],
    "animation": [("codex", "pc", "codex"), ("claude", "pc", "claude")],
    "research": [("john", "cloud", None), ("dola", "cloud", None)],
    "design": [("ludo", "cloud", None), ("kalli", "cloud", None)],
    "art": [("maria", "cloud", None), ("ludo", "cloud", None)],
    "visual": [("claude", "pc", "claude")],
}
SHELL = {"codex", "cursor", "qwen", "antigravity", "cline"}
KEYWORDS = [
    ("animation", r"\b(anim|clip|punch|guard|mocap|cascadeur|retarget|pose)"),
    ("visual", r"\b(still|render|camera|screenshot|video)\b"),
    ("ui", r"\b(ui|screen|panel|hud|button|header|menu|overlay|layout)\b"),
    ("research", r"\b(research|study|studies|how do .* games|sources|benchmark)\b"),
    ("design", r"\b(design|mechanic|loop|balance|pacing)\b"),
    ("art", r"\b(art|palette|mood ?board|mockup|look)\b"),
    ("pure", r"\b(pure|module|maths|math|formula|unit test)\b"),
]


def guess_kind(task: str) -> str:
    for kind, pat in KEYWORDS:
        if re.search(pat, task, re.I):
            return kind
    return "code"


def busy() -> dict[str, list[str]]:
    try:
        runs = json.loads((ROOT / "AgentComms" / "live_runs.json").read_text(encoding="utf-8")).get("runs", {})
    except (OSError, ValueError):
        return {}
    out: dict[str, list[str]] = {}
    for rid, r in runs.items():
        if isinstance(r, dict) and r.get("status") == "running":
            out.setdefault(str(r.get("agent", "")), []).append(rid)
    return out


def watchdog() -> str:
    try:
        out = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                              str(ROOT / "Tools" / "pc_watchdog.ps1"), "-Once"], capture_output=True, text=True, timeout=60).stdout
    except (OSError, subprocess.SubprocessError):
        return "UNKNOWN"
    m = re.search(r"\d{4}-\d\d-\d\d [\d:]+ (GREEN|AMBER|RED)", out)
    return m.group(1) if m else "UNKNOWN"


def decide(task: str, kind: str | None = None, meters: dict[str, Any] | None = None, running: dict[str, list[str]] | None = None,
           pc: str | None = None) -> dict[str, Any]:
    kind = kind or guess_kind(task)
    meters = meters or agent_meters.all_meters()
    running = busy() if running is None else running
    pc = pc or watchdog()
    by = {m["agent"]: m for m in meters["meters"]}
    shells_running = sum(len(v) for k, v in running.items() if k in SHELL)
    ranked = []
    for seat, where, meter in SEATS.get(kind, SEATS["code"]):
        why: list[str] = []
        ok = True
        if running.get(seat):
            ok = False
            why.append("busy on " + ", ".join(running[seat]))
        if where == "pc" and seat in SHELL and shells_running >= SHELL_CAP:
            ok = False
            why.append("%d shell agents already running (cap %d)" % (shells_running, SHELL_CAP))
        if where == "pc" and pc == "RED":
            ok = False
            why.append("PC watchdog RED")
        m = by.get(meter) if meter else None
        if m is not None:
            used = m.get("worst_used_pct")
            if used is not None and used >= FULL:
                ok = False
                why.append("%s plan %.0f%% used" % (seat, used))
            elif used is not None:
                why.append("%s plan %.0f%% used%s" % (seat, used, "" if m.get("live") else " (stale reading)"))
            if seat == "codex" and used is not None and used < 70:
                why.append("plan quota is lost if unused - use it")
        ranked.append({"seat": seat, "where": where, "ok": ok, "why": "; ".join(why) or "free"})
    pick = next((r for r in ranked if r["ok"]), None)
    return {"task": task, "kind": kind, "pc": pc, "pick": pick["seat"] if pick else None,
            "reason": (pick["why"] if pick else "no seat free - queue it"), "ranked": ranked}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("task", nargs="?", default="")
    ap.add_argument("--kind", choices=sorted(SEATS))
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args()
    d = decide(a.task, a.kind)
    if a.json:
        print(json.dumps(d, indent=1))
        return 0
    print("TASK  %s\nKIND  %s   PC %s\nPICK  %s - %s" % (d["task"] or "(none)", d["kind"], d["pc"], d["pick"] or "NONE", d["reason"]))
    for r in d["ranked"]:
        print("  %-8s %-5s %-4s %s" % (r["seat"], r["where"], "ok" if r["ok"] else "no", r["why"]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
