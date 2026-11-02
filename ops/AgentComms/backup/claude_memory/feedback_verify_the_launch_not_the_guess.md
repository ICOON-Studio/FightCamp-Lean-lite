---
name: feedback_verify_the_launch_not_the_guess
description: "2026-09-22 - reported \"qwen may have died\" from a grep that could never have matched; the launcher had silently taken my wrong argument order. Prove an agent STARTED, and never report a guess as status"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 9e3da6ad-2507-4165-a508-3ceb3183e36d
  modified: 2026-09-21T21:41:59.842Z
---

**The operator's reaction was *"what the fuck are you talking about?"*, and they
were right.** I handed over a status table with two rows that were guesses
dressed as facts:

- *"Q127 qwen — Out. No output and no process — may have died, relaunch"*
- *"G61 grok — Out, running in the browser"* — written immediately after I had
  **closed the browser**, and without ever looking. Grok had finished in 37
  seconds with 72 sources.

## Two separate failures, and the second hid the first

**1. The launcher took a wrong argument order silently.** `Tools\qwen_task.cmd`
is `<prompt-file> <workspace-dir> [out-file]` — **three** arguments. I called it
with Codex's **two**-argument shape (`codex_task.cmd <prompt> <out>`), so the out
file was passed as the workspace and Qwen exited at once. **Each launcher has its
own signature; read the `REM Usage:` line before every launch rather than
assuming they match.**

**2. My check could not have detected it either way.** I ran
`ps -eo args | grep -c '[q]wen'` from Git Bash and got 0. **Git Bash's `ps` does
not show Windows process command lines**, so that check returns 0 whether Qwen is
running or not — a control that cannot move. The real check is
`Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*qwen*' }`.

So a wrong conclusion and a worthless check agreed with each other, which felt
like confirmation. Same shape as [[feedback_a_control_that_cannot_move]].

## How to apply

- **After launching any agent, prove it STARTED** before reporting anything:
  `Get-CimInstance Win32_Process` for a live process with the right command line,
  or a growing out-file. A `Start-Process` that returns is not evidence.
- **Read the out file, never the rc** — `qwen_task.cmd` says so in its own
  header: Qwen prints a `--yolo` warning that makes the shell report exit 1 on a
  perfectly successful run.
- **Never write a status row you did not look at.** "Out", "running", "may have
  died" are not statuses. Either check, or say plainly "I have not checked."
- Related: [[feedback_open_the_output_before_the_gate]],
  [[feedback_ready_true_is_not_proof_it_launches]],
  [[feedback_check_the_worktree_when_an_agent_dies]],
  [[feedback_cursor_one_task_per_launch]].
