# MOTIONRULERS1 result (S540, 2026-11-23)

Question (TASK_MOTIONRULERS1, S540 first step): which fight player does each red nightly ruler drive?

## Answer: all three drive the OLD player
| Test | What it builds | Old player today | Same test with `-- fightplayer2` | Decision |
|---|---|---|---|---|
| rokoko_clips_test | FightStage + a probe run with `-- rokoko` (opt-in route, off in the game since S432) | RED: strafe_right planted slide over the bar | not valid: v2 never plays the Rokoko route | out of the nightly list |
| human_feet_test | FightStage, calls stage.play / guard / step / circle itself | RED: boxer 1 foot 4.4 cm under the canvas, pro_left_hook_v2 -> guard, 2 frames (bar 3 cm) | not valid: 0.0 cm under, but the 4 "carried in" rows fail at 0.00 m - v2 does not move bodies through the old stage calls | out of the list; its floor bar moved to v2's ruler |
| head_aim_test | FightStage, old aim layer on and off | RED: A_A_lv jab flat_diff 0.235 (bar 0.20) | not valid: aimed and un-aimed read the same number on all 12 rows - the test's switch does nothing on v2 | out of the list; v2's aim is read by player2_test LANDS |

Nothing in the three files changed but a header line saying this; no bar was touched. They still run by hand as the old
player's control arm. No bisect was run: the rule is that a ruler of the old player is retired, not patched, and none of the
three reads v2.

## One thing the brief had wrong
The brief calls v2 "the shipped player". It is not switched on in the game yet: `Player2.on()` is true only with
`-- fightplayer2` (or a test's `Player2.force`). The .exe still plays the old player, so the two defects above (a foot 4.4 cm
under the canvas for 2 frames after a left hook; one jab row's reach) are still in the build he plays until v2 is switched on.
That switch is the FIGHTPLAYER2 gate (scope section 5: v2 must beat the old player on his eye), not this task.

## What watches v2 now
tests/player2_test.gd was in no test list (not the nightly, not CI). It is in the nightly list now. Run today, fixed 60 fps,
36 s: failures=0.
- LANDS: median glove 0.4 cm off its target, 13 of 14 within 12 cm.
- FLOOR (new row, human_feet's 3 cm bar, balls and ankles against their guard height): deepest 2.8 cm, boxer 1 right ankle in
  pro_back_dodge, 0 frames over. Inside the bar by 2 mm: the first place to look if it goes red.
- DEBT rows, unchanged and already known: SLIDE 9.65 m per 2 exchanges (bar 1 m an exchange, guard 6), JUMPS 2 (bar 0, guard 12).
  These are v2's real open foot work (KNEEROOT1 gave a punch its own feet back); they belong to the FIGHTPLAYER2 phases.

## Runs (one at a time through godot_slot, headless, logs in E:/FightCamp/tmp/motionrulers1)
human_feet_test, head_aim_test, rokoko_clips_test as they stand (fixed 30): red as in the nightly.
human_feet_test and head_aim_test with `-- fightplayer2`: the readings in the table.
player2_test before and after the FLOOR row: failures=0 both times.
