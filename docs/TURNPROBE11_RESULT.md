# TURNPROBE11 RESULT - map v11 of turning pro, measured before any critic scores it

S534, TURNPROBE11 side console. Task: `ops/research/TASK_TURNPROBE11.md`. Map: `ops/research/DESIGN_TURNPRO1_V11.md` (its probe is
section 9). Measurement only: nothing under `scripts/` was touched. v11's numbers are a flagged local copy,
`tools/turnprobe11_rules.gd`; the runner is `tools/turnprobe11.gd`; the tables come from `tools/turnprobe11_sum.py`.

## 1. Verdict: FAIL. v11 turns one answer into no difference

1. **Today's fault is real and the probe sees it.** On today's rules the guarantee house is best on money in 6 of 6 cells
   (33 of 36 boxer by boxer) and its costs ask is the best option every time: worth $909 in a healthy gym, $1,128 in a crunch.
2. **v11 removes that lead and puts nothing measurable in its place.** Under v11 no option differs from the plain guarantee
   house by more than $400 of gym cash over 40 weeks, and the error on each of those gaps is about $215. One career's cash
   swings about $1,700 on the fights that follow. The houses read "balanced" only because the gap is inside the noise.
3. **The money in the fork is too small to be a choice.** The gym keeps a quarter. On the night the ticket house pays the
   gym $2 to $77 more than the guarantee house; the ticket ask adds $13 at most (and costs $2 at 72 seats); the guarantee purse at $1,800 against $1,400
   is $104. Against a 40-week cash fall of $6,300 to $11,300 none of these can be felt.
4. **Members, morale and loyalty wash out.** By week 40 every option sits within 2 members, within a few morale points
   (24 to 33 for everybody) and within 2 loyalty of every other. The crowd by seats, the forgiven loss and the wish change
   nothing that lasts.
5. **What is real:** the debut itself (56 wins in 100 at the ticket house, 76 at the guarantee house; 25 losses against
   10), the softer opponent (+4.7 wins in 100) and the house's lean on the first six pro fights (it changes the pick in 44%
   of offer sets at the ticket house, 20% at the guarantee house). The fork should be built on those, not on the purse.

Bars passed outright: 4 of 15, one more in part (section 3). The map does not go to critics as it stands.

## 2. What was run

- **Population.** The six people the game can sign (Lucy Jackson, Kira Mensah, Samira Khan, Tess Reilly, Danny Osei, Josh
  Harper: four women, two men, five styles, both stances), each played from signing to the first pro call by a bot that
  takes every legal bout. Each is then called on up to four days a week apart. A bout's dice are the fight day's, never the
  career seed, so a "seed" is not a roll: a call day is. Two call days of five boxers landed on one day (the boxer was
  booked) and are counted once: **19 different rolls** (Kira 4, the others 3). The tool now refuses two calls on one day.
- **Cells.** Seats on the day of the call 48, 56, 64, 72 (members set so the forecast reads that; the gym's reputation set
  to carry them) x gym: healthy ($12,000) at all four, crunch ($1,000, under the signing costs) at 48 and 64. Six pooled
  cells of 19 rolls an option; 36 cells boxer by boxer.
- **Arms.** CONTROL = today's rules through the game's own functions (ticket: no ask, own price; guarantee: no ask,
  costs). V11 = the map's sections 3 to 5 (ticket: no ask, own price, softer, later +2; guarantee: no ask, later +2, and
  costs in a crunch). MUTANT = v11 with the guarantee purse back at $1,800. NOWISH = v11 with the wish off (first call day).
- **Every option is played from the call to week 40:** sign, camp, debut, then the pro ladder (the bot books the offered
  fight read nearest 65 in 100). 1,838 careers played, 1,498 counted after the repeated days. Stage A: 42 rows of 200
  scratch nights (8,400 bouts) at 60 seats.
- **Made cases** (Lucy and Danny, 56 seats, three call days): the crunch at 52 loyalty; a healthy gym with the boxer on a
  day job.
- **Not run, against the map's section 9** (PC time; say so before trusting a cell that is missing): 10 seeds a cell (19
  rolls shared by a cell's seats instead), a full-gym cell, a separate "runway under 8 weeks" cell, the wish beyond the
  boxers' own (five of six want the test; day job on two), today's later, softer and split asks (TURNPROBE3B: never best).
  The debutants' threat words are unchanged (the map marks them CHECK). The costs fee is $100 in every crunch.

## 3. The bars

