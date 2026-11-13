# BLOCKLOOK5 result (Grok Dev): straights on the landed path, hooks as today, meet and absorb held

## What changed
- `FightStage.arm_block` (one call, 3 lines): a blocked jab or cross is armed on the landed path (`0.001` carry: PunchReach's drive
  and chest lean, stopped on the glove). A hook or uppercut is armed exactly as before:
  `pr.arm(clip, hand, cs, get_block_target, float(boxers[who]["front"]), 0.001 if RangeTable.kind(clip) == "straight" else 0.0)`
- `BlockCatchPoint.gd` (BLOCKLOOK4, kept): the catch for a straight on the punch's line at 90 % of the landed reach, slid out along
  that line into the catch box (0.11-0.135 m in front of her face). It is used only for a punch on the landed path, so only for straights.
- `BlockCatch.gd`, the two straight regressions:
  - **B_A jab TOUCH -0.036 (block_meet), B_A jab GAP.** The glove was still moving out to the meeting point (and following his shoulder)
    after PunchReach latched its aim at contact minus LATCH_S, so it moved into the punch's front. Now the glove reaches the meeting point
    by MET_HOLD_S (0.03 s) before contact and is held there through the absorb. block_meet B_A fight jab touch is -0.017 (main -0.006,
    bar -0.03); block_catch GAP B_A jab is -0.003 at contact (bar -0.005).
  - **B_A cross absorb 0.017 / SCALE B_A (block_absorb).** The meeting point moved forward with his shoulder after contact and ate the
    knock. Held as above, the knock plays from the meeting point. Held, the jab's knock alone read 0.022 and the cross's 0.031, so
    KNOCK_M is now jab 0.036 and cross 0.044. Both straights now read glove_back 0.033 / 0.041 (bar 0.03-0.06), to_face_min >= 0.099,
    back in guard by 0.38 / 0.42 s, SCALE passes both sides.
- `tests/block_catch_test.gd`: MATCH is gated for the 4 straights; the hook rows are printed (`PASS/INFO MATCH ... informational`), not
  gated, because HOOKTAKES1 (the mocap packs, end of November) brings their targets. The crosses are gated at CROSS_GATE (below). Every
  other bar is unchanged.

## The crosses: best honest value, not 90 %
A blocked cross on the landed path, stopped on a glove kept in the catch box, cannot reach 90 % of a landed cross that ends 0.03 m off
her face from this stand:
- The glove must sit >= 0.06 m in front of her face (CATCH), and >= 0.08 m off it after a >= 0.03 m knock (absorb). That puts the
  front ~0.15 m off her face, against the landed front's 0.027-0.028 m.
- The landed cross's elbow (146-160 deg) needs the hand near full reach, so the elbow difference stays at 39-41 deg (A_B) and
  60-61 deg (B_A) even at the best reach.
- Sliding the glove nearer her face to gain reach would break CATCH or absorb, so I did not.

Measured over 5 runs on the landed path: A_B 87.5-88.6 % / elbow 38.8-41.0 / chest 19.7-20.5; B_A 70.7-72.3 % / 58.9-61.5 / 4.0-4.2.
Gate (`CROSS_GATE`, per setup: reach %, elbow deg, chest deg; shoulder bar unchanged 0.04): A_B 86 / 43 / 22, B_A 69 / 63 / 10.
Main reads A_B 57.6 % / 91.3 / 8.2 and B_A 37.9 % / 104.2 / 35.2, so both stay red on main.

