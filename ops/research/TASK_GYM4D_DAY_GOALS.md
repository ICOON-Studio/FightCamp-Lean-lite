# TASK GYM4D - The 2-minute day's goals and auto-pauses: DayGoals.gd + day_goals.json + its test

Model: qwen3-coder (Qwen CLI, local launcher). Owner: Qwen. Work in your worktree on branch `qwen/gym4d-day-goals`, commit, push
the branch; NEVER push master. Tier: new script + new data + new test -> parse gate on the new files + the new test.

## What it is
The operator chose Kalli's pacing (K87, `research/K87_DAY_LAP_PACING_RAW.md`): a 2-minute day, queue only the next station,
ONE day goal and ONE week goal always on screen, and the game pauses itself at a few moments. This task is ONLY the pure rule module
that (a) builds the day goal and week goal for a fighter and (b) says whether to auto-pause now. No UI, no DayLap edits.

## Owned files (create; touch nothing else)
- `Godot/assets/data/day_goals.json`: `stamina_floor` (30, the bell line), `amber_stamina` (50), `goal_kinds` (day:
  "stamina_at_bell", "sets_by_time"; week: "move_usable_by_day"), `week_days_watched` (5), the auto-pause list ids:
  "queue_empty", "stamina_floor", "coach_pool_short", "injury_flag", "bell", "panel_open", and `never_pause_on` ["walking", "set_done"].
- `Godot/scripts/DayGoals.gd` - `extends RefCounted`, static, pure (no GameState, no autoload, no RNG, no preload):
  - `static func day_goal(ctx: Dictionary) -> Dictionary` -> {kind, text, target, met: bool, progress: float 0..1}. Default kind
    "stamina_at_bell": met when ctx.stamina_at_bell >= stamina_floor (text "Stamina above 30 at the bell", number from data).
    "sets_by_time": ctx.sets_done vs ctx.sets_target by ctx.deadline_minute (text "3 jab sets by 18:00"; game minute 0 = 08:00).
  - `static func week_goal(ctx: Dictionary) -> Dictionary` -> {kind "move_usable_by_day", text "Jab usable by Friday", move, day,
    met, progress = card_minutes / usable_minutes clamped 0..1}. ctx: move_name, card_minutes, usable_minutes, by_day ("Friday"),
    today_index (0 = Monday).
  - `static func should_pause(event: String, ctx: Dictionary) -> Dictionary` -> {pause: bool, why: String}. pause true for:
    "queue_empty" when ctx.next_station == ""; "stamina_floor" when ctx.stamina crosses DOWN through stamina_floor (prev > floor
    >= now); "coach_pool_short" when ctx.pool_left < ctx.pool_needed_rest_of_week; "injury_flag" when ctx.injury_flag; "bell"
    always; "panel_open" always. Never for any id in never_pause_on. Unknown event -> {pause false, why ""}.
  - `static func stamina_band(stamina: float) -> String` -> "green" / "amber" (< amber_stamina) / "red" (< stamina_floor).
- `Godot/tests/day_goals_test.gd` - `extends SceneTree`, ok/FAIL lines, final `DAY GOALS PASS` or `DAY GOALS FAILS=<n>` + exit 1.

## Acceptance (numbers read from the data, never copied)
1. day_goal stamina_at_bell: met at floor, not met at floor - 1; text contains the floor number from the data.
2. sets_by_time: progress = done/target clamped; HH:MM of the deadline (minute 600 -> "18:00").
3. week_goal: progress clamps at 1; met only when card_minutes >= usable_minutes.
4. should_pause: each event's true case and one false case; stamina_floor fires only on the downward crossing (not when already
   under it); walking/set_done never pause; unknown -> false.
5. stamina_band boundaries (floor, amber line) from the data.
6. Purity: ctx is not modified; editing a returned dict does not change the next call.
MUTANTS (comment block at the bottom; run each, each must turn the test red): pause on walking; stamina_floor fires while already
below; progress not clamped; amber/red swapped.

## Parse gate + test (the PC's Godot)
`python Godot/tools/check_scripts.py Godot/scripts/DayGoals.gd Godot/tests/day_goals_test.gd`
`%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/day_goals_test.gd`
NEVER use the `_console.exe` (it opens a window on the operator's screen). Nothing may open on the operator's screens.

## Prior research
K87 (pacing: 2:00 day, goals, auto-pauses, MM's "queue only the next pitstop"), DAYLAP1_DESIGN.md, GYM4_REDESIGN_S178.md.

## What would a human do?
Put every threshold in data, write four small pure functions, and test each boundary from both sides.

## Prefab check
None: pure rules.

## The one trap
`var x := <call>` fails when the call returns Variant - type it; a variable name reused in one function is a parse error.
