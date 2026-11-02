---
name: feedback_control_arm_must_not_share_the_bug
description: A control arm that shares the bug it is meant to exonerate proves nothing - a DIFFERENCE between two bodies cancels common-mode error; check something ABSOLUTE against a known quantity
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 79d91b9d-dd8f-4640-9607-fe7da8006134
  modified: 2026-09-21T12:25:35.058Z
---

**A relative control arm cannot clear a common-mode bug, and reading it as
exoneration is how a wrong number gets shipped with confidence.**

S34 (2026-09-21) measured the CMU paired capture through our retarget and reported
hand-to-elbow drift of **+139.7%** at contact against only **+4.2%** at distance.
The control arm was `root->root`, which drifted just **+1.9%** — so I concluded
"the bodies are placed correctly, the error is entirely in the arm chain", wrote it
into the digest and the roadmap, and told the operator the grip does not survive.

**It was the opposite of exculpatory.** Hips-to-hips is a DIFFERENCE between two
bodies. The actual bug was a missing mount scale (see
[[project_fighter_rigs_are_not_in_metres]]), which is largely common-mode: it
mostly cancels in a body-to-body difference while showing at full size in every
limb. The corrected drift is **+8.8%**, not +139.7%.

**Why:** a control arm only proves something if it would FAIL under the
hypothesised fault. Ask explicitly: "if my instrument were broken in the way I have
not thought of, would this control still look clean?" A difference, a ratio, or
anything else where an error appears on both sides is exactly where it would.

**How to apply:** pair every relative control with an ABSOLUTE one against an
externally known quantity. In this project the cheap absolute checks are anatomical
and free: a standing person's feet are on the floor, a head is about 1.7 m up, a
limb length is rigid, and a capture's own trial label ("A pulls B by the elbow")
says a hand must reach an elbow. Those three caught bugs that every derived gate
missed — including C149's, where three of four self-checks literally could not
fail. Related: [[feedback_give_every_fix_a_control_arm]],
[[feedback_gates_must_derive_not_copy]], [[feedback_open_the_output_before_the_gate]].
