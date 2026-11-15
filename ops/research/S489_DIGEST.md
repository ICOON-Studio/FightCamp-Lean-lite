# S489 digest (2026-11-15)

## Shipped (all on main, pushed)
- Ladder v3 critics committed: Dola 7 depth / 7 design, John 7 / 7 (play 6). On his board as Q-247 with Kalli's v3 attached.
  Before code: close John's two holes ("Not this show" beats the other answers; an ask far down resets the clock free).
- APPROACHUI3: the Week review LOYALTY row. `Loyalty.week(f, from, to)` sums the week's moves by cause (biggest first),
  names a band crossed; `WeekReadRows.loyalty` draws it (bar Monday -> now; UP/DOWN/HELD; gold/red chip on a band crossed);
  no row on a quiet week. tests/loyalty_week_test.gd.
- FOURSTART1 (his Q-246): the TEST CLUB. `scripts/state/TestClub.gd` make(c): Lucy (W light walk-in), Kira (W feather),
  Josh (M welter) + Ana on the mat, Reid hired, past the guide, `Career.test_club = true`. Create screen: TEST CLUB switch
  under HOW THE CLUB STARTS (Main._start_career); TestJump `jump=club4`. Normal start unchanged (0 fighters).
  tests/test_club_test.gd (4 weeks play with all four; each review covers the three boxers); test_jump_test covers club4.
- STEPVALUE1 piece 3: the ROPES COUNT. `scripts/state/StepWire.gd` after(), called in RingDuel.settle right after
  where_next: planned steps move the count by StepEffect (step back +1, pivot/step out clear; cut off/herd -> opponent's
  count); at 3 the next exchange is on own_ropes / opp_ropes. Round dict keeps "ropes" (times put on the ropes) for the Why.
  No DENY/OPEN/DRAIN sizes enter the fight before the map's s9 probes. tests/step_ropes_test.gd.
- STEPVALUE1 learn card: each step tile on WHAT TO LEARN NEXT says StepValue.learn_line against the booked opponent's
  style, else the step's best style (grade OK). study_pick_walk_test checks it (and now runs in run_tests.sh).
- File limits: Main.gd 469, GamePlan.gd 499. LiveRound.gd is still 488 (> its 470 tight limit) -> LIVEROUNDSPLIT1.
- Export built (Builds/FightCamp.exe 16:04), WHAT_TO_TRY current.

## Tests run (all green unless said)
loyalty_week, loyalty, week_read, review_reveal, test_club, first_week, save_load, golden_path, start_slate, test_jump,
gym_bonus, step_ropes, plan_bout, plan_chain, perk_fight, exchanges, trust_fight, corner_jobs, plan_file, rib_damage,
ko_continues, study_pick_walk, learn_slots. file_limits: red only on LiveRound.gd (older).

## Not done / carried
- STYLE5 (Qwen, worktree LEAN_STYLE5) still running at the handover; it edits LiveRound.gd too: apply its diff.
- CLASH9 never started (Qwen took STYLE5 first). PR #313 (CLASH8) stays open, audited not-merge in S487.
- No Arena launch this session (context budget); no still of the approach screens yet.
- Two surplus Miro slot widgets (3458764690503256948/-949) left in place: deletion needs his OK.
