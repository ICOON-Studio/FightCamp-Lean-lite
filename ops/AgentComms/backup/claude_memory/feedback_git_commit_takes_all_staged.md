---
name: git-commit-takes-all-staged
description: "A plain `git commit` commits EVERYTHING staged, not just the files just `git add`ed; use `git commit -- <paths>` or check `git diff --cached --name-only` first"
metadata:
  node_type: memory
  type: feedback
  originSessionId: c8680409-62b0-495a-8631-8ca66a0536f8
  modified: 2026-10-05T09:36:08.396Z
---

S162b: `git checkout origin/<branch> -- files` stages them. My next `git add -- one.md; git commit -m ...` then swallowed 12 unrelated staged test files (G158) and I pushed them (3 of those tests were red).

**Why:** the CLAUDE.md rule "stage explicit paths" is not enough when something is already staged (a checkout of a branch's files, an agent's work).
**How to apply:** before every commit run `git diff --cached --name-only`; commit with `git commit -m ... -- <paths>`. Related: [[feedback_shared_index_git_add_gotcha]].
