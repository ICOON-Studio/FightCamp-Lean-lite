# Gym capacity estimate (GYMCAP1)

Method: deterministic row packing, a lower bound. All station rectangles use `real_zone` metre dimensions from `TrainingFloorLayout.gd`; catalogue footprint cells are not metres. A 0.5 m authored wall allowance and the 1.5 m door allowance are removed; non-ring equipment reserves one 8 x 8 m ring plus a 1.2 m aisle. Rows have a 1.2 m aisle; items within a row touch in this simplified estimate.

Area used is the sum of placed station use-zone rectangles, including the 8 x 8 m ring, divided by gross hall area; it excludes walking aisles and support cupboards. Store items are required only when their minimum tier is met and their real-zone area is at most 15% of gross hall area. Oversized items appear under `too big for this tier`; eligible stations with no legal placement appear under `unplaced required`. Unplaced required items are called out separately. Support items are listed once and do not add athlete slots.

## 1. Maximum copies of one item

| Item ID | T1 | T2 | T3 |
|---|---:|---:|---:|
| `club_ring` | 3 | 8 | 21 |
| `heavy_bag` | 24 | 45 | 112 |
| `speed_bag` | 78 | 152 | 341 |
| `focus_mitts_locker` | 133 | 319 | 637 |
| `compact_weights` | 28 | 55 | 133 |
| `cardio_floor` | 65 | 133 | 297 |
| `first_aid` | 133 | 319 | 637 |
| `double_end_bag` | 45 | 98 | 216 |
| `exercise_bike` | 65 | 133 | 297 |
| `physio_table` | 36 | 70 | 168 |
| `mobility_stretch_station` | 45 | 98 | 216 |
| `air_bike` | 65 | 133 | 297 |
| `cold_water_tub` | 36 | 84 | 192 |
| `rowing_ergometer` | 39 | 95 | 198 |
| `rehabilitation_pool` | 9 | 18 | 44 |
| `sports_medicine_room` | 18 | 36 | 80 |
| `modular_combat_mat` | 24 | 45 | 112 |
| `judo_tatami_area` | 24 | 45 | 112 |
| `grappling_dummy` | 28 | 66 | 152 |
| `striking_safety_locker` | 133 | 319 | 637 |
| `capoeira_roda_kit` | 12 | 28 | 60 |
| `arnis_safety_kit` | 28 | 66 | 152 |
| `footwork_ladder_set` | 52 | 95 | 231 |
| `plyometric_step_rig` | 28 | 55 | 133 |
| `reaction_footwork_grid` | 15 | 40 | 84 |
| `lat_pulldown_dual_pulley` | 24 | 45 | 112 |
| `vertical_chest_press` | 24 | 45 | 112 |
| `assisted_chin_dip` | 24 | 45 | 112 |
| `seated_leg_curl` | 24 | 45 | 112 |
| `leg_extension` | 24 | 45 | 112 |
| `multi_functional_trainer_v` | 18 | 36 | 84 |
| `standing_lateral_fly_machine` | 24 | 45 | 112 |
| `leg_press_45` | 24 | 45 | 112 |
| `isolated_bicep_curl` | 24 | 45 | 112 |
| `standing_leg_curl` | 24 | 45 | 112 |
| `calf_press` | 24 | 45 | 112 |
| `row_plate_loaded` | 24 | 45 | 112 |
| `seated_preacher_curl` | 24 | 45 | 112 |
| `wide_chest_press` | 24 | 45 | 112 |
| `abdominal_crunch_machine` | 24 | 45 | 112 |
| `pulldown_trainer_plate` | 24 | 45 | 112 |
| `butterfly_pec_deck` | 24 | 45 | 112 |
| `hack_squat` | 24 | 45 | 112 |
| `split_row_trainer` | 24 | 45 | 112 |
| `seated_row` | 24 | 45 | 112 |
| `incline_chest_press_plate` | 24 | 45 | 112 |
| `shoulder_press_machine` | 24 | 45 | 112 |
| `hip_abductor` | 24 | 45 | 112 |
| `glute_kickback` | 24 | 45 | 112 |
| `back_extension` | 24 | 45 | 112 |
| `deluxe_power_rack` | 24 | 45 | 112 |
| `olympic_fid_bench` | 36 | 70 | 168 |
| `super_bench` | 36 | 70 | 168 |
| `flat_bench` | 36 | 70 | 168 |
| `adjustable_bench` | 36 | 70 | 168 |
| `olympic_incline_bench` | 36 | 70 | 168 |
| `olympic_decline_bench` | 36 | 70 | 168 |
| `multi_purpose_bench` | 24 | 45 | 112 |
| `preacher_curl_bench` | 36 | 70 | 168 |
| `smith_machine` | 24 | 45 | 112 |
| `cable_crossover` | 18 | 36 | 84 |
| `squat_stand` | 24 | 45 | 112 |
| `weight_tree_plates` | 36 | 70 | 168 |
| `dumbbell_rack` | 36 | 70 | 168 |
| `adjustable_dumbbell_set` | 36 | 70 | 168 |
| `rubber_dumbbell_rack_5_50kg` | 24 | 45 | 112 |
| `kettlebell_set` | 36 | 70 | 168 |
| `olympic_barbell_and_plates` | 24 | 45 | 112 |
| `ez_curl_bar_set` | 36 | 70 | 168 |
| `bumper_plate_set` | 24 | 45 | 112 |
| `medicine_ball_set` | 36 | 70 | 168 |
| `slam_ball_set` | 36 | 70 | 168 |
| `sandbag_set` | 24 | 45 | 112 |
| `weighted_vest` | 36 | 70 | 168 |
| `battle_ropes` | 18 | 42 | 96 |
| `plyo_box_set` | 24 | 45 | 112 |
| `treadmill_commercial` | 36 | 70 | 168 |
| `treadmill_curved_manual` | 36 | 70 | 168 |
| `elliptical_trainer` | 36 | 70 | 168 |
| `elliptical_crosstrainer` | 36 | 70 | 168 |
| `spin_bike` | 36 | 70 | 168 |
| `recumbent_bike` | 36 | 70 | 168 |
| `stair_climber` | 36 | 70 | 168 |
| `ski_erg` | 36 | 70 | 168 |
| `rowing_machine_air` | 36 | 70 | 168 |
| `rowing_machine_water` | 36 | 70 | 168 |
| `rowing_machine_magnetic` | 36 | 70 | 168 |
| `jump_rope_station` | 36 | 70 | 168 |
| `stability_ball_set` | 24 | 45 | 112 |
| `bosu_trainer` | 36 | 70 | 168 |
| `yoga_mat_area` | 24 | 45 | 112 |
| `foam_roller_set` | 36 | 70 | 168 |
| `suspension_trainer_station` | 36 | 70 | 168 |
| `turf_sled_lane` | 12 | 27 | 64 |
| `high_density_rubber_mat_zone` | 12 | 28 | 60 |

