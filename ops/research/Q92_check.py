"""Q92 gate (written by Claude before launch). Run from the repo root: python research/Q92_check.py

Q92 measures the knockdown COUNT (S4a (3)) through Qwen's own instrument. Pins that do not come from Qwen:
- tests/fight_knockdown_count_test.gd printed "counts over 20 bouts: 12" for the room's demo pair, boxing, seeds
  810000-810019, three rounds, at the commit that landed the count - the witness row must reproduce exactly 12;
- J15's ordinary count is 10-25 s, and the engine's model spans exactly that: every count event's length_s and every
  bout's count ticks must sit inside it;
- a decision bout fights three rounds and two rests of ROUND CLOCK: tick - held_ticks == (3 x round + 2 x rest) x hz;
- a held bell can only be held while a count runs: held ticks never exceed 25 s x counts;
- rulesets and their round lengths are READ from combat_rulesets.json; the tool may not name any Q92 file.
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GODOT = ROOT / "Godot"
JSON_PATH = GODOT / "research" / "Q92_knockdown_counts.json"
MD_PATH = GODOT / "research" / "Q92_THE_COUNT_MEASURED.md"
TOOL_PATH = GODOT / "tools" / "measure_knockdown_counts.gd"
RULESETS = ["boxing", "kickboxing", "muay_thai"]
BOUTS = 60
WITNESS_COUNTS = 12

failures = []


def fail(msg):
    failures.append(msg)
    print("FAIL:", msg)


def check_bout(label, bout, hz, rounds, round_s, rest_s):
    counts = int(bout.get("counts_started", -1))
    ticks = int(bout.get("count_ticks", -1))
    held = int(bout.get("held_ticks", -1))
    if counts < 0 or ticks < 0 or held < 0:
        fail("%s: counts_started / count_ticks / held_ticks missing" % label)
        return 0
    if counts > 0 and not (counts * (10 * hz - 1) <= ticks <= counts * (25 * hz + 1)):
        fail("%s: %d counts took %d ticks - outside 10-25 s each" % (label, counts, ticks))
    if counts == 0 and ticks != 0:
        fail("%s: count ticks without a count" % label)
    if held > counts * 25 * hz:
        fail("%s: the bell was held %d ticks for %d counts" % (label, held, counts))
    lengths = bout.get("count_lengths_s", [])
    if len(lengths) != counts:
        fail("%s: %d count events logged for %d counts" % (label, len(lengths), counts))
    for length in lengths:
        if not (10.0 - 1e-6 <= float(length) <= 25.0 + 1e-6):
            fail("%s: a count of %.3f s is outside J15's 10-25 s" % (label, float(length)))
    if not bool(bout.get("counts_paired", False)):
        fail("%s: a count event without its count_end (or an action between them)" % label)
    if str(bout.get("method", "")) == "DECISION":
        want = int(round((rounds * round_s + (rounds - 1) * rest_s) * hz))
        got = int(bout.get("tick", -1)) - held
        if abs(got - want) > 1:
            fail("%s: a DECISION's round clock read %d ticks, the clock says %d" % (label, got, want))
    return counts


def main():
    for p in (JSON_PATH, MD_PATH, TOOL_PATH):
        if not p.is_file():
            fail("missing %s" % p.relative_to(ROOT))
    if failures:
        return finish()
    if re.search(r"Q92_", TOOL_PATH.read_text(encoding="utf-8")):
        fail("the tool names a Q92 file")
    rules = {r["id"]: r for r in json.loads((GODOT / "assets" / "data" / "combat_rulesets.json").read_text(encoding="utf-8"))["rulesets"]}
    data = json.loads(JSON_PATH.read_text(encoding="utf-8"))
    hz = int(data.get("hz", 0))
    if hz <= 0 or not data.get("population"):
        fail("hz or population missing")
        return finish()
    for rid in RULESETS:
        row = data.get("rulesets", {}).get(rid)
        if not isinstance(row, dict):
            fail("no row for %s" % rid)
            continue
        bouts = row.get("bouts", [])
        if len(bouts) != BOUTS:
            fail("%s: %d bouts, want %d" % (rid, len(bouts), BOUTS))
        total = 0
        for i, bout in enumerate(bouts):
            total += check_bout("%s bout %d" % (rid, i), bout, hz, 3, float(rules[rid]["round_seconds"]), float(rules[rid]["rest_seconds"]))
        if int(row.get("counts_total", -1)) != total:
            fail("%s: counts_total %s != summed %d" % (rid, row.get("counts_total"), total))
    witness = data.get("witness", {})
    bouts = witness.get("bouts", [])
    if len(bouts) != 20:
        fail("witness: %d bouts, want 20 (seeds 810000-810019)" % len(bouts))
    total = 0
    for i, bout in enumerate(bouts):
        total += check_bout("witness bout %d" % i, bout, hz, 3, float(rules["boxing"]["round_seconds"]), float(rules["boxing"]["rest_seconds"]))
    if total != WITNESS_COUNTS:
        fail("witness: %d counts over seeds 810000-810019 - tests/fight_knockdown_count_test.gd printed %d" % (total, WITNESS_COUNTS))
    md = MD_PATH.read_text(encoding="utf-8")
    if not md.lstrip().startswith("## DECISIONS"):
        fail("the markdown must open with ## DECISIONS")
    return finish()


def finish():
    print("Q92_check: %d failure(s)" % len(failures))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
