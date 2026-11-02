# R24 DIGEST — THE SCHEDULE HUB (Claude)

The fourth legacy replacement. Kalli's K10 ruled the shape, Codex's C7
(`0dca437`) shipped the reads, and three pre-kit screens are gone.

## What shipped

`Godot/scripts/ScheduleHubPanel.gd` — ONE rail item **SCHEDULE**, tabs
**MY MONTH** / **THE CARDS**, and **THE EVENT** as a drill-in off a cards
row (never a third destination). Hosted by CareerRoot; standalone it
builds its own ShellChrome, the way the GYM and TRAINING hubs do.

- **MY MONTH** — C7's six-row Monday-first grid, one cell per date with
  its obligations stacked as chips and `+N · N ON DAY` when more land
  than the cell can hold; a heavy day (three or more) wears the amber
  edge. Kind filter across the eight kinds C7 sends and nothing else —
  there is no invented Training / Travel / Rest chip. A day opens into
  the SELECTED DAY panel beside the grid, which lists what lands on it
  and offers OPEN ON THE CARDS when one of them is a world event.
- **THE CARDS** — one row per `get_cards_board()` row over six columns
  plus a flag: MY FIGHTER, BOOKABLE, MY DIVISION, MY ORG, or the refusal
  in C7's own words. The four relevance filters and a sortable head. The
  booking bar stays on the board: OPEN EVENT, and BOOK SELECTED opening
  the **BOUT AGREEMENT** (`FightContractScreen`) exactly as the retired
  board did — terms first, then the mandatory fight plan. A refused row
  disables the button and says why.
- **THE EVENT** — `get_event_card()`'s bout list with the gym's own bout
  lit and opened on by default, the tale of the tape beside it, and the
  **set-piece seam**: the hub hands over to the K7 frame and never
  redraws it. ENTER FIGHT WEEK is the one gold on the board.

**Kit family "schedule"** (6 factories / 15 variants): `obligation_chip`,
`day_cell`, `month_grid`, `event_row`, `bout_row`, `setpiece_seam`, plus
the `card_columns` / `bout_columns` helpers that keep each head and its
rows from drifting. Book **166 variants across 15 families**.

## What was deleted

`ScheduleBoard.gd` (1346), `EventsBoard.gd` (1090) and
`EventDetailScreen.gd` (1074) with their scenes and their own three
tests; `ManagementChrome._open_event_night()` went with its only caller.
`EVENTS` left `NAV_ITEMS` and its offers badge moved onto SCHEDULE;
`calendar`, `events` and `event_detail` are now panel routes on
`CareerRoot.tscn`.

## The sweep

Ten tests and five tools repointed, every GameState assertion kept:

- `schedule_progression_test` rewritten around the rule the day modal
  used to enforce — `advance_day()` refuses to end a day with an unfought
  booked fight, and C7's month puts that fight on the right date.
- `header_continue_sequence_test` asserts CONTINUE routes to SCHEDULE on
  the router, then walks the real day clock.
- `watched_status_test`, `event_night_ui_test` and
  `booking_eligibility_visibility_test` read C7's board and card instead
  of the deleted screens' labels; the WATCH day gate is asserted where
  its one remaining copy lives (`FightNightScreen._event_is_today`).
- `organization_fight_offer_test` exercises the Bout Agreement scene
  directly; `scene_router_test` uses SCOUTING as its unhosted example.
- Comments naming a deleted screen were reworded in `GameState.gd`,
  `ManagementChrome.gd`, `OfficeHub.gd`, `UserSettings.gd`,
  `WorldPopulation.gd` and `FightNightScreen.gd`.
- Deleted tools: `CaptureDayModalPreview`, `CaptureEventDetailPreviews`,
  `CaptureEventsBoardPreview`. New: `tools/render_schedule_hub.gd`.

## Verification

Parse gate clean on every touched file. `schedule_hub_panel_test.gd`
57/57. Full suite green. Pictures in
`DesignLibrary/screens/schedule_hub/` (month, day, cards, event, empty).

    python Godot/tools/check_scripts.py Godot/scripts/ScheduleHubPanel.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/schedule_hub_panel_test.gd

## Next

SCOUTING, on K11's boards and Codex's C8 reads.
