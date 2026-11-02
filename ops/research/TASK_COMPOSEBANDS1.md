# TASK COMPOSEBANDS1 (S209) - composure band rename: a normal boxer reads SETTLED, not RATTLED

Model: Arena (cloud). Repo ICOON-Studio/FightCamp, base master. Work on your own branch, open a PR; never merge.
Operator approved (board Q-S207-2, answer "Approve all"), item 4 of `research/LUDO_ROUND43_VERDICT_S208.md`:
"rename the bands so a normal fighter reads SETTLED (80+ FOCUSED, 55-79 SETTLED, 25-54 RATTLED, 0-24 BROKEN)".

## The rename (names only - every threshold, colour and effect value stays exactly as it is)
Old -> new, in this order of meaning (best to worst): Focused -> Focused, Rattled -> Settled, Shaken -> Rattled, Broken -> Broken.
So the band that is called "Rattled" today becomes "Settled", and the band called "Shaken" today becomes "Rattled".
Two systems carry the names:
1. `Godot/assets/data/composure.json` (band rows read by `Godot/scripts/Composure.gd` `_band_row` / `band()`), Title case:
   Focused / Settled / Rattled / Broken.
2. `Godot/scripts/rules/FighterReadout.gd` `composure_band()` (~line 91), UPPER case: FOCUSED / SETTLED / RATTLED / BROKEN.
Every consumer that matches on the old names must follow the move (same effect for the same band, new name):
- `Godot/scripts/LudoFightHud.gd` `composure_band_color` (~395) and `composure_tip` (~408): "Settled" keeps today's Rattled colour
  (COMPOSURE_YELLOW) and tip text "hesitates on counters"; "Rattled" takes today's Shaken colour (COMPOSURE_ORANGE) and tip
  "guards drop, hooks fly".
- `Godot/scripts/rules/ApronShouts.gd` (~34): "Settled" band_mult 0.85, "Rattled" band_mult 0.50 (today's values for the same bands).
- `Godot/scripts/rules/CardAutofire.gd` (~58) matches "Broken" only - unchanged; check.
- `Godot/scripts/animation/IntentBus.gd` COMPOSURES is a different vocabulary (lowercase animation intents) - leave it alone.
- Search the whole repo for any other "Shaken" / "Rattled" / "SHAKEN" / "RATTLED" used as a composure band and move it the same way.

## Tests (update to the new names; no assertion may be deleted or weakened)
`Godot/tests/composure_test.gd` (~99-102), `Godot/tests/fighter_readout_test.gd` (~145-148), `Godot/tests/ludo_fight_hud_test.gd`
(~98-99, ~119), `Godot/tests/ludo_r17_math1_test.gd` (~55, ~59 pass "Rattled" to attempt_shout - after the rename the band with
mult 0.85 is "Settled": change those two calls to "Settled" so the expected numbers stay identical).
NEW `Godot/tests/composure_bands_rename_test.gd`: (a) Composure.band(60.0) == "Settled" (the old "Rattled" range); (b) the old Shaken
range maps to "Rattled"; (c) FighterReadout.composure_band(65.0).name == "SETTLED" and (40.0).name == "RATTLED"; (d) no band row in
composure.json or FighterReadout is named "Shaken"/"SHAKEN"; (e) ApronShouts adherence for "Settled" equals the value the old "Rattled"
produced (0.85 multiplier) - prove it by computing both from the same inputs.
Acceptance: CI "Parse gate + changed tests" green on your PR. These tests load no LFS models.

## Owned files
- `Godot/assets/data/composure.json`
- `Godot/scripts/rules/FighterReadout.gd`
- `Godot/scripts/LudoFightHud.gd`
- `Godot/scripts/rules/ApronShouts.gd`
- `Godot/scripts/rules/CardAutofire.gd`
- `Godot/tests/composure_bands_rename_test.gd`, `Godot/tests/composure_test.gd`, `Godot/tests/fighter_readout_test.gd`,
  `Godot/tests/ludo_fight_hud_test.gd`, `Godot/tests/ludo_r17_math1_test.gd`
Nothing else (if the search finds another consumer, list it in the PR body).

## The one trap
Doing the two renames one after the other with find/replace turns everything into "Rattled" -> "Settled" twice. Rename in one pass by meaning.

## Prior research
LUDO_ROUND43_VERDICT_S208.md "Also noticed"; Composure.gd header (V14 bands). ## What would a human do? Rename the labels, keep the maths.
## Prefab check: none (text rename).
