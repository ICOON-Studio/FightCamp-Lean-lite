# TURNPROBE13 RESULT - map v13 of turning pro, measured before any critic scores it

S536, TURNPRO13 side console. Task: `ops/research/TASK_TURNPRO13.md`. Map: `ops/research/DESIGN_TURNPRO1_V13.md` (its probe is
section 9). Measurement only: nothing under `scripts/` was touched. v13's rules are a flagged local copy,
`tools/turnprobe13_rules.gd`; the runner is `tools/turnprobe13.gd`; the tables come from `tools/turnprobe13_sum.py`.
The population, the pairing, the bot, the cells and the pass rule are probe 12's.

## 1. Verdict: PASS, 14 of 15 bars, every audit bar (v12 was 10 of 15, v11 4 of 15)

1. **The name now stays.** The ticket house ends 8.1 to 8.7 reputation ahead of the guarantee house by week 40 in every
   cell with room (probe 12: 2.7 to 3.4; the bar is 4). With the tune-up rule switched off on the same rolls the lead is
   2.3: the rule adds 6.1. The guarantee house's road wins 2.4 tune-ups in its first fights, each now worth 2, not 5.
2. **The fork is still a trade with room, and bigger.** The ticket house ends $1,812 to $1,976 of gym cash ahead (error
   about $216, nine errors) and gives away 28 debut wins in 100. With the rule off the cash lead is $1,458: the lasting
   name is worth about $500 by week 40.
3. **It still flips in a full gym.** There the ticket house is $630 ahead (under the line) and 19 wins behind: the
   guarantee house is the one answer. The rule changes nothing there ($630 with it on or off), as designed: a name with
   no room pays nothing.
4. **With Softer gone, both options are choices.** The guarantee house is right in 4 of 4 cells, the ticket house in 3 of
   4; neither is the one answer in more than 1 of 4. Boxer by boxer the ticket house is right in 18 of 24 cells.
5. **The card is honest.** The guarantee house shows 78.1 and plays 78.8 (probe 12: 75.0 and 78.6); the ticket house
   shows 60.3 and plays 59.3. Later +2 shows +2.0 and plays +2.1 and +1.1.
6. **The one miss is the instrument's:** bar 2, the cash error in the full cell is $253 against a bar of $250 (74 pairs;
   in the cells with room it is $215 to $217 on 216 pairs). The full cell cannot grow: in 142 of the 216 rolls only the
   ticket house calls there (the seats pass 74).

## 2. What this does not show (read before scoring)

- **Two options are easier to pass than three.** Bars 7, 8 and 11 were written for a screen with asks. With two options
  they say only that neither house is always right. The honest size of the mechanic is ONE decision with a real trade and
  a real flip, plus a road of six fights that now carries it; it is not a deep screen.
- **The bot does not read the +2 / +5 line.** It books the fight read nearest 65 in 100. So the probe sizes the rule; it
  does not show a player using it (taking a step up early at the guarantee house for the name). That is for the critics
  and the build's play test.
- **The ticket house is never the one answer.** It is a trade everywhere there is room. Whether giving away 28 debut wins
  in 100 for about $1,900 and 8 reputation FEELS like a real offer is a taste question the probe cannot answer.
- **The debut gap grew.** Played in careers the ticket house wins 51 debuts in 100 and the guarantee house 79 (probe 12:
  55 and 78). On the scratch nights the ticket house plays 59.3. The older records of the late call weeks (36 call days
  now, 30 then) are the likely cause; it was not isolated.
- **The guarantee house's gyms close more often** with room (16% to 25% against 9% to 14%): its debut is two weeks later
  and the bot does not run the gym. The table "where no option's gym closed" gives the same reading ($1,699 to $1,907).
- Lost against won debuts (bar 12) is not paired: the boxers who lose are also the weaker ones.

## 3. What was run

- **Population.** The six people the game can sign, each played from signing to the first pro call by a bot that takes
  every legal bout, then called on 37 different weeks: **222 rolls** (probe 12: 168). A boxer's call week is one roll,
  because a bout's dice are the fight day's.
- **Cells.** The gym on the day of the call: seats 48, 56 and 64 with room for more members (cap 66), and a full gym
  (members at the cap, a name that draws 10 more). $12,000 in the bank. 216 rolls in each cell with room; 74 in the full
  cell.
- **Arms.** V13 = the map's sections 3 to 5 (ticket house, guarantee house; no ask). FLAT = v13 with the tune-up rule
  off, in the 56 and full cells. TODAY = the game's own functions in the same two cells (ticket no ask; guarantee no ask,
  costs). The mutant is today's costs ask: it reads +$928 and +$909.
