# HOSTPROBE3 RESULT - club show map v6, greybox probe before any critic

S540, task `ops/research/TASK_HOSTPROBE3.md`. Map: `ops/research/DESIGN_HOSTSHOW1_V6.md` (v5 + every HOSTPROBE2 section 7 item;
favours at the game's own rate, owner Q-308 "Yes, keep it"). Measurement only: nothing under `scripts/` changes. v6's new rules
are the flagged copy `tools/hostprobe3_rules.gd`; the runner is `tools/hostprobe3.gd` (base: tools/hostprobe2.gd). Sections
1-3 were written and committed BEFORE the run; the bars are not loosened afterwards.

## 1. Code check
Every CODE claim of v6 carries its file:line in the map (sections 0, 2, 4), read on 2026-11-23. What it changes for the probe:
(a) the pro call on ladder points: Roster.PRO_WINS 7 / PRO_WINS_ANY_RANK 9 / PRO_RANK 3 (Roster.gd:34-36) turned into points by
LadderPoints.seed_of (LadderPoints.gd:18-19): 43 and 53; rank = Region.before (ladder points first, Region.gd:197-212); points
move by LadderRep.change through LadderPoints.settle (both sides, stoppage x1.15 +2); (b) halls Community and Town only, the read
at ClubShow.LUCK's middle; (c) no sell, no Leave off; (d) favours, pull-outs, the promise, the yes chances and the exchange as
HOSTPROBE2.

## 2. Method (as HOSTPROBE2 s2, fixed before the run)
- **Population and dice:** HOSTPROBE1/2's: the TEST CLUB (Lucy wlw 3-1, Kira wfw 1-0, Josh mww 4-2) against their classes' named
  rivals; WEAK / STRONG (+5 every stat) x AS-IS / PRO-CHASE (6 wins); favours held 0 / 1 / 2; clubs young 40 members / rep 10,
  mid 58 / 24, grown 120 / 60; common random numbers per (cell, roll, event); seed 5390.
- **Game modules used:** ClubShow draw parts, BoutRead.chance, WorldBout.fast, LadderPoints.settle / seed_of, Region.before,
  Roster.pro_ready (built, for comparison), FightWeekEvents (pull-out rate, card_bout, fill_gap), PartnerMatch.OUTSIDE_FEE.
- **One value per option:** $1,000 = 3 rep = 3 in 100 pro offer; a seat $30, a member $100; a favour $160 (CODE); a next bout
  $450 cut. The card's horizon: our night plus the boxer's next bout within 12 weeks (the return bout for a promise; else the
  free pick), then the pro check - as HOSTPROBE2.
- **Lazy bot:** the name above as it is (below if no tile). Two reserves; the read's hall.
- **Seasons (new, B8):** each boxer x WEAK / STRONG from the as-signed record, up to 30 bouts, one every 4 weeks with a region
  show (2 rival pairs) before each; bots "sensible" (the name above at a 40 in 100 win chance or better, else below) and "easy"
  (the best win chance); the same dice for the built rule and v6's. PROBE: stats do not grow, no newcomers, no idle clock.

## 3. Bars (written before the run)
HOSTPROBE2's bars for the decisions v6 keeps, not loosened; the owner's favour bar; two bars for the new pro rule.
- **B1 favours (owner Q-308):** the built rules earn 2-4 favours a year at the test club (the game's own rate, about 3); the show's
  spending (use bot) is at most what is earned; and "as it is" beats "with a favour" in at least 1 of 3 card cells where both exist.
- **B2 hall read:** the hall the read names is the measured best (net cash + reputation x $333, two reserves, 8,000 nights) for each
  of the three clubs, or, where not, within $300 of it.
- **B3 routes:** each of above as it is / with a favour / promise / below / wait is best in at least one card cell and in at most
  50% of them.
- **B4 reserves default:** two reserves are best, or within $50 of best, for every club x hall.
- **B6 rank number:** the printed "No. 3 or better: N in 100" (with stoppages) is within 1 point of the measured result in every
  cell (as HOSTPROBE2).
- **B8 the pro line over seasons (new rule):** for the sensible bot, in every boxer x strength cell where the built rule calls in
  at least half the seasons, v6's median bout of the call is within 2 bouts of the built rule's, and v6's share called by bout 24
  is at least 0.8 of the built rule's.
- **B9 a reason to ask up (new rule):** in the pro-chase card cells where both the name above and the name below exist, "above as
  it is" gives at least 3 in 100 more pro offer than "below" in at least half of them.
- **B7 cut rule (a list):** any option whose gain over the next best is under $150 AND under 1 reputation AND under 3 in 100 pro
  offer in every cell it appears is CUT.
- **A1** no route is the one answer in more than 6 of 10 card cells.
- **A2** every route is right in at least one card cell (B3's first half).
- **A3** the best route beats the lazy bot by $1,000 (= 3 rep = 3 in 100 pro) in at least half the card cells.
PASS = B1, B2, B3, B4, B6, B8, B9, A1, A3 all pass. B7 is a list.

## 4. Run
`python ops/Tools/godot_slot.py run --who HOSTPROBE3 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/hostprobe3.gd -- stage=all rolls=2000 out=E:/FightCamp/tmp/hostprobe3/run2000.jsonl`
(591 s, S540, seed 5390, after a 10-roll smoke run; 0 script errors). 2,000 rolls a card cell, 8,000 nights a hall option, 20,000
seeds a rank cell, 2,000 seasons a favour arm, 500 seasons a career cell. Raw lines outside the repo (E:/FightCamp/tmp/hostprobe3/).
The lines: pro points 43 (a 7-0 record's seed), any rank 53 (9-0).

## 5. Verdict: FAIL - 5 of 9 bars pass (B3, B4, B6, B9, A1)

| Bar | Result | Measured |
|---|---|---|
| B1 favours | **FAIL** (third clause) | earned **2.9 a year** (in 2-4: pass); the show spends 2.7 of 2.9 (pass); "as it is" beats "with a favour" in **4 of 16** cells (25 in 100, the bar is 1 in 3). On the points line the yes from the name above now carries the pro offer, so the favour's +3 in 10 is worth more than its $160 (HOSTPROBE2: 8 of 16) |
| B2 hall read | **FAIL** | young and mid: the read names Community, measured best (pass). Grown: the read names Community ($5,612 against Town's $5,560 on a middle night), measured best is Town by **$596** ($6,036 against $5,440). The read's one middle night misses Town's good nights (full 37 in 100, +6 rep) and Community's lost travel when bouts fall through |
| B3 routes | pass | below 12, favour 8, promise 6, wait 6, as it is 4 (36 cells): every route right somewhere, none over 33 in 100 (HOSTPROBE2: below 61 in 100) |
| B4 two reserves | pass | 2 reserves best for every club x hall (6 of 6), by $70-$236 over 1 at Community, $241-$255 at Town |
| B6 rank number | pass | 8 of 8 within 0.52 (as HOSTPROBE2: the rule is unchanged) |
| B8 pro line over seasons | **FAIL** | the points line almost never calls. Sensible bot, built against v6, called by bout 24: Lucy weak 98.6 / 3.6, Lucy strong 100 / 45.8, Kira weak 58.2 / 0.2, Kira strong 92.0 / 2.2 (table s9). Boxers win 10-14 bouts a season and still settle below 43 |
| B9 a reason to ask up | pass | 6 of 6 chase cells with both names: above as it is gives +11 to +20 in 100 more pro offer than below (built rule on the night: +0.4 to +2.1) |
| A1 no route over 6 of 10 | pass | top: below 12 of 36 |
| A3 best beats lazy by $1,000 in half | **FAIL** | **14 of 36** (39 in 100; HOSTPROBE2's card alone: 27 of 108). With the hall, reserves and the read now solved, the card carries the show alone |

B7 (cut list): nothing is cut. Below's best edge over the next option is $54 but +2.3 reputation; every other route clears $150.

## 6. What is real, what is solved, what is worthless
**Real:** the card. Who to ask and how is now spread over all five routes (B3, A1), and at the pro line the name above is the
route to the call (B9: +11 to +20 in 100) - the interconnect does what section 7 item 2 asked, on the night.
**Solved (read, not decided - as v6 meant):** two reserves (B4 holds the default); the hall for young and mid clubs.
**Broken:** the points line itself (B8). **Thin:** the card's lead over the lazy ask (A3).

**Why (read in the code and the rules copy):**
1. **The points line is a seed, not a place boxers reach.** LadderRep.change is zero-sum Elo (16 x (1 - expected)): a boxer who
   keeps winning settles where the pool's expected scores balance, not at "8 + 4 x net wins + bouts". In these divisions the
   pool's names sit at 10-41 points with one 53 and two 65s (s9); a boxer who beats the names in reach gains +2 to +5 a win and
   loses 11-14 on a loss above. 43 is above where a 12-win season settles. The seed equivalence (7-0 = 43) was the wrong
   calibration.
2. **The read's middle night is not the expected night.** Town's value is in its good nights (luck up to 1.15 fills 400 seats
   for a grown club, +6 rep); a single 0.925 night gives Town no full chance and Community a sure full house.
3. **On the points line the favour pays more.** Where the yes from the name above holds the pro call, +3 in 10 of yes is worth
   more than $160; "as it is" wins only where the yes is already high.
4. **Asking up is nearly free for the lazy bot.** A "no" from the name above falls to the name below at 9 in 10 the same week
   (map 4.3), so the lazy ask loses little when it is wrong.

## 7. What to change (FREE HAND, owner S534) - then probe again before any critic
1. **Calibrate the pro line from the game's own careers, not a seed.** Read the ladder points boxers hold at the built call in
   TURNPROBE15's 5,498 careers (tools/turnprobe15*, which have stat growth and newcomers; this probe's closed pool has neither)
   and set the line there (e.g. the median at the built call); or keep the built count and weigh the wins (a win over a name
   above counts 1, a name below 1/2, line 7). Probe B8 in the TURNPROBE15 harness, not this closed pool (here even the built rule
   calls Josh in only 22-39 in 100 of seasons: his division has four names).
2. **The hall read over the range of nights.** The read averages five luck points across ClubShow.LUCK and the expected pull-outs
   with two reserves; when the halls are within $300 the screen says "close - your call" and shows both.
3. **The favour's yes: +2 in 10, not +3** (ESTIMATE), re-measured against B1's 1 in 3. The owner's rate (about 3 a year) is
   untouched.
4. **A "no" costs the slot's week.** The next ask goes out after the 3-day answer (map 4.3's own rule), so a no from the name above
   lands after the posters 1 in 2 of the time and the main event's seats are lost. Price it in the probe; it is the lever A3 needs.
5. **Side defect (not fixed here, no scripts/ change in a probe task; carried from HOSTPROBE2 s7 item 7):** BoutRead's edge cache
   key has no morale (BoutRead.gd:224) and BoutRead.clear_cache has no caller.

No critic brief was written: the probe failed, so per TASK_HOSTPROBE3 step 3 the map goes back for the s7 changes and a fourth
probe before any critic sees it.

## 8. Limits
- Bots follow fixed rules; bouts are BoutRead.chance (ours) and WorldBout.fast (rivals); our wins never count as stoppages.
- The seasons stage (B8) is a closed pool: no stat growth, no newcomers, no idle clock, a fixed 4-week rhythm. It is enough to
  show the 43 line is out of reach (12-20 wins a season, no call), not to set the right line (s7 item 1).
- The card's horizon is our night plus one next bout (as HOSTPROBE2).

## 9. Tables

**Hall read against measured (V = net cash + rep x $333, two reserves)**

| club | read names | read: Community V | read: Town V |
|---|---|---|---|
| young | community | 2330 (185 seats) | -392 (180 seats) |
| mid | community | 3080 (210 seats) | 1870 (211 seats) |
| grown | community | 5612 (250 seats) | 5560 (334 seats) |

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
| Lucy|weak|asis|f0 | Maria Ortega / Aisha Rahman | above_asis | 397 | 0 | above_asis 3433 (pro 0.0, rep 3.61); below 3036 (pro 0.0, rep 3.64); wait 3026 (pro 0.0, rep 3.62); above_promise 2144 (pro 0.0, rep 0.07) |
| Lucy|weak|asis|f1 | Maria Ortega / Aisha Rahman | above_favour | 77 | 77 | above_favour 3399 (pro 0.0, rep 3.35); above_asis 3322 (pro 0.0, rep 3.37); below 2928 (pro 0.0, rep 3.40); wait 2921 (pro 0.0, rep 3.38); above_promise 2073 (pro 0.0, rep -0.11) |
| Lucy|weak|asis|f2 | Maria Ortega / Aisha Rahman | above_favour | 71 | 71 | above_favour 3320 (pro 0.0, rep 3.17); above_asis 3249 (pro 0.0, rep 3.19); below 2893 (pro 0.0, rep 3.32); wait 2892 (pro 0.0, rep 3.32); above_promise 2059 (pro 0.0, rep -0.15) |
| Lucy|weak|chase|f0 | Erin Doyle / Priya Nair | above_asis | 2782 | 0 | above_asis 6884 (pro 12.7, rep 1.02); wait 4102 (pro 4.0, rep 2.61); below 3254 (pro 1.4, rep 2.70); above_promise 1649 (pro 2.3, rep -3.53) |
| Lucy|weak|chase|f1 | Erin Doyle / Priya Nair | above_favour | 725 | 725 | above_favour 7677 (pro 15.7, rep 0.45); above_asis 6952 (pro 12.9, rep 0.94); wait 4008 (pro 3.8, rep 2.61); below 3160 (pro 1.1, rep 2.69); above_promise 1926 (pro 3.1, rep -3.55) |
| Lucy|weak|chase|f2 | Erin Doyle / Priya Nair | above_favour | 748 | 748 | above_favour 7471 (pro 15.2, rep 0.38); above_asis 6723 (pro 12.3, rep 0.85); wait 4083 (pro 4.0, rep 2.59); below 3195 (pro 1.2, rep 2.66); above_promise 1748 (pro 2.6, rep -3.58) |
| Lucy|strong|asis|f0 | Maria Ortega / Aisha Rahman | above_asis | 689 | 0 | above_asis 4449 (pro 0.0, rep 5.94); below 3760 (pro 0.0, rep 5.10); above_promise 3747 (pro 0.0, rep 3.83); wait 3505 (pro 0.0, rep 5.48) |
| Lucy|strong|asis|f1 | Maria Ortega / Aisha Rahman | above_favour | 255 | 255 | above_favour 4697 (pro 0.0, rep 6.43); above_asis 4443 (pro 0.0, rep 5.91); above_promise 3795 (pro 0.0, rep 3.96); below 3781 (pro 0.0, rep 5.15); wait 3454 (pro 0.0, rep 5.38) |
| Lucy|strong|asis|f2 | Maria Ortega / Aisha Rahman | above_favour | 230 | 230 | above_favour 4681 (pro 0.0, rep 6.34); above_asis 4452 (pro 0.0, rep 5.91); below 3768 (pro 0.0, rep 5.10); above_promise 3747 (pro 0.0, rep 3.81); wait 3488 (pro 0.0, rep 5.43) |
| Lucy|strong|chase|f0 | Erin Doyle / Priya Nair | above_asis | 4478 | 0 | above_asis 10729 (pro 22.1, rep 2.99); above_promise 6251 (pro 11.8, rep -0.17); wait 6109 (pro 8.2, rep 3.91); below 4287 (pro 2.4, rep 4.09) |
| Lucy|strong|chase|f1 | Erin Doyle / Priya Nair | above_favour | 3094 | 3094 | above_favour 14322 (pro 33.4, rep 2.59); above_asis 11228 (pro 23.4, rep 3.17); wait 6329 (pro 8.6, rep 4.07); above_promise 6153 (pro 11.2, rep 0.13); below 4576 (pro 3.0, rep 4.26) |
| Lucy|strong|chase|f2 | Erin Doyle / Priya Nair | above_favour | 3532 | 3532 | above_favour 13290 (pro 30.4, rep 2.39); above_asis 9758 (pro 19.1, rep 2.96); wait 6152 (pro 8.2, rep 3.99); above_promise 6128 (pro 11.5, rep -0.23); below 4334 (pro 2.5, rep 4.15) |
| Kira|weak|asis|f0 | Grace Adeyemi / Megan Price | below | 47 | 345 | below 1309 (pro 0.0, rep 0.15); wait 1261 (pro 0.0, rep 0.05); above_asis 964 (pro 0.0, rep -1.83); above_promise 93 (pro 0.0, rep -4.39) |
| Kira|weak|asis|f1 | Grace Adeyemi / Megan Price | below | 54 | 275 | below 1482 (pro 0.0, rep 0.55); wait 1428 (pro 0.0, rep 0.44); above_asis 1207 (pro 0.0, rep -1.27); above_favour 909 (pro 0.0, rep -2.18); above_promise 280 (pro 0.0, rep -3.91) |
| Kira|weak|asis|f2 | Grace Adeyemi / Megan Price | below | 40 | 293 | below 1379 (pro 0.0, rep 0.32); wait 1339 (pro 0.0, rep 0.23); above_asis 1086 (pro 0.0, rep -1.57); above_favour 762 (pro 0.0, rep -2.55); above_promise 146 (pro 0.0, rep -4.24) |
| Kira|weak|chase|f0 | (none legal) / Nina Kowalski | wait | 1666 | 1666 | wait 4089 (pro 9.2, rep -1.06); below 2424 (pro 3.9, rep -0.96) |
| Kira|weak|chase|f1 | (none legal) / Nina Kowalski | wait | 1218 | 1218 | wait 3469 (pro 7.4, rep -1.12); below 2251 (pro 3.5, rep -1.03) |
| Kira|weak|chase|f2 | (none legal) / Nina Kowalski | wait | 1079 | 1079 | wait 3330 (pro 7.0, rep -1.11); below 2252 (pro 3.5, rep -1.04) |
| Kira|strong|asis|f0 | Grace Adeyemi / Megan Price | below | 38 | 158 | below 2541 (pro 0.0, rep 2.77); wait 2503 (pro 0.0, rep 2.69); above_asis 2383 (pro 0.0, rep 1.49); above_promise 1268 (pro 0.0, rep -1.62) |
| Kira|strong|asis|f1 | Grace Adeyemi / Megan Price | below | 42 | 150 | below 2540 (pro 0.0, rep 2.77); wait 2499 (pro 0.0, rep 2.69); above_asis 2390 (pro 0.0, rep 1.54); above_favour 2158 (pro 0.0, rep 0.87); above_promise 1315 (pro 0.0, rep -1.50) |
| Kira|strong|asis|f2 | Grace Adeyemi / Megan Price | below | 41 | 135 | below 2605 (pro 0.0, rep 2.92); wait 2563 (pro 0.0, rep 2.84); above_asis 2469 (pro 0.0, rep 1.75); above_favour 2181 (pro 0.0, rep 0.93); above_promise 1325 (pro 0.0, rep -1.47) |
| Kira|strong|chase|f0 | (none legal) / Nina Kowalski | wait | 1382 | 1382 | wait 6679 (pro 14.8, rep 0.48); below 5297 (pro 10.0, rep 0.84) |
| Kira|strong|chase|f1 | (none legal) / Nina Kowalski | wait | 1036 | 1036 | wait 6828 (pro 15.0, rep 0.68); below 5792 (pro 11.2, rep 1.02) |
| Kira|strong|chase|f2 | (none legal) / Nina Kowalski | wait | 1272 | 1272 | wait 6702 (pro 14.6, rep 0.77); below 5430 (pro 10.1, rep 1.11) |
| Josh|weak|asis|f0 | Ryan McBride / - | above_promise | 1078 | 1078 | above_promise 4153 (pro 0.0, rep 4.85); above_asis 3075 (pro 0.0, rep 3.75); wait 2584 (pro 0.0, rep 3.36) |
| Josh|weak|asis|f1 | Ryan McBride / - | above_promise | 412 | 1129 | above_promise 4195 (pro 0.0, rep 4.91); above_favour 3783 (pro 0.0, rep 4.70); above_asis 3066 (pro 0.0, rep 3.68); wait 2587 (pro 0.0, rep 3.35) |
| Josh|weak|asis|f2 | Ryan McBride / - | above_promise | 401 | 1075 | above_promise 4070 (pro 0.0, rep 4.67); above_favour 3669 (pro 0.0, rep 4.47); above_asis 2995 (pro 0.0, rep 3.62); wait 2531 (pro 0.0, rep 3.27) |
| Josh|weak|chase|f0 | (none legal) / Ryan McBride | below | 0 | 0 | below 3090 (pro 0.0, rep 3.07); wait 3090 (pro 0.0, rep 3.07) |
| Josh|weak|chase|f1 | (none legal) / Ryan McBride | below | 0 | 0 | below 3142 (pro 0.0, rep 3.20); wait 3142 (pro 0.0, rep 3.20) |
| Josh|weak|chase|f2 | (none legal) / Ryan McBride | below | 0 | 0 | below 3078 (pro 0.0, rep 3.04); wait 3078 (pro 0.0, rep 3.04) |
| Josh|strong|asis|f0 | Ryan McBride / - | above_promise | 1453 | 1453 | above_promise 5577 (pro 0.0, rep 8.14); above_asis 4124 (pro 0.0, rep 6.17); wait 3447 (pro 0.0, rep 5.24) |
| Josh|strong|asis|f1 | Ryan McBride / - | above_promise | 558 | 1497 | above_promise 5516 (pro 0.0, rep 8.02); above_favour 4957 (pro 0.0, rep 7.45); above_asis 4018 (pro 0.0, rep 5.96); wait 3369 (pro 0.0, rep 5.08) |
| Josh|strong|asis|f2 | Ryan McBride / - | above_promise | 523 | 1411 | above_promise 5409 (pro 0.0, rep 7.80); above_favour 4887 (pro 0.0, rep 7.31); above_asis 3998 (pro 0.0, rep 5.87); wait 3367 (pro 0.0, rep 5.07) |
| Josh|strong|chase|f0 | (none legal) / Ryan McBride | below | 0 | 0 | below 4014 (pro 0.0, rep 5.02); wait 4014 (pro 0.0, rep 5.02) |
| Josh|strong|chase|f1 | (none legal) / Ryan McBride | below | 0 | 0 | below 4059 (pro 0.0, rep 5.10); wait 4059 (pro 0.0, rep 5.10) |
| Josh|strong|chase|f2 | (none legal) / Ryan McBride | below | 0 | 0 | below 4021 (pro 0.0, rep 5.01); wait 4021 (pro 0.0, rep 5.01) |

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

**Seasons: the pro call, built rule against v6 (500 seasons a row, up to 30 bouts)**

| boxer | form | bot | rule | called in 100 | by bout 24 | median bout of the call | wins a season |
|---|---|---|---|---|---|---|---|
| Lucy | weak | sensible | built | 99.8 | 98.6 | 15 | 5.9 |
| Lucy | weak | sensible | v6 | 4.2 | 3.6 | 12 | 12.5 |
| Lucy | weak | easy | built | 100.0 | 100.0 | 7 | 6.0 |
| Lucy | weak | easy | v6 | 11.8 | 11.2 | 10 | 20.0 |
| Lucy | strong | sensible | built | 100.0 | 100.0 | 10 | 5.3 |
| Lucy | strong | sensible | v6 | 53.2 | 45.8 | 9 | 10.7 |
| Lucy | strong | easy | built | 100.0 | 100.0 | 6 | 6.0 |
| Lucy | strong | easy | v6 | 37.0 | 36.0 | 9 | 19.2 |
| Kira | weak | sensible | built | 81.4 | 58.2 | 22 | 7.2 |
| Kira | weak | sensible | v6 | 0.2 | 0.2 | 23 | 9.4 |
| Kira | weak | easy | built | 86.0 | 67.6 | 19 | 7.0 |
| Kira | weak | easy | v6 | 0.4 | 0.4 | 23 | 9.8 |
| Kira | strong | sensible | built | 92.2 | 92.0 | 13 | 6.7 |
| Kira | strong | sensible | v6 | 3.4 | 2.2 | 22 | 13.8 |
| Kira | strong | easy | built | 79.2 | 78.8 | 11 | 6.2 |
| Kira | strong | easy | v6 | 0.8 | 0.6 | 23 | 12.3 |
| Josh | weak | sensible | built | 22.0 | 22.0 | 3 | 2.4 |
| Josh | weak | sensible | v6 | 0.0 | 0.0 | -1 | 2.5 |
| Josh | weak | easy | built | 19.8 | 19.8 | 4 | 2.4 |
| Josh | weak | easy | v6 | 0.0 | 0.0 | -1 | 2.5 |
| Josh | strong | sensible | built | 38.8 | 38.8 | 3 | 2.9 |
| Josh | strong | sensible | v6 | 0.0 | 0.0 | -1 | 3.1 |
| Josh | strong | easy | built | 43.4 | 43.4 | 3 | 2.9 |
| Josh | strong | easy | v6 | 0.0 | 0.0 | -1 | 3.1 |

**Favours a year (2,000 seasons):** hoard bot earned 2.90, held 10.7 at the year's end over 7.8 host clubs; use bot earned 2.93,
spent 2.75 at shows.
