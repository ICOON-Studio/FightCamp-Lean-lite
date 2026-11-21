# TURNPROBE12 RESULT - map v12 of turning pro, measured before any critic scores it

S535, TURNPRO12 side console. Task: `ops/research/TASK_TURNPRO12.md`. Map: `ops/research/DESIGN_TURNPRO1_V12.md` (its probe is
section 9). Measurement only: nothing under `scripts/` was touched. v12's rules are a flagged local copy,
`tools/turnprobe12_rules.gd`; the runner is `tools/turnprobe12.gd`; the tables come from `tools/turnprobe12_sum.py`.

## 1. Verdict: FAIL, 10 of 15 bars (v11 was 4 of 15). The house is now a real choice; the asks are not

1. **The fork between the two houses is measurable for the first time.** In a gym with room for more members the ticket
   house ends $1,518 to $1,656 of gym cash ahead of the plain guarantee house by week 40 (error about $250, so six errors)
   and gives away 23 debut wins in 100. That is a trade, in all three cells with room.
2. **It flips where the map said it would.** In a full gym the ticket house is $619 ahead (under the line) and 18 wins
   behind: the guarantee house is the one answer there. On today's rules, on these same rolls, the ticket house is $450
   and $641 ahead: v12 adds about $1,200 where there is room and nothing where there is none.
3. **Softer cannot be a choice. This is the audit bar that fails.** It is 7 debut wins in 100 better than the ticket
   house's plain offer and about $950 worse on cash with room (level in a full gym), so it is never beaten by the plain
   offer; but against the guarantee house it is 16 wins behind and only $600 ahead, so the guarantee house beats it in
   every cell. It is the guarantee house done worse. Right in 0 of 4 cells.
4. **The name does not stay.** The ticket house's win is worth 8 to 9 reputation on the night, but by week 40 it is only
   2.7 to 3.4 ahead: the guarantee house's road wins more fights (4.1 pro wins against 3.25) and every win pays 5
   reputation and 8 members. The members are level by week 40 (63 against 64). The ticket house's money is the name
   arriving 30 weeks sooner plus bigger step-up purses, not a lasting lead. Probe 11 asked for a reward that lasts; this
   one is early, not lasting.
5. **A debut loss now leaves a mark.** Debut losers end $2,287 behind the same option's winners (today $972). The roads
   differ as designed: 84% of the ticket house's bookings are step ups against 32%; 96% of its boxers are ranked by week 40
   against 68%.
6. **Two smaller misses.** The guarantee house's card still reads 3.6 low (75.0 shown, 78.6 played; today 79.1): counting
   the weeks past four did not close it, so it is not the camp weeks. And the cash error is $255 in one cell against a
   bar of $250, on 168 rolls instead of 180.

## 2. Which part of turning pro cannot be a choice, and what to cut (free hand, owner S534)

- **CUT every ask on the offer except Later +2** (a calendar tool). Softer fails here; own ticket price, costs from the
  purse, the split and the purse failed in probe 11. Two probes say the same thing: nothing bolted onto the contract is a
  decision. Stop designing asks.
- **KEEP one decision: which house.** It is the promoter's road (a hard first night and step ups, or a safe one and
  tune-ups), it is a trade with room and one answer in a full gym, and the player can change which by making room.
- **Turning pro is then one good decision, not a deep screen.** The depth an 8 needs is in the six fights of the road
  and in the gym's room, both of which already exist. More rounds on the offer screen itself will not find it.
- **To pass, v13 needs three changes, in this order:** (a) drop Softer (bars 8 and 10 go with it); (b) make the name
  last: a soft win should make less name than a hard one, as it already makes fewer fans (CODE
  `scripts/rules/Matchmaking.gd` :241), so the tune-up road stops buying the same reputation a fight later (bar 15);
  (c) aim the guarantee house's card at what plays, 78 (owner: "78 is fine") (bar 4). Then run this probe again on
  180 or more rolls (bar 2).

## 3. What was run

- **Population.** The six people the game can sign, each played from signing to the first pro call by a bot that takes
  every legal bout, then called on up to 30 different weeks: **168 rolls** (21 to 31 a boxer; a boxer's call week is one
  roll, because a bout's dice are the fight day's). The boxers keep boxing as amateurs between calls, so the late rolls
  are older records (7 wins at the first call, 12 to 19 at the last).
