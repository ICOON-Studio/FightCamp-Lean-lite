---
name: feedback_worktrees_on_d
description: "Agent worktrees ate ~100 GB of C: (51 x ~3 GB in %TEMP%\\FightCamp-*); create new ones on D:\\FightCamp\\wt and archive+remove on collection with Tools/worktree_archive.py"
metadata:
  node_type: memory
  type: feedback
  originSessionId: d799320e-f0b6-4f10-84f3-7b7759c7f6d7
  modified: 2026-09-29T00:54:49.875Z
---

Operator 2026-09-29 (S122): "i had 80 gb free yesterday on c wtf happenned ?" - C: fell to 11.9 GB because every
agent task got a `git worktree add ../../../../AppData/Local/Temp/FightCamp-<id>` (full checkout + Godot `.godot`
import cache, ~3 GB; C199 14.8 GB) and none was ever removed: 51 dirs, ~100 GB, 27 created on 09-28 alone.

**Why:** the drive rule (nothing new on C:; bulk on D:) was never applied to worktrees, and collecting a task never
included removing its worktree.

**How to apply:**
- New agent worktrees: `git worktree add D:/FightCamp/wt/<ID> -b <branch> origin/master` - never %TEMP% on C:.
- When a task is COLLECTED (merged or retired): `python Tools/worktree_archive.py --keep <in-flight ids>` - it
  bundles commits not on origin, saves uncommitted diffs and untracked files to D:\FightCamp\worktree_leftovers\<name>,
  then removes the worktree. Nothing is lost; branches stay.
- Watch C: free space in pc_watchdog output at session start; AMBER means look for this first.
Related: [[project_pc_drives]], [[feedback_check_pc_before_heavy_jobs]].
