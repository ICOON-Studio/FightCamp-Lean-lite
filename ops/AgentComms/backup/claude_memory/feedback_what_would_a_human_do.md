---
name: feedback_what_would_a_human_do
description: "Operator rule 2026-09-25 - every research brief and task file must ask and answer \"what would a human do?\" before a method is chosen; gated in agent_comms start"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 8dabac61-fbe3-49ee-adbf-d873c7291826
  modified: 2026-09-25T00:51:32.969Z
---

Operator, 2026-09-25 (S73), verbatim: "in all researches i want this questioned and answered : what a human would do ?"

Every TASK_*.md and *_BRIEF.md carries `## What would a human do?` - how the real professional (animator, promoter,
matchmaker, coach, fighter, referee) does the job - answered before any method is picked.

**Why:** the colour-suit route copied one piece of optical mocap and skipped the rest; agents (and I) reach for a
clever method before asking how the trade already does it. See [[feedback_copy_the_whole_industry_pipeline]].

**How to apply:** write the section into every brief at assignment. `agent_comms.py start` prints RESEARCH DEFECT for
any brief marked "Assigned S73" or later that lacks it (`missing_human_question()`); fix the brief, never the check.
