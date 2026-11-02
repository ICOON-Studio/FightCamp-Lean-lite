# R22 DIGEST — the TRAINING hub (Claude)

The second legacy screen replaced by a kit panel. `TrainingScreen.gd`
(2176 lines) and `TrainingScreen.tscn` are DELETED, not migrated.

## What shipped

- `Godot/scripts/TrainingHubPanel.gd` — THE WEEK (one band per fighter,
  seven days), SESSION (a day-opened drawer, the STORE-drawer pattern),
  FIGHT CAMP (a mode that hardens when the selected fighter is booked).
  Kalli's K9 shape, unchanged. The board never restates station
  occupancy; that stays the GYM hub's FLOOR board (K9 §B).
- Kit family `"training"` — six factories, sixteen variants: `week_band`,
  `focus_chip`, `body_delta`, `session_panel`, `camp_week_rail`,
  `illegal_refusal`, plus the helper `week_band_columns` so a band and
  the sort header above it cannot drift. Book: **151 variants across 14
  families**, re-rendered.
- Reads C5 (`d733584`) and nothing else: one `get_training_hub()` per
  rebuild, one `get_training_day()` per opened day, `forecast_*` never in
  a loop. Writes go through `set_week_program_day` / `clear_week_program`;
  every refusal is surfaced verbatim, and the two that mean another
  system owns the week keep their whole sentence.
- Route `training` is a CareerRoot panel (`SceneRouter`, `CareerRoot`,
  `ManagementChrome.DIRECT_SCENES`). The rail is unchanged.
- Copy/paste is click-arm-click. No drag primitive was minted (K9).
- Pictures: `DesignLibrary/screens/training_hub/` — week, session,
  fight_camp, states, empty — from `tools/render_training_hub.gd`
  (windowed, NOT headless). User approved 2026-09-05.

## Fixed in passing

- The `"gym"` family's manifest `rule` was a copy of the profile family's
  text and described the wrong screen.
- `scene_router_test` used `training` as its example of a route without a
  panel; it now uses `calendar`.

## The sweep

Deleted `TrainingScreen.{gd,tscn}` and `training_screen_test.gd`. Swept
`smoke_test`, six tests, `tests/helpers/management_overview_checks.gd`,
five `tools/Capture*`, `text_overflow_audit` and two comments. Every
assertion that was about GameState was kept and repointed at the system
that owns it: `stage4d_recovery_ui_test` now reads `get_recovery_options`
and `set_week_program_day`; `menu_modernization_test` reads
`get_discipline_training_plan`, `AthleteDevelopment` and
`CompetitionData`. Only the claims about the legacy screen's own widgets
(the Move Lab overlay, the local Advance Week button, the shared header)
were dropped. No `TrainingScreen` scene path remains anywhere.

## Not this stage

The fight camp editor (the hub shows C5's camp summary and an entry point
into the profile's CAMP tab), the SCHEDULE camp panel, and the legacy
flags still read by `EventsBoard` / `OfficeHub` / `ScheduleBoard`.

## Evidence

Parse gate clean on every touched file. `training_hub_panel_test` 42/42.
`ui_kit_book_test`, `scene_router_test` (179/179), `gym_hub_panel_test`
and `smoke_test` green. **Full suite 120/120.**

    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/training_hub_panel_test.gd
