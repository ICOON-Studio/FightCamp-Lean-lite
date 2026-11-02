---
name: feedback_shared_checkout_head_moves
description: "An agent that branches leaves the shared checkout on its branch; your commits silently land there and `git push origin master` says \"Everything up-to-date\""
metadata: 
  node_type: memory
  type: feedback
  originSessionId: b4879ea1-75bc-4eb5-baa2-4cda71accd1f
  modified: 2026-09-10T11:30:15.137Z
---

In the FightCamp shared checkout, an agent (Cursor, 2026-09-10) created
`cursor/u34-judo-board-caller` and left HEAD on it. Six subsequent commits —
three of them Claude's — landed on that branch instead of `master`, and
`git push origin master` answered **"Everything up-to-date"**, truthfully.

**Why:** the failure is silent from every angle. `git status` shows clean, the
commits succeed, the push reports success, and `git log --oneline -1` shows your
commit exactly where you expect it. The branch switch also takes uncommitted
edits to shared files with it, which looks like a lost write and gets
misdiagnosed as a concurrent-write race.

**How to apply:**
- Before believing a commit went where you meant:
  `git rev-parse --abbrev-ref HEAD`, and compare
  `git log --oneline origin/master -1` against your own HEAD — never trust a
  quiet push.
- Write a `HANDOFF.md` block and **commit it in the same breath**. Every block
  committed within seconds survived; the one left dirty vanished.
- Recovery is a fast-forward, not a rescue: `git checkout master && git merge
  --ff-only <branch>`. Do it **after** any running suite finishes, because the
  checkout would otherwise revert files under the gate. See
  [[project_cursor_pushes_to_branches]] and
  [[feedback_shared_index_git_add_gotcha]].
