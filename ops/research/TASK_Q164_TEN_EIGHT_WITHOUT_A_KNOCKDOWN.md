# TASK_Q164 - why a boxing decision scores 10-8 rounds with nobody knocked down (Qwen, full branch)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S64, 2026-09-24. Engine lane (operator split 2026-09-24).

## What was seen
S64 walked a real career (`Godot/tools/s64_career_walk.gd`, test `Godot/tests/career_loop_walk_test.gd`):
Nicosia starter gym, NASIR LARKIN (boxing, middleweight, 0-1) vs DARIO STERLING (1-1-1, rating 41) on a
LOCAL SHOW, boxing ruleset, the real-time path (`FightRealtime` via `FightBeatAdapter`). The result:
UD over 8 rounds, all three judges 10-8 in SIX rounds (R1-3, R5, R8; R6 9-10), cards 79-68, and ZERO
knockdowns on the card. In professional boxing a 10-8 round without a knockdown is rare - find the
real rate before you tune anything (ABC 10-point-must guidance; a study with a per-round count).

## Anchors
- `scripts/FightRealtime.gd:1719` `_close_round`: folds the log with `RealtimeRoundStats` (`RoundStats.fold`), then `Judges.score_round`.
- `scripts/RoundScoring.gd:95-125`: points -> 10-9 / 10-8 by `margin_wide` (`DEFAULT_MARGIN_WIDE`), then the ruleset's 10-8 damage gate.
- `scripts/JudgePanel.gd:84` `score_round`. The atomic sim calls the same scorer from `FightSimulation.gd:3191`.
- `tests/fight_scoring_test.gd` is one of the suite's standing reds (since S29) - run it first and say whether its failure is this.

## Part 1 - measure, with a named population
Write `Godot/tools/q164_round_margins.gd`: N=40 boxing bouts on the real-time path, fighters that DIFFER
(style and attributes inside the ruleset - NEVER two identical fighters, and both legal boxers; name each
pair's ids, ratings and styles in the output). Print: share of rounds 10-8, share 10-8 with zero knockdowns,
the distribution of `points_a - points_b` per round, and `margin_wide` as the realtime path sees it. Do the
same 40 on the atomic path (`FightSimulation`) as the control arm - same pairs, same seeds.

## Part 2 - the mechanism, then the fix
Most likely the real-time fold produces points on a different scale from the atomic sim, so the same
`margin_wide` is crossed far more often. Prove or disprove that with the printout. Fix the MECHANISM (the
scale, or a real-time profile value, or the damage gate the ruleset should apply), not the number that
makes the table look right, and re-run both arms. Report before/after 10-8 share beside the real anchor.

## Owned files
`Godot/tools/q164_round_margins.gd` (new), `research/Q164_DIGEST.md` (new), and ONE of
`scripts/RoundScoring.gd` / `scripts/RealtimeRoundStats.gd` / the boxing scoring profile data - whichever the
mechanism lives in. Do NOT edit FightRealtime.gd, JudgePanel.gd or GameState.gd; if the fix needs them,
report the line and Claude integrates.

## Gate (tier: a script edited)
Parse gate on every touched .gd; then `python Godot/tools/run_tests.py --only fight_scoring,judge_panel,round_scoring,fight_realtime,career_loop_walk`.
fight_scoring_test: report its state before and after - green after is the aim, "no worse" is the ceiling.
Branch `qwen/q164-ten-eight`, worktree off `origin/master`; `--headless --import` once in the fresh worktree.
One `python Tools/agent_comms.py send` per part. Do NOT edit HANDOFF.md.
Trap: a scorecard table can look right because both arms share the bug - the atomic arm is a control only
if it does not read the same folded counters. Say which counters each arm reads.
