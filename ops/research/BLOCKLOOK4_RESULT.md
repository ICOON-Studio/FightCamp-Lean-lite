# BLOCKLOOK4 result (Grok Dev): move the CATCH, not the punch

## Verdict
MATCH is NOT closed. Placing the catch at 90 % of the landed reach cannot work while the punch is armed as today, and the
one-line hook in FightStage.arm_block that makes it work for the jabs and the B_A rear hook regresses block_meet and block_absorb.
The shipped code is the placement (BlockCatchPoint.gd + BlockCatch), switched on only for a punch armed on the landed path
(PunchReach._thru > 0). Without the hook it is inert, so the branch reads exactly as main.

## Why placement alone cannot (measured)
At the blocked contact the puncher's shoulder is only 0.45-0.62 m from her face (block_catch "meet" lines on main:
A_B jab 0.622, A_B cross 0.571, B_A jab 0.558, B_A cross 0.453), while the landed twin's hand reach is 0.48-0.53 m.
The landed straight gets its long arm from ReachLimit.lean_to: the chest turns back to hold the elbow at its kind's angle.
That runs only on the landed path (_thru > 0). Armed as today (no carry, no lean), 90 % of the landed reach from that shoulder
puts the hand at or behind her face. Run b1 (placement only, before the slide below) put the catching glove 0.04-0.16 m
BEHIND her face point (CATCH fwd -0.164..+0.033): BLOCK_CATCH 22. With the glove slid out along the punch's line into the
catch box (fwd 0.11-0.135, so CATCH and the absorb's 0.08 m to the face hold), the arm folds as on main: BLOCK_CATCH 10.
The brief's 0.20-0.28 m catch distance would also break block_catch's CATCH bar (glove centre 0.06-0.14 m in front of the
face). I did not loosen it.

## The outside hook, proven locally and NOT committed
FightStage.arm_block, line 205:
```
-	pr.arm(clip, hand, cs, get_block_target, float(boxers[who]["front"]))
+	pr.arm(clip, hand, cs, get_block_target, float(boxers[who]["front"]), 0.001)
```
(the landed path: PunchReach's drive and chest lean, a 1 mm carry so the front stays on the glove). With it plus this branch:

| test | main | branch | branch + hook |
|---|---|---|---|
| block_catch | 9, 9 | 9, 9 | 7 |
| block_meet | 10 (all CTRL) | 10 (all CTRL) | 12: + A_B fight pro_left_hook BETWEEN/GY -0.112/TOUCH 0.138, + B_A fight pro_left_jab TOUCH -0.036 |
| block_absorb | 0 | 0 | 4: A_B rhook glove back 0.102, B_A rhook 0.103, B_A cross 0.017, SCALE B_A |
| block_set | 0 | 0 | 0 |

So the hook is not mergeable as it stands. A latched meeting point at contact (tried) went to catch 8, meet 11, absorb 6.

## MATCH (bars: reach >= 90 %, elbow <= 15 deg, chest <= 10 deg, shoulder drop <= 0.04 m)
| row | main (= branch) reach / elbow / chest | branch + hook reach / elbow / chest |
|---|---|---|
| A_B jab | 69.0 % / 69.9 / 26.9 | 97.5 % / 10.2 / 1.5 PASS |
| A_B cross | 57.1 % / 92.2 / 7.5 | 87.3 % / 41.5 / 20.2 |
| A_B lead hook | 78.4 % / 26.0 / 10.2 | 118.2 % / 29.1 / 28.4 (+ MEETS touch 0.199) |
| A_B rear hook | 59.5 % / 45.6 / 8.3 | 115.8 % / 17.7 / 16.0 (+ MEETS touch 0.179) |
| B_A jab | 62.1 % / 63.6 / 34.7 | 96.1 % / 9.5 / 4.4 PASS |
| B_A cross | 38.0 % / 104.2 / 35.4 | 72.4 % / 59.1 / 3.7 |
| B_A lead hook | 74.5 % / 30.2 / 9.3 | 102.5 % / 3.5 / 15.7 |
| B_A rear hook | 65.3 % / 36.4 / 31.0 | 98.9 % / 1.4 / 3.0 PASS |

What is left after the hook, and why:
- Crosses: on the landed path the cross still does not extend at its contact clip time. The drive's CORR_M cap keeps the
  glove within 0.30 m of the clip's own, and the cross clip's arm is not out yet at 0.183 s without the landed hips carry.
  Adding the landed carry (PunchWeight.carry) made it worse (round 1b: 80 % / 55 %).
- A_B hooks: on the landed path they stall 0.24-0.33 m off her face (the CORR_M cap; RangeTable has the hook clip short at
  this stand). That is outside any catch box, so MEETS goes red. Their landed twin does not land either (front 0.40-0.68 m
  off the face), so the MATCH twin is itself short and moves run to run.
- B_A lead hook: chest pitch 15.7.

## Flaky row
MEETS B_A pro_left_hook (to_face 0.050-0.052 on main and this branch, bar 0.08; 0.187 in one earlier main run): this is the
9th BLOCK_CATCH failure besides the 8 MATCH rows. With the hook it passes (0.136).

## VISUAL
As main. Nothing changes on screen without the hook. With the hook, `tools/fight3d_gallery.gd only=block` shows the jab
caught out front on a straight arm, the cross still bent.

## Final runs (branch, exact)
```
RESULT: tests/block_catch_test.gd -> BLOCK_CATCH failures=9
RESULT: tests/block_catch_test.gd -> BLOCK_CATCH failures=9
RESULT: tests/block_absorb_test.gd -> BLOCK_ABSORB failures=0
RESULT: tests/block_set_test.gd -> BLOCK_SET failures=0
RESULT: tests/block_meet_test.gd -> BLOCK_MEET failures=10
RESULT: tests/beat_clips_test.gd -> BEATCLIPS failures=0
RESULT: tests/hit_carry_test.gd -> HIT_CARRY failures=44
RESULT: tests/fight_feel_test.gd -> FIGHT_FEEL failures=0
RESULT: tests/file_limits_test.gd -> FILE_LIMITS failures=0
```
Main: BLOCK_CATCH 9, 9; BLOCK_ABSORB 0; BLOCK_SET 0; BLOCK_MEET 10 (all CTRL_LANDED); BEATCLIPS 0; HIT_CARRY 40; FIGHT_FEEL 0;
FILE_LIMITS 0. Branch BLOCK_MEET's 10 are the same CTRL_LANDED rows. hit_carry_test never makes a BlockCatch (no block in
it), and its count moves run to run on identical code (40/42/44 in this session, 47/49 in BLOCKLOOK3).
