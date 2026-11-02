---
name: feedback-ask-pending-issues-at-start
description: Operator S181 - first message of every session asks every open board question + awaiting_operator item, beside the queue; questions answerable on 8787/ main page
metadata:
  type: feedback
---
Operator 2026-10-09 (S181), verbatim: "always ask for pending issues at start of new session and also add option to answer pending questions on theopsboard".

**Why:** S181's start printed QUESTIONS STILL OPEN (Q-S179-1) and the first message stated only the queue - the question sat unasked. The S178 answer box (OPSBOARD1) lived on /old only after S157 made roadmap.html the main page, so he never saw it.
**How to apply:** first message = queue + every open question from `start` + roadmap awaiting_operator. New questions go on the board via `python Tools/agent_comms.py ask "<text>" --options "a|b"`; he answers at 8787/ ("Questions for you", roadmap.html); `start` prints his answers once. See [[feedback_opsboard_is_the_roadmap]].
