# WEIGHT2 probe, ROUND 4 - the cut as a share of body, a pro's regain as a share of the cut, the diet shown (S536 WEIGHT2R4)

Round 3 (docs/WEIGHT2_PROBE3.md) passed weakly: no cell clear of the noise and CUT harder in the leading group of all ten. Round 4 re-sizes the scratch model:
CUT harder = walk big enough that 4 % of body is left as water at his own class line (was a flat 2 kg); a pro gets back a share of the water he took off (0.9 on average;
four nights in five 0.81, one in five 1.25), not a flat 7.2 %; the diet prints its weeks at 0.7 % a week and the training it keeps; 40 seeds a cell; three more bars (section 3).

Run: python ops/Tools/godot_slot.py run --who weight2r4 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/weight2_probe.gd -- seeds=40 bouts=12 abl=3 cal=10

What is real: the five boxers (Data.PROSPECTS), their opponents (Data's region sheets), and every bout (BoutNight.play_out, the game's fight night). What is scratch: the weight model below.
Each run = 12 bouts on a 20-rung ladder; 40 seeds a cell; every choice of a seed fights the same nights (same dice).

Scales: [{ "id": "am", "name": "amateur, weighed an hour before, 3 rounds", "pro": false, "rounds": 3, "regain": 0.5, "opp_regain": 0.5, "free": 2.0, "cond": 4.0, "power": 1.5, "read": 1.0, "knee": 99.0, "cond2": 0.0, "power2": 0.0, "water_ok": 3.0, "cap": 5.0, "miss_base": 0.01, "walkover": true, "opp_off": -3.0 }, { "id": "pro", "name": "pro, weighed the day before, 6 rounds", "pro": true, "rounds": 6, "share": 0.8125, "share_big": 1.25, "big_odds": 0.2, "share_mean": 0.9, "opp_regain": 7.2, "free": 2.0, "cond": 1.5, "power": 0.0, "read": 0.5, "knee": 5.0, "cond2": 1.5, "power2": 1.0, "water_ok": 8.0, "cap": 8.0, "miss_base": 0.02, "walkover": false, "opp_off": -6.0 }]

Model: { "cut_water": 0.04, "up_fill": 0.015, "diet_hold": 0.025, "diet_hold_down": 0.05, "diet_pace": 0.7, "size_power": 1.2, "size_chin": 1.0, "size_speed": 0.4, "size_cap": 8.0, "size_win": 3.0, "tank_max": 25.0, "grow": 0.33, "diet_cost": 0.12, "grow_min": 0.4, "miss_slope": 0.2, "miss_max": 0.7, "miss_push": 2, "rung0": 10.0, "rung_move": 11.0, "rung_gap": 1.2, "rung_max": 20.0, "field_grow": 0.15, "refuse_up": 0.3, "refuse_down": 0.5, "refuse_conf": 0.005, "refuse_loyal": 0.006, "refuse_wish": 0.25, "refuse_wait": 3 }

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

Cut = kilos over the class; diet = weeks of dieting at 0.7 % of body a week to hold the rest off (SOURCED pace, Garthe 2011) and the share of
training gain he keeps while holding it; by water = the part left for fight week (% of body weight); dry = % still missing at the bell (a pro: on the average night);
Stamina = % of his Stamina and tank the cut costs; size gap = his ring weight against the opponent's; refuses = the chance he says no;
win and stopped (won inside / lost inside) are shares of the bouts fought; late = last third of the rounds won; missed = scales missed a run;
moved = runs where two misses moved him up a class; place = ladder rung at the end (1 is the top; start 10, a class move 11) with its standard error over the 40 seeds.

### puncher / am (amateur, weighed an hour before, 3 rounds)

