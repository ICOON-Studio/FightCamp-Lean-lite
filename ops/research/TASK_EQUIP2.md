# TASK EQUIP2 - the equipment catalogue holds a REAL gym's equipment (about 70 new items), data only

Model: Cursor (local, cursor_task.cmd). Worktree E:/FightCamp/wt/EQUIP2, branch cursor/equip2. Never master, never HANDOFF.md, never AgentComms/.
Operator S196 (verbatim, with two pictures of real machine/equipment charts): "gyms have alot more equimpent than we show we isnt all that euipment".
Today `Godot/assets/data/equipment_catalog.json` has 25 items and ONE strength item (compact_weights). This step adds the real gym's equipment as DATA
(no art, no scene): every new item draws as a greybox through the existing DEVICES table until models are sourced (EQUIP3, separate).

## Owned files
- `Godot/assets/data/equipment_catalog.json` (version 2 -> 3; append items; schema per item as the existing rows: id, display_name, category,
  description, discipline_tags, footprint [cells], station_capacity, quality_tier, base_safety, purchase_cost, weekly_upkeep, maintenance_cost,
  store_available, training_modifiers) PLUS two NEW keys per new item: `min_tier` ("T1".."T4", from gym_tiers.json: the smallest facility that
  would have it) and `zone` (strength|cardio|mats|recovery|striking - an EXISTING zone, never a new one).
- `Godot/scripts/TrainingFloorLayout.gd` `DEVICES` table (~52-76): one row per new item: real `size` [w, d, h] metres and `real_zone` [w, d] metres
  (the area one athlete needs INCLUDING clearance), a `shape` from the shapes the greybox already draws (rack, bike, rower, table, mat, boxes,
  locker, crate...), and `zone`. Use real manufacturer-class footprints (a 45 degree leg press is ~2.4 x 1.4 m, a treadmill ~2.0 x 0.9 m, a power
  rack ~1.3 x 1.5 m, a cable crossover ~3.2 x 1.0 m, an olympic bench ~2.2 x 1.5 m); cite the source class in a comment, do not guess smaller.
- `Godot/tests/equipment_catalog_full_test.gd` (NEW). Do NOT edit other tests; fix a failing neighbour only if your data broke it, and say so.

## The list (from the operator's two pictures; ids snake_case; one row each; ~70)
- Selectorised/plate machines (category strength, cap 1, modifiers strength|power): lat_pulldown_dual_pulley, vertical_chest_press, assisted_chin_dip,
  seated_leg_curl, leg_extension, multi_functional_trainer_v, standing_lateral_fly_machine, leg_press_45, isolated_bicep_curl, standing_leg_curl,
  calf_press, row_plate_loaded, seated_preacher_curl, wide_chest_press, abdominal_crunch_machine, pulldown_trainer_plate, butterfly_pec_deck,
  hack_squat, split_row_trainer, seated_row, incline_chest_press_plate, shoulder_press_machine, hip_abductor, glute_kickback, back_extension.
- Racks and benches (strength): deluxe_power_rack, olympic_fid_bench, super_bench, flat_bench, adjustable_bench, olympic_incline_bench,
  olympic_decline_bench, multi_purpose_bench, preacher_curl_bench, smith_machine, cable_crossover, squat_stand, weight_tree_plates, dumbbell_rack.
- Free weights (strength, store): adjustable_dumbbell_set, rubber_dumbbell_rack_5_50kg, kettlebell_set, olympic_barbell_and_plates, ez_curl_bar_set,
  bumper_plate_set, medicine_ball_set, slam_ball_set, sandbag_set, weighted_vest, battle_ropes, plyo_box_set.
- Cardio (category cardio, cap 1, modifiers stamina|agility): treadmill_commercial, treadmill_curved_manual, elliptical_trainer, elliptical_crosstrainer,
  spin_bike, recumbent_bike, stair_climber, ski_erg, rowing_machine_air, rowing_machine_water, rowing_machine_magnetic, jump_rope_station.
