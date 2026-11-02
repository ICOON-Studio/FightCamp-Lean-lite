---
name: feedback_check_for_a_zombie_agent_process_first
description: "a launch that reports a pid but spawns no real agent process is often a stale/zombie process from an earlier session blocking a single-instance lock, not a broken launcher"
metadata:
  node_type: memory
  type: feedback
  originSessionId: b8add24e-181e-45ff-b1e9-727b687ee8cf
  modified: 2026-10-02T09:17:36.773Z
---

S141: `Tools/agent_window.ps1` reported `launched 'CURSOR U210' pid=XXXXX` twice, but no `cursor-agent`
process ever appeared for the U210 workspace (`Get-CimInstance Win32_Process | Where CommandLine -like
'*cursor-agent*'` showed nothing new) and no output file was ever written. The real cause: a
`cursor-agent` process from a PRE-SESSION U208 launch had been running for hours (since before this
session started, likely hung after its actual work finished and committed) and was silently holding a
lock that blocked any new launch through the hidden-window wrapper.

**Fix:** find the stale process (`Get-CimInstance Win32_Process | Where CommandLine -like '*<agent
name>*'` - check `CreationDate` against when THIS session's task was briefed, not just whether a
process exists), kill it by PID only (never by image name - other legitimate instances may be
running), then relaunch. If the hidden-window launcher (`agent_window.ps1`) still fails silently after
that, a direct foreground invocation of the underlying `*_task.cmd` (no `agent_window.ps1` wrapper)
will show the real error instead of swallowing it, and works as a fallback.

**How to apply:** before concluding a launcher script itself is broken, check for a zombie process from
an EARLIER session first - it is the more common cause and the fix is a one-line kill, not a script
rewrite. See [[feedback_verify_live_state_not_notes]] and [[feedback_check_the_worktree_when_an_agent_dies]].
