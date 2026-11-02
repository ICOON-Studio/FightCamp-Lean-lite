# TASK PROFILE2E_FIX4 (S211) - review round 5 of cursor/profile2e (979f0668)

Model: Cursor composer-2.5 (local), same worktree E:/FightCamp/wt/PROFILE2E, branch cursor/profile2e. First `git merge origin/master`.
Claude opened the round-4 stills. FIXED: week program (Mon RING ... Sat/Sun REST), training load reads RING, composure RATTLED (new bands).
STILL BROKEN: the overview portrait shows the CHEST and a fist - no face at all (cropped at the jaw). Your PORTRAIT_COVERAGE check said 76.7%
"ok" because it counts every non-background pixel: a box full of chest passes. A green instrument that cannot read worse is not a check.

## Prior research
TASK_PROFILE2E_FIX3.md (round 4), PROFILE2E_DIGEST.md, CLAUDE.md s5 ("a green instrument must be able to read worse").
## What would a human do?
Look at the box: eyes, nose and mouth in the upper-middle of the frame, top of the head just inside, chin above the bottom third.
## Prefab check
None needed - Godot `Camera3D.unproject_position` does the projection.

## The defect (Claude found it - fix exactly this)
`Godot/scripts/ui/ProfileStage.gd` `_set_camera("portrait")` (~line 222): `camera.look_at(head_aim + Vector3(0.0, -0.34, 0.0))` aims the
camera 34 cm BELOW the head = the chest. Aim at the face: look at a point between the eyes and the mouth (head bone + ~0.03-0.06 m up,
slightly forward along `_facing`), keep 30 deg FOV, distance so head-top to chin spans ~45-60% of the box height.

## 1. Replace the coverage check with a FACE check that can fail (keep the pixel % only as a secondary print)
New static `ProfileStage.portrait_face_metrics(camera, skeleton, viewport_size)`: project with `camera.unproject_position` the world
positions of the head bone, the head TOP (head bone + head height ~0.12 m along the head's up), and the CHIN (neck bone or head bone
- 0.10 m). PASS when: all three are inside the viewport; head-top y >= 2% of height (headroom); chin y <= 75% of height; head bone x
within the middle 40% of the width; (chin_y - top_y) between 35% and 75% of the height. Print
`PORTRAIT_FACE <athlete> top=<y%> head=<x%,y%> chin=<y%> span=<%> ok=<bool>` for Bruno and Niko in the stills run, and assert it in
`profile_stage_test.gd`. PROVE IT: the new check must FAIL on 979f0668 (the chest framing) - paste the FAIL line in the digest.
## 2. Truncated station names in the weekly schedule
`2_tab2_performance_camp.jpg`: "BASIC CARDIO FLO", "COMPACT FREE-WEI" are cut. Wrap to two lines (autowrap in a fixed-width column) or
shorten with a full-name tooltip - never clip a word mid-way. Check every day column at 1920x1080.
## 3. Re-shoot every still, `python Godot/tools/run_tests.py --jobs 1 --only profile`, digest "round 5" with the PORTRAIT_FACE lines
(FAIL on 979f0668, PASS after), commit, push cursor/profile2e. Never master.

## Owned files
- `Godot/scripts/ui/ProfileStage.gd` (382 lines), `Godot/scripts/ui/ProfileOverview.gd` (733), `Godot/scripts/ui/ProfilePerformance*.gd`
- `Godot/tools/profile2_stills.gd`, `Godot/tests/profile_stage_test.gd`, `previews/profile2e/`, `research/PROFILE2E_DIGEST.md`

## Rules + the one trap
Parse gate on touched .gd (`python Godot/tools/check_scripts.py <files>`); watchdog before every Godot run; windowed runs only via
Tools\godot_hidden.ps1; headless with Godot_v4.7.2-stable_win64.exe (NEVER _console.exe - your round 4 left two _console test processes
hung for 3 hours); never open image viewers/browsers; never master. You cannot see images: trust only the projected numbers.
TRAP: `get_bone_global_pose` headless needs `force_update_all_bone_transforms()` first, and the camera must be in the tree.
