---
name: run-jobs-in-terminal-background
description: "S215 operator wants long/heavy commands run in the background or a visible terminal tab, never gated on approval clicks; sessions run on bypass permissions"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 5542dd9f-b563-4266-b577-1f08c4efa1fb
  modified: 2026-10-12T21:57:19.534Z
---

Operator S215 (frustrated that commands were not going through the terminal): "you are set to bypass permissions i do not want to get interrupted can you work this on the background on every new session?"

**Why:** he watches the Terminal panel beside the chat and wants no approval interruptions; bypass permissions is on, so a terminal command needs no click (run_in_terminal ran unprompted). I wrongly said every command would wait for approval.
**How to apply:** every session, run tests, suites, the watchdog, router checks and other long jobs in the background (Bash `run_in_background`) or in a visible tab via `mcp__terminal__run_in_terminal` (one-line commands, `Set-Location '<repo>'; <cmd>`; cwd outside the working dir is refused, so cd inside the command). Keep Bash for short reads whose output is needed this turn. Never type into a tab that holds a Claude session (tab c1 = jev). Desktop sessions are not routed by Jev ([[reference_jev_router]]); routed work = `jev` in a terminal.
