# U129 digest

- `UIKit.scored_card(round, rows, opts)`: 560×236, header `R n` at 12 px title rule + 28 px header, six 30 px rows (STAT 200 / A 120 / B 120 / Δ 120); signed Δ via `_format_signed_delta` (**zero → `0`**); accuracy row uses `region_number`; ≠6 rows → `null` without `push_error`.
- `UIKit.corner_tray(recommended, alternates[4], confirm, opts)`: 560×116 tray with 60/14 char clip budgets.
- Tokens in `UITokens.gd`; kit-book variants `scored-round-four`, `scored-even-delta`, `corner-tray-default` (PNG renders need `tools/render_kit.gd` windowed).
- Parse gate 0 fails; `ui_scored_card_test` 0 failures; `ui_stat_row_contract_test` checks=18 failures=0; `ui_region_panel_contract_test` checks=86 failures=0; `run_tests.py --only ui` total=15 fails=1 (`ui_kit_book_test` missing 3 new renders, pre-existing class of failure).
