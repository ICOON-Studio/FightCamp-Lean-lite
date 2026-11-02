# U125 digest (cursor)

## Verification (Q127 confirmed)

| Source | Count | Classes |
| --- | --- | --- |
| `GameState.gd` `WEIGHT_CLASSES` (removed) | **4** | Featherweight, Lightweight, Welterweight, Middleweight |
| `WorldPopulation.gd` / `RankingsHubPanel.gd` (removed) | **8** | Full ladder |
| `weight_classes.json` `move.ladder` | **8** | Authoritative |

Defect was real: starter roster and GameState offer fallback used four names while boards and world gen used eight.

## Fix

- `WeightCut.division_ladder()` loads `move.ladder` once from `weight_classes.json`.
- Removed hardcoded ladders from `GameState.gd`, `WorldPopulation.gd`, `RankingsHubPanel.gd`.
- `WeightMove.ladder()` delegates to `WeightCut`.
- `PromotionsBoard.gd` sorts by ladder index via `WeightCut`.
- `FightContract.billed_weight_lbs()` reads MMA kg limits from JSON (lbs conversion).
- `TaleOfTape._competition_weight_kg()` uses `WeightCut.limit_for()` instead of `WEIGHT_KG`.
- `GameState.get_division_weight_classes()` exposes the ladder for callers/tests.

## Test

`Godot/tests/weight_class_unification_test.gd` — expected ladder parsed **only** from the JSON file; asserts `WeightCut` and `GameState` match; after `finalize_new_career` prints `world_athletes_per_ladder_class=8 of 8` and `ranked_division_tabs_with_fighters=8 of 8` (boxing/male).

## Suite (`--jobs 6`)

`SUITE total=326 fails=7`: the six known ceiling tests (`athlete_development`, `fight_pair_live`, `fight_scoring`, `fight_stage_realism`, `weight_cut`, `fight_metres` timeout) plus **`rankings_api_test.gd`** (C13 week-to-week movement — not touched by U125). `weight_cut` unchanged in intent (still fails). U125 did not fix `weight_cut`.

## Implicated scripts (grep census)

`WeightCut.gd`, `WeightMove.gd`, `GameState.gd`, `WorldPopulation.gd`, `RankingsHubPanel.gd`, `PromotionsBoard.gd`, `FightContract.gd`, `TaleOfTape.gd`, `weight_class_unification_test.gd`.
