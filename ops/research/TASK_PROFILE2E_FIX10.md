# TASK PROFILE2E_FIX10 (S221) - round 12: the gate passes a side profile with two hands in frame - measure from the eyes, drop the hands

Model: Cursor (composer). Worktree E:/FightCamp/wt/PROFILE2E, branch cursor/profile2e (HEAD d02b5077). Never master.

## What Claude saw (primary source: your round-11 stills at 98c60b4c, opened by Claude S221)
- `previews/profile2e/2_profile_overview.jpg` (Bruno, portrait panel x 24..484, y 154..594): the head is in FULL SIDE
  PROFILE - nose pointing to screen-right, one ear toward us - and a bare hand claws at the chest (x ~190-230, y ~500-560).
- `2_tab3_medical_bio_injured.jpg` FACE & CUT TISSUE panel: same side profile, and TWO hands in frame (x ~830-900 and ~1190-1260,
  y ~880-960).
- Your log for the same run: `face to camera ~3 deg`, `hand_px=0`, `ok=true`. The numbers pass, the picture fails - for the third
  round. The instrument is wrong, not the camera maths.

## Why the instrument lies (Claude read ProfileStage.gd at d02b5077)
1. `_apply_portrait_eye_contact` (~line 337) and `portrait_face_to_cam_deg` (~859) take the face direction from the head BONE's
   -Z, and line ~338 even swaps to +Z when +Z points nearer the camera - so "the face points at the camera" is true by construction.
   The MetaHuman head bone (imported from Unreal) does NOT have its face along +-Z. `_eye_world_position` (~1021-1041) is built from
   the same wrong forward, so the eye point is guessed, not measured.
2. The hand hiding (~735-752) hides MeshInstance3D nodes named hand/glove or skinned to arm bones. The MetaHuman body is ONE skinned
   mesh: hiding it would hide the whole body, so in practice nothing is hidden and the hand pixel count is not seeing the hands.

## What would a human do?
A photographer looks at the subject's EYES to know where the face points (not at his skeleton), stands in front of them at eye height,
and asks him to drop his hands to his sides before the shot.

## Do
1. FACE DIRECTION FROM THE FACE, never from a bone axis:
   - Print every skeleton bone name containing "eye", "nose" or "FACIAL" (report the list).
   - If left/right eye bones exist: eye_mid = their midpoint; across = R_eye - L_eye (horizontal); face_fwd = across.cross(UP) with
     its SIGN chosen so it points from the head bone origin toward eye_mid (dot > 0) - never chosen by the camera.
   - Else: from the HEAD MESH vertices (in world space, posed): the nose tip = the vertex in the band eye_y-6cm..eye_y+2cm with the
     greatest horizontal distance from the head bone origin; face_fwd = horizontal (nose_tip - head_origin). Eye height = the head
     mesh's eye-socket band, or the nose tip y + 3.5 cm - say which you used.
   - Delete the +-Z swap; `portrait_face_to_cam_deg` and the eye point use face_fwd / eye_mid only.
2. CAMERA IN FRONT OF THE FACE: camera position = eye_mid + face_fwd * d (horizontal), y = eye_mid.y, level, looking at eye_mid
   along -face_fwd; keep your frustum lens shift (eyes at 35-42%) and crown/shoulder bands. Do not twist the head toward the camera:
   with the camera placed on face_fwd, the LookAt modifier only needs a few degrees - limit it to 10 deg or remove it.
3. HANDS DOWN FOR THE PORTRAIT: in the portrait only, override the arm bones (UpperArm/LowerArm/Hand, left and right, whatever the
   MetaHuman names are) to a relaxed arms-down pose (upper arms ~10 deg from the body, elbows nearly straight) AFTER the idle clip
   samples, every frame the portrait renders. No mesh hiding. Remove the dead hide-meshes code.
4. A GATE THAT CAN SEE IT - `PORTRAIT_FACE` gets two new geometric numbers, computed with `camera.unproject_position` on the
   rendered camera (world points, no bone axes):
   - `eye_ratio` = projected pixel distance between L and R eye points / the same distance if the face were exactly frontal at that
     depth (= true interocular metres * focal_px / depth). Frontal ~1.0; a side profile ~0.1-0.3. PASS >= 0.90.
   - `hands_in_frame` = how many of the 2 hand points (hand bone origins AND the middle-finger tip bones if present) project inside
     the portrait viewport rect and in front of the camera. PASS == 0.
   FIRST run the new gate on d02b5077 unchanged (Bruno, Niko Park, Phuket, Rafael) and paste the RED lines - eye_ratio must read
   low and hands_in_frame > 0 for Bruno, matching what the stills show. If it reads green on d02b5077, the gate is still blind:
   fix the gate before touching the camera.
5. Add both checks to `tests/profile_stage_test.gd` for the four fighters.

## Gate
- Parse: `python Godot/tools/check_scripts.py <touched .gd>`.
- `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/profile_stage_test.gd` (0 fails), then
  `python Godot/tools/run_tests.py --jobs 2 --only profile,readout` (use `--jobs 1` if the watchdog is not GREEN).
- Stills: `profile2_stills.gd` through `Tools\godot_hidden.ps1` ONLY on a GREEN watchdog (check first; AMBER/RED = wait and
  re-check every few minutes, never skip the stills). Overview + medical injured + techniques.
- Commit + push cursor/profile2e at every checkpoint. Never master. Do not open images in a viewer; read pixels/points in code.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md, UI portrait form)
Red first on the shipped branch (step 4 above). Report per still: where the nose points (left/right/at us), eyes level, any hand,
crown in frame. Do not call it fixed; Claude opens every still, the operator closes it.

## Prior research
TASK_PROFILE2E_FIX5..FIX9 (rounds 6-11), memory: Cursor cannot see images (brief geometric checks), MetaHuman rig notes in
MH2_DIGEST.md (bone names), the visual-gate skill.

## Prefab check
None - our own portrait stage (SubViewport + MetaHuman). Godot's LookAtModifier3D stays available but is no longer the main tool.

## The one trap
Never pick a sign or an axis by "whichever points at the camera" - that makes every check pass. The face direction comes from the
eyes/nose alone; the camera follows it, never the other way round.
