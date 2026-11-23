# HOSTPROBE2 RESULT - club show map v5, greybox probe before any critic

S539, task `ops/research/TASK_HOSTPROBE2.md`. Map: `ops/research/DESIGN_HOSTSHOW1_V5.md` (v4 + every HOSTPROBE1 section 7 item).
Measurement only: nothing under `scripts/` changes. v5's new rules are the flagged copy `tools/hostprobe2_rules.gd`; the
runner is `tools/hostprobe2.gd`. Sections 1-3 were written and committed BEFORE the run; the bars are not loosened afterwards.

## 1. Code check
Every CODE claim of v5 carries its file:line in the map (sections 0 and 2), read on 2026-11-23. What it changes for the probe:
(a) favours are the built ones (start 1, cap 3, FightWeekEvents.card_bout / fill_gap), priced at the game's own $160
(PartnerMatch.OUTSIDE_FEE: a sparring partner costs $160 or 1 favour); (b) the promise holds the pro call (Roster.gd:207) until
the return bout, boxed away against the same name; (c) pull-outs at the built 35 in 100 (FightWeekEvents.gd:5); (d) the sell is
priced by PadWeek.run_week + BoutRead.chance; (e) morale is priced by its mood's trust term in BoutRead.chance (BoutRead.gd:235,
FighterProfile.gd:39), not by HOSTPROBE1's $25 a point; (f) no legal name above at the pro chase = no tile (Newcomers arrive
below on ladder points, Newcomers.gd:2-7).

## 2. Method (as HOSTPROBE1 s2, fixed before the run)
- **Population and dice:** HOSTPROBE1's: the TEST CLUB (Lucy wlw 3-1, Kira wfw 1-0, Josh mww 4-2) against their classes' named
  rivals; WEAK / STRONG (+5 every stat) x AS-IS / PRO-CHASE (6 wins); clubs young 40 / 10 / 16 places, mid 58 / 24 / 22,
  grown 120 / 60 / 40; common random numbers per (cell, roll, event); seed 5390.
- **Game modules used:** ClubShow draw parts, BoutRead.chance, WorldBout.fast, LadderPoints.settle, Region.before (rankings),
  Roster.pro_ready, FighterProfile.apply_morale, FightWeekEvents (pull-out rate, card_bout, fill_gap), PartnerMatch.OUTSIDE_FEE,
  PadWeek.nights_for / week_of / run_week, DrillWeek.inputs (the coach's pad skill).
- **One value per option:** HOSTPROBE1's exchange: $1,000 = 3 rep = 3 in 100 pro offer; a seat $30, a member $100. A favour
  = $160 (CODE, the built favour's own price; HOSTPROBE1 measured v4's favour at $45 from the card itself). Morale and pad
  mastery are no longer probe prices: both are read through BoutRead.chance and valued at what a win is worth over a loss on an
  away bout (rep +5 against -2.4, members +8 against -1.2 = $3,384 a whole win).
- **The card's horizon (new, needed by item 2):** our night, then the boxer's next bout within 12 weeks: the return bout for a
  promise (away, the same name, then the pro check), else the free pick (the legal name with the best win chance), unless a pro
  offer came on the night. Every route gets that second bout, so the routes differ only by the rule.
- **Lazy bot:** Community hall, the name above as it is (below if no tile), no reserves, Keep at the read.

## 3. Bars (written before the run; HOSTPROBE1's, minus the two whose options v5 cut)
- **B1a favours:** the built rules earn 4-6 favours a year at the test club (hoard bot, no show spending).
- **B1b:** "as it is" beats "with a favour" in at least 1 of 3 card cells where both exist.
- B1c (swap) and B4 (weight): CUT with their options - not measured.
- **B2 halls:** each hall is best (net cash + reputation, its best reserves and read) for at least one of the three clubs; the
  gym floor is never best on net cash for the mid or the grown club.
- **B3 routes:** each of above as it is / with a favour / promise / below / wait is best in at least one card cell and in at most
  50% of them.
- **B5 boxer C:** over goal safe + Steady / goal safe + Flat / goal tight, each of Outside novice / Leave off is best at least once.
- **B6 rank number:** the printed "No. 3 or better: N in 100" (with stoppages) is within 1 point of the measured
  Region.rankings result in every cell (20,000 seeds a cell at rolls=2000; each pair's tree from 4,000 bouts alone).
- **B7 cut rule (a list):** any option whose gain over the next best is under $150 AND under 1 reputation AND under 3 in 100 pro
  offer in every cell it appears is CUT.
- **A1** no option is the one answer in more than 6 of 10 cells of its decision (hall over clubs; reserves over club x hall;
  read over club x hall x reserves; route over card cells; boxer C over its 9 cells).
- **A2** every option is right in at least one cell of its decision.
- **A3** the best plan beats the lazy bot by $1,000 (= 3 rep = 3 in 100 pro) in at least half the show cells (club x card cell).
PASS = B1a, B1b, B2, B3, B5, B6, A1, A2, A3 all pass. B7 is a list.

## 4. Run
`python ops/Tools/godot_slot.py run --who hostprobe2 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/hostprobe2.gd -- stage=all rolls=2000 out=E:/FightCamp/tmp/hostprobe2/run2000.jsonl`
(265 s, S539, seed 5390, after a 10-roll smoke run). 2,000 rolls a card cell, 8,000 nights a hall option, 20,000 seeds a rank
cell (4,000 bouts a pair for the printed tree), 2,000 seasons a favour arm. Raw lines outside the repo (E:/FightCamp/tmp/hostprobe2/).

**One re-run, said plainly.** The first run's boxer C stage read the same win chance at every morale: BoutRead caches each
fighter's edge under a key with no morale in it (BoutRead.gd:224; the key hashes stats, moves, combos, personality, perks,
habits, footwork), and nothing in the game calls BoutRead.clear_cache (BoutRead.gd:64; `rg clear_cache` finds no caller).
The probe now calls clear_cache before each morale read, and stage=boxerc was run again (0.2 s, boxerc2.jsonl). The bars and the
other stages are unchanged. The verdict is the same either way (Outside novice 9 of 9).

**Prices the game gave (tag price):** one taper pad night less moves the show bout's win chance by 0.0001-0.0002 (Lucy 34.44 ->
34.43, Kira 40.24 -> 40.24, Josh 62.70 -> 62.68): **boxers sell costs $0.20-$0.80**. A favour = $160 (PartnerMatch.OUTSIDE_FEE).
A whole win over a loss on an away bout = $3,384.

