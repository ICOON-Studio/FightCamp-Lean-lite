# U5 DIGEST — THE BELT BOARD, ONE READ

Cursor · 2026-09-07 · `RankingsHubPanel.gd` + its test. Top tier / high / Fast off.

## What shipped

CHAMPIONS takes `get_championships_read()` once per rebuild into `_championship_rows` / `_belt_reads`, keyed by the scoped discipline × sex. THE DIVISION and P4P never pay for it. Unseeded classes still draw `ChampionshipRead.empty()`.

G15 `BeltLineage.board()` is spent on that scoped array: longest current reign, most defences, newest champion, vacant count. MUTED board line, no new token. The save writes `title_status: champion`; G15 reads `held` — mapped at the call site, not inferred as a lineage.

`since_week: 0` prints no reign date (never `SINCE WEEK 0`, never `0 WEEKS`). Vacancy copy at `_vacancy_text` is unchanged.

## Gate

`python Godot/tools/check_scripts.py Godot/scripts/RankingsHubPanel.gd` — pass.

`tests/rankings_hub_panel_test.gd` 82/82. `tests/championship_read_test.gd` 8/8. `tests/rankings_api_test.gd` 49/49. `tests/belt_lineage_test.gd` green. Full suite **164/164**.

## Left

U6 (after C40, last). GameState / ChampionshipRead / UIKit untouched.
