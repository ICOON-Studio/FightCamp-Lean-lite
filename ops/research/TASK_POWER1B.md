# TASK POWER1B - GOOSE - punch power steps 5-6: no one-frame jump before contact, a follow-through after the freeze

Model: Goose (cloud). Discipline: boxing (demo).

## Contract
OWNS: scripts/fight3d/HitImpact.gd (156 lines), scripts/fight3d/PunchReach.gd (499 lines - any line you add must be paid for by moving a block into a NEW file scripts/fight3d/PunchReachFollow.gd, which you also own), tests/punch_follow_test.gd (new), docs/POWER1B_RESULT.md
RED_TEST: tests/punch_follow_test.gd -> PUNCH_FOLLOW failures=0
REGRESSION: punch_speed_test, punch_weight_test, fight_feel_test, hit_snap_gain_test, head_aim_test, beat_clips_test, file_limits_test
VISUAL: no (Claude films it on the PC with tools/hit_frame_film.gd after the merge)
NOT YOURS: every other file (JoinSmoother.gd, BeatFire.gd, FightStage.gd, BeatClips.gd and MoveStudio.gd are other seats' work right now). Never edit scripts/rules or scripts/state (the 3D fight never decides anything).

## The defects (measured on main after the POWER1 merge 74a910de; ops/research/POWER1_AUDIT_S446.md)
1. ONE-FRAME JUMP: a landed cross reaches the face one frame early at 13-15 m/s (f18 15.0 m/s, f19 1.2 m/s), the jab the
   same at ~13 m/s. The band is jab 6-8, cross 7-9 m/s (tests/punch_speed_test.gd SPEED_BAND). The last solve frame of
   PunchReach catches the glove up to the target in one step.
2. NO FOLLOW-THROUGH: after the hit-stop (HitImpact.HOLD_S jab 0.03 / power 0.05 / big 0.06 s - the industry's size, keep
   it) HitImpact.recover ramps the clip to its fast recovery at once, so the glove leaves the target the moment the freeze
   ends. Checked against the shipped games (our own REA notes, POWER1_AUDIT_S446.md): Undisputed's punch plays on through
   contact for 0.08-0.09 s (jab, cross), 0.15-0.31 s (hooks), 0.18-0.28 s (uppercuts) before it comes back.

## The job
1. RED first: tests/punch_follow_test.gd stands the game's FightStage pair at the fight's gap (copy the staging of
   tests/punch_speed_test.gd: two DIFFERENT bodies, mh_boxer_02 against mh_boxer_03), lands pro_left_jab, pro_right_cross,
   pro_left_hook, pro_right_hook, pro_left_uppercut through the game's land path (FightStage.land / HitImpact.hit as
   punch_speed_test does), and reads the glove front of the DRAWN skeleton (Skeleton3D.skeleton_updated) at 60 frames a
   second from 0.20 s before contact to 0.45 s after. Bars per punch:
   - NO JUMP: no single frame's glove speed in the 0.10 s before contact is above the band top + 20 % (jab 9.6, cross and
     hooks 10.8 m/s; uppercuts: 10.8). Print every frame's speed.
   - FOLLOW: after the freeze ends, the glove keeps going for FOLLOW_S (jab and cross 0.08, hooks 0.15, uppercuts 0.18 s):
     over that window its distance to the target point never grows by more than 0.02 m, and it moves at least 0.03 m in
     total (it carries on, it does not stand still).
   - BACK: the glove is back within 0.05 m of its guard place by 0.45 s after contact (no slow drift home).
   Show it RED on main and paste those lines in the result.
2. Fix 1 in PunchReach (or the new PunchReachFollow.gd): spread the last catch-up over the frames before contact (ease it
   in) so no frame is above the bar; the contact frame stays the same (punch_speed_test SYNC keeps holding).
3. Fix 2 in HitImpact: a FOLLOW_S table by punch kind (named constants beside HOLD_S); after the hold, the punch clip
   plays on at its own pace for FOLLOW_S (the glove carried on through the target by the same reach the solve already
   applies), THEN the fast recovery ramps in as today. The receiver's reaction timing is NOT changed.
4. docs/POWER1B_RESULT.md: before/after table per punch (top frame speed before contact, follow distance, back time) and
   the pass lines. punch_speed_test's failures= count must not rise above its value on main (39 at S446): paste both.

## Prior research
ops/research/POWER1_AUDIT_S446.md (the audit, the B&C / Undisputed numbers); docs/POWER1_STEP2_RESULT.md and
docs/POWER1_STEP4_RESULT.md (how the reach and the hit frame work); ops/research/CROSS_POWER_S439.md (real crosses 6-11.5 m/s);
ops/research/GDSCRIPT_TRAPS.md.
## What would a human do?
A punch is thrown through the target, not at it: the fist carries a few centimetres on after it lands, then snaps home.
It never teleports the last stretch.
## Prefab check
None: our own punch solve and hit-stop; the numbers come from two shipped boxing games' files.

## Rules
Repo ICOON-Studio/FightCamp-Lean, from main; branch goose/issue-<n>; ONE PR to main. Godot 4.7.2:
`godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`. No file over 500 lines. Never delete or
weaken a test. Never "he" or "she" in game text.
RESULT lines for the PR body, copied from your final run:
RESULT: tests/punch_follow_test.gd -> PUNCH_FOLLOW failures=0
RESULT: tests/punch_speed_test.gd -> its own failures= line (not above main's)
