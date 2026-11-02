# TASK R22 — CLAUDE — the TRAINING hub, the second replacement panel

Model: **Opus 5**. Effort: **high**. Fast mode: **ON**.
R21 ran high as the pattern-setter and said later hubs run medium, but
step 6 deletes a 2176-line screen and rewires eight tests and six tools —
that is where a lower setting leaves a hanging parse error that costs a
timeout per test. Fast mode carries the mechanical two-thirds (the panel
and the kit family mirror R21). All three are decided at assignment; do
not self-escalate.
Starts now: C5 landed 2026-09-05 as `d733584` (suite 119/119), so nothing
blocks this. Not date-gated. One session; end it on ship.

Self-contained. Read this file, `K9_DIGEST.md`, `C5_DIGEST.md` and the
anchors below. Never `HANDOFF_ARCHIVE.md`; never `GameState.gd` whole.

## Why

Legacy scenes are discarded, not migrated (user decision 2026-09-05,
HANDOFF Direction notes). GYM shipped as R21. TRAINING is the second
hub: it replaces `TrainingScreen.gd` (2176 lines) and `TrainingScreen.tscn`,
which are **deleted** this stage. Kalli's K9 study is the approved shape;
Codex's C5 is the only read.

## The read contract (C5, already on master)

    get_training_hub() -> {gym, fighters[], stations[], counts}
    get_training_day(athlete_id, day) -> {current, clearance, options[], impacts[]}
    forecast_training_day(athlete_id, day, focus, station_id) -> {body, fatigue, ...}
    forecast_training_week(athlete_id, program := []) -> {start/end + 8-point series}

Every field is listed in `TASK_C5.md` and in `C5_DIGEST.md`. The six rules
that decide how the boards read, from that digest:

- A locked booked-fight day is dressed `focus: "fight"`, label `FIGHT NIGHT`,
  `locked_fight: true`, and has **no** impact rows — the editor offers
  nothing on it.
- `unplanned` means every non-fight day is `rest`; recovery counts as planned.
- A station's `day_used` / `day_free` are seven-element Monday→Sunday arrays.
- Impact rows arrive ordered `rest, recovery, bags, ring, strength, cardio`;
  illegal and full options stay in `options` (with their reason) and are
  absent from `impacts` — show them dimmed, never hidden.
- `readiness` = minimum body readiness minus current fatigue, clamped 0-100;
  `condition` = minimum body readiness before the projected week.
- All four reads are side-effect free (forecasts deep-copy before
  `BodyReadiness.apply_activity`), so the panel may call them on hover.

The panel invents nothing: if a number is not in the read, it is not on the
board.
ONE `get_training_hub()` per rebuild; `get_training_day()` once per opened
day; a `forecast_*` only on an actual hover or selection, never in a loop
over the roster.

## Build, in this order

