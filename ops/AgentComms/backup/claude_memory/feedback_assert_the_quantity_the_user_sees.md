---
name: feedback_assert_the_quantity_the_user_sees
description: "When a module reports in one vocabulary and acts in another, assert the one the user sees — a green suite can fully cover the wrong vocabulary"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: dbdfc741-0ca9-4f42-8c55-adc58d3da89c
  modified: 2026-09-11T02:18:02.619Z
---

**PERMITTED IS NOT OCCURRED has a sharper form: ASSERTED IS NOT THE SAME
QUANTITY.** When a module reports in one vocabulary and *acts* in another, assert
the one the user actually sees.

Found in R103 (2026-09-11). `FightStagePlayer.present_beat` reported the
purchase-list CATEGORY (`strike_head`) while the AnimationPlayer it drove held
`jab`. Over 148 action beats it played **a clip the fight never threw 85 times,
57.4%** — an overhand played a jab, and so did a lead hook whose own clip was
already grafted. **Six assertions passed**: `strike_head_played >= 1`, `skipped`
non-zero, determinism, byte-identical replay. Every one of them was true, and
every one tested the category vocabulary while the defect lived in the clip
vocabulary. The fix's gate now asserts `AnimationPlayer.current_animation`.

**Why:** R102's three defects were *unreachable* paths, which an occurrence floor
catches. This one was a fully reached, fully covered path — so an occurrence floor
on the wrong noun is still green. Two parallel vocabularies for one thing (a
category and a concrete id) is the smell; only one of them is usually asserted.

**How to apply:** when a module has both a category and a concrete id for the same
event, find the quantity that reaches the user — the string in
`AnimationPlayer.current_animation`, the text rendered, the row written — and pin
THAT. A report-level assertion is the hole. And when one module computes an honest
decision onto a data structure (U43 put `clip_role`/`has_clip`/`clip_missing` on
the beat), grep for a reader before trusting it is wired: see
[[feedback_deadend_means_assign_research]] and [[feedback_tier_the_test_gate]].

Corollary that paid off the same day: a blind contract test from the same contract
but a DIFFERENT fixture is the strongest agreement available — U47 reached 177
action beats against R103's 148 and got substitutions=0 on both.

**It happened again at the scale of the whole picture (2026-09-13 night).** Every S4a gate measured joins and
feet while 24 of 33 actions in a bout played no clip at all, the camera sat under the ring canvas and a
bare-knuckle mesh boxed a gloved one - the operator, watching it, called it painful. The quantity the user sees
is the rendered bout itself: render it and look before reporting progress. [[project_watchability_verdict_2026-09-13]]

**And again, one level down (2026-09-14): a whitelist copy dropped a field.** `FightClipBinding.metadata_for` copied
a fixed list of keys and never carried `native_speed_mps`. `walk_at` read it, got 0 and refused every walk from
d02757d on: the operator's "no walking only teleporting". The binding table looked right and no test called
`walk_at`. A four-line print inside the consumer (rate=-1) found it after Cursor's trace had bucketed the skate. The
fix's test asserts what the AnimationPlayer HOLDS (`loc_advance` at rate 0.50), and fails 5/13 without the fix.
