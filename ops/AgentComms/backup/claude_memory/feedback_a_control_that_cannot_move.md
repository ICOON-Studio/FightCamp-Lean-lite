---
name: feedback_a_control_that_cannot_move
description: An unchanged control proves nothing unless the instrument could have moved; ask what would have had to happen
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 50b85198-25e9-4e6d-968f-a6a49b10cbf7
  modified: 2026-09-21T20:28:36.071Z
---

**S41, 2026-09-21, and it passed nine times before I noticed.** The re-baseline
ran `pair_gap_report.gd` over all nine authored pairs and every row came back
byte-identical to Q126's baseline, to six decimals. I nearly reported that as
"the change is safe for authored pairs".

It was a tautology. `pair_gap_report.gd` measures **hips to hips**, and all
three segments S41 added re-aim a bone BELOW `Hips` in the chain. **The hip
positions could not have moved whatever the change did.**

`s41_correction_delta.gd`, written to ask the right question, then showed the
change moves NINE bones — the shoulders by 25-27 degrees.

**Why:** an instrument that is structurally blind to the change under test
reports "no difference" with total confidence, and it reads exactly like a
clean pass. It is the same family as a non-vacuity check on the COUNT rather
than the CONTENT (see [[feedback_a_gate_that_reads_its_subject_cannot_fail]]).

**How to apply:** before quoting an unchanged control, ask **what would have had
to happen for this instrument to read differently** — and if the answer is
"nothing this change is capable of", it has not passed, it has abstained. Then
find or write the instrument that CAN move, and report both.

Corollary from the same session: a fixture where the term under test is
redundant also proves nothing. The solver's first fixture had one contact that
happened to pull the bodies apart, so a build with the penetration term DELETED
still passed. The repair is a fixture where the term is the only thing that can
work. Related: [[feedback_give_every_fix_a_control_arm]],
[[feedback_validate_on_a_fixture_that_can_fail]].
