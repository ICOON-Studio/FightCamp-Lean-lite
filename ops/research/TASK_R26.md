# TASK R26 — OFFICE + STAFF (Claude)

Model: top tier, effort high, Fast off. One session; ship and stop.
**Blocked on C9** (`research/TASK_C9.md`) and on nothing else.

## Spec

The sixth — and largest — legacy replacement, on Kalli's K12 study
(`research/K12_DIGEST.md`, `OFFICE_K12_*.png`). K12's pick (1):

- **OFFICE** keeps its rail item, tabs **THE DESK** / **THE BOOKS**. The desk
  is money — cash, payroll both ways, upkeep, purse on the books, the
  one-week projection. The books are contracts, purse/bonus and the weekly
  objectives with ONE gold CLAIM.
- **STAFF stays a rail item of its own** — coaches, capacity, wages, ratings,
  and **CoachRapport visible for the first time**, fighter × coach, actionable
  click-arm-click. People-work is not paperwork; do not fold it into OFFICE.
- **Weight class** is an action off a fighter (GYM row / fighter card), drawn
  once on THE BOOKS as the placement call with its refusal states. Never a
  destination.
- **PHONE stays out.** Relationship tracking is unfinished and must not be
  dressed as a working feature. If attention items need a home, they belong
  on THE DAY.
- `OfficeHub.gd` (5764 lines) and its scene are DISCARDED, not migrated.

Reads are C9's four projections, once per rebuild: `get_office_desk()`,
`get_office_books()`, `get_staff_board()`, `get_weight_move_card()`. Writes
are the ones that already exist — `claim_objective()` (`GameState.gd:3148`),
`start_weight_move()` (`:1541`), `cancel_weight_move()` (`:1575`).

## The eight routes: RULED (user, 2026-09-05)

The product call is made; no need to ask again. SceneRouter routes eight
`module` ids into OfficeHub (`SceneRouter.gd:65-80`). Their homes:

- `contracts`, `objectives`, `weight_class` -> THE BOOKS (weight class as
  the placement call off a fighter, never a destination).
- `finances` -> THE DESK. `today` -> THE DAY (`day_feed`, already a panel).
- `phone` -> RETIRED. K12 rules it out; the route goes with the screen.
- `live_fight` -> RETIRED. R20 moved the real tick loop into
  `FightNight.tscn`; this module is a husk with no in-game entry. Delete the
  route, the module and the four capture tools that drive it.
- `fight_test` -> KEPT as a DEV route: a small standalone panel (no rail
  item, no kit family owed, reachable from DevJump). It must keep serving
  `FightNightScreen.gd:599` `router.back_or("fight_test")` after a test bout,
  and `AthleteStatModel.gd:122`'s tooltip stays pointed at it.

## Kit gaps to mint (K12, after reusing gym / training / scouting first)

`desk_ledger`, `rapport_pair`, `contract_term_row`, `objective_claim`,
`assign_arm`, `weight_move_action`. Reuse `squad_row`, `filter_strip`,
`sort_header`, `capacity_meter`, `affordability_reason`, `illegal_refusal`,
`alert_strip`, `pair`, `prospect_row`'s column discipline. **No drag
primitive** — assignment is click-arm-click, as in R21/R22. Gold once per
board; green is CONTINUE only.

## Owned files

- NEW `Godot/scripts/OfficeHubPanel.gd`, `Godot/scripts/StaffHubPanel.gd`
- NEW `Godot/tests/office_hub_panel_test.gd`, `Godot/tests/staff_hub_panel_test.gd`
- NEW `Godot/tools/render_office_hub.gd`
- `Godot/scripts/UIKit.gd` + `Godot/assets/data/ui_kit_manifest.json` — family
  "office" (and the book rebuild, `python DesignLibrary/build_kit_book.py`)
- `Godot/scripts/SceneRouter.gd`, `Godot/scripts/CareerRoot.gd`,
  `Godot/scripts/ManagementChrome.gd` — the office/staff routes become panel
  routes; DIRECT_SCENES points at `CareerRoot.tscn`
- DELETE `Godot/scripts/OfficeHub.gd` (+ `.uid`), `Godot/scenes/OfficeHub.tscn`
- The sweep: **20 tests and 5 tools** name OfficeHub today. Keep every
  GameState assertion, move screen claims into the two new panel tests, and
  delete only what tested the deleted screen. Expect the desk-pin claims
  (`_pins_by_module`) in `scouting_hotspot_fix_test` and
  `office_nav_and_profile_overlay_test` to go with the desk.

## Anchors

