---
name: feedback_unnamed_literal_has_no_handle
description: "A bare float inline in an expression is a defect nothing can grep for - four stages of anchor work ran past the one number that set the whole fight's pace"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2e39c758-1950-4071-b0d8-82b8b3911060
  modified: 2026-09-20T14:29:07.880Z
---

S26 (2026-09-20). The FightCamp engine landed **38.37 combined significant strikes a minute against
J20's 6.85** — 5.6x — and the entire miss was this, inline in `FightRealtime._run_impact`:

```gdscript
if rng.randf() > 0.35 * Fatigue.output_multiplier(actor_fatigue):
```

`0.35`, unnamed, unsourced and untested, there since the first version of the fight. **Four
consecutive stages of J20 anchor work ran straight past it**, and S25 could only find it from the
far end — by noticing the knockdown count was wrong and reasoning backwards through the volume.

**Why:** the number was never hidden, it was *un-addressable*. Every technique this project uses to
find things — grep the module tree for the concept, check what a constant is sourced to, ask which
test pins it — operates on **names**. A literal in an expression has none, so it cannot be searched
for, cannot be cited in a digest, and cannot be pinned by a test. It is invisible to exactly the
habits that are otherwise reliable. This is the same shape as R149 (balance built three times and
wired zero) and R150 (`FightCommitment` sitting in `scripts/` while a stage concluded the clause
needed authoring), one level lower down.

**AND THE SEQUEL, WHICH IS THE BIGGER LESSON.** Naming and calibrating it was correct and the full
suite then REFUSED to ship it: six occurrence floors went red — knockdown stoppages, doctor
stoppages, hurt-man corner advice, the round-three fatigue fade *inverted*, the commitment kuzushi
share, and a sourced spacing band. None was a stale pin. The engine's per-strike damage had been
implicitly calibrated against 6.9x the volume, so **volume and per-event effect are one product and
moving one alone breaks everything downstream of it.** The tell was in the stage's own control rows
and I wrote it down without seeing it: knockdowns per landed head strike *fell* 0.64% → 0.50% when
volume fell. So it shipped as a `static var` on the legacy default with the calibrated value
exercised by its test, and the pair became one stage.

**How to apply:**
- If a per-event rate moves the WRONG WAY when you change volume, the two are coupled and you are
  holding half a stage. Print per-event rates as control rows, not just totals.
- When a calibration is right but not shippable alone, a `static var` on the old default with the
  new value **exercised by its test** beats both reverting it and parking it in a comment.
- When a measured quantity is badly wrong and the stage cannot find a lever for it, **grep the hot
  path for bare float literals** before concluding the mechanism does not exist. In GDScript:
  `rg -n '[^_a-zA-Z0-9.]0\.[0-9]+' <file>` over the tick loop and its helpers.
- Naming it is most of the fix. Give it the anchor it is measured against, and **say in the header
  whether it is derived or tuned** — "tuned, not derived, and here is the target it was tuned to" is
  honest and checkable; a bare number pretending to be derived is a fossil.
- Then pin the **observable, never the constant's value** — a check that reads its own subject
  cannot fail, and a later stage may reach the same number another way. See
  [[feedback_a_gate_that_reads_its_subject_cannot_fail]].
- **Prove the new test can fail** by breaking the constant deliberately: at the shipped `0.35` the
  new pace test reported 42.07/min and failed 5 of 19 checks. See
  [[feedback_prove_contract_tests_with_mutants]].

Related: [[feedback_anchor_miss_is_not_its_own_constant]],
[[feedback_search_for_the_thing_not_the_category]], [[feedback_gates_must_derive_not_copy]].
