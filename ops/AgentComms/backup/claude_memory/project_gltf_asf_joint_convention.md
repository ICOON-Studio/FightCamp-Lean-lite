---
name: project-gltf-asf-joint-convention
description: ASF names a bone's DISTAL end, glTF its PROXIMAL end - glb[J] == asf[parent(J)]
metadata:
  type: project
---

CMU's ASF names a *bone*, and `Tools/cmu_asf_amc.joint_world_positions` returns
that bone's **distal** end under its name - so ASF `lwrist` is the wrist. A
glTF/BVH node sits at its bone's **proximal** end, so glTF node `lwrist` is the
**elbow** and the wrist is one node further out at `lhand`.

Verified S39 over every joint and three frames of two fixtures:
`max |glb[J] - asf[parent(J)]| = 0.000002 m`, against 0.429 m for the naive
same-name match.

So to measure the ASF joint `lwrist`/`lradius` in a converted GLB you read the
nodes `lhand`/`lwrist`. Our own rig already uses the glTF convention
(`LeftHand` starts at the wrist, `LeftLowerArm` at the elbow), which is why
`CMU_TO_OURS` is correct as written - a retarget map drives ROTATIONS and needs
no shift. Only POSITION measurements are affected.

`probe_cmu_grip.gd::_check_joint_convention()` asserts this from the loaded
clip's own hierarchy rather than listing trusted fixtures. Do not "fix" the
constants back. Related: [[feedback-validate-on-a-fixture-that-can-fail]].
