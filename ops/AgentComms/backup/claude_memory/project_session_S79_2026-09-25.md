---
name: project-session-s79-2026-09-25
description: "S79 - camp gate, round clock, honest tutorial, THE DAY->HOME, rail 8->4 (J54), M32 slice; M34 four directions sent for the operator's pick"
metadata:
  node_type: memory
  type: project
  originSessionId: 7497c898-6a63-4056-be1e-c6126853b840
  modified: 2026-09-25T16:31:36.523Z
---

S79 (2026-09-25, ca5de555 + b0b5b8c8). Built the road to the fight: `GameState.continue_day()` gates every UI Continue on `get_camp_gate_asks()` (booked + no active camp); `fight_cold()` answers it; `advance_day()` stays ungated so sim tests keep their clock. Round clock = `FightWorldLiveScreen.broadcast_clock()` (time LEFT). Tutorial 24 steps with a `wait` predicate (`training_set`) and `driver_call` (`TrainingHubPanel.tutorial_set_plan`). Rail = `ShellChrome.RAIL_GROUPS` (HOME / FIGHTERS / FIGHTS / MONEY); page rows keep `Nav_<id>` names so hub tests' "rail lights X" still work.

**Why:** operator: "you didn't train, you didn't do anything", "where is the timer", "what the fuck is the day".

**How to apply:**
- The walk driver's `until` step (Continue until ENTER FIGHT WEEK) has NO stuck guard: an ordinary fighter request shows "1 MUST ANSWER" but does not block Continue - I misread it and killed a healthy run. Check `gs.get_camp_gate_asks()` before calling Continue stuck.
- A bare hit-area button (UIKit.way_out_strip) is found by CoachMarks via `set_meta("label", ...)`.
- `agent_window.ps1` from PowerShell: pass `-WorkingDirectory` and `-ArgumentString "a|b|c"`; a `-Arguments @()` array through `powershell -File` binds wrong.
- Grok memos sometimes arrive as an attached document: open it in-page (the "Open <name>" button) and read the text; a summary reply alone is not the memo ([[feedback-never-truncate-an-agent-reply]]).
- Grok Bot account (John/Maria/Kalli) hit 90% weekly on 2026-09-25.
- S80 builds the operator's M34 pick, A if unanswered ([[project-session-S78-2026-09-25]]).
- Operator picked M34 direction A (2026-09-25) but ruled its background (repo gym_environment.png, 2026-08-29, no source) is from another game: deleted in d38afe8c; S80 makes a new original high-res background (Higgsfield gpt_image, sources recorded in assets/images/SOURCES.md). Treat any repo art with no recorded source as possibly ripped until M35's ledger clears it.
