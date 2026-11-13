# TASK BLOCKLOOK3 (Grok Dev) - the block, round 3: the owner's marks on the filmed blocks

Model: Grok Dev. Discipline: boxing (demo). Branch grok/blocklook3, one PR.

BLOCKLOOK2 is on main (c724c01d): the blocker stays in her guard, and BlockCatch brings the glove on the punch's side onto
its line. Claude filmed every blocked punch through the game's own path (tools/fight3d_gallery.gd `only=block`, updated on
main in d4838b13). The owner marked the stills and the reel (review board 2026-11-13_1227, Feedback/2026-11-13-15). His
words, verbatim:
- C347 (reel, the blocks): "why there are no body reactions on the hits from the red fighter ?" The blocker takes a blocked punch with no give at all. A real block absorbs it: the glove is driven back toward her face and her head and shoulders take a small jolt.
- Mark 4, the cross (A_B pro_right_cross): "colission!!". The punching glove sinks into the blocking glove. Your own block_catch row reads `touch=-0.026`: 2.6 cm inside.
- Mark 2, the lead hook seen from behind: "the arm looks shorter ther of the blue fighter". The puncher's arm is folded short because the punch is carried onto the catching glove.
- Mark 3, the rear hook: "90 degrees angle ? wtf is that move ?". The puncher's elbow is bent to about 90 degrees, with the forearm pointing up at the catching glove.
- Mark 1, the lead uppercut: "blue fighter doesnt look like a human". The puncher's torso twists and the shoulder hunches while the arm is carried onto the catch.

## What to change (owned code)
1. ABSORB (C347): on a blocked head punch, from the contact frame:
   - The catching glove is driven back toward the blocker's face by 3-6 cm. It never comes closer than 0.08 m to the face; your to_face reads it.
   - Her head moves back 1-3 cm.
   - Both return to the guard by 0.5 s after contact.
   - Scale it with the punch: cross and rear hook more than jab.
   - On the body hook's elbow brace: the torso gives 1-3 cm.
   - Do it inside BlockCatch, as part of the catch, not as a new clip.
2. NO GLOVE-INTO-GLOVE (mark 4): the punching glove's front stops at the blocking glove's surface. On every blocked row, the gap at contact is at least -0.005 m (at most 0.5 cm in).
3. THE PUNCHER'S ARM STAYS A PUNCH (marks 1-3): the blocked punch's arm must look like the same punch landed, stopped by the glove. At contact, against the SAME clip played as a landed punch (stage.land path) at its own contact frame:
   - Reach: shoulder-to-glove distance at least 90% of the landed punch's.
   - Elbow angle within 15 degrees of the landed punch's.
   - Chest yaw and pitch within 10 degrees of the landed punch's, and the punching shoulder no more than 4 cm lower.

   Where the catching glove is too close for that, the CATCH comes out to meet the punch on its line. The punch is not pulled in to meet the glove.

## Rulers (write them first; each must go red on main for the right reason, paste the red lines)
- tests/block_absorb_test.gd (new): for each head-punch row of block_catch_test (A_B and B_A) and the body hook:
  - `ABSORB <row>: glove_back=<m> head_back=<m> to_face_min=<m> back_in_guard_by=<s>`
  - Bars as in item 1. Red on main: glove_back is about 0.
- tests/block_catch_test.gd (yours): add to each row the landed twin's reach, elbow and chest numbers, and print `MATCH <row> reach=<pct> elbow_diff=<deg> chest_diff=<deg> shoulder_drop=<m>`.
  - Bars as in items 2 and 3.
  - Keep every existing bar. Never loosen one.

## Contract
OWNS: scripts/fight3d/BlockCatch.gd, scripts/fight3d/FightStage.gd (arm_block only), tests/block_catch_test.gd,
  tests/block_absorb_test.gd, docs/BLOCKLOOK3_RESULT.md
RED_TEST: tests/block_absorb_test.gd (no give on main)
REGRESSION: tests/block_set_test.gd, tests/block_meet_test.gd, tests/hit_carry_test.gd, tests/beat_clips_test.gd
VISUAL: Claude films tools/fight3d_gallery.gd only=block on the PC after the PR (you cannot see images)

RESULT lines in the PR body, copied exactly from the final run:
- RESULT: tests/block_absorb_test.gd -> BLOCK_ABSORB failures=0
- RESULT: tests/block_catch_test.gd -> BLOCK_CATCH failures=0   (two runs)
- RESULT: tests/block_set_test.gd -> BLOCK_SET failures=0
- RESULT: tests/block_meet_test.gd -> BLOCK_MEET failures=<n> (all CTRL_LANDED; main has 10)

Files stay under 500 lines; split BlockCatch into a helper you own if it would pass 500, and name the helper in the PR.

## Prior research
- docs/BLOCKLOOK2_RESULT.md
- ops/research/TASK_BLOCKLOOK2_R2.md
- the hit reaction's own give on a landed punch (FightStage.hit, HitSnap): reuse its spring for the absorb rather than a new one.

## What would a human do?
A boxer who catches a cross on the glove gets her own glove knocked back toward her face and rocks back a little, then resets.
The puncher's arm stays a straight cross that was stopped, not an arm folded up to reach the glove.

## Prefab check
None: our own catch and our own hit spring.
