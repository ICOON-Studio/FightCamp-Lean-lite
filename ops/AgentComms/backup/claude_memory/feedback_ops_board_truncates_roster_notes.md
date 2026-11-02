---
name: feedback_ops_board_truncates_roster_notes
description: "The ops board amputated every roster note to 200 chars on each toggle - fixed in source, but the frozen .exe still carries the bug"
metadata: 
  node_type: memory
  type: project
  originSessionId: a3475d8c-1635-429c-ad7f-025c0811adb7
  modified: 2026-09-20T11:21:38.624Z
---

`Tools/opsboard/server.py`'s roster POST stored the incoming note as `str(...)[:200]`, and the page
posts the note it is **showing** alongside every `in_rotation` toggle. So **a toggle was an edit**,
and each one cut the note to 200 characters - compounding, because the stump is what the page shows
next time. Found 2026-09-20 with all eight notes sitting at exactly 200 bytes: Codex's launch line,
Cursor's "it pushes to BRANCHES sometimes", Qwen's gate rule and Kalli's capacity history all gone
mid-sentence. That is why that session opened reading every agent as out of rotation with no
instructions for driving any of them.

Fixed in source: `NOTE_MAX = 4000`, plus a guard that treats an incoming note which is a strict
PREFIX of the stored one as a truncated echo and ignores it. Notes restored from git (`8589d3c6`
for six, `0f3d2a39` for john and maria).

**Why:** the roster notes are the only place an agent's launch command and watch-list live, and
losing them silently costs a whole session's orientation.

**How to apply:** the board the operator actually runs is `FightCampOpsBoard.exe`, a **frozen
build that still carries the old code** - so a phone toggle can amputate again. Either run
`Tools/opsboard/UseSourceBoard.cmd -Replace` (moves 8787 to the checkout's server.py) or rebuild
the exe. Until then, check note lengths at session start; anything at exactly 200 is a stump and
git has the full text. Related: [[project_roster_json_rule]],
[[project_roadmap_and_opsboard]], [[project_agent_comms_truncation]].
