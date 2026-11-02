---
name: feedback_session_start_is_one_command
description: "A fresh session runs `python Tools/agent_comms.py start` and then KNOWS what to do - never ask the operator what to work on"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ae7d7ea0-43f4-42ae-99e8-02cde6bb42a1
  modified: 2026-09-12T06:40:03.252Z
---

Operator rule 2026-09-12: **`python Tools/agent_comms.py start` is the whole
session-start orientation, and after running it you do not ask what to work
on.** Their words: *"next time you should put the command that will
automatically put you on track, this should have not happened once you read
the board on a fresh session you need to know exactly what to do and not ask
me"*.

**Why:** the session opened on `127.0.0.1:8787`, read the ops board, and still
replied "where do you want me?" with three options. The board renders
`AgentComms/roadmap.json` for the OPERATOR'S PHONE and does **not** render its
`handover` block - which is the half a session needs (who holds what, what is
uncollected, which agent's claims to distrust, what is already decided). So the
session saw `now` and the blocked questions and still felt underinformed. Asking
put the operator back in the seat the direct-reach ruling exists to empty.

**How to apply:** run `start` first, every session. It derives everything from
`roadmap.json` + `roster.json` + the live board, so it cannot go stale. `now`
tells you the work; `blocked_on_operator` is the ONLY thing genuinely theirs to
answer, and those get asked once, early, together - not as a menu of options.
Ending a session means updating `now`/`next`/`handover` and running
`Tools/render_roadmap.py`, or the next session starts blind. See
[[feedback_handover_prompt_is_one_block]], [[project_roadmap_and_opsboard]] and
[[feedback_collect_before_you_assign]].
