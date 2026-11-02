---
name: feedback_handover_duties
description: "Handover: ASK the operator first (they may want to keep going), run TWO stale-state checks, memorize the session, every agent holds a task"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3b45bd81-8863-4c4d-99a8-c74c5c175c68
  modified: 2026-09-21T23:23:41.887Z
---

**UPDATE 2026-09-27 (S97), operator verbatim: *"always 2 checks before handing over , always memorize session, and
before doing the handover ask , i maybe want you to kewep going on the same session"*.** So before the handover block:
(1) ASK whether to hand over or keep going in this session - never send the block unasked; (2) run TWO checks that
no record is stale - `agent_comms.py start` output grepped for paused/blocked/out-of-quota/RUNNING/SENT lines, and each
agent's live state (meter, process, branch) - fixing roster.json notes AND roadmap.json `handover.agents` /
`handover.settings` (a SECOND copy of every agent note that `start` prints) between checks; (3) memorize the session.
See [[feedback-verify-live-state-not-notes]].


Operator, 2026-09-22, verbatim: *"new rules: everytime you giveme the prompt
fornew session you memorize the session without me reminding you . In the new
session all agents need to have tasks"*.

**DUTY 1 — MEMORIZE THE SESSION, UNPROMPTED, AND SAY SO IN THE HANDOVER
MESSAGE.** Appending this session's block to [[project_session_log]] is part of
emitting the handover, not a favour to be asked for. It happens in the same
action as the block, every time. Do not wait to be reminded and do not ask
whether to do it.

**And CONFIRM it explicitly in the same message as the prompt** (operator,
2026-09-22: *"you always have to confirm me that you memorized the session when
giving me the prompt for next session"*). One line naming what was written and
where — not "done", but the file and the substance. The operator cannot see the
memory directory, so a silent write is indistinguishable from a skipped one, and
they should not have to ask.

**DUTY 2 — EVERY AGENT HOLDS A TASK AT HANDOVER.** The next session must open
with no idle agent. Assigning them is the CURRENT session's job, done before the
handover goes out, not homework left for the next one.

**THIS REVERSES THE 2026-09-21 IDLE-AGENT RULING** recorded in
[[project_roster_2026-09-21]] and in `CLAUDE.md`'s "AN IDLE AGENT IS NOT A
FAILURE - MANUFACTURED WORK IS". That ruling stood for one day. Where the two
conflict, this one wins.

**How to apply:** the quality bar from the reversed rule is still the right
instinct, so satisfy both — give every agent a task, and make each a REAL slice
rather than 130 lines of spec for a 60-line digest. The operator's own default
for an agent with no technical slice still holds: *"whoever doesnt have a task
assign him to evaluate the project progress and give you suggestions or
corrections"*, each reviewer pointed at a DIFFERENT angle or four of them return
one report. Roster authority is the ops board, not `roster.json` — see
[[project_roster_2026-09-21]].

**Why:** the handover is the one moment both duties are cheap and the one moment
forgetting them is expensive — the next session opens cold, and an agent with no
task stays idle for that whole session because nobody is there to notice.