## 5. Verdict: FAIL - 3 of 9 bars pass (B1b, B6, A3)

| Bar | Result | Measured |
|---|---|---|
| B1a favours earned 4-6 a year | **FAIL** | the built rules earn **2.9 a year** at the test club (2.9 with show spending; 7.8 host clubs touched, 10.7 favours held at the year's end because every host starts at 1) |
| B1b "as it is" beats "with a favour" in 1 of 3 | pass | 8 of 16 (50 in 100): at its built price ($160) the favour is a real spend |
| B2 each hall best for one club; gym floor never best on cash for mid / grown | **FAIL** | Community for young ($3,235 against gym $689, Town $439) and mid ($4,226), Town for grown ($6,861 against $5,623). The gym floor is never best: $1,500 fixed costs against 64-160 seats. The second clause holds |
| B3 each route best once, none over 50% | **FAIL** | below 22, promise 6, favour 4, as it is 2, wait 2 (36 cells): every route is right somewhere (v4 had two never-right routes), but the name below is right in 61 in 100 |
| B5 each of Outside novice / Leave off best once | **FAIL** | Outside novice 9 of 9 by $940-$1,020 (22 seats, +0.3 rep, +3.4 members); the mood moves the next bout's win chance by 0-1.6 points (Kira Steady 40.2, Flat 38.6): the game's mood term is the corner's trust (FighterProfile.gd:39), 0.85-1.05 of the corner's calls |
| B6 printed rank within 1 point | pass | 8 of 8 cells within 0.52 (largest: Josh strong, printed 18.6, measured 19.1). Printing with stoppages fixed v4's 13 and 19 point misses |
| A1 no option the one answer in over 6 of 10 | **FAIL** | hall: Community 2 of 3; reserves: 2 reserves 6 of 9 (1 reserve the other 3, all on the gym floor, by $24-28); read: sell 19 of 27 (keep "wins" the other 8 by under $1, a full gym floor); route: below 22 of 36; boxer C: novice 9 of 9 |
| A2 every option right somewhere | **FAIL** | never right: the gym floor, 0 reserves, Leave off; Keep only by under $1 on a full gym floor |
| A3 best beats lazy by $1,000 in half the show cells | pass | 108 of 108 - but from the hall plan alone (Community / Town + 2 reserves + sell: +$1,570 to +$1,750); the card alone beats the lazy ask by $1,000 in 27 of 108 |

## 6. What is real, what is solved, what is worthless

**Real (the live choices v5 has):**
- **Who to ask, by stage, with a priced promise.** Far from the pro line the promise is right only where the name above is
  beatable on the return (Josh against a lower-rated name above: +$400-$1,450); against a stronger name the return bout costs
  3-4 rep and the promise is worst (Lucy -$1,300, Kira -$870 to -$1,200). At the pro chase the promise holds the pro call and
  costs 2-3 in 100 of pro offer (Lucy weak: 16.6 against 19.3 as it is). The promise is a real decision now; v4's was free.
- **As it is or with a favour** (B1b 8 of 16): the favour pays where the yes is the whole prize (Lucy as signed, +$70-$255).
- **Below or wait at the pro chase** without a name above: below in 10 of 12, wait in 2 (Josh weak, +$35-$268).

**Solved (one answer):** the hall (by club size: Community for a small or middle club, Town for a club with a name), reserves
(2, at $40 against 35 in 100 pull-outs), the read (sell: it is free), boxer C (Outside novice).

**Worthless (B7: never $150 / 1 rep / 3 pro better than the next option anywhere):** the gym floor (best edge -$1,546), 0
reserves (-$24), Keep at the read (+$0.82 at best), Leave off (-$939). Every card route clears B7 somewhere.

**Why (read in the code and the rules copy):**
1. **Built favours are scarce: 2.9 a year.** Every 2nd bout at the SAME host earns one (FightWeekEvents.gd:9, 84-88), and a
   season's ~11 away bouts spread over ~8 host clubs. B1a's 4-6 was written for v4's ledger; under the built rules the favour
   is scarce and B1b shows it is spent with judgement.
2. **At the pro line any win counts the same.** Roster.pro_ready counts wins and a top-3 rank (Roster.gd:186-196); the name
   below gives a 9 in 10 yes and an easier win, and ladder points rank it close enough. Nothing in the pro rule rewards a
   harder win, so "below" is the pro chase's answer.
3. **Seats beat the mood.** Morale reaches the win chance only as the corner's trust on the calls (0.85-1.05,
   BoutRead.gd:235): a missed goal's -20 moves the next bout 0-1.6 points ($0-$55). 22 seats and a bout are worth ~$1,000.
