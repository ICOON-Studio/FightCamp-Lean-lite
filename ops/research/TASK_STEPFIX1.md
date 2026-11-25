# TASK STEPFIX1 - the step in / back off pictures must carry the man (S559)

Kind: build (picture tool fix + re-render). Model: claude-opus-5-5. Discipline: boxing (demo path).
Seat: console worker. Estimate: 1-2 hours, ~10 min of GPU renders.

## Why
Owner S559 on the Ring Switches page: "the fighter do no seem to do use their feet and when i select step-in their feet
have no animation and their position does not change". Checked (Claude, S559): `proto/twohands/img/anim/blue_step_in_r2_0..7`
play during the beat, but the stepping man's front boot stays within a few pixels from frame 0 to frame 7 - the step
take's own body travel (`st_in_m`, 0.355 m, STEPS in `tools/pics2d_anim_more.gd` line ~18, "the body carried by the
take's own hip travel, as StepPlay does") does not reach the pictures. The men only jump when the next range's hold
pictures show (`_r2` stands 33-34 px closer per man in the 480 px picture: the two front toes 113 px apart at Long, 46 at
Mid, touching Inside).

## Do
1. RED FIRST: a picture bar in the step run's gate (or a small python check over the frames): the stepping man's front
   toe moves 25-45 px (one man's share of a range step, in the 480 px web picture) toward the other man from the first to
   the last frame for a step in (away for a back off), the other man moves under 5 px. It must fail on today's frames.
2. Find why the travel is lost (`_step_run` in `tools/pics2d_anim_more.gd`, StepPlay, the root / hips track of the
   refitted step take, the camera re-aim: `_aim` must not follow the stepping man inside a run) and fix it in the tool.
3. Re-render every step run: `blue_step_in`, `blue_step_in_r2`, `blue_step_in_r1`, `blue_back_off`, `..._r3`, `..._r2`
   and the red ones (`only=` prefixes), through the queue on the hidden desktop:
   `python ops/Tools/godot_slot.py run --who STEPFIX1 -- python tools/hidden_desktop.py run --timeout=1800 --log=<log> <godot.exe> --path . --windowed --resolution 1920x1080 --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_anim_more.gd -- <dir> art=toon set=m only=<runs>`
   The last frame of a step in must stand where the next range's hold pictures stand (within 6 px) so nothing jumps.
4. `python proto/twohands/tools/anim_web.py <dir> --strips <strips>` (it merges), `node proto/twohands/tools/anim_check.mjs`,
   `node proto/twohands/tools/page_play_test.mjs`. A before/after strip (old frames from `git show HEAD:...`) to
   `ops/previews/s559_stepfix.png` and on the board: `python ops/Tools/review_add.py --stage S559 --rating "not scored: your eye" --title "Step in carries the man" ops/previews/s559_stepfix.png`.
Note: if `tools/pics2d_camera.json` appears while you work (the owner saving his new camera), STOP rendering and say so:
the full re-render with his camera is a separate job and must not mix two cameras on the page.

## Contract
- OWNS: tools/pics2d_anim_more.gd (the step run only), the step runs' pictures in proto/twohands/img/anim and frames.json rows
- RED_TEST: the toe-travel bar on today's step frames
- REGRESSION: anim_check.mjs PASS, page_play_test.mjs 4 passed
- VISUAL: the before/after strip, opened by you

## Not allowed
No change under scripts/. No other runs re-rendered. Never `_console.exe`; Godot only through godot_slot + hidden_desktop.
HIS GAME FIRST: `Get-Process ArcheAgeChronicles` before a render; if it runs, wait. Commit only your paths, by pathspec.

## Prior research
docs/RINGANIM1_RESULT.md (render steps, timings); memory: "THE FIGHT MUST BE SEEN, SIDE VIEW" (south=blue).

## What would a human do?
Scrub the step clip frame by frame, see the hips stay put, find where the root motion is dropped, fix it, re-export.

## Prefab check
Not applicable (our own take and tool).

## Feedback loops
None: pictures only.
