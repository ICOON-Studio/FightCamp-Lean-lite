---
name: project-session-s57-2026-09-23
description: "S55-S57 - the paired render was fixed (bodies were under the mat), the trunk split failed informatively, and the ground game was measured and found to have no decision"
metadata: 
  node_type: memory
  type: project
  originSessionId: 28faea2b-d19e-495f-9c28-11e3d7a8cd1d
  modified: 2026-09-22T22:30:33.050Z
---

Session S55-S57, 2026-09-23. Suite ended **355/9, nothing new**.

**The paired render is fixed and three holds have been SEEN.** Four earlier runs
wrote 24 frames of empty floor while printing `fails=0`. Neither header
hypothesis was the cause: `FightWorldStage._load_glb` is byte-identical to the
render tool's loader. The posed pair sat **0.85 m under an opaque mat**, because
the grafted clip's root track writes away `mount`'s feet-on-deck offset on every
`seek`. Every diagnostic agreed the bodies were fine because they all read the
REST AABB, which the graft does not move. See
[[feedback-measure-the-posed-thing-not-the-rest-box]].

**S55, the trunk as two capsules:** the J43 inlet radius (0.2167 x thorax r) is
the first arm in the project's history to unbury the neck, 0.0% -> 11.7%, and it
holes the rib cage (UpperChest coverage 47.9% -> 4.8%). Informative failure, does
not ship. [[feedback-informative-failure-still-does-not-ship]]

**S56, the ground game, measured on the unchanged tree:** 74.9% of side-control
entries reach the paying 60-tick gate and the mean hold is **299.6 ticks (15 s)
against a 3 s gate**. `back` is 160 ticks out of 140,158 (0.1%) because from
mount the engine opens submissions before the advance branch. `guard` is 27.3% of
ground time paying nobody.

**Four agents, blind, unanimously picked the position graph** over a unified
action economy and over the archetype layer. The operator approved graph + hold
fix together, then asked for mount first once the measurement showed mount is
37.9% of ground time with no clip.

Handover left `now` = S58: wire `GroundGraph.gd` (built, wired to nothing) behind
a four-arm flag and measure against S56's control numbers.
