---
name: project_godot_skeleton_pose_traps
description: "Headless Godot returns the REST pose from get_bone_global_pose(); and an FBX clip file's node hierarchy is NOT the rig's rest pose"
metadata: 
  node_type: memory
  type: project
  originSessionId: 67e4b1a8-d436-488c-82ee-666290bfaa0d
  modified: 2026-09-14T21:00:28.188Z
---

Two measurement traps found in R108 (2026-09-11), each of which silently
produced a plausible-looking wrong number rather than an error.

**1. `Skeleton3D.get_bone_global_pose()` returns the REST pose in a headless
`--script` run.** Nothing moves it: not adding the skeleton to the scene tree,
not `force_update_all_bone_transforms()`, not awaiting a `process_frame`. It
comes back byte-identical to `get_bone_global_rest()` while `get_bone_pose()` on
the *same bone* correctly shows the rotation just written. Verified in
`Godot/tools/probe_r108b.gd`.
**It fooled a whole study (found 2026-09-14, U108 v Q86):** Q86's headless stance measurement read
FM1 idle_A / idle_Tiramis and Motifect guards as ZERO motion through the Skeleton3D path, and the
STANCE ruling was built on "no bounce"; Blender (one fresh scene per FBX) shows the FM1 idles
bouncing ~147/min, 4.9 cm. RamsterZ H2H clips import as a node tree and read right. A zero-motion
reading from an armature FBX in a headless run is this trap until a second importer agrees.

**How to apply:** in any headless harness, compose the global pose yourself from
`get_bone_pose()` down the `get_bone_parent()` chain. Never read
`get_bone_global_pose()` as a measurement. Two full R108 runs reported two
retarget strategies as byte-identical across nine joints — both columns were
just f01's rest angles read back.

**2. An FBX clip file's node hierarchy is NOT the rig's rest pose.** Each clip is
saved at its own pose: `H2H_HitReaction01.FBX` sits at 127.5° shoulder
abduction, mid-reaction, while the same 68-node rig in `T_pose.fbx` is at 89.8°.
Reading "the source rig's rest" off a clip returns a lie that looks convincingly
like an A-pose. Also: `T_pose.fbx`'s only animation track is on an IK helper
(`ik_hand_l`) — the T-pose is the FILE'S HIERARCHY, there is nothing to play.

**Why:** both failures are [[feedback_assert_the_quantity_the_user_sees]] in a
new costume — the quantity reported was not the quantity acted on.

**How to apply:** read the rest from the vendor's `T_pose.fbx` hierarchy only,
and state which file a "rest pose" number came from. See
[[project_animation_pipeline_2026-09-10]] and
[[feedback_godot_verification_gate]].

**Third trap (2026-09-13, U88): Godot's named direction constants are not data axes.** `Vector3.FORWARD` is
(0, 0, -1). U88 built the hips carry's z axis from it and every forward/back sway was carried backwards - R3 got
WORSE (0.186 -> 0.228) while the unit test, checking the track against that same axis, passed. Build axes from
explicit components and pin every sign to a physical outcome (a planted toe's speed over all four sign choices
found it in one run). Related: [[feedback_a_gate_that_reads_its_subject_cannot_fail]].

**Fourth trap (2026-09-14, S4a foot lock): a SkeletonModifier3D does not run in a test stepped inside `_initialize`.**
ClassDB confirms `TwoBoneIK3D` (4.6+) and a MANUAL `Skeleton3D.modifier_callback_mode_process` with `advance()` in
4.7.2, yet `tools/probe_foot_lock.gd` measured ZERO effect: nodes report not-in-tree there (`global_position` errors
"!is_inside_tree()"), so the modifier never processes. Every realism gate steps the room inside `_initialize` and reads
`get_bone_pose`, so IK built on modifier nodes would be invisible to all of them. Write IK as GDScript that sets bone
poses after the mixer (as the inertialized joins do), and prove an AnimationTree advances in that setup before relying on one.
