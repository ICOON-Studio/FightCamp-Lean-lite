---
name: feedback-mirror-new-info-to-handoff
description: "Whenever the user gives new project/design information in chat, also write it into HANDOFF.md so Codex (the concurrently-working agent) sees it too."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a097cbf7-f586-4498-8789-03364a500757
  modified: 2026-09-02T12:46:26.740Z
---

Whenever the user shares new project information, a design decision, or a
direction change in conversation, mirror it into `HANDOFF.md` (in the
FightCamp project at `C:\Users\user\OneDrive\Documents\ChatGPT\Game`) as a
dated entry, not just as something handled in-session.

**Why:** the user's explicit instruction (2026-08-30): "everytime i give you
new information make sure it is passed to the handoff so codex knows of it
too." Codex is a concurrently-working agent on the same repo that only reads
`HANDOFF.md` for context — it never sees this chat. If new information stays
in-session only, Codex silently works from stale assumptions.

**How to apply:** this applies even when the user hasn't asked me to
implement anything yet — pure information/design-direction sharing still
gets recorded. Before editing, `git pull` and check for concurrent Codex
activity per the standing collaboration protocol already documented at the
top of `HANDOFF.md` itself. Keep the entry factual (what the user actually
said/decided) rather than a full implementation plan, unless they've also
asked for implementation. Commit and push the `HANDOFF.md` update so it's
visible to Codex outside this session.

**Digest format (2026-09-02):** HANDOFF.md is now a one-page DIGEST —
one short block per task (request, what changed, commit hash,
verification), ~100 lines total. Verbose write-ups and all pre-today
history live in `HANDOFF_ARCHIVE.md`; `CURRENT_STATUS.md` is the tiny
sync point for API-side agents. Never let the live file grow long again:
a 13.5k-line HANDOFF overflowed Grok's context via the GitHub API and
locked him in a re-read/summarize loop for 20 minutes. At each day's
start, move the previous day's digest blocks to the archive. Also: push
`master` after every completed task (publication rule) so API-side
agents never build on a stale tree.

See also [[fightcamp-handoff-protocol]] for the fuller collaboration
protocol this project already established.
