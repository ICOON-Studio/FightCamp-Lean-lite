---
name: feedback_a_port_brings_its_blind_spots
description: "We ported Perchance's solver and applied it to an all-pairs comparison the source never performed - measure what the SOURCE never had to answer before blaming your own data"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 94da2c41-2c25-4d0f-9f7b-327dda4c66ad
  modified: 2026-09-22T08:54:57.245Z
---

S47B, 2026-09-22. `FightPoseSolver.gd` is a port of the solver in the operator's
`perchance.org/gro5f7k2s5` BJJ build — the cost function, the weights, the phase
schedule. S47 found our `neck` capsule 0.0% reachable and wrote a whole stage
(S48) around fixing the torso: derive the radius from chest depth, and split the
trunk as the fallback.

**One cheap control closed both roads.** The build's full source was already on
disk, so I ran S47's own reachability test on *its* rig:

- **Its neck is 0.0% exposed too**, buried 0.0750 m inside its own chest —
- on a rig that **already splits the trunk three ways** (pelvis 0.120 / spine
  0.126 / chest 0.130) and already uses slim authored radii.

Splitting doesn't fix it. Slimming doesn't fix it. A neck is buried in a chest on
every capsule humanoid, and that is anatomically right — you reach a neck from
above and from the side.

**It ships anyway because it never scores a hand against its own body.**
`LIMBS` is eight limb points tested against the *other* body; there is no
all-pairs self-collision term anywhere in it. We inherited the cost function and
applied it to a fifteen-capsule all-pairs comparison the source never performed.

Our all-pairs scoring is *right* and stays ([[feedback_measure_one_body_first]]
is where it came from) — but it is why the port surfaced a condition the source
never had to face, and why blaming our own rig data was the wrong first move.

**How to apply.**
- When a ported algorithm misbehaves, ask **what the source never had to
  answer** before concluding your data is wrong. Run your new instrument on the
  source's own fixture.
- A reference implementation on disk is the cheapest control available; reach for
  it before designing a stage around a hypothesis.
- **It also killed a task I had already written.** TASK_C158 asserted neck
  exposure ≥ 5% — false on every rig including the working one. Writing the task
  did not make the criterion true; measuring a second implementation tested it.
  Re-scope, don't annotate: a knowingly-false task left on the board gets
  launched by accident.

Related: [[feedback_give_every_fix_a_control_arm]],
[[feedback_a_control_that_cannot_move]],
[[feedback_print_achieved_beside_wanted]],
[[project_contact_solver]].
