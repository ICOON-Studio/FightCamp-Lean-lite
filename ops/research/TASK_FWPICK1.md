# TASK FWPICK1 - your assistant's fight-week pick (pure rule module + unit test)

Status: OPEN (S474, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror), default.

## Why now
The operator said "Yes, build it" (S473) to the amateur fight week (map ops/research/DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI.md
section 4.7 and 4.4 "Your assistant's default"). The assistant proposes a whole fight week (load stop, sparring night,
weight way) from five facts, names the ONE fact that drove it, and is sometimes wrong (a better assistant is wrong less).
The player can "Use the pick" or set the week himself. This module is the rule alone; Claude wires it.

## What to build: scripts/rules/FightWeekPick.gd (new, under 220 lines)
`extends RefCounted`, pure static functions, no class_name, no preload, no game state. Dice come in as floats in [0, 1).

Input `facts: Dictionary` with keys: "start_tired" int (0-100), "tank_weight" int (tank points the weight costs: 0 when
inside the gap, 4 when only Eat less makes it), "opp_round1" String ("fast" = the opponent starts fast, "slow", "even"),
"rating_gap" float (our boxer's rating minus the opponent's; + = we are better), "unsparred" int (plan lines unsparred),
"near_usable" bool (a plan move is within one week of Usable), "has_week_before" bool.

Constants: STOPS := ["rest_up", "tick_over", "train_through"], TIRED_REST := 65, GAP_TRAIN := -5.0 (the opponent rated
5+ below us = rating_gap >= 5.0), FACT_WORDS (below).

Functions:
1. `sureness(rating: int) -> float` - 0.5 + rating / 200.0, clamped to [0.5, 0.99]. (rating = the assistant's coaching
   rating 0-100; Luke Reid 58 -> 0.79, Marcus Hale 74 -> 0.87 - pin both in the test.)
2. `best_stop(facts: Dictionary) -> Dictionary` - the right stop and the fact that drove it, checked in this order:
   - start_tired >= 65 or tank_weight >= 4 -> {"stop": "rest_up", "fact": "tired" or "weight"} ("tired" when start_tired >= 65)
   - near_usable or rating_gap >= 5.0 -> {"stop": "train_through", "fact": "near_usable" or "rating_gap"} (near_usable first)
   - else {"stop": "tick_over", "fact": "opp_round1" when opp_round1 == "fast", else "default"}
3. `spar(facts: Dictionary, choices_now: int) -> int` - the night's days-out: 8 when has_week_before; else 7 when
   unsparred > 0 and choices_now + 3 < 12; else 0 (none). (choices_now = the tank choice layer already set.)
4. `weight_way(facts: Dictionary) -> String` - "" when tank_weight == 0; "train_off" when start_tired < 42; else "eat_less".
5. `pick(facts: Dictionary, rating: int, roll: float) -> Dictionary` - the whole proposal:
   {"stop", "spar", "weight", "fact", "line", "wrong"}. Take best_stop; when roll >= sureness(rating) the assistant is
   WRONG: it takes the NEXT stop in STOPS after the best (wrapping train_through -> rest_up) and keeps the same reason
   ("wrong": true). spar uses choices_now = the tank cost of the chosen stop (rest_up 0, tick_over 6, train_through 12).
   "line" is the plain sentence for the card, built from FACT_WORDS, e.g. "Tick over: the opponent starts fast."
6. FACT_WORDS := {"tired": "she is still tired from the last weeks", "weight": "the weight will cost her legs",
   "near_usable": "a plan move is a week from Usable", "rating_gap": "the opponent is rated well below her",
   "opp_round1": "the opponent starts fast", "default": "a normal week"}. Words only: never a name, never "best".
   (Owner rule S448: names only in headers; the card says "your assistant".)
7. `stop_name(stop: String) -> String` - "Rest up" / "Tick over" / "Train through".

## The test: tests/fight_week_pick_test.gd (new)
Same shape as tests/amateur_booking_test.gd (extends SceneTree, `_check(cond, label)`, prints
`FIGHT_WEEK_PICK checks=<n> failures=<n>`, quit(1) on any failure). At least 30 checks with FIVE DIFFERENT fact sets
(a tired boxer, a heavy cut, a move near Usable, a big rating edge, a plain week v a fast starter): best_stop and its fact
for each; the order of the rules (tired AND near_usable -> rest_up); sureness at 58 and 74 and the clamps; pick right at
roll 0.0 and wrong at roll 0.99 (next stop, same fact, wrong true) and the wrap from train_through; spar's three cases;
weight_way's three cases; line text contains no "best" and no capitalised name; a seeded run (RandomNumberGenerator seed
474, 2 000 picks at rating 58) is wrong between 17 % and 25 % of the time.

## Pass lines
RESULT: tests/fight_week_pick_test.gd -> FIGHT_WEEK_PICK checks=<n> failures=0

## Contract
OWNS: scripts/rules/FightWeekPick.gd, tests/fight_week_pick_test.gd
RED_TEST: tests/fight_week_pick_test.gd -> FIGHT_WEEK_PICK failures=0 (red on main: the file does not exist)
REGRESSION: tests/amateur_booking_test.gd (unchanged) - nothing else is edited
VISUAL: no
NOT YOURS: every other file; never delete or weaken a test. Do not wire it (Claude does that).
Godot 4.7.2 headless: `godot --headless --audio-driver Dummy --path . --script res://tests/fight_week_pick_test.gd`.
GDScript traps: never `:=` on a Variant from a Dictionary/Array get (type it); tabs for indent.

## Prior research
Map sections 4.4 (assistant's sparring default) and 4.7 (five facts, sureness, wrong = next stop); tests/no_pronoun_test.gd
and tests/plain_words_test.gd (word rules the line must pass).
## What would a human do?
An assistant coach looks at how tired she is, the scale and the opponent's tape, says "tick over, he starts fast", and is
right most of the time.
## Prefab check
None: our own rule.
