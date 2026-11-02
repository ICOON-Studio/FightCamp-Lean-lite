# TASK EQUIP2B - every catalogue item trains something: fit + day-lap rows for the 93 items that have none (S197)
Model: cloud Codex (issue label `codex`) - pure data + one test, no LFS, no Godot window.
Why: `Godot/assets/data/equipment_catalog.json` has 95 items; `station_discipline_fit.json` and `day_lap_stations.json` cover
only 12 station kinds (treadmill, bike, weights, heavy_bag, speed_bag, ...). 93 item ids have NO row, so a fighter placed on
them trains nothing. The starting gym is being filled with these items now (GYMFILL1) - they must work.

## What to do
1. For EVERY item id in equipment_catalog.json `items[]` that is not a key in `day_lap_stations.json` `stations`, add a row in
   the SAME shape as the existing rows: `{"label": <display_name>, "trains": {<attribute>: <gain per fresh hour>}, "drain_per_hour": <int>}`.
   Use only attribute keys that already appear in existing `trains` blocks (read them all first). Values must sit inside the
   range of existing rows for the same kind of work (cardio ~ treadmill/bike, strength ~ weights, striking ~ heavy_bag/speed_bag,
   recovery/stretch = negative drain, i.e. refills). A machine that is a variant of an existing station copies its numbers
   +-20%, with a reason in a `"basis"` field naming the existing station it derives from.
   Items whose `category` is ring, decor, storage or purely structural (mats, flooring zones) get `"trains": {}` and
   `"basis": "not a training station"` - but a mat zone used for stretching/mobility is recovery.
2. Same for `station_discipline_fit.json` `stations`: a block per added training id in the existing shape
   (`summary` + `disciplines.{boxing,kickboxing,muay_thai,mma,bjj,wrestling,judo,...}.{fit, why}`) - use the discipline keys the
   file already uses; fit in [0.4, 1.2]; one plain-English `why` per discipline (<= 140 chars) a player can read.
3. Test `Godot/tests/equipment_training_rows_test.gd` (extends SceneTree, prints `EQUIP2B total=N fails=M`, quits 1 on fails):
   every catalogue id has a day-lap row; every non-empty `trains` key is a known attribute; drain within [-30, 30];
   every id with non-empty trains has a fit block with every discipline key and fit in [0.4, 1.2]; the 12 ORIGINAL rows are
   byte-identical to master (hard-code their current values in the test from master BEFORE you edit).
   Prove it with 3 mutants (delete a row, out-of-range fit, unknown attribute) - each must make it fail; list them in the PR.

## Owned files
Godot/assets/data/day_lap_stations.json, Godot/assets/data/station_discipline_fit.json, Godot/tests/equipment_training_rows_test.gd (new).
Do NOT change any .gd game script, and do not rename or remove existing keys.

## Gates (CI)
- `godot --headless --path Godot --script tests/equipment_training_rows_test.gd` -> exit 0, `fails=0`.
- Existing: tests/station_discipline_fit_test.gd, tests/day_lap_test.gd, tests/equipment_catalog_full_test.gd stay green.

## Prior research
STATIONS4 (the 12-station fit file and its why-lines), DAYLAP1A (day_lap_stations.json `note`: drain/efficiency model), EQUIP2 (95 items, real footprints).
## What would a human do?
A designer fills a spreadsheet: each machine, what it trains, how tiring it is, which sports benefit - derived from the closest known machine.
## Prefab check
n/a (our own data).
## The one trap
Inventing new attribute names makes the rows silently train nothing. Only keys that already exist.
Branch `codex/issue-<n>`; open the PR; never touch master.
