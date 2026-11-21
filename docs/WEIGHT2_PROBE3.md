# WEIGHT2 probe, ROUND 3 - John's numbers, the refusal, an error per cell (S535 WEIGHT2R3)

Round 1 (commit 875376421) FAILED: STAY best in 10 of 10 cells. Round 2 (ddc061494) PASSED on estimates: STAY 5, CUT 2, UP 2, DOWN 1.
Round 3 replaces the estimates John answered (SQ278, ops/research/JOHN_WEIGHT2_RESEARCH_JOHN.md) with his numbers, lets a boxer
refuse a class move (owner Q-293), and prints the error of every ladder place so a best inside the noise is called a tie.

Run: python ops/Tools/godot_slot.py run --who weight2r3 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/weight2_probe.gd -- seeds=20 bouts=12 abl=3 cal=10

What is real: the five boxers (Data.PROSPECTS), their opponents (Data's region sheets), and every bout (BoutNight.play_out,
the game's fight night). What is scratch: the weight model below.
Each run = 12 bouts on a 20-rung ladder; 20 seeds a cell; every choice of a seed fights the same nights (same dice).

Scales: [{ "id": "am", "name": "amateur, weighed an hour before, 3 rounds", "pro": false, "rounds": 3, "regain": 0.5, "opp_regain": 0.5, "free": 2.0, "cond": 4.0, "power": 1.5, "read": 1.0, "knee": 99.0, "cond2": 0.0, "power2": 0.0, "water_ok": 3.0, "cap": 5.0, "miss_base": 0.01, "walkover": true, "opp_off": -3.0 }, { "id": "pro", "name": "pro, weighed the day before, 6 rounds", "pro": true, "rounds": 6, "regain": 7.2, "opp_regain": 7.2, "free": 2.0, "cond": 1.5, "power": 0.0, "read": 0.5, "knee": 5.0, "cond2": 1.5, "power2": 1.0, "water_ok": 8.0, "cap": 8.0, "miss_base": 0.02, "walkover": false, "opp_off": -6.0 }]

Model: { "bulk_kg": 2.0, "up_fill_kg": 1.0, "diet_hold": 0.025, "diet_hold_down": 0.05, "kg_a_week": 0.45, "free_weeks": 2.0, "size_power": 1.2, "size_chin": 1.0, "size_speed": 0.4, "size_cap": 8.0, "size_win": 3.0, "tank_max": 25.0, "grow": 0.33, "diet_cost": 0.12, "grow_min": 0.4, "miss_slope": 0.2, "miss_max": 0.7, "miss_push": 2, "rung0": 10.0, "rung_move": 11.0, "rung_gap": 1.2, "rung_max": 20.0, "field_grow": 0.15, "refuse_up": 0.3, "refuse_down": 0.5, "refuse_conf": 0.005, "refuse_loyal": 0.006, "refuse_wish": 0.25, "refuse_wait": 3 }

## 0. The fit (10 seeds x 12 bouts a cell and setting, no cut, no ladder; 6000 bouts)

| Scale | plain | 4 % bigger (stats only) | 4 % smaller | field 2 points weaker | field 2 points stronger |
| :--- | ---: | ---: | ---: | ---: | ---: |
| am | 40 % | 46 % | 40 % | 49 % | 32 % |
| pro | 45 % | 51 % | 38 % | 54 % | 33 % |

Measured: the size split of punch, chin and hand speed is worth 1.10 wins in 100 per 1 % of ring weight; a rating point 4.75 wins in 100.
John (DERIVED, Baribeau 2023): about 3.0 wins in 100 per 1 % heavier. So the rest goes in the exchanges: size_rating = 0.40 rating points per 1 %.
Field, am: STAY's mean size gap -0.4 % -> about 39 % wins at offset -3.0; the offset becomes -5.3 (STAY at about half).
Field, pro: STAY's mean size gap -6.0 % -> about 27 % wins at offset -6.0; the offset becomes -10.9 (STAY at about half).

## 1. Who they are

| Boxer (shape) | Class | Walks | Power | Speed | Stamina (cond.) | Chin | Discipline | Confidence | Loyalty |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Samira Khan (puncher) | 65 kg | 65.9 kg | 66 | 57 | 60 | 63 | 34 | 66 | 82 |
| Josh Harper (volume) | 70 kg | 71.4 kg | 63 | 56 | 65 | 64 | 80 | 38 | 70 |
| Tess Reilly (big chin) | 75 kg | 76.1 kg | 62 | 55 | 64 | 67 | 62 | 70 | 66 |
| Kira Mensah (drained cutter) | 57 kg | 60.8 kg | 54 | 67 | 58 | 52 | 64 | 58 | 60 |
| Danny Osei (boxer-puncher) | 60 kg | 61.1 kg | 59 | 62 | 57 | 62 | 60 | 82 | 58 |

## 2. The cell table

Cut = kilos over the class; by water = the part left for fight week (% of body weight); dry = % still missing at the bell;
Stamina = % of his Stamina and tank the cut costs; size gap = his ring weight against the opponent's; refuses = the chance he says no;
win and stopped (won inside / lost inside) are shares of the bouts fought; late = last third of the rounds won; missed = scales missed a run;
moved = runs where two misses moved him up a class; place = ladder rung at the end (1 is the top; start 10, a class move 11)
with its standard error over the 20 seeds.

### puncher / am (amateur, weighed an hour before, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 65 | 0.9 kg | 0.0 % | 0.0 % | -0.0 % | -0.5 % | 0 % | 48 % | 10 / 3 % | 33 % | 0.00 | 0 % | 9.80 +- 0.57 |
| CUT | 65 | 2.9 kg | 1.8 % | 1.3 % | -0.0 % | +0.0 % | 0 % | 48 % | 10 / 2 % | 34 % | 0.20 | 0 % | 10.00 +- 0.55 |
| UP | 70 | 0.0 kg | 0.0 % | 0.0 % | -0.0 % | -4.9 % | 14 % | 43 % | 7 / 4 % | 33 % | 0.00 | 0 % | 12.28 +- 0.54 |
| DOWN | 60 | 5.9 kg | 4.0 % | 3.5 % | -7.8 % | +0.0 % | 34 % | 52 % | 14 / 2 % | 34 % | 1.65 | 70 % | 12.15 +- 0.52 |

Best: **STAY** - a tie with CUT (inside two standard errors of the paired difference)

### puncher / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 65 | 0.9 kg | 0.0 % | 0.0 % | -0.0 % | -6.7 % | 0 % | 35 % | 28 / 10 % | 24 % | 0.00 | 0 % | 10.43 +- 0.47 |
| CUT | 65 | 2.9 kg | 1.8 % | 0.0 % | -0.0 % | -5.0 % | 0 % | 38 % | 32 / 8 % | 24 % | 0.30 | 5 % | 9.57 +- 0.37 |
| UP | 70 | 0.0 kg | 0.0 % | 0.0 % | -0.0 % | -10.8 % | 14 % | 36 % | 29 / 11 % | 25 % | 0.00 | 0 % | 11.25 +- 0.43 |
| DOWN | 60 | 5.9 kg | 4.0 % | 0.0 % | -2.9 % | -2.7 % | 34 % | 43 % | 36 / 6 % | 26 % | 0.30 | 5 % | 9.45 +- 0.48 |

Best: **DOWN** - a tie with CUT (inside two standard errors of the paired difference)

### volume / am (amateur, weighed an hour before, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 70 | 1.4 kg | 0.0 % | 0.0 % | -0.0 % | -0.5 % | 0 % | 52 % | 10 / 2 % | 53 % | 0.00 | 0 % | 8.88 +- 0.55 |
| CUT | 70 | 3.4 kg | 2.1 % | 1.7 % | -0.5 % | +0.0 % | 0 % | 52 % | 11 / 2 % | 52 % | 0.05 | 0 % | 8.85 +- 0.56 |
| UP | 75 | 0.0 kg | 0.0 % | 0.0 % | -0.0 % | -3.9 % | 7 % | 51 % | 7 / 3 % | 53 % | 0.00 | 0 % | 10.28 +- 0.53 |
| DOWN | 65 | 6.4 kg | 4.0 % | 3.5 % | -7.9 % | +0.0 % | 27 % | 57 % | 11 / 1 % | 52 % | 1.35 | 50 % | 10.73 +- 0.54 |

Best: **CUT** - a tie with STAY (inside two standard errors of the paired difference)

### volume / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 70 | 1.4 kg | 0.0 % | 0.0 % | -0.0 % | -6.7 % | 0 % | 42 % | 23 / 8 % | 48 % | 0.00 | 0 % | 8.47 +- 0.45 |
| CUT | 70 | 3.4 kg | 2.1 % | 0.0 % | -0.2 % | -4.6 % | 0 % | 48 % | 36 / 6 % | 43 % | 0.20 | 0 % | 6.58 +- 0.42 |
| UP | 75 | 0.0 kg | 0.0 % | 0.0 % | -0.0 % | -10.0 % | 7 % | 44 % | 23 / 9 % | 51 % | 0.00 | 0 % | 9.15 +- 0.41 |
| DOWN | 65 | 6.4 kg | 4.0 % | 0.0 % | -2.9 % | -2.7 % | 27 % | 50 % | 38 / 3 % | 44 % | 0.20 | 0 % | 6.95 +- 0.41 |

Best: **CUT** - a tie with DOWN (inside two standard errors of the paired difference)

### big chin / am (amateur, weighed an hour before, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 75 | 1.1 kg | 0.0 % | 0.0 % | -0.0 % | -0.5 % | 0 % | 52 % | 8 / 1 % | 42 % | 0.00 | 0 % | 9.15 +- 0.52 |
| CUT | 75 | 3.1 kg | 1.5 % | 1.0 % | -0.0 % | +0.0 % | 0 % | 52 % | 8 / 1 % | 42 % | 0.15 | 5 % | 9.30 +- 0.53 |
| UP | 81 | 0.0 kg | 0.0 % | 0.0 % | -0.0 % | -5.3 % | 25 % | 56 % | 5 / 2 % | 56 % | 0.00 | 0 % | 9.18 +- 0.52 |
| DOWN | 70 | 6.1 kg | 3.0 % | 2.6 % | -4.1 % | +0.0 % | 45 % | 50 % | 8 / 1 % | 39 % | 0.20 | 5 % | 10.78 +- 0.52 |

Best: **UP** - a tie with STAY, CUT (inside two standard errors of the paired difference)

### big chin / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 75 | 1.1 kg | 0.0 % | 0.0 % | -0.0 % | -6.7 % | 0 % | 47 % | 21 / 5 % | 41 % | 0.00 | 0 % | 7.78 +- 0.40 |
| CUT | 75 | 3.1 kg | 1.5 % | 0.0 % | -0.0 % | -5.3 % | 0 % | 48 % | 23 / 4 % | 41 % | 0.10 | 0 % | 7.35 +- 0.43 |
| UP | 81 | 0.0 kg | 0.0 % | 0.0 % | -0.0 % | -11.2 % | 25 % | 46 % | 21 / 6 % | 41 % | 0.00 | 0 % | 8.85 +- 0.42 |
| DOWN | 70 | 6.1 kg | 3.0 % | 0.0 % | -1.5 % | -3.7 % | 45 % | 49 % | 26 / 4 % | 40 % | 0.10 | 0 % | 7.70 +- 0.44 |

Best: **CUT** - a tie with DOWN (inside two standard errors of the paired difference)

### drained cutter / am (amateur, weighed an hour before, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 57 | 3.8 kg | 3.7 % | 3.3 % | -7.0 % | +0.0 % | 0 % | 58 % | 4 / 5 % | 64 % | 1.50 | 60 % | 10.18 +- 0.53 |
| CUT | 57 | 5.8 kg | 6.7 % | 6.3 % | -18.9 % | +0.0 % | 0 % | 67 % | 6 / 5 % | 66 % | 2.05 | 100 % | 9.40 +- 0.46 |
| UP | 60 | 1.8 kg | 0.4 % | 0.0 % | -0.0 % | -0.1 % | 5 % | 57 % | 5 / 7 % | 62 % | 0.10 | 0 % | 9.13 +- 0.50 |
| DOWN | 54 | 6.8 kg | 6.2 % | 5.7 % | -16.7 % | +0.0 % | 68 % | 69 % | 7 / 3 % | 73 % | 3.35 | 100 % | 12.20 +- 0.45 |

Best: **UP** - a tie with CUT (inside two standard errors of the paired difference)

### drained cutter / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 57 | 3.8 kg | 3.7 % | 0.0 % | -2.6 % | -3.0 % | 0 % | 55 % | 19 / 15 % | 66 % | 0.30 | 5 % | 6.10 +- 0.40 |
| CUT | 57 | 5.8 kg | 6.7 % | 0.2 % | -9.7 % | -0.0 % | 0 % | 55 % | 23 / 13 % | 66 % | 0.30 | 5 % | 5.95 +- 0.42 |
| UP | 60 | 1.8 kg | 0.4 % | 0.0 % | -0.0 % | -6.3 % | 23 % | 55 % | 17 / 20 % | 70 % | 0.30 | 0 % | 7.42 +- 0.40 |
| DOWN | 54 | 6.8 kg | 6.2 % | 0.0 % | -8.1 % | -0.2 % | 43 % | 56 % | 23 / 11 % | 67 % | 0.30 | 5 % | 6.35 +- 0.43 |

Best: **CUT** - a tie with STAY (inside two standard errors of the paired difference)

### boxer-puncher / am (amateur, weighed an hour before, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 60 | 1.1 kg | 0.0 % | 0.0 % | -0.0 % | -0.5 % | 0 % | 53 % | 8 / 2 % | 52 % | 0.00 | 0 % | 8.90 +- 0.48 |
| CUT | 60 | 3.1 kg | 2.4 % | 1.9 % | -1.7 % | +0.0 % | 0 % | 53 % | 8 / 2 % | 50 % | 0.30 | 5 % | 9.28 +- 0.52 |
| UP | 65 | 0.0 kg | 0.0 % | 0.0 % | -0.0 % | -4.9 % | 36 % | 52 % | 4 / 3 % | 54 % | 0.00 | 0 % | 10.25 +- 0.45 |
| DOWN | 55 | 6.1 kg | 5.0 % | 4.5 % | -11.9 % | +0.0 % | 56 % | 64 % | 13 / 2 % | 59 % | 2.00 | 100 % | 10.68 +- 0.62 |

Best: **STAY** - a tie with CUT (inside two standard errors of the paired difference)

### boxer-puncher / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 60 | 1.1 kg | 0.0 % | 0.0 % | -0.0 % | -6.7 % | 0 % | 48 % | 20 / 6 % | 57 % | 0.00 | 0 % | 7.38 +- 0.42 |
| CUT | 60 | 3.1 kg | 2.4 % | 0.0 % | -0.6 % | -4.3 % | 0 % | 51 % | 24 / 5 % | 55 % | 0.15 | 0 % | 6.83 +- 0.38 |
| UP | 65 | 0.0 kg | 0.0 % | 0.0 % | -0.0 % | -10.9 % | 36 % | 49 % | 21 / 7 % | 57 % | 0.00 | 0 % | 8.25 +- 0.40 |
| DOWN | 55 | 6.1 kg | 5.0 % | 0.0 % | -4.5 % | -1.6 % | 56 % | 53 % | 28 / 4 % | 54 % | 0.15 | 0 % | 6.58 +- 0.36 |

Best: **DOWN** - a tie with CUT (inside two standard errors of the paired difference)

## 3. Ladder place at the end, every cell (lower is better; +- one standard error)

| Cell | STAY | CUT | UP | DOWN | Best | Inside the noise of it |
| :--- | ---: | ---: | ---: | ---: | :--- | :--- |
| puncher / am | 9.80 +- 0.57 | 10.00 +- 0.55 | 12.28 +- 0.54 | 12.15 +- 0.52 | STAY | CUT |
| puncher / pro | 10.43 +- 0.47 | 9.57 +- 0.37 | 11.25 +- 0.43 | 9.45 +- 0.48 | DOWN | CUT |
| volume / am | 8.88 +- 0.55 | 8.85 +- 0.56 | 10.28 +- 0.53 | 10.73 +- 0.54 | CUT | STAY |
| volume / pro | 8.47 +- 0.45 | 6.58 +- 0.42 | 9.15 +- 0.41 | 6.95 +- 0.41 | CUT | DOWN |
| big chin / am | 9.15 +- 0.52 | 9.30 +- 0.53 | 9.18 +- 0.52 | 10.78 +- 0.52 | UP | STAY, CUT |
| big chin / pro | 7.78 +- 0.40 | 7.35 +- 0.43 | 8.85 +- 0.42 | 7.70 +- 0.44 | CUT | DOWN |
| drained cutter / am | 10.18 +- 0.53 | 9.40 +- 0.46 | 9.13 +- 0.50 | 12.20 +- 0.45 | UP | CUT |
| drained cutter / pro | 6.10 +- 0.40 | 5.95 +- 0.42 | 7.42 +- 0.40 | 6.35 +- 0.43 | CUT | STAY |
| boxer-puncher / am | 8.90 +- 0.48 | 9.28 +- 0.52 | 10.25 +- 0.45 | 10.68 +- 0.62 | STAY | CUT |
| boxer-puncher / pro | 7.38 +- 0.42 | 6.83 +- 0.38 | 8.25 +- 0.40 | 6.58 +- 0.36 | DOWN | CUT |

Best counts (the lowest place, round 2's rule): { "STAY": 2, "CUT": 4, "UP": 2, "DOWN": 2 }. The most any one choice wins: 4 of 10 cells (bar: 6 or fewer).
Clear bests (no other choice inside the noise): { "STAY": 0, "CUT": 0, "UP": 0, "DOWN": 0 } - 0 of 10 cells are clear.
Best or tied for best: { "STAY": 5, "CUT": 10, "UP": 2, "DOWN": 4 } - the most any one choice is in the leading group: 10 of 10 cells.

Moving up, all ten cells pooled: knockout share of the wins 31 % staying, 29 % up (x 0.91); stopped 5.6 in 100 bouts staying, 7.2 up (x 1.29).
John E (ESTIMATE, half his biased count, for TWO classes up): knockout share x 0.88, stopped x 1.5.

## 4. Does each lever move the result? (lever off, 3 seeds, against the same seeds with it on)

| Lever off | Mean change in win share | Biggest change in ladder place | Cells whose best choice changes | Moves it |
| :--- | ---: | ---: | ---: | :--- |
| drain | 0.9 points | 1.67 rungs | 4 of 10 | yes |
| size | 4.5 points | 5.33 rungs | 6 of 10 | yes |
| diet | 1.9 points | 1.83 rungs | 2 of 10 | yes |
| miss | 1.7 points | 2.33 rungs | 0 of 10 | yes |
| rank | 2.2 points | 2.50 rungs | 2 of 10 | yes |
| refuse | 0.6 points | 1.17 rungs | 0 of 10 | yes |

Size as it lands on the ladder (lever on against off, over the size gaps of the 40 cell choices): 1.2 wins in 100 per 1 % of ring weight.
The fit of step 0 aims at John's 3.0 with the opponents held still; on the ladder a winner meets better men, which shrinks it.

23816 bouts played in 1229 s.

RESULT: tools/weight2_probe.gd -> PASS (levers all move; top choice best in 4 of 10 cells; 0 of 10 cells clear of the noise)
