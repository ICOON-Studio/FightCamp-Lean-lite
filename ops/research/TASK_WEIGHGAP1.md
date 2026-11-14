# TASK WEIGHGAP1 - the club-show weight gap (pure rule module + unit test)

Status: OPEN (S474, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
The operator said "Yes, build it" (S473) to the amateur fight week, map ops/research/DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI.md
section 4.5. At club shows two amateurs are matched at walking weight within a gap (England Boxing 2026 rules 7.1.3, 2.7.8),
not by the class limit. This module is the rule alone; Claude wires it into Bouts.weigh later.

## What to build: scripts/rules/WeighGap.gd (new, under 150 lines)
`extends RefCounted`, pure static functions, no class_name, no preload, no game state. Constants at the top:
- GAP_LIGHT_KG := 2.5 (classes with a limit up to 65.0 kg), GAP_HEAVY_KG := 5.0 (limit above 65.0), GAP_SKILLS_KG := 2.0
- EAT_LESS_TANK := 4 (tank points), TRAIN_OFF_KG := 0.3, TRAIN_OFF_TIRED := 8, KILO_EDGE_KG := 1.0
- REMATCH_CHANCE := 1.0 / 3.0, MISS_COST := 300, MISS_FAVOUR := 1
Functions:
1. `gap_kg(class_limit: float, skills: bool = false) -> float` - skills bout 2.0; limit <= 65.0 -> 2.5; else 5.0.
2. `margin(own_kg: float, opp_kg: float, class_limit: float, skills := false) -> float` - gap minus abs(own - opp)
   (positive = inside the gap, by how much; negative = outside).
3. `in_gap(own_kg, opp_kg, class_limit, skills := false) -> bool` - margin >= 0.0 (exactly on the edge is inside).
4. `ways(own_kg, opp_kg, class_limit, favours: int, start_tired: int, skills := false) -> Array` - the three ways to make
   the match, always in this order, each a Dictionary:
   - {"id": "eat_less", "tank": 4, "kg": 0.0 ... } - see below; every entry has keys id, ok (bool), why (String, "" when ok),
     tank (int tank points it costs), tired (int tiredness it adds), favours (int favours it spends), kg (float it moves).
   - eat_less: ok always, tank 4, tired 0, favours 0, kg 0.0 (it keeps her at weight; it does not move kg).
   - train_off: ok always, tank 0, tired 8, favours 0, kg 0.3.
   - ask_kilo: ok only when favours >= 1 AND the boxer is outside the gap by no more than KILO_EDGE_KG
     (margin < 0 and margin >= -1.0); tank 0, tired 0, favours 1, kg 1.0. When not ok, why is plain words:
     "no favour with the host" when favours < 1, else "only within 1 kg of the gap" when outside by more than 1 kg,
     else "already inside the gap".
5. `best_cut(start_tired: int) -> String` - "train_off" when start_tired < 42 (it beats Eat less only then, John's derivation),
   else "eat_less".
6. `miss(roll: float, host_has_spare: bool) -> Dictionary` - the boxer is outside the gap on the day. roll in [0, 1).
   When host_has_spare and roll < REMATCH_CHANCE: {"rematched": true, "off": false, "cost": 0, "favours": 0}.
   Otherwise {"rematched": false, "off": true, "cost": 300, "favours": 1}.
7. `championship(weight: float, limit: float, tolerance: float) -> bool` - weight <= limit + tolerance (the day-before class
   limit, unchanged; kept here so the screen reads one module).

## The test: tests/weigh_gap_test.gd (new)
Same shape as tests/amateur_booking_test.gd (extends SceneTree, `_check`, prints `WEIGH_GAP checks=<n> failures=<n>` and
quits with 1 on any failure). At least 20 checks, covering: each gap (57, 60, 65 -> 2.5; 70, 75 -> 5.0; skills 2.0); a
boxer exactly on the edge is in; 0.1 kg over is out; margin sign both ways; ask_kilo ok at 0.5 kg out with 1 favour,
not ok at 1.5 kg out (its why), not ok with 0 favours (its why), not ok when already inside; best_cut at 41 and 42;
miss with a spare at roll 0.2 and 0.5 and without a spare; ways() order and keys.

## Pass lines
RESULT: tests/weigh_gap_test.gd -> WEIGH_GAP checks=<n> failures=0

## Contract
OWNS: scripts/rules/WeighGap.gd, tests/weigh_gap_test.gd
RED_TEST: tests/weigh_gap_test.gd -> WEIGH_GAP failures=0 (red on main: the file does not exist)
REGRESSION: tests/amateur_booking_test.gd (AMATEUR_BOOKING, unchanged), tests/bout_rules_test.gd (unchanged) - nothing else is edited
VISUAL: no
NOT YOURS: every other file. Do not wire it into Bouts.gd (Claude does that).
Parse gate: `python tools/check_scripts.py scripts/rules/WeighGap.gd tests/weigh_gap_test.gd` (if that tool is missing, the
headless run below is the parse check). Run only through
`python ops/Tools/godot_slot.py run --who weighgap1 -- <godot> --headless --audio-driver Dummy --path . --script res://tests/weigh_gap_test.gd`.
Never the _console exe, never a window, never wrapped in `timeout`. Read ops/research/GDSCRIPT_TRAPS.md first (Variant `:=`).

## Prior research
Map section 4.5 (the rule and its numbers); scripts/rules/BoutRules.gd made_weight (the day-before limit); England Boxing
2026 rules 7.1.3 / 2.7.8 as quoted in the map.
## What would a human do?
A club secretary checks both boxers on the same scale an hour before and allows a set difference by class.
## Prefab check
None: a few lines of our own rule.
