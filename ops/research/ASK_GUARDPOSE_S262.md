# ASK (S261 -> S262): how do we build a boxer GUARD POSE with many variations on our MetaHuman bodies?

Operator: "doesn't look like an arm", "it's just a guard pose and we need a shit ton of variations of that".

## Our setup
- Godot 4.7.2, GDScript. Boxers are MetaHuman bodies (UE5 skeleton, renamed: LeftUpperArm/LeftLowerArm/LeftHand, Head, Neck, Hips,
  UpperChest; plus UE helper bones lowerarm_correctiveRoot/bck/fwd/in/out, upperarm_twist/tricep/bicep).
- Motion = ActionForge clips (CC0 Quaternius UAL on the UE5 skeleton) + some QuickMagic mocap, played by an AnimationPlayer in MANUAL
  mode; a per-frame "posture pass" (FightStagePlayer.gd) writes bone poses after the clip (fatigue drop, glove spring, guard lift).
- Today's guard comes from the idle clip's arms: the lead elbow flares 34-39 deg out (target 8-12), the rear wrist floats 0.31 m from
  the head bone and drops to 0.19 m (glove in the cheek) when the other hand jabs; the elbow skin collapses (fixed partly by driving the
  corrective helper bones). We patched it with layers; the operator says the arm still does not read as an arm.
- Plan on the table (Godot/scripts/rules/GuardPose.gd): define a guard as numbers in the boxer's head frame (rear glove, lead glove,
  elbow pole forward/in) for 5 styles (traditional, high guard, peek-a-boo, long guard, Philly shell) + per-boxer seeded jitter +
  guard-attribute height; a two-bone IK per arm puts each wrist on its target with the elbow aimed down/in at the ribs; the punching
  arm fades out of the IK during a strike, the other hand stays in guard.

## Questions (answer as completely as you can, numbered)
1. Is two-bone IK onto head-relative targets the right way to get a guard that reads as a real arm, or should the guard be AUTHORED
   poses (key poses per style, blended) - or both? What do shipped boxing games (Undisputed, Fight Night Champion) do?
2. The exact numbers per style for an orthodox adult male: each glove's position from the head (forward / sideways / down, cm), elbow
   position (from the ribs, cm), upper-arm angle from vertical (front and side), forearm angle, wrist bend, shoulder raise, chin tuck,
   torso lean and crouch.
3. Which bones besides the arm chain must move for the pose to read (clavicle raise/forward, spine/chest curl, neck/head tuck, wrist
   orientation so the glove faces forward)? Give the rotations.
4. How to make "a ton of variations" that all stay legal and readable: which parameters to vary, their ranges, how to tie them to the
   boxer's attributes/style, and how to keep two boxers in one ring visibly different.
5. How to blend guard -> punch -> guard without a pop (IK weight curves, timing), and how the non-punching hand should behave during
   each punch (jab, cross, hook, uppercut).
6. The traps in Godot 4 specifically (bone roll / rest-pose axes on a MetaHuman, IK pole flipping, SkeletonModifier3D vs writing
   poses after the AnimationPlayer, skin collapse at deep elbow bend).
7. The acceptance gate: which measurements on the game camera prove the guard is right (numbers + tolerances).
