# TASK LEGTREMBLE3 - CURSOR (Grok 4.7 High) - the trembling legs, round 2 on a new seat: bake the smoothing into the shipped clips

Status: OPEN (S421, Claude main; LEGTREMBLE2 moved from Antigravity, whose account stopped mid-task: "AI credits balance is too low"). Discipline: boxing. Model: grok-4.7-high. Animation item (operator S401).
Source: the operator on the board's Boxer animations page, 11-10: "all these animaiton are broken the legs treble", "the issue
with the legs is in a lot of clips". Round 1 is PR 156 (branch agy/legtremble1): read its diff and docs/LEGTREMBLE1_RESULT.md
first. Start your branch FROM agy/legtremble1 (`git fetch origin agy/legtremble1` and branch off it): its tools are the base.

## Antigravity's partial round 2 (S421, read by Claude)
Before it stopped it rewrote tools/leg_smooth_bake.gd (FightClips/NativeClip loading, 30 s samples, a 2.60 degree flex bar) and
changed KneeTrack.gd (removed LEGTREMBLE1_FIX, the u_off fade and the unwrap). It baked NO clip and wrote no test. If the branch
agy/legtremble2 exists on origin, read its last commit (`git show origin/agy/legtremble2 --stat`) and take what helps; the KneeTrack
change has no before/after number, so keep it only with one. Your branch starts from agy/legtremble1 as below.

## Why round 1 was not collected (Claude, S420, read on the branch)
1. Nothing compiles: tests/leg_tremble_test.gd:54 and tools/leg_tremble_census.gd:44 call `FightClips.setup_clips(ap, skel)`,
   which does not exist. The loader is `FightClips.load_into(ap, skel)` (scripts/fight3d/FightClips.gd line 50); read it.
2. No clip file changed. The test smooths the clips IN MEMORY (`smooth_animation` inside the test) and then measures its own
   smoothing: a check that can only pass, and the game still plays the trembling clips. The fix must be IN THE SHIPPED FILES.
3. The KneeTrack.gd change (side re-picked inside 35 degrees, u_off fade, unwrapped lerp) has no before/after number of its own.

## Contract
OWNS: tools/leg_tremble_census.gd, tools/leg_smooth_bake.gd, tests/leg_tremble_test.gd, docs/LEGTREMBLE1_RESULT.md,
scripts/fight3d/KneeTrack.gd, assets/anim/baked/*.res (NOT mc_Box1_M3_Right_Hook.res, NOT mc_Box1_M3_Right_Hook_FT.res:
both were just edited by REARHAND5B and are on main), tests/fixtures/leg_tremble_census_before.json
RED_TEST: tests/leg_tremble_test.gd -> LEG_TREMBLE failures=0
REGRESSION: beat_clips_test, move_tip_test, head_aim_test, block_meet_test
BASE: agy/legtremble1
VISUAL: Claude re-renders the board films after the merge and looks. Do not render.

## The job
1. Fix the two calls (`FightClips.load_into`). Run the census on MAIN's clips (before any bake), both ruler controls first
   (smooth 1 Hz sine reads 0, 10 Hz 2 degree wobble reads near 20 a second). Save the per-clip film-arm table as
   tests/fixtures/leg_tremble_census_before.json (clip -> left and right knee zigzags a second).
2. Run tools/leg_smooth_bake.gd ONCE, offline, writing the smoothed clips to assets/anim/baked/*.res (only the clips the
   census reads above 0.5 a second; leave the rest untouched, byte for byte). Commit the changed .res files.
3. The test LOADS THE SHIPPED FILES and measures them as they are; it never calls smooth_animation. Bars as round 1 (zigzags
   <= 0.5 a second both knees, flex diff <= 3 degrees against the before file, peak bend <= 2 degrees, plant foot slide <= 5 mm,
   punch contact and reach unchanged). It reads the before numbers from the fixture, prints before and after per clip, and
   fails if any clip got worse.
4. KneeTrack: run the film arm with main's KneeTrack and with yours, on the baked clips, and print both counts. Keep your
   change only if it lowers the count and changes no guard-knee number (S408: distance out of the hip-ankle-foot plane).
   Otherwise revert KneeTrack.gd to main's.
5. Write the table (before / after, per clip, 153 rows or the clips that changed plus a total) into docs/LEGTREMBLE1_RESULT.md
   under "Round 2".

Write no check that can only pass: show it red by pointing the test at the before fixture's clips (git show main:...), once,
and paste that red line into the result doc.

## Prior research
TASK_LEGTREMBLE1.md (the ruler, the census numbers, the human approach); tools/owned_mocap_jitter.gd header;
ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Smooth the legs of the clips that shake, save the files, and measure the saved files, not a copy made in the test.

## Prefab check
None needed: round 1 wrote the filter.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who agy -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`
(never the console build). No file over 500 lines (leg_smooth_bake.gd is 496: split it if it grows). No fixed he or she in text.

## Result lines (PR body)
RESULT: tests/leg_tremble_test.gd -> LEG_TREMBLE failures=0
RESULT: tests/beat_clips_test.gd -> BEATCLIPS failures=0
RESULT: tests/block_meet_test.gd -> BLOCK_MEET failures=0
