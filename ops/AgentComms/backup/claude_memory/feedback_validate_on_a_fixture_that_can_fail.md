---
name: feedback-validate-on-a-fixture-that-can-fail
description: a control fixture can be the one where the bug is invisible - check a distribution, not one extremum
metadata:
  type: feedback
---

S39: two defects lived in `probe_cmu_grip.gd` for two stages because the only
validated fixture, 18/19_05, is the one where **both are nearly invisible and
partly cancel**.

| defect | 18/19_05 | 22/23_17 |
|---|---|---|
| reading one bone too proximal | 0.140 -> 0.141 | 0.099 -> **0.294** |
| 30 Hz bake of a 120 Hz capture | 0.141 -> 0.146 | 0.099 -> 0.099 |

The published `+8.8%` came back **unchanged** after both were fixed. A figure
surviving a fix is not evidence the old reading was sound.

**Why:** the gate compared ONE number - the minimum - against a remembered
figure, and it agreed by 0.8 mm. The distribution never agreed (p10 0.1745 vs
0.1564, p50 0.2437 vs 0.1960) and nobody looked.

**How to apply:** validate a mechanism on the fixture where it would FAIL
loudest, not the one that is already blessed. Check a distribution, never a
single extremum. And a gate that lists which fixture is trustworthy is a fossil
- assert the invariant instead, derived from the subject's own structure.
See [[feedback-gates-must-derive-not-copy]] and
[[project-gltf-asf-joint-convention]].