| Choice | Class | Walks | Cut | Diet weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 65 | 65.9 kg | 0.9 kg | 2.0 | 84 % | 0.0 % | 0.0 % | -0.0 % | -0.5 % | 0 % | 50 % | 11 / 2 % | 33 % | 0.00 | 0 % | 9.31 +- 0.36 |
| CUT | 65 | 69.5 kg | 4.5 kg | 3.6 | 70 % | 4.0 % | 3.5 % | -8.0 % | +0.0 % | 0 % | 48 % | 12 / 1 % | 32 % | 1.80 | 83 % | 12.50 +- 0.37 |
| UP | 70 | 66.9 kg | 0.0 kg | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -4.9 % | 14 % | 45 % | 9 / 4 % | 32 % | 0.00 | 0 % | 11.64 +- 0.36 |
| DOWN | 60 | 65.9 kg | 5.9 kg | 7.1 | 40 % | 4.0 % | 3.5 % | -7.8 % | +0.0 % | 34 % | 52 % | 15 / 1 % | 33 % | 1.68 | 73 % | 12.20 +- 0.34 |

Best: **STAY**

### puncher / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Walks | Cut | Diet weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 65 | 65.9 kg | 0.9 kg | 2.0 | 84 % | 0.0 % | 0.0 % | -0.0 % | -6.7 % | 0 % | 38 % | 28 / 10 % | 25 % | 0.00 | 0 % | 9.90 +- 0.33 |
| CUT | 65 | 69.5 kg | 4.5 kg | 3.6 | 70 % | 4.0 % | 0.4 % | -3.0 % | -3.1 % | 0 % | 42 % | 34 / 7 % | 24 % | 0.35 | 5 % | 8.66 +- 0.32 |
| UP | 70 | 66.9 kg | 0.0 kg | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -10.9 % | 14 % | 38 % | 27 / 11 % | 26 % | 0.00 | 0 % | 11.10 +- 0.28 |
| DOWN | 60 | 65.9 kg | 5.9 kg | 7.1 | 40 % | 4.0 % | 0.4 % | -2.9 % | -3.1 % | 34 % | 44 % | 37 / 6 % | 24 % | 0.23 | 3 % | 9.36 +- 0.35 |

Best: **CUT**

### volume / am (amateur, weighed an hour before, 3 rounds)

| Choice | Class | Walks | Cut | Diet weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 70 | 71.4 kg | 1.4 kg | 2.8 | 76 % | 0.0 % | 0.0 % | -0.0 % | -0.5 % | 0 % | 53 % | 10 / 2 % | 51 % | 0.00 | 0 % | 8.66 +- 0.40 |
| CUT | 70 | 74.9 kg | 4.9 kg | 3.6 | 70 % | 4.0 % | 3.5 % | -8.0 % | +0.0 % | 0 % | 55 % | 9 / 2 % | 47 % | 1.55 | 68 % | 10.68 +- 0.38 |
| UP | 75 | 72.5 kg | 0.0 kg | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -3.9 % | 7 % | 53 % | 8 / 2 % | 50 % | 0.00 | 0 % | 9.94 +- 0.40 |
| DOWN | 65 | 71.4 kg | 6.4 kg | 7.1 | 40 % | 4.0 % | 3.5 % | -7.9 % | +0.0 % | 27 % | 56 % | 11 / 1 % | 49 % | 1.38 | 50 % | 11.06 +- 0.37 |

Best: **STAY**

### volume / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Walks | Cut | Diet weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 70 | 71.4 kg | 1.4 kg | 2.8 | 76 % | 0.0 % | 0.0 % | -0.0 % | -6.7 % | 0 % | 43 % | 18 / 6 % | 52 % | 0.00 | 0 % | 8.43 +- 0.29 |
| CUT | 70 | 74.9 kg | 4.9 kg | 3.6 | 70 % | 4.0 % | 0.4 % | -3.0 % | -3.1 % | 0 % | 50 % | 37 / 5 % | 45 % | 0.28 | 3 % | 6.14 +- 0.24 |
| UP | 75 | 72.5 kg | 0.0 kg | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -9.9 % | 7 % | 45 % | 20 / 6 % | 54 % | 0.00 | 0 % | 8.90 +- 0.29 |
| DOWN | 65 | 71.4 kg | 6.4 kg | 7.1 | 40 % | 4.0 % | 0.4 % | -2.9 % | -3.1 % | 27 % | 52 % | 38 / 5 % | 49 % | 0.25 | 3 % | 6.59 +- 0.31 |

