---
name: feedback_retire_worktrees_on_merge
description: S211 E: hit 1.0 GB free (agents writing) - each agent worktree is ~7.3 GB (17 GB for MH4); retire it the session its branch merges
metadata:
  type: feedback
---

Operator S211: "fix space on e". E: had 1.0 GB free with 3 agents writing; 17 stale worktrees under E:\FightCamp\wt held ~55 GB.
Freed to 63 GB by removing worktrees whose HEAD was on origin and had no real uncommitted work (ignore *.import/*.uid/.godot).

**Why:** every seeded worktree carries the 4.4 GB import cache + checkout (~7.3 GB; MH4 17 GB). They pile up after merges.

**How to apply:** when you merge or close an agent branch, `git worktree remove --force E:/FightCamp/wt/<ID>` the same session
(check `git branch -r --contains HEAD` and `git status --porcelain` first). Codex sandbox ACLs make the delete fail with
"Permission denied" after git deregisters it: `icacls <dir> /reset /T /C /Q` then Remove-Item -Recurse -Force (only after the
pushed+clean check). Check E: free space at session start beside the watchdog. Related: [[feedback_seed_worktree_import_cache]].

**S223 (2026-10-14, operator "free up space on e: remove old branches"):** E: 14 -> 81 GB by retiring 9 worktrees + 6 stray
leftover folders. Method that worked: push every unpushed commit first (a diverged branch -> push to `<branch>-local-s223`), save
`git diff` + untracked (non .uid/.import/.godot) as tar with `tar --force-local` (plain tar reads "E:" as a remote host) into
E:/FightCamp/wt_retired_s223/, then `git worktree remove --force`; when that says "Permission denied" (Codex sandbox read-only
files) use `cmd /c "attrib -r -s -h <dir>\* /s /d & rd /s /q <dir>"`. `du -sh` on 7 GB worktrees takes >10 min - skip it.
Remote branches cost no disk; deleting them on GitHub is a separate, outward call.
