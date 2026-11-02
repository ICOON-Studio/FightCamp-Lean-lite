# S167 DIGEST - GYM-CLICK1: the gym is the menu (cloud session, 2026-10-05)

## Request
Operator: "cloud session: build GYM-CLICK1 + tests only, leave the video, gbot and Arena for the PC." NAV1 slice 2 (D37, operator 'go').

## Change (a59cef63, behind career switch `gym_is_menu`, user arg `gym_is_menu`; OFF in the game until his OK on a video)
- `GameState.is_gym_is_menu_on()` beside `is_timeline_bar_on()`.
- `ShellChrome.build`: the rail is built but hidden (node kept - badges/tests read it).
- `DayFeedPanel` pins: every place opens its hub (`MENU_ROUTES`): Office desk -> SCHEDULE offers, Staff room -> STAFF,
  The ring -> TRAINING, Gym floor -> ROSTER & FLOOR, Front desk -> lobby, Lockers -> locker room; three new places with
  one live line each (`HomePinReads.door/ledger/board`, read off the same calls their panels use): Street door
  (canvas 330,745) -> SCOUTING fighters ("4 boxers outside you can sign"), The ledger (650,470) -> FINANCES
  ("$13,970 · -$1,813 a week", amber when next week's cash is negative), The board (1090,395) -> RANKINGS ("Silva #2 ·
  Welterweight").
- FIRST JOB box -> the coach on the floor (`CoachAtDoor`, canvas 392..812 x 512..644): a figure + speech plate + gold
  button; the place it points at (street door for "Sign your first boxer", staff room for "Hire a coach") wears the
  gold ring (NAV1 decide-first). The right column then starts with what is left.
- `CareerRoot`: a hub opened with the switch on stands on the HOME gym picture under a 0.55 wash (0.82 hid it); the
  timeline clock's 'panel' hold already keys on route != day_feed.

## Verification
- `gym_menu_test` 40/0. Populations: DevJump slot 8 seed 808 week 6 (Vargas LHW 40, Boone MW 38, Baptiste MW 44,
  Silva F WW 66 + 1 coach), the same gym emptied, one fighter no coach. OFF control arm: rail shows, pins open rooms,
  FIRST JOB box, no coach. ON: rail hidden; all 7 rail pages reachable from a place (route or same panel); 8 live
  lines; no plate overlaps another, the right column or the coach; door opens SCOUTING; hub over the gym; days do not
  move with a panel open (FAST); coach + one gold ring per first job; its button opens SCOUTING FIGHTERS.
- Red on the shipped behaviour: mutant `is_gym_is_menu_on() -> false` = 16 FAIL.
- Neighbours 18/18 green (`run_tests.py --only gym_menu,first_job,timeline,day_feed,home_pin,shell_back,ui_kit_shell,
  office_hub,scouting,staff_hub,tutorial,guide,story_card,new_career_player --jobs 3`).

## Not done / owed (PC)
- Not seen on the game camera (no window in the cloud): no stills, no video. A visual task closes only on the game's
  camera + the operator's OK.
- The 90 s first-ten-minutes video with `timeline_bar gym_is_menu`, under popup_probe; Arena STORY4A launch; NIGHTLY1C2
  chat; J62/M42 pastes - all carried from S166, left for the PC by the operator's instruction.
- Agent sweep: none this session - operator ruled the cloud session builds only ("leave gbot and Arena for the PC").

## Next (decision)
On the PC: agent sweep, then record the first ten minutes as_game with both switches on, open it, fix any clash, send it.

Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/gym_menu_test.gd`
