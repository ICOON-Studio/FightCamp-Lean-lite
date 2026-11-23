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

## 4. Run
1. Smoke: `stage=road seeds=1 boxers=0` (one career, 12 s, 0 script errors): the pre-bout points are recorded.
2. `stage=road seeds=24` (S541, 1,348 s, 144 careers = 6 people x 24 seeds, 0 script errors) -> E:/FightCamp/tmp/hostprobe5/road.jsonl.
   Item 5 worked: **24 distinct careers out of 24 for every person** (HOSTPROBE4: Tess identical on all 24).
3. **The calibration (s2's procedure, seeds 0-7):** W_BELOW 0.5, 0.6 and 0.7 fail B8 on the calibration seeds (Danny, Kira and
   Samira called 2.5-4 bouts late); **0.8 passes for all six -> W_BELOW = 0.8**, set in tools/hostprobe5_rules.gd before stage 4.
   A fault found and fixed here, before the card stage: my first read of the road counted only the wins boxed after signing,
   so the record a boxer brings at signing (Lucy 3-1) was missing and every weight looked hopeless. Those wins now count whole,
   as the built rule counts them. A card run started at 0.5 under the faulty read was stopped after about 30 s, before it
   wrote anything; nothing from it is used.
4. `stage=all rolls=2000` (835 s, seed 5390, 0 script errors) -> E:/FightCamp/tmp/hostprobe5/run2000.jsonl: 108 card cells x
   2,000 rolls, 8,000 nights per hall option, 20,000 seeds per rank cell. Favours: HOSTPROBE4's stage (s1 c).
Command: `python ops/Tools/godot_slot.py run --who HOSTPROBE5 -- <godot> --headless --audio-driver Dummy --path . --script
res://tools/hostprobe5.gd -- stage=<road|all> ...`. The tables below come from two small Python reads of the jsonl (the s2
rules, scratch only).

## 5. Verdict: FAIL - 6 of 9 bars pass (B2, B3, B4, B6, B9, A1)

| Bar | Result | Measured |
|---|---|---|
| B1 favours | **FAIL** | earned 2.94 a year, the show spends 2.75 (HOSTPROBE4, unchanged rules: pass), but "as it is" beats "with a favour" in only **12 of 48** cells (the bar: 16). The favour won where the yes now carries the night (Josh: the only tile, +$424-$841; Lucy: the call or the full house) |
| B2 hall read | pass | the read names the measured best for all three clubs: young and mid Community, grown Town (read $6,838 against measured $6,926). No "close" |
| B3 routes | pass | best counts (108 cells): **below 36 (33 in 100)**, favour 24, promise 19, as it is 17, wait 12. Per club below 13 / 14 / 9 of 36 |
| B4 two reserves | pass | 2 reserves best for every club x hall (6 of 6) |
| B6 rank number | pass | 8 of 8 within 0.52 (rule unchanged) |
| B8 pro call on the road | **FAIL** (1 of 6 people) | test seeds 8-23 at W_BELOW 0.8: Danny, Josh, Kira, Samira and Tess within 0-1.5 bouts, called by bout 24 in 100 of 100; **Lucy: median bout of the call 14 against the built 11.5** (+2.5; she wins 77 in 100 of her bouts against names below) |
| B9 a reason to ask up | pass | **17 of 18** chase cells: "above as it is" gives 3+ in 100 more pro offer than "below" (young 6/6, mid 5/6, grown 6/6). HOSTPROBE4: 0 of 6 |
| A1 no route over 6 of 10 | pass | top: below 36 of 108 (33 in 100) |
| A3 best beats lazy by $1,000 in half | **FAIL** | **14 of 108** (13 in 100; per club 6 / 6 / 2 of 36). All 14 are Josh's promise (a boxer far from the call with one beatable name above). Median lead over the lazy ask: $174; the lazy ask is best in 41 of 108 |

B7 (cut list): nothing is cut. Smallest best edges: favour $2, below $8, wait $22, as it is $94, promise $160 - every route has
cells where it is barely best, and cells where it is best by $300+.

## 6. What is real, what is solved, what is worthless
**Solved by v8:** the reason to ask up (B9: from 0 of 6 to 17 of 18 - only a win over a name above counts whole), below's
over-safety (B3: below best in 33 in 100, from 56), the signing-day variation (24 distinct careers). The hall read, reserves
and rank number stay solved, and stay reads.
**Broken:** the pro call's timing for a leader (B8: Lucy +2.5 bouts), and the favour's price now that the yes carries the
night (B1). **Still thin:** the card's lead over the lazy ask (A3 13 in 100 - worse than HOSTPROBE4's 22).