| # | Bar | Reads | Verdict |
|---|---|---|---|
| 1 | v11: CONTROL must read the guarantee house right in 85%+ of cells, the ticket house under 30% | On the map's pass rule: ticket 100%, guarantee 50%. On money: guarantee 6 of 6 (33 of 36 boxer by boxer), ticket 0 | **FAIL on the pass rule: "the probe cannot see the fault".** The rule is 0% for most options (below). Money sees the fault, so the rest is judged on money |
| 2 | v11: each house right in 30 to 70% of cells, right alone in 15%+ | Pass rule: ticket 100%, guarantee 50%, guarantee alone 0%. Money: ticket 4 of 6 pooled, 18 of 36 boxer by boxer | **FAIL on the pass rule. In band on money, but the gap is $288 with an error of $215: not a measured difference** |
| 3 | v11: at any seat count 52 to 68 neither house right in more than 85% | Money, boxer by boxer: 56 seats ticket 4 of 6; 64 seats ticket 5, guarantee 7 of 12 | PASS |
| 4 | v11: each ask right in at least one cell and wrong in at least one | Softer: best in 0 of 36. Own price 11, ticket later 7, guarantee later 3 of 36; costs 8 of 12 | **FAIL** (softer) |
| 5 | v11: "no ask" right in at least one cell a house | Ticket no ask: 0 of 36. Guarantee no ask: 7 of 36 | **FAIL** (ticket) |
| 6 | v11: the costs ask never in a healthy cell; in a crunch right in under 100%; wrong at 52 loyalty | Never shown healthy (by rule). Crunch: 8 of 12. At 52 loyalty the gym keeps 10% and it is still $338 ahead; the gym closes either way | **FAIL** (52 loyalty does not make it wrong) |
| 7 | v11: the wished house right more often than with no wish, and not always | Same pass rate, cash and pro wins with the wish on or off; morale 3 points apart by week 40, loyalty 1 | **FAIL** (no effect) |
| 8 | v11: played debut wins 52 to 68 (ticket), 70 to 82 (guarantee); four boxers in five within 10 of target | 55.8 and 75.5; 6 of 6 and 5 of 6 | PASS |
| 9 | v11: Later +2 shows +1 to +4; played gain not below 0 | Card +2.0; played +2.5 (ticket), +0.7 (guarantee) | PASS |
| 10 | v11: the lean changes the pick in 10%+ of offer sets, or the card line is cut | 44% of sets (ticket), 20% (guarantee) | PASS: the line is KEPT |
| 11 | v11: the MUTANT ($1,800) must fail bar 2 | It reads as v11 does: $104 more cash, 1 more loyalty, the same house tallies | **FAIL: the instrument cannot tell $1,400 from $1,800, and neither will a player** |
| 12 | Audit: no house best in more than 6 cells of 10 | Ticket house 4 of 6 pooled (67%), 18 of 36 boxer by boxer (50%) | **FAIL pooled, pass boxer by boxer; inside the noise either way** |
| 13 | Audit: no ask best in more than 6 cells of 10 | Ticket later +2: 4 of 6 pooled (it boxes on the guarantee house's Saturdays, which rolled better); 7 of 36 boxer by boxer. Costs: 8 of 12 where shown | **FAIL** |
| 14 | Audit: each ask best somewhere | Softer and the ticket house's no ask: never | **FAIL** |
| 15 | Audit: best against laziest worth 3+ wins in 100 or real money | Money: no. Wins: the house is 20 debut wins in 100, softer 4.7 | **FAIL on money; PASS on debut wins for the house and for softer** |

**The map's pass rule** ("a second pro fight booked within 16 weeks of the debut with cash at or above the day of the
call, and the boxer still here at week 40") reads 0% for most options in both arms. The second fight is booked in 100% of
healthy careers and the boxer is always still here; what fails is the cash line. The gym's cash falls every week whatever
is signed (the bot does not run the gym), and the second fight is booked about two weeks after the debut, so the line
reads which side of the monthly rent that day fell on. That is why the ticket house (debut two weeks earlier) "passes" at
64 and 72 seats and the guarantee house never does. It is a calendar, not a contract.

## 4. The numbers behind the verdict

**Each option against the plain guarantee house on the same call** (gym cash by week 40; the error is one standard error;
healthy = 76 pairs on 19 rolls, crunch = 38 pairs):

| Rules | Gym | Option | Cash against guarantee no ask | Pro wins against it | Gym's cut on the night against it |
|---|---|---|---|---|---|
| today | healthy | ticket no ask | -$451, error $217 | -0.26 | -$62 |
| today | healthy | ticket own price | -$379, error $217 | -0.26 | +$10 |
| today | healthy | guarantee costs | **+$909, error $0** | 0 | -$336 |
| today | crunch | guarantee costs | **+$1,128, error $96** | +0.32 | -$361 |
| v11 | healthy | ticket no ask | -$288, error $215 | -0.21 | +$38 |
| v11 | healthy | ticket own price | -$267, error $215 | -0.21 | +$43 |
| v11 | healthy | ticket softer | -$326, error $213 | -0.16 | -$37 |
| v11 | healthy | ticket later +2 | +$128, error $108 | +0.11 | +$3 |
| v11 | healthy | guarantee later +2 | -$399, error $218 | -0.37 | -$37 |
| v11 | crunch | ticket no ask | +$231, error $313 | -0.03 | +$29 |
| v11 | crunch | guarantee costs | **+$744, error $102** | +0.24 | -$225 |
| v11 | any | MUTANT guarantee at $1,800 | +$104, error $10 | 0 | +$100 |

One career's cash by week 40 spreads about $1,666 either way inside a single option (healthy, 64 seats).

**v11 against today, same house, same call, no ask** (114 pairs): the ticket house ends +$59 cash (error $78), morale
+5.9, loyalty +1.3, members -0.1. The guarantee house ends -$164 cash (error $28), morale -3.4, loyalty -1.3, members -0.2.

**The night (stage A, 200 scratch nights a row):**

| Rules | Option | Card shows | Played win | Lowest .. highest boxer | Loss |
|---|---|---|---|---|---|
| today | ticket house | 60.5 | 61.1 | 54.0 .. 69.0 | 20.8 |
| today | guarantee house | 75.1 | 79.1 | 72.0 .. 84.0 | 8.0 |
| v11 | ticket house | 60.4 | 55.8 | 50.5 .. 63.0 | 25.0 |
| v11 | ticket, softer | 65.5 | 60.5 | 54.0 .. 68.0 | 21.7 |
| v11 | ticket, later +2 | 62.4 | 58.3 | 51.5 .. 68.0 | 23.5 |
| v11 | guarantee house | 75.1 | 75.5 | 67.0 .. 83.0 | 10.3 |
| v11 | guarantee, later +2 | 77.1 | 76.2 | 67.5 .. 84.5 | 9.4 |

Counting a point a camp week brought the guarantee house back to its aim (79.1 to 75.5), as the map wanted. It also made
the ticket house's card read 4.6 too high (60.4 shown, 55.8 played), where today's card is right (60.5 against 61.1).

**The seats do not hold until the night.** Seats set at the call 48 / 56 / 64 / 72 were 56 to 58 / 59 to 60 / 65 / 68 on
the night: the member count walks a quarter of the way to what the gym's reputation carries every week. The lower half of
the both-call band is gone before the bell, so "worth it under 66 seats" is read on a number that moves 8 seats.

**The crunch.** With $1,000 in the bank the gym closed in 265 of 266 v11 careers and 149 of 152 on today's rules,
whichever contract was signed. The costs ask is the best option there and saves nothing.

## 5. What to change (most important first)

1. **Judge the fork on the debut and the first six fights, not on the purse.** With a quarter share of a $1,400 to $1,800
   purse no purse lever reaches the audit's line (real money, or 3 wins in 100). The levers that do move something are
   the win chance (20 points between the houses), the softer opponent (4.7) and the lean (44% and 20% of picks). Rewrite
   section 3 around: ticket house = harder debut and step-up fights; guarantee house = safer debut and tune-ups; and give
   the harder road a lasting reward that is not dollars at a quarter share (ladder position after a debut win, or
   reputation, which the gym keeps).
2. **Pay the win crowd as reputation, or cut it.** Members walk to what reputation carries within weeks; 9 to 12 members
   against 8 is gone by week 40 (every option within 2 members). Reputation is the number that stays.
3. **Replace the pass rule.** "Cash at or above the day of the call" reads the rent day and the bot's unmanaged gym. Use
   the paired reading of section 4 (the same call, each option against the plain guarantee house) and ask for a gap of at
   least $1,000 or 3 wins in 100, with about 180 rolls a cell (an error near $70), on a cloud seat.
4. **The read counts only the weeks past four.** A point for every week over-reads the ticket house by 4.6. Past four
   only: the ticket card stays honest, the guarantee house still comes back toward 75, Later +2 still shows +2.
5. **Size the crunch rescue to the hole, or drop the crunch cell.** $744 to $1,128 against a gym that closes anyway is
   not a rescue. Either the costs ask becomes an advance big enough to reach the debut night with the doors open, or the
   map stops claiming a crunch choice. At 52 loyalty the ask must cost more than it gives: today it is still $338 ahead.
6. **Give the wish a lasting effect or cut it.** Five morale points at signing are 3 by week 40 and move no pass, cash or
   win. It needs something that stays (a loyalty step that can cross the 50 line and the 10% share, for example).
7. **Softer and the ticket house's no ask need a cell where they win.** Softer is worth 4.7 debut wins for $75 of the
   gym's money and $225 of the boxer's: say that on the button in wins, and let a debut loss cost something the gym feels
   at week 40 (today a loss leaves no mark there), or softer can never be right.
8. **The guarantee purse is not a lever.** $1,400 against $1,800 is $104 for the gym. Keep either; it decides nothing.
9. **Re-run this probe after the rewrite, before critics** (S534 DEPTH METHOD). The mutant for the next run should be one
   the instrument can see: today's costs ask is the proven one (+$909, error $0).

## 6. Limits of this probe

- 19 rolls a pooled cell, shared across a cell's seat counts (the same call days): a house gap under about $430 cannot be
  told from zero here. The findings above that rest on error-free pairs (the costs ask, the mutant, the night's money) or
  on stage A's 200 nights a row are solid; "the houses are level under v11" means "not measurably apart", not "proved equal".
- The ticket house boxes on other Saturdays than the guarantee house. In this sample the ticket Saturdays rolled worse
  (47 debut wins in 100 against stage A's 56), which flatters the guarantee house and the ticket house's Later +2.
- The bot does not run the gym (no classes, no dues band, no spending), so cash falls in every career.
- v11's rules live in the probe, applied around the game's own functions: the night's money through the deal, the crowd,
  the forgiven loss and the loyalty from pay as corrections after the game's own result.

## 7. Reproduce

```
python ops/Tools/godot_slot.py run --who turnprobe11 -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/turnprobe11.gd -- stage=b boxers=0,3 days=4 out=<b_0.jsonl>
   (also boxers=1,4 and boxers=2,5; 19 to 37 minutes each)
... -- stage=a nights=200 out=<a.jsonl>                                             (10 minutes)
... -- stage=b boxers=0,4 days=3 seats=56 gyms=crunch52,dayjob out=<m.jsonl>        (25 minutes)
python tools/turnprobe11_sum.py b_0.jsonl b_1.jsonl b_2.jsonl a.jsonl m.jsonl
```

## 8. Tables (as printed by tools/turnprobe11_sum.py)

In these tables "best on money" marks the option with the most gym cash by week 40 in its cell; "Pass" is the map's pass
rule; "cash kept at the 2nd booking" is its cash line alone.

### Population

- run: boxers [0, 3], 4 call days, to week 40, seats [48, 56, 64, 72], gyms ['healthy', 'crunch'] (crunch at [48, 64])
- run: boxers [1, 4], 4 call days, to week 40, seats [48, 56, 64, 72], gyms ['healthy', 'crunch'] (crunch at [48, 64])
- run: boxers [2, 5], 4 call days, to week 40, seats [48, 56, 64, 72], gyms ['healthy', 'crunch'] (crunch at [48, 64])
- run: boxers [0, 4], 3 call days, to week 40, seats [56], gyms ['crunch52', 'dayjob'] (crunch at [48, 64])

| Boxer | Call | Day | Record | Strength (no camp) | Gym's own seats that day | Loyalty | Wish |
|---|---|---|---|---|---|---|---|
| Lucy Jackson (Out-boxer) | 0 | 174 | 7-2 | 65.9 | 71 | 86 | the test |
| Lucy Jackson (Out-boxer) | 1 | 181 | 7-2 | 66.1 | 70 | 86 | the test |
| Lucy Jackson (Out-boxer) | 2 | 209 | 8-2 | 66.8 | 73 | 84 | the test |
| Kira Mensah (Out-boxer) | 0 | 265 | 7-1 | 67.1 | 71 | 96 | the test |
| Kira Mensah (Out-boxer) | 1 | 272 | 7-1 | 67.1 | 70 | 96 | the test |
| Kira Mensah (Out-boxer) | 2 | 279 | 7-1 | 67.1 | 69 | 96 | the test |
| Kira Mensah (Out-boxer) | 3 | 286 | 7-1 | 67.2 | 68 | 96 | the test |
| Samira Khan (Slugger) | 0 | 398 | 7-8 | 69.7 | 70 | 71 | the test |
| Samira Khan (Slugger) | 1 | 405 | 7-8 | 69.7 | 69 | 71 | the test |
| Samira Khan (Slugger) | 2 | 426 | 8-8 | 70.0 | 73 | 69 | the test |
| Tess Reilly (Pressure fighter) | 0 | 41 | 7-4 | 59.4 | 63 | 64 | none |
| Tess Reilly (Pressure fighter) | 1 | 48 | 7-4 | 59.6 | 64 | 64 | none |
| Tess Reilly (Pressure fighter) | 2 | 69 | 8-4 | 60.5 | 70 | 62 | none |
| Danny Osei (Boxer-puncher) | 0 | 167 | 7-1 | 63.7 | 72 | 95 | the test |
| Danny Osei (Boxer-puncher) | 1 | 174 | 7-1 | 63.9 | 70 | 95 | the test |
| Danny Osei (Boxer-puncher) | 2 | 202 | 8-1 | 64.7 | 73 | 100 | the test |
| Josh Harper (Pressure fighter) | 0 | 111 | 7-2 | 60.4 | 69 | 82 | the test |
| Josh Harper (Pressure fighter) | 1 | 118 | 7-2 | 60.5 | 68 | 82 | the test |
| Josh Harper (Pressure fighter) | 2 | 153 | 8-2 | 61.4 | 73 | 80 | the test |

Careers played: 1498 (control 504, v11 800, mutant 126, nowish 68).

### Stage A - the night (same scratch nights for every row of a boxer)

| Boxer | Rules | Option | Debutant | Card shows | Played win / draw / loss | Stopped losses |
|---|---|---|---|---|---|---|
| Lucy Jackson | control | ticket no ask | Boxer-puncher, rated 67.9 | 59.3 | 54.0 / 24.5 / 21.5 | 4.5 |
| Lucy Jackson | control | guarantee no ask | Boxer-puncher, rated 64.9 | 76.1 | 77.0 / 15.0 / 8.0 | 1.5 |
| Lucy Jackson | v11 | ticket no ask | Pressure fighter, rated 70.2 | 58.9 | 50.5 / 21.5 / 28.0 | 4.0 |
| Lucy Jackson | v11 | ticket softer | Pressure fighter, rated 69.2 | 64.0 | 54.0 / 22.5 / 23.5 | 3.5 |
| Lucy Jackson | v11 | ticket later2 | Pressure fighter, rated 70.2 | 60.9 | 51.5 / 21.0 / 27.5 | 4.0 |
| Lucy Jackson | v11 | guarantee no ask | Out-boxer, rated 64.4 | 75.8 | 71.0 / 16.5 / 12.5 | 1.0 |
| Lucy Jackson | v11 | guarantee later2 | Out-boxer, rated 64.4 | 77.8 | 71.5 / 16.0 / 12.5 | 1.0 |
| Kira Mensah | control | ticket no ask | Boxer-puncher, rated 63.8 | 61.7 | 58.5 / 17.0 / 24.5 | 10.5 |
| Kira Mensah | control | guarantee no ask | Boxer-puncher, rated 60.5 | 77.1 | 75.5 / 13.0 / 11.5 | 6.5 |
| Kira Mensah | v11 | ticket no ask | Pressure fighter, rated 65.0 | 61.7 | 52.5 / 20.0 / 27.5 | 13.0 |
| Kira Mensah | v11 | ticket softer | Pressure fighter, rated 64.0 | 67.1 | 58.5 / 17.0 / 24.5 | 9.5 |
| Kira Mensah | v11 | ticket later2 | Pressure fighter, rated 65.0 | 63.7 | 53.5 / 19.5 / 27.0 | 12.5 |
| Kira Mensah | v11 | guarantee no ask | Out-boxer, rated 58.9 | 77.2 | 72.0 / 15.0 / 13.0 | 4.0 |
| Kira Mensah | v11 | guarantee later2 | Out-boxer, rated 58.9 | 79.2 | 75.5 / 15.5 / 9.0 | 2.5 |
| Samira Khan | control | ticket no ask | Boxer-puncher, rated 67.9 | 63.3 | 57.0 / 17.5 / 25.5 | 6.0 |
| Samira Khan | control | guarantee no ask | Boxer-puncher, rated 66.3 | 73.9 | 72.0 / 14.5 / 13.5 | 4.0 |
| Samira Khan | v11 | ticket no ask | Pressure fighter, rated 67.3 | 63.4 | 54.0 / 18.5 / 27.5 | 4.5 |
| Samira Khan | v11 | ticket softer | Pressure fighter, rated 66.3 | 68.8 | 58.0 / 18.0 / 24.0 | 3.5 |
| Samira Khan | v11 | ticket later2 | Pressure fighter, rated 67.3 | 65.4 | 54.0 / 19.0 / 27.0 | 4.5 |
| Samira Khan | v11 | guarantee no ask | Out-boxer, rated 67.5 | 74.0 | 67.0 / 16.5 / 16.5 | 1.0 |
| Samira Khan | v11 | guarantee later2 | Out-boxer, rated 67.5 | 76.0 | 67.5 / 16.0 / 16.5 | 1.0 |
| Tess Reilly | control | ticket no ask | Boxer-puncher, rated 51.7 | 60.1 | 69.0 / 16.5 / 14.5 | 0.5 |
| Tess Reilly | control | guarantee no ask | Boxer-puncher, rated 49.7 | 71.4 | 84.0 / 12.0 / 4.0 | 0.0 |
| Tess Reilly | v11 | ticket no ask | Pressure fighter, rated 51.6 | 60.1 | 63.0 / 17.5 / 19.5 | 1.0 |
| Tess Reilly | v11 | ticket softer | Pressure fighter, rated 50.6 | 65.1 | 68.0 / 15.5 / 16.5 | 0.5 |
| Tess Reilly | v11 | ticket later2 | Pressure fighter, rated 51.6 | 62.1 | 68.0 / 16.0 / 16.0 | 0.5 |
| Tess Reilly | v11 | guarantee no ask | Out-boxer, rated 51.5 | 71.6 | 83.0 / 12.0 / 5.0 | 0.0 |
| Tess Reilly | v11 | guarantee later2 | Out-boxer, rated 51.5 | 73.6 | 84.5 / 12.0 / 3.5 | 0.0 |
| Danny Osei | control | ticket no ask | Boxer-puncher, rated 61.6 | 61.0 | 66.5 / 19.0 / 14.5 | 2.5 |
| Danny Osei | control | guarantee no ask | Boxer-puncher, rated 58.1 | 75.7 | 84.0 / 11.0 / 5.0 | 1.5 |
| Danny Osei | v11 | ticket no ask | Pressure fighter, rated 65.1 | 60.8 | 58.5 / 22.0 / 19.5 | 3.0 |
| Danny Osei | v11 | ticket softer | Pressure fighter, rated 64.1 | 65.9 | 64.0 / 19.0 / 17.0 | 3.0 |
| Danny Osei | v11 | ticket later2 | Pressure fighter, rated 65.1 | 62.8 | 61.0 / 20.0 / 19.0 | 3.0 |
| Danny Osei | v11 | guarantee no ask | Out-boxer, rated 56.7 | 75.6 | 78.0 / 13.5 / 8.5 | 1.0 |
| Danny Osei | v11 | guarantee later2 | Out-boxer, rated 56.7 | 77.6 | 76.5 / 15.0 / 8.5 | 1.5 |
| Josh Harper | control | ticket no ask | Boxer-puncher, rated 55.9 | 57.8 | 61.5 / 14.5 / 24.0 | 2.0 |
| Josh Harper | control | guarantee no ask | Boxer-puncher, rated 53.4 | 76.7 | 82.0 / 12.0 / 6.0 | 1.0 |
| Josh Harper | v11 | ticket no ask | Pressure fighter, rated 55.9 | 57.2 | 56.5 / 15.5 / 28.0 | 1.5 |
| Josh Harper | v11 | ticket softer | Pressure fighter, rated 54.9 | 62.2 | 60.5 / 15.0 / 24.5 | 2.0 |
| Josh Harper | v11 | ticket later2 | Pressure fighter, rated 55.9 | 59.2 | 62.0 / 13.5 / 24.5 | 2.0 |
| Josh Harper | v11 | guarantee no ask | Out-boxer, rated 55.9 | 76.4 | 82.0 / 11.5 / 6.5 | 0.5 |
| Josh Harper | v11 | guarantee later2 | Out-boxer, rated 55.9 | 78.4 | 82.0 / 11.5 / 6.5 | 0.5 |

| Rules | Option | Boxers | Card shows (mean) | Played win (mean) | lowest .. highest | Loss | Within 10 of the card |
|---|---|---|---|---|---|---|---|
| control | ticket no ask | 6 | 60.5 | 61.1 | 54.0 .. 69.0 | 20.8 | 6 of 6 |
| control | guarantee no ask | 6 | 75.1 | 79.1 | 72.0 .. 84.0 | 8.0 | 5 of 6 |
| v11 | ticket no ask | 6 | 60.4 | 55.8 | 50.5 .. 63.0 | 25.0 | 6 of 6 |
| v11 | ticket softer | 6 | 65.5 | 60.5 | 54.0 .. 68.0 | 21.7 | 6 of 6 |
| v11 | ticket later2 | 6 | 62.4 | 58.3 | 51.5 .. 68.0 | 23.5 | 6 of 6 |
| v11 | guarantee no ask | 6 | 75.1 | 75.5 | 67.0 .. 83.0 | 10.3 | 5 of 6 |
| v11 | guarantee later2 | 6 | 77.1 | 76.2 | 67.5 .. 84.5 | 9.4 | 5 of 6 |

### Stage B - TODAY'S RULES (control), cell by cell (pooled over boxers and call days)

| Gym | Seats at the call | Option | n | Pass | 2nd fight in 16 wk | cash kept at the 2nd booking | Debut win / draw / loss | Seats on the night | Gym's cut | Boxer's pay | Cash by the last week | Members | Reputation | Morale | Loyalty | Chin ceiling | Pro wins - losses | Still here |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| crunch | 48 | guarantee costs **(best on money)** | 19 | 0% | 84% | 0% | 89 / 11 / 0 | 58 | $89 | $266 | -12786 | 55 | 6 | 46 | 90 | 99.0 | 1.3 - 0.1 | 0% |
| crunch | 48 | guarantee no ask | 19 | 0% | 84% | 0% | 89 / 11 / 0 | 58 | $450 | $1350 | -13755 | 54 | 5 | 45 | 90 | 99.0 | 1.1 - 0.1 | 0% |
| crunch | 48 | ticket no ask | 19 | 0% | 100% | 0% | 47 / 26 / 26 | 56 | $352 | $1055 | -13852 | 53 | 5 | 31 | 87 | 98.7 | 0.9 - 0.4 | 0% |
| crunch | 48 | ticket price | 19 | 0% | 100% | 0% | 47 / 26 / 26 | 71 | $431 | $1294 | -13772 | 53 | 5 | 31 | 87 | 98.7 | 0.9 - 0.4 | 0% |
| crunch | 64 | guarantee costs **(best on money)** | 19 | 0% | 84% | 0% | 89 / 11 / 0 | 65 | $89 | $266 | -7756 | 66 | 28 | 45 | 89 | 98.8 | 2.2 - 0.3 | 16% |
| crunch | 64 | guarantee no ask | 19 | 0% | 84% | 0% | 89 / 11 / 0 | 65 | $450 | $1350 | -9043 | 65 | 26 | 46 | 89 | 98.9 | 1.7 - 0.2 | 0% |
| crunch | 64 | ticket no ask | 19 | 0% | 100% | 42% | 47 / 26 / 26 | 65 | $406 | $1219 | -9172 | 64 | 25 | 31 | 87 | 98.6 | 1.6 - 0.5 | 0% |
| crunch | 64 | ticket price | 19 | 0% | 100% | 42% | 47 / 26 / 26 | 80 | $475 | $1425 | -9103 | 64 | 25 | 31 | 87 | 98.6 | 1.6 - 0.5 | 0% |
| healthy | 48 | guarantee costs **(best on money)** | 19 | 0% | 100% | 0% | 89 / 11 / 0 | 58 | $114 | $341 | -9711 | 62 | 16 | 35 | 85 | 98.5 | 3.5 - 0.6 | 100% |
| healthy | 48 | guarantee no ask | 19 | 0% | 100% | 0% | 89 / 11 / 0 | 58 | $450 | $1350 | -10620 | 62 | 16 | 35 | 85 | 98.5 | 3.5 - 0.6 | 100% |
| healthy | 48 | ticket no ask | 19 | 0% | 100% | 0% | 47 / 26 / 26 | 56 | $352 | $1055 | -11110 | 61 | 14 | 27 | 82 | 98.1 | 3.3 - 1.0 | 100% |
| healthy | 48 | ticket price | 19 | 0% | 100% | 0% | 47 / 26 / 26 | 71 | $431 | $1294 | -11030 | 61 | 14 | 27 | 82 | 98.1 | 3.3 - 1.0 | 100% |
| healthy | 56 | guarantee costs **(best on money)** | 19 | 0% | 100% | 0% | 89 / 11 / 0 | 60 | $114 | $341 | -9326 | 62 | 16 | 35 | 85 | 98.5 | 3.5 - 0.6 | 100% |
| healthy | 56 | guarantee no ask | 19 | 0% | 100% | 0% | 89 / 11 / 0 | 60 | $450 | $1350 | -10235 | 62 | 16 | 35 | 85 | 98.5 | 3.5 - 0.6 | 100% |
| healthy | 56 | ticket no ask | 19 | 11% | 100% | 11% | 47 / 26 / 26 | 59 | $366 | $1097 | -10755 | 61 | 14 | 27 | 82 | 98.1 | 3.3 - 1.0 | 100% |
| healthy | 56 | ticket price | 19 | 11% | 100% | 11% | 47 / 26 / 26 | 74 | $443 | $1328 | -10678 | 61 | 14 | 27 | 82 | 98.1 | 3.3 - 1.0 | 100% |
| healthy | 64 | guarantee costs **(best on money)** | 19 | 0% | 100% | 0% | 89 / 11 / 0 | 65 | $114 | $341 | -6107 | 69 | 34 | 35 | 85 | 98.5 | 3.5 - 0.6 | 100% |
| healthy | 64 | guarantee no ask | 19 | 0% | 100% | 0% | 89 / 11 / 0 | 65 | $450 | $1350 | -7016 | 69 | 34 | 35 | 85 | 98.5 | 3.5 - 0.6 | 100% |
| healthy | 64 | ticket no ask | 19 | 42% | 100% | 42% | 47 / 26 / 26 | 65 | $406 | $1219 | -7533 | 67 | 32 | 27 | 82 | 98.1 | 3.3 - 1.0 | 100% |
| healthy | 64 | ticket price | 19 | 42% | 100% | 42% | 47 / 26 / 26 | 80 | $475 | $1425 | -7464 | 67 | 32 | 27 | 82 | 98.1 | 3.3 - 1.0 | 100% |
| healthy | 72 | guarantee costs **(best on money)** | 19 | 0% | 100% | 0% | 89 / 11 / 0 | 68 | $114 | $341 | -5435 | 69 | 61 | 35 | 85 | 98.5 | 3.5 - 0.6 | 100% |
| healthy | 72 | guarantee no ask | 19 | 0% | 100% | 0% | 89 / 11 / 0 | 68 | $450 | $1350 | -6344 | 69 | 61 | 35 | 85 | 98.5 | 3.5 - 0.6 | 100% |
| healthy | 72 | ticket no ask | 19 | 53% | 100% | 53% | 47 / 26 / 26 | 68 | $427 | $1280 | -6622 | 68 | 59 | 27 | 82 | 98.1 | 3.3 - 1.0 | 100% |
| healthy | 72 | ticket price | 19 | 58% | 100% | 58% | 47 / 26 / 26 | 83 | $491 | $1474 | -6557 | 68 | 59 | 27 | 82 | 98.1 | 3.3 - 1.0 | 100% |

**control: right on the map's pass rate (within 5 points of the cell's best)** (6 cells)

| | cells where it is right / best | of the cells it shows in | alone |
|---|---|---|---|
| The ticket house | 6 (100%) | 6 | 3 (50%) |
| The guarantee house | 3 (50%) | 6 | 0 (0%) |
| guarantee costs | 3 (50%) | 6 | |
| guarantee no ask | 3 (50%) | 6 | |
| ticket no ask | 5 (83%) | 6 | |
| ticket price | 6 (100%) | 6 | |

**control: best on money (gym cash by the last week)** (6 cells)

| | cells where it is right / best | of the cells it shows in | alone |
|---|---|---|---|
| The ticket house | 0 (0%) | 6 | 0 (0%) |
| The guarantee house | 6 (100%) | 6 | 6 (100%) |
| guarantee costs | 6 (100%) | 6 | |
| guarantee no ask | 0 (0%) | 6 | |
| ticket no ask | 0 (0%) | 6 | |
| ticket price | 0 (0%) | 6 | |

**control: best on members** (6 cells)

| | cells where it is right / best | of the cells it shows in | alone |
|---|---|---|---|
| The ticket house | 0 (0%) | 6 | 0 (0%) |
| The guarantee house | 6 (100%) | 6 | 6 (100%) |
| guarantee costs | 6 (100%) | 6 | |
| guarantee no ask | 4 (67%) | 6 | |
| ticket no ask | 0 (0%) | 6 | |
| ticket price | 0 (0%) | 6 | |

**control: best on pro wins** (6 cells)

| | cells where it is right / best | of the cells it shows in | alone |
|---|---|---|---|
| The ticket house | 0 (0%) | 6 | 0 (0%) |
| The guarantee house | 6 (100%) | 6 | 6 (100%) |
| guarantee costs | 6 (100%) | 6 | |
| guarantee no ask | 4 (67%) | 6 | |
| ticket no ask | 0 (0%) | 6 | |
| ticket price | 0 (0%) | 6 | |

Best option against the worst, gym cash: mean $1320 a cell (smallest $1066, largest $1429).

**control: best on money, boxer by boxer (a cell = boxer x seats x gym)** (36 cells)

| | cells where it is right / best | of the cells it shows in | alone |
|---|---|---|---|
| The ticket house | 3 (8%) | 36 | 3 (8%) |
| The guarantee house | 33 (92%) | 36 | 33 (92%) |
| guarantee costs | 33 (92%) | 36 | |
| guarantee no ask | 0 (0%) | 36 | |
| ticket no ask | 0 (0%) | 36 | |
| ticket price | 3 (8%) | 36 | |

| Seats at the call | 48 | 56 | 64 | 72 |
|---|---|---|---|---|
| ticket house best on money | 1 of 12 | 1 of 6 | 1 of 12 | 0 of 6 |
| guarantee house best on money | 11 of 12 | 5 of 6 | 11 of 12 | 6 of 6 |

### Stage B - MAP v11, cell by cell (pooled over boxers and call days)

| Gym | Seats at the call | Option | n | Pass | 2nd fight in 16 wk | cash kept at the 2nd booking | Debut win / draw / loss | Seats on the night | Gym's cut | Boxer's pay | Cash by the last week | Members | Reputation | Morale | Loyalty | Chin ceiling | Pro wins - losses | Still here |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| crunch | 48 | guarantee costs **(best on money)** | 19 | 0% | 84% | 0% | 79 / 21 / 0 | 58 | $125 | $375 | -13353 | 54 | 6 | 43 | 84 | 99.0 | 1.2 - 0.0 | 0% |
| crunch | 48 | guarantee later2 | 19 | 0% | 47% | 0% | 69 / 25 / 6 | 59 | $313 | $937 | -14287 | 53 | 4 | 42 | 88 | 99.0 | 0.7 - 0.1 | 0% |
| crunch | 48 | guarantee no ask | 19 | 0% | 84% | 0% | 79 / 21 / 0 | 58 | $350 | $1050 | -13959 | 54 | 5 | 42 | 88 | 99.0 | 1.0 - 0.0 | 0% |
| crunch | 48 | ticket later2 | 19 | 0% | 84% | 0% | 79 / 21 / 0 | 58 | $322 | $966 | -13960 | 54 | 5 | 47 | 90 | 99.0 | 1.1 - 0.0 | 0% |
| crunch | 48 | ticket no ask | 19 | 0% | 100% | 0% | 47 / 32 / 21 | 56 | $352 | $1055 | -13792 | 54 | 5 | 38 | 88 | 98.8 | 1.0 - 0.3 | 0% |
| crunch | 48 | ticket price | 19 | 0% | 100% | 0% | 47 / 32 / 21 | 71 | $364 | $1091 | -13775 | 54 | 5 | 38 | 88 | 98.8 | 1.0 - 0.3 | 0% |
| crunch | 48 | ticket softer | 19 | 0% | 100% | 0% | 53 / 32 / 16 | 56 | $277 | $830 | -13894 | 54 | 5 | 39 | 88 | 98.8 | 1.0 - 0.3 | 0% |
| crunch | 64 | guarantee costs **(best on money)** | 19 | 0% | 84% | 0% | 79 / 21 / 0 | 65 | $125 | $375 | -8348 | 65 | 28 | 44 | 84 | 99.0 | 2.0 - 0.1 | 5% |
| crunch | 64 | guarantee later2 | 19 | 0% | 63% | 11% | 69 / 25 / 6 | 65 | $313 | $937 | -9730 | 64 | 24 | 42 | 88 | 98.9 | 1.3 - 0.2 | 0% |
| crunch | 64 | guarantee no ask | 19 | 0% | 84% | 0% | 79 / 21 / 0 | 65 | $350 | $1050 | -9231 | 65 | 26 | 43 | 88 | 99.0 | 1.7 - 0.1 | 0% |
| crunch | 64 | ticket later2 | 19 | 0% | 84% | 0% | 79 / 21 / 0 | 65 | $369 | $1106 | -9250 | 65 | 27 | 46 | 89 | 99.0 | 1.7 - 0.1 | 0% |
| crunch | 64 | ticket no ask | 19 | 0% | 100% | 42% | 47 / 32 / 21 | 65 | $406 | $1219 | -8936 | 64 | 25 | 38 | 88 | 98.6 | 1.6 - 0.5 | 0% |
| crunch | 64 | ticket price | 19 | 0% | 100% | 42% | 47 / 32 / 21 | 80 | $408 | $1222 | -8874 | 64 | 25 | 38 | 88 | 98.6 | 1.7 - 0.5 | 0% |
| crunch | 64 | ticket softer | 19 | 0% | 100% | 42% | 53 / 32 / 16 | 65 | $331 | $994 | -9039 | 65 | 25 | 38 | 87 | 98.6 | 1.6 - 0.4 | 0% |
| healthy | 48 | guarantee later2 | 19 | 0% | 100% | 0% | 74 / 21 / 5 | 59 | $313 | $937 | -11260 | 61 | 13 | 24 | 85 | 98.7 | 3.1 - 0.8 | 100% |
| healthy | 48 | guarantee no ask | 19 | 0% | 100% | 0% | 79 / 21 / 0 | 58 | $350 | $1050 | -10781 | 62 | 16 | 32 | 84 | 98.6 | 3.4 - 0.5 | 100% |
| healthy | 48 | ticket later2 **(best on money)** | 19 | 0% | 100% | 0% | 79 / 21 / 0 | 58 | $322 | $966 | -10661 | 62 | 16 | 33 | 85 | 98.5 | 3.5 - 0.5 | 100% |
| healthy | 48 | ticket no ask | 19 | 0% | 100% | 0% | 47 / 32 / 21 | 56 | $352 | $1055 | -11114 | 60 | 14 | 32 | 83 | 98.1 | 3.2 - 0.8 | 100% |
| healthy | 48 | ticket price | 19 | 0% | 100% | 0% | 47 / 32 / 21 | 71 | $364 | $1091 | -11097 | 60 | 14 | 32 | 83 | 98.1 | 3.2 - 0.8 | 100% |
| healthy | 48 | ticket softer | 19 | 0% | 100% | 0% | 53 / 32 / 16 | 56 | $277 | $830 | -11136 | 61 | 14 | 33 | 83 | 98.1 | 3.3 - 0.8 | 100% |
| healthy | 56 | guarantee later2 | 19 | 0% | 100% | 0% | 74 / 21 / 5 | 60 | $313 | $937 | -10873 | 61 | 13 | 24 | 85 | 98.7 | 3.1 - 0.8 | 100% |
| healthy | 56 | guarantee no ask | 19 | 0% | 100% | 0% | 79 / 21 / 0 | 60 | $350 | $1050 | -10399 | 62 | 16 | 32 | 84 | 98.6 | 3.4 - 0.5 | 100% |
| healthy | 56 | ticket later2 **(best on money)** | 19 | 0% | 100% | 0% | 79 / 21 / 0 | 60 | $334 | $1004 | -10256 | 62 | 16 | 33 | 85 | 98.5 | 3.5 - 0.5 | 100% |
| healthy | 56 | ticket no ask | 19 | 11% | 100% | 11% | 47 / 32 / 21 | 59 | $366 | $1097 | -10750 | 60 | 14 | 32 | 83 | 98.1 | 3.2 - 0.8 | 100% |
| healthy | 56 | ticket price | 19 | 11% | 100% | 11% | 47 / 32 / 21 | 74 | $376 | $1125 | -10722 | 60 | 14 | 32 | 83 | 98.1 | 3.2 - 0.8 | 100% |
| healthy | 56 | ticket softer | 19 | 5% | 100% | 5% | 53 / 32 / 16 | 59 | $291 | $872 | -10774 | 61 | 14 | 33 | 83 | 98.1 | 3.3 - 0.8 | 100% |
| healthy | 64 | guarantee later2 | 19 | 11% | 100% | 11% | 74 / 21 / 5 | 65 | $313 | $937 | -7583 | 69 | 31 | 24 | 85 | 98.7 | 3.1 - 0.8 | 100% |
| healthy | 64 | guarantee no ask | 19 | 0% | 100% | 0% | 79 / 21 / 0 | 65 | $350 | $1050 | -7163 | 69 | 34 | 32 | 84 | 98.6 | 3.4 - 0.5 | 100% |
| healthy | 64 | ticket later2 **(best on money)** | 19 | 0% | 100% | 0% | 79 / 21 / 0 | 65 | $369 | $1106 | -7034 | 68 | 34 | 33 | 85 | 98.5 | 3.5 - 0.5 | 100% |
| healthy | 64 | ticket no ask | 19 | 42% | 100% | 42% | 47 / 32 / 21 | 65 | $406 | $1219 | -7478 | 67 | 32 | 32 | 84 | 98.1 | 3.2 - 0.8 | 100% |
| healthy | 64 | ticket price | 19 | 42% | 100% | 42% | 47 / 32 / 21 | 80 | $408 | $1222 | -7469 | 67 | 32 | 32 | 84 | 98.1 | 3.2 - 0.8 | 100% |
| healthy | 64 | ticket softer | 19 | 42% | 100% | 42% | 53 / 32 / 16 | 65 | $331 | $994 | -7518 | 67 | 32 | 33 | 83 | 98.1 | 3.3 - 0.8 | 100% |
| healthy | 72 | guarantee later2 | 19 | 32% | 100% | 32% | 74 / 21 / 5 | 68 | $313 | $937 | -6685 | 70 | 58 | 24 | 85 | 98.7 | 3.1 - 0.8 | 100% |
| healthy | 72 | guarantee no ask | 19 | 0% | 100% | 0% | 79 / 21 / 0 | 68 | $350 | $1050 | -6463 | 69 | 61 | 32 | 84 | 98.6 | 3.4 - 0.5 | 100% |
| healthy | 72 | ticket later2 **(best on money)** | 19 | 0% | 100% | 0% | 79 / 21 / 0 | 68 | $385 | $1153 | -6344 | 68 | 61 | 33 | 85 | 98.5 | 3.5 - 0.5 | 100% |
| healthy | 72 | ticket no ask | 19 | 58% | 100% | 58% | 47 / 32 / 21 | 68 | $427 | $1280 | -6618 | 68 | 59 | 32 | 84 | 98.1 | 3.2 - 0.8 | 100% |
| healthy | 72 | ticket price | 19 | 53% | 100% | 53% | 47 / 32 / 21 | 83 | $424 | $1271 | -6588 | 68 | 59 | 32 | 84 | 98.1 | 3.2 - 0.8 | 100% |
| healthy | 72 | ticket softer | 19 | 47% | 100% | 47% | 53 / 32 / 16 | 68 | $352 | $1055 | -6684 | 68 | 59 | 33 | 83 | 98.1 | 3.3 - 0.8 | 100% |

**v11: right on the map's pass rate (within 5 points of the cell's best)** (6 cells)

| | cells where it is right / best | of the cells it shows in | alone |
|---|---|---|---|
| The ticket house | 6 (100%) | 6 | 3 (50%) |
| The guarantee house | 3 (50%) | 6 | 0 (0%) |
| guarantee costs | 2 (100%) | 2 | |
| guarantee later2 | 3 (50%) | 6 | |
| guarantee no ask | 3 (50%) | 6 | |
| ticket later2 | 3 (50%) | 6 | |
| ticket no ask | 6 (100%) | 6 | |
| ticket price | 5 (83%) | 6 | |
| ticket softer | 4 (67%) | 6 | |

**v11: best on money (gym cash by the last week)** (6 cells)

| | cells where it is right / best | of the cells it shows in | alone |
|---|---|---|---|
| The ticket house | 4 (67%) | 6 | 4 (67%) |
| The guarantee house | 2 (33%) | 6 | 2 (33%) |
| guarantee costs | 2 (100%) | 2 | |
| guarantee later2 | 0 (0%) | 6 | |
| guarantee no ask | 0 (0%) | 6 | |
| ticket later2 | 4 (67%) | 6 | |
| ticket no ask | 0 (0%) | 6 | |
| ticket price | 0 (0%) | 6 | |
| ticket softer | 0 (0%) | 6 | |

**v11: best on members** (6 cells)

| | cells where it is right / best | of the cells it shows in | alone |
|---|---|---|---|
| The ticket house | 0 (0%) | 6 | 0 (0%) |
| The guarantee house | 6 (100%) | 6 | 6 (100%) |
| guarantee costs | 2 (100%) | 2 | |
| guarantee later2 | 1 (17%) | 6 | |
| guarantee no ask | 3 (50%) | 6 | |
| ticket later2 | 0 (0%) | 6 | |
| ticket no ask | 0 (0%) | 6 | |
| ticket price | 0 (0%) | 6 | |
| ticket softer | 0 (0%) | 6 | |

**v11: best on pro wins** (6 cells)

| | cells where it is right / best | of the cells it shows in | alone |
|---|---|---|---|
| The ticket house | 4 (67%) | 6 | 4 (67%) |
| The guarantee house | 2 (33%) | 6 | 2 (33%) |
| guarantee costs | 2 (100%) | 2 | |
| guarantee later2 | 0 (0%) | 6 | |
| guarantee no ask | 0 (0%) | 6 | |
| ticket later2 | 4 (67%) | 6 | |
| ticket no ask | 0 (0%) | 6 | |
| ticket price | 0 (0%) | 6 | |
| ticket softer | 0 (0%) | 6 | |

Best option against the worst, gym cash: mean $737 a cell (smallest $341, largest $1382).

**v11: best on money, boxer by boxer (a cell = boxer x seats x gym)** (36 cells)

| | cells where it is right / best | of the cells it shows in | alone |
|---|---|---|---|
| The ticket house | 18 (50%) | 36 | 18 (50%) |
| The guarantee house | 18 (50%) | 36 | 18 (50%) |
| guarantee costs | 8 (67%) | 12 | |
| guarantee later2 | 3 (8%) | 36 | |
| guarantee no ask | 7 (19%) | 36 | |
| ticket later2 | 7 (19%) | 36 | |
| ticket no ask | 0 (0%) | 36 | |
| ticket price | 11 (31%) | 36 | |
| ticket softer | 0 (0%) | 36 | |

| Seats at the call | 48 | 56 | 64 | 72 |
|---|---|---|---|---|
| ticket house best on money | 5 of 12 | 4 of 6 | 5 of 12 | 4 of 6 |
| guarantee house best on money | 7 of 12 | 2 of 6 | 7 of 12 | 2 of 6 |

### The mutant (v11 with the guarantee purse back at $1,800), healthy cells

| Seats | v11 guarantee no ask: cash | MUTANT guarantee no ask: cash | best v11 ticket option: cash | mutant ahead of every ticket option |
|---|---|---|---|---|
| 48 | -10781 | -10681 | -10661 | no |
| 56 | -10399 | -10299 | -10256 | no |
| 64 | -7163 | -7063 | -7034 | no |
| 72 | -6463 | -6363 | -6344 | no |

### The wish (call day 0, no ask; the same careers with the wish off)

| House signed | Wish | n | Pass | Morale by the last week | Loyalty | Cash | Pro wins |
|---|---|---|---|---|---|---|---|
| ticket | on | 30 | 10% | 32.6 | 85.8 | -10113 | 2.47 |
| ticket | off | 30 | 10% | 29.6 | 85.8 | -10113 | 2.47 |
| guarantee | on | 30 | 0% | 44.7 | 88.0 | -9527 | 3.03 |
| guarantee | off | 30 | 0% | 47.2 | 89.1 | -9527 | 3.03 |

### The house's lean (first six pro fights)

- control, ticket house: 908 sets of pro offers, the house added a row in 652 (72%), the bot's pick changed in 392 (43% of sets).
- control, guarantee house: 843 sets of pro offers, the house added a row in 810 (96%), the bot's pick changed in 163 (19% of sets).
- v11, ticket house: 1754 sets of pro offers, the house added a row in 1340 (76%), the bot's pick changed in 809 (46% of sets).
- v11, guarantee house: 832 sets of pro offers, the house added a row in 798 (96%), the bot's pick changed in 165 (20% of sets).

### Made cases

| Case | Rules | Option | n | Gym's share | Pass | Gym's cut on the night | Boxer's pay | Cash by the last week | Loyalty | Morale | Still here |
|---|---|---|---|---|---|---|---|---|---|---|---|
| crunch52 | control | guarantee costs | 6 | 25% | 0% | $89 | $266 | -11931 | 69 | 66 | 0% |
| crunch52 | control | guarantee no ask | 6 | 25% | 0% | $450 | $1350 | -13616 | 66 | 59 | 0% |
| crunch52 | control | ticket no ask | 6 | 25% | 0% | $367 | $1100 | -13510 | 62 | 43 | 0% |
| crunch52 | control | ticket price | 6 | 25% | 0% | $443 | $1330 | -13433 | 62 | 43 | 0% |
| crunch52 | mutant | guarantee no ask | 6 | 25% | 0% | $450 | $1350 | -13502 | 65 | 58 | 0% |
| crunch52 | nowish | guarantee no ask | 2 | 25% | 0% | $350 | $1050 | -13062 | 66 | 66 | 0% |
| crunch52 | nowish | ticket no ask | 2 | 25% | 0% | $363 | $1087 | -14567 | 60 | 35 | 0% |
| crunch52 | v11 | guarantee costs | 6 | 10% | 0% | $50 | $450 | -13374 | 57 | 58 | 0% |
| crunch52 | v11 | guarantee later2 | 6 | 25% | 0% | $313 | $937 | -14306 | 61 | 53 | 0% |
| crunch52 | v11 | guarantee no ask | 6 | 25% | 0% | $350 | $1050 | -13712 | 64 | 59 | 0% |
| crunch52 | v11 | ticket later2 | 6 | 25% | 0% | $335 | $1006 | -13600 | 67 | 64 | 0% |
| crunch52 | v11 | ticket no ask | 6 | 25% | 0% | $367 | $1100 | -13523 | 64 | 53 | 0% |
| crunch52 | v11 | ticket price | 6 | 25% | 0% | $376 | $1127 | -13508 | 64 | 53 | 0% |
| crunch52 | v11 | ticket softer | 6 | 25% | 0% | $292 | $875 | -13598 | 64 | 53 | 0% |
| dayjob | control | guarantee costs | 6 | 25% | 0% | $114 | $341 | -8935 | 92 | 52 | 100% |
| dayjob | control | guarantee no ask | 6 | 25% | 0% | $450 | $1350 | -9844 | 92 | 52 | 100% |
| dayjob | control | ticket no ask | 6 | 25% | 0% | $367 | $1100 | -10713 | 87 | 39 | 100% |
| dayjob | control | ticket price | 6 | 25% | 0% | $443 | $1330 | -10636 | 87 | 39 | 100% |
| dayjob | mutant | guarantee no ask | 6 | 25% | 0% | $450 | $1350 | -9755 | 93 | 53 | 100% |
| dayjob | nowish | guarantee no ask | 2 | 25% | 0% | $350 | $1050 | -10150 | 92 | 49 | 100% |
| dayjob | nowish | ticket no ask | 2 | 25% | 0% | $363 | $1087 | -10624 | 87 | 42 | 100% |
| dayjob | v11 | guarantee later2 | 6 | 25% | 0% | $313 | $937 | -11048 | 89 | 34 | 100% |
| dayjob | v11 | guarantee no ask | 6 | 25% | 0% | $350 | $1050 | -9855 | 92 | 53 | 100% |
| dayjob | v11 | ticket later2 | 6 | 25% | 0% | $335 | $1006 | -10202 | 91 | 46 | 100% |
| dayjob | v11 | ticket no ask | 6 | 25% | 0% | $367 | $1100 | -10690 | 87 | 38 | 100% |
| dayjob | v11 | ticket price | 6 | 25% | 0% | $376 | $1127 | -10676 | 87 | 38 | 100% |
| dayjob | v11 | ticket softer | 6 | 25% | 0% | $292 | $875 | -10766 | 87 | 38 | 100% |
