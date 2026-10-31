# S326 - next session (written S325, 2026-10-31)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 28 exported (all 48 suite tests green): injuries and suspensions (scripts/state/Injuries.gd over
Qwen's InjuryRoll) - bout roll from the settled damage, England Boxing stoppage suspensions, weekly training roll, no offers
while out, pull-out of a booked bout ($300), shown on the fighter page / roster / result ribbon; Career.seed (careers used to
roll the same dice); board button "Test: an injury pulls her out". Harness n=40: careless injured 45 %, sensible 43 %.
Digest: Game Godot/research/S325_DIGEST.md.

1. Board: Q-S294-45 (update 27 verdict) and Q-S294-46 (update 28 verdict). Act on them first.
2. Split Bouts.gd (500 lines, the cap): offers/booking/camp/weigh-in in one file, fight night (fight_step, _open, _shout,
   _counts, _lines, _energy, _finish) in another; golden_path + bout_stoppage + injuries + test_jump tests stay green.
3. UPDATE 29: Light/Normal/Hard/Rest per fighter on the Training page (TrainingLoad.cycle; f["load_setting"], default
   TrainingLoad.default_for(in_camp)); Injuries.setting reads it (today: camp protocol 3 = hard); daily gains x
   TrainingLoad.gain; the load gauge (gauge_line + band colour) on Training and her body figure. Post-fight body report:
   BodyReport.report(per-round part burn, her first name) on the result page + "Train <focus> next week" (sets f["focus"]);
   BodyReport.change_line vs f["last_body_report"]. The per-round burn must come from the fight model (BodyLoad/BodyTrack)
   so watched and unwatched bouts read the same. Harness: careless always Hard, sensible Rest the week after a bout; bounds
   careless injured 50-80 %, sensible 10-35 % (if the real rates cannot meet them, report the numbers, do not bend rates).
4. Collect Qwen CHAMPDRAW1 (branch qwen/champdraw1, wt E:/FightCamp/wt/LEAN_GYMBILLS1, out E:/FightCamp/wt/CHAMPDRAW1_out.txt)
   by diff + tests/champ_draw_test.gd; add it to tools/run_tests.sh. Brief Qwen the next pure piece for update 30/31.
5. John J-PRODEBUT1 (seat queue SQ24) lands in Game Godot/research/J_PRODEBUT1_JOHN.md - the pro debut's costs.
6. At wrap-up: P0 is current to update 28 (S325: card text + scores Gym and money 5, Stakes 4, Body and training 5); the
   P5 and P6 frames' cards for updates 27-29 still need moving (skipped S324 and S325), export, WHAT_TO_TRY, board
   question; new tests go into tools/run_tests.sh (S325 found 7 missing).

Traps: running Builds/FightCamp.exe from the Lean folder runs the project, not the pck; board_reconcile calls Lean Qwen runs
"dead" - read the out file; any balance harness plays a population AND each career needs its own Career.seed; rule_guard blocks
any command whose text contains the console exe's name (write briefs with the file tool).
