---
name: feedback_codex_launch_needs_codex_repo
description: codex_task.cmd runs in the MAIN checkout unless CODEX_REPO is set - set CODEX_REPO=<worktree> + CODEX_ADD_DIR=<main .git>
metadata:
  node_type: memory
  type: feedback
  originSessionId: fe303029-85b2-4be6-8131-da16524e6bd5
  modified: 2026-10-09T23:51:48.246Z
---

`Tools/codex_task.cmd` uses `-C "%REPO%"` with REPO = the main checkout (C:\...\Game) unless `CODEX_REPO` is set. S191 launched
LUDO-DOC2 with only CODEX_MODEL set -> Codex sat in the shared master checkout (caught within 2 min, killed by PID tree, nothing written).

**Why:** a Codex run in the main checkout can edit/commit on master beside other sessions; the worktree in the prompt text does not move
its sandbox.

**How to apply:** launch from PowerShell with `$env:CODEX_MODEL='gpt-6.1-sol'; $env:CODEX_REPO='E:\FightCamp\wt\<NAME>';
$env:CODEX_ADD_DIR='C:\Users\user\OneDrive\Documents\ChatGPT\Game\.git'` then agent_window.ps1; verify the live process shows
`-C "E:\FightCamp\wt\<NAME>"` and `--add-dir ...\.git`. Related: [[feedback_codex_use_sol_not_astra]], [[feedback_worktree_per_agent]].
