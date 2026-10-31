# S327 - next session (written S326, 2026-10-31)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 28 (injuries) is exported; update 29 part A is on main (e92b91d) but NOT exported: Light/Normal/
Hard/Rest per fighter on the Training page (act "trainload" - "load" is the load-a-save action), the load gauge (this week
vs her usual, green/amber/red), gains x setting (Rest 0.25 .. Hard 1.3), a camp starts Hard, Normal again after a fight.
Bouts.gd was split (fight night -> BoutNight.gd). Qwen ChampDraw collected. Digest: Game Godot/research/S326_DIGEST.md.

1. Board: Q-S294-45 (update 27) and Q-S294-46 (update 28) verdicts. Act on them first.
2. FIX THE LOAD MODEL FIRST (harness n=40, tools/career_harness.gd): careless 50 % injured, sensible 60 % - a rest week
   (3 h) drags the 4-week average down, so the Normal weeks after it read as a spike (ratio 1.38) and resting RAISES the
   risk. The plan says "a rest week brings the ratio down". Decide from evidence (Gabbett 2016 ACWR; the EWMA variant,
   Williams 2017; critiques of rolling averages) how "her usual" is counted - e.g. an EWMA chronic load, or rest weeks not
   pulling the chronic below a floor - write the why in the digest, change TrainingLoad.ratio / InjuryRoll.load_ratio
   consistently (their tests too), then rerun: bounds careless 50-80 %, sensible 10-35 %. The real training rate alone
   (1.3 % a 10 h week) gives ~29 % over 26 weeks; if sensible cannot get under 35 % with real rates, report the numbers and
   revise the bound in the plan with the reason - never bend the rates.
3. Collect Qwen BOUTBURN1 (branch qwen/boutburn1, wt E:/FightCamp/wt/LEAN_GYMBILLS1, out E:/FightCamp/wt/BOUTBURN1_out.txt)
   by diff + tests/bout_burn_test.gd; add it to tools/run_tests.sh.
4. UPDATE 29 part B: the body report on the result page - BoutBurn.per_round(m["rounds"], her stats, style) ->
   BodyReport.report(.., her first name) (line + "Next week: <focus>"), a button that sets f["focus"], and
   BodyReport.change_line vs f["last_body_report"]. BoutNight._finish (or the result page) is the place.
5. Export update 29 (sh tools/export.sh), WHAT_TO_TRY, a jump/still of the Training page load row + the body report,
   board question, Miro P0 + P5/P6 cards.
Later: update 30 the road to the nationals (SeasonPath + ChampDraw on main); John's pro-debut costs
(Game Godot/research/J_PRODEBUT1_JOHN.md: licence GBP 184, medicals ~GBP 700, opponent ~GBP 1,200 + 300 from her ticket
money, 100 tickets at GBP 40, break-even ~60, manager 15 %) feed the pro debut after it.

Traps: an action name in Main.act may already exist ("load" = load a save) - grep before naming one; run_tests.sh must list
every new test; any balance harness needs a population AND Career.seed per career; rule_guard blocks command text naming
the console exe (write briefs with the file tool).
