# ActionForge how-to (S247) - from the askNK video, read in full

Operator S247: "watch the whole video and learn how to make any animation you want" (https://www.youtube.com/watch?v=i4lCE-_Uem0,
"Finally, A Free 3D Animation Tool That Actually Works!", askNK, 24:03). Source read: the full 733-line transcript (youtube-transcript-api),
every section below carries its timestamp. Operator S247 ask that this serves: "you can import all our animations on actionforge and fix them ?"

Tool: https://actionforge.app/ (beta, CGstuff). Runs LOCALLY in the browser - nothing uploaded. Two modes: the editor (ActionForge) and
Motion Lab (procedural changes). Its clip library = Quaternius UAL, CC0 (00:57-02:01).

## Navigation (01:09)
LMB drag = orbit; wheel = zoom; Shift+LMB = pan; Space = play/pause. Top bar: speed (e.g. 0.25), loop, bones, wireframe, follow camera,
mirror, reverse, re-frame (01:26-01:46). Clips tab = library; "group by category" button (02:15).

## Bring in OUR character (03:31-05:30)
- CHARACTER > RIGGED CHARACTER imports a rigged model; it runs a check (seconds). Limit 100 MB. FBX has issues - import GLB/GLTF (03:49).
- Character settings (gear) = bone REMAP: auto-remap, leave a stray joint blank, mirror L->R, SAVE the mapping for the next character
  of the same rig (04:47-05:26). Ours: mh_boxer_01.glb (5.2 MB GLB, MetaHuman = UE5 Manny bone layout - auto-remap should hit).
- UNRIGGED MODEL: place chin/shoulder/elbow/wrist/fingers/hip/groin/knee/ankle markers, "detect fingers", cloth flags, envelopes, then
  "bind" -> Mixamo-style rig (05:32-08:18). Not needed for us (MetaHumans are rigged).
- "Hold pose" / T-pose preview (08:21).

## Bring in OUR motions (08:40-09:20)
The import-animation button (top right, "IMPORT ANIMATION") takes several files at once; they land at the bottom of the clip list as
"uncategorized". Pick one to preview it on the current character.

## Fix tools - the editor
1. COMPOSE (09:22-10:52): add the selected clip as the BASE strip, add another clip as the next strip and choose WHICH BODY PARTS it
   overrides (feet / chest / hands / arms / head); a layer slider sets each strip's influence. = take the legs of one take and the arms
   of another.
2. ADJUST (10:56-11:46), live while playing: arms up/down, arm width, posture (wider stance), chest movement amount; "whole clip" or a
   time range with fade in / fade out.
3. PROPS (11:48-12:12): katana, training stick, staff on either hand (no gloves/mitts).
4. IK (12:14-13:30): pause, select a limb, drag the IK handle; W = move, E = rotate; POLE VECTOR moves the elbow (or knee); gizmo in
   global or LOCAL space (use local).
5. POSE + TIMELINE (13:39-16:27): every pose change auto-keys on a POSE LAYER (STRIPS -> timeline; FIT to see keys). One pose layer per
   body part, each with its own influence; mute a layer to compare; mirror pose, copy pose, add key, children inherit key, snapping.
   Missing: keying a layer's influence over time (16:04).
6. BLEND / SEQUENCE (16:27-18:47): drop clips one after another on a track - the tool moves the root so clip 2 continues from clip 1;
   stack clips on layers with fades; stretch a loop strip to repeat it; IN PLACE button for game export; right-click a strip = speed,
   modifiers.
7. EXPORT (18:58): FBX (units: Blender / Unreal / Unity) or GLB. PROJECT: save / new / open (19:15).

## Fix tools - Motion Lab (19:35-23:16)
Procedural, per clip: POSTURE (spine forward / sideways), FOLLOW-THROUGH (chest, head), a curve GRAPH, DIRECTION, POLISH; GAIT
(stride, cadence, weight, sway, arm swing, bounce) for locomotion; EDIT TRAILS (drag the motion path of a body part in real time) and
pose edits; GENERATE = 8 directions from one locomotion loop; leaning, sway. Save / export.

## What it cannot do (S246 + this read)
One character per scene - no two-body contact (the pad pair's glove-on-mitt stays on Cascadeur, D13). No gloves/mitts props. No layer
influence keys.

## Our route (S247 plan)
1. Character: import mh_boxer_01.glb (rigged, GLB), auto-remap, save the mapping "MetaHuman".
2. Motions: import our MetaHuman clips as GLB (mh_jab, mh_cross, mh_lead_hook, mh_inside_uppercut, mh_guard_pose; the pad fighter
   loop for its body only).
3. Fix, per clip, against the real reference (Dola D69 jabs, Pexels 7187396 pads): guard hands to the face with IK + pole vector
   (elbows in), posture/chest via Adjust or Motion Lab, snap/return timing via strip speed, a pose layer for the rear hand at the chin.
4. Export FBX, Unreal units, in place, animation only (the AFMotion settings) -> assets/anim/actionforge/ours/; play one-to-one through
   AFMotion; side sheet vs the reference on the game camera; the operator's eye decides.
PILOT FIRST: mh_jab only. The batch follows only if the pilot passes.

## S274 - driving the editor from code (measured in the operator's Chrome, build 20261016.3d1cb7a8)
The editor keeps its whole state in the URL hash and reads it on LOAD (a hash-only change does nothing - set `location.hash`, then
`location.reload()`). Grammar seen and tested:
- `r=u.<id>` = the character (u. = one of YOURS: mh_boxer_01 is u.a45f359ae5de in his browser), `clip=user.<name>_<id>` = an imported
  clip (mh_jab = user.mh_jab_e6705152f8), `clip=<library id>` (idle_loop) = a library clip, `cam=` = the camera (17 numbers).
- `k=<t>:<bone>=<x>/<y>/<z>+<bone>=<x>/<y>/<z>|<t2>:...;n=<layer name>` = ONE POSE LAYER: keys separated by `|`, bones in a key
  by `+`, rotation in degrees per axis (UE5 bone names: upperarm_l, lowerarm_l, hand_l, thumb_01_l ...). Tested: k=0.2 upperarm_l
  0/0/45 raised the left arm and made layer "ProbeLayer" with one key; `0.1:...|0.4:...` made two keys with an eased curve between.
- Still to measure before the pilot: whether a key is an OFFSET on the clip or an absolute local rotation (put the same key on two
  different clips and compare), the Euler order, and how a second layer is written.
- The page's script cannot be fetched outside the page (0 bytes), and the extension hides query-string output - learn by the URL
  the tab reports after each UI action, never by working around either.
Use: compute pose keys in Godot (IK on the MetaHuman body: hand target -> upperarm/lowerarm/hand rotations), write them as a layer
over a Rokoko/ActionForge base clip, export through the editor (GLB/FBX, in place, animation only), play through AFMotion.
