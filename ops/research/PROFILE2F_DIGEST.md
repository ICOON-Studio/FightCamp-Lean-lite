# PROFILE2F - rendered face direction (S226 review)

Status: implementation and rendered evidence delivered on `codex/profile2f`; operator visual acceptance OPEN. Final regression results are recorded below.

## Baseline and ownership

- Worktree `E:/FightCamp/wt/PROFILE2E`; started at `34eb4f48`. Merged origin/master with both HANDOFF sides preserved (`eea1e9f9`). Stage and its test were byte-identical to 34eb4f48 after the merge.
- Existing untracked PROFILE2E artifacts were preserved. Two untracked task files blocking the merge were moved intact to `E:/FightCamp/profile2f_preserved_intake/`. No other agent worktree was touched.
- Task overrides: merge instead of general rebase; new branch instead of master; hidden Godot launcher; one test worker despite task's generic jobs-2 example. Profile-specific single-fighter captures use the existing profile flow harness, not the live-fight two-fighter capture harness. No source animation, playback, slow, loop, guard or light changes. No import files staged.

## Red first and root cause

Initial instrument `ad47710d`, unchanged 34eb4f48 stage:

```text
RENDERED_FACE bruno_moreau eye_ratio=0.216 nose_offset=2.390 glove_pixels=0 inside=true ok=false
FAIL: bruno_moreau rendered eyes/nose/face unobstructed
```

The baseline beauty visibly shows one eye in side profile. Female baseline ratio was 0.220. Its 90-degree mutant could report geometric eye_ratio 0.999 while showing the back of the head with no visible eye pixels. These are real rendered failures, not missing-feature exceptions.

The rig has no eye/nose bones. The old fallback guessed eyes from the extremes of a head-height skin band along a Head bone axis. That is not the mesh's anatomical lateral axis; camera and geometric gate shared the same wrong assumption.

The new reader uses existing `MH_Eye` and `MH_Skin_Head` surfaces, inverse binds and posed skeleton transforms. Raw inspection of MH01..MH12 confirmed the anatomical eye split in mesh rest X and central nose in +Z. No generated markers or replacement bodies. The camera uses horizontal nose-minus-eye-midpoint; portrait distance follows direct perspective bounds over posed head/hair. Preset yaw, pitch and framing remain. No evidence calls for rotating the body relative to its face.

Camera change `3f998d44` passed the strict portrait gate. Additional moving-pose regression `58c01dda` exposed the cached guard-facing direction: `PROFILE_RENDERED_MOVES total=9 fails=4`. The follow-up changes the camera's input to the current posed face after each existing animation advance, preserving the preset angles and scale.

Final moving-camera commit: `d38af143`, pushed after validation. All code commits were individually pushed to `codex/profile2f`.

## Independent pixel gate

The normal GPU beauty and a depth-tested ID pass use the same skinned mesh. Actual visible green eye centroids must remain at least 60% of frontal spacing; both eyes and blue nose pixels must exist; no red hand/body pixels may cover the face box. Portrait nose centring is within 10% of eye spacing. The full-body front34 check retains the intentional preset yaw and requires the nose between the eyes (50% from their midpoint); it is not represented as the strict frontal portrait gate.

Read-only review caught two measurement issues: the nose patch needed posed world coordinates, and ID materials must preserve double-sided culling plus translucent lash alpha. Opaque black lashes had falsely hidden the contact eyes. Green-dominant contribution through the original translucent lashes now counts as visible; eye-spacing, nose and occluder assertions remain. Final material/timing repair: `3135d42c`.

Final GPU results:

