# S325 - next session (written S324, 2026-10-31)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 27 exported (all tests green): the body view is her own body coloured part by part (C149 fixed:
no capsules, 40% bigger, fresh = her own skin) and money bites (GymBills: $35/month dues, $1,800 rent, start $14,600,
LOW CASH / BELOW $0 flags, the gym closes after 4 weeks below $0, losses cost members). Career harness
(tools/career_harness.gd): careless closes 23 %, sensible 0 %. Digest: Game Godot/research/S324_DIGEST.md.

1. Board: Q-S294-45 (update 27 verdict). Act on it first.
2. UPDATE 28 injuries. InjuryRoll is on main (scripts/rules/InjuryRoll.gd). Wire: bout_roll after each bout from the bout's
   BodyMap worst places + rounds (head_stoppage on a stoppage loss, the fighter's ko_history), training_roll each week
   (TrainingLoad.hours/ratio; until update 29 every week is "normal", camp weeks "hard"); fighter.injury {type, days_out,
   until_day}; the fighter page shows InjuryRoll.line (it prints "Injuries: None" always today); booking refuses an injured or
   suspended fighter, an injury inside a booked bout pulls her out (empty-slot fee); news. Rerun the harness with injury
   counts: careless 50-80 % of careers see an injury, sensible 10-35 %.
3. Collect Qwen BODYREPORT1 (running: branch qwen/bodyreport1, wt E:/FightCamp/wt/LEAN_GYMBILLS1, out
   E:/FightCamp/wt/BODYREPORT1_out.txt) by diff + tests/body_report_test.gd. Then brief the next pure module to Qwen
   (update 30: the road to the National Championships - entry rules, regional bouts).
4. At wrap-up: move the Miro P0/P5/P6 cards for updates 27 AND 28 (S324 skipped it on the context budget), export,
   WHAT_TO_TRY, board question.

Traps: running Builds/FightCamp.exe from the Lean folder runs the project, not the pck; board_reconcile calls Lean Qwen runs
"dead" - read the out file; a deterministic game needs a population of players in any balance harness.
