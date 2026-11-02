---
name: feedback_measure_one_body_first
description: "Three sessions hunted a two-body contact defect that was visible on ONE body with no solver at all - when a pair measurement won't come right, measure a single body first"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 94da2c41-2c25-4d0f-9f7b-327dda4c66ad
  modified: 2026-09-22T08:29:30.420Z
---

S43, S46 and S47 each attacked the same symptom — `forearm_r/thorax` penetrating
0.12–0.13 m in a collar tie — from the two-body side: contact offsets, then the
DOF set, then the offsets again derived properly off the rig. Each ran the full
solver over thirteen poses, ~4 minutes a pass, and each moved the residual a
little without moving the verdict.

**The defect was on ONE body and needed no solver to see.** Sample points around
the `neck` capsule's own surface, offset outward by a hand's radius, and count how
many lie outside every other capsule *of the same body*: **0.0% on both rigs.**
The neck sits 0.12–0.16 m inside the `thorax` capsule, because the thorax radius
is the p80 of the Chest bone's skin and the Chest bone owns the deltoids —
r = 0.1909 m on a 0.3054 m segment, a ball whose cap covers the shoulders.

Every neck grip in the corpus was **unsatisfiable by construction**. A solver told
to satisfy an impossible constraint can only answer by burying the hand, which is
exactly what the two-body measurements kept reporting.

**How to apply.**
- Before tuning an interaction between two things, ask whether each thing is
  internally consistent. A pair measurement inherits every single-body defect and
  hides it as an interaction failure.
- **A capsule whose radius exceeds half its own segment length is a sphere.** That
  one ratio (ours: 0.625) is worth printing for every capsule in any rig audit.
- A derivation that is correct and does not help is still information — but only
  if you prove it landed. See [[feedback_print_achieved_beside_wanted]].

Related: [[feedback_give_every_fix_a_control_arm]],
[[feedback_run_the_instrument_on_the_old_tree_first]],
[[project_contact_solver]], [[feedback_validate_on_a_fixture_that_can_fail]].
