---
name: feedback_pure_pr_collect_cheaply
description: check_workflow on a no-worktree branch runs a full Godot editor import and overheated the PC (88 C); collect pure new-file PRs by diff + parse + one test
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2e79d2d5-4ac1-4d72-b5dd-e71fde852ec6
  modified: 2026-10-11T12:30:04.568Z
---

S200: `check_workflow.py branch arena/<id>-fightcamp` extracted the branch to E:/FightCamp/tmp/fightcamp-branch-gate-* and ran a
headless Godot `--editor` import (758 CPU-s, 8 GB on E:), pushing the PC to 88 C / CPU 100% - over the operator's 84 C limit.

**Why:** the gate builds a whole project import for a branch with no worktree, even when the PR only adds 2 pure files.

**How to apply:** for an Arena/Qwen PR that only ADDS its own files (git diff --name-status shows only A), apply the diff on
master, run check_scripts.py on the files and the one test, check CI is green, merge, close the PR. Use check_workflow when a
PR modifies existing files or a worktree exists. Run the watchdog before and kill by PID if it goes RED; delete leftover
fightcamp-branch-gate-* dirs. Also: agent_window -ArgumentString separates paths with `|`, never a space.
Related: [[feedback_watchdog_gate_before_launch]].
