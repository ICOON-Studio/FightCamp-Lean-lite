---
name: project_contact_solver
description: "FightPoseSolver.gd exists - a two-body contact solver with grips, ported from the operator's perchance BJJ build"
metadata: 
  node_type: memory
  type: project
  originSessionId: 50b85198-25e9-4e6d-968f-a6a49b10cbf7
  modified: 2026-09-21T20:28:50.890Z
---

**`Godot/scripts/FightPoseSolver.gd`, shipped 2026-09-21 (S42, `0832a34f`, grips
in `c7ff7afa`). Pure module, no autoloads, no scene preloads. WIRED TO NOTHING
YET** — `PairedStagePlayer` still uses plain corrections. Integration is S43.

Ported from the solver in the operator's own `perchance.org/gro5f7k2s5` BJJ
build, read out of its saved source. **The algorithm ported; its rig did not.**

**THE ONE LINE EVERYTHING RESTS ON:** a target is a **SURFACE GAP**,
`gap = d - (r_a + r_b) - off`, never a centre distance. Two pasted HTML drafts
authored `torso<->torso = 0.05` centre-to-centre against capsules of radius
0.14 — a demand for 0.23 m of interpenetration, so reaching the target meant
burying one man in the other.

**Cost:** `W.pen·Σg²` + `W.pen_max·max²` + `W.mat·Σlow²` (per capsule, BOTH
bodies — never a per-body root offset, which moves the two men separately and
breaks the pair) + `W.touch·Σ(w·g²)` + `W.touch_max·max²` + `W.grip·Σ(w·g²)` +
`W.grip_max·max²` + `W.hold·low²` + `W.reg·Σp²`.

**Phases:** `W_PLACE` root-only (penetration OFF — placement and overlap fight
each other) -> `W_FIT` all DOFs -> `W_PLACE` root re-lock. Coordinate descent,
probes `±{1, 0.4, 0.15}×step`, shrink ×0.45 on a failed sweep, floor 0.004.

**GRIPS are the thing a contact cannot express.** `{body, cap, on_cap, blend,
off, w}` puts a hand's distal end at a PLACE along a capsule on the other body.
Measured: solving the contact alone left the hand 0.4036 m from where the grip
wanted it, fully "in contact" the whole time.

**Thresholds:** `pen <= 0.006`, `touch <= 0.012`, `mat <= 0.012`,
`grip <= 0.012` m.

**`Tools/s42_mutants.py` must stay `red=8 missed=0`.** If a change makes a
mutant go green the test stopped covering it.

Inputs for S43: `research/C153_CAPSULE_SET.md` (13 stature-scaled
capsules, Astra) and `J32_WHAT_A_REAL_CLINCH_IS.md`. See
[[project_fighter_rigs_are_not_in_metres]] — every bound above is metric and
the rigs are not.
