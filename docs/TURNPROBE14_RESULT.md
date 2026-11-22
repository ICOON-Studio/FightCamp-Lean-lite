# TURNPROBE14 RESULT - map v14 of turning pro, measured before any critic scores it

S537, TURNPRO14 side console. Task: `ops/research/TASK_TURNPRO14.md`. Map: `ops/research/DESIGN_TURNPRO1_V14.md` (its probe is
section 9). Measurement only: nothing under `scripts/` was touched. v14's rules are a flagged local copy,
`tools/turnprobe14_rules.gd`; the runner is `tools/turnprobe14.gd`; the tables come from `tools/turnprobe14_sum.py`.
The population, the pairing and the cash are probe 13's. The bars and their lines were fixed in the map before the run.

## 1. Verdict: PASS, 14 of 17 bars, every audit bar (7, 8, 9). Failed: 4, 10 and 15

1. **The kind of each fight is now a choice, and the three roads end in different places.** Inside one house the
   name-chaser books step ups in 85 to 87 of 100 bookings and the win-chaser in 0 to 14 (bar 13: +73 and +84 points).
   With room in the gym the name-chaser ends $1,000 to $1,200 of gym cash and 2.3 to 2.8 reputation ahead of the
   win-chaser, and 1.5 to 2.0 pro wins-less-losses behind it (216 pairs a cell, errors $115, 0.4, 0.11). Both kinds were
   on the table in 100% of the road's sets.
2. **No road is the one answer.** House by house (6 house x gym cells) the name-chaser is right in 2, the win-chaser in
   4, the favour-keeper in 5; the only "one answer" is the win-chaser at the ticket house in a full gym. Two roads differ
   by a line in 6 of 6.
3. **The house is still a trade with room and still flips in a full gym.** Ticket house, test night, keeper road:
   +$2,027 and +$1,928 of gym cash, 9 to 10 reputation ahead, 25 debut wins in 100 behind the plain guarantee house. In
   the full gym every ticket option is beaten by it (+$653, under the line, 18 wins behind).
4. **The debut night is a trade in all six house x gym cells.** The test debutant costs 7 to 9 debut wins in 100 and
   buys 4 to 8 reputation (and $500 to $900 with room; nothing in a full gym).
5. **The tune-up rule is what holds the win-chaser's name down:** with the rule off, on the same rolls, the win-chaser
   ends 9.8 to 11.6 reputation higher.
6. **The favour (stage F).** **Bar 15 failed, and the favour as written works backwards.** With the favour's rules on
   against off (same rolls, to week 80, 35 pairs a cell with room), the KEEPER gains nothing at the ticket house ($0:
   it took no title shot, because it leaves the house's kind once the favour is 8) and +$212 to +$354 at the guarantee
   house (the +$300 purses, $771 to $1,132 a career; under the $500 line). The REBEL is moved, but UPWARD: +$1,036 to
   +$1,383 of gym cash, and at the guarantee house +1.4 to +1.6 wins less losses. Under favour 3 the house takes the kind
   back in about 30 of 100 sets, and being made to book the house's kind was good for the rebel. Low favour is a help,
   not a price. This is the lever to fix before the build.
7. **Two bars failed.** Bar 4: on the mean every card is within 3 of played (60.2 shown / 62.9 played, 70.3 / 71.2,
   78.1 / 78.7, 68.1 / 70.1), but boxer by boxer the worst card is 8.4 to 12.1 under that boxer's own 200 nights (the bar
   is 8): the card under-reads the strongest boxer, worst on the guarantee house's test night. Bar 10: the name-chaser's
   reputation lead over the win-chaser is 2.3 to 2.8 where the bar asks 3 (the rule-off half of the bar passes).

## 2. What this does not show (read before scoring)

- **The bots follow fixed rules.** Three bots that are told to book different kinds will book different kinds: bars 13
  and 17 show the choice is on the table and is taken, not that a player feels it. No bot reads the boxer's form, the
  room in the gym or a title two wins away.
- **The win-chaser is the one answer in 12 of 36 boxer x house x gym cells** (the bar allows 6 in 10, so it passes), and
  it is right in 28 of 36. For a third of the boxer cells "keep him busy" is simply correct.
- **At the ticket house the keeper and the name-chaser read the same** ($62 and 0.8 reputation apart with room): there
  the favour-keeper mostly IS the name road. At the guarantee house the keeper sits between the two others.
- **The name-chaser at the guarantee house is never right when pooled:** it gives up 1.9 to 2.5 wins-less-losses for
  about $1,000 and 2.4 reputation, and ends at favour 2.8. Whether that is a real offer is a taste question.
- **Title shots came only to the ticket house's name-chaser** (7.5% of its sets); the keeper's stood at 0, because it
  switches to tune-ups once the favour is 8.
- **The full gym still has one house:** the plain guarantee house beats every ticket option there, on 74 rolls (in 142
  of the 216 rolls only one house calls in a full gym).
