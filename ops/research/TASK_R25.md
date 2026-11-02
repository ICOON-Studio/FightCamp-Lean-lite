# TASK R25 — THE SCOUTING HUB (Claude)

Model: top tier, effort high, Fast off. One session; ship and stop.

## Spec

The fifth legacy replacement. ONE rail item **SCOUTING** (it already exists
in `ManagementChrome.NAV_ITEMS`) becomes a CareerRoot panel built from the
kit, on Kalli's K11 boards (`research/K11_DIGEST.md`,
`SCOUTING_K11_*.png`). `RecruitmentScreen.gd` (1108 lines) and its scene are
DISCARDED, not migrated (user decision 2026-09-05).

- Tabs **FIGHTERS / STAFF** — two list schemas, one hub.
- **THE CANDIDATE** is the side panel of the selected row: stats, the gym
  gap in that division / coaching slot, the honest downside.
- **CONTRACT OFFER** is a drawer off the selected row (never a third
  destination, never a rail tab), carrying the money axis, the refusal in
  the candidate's own words, and the wage-forever callout.
- **SHORTLIST** pins an interested-but-not-ready world ref.

## The read adapter (C8 LANDED mid-task: `c3bb9b6`)

C8 (`get_scouting_board` / `get_candidate_card` / `get_offer_state` and
`career["shortlist"]`) was OPEN when this task was written and landed while
it ran, so the fallback projection was dropped: the panel reads C8 directly,
the way R21-R24 read C4-C7, and the API it no longer needs to reproduce is:

`get_recruitable_athletes`, `get_recruitable_staff`,
`get_recruitment_markets`, `get_recruitment_quote`, `get_negotiation`,
`get_gym`, `get_roster`, `get_staff`. Writes stay on the existing
negotiation API: `start_negotiation`, `propose_negotiation_terms`,
`cancel_negotiation`, `finalize_negotiated_signing`.

The shortlist is C8's own save field (`shortlist_add` / `shortlist_remove` /
`get_shortlist`). `GameState.gd` is NOT touched by this task - Codex owns
that file - except that C8's own test never ran (Codex had no engine) and
did not even load: `WorldPopulation` is a plain script, so a `--script` test
must preload it. One line, fixed here, and C8 then passes 30/30.

## Owned files

- NEW `Godot/scripts/ScoutingHubPanel.gd`
- NEW `Godot/tests/scouting_hub_panel_test.gd`
- NEW `Godot/tools/render_scouting_hub.gd`
- `Godot/scripts/UIKit.gd` — append family "scouting":
  `prospect_row`, `gym_gap_compare`, `shortlist_pin`, `offer_axis`,
  `offer_drawer` (K11's five gaps; reuse `filter_strip`, `sort_header`,
  `store_drawer`-shaped drawer, `affordability_reason`, `illegal_refusal`)
- `Godot/assets/data/ui_kit_manifest.json` — the "scouting" family
- `Godot/scripts/SceneRouter.gd:63` — `scouting` becomes a panel route
- `Godot/scripts/CareerRoot.gd:27` — `HOSTED["scouting"]`
- `Godot/scripts/ManagementChrome.gd:61` — DIRECT_SCENES → `CareerRoot.tscn`
- DELETE `Godot/scripts/RecruitmentScreen.gd`, its `.uid`,
  `Godot/scenes/RecruitmentScreen.tscn`, `Godot/tests/recruitment_filters_test.gd`
- Sweep the five tests and five tools that load the deleted scene
  (`ia_v2_polish_test`, `office_nav_and_profile_overlay_test`,
  `shared_header_rollout_test`, `smoke_test`, `world_management_ui_test`;
  `CaptureIAV2Previews`, `CaptureManagementPreviews`,
  `CaptureRecruitmentFiltersPreview`, `CaptureStage3CodexPreviews`,
  `text_overflow_audit`) — keep every GameState assertion.

## Anchors

- Panel pattern: `Godot/scripts/ScheduleHubPanel.gd:71` (`_ready`,
  `apply_route_args`, `rebuild`, `contract_for_test`)
- Kit reuse: `UIKit.gd:2018` squad_row, `:2212` filter_strip, `:2264`
  sort_header, `:2462` store_drawer, `:2551` affordability_reason,
  `:2996` illegal_refusal
- Negotiation API: `GameState.gd:363-600`
- Legacy flag: `UserSettings.recruitment_mode` + `consume_recruitment_mode()`

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/ScoutingHubPanel.gd Godot/scripts/UIKit.gd Godot/tests/scouting_hub_panel_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/scouting_hub_panel_test.gd
```

Then the systems it touches (`smoke_test`, `shared_header_rollout_test`,
`world_management_ui_test`, `ia_v2_polish_test`,
`office_nav_and_profile_overlay_test`), then the full suite once before the
commit.
