---
name: feedback_sessions_are_not_cleared
description: operator opens a NEW session instead of clearing - the old one stays alive beside it; hand over with nothing running in the main checkout
metadata:
  node_type: memory
  type: feedback
  originSessionId: baad23f5-3a36-4178-acb6-7644d3d9d094
  modified: 2026-09-24T22:12:05.297Z
---

The operator does not /clear; they start a new session while the old one stays open (said 2026-09-25, S71, and AGAIN
in S73: "i never clear i makenew session" - after I wrote "You can clear now" a dozen times).

**WORDING: never write "clear" / "you can clear now". Write "Start a new session with:" before the handover block.**

**Why:** anything the old session leaves running (suite, waiters, uncommitted edits in the shared checkout) collides with the new session's `git pull` / `start` / suite.

**How to apply:** before giving the handover block: suite finished, `ps -eo args | grep -c '[s]leep'` = 0, everything committed + pushed, working tree clean of my files; agents left running only in their own worktrees on their own branches (never master); after `agent_comms.py ship` the old session touches nothing. Related: [[feedback_handover_prompt_is_one_block]], [[feedback_new_session_per_shipped_stage]].

**THE NEW SESSION OWNS THE OLD SESSION'S AGENT RUNS (operator, 2026-09-25, S76):** "you should handle new sessions
properly ... if you leave agents running". S76 called Q175/C202 "stopped" from a process scan that missed them (the
roster already said RUNNING), then messaged the old session asking what it held. Never do either. `agent_comms.py start`
prints "AGENT RUNS IN FLIGHT - THEY ARE YOURS NOW" from worktree write times; trust it, collect when they land. At
handover, list every run still in flight INSIDE the block.
