# TASK WEEKGRIDPANEL1 - the fight week Tue-Sat grid screen as a panel (renders FightWeekPhysiology) + headless test (S204)
Model: Arena (cloud). Repository ICOON-Studio/FightCamp (Godot 4.7.2, GDScript in Godot/). Own arena/ branch, PR into master, never merge.

## Owned files
- `Godot/scripts/ui/FightWeekGridPanel.gd` (NEW)
- `Godot/tests/fight_week_grid_panel_test.gd` (NEW)
Edit nothing else.

## Spec (operator approved, board Q-S196-3: "fight week as a Tue-Sat grid with a readiness bar, in kg")
`class_name FightWeekGridPanel extends VBoxContainer`, `static func build(start: Dictionary, ctx: Dictionary = {}) -> FightWeekGridPanel`.
`start` = the run_week input {stamina, snap, wear {region: pct}, weight_kg, target_kg}; `ctx` may hold "title" (e.g.
"FIGHT WEEK: VANCE vs MOLINA - SATURDAY NIGHT") and "today" ("tue".."sat").
Data ONLY from the pure module `res://scripts/rules/FightWeekPhysiology.gd` (read it): `schedule()` (15 sessions, each {day, start
"HH:MM", session, intensity, hours, fatigue_pct, snap_pct, wear {region: pct}, weight_kg, flags}) and `run_week(start)` ({rows (one
per session: stamina, snap, max_wear, weight_kg after it), readiness_by_day {tue..sat}, final {stamina, snap, max_wear, weight_kg,
readiness}, made_weight}). Never re-implement the maths.
1. TITLE line from ctx.title (omit the Label when absent).
2. READINESS BAR (one HBoxContainer, 5 meters, Ludo r32 s5.1): STAMINA `final.stamina` / 100 (green #10B981), SNAP `final.snap` %
   (cyan #06B6D4), TISSUE WEAR `final.max_wear` % (amber #F59E0B), WEIGHT "<weight_kg> / <target_kg> kg" with the gap to make
   ("-0.8 kg to make" or "ON WEIGHT"), READINESS `final.readiness` % in gold #D69E2E. Numbers one decimal for kg, whole for %.
3. GRID: a GridContainer with 5 columns: DAY | MORNING | AFTERNOON | EVENING | DAILY CHANGE. One row per day tue..sat (labels
   TUESDAY..SATURDAY). A session goes in MORNING when its start hour < 12, AFTERNOON when < 17, else EVENING. Each session cell: the
   session name, "<hours> h | <INTENSITY>", and its wear ("Wear: right arm +6%" / "Wear: all -8%" / "Wear: clean"). A cell whose
   session has flag "decision" or "weigh_in" gets a gold border #D69E2E. DAILY CHANGE = the sum of that day's fatigue_pct, snap_pct
   and weight_kg ("FATIGUE +14% / SNAP +4% / WEIGHT -1.6 kg") plus "READY <readiness_by_day[day]>%".
4. The row whose day == ctx.today is highlighted (background #1F2637); no highlight when ctx.today is absent.
5. Every unit is kg - the string "lb" must not appear anywhere. Background #12161F. Every cell gets a tooltip through
   `UIKit.tip(node, "text")` (`res://scripts/UIKit.gd`; NEVER `tooltip_text`). Fits Rect2(20, 140, 1146, 588) (Ludo's grid + bar).

## Test - `Godot/tests/fight_week_grid_panel_test.gd` (extends SceneTree; prints `PASS <name>`/`FAIL <name>: <detail>`, final
`WEEKGRIDPANEL total=N fails=M`; quit(1) on fail)
(a) 5 day rows TUESDAY..SATURDAY; 15 session cells, each holding its schedule() session name in the right slot (check Tuesday's 08:00
session is in MORNING and Thursday's last-spar decision session carries the gold border); (b) the readiness bar's 5 values equal
run_week(start).final (stamina, snap, max_wear, weight, readiness) for start {100, 80, {}, 72.0, 70.0}; (c) DAILY CHANGE for Tuesday
equals the sum of Tuesday's sessions from schedule(); (d) no Label/Button text anywhere contains "lb"; (e) ctx.today "thu" highlights
exactly one row and no ctx.today highlights none; (f) build() does not mutate `start`; (g) combined minimum size fits 1146 x 588.
List 3 mutants in the PR body that each fail it.

## Gate
`godot --headless --path Godot --script tests/fight_week_grid_panel_test.gd` exits 0, fails=0, no SCRIPT ERROR. Typed GDScript, tabs,
never `:=` on a Variant. Do not commit .import/.uid files or the .godot cache.

## Prior research
research/LUDO_ROUND32_S197.txt lines 468-505 ("5.1 Tuesday-to-Saturday Schedule UI"), LUDO_ROUND32_VERDICT_S197.md section D
(TAKE, kilograms), research/TASK_WEEKGRID1A.md (the maths), scripts/ui/LastSparPanel.gd (the house pattern for a panel + test).
## What would a human do?
A trainer's whiteboard for fight week: five rows, three sessions a day, and at the top how sharp and how heavy the fighter is.
## Prefab check
None - project UI kit.

## The one trap
Pounds: Ludo's mockup is in lbs; the game is in kg. One "lbs" label is a defect.
