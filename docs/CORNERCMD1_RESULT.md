# CORNERCMD1 result - the corner commands on the real bout (S544)

**Verdict: FAIL - bars 5, 6 and 8 fail at both lengths (bar 3 also fails at 3 rounds). Stop.**
Reading the moment pays a lot: the reader beats PLAN ONLY by **+9.7 +-1.9** (3 rounds) and **+18.2 +-2.0** (6 rounds) wins in 100,
and the best fixed pair by **+10.3 +-2.0** and **+13.3 +-1.7** (bars 1, 2, 4, 7 pass; bar 9 passes with the coach rule tuned).
But a command HELD all bout is almost always a loser for both boxers (wind), except the two that give wind BACK - Reset (the
built "Breathe" +3 wind every 30 s) and Get out of there (-0.5) - which are free recovery: Reset held keeps the wind at 67 or
more at every bell (the page's own STOP flag, "never drops under 60") and adds up to +16, Get out up to +24. So no held command
splits the two boxers (bar 5), no held ring stop beats Centre (bar 6), and one command alone adds over 10 (bar 8).

**The one change that would fix it (not built, measured only in part):** make the wind honest - no command gives wind back
outside the moment it answers. Reset refills only while our boxer is tired or hurt (in any other moment it costs like a quiet
30 s and gives up offence, as now); Get out of there costs 0, not -0.5; and the new commands' wind is sized to the built calls'
scale (Change levels / Sit down / Be first 0.5 / 0.5 / 1.0, the ring 0.5 / 0). Today a held Reset is PUSHPROBE2's "Push five,
Save one" again in a new coat. Second, smaller: PLAN ONLY has no call at all in round 1 (`BoutNight` opens round 1 on plan
""), so in a 3-rounder any held command that answers the opponent's main game gets a free third of the bout (Get out +13.6
against the presser).

Design page (bars written before the runs): `ops/research/DESIGN_CORNERCMD1.md`. Probe: `tools/cornercmd1_probe.gd`
(stages check / step0 / trial / walk / full / fix), the commands as flagged local rules `tools/cornercmd1_rules.gd`, tables
`tools/cornercmd1_sum.py` (`python tools/cornercmd1_sum.py <jsonl> bars`). Raw: `E:/FightCamp/tmp/cornercmd1/*.jsonl` and
`*.log` (outside the repo). Nothing under scripts/ or tests/ changed.

## Step 0 (before the page): today's eight calls

Real bout, PLAN ONLY v a reader who shouts `Exchanges.MODES[sit].best` every exchange; four cells, 500 paired bouts a cell and
boxer (16,000-24,000 bouts a run).

| Reader | 3 rounds | 6 rounds |
|---|---|---|
| sees the coming game (`lv.mode`, only with full film study) | +15.9 +-1.2 | +18.8 +-1.2 |
| sees what the corner sees at film 1 (the game just shown, `LivePreview.gd:40`) | **+9.0 +-1.2** | **+15.0 +-1.2** |

Far over the 2-point line, so the edge is NOT lost in the call's size (`EDGE` best 17 power points on a 66-wide exchange),
`uptake`, or the plan line: PLAN ONLY holds ONE call all round, chosen from our boxer's stats (`BoutRules.auto_corner`), and
none in round 1. The commands were sized from today's table (best 17 / ok 5 / wrong -10). Our loop with no shout gave the
SAME result as `BoutNight.play_out` in 80 of 80 paired bouts (`stage=check`). (PUSHPROBE2's "today" numbers could not be
reproduced as such: they come from the S443 engine and another population. The check against play_out is the reproduction.)

## The bars (as designed; 10 cells x our two women x 70 paired bouts = 140 a cell and arm; 33 arms; 92,400 real bouts)

