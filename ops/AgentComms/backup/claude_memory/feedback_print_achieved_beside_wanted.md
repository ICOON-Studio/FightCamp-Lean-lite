---
name: feedback_print_achieved_beside_wanted
description: "A constraint you change is a WANT; whether the solver reached it is a separate fact. Print achieved beside wanted or 'it didn't help' is not a finding"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 94da2c41-2c25-4d0f-9f7b-327dda4c66ad
  modified: 2026-09-22T08:29:39.784Z
---

S47, 2026-09-22. The derived contact offsets took the collar tie's pelvis gap
from 0.0300 to 0.1200 m and the penetration barely moved (0.1274 → 0.1223). The
tempting report was "derived offsets did not fix it" — which would have been
true, useless, and would have left the next session guessing between two very
different worlds:

- the solver **could not reach** the new stance (then the constraint, the DOF
  ranges or the weights are the story), or
- the solver **did reach it** and the defect is somewhere else entirely.

A ten-line probe settled it: `pelvis surface gap wanted 0.1200 achieved 0.1156`,
and the two men standing 0.5027 m apart against a 0.4848 m arm. **The stance was
achieved to 4 mm.** That eliminated the stance and left only the capsules — which
is how the real defect (an unreachable neck) got found in the same session.

**How to apply.**
- Every constraint you author or change: print **wanted, achieved, and the miss**,
  on the solved state, not on the wish.
- Report the *terms* of a derivation beside its result, the way
  `FighterCapsules` prints a `source` string with every radius. A number with no
  derivation beside it cannot be audited later.
- "X did not help" is only a finding once you have shown X actually happened.

Related: [[feedback_debug_at_the_point_of_write]],
[[feedback_open_the_output_before_the_gate]],
[[feedback_measure_one_body_first]],
[[feedback_gates_must_derive_not_copy]].
