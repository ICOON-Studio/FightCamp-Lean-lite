---
name: feedback-opsboard-at-wrapup
description: S178 operator "always update opsboard when wraping up a session" + "remove unecessary items and obsolete" - board plan, live_runs, queue cleaned before ship
metadata:
  type: feedback
---

Every wrap-up updates the ops board BEFORE `ship`: roadmap `plan` (working_now/next/parked/done_recently/titles), live_runs.json (finished runs moved to live_runs_archive.json, running ones added with chat/branch), and the queue (finished tasks' state prefixed DONE/SUPERSEDED so `_queue_closed` hides them). Verify 127.0.0.1:8787/api/roadmap serves it (agents page caches 60 s).

**Why:** S178 the board still showed MORNING1T/NIGHTLY1C2 "running" days after merging, 70+ old runs, and obsolete "next" items (BUYER1-ON, GYM-CLICK1) after the layout was rejected; `start` called 52 tasks open when ~20 were.
**How to apply:** part of the ship checklist (CLAUDE.md s3). See [[feedback-opsboard-is-the-roadmap]].
