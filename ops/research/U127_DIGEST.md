# U127 digest — stat row + ProfileRevamp literals

**Branch:** `cursor/u127-stat-row`

## Shipped

- `UIKit.stat_row(label, value, max_value, opts)` — 30 px row, label | bar (55% of row width) | tabular right number; opts `bar_colour`, `show_bar`, `grade`, `width`; ellipsis on labels; hairline sep.
- `UITokens` — M22 named colours, stat-row geometry, spacing (8 px base + 4 px half-step comment naming M22 vs G63).
- `ProfileRevampPanel` — attribute list via `VBoxContainer` at fixed 30 px pitch; discipline, loyalty part, fatigue/conditioning rows via `stat_row`.
- `tests/ui_stat_row_test.gd` — contract checks.
- `ui_kit_manifest.json` — `stat_row` listed under `helpers` for book parity (renders deferred).

## Gate

- Parse: `check_scripts` on touched `.gd` — 0 fails.
- `--only ui`: SUITE total=11 fails=0.
- `--only screen`: SUITE total=5 fails=0.
- U126 census (two runs agree): **ProfileRevampPanel literals 918 → 895** (−23).

## Headless

`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/ui_stat_row_test.gd`
