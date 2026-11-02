---
name: project_agent_comms_truncation
description: "agent_comms.py exits 0 and prints nothing when truncated - always check its output, never trust rc=0"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 768ab492-6644-44eb-ba34-cdd20f3a13f0
  modified: 2026-09-07T15:11:32.839Z
---

`Tools/agent_comms.py` has no `if __name__ == "__main__"` guard failure mode:
when the file is truncated (2026-09-07, commit `2c80c26` cut it from 599 lines
to 84, and the follow-up "restore" commit `100f50e` only reached 85), every
subcommand **exits 0 and prints nothing**. `tasks`, `board`, `sweep`, `send`,
`inbox` all silently did nothing for hours; three messages to claude sat unread.

**Why:** rc=0 with empty output reads as "nothing to report", which is exactly
what a healthy `inbox` with no mail also looks like. The failure is invisible.

**How to apply:** after any `agent_comms.py` call, confirm the expected marker
line actually printed - `INBOX agent=... unread=N`, `SENT id=...`, `WROTE
TASKS.md`, `ACK id=...`. If a call prints nothing at all, check
`wc -l Tools/agent_comms.py` (should be ~600) before assuming the mailbox is
empty. Restored in `8b7b0e2` from `d1f91b0`. Related: [[project_handoff_sweep_command]],
[[project_mailbox_scoped_to_readers]].
