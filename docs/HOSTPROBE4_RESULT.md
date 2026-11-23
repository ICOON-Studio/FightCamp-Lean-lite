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

## 4. Run
1. `stage=road seeds=24` (S540, ~70 min with RED waits; 144 careers = 6 people x 24 seeds, 0 script errors) -> E:/FightCamp/tmp/hostprobe4/road.jsonl.
2. The calibration (s2's procedure, seeds 0-7, 48 careers, every one reached the built call): median points at the call **34**,
   75th percentile **40** (25th: 32). Set as PRO_PTS 34 / PRO_PTS_ANY 40 in tools/hostprobe4_rules.gd BEFORE stage 3.
3. `stage=all rolls=2000` (238 s, seed 5390, 0 script errors) -> E:/FightCamp/tmp/hostprobe4/run2000.jsonl. Same counts as
   HOSTPROBE3: 2,000 rolls a card cell, 8,000 nights a hall option, 20,000 seeds a rank cell, 2,000 seasons a favour arm.
Command: `python ops/Tools/godot_slot.py run --who HOSTPROBE4 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/hostprobe4.gd -- stage=<road|all> ...`.

## 5. Verdict: FAIL - 5 of 9 bars pass (B1, B2, B4, B6, A1)

| Bar | Result | Measured |
|---|---|---|
| B1 favours | pass | earned **2.94 a year** (2-4); the show spends 2.75 of 2.92; "as it is" beats "with a favour" in **9 of 16** cells (HOSTPROBE3: 4 of 16). The +2 in 10 did what s7 item 3 asked |
| B2 hall read | pass | the expected-night read names the measured best for all three clubs: young and mid Community, **grown Town** (read $6066 v $5211; measured $6,036 v $5,440). No club was "close" |
| B3 routes | **FAIL** | best route counts (36 cells): below 20, promise 6, as it is 4, favour 3, wait 3. Every route right somewhere, but **below 20 of 36 = 56 in 100** (the bar is 50) |
| B4 two reserves | pass | 2 reserves best for every club x hall (6 of 6) |
| B6 rank number | pass | 8 of 8 within 0.52 (rule unchanged) |
| B8 pro line on the road | **FAIL** (1 of 6 people) | test seeds 8-23: Kira, Samira, Tess, Danny, Josh within 0-2 bouts and called by bout 24 in 100 of 100; **Lucy: v7 median bout 6 against the built 9** (she reaches 34+ points and No. 2 at 5-1) |
| B9 a reason to ask up | **FAIL** | 0 of 6 chase cells: above as it is minus below, pro offer in 100: Lucy|weak|f0 -3.5, Lucy|weak|f1 -2.3, Lucy|weak|f2 -3.7, Lucy|strong|f0 -0.1, Lucy|strong|f1 -1.2, Lucy|strong|f2 -1.4 |
| A1 no route over 6 of 10 | pass | top: below 20 of 36 (56 in 100) |
| A3 best beats lazy by $1,000 in half | **FAIL** | **8 of 36** (HOSTPROBE3: 14 of 36) |

B7 (cut list): nothing is cut. Smallest best edges: favour $169, as it is $514, wait $506 (+2.6 in 100 pro), below $637, promise $1,486.

## 6. What is real, what is solved, what is worthless
**Solved by v7:** the hall read (B2: the expected night finds Town for the grown club), the favour's price (B1: 9 of 16), two
reserves (B4), the rank number (B6). The hall and reserves stay reads, not decisions.
**Broken:** the points line at the pro chase. **Thin:** the card's lead over the lazy ask (A3 fell from 14 to 8 of 36).

**Why (read in the runs):**
1. **34 points is where the game's boxers stand at 7 wins - and also where a good boxer stands at 5 or 6.** The zero-sum
   ladder pays a strong start fast: Lucy is at 36 points and No. 2 at 5-1 on every seed, so the points line calls her 3 bouts
   early (B8). Points measure WHO you beat, not HOW MANY; the median at the built call is low (34) because slower boxers
   (Samira 25-34, Tess 32) reach 7 wins with modest points.
2. **The test club's chase cells already stand over 34** (Lucy 6-1: 35, Kira: 38). The call then hangs on rank alone, and any
   win lifts them into the top 3. The name below says yes 9 in 10, the name above 5 in 10 with a 1 in 2 chance of a late no
   off the posters, so below brings the call more often (B9 negative) and is best in 20 of 36 cells (B3).
3. **The late no works, but on the wrong side of A3.** It made asking up riskier, so the lazy ask (above as it is) is now
   beaten where below is right - but only by $430-$610 in the as-is cells (posters +12, a 9-in-10 yes, a safer win), under the
   $1,000 line. A3 counts cells where the card's choice is worth $1,000; most choices on this card are worth $300-$600.
4. **The mood (task step 4):** the fight itself DOES read mood - LiveRound.gd:183-185 multiplies every corner call and fix the
   boxer takes in by FighterProfile.trust (her mood; FighterProfile.gd:59-61), and the adaptation and fix hold read it too
   (LiveRound.gd:111, 450). There is no direct strength or win term for mood; it moves the fight only through the corner's word.
   HOSTPROBE3's line "the game's win chance never changes with a boxer's mood" is wrong for the fight; the read's caches carry
   the mood since S539 MOODREAD1 (BoutRead.gd:225, 310).

## 7. What to change (FREE HAND, owner S534) - then probe again before any critic
1. **The pro call: keep the built count, weigh the wins (s7 item 1's second option).** A win over a name above on ladder points
   counts 1, a win over a name below 1/2; the line stays 7 with top 3, or 9 at any rank (Roster.gd:34-36). This keeps the
   call's timing where the count puts it (B8) and gives the chase a reason to ask up (below = half a win). Measure on the same
   road (log each opponent's points before the bout) and on the card (B9).
2. **Below's tile is too safe.** With 9 in 10 yes, the posters' +12 and a likely win it is best in 56 in 100 of cells. Either the
   name below brings no posters (v6) or its yes drops to 8 in 10 at a hall where the posters are worth more (ESTIMATE, probe).
3. **Give the card a $1,000 choice (A3): tie the main event to the hall.** Today the hall is read from the club alone. Let the
   main event's posters scale with the hall (Community +24, Town +48, ESTIMATE): a grown club's Town night fills only with the
   name above on the posters, so the ask up decides the full house (+6 rep = $2,000). Interconnect, not a new system.
4. **If the card still cannot reach A3 after items 1-3**, the show goes to the owner as "keep it as a light money night or cut
   the card" (owner S534: a mechanic that cannot reach 8 goes to him; never removed silently).
5. Probe note: the road's careers barely vary by seed for most people (the fight's dice are the fight day's, tools/turnprobe15.gd
   header): Tess is identical on all 24 seeds. The next road stage should vary the signing day so the held-out seeds are
   independent.

No critic brief was written: the probe failed, so per TASK_HOSTPROBE4 step 3 the map goes back for these changes and a fifth
probe before any critic sees it.

## 8. Limits
- Card stage as HOSTPROBE3: fixed bots, BoutRead.chance for ours, WorldBout.fast for rivals, a 20 in 100 stoppage share of our
  losses, our night plus one next bout. The posters are priced per boxer (one top bout per boxer, not one per show).
- The road: one bot (takes every legal bout); the pro offer is cleared each day (no declines); 30 bouts or 156 weeks.
- The late-no chance (1 in 2), the late yes (7 in 10) and the +12 posters for a name below are ESTIMATES.

## 9. Tables

**The road: built rule / v7 (test seeds 8-23, 16 careers a person)**

| Person | Careers | called in 100 | by bout 24 in 100 | median bout of the call | points at the built call | B8 |
|---|---|---|---|---|---|---|
| Lucy Jackson | 16 | 100 / 100 | 100 / 100 | 9 / 6 | 38-42 | **FAIL** |
| Kira Mensah | 16 | 100 / 100 | 100 / 100 | 9 / 10 | 26-47 | pass |
| Samira Khan | 16 | 100 / 100 | 100 / 100 | 15 / 17 | 27-47 | pass |
| Tess Reilly | 16 | 100 / 100 | 100 / 100 | 11 / 12 | 32-32 | pass |
| Danny Osei | 16 | 100 / 100 | 100 / 100 | 8 / 8 | 26-37 | pass |
| Josh Harper | 16 | 100 / 100 | 100 / 100 | 9 / 9 | 35-41 | pass |

**Calibration seeds 0-7: points @ bout (record, rank) at the built call**

| Person | calls |
|---|---|
| Lucy Jackson | 40@9(7-2 r2), 40@9(7-2 r2), 40@9(7-2 r2), 40@9(7-2 r2), 40@9(7-2 r2), 41@8(7-1 r2), 33@14(9-5 r3), 40@9(7-2 r2) |
| Kira Mensah | 34@9(7-2 r3), 33@9(7-2 r3), 33@9(7-2 r3), 33@9(7-2 r3), 27@9(7-2 r3), 33@9(7-2 r3), 33@9(7-2 r3), 33@9(7-2 r3) |
| Samira Khan | 27@15(7-8 r3), 30@15(7-8 r3), 32@15(7-8 r2), 29@16(9-7 r3), 31@15(9-6 r3), 31@15(7-8 r3), 34@11(7-4 r3), 25@19(9-10 r3) |
| Tess Reilly | 32@11(7-4 r3), 32@11(7-4 r3), 32@11(7-4 r3), 32@11(7-4 r3), 32@11(7-4 r3), 32@11(7-4 r3), 32@11(7-4 r3), 32@11(7-4 r3) |
| Danny Osei | 35@8(7-1 r3), 35@8(7-1 r3), 37@8(7-1 r3), 31@9(7-2 r3), 34@8(7-1 r3), 36@8(7-1 r3), 35@10(8-2 r3), 34@8(7-1 r3) |
| Josh Harper | 41@9(7-2 r3), 41@9(7-2 r3), 41@9(7-2 r3), 41@9(7-2 r3), 41@9(7-2 r3), 41@9(7-2 r3), 40@10(8-2 r3), 41@9(7-2 r3) |

**Hall read (expected night) against measured**

| club | read names | read: Community V | read: Town V | measured best (2 reserves) | gap $ |
|---|---|---|---|---|---|
| young | community | 2394 (178 seats) | -395 (167 seats) | community | 0 |
| mid | community | 3412 (202 seats) | 962 (198 seats) | community | 0 |
| grown | town | 5211 (240 seats) | 6066 (320 seats) | town | 0 |

| club | hall | reserves | V | cash | rep | full / half / short in 100 | bad night (p10) |
|---|---|---|---|---|---|---|---|
| young | community | 0 | 1623 | 1927 | -0.91 | 2 / 7 / 39 | 970 |
| young | community | 1 | 2108 | 2157 | -0.15 | 6 / 1 / 17 | 1160 |
| young | community | 2 | 2340 | 2232 | 0.32 | 11 / 0 / 6 | 1190 |
| young | town | 0 | -1136 | 446 | -4.75 | 0 / 98 / 42 | -460 |
| young | town | 1 | -708 | 677 | -4.16 | 0 / 93 / 21 | -260 |
| young | town | 2 | -467 | 759 | -3.68 | 0 / 88 / 8 | -220 |
| mid | community | 0 | 2658 | 2650 | 0.03 | 21 / 0 / 39 | 1540 |
| mid | community | 1 | 3196 | 2876 | 0.96 | 33 / 0 / 17 | 1720 |
| mid | community | 2 | 3432 | 2945 | 1.46 | 39 / 0 / 6 | 1760 |
| mid | town | 0 | 117 | 1354 | -3.71 | 0 / 72 / 42 | 270 |
| mid | town | 1 | 665 | 1584 | -2.76 | 0 / 58 / 21 | 450 |
| mid | town | 2 | 920 | 1663 | -2.23 | 0 / 52 / 8 | 500 |
| grown | community | 0 | 5110 | 4220 | 2.67 | 86 / 0 / 39 | 3330 |
| grown | community | 1 | 5370 | 4240 | 3.39 | 93 / 0 / 17 | 3500 |
| grown | community | 2 | 5440 | 4188 | 3.76 | 97 / 0 / 6 | 3540 |
| grown | town | 0 | 5263 | 5035 | 0.68 | 25 / 0 / 42 | 3260 |
| grown | town | 1 | 5791 | 5264 | 1.58 | 33 / 0 / 21 | 3430 |
| grown | town | 2 | 6036 | 5343 | 2.08 | 37 / 0 / 8 | 3470 |

**Card cells (value $ = seats x $30 + rep x $333 + members x $100 + pro offer x $333 a point + $450 a next bout + favours x $160)**

| cell (boxer / form / record / favours) | above / below | best | gap $ to 2nd | lead $ over lazy | all routes (pro offer in 100, rep) |
|---|---|---|---|---|---|
| Lucy|weak|asis|f0 | Maria Ortega / Aisha Rahman | above_asis | 157 | 0 | above_asis 3614 (pro 0.4, rep 3.63); below 3457 (pro 0.3, rep 3.64); wait 3226 (pro 0.6, rep 3.62); above_promise 2182 (pro 0.1, rep 0.07) |
| Lucy|weak|asis|f1 | Maria Ortega / Aisha Rahman | above_asis | 21 | 0 | above_asis 3549 (pro 0.5, rep 3.39); above_favour 3528 (pro 0.5, rep 3.36); below 3335 (pro 0.3, rep 3.40); wait 3138 (pro 0.7, rep 3.38); above_promise 2120 (pro 0.1, rep -0.10) |
| Lucy|weak|asis|f2 | Maria Ortega / Aisha Rahman | above_favour | 51 | 51 | above_favour 3423 (pro 0.4, rep 3.25); above_asis 3372 (pro 0.3, rep 3.21); below 3299 (pro 0.3, rep 3.32); wait 3025 (pro 0.4, rep 3.32); above_promise 2068 (pro 0.0, rep -0.13) |
| Lucy|weak|chase|f0 | Erin Doyle / Priya Nair | below | 380 | 1238 | below 10849 (pro 24.6, rep 1.92); wait 10469 (pro 24.4, rep 1.93); above_asis 9611 (pro 21.1, rep 0.84); above_promise 6610 (pro 17.3, rep -3.59) |
| Lucy|weak|chase|f1 | Erin Doyle / Priya Nair | below | 355 | 873 | below 10654 (pro 24.1, rep 1.87); wait 10299 (pro 24.0, rep 1.87); above_asis 9781 (pro 21.8, rep 0.74); above_favour 8693 (pro 18.9, rep 0.39); above_promise 6756 (pro 17.8, rep -3.61) |
| Lucy|weak|chase|f2 | Erin Doyle / Priya Nair | below | 412 | 1345 | below 10748 (pro 24.4, rep 1.86); wait 10336 (pro 24.1, rep 1.84); above_asis 9403 (pro 20.7, rep 0.64); above_favour 8398 (pro 18.1, rep 0.30); above_promise 6771 (pro 17.8, rep -3.66) |
| Lucy|strong|asis|f0 | Maria Ortega / Aisha Rahman | above_asis | 514 | 0 | above_asis 4715 (pro 0.8, rep 5.91); below 4201 (pro 0.4, rep 5.10); above_promise 3748 (pro 0.0, rep 3.82); wait 3736 (pro 0.7, rep 5.47) |
| Lucy|strong|asis|f1 | Maria Ortega / Aisha Rahman | above_favour | 169 | 169 | above_favour 4926 (pro 1.1, rep 6.23); above_asis 4757 (pro 0.9, rep 5.88); below 4338 (pro 0.7, rep 5.15); above_promise 3809 (pro 0.1, rep 3.94); wait 3752 (pro 0.9, rep 5.38) |
| Lucy|strong|asis|f2 | Maria Ortega / Aisha Rahman | above_favour | 99 | 99 | above_favour 4947 (pro 1.1, rep 6.19); above_asis 4848 (pro 1.1, rep 5.89); below 4428 (pro 1.0, rep 5.10); above_promise 3750 (pro 0.0, rep 3.80); wait 3737 (pro 0.8, rep 5.42) |
| Lucy|strong|chase|f0 | Erin Doyle / Priya Nair | above_asis | 102 | 0 | above_asis 16514 (pro 40.7, rep 2.28); below 16412 (pro 40.8, rep 2.43); wait 15971 (pro 40.4, rep 2.43); above_promise 14177 (pro 35.9, rep -0.37) |
| Lucy|strong|chase|f1 | Erin Doyle / Priya Nair | below | 223 | 223 | below 16957 (pro 42.3, rep 2.52); above_asis 16734 (pro 41.1, rep 2.48); wait 16618 (pro 42.3, rep 2.52); above_favour 15935 (pro 38.8, rep 2.43); above_promise 14168 (pro 35.5, rep -0.04) |
| Lucy|strong|chase|f2 | Erin Doyle / Priya Nair | below | 383 | 383 | below 15982 (pro 39.3, rep 2.56); above_asis 15599 (pro 37.9, rep 2.25); wait 15579 (pro 39.1, rep 2.56); above_favour 15126 (pro 36.5, rep 2.25); above_promise 14067 (pro 35.6, rep -0.39) |
| Kira|weak|asis|f0 | Grace Adeyemi / Megan Price | below | 375 | 610 | below 1636 (pro 0.0, rep 0.15); wait 1261 (pro 0.0, rep 0.05); above_asis 1026 (pro 0.0, rep -1.80); above_promise 107 (pro 0.0, rep -4.38) |
| Kira|weak|asis|f1 | Grace Adeyemi / Megan Price | below | 378 | 554 | below 1806 (pro 0.0, rep 0.55); wait 1428 (pro 0.0, rep 0.44); above_asis 1253 (pro 0.0, rep -1.26); above_favour 989 (pro 0.0, rep -1.85); above_promise 291 (pro 0.0, rep -3.91) |
| Kira|weak|asis|f2 | Grace Adeyemi / Megan Price | below | 365 | 576 | below 1704 (pro 0.0, rep 0.32); wait 1339 (pro 0.0, rep 0.23); above_asis 1128 (pro 0.0, rep -1.55); above_favour 828 (pro 0.0, rep -2.25); above_promise 159 (pro 0.0, rep -4.23) |
| Kira|weak|chase|f0 | (none legal) / Nina Kowalski | wait | 506 | 506 | wait 9153 (pro 24.7, rep -1.13); below 8647 (pro 22.1, rep -1.05) |
| Kira|weak|chase|f1 | (none legal) / Nina Kowalski | wait | 368 | 368 | wait 8555 (pro 23.0, rep -1.20); below 8187 (pro 20.8, rep -1.15) |
| Kira|weak|chase|f2 | (none legal) / Nina Kowalski | wait | 397 | 397 | wait 8507 (pro 22.9, rep -1.17); below 8110 (pro 20.6, rep -1.14) |
| Kira|strong|asis|f0 | Grace Adeyemi / Megan Price | below | 361 | 459 | below 2864 (pro 0.0, rep 2.77); wait 2503 (pro 0.0, rep 2.69); above_asis 2405 (pro 0.0, rep 1.44); above_promise 1276 (pro 0.0, rep -1.63) |
| Kira|strong|asis|f1 | Grace Adeyemi / Megan Price | below | 364 | 429 | below 2863 (pro 0.0, rep 2.77); wait 2499 (pro 0.0, rep 2.69); above_asis 2434 (pro 0.0, rep 1.51); above_favour 2216 (pro 0.0, rep 1.09); above_promise 1325 (pro 0.0, rep -1.50) |
| Kira|strong|asis|f2 | Grace Adeyemi / Megan Price | below | 364 | 437 | below 2928 (pro 0.0, rep 2.92); wait 2563 (pro 0.0, rep 2.84); above_asis 2491 (pro 0.0, rep 1.70); above_favour 2219 (pro 0.0, rep 1.14); above_promise 1324 (pro 0.0, rep -1.49) |
| Kira|strong|chase|f0 | (none legal) / Nina Kowalski | below | 406 | 0 | below 11859 (pro 30.0, rep 0.25); wait 11453 (pro 29.8, rep 0.22) |
| Kira|strong|chase|f1 | (none legal) / Nina Kowalski | below | 424 | 0 | below 12179 (pro 30.9, rep 0.35); wait 11755 (pro 30.6, rep 0.32) |
| Kira|strong|chase|f2 | (none legal) / Nina Kowalski | below | 287 | 0 | below 12759 (pro 32.6, rep 0.47); wait 12472 (pro 32.8, rep 0.42) |
| Josh|weak|asis|f0 | Ryan McBride / - | above_promise | 1161 | 1161 | above_promise 4253 (pro 0.3, rep 4.85); above_asis 3092 (pro 0.1, rep 3.75); wait 2650 (pro 0.2, rep 3.36) |
| Josh|weak|asis|f1 | Ryan McBride / - | above_promise | 682 | 1179 | above_promise 4312 (pro 0.4, rep 4.91); above_favour 3630 (pro 0.3, rep 4.44); above_asis 3133 (pro 0.2, rep 3.68); wait 2620 (pro 0.1, rep 3.35) |
| Josh|weak|asis|f2 | Ryan McBride / - | above_promise | 675 | 1125 | above_promise 4170 (pro 0.3, rep 4.67); above_favour 3494 (pro 0.3, rep 4.25); above_asis 3045 (pro 0.1, rep 3.62); wait 2597 (pro 0.2, rep 3.27) |
| Josh|weak|chase|f0 | (none legal) / Ryan McBride | below | 306 | 0 | below 17633 (pro 43.5, rep 2.74); wait 17328 (pro 43.5, rep 2.71) |
| Josh|weak|chase|f1 | (none legal) / Ryan McBride | below | 137 | 0 | below 17652 (pro 43.5, rep 2.79); wait 17515 (pro 44.0, rep 2.82) |
| Josh|weak|chase|f2 | (none legal) / Ryan McBride | below | 549 | 0 | below 17598 (pro 43.5, rep 2.60); wait 17049 (pro 42.9, rep 2.61) |
| Josh|strong|asis|f0 | Ryan McBride / - | above_promise | 1486 | 1486 | above_promise 5694 (pro 0.4, rep 8.14); above_asis 4208 (pro 0.3, rep 6.17); wait 3514 (pro 0.2, rep 5.24) |
| Josh|strong|asis|f1 | Ryan McBride / - | above_promise | 926 | 1531 | above_promise 5599 (pro 0.3, rep 8.02); above_favour 4673 (pro 0.1, rep 7.00); above_asis 4068 (pro 0.1, rep 5.96); wait 3519 (pro 0.4, rep 5.08) |
| Josh|strong|asis|f2 | Ryan McBride / - | above_promise | 888 | 1444 | above_promise 5476 (pro 0.2, rep 7.80); above_favour 4588 (pro 0.1, rep 6.84); above_asis 4032 (pro 0.1, rep 5.87); wait 3433 (pro 0.2, rep 5.07) |
| Josh|strong|chase|f0 | (none legal) / Ryan McBride | below | 637 | 0 | below 24584 (pro 62.1, rep 4.36); wait 23946 (pro 61.2, rep 4.33) |
| Josh|strong|chase|f1 | (none legal) / Ryan McBride | below | 125 | 0 | below 24520 (pro 61.8, rep 4.38); wait 24394 (pro 62.4, rep 4.42) |
| Josh|strong|chase|f2 | (none legal) / Ryan McBride | below | 612 | 0 | below 24716 (pro 62.4, rep 4.38); wait 24104 (pro 61.6, rep 4.34) |

**Rank number (No. 3 or better, in 100)**

| cell | printed | measured | diff |
|---|---|---|---|
| Lucy|weak|chase|Erin Doyle | 17.3 | 17.2 | 0.11 |
| Lucy|weak|chase|Priya Nair | 17.6 | 17.4 | 0.18 |
| Lucy|strong|chase|Erin Doyle | 36.1 | 36.6 | -0.47 |
| Lucy|strong|chase|Priya Nair | 36.8 | 36.8 | -0.08 |
| Kira|weak|chase|Nina Kowalski | 86.8 | 87.2 | -0.41 |
| Kira|strong|chase|Nina Kowalski | 88.9 | 89.1 | -0.13 |
| Josh|weak|chase|Ryan McBride | 38.7 | 38.4 | 0.36 |
| Josh|strong|chase|Ryan McBride | 18.6 | 19.1 | -0.52 |

**Favours a year (2,000 seasons):** hoard bot earned 2.94, held 10.7 at the year's end over 7.8 host clubs; use bot earned 2.92, spent 2.75 at shows.
