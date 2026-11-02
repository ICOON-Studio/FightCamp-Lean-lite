---
name: feedback_give_every_fix_a_control_arm
description: "A diagnosis that fits the numbers can still be wrong - read what a measurement is taken RELATIVE TO before believing any story about it, and give every fix a control arm (S29/C140, 2026-09-21)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 56edf8be-ac8b-4ac2-94d2-319c9564c9cf
  modified: 2026-09-20T21:49:29.178Z
---

**I told the operator a defect was "two lines", they acted on it, and the control arm refused it.**

C138's paired BJJ chain had a 1.562 m jump at the first join, and beat 2's live hip travel was
1.573 m. I read that coincidence as one displacement counted twice, blamed the two lines that reset
both root nodes to the spawn marks at every beat, said so with confidence, and wrote it into a
Codex task as Part 1 — which she then built.

`tools/c140_chain_probe.gd` is the same harness with one switch. The control arm reproduces C138's
joins to the digit (1.562 / 0.319 / 0.322 / 0.150 / 0.946), which is what proves it *is* a control.
Chaining the previous beat's live roots moves them by **−0.000 / −0.000 / −0.001 / −0.052 / +0.016 m**.
Nothing.

**Why:** `_align_pair` best-fits a rigid transform over 360 yaw candidates, **applies** it to both
bodies, and only *then* measures `previous[i].distance_to(after[i])`. A residual measured AFTER a
best-fit alignment cannot be a placement error — no translation or rotation can remove it, so it is
a **pose mismatch**. Codex's own digest had said exactly that ("the source clips do not share a
single authored end pose") and I overrode it with a tidier story.

**Why:** a number's meaning is fixed by what it is measured relative to, and I never checked. Two
figures agreeing to three decimals felt like a confession, and coincidence at that precision is
still coincidence when the frame of reference is wrong.

**How to apply:**
- **Before believing any story about a measurement, read what it is taken relative to.** Is it
  absolute, or a residual after a correction the code already applied?
- **Give every fix a control arm** — the same harness with the change switched off. It costs one
  flag. The control is only trustworthy once it reproduces the published numbers to the digit; that
  reproduction is the evidence, not a formality.
- **Run it even when the arithmetic looks like a confession.** This arc has now been saved five
  times by measuring before building ([[feedback_gates_must_derive_not_copy]]), and this is the
  first time the thing refused was *my own* diagnosis rather than a brief's.
- **When an agent's explanation disagrees with yours, weigh it.** Codex was right and closer to the
  code; tidiness is not evidence. See [[feedback_check_pre_merge_authoring]].
- Retract in writing where the next session will look — `C140_CHAIN_CONTROL.json` carries the two
  arms and a `_note` saying the chaining story is dead, so nobody rebuilds it.