| Bar | 3 rounds | 6 rounds |
|---|---|---|
| (1) no fixed arm best in more than 6 of 10 cells | **PASS** (Get out in 5) | **PASS** (Reset in 6) |
| (2) reader - best fixed pair >= 3; reader - PLAN ONLY >= 5 | **PASS** +10.3 +-2.0 (pair Hands up + Ropes); +9.7 +-1.9 | **PASS** +13.3 +-1.7 (Reset + Cut); +18.2 +-2.0 |
| (3) 8 of 10 commands are the reader's pick in 5%+ of command exchanges | **FAIL** 7 (Let your hands go 4%, Sit down 4%, Hands up 0%) | **PASS** 9 (Hands up 0%) |
| (4) the worst command held loses 4+ to PLAN ONLY in 6+ cells | **PASS** 10 of 10 (Let your hands go, -22 to -31) | **PASS** 10 of 10 (-30 to -39) |
| (5) the two boxers disagree on 4+ commands | **FAIL** 2 (Hands up -1.7 / +2.6; Reset -6.0 / +3.7) | **FAIL** 2 (Go to the body -16.4 / +1.4; Reset -6.1 / +17.4) |
| (6) Cut the ring off and Stay away from the ropes each the right ring stop in 2+ cells | **FAIL** Centre 9, Ropes 1, Cut 0 | **FAIL** Centre 9, Ropes 1, Cut 0 |
| (7) always Let your hands go / always Sit down 3+ cells behind the reader with worse wind or head | **PASS** 10 / 10 | **PASS** 10 / 10 |
| (8) no command held adds more than 10 over PLAN ONLY in any cell | **FAIL** Get out +13.6 (presser) | **FAIL** Get out +23.9 (loader); Reset +14.6 (mover) |
| (9) coach at 75 within 3 of the reader, at 40 3+ behind | as designed **FAIL** (-3.9 / -5.7); tuned **PASS** (-0.4 +-0.4 / -10.3 +-1.9) | as designed PASS (-2.5 / -6.1); tuned **PASS** (-0.7 +-0.7 / -9.0 +-1.5) |

Wind stays in 0-100 (it is clamped; it reaches 0 at bells under Let your hands go, Sit down, Push and under PLAN ONLY itself
for Samira). Head is the bout's damage that the counts read (`m.damage.a`), not a 0-100 bar: it ends at 48-66 under the
reader and 111-145 under a held Let your hands go at 6 rounds - so "head in 0-100" is not a check this engine can make.

## Per cell (as designed; wins in 100, (difference over PLAN ONLY +- 2 SE))

## 3 rounds
bouts a cell and arm (both boxers): 140
| cell | plan | push45 | reader | coach40 | coach58 | coach75 | alt | best single | worst single | best pair |
|---|---|---|---|---|---|---|---|---|---|---|
| presser | 57.9 | 62.9 (+5.0+-6.2) | 71.4 (+13.6+-7.1) | 64.3 (+6.4+-5.8) | 65.7 (+7.9+-5.8) | 65.7 (+7.9+-5.8) | 55.0 (-2.9+-6.1) | c:get_out 71.4 (+13.6+-6.5) | c:let_go 30.0 (-27.9+-7.9) | p:get_out+ropes 67.9 (+10.0+-6.2) |
| mover | 57.9 | 60.7 (+2.9+-6.1) | 67.1 (+9.3+-6.4) | 60.7 (+2.9+-5.7) | 63.6 (+5.7+-5.7) | 63.6 (+5.7+-5.7) | 63.6 (+5.7+-6.0) | c:reset 66.4 (+8.6+-5.5) | c:let_go 32.9 (-25.0+-7.3) | p:reset+cut 60.0 (+2.1+-5.9) |
| counter | 63.6 | 64.3 (+0.7+-4.8) | 69.3 (+5.7+-5.3) | 65.7 (+2.1+-5.9) | 67.1 (+3.6+-5.5) | 67.1 (+3.6+-5.5) | 62.1 (-1.4+-5.0) | c:reset 64.3 (+0.7+-4.8) | c:let_go 34.3 (-29.3+-8.2) | p:reset+cut 62.1 (-1.4+-5.7) |
| loader | 67.9 | 69.3 (+1.4+-4.5) | 80.7 (+12.9+-6.0) | 76.4 (+8.6+-5.2) | 77.1 (+9.3+-5.3) | 77.1 (+9.3+-5.3) | 65.7 (-2.1+-6.2) | c:get_out 80.7 (+12.9+-5.7) | c:let_go 38.6 (-29.3+-8.0) | p:get_out+ropes 80.0 (+12.1+-5.9) |
| fader | 60.7 | 62.1 (+1.4+-6.7) | 68.6 (+7.9+-6.1) | 61.4 (+0.7+-6.6) | 63.6 (+2.9+-6.7) | 64.3 (+3.6+-6.5) | 58.6 (-2.1+-6.2) | c:get_out 64.3 (+3.6+-5.9) | c:let_go 32.9 (-27.9+-8.1) | p:get_out+ropes 59.3 (-1.4+-6.4) |
| slow | 60.7 | 65.7 (+5.0+-5.5) | 72.9 (+12.1+-6.2) | 66.4 (+5.7+-5.3) | 70.0 (+9.3+-5.7) | 70.7 (+10.0+-5.8) | 60.7 (+0.0+-5.7) | c:hands 63.6 (+2.9+-4.9) | c:let_go 33.6 (-27.1+-7.8) | p:hands+ropes 61.4 (+0.7+-5.6) |
| body | 55.0 | 56.4 (+1.4+-5.7) | 64.3 (+9.3+-5.7) | 57.9 (+2.9+-4.9) | 58.6 (+3.6+-4.7) | 58.6 (+3.6+-4.7) | 55.0 (+0.0+-5.7) | c:get_out 58.6 (+3.6+-4.7) | c:let_go 32.9 (-22.1+-7.6) | p:hands+ropes 57.9 (+2.9+-4.5) |
| switch | 57.9 | 55.7 (-2.1+-5.5) | 67.1 (+9.3+-5.3) | 61.4 (+3.6+-4.7) | 61.4 (+3.6+-5.1) | 61.4 (+3.6+-5.1) | 52.9 (-5.0+-5.9) | c:get_out 57.1 (-0.7+-5.6) | c:let_go 28.6 (-29.3+-8.0) | p:hands+ropes 54.3 (-3.6+-4.7) |
| favourite | 52.9 | 52.9 (+0.0+-6.1) | 60.7 (+7.9+-6.4) | 54.3 (+1.4+-6.1) | 55.7 (+2.9+-6.1) | 56.4 (+3.6+-5.9) | 49.3 (-3.6+-5.5) | c:get_out 55.0 (+2.1+-6.2) | c:let_go 25.0 (-27.9+-7.6) | p:get_out+ropes 51.4 (-1.4+-6.1) |
| underdog | 75.0 | 75.7 (+0.7+-5.6) | 84.3 (+9.3+-5.7) | 80.7 (+5.7+-4.9) | 82.1 (+7.1+-4.8) | 82.1 (+7.1+-4.8) | 73.6 (-1.4+-6.4) | c:get_out 75.7 (+0.7+-5.6) | c:let_go 44.3 (-30.7+-8.1) | p:hands+ropes 72.9 (-2.1+-5.9) |

