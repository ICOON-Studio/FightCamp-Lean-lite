---
name: project_cursor_preferred_build_agent
description: Operator ruling 2026-09-07 - Cursor is the preferred build agent over Codex; it CANNOT push master, so always merge its branch
metadata: 
  node_type: memory
  type: project
  originSessionId: 17e38d28-a4b3-4991-89d5-eece6c0326de
  modified: 2026-09-08T12:28:43.944Z
---

Operator ruling, 2026-09-07: **Cursor is powerful and far more token-friendly
than Codex — use it to its maximum.** Modules and screen work go to Claude and
Cursor; Codex gets the leftovers (engine follow-ons), not the bulk.

**Cursor CANNOT push `master`.** Its cloud environment insists on a
`cursor/*` branch — confirmed by Cursor itself in the U11 digest, 2026-09-08,
after a task file told it to push master. So a "push to master" instruction is
unachievable and just costs a round trip. Ask instead for: push the branch, and
**name the branch in the first line of the mail**. Claude fetches, merges, runs
the suite and writes Cursor's HANDOFF block.

**Why this matters beyond tidiness:** mail written on a branch is invisible to
`agent_comms.py inbox`. U3, U5 and U8 all reported correctly onto branches;
two sat unread for a day and U5's carried two live defects nobody knew about
until R67 recovered them 2026-09-08. `python Tools/agent_comms.py triage` is
what finds this — it lists unmerged branches and flags BRANCH-ONLY MAIL — so
run it at the start of a session, not just when something feels missing.

**How to apply:** when splitting a cycle, give Cursor the largest share of the
screen/module tasks it can own without two agents sharing a file, state the
owned-file split in BOTH task files when two run in parallel, and expect to do
the merge yourself. See [[project_codex_capacity]] and
[[feedback_codex_assignment_prompt]] — Cursor takes the same start-prompt form
as Codex (it is a full mailbox citizen with a shell), unlike
Grok/Kalli/Maria/John.
