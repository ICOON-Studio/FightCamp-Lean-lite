# R25 DIGEST — THE SCOUTING HUB (Claude)

The fifth legacy replacement. ONE rail item **SCOUTING** is now a CareerRoot
panel built from the kit, on Kalli's K11 boards. `RecruitmentScreen.gd`
(1108 lines), its scene, its filters test and its capture tool are DELETED.

## What shipped

- `Godot/scripts/ScoutingHubPanel.gd` — FIGHTERS / STAFF as two schemas of
  one list; THE CANDIDATE is the side of the selected row; CONTRACT OFFER is
  a drawer off that row, never a third destination. Five filters per tab with
  live counts, eight sortable columns, an honest empty state with a recovery
  button, and a status line that repeats a refusal in the game's own words.
- Reads **Codex C8** (`c3bb9b6`) only: `get_scouting_board()` once per
  rebuild, plus `get_candidate_card()` and `get_offer_state()` when a row is
  open. Writes are the negotiation API that already existed —
  `start_negotiation`, `propose_negotiation_terms`, `cancel_negotiation`,
  `finalize_negotiated_signing` — plus C8's `shortlist_add` /
  `shortlist_remove`. No instant sign: a candidate is a world reference until
  the contract is signed at the terms the negotiation actually settled on.
- The SHORTLIST pin (K11 section B) is live on C8's save field — the thing the
  save used to forget.
- Kit family **"scouting"**: `prospect_row`, `gym_gap_compare`,
  `shortlist_pin` (a drawn star, no glyph font), `offer_axis`, `offer_drawer`
  — K11's five gaps, all five reusing the gym/training family first. 5
  factories / 15 variants; book **181 across 16 families**.
  `action_flag` learned the level "good" (a row that says CAN SIGN was
  drawing it in the muted grey of no-flag).
- Routing: `scouting` is a panel route on CareerRoot; `ManagementChrome`'s
  DIRECT_SCENES points it at `CareerRoot.tscn`. The route id is unchanged, so
  every call site keeps working; the STAFF tab arrives as a `tab` arg, so the
  router contract stays at 31 ids.

## The sweep

`recruitment_filters_test.gd` and `CaptureRecruitmentFiltersPreview.gd` are
deleted with the screen they tested. Five tests and four tools repointed
(`ia_v2_polish`, `office_nav_and_profile_overlay`, `shared_header_rollout`,
`smoke`, `world_management_ui`; `CaptureIAV2Previews`,
`CaptureManagementPreviews`, `CaptureStage3CodexPreviews`,
`text_overflow_audit`). Every GameState assertion was kept — the world-vs-UI
claims in `world_management_ui_test` now run against C8's board instead of
the deleted screen's contract. `scene_router_test` needed a new example of a
route CareerRoot cannot host: RANKINGS.

## C8 was unverified

Codex shipped C8 without an engine ("the documented 4.7.2 console exe is
absent"), so `scouting_hub_api_test.gd` had never run. It did not load:
`WorldPopulation` is a plain script, not an autoload, so a `--script` test
must preload it. One line fixed; the test then passes **30/30**, and C8's API
is confirmed good.

## Evidence

- Parse gate: 11 files, 0 failures.
- `scouting_hub_panel_test` **57/57**; `scouting_hub_api_test` 30/30;
  `scene_router_test` 179/179; smoke, shared header, world management,
  IA v2 polish, office nav and scouting hotspot all green.
- Full suite green before the commit.
- Pictures `DesignLibrary/screens/scouting_hub/` (prospects, candidate,
  offer, staff, empty), rendered by `Godot/tools/render_scouting_hub.gd`.
  Kit book rebuilt: `DesignLibrary/kit/index.html`.

## Test command

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/scouting_hub_panel_test.gd
```

## Next

OFFICE + STAFF (K12 landed `eb42df8`: OFFICE = THE DESK / THE BOOKS, STAFF
stays its own rail item, weight class is an action off a fighter, PHONE stays
out). That build needs its own read API task for Codex first. The K7
set-pieces and the boot/creation scenes (CityScreen, CountryMap) remain.
