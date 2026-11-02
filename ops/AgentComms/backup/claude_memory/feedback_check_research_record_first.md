---
name: check-research-record-before-claiming-unread
description: "Before saying a topic is \"not analysed\" OR asserting a fact about the codebase, grep HANDOFF.md, HANDOFF_ARCHIVE.md and research; a narrow grep is not a finding"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f5109928-16c1-4a7d-810f-e7527c1d2142
  modified: 2026-09-11T20:27:34.760Z
---

On 2026-09-04 I wrote in the handoff that Corner King, MMA Empire, Pound
for Pound and others were "not yet read". The user corrected me: they had
already asked for that analysis, and `research/REFERENCE_SURVEY_2026-09-03.html`
covers every game on the E: and D: drives.

**The rule generalised on 2026-09-11, when the operator caught it twice in one
session and both times the check changed the answer:**

1. I bound four kick ids to `H2H_RoundhouseKick_InPlace` without grepping for it
   first. `HANDOFF.md` already recorded, from R111: *"every kick in the H2H pack
   is a FLYING kick... leave him horizontal and airborne at every frame, reading
   as levitation."*
2. I said "balance isn't a fighter attribute" off one grep of `Godot/scripts/*.gd`
   (no subdirectories, `GameState.gd` never opened). Asked *"is that a result of
   a completed research?"* — no, it was not. Checking properly found `STAT_KEYS`
   in four files AND that balance **is** modelled, as a per-technique
   `balance_break` effect on 16 techniques with graded values 5..15, plus a
   recorded ruling about it in `FightMoves.gd:92`. "Not modelled" was wrong;
   "modelled on the move, with no fighter-side state to act against" was right,
   and is the more useful statement.

**Why:** the user commissions research deliberately and remembers it. A claim
that something was never analysed reads as me having lost their work. And a
confident assertion drawn from one narrow grep is indistinguishable, to them,
from a researched finding — so it gets acted on.

**How to apply:** before calling anything unread, grep `HANDOFF.md`,
`HANDOFF_ARCHIVE.md` and `research/`. Before asserting a fact about the
codebase in chat, either check it properly or **say which it is** — "I grepped X
and saw Y" is honest; stating it flat is not. When a deeper pass is worth it, say
"the survey covered X; this pass goes deeper on Y".
Related: [[feedback_claude_lead_developer_role]],
[[feedback_assert_the_quantity_the_user_sees]], [[feedback_collect_before_you_assign]].
