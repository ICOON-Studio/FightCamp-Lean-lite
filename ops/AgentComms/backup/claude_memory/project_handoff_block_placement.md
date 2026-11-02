---
name: project_handoff_block_placement
description: "A HANDOFF.md COMPLETE block must sit ABOVE the \"## Direction notes\" heading or agent_comms.py cannot see it"
metadata: 
  node_type: memory
  type: project
  originSessionId: 1b094c62-1cb8-46bd-a5e4-d19b97aff79e
  modified: 2026-09-11T19:41:00.847Z
---

`agent_comms.py` reads statuses from `handoff_slice()`, which is only
`^## Active claims` up to `^## Direction notes`. A `### AGENT - ID: ...
(COMPLETE ...)` block written BELOW the `## Direction notes` heading is invisible
to `tasks` and `board`, which then report the task as OPEN (or `COMPLETE?` when a
digest exists). Append new blocks immediately ABOVE that heading.

Traps, each hit at least once:

- **`## Direction notes` OCCURS TWICE AND THE FIRST ONE IS A DECOY.** Around line
  404 the prose quotes the sed command agents are told to run, and that quoted
  line *starts* with `## Direction notes` (`## Direction notes/p' HANDOFF.md`.`).
  It is a line start, so "anchor on line starts" is NOT enough, and a
  `replace(anchor, ..., 1)` puts every block above `## Active claims`, outside
  the slice. Hit again 2026-09-11: nine blocks parsed as zero tasks.
  **Match the line EXACTLY — `ln.strip() == "## Direction notes"` — or take the
  LAST occurrence.**
- The header regex accepts **only `OPEN` or `COMPLETE`**, inside the parens or
  trailing after them. `... (2026-09-11). IN PROGRESS.` is an *unreadable* header
  and the board prints a warning instead of a row. Use `OPEN.` in the header and
  put `**Status: IN PROGRESS**` on a body line if it is wanted.
- The heading needs one alphanumeric id immediately followed by a colon:
  `### QWEN - Q7 + Q7T:` and `### QWEN - Q61 ASSIGNED:` both fail. One block per
  task id, `### QWEN - Q61: ...`.
- `HANDOFF.md` has mixed line endings (mostly CRLF, some LF), so read and write
  with `newline=""` and split on the file's own terminator.

**Why:** a block nobody's tooling can see is the same as no block; the operator
reads the board, not the file. Three of Cursor's finished tasks sat OPEN for days
because nobody had written their blocks at all.

**How to apply:** insert before the LAST `## Direction notes` line, one heading
per id, then verify with
`python -c "import sys;sys.path.insert(0,'Tools');import agent_comms as ac;print(ac.handoff_statuses())"`
— not just `board` — before committing.
Related: [[project_handoff_sweep_command]], [[project_agent_comms_truncation]].
