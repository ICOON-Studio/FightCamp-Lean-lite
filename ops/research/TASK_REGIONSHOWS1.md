# TASK REGIONSHOWS1 - the region's club-show calendar and each show's slots by sex and class (pure module + test)

Status: OPEN (S474, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror), default.

## Why now
The operator said "Yes, build it" (S473) to the amateur fight week (map ops/research/DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI.md
section 2 "SLOTS BY CLASS"). Amateur bouts come from club shows in the region: each show offers 8 to 12 bouts as SLOTS by
sex and weight class, 1 to 3 weeks out. scripts/rules/BoutSheet.gd (already on main - read it) decides which of our
boxers holds a slot; this module makes the slots. The rule alone; Claude wires it.

## What to build: scripts/rules/RegionShows.gd (new, under 220 lines)
`extends RefCounted`, pure static functions, no class_name, no preload, no game state. Everything is deterministic from
`hash()` of a string key (the same idea as scripts/rules/AmateurBooking.gd lead_weeks), so a save and a reload see the
same calendar.

Constants:
- HOSTS := ["Fitzroy Lodge", "West Ham", "Repton", "Lynn AC", "Dale Youth", "All Stars"] (real amateur clubs; fighters stay fictional)
- DIVS := the eight class ids in table order: ["wfw", "wlw", "www", "wmw", "mfw", "mlw", "mww", "mmw"]
- DIV_SEX := {"wfw": "f", "wlw": "f", "www": "f", "wmw": "f", "mfw": "m", "mlw": "m", "mww": "m", "mmw": "m"}
- SHOWS_PER_WEEK_MIN := 1, SHOWS_PER_WEEK_MAX := 2, BOUTS_MIN := 8, BOUTS_MAX := 12
- WOMEN_SHARE := 0.35 (about a third of a club card's bouts are women's; ESTIMATE)
- SHOW_DOW := 5 (shows are on Saturday; day 0 = a Monday, so a show day is monday + 5)
- NAMED_SHARE := 0.25 (a quarter of slots name the host's own boxer: a "named" card that counts toward refusals)

Functions:
1. `week_shows(monday: int) -> Array` - the shows of the week that starts on day `monday` (a multiple of 7):
   1 or 2 shows (from hash("w%d" % monday)), each {"show": host name, "day": monday + 5, "bouts": 8..12}. Two shows in one
   week never share a host.
2. `slots(show: Dictionary) -> Array` - the show's slots: `bouts` entries, each
   {"show": show.show, "day": show.day, "sex": "f"|"m", "div": class id, "named": bool, "opp": String}. Women's slots are
   roundi(bouts * 0.35) (at least 1), the rest men's; classes cycle through that sex's four classes starting at an offset
   from hash(show.show + str(show.day)); named from hash per slot (about 1 in 4); opp = "%s %s boxer" % [show.show, class
   short name] - a placeholder the caller replaces with a rival from the division table.
3. `offered(from_day: int, weeks_min := 1, weeks_max := 3) -> Array` - every slot of every show whose day lies from
   from_day + 7 * weeks_min to from_day + 7 * weeks_max inclusive, soonest first. (This is the 1-3 weeks lead time.)
4. `for_div(slots: Array, div: String) -> Array` - the slots of one class, soonest first.
5. `short_name(div: String) -> String` - "57 kg", "60 kg", "65 kg", "75 kg" for women; "57.5 kg", "60 kg", "70 kg", "75 kg"
   for men (wfw/wlw/www/wmw, mfw/mlw/mww/mmw).

## The test: tests/region_shows_test.gd (new)
Same shape as tests/amateur_booking_test.gd (extends SceneTree, `_check(cond, label)`, prints `REGION_SHOWS checks=<n>
failures=<n>`, quit(1) on any failure). At least 25 checks: week_shows count 1-2 and never the same host twice, show day =
Saturday, bouts 8-12; the same monday gives the same shows twice (repeatable); slots count = bouts, women's share, every
slot's sex matches its class, classes of one sex spread (no class gets more than half of that sex's slots on a 12-bout
card); offered keeps only 1-3 weeks out and is sorted; for_div filters; short_name for all eight; over 52 weeks (mondays
0, 7, ..., 357) every class appears at least 20 times and the average slots a week for one class is between 0.8 and 3.0
(BoutSheet's "2+ cards on average" target needs enough slots); named share over that year between 15 % and 35 %.

## Pass lines
RESULT: tests/region_shows_test.gd -> REGION_SHOWS checks=<n> failures=0

## Contract
OWNS: scripts/rules/RegionShows.gd, tests/region_shows_test.gd
RED_TEST: tests/region_shows_test.gd -> REGION_SHOWS failures=0 (red on main: the file does not exist)
REGRESSION: tests/bout_sheet_test.gd (BOUT_SHEET, unchanged) - nothing else is edited
VISUAL: no
NOT YOURS: every other file; never delete or weaken a test. Do not wire it (Claude does that).
Godot 4.7.2 headless: `godot --headless --audio-driver Dummy --path . --script res://tests/region_shows_test.gd`.
GDScript traps: never `:=` on a Variant from a Dictionary/Array get (type it); `hash()` can be negative (use absi); tabs.

## Prior research
Map section 2; scripts/rules/BoutSheet.gd (the slot shape it reads); scripts/rules/AmateurBooking.gd (hash lead time);
scripts/state/Data.gd DIVISIONS (class ids and limits).
## What would a human do?
A club secretary reads the region's show calendar each week and sees which weights each host still needs.
## Prefab check
None: our own rule.
