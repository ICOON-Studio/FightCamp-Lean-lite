---
name: feedback-leave-a-waiter-when-you-wait
description: S199 - ending a turn with "I'll collect it when it lands" and no waiter lost 7 hours; always start a background waiter that wakes you
metadata:
  type: feedback
---
S199: I wrote "I will collect GYMFILL2 when it lands" and ended the turn. Nothing woke me; the operator came back 8 hours later ("its been 8 hours wtf"). Four of five runs had landed meanwhile.

**Why:** a finished turn is idle until the user speaks or a background task notifies. Agents on the PC/Arena notify nobody.
**How to apply:** before ending a turn that waits on an agent, start `run_in_background` Bash loops that exit when the branch/PR appears (`git ls-remote --heads origin <branch>`, `gh pr list ... --json headRefName`), one per run; when one fires, collect it. Related: [[feedback_no_report_before_next_item]].
