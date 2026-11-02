---
name: feedback-never-take-whole-files-from-a-branch
description: S98 wiped S97's engine: `git checkout <branch> -- file` takes the branch's WHOLE file (older base) AND stages it, and a later plain `git commit` shipped it
metadata:
  type: feedback
---

To bring an agent's change in, apply ITS DIFF, never its file:
`git diff $(git merge-base HEAD <branch>) <branch> -- <files> | git apply --3way`.

**Why:** S98 (2026-09-27) ran `git checkout cursor/u189-kb-leg-share -- FightRealtime.gd FightMoves.gd`. The branch was
cut before S97, so the checked-out file silently dropped S97's 137 lines of limb damage; the checkout also STAGED it.
A later `git add -- <records> && git commit` (no paths on the commit) swept the staged engine files into a "records"
commit (95c5d221) and pushed a master without limb damage. Caught only because the ON-vs-OFF census came out identical
with 0 corner minutes. Repaired in 50b002ce.

**How to apply:** (1) diff + `git apply`, never whole-file checkout from a branch; (2) before EVERY commit run
`git diff --cached --name-only` and commit only when the list is exactly what the message claims; (3) an ON arm that is
byte-identical to OFF is a wiring failure until proven otherwise. Related: [[feedback-shared-index-git-add-gotcha]].
