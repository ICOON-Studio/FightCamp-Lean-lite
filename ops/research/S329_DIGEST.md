# S329 digest - Lean update 31: the pro debut costs money + the Nationals page as pictures (2026-11-01)

## Board
- Q-S294-47 (update 29 verdict) and Q-S294-48 (update 30 verdict) had no answers at session start; both stay open.
- C150 (operator markup on S328 nationals_entered.png): mark 1, WRONG, the whole page - "can be improved". Read as: a
  page of rows; rebuilt as pictures (below). His verdict goes in the update 31 question.

## What now works (Lean main, exported as update 31)
- WORLD > Nationals as pictures (`scripts/ui/NationalsView.gd`, moved out of World.gd, 142 lines now):
  `SeasonRoad.gd` her season as a road (ready, entered, every round; green tick done, red cross out, gold ring next,
  dim ahead; date + opponent under each stop); `NeedRing.gd` the four entry needs as rings (bouts, weeks with the
  club, age, fit) with Enter under them; `Bracket.gd` the draw as a bracket (a box per bout, winner bright, loser dim,
  her name and path gold, champion column) - the national one once drawn, the London regional under it. After the
  nationals her finished road stays until next season's entries open (it jumped to next year's needs at once).
- Update 31, the pro debut (John J-PRODEBUT1, measured BBBofC 2025 + small-hall practice; game money GBP x 1.25):
  `scripts/rules/ProDebut.gd` (Qwen PRODEBUT1, pure) - licence $230, first-licence medicals $875, trainer licence $140;
  100 tickets at $50; break-even 60; her half past it; the gym keeps 25 % (manager 15 + trainer 10).
  Tickets sold = family 20 + members/2 + 2 per amateur win + 10 per title (London/national champion), max 100.
- `Roster.turn_pro` pays the licence + scans (+ the coach's trainer licence, kept on `c.coach.pro_licence` so a new
  coach needs one) and books the debut with `tickets: true`; `BoutNight._finish` pays the gym its share of her ticket
  half on the debut (computed from the members before the result) and adds the news line; the flat purse ($1,500, +$500
  a win, top $3,000) starts from her second pro bout. `Roster.GYM_SHARE` is now 0.25 (was 0.35: K-PROLINE1's 25 %
  manager cut had no source).
- Pro offer modal: the debut card with `TicketBar.gd` (100 cells coloured by who buys - family, members, her wins,
  titles - line at 60), her half, the gym's 25 %; THE GYM PAYS NOW card; WHAT ENDS; the purse after the debut.
- Result ribbon: debut shows "N SOLD - DEBUT TICKETS" and the gym's share. Defect fixed: a championship bout's ribbon
  said "+$450 CLUB TICKET CUT" though nothing is paid (BoutNight sets `club_cut`).
- TestJump `pro` (9-1 at the line -> the offer open); board button "Test: the pro offer and her debut (update 31)",
  task "FightCamp Play test pro".

## Decisions (developer)
- The gym, as her manager, fronts the licence and scans: she is on a $250 stipend that stops when she signs; real
  small-hall managers often do. It is the bite the operator asked for ("money that bites", S324).
- Tickets come from the gym's members and her record, so growing the club pays at the debut - the gym and the fighter
  feed each other. No separate "sell tickets" week activity yet (scope); members are the lever.
- Real numbers mean a quick-start debut is near break-even (53-62 sold: $0-$13 to the gym against $1,245 paid). That
  is John's finding (net about -GBP 1,200 to +GBP 900 in the first year). The question asks the operator whether it
  feels right.
- The Nationals page split into three small drawing controls (each under 120 lines) so the 500-line rule holds.

## Evidence
- tests/pro_debut_test.gd (Qwen, 11 tests): PRO_DEBUT failures=0; regression SEASON_PATH failures=0.
- tests/golden_path_test.gd: the offer shows Tickets + PaysNow; signing pays exactly sheet.costs (>= licence + scans);
  she and the trainer are licensed; the debut ledger has "Debut tickets" = ProDebut.night(...).gym ($63 in the run);
  no "Purse share" on the debut. tests/test_jump_test.gd: jump=pro opens the offer, turnpro pays and books a ticket debut.
- Full Lean suite 52/52 (export.sh reruns it); stills in S329_stills/ opened and checked: nationals_road,
  nationals_entered, national_draw, national_champion (the whole national bracket, road all green), pro_offer,
  debut_result (62 sold, +$13), money_after_debut.

## Next
- Board verdicts Q-S294-47/48 and the update 31 question; then the next Lean step from roadmap `now`.
