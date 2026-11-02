# TASK LUDO-HOUR1A - Ludo's first hour as an ordered beat list (pure module + data) - Arena

Model: Arena Agent Mode. Repo ICOON-Studio/FightCamp, branch from master; work ONLY on your own arena/ branch, open a PR into master,
NEVER merge it. Write ONLY the three NEW files below; edit nothing else. Do not delete or weaken any existing test.

## Owned files
- `Godot/assets/data/first_hour.json` (NEW)
- `Godot/scripts/FirstHour.gd` (NEW, pure: extends RefCounted, static funcs only, no autoload, no preload of game scripts)
- `Godot/tests/first_hour_test.gd` (NEW, extends SceneTree)

## Prior research
Design of record (approved D40 + D41 V13): `research/LUDO_FIRST_HOUR_S190.md` - the minute-by-minute table (16 rows, minutes
00-60: screen, what happens, the player's decision, the tutorial line) - and V13 in `research/DECISION_LEDGER.md` row D41 (solo
player-coach, assistant hire unlocks after the first $350 purse, a 3-prospect shortlist that always leads with Leo Vance, 3 move cards with
the 3rd locked to a pad chain, Sal = house sparring partner). Cast ids are in `Godot/assets/data/ludo_cast.json` (leo_vance, tommy_perez,
ray_miller, sal_barone). House style: `Godot/scripts/PromoterTrap.gd` + `Godot/tests/promoter_trap_test.gd`.

## What would a human do?
Turn Ludo's table into an ordered list of beats, each with what must be true to leave it, and a tiny function that says which beat is next.

## Prefab check
N/A.

## Spec
`first_hour.json`: {"beats": [...]} - one beat per row of Ludo's table, in order, each {id (snake_case, e.g. "gym_intro", "first_lap",
"pad_editor", "mini_camp_setup", "auto_day", "pre_fight_1", "bout_1", "corner_1", "bout_1_finish", "week_review_1", "fight_week_tuesday",
"weigh_in", "bout_2", "corner_2", "doctor", "office_trap"), minute_from, minute_to, screen (as Ludo wrote it), decision (Ludo's words,
shortened <= 120 chars), tutorial_line (Ludo's line verbatim), exit_flag (the one flag that completes the beat, e.g. "gym_named",
"cards_picked", "bout_1_over", "doctor_resolved", "trap_answered"), unlocks (array of flags it unlocks, e.g. bout 1 purse unlocks
"assistant_hire" per V13)}. Opponent beats carry opponent_id (tommy_perez / ray_miller).
`FirstHour.gd`: `beats() -> Array` (ids in order), `beat(id) -> Dictionary` (deep copy), `current(flags: Dictionary) -> String` (the first
beat whose exit_flag is not true in flags; "done" when all are), `unlocked(flags: Dictionary) -> Array` (every unlock earned by completed
beats), `tutorial_line(id) -> String`, `minutes_total() -> int` (60).

## Done = (tier: new files only - parse + this test)
Parse gate, then `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/first_hour_test.gd` (Linux: the Godot 4.7.2 headless
binary from Tools/cloud_setup.sh) -> `FIRST_HOUR_TEST FAILS=0`, no SCRIPT ERROR. Cases: 16 beats in Ludo's order with minutes contiguous
0..60; current({}) == "gym_intro"; flags up to bout_1_over -> current is week_review_1; "assistant_hire" is NOT unlocked before bout 1's
purse and IS after; every opponent beat names a cast id that exists in ludo_cast.json (read that file in the test); all flags true -> "done";
beat() returns copies. PR description: 3 mutants with FAIL counts - (a) two beats swapped, (b) assistant_hire unlocked from the start,
(c) doctor beat's opponent_id changed to tommy_perez.

## The one trap
JSON numbers parse as floats in Godot - compare minutes with int() and arrays element-wise, never `array == [1, 2, 3]`. An unknown id is
push_warning (never push_error: our test runner fails any engine ERROR line).
