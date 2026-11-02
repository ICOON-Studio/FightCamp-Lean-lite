# SHOT LIST - GROUND (generated S114 from `GroundGraph.EDGES`; regenerate when the graph changes)

**Why:** UFC 2's team shot every ground transition as FIVE parts - start, ready, success, deny, cancel - from an 87-page pose
library, so any clip can chain to the next (`J49_MECHANICS_MEET_PRESENTATION.md` 1.2). This is our equivalent: one row per
edge of the engine's own ground graph (`S58_THE_GROUND_GRAPH_WIRED.md`), so every generated or authored clip has a place in
the chain and joins on a shared pose. It is the shooting script for C222 (suit-video grappling) and any Cascadeur authoring.

**Every take (studio calibration, S114):** before the move, both performers stand in a T-pose, then do a slow range of motion
(arms up / out / forward, knees up, hips turn), on a mat printed with a grid of known size (1 m squares), in the colour-graded
cell suits, from the same locked cameras as the move. That take gives the solver scale, bone lengths and the cameras.

**Parts:** START = the seat's neutral hold loop (shared by every edge from that seat). READY = the grip/setup that commits to the
edge. SUCCESS = the transition ending in the target seat's neutral pose. DENY = the defender stops it, ending in the fail seat.
CANCEL = the attacker aborts from READY back to START. Holds are loops only.

| Edge | From -> to (fail) | Actor | Kind | Techniques | Parts to shoot |
|---|---|---|---|---|---|
| `mount_hold` | mount -> mount (mount) | top | hold | bjj_mount | loop (START) |
| `mount_to_back` | mount -> back (mount) | top | advance | bjj_back_control, bjj_mount | ready, success, deny, cancel |
| `mount_to_side` | mount -> side (mount) | top | scramble | bjj_side_control | ready, success, deny, cancel |
| `mount_escape` | mount -> guard (mount) | bottom | scramble | bjj_guard | ready, success, deny, cancel |
| `isolated_arm` | mount -> mount (mount) | top | trap | bjj_kimura, bjj_americana, bjj_armbar | loop (START) |
| `clasp_and_hide` | mount -> mount (mount) | bottom | trap_defense | bjj_guard | loop (START) |
| `turn_into` | mount -> back (mount) | bottom | trap_defense | bjj_guard, bjj_mount | ready, success, deny, cancel |
| `explode_trapped_side` | mount -> guard (mount) | bottom | trap_defense | bjj_guard | ready, success, deny, cancel |
| `side_hold` | side -> side (side) | top | hold | bjj_side_control | loop (START) |
| `side_to_mount` | side -> mount (side) | top | advance | bjj_mount, bjj_side_control | ready, success, deny, cancel |
| `side_to_half` | side -> half (side) | top | scramble | bjj_half_guard | ready, success, deny, cancel |
| `side_escape` | side -> guard (side) | bottom | scramble | bjj_guard | ready, success, deny, cancel |
| `half_to_side` | half -> side (half) | top | advance | bjj_side_control | ready, success, deny, cancel |
| `guard_to_side` | guard -> side (guard) | top | advance | bjj_side_control, bjj_guard | ready, success, deny, cancel |
| `back_to_mount` | back -> mount (back) | top | scramble | bjj_mount | ready, success, deny, cancel |

**Neutral seat loops (START poses, one per seat, shared):** back, guard, half, mount, side.

15 edges; transitions needing four parts: 11.
