---
name: feedback_spell_out_decisions
description: "Never hand the operator shorthand like \"A on all three\" - spell out each decision in plain words, then ask with labelled options; they answered three rulings at once that way"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f1e1e7cb-927d-4ab0-8e18-a7cf09b90221
  modified: 2026-09-13T18:06:44.176Z
---

On 2026-09-13 a report ended "Three decisions for you (I recommend A on each)" with terse ROUNDS / COUNT /
R5B lines. The operator replied: "what do you mean a on all three ?" After each decision was rewritten as
the problem in plain words plus what every option would do, and asked through AskUserQuestion with labelled
options and the recommendation first, all three were answered in one reply (two recommended, one not).

**Why:** the operator reads on a phone and decides from the message alone; option letters and internal IDs
(R5B, C107) carry meaning only for whoever wrote them.

**How to apply:** for any decision that is the operator's - state what goes wrong today, what each option
changes, and the cost, without code names; then put the choices in AskUserQuestion. Record the answers
verbatim in HANDOFF and the roadmap's already-decided list the same turn.

Related: [[feedback_be_concise]], [[feedback_gloss_every_task_code]].