Best: **CUT** - a tie with DOWN (inside two standard errors of the paired difference)

### big chin / am (amateur, weighed an hour before, 3 rounds)

| Choice | Class | Walks | Cut | Diet weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 75 | 76.1 kg | 1.1 kg | 2.1 | 83 % | 0.0 % | 0.0 % | -0.0 % | -0.5 % | 0 % | 52 % | 8 / 1 % | 40 % | 0.00 | 0 % | 9.03 +- 0.33 |
| CUT | 75 | 80.2 kg | 5.2 kg | 3.6 | 70 % | 4.0 % | 3.5 % | -8.0 % | +0.0 % | 0 % | 53 % | 8 / 1 % | 40 % | 1.58 | 70 % | 11.35 +- 0.43 |
| UP | 81 | 77.2 kg | 0.0 kg | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -5.1 % | 25 % | 56 % | 7 / 2 % | 54 % | 0.00 | 0 % | 9.09 +- 0.35 |
| DOWN | 70 | 76.1 kg | 6.1 kg | 7.1 | 40 % | 3.0 % | 2.6 % | -4.1 % | +0.0 % | 45 % | 51 % | 9 / 1 % | 36 % | 0.13 | 3 % | 10.41 +- 0.35 |

Best: **UP** - a tie with STAY (inside two standard errors of the paired difference)

### big chin / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Walks | Cut | Diet weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 75 | 76.1 kg | 1.1 kg | 2.1 | 83 % | 0.0 % | 0.0 % | -0.0 % | -6.7 % | 0 % | 48 % | 19 / 6 % | 42 % | 0.00 | 0 % | 7.58 +- 0.29 |
| CUT | 75 | 80.2 kg | 5.2 kg | 3.6 | 70 % | 4.0 % | 0.4 % | -3.0 % | -3.1 % | 0 % | 49 % | 25 / 4 % | 37 % | 0.10 | 0 % | 7.09 +- 0.30 |
| UP | 81 | 77.2 kg | 0.0 kg | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -11.0 % | 25 % | 48 % | 19 / 6 % | 42 % | 0.00 | 0 % | 8.64 +- 0.29 |
| DOWN | 70 | 76.1 kg | 6.1 kg | 7.1 | 40 % | 3.0 % | 0.3 % | -1.5 % | -4.0 % | 45 % | 50 % | 24 / 5 % | 40 % | 0.10 | 0 % | 7.81 +- 0.34 |

Best: **CUT**

### drained cutter / am (amateur, weighed an hour before, 3 rounds)

| Choice | Class | Walks | Cut | Diet weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 57 | 60.8 kg | 3.8 kg | 3.6 | 70 % | 3.7 % | 3.3 % | -7.0 % | +0.0 % | 0 % | 58 % | 6 / 6 % | 61 % | 1.30 | 50 % | 9.84 +- 0.34 |
| CUT | 57 | 61.0 kg | 4.0 kg | 3.6 | 70 % | 4.0 % | 3.5 % | -8.0 % | +0.0 % | 0 % | 59 % | 6 / 5 % | 63 % | 1.60 | 70 % | 10.11 +- 0.37 |
| UP | 60 | 61.7 kg | 1.7 kg | 3.6 | 70 % | 0.3 % | 0.0 % | -0.0 % | -0.2 % | 5 % | 58 % | 6 / 6 % | 62 % | 0.07 | 0 % | 8.86 +- 0.37 |
| DOWN | 54 | 60.8 kg | 6.8 kg | 7.1 | 40 % | 6.2 % | 5.7 % | -16.7 % | +0.0 % | 68 % | 68 % | 8 / 4 % | 70 % | 3.10 | 100 % | 11.95 +- 0.33 |

Best: **UP**