- **2,894 careers** from the call to week 40. Stage A: 36 rows of 200 scratch nights (7,200 bouts).
- **The v13 rules in the probe.** The card: the game's read, plus 0.2 of every point over 60, plus a point a camp week
  past four; the guarantee house's target +3 on that card. A tune-up win: 3 of the game's 5 reputation taken back after
  the game's own result. Everything else is v12's local copy (the name by seats, the table's last seat, the rebuild flag,
  the firm road).

## 4. How it was run, and one fault

- Three batches were queued through `ops/Tools/godot_slot.py` (who turnpro13). After the first one started, Claude Code
  stopped the three queue waiters because the PC was low on memory; the Godot runs themselves kept going OUTSIDE the
  queue (about 2.3 GB each) and drove RAM to 97%. They were left to finish at another session's request. Every run ended
  with its own "TURNPROBE13 done" line and no script error; no data was lost or mixed.
- **For the next probe:** one run at a time through the queue, never three batches; a killed waiter does not kill its
  Godot child, so check the process list before reporting a run stopped.
- `tests/golden_path_test.gd` was not run: nothing under `scripts/` changed.

## 5. Reproduce

```
python ops/Tools/godot_slot.py run --who turnprobe13 -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/turnprobe13.gd -- stage=b boxers=0 seeds=1 days=36 out=<b_0.jsonl>
   (one run a boxer, 0 to 5, ONE AT A TIME; about 25 minutes each on a quiet PC)
... -- stage=a nights=200 out=<a.jsonl>                                             (6 minutes)
python tools/turnprobe13_sum.py a.jsonl b_0.jsonl ... b_5.jsonl
```

## 6. Tables (as printed by tools/turnprobe13_sum.py)

"Right" = beaten by nobody on the pass rule. "The one answer" = beats every other option.

### Population

