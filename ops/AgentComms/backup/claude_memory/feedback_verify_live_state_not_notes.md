---
name: feedback-verify-live-state-not-notes
description: Operator 2026-09-27 "i do not want ever to see you guided by outdated information" - check live state before stating availability/status, then check again
metadata:
  type: feedback
---

Before telling the operator anything about an agent's availability, a quota, a blocker or a run's state, READ THE LIVE
SOURCE (Codex meter in ~/.codex/sessions rollouts, the operator's latest word in chat, the process list, the branch),
never a roster note, a blocker file or a handover line. When a record disagrees with memory or the operator, the record
is stale: fix it on the spot (roster.json note, `agent_comms.py unblock`, roadmap, memory file) and then run a second
check (`agent_comms.py start` + grep the records) to prove nothing stale remains.

**Why:** S97 (2026-09-27) told the operator Codex was paused until 10-01 and Kalli/John/Maria were blocked, reading
roster notes and blocker files - while memory already said Codex reset on 09-26 and the operator had said the Grok Bot
limit reset. Operator: "we already been through that ... you still have 2 days old log that you follow wtf". Then:
"update your records ... when you do that do another check to make sure".

**S98 repeat (2026-09-27):** S97 then over-corrected - it flipped Kalli/John/Maria's ops-board toggles ON from a note, and S98 sent a task to John without checking the board or the app meter. Operator: "do you even check opsboard what is selected and what not ?". The board toggle is the operator's; read it (`curl 127.0.0.1:8787/api/roster`) and never write in_rotation yourself.

**How to apply:** every session start and every handover: verify each agent's state from its live source, correct any
stale note in the same pass, then re-run the check. Also: when the operator says the nightly suite is running, launch
nothing heavy until it ends. Related: [[codex-allowance-2026-09-26]], [[project-shell-less-agents-unavailable]].
