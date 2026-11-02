---
name: project_capsule_abstraction_verdict
description: S52 - the endpoint inset is dead and the whole TRUNK is past the capsule abstraction; five agents converged blind
metadata: 
  node_type: memory
  type: project
  originSessionId: 309a1b59-f45a-4452-b85f-1037c99a022e
  modified: 2026-09-22T17:07:57.316Z
---

2026-09-22, S52. Dola's endpoint inset (`p.y = boneY ± r`) was built, measured
on both rigs with her own Present Ratio control, and **refused on all three
arms**. Arm A buys zero exposure and deletes the neck; arm B consumes the head
entirely; arm C is both and reads `3.9% | 7.4%` ABSENT where her rig read
`99.4% | 100.0%`.

**Five agents then converged on the same answer, all blind to each other, in one
afternoon** — the strongest convergence this project has had:

- **Q137** (Qwen, 12 rigs measured): head BALL on 10/12 (median r/L 1.17),
  pelvis NEEDLE on **all twelve**, neck NEEDLE 8 / BALL 4, thorax straddling.
  **Every limb from femur outward is fine.** The abstraction fails on the TRUNK,
  which is where every grapple happens.
- **J42** (John, anthropometry): a real male neck is ANSUR Neck Link 107.8 mm
  with soft r 63.3 mm = **r/L 0.59** — *"the double-end inset cannot survive on
  neck even at correct L."* **So the rule is dead, not mis-parameterised.**
- **D12** (Dola): classify on load — `<0.50` normal, `0.50–1.00` degenerate →
  sphere, `≥1.00` absorbed → discard. *"Promote or remove, never
  clamp-to-point."*
- **C164** (Codex blind contract, written first): bands at 0.25 / 0.50 / 1.00.
- **G70** (Grok): one neck volume + four named anchors with approach cones.

**Do NOT change `RADII_M["neck"]` to Dola's 0.035 m** — that is a 0.22 m girth;
ours derives 0.055 from a 0.35 m male girth and J42 puts the real soft radius at
63.3 mm, *larger* than ours. Our radius is right; our **span** is short (59–77 mm
against ~108 mm C7–tragion) and worth fixing on its own terms, but it does not
rescue the inset.

Replacement, already designed: head → sphere, neck keeps its volume with a
corrected span, grips become named anchors on one tube, and elevation-banded
exposure goes in as an **instrument, never a pass gate** (Dola's own
self-objection: a global horizon would read 95% on a clavicle buried under
trapezius).

See [[feedback_prove_contract_tests_with_mutants]],
[[feedback_never_test_identical_fighters]],
[[feedback_informative_failure_still_does_not_ship]].
