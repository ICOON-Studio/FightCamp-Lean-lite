---
name: project-cursor-pushes-to-branches
description: "Cursor ships on its own remote branch and its agent_comms mail rides the branch, so Claude's inbox reads unread=0 — check git branch -r, never the inbox"
metadata: 
  node_type: memory
  type: project
  originSessionId: 5ed0ae59-17fb-4d50-b407-f35cde3f00eb
  modified: 2026-09-08T19:05:11.299Z
---

Cursor pushes finished work to `cursor/<task>-<hash>`, not to master, and its
`agent_comms.py send` message file is committed **on that branch**. Master's
mailbox therefore never sees it: `python Tools/agent_comms.py inbox --agent
claude` reports `unread=0` while a completed task sits waiting.

This cost a session on U15 (2026-09-07) and again on U16 (2026-09-08).

**Why:** the mailbox is files in `AgentComms/messages/`, so mail is only visible
from the branch it was committed on. Nothing is wrong with the tooling — the
inbox is answering honestly about master.

**How to apply:** when the operator says Cursor finished, run `git fetch origin
--prune && git branch -r` FIRST, then `git log --oneline master..origin/<branch>`
and `git diff master...origin/<branch> --stat`. `python Tools/agent_comms.py
triage` reports this class directly ("branch-only mail", "unmerged remote
branches") and is the cheapest single check. Merge with `--no-ff`, then ack the
mail by its id once it is on master.

Corollary for auditing old branches: a branch whose work was hand-spliced onto
master still shows commits ahead **forever**, so `master..branch` never empties.
Compare blob-by-blob (`git rev-parse master:<file>` vs `origin/<b>:<file>`),
never by ancestry. See [[project-legacy-scenes-discarded]] before concluding an
absent file is lost work — `r21-gym-hub` looks like lost scenes and is not.