- run: boxers [0, 3], 1 seeds x 36 call days, to week 40, cells ['48', '56', '64', 'full'] (today's rules also in ['56', 'full'])
- run: boxers [1, 4], 1 seeds x 36 call days, to week 40, cells ['48', '56', '64', 'full'] (today's rules also in ['56', 'full'])
- run: boxers [2, 5], 1 seeds x 36 call days, to week 40, cells ['48', '56', '64', 'full'] (today's rules also in ['56', 'full'])

| Boxer | Rolls (call weeks) | Call days | Record at the calls | Strength (no camp) | Gym's own seats | Room for members (cap) | Loyalty |
|---|---|---|---|---|---|---|---|
| Lucy Jackson (Out-boxer) | 37 | 174 .. 776 | 7-2 .. 22-4 | 65.9 .. 75.5 | 69 .. 100 | 66 | 55 .. 86 |
| Kira Mensah (Out-boxer) | 37 | 265 .. 706 | 7-1 .. 14-3 | 67.1 .. 72.3 | 68 .. 86 | 66 | 72 .. 96 |
| Samira Khan (Slugger) | 37 | 398 .. 958 | 7-8 .. 19-10 | 69.7 .. 75.7 | 69 .. 95 | 66 | 55 .. 71 |
| Tess Reilly (Pressure fighter) | 37 | 41 .. 629 | 7-4 .. 18-10 | 59.4 .. 71.3 | 63 .. 93 | 66 | 55 .. 64 |
| Danny Osei (Boxer-puncher) | 37 | 167 .. 734 | 7-1 .. 22-1 | 63.7 .. 73.1 | 70 .. 100 | 66 | 72 .. 100 |
| Josh Harper (Pressure fighter) | 37 | 111 .. 678 | 7-2 .. 20-4 | 60.4 .. 69.2 | 68 .. 97 | 66 | 58 .. 82 |

Rolls: 222. Careers played and counted: 2894 (v13 1444, v13 with the tune-up rule off 580, today's rules 870). Cells skipped because one house called alone: 142.

### Stage A - the night (the same scratch nights for every row of a boxer)

| Rules | Option | Boxers | Card shows (mean) | Played win (mean) | lowest .. highest | Draw | Loss | Stopped losses |
|---|---|---|---|---|---|---|---|---|
| today | ticket no ask | 6 | 60.5 | 61.1 | 54.0 .. 69.0 | 18.2 | 20.8 | 4.3 |
| today | guarantee no ask | 6 | 75.1 | 79.1 | 72.0 .. 84.0 | 12.9 | 8.0 | 2.4 |
| v13 | ticket no ask | 6 | 60.3 | 59.3 | 54.0 .. 66.0 | 17.8 | 22.9 | 4.0 |
| v13 | ticket later2 | 6 | 62.3 | 61.4 | 55.0 .. 70.0 | 17.5 | 21.1 | 3.6 |
| v13 | guarantee no ask | 6 | 78.1 | 78.8 | 69.5 .. 86.0 | 13.3 | 7.8 | 1.1 |
| v13 | guarantee later2 | 6 | 80.1 | 79.9 | 70.0 .. 87.0 | 13.2 | 6.8 | 0.8 |

### The mutant: today's costs ask against today's plain guarantee house (the instrument must see it)

| Cell | Pairs | Cash by the last week | error | Debut wins in 100 |
|---|---|---|---|---|
| 56 | 216 | +928 | 15 | +0.0 |
| 56 (today's ticket house, no ask) | 216 | +321 | 162 | -25.9 |
| full | 74 | +909 | 0 | +0.0 |
| full (today's ticket house, no ask) | 74 | +633 | 217 | -18.9 |

### Stage B - map v13, cell by cell (pooled over boxers and rolls)

| Cell | Option | n | Debut win / draw / loss | Seats on the night | Name won on the night | Cash by the last week | Members | Reputation | Ranked | Fans | Pro wins - losses | Pro fights | Step ups / tune-ups / paydays booked | Tune-up wins | Chin ceiling | Morale | Loyalty | Gym closed |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 48 | guarantee no ask (right) | 216 | 79 / 13 / 8 | 65 | +0.0 | -13362 | 59 | 12 | 71% | +4.6 | 4.06 - 0.35 | 4.8 | 32 / 68 / 0 | 2.41 | 98.3 | 4 | 66 | 25% |
| 48 | ticket no ask (right) | 216 | 51 / 23 / 25 | 62 | +7.7 | -11446 | 62 | 20 | 92% | +4.9 | 3.21 - 0.81 | 4.4 | 82 / 15 / 3 | 0.45 | 97.9 | 5 | 65 | 14% |
| 56 | guarantee no ask (right) | 216 | 79 / 13 / 8 | 68 | +0.0 | -12879 | 60 | 12 | 72% | +4.6 | 4.10 - 0.35 | 4.8 | 33 / 67 / 0 | 2.43 | 98.3 | 5 | 66 | 22% |
| 56 | ticket no ask (right) | 216 | 51 / 23 / 25 | 65 | +8.1 | -10903 | 62 | 21 | 93% | +4.9 | 3.22 - 0.81 | 4.4 | 82 / 15 / 3 | 0.45 | 97.9 | 5 | 65 | 12% |
| 64 | guarantee no ask (right) | 216 | 79 / 13 / 8 | 70 | +0.0 | -11846 | 61 | 15 | 73% | +4.7 | 4.14 - 0.36 | 4.9 | 33 / 67 / 0 | 2.44 | 98.3 | 4 | 66 | 16% |
| 64 | ticket no ask (right) | 216 | 51 / 23 / 25 | 69 | +8.7 | -10034 | 63 | 24 | 93% | +4.9 | 3.24 - 0.81 | 4.4 | 82 / 15 / 3 | 0.46 | 97.9 | 5 | 65 | 9% |
| full | guarantee no ask **(the one answer)** | 74 | 73 / 19 / 8 | 70 | +0.0 | -7450 | 68 | 58 | 58% | +3.6 | 4.01 - 0.42 | 5.0 | 29 / 71 / 0 | 2.62 | 98.5 | 11 | 74 | 0% |
| full | ticket no ask | 74 | 54 / 24 / 22 | 70 | +9.3 | -6819 | 68 | 68 | 95% | +4.5 | 3.12 - 0.89 | 4.6 | 81 / 15 / 4 | 0.49 | 98.1 | 10 | 73 | 0% |

### The pass rule: each option against the plain guarantee house on the same roll

| Cell | Option | Pairs | Cash by the last week | error | Debut wins in 100 | error | Reputation | Reads |
|---|---|---|---|---|---|---|---|---|
| 48 | ticket no ask | 216 | +1916 | 216 | -28.2 | 4.5 | +8.1 | a trade |
| 56 | ticket no ask | 216 | +1976 | 217 | -28.2 | 4.5 | +8.4 | a trade |
| 64 | ticket no ask | 216 | +1812 | 215 | -28.2 | 4.5 | +8.7 | a trade |
| full | ticket no ask | 74 | +630 | 253 | -18.9 | 8.1 | +9.8 | beaten by it |

The same gaps on the rolls where no option's gym closed (the bot does not run the gym; a closed gym stops its own bills):

| Cell | Option | Pairs | Cash by the last week | error | Debut wins in 100 |
|---|---|---|---|---|---|
| 48 | ticket no ask | 153 | +1699 | 228 | -30.7 |
| 56 | ticket no ask | 164 | +1907 | 235 | -28.7 |
| 64 | ticket no ask | 177 | +1787 | 225 | -26.6 |
| full | ticket no ask | 74 | +630 | 253 | -18.9 |

### Who is right, cell by cell

| Cell | Right (beaten by nobody) | The one answer |
|---|---|---|
| 48 | guarantee no ask, ticket no ask | - |
| 56 | guarantee no ask, ticket no ask | - |
| 64 | guarantee no ask, ticket no ask | - |
| full | guarantee no ask | guarantee no ask |

### The new lever's control arm: v13 with the tune-up rule off (every pro win pays 5 reputation), same rolls

| Cell | Pairs | Ticket house's reputation lead, v13 | the rule off | The rule adds | Ticket house's cash lead, v13 | the rule off |
|---|---|---|---|---|---|---|
| 56 | 216 | +8.4 | +2.3 | +6.1 | +1976 | +1458 |
| full | 74 | +9.8 | +3.4 | +6.4 | +630 | +630 |

### Boxer by boxer (a cell = boxer x gym, 24 cells)

| Option | right in | the one answer in |
|---|---|---|
| guarantee no ask | 24 of 24 | 6 of 24 |
| ticket no ask | 18 of 24 | 0 of 24 |

### What a debut loss leaves at the last week (the same option, lost against won)

| Rules | Option | Debuts won / lost | Cash, lost less won | Ranked, won / lost | Pro wins after the debut, won / lost | Rebuilding at the last week, lost |
|---|---|---|---|---|---|---|
| today | guarantee no ask | 209 / 24 | -1439 | 89% / 79% | 2.92 / 2.58 | 42% |
| today | ticket no ask | 139 / 70 | -1352 | 94% / 97% | 3.24 / 3.07 | 30% |
| v13 | guarantee no ask | 558 / 57 | -2137 | 77% / 63% | 3.34 / 3.37 | 19% |
| v13 | ticket no ask | 361 / 175 | -4237 | 100% / 94% | 2.74 / 3.08 | 27% |

### The bars

| # | Bar | Reads | Verdict |
|---|---|---|---|
| 1 | Instrument: today's costs ask reads +$700 to +$1,100 against today's plain guarantee house, error under $100, in every cell it is played | 56: +928, error 15; full: +909, error 0 | PASS |
| 2 | Instrument: the error on every option's cash gap is $250 or less in every pooled cell (a $1,000 gap is four errors) | largest error $253 | **FAIL** |
| 3 | Played debut wins: ticket house 52 to 68 in 100, guarantee house 70 to 82 | 59.3 and 78.8 | PASS |
| 4 | The card is honest: shown within 3 of played, each house | ticket 60.3 shown, 59.3 played; guarantee 78.1 shown, 78.8 played | PASS |
| 5 | The fork is a trade somewhere: the ticket house, no ask, is $1,000+ ahead on cash and 3+ debut wins behind in at least one cell | cells: 48, 56, 64 | PASS |
| 6 | The fork flips: the plain guarantee house beats the ticket house's plain offer in at least one cell | cells: full | PASS |
| 7 | AUDIT: no option is the one answer in more than 6 cells of 10 | guarantee no ask 1 of 4; ticket no ask 0 of 4 | PASS |
| 8 | AUDIT: every option is right (beaten by nobody) in at least one cell | guarantee no ask 4 of 4; ticket no ask 3 of 4 | PASS |
| 9 | AUDIT: best against laziest - in at least half the cells an option is ahead of the plain guarantee house by $1,000 or 3 wins in 100 | 3 of 4 cells (48, 56, 64) | PASS |
| 10 | The lever is real: with the tune-up rule off, on the same rolls, the ticket house's reputation lead is 1+ smaller in every cell with room it is played in | 56: the rule adds +6.1 | PASS |
| 11 | Boxer by boxer: no option the one answer in more than 6 cells of 10, every option right in at least 2 | guarantee no ask right 24, one answer 6 of 24; ticket no ask right 18, one answer 0 of 24 | PASS |
| 12 | A debut loss leaves a mark at the last week: $1,000+ of cash or 20+ points of ranked share behind the same option's wins | v13: cash -2521, ranked -0 points behind; today: cash -1043, ranked -2 | PASS |
| 13 | The roads differ: step ups are 25+ points more of the ticket house's bookings than of the guarantee house's | ticket 82% step ups, guarantee 32%; ranked by the last week 93% against 70% | PASS |
| 14 | Later +2: the card shows +1 to +4, the played gain is not below 0 (a calendar tool, not a fork lever) | card +2.0 / +2.0; played +2.1 (ticket), +1.1 (guarantee) | PASS |
| 15 | The name stays: the ticket house's plain offer ends 4+ reputation ahead of the plain guarantee house in every cell with room | +8.1, +8.4, +8.7 | PASS |

Bars passed: 14 of 15. Audit bars (7, 8, 9): all pass. VERDICT: PASS (PASS = 12 or more with every audit bar).
