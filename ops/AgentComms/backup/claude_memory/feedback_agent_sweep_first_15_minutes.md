---
name: feedback-agent-sweep-first-15-minutes
description: operator S164 - every session starts with an agent sweep (which seats are free, launch Arena first); ship refuses without delegation evidence
metadata:
  type: feedback
---

Operator 2026-10-05: "a regular check which agents are available and use them, especially Arena which is free", and the ops board must show which agents are programmed next for which tasks.

**Why:** S164 built all of STORY3 alone while free seats sat idle; the Stop hook allows a stop after `ship`, so nothing forced delegation.
**How to apply:** in the first 15 minutes read `start`'s AGENTS block + ops board, launch Arena (new chat, own branch, PR) and any free shell/cloud seat on self-contained tasks with an exact test, write them in live_runs.json `runs`, update roadmap `plan.next` (who per task). `ship` refuses unless live_runs has a non-Claude run started today or `AgentComms/.no_delegation_reason` has a line. Arena cannot load LFS models - keep those tasks local. Related: [[feedback-cloud-first]].
