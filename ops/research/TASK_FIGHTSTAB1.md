# TASK FIGHTSTAB1 - the gym floor's top bar has no way to Fights (Ziva S267 P11 / Round 3 item 4; boxing demo)

Model: Cursor (cloud). Discipline: BOXING (demo).
Source: `research/ZIVA_PLAYTEST_S267.md` P11 and Round 3 (line ~526): the week review says "Nothing booked yet - find a fight
in Fights." but on the gym floor (the game's main screen as_game) there is no Fights button. The old shell dock has one
(`scripts/ShellChrome.gd` BAR_ITEMS :22, `["calendar", "swords", "Fights"]`, hotkey F6), but the S268 floor HUD is ONE slim top
bar (`scripts/ui/GymTopBar.gd`, BUTTONS :19: PLAN / TRAINING / COACH / OFFICE / APPLICANT) and none of them reaches the fights
screen. A DEFECT a player saw (the game points at a screen the player cannot open).

## What to build
1. A RED test first, on master, as_game: `Godot/tests/floor_fights_button_test.gd` - new career on the gym floor (setup of
   `tests/self_run_day_test.gd`), find `GymTopBar`; assert a button with id "fights" (lucide "swords", label "FIGHTS",
   tooltip "Find and book fights - offers, events, your next bout (F6)") exists and is visible; emit its press and assert the
   route the shell opens for the dock's "calendar" entry is the one that opens (trace how GymTopBar `button_pressed(id)` is
   handled - grep `button_pressed` in GymHallPanel.gd / GymHall3D.gd - and how ShellChrome routes "calendar"; reuse that route,
   do not build a new screen). Also assert F6 on the floor opens the same route if the dock's NAV_FKEYS are live there.
   It must be RED on master - paste the FAIL line.
2. Add the button to `GymTopBar.BUTTONS` between TRAINING and COACH (Two Point standard: icons + modals; size/spacing as the
   others - `research/TWOPOINT_HUD_S268.md`), wire its press to the existing fights route. The week review's
   "find a fight in Fights" line stays true.

## Owned files
`Godot/scripts/ui/GymTopBar.gd`, `Godot/scripts/GymHallPanel.gd` (only the button_pressed handler), `Godot/tests/floor_fights_button_test.gd`.
GymHall3D.gd (5,370 lines) only if the handler lives there - `sed -n` windows, name the function in the PR body.
NOTE: Cursor task FASTGREY1 also owns GymHallPanel.gd (a different function) - touch ONLY the button handler.

## Parse gate and tests
`python Godot/tools/check_scripts.py <touched .gd>`; on the cloud:
`python Tools/cloud_test.py floor_fights_button_test,hud_v3_layout_test,floor_hud2_route_test,self_run_day_test --as-game` and the
same list plain (plain = switches-OFF control arm).
PR body: `RESULT: tests/floor_fights_button_test.gd -> FLOOR_FIGHTS_BUTTON failures=0` and the red line from master.
You cannot see images - Claude takes the stills on the game camera.

## Prior research
searched: fights tab club hud (nothing). TWOPOINT_HUD_S268.md (top bar sizes), memory HUD = top bar + modals (S268).

## What would a human do?
Click where the review tells him to go; if there is no such button on the main screen, add it next to the others.

## Prefab check
n/a (one button on our own bar).

## The one trap
Do not add a second fights screen - route to the one the dock already opens.

## Contract
OWNS: Godot/scripts/ui/GymTopBar.gd, Godot/tests/floor_fights_button_test.gd
RED_TEST: Godot/tests/floor_fights_button_test.gd -> FLOOR_FIGHTS_BUTTON failures=0
REGRESSION: hud_v3_layout_test
VISUAL: yes
