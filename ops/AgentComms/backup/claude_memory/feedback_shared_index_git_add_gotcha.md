---
name: feedback_shared_index_git_add_gotcha
description: "`git add -- <file>` does NOT bound a commit in the shared checkout; verify with `git show --stat HEAD` every time, and expect the collision from both directions"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 952a1332-4f38-40f2-af5a-c51f402e7b80
  modified: 2026-09-21T08:30:40.530Z
---

**`git add -- <paths>` does not bound what a commit CONTAINS** when another agent
has staged work in the same index. Always verify afterwards with
`git show --stat HEAD` and **read the file list, not the summary line**. RTK's
"N files changed" is not the stat; the stat is.

**Why:** Codex, Cursor and Claude share one checkout and one `.git/index`. Work
another agent has staged is already in the index, so a scoped `git add` followed
by `git commit` sweeps it in.

**It bites from BOTH directions, and 2026-09-21 (S31) hit both in one session:**

1. **You sweep in theirs.** A commit intended for one JSON file reported
   "5 files changed, 2104 insertions" — four of them were Codex's untracked
   C145 deliverables. The insertion count was the tell and it was read as
   "the roadmap is large" instead of being checked.
2. **They delete yours.** Codex then committed against an index predating the
   next commit, so its "C145" commit contained **nothing but the deletion of
   three files** Claude had just added, and it pushed that. Its own report said
   "C145 complete and pushed as `4bfb2ddf`" — true of the hash, false of the
   contents.

**Nothing was lost** because the files were still on disk; `git checkout <sha> --
<paths>` or simply re-adding recovers it. But master carried the deletion for
two commits and origin had it.

**How to apply:** after every commit in the shared checkout, `git show --stat
HEAD` and confirm the file list is exactly what you meant. Before staging, check
`git status -s` for another agent's pre-staged work and `git reset -- <paths>`
it. Never trust an agent's own claim that it pushed its deliverables — verify
the commit contents, per [[feedback_collect_before_you_assign]] and
[[feedback_verify_before_you_trust]].
