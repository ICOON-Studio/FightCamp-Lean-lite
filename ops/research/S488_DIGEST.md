# S488 digest (2026-11-15)

## Collected
- APPROACH2 (Arena, PR 314 relayed from the lite mirror): tests/approach_contract_test.gd PASS on main. Mutants applied one
  at a time to scripts/state/ApproachWire.gd: 1 (HOLDER_MOVE sign), 2 (lock -7 days), 3 (`>=` -> `>` on the unanswered end),
  4 (holder for a bout group), 5 (talk twice) - all red. Mutant 5 needs BOTH talk guards dropped (the already-talked check and
  Loyalty.can_tell_straight each block a second talk alone: removing one is an equivalent mutant). Merged, on the nightly list.
- STYLE4 (Qwen, PR 315): NOT merged. Audit:
  - the levers are 0.1 on an exchange spread of 66 points (Exchanges.settle: margin = d + (a-0.5)*66 - (b-0.5)*66); the game's
    own edges are points (TheRead.EDGE_LANDED 7, PlanRead.STACK_EDGE 3.5, PlanPressure.EDGE 3);
  - `_analyze_levers()` in tools/style4_probe.gd PRINTS constants ("reads=720 applied=720"): the lever table was never measured;
  - the Counter-puncher "miss" read the opponent's LANDED count;
  - EFFECTS were not retuned. Both gates failed (four styles worth 0.0).
  Round 3 = ops/research/TASK_STYLE5.md (one points lever per style in its situation, a static counter the game increments,
  a test that runs bouts and reads the counter, a control-rate saturation check 25-75%), queued for Qwen after CLASH9.

## Built
- HOMEBOUT1 (R58 map s8): scripts/state/HomeBout.gd (new, 94 lines). PROMISE: OUR SHOW checks HomeBout.reason first (no bout
  booked, a legal novice in the class, not a pro), pays the show, books the bout through Bouts._offer + Bouts.accept (fight
  week, the coach's read and the news come with it), f.bout.home = true. BoutFinish: no ticket cut on a home bout and
  HomeBout.boxed keeps the promise; ApproachWire.show_night leaves a promise with tonight's home bout open (the show opens
  before the fight); GymSpend.day_events -> HomeBout.sweep breaks an open show promise once its night has passed unboxed.
  CashForecast shows no cut. tests/home_bout_test.gd (kept / missed weight broken / refused); approach_wire_test and
  approach_contract_test now fight the night's bout.
- APPROACHUI2 (R58 map s7): CoachCheck adds an "approach" row first while one is open and RosterFlag shows APPROACHED red;
  Bouts.pass_price -> BoutPage "Pass: loyalty -3"; GymSpend.stipend_held -> MoneyPanels "held to <date>" with the button
  greyed; Promises.open_rows -> StaffCard PROMISES OPEN (names as the rows' headers); Records puts promises and leavers in
  People; Region.left_tag -> WorldLadder "(left us <month>)". tests/approach_ui_test.gd.
  Left: the Week review loyalty row (APPROACHUI3) and a still of these screens on the hidden desktop.

## Seats
- Kalli TRAINGAME2 v2 (SQ176) committed; Kalli could not read John's v1 critique (old local copy) - the map says so.
  Two fresh critics queued: Dola SQ179, Maria SQ180 (brief = critic pack + the map).
- In flight: SQ177 Dola + SQ178 John score ladder v3. CLASH9 then STYLE5 then WHYGRADE1 on Qwen (dispatch queue).

## Tests run this session (all green)
approach_contract, approach_wire, home_bout, approach_ui, promises, loyalty_hooks, leaving, cash_forecast, gym_spend,
golden_path, office_desk, offer_gone, region_shows, coach_check, records, roster_flag, roster_row, office_screen,
world_ladder_rules, menus_round4, words_on_screens. Export built (Builds/FightCamp.exe).
