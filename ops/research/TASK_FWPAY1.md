# TASK FWPAY1 - who pays for the fight-week trip: club, half each or the boxer (pure rule module + unit test)

Status: OPEN (S475, Claude main). Discipline: boxing. Model: Goose (cloud), default.

## Why now
The operator said "Yes, build it" (S473) to the amateur fight week (map ops/research/DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI.md
section 4.6 WHO PAYS). A trip's cost can be paid by the club, split, or paid from the boxer's own savings, each with a mood
effect and a gate. This module is the rule alone; Claude wires it. Savings' weekly growth is a separate decision (the input
here is just the boxer's savings in dollars).

## What to build: scripts/rules/FightWeekPay.gd (new, under 200 lines)
`extends RefCounted`, pure static functions, no class_name, no preload, no game state.

Constants: PAYERS := ["club", "half", "boxer"]; PAYER_NAMES := {"club": "The club", "half": "Half each", "boxer": "The boxer"};
CLUB_MOOD := 3; FAIRNESS_MOOD := -2; HALF_WIN_MOOD := 3; HALF_LOSS_MOOD := 0; BOXER_WIN_MOOD := 6; BOXER_LOSS_MOOD := -6;
CONFIDENCE_GATE := 55; SKINT_UNDER := 100; SKINT_MOOD_WEEK := -2; FAIRNESS_WEEKS := 8.

Functions:
1. `club_share(payer: String, cost: int) -> int` - club cost; half = ceil(cost / 2.0) (club pays the odd dollar); boxer 0.
2. `boxer_share(payer: String, cost: int) -> int` - cost - club_share.
3. `allowed(payer: String, cost: int, savings: int, confidence: int) -> Dictionary` - {"ok", "why"}:
   club always ok; half needs savings >= boxer_share ("Savings do not cover half"); boxer needs confidence >= 55
   ("Not confident enough to pay") AND savings >= cost ("Savings do not cover it"); check confidence first.
4. `mood_now(payer: String) -> int` - the paying boxer's mood at payment: club +3; half and boxer 0 (theirs comes after the bout).
5. `fairness_hit(this_boxer_club_paid: int, other_boxer_club_paid: int) -> int` - -2 when this_boxer_club_paid >
   other_boxer_club_paid (counts in the last 8 weeks, this payment included), else 0. (Applied to each other boxer.)
6. `mood_after(payer: String, won: bool) -> int` - half +3 / 0; boxer +6 / -6; club 0 (it got its +3 at payment).
7. `skint(payer: String, cost: int, savings: int) -> bool` - true when the boxer paid something (half or boxer) and
   savings - boxer_share < 100.
8. `skint_week(is_skint: bool) -> int` - -2 mood a week while skint, else 0.
9. `expected_mood(payer: String, win_rate: float) -> float` - club 3.0; half 3.0 * win_rate; boxer 6.0 * (2 * win_rate - 1).
   (At win_rate 0.61: half 1.83, boxer 1.32 - pin both, to 0.01.)
10. `row_line(payer: String, cost: int, savings: int, confidence: int) -> String` - the plain row text, e.g.
    "Half each: club $135, boxer $135" or the greyed reason "The boxer: Savings do not cover it". No person's name, no
    "he"/"she" (tests/no_pronoun_test.gd), never "best".

## The test: tests/fight_week_pay_test.gd (new)
Same shape as tests/amateur_booking_test.gd (extends SceneTree, `_check(cond, label)`, prints
`FIGHT_WEEK_PAY checks=<n> failures=<n>`, quit(1) on any failure). At least 35 checks with FOUR different boxers (savings
40 / 150 / 400 / 1200, confidence 40 / 55 / 70 / 90) against costs 0, 210, 270, 745: shares incl. the odd dollar; every gate
and its exact why, confidence checked before savings; mood_now, fairness_hit, mood_after both results; skint at the edge
(exactly 100 left = not skint, 99 = skint); expected_mood at 0.61 and at 0.5 (boxer 0.0); row_line words.

## Pass lines
RESULT: tests/fight_week_pay_test.gd -> FIGHT_WEEK_PAY checks=<n> failures=0

## Contract
OWNS: scripts/rules/FightWeekPay.gd, tests/fight_week_pay_test.gd
RED_TEST: tests/fight_week_pay_test.gd -> FIGHT_WEEK_PAY failures=0 (red on main: the file does not exist)
REGRESSION: tests/fight_week_test.gd (unchanged) - nothing else is edited
VISUAL: no
NOT YOURS: every other file; never delete or weaken a test. Do not wire it (Claude does that).
Godot 4.7.2 headless: `godot --headless --audio-driver Dummy --path . --script res://tests/fight_week_pay_test.gd`.
GDScript traps: never `:=` on a Variant from a Dictionary/Array get (type it); tabs for indent; no int/int division.

## Prior research
Map section 4.6 (payer table, 61% wins MEASURED, BudgetProbe); scripts/rules/FightWeek.gd and FightWeekEvents.gd (siblings).
## What would a human do?
An amateur club often cannot fund every trip; a confident boxer with a day job chips in, and the others notice who gets the
club's money.
## Prefab check
None: our own rule.
