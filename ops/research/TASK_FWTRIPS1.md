# TASK FWTRIPS1 - where to train in the fight week: trips and coach away (pure rule module + unit test)

Status: OPEN (S475, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror), default.

## Why now
The operator said "Yes, build it" (S473) to the amateur fight week (map ops/research/DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI.md
section 4.1 WHERE TO TRAIN and its COACH AWAY card). One trip per bout; the card says which week it uses. This module is the
rule alone; Claude wires it into the fight week screen.

## What to build: scripts/rules/FightWeekTrips.gd (new, under 200 lines)
`extends RefCounted`, pure static functions, no class_name, no preload, no game state. Dice come in as floats in [0, 1).

Constants:
- TRIPS := ["home", "city_with_assistant", "city_alone", "hill_cottage"]
- TRIP_NAMES := {"home": "Home gym", "city_with_assistant": "City club, with your assistant",
  "city_alone": "City club, alone", "hill_cottage": "Hill cottage"}
- FOOD_TWO := 120, FOOD_ONE := 60, CITY_FEE := 150, COTTAGE_OFF := 745, COTTAGE_SUMMER := 1170 (June to August)
- EDGE_WITH := 1.0, EDGE_ALONE := 0.5 (round-1 edge against the opponent's style)
- CITY_INJURY_X := 1.15 (with assistant), ALONE_TIRED_PER_TRAVEL_DAY := 1, COTTAGE_TIRED_OFF := 10
- EVENING_CLASS := 350 (lost when the assistant is away a full week)

Functions:
1. `cost(trip: String, month: int) -> int` - home 0; city_with_assistant 150 + 120; city_alone 150 + 60;
   hill_cottage 745, or 1170 when month is 6, 7 or 8. Unknown trip -> 0.
2. `weeks(trip: String) -> Array` - which weeks it may use: home ["week_before", "fight_week"]; both city trips
   ["week_before", "fight_week"]; hill_cottage ["week_before"].
3. `allowed(trip: String, championship: bool, has_week_before: bool) -> Dictionary` - {"ok": bool, "why": String}.
   hill_cottage needs championship true (regional/national draws only) AND has_week_before; why words:
   "Only for championship rounds" / "Needs a week before the fight week". Every other trip ok when it has a week to use
   (fight_week is always there). Home always ok.
4. `edge(trip: String, opp_style_matched: bool) -> float` - round-1 edge: city_with_assistant 1.0, city_alone 0.5, only when
   opp_style_matched (the club has a partner in the opponent's style); else 0.0. home and hill_cottage 0.0.
5. `injury_x(trip: String) -> float` - city_with_assistant 1.15, else 1.0.
6. `tired_change(trip: String, travel_days: int) -> int` - city_alone +1 a travel day (travel_days clamped 0..7);
   hill_cottage -10 (fight week starts 10 lower); else 0.
7. `banks_full(trip: String) -> bool` - true only for hill_cottage (the week before banks in full, no TrainingLoad entry).
8. `coach_away(trip: String) -> Dictionary` - the COACH AWAY card:
   home {"away": ""}; city_alone {"away": ""};
   city_with_assistant {"away": "assistant", "days": "by day", "evening_class_lost": 0, "class_runs": true};
   hill_cottage {"away": "head_coach", "days": "all week", "no_shouts_other_bouts": true, "refund": false}.
9. `others_train_x(away: String, head_coach_factor: float) -> float` - the other boxers' training factor that week:
   "" -> 1.0; "assistant" -> head_coach_factor (the screen prints this real number); "head_coach" -> 0.6 (S474 decision:
   the other boxers train at 60% with no coach rating, scripts/state/Sim.gd line ~45).
10. `card_line(trip: String, month: int, opp_style_matched: bool) -> String` - one plain line for the trip card, e.g.
    "City club, with your assistant: $270 - round-1 edge +1.0 against this style". Never a person's name, never "best",
    no "he"/"she" (tests/no_pronoun_test.gd), no percent sign for the edge.

## The test: tests/fight_week_trips_test.gd (new)
Same shape as tests/amateur_booking_test.gd (extends SceneTree, `_check(cond, label)`, prints
`FIGHT_WEEK_TRIPS checks=<n> failures=<n>`, quit(1) on any failure). At least 35 checks: every cost incl. the summer months
5/6/8/9 edges of the cottage price; weeks() per trip; allowed() for the cottage in all four (championship x week_before)
cases with the exact why words; edge with and without a matched style; injury_x; tired_change incl. clamp; banks_full;
coach_away for all four trips; others_train_x three cases; card_line for four trips holds the dollar figure, no "best", no
capitalised person name, no "%".

## Pass lines
RESULT: tests/fight_week_trips_test.gd -> FIGHT_WEEK_TRIPS checks=<n> failures=0

## Contract
OWNS: scripts/rules/FightWeekTrips.gd, tests/fight_week_trips_test.gd
RED_TEST: tests/fight_week_trips_test.gd -> FIGHT_WEEK_TRIPS failures=0 (red on main: the file does not exist)
REGRESSION: tests/fight_week_test.gd (unchanged) - nothing else is edited
VISUAL: no
NOT YOURS: every other file; never delete or weaken a test. Do not wire it (Claude does that).
Godot 4.7.2 headless: `godot --headless --audio-driver Dummy --path . --script res://tests/fight_week_trips_test.gd`.
GDScript traps: never `:=` on a Variant from a Dictionary/Array get (type it); tabs for indent; no int/int division.

## Prior research
Map section 4.1 (trip table, cottage championship-only, seaside cut, partner choice not taken) and COACH AWAY card;
John S449 food prices; scripts/rules/FightWeek.gd (sibling module, same style).
## What would a human do?
A club coach weighs a week of sparring at a bigger city club against the cost and the gym left without its assistant,
and saves the countryside camp for a championship run.
## Prefab check
None: our own rule.
