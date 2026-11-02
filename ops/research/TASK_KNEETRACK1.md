# TASK KNEETRACK1 - ANTIGRAVITY - the knees point over the toes (every clip, the board's previews and the fight)

Status: OPEN (S370, Claude). Seat: Antigravity (agy) on gemini-4-argon-high, via ops/Tools/seat_dispatch.py.
Discipline: boxing (the demo).

## Why
Operator S370, watching the clips on the board's Animations page: "the knee joints do not feel right in the clips i watch
on the board", then "its a lot of clips why you do not assign arena or gemini4 to fix them".
Claude measured it (tools/knee_probe.gd, on main, headless): 57 of the standing clips fail. The fault is the knee's
DIRECTION, not its bend: the knee points somewhere other than the toes - it caves in, bows out, and in some frames bends
backwards. Worst standing cases (knee-to-toes angle, leg, time):
- footwork: advance 97 R @0.60 (backwards), retreat 95 R @0.40 (backwards), strafe_left / strafe_right -87 R
- punches: pro_right_hook_miss -176 R (13 backward frames), pro_right_uppercut_special -159 R, pro_right_uppercut_ft -130 R,
  pro_left_uppercut_ft 79 L, pro_right_cross 62 R @0.23, pro_left_jab_a 60 L
- defence: pro_left_dodge 47 R, pro_back_dodge 48 L; getting hit: pro_hit_by_hook_v7_short 50 R; entry_ring -171 R
The shin's turn against the thigh (twist) is fine everywhere - only the knee's direction is wrong.
FootPlant.gd's leg IK (the live fight) keeps "the plane the knee bends in now", so the fight inherits the same bad knee.

## What the probe measures (read tools/knee_probe.gd first - do not edit it)
The board's boxer body (mh_boxer_10) with every clip FightClips loads, at 30 fps, both legs: while the knee is bent more
than 20 deg, the angle between where the knee points (its offset from the hip-ankle line, flat) and where the foot points
(ankle -> toes, flat). Bars: |angle| <= 35 deg in >= 95 % of a clip's bent frames, no frame past 90 deg (backwards).
Clips with the boxer down (knockout / countdown / fall) print but never gate. `-- layer=1` calls your layer after the
clip on every frame: `KneeTrack.align(skel, 1.0)`.

## The job
1. NEW scripts/fight3d/KneeTrack.gd (extends SkeletonModifier3D, under 150 lines): the knee layer.
   `static func align(skel: Skeleton3D, weight: float) -> void` - for each leg (LeftUpperLeg/LeftLowerLeg/LeftFoot/
   LeftToes, the same on the Right; bone names as FootPlant.LEGS), when the knee is bent: turn the THIGH about the
   hip-ankle line (the "swivel" of a two-bone chain - hip and ankle stay exactly where the clip put them) so the knee
   points over the toes; correct only the part past ~20 deg (a little knee-in/out is human), and ease the correction to
   zero as the bend goes under ~15 deg (a straight leg has no direction). Keep the FOOT's global rotation as the clip
   gave it (counter-rotate the foot's local pose), so the foot does not swing. `weight` scales the correction.
   The modifier's `_process_modification()` calls `align(get_skeleton(), influence)`.
2. scripts/fight3d/BoxerBuild.gd: add KneeTrack to the boxer's modifier stack BEFORE FootPlant (FootPlant's IK keeps the
   knee's bend plane, so it must see the corrected knee); falls/knockouts/wins free the legs the way FootPlant.FREE does.
3. tools/clip_orbit.gd (the board's preview renderer): call `KneeTrack.align(skel, 1.0)` on every frame after the clip,
   so the board's previews show the knees as the fight plays them; say so in its header comment.
4. Keep every file under 500 lines.
5. TRAP (Ziva S362, end of docs/ziva/ZIVAFOOT1_result.md): on this body a SkeletonModifier3D in the boxer's stack may
   compute a pose that never reaches the SHOWN pose. Prove the knee layer shows in the fight: say in your result file how
   you checked it (e.g. a reader modifier after it, or the Argon AFTER film of tools/fight3d_play.gd). If the stack is
   inert, say so in the result file with the numbers - Claude then wires `KneeTrack.align` into the fight's per-frame
   compose (FightStage.gd is not yours).

## Acceptance (Claude measures on your branch; numbers from the run, never from a description)
- tools/knee_probe.gd -- layer=1: KNEE_SUMMARY ... -> PASS (layer=off on main reads fail=57).
- beat_clips_test, move_clips_test, fight_flow_test, golden_path_test green; tools/move_player_probe.gd (the Playbook) green.
- Argon judges the before/after films (the knees in the orbit); the operator judges after on the board.

## Deliver
Edit only the OWNS files with your file tools; no shell. Do not commit: the dispatcher commits, tests, films and opens
the PR. Write docs/agy/KNEETRACK1_result.md: what you changed, per numbered point.

## Contract
OWNS: scripts/fight3d/KneeTrack.gd, scripts/fight3d/BoxerBuild.gd, tools/clip_orbit.gd, docs/agy/KNEETRACK1_result.md
RED_TEST: tools/knee_probe.gd -- layer=1 -> KNEE_SUMMARY
REGRESSION: beat_clips_test, move_clips_test, fight_flow_test, golden_path_test
VISUAL: yes
FILM: --resolution 960x540 --script res://tools/clip_orbit.gd -- out=user://knee_film ids=advance,retreat,strafe_left,pro_right_cross,pro_right_uppercut_ft,pro_left_uppercut_ft

## Prior research
ops/research/S366_DIGEST.md (the /animations orbit previews), scripts/fight3d/FootPlant.gd `_solve` (the analytic
two-bone IK this layer sits in front of), memory: agents animate, Claude builds mechanics (S338).

## What would a human do?
An animator fixing retargeted mocap sets a knee pole target in front of the toes and lets the leg IK swivel the knee onto
it - the hip and the foot stay, only the knee's direction changes.

## Prefab check
Godot 4.7 has TwoBoneIK3D / SkeletonModifier3D; a pole-vector swivel on the existing chain is the standard fix. No
asset re-export: the 198 clips stay as they are, the layer corrects them at play time (cheap: two legs a frame).
