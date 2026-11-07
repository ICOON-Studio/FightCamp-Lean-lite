# TASK WALK1 - CURSOR (GPT-5.6 Sol High) - the shown stance is not the planned stance: find the layer that squashes it

Status: HELD (S399) until RETARGET1 and rokoko-back prove the clips clean against the source - no layer work on a broken base. Operator S399: "why do you even care for such
detail when you cant even make walking look normal". Discipline: boxing. Runs AFTER SOUTHPAW2 (same files).

## Contract
OWNS: scripts/fight3d/BoxerFootwork.gd, scripts/fight3d/BoxerFootworkRig.gd, scripts/fight3d/FootPlant.gd, scripts/fight3d/RingFeet.gd, scripts/fight3d/KneeTrack.gd, tools/stance_probe.gd, tests/stance_shown_test.gd
RED_TEST: tests/stance_shown_test.gd -> STANCE_SHOWN failures=0
REGRESSION: ring_feet_test, foot_plant_test, boxer_footwork_test, knee_track_test, fight_polish_test, corner_warm_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/footwork_film.gd -- out=E:/FightCamp/tmp/walk1 seg=side,standoff

## What is measured (S399, main) - READ THIS FIRST, the first numbers were wrong
- MEASUREMENT TRAP: Godot 4 SkeletonModifier3D results exist only during the skeleton update. Reading
  get_bone_global_pose() anywhere else returns the RAW CLIP pose (no footwork rig, no FootPlant, no KneeTrack). The
  "0.275 x 0.373 square stance" (and SOUTHPAW1's whole test) measured the raw guard clip, not what is drawn. Read bones
  inside `skel.skeleton_updated` (tools/stance_probe.gd does: "drawn" rows).
- DRAWN at rest / in the pocket (tools/stance_probe.gd, headless FightStage, orthodox and southpaw, mh_boxer_13 and _01, rig
  weight natural = 1.0): length 0.50-0.54 x width 0.34-0.37 = the plan; no knock-knee (valgus -0.003..-0.12 m, outside the
  line). So the rig's standing stance is RIGHT. The raw guard clip under it is square (0.289 x 0.433).
- The film still looks wrong (E:/FightCamp/tmp/walk_s399/side.mp4 footwork_film side: feet barely lift on the forward
  steps 0:04.2-0:05.4, the body glides; the fighter-look still and Argon's film: knees in on blue). Those come from moments the
  standing probe does not create: real STEPS (lift, skate, pivots), PUNCHES and HITS (does the rig fade and the square clip
  show?), the CLINCH, and the CORNER WALKS (af_walk on CornerCrew: no footwork rig at all).
- The CLIP too: ops/previews/lean_anim/advance.mp4 alone on the turntable has the feet on one line at 0:00.6-0:00.9 and the
  knees in at 0:01.1-0:01.2 (Claude 4/10) - if any step plays that clip with the rig faded, that is what shows.

## Do
1. Extend tools/stance_probe.gd (it exists: plan / rig / drawn rows, `phase=`, `stance=`, `off=<modifier>`, `natural`) and
   write tests/stance_shown_test.gd: run a PLAYED round headless (the round as fight3d_film plays it, fixed clock), and per
   frame, from the DRAWN pose (inside skeleton_updated), log the state (step / punch / hit / clinch / walk / rest) and: ball to
   ball length along her facing and width across it, rear and lead heel height over the ball, the stepping foot's peak
   lift per step, the rig weight. Print the worst frames per state. Bars (main must FAIL at least one, in a named state):
   - shown length within 10 % of the planned length x her scale, shown width within 10 % of the planned width x scale;
   - rear heel shown within HEEL_REAR (+-0.5 cm) over the bounce; never flat (< 0.8 cm) while bouncing;
   - a stepping foot's peak lift >= 60 % of LIFT_M (flat-footed: of FLAT_LIFT_M);
   - a planted ball moves < 1 cm while planted (no skate).
2. For each failing state, find the cause (the rig fading to the square clip, a clip's own feet, a layer) with `off=` and
   rig-weight rows, write the table in the PR body, and fix it inside OWNS (one writer per foot bone). If a test elsewhere
   reads bones outside skeleton_updated for a pass/fail, list it in the PR body (do not edit it).
3. Every REGRESSION green; if SOUTHPAW2 merged, run its tests/guard_valgus_test.gd too. Start every Godot run
   through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`. Do not loosen a bar, do not drop samples.

## Result lines (PR body)
RESULT: STANCE_SHOWN main <n> failures -> after failures=0
RESULT: shown length/width main <l>/<w> -> after <l>/<w> (plan <l>/<w> x scale)
RESULT: rear heel main <min-max> -> after <min-max>; step lift main <x> -> after <x>; skate main <x> -> after <x>
RESULT: squashed by <file:line> (the layer table)
RESULT: regression <pass/fail per test>

## What would a human do?
Stand side-on in a boxing stance: lead foot forward, rear foot back and out, rear heel up; step by lifting the foot, not by
sliding the body.
