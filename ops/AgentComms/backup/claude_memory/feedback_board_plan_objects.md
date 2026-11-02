---
name: feedback-board-plan-objects
description: Ops board roadmap plan.next / working_now must be OBJECTS {id,who,title,after}; strings rendered as blank rows (operator S207 "there is not task shown Up NEXT")
metadata:
  type: feedback
---

Operator S207 (verbatim): "delegate heavy token work. there is not task shown Up NEXT,IN ORDER on opsboard". S206 wrote plain strings into
roadmap.json `plan.next` and `plan.working_now`; Tools/opsboard/roadmap.html reads `n.title`/`n.who`/`n.id`, so every row was blank.

**Why:** the board is how he follows the work; a blank "Up next" looks like nothing is planned.

**How to apply:** write `plan.next` items as `{"id","who","title","after"}` and `working_now` as `{"id","who","title"}`. S207 also made the
page accept strings (who = the "Agent:" prefix or claude), but objects carry the chips. After editing, curl 127.0.0.1:8787/api/roadmap.
Also from the same message: delegate token-heavy work (implementation, renders, research reads) to the seats; Claude briefs/reviews/merges.
Related: [[feedback_opsboard_at_wrapup]].
