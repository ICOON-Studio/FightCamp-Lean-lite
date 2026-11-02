# U128 digest — region panel in UIKit

**Branch:** `cursor/u128-region-panel`

## Shipped

- `UITokens`: `STAT_ROW_PITCH_HUD` (24) plus G64 panel/column constants.
- `UIKit.stat_row`: `pitch`, `label_width`, `number_size`, `column_gap`, `bar_width`, `bar_fraction`, `track_colour`, `label_colour`, `hatch`, `doctor_glyph` — profile default pitch stays 30.
- `UIKit.region_panel(regions, opts)`: 220×164, `BODY` header, six rows via `stat_row` at 24 px; M23 fill/hatch/glyph from `region_readout_state` (condition ≤15 doctor, ≤35 critical, ≤55 hurt, else fine).
- `tests/ui_region_panel_test.gd`.

## Gate

Parse gate on touched `.gd`; `ui_region_panel_test` 0 failures; `ui_stat_row_contract_test` checks=18 failures=0; `run_tests.py --only ui` total=13 fails=1 (pre-existing `ui_kit_book_test.gd` rc=1); `--only screen` total=5 fails=0.

## Trap avoided

No fourth row child; no `caps()` on region labels; panel rows use fixed 112 px bar width and zero column gap so 52+112+40 fits 204.
