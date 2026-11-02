---
name: feedback_agents_start_before_the_stage
description: "Operator 2026-09-24: 'why is codex not working non-stop' and 'assign full branch deliveries not small tasks' - launch every agent at session START from origin/master, before building; never queue launches behind the stage push"
metadata:
  node_type: memory
  type: feedback
  originSessionId: c99443fd-b71c-4f47-b63d-3e9ea8545494
  modified: 2026-09-23T22:21:02.458Z
---

**Operator, 2026-09-24, verbatim:** *"why is codex does work non-stop as i asked sessions ago?"*
and *"expedite the process ... plan ahead assign full branch deliveries not small tasks"* and *"i
have upgraded the plan a week ago there is no 5 hour limit"*.

**Why:** in S62 Codex sat idle for the first hour because every launch was queued behind the S62
stage commit (agents branch from origin/master). Task files already on master (ARENA_ART venue 7)
needed no push at all. A blind one-test task (U150 part 1) came back in five minutes and left Cursor
idle again.

**How to apply:** at `start`, write the new task files FIRST, push once, launch every agent on a
FULL BRANCH (several parts, one digest, one send per part), then build the stage. Launch anything
whose task file is already on master immediately. Cursor stops after each launch (one task per
launch) - relaunch it per part. Codex has no session cap; bound its tasks by gate, not by clock.
Fresh worktrees lack Godot's class cache: put `--headless --import` in every launch prompt.
Related: [[feedback_cursor_one_task_per_launch]], [[feedback_handover_duties]],
[[project_session_S62_2026-09-24]].