1. **Kit gap.** The six instruments `K9_DIGEST.md` names go into
   `UIKit.gd` plus `Godot/assets/data/ui_kit_manifest.json` as family
   `"training"` (append after family `"gym"`, which starts at manifest
   line 2122 and runs to the file's end, 2690): `week_band`, `focus_chip`,
   `body_delta`, `session_panel`, `camp_week_rail`, `illegal_refusal`.
   Reuse the gym family first — `squad_row` 2018, `floor_grid` 2407,
   `filter_strip`, `sort_header` (columns shared at 1967), `capacity_meter`,
   `station_tile`, `occupancy_chip`, `store_drawer`, `catalog_row`,
   `affordability_reason` — and the profile family's `alert_strip`,
   `tab_bar`, `pair`, `badge`. Mint only what is genuinely absent.
   `ui_kit_book_test.gd` is the parity gate: every new factory needs a
   manifest entry with variants, and vice versa.
   **Fix in passing:** the `"gym"` family's `rule` string (manifest 2124)
   is a copy of the profile family's text and describes the wrong screen.
   Rewrite it in one line for the gym hub while the file is open.
2. **`Godot/scripts/TrainingHubPanel.gd`** (no `.tscn`; CareerRoot mounts
   a panel by script path). Copy `GymHubPanel.gd`'s skeleton exactly:
   `host_shell` / `host_continue` / `apply_route_args(args)` (75),
   `select_tab` (87), `rebuild` (95), `on_continue` (133), the
   `*_for_test` accessors (749-820) so the test drives it without a mouse.
   Shape, per K9:
   - **THE WEEK** is the home tab: one `week_band` per roster fighter —
     seven `focus_chip` days, load, event-night underline, the C5 flag,
     filter strip and sort header. It never restates station occupancy
     (that is FLOOR's job, K9 §B).
   - **SESSION** is a day-opened editor panel using the STORE-drawer
     pattern off THE WEEK (`_build_store` 559 is the model), not a rail
     tab: focus, owned equipment, the `illegal_refusal` line, the six
     regions plus fatigue before/after as `body_delta`, PASTE / CLEAR.
   - **FIGHT CAMP** is a mode, not a rail item: a soft tab that hardens
     when the selected fighter is booked. This stage shows C5's camp
     SUMMARY block and an entry point only — no camp editor. The camp
     panel under SCHEDULE stays until a later task retires it.
   - **Copy/move is click-arm-click** (K9's ruling, same as FLOOR MOVE).
     Do not mint a drag primitive.
3. **Writes.** C5 is read-only, so every mutation goes through the
   existing GameState API: `set_week_program_day(athlete_id, day, focus,
   station_id)` 4222, `clear_week_program(athlete_id)` 4311. Both return
   `{"ok", "reason"}` — surface the reason verbatim in the status line,
   `GymHubPanel._apply` 718 is the pattern. Note the two refusals that are
   NOT about discipline or equipment and must read as their own message:
   `MOVE LAB WEEK ACTIVE` and `DISCIPLINE PROGRAM ACTIVE` (4228-4231).
   Re-read the hub after every successful write.
4. **Router.** `training` becomes a panel route:
   `{"tier": "career", "scene": CAREER_ROOT_SCENE, "panel":
   "res://scripts/TrainingHubPanel.gd", "nav": "training", "label":
   "TRAINING"}` at `SceneRouter.gd:55`. `ManagementChrome.DIRECT_SCENES`
   line 58 points `training` at `res://scenes/CareerRoot.tscn`.
   `NAV_ITEMS` (line 39) already carries TRAINING — no rail change.
5. **Pictures.** `Godot/tools/render_training_hub.gd`, modelled on
   `render_gym_hub.gd` (windowed, NOT headless), renders K9's four boards
   — week, session, fight camp, states — to
   `DesignLibrary/screens/training_hub/`. The user judges them before
   step 6.
6. **Delete the legacy screen.** `TrainingScreen.tscn` + `TrainingScreen.gd`.
   Drop line 15 from `smoke_test.gd`'s SCENES. Then the references, each
   of which is one or two lines: `ManagementChrome.gd:58`,
   `SceneRouter.gd:55`, comments only in `AthleteProfileScreen.gd:182` and
   `ManagementOverview.gd:447`, and the tests — `training_screen_test.gd`
   (3 refs; retire it, its GameState assertions move into the new test),
   `discipline_program_integration_test.gd`,
   `technique_training_integration_test.gd`, `stage4d_recovery_ui_test.gd`,
   `ia_v2_polish_test.gd`, `menu_modernization_test.gd`,
   `shared_header_rollout_test.gd` (2), `tests/helpers/management_overview_checks.gd`
   — one ref each: keep every assertion that is about GameState, drop only
   the scene claim. The `tools/Capture*Previews.gd` that load the scene
   (`CaptureArenaStylePreviews`, `CaptureManagementCompletionPreviews`,
   `CaptureManagementPreviews`, `CaptureStage3CodexPreviews`,
   `CaptureStage4DRecoveryPreviews`, `text_overflow_audit`): delete a tool
   that exists only for it, else drop the entry. Verify by grep that no
   `TrainingScreen` scene path remains.
7. **Not this stage.** The fight camp editor, the SCHEDULE camp panel,
   and any legacy flag still read by `EventsBoard` / `OfficeHub` /
   `ScheduleBoard`. The digest records what is left.

## Gate

    python Godot/tools/check_scripts.py Godot/scripts/TrainingHubPanel.gd Godot/scripts/UIKit.gd Godot/scripts/SceneRouter.gd Godot/scripts/ManagementChrome.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/training_hub_panel_test.gd

`training_hub_panel_test.gd` (new, modelled on `gym_hub_panel_test.gd`)
proves: the panel standalone with its own shell and the rail lit on
`training`; one band per roster fighter with seven days; a booked
fighter's fight day locked; the session drawer opening on a day and
writing a focus through `set_week_program_day`; an illegal option shown
with its reason and refused; CLEAR emptying the week; the MOVE LAB
refusal surfacing its own text; click-arm-click paste; CareerRoot hosting
the `training` route.

Then `scene_router_test`, `ui_kit_book_test`, `smoke_test`; the full
suite once, in the background, right before the commit. Digest
`research/R22_DIGEST.md` (short); cite C5's hash in it and this
stage's hash in the next digest.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/TrainingHubPanel.gd
Godot/scripts/UIKit.gd
Godot/scripts/SceneRouter.gd
Godot/scripts/ManagementChrome.gd
Godot/tests/training_hub_panel_test.gd
research/R22_DIGEST.md
```