alt (let_go / reset every other exchange) - reader: -11.0+-2.1
BAR 1 PASS: most cells won by one non-reading arm: c:get_out in 5 of 10
BAR 2 PASS: reader - best pair (p:hands+ropes) +10.3+-2.0; reader - plan +9.7+-1.9; (reader - each cell's best pair, post hoc: +7.9+-1.9)
BAR 3 FAIL: commands the reader picks in 5%+ of command exchanges: 7 of 10 (body 17%, levels 15%, let_go 4%, first 13%, sit 4%, hands 0%, reset 28%, get_out 18%, cut 20%, ropes 31%)
BAR 4 PASS: cells where the worst command held all bout loses 4+ to PLAN ONLY: 10
BAR 5 FAIL: commands the two boxers disagree on: 2 - hands (-1.7 / +2.6); reset (-6.0 / +3.7)
BAR 6 FAIL: best ring stop by cell: {'r:ropes': 1, 'plan': 9}
BAR 7 PASS: cells 3+ behind the reader with worse wind/head: let_go 10, sit 10
BAR 8 FAIL: largest single-command gain over PLAN ONLY: +13.6 (c:get_out, presser); bells at 0 wind min 0.0
BAR 9 FAIL: coach - reader: 75 -3.9+-1.3, 58 -4.1+-1.4, 40 -5.7+-1.6

| command | Lucy Jackson | Samira Khan |
|---|---|---|
| c:body | -17.7+-3.2 | -1.4+-2.4 |
| c:levels | -7.3+-2.3 | -1.9+-2.7 |
| c:let_go | -29.3+-3.6 | -26.0+-3.5 |
| c:first | -12.6+-3.1 | -14.6+-3.2 |
| c:sit | -7.1+-2.3 | -16.0+-3.1 |
| c:hands | -1.7+-2.3 | +2.6+-2.3 |
| c:reset | -6.0+-2.6 | +3.7+-2.4 |
| c:get_out | +4.1+-2.3 | +0.0+-2.9 |
| r:cut | -4.1+-1.8 | -8.0+-2.5 |
| r:ropes | -4.1+-2.2 | -4.9+-1.6 |
| push45 | +2.9+-2.3 | +0.4+-2.8 |
| reader | +9.4+-2.6 | +10.0+-2.8 |
| alt | -5.3+-2.6 | +2.7+-2.6 |

## 6 rounds
bouts a cell and arm (both boxers): 140
| cell | plan | push45 | reader | coach40 | coach58 | coach75 | alt | best single | worst single | best pair |
|---|---|---|---|---|---|---|---|---|---|---|
| presser | 63.6 | 66.4 (+2.9+-5.7) | 82.5 (+18.9+-6.8) | 76.1 (+12.5+-6.2) | 80.0 (+16.4+-6.4) | 78.9 (+15.4+-6.2) | 67.5 (+3.9+-6.1) | c:get_out 75.7 (+12.1+-5.4) | c:let_go 27.9 (-35.7+-8.0) | p:get_out+ropes 72.1 (+8.6+-5.1) |
| mover | 55.4 | 52.1 (-3.2+-5.5) | 77.9 (+22.5+-6.7) | 70.7 (+15.4+-6.3) | 72.9 (+17.5+-6.4) | 76.1 (+20.7+-6.4) | 67.1 (+11.8+-5.7) | c:reset 70.0 (+14.6+-6.0) | c:let_go 16.1 (-39.3+-6.9) | p:reset+cut 66.8 (+11.4+-5.8) |
| counter | 65.0 | 67.5 (+2.5+-4.5) | 78.6 (+13.6+-6.0) | 77.1 (+12.1+-6.1) | 77.5 (+12.5+-5.8) | 78.6 (+13.6+-6.0) | 72.9 (+7.9+-5.2) | c:reset 71.8 (+6.8+-5.7) | c:let_go 27.9 (-37.1+-8.0) | p:reset+cut 71.1 (+6.1+-6.0) |
| loader | 61.8 | 62.5 (+0.7+-4.6) | 85.0 (+23.2+-6.8) | 80.0 (+18.2+-6.4) | 80.0 (+18.2+-6.4) | 81.8 (+20.0+-6.5) | 77.5 (+15.7+-7.2) | c:get_out 85.7 (+23.9+-6.6) | c:let_go 32.1 (-29.6+-7.0) | p:get_out+ropes 82.1 (+20.4+-6.7) |
| fader | 58.9 | 58.9 (+0.0+-5.6) | 81.4 (+22.5+-6.5) | 71.1 (+12.1+-5.4) | 75.4 (+16.4+-5.9) | 79.3 (+20.4+-6.4) | 67.9 (+8.9+-6.2) | c:get_out 63.2 (+4.3+-5.5) | c:let_go 20.4 (-38.6+-7.9) | p:reset+cut 62.1 (+3.2+-6.4) |
| slow | 59.6 | 63.2 (+3.6+-4.6) | 80.4 (+20.7+-6.4) | 71.4 (+11.8+-6.0) | 76.4 (+16.8+-6.0) | 77.1 (+17.5+-6.0) | 69.3 (+9.6+-6.0) | c:hands 67.9 (+8.2+-5.0) | c:let_go 20.4 (-39.3+-7.4) | p:reset+cut 65.7 (+6.1+-6.1) |
| body | 60.0 | 59.6 (-0.4+-4.5) | 77.9 (+17.9+-5.8) | 71.8 (+11.8+-5.5) | 74.3 (+14.3+-5.5) | 75.0 (+15.0+-5.6) | 64.6 (+4.6+-5.6) | c:reset 64.6 (+4.6+-6.2) | c:let_go 25.7 (-34.3+-7.9) | p:reset+cut 62.9 (+2.9+-5.5) |
| switch | 57.1 | 55.4 (-1.8+-5.4) | 74.6 (+17.5+-6.3) | 66.4 (+9.3+-6.0) | 67.9 (+10.7+-5.6) | 69.3 (+12.1+-5.9) | 61.8 (+4.6+-6.4) | c:reset 61.8 (+4.6+-6.5) | c:let_go 20.0 (-37.1+-7.9) | p:reset+cut 61.1 (+3.9+-6.4) |
| favourite | 51.1 | 53.6 (+2.5+-5.5) | 66.8 (+15.7+-6.3) | 62.9 (+11.8+-5.4) | 62.1 (+11.1+-5.9) | 65.4 (+14.3+-6.4) | 58.6 (+7.5+-5.6) | c:reset 56.4 (+5.4+-6.1) | c:let_go 16.8 (-34.3+-7.2) | p:reset+cut 55.7 (+4.6+-5.7) |
| underdog | 80.7 | 77.5 (-3.2+-4.3) | 90.0 (+9.3+-5.0) | 86.1 (+5.4+-4.8) | 87.5 (+6.8+-4.7) | 88.6 (+7.9+-4.5) | 81.8 (+1.1+-4.4) | c:reset 83.6 (+2.9+-3.6) | c:let_go 44.6 (-36.1+-7.5) | p:reset+cut 82.1 (+1.4+-4.2) |

alt (let_go / reset every other exchange) - reader: -10.6+-1.6
BAR 1 PASS: most cells won by one non-reading arm: c:reset in 6 of 10
BAR 2 PASS: reader - best pair (p:reset+cut) +13.3+-1.7; reader - plan +18.2+-2.0; (reader - each cell's best pair, post hoc: +11.3+-1.6)
BAR 3 PASS: commands the reader picks in 5%+ of command exchanges: 9 of 10 (body 11%, levels 9%, let_go 6%, first 8%, sit 9%, hands 0%, reset 45%, get_out 12%, cut 22%, ropes 20%)
BAR 4 PASS: cells where the worst command held all bout loses 4+ to PLAN ONLY: 10
BAR 5 FAIL: commands the two boxers disagree on: 2 - body (-16.4 / +1.4); reset (-6.1 / +17.4)
BAR 6 FAIL: best ring stop by cell: {'plan': 9, 'r:ropes': 1}
BAR 7 PASS: cells 3+ behind the reader with worse wind/head: let_go 10, sit 10
BAR 8 FAIL: largest single-command gain over PLAN ONLY: +23.9 (c:get_out, loader); bells at 0 wind min 0.0
BAR 9 PASS: coach - reader: 75 -2.5+-1.0, 58 -4.1+-1.1, 40 -6.1+-1.3

| command | Lucy Jackson | Samira Khan |
|---|---|---|
| c:body | -16.4+-2.9 | +1.4+-2.9 |
| c:levels | -7.9+-1.8 | -1.8+-2.9 |
| c:let_go | -39.6+-3.3 | -32.6+-3.4 |
| c:first | -33.6+-3.1 | -15.7+-3.3 |
| c:sit | -9.0+-2.0 | -12.0+-3.0 |
| c:hands | +0.4+-1.6 | +4.9+-2.7 |
| c:reset | -6.1+-1.9 | +17.4+-3.0 |
| c:get_out | +2.3+-1.3 | +4.1+-3.1 |
| r:cut | -6.5+-1.8 | -4.8+-2.8 |
| r:ropes | -5.1+-1.7 | -2.6+-2.4 |
| push45 | -0.6+-1.5 | +1.4+-2.8 |
| reader | +11.4+-2.2 | +25.0+-3.2 |
| alt | -1.8+-1.9 | +16.9+-3.1 |

## Wind and head at each bell (as designed, mean over 10 cells)

| Arm | Lucy, 6 rounds: wind | head | Samira, 6 rounds: wind | head |
|---|---|---|---|---|
| PLAN ONLY | 66 46 31 19 11 5 | 10 19 29 38 48 58 | 66 32 6 0 0 0 | 9 19 37 59 82 103 |
| reader | 60 32 25 26 25 26 | 8 16 25 32 40 48 | 59 29 25 27 29 29 | 7 17 31 43 54 66 |
| Reset held | 81 78 79 76 73 68 | 11 20 31 40 51 60 | 81 78 78 75 72 67 | 10 20 33 44 56 68 |
| Get out held | 69 48 34 22 13 7 | 9 17 27 36 46 57 | 69 48 34 22 14 7 | 10 21 34 49 65 83 |
| Let your hands go held | 51 10 0 0 0 0 | 14 30 54 76 94 111 | 51 10 0 0 0 0 | 12 32 64 93 120 145 |
| Sit down held | 61 35 16 3 0 0 | 15 30 44 58 72 86 | 61 22 0 0 0 0 | 16 33 60 86 112 137 |

The reader changes commands 7.7 (3 rounds) to 12.5-13.1 (6 rounds) times a bout; its calls work 4,023-10,047 times against
398-622 wrong (the result page's count). Its picks, 6 rounds: Reset 41-45% of command exchanges, then Get out, Go to the body,
Change levels, Sit down (Samira) / Let your hands go (Lucy), Be first; Cut the ring off 22%, Stay away from the ropes 20%.
Hands up is never picked: at "loading up" Be first ties it on the table and both our women do Be first better.

## The one-rep trial and the feedback loops

- Every cell did NOT pick the same command (picks above); every command changes results (bar 4: each held command moves the
  bout); the control arm equals play_out (80 / 80). The walk (one bout, Lucy v the mover, printed exchange by exchange) showed
  the round's first 30 s fought on the plan; fixed: a held command with a call of its own is the corner minute's call.
- STOP flags: no arm ends a round under 0 (clamped); **Reset held never drops under 60 (67-81 at every bell) - the free
  recovery loop the brief warned about.** "alt" (Let your hands go and Reset every other exchange) does NOT beat the reader
  (-11.0 +-2.1 at 3 rounds, -10.6 +-1.6 at 6), so the alternating exploit is closed; the held one is not.
- Sit down -> head: the head at the last bell is 1.4-2.1x the reader's (bar 7's cost is real).

## The tuned numbers (before -> after)

- Coach rule (spec 10): follows the reader with chance tactics / 100 -> **(tactics - 30) / 50** (75: 0.9, 58: 0.56, 40: 0.2).
  Bar 9 FAIL at 3 rounds -> PASS at both (paired on the same dice as the main run; `coachtune.jsonl`).
- Nothing else was tuned for the verdict. A diagnostic run (`stage=fix`, 45 bouts a boxer, 59,400 bouts) tried the round's
  call from the opponent's file (his favourite game's best call) with the ring at 1.0 of a call and its wind 0.5 / 0: bars 1-4
  and 7 pass at 3 rounds, but 5, 6 and 8 still fail at both lengths (Get out +12.2; Reset held +16.1 at 6 rounds; Ropes the
  right stop in 2 cells, Cut in none; the boxers disagree on 0-1 commands). It was not the plan's call: it is the wind.

## Honest limits

- 140 bouts a cell and arm: 2 SE is 5-8 points on one cell, 1.6-2.8 over all cells. The failing bars fail by far more
  (bar 8 by 3.6-13.9 points, bar 6 with Cut the right stop in 0 cells, bar 5 at 2 of the 4 needed).
- Two boxers (Lucy Jackson, Out-boxer, coachability 84; Samira Khan, Slugger, 52 - TELLPLAY1's week-4 books), one coach (58)
  writing the plan, film 1. Amateur rules for both lengths. Women v women of their class (DebutOpp), the opponent re-styled by
  cell, rating = our boxer's night number (+3 favourite, -3 underdog). The switch-hitter changes stance every round from round 2.
- The commands are local rules: a command with a built call shouts it every exchange (shout count reset: no limit) and the base
  takes the difference to the command's own table; a new command keeps the plan's call side effects (body share, place) and
  takes its edge on the base. Head is added only on a lost 30 s. Ring "cut" raises `ring_cut` for the rest of the round once on.
- The reader sees at film 1 (the game just shown); a player with film 3 would read better.
- 3D look: not in this task.

## Population (printed in each run's first line)

Lucy Jackson (f, Out-boxer, orthodox, night 58.4; grades: Get out / Be first Good, Body / Change levels / Cut Poor, Ropes
Good) and Samira Khan (f, Slugger, orthodox, night 55.5; Body / Sit down Good, Ropes Poor, the rest OK).
Cells: presser (Pressure fighter, Never stops throwing), mover (Out-boxer, Long jab), counter (Counter-puncher), loader (Slugger,
Heavy right hand), fader (Volume puncher, Fades after round 2), slow starter (Boxer-puncher, Slow to start), body puncher
(Body hooks), switch-hitter, favourite (+3), underdog (-3). Paired dice: bout k = career day 70000 + 7k in every arm.

## Reproduce

`python ops/Tools/godot_slot.py run --who CORNERCMD1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/cornercmd1_probe.gd -- stage=full n=70 lens=3,6 out=<jsonl>`
(53 min on one slot); `stage=step0 pols=plan,reader0_seen n=500 cells=presser,mover,counter,loader`; `stage=check`;
`stage=walk cells=mover lens=3 arm=reader`; coach tune `arms=reader,coach40,coach58,coach75 coach_a=30 coach_b=50`;
diagnostic `stage=fix favplan=1 ring_scale=1.0 cut_wind=0.5 ropes_wind=0.0 n=45`.
