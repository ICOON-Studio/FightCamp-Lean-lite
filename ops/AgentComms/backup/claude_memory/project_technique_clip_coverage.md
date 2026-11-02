---
name: project_technique_clip_coverage
description: "696 technique nodes, 534 need motion; the grappling 189 are the wall and cannot be bought or generated"
metadata: 
  node_type: memory
  type: project
  originSessionId: 928672c1-cd85-44c1-9dba-06a222f809a3
  modified: 2026-09-22T10:18:38.004Z
---

Measured 2026-09-22 from `Godot/assets/data/technique_catalog.json` and
`FightClipBinding.gd`:

- **696** technique nodes across 15 disciplines.
- **162** are `kind: skill` — passive attributes (distance read, coverage,
  mobility). **They will never need a clip**, and a modal must not show them an
  empty viewport.
- **534** are `move`/`sequence` and need motion. Coverage was **15**; Qwen's
  Q133 wired clips already on disk and took it to **158 (29.6%)**.
- **189 of the 534 are grappling** (judo 115, BJJ 72, wrestling 18, sambo 18).

**The split that matters:** solo striking is a money-and-throughput problem
(Higgsfield text-to-motion, 0.1 credit a job, ~923.9 credits available).
**Grappling is the wall** — a paired positional pack is not a SKU anywhere,
Higgsfield returned one body in 8 of 8 attempts, and composed takedowns scored
0 of 36. That is why the contact solver exists.

**Operator ruling 2026-09-22, verbatim:** *"wire everything that we own already,
produce clips form higgsfield to cover everything else, for the grappling you
can use a single actor performing the technique from higgsfield."* This
**releases the generator spend** that was paused behind the engine stage.

**How to apply:** the open risk is that a solo armbar or guard pass reads as
miming, because the technique IS the contact — G67 and J39 are sorting which of
the 189 survive a single actor. For the ones that do not, the contact solver
already produces a solved two-body pose that can be shown as a turntable.
Related: [[project_higgsfield_mma_study]], [[reference_paired_grappling_market]],
[[project_engine_first_2026-09-14]].
