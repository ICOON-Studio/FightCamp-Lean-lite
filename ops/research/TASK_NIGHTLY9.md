# TASK NIGHTLY9 - the three NIGHTLY8 reds that needed a call: the calls are made, build them (S246, Grok Dev)

Seat: Grok Dev (cloud coding seat, Godot 4.7.2). Model: Grok Dev default. Discipline: BOXING (demo).
One branch + PR per test: `grok/nightly9-<test stem>`, PR to master; Claude merges by diff. Thank you for NIGHTLY8 -
#246/#247 collected S244, and your "decision_pacing files are empty" catch was a real defect: fixed on master f3563220
(DecisionPacing.gd + its test restored, `DECISION_PACING failures=0`) - pull first.

## Your RTD question (#247)
Keep `RTD` in `VALID_METHODS`: the game produces it (FightRealtime.gd:3776/:3984) and a corner retirement is a real boxing result.

## 1. `tests/fight_identity_test.gd` - "rivalry heat costs stamina" (decided: the instrument is wrong, not the game)
Fact: heat 100 scales movement AND strike drain by 1.10 (`Rivalries.stamina_scale`, applied FightRealtime.gd ~5235 and ~6510).
End-of-bout stamina hides it: between-round recovery refills the tank and fight length differs (your 544.13 vs 544.43).
Do: replace the end-stamina sum with STAMINA SPENT PER LIVE TICK for side a - in the test, sum every tick-over-tick DROP of
`state.a.stamina` (ignore rises = recovery), divide by side a's live ticks; assert hot > cold. Keep the cold/hot pair and
`recovery_rate` 50 pin as they are. Print both rates. If hot <= cold even then, the game is broken: trace why the scale
does not bite (is `identity_in_fight` true in this bout?) and fix the game, not the test.
Prove the instrument can read worse: a temporary local mutant with `stamina_per_heat` 0.0 must turn the check red (say so in the PR).

## 2. `tests/switch_gate_hands_smooth_in_whole_test.gd` (decided: gate what smoothing owns)
The punching glove inside its contact window is unsmoothed on purpose since S131 (contact must land where the sim says).
Do: the p95 gate reads every hand sample EXCEPT the striking glove during its contact window; print that excluded set's p95
separately as info (ON and OFF). Expect ~0.65 ON < 0.99 OFF. Name the S131 commit in the PR.

## 3. `tests/fight_clip_slice_test.gd` - head-strike beat under 1.2 s (decided: measure what the player sees)
The check reads raw clip length. The game plays clips with a speed-up. Do: the check measures PLAYED length
(clip length / the playback speed the game applies to that beat - trace the exact function the fight uses, name it in the PR).
Caps: straight punches (jab/cross) 1.2 s played; hooks and uppercuts 1.4 s played (they travel a longer arc).
`boxing_rear_hook` at ~1.28 s played then passes; a 1.724 s unscaled hook must still fail (state it in the PR).

## Not yours
`fight_stage_realism_test` (red by design, GATED S4a); `fight_realtime_test` (green alone).

## Green, per PR
Test alone prints its pass line; parse gate `python Godot/tools/check_scripts.py <touched .gd>`;
`python Godot/tools/run_tests.py --only <system substring> --jobs 2` unchanged-or-better vs master.
PR body: `RESULT: tests/<name>.gd -> <exact pass line>`.

## Rules
research/GDSCRIPT_TRAPS.md. FightRealtime.gd / GameState.gd are huge - grep + sed -n windows. Plain --script tests are
the OFF control arm. Never test identical fighters.
THE ONE TRAP: change only the three expectations named above, exactly as written - nothing else in those tests.

## Prior research
TASK_NIGHTLY8.md + your NIGHTLY8 report; roadmap NIGHTLY1 row; S244_DIGEST.md.

## What would a human do?
Fix the measuring stick where it reads the wrong quantity, prove it can still go red, keep the game's design.

## Prefab check
None - our own tests.
