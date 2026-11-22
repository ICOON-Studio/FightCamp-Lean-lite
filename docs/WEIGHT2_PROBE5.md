# WEIGHT2 probe, ROUND 5 - the same kilos by diet, by water or carried up; frame on; the field cuts; the design's three scales (S536 WEIGHT2R5)

Round 4 (docs/WEIGHT2_PROBE4.md) passed its bars and two critics stopped at 6: the probe never ran the one trade the design is about, erased height and reach,
let the field ring heavy for nothing and boxed a scale the design does not have. Round 5 changes the scratch model for exactly those four things:
1. Water comes off first up to the free 2 %, and section 5 runs the SAME kilos (3 / 4 / 5 / 6 % over the line) by DIET, by WATER, MIXED, or carried UP.
2. Frame is on: the opponent's height and reach are drawn from the class boxed at (AttrGen.body), from that division's own sheet; the fit takes the average worth of a class of frame back out of a move, so size is not counted twice.
3. The field cuts and pays John's table (a pro opponent 6 to 10 %, mean 8 % = his 7.2 % regain); the hard cutters fade late on the game's own word; the field is refitted after.
4. Three scales: club show (one hour, the gap rule, no walkover), championship (three hours, +1.9 %, a walkover, weighed on each of three boxing days), pro. The amateur hybrid is gone.

Run: python ops/Tools/godot_slot.py run --who weight2r5 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/weight2_probe.gd -- seeds=40 bouts=12 abl=3 cal=6 pol=16 read=20