## 2. Full mix by tier

| Tier | Counts (item x count) | Support | Zone area / gross hall | Station slots | Unplaced required | Too big for this tier | Space-limited |
|---|---|---|---:|---:|---|---|---|
| T1 | club_ring x 1, heavy_bag x 1, speed_bag x 1, double_end_bag x 1, exercise_bike x 2, mobility_stretch_station x 1, air_bike x 1, rowing_ergometer x 1, rehabilitation_pool x 1, sports_medicine_room x 1, capoeira_roda_kit x 1, footwork_ladder_set x 3, plyometric_step_rig x 1, reaction_footwork_grid x 1, assisted_chin_dip x 1, calf_press x 1, abdominal_crunch_machine x 1, butterfly_pec_deck x 1, hack_squat x 1, incline_chest_press_plate x 1, hip_abductor x 1, glute_kickback x 1, back_extension x 1, deluxe_power_rack x 1, adjustable_bench x 1, adjustable_dumbbell_set x 1, bumper_plate_set x 1, battle_ropes x 1, bosu_trainer x 1, turf_sled_lane x 1, high_density_rubber_mat_zone x 1 | striking_safety_locker, first_aid, focus_mitts_locker | 64.5% | 50 | isolated_bicep_curl, judo_tatami_area, lat_pulldown_dual_pulley, leg_extension, leg_press_45, modular_combat_mat, multi_purpose_bench, olympic_barbell_and_plates, plyo_box_set, pulldown_trainer_plate, row_plate_loaded, rubber_dumbbell_rack_5_50kg, sandbag_set, seated_leg_curl, seated_preacher_curl, seated_row, shoulder_press_machine, split_row_trainer, squat_stand, stability_ball_set, standing_lateral_fly_machine, standing_leg_curl, vertical_chest_press, wide_chest_press, yoga_mat_area, arnis_safety_kit, grappling_dummy, dumbbell_rack, elliptical_crosstrainer, elliptical_trainer, ez_curl_bar_set, flat_bench, foam_roller_set, jump_rope_station, kettlebell_set, medicine_ball_set, olympic_decline_bench, olympic_fid_bench, olympic_incline_bench, physio_table, preacher_curl_bench, recumbent_bike, rowing_machine_air, rowing_machine_magnetic, rowing_machine_water, ski_erg, slam_ball_set, spin_bike, stair_climber, super_bench, suspension_trainer_station, treadmill_commercial, treadmill_curved_manual, weight_tree_plates, weighted_vest, cold_water_tub | None | None |
| T2 | club_ring x 1, heavy_bag x 1, speed_bag x 1, double_end_bag x 1, exercise_bike x 1, air_bike x 1, cold_water_tub x 1, rowing_ergometer x 1, rehabilitation_pool x 1, sports_medicine_room x 1, modular_combat_mat x 1, judo_tatami_area x 1, capoeira_roda_kit x 1, footwork_ladder_set x 2, reaction_footwork_grid x 1, lat_pulldown_dual_pulley x 1, vertical_chest_press x 1, assisted_chin_dip x 1, seated_leg_curl x 1, leg_extension x 1, multi_functional_trainer_v x 1, standing_lateral_fly_machine x 1, leg_press_45 x 1, isolated_bicep_curl x 1, standing_leg_curl x 1, calf_press x 1, row_plate_loaded x 1, seated_preacher_curl x 1, abdominal_crunch_machine x 1, pulldown_trainer_plate x 1, butterfly_pec_deck x 1, hack_squat x 1, split_row_trainer x 1, seated_row x 1, incline_chest_press_plate x 1, shoulder_press_machine x 1, hip_abductor x 1, glute_kickback x 1, back_extension x 1, deluxe_power_rack x 1, adjustable_bench x 1, multi_purpose_bench x 1, smith_machine x 1, cable_crossover x 1, squat_stand x 1, dumbbell_rack x 1, adjustable_dumbbell_set x 1, rubber_dumbbell_rack_5_50kg x 1, olympic_barbell_and_plates x 1, bumper_plate_set x 1, sandbag_set x 1, battle_ropes x 1, plyo_box_set x 1, stability_ball_set x 1, bosu_trainer x 1, turf_sled_lane x 1, high_density_rubber_mat_zone x 1 | striking_safety_locker, first_aid, focus_mitts_locker | 58.0% | 76 | wide_chest_press, yoga_mat_area, plyometric_step_rig, arnis_safety_kit, grappling_dummy, elliptical_crosstrainer, elliptical_trainer, ez_curl_bar_set, flat_bench, foam_roller_set, jump_rope_station, kettlebell_set, medicine_ball_set, olympic_decline_bench, olympic_fid_bench, olympic_incline_bench, physio_table, preacher_curl_bench, recumbent_bike, rowing_machine_air, rowing_machine_magnetic, rowing_machine_water, ski_erg, slam_ball_set, spin_bike, stair_climber, super_bench, suspension_trainer_station, treadmill_commercial, treadmill_curved_manual, weight_tree_plates, weighted_vest, mobility_stretch_station | None | None |
| T3 | club_ring x 1, heavy_bag x 13, speed_bag x 5, double_end_bag x 3, exercise_bike x 9, physio_table x 2, mobility_stretch_station x 2, air_bike x 8, cold_water_tub x 2, rowing_ergometer x 5, rehabilitation_pool x 1, sports_medicine_room x 2, modular_combat_mat x 6, judo_tatami_area x 3, grappling_dummy x 5, capoeira_roda_kit x 2, arnis_safety_kit x 5, footwork_ladder_set x 5, plyometric_step_rig x 2, reaction_footwork_grid x 3, lat_pulldown_dual_pulley x 2, vertical_chest_press x 2, assisted_chin_dip x 2, seated_leg_curl x 2, leg_extension x 2, multi_functional_trainer_v x 1, standing_lateral_fly_machine x 1, leg_press_45 x 1, isolated_bicep_curl x 1, standing_leg_curl x 1, calf_press x 1, row_plate_loaded x 1, seated_preacher_curl x 1, wide_chest_press x 1, abdominal_crunch_machine x 1, pulldown_trainer_plate x 1, butterfly_pec_deck x 1, hack_squat x 1, split_row_trainer x 1, seated_row x 1, incline_chest_press_plate x 1, shoulder_press_machine x 1, hip_abductor x 1, glute_kickback x 1, back_extension x 1, deluxe_power_rack x 1, olympic_fid_bench x 1, super_bench x 1, flat_bench x 1, adjustable_bench x 1, olympic_incline_bench x 1, olympic_decline_bench x 1, multi_purpose_bench x 1, preacher_curl_bench x 1, smith_machine x 1, cable_crossover x 1, squat_stand x 1, weight_tree_plates x 1, dumbbell_rack x 1, adjustable_dumbbell_set x 1, rubber_dumbbell_rack_5_50kg x 1, kettlebell_set x 1, olympic_barbell_and_plates x 1, ez_curl_bar_set x 1, bumper_plate_set x 1, medicine_ball_set x 1, slam_ball_set x 1, sandbag_set x 1, weighted_vest x 1, battle_ropes x 1, plyo_box_set x 1, treadmill_commercial x 1, treadmill_curved_manual x 1, elliptical_trainer x 1, elliptical_crosstrainer x 1, spin_bike x 1, recumbent_bike x 1, stair_climber x 1, ski_erg x 1, rowing_machine_air x 1, rowing_machine_water x 1, rowing_machine_magnetic x 1, jump_rope_station x 1, stability_ball_set x 1, bosu_trainer x 1, yoga_mat_area x 1, foam_roller_set x 1, suspension_trainer_station x 1, turf_sled_lane x 1, high_density_rubber_mat_zone x 1 | striking_safety_locker, first_aid, focus_mitts_locker | 65.8% | 216 | None | None | None |

