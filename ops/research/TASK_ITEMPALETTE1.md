# TASK ITEMPALETTE1 - the build palette: every catalogue item sorted by room, then type (pure rules)

Model: Goose (cloud, label `goose`). Discipline: BOXING (demo) - the gym building (GYMBUILD step C).

## Why (operator S276, verbatim)
"can you make a pallette of the gym and a sidebar menu with all the assets and i can start building the gym myself";
"sort items that can be bought by room"; "if text becomes too heavy replace it with an icon and a toolip".
Plan: research/GYMBUILD_PLAN_S276.md (target 3). Claude builds the sidebar UI on top of this module; this task is ONLY the
pure data module the sidebar reads.

## Build: `Godot/scripts/rules/ItemPalette.gd` (NEW, pure: `extends RefCounted`, static funcs, no scene, no autoload)
Input is the parsed catalogue Dictionary (`res://assets/data/equipment_catalog.json`: {"version", "items": [ {id, display_name,
category, description, discipline_tags, footprint, purchase_cost, weekly_upkeep, maintenance_cost, store_available, quality_tier,
min_tier?, requires?, zone?, training_modifiers, station_capacity} ]}) - pass it in, never load files inside the module.
1. `const ROOM_OF_CATEGORY := {"ring": "training_floor", "bags": "training_floor", "strength": "training_floor", "cardio":
   "training_floor", "analysis": "film_room", "recovery": "physio"}` and `const ROOM_ORDER := ["training_floor", "reception",
   "office", "locker_room", "physio", "film_room"]`. Unknown category -> room "other" (listed last, never dropped).
2. `room_of(item: Dictionary) -> String`.
3. `palette(catalog: Dictionary, discipline: String, gym_tier: int) -> Array` - one row per room in ROOM_ORDER that has items (then
   "other"): `{"room": id, "groups": [{"category": c, "items": [row...]}]}`; groups sorted by category name; items by purchase_cost
   ascending then id. Item row: `{"id", "label": display_name, "price": purchase_cost, "upkeep": weekly_upkeep, "icon": category,
   "tooltip": <=90 chars built from description (first sentence, cut at a word), "size": footprint, "locked": bool, "lock_reason": String}`.
   Filter: only items whose discipline_tags contain `discipline` (an item with no tags = every discipline).
   Locks: `min_tier` > gym_tier -> locked, reason "Gym level %d"; `store_available == false` -> locked, reason "Not sold in shops";
   `requires` (an id or a list of ids) -> listed in the reason "Needs <label>" when the caller says it is not owned - add a 4th
   optional arg `owned: Dictionary = {}` (id -> true) and lock when any required id is missing.
4. `find(catalog: Dictionary, item_id: String) -> Dictionary` - the item row as in (3), {} when unknown.
5. `counts(palette_rows: Array) -> Dictionary` - room -> number of items (for the sidebar's tab badges).

## The proof: `Godot/tests/item_palette_test.gd` (NEW, `extends SceneTree`, pure, no LFS; prints `ITEM_PALETTE failures=<n>`)
Write it FIRST and show it red (module missing). Use a SMALL hand-made catalogue in the test (6-10 items over 4 categories, one with
no discipline tags, one kickboxing-only, one store_available false, one min_tier 3, one with requires) AND one block over the real
`equipment_catalog.json` (load it in the test): every item appears exactly once over all rooms for discipline "boxing" OR is filtered
out by its tags (count both and check they sum to the boxing-tagged + untagged total); sort order holds in every group; tooltips
<= 90 chars and never cut mid-word; control cases for each lock (the same item unlocked one step on the passing side).
Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/rules/ItemPalette.gd Godot/tests/item_palette_test.gd`.
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/item_palette_test.gd` (NEVER _console.exe).
PR body: `RESULT: tests/item_palette_test.gd -> ITEM_PALETTE failures=0`.

## Owned files
Godot/scripts/rules/ItemPalette.gd (new), Godot/tests/item_palette_test.gd (new). Touch NOTHING else (not the catalogue).

## Prior research
GYMBUILD_PLAN_S276.md; TWOPOINT_MUSEUM_STUDY_S243.md (TPM sorts its build menu by room then type); S277_GYM_EMPIRE_BENCHMARK.md
("Windows Paint" menus were its players' complaint - our sidebar is icons + tooltips); club_rooms/BuildMode.gd (catalog_price).

## What would a human do?
Two Point: open BUILD, pick the room's tab, scroll groups of item cards (icon, price, a one-line tooltip), locked cards greyed with
the reason.

## Prefab check
None needed - a ~150-line pure sorter over our own JSON.

## The one trap
Never drop an item silently (unknown category -> "other") and never invent a price; every lock has a control case.

## Contract
OWNS: Godot/scripts/rules/ItemPalette.gd, Godot/tests/item_palette_test.gd
RED_TEST: Godot/tests/item_palette_test.gd -> ITEM_PALETTE failures=0
REGRESSION: placement_rules_test
VISUAL: no
