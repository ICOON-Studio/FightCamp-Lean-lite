# TASK COACHNECK1 - the corner coach's neck stays upright in his close-up (the owner's C415 mark)

Status: OPEN (S496, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
The owner marked the corner-minute close-up (review comment C415, `ops/Feedback/2026-11-16-01/README.md`, picture
`marked.png` there): "his neck is coming out horizontally from his neck not vertically. the coach does not look like human
with this neck". The seated, hunched coach looks at his boxer and his head juts forward on a near-level neck. This is the
4th neck note (S309, S310, S437 in `scripts/fight3d/CornerIK.gd` comments) - each time the look was shared further down
the spine, never measured. This time it is measured.

## Read first
- `scripts/fight3d/CornerIK.gd` WHOLE (261 lines): `look()`, `_turn_head()` (MAX_LOOK_DEG 65, CHAIN_SHARE head, neck_02,
  neck_01, spine_05, spine_04, spine_03), the S310 trunk-up step, `loosen()` (S437).
- `tools/bodylook_pose.gd` header: a saved pose = every bone AFTER the modifiers, as the game drew it.
  The owner's pose: `docs/playtest/bodylook1/coach_c07_pose.json` (coach body `mh_staff_coach`).
- `tools/corner_film.gd` (its `posedump=<file>` option writes that pose again at still c07 `c07_reverse_pick`).

## What to build
1. `tools/coach_neck_probe.gd` (new, headless, SceneTree script, under 150 lines): loads the coach body
   (`res://assets/models/metahuman/mh_staff_coach.glb` - check the real path in CornerCrew.gd / BoxerBuild.gd), applies a
   pose file with `BodylookPose.apply`, then measures in WORLD space: (a) NECK ANGLE = the angle between the vector from
   the `Neck` bone (or `neck_01`) to the `Head` bone and the upper-spine up axis (`spine_05` / `Chest` bone's +Y); (b) the
   same vector's angle from world vertical; (c) HEAD AHEAD = how far the Head bone sits in front of the neck base,
   horizontally, in cm. Prints one line:
   `COACH_NECK neck_vs_chest=<deg> neck_vs_vertical=<deg> head_ahead_cm=<cm> ok=<1|0>` with ok=1 when neck_vs_chest <= 25
   AND neck_vs_vertical <= 40. On today's pose it must print ok=0 (that is the red). Exits 0 either way; never hangs
   (skip option words in the arg loop; quit() at the end).
2. The fix in `scripts/fight3d/CornerIK.gd` only: when the coach (or anyone) looks DOWN/FORWARD at a seated boxer from a
   hunch, the look's pitch goes into the chest and lower spine and the neck keeps its line with the chest (a real man
   leaning in to talk bends at the waist and upper back, his neck stays in line). Concretely: cap the neck and head
   bones' share of a PITCH (nodding forward) turn so the neck stays within 20 deg of the chest axis, and give the rest
   to spine_05/04/03; keep yaw (turning to face her) shared as today. Keep `MAX_LOOK_DEG` behaviour for yaw. Under 500 lines.
3. Re-dump the pose with the fix through the game's own corner film and re-run the probe on it:
   `python tools/hidden_desktop.py run --timeout=600 --log=<wt>/corner.log <godot.exe> --path . --windowed --resolution 1280x720 --audio-driver Dummy --script res://tools/corner_film.gd -- <out_dir> posedump=<out_dir>/coach_c07_after.json`
   then `<godot.exe> --headless --audio-driver Dummy --path . --script res://tools/coach_neck_probe.gd -- <out_dir>/coach_c07_after.json`
   must print ok=1. Put both probe lines (before on the saved pose, after on the new dump) in the PR body.
   Never run Godot windowed except through hidden_desktop.py (nothing may open on the owner's monitors). Never `tools/run_tests.sh`.

## Contract
OWNS: scripts/fight3d/CornerIK.gd, tools/coach_neck_probe.gd
RED_TEST: tools/coach_neck_probe.gd -- docs/playtest/bodylook1/coach_c07_pose.json -> COACH_NECK
REGRESSION: corner_crew_bodies_test, corner_face_line_test, corner_jobs_test
VISUAL: yes - Claude renders the c07 close-up before/after on the game camera and the owner judges it; your PR is not merged before.
NOT YOURS: every other file. Never delete or weaken a test. Work on your own branch, open a PR into main, never merge.
Run one test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd` (Godot 4.7.2).
PR body: the two COACH_NECK lines (before / after), `RESULT: tests/<each regression>_test.gd -> <its pass line>`.

## Prior research
`docs/playtest/bodylook1/README.md` (the collar work on the same close-up; the pose tools), memory notes in
CornerIK.gd's S309/S310/S437 comments (what was tried).

## What would a human do?
A seated man leaning in to talk to someone below him bends at the hips and upper back; his neck stays roughly in line
with his chest and his chin tucks; he does not crane the neck out level.

## Prefab check
None: this is a limit inside our own look IK.

## The one trap
The saved pose is AFTER CornerIK ran, so changing CornerIK does not change what the saved file measures - only the
re-dump in step 3 shows the fix. Measure the neck in world space from the Skeleton3D global bone poses
(`skel.global_transform * skel.get_bone_global_pose(i)`), not from the local values in the file.