- **Every option ends under water** ($6,500 to $13,500 below zero by week 40) and 6% to 26% of the gyms with room close:
  the bot does not run the gym. The gaps are paired on the same roll, so they stand; the levels do not.
- The house pass rule has no reputation axis, so the guarantee house's test night reads "beaten by it" there (9 debut
  wins behind, $500 ahead) although it ends 4 reputation ahead; the night's own rule reads it as a trade.
- Lost against won debuts (bar 12) is not paired: the boxers who lose are also the weaker ones.

## 3. What was run

- **Population.** The six people the game can sign, each played from signing to the first pro call by a bot that takes
  every legal bout, then called on 36 different weeks at least a week apart: **216 rolls** in stage B (a boxer's call
  week is one roll, because a bout's dice are the fight day's), plus one call a boxer for stage A's scratch nights.
- **Cells.** The gym on the day of the call: seats 48 and 64 with room for more members (cap 66), and a full gym
  (members at the cap, a name that draws 10 more). $12,000 in the bank. 216 rolls in each cell with room; 74 in the full
  cell.
- **Options.** Eight a cell under v14: each house's own debut night with the three road bots (name-chaser, win-chaser,
  favour-keeper) and the other night with the keeper. FLAT = v14 with the tune-up rule off (the win-chaser) and TODAY =
  the game's own functions (ticket no ask; guarantee no ask, costs), both in the 64 and full cells. The mutant is
  today's costs ask: it reads +$934 and +$909.
- **5,498 careers** from the call to week 40 in stage B. Stage A: 48 rows of 200 scratch nights (9,600 bouts).
- **Stage F.** Each house's keeper and its full rebel (the other night, the other kind), favour rules on and off, to
  week 80. Planned on 72 rolls (12 call weeks a boxer); **read on 36** (boxers 0 to 2 whole, 809 careers): the run takes
  about 3.4 minutes a roll, twice the plan. Bar 15 is read on that half and failed on it.

## 4. How it was run

- An earlier run of this task was stopped by the PC's low-memory guard after 31 of 222 rolls; its output was not kept, so
  everything here is from the rerun.
- The rerun went ONE Godot run at a time through `ops/Tools/godot_slot.py` (who turnpro14), each run writing its own file
  and log: stage A (4 minutes), then stage B one boxer a run (32 to 40 minutes each), then stage F. Every run counted
  here ended with its own "TURNPROBE14 done" line and no script error, except stage F: its queue waiter reached
  the two-hour limit, the Godot run went on outside the queue and had grown to 9.4 GB of memory when it was stopped by
  its own process id after boxer 2's last whole roll. Its lines up to there are complete careers; boxers 3 to 5 were not
  played in stage F. The verdict does not hang on it: 14 bars pass without bar 15.
- `tests/golden_path_test.gd` was not run: nothing under `scripts/` changed.

## 5. Reproduce

```
python ops/Tools/godot_slot.py run --who turnpro14 -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/turnprobe14.gd -- stage=a nights=200 out=<a.jsonl>
... -- stage=b boxers=0 seeds=1 days=36 out=<b0.jsonl>      (one run a boxer, 0 to 5, ONE AT A TIME)
... -- stage=f seeds=1 days=12 weeks=80 out=<f.jsonl>       (slow: about 3.4 minutes a roll)
python tools/turnprobe14_sum.py a.jsonl b0.jsonl ... b5.jsonl f.jsonl
```

## 6. Tables (as printed by tools/turnprobe14_sum.py)

## Population

