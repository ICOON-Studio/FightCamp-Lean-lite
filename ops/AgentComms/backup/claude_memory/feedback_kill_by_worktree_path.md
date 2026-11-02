---
name: feedback-kill-by-worktree-path
description: "never kill Godot/python by image name - it takes down agents' runs; filter by the worktree path in the command line, and use run_in_background, never a bare & in Bash"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 9b3d2f85-758f-4af3-9b48-b756fa89fc89
  modified: 2026-09-27T12:22:01.573Z
---

Stop stray test runs by matching the command line on MY worktree path (e.g. `FightCamp-U171`), never `Stop-Process Godot*`.
In S102 an image-name kill also killed Codex C217's Godot runs. A `&`-backgrounded bash script also survived TaskStop and
raced a second copy in the same worktree - use the Bash tool's run_in_background only, and check for duplicate
`bisect`/`run_tests` processes before relaunching.

**Why:** the checkout is shared with agents; a blanket kill silently breaks their work.
**How to apply:** `Get-CimInstance Win32_Process | ? CommandLine -match '<my worktree>'`, then stop those PIDs.
Related: [[feedback_two_agents_max_idle_priority]].
