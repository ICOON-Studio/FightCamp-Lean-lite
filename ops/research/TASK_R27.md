# TASK R27 — THE K7 SET-PIECES (Claude)

Model: top tier, effort high, Fast off. One session; ship and stop.
UNBLOCKED: Kalli's K7 study and Codex's C11 reads (`7844ec5`) are both in.
Dress from `research/SETPIECE_FRAME_K7.html`, `K7_DIGEST.md` and the
five `SETPIECE_K7_*.png` boards.

## Spec

The seventh replacement and the first one OUTSIDE the career shell. Five
set-pieces — `fight_week`, `weigh_in`, `fight_night`, `fight_result`,
`crowning` — stop looking like office widgets and share one frame.

1. **ONE HOST.** NEW `SetpieceRoot.tscn` / `SetpieceRoot.gd`, mirroring
   `CareerRoot` (`CareerRoot.gd:99` `show_route`, `:130` `_mount`): the
   chrome is built ONCE above a BodyStack and the five phases swap the BODY
   only — K7's ruling is "body + phase change only". `SetpieceChrome.gd`
   draws the way-out strip, the stakes tag, the clock/round and the names.
   No rail, no top bar, no breadcrumb, no Continue.
2. **THE FIVE BODIES.**
   - `fight_week` -> NEW `FightWeekPanel.gd` (no scene exists today,
     `SceneRouter.gd:93`)
   - `weigh_in` -> NEW `WeighInPanel.gd` (`SceneRouter.gd:94`)
   - `fight_night` -> the EXISTING `scenes/FightNight.tscn`, instanced as the
     body. R20 is one day old and six tests instantiate that scene directly;
     the root therefore accepts a PackedScene body as well as a script panel.
     Do not fold `FightNightScreen.gd` into a panel.
   - `fight_result` -> NEW `FightResultPanel.gd`; `FightResultScreen.gd`
     (387 lines) and its scene are DISCARDED.
   - `crowning` -> NEW `CrowningPanel.gd`; `DoubleChampCrowning.gd` (285) and
     its scene are DISCARDED.
3. **THE HANDOFF, PLAYED EXACTLY** (K7 timings, the router contract).
   Enter 940 ms sequential: rail out 180 + top fold 160 are the SHELL's, so
   `CareerRoot` folds before the scene changes; seam 220 + frame lock 240 +
   settle 140 are `SetpieceRoot`'s. Exit 480 ms: chrome fold 280, then shell
   restore 200. A phase-to-phase move INSIDE the root is the settle only
   (140), never the full 940 — the gear has already changed. Belt-change
   hero holds 1600 ms before the way out arms; decision cards flip 120 ms.
   **Transitions must be skippable.** A `transitions_enabled` flag (default
   true) that every test and every render tool sets false; a headless test
   must never await a tween. This is the one thing here that can hang the
   suite instead of failing it.
4. **ENTRY POINTS.** `ScheduleHubPanel.gd:805` mounts the hub-side seam and
   `:964` `_on_enter_fight_week` jumps straight to `fight_night` today — it
   points at `fight_week` now and the frame walks the phases.
   `MatchSimulatorPanel.gd:210` keeps pushing `fight_night` in mode "test":
   the lab dresses the frame WITHOUT career stakes and its way out stays
   `router.back_or("fight_test")` (`FightNightScreen.gd:599`).
5. **CROWNING STOPS BEING AN OVERLAY.** `ManagementChrome.gd:239` and
   `:333-348` mount `DoubleChampCrowning` over whatever screen is up; that
   goes. Crowning is a route: `CareerRoot.on_continue` (`:156`) checks
   `get_crowning_card()` after the advance and pushes `crowning`, and the
   result panel pushes the route where `FightResultScreen.gd:203-211`
   chained the overlay.
6. **THE ONE WRITE.** `consume_pending_crowning()` (`GameState.gd:9505`)
   fires ONCE, as the player leaves the crowning board. Everything else read
   is C11's four projections, called once per rebuild.

**HARD RULES.**

- No settlement, no resolution, no consumption from a set-piece body beyond
  that single crowning consume. Weigh-ins resolve inside the day/week
  advance (`GameState.gd:4712`, `:5058`): WEIGH-IN presents `slot` before and
  `resolved` after, and never calls `_resolve_weigh_ins`.
- RESULT never advances the day. The advance is still the shell's Continue,
  and green CONTINUE returns only on the Result exit.
- Kit rulings: gold ×1 per frame and, in the hero, on the belt only; a
  stoppage is semantic BAD red, never gold; Bebas Neue display / IBM Plex
  Mono else; SIZE_MIN 12; silhouette placeholders, ONE figure per screen;
  "GYM" not "camp" except the FIGHT CAMP PREP phase label.

## The reads (C11, `GameState.gd`)

`get_fight_week_card(athlete_id)` `:11641` — opponent, record, event, venue,
weeks/days out, stakes ("TITLE BOUT" / "RANKING FIGHT" / "FEATURE BOUT"),
camp options, weight status.
`get_weigh_in_card(athlete_id)` `:11677` — limit, current weight, action,
`slot`, `resolved`, `miss_fraction`, `fine`, stakes line.
`get_fight_result_card(athlete_id)` `:11711` — the pending result plus
`record_after` / `record_line` and the full settlement (purse, win and
performance bonus, gate share, expenses, weight fine, paid).
`get_crowning_card()` `:11741` — the pending crowning, read WITHOUT erasing.