## Red on main (the straight rows, this test)
```
FAIL MATCH A_B pro_left_jab: reach 69.4% of landed (bar >= 90%), elbow diff 68.6 deg (bar 15), chest yaw diff 13.0 / pitch diff 27.9 deg (bar 10), shoulder -0.020 m lower (bar 0.04)
FAIL MATCH A_B pro_right_cross: reach 57.6% of landed (bar >= 86%), elbow diff 91.3 deg (bar 43), chest yaw diff 7.5 / pitch diff 8.2 deg (bar 22), shoulder +0.001 m lower (bar 0.04)
FAIL MATCH B_A pro_left_jab: reach 61.9% of landed (bar >= 90%), elbow diff 64.1 deg (bar 15), chest yaw diff 17.8 / pitch diff 34.6 deg (bar 10), shoulder -0.035 m lower (bar 0.04)
FAIL MATCH B_A pro_right_cross: reach 37.9% of landed (bar >= 69%), elbow diff 104.2 deg (bar 63), chest yaw diff 18.1 / pitch diff 35.2 deg (bar 10), shoulder -0.000 m lower (bar 0.04)
FAIL MEETS B_A pro_left_hook: touch +0.009 m (bar <= 0.04, not > 0.03 inside), to_face 0.058 (bar >= 0.08)
BLOCK_CATCH failures=5
```

## RESULT, main vs branch (exact, final runs)
```
main:   RESULT: tests/block_catch_test.gd -> BLOCK_CATCH failures=5
main:   RESULT: tests/block_catch_test.gd -> BLOCK_CATCH failures=5
main:   RESULT: tests/block_meet_test.gd -> BLOCK_MEET failures=10
main:   RESULT: tests/block_absorb_test.gd -> BLOCK_ABSORB failures=0
main:   RESULT: tests/block_set_test.gd -> BLOCK_SET failures=0
main:   RESULT: tests/beat_clips_test.gd -> BEATCLIPS failures=0
main:   RESULT: tests/hit_carry_test.gd -> HIT_CARRY failures=47
main:   RESULT: tests/fight_feel_test.gd -> FIGHT_FEEL failures=0
main:   RESULT: tests/file_limits_test.gd -> FILE_LIMITS failures=0
branch: RESULT: tests/block_catch_test.gd -> BLOCK_CATCH failures=2
branch: RESULT: tests/block_catch_test.gd -> BLOCK_CATCH failures=1
branch: RESULT: tests/block_meet_test.gd -> BLOCK_MEET failures=10
branch: RESULT: tests/block_absorb_test.gd -> BLOCK_ABSORB failures=0
branch: RESULT: tests/block_set_test.gd -> BLOCK_SET failures=0
branch: RESULT: tests/beat_clips_test.gd -> BEATCLIPS failures=0
branch: RESULT: tests/hit_carry_test.gd -> HIT_CARRY failures=48
branch: RESULT: tests/fight_feel_test.gd -> FIGHT_FEEL failures=0
branch: RESULT: tests/file_limits_test.gd -> FILE_LIMITS failures=0
```
Extra runs on the same code: branch block_catch #3 `BLOCK_CATCH failures=0`; hit_carry again: branch `HIT_CARRY failures=40`,
main `HIT_CARRY failures=43`. hit_carry_test makes no block and its count moves run to run on identical code (40-48), so it is noise.
- block_meet: the branch's 10 are all CTRL_LANDED, the same rows as main.
- block_catch's remaining failures are MEETS rows on the hook path, which this task leaves as before:
  - **MEETS B_A pro_left_hook** (to_face 0.050-0.063, bar 0.08) is the known flaky row: red on main in both runs, red in branch runs
    1 and 2, passing in run 3.
  - **MEETS B_A pro_right_hook** (touch 0.065) failed once, in branch run 1. It read contact frame 30 against 31-32 in every other run,
    and passed at touch 0.024 in runs 2 and 3. It is a timing flake: hooks run exactly as on main, and nothing this branch adds runs
    for them.

