---
name: feedback-gate-the-guessed-id
description: "recording a bad id in a digest is not a fix; gate it, and when an id is missing search for the thing's NAME before concluding it is absent"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 28faea2b-d19e-495f-9c28-11e3d7a8cd1d
  modified: 2026-09-22T22:30:59.096Z
---

A name written in code that is supposed to match data must be gated, not
reviewed. And when a lookup fails, search for the THING by its human name before
concluding it does not exist.

**Why:** the technique catalogue holds 711 ids and nothing checked that an id
written in code was one of them. It cost work three times. C169 went to author
the closed-guard hold, could not find `bjj_closed_guard`, and recorded *"there is
no eligible clip"* — **the position was there all along as `bjj_guard`, name
"Closed Guard"**, and a hold was skipped. Its brief had handed it candidate ids
and it treated that list as the search space. I then invented `bjj_back_mount`
myself (real id `bjj_back_control`). The operator's reaction to the second one
was *"i thought you fixed that on the previous session"* — it had not been fixed,
it had been RECORDED, and a note in a digest is not a gate.

**How to apply:** `Godot/tests/technique_id_reference_test.gd` loads the
catalogue and refuses anything not in it; add new reference sources to its list
rather than writing another test. When writing a brief, give the SEARCH not the
candidates. When a lookup fails, grep the human name first.

Related: [[feedback-search-for-the-thing-not-the-category]],
[[feedback-gates-must-derive-not-copy]],
[[feedback-prove-contract-tests-with-mutants]].
