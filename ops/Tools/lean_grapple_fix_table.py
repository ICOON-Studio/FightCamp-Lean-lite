"""lean_grapple_fix_table.py - every played grappling move measured PURE and AS THE GAME DRAWS IT (S399 GRAPPLEFIX1).

Runs Lean/tools/grapple_orbit.gd headless, numbers only (`nofilm=1`), once per arm, on the 47 moves the belt match plays
(Tools/lean_grapple_catalogue.py rows[].id; a reversed row plays reversed and a takedown or sweep lands fast in the game arm,
as GrappleBrowser.play_out does). Every Godot run goes through Tools/godot_slot.py. Writes the rows to
AgentComms/grapplefix_<label>.json and, with --table, research/GRAPPLEFIX1_TABLE.md (worst game-arm move first).

Bars (TASK_GRAPPLEFIX1): torso inside <= 3 cm, a limb parked in a body <= 2 cm for over 0.2 s, pop <= 3 cm in one frame,
jerk p95 <= 60 m/s^3, flips <= 0.1 /s.

    python ops/Tools/lean_grapple_fix_table.py --label main             # measure both arms, save AgentComms/grapplefix_main.json
    python ops/Tools/lean_grapple_fix_table.py --label after --game-only
    python ops/Tools/lean_grapple_fix_table.py --table main after       # the table: pure, game on main, game after
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = ROOT.parent
GODOT = Path(os.environ.get("LOCALAPPDATA", "")) / "Programs" / "Godot" / "Godot_v4.7.2-stable_win64.exe"
BARS = {"torso_in_m": 0.03, "limb_park_m": 0.02, "spike_m": 0.03, "jerk_p95": 60.0, "flips_s": 0.1}


def moves() -> list[dict]:
    out = subprocess.run([sys.executable, str(ROOT / "Tools" / "lean_grapple_catalogue.py"), "--json"], capture_output=True,
                         text=True, check=True, cwd=ROOT).stdout
    rows = json.loads(out)["rows"]
    seen, res = set(), []
    for r in rows:
        if r.get("id") is None:
            continue
        tok = f"{r['id']}{'r' if r.get('reverse') else ''}{'l' if r.get('kind') in ('takedown', 'sweep') else ''}"
        if tok in seen:
            continue
        seen.add(tok)
        res.append({"tok": tok, "id": f"{r['id']}{'r' if r.get('reverse') else ''}", "title": r["title"], "kind": r["kind"]})
    return res


def run_arm(toks: list[str], game: bool) -> dict:
    args = ["nofilm=1", "ids=" + ",".join(toks)] + (["game=1"] if game else [])
    cmd = [sys.executable, str(ROOT / "Tools" / "godot_slot.py"), "run", "--who", "grapple", "--", str(GODOT), "--headless",
           "--fixed-fps", "30", "--audio-driver", "Dummy", "--path", str(LEAN), "--script", "res://tools/grapple_orbit.gd",
           "--"] + args
    proc = subprocess.run(cmd, cwd=LEAN, capture_output=True, text=True, errors="replace")
    rows = {}
    for line in (proc.stdout + proc.stderr).splitlines():
        if line.startswith("GORBIT_JSON "):
            row = json.loads(line[len("GORBIT_JSON "):])
            rows[str(row["id"])] = row
        elif "SCRIPT ERROR" in line:
            print(line, flush=True)
    return rows


def fails(row: dict) -> list[str]:
    return [k for k, bar in BARS.items() if float(row.get(k, 0.0)) > bar]


def badness(row: dict) -> float:
    return sum(max(0.0, float(row.get(k, 0.0)) / bar - 1.0) for k, bar in BARS.items())


def measure(label: str, game_only: bool, toks: list[str] | None) -> None:
    ms = moves()
    if toks:
        ms = [m for m in ms if m["tok"] in toks or m["id"] in toks]
    data = {"moves": ms}
    if not game_only:
        data["pure"] = run_arm([m["id"].rstrip("r") for m in ms], False)
    data["game"] = run_arm([m["tok"] for m in ms], True)
    out = ROOT / "AgentComms" / f"grapplefix_{label}.json"
    out.write_text(json.dumps(data, indent=1) + "\n", encoding="utf-8")
    g = data["game"]
    passing = [m["id"] for m in ms if m["id"] in g and not fails(g[m["id"]])]
    print(f"GRAPPLEFIX {label}: {len(g)}/{len(ms)} measured, {len(passing)} pass every bar: {','.join(passing)}")
    for m in sorted(ms, key=lambda m: -badness(g.get(m["id"], {}))):
        r = g.get(m["id"])
        if r:
            print(f"  {m['id']:6} {m['title'][:34]:34} torso {r['torso_in_m']:.3f} park {r['limb_park_m']:.3f} "
                  f"pop {r['spike_m']:.3f} jerk {r['jerk_p95']:6.1f} flips {r['flips_s']:.2f}  {','.join(fails(r))}")


def cell(r: dict | None, k: str, fmt: str) -> str:
    if not r:
        return "-"
    v = float(r.get(k, 0.0))
    s = format(v * 100 if k in ("torso_in_m", "limb_park_m", "spike_m") else v, fmt)
    return f"**{s}**" if v > BARS[k] else s


def table(labels: list[str]) -> None:
    sets = [json.loads((ROOT / "AgentComms" / f"grapplefix_{l}.json").read_text(encoding="utf-8")) for l in labels]
    base = sets[0]
    pure = base.get("pure", {})
    games = [(l, s["game"]) for l, s in zip(labels, sets)]
    last = games[-1][1]
    ms = sorted(base["moves"], key=lambda m: -badness(games[0][1].get(m["id"], {})))
    keys = [("torso_in_m", ".1f", "torso cm"), ("limb_park_m", ".1f", "park cm"), ("spike_m", ".1f", "pop cm"),
            ("jerk_p95", ".0f", "jerk"), ("flips_s", ".2f", "flips/s")]
    lines = ["# GRAPPLEFIX1 - the 47 played moves, pure vs as the game draws them", "",
             "S399 GRAPPLEFIX1. Measured by `ops/Tools/lean_grapple_fix_table.py` (tools/grapple_orbit.gd `nofilm=1`, headless, "
             "--fixed-fps 30, bones read on Skeleton3D.skeleton_updated). **pure** = the GrappleMap recording on our women, no layers "
             "(what the board's previews showed). **game** = the belt match's drawing: GrapplePlayer contact on (GrappleDrawn placement, "
             "GrappleLimbs clearance + holds), GrapplePose IK, GrappleGrip, the browser's pacing. Each cell is `" +
             " / ".join(labels_for(labels)) + "`. Bold = over the bar.", "",
             "Bars: torso inside <= 3 cm; a limb or head parked inside the other's torso/head <= 2 cm for over 0.2 s; one-frame pop "
             "<= 3 cm; jerk p95 <= 60 m/s^3; direction flips <= 0.1 /s per bone. Sorted worst first by the game arm on `" + labels[0] + "`.", ""]
    for l, g in games:
        n = sum(1 for m in base["moves"] if m["id"] in g and not fails(g[m["id"]]))
        lines.append(f"- game `{l}`: **{n}/{len(base['moves'])}** moves pass every bar")
    npure = sum(1 for m in base["moves"] if m["id"] in pure and not fails(pure[m["id"]]))
    lines += [f"- pure: {npure}/{len(base['moves'])}", ""]
    lines.append("| move | kind | " + " | ".join(h for _, _, h in keys) + " | fails (game " + labels[-1] + ") |")
    lines.append("|---|---|" + "---|" * len(keys) + "---|")
    for m in ms:
        cells = []
        for k, fmt, _ in keys:
            cells.append(" / ".join([cell(pure.get(m["id"]), k, fmt)] + [cell(g.get(m["id"]), k, fmt) for _, g in games]))
        lines.append(f"| {m['id']} {m['title'][:32]} | {m['kind']} | " + " | ".join(cells) + " | " +
                     (", ".join(fails(last[m["id"]])) if m["id"] in last else "-") + " |")
    lines.append("")
    (ROOT / "research" / "GRAPPLEFIX1_TABLE.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print("wrote research/GRAPPLEFIX1_TABLE.md")


def labels_for(labels: list[str]) -> list[str]:
    return ["pure"] + [f"game {l}" for l in labels]


def main(argv: list[str]) -> int:
    if "--table" in argv:
        table([a for a in argv[argv.index("--table") + 1:] if not a.startswith("--")])
        return 0
    label = argv[argv.index("--label") + 1] if "--label" in argv else "main"
    toks = argv[argv.index("--ids") + 1].split(",") if "--ids" in argv else None
    measure(label, "--game-only" in argv, toks)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