4. **A pad night is worth nothing to the read.** One taper pad night (half minutes, PadWeek.gd:94) adds so little mastery that
   BoutRead.chance moves by 0.0002: selling is free seats.
5. **The gym floor cannot pay its fixed costs.** $1,500 officials / doctor / medals against at most 4 seats a place.
6. **2 reserves at $40 against 35 in 100** is cheap insurance; no club or hall makes 0 right.

## 7. What to change (FREE HAND, owner S534) - then probe again before any critic
1. **Favours: keep the built rate.** 2.9 a year is scarce and B1b says it is spent with judgement. B1a's 4-6 was v4's own
   target; the next probe's favour bar should read "spent at shows <= earned, and 'as it is' beats 'with a favour' in 1 of 3"
   (a bar change, so it goes to the owner on the board, not decided here).
2. **Give the pro chase a reason to ask up.** Interconnect the pro call with the quality of the wins: e.g. the call needs top 3
   on LADDER POINTS (LadderRep already pays +11-14 for a win over a name above, +2-5 over a name below, LadderRep.gd:27-46)
   rather than wins + rank. Then below and above differ at the line. Probe it on the pro chase cells first.
3. **The hall: two halls, shown as a read of the club, not a decision** (the gym floor never pays), or give the gym floor its
   real costs (no rent, officials for 6 bouts: fixed ~$900) and re-measure the young club.
4. **Reserves: 2 as the coach's default** (a line on the sheet), or price a reserve as real clubs do (a reserve who does not box
   is owed a bout: one built favour).
5. **The read: give "sell" a real price or cut it.** A taper pad night is worth $0.2-0.8 to the read. A price the game counts:
   the evening's rest (PadWeek "rest" evenings, PadWeek.gd:169-171) or a cash commission. Else the read is Keep / Cancel only.
