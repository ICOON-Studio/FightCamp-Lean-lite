---
name: feedback-seed-worktree-import-cache
description: S206 - seed every new agent worktree with Tools/seed_godot_cache.ps1 before launch; a fresh worktree's full Godot import drove the PC to 87 C
metadata:
  type: feedback
---
S206: with 2 Codex sol runs live the PC hit RED (87 C sustained, CPU 100%; operator limit 84 C). The heaviest process was Codex
ANIMFATIGUE1's full `godot --editor --import` in its fresh E: worktree (no .godot cache). Claude suspended that run's process tree
(NtSuspendProcess - frozen, not killed), killed only the import, seeded the cache (5.2 GB in 58 s, disk only) and resumed it.
Operator, asked whether animation runs could move to GitHub (they need 0.9 GB of LFS bodies/clips the cloud runs skip, and cloud
Codex bills the API key): "stay on the plan, do the cache fix and see how it goes".

**Why:** a fresh worktree re-imports the whole project (4.4 GB) on its first Godot command - pure CPU heat for nothing.

**How to apply:** after `git worktree add`, run `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\seed_godot_cache.ps1
-Worktree E:\FightCamp\wt\<NAME>` BEFORE launching the agent (CLAUDE.md s8, AGENT_TOOLS.md "Worktree setup"). When the watchdog goes
RED mid-run: suspend (not kill) the heaviest agent tree, fix the cause, resume. Related: [[feedback_pc_limits_80c]],
[[feedback-codex-use-sol-not-astra]].
