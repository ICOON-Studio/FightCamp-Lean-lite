# U6 DIGEST — THE CARD THAT CAN BE READ BACK

Cursor · 2026-09-07 · `ScheduleHubPanel.gd` + its test. Top tier / high / Fast off.

## What shipped

C40 landed (`channel` on every offer). All three parts:

1. Open event feeds `_event.results` to `get_scorecards_read()` once per rebuild. A decision prints the judges; a bout that did not go to the cards prints its method; an empty result prints nothing.
2. `get_belt_scale_read(open_event, selected_bout)` once per rebuild. `belt_not_on_the_line` is said in words on the tape. Empty / still-a-title-fight prints nothing.
3. `_amateur_verb` reads `channel`: CONFIRM THE MATCH for matchmaker / gym-to-gym / short_notice, ENTER THE CARD for `open_card` and for an absent field. Never ACCEPT. CONFIRM still writes through `book_fight()` (U4 D5), not OPEN AGREEMENT.

## Gate

`python Godot/tools/check_scripts.py Godot/scripts/ScheduleHubPanel.gd` — pass.

`tests/schedule_hub_panel_test.gd` 64/64. `tests/amateur_board_test.gd` 45/45 (ENTER path unchanged; CONFIRM added). `tests/scorecard_read_test.gd` 11/11. `tests/belt_scale_read_test.gd` 9/9. `tests/schedule_hub_api_test.gd` 804/804. Full suite **164/164**.

## Left

GameState / ScorecardRead / ChampionshipRead / UIKit untouched. `gym_to_gym` still has no producer (C40).
