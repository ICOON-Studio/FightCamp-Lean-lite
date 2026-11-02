---
name: no-report-before-next-item
description: Never end a turn with a report after one item while queued work remains; start the next item immediately
metadata:
  node_type: memory
  type: feedback
  originSessionId: e9af1fe3-ace1-499a-82d2-dbf93f4b9fb6
  modified: 2026-10-05T21:30:27.285Z
---

S170 (2026-10-06): after finishing the Fight Business walk and merging STORY4A I wrote a closing report + handover block with STORY4B, offers redesign, floor still all still queued. Operator: "I kept ending my turns with a report instead of starting the next item" and asked for a rule.

**Why:** a report is not progress; the operator judges by playable milestones, and the goal is one watchable boxer career sooner. Complements [[feedback_agents_start_before_the_stage]] and the NEVER IDLE rule.

**How to apply:** after every commit, make the next tool call the first step of the next item in `now.next_action`. End the turn only when the queue is empty, the next item needs operator money/taste/scope, or context ~250k. Rule is in CLAUDE.md s2 "NO REPORT BEFORE THE NEXT ITEM".
