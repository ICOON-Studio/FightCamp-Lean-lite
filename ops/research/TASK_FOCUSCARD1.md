# TASK FOCUSCARD1 - the station FOCUS CARD replaces the effort bar, and the gain bubbles name every attribute (boxing demo)

Model: Cursor (cloud). Discipline: BOXING (demo).
Approved by the operator, board Q-S264-1 (S266): "Build the station focus plan as written". Spec: `research/STATION_FOCUS_S266.md`
(sections "Simple" 2-3). Operator: "you select the heavy bag and you have 2-3 options to focus with different +/-", "the bars of
attriton and stamina there you se the gains ;like bubles", "keep it simple but deep".

## Already on master (S267, Claude) - the data path is DONE, you build the UI on it
- `scripts/rules/StationFocus.gd` (table, `card_lines(station)` exact text) and `scripts/rules/StationFocusTraining.gd`.
- `GymHall3D.gd` (4,900+ lines - read in windows; GymClub3D extends it) now has, behind switch `station_focus` (GAME_ON):
  `focus_options() -> [{id, name, line, selected}]` for the station he is at ([] when none / walking), `set_focus(id)`,
  `focus_key(1..3)`, `current_focus(station="")`, and `last_ring_report` / a "ring_report" decision card at the end of a spar.
  The focus is his PROGRAM: kept on the athlete (`station_focus` {station: focus_id}) - tomorrow's block at that station plays it.
- The effort bar today: `scripts/ui/FormCueBar.gd` (338 lines; keys 1-3 at :60-:80; built by `GymClub3D._build_cue_bar` ~:1137,
  placed by `GymHall3D._place_cue_bar` ~:4885 at `CUE_BAR_POS` bottom centre).

## Files you own
1. NEW `Godot/scripts/ui/FocusCard.gd` - same look as FormCueBar (its Round-70 tokens, 180 ms hover tween, rounded 4): a title
   `<STATION NAME> - FOCUS`, then one row per `focus_options()` entry showing its `line` text exactly (`[1] POWER SHOTS   + POWER  - more
   fatigue`), the selected row gold-bordered; keys 1-3 and click call `floor.focus_key(i)` / `floor.set_focus(id)`; `refresh()` re-reads
   `focus_options()`; hidden while `focus_options()` is empty (walking, recovery). Animated per memory rule (every change tweens).
2. EDIT `Godot/scripts/GymClub3D.gd` `_build_cue_bar` only: when `GameSwitches.on("station_focus")`, build `FocusCard` (node name
   `FocusCard`) at the same `CUE_BAR_POS` INSTEAD of FormCueBar; OFF = FormCueBar exactly as today. Refresh it when the station changes
   (find the call site that already refreshes FormCueBar - name it in the PR).
3. EDIT `Godot/scripts/GymHall3D.gd` `_gain_tick` (~:3170) only: when `station_focus` is ON, the bubble words are ATTRIBUTE names:
   raw keys map `ring_iq -> FIGHT IQ`, `defence -> GUARD`, `hand_speed -> HAND SPEED`, others upper-cased with `_` -> space; AND the new
   attributes the focus grows (hand_speed, head_movement, guard, footwork, composure, recovery) join the bubbles: per tick, compute
   `AttributeTraining.day_gains(stats, minutes_so_far, coach_rating, age, gen_cap, StationFocusTraining.split_minutes(plan_so_far))`
   and bubble each attribute whose delta since the last tick is >= 0.01 as `+0.03 HEAD MOVEMENT` (two decimals). Still at most two
   bubbles per tick, largest first. OFF = today's text exactly.
4. NEW `Godot/tests/focus_card_test.gd` (OK/FAIL lines; ends `print("FOCUS_CARD failures=%d" % failures)`): a floor (copy the set-up of
   `tests/gym_club_3d_test.gd` / `tests/form_cue_engine_test.gd`) with the fighter AT the heavy bag and `station_focus` forced ON
   (`OS.set_environment` or the test seam those tests use - read GameSwitches.on): FocusCard exists, shows 3 rows whose texts equal
   `StationFocus.card_lines("heavy_bag")`, key 1 -> `current_focus() == "power_shots"` and the row 1 selected; at recovery the card hides;
   switch OFF -> FormCueBar and no FocusCard; a gain tick at pads with focus `hand_speed` produces a bubble text containing `HAND SPEED`.
   Must go RED on master first (no FocusCard).

## Acceptance
`tests/focus_card_test.gd -> FOCUS_CARD failures=0`, plus `form_cue_engine_test`, `gain_bubbles_test`, `gym_club_3d_test`,
`rooms_training_hud_test` still pass (as_game and plain). PR body: RESULT lines, the line windows edited. You cannot see images -
Claude takes the iso stills (card at the heavy bag, bubbles rising).

## Prior research
STATION_FOCUS_S266.md; FormCueBar (Ludo r87); gain bubbles (S231 GainBubbles, operator "gamedev tycoon bubbles"); HUD2 layout
(effort bar bottom centre, S266 42d5cc04); TWOPOINT_ALIGNMENT.md (iso camera, HUD slots).

## What would a human do?
Two Point / Game Dev Tycoon: click the station, a small card with its options, pick one, the worker carries on and the bubbles show
what grows.

## Prefab check
None - our own HUD widgets (FormCueBar, GainBubbles) are the base.

## The one trap
Do not change any gain/load numbers - the data path is Claude's (StationFocusTraining); you only show it and call set_focus.
New features ship ON (GAME_ON `station_focus` already); plain `--script` tests are the OFF arm.

## Contract
OWNS: Godot/scripts/ui/FocusCard.gd, Godot/scripts/GymClub3D.gd, Godot/scripts/GymHall3D.gd, Godot/tests/focus_card_test.gd
RED_TEST: Godot/tests/focus_card_test.gd -> FOCUS_CARD failures=0
REGRESSION: form_cue_engine_test, gain_bubbles_test, gym_club_3d_test, rooms_training_hud_test
VISUAL: yes

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
