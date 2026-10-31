# S329 - next session (written S328, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 30 is exported (Builds/, WHAT_TO_TRY.txt): the road to the National Amateur Championships.
scripts/state/Champs.gd wires SeasonPath + ChampDraw: England Boxing entry rules (5 bouts, 91 days with the club -
fighter key "joined", Elite 19-40, fit, amateur), entry window day 84-140 (Mon 30 Mar - Mon 25 May), the London regional
(her + 3 of the region, semi 8 Jun, final 15 Jun), the national draw of 8-12 regional champions (NationalField.gd, rating
62-73) on 13/14/20/21 Jul. Every round is a normal booked bout (bout["champ"] = stage): camp, weigh-in, corner, 3D, the
injury choice. No ticket cut and no draws at championships; byes pass on their day (Champs.day_events, last in
Sim.step_day); pull-out / head suspension / missed weight = withdrawal; result in f["titles"]; a national finalist gets the
pro call. HOME season line + amber "Enter Lucy for the nationals"; WORLD tab 4 Nationals (road, her road, the draw);
calendar dates. TestJump "nationals" + board button "Test: the road to the nationals (update 30)".
Digest: Game Godot/research/S328_DIGEST.md. Stills: Game Godot/research/S328_stills/.

1. Board Q-S294-47 (update 29 verdict) and Q-S294-48 (update 30 verdict). Act on them first.
2. UPDATE 31: the pro debut costs money - John's numbers (Game Godot/research/J_PRODEBUT1_JOHN.md: BBBofC licence +
   medical/MRI, the opponent's fee the boxer often pays, tickets to sell) into Roster.turn_pro / the debut booking, shown on
   the pro offer before he signs; if it needs rules, brief Qwen for a pure ProDebut module (owned files, one test command).
3. Export update 31 (sh tools/export.sh), WHAT_TO_TRY, stills on the hidden desktop, board question with --attach,
   review_add, Miro P0 + part cards (P6 Stakes / P7 Roster).

Traps: a scripted career that books bouts must start a camp (Lucy 62.6 kg vs 61.2 limit: no camp = missed weight every
bout); editing a test while run_tests.sh runs turns that test red - rerun it alone; Career.seed is randi() per career -
long-path tests fix c.seed; run_tests.sh must list every new test; board JSON files keep their indent (roadmap.json 1,
launch_targets.json 2).
