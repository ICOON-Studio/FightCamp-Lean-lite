---
name: project_roadmap_and_opsboard
description: The plan lives in AgentComms/roadmap.json and renders to ROADMAP.md and the ops board at 127.0.0.1:8787 - read it at session start to know what session you are in
metadata: 
  node_type: memory
  type: project
  originSessionId: 2e96d4ea-3292-48e0-abf9-61469f27415c
  modified: 2026-09-12T04:01:01.841Z
---

**`AgentComms/roadmap.json` is the single source for the project plan** (written
2026-09-12 on the operator's ask for a 5–10 session plan with stage and overall
completion). It carries `now`, `next`, `assessment`, `stages`, `sessions` (each
with an `owner`, a `summary` and a `brief` path) and `blocked_on_operator`.

- `Tools/render_roadmap.py` generates `ROADMAP.md` from it. **Editing the
  markdown by hand is destroyed on the next run, deliberately.**
- The ops board renders the same JSON: `Tools/opsboard/server.py`, reachable at
  **127.0.0.1:8787** and on the LAN for the operator's phone. The operator reads
  it one-handed on an iPhone.

**How to apply:** at session start, read `roadmap.json` to know which session
this is and what its gate is; update `now`/`next`/`status` when a session ships,
and re-run the renderer. An agent is briefed by
`git fetch origin && git rebase origin/master && cat <brief>` and nothing else —
a multi-line prompt passed as a CLI argument arrives **truncated**.

Five stages: **A** the fight is correct, **B** watchable, **C** a broadcast,
**D** the career holds it, **E** ship. The honest completion figures come from
Codex's deep audit and Cursor's televised-MMA gap assessment, are **judgement not
measurement**, and must always be rendered with their attribution.

Related: [[feedback_gates_must_derive_not_copy]],
[[feedback_handover_prompt_is_one_block]], [[project_session_log]].

**S115 (2026-09-28): stages A-E ARE the milestones.** Never build a second list beside them - the operator caught M1-M10:
"why you ignore the roadmap in the opsboard?". The active milestone lives in the active stage's `active_milestone`
(PLAYABLE WITH A BOXER in stage B); `roadmap.next` must be kept current or the board shows stale text.
