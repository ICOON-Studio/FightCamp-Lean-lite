---
name: feedback_codex_desktop_app_locks_sandbox
description: "Codex CLI runs die in 20 s (\"helper_unknown_error: setup refresh had errors\") while the Codex desktop app is open - fixed in codex_task.cmd via an empty LOCALAPPDATA"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e0c13d63-ac59-432c-a3b8-822d3dedd70c
  modified: 2026-10-09T19:07:27.824Z
---

A Codex launch that "runs" but leaves 0 edits: read `~/.codex/sessions/<date>/*.jsonl` last_agent_message and `~/.codex/.sandbox/sandbox.<date>.log`. S188: CLI 0.162.0's sandbox setup re-ACLs `%LOCALAPPDATA%\OpenAI\Codex\runtimes\...\node_repl.exe`, which the operator's open Codex desktop app locks (os error 32), so no shell command ever ran.

**Why:** S187 reported SPLIT1/GATES1 "RUNNING" for a session while both had died in 20 s - the rc and the live_runs entry said nothing.

**How to apply:** `Tools/codex_task.cmd` now sets `LOCALAPPDATA=E:\FightCamp\codex_localappdata` for the CLI only; never close the operator's Codex app. Check a run's sandbox log within minutes of launch. Related: [[feedback_check_for_a_zombie_agent_process_first]], [[feedback_codex_use_sol_not_astra]].
