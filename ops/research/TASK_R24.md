# TASK R24 — CLAUDE — the SCHEDULE hub

Model: top tier (Opus 5). Fast mode off. One session; end it when the
stage ships.

The fourth legacy replacement. Kalli's K10 ruled the shape, Codex's C7
(`0dca437`) shipped the reads. Three pre-kit screens die here.

## The shape (K10, adopted)

- **ONE rail item SCHEDULE.** `EVENTS` leaves `ManagementChrome.NAV_ITEMS`
  and its offers badge moves onto SCHEDULE.
- Tabs **MY MONTH** / **THE CARDS**.
- **EVENT** is a drill-in off a cards row — the drawer pattern R21 used
  for the store and R22 for the session — never a third destination.
- **DAY ÷ SCHEDULE:** THE DAY says what today holds; SCHEDULE shows dated
  obligations across the month and the world's cards, and never restates
  the briefing.

## Reads (C7 only, one per rebuild)

    GameState.get_schedule_month(week)   11016   the six-row Monday-first grid
    GameState.get_cards_board()          11094   six columns + four filters + refusals
    GameState.get_event_card(event_id)   11160   bouts, my slot, tale, purse, results

Writes stay what they already are: `book_fight` through the existing
booking path, and nothing else. Nothing is computed in the panel that C7
already computes.

## Deliver

1. `Godot/scripts/ScheduleHubPanel.gd` — the hub, hosted by CareerRoot
   (`host_shell` set) exactly as `TrainingHubPanel.gd` is; standalone it
   builds its own ShellChrome. Title, line and tab switch in the free
   band; body starts at 210.
2. Kit family **"schedule"** in `Godot/scripts/UIKit.gd` +
   `Godot/assets/data/ui_kit_manifest.json`: `month_grid`, `day_cell`,
   `obligation_chip`, `event_row`, `bout_row`, `setpiece_seam`. Reuse
   `filter_strip`, `sort_header`, `tab_bar`, `alert_strip`, `badge`,
   `pair`, `affordability_reason`, `illegal_refusal`, `store_drawer` /
   `session_panel` for the drill-in surface before minting anything.
3. Routing: `SceneRouter.ROUTES` — `calendar`, `events`, `event_detail`
   become panel routes on `CareerRoot.tscn` with nav `calendar`
   (`events` carries `"tab": "cards"`, `event_detail` the event id);
   `CareerRoot.HOSTED` mirrors them.
   `ManagementChrome.NAV_ITEMS` drops `EVENTS`; `DIRECT_SCENES` repoints
   `calendar` / `events` / `event_detail` at `CareerRoot.tscn`.
   `ShellChrome.gd:161` moves the offers badge onto `calendar`.
4. Deletions: `scripts/ScheduleBoard.gd` (1346),
   `scripts/EventsBoard.gd` (1090), `scripts/EventDetailScreen.gd`
   (1074), their `.tscn`, their `.uid`, and the tests that only exist to
   test them (`schedule_board_test.gd`, `events_board_test.gd`,
   `event_detail_screen_test.gd`).
5. The sweep — every other reference repointed, never deleted, keeping
   each test's GameState assertions:
   `booking_eligibility_visibility_test`, `event_night_ui_test`,
   `ia_v2_navigation_test`, `ia_v2_polish_test`,
   `office_nav_and_profile_overlay_test`, `organization_fight_offer_test`,
   `schedule_progression_test`, `shared_header_rollout_test`,
   `watched_status_test`, `smoke_test` (three sites), plus the comment-only
   mentions in `objectives_board_test`, `event_night_backend_test`,
   `header_real_date_test`. Tools: `CaptureArenaStylePreviews`,
   `CaptureDayModalPreview`, `CaptureEventDetailPreviews`,
   `CaptureEventsBoardPreview`, `text_overflow_audit`. Comments naming a
   deleted screen in `GameState.gd:2299`, `ManagementChrome.gd:354/369/795`,
   `OfficeHub.gd:898/2668`, `UserSettings.gd:64/66/70`,
   `WorldPopulation.gd:657/725`, `FightNightScreen.gd:4/255` are
   reworded, not left lying.
   `ManagementChrome.gd:383` loads `EventDetailScreen.tscn` for its
   post-booking hand-off — repoint it at the route, do not leave a
   dangling load.
6. `Godot/tests/schedule_hub_panel_test.gd` — the new gate.
7. Renders into `DesignLibrary/screens/schedule_hub/` via
   `Godot/tools/render_schedule_hub.gd` (mirror `render_training_hub.gd`),
   run WITHOUT `--headless`.

## Rules that decide whether this is correct

- Kit only; nothing smaller than `SIZE_MIN` 12; gold once per board (the
  set-piece seam's ENTER FIGHT WEEK on the event, the CLAIM-equivalent
  nowhere else); green is Continue alone; a pair block is slate.
- **No fight camp on these boards** — that is TRAINING (K9).
- Females never fight males; weight classes must match. A row that cannot
  be booked says C7's reason in full, never a dash.
- A `Label` outside a Container gets explicit `\n`.
- Scene-compiled script: `get_node_or_null("/root/GameState")` +
  `has_method`, never the bare autoload identifier.
- One figure once per board; silhouettes only.

## Gate

    python Godot/tools/check_scripts.py Godot/scripts/ScheduleHubPanel.gd Godot/scripts/UIKit.gd Godot/scripts/SceneRouter.gd Godot/scripts/CareerRoot.gd Godot/scripts/ManagementChrome.gd Godot/scripts/ShellChrome.gd Godot/tests/schedule_hub_panel_test.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/schedule_hub_panel_test.gd

Then `career_root_test.gd`, `scene_router_test.gd` and `smoke_test.gd`;
the full suite ONCE in the background before the commit. Stage explicit
paths, check `git status -s` first, push `master`, write
`research/R24_DIGEST.md` and the HANDOFF block, then END the
session.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/ScheduleHubPanel.gd
Godot/scripts/UIKit.gd
Godot/scripts/SceneRouter.gd
Godot/scripts/CareerRoot.gd
Godot/scripts/ManagementChrome.gd
Godot/scripts/ShellChrome.gd
Godot/tests/schedule_hub_panel_test.gd
Godot/tools/render_schedule_hub.gd
research/R24_DIGEST.md
```
