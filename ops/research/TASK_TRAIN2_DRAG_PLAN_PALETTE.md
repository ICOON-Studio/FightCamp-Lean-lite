# TASK TRAIN2 - drag-to-plan palette on the Training planner

Model: Arena (free coding worker), own branch arena/<chat-id>-fightcamp, PR into master, never merge. Tier: script edited -> parse gate +
the new test + `run_tests.py --only training --jobs 2` and `--only program`.
Origin (operator S170, shown a manager game's rota): "what do you think of this screen?" -> Claude: copy the MECHANISM - a palette of
discipline icons you drag onto a day - not the look. Operator: "go with your recommendations".

## Prior research
`python Tools/prior_research.py training planner palette drag` first. Baseline stills: `previews/s170_floor3/25_planner_programmed.png`,
`previews/s170_coach2/32_planner_coached.png`. Fight Business walk (`S170_FIGHT_BUSINESS_WALK.md`) = a focus pick + weekly tick only.

## What would a human do?
Look at the week, see which days are empty, grab "Technique" from a shelf and drop it on Wednesday. No menu, no modal. If it cannot go there
(no coach, injured, fight night, station full) the day says why, in words, on the spot.

## Prefab check
Godot has built-in drag and drop on Control (`_get_drag_data`, `_can_drop_data`, `_drop_data`) - use it. UIKit primitives only (`UIKit.block`,
`chip`, `caps`, `tip`). No new theme token, no new art.

## Owned files
- `Godot/scripts/TrainingHubPanel.gd` (~1,300 lines; NEVER read whole). Windows: `rebuild` 100-145 (status line at 138), `_build_week` ~200-260
  (presets row + week bands + hint at 250), the preset apply loop ~1180-1225, `_on_day` (day press -> drawer).
- `Godot/scripts/UIKit.gd` `week_band` (search `static func week_band`): the 7 day cells; they become drop targets.
- New test `Godot/tests/training_palette_test.gd`.
- GameState is NOT edited: the drop calls the existing `set_week_program_day(athlete_id, day, focus, station_id)` and shows its `reason` verbatim.

## Build
1. A PALETTE strip under the presets row: one tile per focus the planner already offers (power, speed, technique, conditioning, boxing IQ /
   the ring, bags, strength, cardio, recovery - read them from the same list the day drawer uses; do not hard-code a second list). Tile = icon
   + name + one tooltip line (`UIKit.tip`) saying what it trains.
2. Drag a tile onto a day cell = program that day with that focus (auto-pick the station exactly as the drawer does). A refused drop leaves
   the day unchanged and writes the refusal into the existing status line (never a silent no-op).
3. While dragging, every day cell that would refuse shows a dim state; the cell under the cursor highlights.
4. Dragging a filled day cell onto another moves it (swap if both filled); dropping on the palette clears it. Keep the click -> drawer path.
5. Keep every existing node name the tests read (`Hub`, `Status`, `Hint`, preset buttons, band/day names); grep `Godot/tests` for them first.

## Acceptance (the one test)
`Godot/tests/training_palette_test.gd`, headless, real career (copy the setup of `Godot/tests/training_no_coach_test.gd`): (a) the palette has one
tile per focus the drawer offers; (b) simulate a drop (call the cell's `_drop_data` directly with the drag payload) of "technique" on day 2 -> the
GameState program day 2 focus is technique; (c) with `gs.career["staff"] = []` the same drop is refused, the day is unchanged and the status line
says HIRE A COACH FIRST; (d) a drop on a fight-night-locked day is refused with its reason; (e) control arm: the old click -> drawer path still sets
a day. Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/training_palette_test.gd` (NEVER `_console.exe`).
Claude then walks it as_game (`research/s170_coach.plan` + a drop step) and opens the still before merging.

## The one trap
Drag and drop does not run headless from real mouse input; call `_get_drag_data` / `_drop_data` directly in the test, and ALSO check the
real cell is a Control with `mouse_filter` STOP and a size > 0, or the drop never reaches it in the game. Do not delete or weaken a test.
