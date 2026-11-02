"""Q91 gate (written by Claude before launch). Run from the repo root: python research/Q91_check.py

Q91 is a static audit: every place the realtime engine can put a bout on the ground, open a submission or finish
one, and whether a ruleset decides it. Nothing here trusts Qwen's list:
- the call sites are DERIVED from the source by this script (multi-line `_move_seat(` calls whose to_stance is
  "ground", every `"sub_open"] = true`, every `_finish_submission(` call) and each must appear in the table;
- every row's `quote` must really be in the file within 3 lines of the row's line (citations cannot be invented);
- every `gate` that is not "none" must quote code that really is within 25 lines above the site.
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GODOT = ROOT / "Godot"
JSON_PATH = GODOT / "research" / "Q91_ground_paths.json"
MD_PATH = GODOT / "research" / "Q91_GROUND_PATHS.md"
ENGINE = GODOT / "scripts" / "FightRealtime.gd"

failures = []


def fail(msg):
    failures.append(msg)
    print("FAIL:", msg)


def derived_sites(lines):
    text = "\n".join(lines)
    sites = []
    for m in re.finditer(r"_move_seat\(", text):
        start = m.start()
        depth = 0
        end = start
        for i in range(m.end() - 1, len(text)):
            if text[i] == "(":
                depth += 1
            elif text[i] == ")":
                depth -= 1
                if depth == 0:
                    end = i
                    break
        call = text[start:end + 1]
        if "static func _move_seat" in text[max(0, start - 20):start + 12]:
            continue
        args = [a.strip() for a in call[len("_move_seat("):-1].split(",")]
        if len(args) >= 5 and args[4] == '"ground"':
            sites.append(("ground_entry", text.count("\n", 0, start) + 1))
    for i, line in enumerate(lines, 1):
        if '"sub_open"] = true' in line:
            sites.append(("submission_open", i))
        if "_finish_submission(" in line and "static func" not in line:
            sites.append(("submission_finish", i))
    return sites


def main():
    for p in (JSON_PATH, MD_PATH):
        if not p.is_file():
            fail("missing %s" % p.relative_to(ROOT))
    if failures:
        return finish()
    lines = ENGINE.read_text(encoding="utf-8").splitlines()
    data = json.loads(JSON_PATH.read_text(encoding="utf-8"))
    rows = data.get("rows", [])
    if not rows:
        fail("no rows")
        return finish()
    for i, row in enumerate(rows):
        for key in ("kind", "file", "line", "quote", "gate", "what"):
            if key not in row:
                fail("row %d lacks %s" % (i, key))
        if row.get("file") != "Godot/scripts/FightRealtime.gd":
            continue
        line_no = int(row.get("line", 0))
        window = lines[max(0, line_no - 4):line_no + 3]
        if str(row.get("quote", "")).strip() == "" or not any(str(row["quote"]).strip() in w for w in window):
            fail("row %d: quote %r is not within 3 lines of FightRealtime.gd:%d" % (i, row.get("quote"), line_no))
        gate = str(row.get("gate", ""))
        if gate != "none":
            above = "\n".join(lines[max(0, line_no - 26):line_no])
            if gate.strip() not in above:
                fail("row %d: gate %r is not in the 25 lines above FightRealtime.gd:%d" % (i, gate, line_no))
    for kind, line_no in derived_sites(lines):
        if not any(r.get("kind") == kind and r.get("file") == "Godot/scripts/FightRealtime.gd"
                   and abs(int(r.get("line", -99)) - line_no) <= 3 for r in rows):
            fail("derived %s at FightRealtime.gd:%d has no row" % (kind, line_no))
    md = MD_PATH.read_text(encoding="utf-8")
    if not md.lstrip().startswith("## DECISIONS"):
        fail("the markdown must open with ## DECISIONS")
    return finish()


def finish():
    print("Q91_check: %d failure(s)" % len(failures))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