- run (stage b): boxers [0], 1 seeds x 36 call days, to week 40, cells ['48', '64', 'full'] (today's rules and the flat arm also in ['64', 'full'])
- run (stage b): boxers [1], 1 seeds x 36 call days, to week 40, cells ['48', '64', 'full'] (today's rules and the flat arm also in ['64', 'full'])
- run (stage b): boxers [2], 1 seeds x 36 call days, to week 40, cells ['48', '64', 'full'] (today's rules and the flat arm also in ['64', 'full'])
- run (stage b): boxers [3], 1 seeds x 36 call days, to week 40, cells ['48', '64', 'full'] (today's rules and the flat arm also in ['64', 'full'])
- run (stage b): boxers [4], 1 seeds x 36 call days, to week 40, cells ['48', '64', 'full'] (today's rules and the flat arm also in ['64', 'full'])
- run (stage b): boxers [5], 1 seeds x 36 call days, to week 40, cells ['48', '64', 'full'] (today's rules and the flat arm also in ['64', 'full'])
- run (stage f): boxers [0, 1, 2, 3, 4, 5], 1 seeds x 12 call days, to week 80, cells ['48', '64', 'full'] (today's rules and the flat arm also in ['64', 'full'])

| Boxer | Rolls (call weeks) | Call days | Record at the calls | Strength (no camp) | Gym's own seats | Room for members (cap) | Loyalty |
|---|---|---|---|---|---|---|---|
| Lucy Jackson (Out-boxer) | 36 | 174 .. 776 | 7-2 .. 22-4 | 65.9 .. 75.5 | 69 .. 100 | 66 | 55 .. 86 |
| Kira Mensah (Out-boxer) | 36 | 265 .. 706 | 7-1 .. 14-3 | 67.1 .. 72.3 | 68 .. 86 | 66 | 72 .. 96 |
| Samira Khan (Slugger) | 36 | 398 .. 958 | 7-8 .. 19-10 | 69.9 .. 75.7 | 69 .. 95 | 66 | 55 .. 71 |
| Tess Reilly (Pressure fighter) | 36 | 41 .. 629 | 7-4 .. 18-10 | 59.4 .. 71.3 | 63 .. 93 | 66 | 55 .. 64 |
| Danny Osei (Boxer-puncher) | 36 | 167 .. 734 | 7-1 .. 22-1 | 63.7 .. 73.1 | 70 .. 100 | 66 | 72 .. 100 |
| Josh Harper (Pressure fighter) | 36 | 111 .. 678 | 7-2 .. 20-4 | 60.4 .. 69.1 | 68 .. 97 | 66 | 58 .. 82 |

Rolls: 216. Careers played and counted, stage B: 5498 (v14 4048, v14 with the tune-up rule off 580, today's rules 870). Stage F (the favour, 80 weeks): 809 careers on 36 rolls. Cells skipped because one house called alone: 146.

## Stage A - the night (the same scratch nights for every row of a boxer)

| Rules | House | Debutant | Ask | Boxers | Card shows (mean) | Played win (mean) | lowest .. highest | Draw | Loss | Stopped losses | Worst boxer: card less played |
|---|---|---|---|---|---|---|---|---|---|---|---|
| today | guarantee | - | none | 6 | 75.3 | 80.2 | 73.5 .. 85.0 | 12.8 | 7.0 | 2.2 | -13.5 |
| today | ticket | - | none | 6 | 60.4 | 63.1 | 57.0 .. 70.0 | 17.3 | 19.6 | 3.9 | -9.9 |
| v14 | guarantee | build | later2 | 6 | 80.1 | 80.2 | 73.5 .. 85.5 | 12.2 | 7.6 | 2.2 | -8.8 |
| v14 | guarantee | build | none | 6 | 78.1 | 78.7 | 73.0 .. 84.5 | 13.1 | 8.2 | 2.4 | -9.8 |
| v14 | guarantee | test | none | 6 | 68.1 | 70.1 | 63.5 .. 76.5 | 15.8 | 14.2 | 3.1 | -12.1 |
| v14 | ticket | build | none | 6 | 70.3 | 71.2 | 67.5 .. 78.5 | 16.2 | 12.5 | 2.3 | -8.4 |
| v14 | ticket | test | later2 | 6 | 62.2 | 65.2 | 59.0 .. 76.0 | 17.2 | 17.6 | 3.8 | -13.9 |
| v14 | ticket | test | none | 6 | 60.2 | 62.9 | 57.0 .. 70.0 | 17.2 | 19.8 | 4.0 | -9.9 |

## The mutant: today's costs ask against today's plain guarantee house (the instrument must see it)

| Cell | Pairs | Cash by the last week | error | Debut wins in 100 |
|---|---|---|---|---|
| 64 | 216 | +934 | 11 | +0.0 |
| 64 (today's ticket house, no ask) | 216 | +286 | 160 | -25.0 |
| full | 74 | +909 | 0 | +0.0 |
| full (today's ticket house, no ask) | 74 | +463 | 206 | -17.6 |

## Stage B - map v14, cell by cell (pooled over boxers and rolls). An option = house, debutant, road bot

| Cell | Option | n | Debut win / draw / loss | Seats on the night | Name won on the night | Cash by the last week | Members | Reputation | Ranked | Fans | Pro wins - losses | Pro fights | Booked: step ups / tune-ups / rebuild / paydays (title shots) | Tune-up wins | Favour at the end | Morale | Loyalty | Gym closed |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 48 | guarantee build keeper | 216 | 75 / 16 / 9 | 65 | +0.0 | -13317 | 61 | 13.1 | 75% | +4.6 | 4.21 - 0.32 | 4.9 | 34 / 61 / 6 / 0 (0.0) | 2.40 | 7.2 | 5 | 65 | 24% |
| 48 | guarantee build name | 216 | 75 / 16 / 9 | 65 | +0.0 | -12499 | 60 | 13.9 | 92% | +4.5 | 3.16 - 0.71 | 4.3 | 85 / 1 / 14 / 0 (0.0) | 0.00 | 2.8 | 6 | 66 | 18% |
| 48 | guarantee build win | 216 | 75 / 16 / 9 | 65 | +0.0 | -13554 | 60 | 11.5 | 67% | +4.2 | 4.62 - 0.22 | 5.2 | 0 / 96 / 4 / 0 (0.0) | 3.72 | 9.8 | 5 | 65 | 26% |
| 48 | guarantee test keeper | 216 | 65 / 23 / 12 | 65 | +5.1 | -12795 | 63 | 17.1 | 62% | +4.5 | 4.53 - 0.28 | 5.2 | 14 / 81 / 5 / 0 (0.0) | 3.37 | 7.3 | 5 | 65 | 22% |
| 48 | ticket build keeper | 216 | 60 / 22 / 18 | 62 | +0.0 | -12202 | 61 | 15.5 | 93% | +5.0 | 3.42 - 0.68 | 4.4 | 86 / 3 / 11 / 0 (0.0) | 0.00 | 7.3 | 6 | 65 | 15% |
| 48 | ticket test keeper | 216 | 50 / 26 / 24 | 62 | +7.6 | -11290 | 63 | 22.4 | 92% | +4.9 | 3.66 - 0.59 | 4.7 | 62 / 27 / 11 / 0 (0.0) | 0.73 | 7.5 | 5 | 65 | 12% |
| 48 | ticket test name | 216 | 50 / 26 / 24 | 62 | +7.6 | -11228 | 63 | 21.6 | 94% | +4.6 | 3.24 - 0.82 | 4.5 | 87 / 0 / 13 / 0 (7.7) | 0.00 | 9.4 | 5 | 65 | 12% |
| 48 | ticket test win | 216 | 50 / 26 / 24 | 62 | +7.6 | -12449 | 63 | 18.8 | 65% | +4.6 | 4.31 - 0.39 | 5.1 | 14 / 79 / 7 / 0 (0.0) | 3.21 | 2.8 | 4 | 64 | 19% |
| 64 | guarantee build keeper | 216 | 75 / 16 / 9 | 70 | +0.0 | -11821 | 62 | 16.2 | 77% | +4.7 | 4.28 - 0.33 | 5.0 | 34 / 60 / 6 / 0 (0.0) | 2.46 | 7.2 | 5 | 65 | 15% |
| 64 | guarantee build name | 216 | 75 / 16 / 9 | 70 | +0.0 | -11070 | 62 | 17.0 | 93% | +4.5 | 3.19 - 0.71 | 4.3 | 85 / 2 / 14 / 0 (0.0) | 0.00 | 2.7 | 6 | 66 | 6% |
| 64 | guarantee build win | 216 | 75 / 16 / 9 | 70 | +0.0 | -12064 | 62 | 14.6 | 69% | +4.3 | 4.72 - 0.22 | 5.3 | 0 / 96 / 4 / 0 (0.0) | 3.83 | 9.8 | 5 | 65 | 16% |
| 64 | guarantee test keeper | 216 | 65 / 23 / 12 | 70 | +5.5 | -11320 | 65 | 20.7 | 67% | +4.7 | 4.63 - 0.29 | 5.3 | 15 / 80 / 5 / 0 (0.0) | 3.43 | 7.3 | 5 | 65 | 12% |
| 64 | ticket build keeper | 216 | 60 / 22 / 18 | 69 | +0.0 | -10757 | 62 | 18.6 | 93% | +5.0 | 3.46 - 0.69 | 4.5 | 86 / 3 / 11 / 0 (0.0) | 0.00 | 7.3 | 5 | 65 | 9% |
| 64 | ticket test keeper | 216 | 50 / 26 / 24 | 69 | +8.5 | -9894 | 64 | 26.2 | 92% | +4.9 | 3.68 - 0.60 | 4.7 | 61 / 27 / 11 / 0 (0.0) | 0.74 | 7.5 | 5 | 65 | 9% |
| 64 | ticket test name | 216 | 50 / 26 / 24 | 69 | +8.5 | -9830 | 64 | 25.4 | 94% | +4.7 | 3.25 - 0.83 | 4.5 | 87 / 0 / 13 / 0 (7.8) | 0.00 | 9.4 | 5 | 65 | 8% |
| 64 | ticket test win | 216 | 50 / 26 / 24 | 69 | +8.5 | -11011 | 64 | 22.7 | 66% | +4.7 | 4.36 - 0.39 | 5.2 | 14 / 79 / 7 / 0 (0.0) | 3.24 | 2.8 | 4 | 64 | 13% |
| full | guarantee build keeper | 74 | 68 / 24 / 8 | 70 | +0.0 | -7190 | 69 | 59.1 | 68% | +3.7 | 4.18 - 0.43 | 5.1 | 34 / 59 / 7 / 0 (0.0) | 2.46 | 7.2 | 12 | 73 | 0% |
| full | guarantee build name | 74 | 68 / 24 / 8 | 70 | +0.0 | -7203 | 67 | 58.6 | 88% | +3.4 | 2.84 - 0.86 | 4.2 | 80 / 1 / 18 / 0 (0.0) | 0.00 | 2.9 | 13 | 75 | 0% |
| full | guarantee build win | 74 | 68 / 24 / 8 | 70 | +0.0 | -7329 | 69 | 58.0 | 69% | +3.1 | 4.72 - 0.28 | 5.4 | 0 / 95 / 5 / 0 (0.0) | 3.86 | 9.8 | 12 | 73 | 0% |
| full | guarantee test keeper | 74 | 61 / 26 / 14 | 70 | +5.0 | -7350 | 69 | 63.6 | 62% | +3.7 | 4.58 - 0.36 | 5.4 | 15 / 78 / 7 / 0 (0.0) | 3.41 | 7.3 | 12 | 73 | 0% |
| full | ticket build keeper | 74 | 59 / 24 / 16 | 70 | +0.0 | -6539 | 68 | 61.3 | 93% | +4.7 | 3.36 - 0.80 | 4.6 | 86 / 2 / 12 / 0 (0.0) | 0.00 | 7.4 | 11 | 73 | 0% |
| full | ticket test keeper | 74 | 50 / 27 / 23 | 70 | +8.6 | -6538 | 68 | 68.8 | 93% | +4.2 | 3.54 - 0.74 | 4.9 | 61 / 26 / 13 / 0 (0.0) | 0.72 | 7.6 | 10 | 73 | 0% |
| full | ticket test name | 74 | 50 / 27 / 23 | 70 | +8.6 | -6559 | 67 | 68.2 | 96% | +4.2 | 3.12 - 0.96 | 4.7 | 85 / 0 / 15 / 0 (6.2) | 0.00 | 9.5 | 10 | 73 | 0% |
| full | ticket test win | 74 | 50 / 27 / 23 | 70 | +8.6 | -7098 | 69 | 67.4 | 72% | +3.8 | 4.65 - 0.45 | 5.6 | 14 / 79 / 7 / 0 (0.0) | 3.31 | 2.5 | 8 | 72 | 0% |

## The house: every option against the plain guarantee house (its own debutant, the keeper road) on the same roll

| Cell | Option | Pairs | Cash by the last week | error | Debut wins in 100 | error | Reputation | Pro wins less losses | Reads (cash and debut wins) |
|---|---|---|---|---|---|---|---|---|---|
| 48 | guarantee build name | 216 | +818 | 113 | +0.0 | 0.0 | +0.8 | -1.44 | no measured difference |
| 48 | guarantee build win | 216 | -237 | 66 | +0.0 | 0.0 | -1.6 | +0.50 | no measured difference |
| 48 | guarantee test keeper | 216 | +521 | 90 | -9.3 | 2.3 | +3.9 | +0.36 | beaten by it |
| 48 | ticket build keeper | 216 | +1115 | 149 | -15.7 | 4.5 | +2.4 | -1.15 | a trade |
| 48 | ticket test keeper | 216 | +2027 | 184 | -25.0 | 4.5 | +9.3 | -0.82 | a trade |
| 48 | ticket test name | 216 | +2089 | 191 | -25.0 | 4.5 | +8.5 | -1.48 | a trade |
| 48 | ticket test win | 216 | +868 | 171 | -25.0 | 4.5 | +5.7 | +0.03 | beaten by it |
| 64 | guarantee build name | 216 | +751 | 110 | +0.0 | 0.0 | +0.8 | -1.46 | no measured difference |
| 64 | guarantee build win | 216 | -242 | 66 | +0.0 | 0.0 | -1.5 | +0.56 | no measured difference |
| 64 | guarantee test keeper | 216 | +501 | 89 | -9.3 | 2.3 | +4.5 | +0.40 | beaten by it |
| 64 | ticket build keeper | 216 | +1064 | 145 | -15.7 | 4.5 | +2.4 | -1.18 | a trade |
| 64 | ticket test keeper | 216 | +1928 | 185 | -25.0 | 4.5 | +10.0 | -0.87 | a trade |
| 64 | ticket test name | 216 | +1991 | 191 | -25.0 | 4.5 | +9.3 | -1.53 | a trade |
| 64 | ticket test win | 216 | +810 | 169 | -25.0 | 4.5 | +6.5 | +0.02 | beaten by it |
| full | guarantee build name | 74 | -12 | 177 | +0.0 | 0.0 | -0.4 | -1.77 | no measured difference |
| full | guarantee build win | 74 | -138 | 103 | +0.0 | 0.0 | -1.1 | +0.69 | no measured difference |
| full | guarantee test keeper | 74 | -160 | 107 | -6.8 | 2.9 | +4.5 | +0.47 | beaten by it |
| full | ticket build keeper | 74 | +651 | 216 | -8.1 | 7.6 | +2.2 | -1.18 | beaten by it |
| full | ticket test keeper | 74 | +653 | 201 | -17.6 | 8.0 | +9.7 | -0.95 | beaten by it |
| full | ticket test name | 74 | +631 | 216 | -17.6 | 8.0 | +9.1 | -1.58 | beaten by it |
| full | ticket test win | 74 | +92 | 177 | -17.6 | 8.0 | +8.3 | +0.46 | beaten by it |

## The road, house by house (the house's own debutant; a cell here = house x gym)

| Cell | House | Road | n | Cash by the last week | Reputation | Pro wins less losses | Ranked | Step ups of bookings | Right | The one answer |
|---|---|---|---|---|---|---|---|---|---|---|
| 48 | ticket | name | 216 | -11228 | 21.6 | +2.41 | 94% | 87% | yes | - |
| 48 | ticket | win | 216 | -12449 | 18.8 | +3.93 | 65% | 14% | - | - |
| 48 | ticket | keeper | 216 | -11290 | 22.4 | +3.07 | 92% | 62% | yes | - |
| 48 | guarantee | name | 216 | -12499 | 13.9 | +2.45 | 92% | 85% | - | - |
| 48 | guarantee | win | 216 | -13554 | 11.5 | +4.40 | 67% | 0% | yes | - |
| 48 | guarantee | keeper | 216 | -13317 | 13.1 | +3.89 | 75% | 34% | yes | - |
| 64 | ticket | name | 216 | -9830 | 25.4 | +2.42 | 94% | 87% | yes | - |
| 64 | ticket | win | 216 | -11011 | 22.7 | +3.97 | 66% | 14% | - | - |
| 64 | ticket | keeper | 216 | -9894 | 26.2 | +3.08 | 92% | 61% | yes | - |
| 64 | guarantee | name | 216 | -11070 | 17.0 | +2.49 | 93% | 85% | - | - |
| 64 | guarantee | win | 216 | -12064 | 14.6 | +4.50 | 69% | 0% | yes | - |
| 64 | guarantee | keeper | 216 | -11821 | 16.2 | +3.95 | 77% | 34% | yes | - |
| full | ticket | name | 74 | -6559 | 68.2 | +2.16 | 96% | 85% | - | - |
| full | ticket | win | 74 | -7098 | 67.4 | +4.20 | 72% | 14% | yes | yes |
| full | ticket | keeper | 74 | -6538 | 68.8 | +2.80 | 93% | 61% | - | - |
| full | guarantee | name | 74 | -7203 | 58.6 | +1.97 | 88% | 80% | - | - |
| full | guarantee | win | 74 | -7329 | 58.0 | +4.43 | 69% | 0% | yes | - |
| full | guarantee | keeper | 74 | -7190 | 59.1 | +3.74 | 68% | 34% | yes | - |

The name-chaser against the win-chaser, same house, same rolls:

| Cell | House | Pairs | Cash | error | Reputation | error | Pro wins less losses | error |
|---|---|---|---|---|---|---|---|---|
| 48 | ticket | 216 | +1221 | 116 | +2.8 | 0.4 | -1.51 | 0.11 |
| 64 | ticket | 216 | +1181 | 113 | +2.8 | 0.4 | -1.55 | 0.11 |
| full | ticket | 74 | +539 | 169 | +0.7 | 0.7 | -2.04 | 0.20 |
| 48 | guarantee | 216 | +1055 | 117 | +2.4 | 0.4 | -1.94 | 0.12 |
| 64 | guarantee | 216 | +993 | 113 | +2.3 | 0.4 | -2.02 | 0.11 |
| full | guarantee | 74 | +126 | 180 | +0.6 | 0.7 | -2.46 | 0.22 |

## The tune-up rule's control arm: the win-chaser with the rule off (every pro win pays 5 reputation), same rolls

| Cell | House | Pairs | Win-chaser's reputation, rule on | rule off | The rule takes |
|---|---|---|---|---|---|
| 64 | ticket | 216 | 22.7 | 32.4 | 9.8 |
| 64 | guarantee | 216 | 14.6 | 26.2 | 11.6 |
| full | ticket | 74 | 67.4 | 77.4 | 9.9 |
| full | guarantee | 74 | 58.0 | 69.6 | 11.6 |

## Boxer by boxer (a cell = boxer x house x gym)

| Road | right in | the one answer in |
|---|---|---|
| name | 14 of 36 | 0 of 36 |
| win | 28 of 36 | 12 of 36 |
| keeper | 23 of 36 | 1 of 36 |

## What the bots booked, and what was on the table (stage B, all cells)

| House | Road | Careers | Sets | Step ups (title shots in them) | Tune-ups | Rebuild fights | Paydays | Road sets with both kinds on the table | Sets the house took the kind back | Favour at the end | Careers that reached favour 8 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| ticket | name | 506 | 2042 | 87% (7.5%) | 0% | 13% | 0% | 100% | 0.0% | 9.4 | 97% |
| ticket | win | 506 | 2529 | 14% (0.0%) | 79% | 7% | 0% | 100% | 13.8% | 2.7 | 0% |
| ticket | keeper | 506 | 2217 | 61% (0.0%) | 27% | 12% | 0% | 100% | 0.0% | 7.5 | 97% |
| guarantee | name | 506 | 1991 | 84% (0.0%) | 2% | 14% | 0% | 100% | 1.5% | 2.8 | 0% |
| guarantee | win | 506 | 2543 | 0% (0.0%) | 96% | 4% | 0% | 100% | 0.0% | 9.8 | 99% |
| guarantee | keeper | 506 | 2352 | 34% (0.0%) | 60% | 6% | 0% | 100% | 0.0% | 7.2 | 99% |

## The debut night: the test debutant against the build debutant, same house, the keeper road, same rolls

| Cell | House | Pairs | Debut wins in 100 | error | Cash by the last week | error | Reputation | error | Reads |
|---|---|---|---|---|---|---|---|---|---|
| 48 | ticket | 216 | -9.3 | 2.1 | +912 | 118 | +6.9 | 0.6 | a trade |
| 48 | guarantee | 216 | -9.3 | 2.3 | +521 | 90 | +3.9 | 0.4 | a trade |
| 64 | ticket | 216 | -9.3 | 2.1 | +863 | 122 | +7.6 | 0.7 | a trade |
| 64 | guarantee | 216 | -9.3 | 2.3 | +501 | 89 | +4.5 | 0.5 | a trade |
| full | ticket | 74 | -9.5 | 3.4 | +1 | 142 | +7.5 | 1.2 | a trade |
| full | guarantee | 74 | -6.8 | 2.9 | -160 | 107 | +4.5 | 0.8 | a trade |

## What a debut loss leaves at the last week (the same option, lost against won; NOT paired - the boxers who lose are the weaker ones)

| Rules | Option | Debuts won / lost | Cash, lost less won | Ranked, won / lost | Pro wins after the debut, won / lost | Rebuilding at the last week, lost |
|---|---|---|---|---|---|---|
| today | guarantee no ask | 210 / 19 | -1827 | 89% / 84% | 2.94 / 2.84 | 21% |
| today | ticket no ask | 143 / 66 | -1451 | 96% / 94% | 3.23 / 3.17 | 30% |
| v14 | guarantee build keeper | 368 / 46 | -1767 | 76% / 63% | 3.49 / 3.67 | 22% |
| v14 | guarantee test keeper | 323 / 60 | -2177 | 79% / 42% | 4.05 / 3.93 | 5% |
| v14 | ticket build keeper | 294 / 88 | -1571 | 97% / 97% | 2.93 / 3.36 | 24% |
| v14 | ticket test keeper | 247 / 115 | -3678 | 100% / 88% | 3.25 / 3.51 | 15% |

## Stage F - the favour: its rules on against off, same rolls, same bookings wanted (to the last week of the longer run)

| Cell | Option | Pairs | Cash, on less off | error | Reputation | error | Pro wins less losses | error | Favour at the end | Careers at favour 8+ at some set | Purse bonus paid a career | Title shots a career (won) | Sets the house took the kind back | Holds an area belt, on / off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 48 | guarantee build keeper (keeper) | 35 | +212 | 70 | +0.0 | 0.1 | +0.00 | 0.04 | 7.6 | 100% | $771 | 0.00 (0.00) | 0.0% | 0% / 0% |
| 48 | guarantee test name (rebel) | 35 | +1036 | 416 | +1.3 | 1.2 | +1.40 | 0.32 | 2.5 | 0% | $0 | 0.00 (0.00) | 31.7% | 3% / 9% |
| 48 | ticket build win (rebel) | 35 | +1328 | 483 | +3.8 | 1.0 | -0.43 | 0.36 | 2.5 | 0% | $0 | 0.00 (0.00) | 32.2% | 0% / 0% |
| 48 | ticket test keeper (keeper) | 35 | +0 | 0 | +0.0 | 0.0 | +0.00 | 0.00 | 7.4 | 100% | $0 | 0.00 (0.00) | 0.0% | 3% / 3% |
| 64 | guarantee build keeper (keeper) | 35 | +263 | 68 | +0.1 | 0.1 | +0.03 | 0.03 | 8.0 | 100% | $977 | 0.00 (0.00) | 0.0% | 0% / 0% |
| 64 | guarantee test name (rebel) | 35 | +1078 | 432 | +1.3 | 1.4 | +1.60 | 0.36 | 2.5 | 0% | $0 | 0.00 (0.00) | 32.6% | 3% / 9% |
| 64 | ticket build win (rebel) | 35 | +1383 | 524 | +4.5 | 1.1 | -0.80 | 0.42 | 2.3 | 0% | $0 | 0.00 (0.00) | 28.8% | 0% / 0% |
| 64 | ticket test keeper (keeper) | 35 | +0 | 0 | +0.0 | 0.0 | +0.00 | 0.00 | 7.4 | 100% | $0 | 0.00 (0.00) | 0.0% | 6% / 6% |
| full | guarantee build keeper (keeper) | 31 | +354 | 91 | +0.2 | 0.1 | +0.10 | 0.05 | 8.1 | 100% | $1132 | 0.00 (0.00) | 0.0% | 0% / 0% |
| full | guarantee test name (rebel) | 31 | +1117 | 377 | +1.5 | 1.4 | +1.74 | 0.37 | 2.5 | 0% | $0 | 0.00 (0.00) | 33.2% | 3% / 10% |
| full | ticket build win (rebel) | 31 | +1441 | 469 | +4.4 | 1.1 | -1.23 | 0.40 | 2.3 | 0% | $0 | 0.00 (0.00) | 28.1% | 0% / 0% |
| full | ticket test keeper (keeper) | 31 | +0 | 0 | +0.0 | 0.0 | +0.00 | 0.00 | 7.4 | 100% | $0 | 0.00 (0.00) | 0.0% | 6% / 6% |

## The bars

| # | Bar | Reads | Verdict |
|---|---|---|---|
| 1 | Instrument: today's costs ask reads +$700 to +$1,100 against today's plain guarantee house, error under $100, in every cell it is played | 64: +934, error 11; full: +909, error 0 | PASS |
| 2 | Instrument: the error on every option's cash gap is $250 or less in every pooled cell (a $1,000 gap is four errors) | largest error $216 | PASS |
| 3 | Played debut wins in 100: ticket test 52 to 68, ticket build 62 to 78, guarantee build 70 to 82, guarantee test 60 to 76 | 62.9, 71.2, 78.7, 70.1 | PASS |
| 4 | The card is honest: each of the four debutants shown within 3 of played on the mean, and no boxer's card more than 8 from that boxer's own nights | ticket test 60.2 shown, 62.9 played, worst boxer -9.9; ticket build 70.3 shown, 71.2 played, worst boxer -8.4; guarantee build 78.1 shown, 78.7 played, worst boxer -9.8; guarantee test 68.1 shown, 70.1 played, worst boxer -12.1 | **FAIL** |
| 5 | The house is a trade somewhere: the ticket house (its test debutant, the keeper road) is $1,000+ ahead on cash and 3+ debut wins behind the plain guarantee house in at least one cell | cells: 48, 64 | PASS |
| 6 | The house flips: the plain guarantee house beats that ticket-house option in at least one cell | cells: full | PASS |
| 7 | AUDIT (the kind): inside a house no road is the one answer in more than 6 of 10 house x gym cells | name 0 of 6; win 1 of 6; keeper 0 of 6 | PASS |
| 8 | AUDIT (the kind): every road is right in at least one house x gym cell, and in at least half of them two roads differ by a line on some axis ($1,000, 3 reputation, 1 win less loss) | name right 2 of 6; win right 4 of 6; keeper right 5 of 6; two roads differ in 6 of 6 | PASS |
| 9 | AUDIT: best against laziest - in at least half the cells an option is ahead of the plain guarantee house by $1,000 or 3 debut wins in 100 | 2 of 3 cells (48, 64) | PASS |
| 10 | The name is the kind's (probe 13's bars 10 and 15, one fact): with the tune-up rule off the win-chaser ends 1+ reputation higher in every cell with room it is played in, and with it on the name-chaser ends 3+ reputation ahead of the win-chaser in the same house in every cell with room | the rule takes 9.8 (ticket, 64), 11.6 (guarantee, 64); the name-chaser's lead +2.8 (ticket, 48), +2.8 (ticket, 64), +2.4 (guarantee, 48), +2.3 (guarantee, 64) | **FAIL** |
| 11 | Boxer by boxer (boxer x house x gym): no road the one answer in more than 6 cells of 10, every road right in at least 2 | name right 14, one answer 0 of 36; win right 28, one answer 12 of 36; keeper right 23, one answer 1 of 36 | PASS |
| 12 | A debut loss leaves a mark at the last week: $1,000+ of cash or 20+ points of ranked share behind the same option's wins (not paired: a reading, not a cost) | v14: cash -1895, ranked +9 points behind; today: cash -1191, ranked -0 | PASS |
| 13 | Inside one house two bots book different kinds: step ups are 25+ points more of the name-chaser's bookings than of the win-chaser's, at each house | ticket +73 points; guarantee +84 points | PASS |
| 14 | Later +2: the card shows +1 to +4, the played gain is not below 0 (a calendar tool; the card's part is the card's own formula) | card +2.0 / +2.0; played +2.3 (ticket), +1.6 (guarantee) | PASS |
| 15 | The favour moves the result (stage F, the favour's rules on against off on the same rolls): a line on some axis ($500 of gym cash, 3 reputation, 0.5 of a win less loss) for a keeper in at least one house AND for a full rebel in at least one house | keeper moved: none; rebel moved: guarantee test name, ticket build win, guarantee test name, ticket build win, guarantee test name, ticket build win | **FAIL** |
| 16 | The debut night is a trade: in at least one house x gym cell the test debutant is 3+ debut wins behind and 3+ reputation or $1,000 ahead, and neither debutant is the one answer in more than 6 of 10 of them | a trade in: ticket 48, guarantee 48, ticket 64, guarantee 64, ticket full, guarantee full; test the one answer 0, build 0 of 6 | PASS |
| 17 | Both kinds are on the table: 80%+ of the road's sets that are not rebuild sets carry a tune-up and a step up, at each house | ticket 100%; guarantee 100% | PASS |

Bars passed: 14 of 17 (17 bars read; 17 are defined). Audit bars (7, 8, 9): all pass. VERDICT: PASS (PASS = 14 or more of 17 with every audit bar).
