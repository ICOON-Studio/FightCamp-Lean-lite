# TASK BOUTSHEET1 - the amateur bout sheet: slots, swap, pass, refusals, rematch, rest window (pure module + unit test)

Status: OPEN (S474, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
The operator said "Yes, build it" (S473) to the amateur fight week (map ops/research/DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI.md
section 2). A club show offers bouts as SLOTS by sex and weight class; the club decides which boxer takes a slot, may pass
a sheet or refuse a named card (two refusals lock that club out). This module is the rule alone; Claude wires it.

## What to build: scripts/rules/BoutSheet.gd (new, under 250 lines)
`extends RefCounted`, pure static functions, no class_name, no preload, no game state. Days are ints (day numbers).
Constants: MAX_CARDS := 3, REFUSE_LIMIT := 2, REFUSE_WINDOW_DAYS := 56, LOCKOUT_DAYS := 56, LEAD_WEEKS_MIN := 1,
LEAD_WEEKS_MAX := 3, REST_WINDOWS := [3, 5, 8], REST_DEFAULT := 3, RUST_WEEKS := 6.

A boxer is a Dictionary {"id": String, "sex": "f"|"m", "div": String (class id), "last_bout_day": int (-1 = never),
"ready_day": int (first day she may box: the rest window, suspension and stop rest already folded in by the caller)}.
A slot is {"show": String (host club id), "day": int, "sex": String, "div": String, "named": bool, "opp": String}.

Functions:
1. `lead_weeks(key: String) -> int` - deterministic 1..3 from hash(key) (same idea as scripts/rules/AmateurBooking.gd lead_weeks).
2. `rest_ready_day(last_bout_day: int, window_weeks: int, suspension_end: int, stop_rest_end: int) -> int` - the latest of
   last_bout_day + 7 * window_weeks, suspension_end and stop_rest_end. window_weeks not in REST_WINDOWS -> REST_DEFAULT.
3. `eligible(boxers: Array, slot: Dictionary) -> Array` - the boxers of the slot's sex and div whose ready_day <= slot day,
   ordered by who has waited longer (lowest last_bout_day first; -1 = never boxed = longest wait; tie -> id order).
4. `holder(boxers: Array, slot: Dictionary, swapped: Dictionary) -> String` - the boxer id the slot goes to: the first
   eligible, unless swapped has key slot_key(slot) naming another eligible id. "" when nobody is eligible.
5. `slot_key(slot: Dictionary) -> String` - "%s:%d:%s" % [show, day, div].
6. `swap(boxers: Array, slot: Dictionary, swapped: Dictionary) -> String` - gives the slot to the next eligible boxer after
   the current holder (wraps around), writes swapped[slot_key] = that id and returns it; "" (no change) when fewer than two
   eligible.
7. `swap_note(div_short: String) -> String` - "this slot went to your other %s boxer" (the card of the one who lost it).
8. `sheet(boxer: Dictionary, slots: Array, boxers: Array, swapped: Dictionary, locked: Dictionary, day: int) -> Array` - the
   slots this boxer holds, skipping shows in locked whose value (the unlock day) > day; at most MAX_CARDS, soonest first.
9. `refuse(refusals: Dictionary, show: String, day: int) -> Dictionary` - refusals maps show -> Array of refusal days.
   Adds day, drops days older than REFUSE_WINDOW_DAYS, and returns {"count": n, "locked_until": day + 56 when n >= 2 else -1}.
   Passing a whole sheet is free: there is no function for it, the caller simply does nothing.
10. `refused_line(refusals: Dictionary, show: String, day: int) -> String` - "refused %d of 2" counting only days within the
    window.
11. `rematch(history: Array, opp: String) -> bool` - history is an Array of opponent names she has met; true when opp is in it.
12. `rusty(ready_since_day: int, day: int, last_bout_day: int) -> bool` - true when she has been ready RUST_WEEKS * 7 days or
    more without a bout (day - max(ready_since_day, last_bout_day) >= 42).

## The test: tests/bout_sheet_test.gd (new)
Same shape as tests/amateur_booking_test.gd (extends SceneTree, `_check`, prints `BOUT_SHEET checks=<n> failures=<n>`,
quit(1) on any failure). At least 25 checks with a fixture of four DIFFERENT boxers (two women at 65 kg with different
last bouts, one man at 60, one woman at 57 still resting): eligible order, the resting one left out, holder default, swap
and swap back, swap with one eligible is a no-op, sheet trims to 3 and skips a locked show, refuse twice -> locked, a refusal
older than 56 days drops out, refused_line, rematch both ways, rusty at 41 and 42 days, rest_ready_day picks the latest of
the three and falls back to 3 weeks on a bad window, lead_weeks always 1..3 and repeatable.

## Pass lines
RESULT: tests/bout_sheet_test.gd -> BOUT_SHEET checks=<n> failures=0

## Contract
OWNS: scripts/rules/BoutSheet.gd, tests/bout_sheet_test.gd
RED_TEST: tests/bout_sheet_test.gd -> BOUT_SHEET failures=0 (red on main: the file does not exist)
REGRESSION: tests/amateur_booking_test.gd (AMATEUR_BOOKING, unchanged) - nothing else is edited
VISUAL: no
NOT YOURS: every other file. Do not wire it into Bouts.gd or Matchmaking.gd (Claude does that).
Run only through `python ops/Tools/godot_slot.py run --who boutsheet1 -- <godot> --headless --audio-driver Dummy --path . --script res://tests/bout_sheet_test.gd`.
Never the _console exe, never a window, never wrapped in `timeout`. Read ops/research/GDSCRIPT_TRAPS.md first.

## Prior research
Map section 2 (every rule above); scripts/rules/AmateurBooking.gd (lead_weeks hash idea, novice rule);
scripts/rules/Matchmaking.gd (STOP_REST_WEEKS, kept).
## What would a human do?
A club secretary reads the show's bout sheet by class, puts forward the boxer who has waited longest, and remembers which
hosts were let down.
## Prefab check
None: our own rule.
