# S328 - next session (written S327, 2026-10-31)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 29 is exported (Builds/, WHAT_TO_TRY.txt). From his board answers (Q-S294-45 "Money too harsh",
Q-S294-46 "option on player if he pulls out ... how serious, how many weeks"): the gym closes after 8 weeks below $0, a loss
costs 1-2 members, a waiting sponsor is a HOME need; an injury past a booked bout asks pull out ($300) or fight hurt (10-20
off her tank, heals 50 % slower after), every injury line says minor/moderate/serious + "fit on <date>" (head knocks and
stoppage suspensions are never a choice). Her usual load is an EWMA with a 42-day fitness span (f["chronic"]); a camp steps
up only as far as stays safe (Hard camp trains Hard). Qwen BoutBurn collected; the result page shows the body report + a
"Train <focus> next week" button, and colours her figure from the report when the bout was not watched in 3D.
Digest: Game Godot/research/S327_DIGEST.md. Stills: Game Godot/research/S327_stills/.

1. Board Q-S294-47 (update 29 verdict). Act on it first.
2. UPDATE 30: the road to the National Championships - SeasonPath + ChampDraw (both on main, pure + tested) wired into the
   game: the season goal on HOME, the qualifying events on the calendar, the draw on the World page, her path round by round.
   Read both modules and the make-it-a-game plan section for update 30 first; brief Qwen/Kalli/John for any missing piece
   (numbers -> John, words -> Kalli, pure module -> Qwen) before building.
3. Export update 30 (sh tools/export.sh), WHAT_TO_TRY, stills (a tools/*_still.gd on the hidden desktop), board question
   with --attach, review_add, Miro P0 + part cards.
Later: John's pro-debut costs (Game Godot/research/J_PRODEBUT1_JOHN.md) feed the pro debut after update 30.

Harness bounds now (tools/career_harness.gd header): careless closes 5-25 %, sensible 0 %; injured careless 50-80 %,
sensible 30-50 % (real rates alone give ~43 %). Last run n=40: 15 % / 0 %; 53 % / 48 %.

Traps: Career.seed is randi() per career - any test that plays a long path fixes c.seed (golden path uses 1); an action
name in Main.act may already exist (grep first); run_tests.sh must list every new test; any balance harness needs a
population AND Career.seed per career; the 3D body track exists but is all zeros after a skipped bout (check the sum, not
is_empty); rule_guard blocks command text naming the console exe (write briefs with the file tool); board JSON files keep
their own indent (roadmap.json indent 1) - rewrite them in their original format.
