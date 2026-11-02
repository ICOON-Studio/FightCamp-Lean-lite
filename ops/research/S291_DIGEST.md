# S291 digest (2026-10-23) - quick start full, design focus approved (D48), the golden path plays end to end

## Operator words (verbatim)
- "make the quick start button to fill everything in the gym"
- "as a game designer for this game can you have your own proper presentation for the game , wehre do you think we should focus ?
  we lose too much time on the gymfloor and the result is still 0 , havent been able to play the game ?"
- Q-S289-1 (chat): "Yes - park gym building for the demo and make the fighter's path playable end to end first. Start with the
  game-arm golden path test from quick start." -> DECISION_LEDGER D48.
- Board answers read at start: Q-S277-10 "Hand-key it in Cascadeur instead" (bike clip); Q-S277-11 "Passes - go on to hero pieces"
  (hero pieces now PARKED by D48 - gym building).

## What now works (evidence)
1. 7cc64496 QUICK START = THE WHOLE GYM: every room to its piece cap, every shop kind (double-end bag added), and the catalogue room
   items (poster, clock, vending, cooler, bench, shower, pinboard, ice barrel) DRAW - before, a bought one stood in the data and drew
   nothing (GymClubLayout.CATALOG_ITEM_PIECES + ClubRoomBase._proc_piece). tests/quick_start_fills_all_test 30/30 game arm (red on
   master by tools/s291_quickstart_gap_probe.gd); still previews/s291_quickstart/quickstart_floor_far.jpg (on 8787/review).
2. 39b42957 DESIGN FOCUS deck https://claude.ai/artifact/7eNQCRoaEBswxzq18YyRKm + research/S291_DESIGN_FOCUS.md (research:
   Punch Club / Motorsport Manager reviews, Microsoft Research first-hour study, slice post-mortems). Approved -> D48.
3. GOLDEN PATH TEST tests/golden_path_test.gd (`-- as_game`): the title board's QUICK START through visible controls only -
   G1 built gym, G2 walk-in signs (interview, 3 cards), G3 goal on screen, G4 coach signs (OFFICE > Staff > HIRE A COACH),
   G5 a week runs at 3x (countdown and date follow), G6 WEEK button -> week review with gains, G7 WORLD > Schedule > FIND X A BOUT
   -> booked, G8 fight night calls itself -> fight week -> weigh-in -> BEGIN FIGHT -> SIM TO RESULT -> result, G9 the result says why
   and the next goal waits. passed=9/9 after four fixes it found:
   - the goal countdown used the WEEKDAY (0-6): a two-week goal restarted every Monday (GymHall3D._goal_day).
   - a rebuilt career top bar left the floor holding the freed one: date frozen at "Mon 5 Jan, Week 1", money label stale, and the
     floor's PLAN / WEEK / REPORT tray gone - the week review could not be opened (CareerRoot._rebuild_shell hands the new shell
     to the mounted screen; _resync_floor_shell rebuilds the tray, guarded to the screen still in the tree).
   - SIM TO RESULT stopped on a pending ringside doctor call and took the result mid-call: a 3-round bout "decided after 2 rounds".
     The corner now answers (FightRealtime.corner_answers_doctor, the unwatched-bout rule); the bout ran on to a TKO in R3.
   - FightWeekRail.auto_open hung a tree timer on a lambda capturing the rail; the soft day roll rebuilds the rail daily, so every
     booked-week day raised "Lambda capture at index 0 was freed" (7 engine errors per path run, red on c02c96ff too - bisected with
     tools/s291_lambda_bisect.gd) and never released the calendar hold. Weak reference; the hold is released either way.
   Runner: golden_path + goal + calendar_drawer + top-bar tests green both arms; timeline_bar_test / first_corner_test red as_game on
   the pre-session code too (gap 7).
   Not a defect: cash flat for weeks = wages billed MONTHLY (operator R8 2026-09-03 "i want payrolls and upkeep monthly").

## Golden path gaps found, not fixed yet (the next items, in order)
1. Camp skipped: booked 3 weeks out, nothing offers a camp/film study - fight week says "too late for a camp".
2. The week review says "find a fight in Fights" - no such place on the bar; the booking is WORLD > Schedule > FIND X A BOUT.
3. Progression is faint: a full week of training gave conditioning +0.3, power +0.1 (pillar 1, "feeling of progression").
4. Money: the first monthly bill took $18,140 -> $6,276; amateur bouts pay nothing -> broke in month two.
5. The next goal waits in an office talk after the fight; the floor shows no goal (the player must find the office).
6. Two bars report visible (the floor's hidden GymTopBar in the 3D HUD and the career TopBar) - tests must press by path.
7. Pre-existing as_game reds (red on c02c96ff too, every session-touched script swapped back): timeline_bar_test ("14 day
   cells", gold ribbon, FAST one day), first_corner_test (get_node on null), floor_week_bookkeeping_test (PLANNED 1/1, stats
   sum 0.0), week_review_test (seventh Continue, camp cash, P37 gain), camp_reaches_bout_test (camp_live OFF byte-identity),
   camp_pays_test (known). -> red-fix brief. The week-review ones overlap gap 3 (faint gains).
8. FIXED (gap 2): the review's "find a fight in Fights" -> "WORLD > Schedule finds a bout"; golden_path G6 fails on "in Fights".

## Decisions taken (developer calls)
- The golden path test walks visible controls only and presses the career TopBar by node path where the hidden floor bar carries the
  same words. It is long (~5 min, 3 weeks at 3x) - one runner slot; it is the D48 gate, run before any path change ships.
- Room items without a model on disk are built pieces at catalogue size (no MPFB/generator assets); Ludo hero pieces stay parked.
