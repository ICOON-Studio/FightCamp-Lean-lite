# HOSTPROBE4 RESULT - club show map v7, greybox probe before any critic

S540, task `ops/research/TASK_HOSTPROBE4.md`. Map: `ops/research/DESIGN_HOSTSHOW1_V7.md` (v6 + every HOSTPROBE3 section 7 item).
Measurement only: nothing under `scripts/` changes. v7's rules are the flagged copy `tools/hostprobe4_rules.gd`; the runner is
`tools/hostprobe4.gd` (base: tools/hostprobe3.gd; the road stage is tools/turnprobe15.gd's _build road). Sections 1-3 were
written and committed BEFORE the run; the bars are not loosened afterwards.

## 1. Code check
As HOSTPROBE3 s1 (the map's CODE claims carry file:line, read 2026-11-23), plus what v7 adds:
(a) the road: the game's own careers - Career.quick_start, FirstWeek.skip, Sim.sign / hire / step_day, Bouts accept / camp /
weigh / fight_step "sim" / after_fight (as tools/turnprobe15.gd _build/_day); our ladder points move in BoutFinish.gd:144
(LadderPoints.settle), rivals' in Region.gd:175, the idle clock in Region.gd:120; rank = Region.our_rank (Region.gd:237);
the built call = Roster.pro_ready (Roster.gd:186-196) with that rank. (b) The pro offer is cleared each day (as
tools/turnprobe15.gd _calls) so the road runs on past the built call: no decline is recorded.
(c) The mood question (task step 4) is answered in s6 from the code.

## 2. Method (fixed before the run)
- **Card, hall, rank, favours stages:** HOSTPROBE3 s2 unchanged (the TEST CLUB, WEAK / STRONG x AS-IS / PRO-CHASE, favours
  0 / 1 / 2, clubs young / mid / grown, common random numbers, seed 5390, 2,000 rolls a card cell, the same exchange:
  $1,000 = 3 rep = 3 in 100 pro offer; a seat $30; a member $100; a favour $160; a next bout $450).
- **v7's changes in the card:** the favour's yes +2 in 10 (was +3); a no from the name above lands after the posters 1 in 2
  (LATE_NO): then the name below says yes 7 in 10 (not 9) and our bout is not on the posters; a home boxer v the name below
  booked in time is on the posters (+12 seats, POSTERS_BELOW); the main event (the name above) keeps +24 and +-3 rep; wait
  stays off the posters (as v6). Lazy bot: the name above as it is (below if no tile).
- **The hall read:** five lucks across ClubShow.LUCK x every pull-out pattern weighted by its chance, two reserves.
- **The road (B8 and the calibration):** the six people the game can sign (Data.lucy + Data.PROSPECTS) from signing on the
  game's own clock, a bot that takes every legal bout, up to 30 bouts or 156 weeks, seed 7000 + 137 x person + 1009 x s.
  **Calibration seeds s = 0-7, test seeds s = 8-23.** After each bout: bouts, record, ladder points, rank, the built call.
  **The lines (procedure fixed here):** PRO_PTS = the median ladder points at the built call (the first bout after which
  Roster.pro_ready holds) over every calibration career that reaches it; PRO_PTS_ANY = the 75th percentile of the same
  points. Rounded to whole points. v7 calls at the first bout with (rank 1-3 AND points >= PRO_PTS) OR points >= PRO_PTS_ANY.
  Both rules are read off the same careers (the rule changes no booking; the call is never taken).

## 3. Bars (written before the run)
HOSTPROBE3's bars, not loosened; B8 now on the road (the task: boxers who grow, newcomers; not the closed pool).
- **B1 favours (owner Q-308):** earned 2-4 a year; the show's spend (use bot) at most what is earned; "as it is" beats "with
  a favour" in at least 1 of 3 card cells where both exist.
- **B2 hall read:** the hall the read names is the measured best (net cash + reputation x $333, two reserves, 8,000 nights)
  for each of the three clubs, or, where not, within $300 of it.
- **B3 routes:** each of above as it is / with a favour / promise / below / wait is best in at least one card cell and in at
  most 50% of them.
- **B4 reserves default:** two reserves best, or within $50 of best, for every club x hall.
- **B6 rank number:** the printed "No. 3 or better" within 1 point of the measured result in every cell.
- **B8 the pro line on the road:** on the TEST seeds, in every person where the built rule calls (by bout 30) in at least
  half the careers, v7's median bout of the call is within 2 bouts of the built rule's, and v7's share called by bout 24 is
  at least 0.8 of the built rule's.
- **B9 a reason to ask up:** in the pro-chase card cells where both names exist, "above as it is" gives at least 3 in 100
  more pro offer than "below" in at least half of them.
- **B7 cut rule (a list):** an option whose gain over the next best is under $150 AND under 1 rep AND under 3 in 100 pro
  offer in every cell it appears is CUT.
- **A1** no route is the one answer in more than 6 of 10 card cells.
- **A3** the best route beats the lazy bot by $1,000 in at least half the card cells.
PASS = B1, B2, B3, B4, B6, B8, B9, A1, A3 all pass (9 bars). B7 is a list.
