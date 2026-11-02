---
name: feedback_blind_tests_can_collide
description: "When two blind tests written from two different research files disagree, the collision is the finding and the module is where it gets settled"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 47e37ea4-ab16-495f-bd15-4e950ac50427
  modified: 2026-09-10T09:57:37.001Z
---

Two blind contract tests, each written honestly from its own research file,
can disagree with **each other** rather than with the module. It happened on
2026-09-10: C67 (from G37) and Q22 both pinned that a caller stating grand
amplitude in danger gets UWW's published 5, while C73 (from G39 §6.1) asserted
no throw ever returns 5.

**Why:** both were right about different things. G37 documented a band the
rulebook publishes; G39 refused *deriving* that band from facts the engine
cannot emit. Neither test was wrong and neither could be deleted.

**How to apply:** resolve it in the MODULE, not by editing either assertion
away — here, a 5 came to need BOTH facts STATED, because a derived flag is our
own invention and an invention must never promote a published 4 to a published
5. Then report the collision as a finding in the digest. Related: the
reconciliation seam belongs to whoever owns the stage that caused it — see
[[feedback_write_it_yourself_when_spec_exceeds_code]].

A second, cheaper case from the same day: a blind test asserted the right rule
on the WRONG EVENT (osaekomi on `control`, where the fold returns early and
never calls `award()`). Move the assertion to the event the engine actually
emits and keep every band it wrote — do not make the module answer on a path
no real bout takes, which is just [[feedback_godot_verification_gate]]'s dead
code with a green test on top.
