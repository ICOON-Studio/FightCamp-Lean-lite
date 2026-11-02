---
name: reference-video-archive
description: Every video shown to the operator lives in D:\FightCamp\videos (operator asked 2026-09-28 where they were)
metadata:
  node_type: memory
  type: reference
  originSessionId: b8f0fab2-8425-48bb-b604-aa7c2f5eeaa9
  modified: 2026-09-28T14:53:41.640Z
---

All videos sent to the operator are archived in `D:\FightCamp\videos` (163 files gathered S120 from session
scratchpads and %TEMP%, where Windows can clean them). Save every NEW video there too, not only in a scratchpad.

**Why:** operator S120 asked "where are the stored videos you are showing me" - they were scattered in temp folders.
**How to apply:** after rendering any mp4 for the operator, `cp` it to D:\FightCamp\videos (D: = bulk drive, [[project-pc-drives]]).

**Operator's own screen recordings (S131, 2026-09-30):** `Tools/desktop_recorder.pyw` (start: `Tools\desktop_recorder.cmd`,
HOME = box + record, HOME = save, CTRL+ALT+HOME = quit) writes `D:\FightCamp\videos\desktop\rec_<date>_<time>.mp4` +
`recorder.log`. When he says "I recorded it", look there first (newest file). Home is taken system-wide while it runs.