**Why (read in the runs):**
1. **The game's own boxers rarely beat a name above them.** Over 144 careers only 7-26 in 100 of the wins were over a name above
   on ladder points (Danny 7, Josh 12, Kira 14, Samira 21, Lucy 23, Tess 26): the game's offers (Bouts) mostly come from names
   below a winning boxer. So ANY discount on a win below moves the call for boxers who never touch the show: at 0.5 three
   people move 3-4 bouts, at 0.8 the leader still moves 2.5. And a BONUS for a win above instead (read off the same careers,
   information only, not a bar) keeps the timing exactly (1.25: all six medians unchanged) but then a win below at 6 counted
   wins still brings the call, which is B9's failure. **B8 and B9 pull against each other for any pro-call rule:** to make a
   win below NOT bring the call at the line while ordinary careers (mostly wins below) keep their timing, the rule would need to
   know who used the show.
2. **The favour got stronger because the night got real.** Valuing the card on the night (item 3) put $2,000-$4,000 on the
   main event's yes at Town and on the call at the chase. +2 in 10 for $160 is then cheap; "as it is" wins only for Kira (the
   name above beats her) and in a few grown-club chase cells.
3. **A3 is structural.** 36 of 108 cells have no legal name above (the novice rule): the lazy ask is "below", the only other
   route is "wait", and they can never pass. Where a name above exists, "ask up as it is" carries the main event AND the counted
   win, so the alternatives (a favour, a promise, the safer name) move the value by $100-$600. Only the promise, for a boxer far
   from the call, is a $1,000 choice. The hall tie made the lazy ask BETTER (it gets the bigger posters too): grown club 2 of 36.

## 7. What to change, and can it reach 8 (task step 4)
**This is the third FAIL in a row** (v6 5/9, v7 5/9, v8 6/9; HOSTPROBE2-4 before it).
**Can the card reach 8? My answer: no, not as a matchmaking card.** The evidence across five probes: A3 has failed every round
(HOSTPROBE2 27 of 108, HOSTPROBE3 14 of 36, HOSTPROBE4 8 of 36, HOSTPROBE5 14 of 108) and the reason is the same each time: the
card's routes differ by a few hundred dollars except the promise, and a third of the cells have no name above at all. The pro
call cannot carry it either: the game's own careers make B8 and B9 contradict each other (s6 item 1). The parts that work are
READS (which hall, two reserves, the rank number), not decisions. Per the owner's rule (S534: under 8 -> his cut-or-keep call,
never removed silently) this goes to him.
**My recommendation for his call: keep the club show as a LIGHT MONEY NIGHT, cut the five-route card.** Keep: pick the date, the
hall read (books the hall that pays, one click), two standby reserves by default, the night's sheet, and the built "top of our
show" boxer (HomeBout, S488) as the one main event. Cut: above / favour / promise / below / wait per boxer, the late no, the
weighed pro call (Roster.pro_ready stays as built). It is a few minutes' play three times a year, honest about being light.
**If he wants to keep trying instead, the next round must change the measure, not the numbers:**
1. Give the card a choice the lazy ask gets wrong: e.g. the main event costs a purse that scales with the hall (the name above
   asks for money at Town), so asking up has a price the lazy bot ignores. ESTIMATE, probe.