- `PROFILE_RENDERED total=6 fails=0`: male/female observed eye spacing 0.987/1.039, observed nose offset 0.000/0.000. Both 90-degree body mutants remain RED; the hand-colour occluder remains RED while geometric eye ratio is 0.999.
- `PROFILE_RENDERED_MOVES total=13 fails=0`: both sexes pass guard, between and measured contact, including active-clip and timestamp assertions. Contact eye pixels male 11/7, female 12/11; observed spacing 0.940/0.939; no hand pixels in the face box. The standalone fixtures exercise the normal body picker; the game-flow bodies below are separately resolved and logged as MH06/MH12.
- Evidence: `red/`, `portrait_verified/`, `moves_verified/`, `game/`, `rendered_gate_comparison.jpg`, and their text summaries under `previews/profile2f_s224/`.
- Parse: initial four scripts 0 failures; subsequent stage parse 1/0; capture and sampling parse 2/0; final ID-material test parse 1/0. Full suite not run.

Final behavior gates after the moving-camera change: `PROFILE_STAGE total=256 fails=0`, focused runner `SUITE total=1 fails=0`, required affected subset `SUITE total=15 fails=0`, all with `--jobs 1`. These cover playback, slow, loop, combinations, grounding, profile layout and real handlers. Earlier validation had a thermal launch refusal and a passing targeted retry; the final 15/0 run required no retry. Logs were inspected for errors, not judged on exit code alone.

## Capture corrections and limits

The first capture was rejected: it froze the hidden overview portrait rather than the visible technique stage, giving identical between/contact times. The delivered harness selects the non-portrait stage, clicks the real Jab row and asserts the active clip. It advances normal playback to the actual clip clock because `as_game` can warp wall time; no direct seeking or disabling production pose writers. Capture commit `35a6f2d1`.

Existing FBX buffer-read and ObjectDB leak warnings occur in baseline and candidate runs. A full capture-log audit found 15 missing imported gym/card textures in the seeded cache; the exact files were copied from the existing main cache and the capture repeated. The completed capture still reports one resource in use at shutdown, after all eight images and clock assertions succeed; this cleanup issue is not reported as a clean runtime log. No SCRIPT ERROR occurred. Existing female shirt holes remain visible. The task's unchanged-body/animation scope takes precedence over repairing unrelated art under the generic visual-gate rule; those holes are reported for their owner. Stills establish sampled poses, not continuous playback smoothness or foot sliding. Per-frame landmark extraction has not received a dedicated performance benchmark.

## Reproduction

Before every invocation run `powershell -NoProfile -ExecutionPolicy Bypass -File Tools/pc_watchdog.ps1 -Once`; RED means wait. Use only `Tools/godot_hidden.ps1` with `FIGHTCAMP_GODOT_EXE=C:/Users/user/AppData/Local/Programs/Godot/Godot_v4.7.2-stable_win64.exe`.

```text
Tools/godot_hidden.ps1 --path Godot --resolution 1920x1080 --script tests/profile_stage_test.gd -- as_game rendered_face out=docs/previews/profile2f_s224/portrait_verified
Tools/godot_hidden.ps1 --path Godot --resolution 1920x1080 --script tests/profile_stage_test.gd -- as_game rendered_moves out=docs/previews/profile2f_s224/moves_verified
Tools/godot_hidden.ps1 --path Godot --resolution 1920x1080 --script tools/profile2_stills.gd -- as_game profile2f out=docs/previews/profile2f_s224/game
python Godot/tools/run_tests.py --godot <watchdog-and-hidden-launcher-wrapper> --jobs 1 --only profile_stage
python Godot/tools/run_tests.py --godot <watchdog-and-hidden-launcher-wrapper> --jobs 1 --only profile
```

## Game-flow still inspection

All eight 1920x1080 files were opened with file tools, with no screen windows. Career recruitment -> gym quick look -> full profile -> actual Techniques tab and Jab row. Samples: clip 0.1614s between, 0.3236s contact; both sexes passed active-clip/time assertions.

### `game/male_overview.jpg`

Gap: one fighter on the profile stage; no opponent.

Nose: faces the viewer, centred between the eyes.

Wrists: outside the intended portrait crop.

Feet: outside the intended head-and-torso portrait crop.