## MATCH (branch, final runs 1 / 2)
| row | reach | elbow diff | chest diff | shoulder drop | gate | result |
|---|---|---|---|---|---|---|
| A_B jab | 97.4 / 97.4 % | 10.8 / 10.7 | 2.3 / 2.2 | +0.001 / +0.004 | 90 / 15 / 10 | PASS |
| B_A jab | 96.0 / 96.0 % | 9.7 / 9.5 | 4.0 / 4.1 | -0.026 / -0.025 | 90 / 15 / 10 | PASS |
| A_B cross | 88.1 / 88.6 % | 39.9 / 38.8 | 20.1 / 20.3 | +0.026 / +0.024 | 86 / 43 / 22 | PASS (gate) |
| B_A cross | 71.1 / 71.0 % | 60.8 / 60.7 | 4.1 / 4.0 | -0.034 / -0.037 | 69 / 63 / 10 | PASS (gate) |
| A_B lead hook | 75.0 / 73.8 % | 29.7 / 31.0 | 9.5 / 10.2 | -0.053 / -0.049 | info | HOOKTAKES1 |
| A_B rear hook | 61.3 / 68.4 % | 43.7 / 36.6 | 10.3 / 9.0 | +0.021 / +0.016 | info | HOOKTAKES1 |
| B_A lead hook | 73.9 / 71.7 % | 30.7 / 33.0 | 9.5 / 9.8 | +0.034 / +0.036 | info | HOOKTAKES1 |
| B_A rear hook | 55.4 / 64.8 % | 45.8 / 36.7 | 32.6 / 31.2 | +0.022 / +0.027 | info | HOOKTAKES1 |

Files: BlockCatch.gd 343, BlockCatchPoint.gd 53, FightStage.gd 478, block_catch_test.gd 392 lines.

## VISUAL
Claude renders the block reel (`tools/fight3d_gallery.gd only=block`):
- The jab and the cross are thrown long, chest turned as when they land, and stopped on her glove out in front (glove 0.11-0.135 m in
  front of her face). The glove snaps back 3-4 cm and returns by 0.42 s.
- The cross is visibly longer than on main (A_B 58 -> 88 % of landed) but still bent at the elbow (~120 deg).
- Hooks look as on main.

## BLOCKLOOK5B: A_B preview jab caught by the rear glove
Cause: the blocked straight's stop point was `block_pos + (puncher_glove - block_pos).normalized() * 0.045`, aimed at the
puncher's glove, which sits lower than her guard. On the preview jab the punch front came in about 5 cm under the rear glove
(front y -0.10..-0.12, rear glove -0.05, lead glove -0.10), so the lead glove was only about 2 cm farther away. On Claude's PC
that flipped the nearest glove to l (gy -0.094, GY_FAIL).
Fix (FightStage.arm_block only): a jab's stop point is level (`to_p.y = 0`), so the jab stops on the rear glove's face. Now the
lead glove is at least 3.5 cm farther than the rear glove at every preview frame. The cross keeps the old stop point because a
level stop dropped B_A cross MATCH reach to 68.6 % (bar 69). Nothing in BlockCatch.gd, BlockCatchPoint.gd or the tests changed.

block_meet, main 7628269d vs branch, same session:
- main:   `ROW A_B preview pro_left_jab touch=-0.000 between=yes to_face=0.151 gy=-0.048 wrist=0.000 gap=0.884 (glove r, frame 9, catch weight 1.00)`
- branch: `ROW A_B preview pro_left_jab touch=0.003 between=yes to_face=0.129 gy=-0.060 wrist=0.000 gap=0.884 (glove r, frame 8, catch weight 1.00)`
- Gloves: every ROW catches with the same glove as on main.
- gy: only two ROWs changed gy. A_B preview jab went -0.048 -> -0.060 and B_A fight lead hook went -0.051 -> -0.048; both are inside [-0.08, 0.06].
- Every block ROW passes. The only failures are CTRL_LANDED rulers (main 9, branch 8).

RESULT (main 7628269d with the branch's block_catch_test / branch):
- BLOCK_MEET failures=9 / BLOCK_MEET failures=8 (CTRL_LANDED only)
- BLOCK_CATCH failures=5 / BLOCK_CATCH failures=1, run 2: 5 / 1. The only red is MEETS B_A pro_left_hook; hook MATCH is info.
- BLOCK_ABSORB failures=0 / 0, BLOCK_SET failures=0 / 0, BEATCLIPS failures=0 / 0, FIGHT_FEEL failures=0 / 0, FILE_LIMITS failures=0 / 0
