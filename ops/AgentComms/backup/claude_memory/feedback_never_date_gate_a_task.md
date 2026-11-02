---
name: feedback-never-date-gate-a-task
description: "Never write a start date into another agent's task; assign it and let them start when their credits allow"
metadata:
  type: feedback
---

2026-09-04, on Codex's C2 assignment: "do not block tasks behind dates
for codex again". Claude had written "starts 2026-09-07" (the date
Codex's credits were expected back) into the task file, the HANDOFF
claim and the sync point.

**Why:** a date is a guess about someone else's budget, and it stalls
work that is otherwise ready — the agent reads the date, decides it is
not their turn, and the task sits. Credit state is an observation, never
a gate.

**How to apply:** assign the task with its spec and say "start when your
credits allow". Keep credit levels as a status note in
`CURRENT_STATUS.md` if it is useful, but never in the task's own
heading or its first paragraph. Same for my own stages: no "next week",
just the assignment.

See [[project-credit-budget-2026-09]] and
[[feedback-claude-lead-developer-role]].
