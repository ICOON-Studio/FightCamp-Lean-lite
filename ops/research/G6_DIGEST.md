# G6 COMPLETE (bodies on origin)

Commits:
- `02f8691` test file
- `d8cdfb1` `Godot/scripts/UIKitShell.gd` (twelve factories)
- `a4c33dd` test points at Shell until UIKit wrappers land
- this commit: wrappers to append + digest

Still needed on the game tree (this sandbox cannot rewrite 50KB UIKit/manifest in one API call):
1. Append `research/G6_APPEND_UIKIT.gd.txt` to `Godot/scripts/UIKit.gd`.
2. Add family `shell` to `Godot/assets/data/ui_kit_manifest.json` (see HANDOFF G6 list; 1-3 variants per factory).
3. Parse gate + `ui_kit_shell_test.gd` + `ui_kit_test.gd` + `ui_kit_book_test.gd` (unrendered shell ids expected).

Factories: command_list, ledger_row, stat_tile, briefing_hero, ticker_row, action_card, alerts_column, result_card, moment_row, champion_mark, record_cell, division_switcher.
Kit look: raised, gym + gold. Not MMA Empire glass/red.
