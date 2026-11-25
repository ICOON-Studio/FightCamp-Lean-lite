# TASK RINGCAM1 - a fixed ring camera for every picture, ready for the owner's angle (S559)

Kind: build (picture tools). Model: claude-opus-5-5. Discipline: boxing (demo path).
Seat: console worker. Estimate: 2 hours code + a sample render; the full re-render only after the owner's camera save.

## Why
STEPFIX1 (`ops/research/STEPFIX1_RESULT.md`) found the step pictures do carry the man, but every step starts with a
~33 px sideways snap of BOTH men: the hold and guard pictures are framed on the pair's middle, the step runs on their end
pose. Its recommendation 4: frame every picture on a FIXED ring spot (the camera never follows the pair), so nothing
snaps and nothing slides; fold it into the full re-render with the owner's new camera (CAMPICK1: `tools/camera_pick.cmd`
saves `tools/pics2d_camera.json`; not saved yet).

## Do
1. In the picture tools (`tools/pics2d_set.gd` `_aim`, `tools/pics2d_camera.gd`, the runs in `tools/pics2d_anim.gd` and
   `tools/pics2d_anim_more.gd`): an option (default ON once proven) to aim every run at ONE fixed point of the ring - the
   midpoint of the two men at Mid range - instead of the pair's middle, with the frame wide enough that both men stay head
   to feet at Long and at Inside (the framing gate must still pass; if the 768 px square cannot hold Long, say what
   ortho size it needs). Read the owner's pitch / yaw / size from `tools/pics2d_camera.json` when present.
2. Proof on a SAMPLE only (not the full set): render `blue_both_high_high` (all three ranges), `blue_step_in_r2`,
   `blue_step_in_r1`, `blue_back_off_r2`, `blue_jab_landed`, `blue_cross_landed_r2` (if that name exists) into
   E:/FightCamp/tmp/ringcam1/, and run `python tools/step_travel_check.py` (STEPFIX1's) on them: the START bar (first
   frame against the previous hold) must pass, with travel, other man and end still passing. A side-by-side strip
   before / after to `ops/previews/s559_ringcam.png`, opened by you.
3. Do NOT run anim_web.py on the sample (the page must not mix two cameras). Write the full re-render command list (every
   run family, the order, ~minutes each from docs/RINGANIM1_RESULT.md) into `ops/research/RINGCAM1_RESULT.md` so the
   session can start it the minute the owner saves his angle. Note the follow-ups the re-render forces: the floor
   distance numbers in `proto/twohands/ring_ui.js` (TOES) must be re-measured; `_dodge`'s `SIZE / ORTHO_M` (CAMPICK1's note).
Godot only through `python ops/Tools/godot_slot.py run --who RINGCAM1 -- python tools/hidden_desktop.py run ...`, never
`_console.exe`. HIS GAME FIRST (`Get-Process ArcheAgeChronicles`). If `tools/pics2d_camera.json` appears while you work,
use it for the sample and say so.

## Contract
- OWNS: tools/pics2d_set.gd (aim only), tools/pics2d_camera.gd, tools/pics2d_anim.gd and tools/pics2d_anim_more.gd (aim
  call sites only), tools/step_travel_check.py (if it needs a range-aware hold reference), ops/research/RINGCAM1_RESULT.md
- RED_TEST: step_travel_check.py START bar fails on today's frames (STEPFIX1 showed it)
- REGRESSION: with the option OFF, one run renders byte-identical to today
- VISUAL: the before/after strip, opened by you: no snap at the step's first frame; both men whole at Long and Inside

## Prior research
ops/research/STEPFIX1_RESULT.md; ops/research/CAMPICK1_RESULT.md; ops/research/RS3D1_ASSESSMENT.md (Option A);
docs/RINGANIM1_RESULT.md (render commands and times).

## What would a human do?
Lock the camera to the set, not the actors, so cuts between shots line up.

## Prefab check
Not applicable (our tool).

## Feedback loops
None: pictures only.
