# TASK WEEKGRID1B - open the fight week Tue-Sat grid from the V3 club HUD (wire the merged FightWeekGridPanel) (S207)
Model: Cursor (Godot UI). Worktree E:\FightCamp\wt\WEEKGRID1B, branch cursor/weekgrid1b. Approved: operator board Q-S196-3
("approve all", Ludo r32 5.1: fight week as a Tue-Sat grid with a READINESS bar, in kg).

## Prior research
TASK_WEEKGRIDPANEL1.md (the panel's spec, merged S205 PR #116), Ludo r32 s5.1, FightWeekPhysiology.gd (the pure maths).
## What would a human do?
Put one "WEEK PLAN" button on the fight-week rail the player already sees; it opens the grid as an overlay, Esc/close returns.
## Prefab check
Nothing to buy: the panel exists (`Godot/scripts/ui/FightWeekGridPanel.gd`, 212 lines, `static func build(start, ctx)`).

## Spec
1. `Godot/scripts/LudoGymHud.gd` (835 lines - read ONLY `sed -n 325,430p` and grep-found windows): when `uses_fight_week_rail(_gs,
   athlete_id)` is true, `_rebuild_week()` appends ONE Button named `WeekGridButton`, text "WEEK PLAN", under the rail rows.
   Pressing it calls a new `open_week_grid(athlete_id)` that adds `FightWeekGridPanel.build(start, ctx)` inside a full-rect
   PanelContainer overlay named `WeekGridOverlay` (dark backdrop, a CLOSE button, Esc closes; `remove_child` before `queue_free`).
2. NEW `static func week_grid_start(gs, athlete_id) -> Dictionary` in LudoGymHud: the panel's `start` from the athlete's REAL state
   (grep the GameState getters for stamina/snap/wear/weight - `grep -n "func get_athlete\|stamina\|weight_kg\|target_kg"
   Godot/scripts/GameState.gd | head -40`; GameState.gd is never read whole). Keys {stamina, snap, wear {region: pct}, weight_kg,
   target_kg}; a key the state lacks takes the FightWeekPhysiology default, never an invented number. ctx.title = "FIGHT WEEK: <A>
   vs <B> - SATURDAY NIGHT" from `get_fight_week_card`; ctx.today = the current day id.
3. Outside fight week nothing changes (no button).

## Owned files
- `Godot/scripts/LudoGymHud.gd` (only the above)
- `Godot/tests/week_grid_open_test.gd` (NEW)
Read-only: FightWeekGridPanel.gd, GameFightWeek.gd, FightWeekPhysiology.gd, club_fight_week_entry_test.gd (copy its FakeState pattern).

## Acceptance (tier: script edited)
- NEW `Godot/tests/week_grid_open_test.gd` (two DIFFERENT stand-in boxers through a fake GameState like club_fight_week_entry_test):
  boxer A in fight week -> HUD has `WeekGridButton`; pressing it -> `WeekGridOverlay` holds a FightWeekGridPanel whose weight label
  shows A's weight/target; CLOSE removes the overlay. Boxer B 3 weeks out -> no button. Must be RED on master first (no button).
- Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/LudoGymHud.gd Godot/tests/week_grid_open_test.gd`
- `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/week_grid_open_test.gd`
- `python Godot/tools/run_tests.py --jobs 1 --only ludo_gym,fight_week,club_fight_week,hud` - nothing green goes red.

## The one trap
The HUD rebuilds the week list on every refresh: keep the overlay as a child of the HUD root (not of `_week`), or a refresh frees it.