- Panel pattern: `Godot/scripts/ScoutingHubPanel.gd` (R25) — `apply_route_args`,
  `rebuild`, the drawer, `contract_for_test`, and the legacy-flag rule
  (a hand-off flag is consumed ONCE, not on every rebuild)
- Kit family pattern: `UIKit.gd` "scouting" block at the end of the file
- Rapport: `CoachRapport.gd:85` `get_rapport`, `:114` `band`, `:123` `band_name`
- Weight move: `GameState.gd:1445` / `:1480` / `:1541` / `:1575`
- Objectives: `GameState.gd:3142` / `:3148`, `WeeklyObjectives.gd:122` snapshot

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/OfficeHubPanel.gd Godot/scripts/StaffHubPanel.gd Godot/scripts/UIKit.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/office_hub_panel_test.gd
```

Then `staff_hub_panel_test`, `office_hub_api_test`, `smoke_test`,
`scene_router_test`, `objectives_board_test`, `weight_move_test`, and the
full suite once in the background before the commit. Renders windowed
(no `--headless`), pictures to `DesignLibrary/screens/office_hub/`.

## The sweep, mapped (2026-09-05, before C9 landed)

The estimate in "Owned files" was low. Actual: **24 tests, 11 tools, 6
scripts** name OfficeHub. Classified so R26 does not re-derive it.

**A. Route-only — survives untouched** once `office_menu` / `staff` point at
`CareerRoot.tscn`: `dev_jump_test` (55/68/138), `schedule_hub_api_test:15`,
`scouting_hub_api_test:19`, `contract_dossier_test` (50/54, back-route),
`scouting_hotspot_fix_test` (65/68, back-route).
Two need one edit: `scene_router_test:61` lists the module ids (drop `phone`
and `live_fight`), and `world_management_ui_test` (43/49-50) asserts the
office route resolves to `OfficeHub.tscn` -> `CareerRoot.tscn`.

**B. Screen claims — move to the two panel tests, or die with the desk.**
Move: `ia_v2_navigation_test` (office_menu + staff), `ia_v2_polish_test`,
`live_refresh_test` (37/40, finances -> THE DESK), `objectives_board_test`
(187-193 -> THE BOOKS), `weight_move_test` (149-155 -> the placement call),
`sponsorship_test` (52/116) and `news_morale_sanctioning_test:175` (both keep
their GameState assertions; only the mount changes).
Die: every `_pins_by_module` claim — `contract_dossier_test` (21-30),
`scouting_hotspot_fix_test` (27/31), `office_nav_and_profile_overlay_test`
(46-69, 140), `shared_header_rollout_test:62`.
Repoint at ShellChrome, which owns the header now: `header_real_date_test`
(40/44), `header_continue_sequence_test:28`, `shared_header_rollout_test`
(24/59). `booking_eligibility_visibility_test` (8/75) is a const + an
autoload note. `feedback_overlay_test` (73/83) is only a fixture STRING
("OfficeHub.tscn, in-game overlay (F8)") — update the text, nothing else.

**C. The two ruled modules.** `fight_boxing_presentation_test:56-60` and
`fight_skill_presentation_test:59-63` both drive `open_module_for_test
("live_fight")`, which is retired — repoint them at `FightNight.tscn`, whose
tick loop R20 already owns, and keep the presentation claims.
`smoke_test` is the heavy one: FIVE sites — `:14` (scene list), `:194-222`
(ruleset contract + popup modules), `:532-538` (`fight_test`), `:756-761`
(`live_fight`), `:852-869` (real-Career module sweep).

**Scripts.** Only `SceneRouter.gd` and `ManagementChrome.gd` carry real code:
ManagementChrome at `:67-76` (the `local_open` / `_dive_to_module` handler
every non-office screen routes through) and `:252` (the Continue fallback
that exempts OfficeHub — the exemption goes when the desk does).
`ManagementOverview.gd:422`, `UserSettings.gd:58` and `FightNightScreen.gd`
(4, 29) are COMMENTS only; reword, no behaviour.

**Tools (11).** Office entry drops from `CaptureIAV2Previews`,
`CaptureStage3ClaudePreviews`, `CaptureManagementPreviews`,
`CaptureManagementCompletionPreviews`, `CaptureArenaStylePreviews`,
`CaptureStage4DRecoveryPreviews`, `text_overflow_audit`. The four that drive
the retired `live_fight` — `CaptureFightScenePreview`,
`CaptureStage4ACodexPreviews`, `CaptureStage4BBoxingPreviews`,
`CaptureRingNightCommandBarPreview` (this one uses `fight_test`) — go to
`FightNight.tscn` or are deleted with the module.
