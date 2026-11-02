---
name: reference_unreal_source_on_pc
description: "Unreal Engine 5.8's plugin SOURCE is installed on the PC - read shipped animation defaults (Foot Placement: plant 60 cm/s / 10 cm, unplant 35 cm, spring 250) straight from the headers as DOCUMENTED numbers"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 8884e447-794c-498c-b905-0270a1b92aa6
  modified: 2026-09-14T01:08:59.358Z
---

Unreal Engine 5.8 is installed at `C:/Program Files/Epic Games/UE_5.8` WITH plugin source (`.h` and `.cpp`), not only
binaries. Any animation-system default Epic ships can be read in minutes and labelled DOCUMENTED - no research task,
no invented bound.

**Found 2026-09-14 for the S4a foot lock:**
`Engine/Plugins/Animation/AnimationWarping/Source/Runtime/Public/BoneControllers/AnimNode_FootPlacement.h`
(`FFootPlacementPlantSettings`, `FFootPlacementInterpolationSettings`, `FFootPlacementPelvisSettings`) and
`.../Private/BoneControllers/AnimNode_FootPlacement.cpp` (`DeterminePlantType`: unplant when the plant is more than
UnplantRadius from FK horizontally; replant within ReplantRadiusRatio of it). Defaults (cm): SpeedThreshold 60,
DistanceToGround 10, UnplantRadius 35, ReplantRadiusRatio 0.35, MaxExtensionRatio 0.5, MinExtensionRatio 0.2,
UnplantLinearStiffness 250 / damping 1.0, LockType PivotAroundBall, pelvis MaxOffset 50.

**Why it mattered:** K44's thresholds were SECONDARY (s&box, Orange Duck) and 4x stricter; U92 then measured UE's
0.60 m/s against the source mocap's own plants and it won (IoU 0.70 v 0.46). Reading the engine settled the constants
AND their provenance at once.

**How to apply:** before assigning research for an animation constant (IK limits, blend times, root motion, motion
matching, retarget chains), `find "/c/Program Files/Epic Games/UE_5.8/Engine/Plugins/Animation" -iname "*<node>*"` and
read the UPROPERTY defaults and their comments. Quote parameter names and numbers only; never copy engine code into the
project. Related: [[reference_pc_animation_tools]], [[feedback_ground_tests_in_real_studies]].

**Read 2026-09-14 (Codex C118/C119/C121, each spot-checked in the source):** Foot Placement never unplants for reach -
it clamps (max extension = desired + (limb - desired) x 0.5) and drops the pelvis (MaxOffset 50 cm, horizontal 10,
spring 350/1). Dead Blending (Engine/Private/Animation/AnimNode_DeadBlending.cpp) extrapolates the outgoing pose with
velocity clamped at 360 deg/s and 500 cm/s, half-life clamp(1.0 x diff/velocity, 0.05, 1.0) s, blended out over 0.25 s
HermiteCubic - ported as Godot/scripts/FightDeadBlend.gd. Motion Warping's SkewWarp, for an IN-PLACE clip, eases the
root from start to the warp target over the window (RootMotionModifier_SkewWarp.cpp:189-238). A Codex reading task whose
check parses the headers' UPROPERTY defaults and re-finds every quoted line lands first pass.
