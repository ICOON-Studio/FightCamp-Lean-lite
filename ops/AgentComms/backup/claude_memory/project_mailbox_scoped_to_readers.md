---
name: project-mailbox-scoped-to-readers
description: "The agent mailbox carries Claude, Codex and John only; Grok, Kalli and Maria have no shell and are reached through TASKS.md"
metadata: 
  node_type: memory
  type: project
  originSessionId: 234fb1ee-ad4b-486c-9664-062c24ae74d2
  modified: 2026-09-07T10:26:02.076Z
---

Scoped 2026-09-07 (commit `b9cedc3`). `Tools/agent_comms.py` has `MAILBOX =
{codex, claude, john, all}` separate from `AGENTS`. `--to`, `inbox --agent` and
`ack --agent` refuse anyone else; `--from` stays open because that is Claude
relaying their report into the mailbox.

**Why:** a Grok, Kalli or Maria session runs off the GitHub API with **no Windows
shell**, so it cannot run `agent_comms.py` at all. 25 messages had sat unread
forever (maria acked 0 of 16, kalli 1 of 7, grok 0 of everything) while `board`
and `brief` kept carrying them.

**How to apply:** assignment and the mailbox are different things — all six are
assignable, but only mail an agent that reads mail. Grok, Kalli and Maria are
reached through root `TASKS.md` plus their own `research/TASK_<id>.md`,
and Grok additionally through the `## GROK START HERE` block in `HANDOFF.md`.

Landed in the same chore as `agent_comms.py sweep` — see
[[project-handoff-sweep-command]]. Related:
[[feedback-codex-assignment-prompt]].
