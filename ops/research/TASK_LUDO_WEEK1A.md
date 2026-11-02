# TASK LUDO-WEEK1A - Ludo's fight week, Monday to Saturday (pure module + data) - Arena

Model: Arena Agent Mode. Repo ICOON-Studio/FightCamp, branch from master; work ONLY on your own arena/ branch, open a PR into master,
NEVER merge it. Write ONLY the three NEW files below; edit nothing else. Do not delete or weaken any existing test.

## Owned files
- `Godot/assets/data/fight_week.json` (NEW)
- `Godot/scripts/FightWeek.gd` (NEW, pure: extends RefCounted, static funcs only, no autoload, no preload of game scripts)
- `Godot/tests/fight_week_test.gd` (NEW, extends SceneTree)

## Prior research
Design of record (approved D40, V6 "camp weeks 1-3 ours + week 4 Ludo's Mon-Sat fight week"): `research/LUDO_ROUND4_S190.md`
section "A) The Camp Week: Day-by-Day Cadence (Mon-Sat)" (~lines 27-60) - every number below is from it. The Friday cut options are
already data in `Godot/assets/data/weigh_in_cut.json` if it is on master (LUDO-CUT3A) - reference its option ids, do NOT copy its numbers.
House style: `Godot/scripts/PromoterTrap.gd` + `Godot/tests/promoter_trap_test.gd`.

## What would a human do?
Six rows - one per day - each with its one decision, its two choices and what each costs; a function that says which day it is and what
a choice does.

## Prefab check
N/A.

## Spec
`fight_week.json`: {"days": [mon, tue, wed, thu, fri, sat]} each {id ("mon".."sat"), title, mechanic, decision, choices: {...}}:
- mon "Tactical Drill": choices {counter_focus, evasive_route}; cost {weekly_stamina_spent 0.35}; over_drill_marker "amber_fatigue" (the
  "drilled too aggressively" case) - flag only.
- tue "Hard Sparring": the lock-one-sacrifice-one commitment: lock {drill_speed_crit +0.15}, sacrifice {guard_vs_secondary -0.10};
  permanent true; risk {mileage true, minor_swelling true}.
- wed "Active Recovery": choices rest {regenerate ["chin", "snap"], cost "coach_time"} vs light_conditioning {weight_trend "toward_limit",
  risk "weight_amber"}.
- thu "Film Study": coach_hours 3, tells_max 3, cost "cutman_prep_time".
- fri "Weigh-in Cut": choices = the weigh_in_cut option ids ["safe_sweat", "sauna_push", "extreme_drain"].
- sat "Fight Night": no choices.
`FightWeek.gd`: `days() -> Array` (ids in order), `day(id) -> Dictionary` (deep copy), `day_for_index(i: int) -> String` (0 = mon ..
5 = sat; clamp outside), `choices(id) -> Array` (choice ids, [] for sat), `apply_tuesday(lock_drill: String, sacrifice_vs: String) ->
Dictionary` ({lock: {drill, speed_crit 0.15}, sacrifice: {vs, guard -0.10}, permanent: true}), `is_fight_week(camp_week: int,
camp_weeks: int) -> bool` (true only in the camp's LAST week).

## Done = (tier: new files only - parse + this test)
Parse gate, then `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/fight_week_test.gd` (Linux: the Godot 4.7.2 headless
binary from Tools/cloud_setup.sh) -> `FIGHT_WEEK_TEST FAILS=0`, no SCRIPT ERROR. Cases: 6 days in order; each day's numbers typed from
LUDO_ROUND4_S190.md (0.35, +0.15, -0.10, 3 hours, 3 tells); sat has no choices; day_for_index clamps (-1 -> mon, 9 -> sat);
apply_tuesday output; is_fight_week(4, 4) true, (3, 4) false, (1, 1) true; day() returns copies. PR description: 3 mutants with FAIL
counts - (a) mon stamina 0.35 -> 0.30, (b) sacrifice -0.10 -> -0.05, (c) is_fight_week true for every week.

## The one trap
JSON numbers parse as floats in Godot - compare with an epsilon and arrays element-wise, never `array == [1, 2, 3]`.
