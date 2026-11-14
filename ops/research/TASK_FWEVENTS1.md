# TASK FWEVENTS1 - fight week events: the Monday pull-out roll, late replacement asks, favours with a host (pure module + test)

Status: OPEN (S474, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
The operator said "Yes, build it" (S473) to the amateur fight week (map ops/research/DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI.md
sections 2 "FAVOURS WITH A HOST" and 6 "Things that happen"). Club-show bouts fall through in the final week (25-50 %,
Northants Telegraph 2025, Sussex Express 2015); hosts ask clubs to fill late gaps; a club that helps earns favours.
This module is the rule alone; Claude wires it into the clock and Home.

## What to build: scripts/rules/FightWeekEvents.gd (new, under 200 lines)
`extends RefCounted`, pure static functions, no class_name, no preload, no game state. Dice come in as floats in [0, 1)
(the caller rolls them), so every function is deterministic.
Constants: PULL_OUT_CHANCE := 0.35, ROLL_DAYS_OUT := 5, ASK_CHANCE := 1.0 / 6.0, FAVOURS_MAX := 3,
GO_HOME_MOOD := -6, REPLACEMENT_REP_X := 2.

Functions:
1. `roll_day(bout_day: int) -> int` - the Monday of fight week the roll fires: bout_day - 5.
2. `pulls_out(roll: float) -> bool` - roll < 0.35.
3. `answers(favours: int, host: String) -> Array` - the fall-through card's three answers in this order, each
   {"id", "ok", "why", "mood", "favours", "rep_x"}:
   - "take_replacement": ok true, mood 0, favours 0, rep_x 2 (a tougher name at short notice, double reputation on a win).
   - "go_home": ok true, mood -6, favours 0, rep_x 1.
   - "next_month": ok only when favours >= 1 (why "no favour with %s" % host otherwise), mood 0, favours -1, rep_x 1.
4. `kept_on_pull_out(banked: int, commute_paid: int) -> Dictionary` - {"banked": banked, "refund": 0}: a banked week always
   stays, a commute that already happened refunds nothing.
5. `asks(roll: float, fits_gap: bool, ready: bool, asked_this_show: bool) -> bool` - a host asks at most once per show,
   only when the boxer fits the gap and is READY: true when not asked_this_show and fits_gap and ready and roll < 1/6.
6. `fill_gap(favours: int) -> int` - favours after filling a late gap: min(favours + 1, 3).
7. `spend(favours: int, n: int) -> Dictionary` - {"ok": favours >= n, "favours": favours - n when ok else favours}.
8. `one_stop(stops_this_bout: int) -> bool` - true when the clock may still stop for this boxer's bout (at most one stop
   per boxer per bout): stops_this_bout < 1.

## The test: tests/fight_week_events_test.gd (new)
Same shape as tests/amateur_booking_test.gd (extends SceneTree, `_check`, prints `FIGHT_WEEK_EVENTS checks=<n> failures=<n>`,
quit(1) on any failure). At least 25 checks: roll_day; pulls_out at 0.34 / 0.35 / 0.9; answers order and keys, next_month
greyed with its why at 0 favours and ok at 1; kept_on_pull_out; asks in each blocked case and the open case at 0.1 / 0.2;
fill_gap caps at 3; spend ok and not ok; one_stop at 0 and 1. A fixture of 1 000 seeded rolls (RandomNumberGenerator,
seed 474) puts pulls_out between 30 % and 40 % and asks (all gates open) between 12 % and 21 %.

## Pass lines
RESULT: tests/fight_week_events_test.gd -> FIGHT_WEEK_EVENTS checks=<n> failures=0

## Contract
OWNS: scripts/rules/FightWeekEvents.gd, tests/fight_week_events_test.gd
RED_TEST: tests/fight_week_events_test.gd -> FIGHT_WEEK_EVENTS failures=0 (red on main: the file does not exist)
REGRESSION: tests/weigh_gap_test.gd (WEIGH_GAP, unchanged), tests/bout_sheet_test.gd (BOUT_SHEET, unchanged) - nothing else is edited
VISUAL: no
NOT YOURS: every other file. Do not wire it (Claude does that).
Run only through `python ops/Tools/godot_slot.py run --who fwevents1 -- <godot> --headless --audio-driver Dummy --path . --script res://tests/fight_week_events_test.gd`
(in the cloud: `godot --headless --audio-driver Dummy --path . --script res://tests/fight_week_events_test.gd`). Never the
_console exe, never a window, never wrapped in `timeout`. Read ops/research/GDSCRIPT_TRAPS.md first.

## Prior research
Map sections 2 and 6 (every number above); scripts/rules/WeighGap.gd (the favour spent on Ask for a kilo, MISS_FAVOUR).
## What would a human do?
A club secretary hears on Monday that the opponent pulled out, and either takes the host's late name, goes home, or calls in
a favour for next month's slot.
## Prefab check
None: our own rule.
