#!/usr/bin/env python3
"""clip_rate_batch.py - rate every boxing clip the fight plays with the local Ollama clip judge (S399).

Operator S399: "its also all other move animations we are missing too, and those we have, have they been rated, i want to
start seeing clips on the board". The catalogue (lean_anim_catalogue.py) had 153 clips, 0 verified, 126 never checked.
This walks the IN GAME clips (then LOADED with --all), judges each preview (ops/previews/lean_anim/<id>.mp4) with
`ollama_judge.py --kind clip`, and appends a row to AgentComms/clip_verdicts.json "boxing" - the ops board's Boxer
animations page shows it. An Ollama row never passes a clip (the bar stays: his OK or Argon 9/10+); it ranks them.
Resumable: a clip that already has an S399 Ollama row is skipped. Writes the json after every clip.

    python ops/Tools/clip_rate_batch.py [--all] [--limit N]
    python ops/Tools/clip_rate_batch.py --table      # the scores so far, worst first
    python ops/Tools/clip_rate_batch.py --post Guard # one board post for a catalogue group, captioned, worst first
"""
from __future__ import annotations

import json
import re
import subprocess
import sys
import time
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
ROOT = TOOLS.parent
VERDICTS = ROOT / "AgentComms" / "clip_verdicts.json"
PREVIEWS = ROOT / "previews" / "lean_anim"
CHECK = "Ollama gemma4:12b clip judge S399 (LOW TRUST, ranks only)"
SCORE = re.compile(r"score[\s*:]*\**\s*(\d+(?:\.\d+)?)\s*/\s*10", re.I)
VERDICT = re.compile(r"\b(SHIP|FIX|CUT)\b")


def load() -> dict:
    return json.loads(VERDICTS.read_text(encoding="utf-8"))


def save(d: dict) -> None:
    VERDICTS.write_text(json.dumps(d, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")


def rows(include_loaded: bool) -> list[dict]:
    out = subprocess.run([sys.executable, TOOLS / "lean_anim_catalogue.py", "--json"], capture_output=True, text=True,
                         encoding="utf-8").stdout
    cat = json.loads(out)
    return [r for g in cat["groups"] for r in g["rows"] if r["status"] == "IN GAME" or include_loaded]


def rated(d: dict, cid: str) -> bool:
    return any(x.get("check") == CHECK for x in d.get("boxing", {}).get(cid, []))


def table() -> None:
    d = load()
    got = []
    for cid, checks in d.get("boxing", {}).items():
        for x in checks:
            if x.get("check") == CHECK:
                m = re.match(r"\s*(\d+(?:\.\d+)?)/10", str(x.get("result", "")))
                got.append((float(m.group(1)) if m else -1.0, cid, str(x.get("result", "")), str(x.get("note", ""))[:110]))
    for s, cid, res, note in sorted(got):
        print(f"{s:4.1f}  {cid:42s} {res:14s} {note}")
    if got:
        ss = sorted(g[0] for g in got if g[0] >= 0)
        print(f"CLIP_RATE n={len(got)} median={ss[len(ss) // 2] if ss else '-'} under6={sum(1 for s in ss if s < 6)}")


def post(group: str) -> int:
    """S399 'i want to start seeing clips on the board': one review post per catalogue group, every clip captioned with
    its score and first defect; worst first. Posts only when every clip in the group has an S399 row."""
    cat = json.loads(subprocess.run([sys.executable, TOOLS / "lean_anim_catalogue.py", "--json"], capture_output=True,
                                    text=True, encoding="utf-8").stdout)
    g = next((g for g in cat["groups"] if g["group"].lower().startswith(group.lower())), None)
    if g is None:
        print(f"CLIP_POST no group {group}")
        return 2
    d = load()
    got = []
    for r in g["rows"]:
        row = next((x for x in reversed(d.get("boxing", {}).get(r["id"], [])) if x.get("check") == CHECK), None)
        if row is None:
            print(f"CLIP_POST {g['group']}: {r['id']} not rated yet")
            return 1
        m = re.match(r"\s*(\d+(?:\.\d+)?)/10", str(row["result"]))
        got.append((float(m.group(1)) if m else -1.0, r["id"], row))
    got.sort()
    files = [f"{(PREVIEWS / f'{cid}.mp4').as_posix()}={cid}: {row['result']} - {row['note'][:90] or 'no defect named'}"
             for _, cid, row in got]
    ss = [s for s, _, _ in got if s >= 0]
    rating = f"Ollama gemma4 clip judge (low trust, ranks only): median {ss[len(ss) // 2]:.0f}/10, {sum(1 for s in ss if s < 6)} under 6"
    p = subprocess.run([sys.executable, TOOLS / "review_add.py", "--title", f"Boxer clips: {g['group']} ({len(got)}), worst first",
                        "--stage", "S399", "--rating", rating, *files], capture_output=True, text=True, encoding="utf-8")
    print((p.stdout + p.stderr).strip()[-300:])
    return p.returncode


def main(argv: list[str]) -> int:
    if "--post" in argv:
        return post(argv[argv.index("--post") + 1])
    if "--table" in argv:
        table()
        return 0
    limit = int(argv[argv.index("--limit") + 1]) if "--limit" in argv else 10 ** 6
    done = 0
    for r in rows("--all" in argv):
        cid = r["id"]
        mp4 = PREVIEWS / f"{cid}.mp4"
        if done >= limit or rated(load(), cid) or not mp4.is_file():
            continue
        md = mp4.with_suffix(".gemini_argon.md")
        md.unlink(missing_ok=True)
        t0 = time.time()
        for _wait in range(60):   # S399: a RED watchdog skips the judge - wait it out (1 min a try), never skip the clip
            p = subprocess.run([sys.executable, TOOLS / "ollama_judge.py", mp4, "--kind", "clip", "--what", cid,
                                "--intent", f"{r.get('label', cid)} ({r.get('why', '')})", "--every", "1.0"],
                               capture_output=True, text=True, encoding="utf-8", timeout=1800)
            if "watchdog RED" not in p.stdout:
                break
            time.sleep(60)
        if p.returncode != 0 or not md.is_file():
            print(f"CLIP_RATE {cid}: judge failed {(p.stdout + p.stderr).strip()[-160:]}")
            continue
        text = md.read_text(encoding="utf-8", errors="replace")
        m = SCORE.findall(text)
        v = VERDICT.findall(text)
        score = m[-1] if m else "?"
        defect = next((ln.strip(" *-#") for ln in text.splitlines() if re.search(r"\d:\d\d|\d\.\d\s*s", ln)
                       and not ln.lower().startswith("# judge")), "")
        d = load()
        d.setdefault("boxing", {}).setdefault(cid, []).append({
            "check": CHECK, "result": f"{score}/10 {v[-1] if v else ''}".strip(), "pass": False,
            "note": defect[:240], "source": md.relative_to(ROOT).as_posix(), "when": time.strftime("%Y-%m-%d")})
        save(d)
        done += 1
        print(f"CLIP_RATE {cid}: {score}/10 {v[-1] if v else ''} ({time.time() - t0:.0f} s)", flush=True)
    table()
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
