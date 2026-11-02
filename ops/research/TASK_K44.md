# TASK K44 — KALLI — FOOT-LOCK IK IN GODOT 4.7: HOW SHIPPED GAMES KEEP A PLANTED FOOT STILL, AND WHAT GODOT GIVES US

Model: Grok Bot (Kalli), research. Owner: kalli. Stage: S4a (no sliding) - forecast research for the foot-plant pass.

**Research only.** No code, no downloads, no sign-ups. Links and dates. One pass. Reply in this chat.

## Why this exists

Our game is Godot **4.7.2** (GDScript, Forward+). Two retargeted mocap fighters (Unreal-style source skeleton onto a
Godot humanoid skeleton, bones named Hips, LeftUpperLeg, LeftLowerLeg, LeftFoot, LeftToes...) play clips on an
AnimationPlayer we advance manually. We now carry the source hips' travel, which cut planted-foot skate by 60-85% on
single clips, but 0.12-0.33 m/s remains because the fighter's legs are not the mocap actor's legs, and the room also
moves bodies a few centimetres between clips. The operator has ruled out BUYING an IK foot-plant system, so we build
one. We need the method and the Godot parts before we write it.

## What we already hold - do NOT re-research

Our J19: UFC's GDC 2015 talk used procedural foot planting so blending does not slide the feet. Our G48: a punch can be
warped about 10 cm (8-15 cm) with bounded two-bone IK. Our K43: Godot frame pacing.

## What to find - one row each, labelled DOCUMENTED (docs / engine source / PR) / SECONDARY / NOT FOUND

1. **Godot's IK nodes in 4.6-4.7:** which `SkeletonModifier3D` IK nodes exist (for example TwoBoneIK3D, FABRIK3D,
   CCDIK3D, SplineIK3D, LookAtModifier3D) - the version each arrived in, the class-reference link, the properties that
   set the target, the pole/knee direction and the influence (blend) amount, and whether they run AFTER an
   AnimationPlayer in the same frame. Is `SkeletonIK3D` deprecated?
2. **Contact detection:** how a foot is judged planted in the literature and in engines - height and velocity
   thresholds (with the numbers used, for example in Kovar, Schreiner & Gleicher 2002 "Footskate Cleanup for Motion
   Capture Editing", or later papers), and whether contacts are precomputed per clip (curves/markers) or detected at
   runtime.
3. **The locking method:** once planted, where the lock target comes from (the foot's world position at contact),
   how the lock is released (lift-off threshold), the blend-in / blend-out durations used, what happens when the
   locked foot would overstretch the leg (release, clamp, or pelvis adjustment), and the hips-height adjustment that
   keeps both feet reachable.
4. **Unreal 5's equivalents** for comparison only: IK Retargeter "IK goals" / foot plant, the Foot Placement node,
   Leg IK - what each does, in one line each.
5. **Pitfalls:** knee popping, foot sliding at lock release, ankle rotation (flat foot vs toe pivot - a boxer's rear
   foot pivots on the ball during a cross), and cost per frame.

## Your answer's first section: `## DECISIONS`

At most six lines:
- the Godot 4.7 node(s) to build the foot lock on, or "write the two-bone solve ourselves" and why;
- contact thresholds to start from (height, speed), with their source;
- lock blend-in and blend-out times to start from, with their source;
- precompute contacts per clip, or detect at runtime;
- how to handle a pivoting foot;
- the one pitfall to test first.

Claude collects as: `research/K44_FOOT_LOCK_IK.md`
