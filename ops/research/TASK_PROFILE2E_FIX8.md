# TASK PROFILE2E_FIX8 (S215) - round 9: the gate passes but the picture still shows the defect - gate the PIXELS

Model: Cursor (composer). Worktree E:/FightCamp/wt/PROFILE2E, branch cursor/profile2e (HEAD b85eb471). Never master.

## What Claude saw (primary source: your round-8 stills, opened by Claude S215 - you could not open JPEGs)
- `2_profile_overview.jpg` (Bruno, portrait panel x 24..484, y 154..594): the hair TOUCHES the panel top edge (crown ~0%, your
  log says ~13%); the face points DOWN - eyelids half closed, gaze at the floor, we see the top of the scalp. Chin ~65% is fine,
  shoulders visible are fine.
- `2_tab3_medical_bio.jpg` (FACE & CUT TISSUE panel): same - head pitched down, eyes on the floor, camera above the eyes.
- So `PORTRAIT_FACE ... head_pitch=4.1 ok=true` measures a bone/mesh number that is not what the picture shows. A gate that passes
  on this picture closes nothing (CLAUDE.md: a visual fix closes only on the game's picture).

## Do
1. Make the gate read the RENDERED image: in profile_stage_test grab the face SubViewport texture (get_texture().get_image()) at
   the real panel size and measure there: crown = first row with non-background pixels from the top (must be 6-14% of height);
   eye line from the projected eye-bone positions (unproject the eye bones with the portrait camera, 35-42%); face direction from
   the projected nose-tip vs the two eyes (nose must not sit below the eye midpoint by more than an eye-to-eye distance x 0.9 - a
   downward-pitched face pushes the nose low). Red first: the gate must FAIL on b85eb471's picture.
2. Fix the look: camera at eye height looking level (not from above); head and neck levelled so the face looks at the camera
   (if the MetaHuman face rig has eye bones / look-at, aim the eyes at the camera; eyelids open - the idle frame you froze may be a
   blink/look-down frame - pick a neutral open-eye frame). Portrait only, never the fight animation.
3. Re-shoot the same stills; describe in PROFILE2E_DIGEST.md the gate numbers read FROM THE PICTURE for Bruno, Niko, Phuket, Rafael.
4. `python Godot/tools/run_tests.py --jobs 2 --only profile,readout` - nothing green goes red. Commit, push cursor/profile2e.

## Owned files
ProfileStage.gd, profile_stage_test.gd, tools/profile2_stills.gd, docs/previews/profile2e/, PROFILE2E_DIGEST.md. Not ProfileOverview.gd.

## Prior research / What would a human do? / Prefab check
Prior: FIX5-FIX7 briefs, PROFILE2E_DIGEST.md rounds 6-8. Human: a portrait photographer shoots at eye level, subject looking into
the lens, ~10% headroom, and checks the PRINT, not the light meter. Prefab: none - our rig.

## Rules
Watchdog before each Godot run (RED = wait); windowed Godot only via Tools\godot_hidden.ps1; headless Godot_v4.7.2-stable_win64.exe
only (never _console.exe); no image viewers/start/explorer. You cannot see images: the pixel gate IS your eyes - make it strict.

## The one trap
A headless run renders no texture (dummy renderer): the pixel gate must run windowed via Tools\godot_hidden.ps1, or it measures an
empty image and "passes".
