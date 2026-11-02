---
name: feedback-collect-before-you-assign
description: "At session start, COLLECT finished agent work before assigning anything — a task listed 'assigned, not yet back' is often answered-and-uncollected, or was never sent."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: da9945ec-cfff-4be4-a367-ba90920ee0a8
  modified: 2026-09-10T18:51:19.359Z
---

At every session start, **collect before you assign**. A task the handover lists
as "assigned, not yet back" is, often enough, one of three things — and only one
of them means the agent is actually working:

1. **Answered and never collected.** 2026-09-10: G49 was sitting complete in the
   Grok browser tab — Expert tier, 126 sources, verdict written — while the
   handover called it outstanding. It was R101's precondition and the stage was
   blocked on work that was already done.
2. **Never sent.** J21 (John) and K28 (Kalli) were both listed as assigned and
   neither had ever been delivered. `ad1030a` had caught the identical shape for
   C85/U42 hours earlier.
3. **Delivered to disk and never committed.** J19, J20 and M18 were all on disk,
   untracked.

**Why:** a pushed task file is not delivery, and neither is a board row. The board
reflects what someone wrote in `HANDOFF.md`, not what an agent actually produced.
Believing it costs the whole stage — and re-assigning already-finished work
spends an Expert-tier study twice.

**How to apply:** before writing a single new task, for each agent listed as
holding something: check the actual artifact. Look at the Grok browser tab
(`mcp__Claude_Browser__get_page_text`), run `grokbots.py read --to "<name>"` (it
opens a chat and reads it WITHOUT sending), and run `ls -1t research/` plus
`git status -s` for untracked deliverables. Only then decide who is idle.

**A FOURTH SHAPE, AND IT IS THE CHEAPEST TO CHECK (2026-09-21).** *Finished,
collected, merged — and still listed as "written, NOT LAUNCHED".* Five at once:
C133, U109, K63, J22 and M20. Every deliverable was on master (C133+J22 in
`3d32d0bb`, K63 in `0251db80`, M20 in `5145ad26`), and `U109_check.py` printed
`U109_CHECK PASS` on the spot. U109's supposedly-NEW tool files had been landed
days earlier by U111. I launched Cursor and Codex on two of them before checking
and had to kill both.

**The mechanical check, and it is one command per task:**
`ls research/<ID>_*.md` and then run that task's check script. A task file
existing is not evidence the task is open, and the "NOT LAUNCHED" annotations in
`agent_comms.py start` are PROSE SOMEBODY WROTE, not a derived fact — the
`holds:` lists come from roster/claim state nobody clears on collection. Never
launch on the strength of that annotation alone.

Kalli is **alive** despite the standing warning — verify it rather than assuming.

Related: [[project-shell-less-agents-unavailable]],
[[feedback-drive-qwen-and-grok-to-delivery]],
[[project-qwen-and-grok-reachable-in-app]], [[project-session-log]].