2. Drop the pro-call lever from the show (s6 item 1: no rule passes B8 and B9 together on the game's own careers).
3. Re-price the favour against the night it now buys (+1 in 10, or the favour buys a yes only from the name below).
4. The 36 cells without a name above need their own route (an out-of-region name) or should leave the card's count.
No critic brief was written: the probe failed, so per TASK_HOSTPROBE5 step 3 the map stops here for the owner's call.

## 8. Limits
- Card stage as HOSTPROBE4 (fixed bots, BoutRead.chance for ours, WorldBout.fast for rivals, 20 in 100 of our losses
  stoppages, our night plus one next bout), now with the night (one other home boxer at 5 wins, our own bout never pulled).
- The chase cell is "one counted win from the call" (6.0); an as-is boxer counts every win. The road's bot takes every legal
  bout and never asks up (the game's ordinary career); the pro offer is cleared each day (no declines).
- ESTIMATES: the late-no chance (1 in 2), late yes (7 in 10), below's yes 8 in 10, +12 posters below, Town main event +48.

## 9. Tables

**The road: built rule / v8 at W_BELOW 0.8 (test seeds 8-23, 16 careers a person)**

| Person | Careers | called in 100 | by bout 24 in 100 | median bout of the call | wins over a name above, in 100 | B8 |
|---|---|---|---|---|---|---|
| Danny Osei | 16 | 100 / 100 | 100 / 100 | 8.5 / 10 | 7 | pass |
| Josh Harper | 16 | 100 / 100 | 100 / 100 | 10 / 10 | 12 | pass |
| Kira Mensah | 16 | 100 / 100 | 100 / 100 | 9 / 10 | 14 | pass |
| Lucy Jackson | 16 | 100 / 100 | 100 / 100 | 11.5 / 14 | 23 | **FAIL** |
| Samira Khan | 16 | 100 / 100 | 100 / 100 | 13.5 / 14 | 21 | pass |
| Tess Reilly | 16 | 100 / 100 | 100 / 100 | 12 / 12 | 26 | pass |

**The calibration grid: median bout of the call, built / v8 (X = fails B8)**

| Person | cal 0.5 | cal 0.6 | cal 0.7 | cal 0.8 | test 0.5 | test 0.6 | test 0.7 | test 0.8 |
|---|---|---|---|---|---|---|---|---|
| Danny Osei | 9/12 X | 9/11.5 X | 9/11 | 9/10 | 8.5/12 X | 8.5/11 X | 8.5/11 X | 8.5/10 |
| Josh Harper | 10/12 | 10/12 | 10/11 | 10/11 | 10/11.5 | 10/11.5 | 10/10 | 10/10 |
| Kira Mensah | 9/13 X | 9/12 X | 9/11.5 X | 9/10.5 | 9/13 X | 9/12 X | 9/11 | 9/10 |
| Lucy Jackson | 13.5/14.5 | 13.5/14.5 | 13.5/14.5 | 13.5/14.5 | 11.5/14.5 X | 11.5/14.5 X | 11.5/14 X | 11.5/14 X |
| Samira Khan | 13.5/17 X | 13.5/16.5 X | 13.5/15.5 | 13.5/15 | 13.5/14.5 | 13.5/14.5 | 13.5/14 | 13.5/14 |
| Tess Reilly | 12/12 | 12/12 | 12/12 | 12/12 | 12/12 | 12/12 | 12/12 | 12/12 |

**Hall read (expected night, main event booked) against measured**

| club | read names | read: Community V | read: Town V | measured best (Community / Town, 2 reserves) | gap $ |
|---|---|---|---|---|---|
| young | community | 2394 | 575 | community (2340 / 564) | 0 |
| mid | community | 3412 | 1837 | community (3432 / 1861) | 0 |
| grown | town | 5211 | 6838 | town (5440 / 6926) | 0 |

| club | hall | reserves | V | cash | rep | full / half / short in 100 | bad night (p10) |
|---|---|---|---|---|---|---|---|
| young | community | 0 | 1623 | 1927 | -0.91 | 2 / 7 / 39 | 970 |
| young | community | 1 | 2108 | 2157 | -0.15 | 6 / 1 / 17 | 1160 |
| young | community | 2 | 2340 | 2232 | 0.32 | 11 / 0 / 6 | 1190 |
| young | town | 0 | -248 | 1114 | -4.09 | 0 / 81 / 42 | 90 |
| young | town | 1 | 291 | 1345 | -3.17 | 0 / 68 / 21 | 280 |
| young | town | 2 | 564 | 1426 | -2.59 | 0 / 61 / 8 | 320 |
| mid | community | 0 | 2658 | 2650 | 0.03 | 21 / 0 / 39 | 1540 |
| mid | community | 1 | 3196 | 2876 | 0.96 | 33 / 0 / 17 | 1720 |
| mid | community | 2 | 3432 | 2945 | 1.46 | 39 / 0 / 6 | 1760 |
| mid | town | 0 | 1112 | 2020 | -2.73 | 0 / 47 / 42 | 810 |
| mid | town | 1 | 1616 | 2249 | -1.90 | 0 / 37 / 21 | 990 |
| mid | town | 2 | 1861 | 2329 | -1.40 | 0 / 31 / 8 | 1040 |
| grown | community | 0 | 5110 | 4220 | 2.67 | 86 / 0 / 39 | 3330 |
| grown | community | 1 | 5370 | 4240 | 3.39 | 93 / 0 / 17 | 3500 |
| grown | community | 2 | 5440 | 4188 | 3.76 | 97 / 0 / 6 | 3540 |
| grown | town | 0 | 6217 | 5684 | 1.60 | 41 / 0 / 42 | 3790 |
| grown | town | 1 | 6705 | 5886 | 2.46 | 48 / 0 / 21 | 3970 |
| grown | town | 2 | 6926 | 5941 | 2.96 | 52 / 0 / 8 | 4000 |

**Card cells (value $ = night cash + rep x $333 + members x $100 + pro offer x $333 a point + $450 a next bout + favours x $160;
routes best first; chase cells show the pro offer in 100)**

| cell (club / boxer / form / record / favours) | hall | above / below | best | gap $ to 2nd | lead $ over lazy | routes |
|---|---|---|---|---|---|---|
| young|Lucy|weak|asis|f0 | community | Maria Ortega / Aisha Rahman | asis | 228 | 0 | asis 4175; below 3947; wait 3599; prom 2954 |
| young|Lucy|weak|asis|f1 | community | Maria Ortega / Aisha Rahman | fav | 32 | 32 | fav 4186; asis 4154; below 3900; wait 3546; prom 2949 |
| young|Lucy|weak|asis|f2 | community | Maria Ortega / Aisha Rahman | fav | 18 | 18 | fav 4182; asis 4165; below 3929; wait 3574; prom 2917 |
| young|Lucy|weak|chase|f0 | community | Erin Doyle / Priya Nair | asis | 994 | 0 | asis 8312 (pro 14.3); below 7318 (pro 10.6); prom 7088 (pro 15.9); wait 6944 (pro 10.5) |
| young|Lucy|weak|chase|f1 | community | Erin Doyle / Priya Nair | fav | 281 | 281 | fav 9234 (pro 17.5); asis 8953 (pro 16.2); below 8187 (pro 13.1); wait 7756 (pro 12.9); prom 7397 (pro 16.7) |
| young|Lucy|weak|chase|f2 | community | Erin Doyle / Priya Nair | fav | 126 | 126 | fav 8802 (pro 16.1); asis 8676 (pro 15.2); below 7658 (pro 11.4); wait 7370 (pro 11.6); prom 6791 (pro 15.0) |
| young|Lucy|strong|asis|f0 | community | Maria Ortega / Aisha Rahman | asis | 486 | 0 | asis 5166; below 4680; prom 4540; wait 4132 |
| young|Lucy|strong|asis|f1 | community | Maria Ortega / Aisha Rahman | fav | 162 | 162 | fav 5292; asis 5129; below 4642; prom 4547; wait 4129 |
| young|Lucy|strong|asis|f2 | community | Maria Ortega / Aisha Rahman | fav | 180 | 180 | fav 5367; asis 5187; below 4681; prom 4595; wait 4112 |
| young|Lucy|strong|chase|f0 | community | Erin Doyle / Priya Nair | asis | 544 | 0 | asis 14982 (pro 32.1); prom 14438 (pro 33.4); below 13595 (pro 27.4); wait 13127 (pro 27.1) |
| young|Lucy|strong|chase|f1 | community | Erin Doyle / Priya Nair | fav | 416 | 416 | fav 15911 (pro 35.4); asis 15495 (pro 33.6); prom 14917 (pro 34.6); below 14454 (pro 29.6); wait 14033 (pro 29.5) |
| young|Lucy|strong|chase|f2 | community | Erin Doyle / Priya Nair | fav | 495 | 495 | fav 15570 (pro 34.3); asis 15075 (pro 32.3); prom 14936 (pro 34.6); below 13798 (pro 27.8); wait 13423 (pro 27.8) |
| young|Kira|weak|asis|f0 | community | Grace Adeyemi / Megan Price | below | 397 | 462 | below 2253; wait 1856; asis 1792; prom 912 |
| young|Kira|weak|asis|f1 | community | Grace Adeyemi / Megan Price | below | 412 | 460 | below 2302; wait 1890; asis 1841; fav 1622; prom 923 |
| young|Kira|weak|asis|f2 | community | Grace Adeyemi / Megan Price | below | 424 | 504 | below 2326; wait 1902; asis 1823; fav 1578; prom 899 |
| young|Kira|weak|chase|f0 | community | - / Nina Kowalski | wait | 741 | 741 | wait 4171 (pro 7.2); below 3430 (pro 3.9) |
| young|Kira|weak|chase|f1 | community | - / Nina Kowalski | wait | 487 | 487 | wait 3806 (pro 6.0); below 3319 (pro 3.5) |
| young|Kira|weak|chase|f2 | community | - / Nina Kowalski | wait | 463 | 463 | wait 3792 (pro 5.9); below 3329 (pro 3.5) |
| young|Kira|strong|asis|f0 | community | Grace Adeyemi / Megan Price | below | 361 | 361 | below 3453; asis 3091; wait 3057; prom 2034 |
| young|Kira|strong|asis|f1 | community | Grace Adeyemi / Megan Price | below | 336 | 336 | below 3479; asis 3143; wait 3075; fav 2925; prom 2095 |
| young|Kira|strong|asis|f2 | community | Grace Adeyemi / Megan Price | below | 299 | 299 | below 3373; asis 3074; wait 2979; fav 2885; prom 2048 |
| young|Kira|strong|chase|f0 | community | - / Nina Kowalski | below | 199 | 0 | below 6845 (pro 11.5); wait 6647 (pro 11.9) |
| young|Kira|strong|chase|f1 | community | - / Nina Kowalski | wait | 22 | 22 | wait 6990 (pro 13.0); below 6968 (pro 11.8) |
| young|Kira|strong|chase|f2 | community | - / Nina Kowalski | below | 169 | 0 | below 6775 (pro 11.2); wait 6606 (pro 11.8) |
| young|Josh|weak|asis|f0 | community | Ryan McBride / - | prom | 1249 | 1249 | prom 5037; asis 3788; wait 3225 |
| young|Josh|weak|asis|f1 | community | Ryan McBride / - | prom | 749 | 1173 | prom 4931; fav 4182; asis 3757; wait 3195 |
| young|Josh|weak|asis|f2 | community | Ryan McBride / - | prom | 861 | 1341 | prom 5102; fav 4242; asis 3761; wait 3201 |
| young|Josh|weak|chase|f0 | community | - / Ryan McBride | below | 370 | 0 | below 12727 (pro 26.1); wait 12357 (pro 26.1) |
| young|Josh|weak|chase|f1 | community | - / Ryan McBride | below | 126 | 0 | below 12689 (pro 26.1); wait 12563 (pro 26.7) |
| young|Josh|weak|chase|f2 | community | - / Ryan McBride | below | 8 | 0 | below 12536 (pro 25.6); wait 12528 (pro 26.6) |
| young|Josh|strong|asis|f0 | community | Ryan McBride / - | prom | 1559 | 1559 | prom 6303; asis 4744; wait 4025 |
| young|Josh|strong|asis|f1 | community | Ryan McBride / - | prom | 871 | 1463 | prom 6320; fav 5449; asis 4858; wait 4099 |
| young|Josh|strong|asis|f2 | community | Ryan McBride / - | prom | 930 | 1541 | prom 6218; fav 5288; asis 4677; wait 3956 |
| young|Josh|strong|chase|f0 | community | - / Ryan McBride | below | 654 | 0 | below 18160 (pro 40.1); wait 17507 (pro 39.1) |
| young|Josh|strong|chase|f1 | community | - / Ryan McBride | wait | 149 | 149 | wait 18598 (pro 42.3); below 18449 (pro 40.8) |
| young|Josh|strong|chase|f2 | community | - / Ryan McBride | below | 236 | 0 | below 18459 (pro 40.8); wait 18223 (pro 41.1) |
| mid|Lucy|weak|asis|f0 | community | Maria Ortega / Aisha Rahman | asis | 265 | 0 | asis 5279; below 5014; wait 4588; prom 4124 |
| mid|Lucy|weak|asis|f1 | community | Maria Ortega / Aisha Rahman | fav | 18 | 18 | fav 5238; asis 5220; below 4983; wait 4565; prom 4108 |
| mid|Lucy|weak|asis|f2 | community | Maria Ortega / Aisha Rahman | fav | 12 | 12 | fav 5274; asis 5262; below 4950; wait 4540; prom 4136 |
| mid|Lucy|weak|chase|f0 | community | Erin Doyle / Priya Nair | asis | 719 | 0 | asis 9659 (pro 15.1); below 8940 (pro 12.1); wait 8510 (pro 12.1); prom 8328 (pro 16.4) |
| mid|Lucy|weak|chase|f1 | community | Erin Doyle / Priya Nair | fav | 166 | 166 | fav 10370 (pro 17.7); asis 10205 (pro 16.7); below 9641 (pro 14.1); wait 9244 (pro 14.2); prom 7813 (pro 14.8) |
| mid|Lucy|weak|chase|f2 | community | Erin Doyle / Priya Nair | fav | 156 | 156 | fav 9947 (pro 16.4); asis 9791 (pro 15.4); below 9028 (pro 12.3); wait 8541 (pro 12.1); prom 8489 (pro 16.8) |
| mid|Lucy|strong|asis|f0 | community | Maria Ortega / Aisha Rahman | asis | 591 | 0 | asis 6377; below 5786; prom 5779; wait 5178 |
| mid|Lucy|strong|asis|f1 | community | Maria Ortega / Aisha Rahman | fav | 174 | 174 | fav 6410; asis 6235; below 5704; prom 5639; wait 5119 |
| mid|Lucy|strong|asis|f2 | community | Maria Ortega / Aisha Rahman | fav | 141 | 141 | fav 6475; asis 6334; below 5730; prom 5685; wait 5168 |
| mid|Lucy|strong|chase|f0 | community | Erin Doyle / Priya Nair | prom | 174 | 174 | prom 15942 (pro 34.4); asis 15768 (pro 31.1); below 15010 (pro 28.1); wait 14577 (pro 28.1) |
| mid|Lucy|strong|chase|f1 | community | Erin Doyle / Priya Nair | fav | 256 | 256 | fav 17037 (pro 35.3); asis 16781 (pro 34.0); prom 16678 (pro 36.3); below 14902 (pro 27.8); wait 14397 (pro 27.7) |
| mid|Lucy|strong|chase|f2 | community | Erin Doyle / Priya Nair | fav | 234 | 565 | fav 16800 (pro 34.5); prom 16567 (pro 36.0); asis 16235 (pro 32.4); below 14990 (pro 28.0); wait 14537 (pro 28.0) |
| mid|Kira|weak|asis|f0 | community | Grace Adeyemi / Megan Price | below | 423 | 423 | below 3319; asis 2896; wait 2885; prom 2080 |
| mid|Kira|weak|asis|f1 | community | Grace Adeyemi / Megan Price | below | 415 | 415 | below 3389; asis 2974; wait 2939; fav 2765; prom 2116 |
| mid|Kira|weak|asis|f2 | community | Grace Adeyemi / Megan Price | below | 372 | 372 | below 3269; asis 2897; wait 2839; fav 2685; prom 2033 |
| mid|Kira|weak|chase|f0 | community | - / Nina Kowalski | wait | 588 | 588 | wait 5334 (pro 7.4); below 4746 (pro 4.3) |
| mid|Kira|weak|chase|f1 | community | - / Nina Kowalski | wait | 564 | 564 | wait 5161 (pro 7.2); below 4597 (pro 4.1) |
| mid|Kira|weak|chase|f2 | community | - / Nina Kowalski | wait | 302 | 302 | wait 4777 (pro 6.0); below 4475 (pro 3.9) |
| mid|Kira|strong|asis|f0 | community | Grace Adeyemi / Megan Price | below | 278 | 278 | below 4438; asis 4160; wait 4010; prom 3175 |
| mid|Kira|strong|asis|f1 | community | Grace Adeyemi / Megan Price | below | 328 | 328 | below 4509; asis 4181; wait 4085; fav 4018; prom 3173 |
| mid|Kira|strong|asis|f2 | community | Grace Adeyemi / Megan Price | below | 237 | 237 | below 4362; asis 4125; fav 3987; wait 3924; prom 3171 |
| mid|Kira|strong|chase|f0 | community | - / Nina Kowalski | below | 214 | 0 | below 7647 (pro 10.4); wait 7433 (pro 11.2) |
| mid|Kira|strong|chase|f1 | community | - / Nina Kowalski | below | 200 | 0 | below 7514 (pro 10.2); wait 7314 (pro 10.8) |
| mid|Kira|strong|chase|f2 | community | - / Nina Kowalski | below | 136 | 0 | below 8150 (pro 11.8); wait 8014 (pro 12.7) |
| mid|Josh|weak|asis|f0 | community | Ryan McBride / - | prom | 1285 | 1285 | prom 6216; asis 4932; wait 4290 |
| mid|Josh|weak|asis|f1 | community | Ryan McBride / - | prom | 720 | 1191 | prom 5986; fav 5266; asis 4795; wait 4162 |
| mid|Josh|weak|asis|f2 | community | Ryan McBride / - | prom | 779 | 1323 | prom 6134; fav 5354; asis 4811; wait 4190 |
| mid|Josh|weak|chase|f0 | community | - / Ryan McBride | below | 477 | 0 | below 13819 (pro 26.3); wait 13342 (pro 26.1) |
| mid|Josh|weak|chase|f1 | community | - / Ryan McBride | below | 516 | 0 | below 13785 (pro 26.2); wait 13270 (pro 25.8) |
| mid|Josh|weak|chase|f2 | community | - / Ryan McBride | below | 165 | 0 | below 13553 (pro 25.7); wait 13388 (pro 26.4) |
| mid|Josh|strong|asis|f0 | community | Ryan McBride / - | prom | 1754 | 1754 | prom 7565; asis 5812; wait 5031 |
| mid|Josh|strong|asis|f1 | community | Ryan McBride / - | prom | 997 | 1601 | prom 7421; fav 6424; asis 5821; wait 5026 |
| mid|Josh|strong|asis|f2 | community | Ryan McBride / - | prom | 937 | 1582 | prom 7542; fav 6605; asis 5960; wait 5135 |
| mid|Josh|strong|chase|f0 | community | - / Ryan McBride | below | 393 | 0 | below 19525 (pro 40.6); wait 19133 (pro 40.6) |
| mid|Josh|strong|chase|f1 | community | - / Ryan McBride | wait | 185 | 185 | wait 19694 (pro 42.3); below 19509 (pro 40.5) |
| mid|Josh|strong|chase|f2 | community | - / Ryan McBride | below | 492 | 0 | below 20082 (pro 42.3); wait 19590 (pro 42.0) |
| grown|Lucy|weak|asis|f0 | town | Maria Ortega / Aisha Rahman | asis | 1106 | 0 | asis 8619; below 7513; prom 7426; wait 7094 |
| grown|Lucy|weak|asis|f1 | town | Maria Ortega / Aisha Rahman | fav | 219 | 219 | fav 8941; asis 8723; below 7623; prom 7582; wait 7201 |
| grown|Lucy|weak|asis|f2 | town | Maria Ortega / Aisha Rahman | fav | 268 | 268 | fav 8934; asis 8666; below 7576; prom 7513; wait 7172 |
| grown|Lucy|weak|chase|f0 | town | Erin Doyle / Priya Nair | asis | 2084 | 0 | asis 13684 (pro 16.8); prom 11601 (pro 16.0); below 11599 (pro 12.1); wait 11219 (pro 12.2) |
| grown|Lucy|weak|chase|f1 | town | Erin Doyle / Priya Nair | asis | 160 | 0 | asis 14067 (pro 18.1); fav 13907 (pro 18.1); below 12130 (pro 13.7); wait 11769 (pro 13.8); prom 11740 (pro 16.2) |
| grown|Lucy|weak|chase|f2 | town | Erin Doyle / Priya Nair | asis | 160 | 0 | asis 13536 (pro 16.3); fav 13376 (pro 16.3); prom 11837 (pro 16.5); below 11616 (pro 12.0); wait 11130 (pro 11.8) |
| grown|Lucy|strong|asis|f0 | town | Maria Ortega / Aisha Rahman | asis | 669 | 0 | asis 9769; prom 9099; below 8323; wait 8018 |
| grown|Lucy|strong|asis|f1 | town | Maria Ortega / Aisha Rahman | fav | 332 | 332 | fav 10281; asis 9949; prom 9244; below 8406; wait 8173 |
| grown|Lucy|strong|asis|f2 | town | Maria Ortega / Aisha Rahman | fav | 355 | 355 | fav 10316; asis 9961; prom 9231; below 8477; wait 8187 |
| grown|Lucy|strong|chase|f0 | town | Erin Doyle / Priya Nair | asis | 861 | 0 | asis 20222 (pro 34.5); prom 19361 (pro 34.4); below 17880 (pro 28.7); wait 17445 (pro 28.7) |
| grown|Lucy|strong|chase|f1 | town | Erin Doyle / Priya Nair | fav | 188 | 188 | fav 20921 (pro 36.6); asis 20734 (pro 35.9); prom 19091 (pro 33.6); below 18045 (pro 29.1); wait 17516 (pro 28.9) |
| grown|Lucy|strong|chase|f2 | town | Erin Doyle / Priya Nair | fav | 234 | 234 | fav 19911 (pro 33.8); asis 19677 (pro 32.9); prom 19599 (pro 35.2); below 17343 (pro 27.3); wait 16973 (pro 27.4) |
| grown|Kira|weak|asis|f0 | town | Grace Adeyemi / Megan Price | asis | 206 | 0 | asis 6206; below 6000; wait 5538; prom 5534 |
| grown|Kira|weak|asis|f1 | town | Grace Adeyemi / Megan Price | asis | 131 | 0 | asis 6211; fav 6080; below 5930; prom 5527; wait 5480 |
| grown|Kira|weak|asis|f2 | town | Grace Adeyemi / Megan Price | asis | 94 | 0 | asis 6208; fav 6113; below 5899; prom 5512; wait 5462 |
| grown|Kira|weak|chase|f0 | town | - / Nina Kowalski | wait | 506 | 506 | wait 7566 (pro 6.2); below 7060 (pro 3.4) |
| grown|Kira|weak|chase|f1 | town | - / Nina Kowalski | wait | 330 | 330 | wait 7477 (pro 6.3); below 7147 (pro 4.0) |
| grown|Kira|weak|chase|f2 | town | - / Nina Kowalski | wait | 286 | 286 | wait 7420 (pro 5.9); below 7134 (pro 3.7) |
| grown|Kira|strong|asis|f0 | town | Grace Adeyemi / Megan Price | asis | 363 | 0 | asis 7389; below 7026; wait 6597; prom 6586 |
| grown|Kira|strong|asis|f1 | town | Grace Adeyemi / Megan Price | fav | 6 | 6 | fav 7424; asis 7418; below 7063; prom 6636; wait 6619 |
| grown|Kira|strong|asis|f2 | town | Grace Adeyemi / Megan Price | fav | 2 | 2 | fav 7457; asis 7454; below 7113; wait 6666; prom 6626 |
| grown|Kira|strong|chase|f0 | town | - / Nina Kowalski | below | 216 | 0 | below 10580 (pro 11.6); wait 10364 (pro 12.2) |
| grown|Kira|strong|chase|f1 | town | - / Nina Kowalski | below | 181 | 0 | below 10390 (pro 10.8); wait 10209 (pro 11.6) |
| grown|Kira|strong|chase|f2 | town | - / Nina Kowalski | below | 171 | 0 | below 11020 (pro 12.5); wait 10849 (pro 13.3) |
| grown|Josh|weak|asis|f0 | town | Ryan McBride / - | prom | 809 | 809 | prom 9486; asis 8677; wait 7218 |
| grown|Josh|weak|asis|f1 | town | Ryan McBride / - | prom | 160 | 785 | prom 9508; fav 9348; asis 8722; wait 7268 |
| grown|Josh|weak|asis|f2 | town | Ryan McBride / - | prom | 160 | 883 | prom 9447; fav 9287; asis 8564; wait 7168 |
| grown|Josh|weak|chase|f0 | town | - / Ryan McBride | below | 585 | 0 | below 16578 (pro 26.5); wait 15993 (pro 25.9) |
| grown|Josh|weak|chase|f1 | town | - / Ryan McBride | below | 323 | 0 | below 16453 (pro 26.4); wait 16130 (pro 26.6) |
| grown|Josh|weak|chase|f2 | town | - / Ryan McBride | below | 224 | 0 | below 16172 (pro 25.4); wait 15948 (pro 25.9) |
| grown|Josh|strong|asis|f0 | town | Ryan McBride / - | prom | 1070 | 1070 | prom 10937; asis 9867; wait 8149 |
| grown|Josh|strong|asis|f1 | town | Ryan McBride / - | prom | 160 | 978 | prom 10942; fav 10782; asis 9964; wait 8186 |
| grown|Josh|strong|asis|f2 | town | Ryan McBride / - | prom | 160 | 1001 | prom 10846; fav 10686; asis 9846; wait 8162 |
| grown|Josh|strong|chase|f0 | town | - / Ryan McBride | below | 279 | 0 | below 22096 (pro 40.5); wait 21817 (pro 40.8) |
| grown|Josh|strong|chase|f1 | town | - / Ryan McBride | below | 323 | 0 | below 22080 (pro 40.5); wait 21756 (pro 40.8) |
| grown|Josh|strong|chase|f2 | town | - / Ryan McBride | below | 493 | 0 | below 21794 (pro 39.8); wait 21301 (pro 39.5) |

**Rank number (No. 3 or better, in 100)**

| cell | printed | measured | diff |
|---|---|---|---|
| Lucy|weak|chase|Erin Doyle | 17.3 | 17.2 | 0.10 |
| Lucy|weak|chase|Priya Nair | 17.6 | 17.4 | 0.20 |
| Lucy|strong|chase|Erin Doyle | 36.1 | 36.6 | -0.50 |
| Lucy|strong|chase|Priya Nair | 36.8 | 36.8 | 0.00 |
| Kira|weak|chase|Nina Kowalski | 86.8 | 87.2 | -0.40 |
| Kira|strong|chase|Nina Kowalski | 88.9 | 89.1 | -0.20 |
| Josh|weak|chase|Ryan McBride | 38.7 | 38.4 | 0.30 |
| Josh|strong|chase|Ryan McBride | 18.6 | 19.1 | -0.50 |

**Favours a year:** HOSTPROBE4's stage (unchanged rules, same seed): hoard bot earned 2.94; use bot earned 2.92, spent 2.75.
