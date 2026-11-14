# TASK FWTANK1 - the amateur fight week: tank, load stop and sparring nights (pure rule module + unit test)

Status: OPEN (S474, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror), default.

## Why now
The operator said "Yes, build it" (S473) to the amateur fight week (map ops/research/DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI.md
sections 4.2, 4.3, 4.4). An amateur bout has no camp: the player picks one LOAD STOP for the fight week and places 0-2
sparring nights; both cost the TANK (the energy ceiling at the first bell). This module is the rule alone; Claude wires it.

## What to build: scripts/rules/FightWeek.gd (new, under 250 lines)
`extends RefCounted`, pure static functions, no class_name, no preload, no game state. All numbers are constants at the top
(they are estimates until a probe runs - keep them named, never inline).

Constants:
- TIRED_FREE := 50, TIRED_LAYER_CAP := 25
- STOPS := ["rest_up", "tick_over", "train_through"]; DEFAULT_STOP := "tick_over"
- STOP_TANK := {"rest_up": 0, "tick_over": 6, "train_through": 12}
- REST_UP_TIRED_TO := 30
- SPAR_EARLY_TANK := 3 (6-7 days out), SPAR_LATE_TANK := 5 (5 or fewer days out), EAT_LESS_TANK := 4
- SPAR_LATE_INJURY_X := 2.5, SPAR_LATE_CUT_STOP := 0.03
- BANK_SHARE := {"rest_up": 0.2, "tick_over": 0.5, "train_through": 1.0}
- TRAIN_THROUGH_TIRED_AFTER := 6
- REST_UP_EDGE := [[40, -2.0], [65, -1.0]] (start tiredness under 40 -> FLAT -2.0; 40-64 -> FLAT -1.0; 65+ -> Sharp, 0.0)

Functions:
1. `tired_layer(start_tired: int) -> int` - max(0, start_tired - 50) capped at 25.
2. `tank(start_tired: int, stop: String, spar_nights: Array, eat_less: bool) -> Dictionary` - spar_nights is an Array of
   ints, each the days-out of one fight-week sparring night (week-before nights are NOT passed here; they cost mastery, not
   tank). Returns {"tired_layer": int, "choices": int, "off": int, "parts": Array}:
   - rest_up: the tiredness layer is 0 (she is rested to 30 before the bell) - tired_layer returns 0 for rest_up.
   - choices = STOP_TANK[stop] + each night (days_out <= 5 -> 5, else 3) + (4 if eat_less). Uncapped.
   - off = tired_layer + choices. parts = [[label, points] ...] in order: "Tiredness", the stop name, each night
     ("Sparring, n days out"), "Eat less" - only non-zero parts.
   Worked examples (from the map, the test must pin them): start 75: rest_up 0; tick_over 31; train_through 37;
   train_through + nights [5, 4] = 47.
3. `round_one(start_tired: int, stop: String) -> Dictionary` - {"state": "sharp"|"flat", "edge": float, "boost": bool}.
   rest_up: under 40 -> flat -2.0; 40-64 -> flat -1.0; 65+ -> sharp 0.0 boost false. tick_over: sharp 0.0 boost true
   (one chosen plan line fires one level up in rounds 1 and 2). train_through: sharp 0.0 boost false.
4. `banked(stop: String, week_units: int) -> int` - roundi(week_units * BANK_SHARE[stop]) (pad units banked for mastery).
5. `tired_after(stop: String) -> int` - 6 for train_through, else 0.
6. `best_when(stop: String) -> String` - the printed line: rest_up "start tiredness 65+, or a heavy cut"; tick_over
   "most weeks under 65"; train_through "a plan move is within a week of Usable, or the opponent is 5+ below".
7. `spar_night(days_out: int) -> Dictionary` - days_out >= 8: {"when": "week_before", "tank": 0, "costs_pad_night": true,
   "readies": 2, "injury_x": 1.0, "cut_stop": 0.0}; 6-7: {"when": "fight_week", "tank": 3, "costs_pad_night": false,
   "readies": 2, "injury_x": 1.0, "cut_stop": 0.0}; <= 5: {"when": "late", "tank": 5, "costs_pad_night": false,
   "readies": -1 (every line), "injury_x": 2.5, "cut_stop": 0.03}.
8. `ready_lines(lines: Array, picked: Array, days_out: int) -> Array` - lines is an Array of Dictionaries
   {"id": String, "unsparred": bool} in plan order. Returns the ids this night readies: a late night readies every
   unsparred line; otherwise the picked ids (at most 2, only unsparred ones), or when picked is empty the first two
   unsparred lines in plan order.
9. `fire_shift(unsparred: bool, round_no: int) -> int` - -1 for an unsparred line in rounds 1 and 2, else 0.
10. `assistant_spar(has_week_before: bool, choices_now: int) -> int` - the assistant's default night: 8 (a week-before
    night) when has_week_before; else 7 when choices_now + 3 < 12; else 0 (none). Return the days-out, 0 = none.
11. `next_stop(stop: String) -> String` - the stop after it in STOPS ("" after train_through) for the next-stop hover.

## The test: tests/fight_week_test.gd (new)
Same shape as tests/amateur_booking_test.gd (extends SceneTree, `_check(cond, label)`, prints
`FIGHT_WEEK checks=<n> failures=<n>`, quit(1) on any failure). At least 30 checks: the four worked tank examples at start 75;
tired_layer at 40, 50, 60, 90 (cap); the rest_up edge bands at 39, 40, 64, 65; tick_over boost; banked for 720 units per stop
(144, 360, 720); spar_night at 9, 7, 6, 5, 1; ready_lines with picks, without picks, late night, already-sparred lines skipped,
more than 2 picks trimmed; fire_shift rounds 1, 2, 3; assistant_spar three cases; parts order and that zero parts are left out.

## Pass lines
RESULT: tests/fight_week_test.gd -> FIGHT_WEEK checks=<n> failures=0

## Contract
OWNS: scripts/rules/FightWeek.gd, tests/fight_week_test.gd
RED_TEST: tests/fight_week_test.gd -> FIGHT_WEEK failures=0 (red on main: the file does not exist)
REGRESSION: tests/amateur_booking_test.gd (unchanged) - nothing else is edited
VISUAL: no
NOT YOURS: every other file; never delete or weaken a test. Do not wire it into WeekPhase / screens (Claude does that).
Godot 4.7.2 headless: `godot --headless --audio-driver Dummy --path . --script res://tests/fight_week_test.gd`.
GDScript traps: never `:=` on a Variant from a Dictionary/Array get (type it: `var x: int = d["k"]`); no `%` on ints without
care; tabs for indent.

## Prior research
Map sections 4.2-4.4 (every number above comes from there); scripts/rules/WeekPhase.gd (the camp phases this replaces for
amateur bouts: TAPER = three rest days, no sparring); John S449 (tick over: one rest day, volume halved).
## What would a human do?
A coach in fight week chooses how hard to go and whether to spar once more, and knows each choice costs legs on the night.
## Prefab check
None: our own rule.
