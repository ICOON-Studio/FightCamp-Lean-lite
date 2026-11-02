---
name: feedback-measure-the-posed-thing-not-the-rest-box
description: "a skinned mesh reports the AABB it was IMPORTED with, so every check that reads it agrees the body is fine while the body is somewhere else"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 28faea2b-d19e-495f-9c28-11e3d7a8cd1d
  modified: 2026-09-22T22:30:45.616Z
---

`MeshInstance3D.get_aabb()` returns the REST box the mesh was imported with. Pose
or graft the skeleton and the real geometry leaves that box while every property
still reads correct — `visible=1`, a plausible span, a sane centre.

**Why:** four runs of `render_paired_hold.gd` wrote 24 frames of empty floor and
printed `graft ok`, `meshes=1 visible=1` and `RENDER total=1 fails=0`. The bounds
reported a 1.894 m span near the origin and the non-vacuity gate passed at
centre.y = 0.000, while both men lay 0.85 m under an opaque mat. Two header
hypotheses were written from those readings and both were wrong.

**How to apply:** for anything posed, measure `skel.global_transform *
skel.get_bone_global_pose(i).origin` over the bones, never the mesh AABB — for
camera framing, for floor placement and for every gate. And give the render
itself a control it can differ from: photograph the scene with the bodies hidden
and fail any frame that matches it. That check would have caught this on run one.

Related: [[feedback-open-the-output-before-the-gate]],
[[feedback-a-gate-that-reads-its-subject-cannot-fail]],
[[project-godot-skeleton-pose-traps]].
