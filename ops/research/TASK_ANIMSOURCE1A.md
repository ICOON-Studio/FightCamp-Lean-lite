# TASK ANIMSOURCE1A - author REAL boxing moves in Cascadeur on the MetaHuman skeleton (start: the inside uppercut) (S207)
Model: gpt-6.1-sol (Codex, animation). Worktree E:\FightCamp\wt\ANIMSOURCE1, branch codex/animsource1. Keep going until the
acceptance is met - no run limit.

## Why (operator S207, verbatim)
"why the animations are basically no animation but a scrable of hands" / "why the fuck you donot use the fucking tools i pay to
make them ?" / "i do not want to see mbfb model anywhere again". The operator pays for Cascadeur Pro (access runs to 2026-10-27).
Our moves are retargeted from another rig (Cascy / Mixamo), time-warped, then patched by procedural layers - the hands scramble.
The fix is SOURCE motion authored for OUR final skeleton: the MetaHuman boxers (Godot/assets/models/metahuman/mh_boxer_01..04.glb).

## Tools you have (read first)
- Tools/cascadeur/README.md - Cascadeur 2026.2 script server (127.0.0.1:8765, POST /run executes Python in the live app;
  `python Tools/cascadeur/ensure_server.py` starts it; csend.py; the traps listed there). Existing authoring scripts in
  Tools/cascadeur/ (apply_pose.py, apply_clip.py, author_*.py) show the API in use. Full API: the install's
  resources/scripts/python/samples/api_document.py.
- research/C231_DIGEST.md (the last inside uppercut authored in Cascadeur on the Cascy rig, then retargeted - what NOT to repeat).

## HARD RULE - nothing on the operator's screens
Cascadeur is a GUI app. It must run on a HIDDEN Win32 desktop like our Godot jobs (see Tools/godot_desktop.ps1, which creates a
desktop with CreateDesktop and launches the process into it). FIRST make `Tools/cascadeur/ensure_server.py --hidden` launch
Cascadeur on that hidden desktop (reuse godot_desktop.ps1's P/Invoke; one new small .ps1 is fine). Never start it visibly.

## Spec
1. Bring the MetaHuman body skeleton into Cascadeur (export mh_boxer_01 to FBX with Blender 5.2 headless if Cascadeur needs FBX;
   use Cascadeur's rig/quick-rigging for the custom skeleton). Record exactly how in your digest - every next move reuses it.
2. Author `boxing_inside_uppercut` as a REAL inside (rear-hand) uppercut at chest-to-chest range, keyed in Cascadeur, AutoPhysics on:
   guard -> knees dip 6-10 cm and hips/shoulders turn -> the elbow stays UNDER the fist and the fist rises from chest height to the
   opponent's chin height with the palm toward the boxer -> contact ~0.25-0.30 s -> back to guard by ~0.6-0.7 s. Feet planted.
3. Export it as a GLB on the MetaHuman skeleton (no retarget step in Godot) -> Godot/assets/anim/metahuman/mh_inside_uppercut.glb.
4. A frame sheet for Claude only (NEVER post it anywhere): 12 frames side view + 12 frames front view of the MetaHuman playing it,
   both men head to feet, saved to E:/FightCamp/tmp/animsource1/. Open it yourself and fix what looks wrong before reporting.
5. Then the same pipeline for jab, cross, lead hook (one GLB each), only after 2-4 pass.

## Acceptance (shape, not just distance)
- NEW Godot/tools/move_shape_probe.gd: plays a MetaHuman GLB clip and prints per move: forearm angle from vertical over the last
  40% before contact (uppercut: <= 25 deg every frame), fist rise start->contact (uppercut >= 0.20 m up, horizontal travel <= 0.15 m),
  elbow below wrist during the rise (uppercut: every frame), each foot moves <= 0.01 m, no frame-to-frame hand jump > 0.08 m at 30 fps.
- Probe green for the uppercut, and the frame sheet looked at by you.
- Parse every .gd; Godot `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe"` (never _console). Commit + push the branch.

## Owned files
- `Tools/cascadeur/` (new scripts + ensure_server.py --hidden), `Tools/cascadeur_hidden.ps1` (NEW, if needed)
- `Godot/assets/anim/metahuman/` (NEW clips)
- `Godot/tools/move_shape_probe.gd` (NEW)
- `research/ANIMSOURCE1A_DIGEST.md` (NEW)

## Prior research
C231_DIGEST.md, S30_THE_PAIRED_POSE.md, Tools/cascadeur/README.md, topics/striking.md, MH2/MH3 digests (MetaHuman rigs in Godot).
## What would a human do?
An animator keys the punch in Cascadeur on the final character's rig, turns on AutoPhysics, checks it from two angles, exports.
## Prefab check
Cascadeur is the paid tool for exactly this; Mixamo has no inside uppercut; the UE Game Animation Sample is UE-only licence.
## The one trap
Never judge a punch by distance-to-target alone - the S207 IK layer reached the chin with a horizontal elbow-first arm.
