"""Q90 gate (written by Claude before launch). Exit 0 only when Qwen's delivery is complete AND consistent
with instruments Qwen did not write. Run from the repo root: python research/Q90_check.py

What it checks, and where each reference comes from:
- the rulesets and their round lengths are READ from Godot/assets/data/combat_rulesets.json (derived, never copied);
- a decision bout fights exactly rounds x round_seconds of round time (PHYSICS of the clock - C107's lesson:
  its first delivery reported 51 s bouts and passed a loose bound);
- stance ticks add up to the round ticks of the bout (a share cannot come from nowhere);
- the witness (Grappler vs Fish, muay thai, seed 93248, 3 rounds) must end by SUBMISSION - pinned to an
  INDEPENDENT instrument: tests/grapple_adapter_test.gd printed `method=SUBMISSION` for exactly this bout under
  C109's ruleset round lengths (2026-09-13), before Q90 existed;
- the tool may not read any Q90 output or this checker (a tool that can read its reference will copy it).
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GODOT = ROOT / "Godot"
JSON_PATH = GODOT / "research" / "Q90_ground_by_ruleset.json"
MD_PATH = GODOT / "research" / "Q90_GROUND_UNDER_STRIKING_RULES.md"
TOOL_PATH = GODOT / "tools" / "measure_ground_by_ruleset.gd"
RULESETS = ["boxing", "kickboxing", "muay_thai", "mma"]
BOUTS = 60

failures = []


def fail(msg):
    failures.append(msg)
    print("FAIL:", msg)


def main():
    for p in (JSON_PATH, MD_PATH, TOOL_PATH):
        if not p.is_file():
            fail("missing %s" % p.relative_to(ROOT))
    if failures:
        return finish()

    tool_src = TOOL_PATH.read_text(encoding="utf-8")
    if re.search(r"Q90_|Q90_check", tool_src):
        fail("the tool names a Q90 file - it must measure, never read its own reference or output")
    if "advance_tick" not in tool_src:
        fail("the tool must step FightRealtime.advance_tick and sample the stance each tick")
    if "style_fighter" not in tool_src:
        fail("the tool must book measure_ruleset_sweep.gd's style_fighter pairs (legal, different men)")
    if re.search(r'"round_seconds"\s*:', tool_src) or re.search(r'\[\s*"round_seconds"\s*\]\s*=', tool_src):
        fail("the tool must not pass round_seconds - the engine books the ruleset's own length (C109)")

    rules_doc = json.loads((GODOT / "assets" / "data" / "combat_rulesets.json").read_text(encoding="utf-8"))
    rules = {r["id"]: r for r in rules_doc["rulesets"]}

    data = json.loads(JSON_PATH.read_text(encoding="utf-8"))
    pop = data.get("population", {})
    if not isinstance(pop, dict) or not pop:
        fail("population block missing - a measurement names its fighters and its catalogue")
    hz = int(data.get("hz", 0))
    if hz <= 0:
        fail("hz missing")
        return finish()

    rows = data.get("rulesets", {})
    for rid in RULESETS:
        row = rows.get(rid)
        if not isinstance(row, dict):
            fail("no row for %s" % rid)
            continue
        bouts = row.get("bouts", [])
        if len(bouts) != BOUTS:
            fail("%s: %d bouts, want %d" % (rid, len(bouts), BOUTS))
        rounds = int(row.get("rounds", 0))
        round_s = float(rules[rid]["round_seconds"])
        if abs(float(row.get("round_seconds", -1)) - round_s) > 1e-6:
            fail("%s: row round_seconds %s != ruleset %s" % (rid, row.get("round_seconds"), round_s))
        methods = {}
        for i, bout in enumerate(bouts):
            method = str(bout.get("method", ""))
            methods[method] = methods.get(method, 0) + 1
            ticks = {k: int(bout.get("stance_ticks", {}).get(k, 0)) for k in ("standing", "clinch", "ground")}
            round_ticks = int(bout.get("round_ticks", -1))
            if sum(ticks.values()) != round_ticks:
                fail("%s bout %d: stance ticks %d != round ticks %d" % (rid, i, sum(ticks.values()), round_ticks))
            if method == "DECISION":
                want = int(round(rounds * round_s * hz))
                if abs(round_ticks - want) > hz:  # within one second
                    fail("%s bout %d: a DECISION fought %d round ticks, the clock says %d (%d x %.0f s x %d Hz)"
                         % (rid, i, round_ticks, want, rounds, round_s, hz))
            if int(bout.get("submission_finishes", 0)) not in (0, 1):
                fail("%s bout %d: submission_finishes must be 0 or 1" % (rid, i))
            if (method == "SUBMISSION") != (int(bout.get("submission_finishes", 0)) == 1):
                fail("%s bout %d: method %s disagrees with submission_finishes" % (rid, i, method))
            if int(bout.get("ground_spells", 0)) > 0 and ticks["ground"] == 0:
                fail("%s bout %d: ground spells without ground ticks" % (rid, i))
        summary = row.get("methods", {})
        if summary != methods:
            fail("%s: methods summary %s != counted from bouts %s" % (rid, summary, methods))

    witness = data.get("witness", {})
    if str(witness.get("method", "")) != "SUBMISSION":
        fail("witness 93248 (Grappler vs Fish, muay thai, 3 rounds) must end by SUBMISSION - "
             "tests/grapple_adapter_test.gd printed exactly that under C109; got %r" % witness.get("method"))
    if int(witness.get("seed", -1)) != 93248:
        fail("witness seed must be 93248")

    md = MD_PATH.read_text(encoding="utf-8")
    if not md.lstrip().startswith("## DECISIONS"):
        fail("the markdown must open with ## DECISIONS")
    for rid in RULESETS:
        if rid not in md:
            fail("the markdown never names %s" % rid)
    return finish()


def finish():
    print("Q90_check: %d failure(s)" % len(failures))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
