# TASK Q183 - QWEN - THE FOOTWORK SWITCH, DECIDED ON EVERY ANCHORED ROW (incl. leg share)
Owner: qwen. Assigned S81, 2026-09-26 (queued: launch after the 04:00 suite). Model: qwen3-coder, medium, `--yolo`.
Branch: `qwen/q183-footwork-full-census`.

## Why (Claude's review of Q182, merged)
Q182 did good work: the census now reports m/min PER FIGHTER, the default is wired per ruleset, and boxing (speed 1.55)
and kickboxing (1.65 + holds 30-55 ticks) now land 32.6 and 37.3 m/min per fighter, inside G100's 32-48. But **the MMA
default flip turned `fight_realtime_test` red: MMA leg-kick share fell from its measured 8% to 4.9%** - away from real
MMA, and no census counted kicks. Claude held the default OFF for every ruleset (`FightRealtime.gd:959-964`, the
`false and` guard; the test now asserts MMA default OFF). The switch is ready to flip once the numbers say so.

## What would a human do?
Before flipping a global default the designer lists EVERY number the existing test suite already gates for that sport,
measures each OFF vs ON over the real matchup spread, and flips only the sports where none of them moves away from its
real anchor. The gates the suite already holds ARE the checklist.

## The work
1. Extend `Godot/tools/q182_footwork_census.gd` (copy to q183_...): add **leg-kick share, body/head/leg target split,
   kicks thrown per round, takedowns attempted/landed (MMA), clinch share**, and every other row the fight tests gate -
   find them: `grep -rn "_check(" Godot/tests/fight_realtime_test.gd Godot/tests/fight_stage*_test.gd Godot/tests/fight_scoring_test.gd`
   and take the rows with a number in them. Each row: OFF, ON, difference with 95% interval, its anchor band, per-what.
2. 3 matchups x 30 seeds per ruleset (your Q181 matchups), current master (Q182 tuning in).
3. Verdict per ruleset: FLIP if no row moves AWAY from its anchor with an interval that excludes zero; otherwise name the
   blocking row. For MMA, say WHY leg share falls when feet move less (fewer range resets? kick range never reached?)
   by counting kick attempts by distance band.
4. If a ruleset passes, flip it in `FightRealtime.gd` (the one guarded line) and update
   `Godot/tests/fight_footwork_economy_test.gd` to match; if none passes, change nothing in scripts.

## Owned files
`Godot/tools/q183_footwork_full_census.gd`, `research/Q183_DIGEST.md`; and ONLY if a ruleset passes: the default
line in `Godot/scripts/FightRealtime.gd` and the default checks in `Godot/tests/fight_footwork_economy_test.gd`.

## Tier
Parse gate on the tool (and the script/test if touched). If you flip anything: `run_tests.py --only fight_footwork`, then
`--only fight_realtime`, `--only fight_stage`, `--only fight_scoring` - one `--only` per invocation, read `total=`.
Not alongside a full suite run: check `tasklist` for a Godot suite (`run_tests.py`) before starting.

## Done
Commit on your branch, push, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q183 --body "<one line per ruleset: FLIP or the blocking row with its interval>"`.
Do not edit HANDOFF.md.

## The trap
Every rate says what it is divided by in its own label (per fighter, per bout, per round, share of strikes) - Q181's sum
printed beside a per-fighter band is the mistake this task exists to not repeat.
