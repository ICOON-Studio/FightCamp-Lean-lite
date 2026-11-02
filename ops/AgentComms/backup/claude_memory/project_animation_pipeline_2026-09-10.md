---
name: project_animation_pipeline_2026-09-10
description: "R94's measured animation numbers — 0.2 credits a clip for all twelve fighters, no BoneMap, and the grapple gap that blocks a 3D ground fight"
metadata: 
  node_type: memory
  type: project
  originSessionId: b4879ea1-75bc-4eb5-baa2-4cda71accd1f
  modified: 2026-09-10T11:30:27.417Z
---

Measured 2026-09-10 (R94), with G42/G43 settling the architecture on top.

**The numbers.** Ludo preset library 641 clips, Combat 97. **0.2 credits per
clip, ONCE, for all twelve fighters** — the retarget output is a mesh-free
~58 KiB animation-only glTF on the 23-node hierarchy every fighter carries, and
its 22 bone names *are* `SkeletonProfileHumanoid`, so **no BoneMap**. Caveat: the
account badge shows whole credits and did not visibly move, so 0.2 is the stated
price, not a confirmed debit. The three "variations" a generation returns are
byte-identical — one clip, not three.

**The only integration cost** is a track-path rename (clip has no skin → tracks
address Node3Ds; fighter has a skin → bones live in a `Skeleton3D`). It lives in
`Godot/scripts/BoneTrackGraft.gd` and is idempotent. Verify with
`Godot/tools/probe_anim.gd` and `Godot/tests/fight_world_anim_test.gd`.

**The gap that blocks the 3D ground fight:** 97 combat clips, exactly ONE
grappling ("Grab & Throw"). C75 checked Mixamo, CMU, the stores and
text-to-motion — **no source clears it**; a full animated ground fight is
custom two-performer capture. The ground game gets *presented*, not animated,
which is also where G38 landed from the read side.

**How to apply:** buy short **in-place** single punches and additive hit-reacts,
not combo strings — the 2.47 s combo is a labelled *replay*, never the live unit
(G42). Camera rule (G43): wide, corner, labelled replay and the HUD are
summaries; **tight contact is a claim, and only claims the engine already made
may be shown**. Related: [[project_fight_stage_state_2026-09-09]].
