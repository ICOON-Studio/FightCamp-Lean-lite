# TASK Q92 — QWEN — THE COUNT, MEASURED: HOW OFTEN, HOW LONG, AND HOW OFTEN THE BELL WAITS

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`,
branch `qwen/q92-counts` - already created from `origin/master` for you. Push the BRANCH.
Stage: S4a item (3), THE COUNT - an independent measurement of what Claude just built.

**Test tier: A NEW TOOL ONLY, no script edited.** Parse gate on your tool, run it, then the check. No test, no suite.

## Owned files

- `Godot/tools/measure_knockdown_counts.gd` - NEW, yours (`extends SceneTree`).
- `research/Q92_knockdown_counts.json` - NEW, written by your tool.
- `research/Q92_THE_COUNT_MEASURED.md` - NEW, yours, 30 lines at most.

Read ONLY: `Godot/tools/measure_ground_by_ruleset.gd` (your own Q90 tool - reuse its booking), the block that starts
at `grep -n "THE COUNT (operator ruling COUNT" Godot/scripts/FightRealtime.gd` (about 30 lines), and
`grep -n "func count_length_s\|func _start_count\|func _counting\|func _hold_the_bell\|func _log_new_count" Godot/scripts/FightRealtime.gd`
with 25 lines at each. `FightRealtime.gd` is ~2,700 lines - NEVER open it whole. `FightWorldLiveScreen.gd` - only
`grep -n "static func demo_fighter"` and 25 lines. Nothing else; do not read HANDOFF.md.

## Why this exists

The engine now counts: when a boxer, kickboxer or muay thai fighter is knocked down and gets up, nobody acts for the
referee's count (10-25 s, a model built on J15), the round clock keeps running, and a count still running at the end
of a round holds the bell (K35). Claude's own test checks the mechanism. This measures what it does to whole bouts,
through a second instrument.

## What the tool does

- For each of `["boxing", "kickboxing", "muay_thai"]`: 60 bouts, seeds `996000 + i`, the styled pair
  `style_fighter(ruleset, 0, "a")` vs `style_fighter(ruleset, 1, "b")` from `res://tools/measure_ruleset_sweep.gd`,
  options `{"seed", "rounds": 3, "ruleset": <the ruleset dictionary>}`, run with `FightRealtime.run_to_completion`.
- **The witness**: `FightWorldLiveScreen.demo_fighter("a")` vs `demo_fighter("b")`, boxing, seeds `810000`-`810019`,
  3 rounds, the same way.
- Per bout write: `seed`, `method` (`FightRealtime.result(state)["method"]`), `tick` (`state["tick"]`),
  `held_ticks`, `counts_started`, `count_ticks` (all three read from `state`), `knockdowns` (the two fighters'
  `knockdowns_total` summed), `count_lengths_s` (the `length_s` of every log event whose `type` is `"count"`, in
  order), `bell_held` (true when `held_ticks > 0`), and `counts_paired`: true when, walking the log in order, every
  `"count"` event is followed by a `"count_end"` before the next `"count"`, and no event of type `"action"` falls
  between a `"count"` and its `"count_end"`.
- Per ruleset also `counts_total`, `bouts_with_a_count`, `bouts_with_bell_held`, `count_share_of_round_time`
  (sum of count ticks / sum of `tick - held_ticks` over the ruleset's bouts) and `methods`.
- Top level: `hz`, `population` (each pair's names and reach; the catalogue path if you can read it), `rulesets`,
  `witness` (`{"bouts": [...], "counts_total"}`).

## The markdown

Opens with `## DECISIONS`: one table - ruleset | bouts | knockdowns | counts | bouts with a count | mean count length
(s) | count share of round time | bouts where the bell waited | methods - plus the witness row, and one line comparing
the count share with C107's modelled 1.1% (`research/C107_KNOCKDOWN_CLOCK.md`, first 15 lines only). No
recommendation.

## Gate

1. `python Godot/tools/check_scripts.py Godot/tools/measure_knockdown_counts.gd`
2. `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tools/measure_knockdown_counts.gd --timeout 2400`
3. **`python research/Q92_check.py` must exit 0** - written before you started; it pins your witness to the
   count Claude's test printed and every bout to the clock. Fix the TOOL if it fails; never the JSON or the check.
4. Open the JSON and read one boxing bout that has a count, yourself, before committing.

## Commit

`git status -s` first. Commit ONLY your three files, paths on the commit line; `git show --stat HEAD`;
`git push -u origin qwen/q92-counts`; `python Tools/agent_comms.py send --from qwen --to claude --topic "Q92 ready" --body "<hash>"`.
Do not edit `HANDOFF.md`.

## The trap

A GDScript runtime error HANGS a headless run until its timeout: read the log after the first minute. And never build
fighters by hand - the styled pairs and the demo pair already carry `"stats"`, not `"attributes"`.
