---
name: feedback-no-apply3-in-shared-checkout
description: S206 - `git apply -3` in the shared main checkout left UU/A index entries that blocked the parallel floor session's commits
metadata:
  type: feedback
---
S206: collecting Codex ANIMFATIGUE1 with `git apply -3` (it overlapped the just-merged ANIMSCURVE1 in FightStagePlayer.gd and
record_room.gd) wrote conflict state into the SHARED index: two files UU, the new files staged A. The floor-redesign session in the
same checkout could not commit until Claude cleared it (`git reset -- <paths>`, working tree kept).

**Why:** the main checkout is shared by several Claude sessions; the index is global, the working-tree edits are not in its way.

**How to apply:** apply agent diffs with plain `git apply` (no -3, no --index); when it fails on overlap, apply to a temp copy or
resolve the hunks by hand in the working tree, then stage ONLY at commit time with explicit paths. Never leave staged or unmerged
entries between commands. Related: [[feedback_check_master_before_calling_a_branch_uncollected]].
