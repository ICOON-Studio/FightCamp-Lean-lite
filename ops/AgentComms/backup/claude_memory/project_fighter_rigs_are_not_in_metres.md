---
name: project_fighter_rigs_are_not_in_metres
description: "Fighter meshes are Tripo exports at arbitrary scale (f05 is 1.850 tall, f06 is 1.000) and only FighterPhysique.height_scale() makes them metres - any measurement that skips it is in mesh units"
metadata: 
  node_type: memory
  type: project
  originSessionId: 79d91b9d-dd8f-4640-9607-fe7da8006134
  modified: 2026-09-21T12:25:22.393Z
---

**The rigged fighter `.glb` files are NOT in metres and nothing in the file says so.**
They are Tripo exports, each at whatever scale Tripo happened to produce:
`f05_m_mma_light_rigged` has a mesh height of **1.850**, and `f06_m_mma_lhw_rigged`
has a mesh height of **1.000**. Neither the fighter node nor the `Skeleton3D` carries
a scale — every node reads `(1, 1, 1)` — so nothing in the scene warns you.

The room never renders them raw. `FighterPhysique.height_scale(mesh_height_m,
target_height_m)` returns `target / mesh` and that uniform scale goes on the fighter
node, so the mesh stands at the athlete's real height from
`FighterPhysique.reference_height_m(limit_kg, sex)`. For the two above that is
**0.963 for f05 and 1.890 for f06** — nearly a factor of two apart.

**Why:** any tool that composes bone transforms from `get_bone_rest()` /
`get_bone_global_pose()` and then compares them against world metres is mixing units,
and f06 comes out at roughly HALF its rendered size while f05 looks about right. It
does not look like a unit bug; it looks like one fighter's limbs drifting.

**How to apply:** multiply rig-local offsets by the mount scale before comparing
against anything in metres, and divide metre targets by it before handing them to a
solver that works in skeleton units. Sanity-check any new fighter instrument against
an ABSOLUTE known quantity — a rig's head belongs about 1.7 m off the floor — because
a relative check between two bodies hides a common-mode scale error. See
[[feedback_control_arm_must_not_share_the_bug]].

**This has now bitten three times**: S4 (4) compared world-metre positions against a
floor still in mesh units and printed 0.364 m for 0.343 m;
`FightBodyCapsules.gd:148` carries the warning in capitals because of it; and on
2026-09-21 `tools/probe_cmu_grip.gd` reported a +139.7% retarget drift that was
almost entirely f06 being half-scale — the real figure is +8.8%.
