---
name: project_qwen_and_grok_reachable_in_app
description: "ALL FOUR agents - Qwen, Grok, Codex and Cursor - run inside Claude's own console. Claude writes AND executes every task with NO human input, and the session needs only ONE prompt: Claude's. Read at the start of every session."
metadata: 
  node_type: memory
  type: project
  originSessionId: dbb0878c-04f8-4381-a15f-a1bdc24b682c
  modified: 2026-09-12T23:19:54.266Z
---

**Widened 2026-09-10 from "Qwen and Grok" to ALL FOUR.** The filename is
historical; the scope is the whole roster.

Operator instruction, first given 2026-09-09 and extended 2026-09-10:
**Claude assigns, launches and drives every agent DIRECTLY, WITHOUT HUMAN
INPUT. One prompt per session — Claude's — and it covers writing each task
file AND executing it.** Do not hand the operator a copy-paste start prompt
for anybody; that puts them back in the relay seat, which is what this rule
exists to stop.

| Agent | Launch |
| --- | --- |
| **Qwen** | PowerShell, backgrounded: `& "$env:LOCALAPPDATA\qwen-code\bin\qwen.cmd" --yolo -p $prompt *> <out>`. **`--yolo`, never `auto`** — other modes leave it with no shell tool and it exits having done nothing. One task per launch; a `-p` run finishes and stops. |
| **Grok** | in-app browser (`mcp__Claude_Browser__*`), **Expert** tier. See [[feedback-grok-build-mode-trap]] — Escape does NOT close the model menu, so the next click lands on Build. |
| **Codex** | `Tools/codex_task.cmd <promptfile> <lastmsgfile>`, a committed wrapper an allow rule points at. **Pass BACKSLASH paths** — cmd's `type` cannot read `C:/forward/slashes` and the run dies with "No prompt provided via stdin". |
| **Cursor** | `& "$env:LOCALAPPDATA\cursor-agent\cursor-agent.cmd" --model composer-2.5 -p --force --trust $prompt *> <out>`. **`--trust` is required** or it refuses the directory. `--plan` / `--mode ask` are read-only. Composer's model id is `composer-2.5` (`cursor-agent models` lists them). Pass the prompt as ONE line (`-replace "`r?`n", " "`) with no double quotes inside - it goes through a `.cmd` shim (verified 2026-09-13, U72-U74). |
| **Qwen** | stdin, not `-p`: `Get-Content <file> -Raw \| & "$env:LOCALAPPDATA\qwen-code\bin\qwen.cmd" --yolo -m qwen3-coder *> <out>` (verified 2026-09-13). |

**Workflow (operator, 2026-09-10): write task files during test-wait dead
time, and execute them at the START of the next session.** Waiting on a
9-minute suite run is when the next slate gets authored.

**Capability notes that still bind.** Grok alone has **no checkout and no
Godot**: its work stays pure research or pure modules with zero preloads, it
is never handed a repo test command, and its module and test remain two tasks
from one contract. Qwen, Codex and Cursor all have real shells and run the
gate themselves. **Verify every agent's report rather than trusting it** —
Codex once reported `SUITE fails=214` when the truth was `fails=0`, and Cursor
answered 91 for an 89-line file. **Never run the full suite while another
agent is running Godot**; that contention produces the fake all-failed line.

**Installing their CLIs is NOT Claude's job when a login is involved** — see
[[project-shell-sandbox-split]]. Claude's shell writes outside the repo land
in an invisible overlay, so an install "succeeds" that the operator cannot see
or log into.

Do not re-derive any of this from `ListAgents` — none of them is exposed as a
subagent handle there, and an empty listing is not evidence they are
unreachable. Idle agents are a standing failure: with no build slice ready
they get forecast research ([[feedback_deadend_means_assign_research]]).

Related: [[feedback_drive_qwen_and_grok_to_delivery]],
[[feedback_codex_assignment_prompt]] (superseded), [[project_qwen_build_agent]].
