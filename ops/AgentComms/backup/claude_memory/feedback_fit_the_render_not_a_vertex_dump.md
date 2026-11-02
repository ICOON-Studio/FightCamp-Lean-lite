---
name: fit-the-render-not-a-vertex-dump
description: S147 glove fit - numbers from a skinned-vertex dump disagreed with the live render; tune against opened stills, and never split one continuous mesh into separately scaled parts
metadata:
  type: feedback
---

Fitting a glove to the posed hand: a skinned-vertex dump read via `get_bone_global_pose()` outside the skeleton update misses SkeletonModifier3D effects (FighterFist fold) and its x side disagreed with the render, so a "numerically perfect" fit (INDEX_SHIFT +0.012) made the render worse (the opposite sign fixed it).

**Why:** the S147 glove cost ~15 render cycles because the first two causes were guessed (thumb, then hand through a hole); the real causes were (1) separately scaled Fist/Cuff parts tearing a seam and (2) decimating before welding UV-seam vertices.
**How to apply:** one continuous surface stays ONE mesh (colour bands via vertex colour + shader); weld before decimate; to tell geometry from draw order, scale the object 1.4x and look; sweep offsets in-engine with a user-arg (`gs=sx,sy,sz,dx,dy,dz`) instead of rebuilding the asset; open every still. See [[feedback_open_the_output_before_the_gate]], [[feedback_assert_the_quantity_the_user_sees]].
