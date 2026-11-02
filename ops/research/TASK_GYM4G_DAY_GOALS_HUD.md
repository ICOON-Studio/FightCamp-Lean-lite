# TASK GYM4G - The day goal and week goal on screen: DayGoalsHud.gd (a UI widget) + the pause banner + its headless test

Model: Cursor (cursor-agent, default model). Owner: Cursor. Worktree `E:/FightCamp/wt/GYM4G`, branch `cursor/gym4g-day-goals-hud`
(created from master). Commit, push the branch; NEVER push master, never merge. Tier: new script + new test + one data edit ->
parse gate on the new .gd files + the new test + `tests/day_goals_test.gd` (must stay green).

## What it is
The operator OK'd the club plan (S178: "OK, build it"; pacing "2:00 day (Kalli)"). K87 pacing, design of record
`research/GYM4_REDESIGN_S178.md` section "Pacing": "One DAY goal and one WEEK goal always on screen ('stamina above 30 at
the bell', 'jab usable by Friday'). Auto-pause: queue empty, stamina 30, coach pool short for the rest of the week, injury flag,
the bell." The rules are merged as a pure module, `Godot/scripts/DayGoals.gd` (125 lines, read it whole):
`day_goal(ctx) -> {kind, text, target, met, progress}`, `week_goal(ctx) -> {kind, text, move, day, met, progress}`,
`should_pause(event, ctx) -> {pause: bool, why: String}`, `stamina_band(stamina) -> "red"|"amber"|"green"`.
This task is ONLY the widget that draws them. Claude wires it into the 3D club (GymClub3D / GymHall3D) after the merge -
do NOT touch any scene, GymHall3D.gd, GymClub3D.gd, CareerRoot.gd or GameState.gd.

## Owned files
- `Godot/scripts/DayGoalsHud.gd` - NEW, `extends Control`. Public:
  - `show_goals(day: Dictionary, week: Dictionary) -> void` - takes exactly what `DayGoals.day_goal` / `week_goal` return.
  - `show_pause(event: String) -> void` - a banner across the top centre: icon + the player line for that event (see data edit),
    a small "Space to resume" hint. `clear_pause() -> void`. `pause_line() -> String` (the shown text, "" when hidden).
  - `goal_text(which: String) -> String` ("day"|"week") and `goal_progress(which: String) -> float` for the test.
- `Godot/tests/day_goals_hud_test.gd` - NEW, headless `extends SceneTree`, use `func _initialize()` (NOT `_init`: in `_init` the
  tree is not running, so a Control added to root is not inside it and `get_viewport()` is null), ok/FAIL lines, final
  `DAY GOALS HUD PASS checks=<n>` or `DAY GOALS HUD FAILS=<n>` + exit 1.
- `Godot/assets/data/day_goals.json` - ADD one key `"pause_lines"`: event id -> the line a player reads. The current
  `DayGoals.should_pause` `why` strings are developer words ("Stamina crossed floor downward"); the banner shows these instead:
  `queue_empty` "Nothing queued - pick his next station", `stamina_floor` "He's running on empty - rest or ease off",
  `coach_pool_short` "Coach hours won't last the week", `injury_flag` "Something's wrong - check him now", `bell` "The bell -
  day over", `panel_open` "" (no banner for an open panel). Do not change any existing key.

## Look (operator rules: icons over text, every icon has a tooltip; bright, readable)
- Top-left, two stacked rows, each: a Lucide icon (`IconKit.line_icon(name, 20)`, `scripts/IconKit.gd`; day = "sunrise", week =
  "calendar-check"), the goal text, a thin progress bar under the text (`UIKit.gauge_bar` or a plain ColorRect pair), and when
  `met` a "circle-check" icon tinted green. Tooltip on each row via `UIKit.tip(node, text)` (`scripts/UIKit.gd` ~line 206) -
  NEVER `tooltip_text` (UserSettings/TipLayer clears it; tests read the node's meta "tip"). Day tooltip: "Today's goal - " + text;
  week tooltip: "This week's goal - " + text.
- Colours from `scripts/UITokens.gd` (UIKit preloads it as `T`); the bar colour follows `DayGoals.stamina_band` for a
  stamina goal (red/amber/green), gold otherwise. `mouse_filter = MOUSE_FILTER_IGNORE` on the root so it never eats clicks
  meant for the 3D club; the rows themselves are `MOUSE_FILTER_PASS` so their tooltips work.
- Banner icon by event: queue_empty "list" if it exists in `assets/icons/lucide/` else "circle-alert"; stamina_floor "heart-pulse";
  coach_pool_short "hourglass"; injury_flag "bandage"; bell "bell". Check each with `IconKit.has_icon` and fall back to "circle-alert".

## Acceptance (day_goals_hud_test.gd - every text and number read from DayGoals / day_goals.json, never copied)
1. `show_goals(DayGoals.day_goal(ctx_a), DayGoals.week_goal(ctx_b))` -> `goal_text("day") == day.text`,
   `goal_text("week") == week.text`, `goal_progress` equals each dict's `progress` (+-0.001), for two different ctx pairs
   (a stamina_at_bell day and a sets_by_time day).
2. A met goal shows the check icon; an unmet one does not (find it by node name, e.g. "DayMet"/"WeekMet", `visible`).
3. Every row and the banner icon carry a non-empty meta "tip"; no node in the widget has a non-empty `tooltip_text`.
4. For every event in `day_goals.json` `auto_pause`: `show_pause(event)` -> `pause_line() == pause_lines[event]`; an empty line
   (panel_open) hides the banner; `clear_pause()` -> `pause_line() == ""` and the banner is hidden.
5. Every banner/goal icon is a real file (`IconKit.has_icon(name)` true) and the TextureRect's texture is non-null.
6. The widget's root `mouse_filter == MOUSE_FILTER_IGNORE`.
7. `tests/day_goals_test.gd` still passes (you only ADDED a key).
MUTANTS (comment block at the bottom of DayGoalsHud.gd; run each, each must turn the test red, then revert): tooltip via
`tooltip_text`; banner shows the `should_pause` why instead of the pause line; progress bar ignores `progress` (always full);
met icon always visible.

## Parse gate + tests (the PC's Godot, headless; NEVER the _console.exe - it opens a window on the operator's screen)
`python Godot/tools/check_scripts.py Godot/scripts/DayGoalsHud.gd Godot/tests/day_goals_hud_test.gd`
`%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/day_goals_hud_test.gd`
`%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/day_goals_test.gd`
The runner fails a test on ANY "SCRIPT ERROR" line even when it prints PASS - grep your log for it. No windowed Godot, no image,
video or browser opened. Nothing may appear on the operator's screens.

## Prior research
K87 (Kalli's pacing: one day goal + one week goal always on screen, auto-pauses), GYM4_REDESIGN_S178.md "Pacing", DayGoals.gd
(merged GYM4D), J61/J64 (Two Point / Motorsport Manager HUDs), memory/GLOSSARY 'Icon with tooltip'.

## What would a human do?
Copy Motorsport Manager's race HUD: the objective top-left in one line with a bar, and a clear banner when the game stops itself
and why, so the player never wonders why time stopped.

## Prefab check
Plain Godot Controls + the repo's own UIKit/IconKit/Lucide set - nothing to download.

## The one trap
`var x := <call>` fails when the call returns Variant - type it (`var n: int = ...`); a variable name reused in one function is a
parse error; `remove_child(node)` before `queue_free()` when you rebuild rows; a Label outside a Container breaks lines only with `\n`.