### drained cutter / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Walks | Cut | Diet weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 57 | 60.8 kg | 3.8 kg | 3.6 | 70 % | 3.7 % | 0.4 % | -2.6 % | -3.4 % | 0 % | 55 % | 19 / 17 % | 69 % | 0.23 | 3 % | 6.01 +- 0.28 |
| CUT | 57 | 61.0 kg | 4.0 kg | 3.6 | 70 % | 4.0 % | 0.4 % | -3.0 % | -3.1 % | 0 % | 55 % | 19 / 17 % | 69 % | 0.23 | 3 % | 5.99 +- 0.29 |
| UP | 60 | 61.7 kg | 1.7 kg | 3.6 | 70 % | 0.3 % | 0.0 % | -0.0 % | -6.5 % | 23 % | 56 % | 15 / 20 % | 71 % | 0.23 | 0 % | 7.15 +- 0.29 |
| DOWN | 54 | 60.8 kg | 6.8 kg | 7.1 | 40 % | 6.2 % | 0.6 % | -8.1 % | -0.9 % | 43 % | 57 % | 22 / 11 % | 68 % | 0.23 | 3 % | 6.33 +- 0.29 |

Best: **STAY** - a tie with CUT (inside two standard errors of the paired difference)

### boxer-puncher / am (amateur, weighed an hour before, 3 rounds)

| Choice | Class | Walks | Cut | Diet weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 60 | 61.1 kg | 1.1 kg | 2.6 | 78 % | 0.0 % | 0.0 % | -0.0 % | -0.5 % | 0 % | 55 % | 8 / 1 % | 50 % | 0.00 | 0 % | 8.40 +- 0.36 |
| CUT | 60 | 64.2 kg | 4.2 kg | 3.6 | 70 % | 4.0 % | 3.5 % | -8.0 % | +0.0 % | 0 % | 56 % | 8 / 2 % | 50 % | 1.55 | 63 % | 10.53 +- 0.42 |
| UP | 65 | 62.0 kg | 0.0 kg | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -5.1 % | 36 % | 55 % | 5 / 2 % | 51 % | 0.00 | 0 % | 9.61 +- 0.37 |
| DOWN | 55 | 61.1 kg | 6.1 kg | 7.1 | 40 % | 5.0 % | 4.5 % | -11.9 % | +0.0 % | 56 % | 64 % | 12 / 1 % | 56 % | 2.00 | 100 % | 10.68 +- 0.38 |

Best: **STAY**

### boxer-puncher / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Walks | Cut | Diet weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 60 | 61.1 kg | 1.1 kg | 2.6 | 78 % | 0.0 % | 0.0 % | -0.0 % | -6.7 % | 0 % | 51 % | 19 / 6 % | 58 % | 0.00 | 0 % | 6.99 +- 0.29 |
| CUT | 60 | 64.2 kg | 4.2 kg | 3.6 | 70 % | 4.0 % | 0.4 % | -3.0 % | -3.1 % | 0 % | 52 % | 24 / 5 % | 57 % | 0.17 | 3 % | 6.39 +- 0.28 |
| UP | 65 | 62.0 kg | 0.0 kg | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -11.0 % | 36 % | 51 % | 19 / 6 % | 59 % | 0.00 | 0 % | 7.88 +- 0.26 |
| DOWN | 55 | 61.1 kg | 6.1 kg | 7.1 | 40 % | 5.0 % | 0.5 % | -4.5 % | -2.1 % | 56 % | 54 % | 25 / 4 % | 57 % | 0.15 | 0 % | 6.67 +- 0.28 |

Best: **CUT**

## 3. Ladder place at the end, every cell (lower is better; +- one standard error)