Face: both eyes visible, nose between them, no hand over the face, whole head and hair in frame.

Body: Bruno Moreau, MetaHuman MH06.

### `game/male_guard.jpg`

Gap: one fighter on the profile stage; no opponent.

Nose: points towards the viewer in the retained three-quarter view.

Wrists: both fists follow the forearms in guard, below the face.

Feet: both in frame on the plinth, staggered without crossing; a still cannot establish sliding.

Face: both eyes visible, nose between them, no hand over the face, whole head and hair in frame.

Body: Bruno Moreau, MetaHuman MH06.

### `game/male_jab_between.jpg`

Gap: one fighter on the profile stage; no opponent.

Nose: points towards the viewer in the retained three-quarter view.

Wrists: extended hand follows the forearm; rear hand stays beside the torso.

Feet: both in frame on the plinth, staggered without crossing; a still cannot establish sliding.

Face: both eyes visible, nose between them, no hand over the face, whole head and hair in frame.

Body: Bruno Moreau, MetaHuman MH06.

### `game/male_jab_contact.jpg`

Gap: one fighter on the profile stage; no opponent.

Nose: faces the viewer with the head tipped down at measured jab contact.

Wrists: extended hand follows the forearm; rear hand stays beside the torso.

Feet: both in frame on the plinth, staggered without crossing; a still cannot establish sliding.

Face: both eyes visible, nose between them, no hand over the face, whole head and hair in frame.

Body: Bruno Moreau, MetaHuman MH06.

### `game/female_overview.jpg`

Gap: one fighter on the profile stage; no opponent.

Nose: faces the viewer, centred between the eyes.

Wrists: outside the intended portrait crop.

Feet: outside the intended head-and-torso portrait crop.

Face: both eyes visible, nose between them, no hand over the face, whole head and hair in frame.

Body: Hana Navarro, MetaHuman MH12. Existing shirt cutouts are visible; clothing assets were not changed.

### `game/female_guard.jpg`

Gap: one fighter on the profile stage; no opponent.

Nose: points towards the viewer in the retained three-quarter view.

Wrists: both fists follow the forearms in guard, below the face.

Feet: both in frame on the plinth, staggered without crossing; a still cannot establish sliding.

Face: both eyes visible, nose between them, no hand over the face, whole head and hair in frame.

Body: Hana Navarro, MetaHuman MH12. Existing shirt cutouts are visible; clothing assets were not changed.

### `game/female_jab_between.jpg`

Gap: one fighter on the profile stage; no opponent.

Nose: points towards the viewer in the retained three-quarter view.

Wrists: extended hand follows the forearm; rear hand stays beside the torso.

Feet: both in frame on the plinth, staggered without crossing; a still cannot establish sliding.

Face: both eyes visible, nose between them, no hand over the face, whole head and hair in frame.

Body: Hana Navarro, MetaHuman MH12. Existing shirt cutouts are visible; clothing assets were not changed.

### `game/female_jab_contact.jpg`

Gap: one fighter on the profile stage; no opponent.

Nose: faces the viewer with the head tipped down at measured jab contact.

Wrists: extended hand follows the forearm; rear hand stays beside the torso.

Feet: both in frame on the plinth, staggered without crossing; a still cannot establish sliding.

Face: both eyes visible, nose between them, no hand over the face, whole head and hair in frame.

Body: Hana Navarro, MetaHuman MH12. Existing shirt cutouts are visible; clothing assets were not changed.

S226 review: POSTED 9 file(s) -> http://127.0.0.1:8787/review  (E:\FightCamp\review\2026-10-15_2222_profile2f_eyes_and_nose_in_the_game_prof)
OLDER VERSION marked on 1 post(s): 2026-10-15_2212_profile2f_eyes_and_nose_in_the_game_prof

OPEN for Claude to inspect every still and for the operator to close. SendUserFile is unavailable in this session; local links and the requested ops-board post provide the files.
