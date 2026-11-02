# TASK Q182 - QWEN - FOOTWORK ECONOMY: ON FOR MMA, TUNE BOXING/KICKBOXING INTO THE BAND
Owner: qwen. Assigned S81, 2026-09-26. Model: qwen3-coder, medium, `--yolo`. Branch: `qwen/q182-footwork-per-ruleset`.

## Claude's review of Q181 (merged) - the verdict changes
Your Q181 is the right shape (3 matchups, 95% intervals, anchors beside the rows). Two findings from the review:
1. **The m/min row is the SUM of both fighters.** `q181_footwork_powered_census.gd:197`:
   `mpm_avg = (travel_a + travel_b) / mins` - named "avg", printed beside G100's PER-FIGHTER band. Halved, per fighter:
   | Ruleset | OFF | ON | G100 band |
   |---|---|---|---|
   | Boxing | 46.5 | 27.3 | 32-48 |
   | Kickboxing | 44.4 | 26.9 | 32-48 |
   | MMA | 34.2 | 13.4 | 12-33 |
   So for boxing and kickboxing the economy moves a fighter from INSIDE the band to BELOW it. For MMA it moves him inside.
2. **The verdict rule was read the wrong way round.** "Blocked if it moved away by more than its interval" was meant as
   "blocked if the move AWAY is real" (its 95% interval excludes zero). Boxing landed/min +0.52 [0.39, 0.64] and kickboxing
   +0.20 [0.06, 0.36] move away from J20 and are real. They are small; they are named, not ignored.
**Decision (Claude, lead):** footwork economy ON for MMA; OFF for boxing and kickboxing until they land in 32-48 per fighter.

## What would a human do?
A sim designer who finds a movement model undershooting in one sport tunes that sport's parameters against the same
footage-derived band, keeps the others untouched, and ships the per-sport default only when each sport's own gate passes.

## The work
1. **Fix the instrument** (copy to `Godot/tools/q182_footwork_census.gd`): print m/min PER FIGHTER (mean of A and B, and
   each side), label it so; keep everything else from Q181. Re-run MMA OFF/ON to confirm 34 -> 13 per fighter.
2. **Per-ruleset default** in `FightRealtime.gd` (`:957`, `options.get("footwork_economy", false)`): the default becomes
   `true` when the bout's ruleset is MMA, `false` otherwise; an explicit option still wins. Name the ruleset check the way
   `begin()` already names `is_mma` (`:1246-1276`).
3. **Tune boxing and kickboxing** (still OFF by default): adjust the burst speed or burst/hold draw for those rulesets
   (`:1261-1274`, your Q178 constants) until per-fighter m/min lands inside 32-48 with burst p50 1.5-3 s and hold p50
   2-8 s still met, over your 3 matchups x 30 seeds. Report OFF, ON-before-tuning, ON-after-tuning with intervals. If you
   get them in band, say so and recommend flipping them - do NOT flip them in this task.

## Owned files
`Godot/scripts/FightRealtime.gd` (the default line and the boxing/KB footwork constants only),
`Godot/tools/q182_footwork_census.gd`, `Godot/tests/fight_footwork_economy_test.gd` (add: MMA default ON, boxing/KB
default OFF, explicit option overrides), `research/Q182_DIGEST.md`.

## Tier (a script IS edited)
Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/FightRealtime.gd Godot/tests/fight_footwork_economy_test.gd`.
Then, ONE `--only` per invocation (they do not stack): `python Godot/tools/run_tests.py --only fight_footwork`,
`--only fight_realtime`, `--only fight_mma`, `--only fight_stage`, `--only fight_metres` (slow: ~9 min alone, not hung).
Name any red and whether it was red before your change (revert your one file in YOUR worktree to check, restore after).
**Start no Godot process after 03:40 local time - the full suite runs at 04:00 in the main checkout.** If not finished,
commit what you have on your branch with a note, push, stop.

## Done
Commit on `qwen/q182-footwork-per-ruleset`, push, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q182 --body "<one line: MMA default ON + tests, boxing/KB per-fighter m/min after tuning>"`.
Do not edit HANDOFF.md.

## The trap
The label trap you just hit: every rate printed must say what it is divided by (per fighter or per bout) in its own label.