- **Cells.** The gym on the day of the call: seats 48, 56 and 64 with room for more members (cap 66), and a full gym
  (members at the cap, a name that draws 10 more). $12,000 in the bank. 162 rolls in each cell with room; 74 in the full
  cell (in the other 88 only the ticket house calls: the seats pass 74).
- **Arms.** V12 = the map's sections 3 to 5 (ticket: no ask, softer; guarantee: no ask). TODAY = the game's own
  functions in the 56 and full cells (ticket no ask; guarantee no ask, costs). The mutant is today's costs ask.
- **2,388 careers** from the call to week 40 (the bot books the offered pro fight read nearest 65 in 100 from what the
  house's road puts on the table). Stage A: 42 rows of 200 scratch nights (8,400 bouts).
- **The pass rule.** Each option against the plain guarantee house on the same roll; A beats B when it is ahead by the
  line on one axis ($1,000 of gym cash by week 40, or 3 debut wins in 100) and not behind by the line on the other.

## 4. Limits

- 168 rolls, not 180; the full cell has 74. One cell's error is $255.
- The bot does not run the gym: cash falls in every career, and in the cells with room 5% to 18% of gyms close before
  week 40 (more under the guarantee house, whose debut is two weeks later). The table of gaps "where no option's gym
  closed" gives the same reading ($1,389 to $1,545).
- The line rule is not transitive near $1,000: Softer "beats" the ticket house's plain offer at -$941 and -$864 of cash,
  which takes the plain offer out of "right" in the 48 and 64 cells although it is a trade against the guarantee house
  there. Without Softer the plain ticket offer is right in all three cells with room.
- Lost against won debuts (bar 12) is not paired: the boxers who lose are also the weaker ones.
- v12's rules live in the probe, applied around the game's own functions: the name, the seat, the fans and the rebuild
  flag after the game's own result; the road by removing rows from the promoter's set before the bot reads it.
- Two shards lost their place in the Godot queue to a lock error in `ops/Tools/godot_slot.py` (`PermissionError` on
  `godot_queue/.lock`) and were run again; no data was lost. Earlier runs with a call-spacing fault are not counted.
- `tests/debut_pick_test.gd` was not run: nothing under `scripts/` changed.

## 5. Reproduce

```
python ops/Tools/godot_slot.py run --who turnprobe12 -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/turnprobe12.gd -- stage=b boxers=0 seeds=1 days=30 out=<b_0.jsonl>
   (one run a boxer, 0 to 5; 10 to 30 minutes each)
... -- stage=a nights=200 out=<a.jsonl>                                             (6 minutes)
python tools/turnprobe12_sum.py a.jsonl b_0.jsonl ... b_5.jsonl
```

## 6. Tables (as printed by tools/turnprobe12_sum.py)

"Right" = beaten by nobody on the pass rule. "The one answer" = beats every other option.

### Population

- run: boxers [0], 1 seeds x 30 call days, to week 40, cells ['48', '56', '64', 'full'] (today's rules also in ['56', 'full'])
- run: boxers [1], 1 seeds x 30 call days, to week 40, cells ['48', '56', '64', 'full'] (today's rules also in ['56', 'full'])
- run: boxers [2], 1 seeds x 30 call days, to week 40, cells ['48', '56', '64', 'full'] (today's rules also in ['56', 'full'])
- run: boxers [3], 1 seeds x 30 call days, to week 40, cells ['48', '56', '64', 'full'] (today's rules also in ['56', 'full'])
- run: boxers [4], 1 seeds x 30 call days, to week 40, cells ['48', '56', '64', 'full'] (today's rules also in ['56', 'full'])
- run: boxers [5], 1 seeds x 30 call days, to week 40, cells ['48', '56', '64', 'full'] (today's rules also in ['56', 'full'])

| Boxer | Rolls (call weeks) | Call days | Record at the calls | Strength (no camp) | Gym's own seats | Room for members (cap) | Loyalty |
|---|---|---|---|---|---|---|---|
| Lucy Jackson (Out-boxer) | 31 | 174 .. 664 | 7-2 .. 19-4 | 65.9 .. 74.3 | 69 .. 95 | 66 | 55 .. 86 |
| Kira Mensah (Out-boxer) | 31 | 265 .. 622 | 7-1 .. 12-3 | 67.1 .. 71.5 | 68 .. 81 | 66 | 76 .. 96 |
| Samira Khan (Slugger) | 31 | 398 .. 846 | 7-8 .. 17-9 | 69.7 .. 74.3 | 69 .. 91 | 66 | 58 .. 71 |
| Tess Reilly (Pressure fighter) | 28 | 41 .. 454 | 7-4 .. 14-9 | 59.4 .. 68.9 | 63 .. 86 | 66 | 55 .. 64 |
| Danny Osei (Boxer-puncher) | 21 | 167 .. 454 | 7-1 .. 14-1 | 63.7 .. 69.2 | 70 .. 86 | 66 | 88 .. 100 |
| Josh Harper (Pressure fighter) | 26 | 111 .. 496 | 7-2 .. 15-4 | 60.4 .. 67.0 | 68 .. 88 | 66 | 58 .. 82 |

Rolls: 168. Careers played and counted: 2388 (v12 1680, today's rules 708). Cells skipped because one house called alone: 88.

### Stage A - the night (the same scratch nights for every row of a boxer)

| Rules | Option | Boxers | Card shows (mean) | Played win (mean) | lowest .. highest | Draw | Loss | Stopped losses |
|---|---|---|---|---|---|---|---|---|
| today | ticket no ask | 6 | 60.5 | 61.1 | 54.0 .. 69.0 | 18.2 | 20.8 | 4.3 |
| today | guarantee no ask | 6 | 75.1 | 79.1 | 72.0 .. 84.0 | 12.9 | 8.0 | 2.4 |
| v12 | ticket no ask | 6 | 60.4 | 59.9 | 54.0 .. 66.0 | 17.5 | 22.6 | 3.8 |
| v12 | ticket softer | 6 | 65.6 | 63.9 | 57.5 .. 70.5 | 17.2 | 18.9 | 3.0 |
| v12 | ticket later2 | 6 | 62.4 | 61.4 | 55.0 .. 70.0 | 17.6 | 21.0 | 3.6 |
| v12 | guarantee no ask | 6 | 75.0 | 78.6 | 69.0 .. 85.5 | 13.2 | 8.2 | 1.1 |
| v12 | guarantee later2 | 6 | 77.0 | 79.8 | 70.0 .. 87.0 | 13.0 | 7.2 | 0.9 |

Softer against the ticket house's plain offer: +4.0 played wins in 100 (card +5.2).

### The mutant: today's costs ask against today's plain guarantee house (the instrument must see it)

| Cell | Pairs | Cash by the last week | error | Debut wins in 100 |
|---|---|---|---|---|
| 56 | 162 | +920 | 7 | +0.0 |
| 56 (today's ticket house, no ask) | 162 | +450 | 179 | -21.0 |
| full | 74 | +909 | 0 | +0.0 |
| full (today's ticket house, no ask) | 74 | +641 | 215 | -18.9 |

### Stage B - map v12, cell by cell (pooled over boxers and rolls)

| Cell | Option | n | Debut win / draw / loss | Seats on the night | Name won on the night | Cash by the last week | Members | Reputation | Ranked | Fans | Pro wins - losses | Pro fights | Step ups / tune-ups / paydays booked | Chin ceiling | Morale | Loyalty | Gym closed |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 48 | guarantee no ask (right) | 162 | 78 / 13 / 9 | 63 | +0.0 | -12382 | 64 | 20 | 69% | +4.6 | 4.07 - 0.37 | 4.8 | 33 / 67 / 0 | 98.3 | 6 | 67 | 18% |
| 48 | ticket no ask | 162 | 55 / 22 / 23 | 60 | +8.1 | -10823 | 63 | 22 | 95% | +4.9 | 3.23 - 0.77 | 4.4 | 84 / 14 / 2 | 98.0 | 6 | 67 | 9% |
| 48 | ticket softer | 162 | 62 / 18 / 20 | 60 | +0.0 | -11764 | 60 | 15 | 92% | +4.9 | 3.28 - 0.78 | 4.4 | 84 / 13 / 3 | 98.0 | 7 | 67 | 10% |
| 56 | guarantee no ask (right) | 162 | 78 / 13 / 9 | 65 | +0.0 | -11831 | 64 | 20 | 70% | +4.7 | 4.10 - 0.37 | 4.9 | 33 / 67 / 0 | 98.3 | 6 | 67 | 14% |
| 56 | ticket no ask (right) | 162 | 55 / 22 / 23 | 64 | +8.6 | -10175 | 63 | 23 | 96% | +5.0 | 3.25 - 0.77 | 4.4 | 84 / 14 / 2 | 98.0 | 6 | 67 | 7% |
| 56 | ticket softer | 162 | 62 / 18 / 20 | 64 | +0.0 | -11224 | 60 | 15 | 93% | +5.0 | 3.30 - 0.78 | 4.5 | 84 / 13 / 3 | 98.0 | 7 | 67 | 8% |
| 64 | guarantee no ask (right) | 162 | 78 / 13 / 9 | 68 | +0.0 | -10809 | 65 | 24 | 70% | +4.7 | 4.14 - 0.37 | 4.9 | 33 / 67 / 0 | 98.3 | 6 | 67 | 8% |
| 64 | ticket no ask | 162 | 55 / 22 / 23 | 67 | +9.2 | -9292 | 64 | 27 | 96% | +5.0 | 3.25 - 0.78 | 4.4 | 84 / 14 / 2 | 97.9 | 6 | 67 | 6% |
| 64 | ticket softer | 162 | 62 / 18 / 20 | 67 | +0.0 | -10156 | 62 | 18 | 93% | +5.0 | 3.30 - 0.78 | 4.5 | 84 / 13 / 3 | 98.0 | 7 | 67 | 5% |
| full | guarantee no ask **(the one answer)** | 74 | 72 / 20 / 8 | 70 | +0.0 | -7460 | 68 | 66 | 57% | +3.6 | 4.00 - 0.43 | 5.0 | 29 / 71 / 0 | 98.5 | 10 | 74 | 0% |
| full | ticket no ask | 74 | 54 / 24 / 22 | 70 | +9.3 | -6841 | 68 | 69 | 97% | +4.5 | 3.12 - 0.89 | 4.5 | 81 / 16 / 3 | 98.1 | 10 | 73 | 0% |
| full | ticket softer | 74 | 61 / 20 / 19 | 70 | +0.0 | -6785 | 68 | 60 | 93% | +4.5 | 3.16 - 0.89 | 4.6 | 81 / 14 / 5 | 98.1 | 11 | 73 | 0% |

### The pass rule: each option against the plain guarantee house on the same roll

| Cell | Option | Pairs | Cash by the last week | error | Debut wins in 100 | error | Reputation | Reads |
|---|---|---|---|---|---|---|---|---|
| 48 | ticket no ask | 162 | +1559 | 246 | -22.8 | 5.3 | +2.7 | a trade |
| 48 | ticket softer | 162 | +618 | 202 | -16.0 | 5.3 | -5.0 | beaten by it |
| 56 | ticket no ask | 162 | +1656 | 250 | -22.8 | 5.3 | +3.2 | a trade |
| 56 | ticket softer | 162 | +607 | 201 | -16.0 | 5.3 | -5.1 | beaten by it |
| 64 | ticket no ask | 162 | +1518 | 244 | -22.8 | 5.3 | +3.4 | a trade |
| 64 | ticket softer | 162 | +654 | 197 | -16.0 | 5.3 | -5.3 | beaten by it |
| full | ticket no ask | 74 | +619 | 255 | -17.6 | 8.2 | +3.5 | beaten by it |
| full | ticket softer | 74 | +676 | 249 | -10.8 | 8.1 | -5.6 | beaten by it |

The same gaps on the rolls where no option's gym closed (the bot does not run the gym; a closed gym stops its own bills):

| Cell | Option | Pairs | Cash by the last week | error | Debut wins in 100 |
|---|---|---|---|---|---|
| 48 | ticket no ask | 128 | +1389 | 260 | -23.4 |
| 48 | ticket softer | 128 | +433 | 219 | -17.2 |
| 56 | ticket no ask | 136 | +1545 | 262 | -22.8 |
| 56 | ticket softer | 136 | +478 | 217 | -16.9 |
| 64 | ticket no ask | 146 | +1494 | 253 | -21.2 |
| 64 | ticket softer | 146 | +608 | 207 | -14.4 |
| full | ticket no ask | 74 | +619 | 255 | -17.6 |
| full | ticket softer | 74 | +676 | 249 | -10.8 |

### Who is right, cell by cell

| Cell | Right (beaten by nobody) | The one answer |
|---|---|---|
| 48 | guarantee no ask | - |
| 56 | guarantee no ask, ticket no ask | - |
| 64 | guarantee no ask | - |
| full | guarantee no ask | guarantee no ask |

Softer against the ticket house's plain offer, same roll:
- 48: cash -941 (error 136), debut wins +6.8 in 100 (error 2.0)
- 56: cash -1049 (error 139), debut wins +6.8 in 100 (error 2.0)
- 64: cash -864 (error 141), debut wins +6.8 in 100 (error 2.0)
- full: cash +56 (error 128), debut wins +6.8 in 100 (error 2.9)

### Boxer by boxer (a cell = boxer x gym, 24 cells)

| Option | right in | the one answer in |
|---|---|---|
| guarantee no ask | 22 of 24 | 8 of 24 |
| ticket no ask | 7 of 24 | 0 of 24 |
| ticket softer | 10 of 24 | 2 of 24 |

### What a debut loss leaves at the last week (the same option, lost against won)

| Rules | Option | Debuts won / lost | Cash, lost less won | Ranked, won / lost | Pro wins after the debut, won / lost | Rebuilding at the last week, lost |
|---|---|---|---|---|---|---|
| today | guarantee no ask | 165 / 19 | -1434 | 88% / 74% | 2.98 / 2.58 | 42% |
| today | ticket no ask | 117 / 52 | -1168 | 94% / 100% | 3.26 / 3.04 | 27% |
| v12 | guarantee no ask | 425 / 48 | -2296 | 76% / 48% | 3.39 / 3.17 | 31% |
| v12 | ticket no ask | 301 / 124 | -3619 | 100% / 96% | 2.72 / 3.04 | 24% |
| v12 | ticket softer | 339 / 107 | -1992 | 94% / 95% | 2.65 / 3.04 | 24% |

### The bars

| # | Bar | Reads | Verdict |
|---|---|---|---|
| 1 | Instrument: today's costs ask reads +$700 to +$1,100 against today's plain guarantee house, error under $100, in every cell it is played | 56: +920, error 7; full: +909, error 0 | PASS |
| 2 | Instrument: the error on every option's cash gap is $250 or less in every pooled cell (a $1,000 gap is four errors) | largest error $255 | **FAIL** |
| 3 | Played debut wins: ticket house 52 to 68 in 100, guarantee house 70 to 82 | 59.9 and 78.6 | PASS |
| 4 | The card is honest: shown within 3 of played, each house (weeks past four) | ticket 60.4 shown, 59.9 played; guarantee 75.0 shown, 78.6 played | **FAIL** |
| 5 | The fork is a trade somewhere: the ticket house, no ask, is $1,000+ ahead on cash and 3+ debut wins behind in at least one cell | cells: 48, 56, 64 | PASS |
| 6 | The fork flips: the plain guarantee house beats the ticket house's plain offer in at least one cell | cells: full | PASS |
| 7 | AUDIT: no option is the one answer in more than 6 cells of 10 | guarantee no ask 1 of 4; ticket no ask 0 of 4; ticket softer 0 of 4 | PASS |
| 8 | AUDIT: every option is right (beaten by nobody) in at least one cell | guarantee no ask 4 of 4; ticket no ask 1 of 4; ticket softer 0 of 4 | **FAIL** |
| 9 | AUDIT: best against laziest - in at least half the cells an option is ahead of the plain guarantee house by $1,000 or 3 wins in 100 | 3 of 4 cells (48, 56, 64) | PASS |
| 10 | Softer wins somewhere and loses somewhere against the ticket house's plain offer | softer beats it in: 48, 64, full; beaten by it in: none | **FAIL** |
| 11 | Boxer by boxer: no option the one answer in more than 6 cells of 10, every option right in at least 2 | guarantee no ask right 22, one answer 8 of 24; ticket no ask right 7, one answer 0 of 24; ticket softer right 10, one answer 2 of 24 | PASS |
| 12 | A debut loss leaves a mark at the last week: $1,000+ of cash or 20+ points of ranked share behind the same option's wins | v12: cash -2287, ranked +1 points behind; today: cash -972, ranked -3 | PASS |
| 13 | The roads differ: step ups are 25+ points more of the ticket house's bookings than of the guarantee house's | ticket 84% step ups, guarantee 32%; ranked by the last week 96% against 68% | PASS |
| 14 | Later +2: the card shows +1 to +4, the played gain is not below 0 (a calendar tool, not a fork lever) | card +2.0 / +2.0; played +1.5 (ticket), +1.2 (guarantee) | PASS |
| 15 | The name stays: the ticket house's plain offer ends 4+ reputation ahead of the plain guarantee house in every cell with room | +2.7, +3.2, +3.4 | **FAIL** |

Bars passed: 10 of 15. Audit bars (7, 8, 9): not all pass. VERDICT: FAIL (PASS = 12 or more with every audit bar).