What is real: the five boxers (Data.PROSPECTS) with their own height and reach (BodyFacts), each class's opponents (Data's division sheets), the club-show gap (WeighGap) and every bout (BoutNight, the game's fight night). What is scratch: the weight model (tools/weight2_model.gd).
Each run = 12 bout slots on a 20-rung ladder; 40 seeds a cell; every choice of a seed fights the same nights (same dice). A championship is three boxing days in a row: a loss or a walkover ends it, so its runs box fewer bouts.

Scales: [{ "id": "club", "name": "club show: weighed an hour before, the gap rule, 3 rounds", "pro": false, "rounds": 3, "days": 1, "regain": 0.5, "miss": "gap", "free": 2.0, "cond": 4.0, "power": 1.5, "read": 1.0, "knee": 99.0, "cond2": 0.0, "power2": 0.0, "water_ok": 3.0, "cap": 5.0, "miss_base": 0.01, "opp_cut": [0.0], "opp_back": 0.0, "opp_short": 1.0, "opp_off": -3.0 }, { "id": "champ", "name": "championship: weighed three hours before on each of three boxing days, 3 rounds", "pro": false, "rounds": 3, "days": 3, "regain": 1.9, "miss": "walkover", "free": 2.0, "cond": 4.0, "power": 1.5, "read": 1.0, "knee": 99.0, "cond2": 0.0, "power2": 0.0, "water_ok": 3.0, "cap": 5.0, "miss_base": 0.01, "opp_cut": [2.0, 3.0, 4.0], "opp_back": 1.9, "opp_short": 0.0, "opp_off": -3.0 }, { "id": "pro", "name": "pro: weighed the day before, 6 rounds", "pro": true, "rounds": 6, "days": 1, "share": 0.8125, "share_big": 1.25, "big_odds": 0.2, "share_mean": 0.9, "miss": "fine", "free": 2.0, "cond": 1.5, "power": 0.0, "read": 0.5, "knee": 5.0, "cond2": 1.5, "power2": 1.0, "water_ok": 8.0, "cap": 8.0, "miss_base": 0.02, "opp_cut": [6.0, 7.0, 8.0, 9.0, 10.0], "opp_share": 0.9, "opp_short": 0.0, "opp_off": -6.0 }]

Model: { "cut_water": 0.04, "up_fill": 0.015, "diet_hold": 2.5, "diet_hold_down": 5.0, "diet_pace": 0.7, "size_power": 1.2, "size_chin": 1.0, "size_speed": 0.4, "size_cap": 8.0, "size_win": 3.0, "grow": 0.33, "diet_cost": 0.12, "grow_min": 0.4, "miss_slope": 0.2, "miss_max": 0.7, "miss_push": 2, "rung0": 10.0, "rung_move": 11.0, "rung_gap": 1.2, "rung_max": 20.0, "field_grow": 0.15, "refuse_up": 0.3, "refuse_down": 0.5, "refuse_conf": 0.005, "refuse_loyal": 0.006, "refuse_wish": 0.25, "refuse_wait": 3, "carry": 0.74, "fade_at": 15.0, "opp_stat": 60.0, "read_width": 1.5, "read_hard": 9.0 }

## The bars, written before the run

- Round 4's, as shares of the 15 cells: every one of round 4's six levers moves the result; no choice best in more than 9 cells (6 of 10); 6 or more cells clear of the noise (4 of 10);
  CUT harder in the leading group of at most 6 in 10 of the cells where it is a choice; one amateur cell or more where CUT is clearly worse than STAY. A boxer for whom CUT is the same plan as STAY has no CUT (the critic's item 14).
- Item 1: inside ONE scale the best policy changes with how far over he is AND with the boxer. A change = each cell's best is outside the other cell's leading group (best plus everything inside two standard errors of it).
- Item 2: moving DOWN best or tied in one cell or more of a boxer who works off the jab (Out-boxer or Boxer-puncher); moving UP best or tied in one cell or more of the chin with no reach (Chin 64 or more, the least reach against the class).

## 0. The fit (6 seeds x 12 bouts a cell and setting, no cut of ours, no ladder; the field with its own cut, frame on; 7560 bouts)

| Scale | plain | 4 % bigger (stats only) | 4 % smaller | field 2 points weaker | field 2 points stronger | opponent's frame from the class above | from the class below |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| club | 50 % | 55 % | 48 % | 60 % | 40 % | 51 % | 49 % |
| champ | 53 % | 58 % | 51 % | 64 % | 44 % | 54 % | 52 % |
| pro | 57 % | 65 % | 57 % | 69 % | 51 % | 59 % | 57 % |

Measured: the size split of punch, chin and hand speed is worth 1.00 wins in 100 per 1 % of ring weight; a rating point 4.79 wins in 100; a cm of class frame (height and reach together, the class step is 4.7 cm) -0.20 wins in 100.
John (DERIVED, Baribeau 2023): about 3.0 wins in 100 per 1 % heavier. So the rest goes in the exchanges: size_rating = 0.42 rating points per 1 %.
Frame and mass together (Kalli's point 6): a class move's size term already pays for being the bigger or smaller man, so the AVERAGE worth of the frame that comes with the class, 0.00 rating points a cm, is taken back out of a move. What is left of frame is the boxer's own: more than average for one who lives on the long jab, less for one who does not.
Field, club: STAY's mean size gap +1.5 % -> about 54 % wins at offset -3.0; the offset becomes -2.1 (STAY at about half).
Field, champ: STAY's mean size gap -0.2 % -> about 52 % wins at offset -3.0; the offset becomes -2.6 (STAY at about half).
Field, pro: STAY's mean size gap -4.9 % -> about 43 % wins at offset -6.0; the offset becomes -7.5 (STAY at about half).
Round 4's offsets were -5.3 (its amateur hybrid) and -10.9 (pro, a field that rang 7.2 % over and paid nothing).

## 1. Who they are

Height and reach are the game's own (BodyFacts, seeded by the name); the class columns are the mean frame of the class below, their own and the class above (AttrGen.body: 1 cm a kg).

| Boxer (shape) | Style | Class | Walks | Power | Speed | Stamina | Chin | Discipline | Confidence | Loyalty | Height | Reach | Reach of the class below / own / above |
| :--- | :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Samira Khan (puncher) | Slugger | 65 kg | 65.9 kg | 66 | 57 | 60 | 63 | 34 | 66 | 82 | 171 cm | 169 cm | 167 / 172 / 177 cm |
| Josh Harper (volume) | Pressure fighter | 70 kg | 71.4 kg | 63 | 56 | 65 | 64 | 80 | 38 | 70 | 183 cm | 182 cm | 180 / 185 / 190 cm |
| Tess Reilly (big chin) | Pressure fighter | 75 kg | 76.1 kg | 62 | 55 | 64 | 67 | 62 | 70 | 66 | 184 cm | 186 cm | 177 / 182 / 188 cm |
| Kira Mensah (drained cutter) | Out-boxer | 57 kg | 60.8 kg | 54 | 67 | 58 | 52 | 64 | 58 | 60 | 166 cm | 168 cm | 161 / 164 / 167 cm |
| Danny Osei (boxer-puncher) | Boxer-puncher | 60 kg | 61.1 kg | 59 | 62 | 57 | 62 | 60 | 82 | 58 | 176 cm | 177 cm | 170 / 175 / 180 cm |

## 2. The cell table (round 4's four class choices, on the three scales)

Diet = % of walking weight held off by the diet, its weeks at 0.7 % a week and the share of training gain kept while he holds it; by water = the rest (the first 2 % is free and comes off first);
dry = % still missing at the bell (a pro: on the average night); Stamina = % of his Stamina and tank the cut costs on the first boxing day; size gap = his ring weight against the field's mean ring weight;
refuses = the chance he says no; win, stopped (won inside / lost inside) = shares of the bouts fought; late = last third of the rounds won; missed = scales missed a run; no bout = bouts lost to the scale a run
(club show: called off, nothing on the record; championship: a walkover loss); moved = runs where two misses moved him up; bouts = bouts boxed a run; place = ladder rung at the end (1 is the top; start 10, a class move 11) +- its standard error over the 40 seeds.

### puncher / club (club show: weighed an hour before, the gap rule, 3 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 65 | 65.9 kg | 0.0 % | 0.0 | 100 % | 1.4 % | 0.9 % | -0.0 % | +1.5 % | 0 % | 56 % | 11 / 2 % | 34 % | 0.15 | 0.00 | 0 % | 12.0 | 7.99 +- 0.44 |
| CUT | 65 | 69.5 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 3.5 % | -8.0 % | +1.5 % | 0 % | 45 % | 8 / 2 % | 24 % | 2.92 | 0.00 | 0 % | 12.0 | 10.79 +- 0.38 |
| UP | 70 | 66.9 kg | 0.0 % | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -3.5 % | 14 % | 38 % | 5 / 2 % | 24 % | 0.00 | 0.00 | 0 % | 12.0 | 13.59 +- 0.51 |
| DOWN | 60 | 65.9 kg | 5.0 % | 7.1 | 40 % | 4.0 % | 3.5 % | -7.8 % | +1.5 % | 34 % | 35 % | 10 / 2 % | 21 % | 2.38 | 0.00 | 0 % | 12.0 | 13.85 +- 0.56 |

Best: **STAY**

### puncher / champ (championship: weighed three hours before on each of three boxing days, 3 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 65 | 65.9 kg | 0.0 % | 0.0 | 100 % | 1.4 % | 0.0 % | -0.0 % | -0.5 % | 0 % | 53 % | 8 / 2 % | 34 % | 0.07 | 0.07 | 0 % | 7.3 | 9.28 +- 0.36 |
| CUT | 65 | 69.5 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 2.2 % | -8.0 % | +0.0 % | 0 % | 38 % | 6 / 5 % | 17 % | 1.23 | 1.23 | 45 % | 4.4 | 12.57 +- 0.26 |
| UP | 70 | 66.9 kg | 0.0 % | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -6.2 % | 14 % | 32 % | 4 / 3 % | 21 % | 0.00 | 0.00 | 0 % | 5.6 | 12.88 +- 0.28 |
| DOWN | 60 | 65.9 kg | 5.0 % | 7.1 | 40 % | 4.0 % | 2.2 % | -7.8 % | +0.0 % | 34 % | 40 % | 8 / 3 % | 24 % | 0.93 | 0.93 | 28 % | 4.7 | 12.98 +- 0.29 |

Best: **STAY**

### puncher / pro (pro: weighed the day before, 6 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 65 | 65.9 kg | 0.0 % | 0.0 | 100 % | 1.4 % | 0.1 % | -0.0 % | -5.6 % | 0 % | 40 % | 27 / 10 % | 28 % | 0.35 | 0.00 | 5 % | 12.0 | 9.13 +- 0.35 |
| CUT | 65 | 69.5 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 0.4 % | -3.0 % | -3.1 % | 0 % | 40 % | 31 / 8 % | 27 % | 0.35 | 0.00 | 5 % | 12.0 | 9.21 +- 0.34 |
| UP | 70 | 66.9 kg | 0.0 % | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -10.9 % | 14 % | 30 % | 22 / 11 % | 23 % | 0.03 | 0.00 | 0 % | 12.0 | 13.07 +- 0.50 |
| DOWN | 60 | 65.9 kg | 5.0 % | 7.1 | 40 % | 4.0 % | 0.4 % | -2.9 % | -3.1 % | 34 % | 36 % | 29 / 8 % | 24 % | 0.35 | 0.00 | 5 % | 12.0 | 11.41 +- 0.46 |

Best: **CUT** - a tie with STAY (inside two standard errors of the paired difference)

### volume / club (club show: weighed an hour before, the gap rule, 3 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 70 | 71.4 kg | 0.0 % | 0.0 | 100 % | 2.0 % | 1.5 % | -0.0 % | +1.5 % | 0 % | 46 % | 6 / 2 % | 45 % | 0.17 | 0.00 | 0 % | 12.0 | 10.51 +- 0.35 |
| CUT | 70 | 74.9 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 3.5 % | -8.0 % | +1.5 % | 0 % | 40 % | 6 / 2 % | 37 % | 1.83 | 0.00 | 0 % | 12.0 | 12.13 +- 0.34 |
| UP | 75 | 72.5 kg | 0.0 % | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -2.4 % | 7 % | 43 % | 9 / 4 % | 39 % | 0.03 | 0.00 | 0 % | 12.0 | 12.13 +- 0.32 |
| DOWN | 65 | 71.4 kg | 5.0 % | 7.1 | 40 % | 4.0 % | 3.5 % | -7.9 % | +1.5 % | 27 % | 42 % | 7 / 1 % | 39 % | 1.63 | 0.00 | 0 % | 12.0 | 12.49 +- 0.33 |

Best: **STAY**

### volume / champ (championship: weighed three hours before on each of three boxing days, 3 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 70 | 71.4 kg | 0.0 % | 0.0 | 100 % | 2.0 % | 0.1 % | -0.0 % | +0.0 % | 0 % | 47 % | 6 / 1 % | 44 % | 0.07 | 0.07 | 0 % | 6.7 | 10.26 +- 0.31 |
| CUT | 70 | 74.9 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 2.2 % | -8.0 % | +0.0 % | 0 % | 36 % | 3 / 1 % | 32 % | 0.70 | 0.70 | 18 % | 5.1 | 12.21 +- 0.23 |
| UP | 75 | 72.5 kg | 0.0 % | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -5.2 % | 7 % | 34 % | 5 / 6 % | 32 % | 0.00 | 0.00 | 0 % | 5.9 | 12.79 +- 0.25 |
| DOWN | 65 | 71.4 kg | 5.0 % | 7.1 | 40 % | 4.0 % | 2.2 % | -7.9 % | +0.0 % | 27 % | 39 % | 5 / 1 % | 37 % | 0.65 | 0.65 | 15 % | 5.3 | 12.82 +- 0.21 |

Best: **STAY**

### volume / pro (pro: weighed the day before, 6 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 70 | 71.4 kg | 0.0 % | 0.0 | 100 % | 2.0 % | 0.2 % | -0.0 % | -5.0 % | 0 % | 43 % | 24 / 9 % | 45 % | 0.28 | 0.00 | 3 % | 12.0 | 8.54 +- 0.34 |
| CUT | 70 | 74.9 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 0.4 % | -3.0 % | -3.1 % | 0 % | 43 % | 26 / 7 % | 44 % | 0.28 | 0.00 | 3 % | 12.0 | 8.41 +- 0.29 |
| UP | 75 | 72.5 kg | 0.0 % | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -9.9 % | 7 % | 45 % | 16 / 12 % | 56 % | 0.00 | 0.00 | 0 % | 12.0 | 9.65 +- 0.26 |
| DOWN | 65 | 71.4 kg | 5.0 % | 7.1 | 40 % | 4.0 % | 0.4 % | -2.9 % | -3.1 % | 27 % | 44 % | 29 / 10 % | 47 % | 0.28 | 0.00 | 3 % | 12.0 | 8.79 +- 0.28 |

Best: **CUT** - a tie with STAY, DOWN (inside two standard errors of the paired difference)

### big chin / club (club show: weighed an hour before, the gap rule, 3 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 75 | 76.1 kg | 0.0 % | 0.0 | 100 % | 1.4 % | 1.0 % | -0.0 % | +1.5 % | 0 % | 46 % | 11 / 2 % | 36 % | 0.07 | 0.00 | 0 % | 12.0 | 10.21 +- 0.34 |
| CUT | 75 | 80.2 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 3.5 % | -8.0 % | +1.5 % | 0 % | 38 % | 8 / 2 % | 25 % | 2.25 | 0.00 | 0 % | 12.0 | 12.53 +- 0.31 |
| UP | 81 | 77.2 kg | 0.0 % | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -3.7 % | 25 % | 47 % | 8 / 2 % | 50 % | 0.00 | 0.00 | 0 % | 12.0 | 11.25 +- 0.31 |
| DOWN | 70 | 76.1 kg | 5.0 % | 7.1 | 40 % | 3.0 % | 2.6 % | -4.1 % | +1.5 % | 45 % | 43 % | 7 / 1 % | 28 % | 0.10 | 0.00 | 0 % | 12.0 | 12.40 +- 0.36 |

Best: **STAY**

### big chin / champ (championship: weighed three hours before on each of three boxing days, 3 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 75 | 76.1 kg | 0.0 % | 0.0 | 100 % | 1.4 % | 0.0 % | -0.0 % | -0.4 % | 0 % | 44 % | 10 / 3 % | 32 % | 0.05 | 0.05 | 0 % | 6.5 | 10.51 +- 0.30 |
| CUT | 75 | 80.2 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 2.2 % | -8.0 % | +0.0 % | 0 % | 30 % | 5 / 4 % | 19 % | 0.88 | 0.88 | 20 % | 4.5 | 12.71 +- 0.19 |
| UP | 81 | 77.2 kg | 0.0 % | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -6.4 % | 25 % | 44 % | 5 / 4 % | 47 % | 0.00 | 0.00 | 0 % | 6.7 | 11.57 +- 0.29 |
| DOWN | 70 | 76.1 kg | 5.0 % | 7.1 | 40 % | 3.0 % | 1.3 % | -4.1 % | +0.0 % | 45 % | 37 % | 6 / 2 % | 23 % | 0.07 | 0.07 | 0 % | 6.1 | 12.45 +- 0.22 |

Best: **STAY**

### big chin / pro (pro: weighed the day before, 6 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 75 | 76.1 kg | 0.0 % | 0.0 | 100 % | 1.4 % | 0.1 % | -0.0 % | -5.5 % | 0 % | 48 % | 22 / 7 % | 43 % | 0.10 | 0.00 | 0 % | 12.0 | 7.69 +- 0.26 |
| CUT | 75 | 80.2 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 0.4 % | -3.0 % | -3.1 % | 0 % | 43 % | 28 / 6 % | 34 % | 0.10 | 0.00 | 0 % | 12.0 | 8.66 +- 0.26 |
| UP | 81 | 77.2 kg | 0.0 % | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -11.0 % | 25 % | 45 % | 18 / 9 % | 42 % | 0.00 | 0.00 | 0 % | 12.0 | 9.61 +- 0.26 |
| DOWN | 70 | 76.1 kg | 5.0 % | 7.1 | 40 % | 3.0 % | 0.3 % | -1.5 % | -4.0 % | 45 % | 42 % | 19 / 5 % | 37 % | 0.10 | 0.00 | 0 % | 12.0 | 9.86 +- 0.35 |

Best: **STAY**

### drained cutter / club (club show: weighed an hour before, the gap rule, 3 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 57 | 60.8 kg | 2.5 % | 3.6 | 70 % | 3.7 % | 3.3 % | -7.0 % | +1.5 % | 0 % | 47 % | 8 / 7 % | 54 % | 1.85 | 0.00 | 0 % | 12.0 | 10.34 +- 0.32 |
| CUT | 57 | 61.0 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 3.5 % | -8.0 % | +1.5 % | 0 % | 47 % | 8 / 7 % | 54 % | 2.25 | 0.00 | 0 % | 12.0 | 10.34 +- 0.31 |
| UP | 60 | 61.7 kg | 0.8 % | 1.1 | 91 % | 2.0 % | 1.5 % | -0.0 % | +1.5 % | 5 % | 52 % | 7 / 7 % | 57 % | 0.13 | 0.00 | 0 % | 12.0 | 10.15 +- 0.32 |
| DOWN | 54 | 60.8 kg | 5.0 % | 7.1 | 40 % | 6.2 % | 5.7 % | -16.7 % | +1.5 % | 68 % | 49 % | 8 / 6 % | 55 % | 10.07 | 3.48 | 0 % | 8.5 | 10.78 +- 0.32 |

Best: **UP** - a tie with STAY, CUT, DOWN (inside two standard errors of the paired difference)

### drained cutter / champ (championship: weighed three hours before on each of three boxing days, 3 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 57 | 60.8 kg | 2.5 % | 3.6 | 70 % | 3.7 % | 2.0 % | -7.0 % | +0.0 % | 0 % | 51 % | 5 / 7 % | 59 % | 0.82 | 0.82 | 23 % | 5.8 | 10.84 +- 0.28 |
| CUT | 57 | 61.0 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 2.2 % | -8.0 % | +0.0 % | 0 % | 50 % | 5 / 6 % | 59 % | 1.00 | 1.00 | 30 % | 5.4 | 11.15 +- 0.28 |
| UP | 60 | 61.7 kg | 0.8 % | 1.1 | 91 % | 2.0 % | 0.2 % | -0.0 % | +0.0 % | 5 % | 56 % | 7 / 6 % | 59 % | 0.10 | 0.10 | 0 % | 7.4 | 10.00 +- 0.32 |
| DOWN | 54 | 60.8 kg | 5.0 % | 7.1 | 40 % | 6.2 % | 4.5 % | -16.7 % | +0.0 % | 68 % | 66 % | 11 / 5 % | 66 % | 2.35 | 2.35 | 100 % | 3.7 | 12.95 +- 0.28 |

Best: **UP**

### drained cutter / pro (pro: weighed the day before, 6 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 57 | 60.8 kg | 2.5 % | 3.6 | 70 % | 3.7 % | 0.4 % | -2.6 % | -3.4 % | 0 % | 54 % | 18 / 19 % | 71 % | 0.23 | 0.00 | 3 % | 12.0 | 6.60 +- 0.28 |
| CUT | 57 | 61.0 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 0.4 % | -3.0 % | -3.1 % | 0 % | 54 % | 19 / 18 % | 70 % | 0.23 | 0.00 | 3 % | 12.0 | 6.51 +- 0.27 |
| UP | 60 | 61.7 kg | 0.8 % | 1.1 | 91 % | 2.0 % | 0.2 % | -0.0 % | -5.0 % | 23 % | 54 % | 19 / 22 % | 72 % | 0.23 | 0.00 | 0 % | 12.0 | 7.42 +- 0.24 |
| DOWN | 54 | 60.8 kg | 5.0 % | 7.1 | 40 % | 6.2 % | 0.6 % | -8.1 % | -0.9 % | 43 % | 57 % | 24 / 15 % | 69 % | 0.23 | 0.00 | 3 % | 12.0 | 6.46 +- 0.26 |

Best: **DOWN** - a tie with STAY, CUT (inside two standard errors of the paired difference)

### boxer-puncher / club (club show: weighed an hour before, the gap rule, 3 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 60 | 61.1 kg | 0.0 % | 0.0 | 100 % | 1.8 % | 1.3 % | -0.0 % | +1.5 % | 0 % | 51 % | 5 / 3 % | 52 % | 0.13 | 0.00 | 0 % | 12.0 | 9.35 +- 0.38 |
| CUT | 60 | 64.2 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 3.5 % | -8.0 % | +1.5 % | 0 % | 45 % | 4 / 3 % | 47 % | 2.63 | 0.00 | 0 % | 12.0 | 10.88 +- 0.37 |
| UP | 65 | 62.0 kg | 0.0 % | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -3.6 % | 36 % | 50 % | 2 / 4 % | 50 % | 0.00 | 0.00 | 0 % | 12.0 | 10.91 +- 0.35 |
| DOWN | 55 | 61.1 kg | 5.0 % | 7.1 | 40 % | 5.0 % | 4.5 % | -11.9 % | +1.5 % | 56 % | 46 % | 6 / 2 % | 46 % | 4.33 | 0.00 | 0 % | 12.0 | 11.51 +- 0.35 |

Best: **STAY**

### boxer-puncher / champ (championship: weighed three hours before on each of three boxing days, 3 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 60 | 61.1 kg | 0.0 % | 0.0 | 100 % | 1.8 % | 0.0 % | -0.0 % | -0.1 % | 0 % | 53 % | 5 / 3 % | 51 % | 0.07 | 0.07 | 0 % | 7.2 | 9.47 +- 0.33 |
| CUT | 60 | 64.2 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 2.2 % | -8.0 % | +0.0 % | 0 % | 45 % | 4 / 4 % | 46 % | 1.30 | 1.30 | 43 % | 4.7 | 12.11 +- 0.26 |
| UP | 65 | 62.0 kg | 0.0 % | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -6.4 % | 36 % | 46 % | 2 / 5 % | 47 % | 0.00 | 0.00 | 0 % | 6.8 | 11.54 +- 0.30 |
| DOWN | 55 | 61.1 kg | 5.0 % | 7.1 | 40 % | 5.0 % | 3.3 % | -11.9 % | +0.0 % | 56 % | 57 % | 9 / 2 % | 56 % | 1.63 | 1.63 | 70 % | 4.7 | 12.50 +- 0.28 |

Best: **STAY**

### boxer-puncher / pro (pro: weighed the day before, 6 rounds)

| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 60 | 61.1 kg | 0.0 % | 0.0 | 100 % | 1.8 % | 0.2 % | -0.0 % | -5.2 % | 0 % | 52 % | 14 / 10 % | 63 % | 0.17 | 0.00 | 3 % | 12.0 | 7.16 +- 0.29 |
| CUT | 60 | 64.2 kg | 2.5 % | 3.6 | 70 % | 4.0 % | 0.4 % | -3.0 % | -3.1 % | 0 % | 51 % | 15 / 9 % | 60 % | 0.17 | 0.00 | 3 % | 12.0 | 7.33 +- 0.27 |
| UP | 65 | 62.0 kg | 0.0 % | 0.0 | 100 % | 0.0 % | 0.0 % | -0.0 % | -11.0 % | 36 % | 49 % | 12 / 13 % | 62 % | 0.03 | 0.00 | 0 % | 12.0 | 8.84 +- 0.27 |
| DOWN | 55 | 61.1 kg | 5.0 % | 7.1 | 40 % | 5.0 % | 0.5 % | -4.5 % | -2.1 % | 56 % | 53 % | 20 / 5 % | 60 % | 0.17 | 0.00 | 3 % | 12.0 | 7.45 +- 0.23 |

Best: **STAY** - a tie with CUT, DOWN (inside two standard errors of the paired difference)

## 3. Ladder place at the end, every cell (lower is better; +- one standard error)

| Cell | STAY | CUT | UP | DOWN | Best | Inside the noise of it | CUT against STAY (rungs; + is worse) |
| :--- | ---: | ---: | ---: | ---: | :--- | :--- | ---: |
| puncher / club | 7.99 +- 0.44 | 10.79 +- 0.38 | 13.59 +- 0.51 | 13.85 +- 0.56 | STAY | - | +2.80 +- 0.23 (clearly worse) |
| puncher / champ | 9.28 +- 0.36 | 12.57 +- 0.26 | 12.88 +- 0.28 | 12.98 +- 0.29 | STAY | - | +3.30 +- 0.37 (clearly worse) |
| puncher / pro | 9.13 +- 0.35 | 9.21 +- 0.34 | 13.07 +- 0.50 | 11.41 +- 0.46 | CUT | STAY | +0.09 +- 0.24 |
| volume / club | 10.51 +- 0.35 | 12.13 +- 0.34 | 12.13 +- 0.32 | 12.49 +- 0.33 | STAY | - | +1.61 +- 0.19 (clearly worse) |
| volume / champ | 10.26 +- 0.31 | 12.21 +- 0.23 | 12.79 +- 0.25 | 12.82 +- 0.21 | STAY | - | +1.95 +- 0.29 (clearly worse) |
| volume / pro | 8.54 +- 0.34 | 8.41 +- 0.29 | 9.65 +- 0.26 | 8.79 +- 0.28 | CUT | STAY, DOWN | -0.13 +- 0.26 |
| big chin / club | 10.21 +- 0.34 | 12.53 +- 0.31 | 11.25 +- 0.31 | 12.40 +- 0.36 | STAY | - | +2.31 +- 0.19 (clearly worse) |
| big chin / champ | 10.51 +- 0.30 | 12.71 +- 0.19 | 11.57 +- 0.29 | 12.45 +- 0.22 | STAY | - | +2.20 +- 0.31 (clearly worse) |
| big chin / pro | 7.69 +- 0.26 | 8.66 +- 0.26 | 9.61 +- 0.26 | 9.86 +- 0.35 | STAY | - | +0.97 +- 0.21 (clearly worse) |
| drained cutter / club | 10.34 +- 0.32 | 10.34 +- 0.31 | 10.15 +- 0.32 | 10.78 +- 0.32 | UP | STAY, CUT, DOWN | +0.00 +- 0.13 |
| drained cutter / champ | 10.84 +- 0.28 | 11.15 +- 0.28 | 10.00 +- 0.32 | 12.95 +- 0.28 | UP | - | +0.31 +- 0.16 |
| drained cutter / pro | 6.60 +- 0.28 | 6.51 +- 0.27 | 7.42 +- 0.24 | 6.46 +- 0.26 | DOWN | STAY, CUT | -0.09 +- 0.06 |
| boxer-puncher / club | 9.35 +- 0.38 | 10.88 +- 0.37 | 10.91 +- 0.35 | 11.51 +- 0.35 | STAY | - | +1.52 +- 0.14 (clearly worse) |
| boxer-puncher / champ | 9.47 +- 0.33 | 12.11 +- 0.26 | 11.54 +- 0.30 | 12.50 +- 0.28 | STAY | - | +2.64 +- 0.27 (clearly worse) |
| boxer-puncher / pro | 7.16 +- 0.29 | 7.33 +- 0.27 | 8.84 +- 0.27 | 7.45 +- 0.23 | STAY | CUT, DOWN | +0.16 +- 0.11 |

Best counts (the lowest place, round 2's rule): { "STAY": 10, "CUT": 2, "UP": 2, "DOWN": 1 }. The most any one choice wins: 10 of 15 cells (bar: 9 or fewer).
Clear bests (no other choice inside the noise): { "STAY": 9, "CUT": 0, "UP": 1, "DOWN": 0 } - 10 of 15 cells are clear (bar: 6 or more).
Best or tied for best: { "STAY": 14, "CUT": 5, "UP": 2, "DOWN": 4 }. CUT harder is in the leading group of 5 of the 15 cells where it is a choice (bar: 9 or fewer).
Amateur cells where CUT harder is clearly worse than STAY (two standard errors, seed by seed): 8 (puncher / club, puncher / champ, volume / club, volume / champ, big chin / club, big chin / champ, boxer-puncher / club, boxer-puncher / champ) (bar: 1 or more).

Moving up, all cells pooled: knockout share of the wins 27 % staying, 23 % up (x 0.86); stopped 6.1 in 100 bouts staying, 7.9 up (x 1.29).
John E (ESTIMATE, half his biased count, for TWO classes up): knockout share x 0.88, stopped x 1.5.

## 4. Does each lever move the result? (lever off, 3 seeds, against the same seeds with it on)

frame off = the opponent's height and reach erased, as in round 4; field off = the field's cut costs it nothing, as in round 4 (it still rings as heavy).

| Lever off | Mean change in win share | Biggest change in ladder place | Cells whose best choice changes | Moves it |
| :--- | ---: | ---: | ---: | :--- |
| drain | 2.3 points | 2.33 rungs | 6 of 15 | yes |
| size | 3.9 points | 6.17 rungs | 6 of 15 | yes |
| diet | 1.0 points | 1.83 rungs | 3 of 15 | yes |
| miss | 1.4 points | 2.00 rungs | 0 of 15 | yes |
| rank | 1.9 points | 1.33 rungs | 1 of 15 | yes |
| refuse | 0.8 points | 1.17 rungs | 0 of 15 | yes |
| frame | 0.8 points | 1.00 rungs | 1 of 15 | yes |
| field | 2.3 points | 2.00 rungs | 4 of 15 | yes |

Size as it lands on the ladder (lever on against off, over the size gaps of the cell choices): 1.3 wins in 100 per 1 % of ring weight.
The fit of step 0 aims at John's 3.0 with the opponents held still; on the ladder a winner meets better men, which shrinks it.

## 5. Item 1: the same kilos by DIET, by WATER, MIXED or carried UP (16 seeds a cell, 12 bout slots)

Every boxer is put 3, 4, 5 and 6 % over his own class line (his Data walking weight is not used here) and the same kilos come off four ways. In all four the first 2 % is water (free).
DIET = a Lean diet takes what it can of the rest (up to 2.5 % of body, at 0.7 % a week, training gain x (1 - 0.12 per 1 % held)), water the remainder. WATER = no diet (Hold), all of it by water in fight week.
MIX = half the rest by diet, half by water. UP = nothing comes off: the class above (one rung, a smaller man there, a shorter one), or at a club show his own class when he is still inside the gap of a class opponent (WeighGap: 2.5 kg to 65, 5 kg over).
Nobody is asked here (no refusal): the table prices the kilos, not his answer. Two missed scales still move him up.

### 5.1 What each policy is (the 60 kg man's sums; the shares are the same for every boxer, only the club show's gap differs by class)

| Scale | Over | Policy | Class | Diet | Weeks | Training kept | Water | Stamina, day 1 | Stamina, day 3 | Scale missed (Discipline 34 / 80) | Size gap |
| :--- | ---: | :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| club | +3 % | DIET | 60 | 0.9 % | 1.3 | 89 % | 2.0 % | -0.0 % | - | 1 / 1 in 100 | +1.5 % |
| club | +3 % | WATER | 60 | 0.0 % | 0.0 | 100 % | 2.9 % | -3.7 % | - | 1 / 1 in 100 | +1.5 % |
| club | +3 % | MIX | 60 | 0.5 % | 0.7 | 95 % | 2.5 % | -1.8 % | - | 1 / 1 in 100 | +1.5 % |
| club | +3 % | UP | 60 (carried) | 0.0 % | 0.0 | 100 % | 0.0 % | -0.0 % | - | 0 / 0 in 100 | +4.0 % |
| club | +4 % | DIET | 60 | 1.8 % | 2.6 | 78 % | 2.0 % | -0.0 % | - | 1 / 1 in 100 | +1.5 % |
| club | +4 % | WATER | 60 | 0.0 % | 0.0 | 100 % | 3.8 % | -7.4 % | - | 21 / 13 in 100 | +1.5 % |
| club | +4 % | MIX | 60 | 0.9 % | 1.3 | 89 % | 2.9 % | -3.7 % | - | 1 / 1 in 100 | +1.5 % |
| club | +4 % | UP | 65 | 0.0 % | 0.0 | 100 % | 0.0 % | -0.0 % | - | 0 / 0 in 100 | -3.0 % |
| club | +5 % | DIET | 60 | 2.5 % | 3.6 | 70 % | 2.3 % | -1.0 % | - | 1 / 1 in 100 | +1.5 % |
| club | +5 % | WATER | 60 | 0.0 % | 0.0 | 100 % | 4.8 % | -11.0 % | - | 42 / 26 in 100 | +1.5 % |
| club | +5 % | MIX | 60 | 1.4 % | 2.0 | 83 % | 3.4 % | -5.5 % | - | 10 / 6 in 100 | +1.5 % |
| club | +5 % | UP | 65 | 0.0 % | 0.0 | 100 % | 0.0 % | -0.0 % | - | 0 / 0 in 100 | -2.1 % |
| club | +6 % | DIET | 60 | 2.5 % | 3.6 | 70 % | 3.2 % | -4.6 % | - | 5 / 3 in 100 | +1.5 % |
| club | +6 % | WATER | 60 | 0.0 % | 0.0 | 100 % | 5.7 % | -14.6 % | - | 100 / 100 in 100 | +1.5 % |
| club | +6 % | MIX | 60 | 1.8 % | 2.6 | 78 % | 3.8 % | -7.3 % | - | 20 / 13 in 100 | +1.5 % |
| club | +6 % | UP | 65 | 0.0 % | 0.0 | 100 % | 0.0 % | -0.0 % | - | 0 / 0 in 100 | -1.2 % |
| champ | +3 % | DIET | 60 | 0.9 % | 1.3 | 89 % | 2.0 % | -0.0 % | -0.0 % | 1 / 1 in 100 | +0.0 % |
| champ | +3 % | WATER | 60 | 0.0 % | 0.0 | 100 % | 2.9 % | -3.7 % | -8.4 % | 1 / 1 in 100 | +0.0 % |
| champ | +3 % | MIX | 60 | 0.5 % | 0.7 | 95 % | 2.5 % | -1.8 % | -4.2 % | 1 / 1 in 100 | +0.0 % |
| champ | +3 % | UP | 65 | 0.0 % | 0.0 | 100 % | 0.0 % | -0.0 % | -0.0 % | 0 / 0 in 100 | -6.7 % |
| champ | +4 % | DIET | 60 | 1.8 % | 2.6 | 78 % | 2.0 % | -0.0 % | -0.0 % | 1 / 1 in 100 | +0.0 % |
| champ | +4 % | WATER | 60 | 0.0 % | 0.0 | 100 % | 3.8 % | -7.4 % | -16.9 % | 21 / 13 in 100 | +0.0 % |
| champ | +4 % | MIX | 60 | 0.9 % | 1.3 | 89 % | 2.9 % | -3.7 % | -8.4 % | 1 / 1 in 100 | +0.0 % |
| champ | +4 % | UP | 65 | 0.0 % | 0.0 | 100 % | 0.0 % | -0.0 % | -0.0 % | 0 / 0 in 100 | -5.8 % |
| champ | +5 % | DIET | 60 | 2.5 % | 3.6 | 70 % | 2.3 % | -1.0 % | -2.4 % | 1 / 1 in 100 | +0.0 % |
| champ | +5 % | WATER | 60 | 0.0 % | 0.0 | 100 % | 4.8 % | -11.0 % | -25.3 % | 42 / 26 in 100 | +0.0 % |
| champ | +5 % | MIX | 60 | 1.4 % | 2.0 | 83 % | 3.4 % | -5.5 % | -12.6 % | 10 / 6 in 100 | +0.0 % |
| champ | +5 % | UP | 65 | 0.0 % | 0.0 | 100 % | 0.0 % | -0.0 % | -0.0 % | 0 / 0 in 100 | -4.9 % |
| champ | +6 % | DIET | 60 | 2.5 % | 3.6 | 70 % | 3.2 % | -4.6 % | -10.6 % | 5 / 3 in 100 | +0.0 % |
| champ | +6 % | WATER | 60 | 0.0 % | 0.0 | 100 % | 5.7 % | -14.6 % | -33.5 % | 100 / 100 in 100 | +0.0 % |
| champ | +6 % | MIX | 60 | 1.8 % | 2.6 | 78 % | 3.8 % | -7.3 % | -16.7 % | 20 / 13 in 100 | +0.0 % |
| champ | +6 % | UP | 65 | 0.0 % | 0.0 | 100 % | 0.0 % | -0.0 % | -0.0 % | 0 / 0 in 100 | -4.0 % |
| pro | +3 % | DIET | 60 | 0.9 % | 1.3 | 89 % | 2.0 % | -0.0 % | - | 2 / 2 in 100 | -5.0 % |
| pro | +3 % | WATER | 60 | 0.0 % | 0.0 | 100 % | 2.9 % | -1.4 % | - | 2 / 2 in 100 | -4.2 % |
| pro | +3 % | MIX | 60 | 0.5 % | 0.7 | 95 % | 2.5 % | -0.7 % | - | 2 / 2 in 100 | -4.6 % |
| pro | +3 % | UP | 65 | 0.0 % | 0.0 | 100 % | 0.0 % | -0.0 % | - | 0 / 0 in 100 | -11.3 % |
| pro | +4 % | DIET | 60 | 1.8 % | 2.6 | 78 % | 2.0 % | -0.0 % | - | 2 / 2 in 100 | -5.0 % |
| pro | +4 % | WATER | 60 | 0.0 % | 0.0 | 100 % | 3.8 % | -2.8 % | - | 2 / 2 in 100 | -3.4 % |
| pro | +4 % | MIX | 60 | 0.9 % | 1.3 | 89 % | 2.9 % | -1.4 % | - | 2 / 2 in 100 | -4.2 % |
| pro | +4 % | UP | 65 | 0.0 % | 0.0 | 100 % | 0.0 % | -0.0 % | - | 0 / 0 in 100 | -10.4 % |
| pro | +5 % | DIET | 60 | 2.5 % | 3.6 | 70 % | 2.3 % | -0.4 % | - | 2 / 2 in 100 | -4.7 % |
| pro | +5 % | WATER | 60 | 0.0 % | 0.0 | 100 % | 4.8 % | -4.1 % | - | 2 / 2 in 100 | -2.5 % |
| pro | +5 % | MIX | 60 | 1.4 % | 2.0 | 83 % | 3.4 % | -2.1 % | - | 2 / 2 in 100 | -3.7 % |
| pro | +5 % | UP | 65 | 0.0 % | 0.0 | 100 % | 0.0 % | -0.0 % | - | 0 / 0 in 100 | -9.6 % |
| pro | +6 % | DIET | 60 | 2.5 % | 3.6 | 70 % | 3.2 % | -1.7 % | - | 2 / 2 in 100 | -3.9 % |
| pro | +6 % | WATER | 60 | 0.0 % | 0.0 | 100 % | 5.7 % | -6.5 % | - | 2 / 2 in 100 | -1.7 % |
| pro | +6 % | MIX | 60 | 1.8 % | 2.6 | 78 % | 3.8 % | -2.7 % | - | 2 / 2 in 100 | -3.3 % |
| pro | +6 % | UP | 65 | 0.0 % | 0.0 | 100 % | 0.0 % | -0.0 % | - | 0 / 0 in 100 | -8.7 % |

### 5.2 club show: weighed an hour before, the gap rule, 3 rounds: ladder place at the end (lower is better; +- one standard error)

| Boxer (Stamina, Discipline) | Over | DIET | WATER | MIX | UP | Best | CUT a rule? |
| :--- | ---: | ---: | ---: | ---: | ---: | :--- | :--- |
| puncher (60, 34) | +3 % | 8.47 +- 0.79 | 9.50 +- 0.76 | 8.63 +- 0.77 | 13.59 +- 0.90 | DIET (= MIX) | UP = the class above |
| puncher (60, 34) | +4 % | 8.50 +- 0.79 | 10.00 +- 0.78 | 9.66 +- 0.75 | 12.66 +- 1.03 | DIET | UP = the class above |
| puncher (60, 34) | +5 % | 9.00 +- 0.82 | 11.22 +- 0.56 | 10.13 +- 0.76 | 12.66 +- 1.03 | DIET | UP = the class above |
| puncher (60, 34) | +6 % | 10.22 +- 0.72 | 11.66 +- 0.57 | 10.69 +- 0.63 | 12.47 +- 0.90 | DIET (= MIX) | UP = the class above |
| volume (65, 80) | +3 % | 10.66 +- 0.54 | 11.16 +- 0.51 | 10.88 +- 0.50 | 8.88 +- 0.57 | UP | UP = carried, own class |
| volume (65, 80) | +4 % | 10.75 +- 0.54 | 11.78 +- 0.53 | 11.41 +- 0.49 | 8.28 +- 0.59 | UP | UP = carried, own class |
| volume (65, 80) | +5 % | 10.94 +- 0.50 | 12.28 +- 0.56 | 11.78 +- 0.49 | 7.59 +- 0.61 | UP | UP = carried, own class |
| volume (65, 80) | +6 % | 11.94 +- 0.54 | 12.38 +- 0.61 | 11.91 +- 0.50 | 7.31 +- 0.61 | UP | UP = carried, own class |
| big chin (64, 62) | +3 % | 10.38 +- 0.57 | 10.84 +- 0.62 | 10.63 +- 0.57 | 8.59 +- 0.58 | UP | UP = carried, own class |
| big chin (64, 62) | +4 % | 10.50 +- 0.53 | 11.88 +- 0.64 | 10.97 +- 0.64 | 8.44 +- 0.54 | UP | UP = carried, own class |
| big chin (64, 62) | +5 % | 10.66 +- 0.56 | 12.41 +- 0.55 | 11.88 +- 0.64 | 7.81 +- 0.64 | UP | UP = carried, own class |
| big chin (64, 62) | +6 % | 11.94 +- 0.62 | 13.00 +- 0.60 | 12.41 +- 0.57 | 11.97 +- 0.50 | UP (= DIET, MIX) | UP = the class above |
| drained cutter (58, 64) | +3 % | 9.38 +- 0.62 | 9.50 +- 0.62 | 9.38 +- 0.63 | 7.88 +- 0.60 | UP | UP = carried, own class |
| drained cutter (58, 64) | +4 % | 9.66 +- 0.63 | 9.84 +- 0.65 | 9.78 +- 0.58 | 10.88 +- 0.54 | DIET (= WATER, MIX) | UP = the class above |
| drained cutter (58, 64) | +5 % | 9.78 +- 0.58 | 10.47 +- 0.64 | 9.88 +- 0.59 | 10.56 +- 0.57 | DIET (= MIX) | UP = the class above |
| drained cutter (58, 64) | +6 % | 10.00 +- 0.54 | 10.06 +- 0.67 | 10.22 +- 0.61 | 9.94 +- 0.60 | UP (= DIET, WATER, MIX) | UP = the class above |
| boxer-puncher (57, 60) | +3 % | 9.47 +- 0.69 | 9.69 +- 0.62 | 9.47 +- 0.69 | 8.78 +- 0.69 | UP (= DIET, MIX) | UP = carried, own class |
| boxer-puncher (57, 60) | +4 % | 9.72 +- 0.67 | 10.34 +- 0.59 | 9.81 +- 0.66 | 11.13 +- 0.56 | DIET (= MIX) | UP = the class above |
| boxer-puncher (57, 60) | +5 % | 9.84 +- 0.66 | 10.84 +- 0.74 | 10.44 +- 0.63 | 10.75 +- 0.61 | DIET | UP = the class above |
| boxer-puncher (57, 60) | +6 % | 10.56 +- 0.68 | 10.47 +- 0.63 | 10.72 +- 0.71 | 10.44 +- 0.70 | UP (= DIET, WATER, MIX) | UP = the class above |

Best counts: { "DIET": 8, "WATER": 0, "MIX": 0, "UP": 12 }.
The best policy changes with how far over he is (same boxer): 2 pairs - drained cutter +3 % UP -> +4 % DIET; drained cutter +3 % UP -> +5 % DIET.
The best policy changes with the boxer (same % over): 16 pairs - +3 %: puncher DIET, volume UP; +3 %: puncher DIET, big chin UP; +3 %: puncher DIET, drained cutter UP; +4 %: puncher DIET, volume UP; +4 %: puncher DIET, big chin UP; +4 %: volume UP, drained cutter DIET; +4 %: volume UP, boxer-puncher DIET; +4 %: big chin UP, drained cutter DIET ....
Of those boxer pairs, 15 sit on opposite sides of Stamina 60 (the fade line: big chin 64 and volume 65 over it; puncher 60, cutter 58 and boxer-puncher 57 not), and 4 are the Discipline 34 against the Discipline 80 boxer.
Bar on this scale (both kinds of change): MET.

### 5.3 championship: weighed three hours before on each of three boxing days, 3 rounds: ladder place at the end (lower is better; +- one standard error)

| Boxer (Stamina, Discipline) | Over | DIET | WATER | MIX | UP | Best | CUT a rule? |
| :--- | ---: | ---: | ---: | ---: | ---: | :--- | :--- |
| puncher (60, 34) | +3 % | 9.47 +- 0.57 | 10.25 +- 0.64 | 9.88 +- 0.58 | 12.78 +- 0.50 | DIET (= MIX) | UP = the class above |
| puncher (60, 34) | +4 % | 10.03 +- 0.66 | 12.47 +- 0.41 | 10.69 +- 0.49 | 12.72 +- 0.58 | DIET | UP = the class above |
| puncher (60, 34) | +5 % | 10.38 +- 0.58 | 13.56 +- 0.32 | 11.31 +- 0.62 | 12.91 +- 0.45 | DIET | UP = the class above |
| puncher (60, 34) | +6 % | 11.56 +- 0.45 | 12.69 +- 0.50 | 12.31 +- 0.33 | 12.38 +- 0.58 | DIET (= WATER, UP) | UP = the class above |
| volume (65, 80) | +3 % | 10.78 +- 0.50 | 11.50 +- 0.40 | 11.38 +- 0.44 | 13.50 +- 0.34 | DIET | UP = the class above |
| volume (65, 80) | +4 % | 11.63 +- 0.32 | 12.66 +- 0.30 | 11.94 +- 0.34 | 13.31 +- 0.38 | DIET (= MIX) | UP = the class above |
| volume (65, 80) | +5 % | 11.72 +- 0.40 | 13.13 +- 0.25 | 12.13 +- 0.30 | 13.41 +- 0.32 | DIET (= MIX) | UP = the class above |
| volume (65, 80) | +6 % | 11.97 +- 0.46 | 13.22 +- 0.37 | 12.81 +- 0.34 | 12.88 +- 0.40 | DIET | UP = the class above |
| big chin (64, 62) | +3 % | 11.09 +- 0.43 | 12.00 +- 0.43 | 11.53 +- 0.45 | 12.44 +- 0.39 | DIET (= MIX) | UP = the class above |
| big chin (64, 62) | +4 % | 11.16 +- 0.42 | 12.72 +- 0.37 | 12.09 +- 0.36 | 11.88 +- 0.42 | DIET (= UP) | UP = the class above |
| big chin (64, 62) | +5 % | 11.38 +- 0.38 | 12.66 +- 0.32 | 12.22 +- 0.33 | 11.66 +- 0.42 | DIET (= UP) | UP = the class above |
| big chin (64, 62) | +6 % | 12.50 +- 0.31 | 11.94 +- 0.39 | 12.78 +- 0.25 | 11.28 +- 0.45 | UP (= WATER) | UP = the class above |
| drained cutter (58, 64) | +3 % | 9.31 +- 0.52 | 9.94 +- 0.52 | 9.50 +- 0.55 | 11.72 +- 0.40 | DIET (= MIX) | UP = the class above |
| drained cutter (58, 64) | +4 % | 9.38 +- 0.55 | 11.00 +- 0.52 | 9.69 +- 0.58 | 11.22 +- 0.49 | DIET (= MIX) | UP = the class above |
| drained cutter (58, 64) | +5 % | 9.50 +- 0.57 | 12.00 +- 0.35 | 10.84 +- 0.47 | 11.06 +- 0.48 | DIET | UP = the class above |
| drained cutter (58, 64) | +6 % | 10.19 +- 0.55 | 12.03 +- 0.49 | 11.00 +- 0.56 | 10.72 +- 0.58 | DIET (= UP) | UP = the class above |
| boxer-puncher (57, 60) | +3 % | 10.00 +- 0.63 | 10.16 +- 0.62 | 10.13 +- 0.61 | 12.06 +- 0.47 | DIET (= WATER, MIX) | UP = the class above |
| boxer-puncher (57, 60) | +4 % | 10.06 +- 0.63 | 11.78 +- 0.39 | 10.50 +- 0.58 | 11.69 +- 0.51 | DIET (= MIX) | UP = the class above |
| boxer-puncher (57, 60) | +5 % | 10.50 +- 0.59 | 12.75 +- 0.39 | 11.38 +- 0.45 | 11.75 +- 0.51 | DIET | UP = the class above |
| boxer-puncher (57, 60) | +6 % | 10.59 +- 0.61 | 11.97 +- 0.51 | 11.31 +- 0.47 | 11.44 +- 0.54 | DIET (= UP) | UP = the class above |

Best counts: { "DIET": 19, "WATER": 0, "MIX": 0, "UP": 1 }.
The best policy changes with how far over he is (same boxer): 1 pairs - big chin +3 % DIET -> +6 % UP.
The best policy changes with the boxer (same % over): 1 pairs - +6 %: volume DIET, big chin UP.
Of those boxer pairs, 0 sit on opposite sides of Stamina 60 (the fade line: big chin 64 and volume 65 over it; puncher 60, cutter 58 and boxer-puncher 57 not), and 0 are the Discipline 34 against the Discipline 80 boxer.
Bar on this scale (both kinds of change): MET.

### 5.4 pro: weighed the day before, 6 rounds: ladder place at the end (lower is better; +- one standard error)

| Boxer (Stamina, Discipline) | Over | DIET | WATER | MIX | UP | Best | CUT a rule? |
| :--- | ---: | ---: | ---: | ---: | ---: | :--- | :--- |
| puncher (60, 34) | +3 % | 9.22 +- 0.70 | 8.97 +- 0.66 | 9.19 +- 0.62 | 13.16 +- 1.03 | WATER (= DIET, MIX) | UP = the class above |
| puncher (60, 34) | +4 % | 9.09 +- 0.58 | 8.47 +- 0.51 | 9.13 +- 0.64 | 13.19 +- 0.94 | WATER (= DIET, MIX) | UP = the class above |
| puncher (60, 34) | +5 % | 9.47 +- 0.81 | 8.09 +- 0.46 | 8.56 +- 0.59 | 12.97 +- 0.99 | WATER (= MIX) | UP = the class above |
| puncher (60, 34) | +6 % | 8.53 +- 0.62 | 8.22 +- 0.51 | 8.66 +- 0.52 | 11.56 +- 0.96 | WATER (= DIET, MIX) | UP = the class above |
| volume (65, 80) | +3 % | 8.56 +- 0.47 | 8.19 +- 0.38 | 8.41 +- 0.40 | 9.44 +- 0.41 | WATER (= DIET, MIX) | UP = the class above |
| volume (65, 80) | +4 % | 8.38 +- 0.52 | 7.47 +- 0.49 | 7.88 +- 0.45 | 9.38 +- 0.41 | WATER (= MIX) | UP = the class above |
| volume (65, 80) | +5 % | 8.97 +- 0.47 | 7.56 +- 0.45 | 8.00 +- 0.55 | 9.41 +- 0.44 | WATER (= MIX) | UP = the class above |
| volume (65, 80) | +6 % | 8.06 +- 0.53 | 6.63 +- 0.44 | 8.25 +- 0.48 | 9.16 +- 0.51 | WATER | UP = the class above |
| big chin (64, 62) | +3 % | 7.91 +- 0.50 | 8.03 +- 0.46 | 7.72 +- 0.49 | 9.75 +- 0.55 | MIX (= DIET, WATER) | UP = the class above |
| big chin (64, 62) | +4 % | 8.25 +- 0.34 | 8.75 +- 0.52 | 8.47 +- 0.50 | 9.59 +- 0.39 | DIET (= WATER, MIX) | UP = the class above |
| big chin (64, 62) | +5 % | 8.03 +- 0.60 | 7.84 +- 0.72 | 8.09 +- 0.60 | 9.41 +- 0.55 | WATER (= DIET, MIX) | UP = the class above |
| big chin (64, 62) | +6 % | 8.91 +- 0.56 | 8.75 +- 0.63 | 9.28 +- 0.52 | 9.22 +- 0.49 | WATER (= DIET, MIX, UP) | UP = the class above |
| drained cutter (58, 64) | +3 % | 6.47 +- 0.49 | 6.22 +- 0.46 | 6.34 +- 0.43 | 9.00 +- 0.32 | WATER (= DIET, MIX) | UP = the class above |
| drained cutter (58, 64) | +4 % | 6.72 +- 0.43 | 6.00 +- 0.46 | 6.44 +- 0.48 | 8.47 +- 0.28 | WATER | UP = the class above |
| drained cutter (58, 64) | +5 % | 6.56 +- 0.39 | 5.34 +- 0.46 | 6.28 +- 0.42 | 8.25 +- 0.37 | WATER | UP = the class above |
| drained cutter (58, 64) | +6 % | 6.56 +- 0.47 | 5.91 +- 0.55 | 6.38 +- 0.51 | 8.03 +- 0.29 | WATER | UP = the class above |
| boxer-puncher (57, 60) | +3 % | 7.06 +- 0.44 | 6.63 +- 0.53 | 6.88 +- 0.49 | 8.97 +- 0.43 | WATER | UP = the class above |
| boxer-puncher (57, 60) | +4 % | 7.13 +- 0.43 | 6.72 +- 0.39 | 6.97 +- 0.44 | 8.97 +- 0.36 | WATER | UP = the class above |
| boxer-puncher (57, 60) | +5 % | 6.91 +- 0.47 | 6.47 +- 0.54 | 6.78 +- 0.45 | 8.22 +- 0.39 | WATER (= DIET, MIX) | UP = the class above |
| boxer-puncher (57, 60) | +6 % | 7.13 +- 0.38 | 6.34 +- 0.38 | 6.78 +- 0.42 | 8.19 +- 0.45 | WATER | UP = the class above |

Best counts: { "DIET": 1, "WATER": 18, "MIX": 1, "UP": 0 }.
The best policy changes with how far over he is (same boxer): 0 pairs.
The best policy changes with the boxer (same % over): 0 pairs.
Of those boxer pairs, 0 sit on opposite sides of Stamina 60 (the fade line: big chin 64 and volume 65 over it; puncher 60, cutter 58 and boxer-puncher 57 not), and 0 are the Discipline 34 against the Discipline 80 boxer.
Bar on this scale (both kinds of change): not met.

Item 1's bar (inside ONE scale the best policy changes with how far over he is AND with the boxer): **MET** (club: both changes; champ: both changes; pro: not both changes).

## 6. Item 2: frame back on

Every opponent above has a height and a reach drawn from the class boxed at (AttrGen.body: 172 cm at 60 kg, 1 cm a kg, women 8 cm shorter, reach = height + 3, each +- 4), from that division's own sheet.
So moving DOWN meets shorter men with shorter arms, moving UP taller ones; the game reads reach on the long jab (Duels.REACH_PER_CM) and height inside (Duels.HEIGHT_PER_CM). The lever table (section 4, frame) is the control arm.

| Boxer | Style | Reach against his own class | against the class below | against the class above | DOWN: place behind the cell's best (club / champ / pro) | UP: place behind the best (club / champ / pro) |
| :--- | :--- | ---: | ---: | ---: | :--- | :--- |
| puncher | Slugger | -3 cm | +2 cm | -8 cm | +5.86 / +3.70 / +2.20 | +5.60 / +3.60 / +3.86 |
| volume | Pressure fighter | -3 cm | +2 cm | -8 cm | +1.98 / +2.56 / +0.38 (tied) | +1.61 / +2.53 / +1.24 |
| big chin | Pressure fighter | +4 cm | +9 cm | -2 cm | +2.19 / +1.94 / +2.18 | +1.04 / +1.06 / +1.93 |
| drained cutter | Out-boxer | +4 cm | +7 cm | +1 cm | +0.63 (tied) / +2.95 / +0.00 (best) | +0.00 (best) / +0.00 (best) / +0.96 |
| boxer-puncher | Boxer-puncher | +2 cm | +7 cm | -3 cm | +2.16 / +3.03 / +0.29 (tied) | +1.56 / +2.06 / +1.68 |

The boxers who work off the jab (Out-boxer, Boxer-puncher): drained cutter, boxer-puncher. Moving DOWN is best or tied for them in: drained cutter / club, drained cutter / pro, boxer-puncher / pro.
The chin with no reach (Chin 64 or more, the least reach against the class): volume (-3 cm). Moving UP is best or tied in: no cell.
Item 2's bar (DOWN best or tied for a jabber, UP for the chin with no reach): **NOT MET**.

## 7. Item 3: the field cuts too

Each night's opponent took off one of the scale's cuts (drawn evenly) and pays John's table for it: the cost comes off his rating as the mean of the six stats, except that a cut worth 15 % of Stamina or more
makes him a fader on the game's own word ("Fades": AttrGen takes 14 off his Stamina, he tires from round 3, BoutRules.OPP_FADE), so a hard cut shows late and not in round 1. On a championship's later days the cost carries, for him as for us.

| Scale | He took off | Rings over the line | Stamina | Power | Reading | Off his rating | Fades late |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | :--- |
| club | 0 % | -1.0 % | -0.0 % | -0.0 % | -0.0 % | 0.00 points | no |
| champ | 2 % | +1.9 % | -0.0 % | -0.0 % | -0.0 % | 0.00 points | no |
| champ, day 3 | 2 % | +1.9 % | -0.0 % | -0.0 % | -0.0 % | 0.00 points | no |
| champ | 3 % | +1.9 % | -4.0 % | -1.5 % | -1.0 % | 0.75 points | no |
| champ, day 3 | 3 % | +1.9 % | -9.2 % | -3.4 % | -2.3 % | 1.72 points | no |
| champ | 4 % | +1.9 % | -8.0 % | -3.0 % | -2.0 % | 1.50 points | no |
| champ, day 3 | 4 % | +1.9 % | -18.3 % | -6.9 % | -4.6 % | 1.60 points | yes |
| pro | 6 % | +5.4 % | -7.5 % | -1.0 % | -2.0 % | 1.25 points | no |
| pro | 7 % | +6.3 % | -10.5 % | -2.0 % | -2.5 % | 1.75 points | no |
| pro | 8 % | +7.2 % | -13.5 % | -3.0 % | -3.0 % | 2.25 points | no |
| pro | 9 % | +8.1 % | -16.5 % | -4.0 % | -3.5 % | 1.10 points | yes |
| pro | 10 % | +9.0 % | -19.5 % | -5.0 % | -4.0 % | 1.30 points | yes |

The refit of the field is in section 0. On the tape the cut is a RANGE (Knowledge): the read is his true cut +- 1.5 %. The plan can use it: when the read says 9 % or more,
the corner calls "Let your hands go" from round 3 (the best call against a tiring man, Exchanges.MODES) instead of its own pick. Three arms on the pro scale, STAY, 20 seeds, the same nights:
blind (the game's corner, as everywhere above), the ranged read, and an exact read. Hard cutters = the nights he took off 9 or 10 % (two in five).

| Boxer | Arm | Win, all bouts | Win against the hard cutters | Late rounds won against the hard cutters | against the rest | Place |
| :--- | :--- | ---: | ---: | ---: | ---: | ---: |
| puncher | blind | 41 % | 31 % (95 bouts) | 21 % | 31 % | 9.00 +- 0.56 |
| puncher | range | 38 % | 22 % (95 bouts) | 11 % | 32 % | 9.82 +- 0.45 |
| puncher | exact | 36 % | 20 % (95 bouts) | 9 % | 32 % | 10.18 +- 0.52 |
| volume | blind | 44 % | 35 % (111 bouts) | 42 % | 42 % | 8.28 +- 0.46 |
| volume | range | 40 % | 29 % (111 bouts) | 34 % | 41 % | 9.18 +- 0.42 |
| volume | exact | 39 % | 23 % (111 bouts) | 25 % | 45 % | 9.32 +- 0.39 |
| big chin | blind | 48 % | 42 % (105 bouts) | 41 % | 41 % | 7.80 +- 0.43 |
| big chin | range | 41 % | 25 % (105 bouts) | 21 % | 43 % | 9.28 +- 0.47 |
| big chin | exact | 40 % | 20 % (105 bouts) | 18 % | 43 % | 9.50 +- 0.46 |
| drained cutter | blind | 53 % | 47 % (87 bouts) | 66 % | 72 % | 6.72 +- 0.38 |
| drained cutter | range | 50 % | 33 % (87 bouts) | 48 % | 72 % | 7.47 +- 0.47 |
| drained cutter | exact | 49 % | 25 % (87 bouts) | 36 % | 75 % | 7.70 +- 0.46 |
| boxer-puncher | blind | 51 % | 49 % (93 bouts) | 60 % | 61 % | 7.25 +- 0.42 |
| boxer-puncher | range | 48 % | 41 % (93 bouts) | 44 % | 60 % | 7.90 +- 0.33 |
| boxer-puncher | exact | 49 % | 37 % (93 bouts) | 38 % | 62 % | 7.90 +- 0.36 |

All five, blind: win 47.1 %; against the hard cutters 40.5 % (491 bouts); late rounds won against them 45.5 %, against the rest 50.1 %; place against blind +0.00 +- 0.00 rungs.
All five, range: win 43.4 %; against the hard cutters 29.7 % (491 bouts); late rounds won against them 30.8 %, against the rest 50.3 %; place against blind +0.92 +- 0.13 rungs.
All five, exact: win 42.6 %; against the hard cutters 24.8 % (491 bouts); late rounds won against them 24.3 %, against the rest 52.0 %; place against blind +1.11 +- 0.15 rungs.

Read it as: the first number pair says whether the field's cut has teeth (a hard cutter should be easier to beat late than the rest); the place against blind says whether reading it off the tape is worth anything to the plan.

## 8. Item 4: the design's three scales, side by side

| Scale | A missed scale is | Best choice, cell by cell (boxer order: puncher, volume, big chin, cutter, boxer-puncher) | Scales missed a run (STAY / CUT) | Bouts lost to the scale a run (STAY / CUT) | Bouts boxed a run (STAY) |
| :--- | :--- | :--- | ---: | ---: | ---: |
| club show: weighed an hour before, the gap rule, 3 rounds | the gap rule: on if still inside the gap, else re-matched 1 in 3, else off and $300; nothing on the record | STAY; STAY; STAY; UP (= STAY, CUT, DOWN); STAY | 0.47 / 2.38 | 0.00 / 0.00 | 12.0 |
| championship: weighed three hours before on each of three boxing days, 3 rounds | a walkover loss and out of the draw; two move him up | STAY; STAY; STAY; UP; STAY | 0.22 / 1.02 | 0.22 / 1.02 | 6.7 |
| pro: weighed the day before, 6 rounds | a fine, he boxes on; two move him up | CUT (= STAY); CUT (= STAY, DOWN); STAY; DOWN (= STAY, CUT); STAY (= CUT, DOWN) | 0.23 / 0.23 | 0.00 / 0.00 | 12.0 |

The championship's second and third days are where a cut past the free 2 % is paid again: section 5.1 prints the Stamina cost on day 1 and on day 3 (x 2.29 by the third day at a carry of 0.74 a day).

## 9. The result

85774 bouts played in 2145 s.

Round 4's bars: DO NOT hold (levers all move; top choice best in 10 of 15 cells; 10 clear of the noise; CUT in the leading group of 5 of 15; CUT clearly worse than STAY in 8 amateur cells).
Item 1 (the same kilos by diet, water, mix or up): holds. Item 2 (frame): DOES NOT hold.

RESULT: tools/weight2_probe.gd -> FAIL (broke: round 4's bars, item 2 (frame))
