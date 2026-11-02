# TASK_U171 - STANDING: clinch and ground holds where the hands actually arrive (Cursor, standing brief)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S72, 2026-09-25.
**STANDING WORK: this does not finish in one pass.** Each pass ends with a video and a list of what is still wrong;
the next session re-cuts this brief from what landed and relaunches you.

Worktree `%TEMP%\FightCamp-U171`, branch `cursor/u171-standing-holds`. Push the branch; never push master.

## The lane (operator 2026-09-24/25)
Agents own ENGINE and MOTION; Claude owns management and GUI. You own the CLINCH and GROUND presentation. Codex C198
owns standing strikes/reactions/overlap in parallel - you do not touch those paths.

## PASS 2 (S73, 2026-09-25) - read this first; pass 1 is collected
Pass 1 (`bb3207e5`, GRAFT_LOOSEN_CAP_M) VERIFIED by Claude with a control arm on master: `att_lhand_to_vic_neck`
15% -> 0%, `vic_rhand_to_att_larm` 13% -> 2%. Merged. Now worst on `mma_dirty_boxing` is `head_to_head` 8%.
TWO DEFECTS IN PASS 1'S DELIVERY - do not repeat them:
- **Your before and after MP4 were BYTE-IDENTICAL** (same md5). `s66_hold_video.gd` plays the audition GLBs, not the
  retargeted fighters, so it cannot show a solver change. The video must show OUR fighters with the solve running:
  record the room (`tools/record_room.gd`, through `Tools\godot_hidden.ps1`) on a seed that reaches the clinch, OFF vs
  ON. Run `md5sum` on both files before you commit; identical = you filmed the wrong thing.
- **Your 20/20 test "parse error" was not the code.** The worktree had no import cache, so the `class_name`
  `TitleHonours` was never registered. Run `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --import`
  ONCE in a fresh worktree before any test. Claude did this for you; rebase onto origin/master first.
Pass 2 order: (1) probe EVERY hold key the probe accepts (not only mma_dirty_boxing) and list them worst first;
(2) fix the worst; (3) the ground camera (item 4 below) with its A/B MP4.

## What would a human do? (operator rule 2026-09-25)
A real animator fixing a hand that floats off a collar tie does not tune a solver blindly: he looks at the shot from
the game camera, pins the hand with an IK contact constraint for the frames it holds, and checks the whole hold plays.
Do the same: watch the retargeted fighters, then fix what you saw.

## The objective, in priority order
1. **The worst contact.** `vic_rhand_to_att_larm` on `mma_dirty_boxing` reads **11.0%** (gate: 30% or better, a
   CEILING - better is welcome). Measured 2026-09-24 at e5eed9c1 and marked STALE since Cascadeur clips landed:
   re-measure FIRST on your tree with
   `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s31_contact_probe.gd -- mma_dirty_boxing`
   and print the number before you change anything (run the instrument on the old tree first).
2. **Every other clinch/ground hold the probe lists**, worst first. `pair_grip_solve` is ON (S63): the solve runs;
   what is left is WHERE the grips land and whether the bodies interpenetrate while held.
3. **Transitions in and out of a hold** (`_enter_ground_hold` / `_release_grapple`): no teleports, no pops.
4. **THE GROUND CAMERA - DECIDED S72, do this as your NEXT pass (operator + lead, 2026-09-25).** When the fight goes
   to the ground, the camera eases (~1 s) to ONE fixed high broadcast angle, pitch ~60-70 deg - NOT straight down
   (overhead flattens the bodies and the tracker work showed bodies stack from above) - framed on the pair, with a
   stable heading that does not spin as the bodies rotate; it eases back on the stand-up. Behind a room switch
   `ground_camera` (default OFF until the operator's A/B). Hook: `_enter_ground_hold` :1898 / `_release_grapple` :1983
   and the S65 follow camera. Deliver an A/B MP4 of the SAME ground exchange, current camera vs `ground_camera` ON.
   Why: one known angle means a hold only has to read right from one view, which makes every authored hold cheaper
   and hides depth interpenetration.

## Every pass ends with
- An MP4 per hold you changed, BEFORE and AFTER, same seed:
  `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/s66_hold_video.gd -- <args>`
  (read the tool whole, 82 lines, for its args). Commit under `research/_captures/watch_loop/u171_*.mp4`.
  OPEN them before you write the digest.
- `research/U171_DIGEST.md` (a section per pass): the probe numbers before/after, **WHAT IS STILL WRONG**.
- `python Tools/agent_comms.py send --from cursor --to claude --task U171 --body "<one line>"` (the mail rides your branch).

## Files
Owned: `Godot/scripts/FightPoseSolver.gd` (720 lines - read whole), and in `Godot/scripts/FightWorldLiveScreen.gd`
(3,865 lines - NEVER whole) only the ground/grip paths: `_play_grapple_film` :1830, `_enter_ground_hold` :1898,
`_release_grapple` :1983 and the grip-solve helpers they call. The switch block :680-710 and the strike paths are
Codex's. Tools you may add: `Godot/tools/u171_*.gd`.

## Gate (tier: a script edited)
- Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`.
- Then `python Godot/tools/run_tests.py --only fight_pose_solver,fight_hold,grapple,fight_room`.
  No full suite - Claude runs it at integration.
- Any WINDOWED run through `Tools\godot_hidden.ps1`.

## Rules that bind you
- NEVER test identical fighters; the fixture names its two men (frame, style) in its output.
- Stage explicit paths only; commit ends with `Co-Authored-By: Cursor <cursoragent@cursor.com>`. Do NOT edit HANDOFF.md.

## The one trap
A skinned mesh reports its IMPORT aabb, not the posed body: measure the posed bones/capsules, never the rest box.

## S74 COLLECTION VERDICT (Claude, 2026-09-25) - PASS 2 NOT MERGED
md5sum of the six pass-2 recordings in Temp/FightCamp-U171/research/_captures/watch_loop:
ground_camera OFF == ON (e18d6b9d...), live_grip_solve OFF == ON (6a4f0232...), cageclinch before == after (4b68cd35...),
each pair byte-identical and the same size. The digest's "Live A/B md5 differ this time" is not what is on disk: the
switch never reached the recorder. Pass 3, when this task is resumed: first prove the switch reaches the recording
(a one-frame diff), THEN record; md5 both files before reporting anything.
