---
name: cursor-one-task-per-launch
description: "Cursor's cursor-agent -p must be launched one task per PowerShell background command; a sequential \"task A; task B\" launcher hangs after A exits with no child process and never starts B"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6bfe5dac-0993-4c52-8a25-9f9c8967fd1d
  modified: 2026-09-10T02:18:01.740Z
---

Launch Cursor with ONE task per `run_in_background` PowerShell command. On
2026-09-10 a launcher of the form `& cursor-agent ... $p1 *> a.out; & cursor-agent ... $p2 *> b.out`
finished U30 (output complete, commit pushed) and then sat as a zombie
`powershell.exe` with no child process, never writing its `.done` marker and
never starting U29. Killing it and relaunching U29 fresh worked immediately.

**Why:** cursor-agent's exit does not release the PS 5.1 pipeline the way a
normal native command does; the second invocation is never reached.

**How to apply:** one launch per task; verify the agent is alive with
`Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*cursor-agent*' }`
(the process is `node.exe`, not `cursor-agent.exe`), and treat "no child
process + no `.done`" as hung. Same shape as [[feedback-drive-qwen-and-grok-to-delivery]].