| Cell | STAY | CUT | UP | DOWN | Best | Inside the noise of it | CUT against STAY (rungs; + is worse) |
| :--- | ---: | ---: | ---: | ---: | :--- | :--- | ---: |
| puncher / am | 9.31 +- 0.36 | 12.50 +- 0.37 | 11.64 +- 0.36 | 12.20 +- 0.34 | STAY | - | +3.19 +- 0.23 (clearly worse) |
| puncher / pro | 9.90 +- 0.33 | 8.66 +- 0.32 | 11.10 +- 0.28 | 9.36 +- 0.35 | CUT | - | -1.24 +- 0.21 (clearly better) |
| volume / am | 8.66 +- 0.40 | 10.68 +- 0.38 | 9.94 +- 0.40 | 11.06 +- 0.37 | STAY | - | +2.01 +- 0.23 (clearly worse) |
| volume / pro | 8.43 +- 0.29 | 6.14 +- 0.24 | 8.90 +- 0.29 | 6.59 +- 0.31 | CUT | DOWN | -2.29 +- 0.25 (clearly better) |
| big chin / am | 9.03 +- 0.33 | 11.35 +- 0.43 | 9.09 +- 0.35 | 10.41 +- 0.35 | UP | STAY | +2.33 +- 0.29 (clearly worse) |
| big chin / pro | 7.58 +- 0.29 | 7.09 +- 0.30 | 8.64 +- 0.29 | 7.81 +- 0.34 | CUT | - | -0.49 +- 0.15 (clearly better) |
| drained cutter / am | 9.84 +- 0.34 | 10.11 +- 0.37 | 8.86 +- 0.37 | 11.95 +- 0.33 | UP | - | +0.28 +- 0.13 (clearly worse) |
| drained cutter / pro | 6.01 +- 0.28 | 5.99 +- 0.29 | 7.15 +- 0.29 | 6.33 +- 0.29 | STAY | CUT | -0.03 +- 0.04 |
| boxer-puncher / am | 8.40 +- 0.36 | 10.53 +- 0.42 | 9.61 +- 0.37 | 10.68 +- 0.38 | STAY | - | +2.13 +- 0.24 (clearly worse) |
| boxer-puncher / pro | 6.99 +- 0.29 | 6.39 +- 0.28 | 7.88 +- 0.26 | 6.67 +- 0.28 | CUT | - | -0.60 +- 0.17 (clearly better) |

Best counts (the lowest place, round 2's rule): { "STAY": 4, "CUT": 4, "UP": 2, "DOWN": 0 }. The most any one choice wins: 4 of 10 cells (bar: 6 or fewer).
Clear bests (no other choice inside the noise): { "STAY": 3, "CUT": 3, "UP": 1, "DOWN": 0 } - 7 of 10 cells are clear.
Best or tied for best: { "STAY": 5, "CUT": 5, "UP": 2, "DOWN": 1 } - the most any one choice is in the leading group: 5 of 10 cells; CUT harder in 5 (bar: 6 or fewer).
Amateur cells where CUT harder is clearly worse than STAY (two standard errors, seed by seed): 5 (puncher / am, volume / am, big chin / am, drained cutter / am, boxer-puncher / am) (bar: 1 or more).

Moving up, all ten cells pooled: knockout share of the wins 29 % staying, 27 % up (x 0.92); stopped 5.6 in 100 bouts staying, 6.5 up (x 1.16).
John E (ESTIMATE, half his biased count, for TWO classes up): knockout share x 0.88, stopped x 1.5.

## 4. Does each lever move the result? (lever off, 3 seeds, against the same seeds with it on)

| Lever off | Mean change in win share | Biggest change in ladder place | Cells whose best choice changes | Moves it |
| :--- | ---: | ---: | ---: | :--- |
| drain | 2.0 points | 2.00 rungs | 4 of 10 | yes |
| size | 4.6 points | 5.00 rungs | 6 of 10 | yes |
| diet | 2.4 points | 1.83 rungs | 2 of 10 | yes |
| miss | 1.8 points | 3.50 rungs | 0 of 10 | yes |
| rank | 1.9 points | 2.50 rungs | 4 of 10 | yes |
| refuse | 0.6 points | 1.17 rungs | 0 of 10 | yes |

Size as it lands on the ladder (lever on against off, over the size gaps of the 40 cell choices): 1.2 wins in 100 per 1 % of ring weight.
The fit of step 0 aims at John's 3.0 with the opponents held still; on the ladder a winner meets better men, which shrinks it.

32885 bouts played in 932 s.

RESULT: tools/weight2_probe.gd -> PASS (levers all move; top choice best in 4 of 10 cells; 7 of 10 cells clear of the noise; CUT in the leading group of 5; CUT clearly worse than STAY in 5 amateur cells)
