# Next session: S309 (written S308, 2026-10-30, after update 9: 3:00 rounds, a shout every 30 s, clues)

## Start
1. `cd /e/FightCamp/Game && git pull && python Tools/agent_comms.py start`, then work in `E:\FightCamp\Lean` (`git pull`).
2. Board: Q-S294-15 (his verdict on update 9: do the calls change the fight?) and his review comments on the S308 stills.
   Quote each. The plan he approved is on Miro frames 6-11 (https://miro.com/app/board/uXjVEV03QWA=/) and in
   `E:\FightCamp\Game\Godot\research\S308_FIGHT_TACTICS_PLAN.md`.
3. Then by his word. Open pieces of the plan: the corner minute's "one fix for a habit" (not built); clue difficulty
   (the "(coach)" mark gives the answer away - consider showing it only with film study); shout bar time (8 s).
   Standing answer: Q-S294-10 "Keep polishing the fight first".

## Where it stands (Lean 1e628ce)
- scripts/rules/Exchanges.gd: the rules. EXCHANGES 6 x EX_SECONDS 30, EX_SPREAD 66 (a round's mean margin spreads like
  the old ROUND_SPREAD 27), MODES (6 opponent games + she_tired / she_hurt, each best/ok/wrong), CALLS (8; long/body/calm
  keep their old ids), EDGE best 15 / ok 5 / wrong -7, grade (Good/OK/Poor from the stats a call needs), uptake
  (coachability; shouts past FULL_SHOUTS 2 at half), next_mode (style weights, scout's weakness, KEEP 0.6), read() (the
  corner's advice from the last three exchanges).
- scripts/state/LiveRound.gd: m["live"] = the open round; open / exchange(shout) / preview (clue: next game with film
  depth 3, else the last one) / close / finish. Bouts.fight_step: "start", "corner:<call>" open a round and fight its first
  30 s on the plan; "shout:<call>" ("shout:" = say nothing); "round_out"; "sim"/"rest"/"end" as before.
- 3D: FightView plays exchange by exchange (ExchangeBeats.build per 30 s, _show_game makes the opponent's game visible),
  ShoutBar at each 30 s (ring at 0.3 speed, 8 real seconds), FightHud (scorebug/caption/banner), CallButtons (shout row,
  8-call corner grid; also in the words screen FightNight._live).
- tools/exchange_balance.gd: win share by edge and corner policy (none / seen / seen2 / oracle / wrong). Even: 0.60 / 0.70 /
  0.69 / 0.77 / 0.31. tests/exchanges_test.gd bounds it. tools/fight3d_play.gd checks the 3D flow (2x).

## Traps
- A node skipped from a button (FightIntro / CornerMinute finish) stays in the tree to the frame's end: set_process(false)
  in finish, or its _process films again (round 1 was stuck on the intro's wide lens).
- FightView.gd 497 lines: new fight code goes in ExchangeBeats / ShoutBar / FightHud / FightCast.
- His FightCamp.exe is usually open: the .exe copy in tools/export.sh fails, the .pck lands.

## Wrap-up duties
CLAUDE.md "Wrap-up": tests + export, ops board roadmap, rewrite this file, memorize the session, ask before handing over.
