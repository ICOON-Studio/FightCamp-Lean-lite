# TASK WEEKGRID1A - the fight week Tue-Sat schedule + readiness formulas as data + pure module + test (S198)
Model: Qwen (qwen3-coder) - pure module, no UI, no GameState. Worktree E:/FightCamp/wt/NIGHTLY2. NEW branch qwen/weekgrid1a:
`git fetch && git checkout -B qwen/weekgrid1a origin/master`.

## Owned files
- `Godot/assets/data/fight_week_schedule.json` (NEW)
- `Godot/scripts/rules/FightWeekPhysiology.gd` (NEW)
- `Godot/tests/fight_week_physiology_test.gd` (NEW)

## Spec (operator approved, board Q-S196-3: "fight week as a Tue-Sat grid with a readiness bar, in kg")
Source: research/LUDO_ROUND33_S198.txt "5.2 Definitive Tuesday-to-Saturday Schedule, Fatigue Formulas" (lines ~939-1002).
CORRECTION (approved): every weight is in KILOGRAMS (lbs x 0.4536, round to 0.1 kg); the weight penalty per kg = 15 x 2.2046 = 33.07.
1. `fight_week_schedule.json`: the 15 sessions of Ludo's matrix in order: {day "tue".."sat", start "08:00", session, intensity
   ("zero","none","low","medium","high","max" + numeric 0.0-3.0: zero/none 0, low 0.5, medium 1.0, high 2.0, max 3.0), hours,
   fatigue_pct (+ = tiring, - = recovery, as Ludo: Tue padwork +14.0 ... Fri refeed -25.0), snap_pct, wear {region: pct} using OUR six
   regions (head_neck, torso_core, left_arm, right_arm, left_leg, right_leg - map wrists/hands to both arms, calves/patella/achilles to
   both legs, "Tissue Flush -8%" = all six -8; write the mapping in the json `note`), weight_kg, flags (e.g. "decision" for THU 14:00
   LAST-SPAR COMMITMENT, "weigh_in" for FRI 09:00)}. Copy Ludo's numbers exactly apart from the kg conversion.
2. `FightWeekPhysiology.gd`: `extends RefCounted`, `class_name FightWeekPhysiology`, pure static, loads + caches the json (pattern of
   `scripts/rules/CutScar.gd`). API:
   - `schedule() -> Array` (deep copies);
   - `hourly_fatigue(intensity: float, conditioning_0_100: float, gym_temp_c: float) -> float` = (intensity*8.5)/(1+conditioning*0.012)
     x (1 + max(0, (temp-22)*0.035));
   - `snap(base_snap: float, stamina_pct: float, hours_since_high: float) -> float` - Ludo's piecewise curve (0.88->1.0 over 0-18 h,
     1.0 from 18-48 h, then -0.008/h to a 0.75 floor) x clamp(stamina/80, 0.5, 1.0);
   - `readiness(stamina: float, snap: float, max_region_wear: float, weight_over_kg: float) -> float` = clamp(0.35*stamina + 0.40*snap
     - 0.25*max_wear - (weight_over_kg > 0 ? 25 + 33.07*kg : 0), 0, 100);
   - `run_week(start: Dictionary) -> Dictionary` where start = {stamina, snap, wear {region: pct}, weight_kg, target_kg}: walks the 15
     sessions in order applying fatigue_pct to stamina (stamina -= fatigue_pct, clamp 0..100), snap_pct to snap (clamp 0..100),
     wear pct to each region (clamp 0..100), weight_kg to weight; returns {rows: [one per session with stamina/snap/max_wear/weight
     after it], readiness_by_day {tue..sat: readiness at the day's last session}, final {stamina, snap, max_wear, weight_kg, readiness},
     made_weight bool at the weigh-in row}.
3. Test `fight_week_physiology_test.gd` (extends SceneTree; prints `FIGHTWEEK total=N fails=M`; quit(1) on fail): 15 sessions in day
   order; the THU decision row and FRI weigh-in row exist; every weight in kg (e.g. Thu sauna -3.8 lbs -> -1.7 kg); hourly_fatigue
   exact values at (2.0, 50, 22) and (2.0, 50, 30); snap at 6 h, 24 h, 60 h and the 0.75 floor at 200 h; readiness exact for two inputs
   incl. 0.5 kg over (penalty 25 + 16.5); run_week from {100, 80, {}, 72.0, 70.0} returns 5 day readiness values in 0..100 and
   made_weight matches weight_kg <= target at the weigh-in row; inputs never mutated. Name 3 mutants in your final message.

## Gates
`python Godot/tools/check_scripts.py <new .gd>`; `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot
--script tests/fight_week_physiology_test.gd` -> exit 0, no FAIL, no SCRIPT ERROR. Typed GDScript (never := on a Variant).

## Prior research
LUDO_ROUND32_S197.txt 5.1, LUDO_ROUND33_S198.txt 5.2, LUDO_ROUND32_VERDICT_S197.md D. Existing fight week: scripts/FightWeekRail.gd,
FightWeekPanel.gd (read-only context - do not edit).
## What would a human do?
A trainer writes the fight week on a whiteboard, session by session, and ticks weight and sharpness every evening.
## Prefab check
None - our own rules.

## The one trap
Kilograms everywhere (operator correction) - a single lbs number left in the json is a defect. Commit on qwen/weekgrid1a, push; never
master; never open windows, image viewers or browsers.