6. **Boxer C: cut Leave off as a show choice** (the game's mood term is too small to make a goal worth a bout), or wire the goal's
   own reward (FighterGoal success: the stat it pays) into the price and re-measure.
7. **Side defect (not fixed here: no scripts/ change in this task):** BoutRead's edge cache key (BoutRead.gd:224) has no morale
   and BoutRead.clear_cache (BoutRead.gd:64) has no caller, so within a session the game's win read never moves with a boxer's
   mood after the first read. Add the mood (FighterProfile.mood) to the key, or clear the cache on each day's tick.

## 8. Limits
- Bots follow fixed rules; bouts are BoutRead.chance (ours) and WorldBout.fast (rivals), not a full BoutNight; our wins never
  count as stoppages (PROBE, as HOSTPROBE1).
- The card's horizon is our night plus one next bout; no region show between them; FAVOURS2's half favour for a bout on a host's
  show is left out of both the return bout and the free pick (the same for both).
- The favour year uses FAVOURPROBE1's rates (~11 away bouts, 0.3 late gaps a year), each host drawn from the opponent's
  division clubs.

## 9. Card cells (value $ = seats x $30 + rep x $333 + members x $100 + pro offer x $333 a point + $450 a next bout + favours x $160)

| cell (boxer / form / record / favours) | above / below | best | gap $ | all routes (pro offer in 100, rep) |
|---|---|---|---|---|
| Lucy|weak|asis|f0 | Maria Ortega / Aisha Rahman | above_asis | 397 | above_asis 3433 (pro 0.0, rep 3.61); below 3036 (pro 0.0, rep 3.64); wait 3026 (pro 0.0, rep 3.62); above_promise 2144 (pro 0.0, rep 0.07) |
| Lucy|weak|asis|f1 | Maria Ortega / Aisha Rahman | above_favour | 77 | above_favour 3399 (pro 0.0, rep 3.35); above_asis 3322 (pro 0.0, rep 3.37); below 2928 (pro 0.0, rep 3.40); wait 2921 (pro 0.0, rep 3.38); above_promise 2073 (pro 0.0, rep -0.11) |
| Lucy|weak|asis|f2 | Maria Ortega / Aisha Rahman | above_favour | 71 | above_favour 3320 (pro 0.0, rep 3.17); above_asis 3249 (pro 0.0, rep 3.19); below 2893 (pro 0.0, rep 3.32); wait 2892 (pro 0.0, rep 3.32); above_promise 2059 (pro 0.0, rep -0.15) |
| Lucy|weak|chase|f0 | Erin Doyle / Priya Nair | below | 59 | below 10348 (pro 23.8, rep 2.08); wait 10289 (pro 23.6, rep 2.09); above_asis 8986 (pro 19.3, rep 0.84); above_promise 6370 (pro 16.6, rep -3.59) |
| Lucy|weak|chase|f1 | Erin Doyle / Priya Nair | below | 33 | below 10222 (pro 23.4, rep 2.04); wait 10189 (pro 23.4, rep 2.04); above_asis 9041 (pro 19.5, rep 0.76); above_favour 8409 (pro 18.0, rep 0.39); above_promise 6454 (pro 16.9, rep -3.61) |
| Lucy|weak|chase|f2 | Erin Doyle / Priya Nair | below | 89 | below 10303 (pro 23.7, rep 2.04); wait 10214 (pro 23.4, rep 2.02); above_asis 8748 (pro 18.7, rep 0.67); above_favour 8201 (pro 17.4, rep 0.32); above_promise 6541 (pro 17.2, rep -3.64) |
| Lucy|strong|asis|f0 | Maria Ortega / Aisha Rahman | above_asis | 689 | above_asis 4449 (pro 0.0, rep 5.94); below 3760 (pro 0.0, rep 5.10); above_promise 3747 (pro 0.0, rep 3.83); wait 3505 (pro 0.0, rep 5.48) |
| Lucy|strong|asis|f1 | Maria Ortega / Aisha Rahman | above_favour | 255 | above_favour 4697 (pro 0.0, rep 6.43); above_asis 4443 (pro 0.0, rep 5.91); above_promise 3795 (pro 0.0, rep 3.96); below 3781 (pro 0.0, rep 5.15); wait 3454 (pro 0.0, rep 5.38) |
| Lucy|strong|asis|f2 | Maria Ortega / Aisha Rahman | above_favour | 230 | above_favour 4681 (pro 0.0, rep 6.34); above_asis 4452 (pro 0.0, rep 5.91); below 3768 (pro 0.0, rep 5.10); above_promise 3747 (pro 0.0, rep 3.81); wait 3488 (pro 0.0, rep 5.43) |
| Lucy|strong|chase|f0 | Erin Doyle / Priya Nair | below | 131 | below 16057 (pro 40.4, rep 2.61); wait 15926 (pro 40.0, rep 2.61); above_asis 15795 (pro 38.4, rep 2.38); above_promise 13930 (pro 35.1, rep -0.34) |
| Lucy|strong|chase|f1 | Erin Doyle / Priya Nair | below | 17 | below 16602 (pro 41.9, rep 2.69); wait 16585 (pro 41.9, rep 2.69); above_asis 16087 (pro 39.1, rep 2.54); above_favour 15497 (pro 37.2, rep 2.44); above_promise 13938 (pro 34.8, rep -0.03) |
| Lucy|strong|chase|f2 | Erin Doyle / Priya Nair | below | 79 | below 15703 (pro 39.1, rep 2.75); wait 15624 (pro 38.9, rep 2.75); above_asis 14861 (pro 35.6, rep 2.30); above_favour 14612 (pro 34.7, rep 2.23); above_promise 13927 (pro 35.2, rep -0.39) |
| Kira|weak|asis|f0 | Grace Adeyemi / Megan Price | below | 47 | below 1309 (pro 0.0, rep 0.15); wait 1261 (pro 0.0, rep 0.05); above_asis 964 (pro 0.0, rep -1.83); above_promise 93 (pro 0.0, rep -4.39) |
| Kira|weak|asis|f1 | Grace Adeyemi / Megan Price | below | 54 | below 1482 (pro 0.0, rep 0.55); wait 1428 (pro 0.0, rep 0.44); above_asis 1207 (pro 0.0, rep -1.27); above_favour 909 (pro 0.0, rep -2.18); above_promise 280 (pro 0.0, rep -3.91) |
| Kira|weak|asis|f2 | Grace Adeyemi / Megan Price | below | 40 | below 1379 (pro 0.0, rep 0.32); wait 1339 (pro 0.0, rep 0.23); above_asis 1086 (pro 0.0, rep -1.57); above_favour 762 (pro 0.0, rep -2.55); above_promise 146 (pro 0.0, rep -4.24) |
| Kira|weak|chase|f0 | (none legal) / Nina Kowalski | below | 1599 | below 16919 (pro 47.6, rep -0.98); wait 15319 (pro 43.0, rep -1.06) |
| Kira|weak|chase|f1 | (none legal) / Nina Kowalski | below | 1089 | below 16603 (pro 46.8, rep -1.07); wait 15514 (pro 43.6, rep -1.12) |
| Kira|weak|chase|f2 | (none legal) / Nina Kowalski | below | 1163 | below 16316 (pro 46.0, rep -1.10); wait 15153 (pro 42.5, rep -1.13) |
| Kira|strong|asis|f0 | Grace Adeyemi / Megan Price | below | 38 | below 2541 (pro 0.0, rep 2.77); wait 2503 (pro 0.0, rep 2.69); above_asis 2383 (pro 0.0, rep 1.49); above_promise 1268 (pro 0.0, rep -1.62) |
| Kira|strong|asis|f1 | Grace Adeyemi / Megan Price | below | 42 | below 2540 (pro 0.0, rep 2.77); wait 2499 (pro 0.0, rep 2.69); above_asis 2390 (pro 0.0, rep 1.54); above_favour 2158 (pro 0.0, rep 0.87); above_promise 1315 (pro 0.0, rep -1.50) |
| Kira|strong|asis|f2 | Grace Adeyemi / Megan Price | below | 41 | below 2605 (pro 0.0, rep 2.92); wait 2563 (pro 0.0, rep 2.84); above_asis 2469 (pro 0.0, rep 1.75); above_favour 2181 (pro 0.0, rep 0.93); above_promise 1325 (pro 0.0, rep -1.47) |
| Kira|strong|chase|f0 | (none legal) / Nina Kowalski | below | 1430 | below 23750 (pro 66.3, rep 0.40); wait 22321 (pro 62.1, rep 0.36) |
| Kira|strong|chase|f1 | (none legal) / Nina Kowalski | below | 1845 | below 24446 (pro 68.2, rep 0.53); wait 22601 (pro 62.7, rep 0.50) |
| Kira|strong|chase|f2 | (none legal) / Nina Kowalski | below | 1468 | below 24577 (pro 68.5, rep 0.66); wait 23109 (pro 64.2, rep 0.62) |
| Josh|weak|asis|f0 | Ryan McBride / - | above_promise | 1078 | above_promise 4153 (pro 0.0, rep 4.85); above_asis 3075 (pro 0.0, rep 3.75); wait 2584 (pro 0.0, rep 3.36) |
| Josh|weak|asis|f1 | Ryan McBride / - | above_promise | 412 | above_promise 4195 (pro 0.0, rep 4.91); above_favour 3783 (pro 0.0, rep 4.70); above_asis 3066 (pro 0.0, rep 3.68); wait 2587 (pro 0.0, rep 3.35) |
| Josh|weak|asis|f2 | Ryan McBride / - | above_promise | 401 | above_promise 4070 (pro 0.0, rep 4.67); above_favour 3669 (pro 0.0, rep 4.47); above_asis 2995 (pro 0.0, rep 3.62); wait 2531 (pro 0.0, rep 3.27) |
| Josh|weak|chase|f0 | (none legal) / Ryan McBride | wait | 35 | wait 15480 (pro 38.0, rep 2.71); below 15444 (pro 37.9, rep 2.74) |
| Josh|weak|chase|f1 | (none legal) / Ryan McBride | wait | 268 | wait 15600 (pro 38.3, rep 2.82); below 15332 (pro 37.5, rep 2.79) |
| Josh|weak|chase|f2 | (none legal) / Ryan McBride | below | 91 | below 15391 (pro 37.9, rep 2.60); wait 15300 (pro 37.6, rep 2.61) |
| Josh|strong|asis|f0 | Ryan McBride / - | above_promise | 1453 | above_promise 5577 (pro 0.0, rep 8.14); above_asis 4124 (pro 0.0, rep 6.17); wait 3447 (pro 0.0, rep 5.24) |
| Josh|strong|asis|f1 | Ryan McBride / - | above_promise | 558 | above_promise 5516 (pro 0.0, rep 8.02); above_favour 4957 (pro 0.0, rep 7.45); above_asis 4018 (pro 0.0, rep 5.96); wait 3369 (pro 0.0, rep 5.08) |
| Josh|strong|asis|f2 | Ryan McBride / - | above_promise | 523 | above_promise 5409 (pro 0.0, rep 7.80); above_favour 4887 (pro 0.0, rep 7.31); above_asis 3998 (pro 0.0, rep 5.87); wait 3367 (pro 0.0, rep 5.07) |
| Josh|strong|chase|f0 | (none legal) / Ryan McBride | below | 265 | below 21464 (pro 53.7, rep 4.36); wait 21199 (pro 52.9, rep 4.33) |
| Josh|strong|chase|f1 | (none legal) / Ryan McBride | below | 366 | below 21597 (pro 54.0, rep 4.38); wait 21231 (pro 52.9, rep 4.42) |
| Josh|strong|chase|f2 | (none legal) / Ryan McBride | below | 186 | below 21326 (pro 53.2, rep 4.38); wait 21140 (pro 52.7, rep 4.34) |

## 10. Halls (V = cash + rep x $333; best 8 plans a club)

| club | options, best first |
|---|---|
| young | community/r2/sell: V3235 cash2831 rep1.21 full33% half0% short6% p10 1789<br>community/r1/sell: V2977 cash2756 rep0.66 full25% half0% short17% p10 1759<br>community/r0/sell: V2436 cash2526 rep-0.27 full13% half0% short39% p10 1569<br>community/r2/keep: V2340 cash2232 rep0.32 full11% half0% short6% p10 1190<br>community/r1/keep: V2108 cash2157 rep-0.15 full6% half1% short17% p10 1160<br>community/r0/keep: V1623 cash1927 rep-0.91 full2% half7% short39% p10 970<br>gym/r1/keep: V689 cash-230 rep2.76 full100% half0% short12% p10 -320<br>gym/r1/sell: V689 cash-231 rep2.76 full100% half0% short12% p10 -320 |
| mid | community/r2/sell: V4226 cash3469 rep2.28 full60% half0% short6% p10 2359<br>community/r1/sell: V4021 cash3427 rep1.78 full53% half0% short17% p10 2319<br>community/r0/sell: V3527 cash3230 rep0.89 full42% half0% short39% p10 2139<br>community/r2/keep: V3432 cash2945 rep1.46 full39% half0% short6% p10 1760<br>community/r1/keep: V3196 cash2876 rep0.96 full33% half0% short17% p10 1720<br>community/r0/keep: V2658 cash2650 rep0.03 full21% half0% short39% p10 1540<br>town/r2/sell: V1793 cash2263 rep-1.41 full0% half31% short8% p10 1099<br>town/r1/sell: V1539 cash2183 rep-1.94 full0% half38% short21% p10 1049 |
| grown | town/r2/sell: V6861 cash5903 rep2.88 full51% half0% short8% p10 4069<br>town/r1/sell: V6626 cash5840 rep2.36 full46% half0% short21% p10 4029<br>town/r0/sell: V6120 cash5626 rep1.48 full39% half0% short42% p10 3859<br>town/r2/keep: V6036 cash5343 rep2.08 full37% half0% short8% p10 3470<br>town/r1/keep: V5791 cash5264 rep1.58 full33% half0% short21% p10 3430<br>community/r2/sell: V5623 cash4328 rep3.89 full100% half0% short6% p10 4139<br>community/r1/sell: V5620 cash4403 rep3.65 full100% half0% short17% p10 4099<br>community/r0/sell: V5474 cash4431 rep3.13 full98% half0% short39% p10 3929 |

## 11. Boxer C (after the cache fix) and the rank number

| cell | best | gap $ | options |
|---|---|---|---|
| Lucy|safe_steady | novice | 1020 | novice V2166, next bout win 33.9, morale 71/54; leave V1146, next bout win 33.9, morale 58 |
| Lucy|safe_flat | novice | 1018 | novice V2160, next bout win 33.8, morale 54/37; leave V1141, next bout win 33.7, morale 41 |
| Lucy|tight | novice | 1017 | novice V2164, next bout win 33.8, morale 54/36; leave V1146, next bout win 33.9, morale 68 |
| Kira|safe_steady | novice | 1020 | novice V2381, next bout win 40.2, morale 71/50; leave V1361, next bout win 40.2, morale 58 |
| Kira|safe_flat | novice | 1003 | novice V2310, next bout win 39.4, morale 54/33; leave V1307, next bout win 38.6, morale 41 |
| Kira|tight | novice | 939 | novice V2300, next bout win 37.8, morale 47/26; leave V1361, next bout win 40.2, morale 68 |
| Josh|safe_steady | novice | 1020 | novice V3140, next bout win 62.7, morale 71/52; leave V2120, next bout win 62.7, morale 58 |
| Josh|safe_flat | novice | 1008 | novice V3092, next bout win 62.1, morale 54/35; leave V2084, next bout win 61.6, morale 41 |
| Josh|tight | novice | 1002 | novice V3122, next bout win 62.1, morale 52/33; leave V2120, next bout win 62.7, morale 68 |

| rank cell | printed | measured | diff |
|---|---|---|---|
| Lucy|weak|chase|Erin Doyle | 17.3 | 17.2 | 0.11 |
| Lucy|weak|chase|Priya Nair | 17.6 | 17.4 | 0.18 |
| Lucy|strong|chase|Erin Doyle | 36.1 | 36.6 | -0.47 |
| Lucy|strong|chase|Priya Nair | 36.8 | 36.8 | -0.08 |
| Kira|weak|chase|Nina Kowalski | 86.8 | 87.2 | -0.41 |
| Kira|strong|chase|Nina Kowalski | 88.9 | 89.1 | -0.13 |
| Josh|weak|chase|Ryan McBride | 38.7 | 38.4 | 0.36 |
| Josh|strong|chase|Ryan McBride | 18.6 | 19.1 | -0.52 |

No critic brief was written: the probe failed, so per TASK_HOSTPROBE2 step 3 the map goes back for the changes in s7 and a
third probe before any critic sees it.
