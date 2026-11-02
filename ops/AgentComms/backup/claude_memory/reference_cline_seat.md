---
name: reference-cline-seat
description: "Cline CLI seat set up 2026-10-02 - worktree E:/FightCamp/wt/CLINE, Tools/cline_task.cmd, free OpenRouter stealth/space-bunny-alpha until 2026-10-05"
metadata:
  node_type: memory
  type: reference
  originSessionId: 698f888a-d3b1-4e30-a098-36127d223971
  modified: 2026-10-03T07:42:00.553Z
---

Operator 2026-10-02 (S148) "do these": `npm i -g cline` (3.0.68), worktree E:/FightCamp/wt/CLINE (branch cline/seat), launcher Tools/cline_task.cmd <prompt-file> <out-file> (fd5976f4).
Model: OpenRouter `stealth/space-bunny-alpha`. It is free, has a 1M context and tool calling, and EXPIRES 2026-10-05. Its anonymous provider may keep prompts, so give it no sensitive work.
The key is the operator's. He runs `cline auth openrouter -k <key> -m stealth/space-bunny-alpha` once. Claude never handles the key.
Cline has NO sandbox and auto-approves tools by default. The launcher pins `-c` to the worktree. Still review every diff before merge (check_workflow.py branch).
His Cline desktop app was signed in to Cline Hub billing Claude Sonnet 5 (paid) with folder = system32. Told him to change both.
After 10-05: CLINE_MODEL can switch the model, but any paid model is an operator money call.

S148 late FIX: Claude's `npm i -g cline` is in the SHELL SANDBOX ([[project-shell-sandbox-split]]). The operator's window cannot see it, so `cline auth` from his side is impossible. Instead the operator double-clicks Tools/cline_set_key.cmd, which writes %USERPROFILE%/.fightcamp/openrouter_key.txt. cline_task.cmd reads that file and passes it with -P openrouter -k per run. Test: CLINE_OK. U214 launched 23:39 at idle priority.

S153 TRAP: `Tools\cline_task.cmd` run directly (AGENT_WINDOW unset) runs Cline INLINE in Claude's shell - it dies when the 30-min background job ends. Launch from the PowerShell tool (bash eats the backslashes): `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\agent_window.ps1 -Title "CLINE <ID>" -Command Tools\cline_task.cmd -ArgumentString "<prompt>|<out>"` - it prints `launched ... pid=N`.