- Mobility/functional (recovery or strength zone): stability_ball_set, bosu_trainer, yoga_mat_area, foam_roller_set, suspension_trainer_station,
  turf_sled_lane, high_density_rubber_mat_zone.
Existing ids stay untouched. Pick `discipline_tags` honestly: machines/free weights -> ["all"]; sandbag/battle ropes/slam ball -> add the striking
and grappling disciplines that really use them; judo/wrestling tags only where real.
TRAINING_MODIFIERS: use ONLY tags that already exist in the catalogue and in `GameState.TRAINING_MODIFIER_STAT` (the vocabulary test guards it):
strength, power, stamina, agility, balance, mobility, speed, hand_speed, recovery. No new tag.
PRICES (EUR/$ game money, consistent with the heavy bag 850): selectorised machine 2,200-4,800; plate-loaded 1,800-3,600; bench 250-900; rack
1,400-2,600; dumbbell sets 900-3,200; kettlebells 600; cardio machine 2,500-7,500 (commercial treadmill top); weekly_upkeep ~1.0-1.5% of price;
maintenance_cost ~12% of price; quality_tier 1-3. `store_available: true` for everything buyable; `min_tier` T1 for benches/free weights/bikes, T2
for most machines, T3 for the multi-station rigs, T4 for the pool-class items.

## Prior research
- `python Tools/prior_research.py equipment catalogue store stations real gym` first; research/topics/training_floor.md; D42_FRESH_EYES_TIER_AND_WEAR.md;
  LUDO_ROUND25/28 (tiers, wear); `station_discipline_fit.json` (STATIONS4: per-discipline fit - do NOT add rows here; EQUIP2B will).
- The catalogue is consumed by `GameState.gd` (market/placement), `equipment_market_filter_test`, `training_modifier_map_test`, `gym_hub_panel_test`.

## What would a human do?
Walk through a commercial gym with a notebook: every machine in the pictures is a row with its footprint, what muscle group it works, who needs it,
and what it costs; then check nothing in the game explodes when the store lists seventy more things.

## Spec
1. Append the items; every row has every key (derived check in the test).
2. DEVICES rows for every new id with `real_zone` >= `size` footprint + 0.3 m each side (derived check).
3. Market: the existing market filter shows the new store-available items under the right discipline filter without changing its code; if it needs a
   code change, STOP and report instead (that is a separate task).
4. No change to day_lap_stations.json, station_discipline_fit.json, or any scene.

## Done (tier: a data file + one table edited - parse, focused tests, related runs)
- `python Godot/tools/check_scripts.py Godot/scripts/TrainingFloorLayout.gd Godot/tests/equipment_catalog_full_test.gd`; JSON valid.
- `equipment_catalog_full_test.gd` RED first on master (count of missing ids - paste it), then green: every listed id present once; all keys present;
  every `training_modifiers` tag in TRAINING_MODIFIER_STAT; every new id has a DEVICES row with `real_zone` >= size; `min_tier` and `zone` valid
  (zone in the layout's ZONE_ consts, tier in gym_tiers.json); prices inside the ranges above; ids unique across old + new; the 25 old rows unchanged
  (compare against the git HEAD copy of the file, not a pasted literal).
- Related: `python Godot/tools/run_tests.py --only equipment --jobs 2`, `--only training_modifier --jobs 2`, `--only gym_hub --jobs 2`,
  `--only gym_decor --jobs 2` -> 0 fails (a failure caused by your data is yours to fix; an unrelated red goes in the report).
Final message: red count, green results, anything the market code could not take.

## The one trap
Counts leak: tests like `equipment_market_filter_test` compare the visible list to `_expected_ids` derived from the catalogue (fine) but other tests may
hard-code "25 items" or a category count - grep `25`/`size() ==` in the consumers before you start, and fix only counts your data changed, saying so.
