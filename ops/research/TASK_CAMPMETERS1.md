# TASK CAMPMETERS1 - the camp's two meters: Readiness (gains) and Wear (attrition), as one pure rules module (boxing)

Model: Arena (cloud). Discipline: BOXING (demo). Fast lane: ADD ONLY the two new files below, touch nothing else.

## Why
Operator board Q-S249-4 (S255): "Approve" the production roadmap; its S255 slice is "one screen shows a deadline goal + GAINS and
ATTRITION and the day you must change the plan". Design: Ludo r119 A2 (research/PRODUCTION_ROADMAP_S254.md "S255 READ"):
Readiness 0-100 = plan familiarity 0.35 + weight cut 0.35 + primary tactic mastery 0.30, target >= 80; Wear 0-100 = muscle fatigue
0.40 + micro-trauma/chin 0.35 + weight drain 0.25; bands 0-39 fresh, 40-59 productive, 60 = change-the-plan point (amber; growth
-40%, injury +25% per session), 80+ breakdown; the fix = drop sparring/heavy bag for recovery work until wear < 50.
This module only COMPOSES numbers the game already has (GameplanReadiness.gd readiness, AreaWear.gd/BoutWear.gd area wear, the weight
cut, MoveMastery mastery) - Claude feeds it and Cursor draws the strip afterwards. Do NOT re-implement those modules.

## Files you create (only these)
1. `Godot/scripts/rules/CampMeters.gd` - `extends RefCounted`, ALL functions `static`, NO preloads, NO autoloads, NO RNG,
   no class_name, no argument modified.
2. `Godot/tests/camp_meters_test.gd` - `extends SceneTree`, `OK  <label>` / `FAIL <label>` lines, ends with
   `print("CAMP_METERS failures=%d" % failures)` and `quit(0 if failures == 0 else 1)`.

## CampMeters.gd API
- consts: `W_FAMILIARITY = 0.35`, `W_WEIGHT_CUT = 0.35`, `W_TACTIC = 0.30`, `READY_TARGET = 80.0`;
  `W_FATIGUE = 0.40`, `W_TRAUMA = 0.35`, `W_DRAIN = 0.25`; `BAND_PRODUCTIVE = 40.0`, `BAND_CHANGE_PLAN = 60.0`, `BAND_BREAKDOWN = 80.0`;
  `RECOVER_UNTIL = 50.0`; `GROWTH_MULT_OVER_PLAN = 0.60`; `INJURY_MULT_OVER_PLAN = 1.25`; `GROWTH_MULT_BREAKDOWN = 0.30`;
  `INJURY_MULT_BREAKDOWN = 1.60`; `HARD_STATIONS = ["sparring", "heavy_bag"]`.
- `static func weight_cut_progress(start_kg: float, current_kg: float, target_kg: float) -> float` - 0..100 share of the cut done;
  100 when current <= target; 100 when start <= target (no cut needed); never negative (heavier than start = 0).
- `static func readiness(familiarity: float, weight_cut: float, tactic_mastery: float) -> float` - each input clamped 0..100,
  weighted sum, rounded to 0.1.
- `static func wear(fatigue: float, trauma: float, drain: float) -> float` - same rule with the wear weights.
- `static func wear_band(w: float) -> String` - "fresh" (< 40), "productive" (40..< 60), "change_plan" (60..< 80), "breakdown" (>= 80).
- `static func effects(w: float) -> Dictionary` -> `{"growth_mult", "injury_mult", "alert": bool, "border": "none"|"amber"|"red"}`:
  fresh/productive 1.0/1.0/false/none, change_plan 0.60/1.25/true/amber, breakdown 0.30/1.60/true/red.
- `static func recovery_advice(w: float, in_recovery: bool) -> Dictionary` -> `{"drop_stations": Array, "recover": bool}`:
  recover starts at w >= BAND_CHANGE_PLAN and, once in_recovery is true, stays true until w < RECOVER_UNTIL (hysteresis: w 55 with
  in_recovery true -> still recover); drop_stations = HARD_STATIONS while recover, else [].
- `static func strip(readiness_v: float, wear_v: float, days_left: int, opponent: String, weight_kg: float, target_kg: float) -> Dictionary`
  -> `{"readiness", "ready_target", "on_track": bool (readiness >= target), "wear", "band", "alert", "days_left", "opponent",
  "weight_gap_kg"}` - the one dict the goal strip draws.
- Every number is a `const`; the test reads the consts, never the literals.

## The test (from this contract, not from your code)
- readiness(100,100,100) == 100; (0,0,0) == 0; (80,80,80) == 80; weights sum to 1.0 for both meters; inputs out of range clamp;
- weight_cut_progress: 80 -> 75 target 72 = 62.5; at or under target = 100; heavier than start = 0; start <= target = 100;
- bands flip exactly at 40 / 60 / 80 (39.9 fresh, 40 productive, 59.9 productive, 60 change_plan, 80 breakdown);
- effects at 60: growth 0.60, injury 1.25, alert, amber; at 59.9: 1.0 / 1.0 / no alert;
- recovery hysteresis: 61 not in recovery -> recover; 55 in recovery -> recover; 49.9 in recovery -> not; 55 not in recovery -> not;
- strip: on_track flips at READY_TARGET; weight_gap_kg = weight - target; no argument modified.
- Mutants: say in the PR body which two consts you nudged and that the test went red.

## Prior research
`python Tools/prior_research.py readiness wear meters`: GameplanReadiness.gd (plan familiarity, S235), TrainingMeters.gd (METERS1
day readouts), AreaWear.gd / BoutWear.gd (per-region wear, FIGHTLINK 1b), CareerWear.gd (career-long wear) - this module sits above
them and reads their outputs as plain numbers. GYMFLOOR_MECHANICS_IDEAS_S234.md ("sloppy" gains x0.6) agrees with the 0.60 growth mult.

## What would a human do?
A trainer keeps two things in his head during camp: "is he ready for this guy and the scale?" and "is he getting beat up in the gym?".
When the second one gets too high he pulls him out of sparring for two days and does pads and roadwork until he's fresh again.

## Prefab check
No camp-readiness library exists. Pure GDScript, no assets.

## Contract
OWNS: Godot/scripts/rules/CampMeters.gd, Godot/tests/camp_meters_test.gd
RED_TEST: Godot/tests/camp_meters_test.gd -> CAMP_METERS failures=0
REGRESSION: camp_meters_test
VISUAL: no
