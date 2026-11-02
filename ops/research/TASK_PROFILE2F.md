# TASK PROFILE2F (S224) - the fighter profile's 3D stage shows the boxer's FACE, proven on the rendered image

Model: Codex gpt-6-astra, effort high (CODEX_MODEL=gpt-6-astra, CODEX_EFFORT=high), PC, after the ANIMCHAIN2 run ends (Godot is
exclusive until then). Worktree E:\FightCamp\wt\PROFILE2E (exists; branch cursor/profile2e at 34eb4f48 = round 12) - first
`git fetch origin && git merge origin/master` (keep both sides; never take a whole file from another branch). Seed the import cache:
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\PROFILE2E`.
Push to a NEW branch codex/profile2f. Never master.

## The defect (seen by Claude on round 12's own stills)
`E:/FightCamp/wt/PROFILE2E/previews/profile2e_s223/2_profile_overview.jpg`: Bruno stands in full side profile, nose to
the right, body side-on - the whole body is ~90 deg off. `Godot/scripts/ui/ProfileStage.gd` (260 lines on master) `_chest_facing()`
(~line 85) reads the facing from the chest bones and gets it wrong for this rig; `_set_camera` (~192) aims from that. The test
`profile_stage_test.gd` reported face_ok / eye_ratio = 1.0 while the picture shows a side profile = a BLIND gate. Twelve rounds of
camera tuning failed: no round 13 of tuning numbers.

## Do
1. Facing from the FACE: find the head's eye bones/markers (or the head mesh's eye vertices) and the nose tip on this MetaHuman rig;
   face-forward = normalize(nose_tip - eye_midpoint) projected on the floor plane. Place the camera on that axis (front 3/4 = rotate
   the axis by the existing preset's yaw), at eye height per the preset, looking at the eye midpoint. Keep the presets' framing.
2. If the body itself stands rotated relative to its face (a rig/import yaw), turn the BODY to face the camera's preset, not the camera
   around the body - the same stage is used by other screens (grep ProfileStage callers) and must show the same front.
3. Keep every other behaviour (play(), slow, loop, guard, lights) unchanged.

## Gate - on the RENDERED image (red first)
- New check inside `Godot/tests/profile_stage_test.gd` (windowed, through `Tools\godot_hidden.ps1` - it needs the GPU): render the
  stage to an Image at 1920x1080 profile layout, project the two eye points and the nose tip through the camera
  (`camera.unproject_position`), then assert on the PIXELS: both eye points inside the viewport and not occluded (depth test against
  the head mesh, or the screen-space distance between eyes >= 60% of the frontal value); nose tip x between the two eyes' x within
  10% of the eye distance from their midpoint; no glove/hand pixels over the face box (sample the face box for the glove material
  colour). RED first on 34eb4f48 (paste the red line), then green.
- Mutant: rotate the body 90 deg in the test and show the check goes red.
- Parse: `python Godot/tools/check_scripts.py <touched .gd>`. Then `python Godot/tools/run_tests.py --jobs 2 --only profile`.
- Stills: the profile screen from the game's own flow (`-- as_game`): overview tab, one move playing (mid-punch), two different
  boxers (one MetaHuman male, one female). Save under previews/profile2f_s224/.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. Red on the shipped tree first (34eb4f48 still = side profile).
2. Game-camera stills in guard AND mid-move; for each: both eyes, nose between them, no glove over the face, the whole head in frame.
3. Write the per-still checks in research/PROFILE2F_DIGEST.md. Do not call it accepted: Claude opens every still, the operator
   closes it.

## Rules
Nothing opens on the operator's screens (godot_hidden.ps1 only, never _console.exe, file tools to view images). Watchdog before every
Godot run (`Tools\pc_watchdog.ps1 -Once`; RED = wait). Explicit `git add -- <files>`; never bare stash / reset --hard / checkout . /
clean / add -A; never commit *.import churn. Read GDSCRIPT_TRAPS.md before writing GDScript. Plain --script tests are the OFF control
arm; this is a defect fix, no switch.

## Prior research
TASK_PROFILE2E_FIX7..9.md (rounds that tuned numbers); S223_DIGEST PROFILE2 row; feedback: a visual fix is done only on the game's camera.

## What would a human do?
A portrait photographer finds the eyes first and places the camera on them - never on the shoulders.

## Prefab check
None needed: the eye/nose points come from the rig itself.

## The one trap
The old test read eye_ratio from bone positions, not pixels - it passed on a side profile. The new gate must be able to read worse:
prove it with the 90 deg mutant.
