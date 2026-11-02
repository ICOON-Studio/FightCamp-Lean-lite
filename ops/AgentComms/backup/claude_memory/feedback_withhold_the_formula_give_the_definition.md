---
name: feedback_withhold_the_formula_give_the_definition
description: brief a blind contract test with the geometric/behavioural DEFINITION and withhold your formula - it then finds defects in the contract that your own gate cannot
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3f51d2e0-2dbf-4f29-8a38-7fb8b4bbd745
  modified: 2026-09-22T20:23:51.890Z
---

**When commissioning a blind contract test, give the DEFINITION of the thing
and deliberately withhold your own arithmetic.** A test written from someone
else's formula only ever agrees with that formula, bugs included.

**Why:** S54 (2026-09-22). Grok was briefed on the *shape* — "a right circular
cylinder closed by flat planar disks, exact signed Euclidean distance" — with
my implementation withheld. It came back having found a genuine defect in my
**contract**: I had asserted that any point "strictly between the two end
planes" has its nearest surface on the barrel, so `flat == dome` there. False —
a point INSIDE and near the cap reads `flat = -0.01` against `dome = -0.14`.
**My own non-vacuity check sampled only an OUTSIDE point beside the barrel, so
it could never have hit the clash.** The blind half found what my gate was
structurally blind to. The test then passed against the real module first time,
`checks=1902 checks_failed=0`.

It also caught the *source* agent: D13's rim branch `sqrt(d_axial² + d_perp²) - r`
is the distance to a sphere at `p1` — the dome it was meant to replace. The
correct form is `sqrt(d_axial² + (d_perp - r)²)`, the rim circle.

**How to apply:** say what the thing IS, list the invariants it must satisfy
(containment, identities that hold in one region and must FAIL in another,
symmetry, rigid-motion invariance), name the degenerate cases as decisions, and
ask explicitly for ambiguities in the contract itself. Then prove the returned
test with mutants before believing it — patching the module to the rejected
formula should turn it red on named rows.

Builds on [[feedback_prove_contract_tests_with_mutants]] and
[[feedback_blind_tests_can_collide]]; related
[[feedback_gates_must_derive_not_copy]] — derive an agent's arithmetic rather
than copying it, and say where you diverged.