## 3. Stations per tier by category

| Category | T1 | T2 | T3 |
|---|---:|---:|---:|
| Ring | 1 | 1 | 1 |
| Bags | 3 | 4 | 22 |
| Strength | 16 | 38 | 59 |
| Cardio | 5 | 4 | 35 |
| Mats | 6 | 7 | 31 |
| Recovery | 3 | 4 | 11 |

## 4. People at once

| Tier | Station slots (physical) | Supervised slots (coaches x 10) | Fighters max (minimum) | Members max | Total max |
|---|---:|---:|---:|---:|---:|
| T1 | 50 | 20 | 20 | 60 | 80 |
| T2 | 76 | 40 | 40 | 150 | 190 |
| T3 | 216 | 80 | 80 | 360 | 440 |

Members use min(tier `member_capacity`, floor(gross hall m2 / 4.65 m2/person)); `verified: false`. Per-tier coaches are authored and `verified: false`; source: Authored planning assumption for TASK_GYMCAP1B; per-tier coach headcounts are unverified. Supervised slots use 10 athletes/coach.

## Three largest surprises

1. The starting club requires eligible station items whose real-zone area fits the hall; 0 oversized items are called out separately.
2. The heavy-bag row is 3 x 3 m per athlete zone, so single-item counts differ sharply from catalogue grid cells. T1 through T3 fit 24, 45, and 112 heavy-bag zones respectively.
3. Per-tier coach assumptions change the supervised limit; they remain unverified. The conservative 4.65 m2/person member fallback is also unverified.

## Rule provenance

- Station zones: `Godot/scripts/TrainingFloorLayout.gd` `DEVICES.real_zone` values, metres and clearance included.
- Ring: `gym_club.json` ring size, 8 x 8 m, as directed in TASK_GYMCAP1.
- Door margin: `TrainingFloorLayout.gd` `DOOR_WALL_MARGIN_M = 1.5`. Wall margin, staffing assumptions, and mix order are labelled authored constants in `assets/data/club_capacity_rules.json`.
- Fallback items without a `real_zone`: footprint cell dimensions treated as 1.0 m per cell plus 0.5 m on each side.
- People density: 50 sq ft / 4.65 m2 fallback, `verified: false`; no building-code figure was verified in the cited research.
