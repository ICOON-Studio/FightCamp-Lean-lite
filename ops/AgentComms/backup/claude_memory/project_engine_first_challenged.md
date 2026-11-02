---
name: project_engine_first_challenged
description: "2026-09-22 - four independent reviewers converge that OVERLAP is a contact/blend defect, not a decision defect; engine-first is FORCED for grappling and a CHOICE for striking that inverted the commercial order"
metadata: 
  node_type: memory
  type: project
  originSessionId: 9e3da6ad-2507-4165-a508-3ceb3183e36d
  modified: 2026-09-21T21:41:35.755Z
---

**The operator told idle agents to evaluate the project. Four came back and they
triangulate.** This is the strongest direction input the project has had since
the 2026-09-14 engine-first decision, and it does not overturn that decision so
much as **split it in two**.

## The convergence

- **G61 (Grok, 72 sources)** — *"Overlap and jerk are mostly contact/blend
  failures, not decision failures. A correct CoG or strike-rate model does not
  make two meshes occupy one volume less."*
- **M21 (Maria)** — "overlap dominant; fix contact volume BEFORE polish;
  management fight grammar OK."
- **U124 (Cursor)** — the gate meant to catch overlap **cannot see it**:
  `fight_body_overlap_test.gd` refuses on `REFUSED_PAIRS` including `arm>head`,
  a key `FightBodyCapsules.class_pair_key` can NEVER emit (head rank 1, arm rank
  2 → always `head>arm`), while `probe_overlap_census.gd` documents 82 frames
  (9.1%) of real `head>arm` overlap on seed 810039. It prints
  `ok, worst 0.0000 m` over skull-in-shoulder.
- **K68 (Kalli)** dissents one level up — buyers of this genre reward management
  depth and believable outcomes, not 3D; ship a text/stats bout path NOT gated
  on the contact solver.

## THE ASYMMETRY — the actual deliverable, and do not re-derive it

- **GRAPPLING: engine-first is FORCED.** No paired pack is a product anywhere,
  AI generation returns one body (8 of 8), solo compose scored 0 of 36. *"It is
  not a bet there. It is the only path."* The contact solver is the correct
  object. **Keep going.**
- **STRIKING: engine-first is a CHOICE**, and the commercial order is clips +
  touch-IK first with physics as cleanup. **"Your 2026-09-14 bet inverted that
  order."** Spending a year on weak-line and CoG while the operator still names
  overlap and jerk is solving the wrong half.

## The evidence that makes it hard to dismiss

EA MMA 2010 used physics **only** to clean interpenetration, never to pose —
they needed the actors' visual intention. Yuke's UFC Undisputed fixed
stuck/jitter with constraint limits and IK targeting, **not a better decision
tree**. UFC 4 rescales both bodies to the same size on the ground so limbs do
not clip. Fight Night 4 had to rebuild collision so gloves stopped disappearing
into skulls. EA FC's Hypermotion abandoned studio mocap because aggregate stats
plus generic clips still looked like skating.

> "A sim can hit every FightCamp calibration target and still look like two
> mannequins sharing a pelvis. The 323 tests do not observe *does this read as
> two athletes*."

## How to apply

**Build S43, but frame it as a PRESENTATION layer that makes poses touch** — not
as proof that better decisions produce a watchable fight. Treat the striking
half as an open question rather than a settled bet.

**Two falsification tests were offered; run them rather than arguing.** (1) Same
clip set, contact solver on vs off — if jerk survives a clean contact solve it
was never a decision problem. (2) A non-dev watches 30 s of striking and 30 s of
grappling and does not say overlap, slide or pop, while the rate sheet stays in
its published bands.

Full records: `research/G61_IS_ENGINE_FIRST_RIGHT.md`,
`K68_WHERE_THIS_SITS.md`, `M21_WHAT_IT_LOOKS_LIKE.md`,
`U124_DECLARED_ONLY_GATES.md`. Related: [[project_engine_first_2026-09-14]],
[[project_watchability_verdict_2026-09-13]],
[[project_operator_verdict_foot_lock_2026-09-14]],
[[reference_paired_grappling_market]], [[project_contact_solver]].
