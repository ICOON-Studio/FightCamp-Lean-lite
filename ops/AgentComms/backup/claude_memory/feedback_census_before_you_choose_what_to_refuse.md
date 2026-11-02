---
name: feedback_census_before_you_choose_what_to_refuse
description: "A single worst-case number says how bad the worst is, never WHAT is wrong - census the whole distribution before picking which cases to handle, and check every key you refuse is one the producer can actually emit"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 79d91b9d-dd8f-4640-9607-fe7da8006134
  modified: 2026-09-21T14:12:14.927Z
---

**U119 refused three class pairs, drove all three to zero, reported success, and
moved `frames_penetrating` by exactly nothing — 341 of 900 before and after.**

It was scoped off `probe_body_overlap`, which reports ONE number per frame: the
deepest overlapping pair. That can say how bad the worst case is. It cannot say
what is *common*, and the common ones were the problem. A census over every class
pair (`tools/probe_overlap_census.gd`, S36) showed the real shape at once:

    arm=arm     214 frames (23.8%)   arm>torso  203 (22.6%)
    arm>hand    202 (22.4%)          leg=leg    157 (17.4%)
    hand>torso  140 (15.6%)          head>arm    82 ( 9.1%)
    torso=torso   3 ( 0.3%)   <- the hip floor was already working

**AND ONE OF THE THREE REFUSED KEYS WAS A STRING THE PRODUCER CAN NEVER EMIT.**
`FightBodyCapsules.class_pair_key` always writes the lower `CLASS_RANK` first,
and head is 1 against arm's 2 — so it is *always* `head>arm`. U119 refused
`arm>head`, which matched nothing, while 82 frames of head-inside-shoulder went
untouched. **That was precisely the picture the operator had complained about**,
and the fix that "handled" it read as covered. A refused key nobody generates is
worse than no rule at all.

**Why:** a rule keyed on a value is only real if you have seen the producer emit
that value. Grep the generator, or census the live output, and check your keys
against what actually appears — never against what the naming convention implies.

**How to apply:**
- Before choosing which cases to handle, **count them all**. One aggregate hides
  the distribution, and the distribution is the design.
- **Assert your keys exist in the data**, not just in your head.
- Expect the first table to be wrong. Mine was: I argued the guard pairs
  (`hand=hand`, `arm>hand`, `arm=hand`) belonged to another solver and would be
  double-corrected. Refusing the others made them *worse* — `arm>hand` went
  202 → 300 — because separating bodies for a torso overlap drives the hands
  into the opponent's guard, and that solver runs *before* the correction.
  Adding them took any-penetration from 355 to 33.

Related: [[feedback_a_gate_that_reads_its_subject_cannot_fail]],
[[feedback_gates_must_derive_not_copy]],
[[feedback_open_the_output_before_the_gate]].
