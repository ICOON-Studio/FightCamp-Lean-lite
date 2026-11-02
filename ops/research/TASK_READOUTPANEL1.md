# TASK READOUTPANEL1 - the fighter readout as a drawer panel (renders data, no GameState) + headless test (S198)
Model: Arena (cloud). Repository ICOON-Studio/FightCamp (Godot 4.7.2, GDScript in Godot/). Own arena/ branch, PR into master, never merge.

## Owned files
- `Godot/scripts/ui/FighterReadoutPanel.gd` (NEW)
- `Godot/tests/fighter_readout_panel_test.gd` (NEW)

## Spec (operator approved: Ludo round 32 A "the fighter readout", board Q-S196-2 verbatim: "amazing, approve all and use 0-100
## for band as ludo says") - the readout shows Ludo's 0-100 numbers. (The 1-20 note in LUDO_ROUND32_VERDICT_S197.md A is OVERRULED.)
`class_name FighterReadoutPanel extends VBoxContainer`. `static func build(athlete: Dictionary, opts: Dictionary = {}) -> FighterReadoutPanel`.
Data comes ONLY from the pure module `res://scripts/rules/FighterReadout.gd` (read it: `headlines(athlete)`, `regions(athlete)`,
`composure_band(v)`, `masked(readout, scout_level)`); opts: `scout_level` (0-3, default 3 = own fighter), `width` (default 700 - the
drawer body width at 1920: 0.382 x 1920 minus padding), `month_ago` (athlete dict for deltas via `with_delta`, optional).
Layout, top to bottom:
1. Header row: name, age, record (`UIKit.record_text(athlete)` from `res://scripts/UIKit.gd`), weight class if present, composure
   band chip (name + colour from composure_band).
2. 9 headline cards in a 3 x 3 GridContainer. Each card: label, the 0-100 number FighterReadout gives (tooltip "scale 0-100"),
   a 0-100 bar, and the +/- change since last month when `month_ago` is given (one decimal). Scout masks: level 0 shows
   the letter text FighterReadout gives ("C- to A") and no bar; level 1 shows the RANGE "62-72"; level 2/3 the exact number.
3. Body: 6 region rows (label, wear %, band name, colour swatch from the row's `color`) - hidden (one line "Body condition: scout
   level 3 needed") when the masked readout has `regions_visible == false`.
Every number/label that needs explaining gets a tooltip through `UIKit.tip(node, "text")` (NEVER `tooltip_text` - it is cleared in
this project). Colours: background #12161F, accent #D69E2E (Ludo round 31). No GameState, no autoload reads, no scene changes.

## Test - `Godot/tests/fighter_readout_panel_test.gd` (extends SceneTree; prints `READOUTPANEL total=N fails=M`; quit(1) on fail)
Two DIFFERENT fighters (different stats, ages, records - never identical fixtures): (a) 9 headline cards exist and each shows
its row's FighterReadout value (read the Label text); (b) every bar's value equals its card's number and no number > 100; (c) level 1
shows a range "a-b" equal to FighterReadout.masked's range; level 0 shows no digits on the cards; (d) regions hidden below level 3, 6 rows at level 3
with the band names from FighterReadout; (e) with month_ago a delta label appears with a sign; (f) the panel's minimum width <= opts
width (nothing wider than the drawer). List 3 mutants in the PR body that each fail it.

## Gate
`godot --headless --path Godot --script tests/fighter_readout_panel_test.gd` exits 0, fails=0, no SCRIPT ERROR. Typed GDScript, tabs,
never `:=` on a Variant. No LFS models are loaded. Do not commit .import/.uid files or the .godot cache.

## Prior research
LUDO_ROUND32_S197.txt PART 2 (the readout layout), LUDO_ROUND32_VERDICT_S197.md A, scripts/rules/FighterReadout.gd + tests/fighter_readout_test.gd.
## What would a human do?
A UI designer shows the readout's numbers exactly as the approved design states them, - a number, a bar and the month's change per card.
## Prefab check
None - project UI kit.

## The one trap
Show FighterReadout's numbers as they are (0-100) - do not convert them to the signing card's 1-20, and do not edit FighterReadout.gd.
