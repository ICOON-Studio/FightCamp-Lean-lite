# U15 DIGEST — THE TOURNAMENT NOBODY CAN SEE

**Branch:** `cursor/u15-tournament-nobody-can-see-8fdc`  
**Commit:** `63b6120` (panel + test); digest follows.

## What landed

SCHEDULE gains a **TOURNAMENTS** tab. On rebuild (that tab only, once):

- `get_grand_prix_events()` → announced rows (name, discipline, weight class, bracket size, week) in words via `PB.discipline_word` / underscore strip — never raw tokens.
- `get_grand_prix_invites()` → open seats; `get_grand_prix_stage_note(offer_id)` cached into `_gp_stage_notes` in the same guarded block, never inside a row builder.
- Seating only through `accept_grand_prix_invite(event_id, athlete_id)`.

Absent accessors (`omit_gp_for_test` / missing methods): quiet empty, no invented rows, lead y unchanged.

No champion / belt / reign / defence language. No purse or invented money. No `GameState.gd` / `UIKit.gd` / `UITokens.gd` / `HANDOFF.md` edits.

## Gates

- Parse: `ScheduleHubPanel.gd` + test → 2/0
- `schedule_hub_panel_test.gd` → 94/0 (absent read + announce + TAKE SEAT)
- `tournaments_test.gd` → failures=0
- `smoke_test.gd` → failures=0
- Full suite → **184/0** (floor met)

## Trap dodged

OFFER ≠ INVITE. The tab lists events from `get_grand_prix_events` and seats from `get_grand_prix_invites`; it never treats the offer list as the invite board.
