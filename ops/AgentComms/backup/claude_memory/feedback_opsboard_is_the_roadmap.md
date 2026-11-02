---
name: feedback_opsboard_is_the_roadmap
description: "S157 operator wants the ops board to show only a clear roadmap - running, next in order, who is scheduled for what; fed by roadmap.json `plan`"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 664eaa86-b9d0-454f-b955-7b1b43e5eabe
  modified: 2026-10-03T20:06:31.419Z
---

Operator 2026-10-03 (S157): "tidy up the opsboard there is a lot of information i do not need to know, i want to know clearly a detailed roadmap showing what is being worked what is next who agents are scheduled for what and who are running".

Built: 127.0.0.1:8787/ = Tools/opsboard/roadmap.html; the old detailed board is at /old. Running = live_runs.json status running (derived). Everything else = roadmap.json `plan` (goal, titles, working_now, next[ordered, who, after], waiting_seat, parked, agents one-liners).

**Why:** the old page was stale roster notes, launcher essays and per-agent stats; he could not see who does what.
**How to apply:** update `plan` at every launch, landing and ship (CLAUDE.md s3 ship duty). Titles in plain words, no task codes. Never add sections back without him asking. Related: [[project_roadmap_and_opsboard]].
