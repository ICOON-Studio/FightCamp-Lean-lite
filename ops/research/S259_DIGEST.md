# S259 DIGEST (2026-10-19) - the jab no longer fires like a bullet; every seat reviewed the fight clip

Operator S258: "the jab fires like bullet why is it so fast" and "next session have everyone (ziva etc) review the clip".
Operator S259 (chat): "why you do not upload the video file oon grok ?"; "do we have all 16 stats ludo proposed in the game like
punch speed ?" -> "ask again what attributes we need and trained to make the fight as much human-like as possible"; GitHub: "should
i upgrade github to 20$ a month" -> "i made iccon enterprise" -> "can you do htat forme ?".

## What now works - PUNCHRETIME1 (switch `punch_retime`, GAME_ON)
- Measured first (`tools/jab_speed_probe.gd`, new; seed 95501, as_game, 60 Hz, glove reach from the chest per take):
  boxing_jab glove guard -> full reach in 0.07 s, back in 0.05 s, peak 8.3 m/s (max 11). Solver on/off made no difference.
  WRITERS: (1) the certified clip itself extends in 0.10 s / retracts in 0.08 s; (2) the S-curve (`anim_scurve`, ON) sets the
  contact tangent to 1.5x -> 0.07 / 0.05 s. boxing_jab / boxing_cross had no human_speed_tempo anchor (peak speed only was
  checked, never stroke time).
- `scripts/animation/PunchRetime.gd` (new, pure): per boxing hand strike, extension (10% launch -> contact) >= the G75 floors already
  in strike_speed_anchors.json (jab 0.200, cross 0.233, hook/uppercut 0.333, overhand 0.300 s); retraction (contact -> 75% back)
  >= Ludo S259 (jab 0.18, cross 0.22, hook 0.24, uppercut 0.26, overhand 0.32 s); wind-up at 1x; a slower clip is never sped up.
- `FightStagePlayer`: `_measure_retime_marks` (position-based launch/back; the U165 velocity onset fires on the jab's cock),
  `_begin_retime` / `_retime_advance` own the take (S-curve and U165 stand down), `whole_phases` reports the RETIMED contact so the
  room schedules the hit on it (contact moves ~0.09 s later), `_whole_hold_s` returns wall time (control = retimed contact +
  PunchTiming offset). Room forwards option `punch_retime`.
- Result on the live fight (as_game): jab extension 0.22 s, retraction 0.20 s, peak 5.3 m/s (Stanley 2018 amateur jab 5.85).
- `tests/punch_retime_test.gd` (new): pure plan contract + two live arms on the GAME's path (GAME_ON via GameState.career - a plain
  --script run plays a different rig); OFF 0.117 / 0.100 s breaks the bounds, ON 0.183 / 0.225 s, 5.29 m/s holds.
  PUNCH_RETIME failures=0.
- Defect fixed in passing: `fight_stage_scurve_switch_test` red since S255 (PunchTiming preload sat inside the ANIMSCURVE1 block the
  test strips) - preload moved out.

## CLIPREVIEW1 (research/CLIPREVIEW1_FEEDBACK.md)
Ludo, Grok (frames + the mp4), Dola, John, Kalli answered; Maria pending; Ziva could not load the fight room (run_scene timed out
twice, S250 limit) and has no verbal channel. Verdict: 1 SPACING first (all five: 0.557 m = clinch range; jab range ~1.2 m),
2 jab timing (done), 3 feet planted in punches, 4 twist from the hips, 5 red's crouch.

## Attributes (research/ATTRIBUTES_S259_VERDICT.md, Ludo 19,907 chars)
Ludo r114 proposed 12, not 16. Today: 9 stored stats (speed covers hands AND feet), accuracy/evasion derived, composure only an
in-fight state, no stat changes the watched animation. Ludo S259: 11 trained attributes (hand_speed + footwork from speed, guard +
head_movement from defense, composure + recovery trained, chin innate) with migration; top 4 for a human-looking fight: footwork,
guard, composure, hand_speed. On the board for approval: Q-S256-1.

## GitHub
ICOON-Studio is on an Enterprise TRIAL (operator made it S259). October before it: 10,624 Actions min, $43.05 of the $50 hard cap.
Trial = 3,000 min total, 30 days; LFS listed unavailable in trial (download checked OK S259). Paid activation page reached
(shipping saved = billing, operator OK); NO card on file - the operator adds the card, then activates (or says "yes, activate").

## Not done / next
- Regression set (14 tests) interrupted by heat (nightly 05:00 running); rerun when GREEN/AMBER.
- Jab before/after video (visual gate) not recorded yet - windowed run on the hidden desktop.
- FIGHTGAP1 (spacing) now goes BEFORE FIGHTMOTION1 step 2 (CLIPREVIEW1 verdict).

## Later in S259
- GitHub Enterprise PAID: operator added his card, said "yes activate"; Claude clicked "Activate paid GitHub Enterprise". Billing
  now reads "N min used / 50,000 min included" (Actions), 250 GB LFS bandwidth + 250 GB LFS storage.
- CLOUD TESTS 77da2548: .github/workflows/cloud-tests.yml (workflow_dispatch only/ref/tag/as_game; LFS pulled + cached, Godot import
  cache) + Tools/cloud_test.py (dispatch, --shards N parallel runners, wait, SUITE lines) + run_tests.py --as-game. First run
  2026-10-19 (runs 39189805806 / 39189808395): LFS pull OK on the runner, cold import in progress at handover - read the SUITE lines
  next session; then LFS on in ci.yml and drop the "no LFS-loading tests" rule.
- Board Q-S256-1 answered: "add them all , wire them properly to training and fight" -> TASK_ATTRIB1 (e330e8b8) to Arena (pure
  rules/Attributes.gd + test; chat 01a15201..., branch arena/a6926d62-fightcamp). Part B (wiring) next session. Decision: the new
  attributes feed FightLink's existing levers (an all-50 fighter plays exactly as today) - Ludo's section-4 hit model is NOT swapped
  in one go.
- Handover at ~505k context (rule: 330k).
- CLOUD TESTS PROVEN (after ship): runs 39189805806 / 39189808395 - LFS 268 of 268 files on the runner, cold import 530 s errors=0,
  punch_retime_test + boxing_output_test PASS (SUITE total=2 fails=0), fight_stage_scurve_switch_test PASS (total=1 fails=0);
  19 min wall cold. CLOUD_TEST_SUMMARY total=3 fails=0. Next: LFS on in ci.yml, nightly to the cloud (proposal card task_8f6d0d83).
