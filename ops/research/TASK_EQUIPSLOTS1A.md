# TASK EQUIPSLOTS1A - authored equipment slots: data + purchase/replace/move rules + geometry test (Codex)

Model: Codex luna, medium effort (pure data + GameState logic + tests; no visuals in this part).
Approved design: `research/LUDO_ROUND45_VERDICT_S212.md` (operator Q-S211-2 "Yes - build it as in the verdict"). Read its
TAKEN 1, 4, 5, 6, 7, 9 and CHANGED/REFUSED before coding. Part B (3D mounting, build-mode overlay, shop drawer) is a later task.

## The defect this fixes
`GameState.purchase_equipment` (GameState.gd:4044-4076) places a bought item on an abstract tile grid via `_find_first_fit`
(GameState.gd:4578) - the 3D club only draws its authored places, so a bought bag costs money and never appears.

## Spec
1. SLOT DATA in `Godot/assets/data/club_layouts/s206.json` (28 KB, the layout the game uses; read it whole - it is data) under a new
   top-level key `slots`: one row per slot `{id, zone, category, pos:[x,z], yaw_deg, footprint:[w,d], clearance_m, mount:"beam"|"wall"|"floor"|"ring", start_item:"<catalog_id>"|""}`.
   T1 counts (verdict TAKEN 5): bag_line_west beam 5 (4 filled), bag_line_east beam 3 (0), bag_wall_east 3 (0), cardio 4 (2),
   timing 4 (2), footwork 2 (1), stretch 3 (2), strength 5 (3), ring 1 (1) = 30 slots, 15 filled. boxing_floor has NO slots (stays
   open). The 15 filled slots use the positions of the existing authored places/props of the same kind (GymClubLayout.place_ids(),
   GymClub3D._prop_for, GymClub3D.gd:178) so nothing visible moves. Also a `slots_by_tier` block with T2/T3 counts per zone from the
   verdict (bags 8/14 west, cardio 8/14, strength 8/14, second ring at T3) - counts only, positions come with the T2 hall.
2. NEW pure module `Godot/scripts/club_capacity/EquipSlots.gd` (static funcs, no scene access, data passed in):
   `slots_for(layout: Dictionary, tier: int) -> Array`, `zone_usage(slots, items) -> Dictionary` ({zone: {used, total}}),
   `free_slot_for(slots, items, category, zone_hint) -> String`, `can_place(slot, catalog_row) -> bool` (category match, bag
   only on beam/wall mounts - verdict trap 9), `diminishing_return(k: int) -> float` = 1/sqrt(k) for the k-th station of a kind.
3. `GameState.purchase_equipment(catalog_id, slot_id := "")`: picks `slot_id` or `EquipSlots.free_slot_for`; zone full returns
   `{"ok": false, "reason": "ZONE FULL (CARDIO 4/4) - REPLACE A STATION OR MOVE TO A BIGGER GYM"}` (zone name + counts from data);
   the instance stores `slot_id` (keep its old x/y fields for save compatibility). Add `replace_equipment(instance_id, catalog_id)`
   (same slot; old item sold at condition x 50% of its purchase_cost) and make `move_equipment` accept a slot id of the same zone
   (keep the old x,y signature working - other callers exist: grep `move_equipment(`). Old saves: items without `slot_id` get the
   first compatible free slot on load (one migration function, idempotent).
4. Shop filter (verdict TAKEN 6): boxing club hides bodybuilding isolation machines (pec deck, preacher, leg extension/curl, calf,
   smith, hack squat, ab machine, the 10 bench types -> keep ONE adjustable bench) and MMA kit (tatami, grappling dummy, octagon) by
   setting `store_available: false` or a `requires: "mma"|"t2"` tag in `assets/data/equipment_catalog.json` - NEVER delete a row.
   Generic names only (no brand names).
5. Do NOT add Ludo's invented prices/gains/queue numbers (verdict CHANGED/REFUSED). The queue/peak-hour mechanic is part C.

## Owned files
- `Godot/assets/data/club_layouts/s206.json` (add `slots`, `slots_by_tier`)
- `Godot/assets/data/equipment_catalog.json` (flags only)
- `Godot/scripts/club_capacity/EquipSlots.gd` (new)
- `Godot/scripts/GameState.gd` (19,699 lines - NEVER read whole: `sed -n '4030,4130p'`, `sed -n '4570,4680p'`, grep `_make_equipment_instance`, `get_floor`)
- `Godot/tests/equip_slots_test.gd` (new)
- `Godot/tests/equipment_catalog_full_test.gd` (Claude review S213: legacy guard compares snapshot fields; `requires` may be added)

## Acceptance (the test you write first; it must fail on master)
`Godot/tests/equip_slots_test.gd`:
- T1 slot total 30, filled 15, boxing_floor 0; every slot rect (footprint + clearance) inside its zone rectangle
  (`GymClubLayout.zone_rect`) and not overlapping another slot or the ring apron; bag slots only on beam/wall mounts and >= 1.8 m apart.
- buying a heavy bag on a new career lands in a bag-beam slot and the instance has `slot_id`; buying until bag_line_west is full then
  once more -> ok=false with "ZONE FULL"; replace keeps the slot and refunds condition x 50%; move to another free slot of the zone works,
  to another zone fails; an old save row without slot_id migrates; the shop list contains no pec deck / smith / tatami.
- Prove it bites: break one rule (e.g. allow bags on floor mounts) and see the test go red, then restore.
Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/club_capacity/EquipSlots.gd Godot/scripts/GameState.gd Godot/tests/equip_slots_test.gd`.
Test: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/equip_slots_test.gd` (exe in %LOCALAPPDATA%\Programs\Godot\),
then `python Godot/tools/run_tests.py --only equip,club_fill,equipment,purchase --jobs 1` (ONE comma list).

## Prior research
LUDO_ROUND45_VERDICT_S212.md (design), GYM4_REDESIGN_S178.md (club plan), R146_EQUIPMENT_TRAINING_STUDY.md, U179_PROP_CENSUS.md
(catalogue <-> 3D props), EQUIPMOTION1A (machines in use, merged 2084057b).

## What would a human do?
Real boxing clubs hang bags from fixed beams and bolt machines to set spots; a manager buys "another bag for the free hook", never
"a bag somewhere on a grid". Management sims (Two Point Hospital, Planet Coaster build zones) snap to valid spots and say why a spot is invalid.

## Prefab check
No Godot prefab for authored slot snapping fits our data-driven layout; this is ~150 lines of pure GDScript over our own JSON.

## The one trap
GameState.gd is 19,699 lines and shared - edit only the named functions, keep every existing signature working (callers: grep
`purchase_equipment(` and `move_equipment(` across scripts/ and tests/), and run the dependent tests listed above, not only yours.
Windows: no popups, never open images; check `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` before Godot runs.
Commit on branch codex/equipslots1a and push.
