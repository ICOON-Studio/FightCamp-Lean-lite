# BLOCKLOOK2 - a block is a guard that catches the punch

## Round 2 (Claude S448 review) - RESULT
```
RESULT: tests/block_catch_test.gd -> BLOCK_CATCH failures=0   (two runs)
RESULT: tests/block_set_test.gd -> BLOCK_SET failures=0
RESULT: tests/block_meet_test.gd -> BLOCK_MEET failures=10 (all CTRL_LANDED, main has 12)
```
block_set_test red on main (no BlockCatch there; every row reads "catch weight -1.000 ... (no BlockCatch)"): `BLOCK_SET failures=11`.

Round 2 changes:
- `FightStage.arm_block` (the accepted fix): while the blocker's BlockCatch has weight, the punch is carried onto the CATCHING
  glove (`BlockCatch.catch_hand()`), not the nearer one. 496 lines.
- `BlockCatch`:
  - The glove is set (weight full) 0.06 s before contact, after a rise starting 0.25 s before it.
  - The OTHER glove is held where it sat in her chest's frame when the catch began. Her guard's own drift moved it 5-6 cm
    during a block; that drift is what failed the 0.05 bar in round 1.
  - A hook is met lower, down to 0.06 m under the face point.
  - The hold after contact also runs on the punch clip's clock (block_meet steps the clip at half speed; on real time
    alone the catch had already eased to 0.53 when its best frame was read - that was the A_B rear hook GY row).
- `block_set_test`: SET now reads the catch. The blocker's BlockCatch weight must be full (>= 0.9999) on the frame BEFORE
  the frame the punch's clip reaches its contact. It keeps the same rows and the same path through BeatFire.fire.
  pro_left_jab_hard is SKIPPED on main and on the branch alike: no lone-punch roll picks it.
- `block_meet_test`: each ROW now also prints which glove it read, the frame and the catch weight. Every bar and the scan
  are unchanged.

block_meet: all 15 block rows pass, including the 4 former GY rows:
- A_B jab fight gy -0.048
- A_B jab preview gy -0.048
- A_B rear hook gy -0.060
- A_A cross gy -0.048

The 10 failures left are CTRL_LANDED RULER_FAIL (punches that land; no block involved). Main fails all 12 CTRL_LANDED rows.
Here B_A jab and A_A jab pass by small margins (0.046 / 0.048 against a 0.05 bar).

Jab row: no longer bimodal. A_B jab touch is +0.005 and +0.000 in the two final runs; round 2's earlier runs read
+0.001 to +0.006. In round 1 it read either +0.004 or ~+0.08: the punch landed on the lead glove.

Margins to watch: B_A lead hook touch +0.034/+0.037 (bar 0.04). A_B jab other glove is now 0.005 m.

hit_carry_test (regression): main `HIT_CARRY failures=48`; branch 37 and 41 over two runs. That is fewer failures, and the
count is noisy on this box; no block code runs in it.

Final block_catch rows (run 2):
```
ROW A_B pro_left_jab: hips_moved=0.033 lean=-1.1 deg head_drop=-0.012 catch=RightHand fwd=0.110 gy=-0.048 between=yes other=0.005 (world 0.028) side=-0.050 touch=+0.000 to_face=0.152 over_head=+0.022 wrist=0.0000 (block frames 1..33, contact 15)
ROW A_B pro_right_cross: hips_moved=0.011 lean=-0.1 deg head_drop=0.032 catch=LeftHand fwd=0.110 gy=-0.048 between=yes other=0.001 (world 0.032) side=+0.050 touch=-0.026 to_face=0.130 over_head=+0.022 wrist=0.0000 (block frames 1..32, contact 11)
ROW A_B pro_left_hook: hips_moved=0.008 lean=+0.7 deg head_drop=0.015 catch=RightHand fwd=0.080 gy=-0.060 between=yes other=0.002 (world 0.017) side=-0.083 touch=+0.013 to_face=0.178 over_head=+0.022 wrist=0.0000 (block frames 16..51, contact 30)
ROW A_B pro_right_hook: hips_moved=0.028 lean=+1.5 deg head_drop=-0.023 catch=LeftHand fwd=0.080 gy=-0.049 between=yes other=0.002 (world 0.034) side=+0.045 touch=+0.011 to_face=0.162 over_head=+0.022 wrist=0.0000 (block frames 18..53, contact 32)
ROW B_A pro_left_jab: hips_moved=0.035 lean=-2.5 deg head_drop=-0.022 catch=RightHand fwd=0.110 gy=-0.048 between=yes other=0.003 (world 0.057) side=-0.050 touch=-0.016 to_face=0.123 over_head=+0.022 wrist=0.0000 (block frames 1..33, contact 15)
ROW B_A pro_right_cross: hips_moved=0.004 lean=+0.4 deg head_drop=0.040 catch=LeftHand fwd=0.110 gy=-0.048 between=yes other=0.003 (world 0.042) side=+0.050 touch=-0.024 to_face=0.127 over_head=+0.022 wrist=0.0000 (block frames 1..32, contact 11)
ROW B_A pro_left_hook: hips_moved=0.004 lean=+0.9 deg head_drop=0.011 catch=RightHand fwd=0.080 gy=-0.060 between=yes other=0.004 (world 0.020) side=-0.082 touch=+0.034 to_face=0.104 over_head=+0.022 wrist=0.0000 (block frames 16..51, contact 30)
ROW B_A pro_right_hook: hips_moved=0.028 lean=+0.5 deg head_drop=-0.015 catch=LeftHand fwd=0.080 gy=-0.055 between=yes other=0.003 (world 0.082) side=+0.039 touch=+0.019 to_face=0.134 over_head=+0.022 wrist=0.0000 (block frames 18..53, contact 32)
BLOCK_CATCH failures=0
```

