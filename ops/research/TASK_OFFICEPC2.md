# TASK OFFICEPC2 (rev 1 S241: BoutRows replaced by FightBoard from TASK_FIGHTBOARD1) - click the office desk -> the office PC opens; book a bout there; the floor FIND A FIGHT button goes (S241)

Seat: cloud Cursor (Godot UI/gameplay). Branch `cursor/issue-<n>`, Claude merges by diff. Model: Cursor default.
Discipline: BOXING (the demo).

## Why (operator, board Q-S239-1 + S240, verbatim)
"instead of the find fight button add for now the office with a desk a pc on it click the pc and have options [...] Tournaments (book a
fight here)"; Q-S239-1: "Add all the rooms we have rdy so their opjects )desk PC in Office) can be accessed with unzooming gym floor a bit
and and clicking it." Lead designer Ludo r106/r108 agreed: two tabs, BOUT CONTRACTS + FINANCES.

## What is already on master (S241, read these - do not rebuild them)
- `GymClub3D.thing_at` (Godot/scripts/GymClub3D.gd ~1462): with switch `iso_camera` ON, the office desk returns
  `{"kind": "room_prop", "route": "office_pc"}`; the left-click handler (~1640) emits `room_route_requested("office_pc", args)`.
- `GymHallPanel.gd` line 126 connects `room_route_requested` to `_push_route` (line 1102), which pushes to SceneRouter - "office_pc"
  is NOT a SceneRouter route, so today the click does nothing.
- `scripts/ui/OfficePcScreen.gd` (PCHUB1): `open(tab)`, `close()`, `show_bouts(rows)`, `show_finances(ledger)`, `set_gym_name(name)`,
  `set_fighter_name(name)`, signals `closed`, `book_requested(offer_id)`. Test: tests/office_pc_screen_test.gd.
- `scripts/ui/FindFightPanel.gd` row contract: `{offer_id, name, record_text, rating, style_word, stance, scout_line, purse, fight_day,
  days_out, fits_goal, tag}` (TASK_FINDFIGHT1.md line 13).
- `scripts/rules/FinanceLedger.gd` (FINLEDGER1): `FinanceLedger.ledger(career) -> {cash, weekly_costs, recent_income, net_weekly}`.
- `scripts/ui/FightCountdownPill.gd`: `show_bout(name, days_left)`, `clear()` - not mounted anywhere yet.
- Offers: `GameState.get_fight_offers()` (GameState.gd 8886; keys id, opponent_name, opponent_rating, opponent_record {wins,losses,draws},
  weight_class, purse, scheduled_week/weeks_out...). Booking: `GameState.book_fight(athlete_id, offer_id)` (GameState.gd 14802) - the ONE
  booking path (strike, hold, weight checks inside). The calendar does it at ScheduleHubPanel.gd 2656. Opponent style/stance:
  `FightOpponentGenerator.gd` turns an offer into a full opponent (deterministic per offer) - use it, never invent a style.
- The floor FIND A FIGHT button: `ui/HudV3Widgets.gd` line 46 (`FindFight`), wired in `ShellChrome.gd` 885-887 to the calendar offers.
- Fighter goal for `fits_goal`: `scripts/rules/FighterGoal.gd` (the athlete's `goal` dict; a bout fits if the goal is a debut / a fight
  goal - read the archetype ids there and say in the PR which ids count).

## Do
1. The bout list rules = `Godot/scripts/rules/FightBoard.gd` + `Godot/tests/fight_board_test.gd`, built EXACTLY as
   `research/TASK_FIGHTBOARD1.md` specifies (style_of, rows, the film tell - every function and check there). That brief was
   Arena's (S239) and stalled with no branch; it is yours now, inside this task. Then map `FightBoard.rows(...)` to the FindFightPanel
   row contract above in GymHallPanel (or a tiny helper in FightBoard if the keys differ) - never a second rows module.
2. `GymHallPanel.gd`: in `_push_route`, route "office_pc" opens a lazily built OfficePcScreen over the hall (top layer, full 1920x1080),
   `set_gym_name(<career gym name>)`, `set_fighter_name(<selected athlete name>)`, `show_bouts(<FightBoard.rows mapped to the row contract>)`,
   `show_finances(FinanceLedger.ledger(career))`, `open("bouts")`; the day clock pauses while it is open (as the other floor drawers do -
   find how SkipDayDrawer pauses it, GymHallPanel.gd ~60) and resumes on `closed`.
   `book_requested(offer_id)` -> `GameState.book_fight(athlete_id, offer_id)`; ok -> close the screen, mount/refresh a FightCountdownPill
   on the floor HUD (`show_bout(opponent, days_left)`); not ok -> show the returned `reason` inside the PC (a status line, never a print).
   After a booking the pill stays on every later floor day until the bout (read the athlete's `booked_fight`).
3. Drop the floor FIND A FIGHT button when `iso_camera` is ON (HudV3Widgets / ShellChrome): the PC is the way to book from the gym.
   The calendar's own offers tab stays (playable_loop_test books through Nav_calendar - do not break it).
4. Everything ships ON (GameSwitches GAME_ON `iso_camera` already ON); plain `--script` tests stay the OFF arm.

## Tests (red on master first - paste the red line in the PR body)
- `Godot/tests/fight_board_test.gd` exactly as TASK_FIGHTBOARD1.md says (prints `FIGHT_BOARD failures=N`).
- New `Godot/tests/office_pc_wiring_test.gd` (SceneTree, `career["iso_camera"]=true`, GymHallPanel with a career as
  tests/playable_loop_test.gd builds one): emit the hall's `room_route_requested("office_pc", {})` -> an OfficePcScreen is visible with
  >= 1 bout row of the fighter's class; press the first row's ACCEPT then SIGN & LOCK BOUT -> `book_fight` booked it (athlete
  `booked_fight` non-empty), the screen closed, a FightCountdownPill is visible; the floor `FindFight` button is absent with iso ON and
  present with iso OFF. Prints `OFFICE_PC_WIRING failures=N`.
- Then `python Godot/tools/run_tests.py --only office_pc,find_fight,playable_loop,gym_hall --jobs 2`: no NEW reds vs master.
- PR body: `RESULT: tests/fight_board_test.gd -> FIGHT_BOARD failures=0` and `RESULT: tests/office_pc_wiring_test.gd -> OFFICE_PC_WIRING failures=0`.
Command: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd`. Parse gate first:
`python Godot/tools/check_scripts.py <touched .gd>`.

## Rules
GDSCRIPT_TRAPS.md. GameState.gd (huge) and GymClub3D.gd - grep + read windows, never whole; do not edit GameState.gd. GymHallPanel.gd is
1,320 lines - read windows. Never delete or weaken a test.
THE ONE TRAP: a confirm/header line that names a fixed boxer or gym ("DANNY REYES", "ANVIL STREET GYM" are test fixtures only) - every
name on screen comes from the career.

## Prior research
TASK_FINDFIGHT1.md (row contract, pill), TASK_PCHUB1.md, TASK_ISOCAM1.md, research/ludo_rx/LUDO_R106_raw.txt + LUDO_R108_raw.txt,
J4_THE_DESK_AND_THE_CUT.md (the desk the player sits at; book_fight is the one write).

## What would a human do?
Football Manager / Two Point: click the office computer, the inbox opens with offers, accept one, the date appears on the HUD.

## Prefab check
None needed - every screen and rule exists; this is wiring.
