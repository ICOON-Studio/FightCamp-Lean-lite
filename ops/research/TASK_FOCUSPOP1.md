# TASK FOCUSPOP1 - station focus as a small icon pop-up beside the clicked station (no text rows)

Model: Cursor (cloud). Discipline: BOXING (demo).

## Why (operator S274, on the HEAVY BAG - FOCUS card at the bottom of the screen)
"this can be a small modal next to the clicked item and no need for text use an icon and tooltip what it does"
Operator design rule for the gym (S266, over Ludo): station focus approved; HUD rule S268: top bar + modals, icons, no flavour
text. Today Godot/scripts/ui/FocusCard.gd (281 lines, S267 FOCUSCARD1) shows 2-3 TEXT rows ("[1] POWER SHOTS + POWER - more
fatigue") as a strip at the bottom centre while he trains.

## What to build
1. A POP-UP beside the station the player clicks: when he clicks a station on the floor (the existing click path that sends
   the fighter there / opens its info - find it in GymHall3D.gd 5,4xx lines / GymClub3D.gd; `sed -n` windows), a small
   panel opens anchored to that station's screen position (unproject the station's 3D point with the active camera; keep it on
   screen; it must not cover the station itself or the top bar). It holds ONE icon button per focus of that station, in a row.
2. ICONS ONLY - no text on the buttons. Icons from IconKit.line_icon (Godot/scripts/IconKit.gd, Lucide set on disk in
   assets/icons/lucide, MIT/ISC - LICENSE-lucide.txt). Mapping (focus id -> icon; every name exists on disk):
   heavy_bag: power_shots=hand-fist, combinations=layers, bag_rounds=timer
   pads: hand_speed=zap, defence=shield, under_fire=flame
   speed_bag: rhythm=activity, endurance=hourglass
   double_end: guard=shield, slips=wind, counters=swords
   shadowbox: technique=target, footwork=footprints
   agility_ladder: quick_feet=fast-forward, long_sets=refresh-cw
   treadmill: steady=heart-pulse, intervals=trending-up, easy_spin=heart
   weights: strength=dumbbell, explosive=chevrons-up
   ring: technical=eye, hard=flame, situational=crosshair
   Put the map in ONE const table (e.g. FocusIcons.gd); a focus with no icon falls back to "target" and prints a warning.
3. TOOLTIP per button = what it does, built from the focus row in rules/StationFocus.gd FOCUS (name, gains, load): e.g.
   "POWER SHOTS - power ++, technique +, more fatigue" (load > 1.05 -> "more fatigue", < 0.95 -> "less fatigue"). Never invent
   numbers or prose; Godot's tooltip_text is fine (Two Point style: one short line).
4. The ACTIVE focus has the gold outline (COLOR_GOLD from FocusCard); keys 1-3 keep working while it is open; a click on an
   icon sets the focus through the SAME call FocusCard uses today (_on_row_pressed -> the floor's focus setter) and closes the
   pop-up; Esc / a click elsewhere closes it.
5. The bottom-centre text card is retired in the game path (switch: keep `FocusCard` code, show the pop-up instead when the new
   GAME_ON switch `focus_popup` is on - operator S221 rule: new features ship ON). While he trains, the station shows its current
   focus as a small icon badge next to its floor tag (no text), so the player still sees the choice without the card.

## Tests (plain --script = OFF control arm; run yours -- as_game)
- NEW Godot/tests/focus_popup_test.gd (red on master): clicking the heavy bag opens a pop-up with exactly 3 icon buttons, each
  with an empty text and a non-empty tooltip naming the focus; clicking COMBINATIONS sets the athlete's station_focus to
  combinations (the same field FocusCard sets) and closes it; the pop-up's rect does not overlap the station's projected point
  or the top bar; no Label with more than 3 words inside it.
- Regression: focus_card_test (if present), station_focus tests (grep tests for station_focus), day_plan_focus_test,
  floor_week_bookkeeping_test, plain + as_game.
- Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`.
PR body: `RESULT: tests/focus_popup_test.gd -> <pass line>`.

## Owned files
Godot/scripts/ui/FocusPopup.gd (new), Godot/scripts/ui/FocusIcons.gd (new), Godot/scripts/GymHall3D.gd / GymClub3D.gd (the
click hook + badge only), Godot/scripts/GameSwitches.gd (one GAME_ON key), Godot/tests/focus_popup_test.gd (new).

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
Stills on the club's game camera (tools/s274_gymday_stills.gd is a working template: seeded career, iso club camera): the
pop-up open beside the heavy bag, the tooltip shown on hover, and the floor with the badge after a choice. Claude opens every
still; the operator closes it.

## Prior research
STATION_FOCUS_S266.md (the approved design), TWOPOINT_HUD_S268 (top bar + modals), TWOPOINT_ALIGNMENT.md (operator S244: every
gym item follows Two Point), the S267 FocusCard brief.

## What would a human do?
Two Point Museum: click an exhibit, a small radial/row of icons pops next to it, hover shows one line, click and it closes.

## Prefab check
Lucide icons already in the project; Godot tooltips built in. Nothing to buy.

## The one trap
Never put the old text rows inside the pop-up - the operator asked for icons + tooltips; the words live only in the tooltip.

## Contract
OWNS: Godot/scripts/ui/FocusPopup.gd, Godot/scripts/ui/FocusIcons.gd, Godot/tests/focus_popup_test.gd
RED_TEST: Godot/tests/focus_popup_test.gd -> FOCUS_POPUP failures=0
REGRESSION: day_plan_focus_test
VISUAL: yes