## Kit gaps to mint (family "setpiece")

`setpiece_chrome`, `way_out_strip`, `stakes_tag`, `phase_clock`,
`fighter_slab`, `tale_row`, `scale_readout`, `verdict_block`,
`scorecard_row`, `settlement_ledger`, `belt_hero`, `phase_shutter`.
Reuse first: `pair`, `block`, `caps`, `display`, `continue_unit`,
`alert_strip`, `illegal_refusal`, and `RingNightView.presentation()` (R26).
`UIKit.setpiece_seam` (`:3465`) is the HUB's handoff and stays on the hub —
it is never redrawn inside the frame. No drag primitive.

## Owned files

- NEW `Godot/scripts/SetpieceRoot.gd`, `SetpieceChrome.gd`,
  `FightWeekPanel.gd`, `WeighInPanel.gd`, `FightResultPanel.gd`,
  `CrowningPanel.gd`
- NEW `Godot/scenes/SetpieceRoot.tscn`
- NEW `Godot/tests/setpiece_root_test.gd`, `Godot/tests/setpiece_panels_test.gd`
- NEW `Godot/tools/render_setpiece.gd`
- `Godot/scripts/UIKit.gd` + `Godot/assets/data/ui_kit_manifest.json` —
  family "setpiece", then `python DesignLibrary/build_kit_book.py`
- `Godot/scripts/SceneRouter.gd` (`:92-97`, the five tier-3 routes),
  `CareerRoot.gd` (fold / restore + the crowning hook),
  `ManagementChrome.gd` (the overlay goes), `ScheduleHubPanel.gd` (seam
  target), `FightNightScreen.gd` (the two statics move)
- DELETE `Godot/scripts/FightResultScreen.gd` (+ `.uid`),
  `Godot/scenes/FightResultScreen.tscn`,
  `Godot/scripts/DoubleChampCrowning.gd` (+ `.uid`),
  `Godot/scenes/DoubleChampCrowning.tscn`,
  `Godot/tests/fight_result_screen_test.gd`

## The sweep, mapped (small — four files change, two are deletions)

- `FightNightScreen.gd:25-26, 565, 574` — `payload_from_sim` and
  `next_event_tonight` are statics on the deleted script. Move both to
  `FightResultPanel.gd`, keep the payload contract, and make
  `_present_player_result` (`:564`) push the `fight_result` ROUTE instead of
  instancing an overlay: the ring is no longer a host, it is a body in the
  same frame.
- `tests/fight_result_screen_test.gd` — every claim moves into
  `setpiece_panels_test.gd`; then delete the file.
- `tests/titles_rankings_test.gd:286` — load `CrowningPanel.gd`.
- `tests/scene_router_test.gd:271-288` and `tests/smoke_test.gd:15, 508,
  532-538` — `FightNight.tscn` keeps loading standalone, so those claims
  stand; ADD `SetpieceRoot.tscn`, the five routes' scene and the
  transitions-off contract.
- UNTOUCHED, and check that they stay so: `combo_show_test.gd:114-118`,
  `ring_night_command_bar_test.gd:43-47`,
  `booking_eligibility_visibility_test.gd:119`,
  `tools/CaptureRingNightCommandBarPreview.gd` — all four drive
  `FightNight.tscn` / `FightNightScreen.gd` directly.

## Anchors

- Host pattern: `CareerRoot.gd:99` `show_route`, `:112` `_mount`, `:116`
  `_rebuild_shell`, `:165` `contract_for_test` (give `SetpieceRoot` the same
  test contract: phase, body name, chrome present, transitions flag)
- Router: `SceneRouter.gd:284` `_enter` (a tier-3 route with an empty
  `scene` warns and returns false today — the five now name
  `SetpieceRoot.tscn` and carry their phase the way `tab` is carried, `:300`)
- Kit family pattern: the "office" block at the end of `UIKit.gd`
- Panel pattern: `ScoutingHubPanel.gd` / `OfficeHubPanel.gd` —
  `apply_route_args`, `rebuild`, `contract_for_test`, and the rule that a
  hand-off flag is consumed ONCE, not on every rebuild

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/SetpieceRoot.gd Godot/scripts/SetpieceChrome.gd Godot/scripts/FightWeekPanel.gd Godot/scripts/WeighInPanel.gd Godot/scripts/FightResultPanel.gd Godot/scripts/CrowningPanel.gd Godot/scripts/UIKit.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/setpiece_root_test.gd
```

Then `setpiece_panels_test`, `setpiece_api_test`, `scene_router_test`,
`titles_rankings_test`, `combo_show_test`, `ring_night_command_bar_test`,
`event_night_ui_test`, `smoke_test`, and the full suite ONCE in the
background before the commit. Renders windowed (no `--headless`), pictures
to `DesignLibrary/screens/setpiece/`.
