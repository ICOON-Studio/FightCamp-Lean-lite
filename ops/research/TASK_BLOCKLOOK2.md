# TASK BLOCKLOOK2 - GROK DEV - a block is a guard that catches the punch, not a hunched cover-up

Model: Grok Dev (Cursor replaced, operator S446). Discipline: boxing (demo). START AFTER JOINFIX1's PR IS OPEN.

## Contract
OWNS: scripts/fight3d/BlockCatch.gd (new, replaces BlockGloveLift.gd: delete that file and its .uid), scripts/fight3d/BeatFire.gd (273 lines; the block branch, lines ~182-200), scripts/fight3d/BeatClips.gd (319 lines; DEFENCE["block"] only), scripts/fight3d/FightStage.gd (497 lines; ONLY the BlockGloveLift lines 173-195 swapped for BlockCatch - the file may not grow past 500), scripts/fight3d/MoveStudio.gd (the block preview line ~96-100 only), tests/block_catch_test.gd (new), tests/block_meet_test.gd (311 lines; point it at the new block, never loosen a bar), docs/BLOCKLOOK2_RESULT.md
RED_TEST: tests/block_catch_test.gd -> BLOCK_CATCH failures=0
REGRESSION: block_meet_test, block_set_test, beat_clips_test, fight_feel_test, punch_speed_test, head_aim_test, hit_snap_gain_test, guard_weave_test, file_limits_test
VISUAL: yes - Claude films blocks in the played fight on the PC (tools/hit_frame_film.gd) and judges them; the PR cannot close on tests alone
NOT YOURS: every other file. Never edit scripts/rules or scripts/state (the 3D fight never decides anything).

## The defect (the owner's words, review board 2026-11-12: "doesnt even look like a normal human"; "nothing seem to be blocked red fighter misses, blue fighter just holds guard")
The game's only block is the clip `mc_to_block` (MoCap Online Punch_M3_Idle_To_Block). Rendered alone (Claude, S447,
docs/mockups/s447/block_clip/mc_to_block_*.png, six moments 0.00-0.93 s): from its first frame it is a deep cover-up -
torso hunched forward and sideways, head buried in the arms, BOTH gloves above the head. BlockGloveLift then lifts the
arms further. Against a jab the punch lands on the upper arm/chest under the raised gloves (S446,
docs/mockups/s446/block_A_B_jab_after_power1.png). Every other block clip we own (pro blocks, mc_block_hit, mc_block)
also holds a glove above the head for 1-4.6 s (BeatClips.gd lines 96-100). No clip in the library is a usable block.

## The job (a guard-based catch: no block clip at all)
1. RED first: tests/block_catch_test.gd stands the game's FightStage pair at the stage's own gap (tests/ruler_stand.gd, as
   block_meet_test does: A=mh_boxer_10, B=mh_boxer_12; setups A_B and B_A), plays pro_left_jab, pro_right_cross,
   pro_left_hook, pro_right_hook into a block through the GAME's path (BeatFire's block branch, as block_meet_test's
   fight path), and reads the DRAWN skeleton (Skeleton3D.skeleton_updated, after every modifier) of the blocker at the
   contact frame. Bars per row:
   - UPRIGHT: the blocker's chest (spine top) leans at most 12 degrees further from vertical than in her guard one frame
     before the block starts; the head bone drops at most 0.06 m.
   - ONE GLOVE CATCHES: the catching glove (jab/lead hook: the blocker's REAR glove, on the side the punch comes from;
     cross/rear hook: the LEAD glove) is between the punch and the face, its centre 0.06-0.14 m in front of the face and
     -0.08..+0.06 m of face height (cheek to temple); the OTHER glove stays in guard (moves at most 0.05 m).
   - MEETS: block_meet_test's touch bar (glove-to-glove surface <= 0.04 m, not > 0.03 m inside) and to_face >= 0.08 m.
   - NO GLOVE ABOVE THE HEAD: neither hand bone more than 0.03 m above the head bone at any frame of the block
     (the S304 glove_height_check rule).
   - WRIST: elbow-to-wrist distance changes <= 0.01 m (the arm turns about the shoulder, never a torn hand).
   Show it RED on main (the cover-up fails UPRIGHT and NO GLOVE ABOVE THE HEAD) and paste those lines in the result.
2. BlockCatch.gd (a SkeletonModifier3D like BlockGloveLift, same set-up in FightStage, same lines): while a block is
   armed for this boxer it keeps her in her GUARD (no clip change: BeatFire stops calling stage.play(other, bclip...) for
   a block) and moves the catching arm about the shoulder (the BlockGloveLift method: turn UpperArm, then ForeArm, never
   the hand alone) so the glove reaches the catch point on the punch line (the punching glove's path toward
   FightStage.target_point) at the contact time, eases out over ~0.25 s after it; a small chin tuck (head down <= 0.03 m)
   and a give of 0.02-0.04 m backward on the hit are allowed. Arm timing: the glove is set BLOCK_SET_S before contact as
   today (block_set_test keeps holding).
3. BeatFire: the block branch arms BlockCatch (side, punch, contact time) instead of playing bclip; body_hook stays as is.
   BeatClips.DEFENCE["block"] becomes an empty list or a guard marker - keep `defence()` callers working (MoveStudio's
   preview arms the same catch).
4. block_meet_test: its fight-path rows read the new block; every bar keeps its number.
5. docs/BLOCKLOOK2_RESULT.md: before/after per row (lean, head drop, catch glove distance, touch, glove over head), the pass
   lines.

## Prior research
ops/research/TASK_BLOCKLOOK1.md (the finding); ops/research/J50_HOW_A_DEFENDER_DEFENDS.md (a jab is caught with the rear
glove at the cheek/temple; high guard vs shell); ops/research/DEFFLOW1_DESIGN_S382.md (parry/catch geometry: the side glove
meets the punch ~0.5 hand-width in front of the face); ops/research/D64_GUARD_STYLES.md; BeatClips.gd lines 96-100 (S304:
every owned block clip holds a glove above the head); scripts/fight3d/BlockGloveLift.gd (the arm-turn method that keeps the
wrist on); scripts/fight3d/GuardTuck.gd (the guard's glove places); ops/research/GDSCRIPT_TRAPS.md.
## What would a human do?
Stay in the stance, eyes on the opponent, and bring the near glove a hand's width to the punch: the jab smacks into the
rear glove at the cheek, the head barely moves. A shell with both gloves over the head is for a flurry on the ropes, not
for one jab in the open.
## Prefab check
No owned clip is usable (all hold a glove above the head; checked S304 and S447). Bought packs wait for the end of
November (Punch Perfect lists 2 blocks; unseen). An IK catch on the guard needs no asset and keeps every style's guard.

## Rules
Repo ICOON-Studio/FightCamp-Lean, from main; branch `grok/blocklook2`; ONE PR to main. Godot: plain
`godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`. No file over 500 lines. Never delete or weaken
a test. Never "he" or "she" in game text.
RESULT lines for the PR body, copied from your final run:
RESULT: tests/block_catch_test.gd -> BLOCK_CATCH failures=0
RESULT: tests/block_meet_test.gd -> its own pass line
RESULT: tests/block_set_test.gd -> its own pass line
