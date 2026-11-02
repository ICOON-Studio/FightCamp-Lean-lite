---
name: feedback_defects_live_where_agents_meet
description: "Two agents can each ship a correct piece and the defect exists only where they meet - only the integrator's full suite finds it"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 928672c1-cd85-44c1-9dba-06a222f809a3
  modified: 2026-09-22T10:53:37.654Z
---

When two agents land work in the same area, run the **full suite** after merging
both. Each branch's own gate passes; the defect lives in the gap between them
and no subset touches it.

S48 (2026-09-22): Cursor's U131 technique-modal resolver reported state
`PLAYING` for any bound clip. Qwen's Q133 then bound `boxing_one_two` to a
**jab** clip marked `provenance: "near"` — correct, and marked as a stand-in
exactly as its task required. The resolver could not see the mark, so the modal
would have shown the name *One-Two* over a jab with nothing on the face to say
so. **111 of Q133's 121 bindings are NEAR**, so it was the common path.

`--only ui` was 16/0 before the merge. `--only clip` was 10/0 after it. **Only
the full suite caught it** — as a 9th failure against a ceiling of 8.

**Why:** each agent is told to read only its own task file, which is the right
credit rule and is precisely what makes cross-agent defects invisible to them.
Nobody but the integrator ever sees both sides.

**How to apply:** after merging two agents whose work touches the same subsystem,
run the full suite and compare against the *named* ceiling — an extra red is the
signal. Then ask which agent is wrong before assuming either is: here both were
right and the missing piece was a third thing (the resolver reading the
provenance mark). Related: [[feedback_tier_the_test_gate]],
[[feedback_blind_tests_can_collide]],
[[feedback_open_the_output_before_the_gate]].
