# ASK (John, deep research) - MetaHuman BODY corrective joints in UE 5.8: where they are evaluated, how to sample them headless (S262)

Give the longest complete answer you can; cite the Epic doc / forum / source file for every claim, mark guesses as guesses.

## Context
FightCamp (Godot 4.7.2 boxing game) uses MetaHuman bodies exported from UE 5.8 (project MHPilot.uproject, headless Python
via UnrealEditor-Cmd -run=pythonscript, our scripts mh_build_pilot.py / mh_probe.py). The body skeleton arrives in Godot with
the helper joints (e.g. lowerarm_bck_l, lowerarm_fwd_l, lowerarm_in_l, lowerarm_out_l, upperarm_bck_l, upperarm_fwd_l,
upperarm_bicep_l, upperarm_tricep_l, clavicle_out_l, clavicle_scap_l, the twist joints) but nothing drives them - in Unreal
something does (the MetaHuman body post-process AnimBP / RBF pose drivers / RigLogic). So in Godot elbows pinch and
shoulders collapse when the boxer bends his arm. We drive the twist joints already (our own formula) and four elbow helpers
with a hand-tuned guess (S261) - the operator says the bodies "do not look very nice or real".

## The plan we want to validate
SAMPLE, don't reverse-engineer: in UE 5.8 headless, pose the driver joints of a MetaHuman body (upperarm, lowerarm, hand,
clavicle, thigh, calf) on a grid (e.g. elbow flex 0/30/60/90/120/145 deg x forearm roll -60/0/+60; shoulder raise/forward
grid), let Unreal evaluate the correctives exactly as it does in game, and record every helper joint's local transform per
sample -> a JSON table. Godot then interpolates the table at runtime (RBF over the driver rotations).

## Questions
1. In UE 5.8, WHERE are MetaHuman BODY correctives evaluated? Post-process Anim Blueprint with RBF/Pose Driver nodes
   (asset names?), Control Rig (which rig, e.g. "MetaHuman_ControlRig" / "body_postprocess"?), RigLogic from the body DNA
   (does the body DNA carry RBF solvers since MetaHuman 5.x / "MetaHuman Creator in engine"?), or the "MetaHuman
   Character" asset pipeline? Name the exact assets/classes for a MetaHuman created/assembled in UE 5.6-5.8.
2. How do we EVALUATE them headless from Python at a given pose and READ the resulting helper joint transforms?
   Options we can think of: spawn a SkeletalMeshActor with the post-process AnimBP in an editor world and tick it;
   AnimSequence baking ("Bake Animation" / AnimSequence with post-process enabled, then read bone tracks); Control Rig
   python API (ControlRigBlueprint / RigHierarchy evaluate); RigLogic python bindings (dna / riglogic modules shipped with
   the MetaHuman plugin) evaluating the body DNA directly. Which works headless (no viewport) in 5.8, with code sketch.
3. Alternative: read the RBF solver DATA directly (driver target poses, radius/kernel, distance method swing/twist,
   output joint targets) from the PoseDriver nodes or the DNA, so Godot can run the same RBF. Where is it stored, and is
   it accessible from Python (property names)?
4. RBF details as UE implements them (FRBFSolver): distance methods (Euclidean, Quaternion, Swing angle, Twist angle),
   function types (Gaussian, Exponential, Linear, Cubic, Quintic), normalisation, "radius" meaning - so a Godot port
   matches.
5. Licence: may we ship a table of sampled helper-joint transforms derived from a MetaHuman body in a non-Unreal game?
   (We already ship the MetaHuman meshes under the MetaHuman licence terms that allow other engines since 2025 - confirm
   the derived corrective data falls under the same terms.)

## Output we need
A step list we can run (UE Python), the asset names, the RBF parameters, and the risks. Save nothing else; text answer.