# Round 1

Brief: ops/research/TASK_BLOCKLOOK2.md. Branch `grok/blocklook2` from main f0ea70e4. Godot 4.7.2 headless, Linux box.

## What changed
- `scripts/fight3d/BlockCatch.gd` (new, replaces BlockGloveLift.gd, which is deleted): a SkeletonModifier3D, made once per
  blocker and added last on her modifier stack. No clip change: she stays in her guard. The catching arm is turned
  UpperArm, then LowerArm (two-bone reach, bone lengths kept, the hand never moved alone). The REAR glove catches the jab
  and the lead hook, and the LEAD glove catches the cross and the rear hook. The glove rises over 0.22 s (BLOCK_SET_S at
  the block rate) and is set 0.03 s before contact. It holds for 0.08 s, then eases out over 0.25 s. The timing follows
  the punch's own clip while it plays; before that it counts down the real seconds to contact. A refused or cut-off
  punch, a counter punch or a hit lets the glove go.
  - Catch point: in front of the face point (straights 0.11 m forward and 0.05 m out to the catching side; hooks 0.08 m
    and 0.09 m), at cheek height, never more than 0.022 m above the Head bone.
  - On a hook, the glove slides up/down and sideways to meet the incoming glove, staying inside the bar box.
- `BeatFire.gd`, block branch: arms BlockCatch (`BlockCatch.block(...)`) instead of `stage.play(other, bclip, ...)`.
  The refused / cut-off rule is kept. The body_hook branch (HitSnap.brace) is unchanged.
- `BeatClips.DEFENCE["block"]` is now `[]`, so `defence("block")` returns "". The other callers ask only for
  slip/weave/pull.
- `FightStage.gd`: only the BlockGloveLift const and set-up lines changed; they now call `BlockCatch.on(self, blocker)`.
  The file has 491 lines.
- `MoveStudio.defend`: the even-jab preview arms the same catch, with `arm_block` plus `BlockCatch.block`.
- `tests/block_catch_test.gd` (new) and `tests/block_meet_test.gd`: block_meet now arms BlockCatch where it used to play
  `mc_to_block`. Every bar keeps its number.

## RED on main (block_catch_test, same test file)
On main, every row fails NO GLOVE ABOVE THE HEAD (+0.053..+0.061 m) and CATCH (the other glove moves 0.079-0.169 m in her
guard). Three rows also fail MEETS. `BLOCK_CATCH failures=19`.

UPRIGHT does **not** fail on main. Read on the drawn skeleton (Chest->Neck, after every modifier), the cover-up as the
stage draws it leans at most 4 degrees more than the guard, and the head drops at most 0.054 m. A separate probe that
played mc_to_block at 1.1x on the stage found the same: trunk 13.0 -> 14.5 degrees and the head down ~0.047 m. The test
was not bent to make main fail UPRIGHT.

