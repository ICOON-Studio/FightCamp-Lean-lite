# HOSTPROBE5 RESULT - club show map v8, greybox probe before any critic

S541, task `ops/research/TASK_HOSTPROBE5.md`. Map: `ops/research/DESIGN_HOSTSHOW1_V8.md` (v7 + every HOSTPROBE4 section 7 item).
Measurement only: nothing under `scripts/` changes. v8's rules are the flagged copy `tools/hostprobe5_rules.gd`; the runner is
`tools/hostprobe5.gd` (base: tools/hostprobe4.gd). Sections 1-3 were written and committed BEFORE the run; the bars are not
loosened afterwards.

## 1. Code check
As HOSTPROBE4 s1 (the road: Career.quick_start, FirstWeek.skip, Sim.sign / hire / step_day, Bouts accept / camp / weigh /
fight_step "sim" / after_fight; our points move in BoutFinish.gd:144, rivals' in Region.gd:175, the idle clock Region.gd:120;
rank = Region.our_rank, Region.gd:237; the built call = Roster.pro_ready, Roster.gd:186-196, lines PRO_WINS 7 / PRO_RANK 3 /
PRO_WINS_ANY_RANK 9, Roster.gd:34-36). v8 adds: (a) the opponent's ladder points and ours are read on the fight day BEFORE the bout
(c.rival(name) - the live rival, not the offer's copy), so the road can weigh each win; (b) the first bout is taken only from
day WAIT = (37 s + 11 b) mod 50 after signing (offers before it are declined), so each seed's calendar, rivals and fight-day
dice differ (HOSTPROBE4 s7 item 5: Tess was identical on all 24 seeds); (c) the favour stage is not re-run: it reads only built
rules and v7's use bot, both unchanged, on the same seed - HOSTPROBE4's figures stand for B1's earned / spent part.

## 2. Method (fixed before the run)
- **The road (B8 and the calibration):** the six signable people (Data.lucy + Data.PROSPECTS), seeds s = 0-23, seed
  7000 + 137 b + 1009 s, the WAIT above, a bot that takes every legal bout, up to 30 bouts or 156 weeks. After each bout:
  bouts, record, points, rank, the built call, and the opponent's points and ours before it.
- **v8's call (read off the same bouts, it changes no booking):** weighed wins = each win counts 1 when the opponent's points
  were above ours before the bout, else W_BELOW. Called at the first bout with (weighed wins >= 7 AND rank 1-3) OR weighed
  wins >= 9 (Roster's own lines).
- **Calibrating W_BELOW (procedure fixed here):** on the CALIBRATION seeds 0-7, W_BELOW = the LOWEST of {0.5, 0.6, 0.7, 0.8}
  for which B8 (below) passes for all six people. If none passes, W_BELOW = 0.5 (section 7's own number) and B8 is expected to
  fail. B8 is then judged on the TEST seeds 8-23 only. Set in tools/hostprobe5_rules.gd BEFORE the card stage.
- **Card cells (v8 adds the club):** HOSTPROBE4's cells (Lucy / Kira / Josh x WEAK / STRONG x AS-IS / PRO-CHASE x favours 0 / 1
  / 2) x the three clubs (young 40 members rep 10, mid 58 / 24, grown 120 / 60) = 108 cells, each on the hall its read names
  (v8's read). The PRO-CHASE boxer stands at 6 wins and 6.0 weighed wins (ONE COUNTED WIN from the call, as HOSTPROBE4's 6-win
  chase was one win from it); an as-is boxer counts every win (he is far from 7 either way). Each roll now plays THE NIGHT too
  (the read hall, one other home boxer at 5 wins, two reserves, this roll's luck and pull-outs; our bout is not pulled - the
  route decides whether it is on): the bout's following and posters move seats, cash and the full / half-empty reputation.
  Value $ = night cash + (bout rep + night rep) x $333 + members x $100 + pro offer x $333 a point + $450 a next bout + favours x
  $160. Seed 5390, 2,000 rolls a cell, common random numbers, the same bots (lazy: the name above as it is, below if no tile).
- **Hall (B2, B4) and rank (B6):** as HOSTPROBE4 (8,000 nights a hall option; 20,000 seeds a rank cell), with v8's posters
  (the hall's main event: Community 24, Town 48; the read and the hall stage assume the main event is booked).

## 3. Bars (written before the run; HOSTPROBE4's, not loosened)
- **B1 favours (owner Q-308):** earned 2-4 a year and the show's spend at most what is earned (HOSTPROBE4's stage, unchanged);
  "as it is" beats "with a favour" in at least 1 of 3 card cells where both exist.
- **B2 hall read:** the hall the read names is the measured best (net + rep x $333, two reserves, 8,000 nights) for each club,
  or within $300 of it.
- **B3 routes:** each of above as it is / with a favour / promise / below / wait is best in at least one card cell and in at
  most 50 in 100 of them.
- **B4 reserves default:** two reserves best, or within $50 of best, for every club x hall.
- **B6 rank number:** the printed "No. 3 or better" within 1 point of the measured result in every cell.
- **B8 the pro line on the road:** on the TEST seeds (8-23), in every person where the built rule calls (by bout 30) in at
  least half the careers, v8's median bout of the call is within 2 bouts of the built rule's, and v8's share called by bout 24
  is at least 0.8 of the built rule's.
- **B9 a reason to ask up:** in the pro-chase cells where both names exist, "above as it is" gives at least 3 in 100 more pro
  offer than "below" in at least half of them.
- **B7 cut rule (a list):** an option whose gain over the next best is under $150 AND under 1 rep AND under 3 in 100 pro offer
  in every cell it appears is CUT.
- **A1** no route is the one answer in more than 6 of 10 card cells.
- **A3** the best route beats the lazy bot by $1,000 in at least half the card cells.
PASS = B1, B2, B3, B4, B6, B8, B9, A1, A3 (9 bars). B3, B9, A1, A3 are counted over all 108 cells; each club's count is printed
beside it. B7 is a list.
