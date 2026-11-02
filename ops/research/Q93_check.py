"""Q93 gate (written by Claude before launch). Run from the repo root: python research/Q93_check.py

Q93 is a static audit: why the realtime engine's boxers and kickboxers never clinch (Q90: 0.000 of round time) while
real boxers clinch ~10% of it (K38). Nothing here trusts Qwen's list:
- every `_move_seat(` call whose to_stance is "clinch" is DERIVED from FightRealtime.gd and must have a row;
- every row's quote must really be within 3 lines of its cited line, and a non-"none" gate within 25 lines above;
- every catalogue node id Qwen cites must exist in assets/data/technique_catalog.json;
- every ruleset row must name the disciplines the ruleset's discipline_tags list in combat_rulesets.json.
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GODOT = ROOT / "Godot"
JSON_PATH = GODOT / "research" / "Q93_clinch_paths.json"
MD_PATH = GODOT / "research" / "Q93_WHY_BOXERS_NEVER_CLINCH.md"
ENGINE = GODOT / "scripts" / "FightRealtime.gd"
RULESETS = ["boxing", "kickboxing", "muay_thai", "mma"]

failures = []


def fail(msg):
    failures.append(msg)
    print("FAIL:", msg)


def clinch_sites(text):
    sites = []
    for m in re.finditer(r"_move_seat\(", text):
        start = m.start()
        if "static func _move_seat" in text[max(0, start - 20):start + 12]:
            continue
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
        args = [a.strip() for a in text[start + len("_move_seat("):end].split(",")]
        if len(args) >= 5 and args[4] == '"clinch"':
            sites.append(text.count("\n", 0, start) + 1)
    return sites


def main():
    for p in (JSON_PATH, MD_PATH):
        if not p.is_file():
            fail("missing %s" % p.relative_to(ROOT))
    if failures:
        return finish()
    text = ENGINE.read_text(encoding="utf-8")
    lines = text.splitlines()
    data = json.loads(JSON_PATH.read_text(encoding="utf-8"))
    rows = data.get("sites", [])
    for i, row in enumerate(rows):
        for key in ("file", "line", "quote", "gate", "what"):
            if key not in row:
                fail("site %d lacks %s" % (i, key))
        if row.get("file") != "Godot/scripts/FightRealtime.gd":
            continue
        line_no = int(row.get("line", 0))
        window = lines[max(0, line_no - 4):line_no + 3]
        quote = str(row.get("quote", "")).strip()
        if not quote or not any(quote in w for w in window):
            fail("site %d: quote %r is not within 3 lines of FightRealtime.gd:%d" % (i, quote, line_no))
        gate = str(row.get("gate", ""))
        if gate != "none" and gate.strip() not in "\n".join(lines[max(0, line_no - 26):line_no]):
            fail("site %d: gate %r is not in the 25 lines above FightRealtime.gd:%d" % (i, gate, line_no))
    for line_no in clinch_sites(text):
        if not any(r.get("file") == "Godot/scripts/FightRealtime.gd" and abs(int(r.get("line", -99)) - line_no) <= 3
                   for r in rows):
            fail("derived clinch entry at FightRealtime.gd:%d has no row" % line_no)

    catalog = json.loads((GODOT / "assets" / "data" / "technique_catalog.json").read_text(encoding="utf-8"))
    node_ids = {str(n.get("id", "")) for d in catalog.get("disciplines", []) for n in d.get("nodes", [])}
    rules = {r["id"]: r for r in json.loads((GODOT / "assets" / "data" / "combat_rulesets.json").read_text(encoding="utf-8"))["rulesets"]}
    palettes = data.get("rulesets", {})
    for rid in RULESETS:
        row = palettes.get(rid)
        if not isinstance(row, dict):
            fail("no ruleset row for %s" % rid)
            continue
        named = set(str(x) for x in row.get("discipline_tags", []))
        want = set(str(x) for x in rules[rid].get("discipline_tags", []))
        if named != want:
            fail("%s: discipline_tags %s != combat_rulesets.json %s" % (rid, sorted(named), sorted(want)))
        for node_id in row.get("clinch_nodes", []):
            if str(node_id) not in node_ids:
                fail("%s: clinch node %r is not in technique_catalog.json" % (rid, node_id))
        if "why" not in row or not str(row["why"]).strip():
            fail("%s: no 'why'" % rid)
    md = MD_PATH.read_text(encoding="utf-8")
    if not md.lstrip().startswith("## DECISIONS"):
        fail("the markdown must open with ## DECISIONS")
    return finish()


def finish():
    print("Q93_check: %d failure(s)" % len(failures))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
