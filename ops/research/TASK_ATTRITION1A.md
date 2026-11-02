# TASK ATTRITION1A - each training area wears the body differently: pure module + data + test (S197)
Model: cloud Codex (issue label `codex`) - pure GDScript + JSON + one headless test; no LFS, no window, no game wiring.
Operator approved (board Q-S196-2, verbatim: "amazing, approve all and use 0-100 for band as ludo says") Ludo round 32 PART 3 -
research/LUDO_ROUND32_S197.txt (section "PART 3 - TRAINING AREAS AND THE BODY", 3.1 table + formulas, 3.2 the 12 mechanics) and
Claude's verdict research/LUDO_ROUND32_VERDICT_S197.md section B.

## Build (NEW files only)
1. `Godot/assets/data/area_wear.json`:
   - `areas`: Ludo's 8 areas (bag_line, speed_bag, sparring_ring, pads, cardio, strength, turf, stretch) with `stamina_per_hour`,
     `wear_per_hour` {region: percent}, `coach_role`, `coach_effect` (what the role reduces, as numbers).
   - Body regions are OURS: head_neck, torso_core, left_arm, right_arm, left_leg, right_leg. Map Ludo's: Head/Brain + Jaw + Neck/Eyes
     -> head_neck; Torso/Spine -> torso_core; Hands/Wrists, Shoulders, Arms -> split equally left_arm/right_arm (Ludo's "Right hand" ->
     right_arm); Legs/Knees/Ankles/Feet -> split left_leg/right_leg. Stretch heals ALL regions 6.5%/h.
   - `station_area`: EVERY station id in `Godot/assets/data/day_lap_stations.json` `stations` that has a non-empty `trains` -> one of the
     8 areas (derive from the id/label and Godot/assets/data/equipment_catalog.json `category`; e.g. heavy_bag -> bag_line, treadmill ->
     cardio, power_rack -> strength, ring_sparring -> sparring_ring, pads -> pads). Stations with empty trains are not listed.
   - `bands` (0-100 wear, operator: "use 0-100"): Pristine 0-14, Fatigued 15-39, Degraded 40-69 (-15% output in that region),
     Compromised 70-89 (-35%), Critical 90-100; each with Ludo's hex colour.
   - `combos_v1`: the six the verdict picked: kinetic_sequence (bag -> speed bag within 60 min: +25% speed gain), metacarpal_overload
     (bag -> pads: hand wear x2.25), concussion_ceiling (sparring > 2 sessions in 5 days: chin -1 per excess session for 14 days),
     dead_leg (leg wear > 60: footwork gain 0 on turf/bag line), rhythm_lock (speed bag within 30 min before sparring: +18% jab accuracy
     for 2 rounds), systemic_collapse (contact area under 15 stamina: injury chance 8.5%/min instead of 0.2%).
2. `Godot/scripts/rules/AreaWear.gd` - extends RefCounted, class_name AreaWear, pure static, loads + caches area_wear.json exactly like
   Godot/scripts/rules/CareerWear.gd. No GameState, no autoload, no RNG, no preload. Typed GDScript (never `:=` on a Variant). API:
   - `area_of(station_id: String) -> String` ("" when not a training station)
   - `wear_for(station_id: String, minutes: float, stamina: float, coach_roles: Array) -> Dictionary` {region: wear points 0-100 scale}
     using Ludo's formula Wear = Base x (1 + max(0, (25 - stamina) / 10)), scaled by minutes/60, reduced by a present coach role.
   - `apply(wear: Dictionary, delta: Dictionary) -> Dictionary` clamped 0..100 per region; stretch/negative values heal.
   - `band_of(value: float) -> Dictionary` {name, colour, output_mult}.
   - `combo_effects(history: Array, station_id: String, now_minute: float, wear: Dictionary, stamina: float) -> Array` - history is
     [{station_id, start_minute, end_minute}] of the last 5 days; returns the triggered combos_v1 with their numbers.
3. `Godot/tests/area_wear_test.gd` - extends SceneTree, prints `AREAWEAR total=N fails=M`, quit(1) on fail: every trains-station maps to
   an area; bag line 60 min at 100 stamina adds 4.2% split to the arms; same at 15 stamina = x2.0; head coach on sparring stops cut
   build-up (as data says); stretch heals; clamps; each band boundary (14/15, 39/40, 69/70, 89/90); each of the 6 combos triggers on its
   case and not on a near-miss. 3 mutants listed in the PR body, each must fail the test.

## Gate (CI)
`godot --headless --path Godot --script tests/area_wear_test.gd` -> exit 0, fails=0, no SCRIPT ERROR. Do not edit existing files.
Branch `codex/issue-<n>`, open the PR, never merge; never touch master.