## Before / after per row (main -> branch, final runs)
| row | lean deg | head drop m | catch glove fwd m (gy) | touch m | glove over head m |
|---|---|---|---|---|---|
| A_B jab   | +0.4 -> -1.1 | 0.025 -> -0.006 | 0.108 (-0.020) -> 0.110 (-0.048) | +0.047 -> +0.004 | +0.054 -> +0.022 |
| A_B cross | -0.6 -> -0.1 | 0.020 -> 0.039 | 0.104 (-0.024) -> 0.110 (-0.048) | +0.009 -> -0.013 | +0.053 -> +0.022 |
| A_B lead hook | -2.9 -> +0.6 | 0.001 -> 0.015 | 0.101 (-0.023) -> 0.080 (-0.063) | +0.019 -> +0.013 | +0.057 -> +0.022 |
| A_B rear hook | +0.3 -> +1.2 | -0.016 -> -0.025 | 0.105 (-0.024) -> 0.080 (-0.064) | +0.007 -> **+0.046** | +0.054 -> +0.022 |
| B_A jab   | -0.3 -> -2.2 | 0.006 -> -0.024 | 0.090 (-0.020) -> 0.110 (-0.048) | +0.070 -> -0.013 | +0.057 -> +0.022 |
| B_A cross | -0.8 -> +0.8 | 0.022 -> 0.043 | 0.107 (-0.023) -> 0.110 (-0.048) | -0.000 -> -0.027 | +0.057 -> +0.022 |
| B_A lead hook | -4.1 -> +0.6 | -0.007 -> 0.010 | 0.090 (-0.022) -> 0.080 (-0.065) | +0.072 -> +0.038 | +0.061 -> +0.022 |
| B_A rear hook | -1.3 -> +0.0 | -0.017 -> -0.001 | 0.095 (-0.023) -> 0.080 (-0.057) | +0.011 -> +0.020 | +0.055 -> +0.022 |

Other glove (in her guard): main 0.079-0.169 m, branch 0.007-0.053 m. Wrist change is 0.0000 m everywhere.

## Final result lines (branch)
- `BLOCK_CATCH failures=2`:
  - A_B rear hook MEETS touch +0.046.
  - A_B lead hook CATCH: the other glove moved 0.053 m in her guard.
- `BLOCK_MEET failures=14` (main: 12):
  - 10 are CTRL_LANDED RULER_FAIL, which are already failing on main (12 there).
  - 4 are GY_FAIL rows (A_B jab fight/preview -0.110, A_B rear hook -0.086, A_A cross -0.100). In those rows the punch
    is carried onto the guard's LEAD glove; see the bug below.
- `BLOCK_SET failures=11` (main: 0): structural. block_set_test (not owned) requires the blocker to play a clip whose name
  contains "block" at contact, and the brief removes every block clip. It is left red and was not edited.

## Remaining failures: cause (non-owned code)
`FightStage.arm_block` (lines ~196-212, outside the owned lines) carries the punch onto whichever blocker glove is
NEARER the punching glove. In the guard, the lead glove sits about 0.17 m forward, so for the short boxer's jab and
rear hook it wins over the catching glove. The trace shows the jab front 0.045 m from the lead glove and 0.141 m from
the catching glove. This also makes A_B jab bimodal between runs (touch +0.004 / +0.08).

Proposed 3-line fix (not committed: outside the OWNS list). After `var block_pos ... = gl_l_pos if dl <= dr else gl_r_pos`:
```
		var bc: Node = boxers[blocker].get("block_catch")
		if bc != null and float(bc.get("w")) > 0.0:
			block_pos = gl_l_pos if str(bc.get("_arm")[2]).begins_with("Left") else gl_r_pos
```
With it applied locally: BLOCK_CATCH failures=0 and 1 over two runs (the 1 was the other-glove 0.055 row), and all
block_meet block rows pass except A_B rear hook GY -0.091. LOW_M was then lowered to 0.065 so the glove does not
follow a hook that low.

The other glove: a control run with the catch's arm weight forced to 0 moved the other glove 0.049 m in her guard on
the same row. That movement is the guard's own (GuardWeave/GuardTuck), not BlockCatch.

## Regressions (main baseline -> branch)
| test | main | branch |
|---|---|---|
| block_meet_test | 12 (all CTRL_LANDED) | 14 (10 CTRL_LANDED + 4 GY, see above) |
| block_set_test | 0 | 11 (structural, see above) |
| beat_clips_test | 0 | 0 |
| fight_feel_test | 0 | 0 |
| punch_speed_test | 42 / 40 / 39 | 40 / 45 / 43 (box noise) |
| head_aim_test | 0 | 0 |
| hit_snap_gain_test | 0 | 0 |
| guard_weave_test | PASS | PASS |
| file_limits_test | 0 | 0 |

## Notes
- The test reads the other glove in her chest's frame, with the world move printed beside it. GuardWeave wanders her
  trunk 2-4 cm between punches, and that is her guard, not the glove leaving it.
- The test stands the pair at 30 Hz (ruler_stand's settle counts are 30 Hz frames; at 60 Hz the two opening stands
  disagreed) and reads the rows at 60 Hz.
- tools/block_meet_probe.gd and tests/human_feet_test.gd still play `mc_to_block` directly. The clip stays in the
  library, so they still run, but the probe no longer matches the game.
- Claude's filmed visual check is still needed.
