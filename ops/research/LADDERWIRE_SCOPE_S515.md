# LADDERWIRE - wiring the season ladder v6 into the game (S515 plan)

Owner's yes: Q-S294-270 "Yes, build it" (ladder v6, critics Dola 9/9, Goose 8/7). Map: ops/research/DESIGN_LADDER1_V6_DOLA.md
(rules R1-R10 lines 1047-1164, screen Part 2 lines 1165-1271). Pure rules: scripts/rules/LadderRep.gd (Goose #366, S515).

## Stage 1 - DONE S515
scripts/state/LadderPoints.gd: every amateur (ours, rivals) carries `rep` 0-100, seeded from the record (R10). Our bouts
(BoutFinish) and the region's rival bouts (Region._rival_bout) move both sides by LadderRep.change; the result page shows
LADDER POINTS +N, NOW M. tests/ladder_points_test.gd.

## Stage 2 - the table (World > Rankings, Fights > Who do we fight?)
- Region.rankings sorts by rep (R1), ranked from 4 wins kept (the dashed line under it). RISK: BoutRead.rank_move,
  RankLine, Matchmaking and rank_line_test / world_ladder_rules_test read net-wins order today - change Region.before to
  rep first, then net wins; run every test that names rank (grep rank_ in tests) before committing.
- The Ask card's rows (AskBout / AskFlow.answers): each opponent row gets its rep, the R2 reach (out of reach greyed:
  LadderRep.grey OUT OF REACH "Needs N more points"), the price line (LadderRep.price: points win/loss, members, standing,
  $450, morale) and "Leans Yes / Leans No - <biggest reason>" (LadderRep.yes_score; inputs from the rival: expected, idle
  weeks from RivalPast, last meeting from RivalPast, protecting = a bout within 4 weeks; temperament: a seeded word per
  rival club, learned after the first ask).
- A No: the ask is refused with the biggest reason; DUCKED / OWED (R6) as two flags on the rival.

## Stage 3 - the clock and the season
- LadderRep.clock on a free week (R8): -1 every 2 weeks after 8 free weeks; a bout 20+ below does not reset it.
- Season 1 Jan: rep carries over; the final table in Records.
- R9 offers from rival gyms: Accept / Not this show (once a season) / Pass (-2 to the challenger).

## Stage 4 - pro table (R10) stays with the pro ladder (ProLadder): mandatories and eliminators only there.

Each stage: wired, shown in the .exe, one golden-path walk (owner S425), and a probe that a season's table stays sane
(points spread 0-100, no boxer stuck at a cap, ranked top 3 turns over).
