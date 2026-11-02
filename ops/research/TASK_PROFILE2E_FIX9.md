# TASK PROFILE2E_FIX9 (S219) - round 10: the face still looks at the floor - put the camera at eye height and aim the head at it

Model: Cursor (composer). Worktree E:/FightCamp/wt/PROFILE2E, branch cursor/profile2e (HEAD 6c53c964). Never master.

## What Claude saw (primary source: your round-9 stills, opened by Claude S219)
- `previews/profile2e/2_profile_overview.jpg` (Bruno, portrait panel x 24..484, y 154..594): the crown is now inside the
  frame - FIXED, keep it. Still WRONG: the face points DOWN - eyelids lowered, gaze at the floor below the panel, we look down on
  the brow and the top of the head. Also a bare right hand floats in front of the chest at x ~190-230, y ~480-560.
- Your log says `head_pitch -5.0 ok=true`. Two rounds now the number passes and the picture fails, so the cause is not the head
  bone alone: the CAMERA sits above the eyes and looks down, and the idle pose tucks the chin (a boxer's guard does that).

## What would a human do?
A portrait photographer puts the lens at the subject's eye height, level, and asks him to look into the lens. Do the same:
1. Camera: position y = the eye midpoint's world y (from the MetaHuman eye bones / FACIAL_L_Eye, FACIAL_R_Eye or the head mesh
   eye landmarks you already use), camera pitch 0 deg (level), framing by moving it back/forward and by FOV only - never by tilting.
2. Head: a `LookAtModifier3D` (Godot 4.7) on the head bone (and a 40% share on the neck) targeting the camera, angle limits
   +-25 deg, so the face points into the lens whatever the idle frame does. Eyes: if the MetaHuman has eye bones, aim them too.
3. Hands: the portrait shows head + shoulders only; hide or lower the arms for the portrait (rest pose arms, or crop so no hand
   enters the panel). No hand pixels inside the panel.

## Gate (must read RED on 6c53c964 first - paste the red line)
`PORTRAIT_FACE` adds: `cam_eye_dy` (camera y minus eye y, must be within +-2 cm), `cam_pitch` (|pitch| <= 2 deg),
`face_to_cam` (angle between the head forward vector and the vector head->camera, <= 10 deg), `hand_px` (count of rendered hand
pixels inside the portrait panel from the windowed still, must be 0). Keep your crown/eyes/chin/shoulder bands. Run it on Bruno,
Niko Park, Phuket and Rafael.

## Do
- Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`.
- Test: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/profile_stage_test.gd` then
  `python Godot/tools/run_tests.py --jobs 1 --only profile,readout`.
- Stills: same command as round 9 (`profile2_stills.gd` through `Tools\godot_hidden.ps1`), overview + techniques + medical.
- Commit + push cursor/profile2e at every checkpoint. Watchdog before every Godot run; RED = wait.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
(For this UI portrait: step 2 = the profile2_stills.gd stills; step 3 = where the nose points, eyes level or not, any hand, crown.)

## Prior research
PROFILE2E_DIGEST.md rounds 1-9; TASK_PROFILE2E_FIX8.md (the pixel gate you built - keep it).

## Prefab check
Godot 4.7 `LookAtModifier3D` (built in) - no custom IK.

## The one trap
Do not tilt the camera to make the crown fit: that is what put the lens above the eyes. Frame with distance/FOV only.
