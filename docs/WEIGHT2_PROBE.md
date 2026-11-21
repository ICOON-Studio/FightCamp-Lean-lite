# WEIGHT2 probe - weight as one mechanic, measured on a greybox before any build (S535 WEIGHTMOVE1)

Run: python ops/Tools/godot_slot.py run --who weight2 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/weight2_probe.gd -- seeds=20 bouts=6 abl=5

What is real: the five boxers (Data.PROSPECTS), their opponents (Data's region sheets), and every bout (BoutNight.play_out,
the game's fight night). What is scratch: the weight model below. Every number in it is an ESTIMATE waiting for John.
Each run = 6 bouts on a 12-rung ladder; 20 seeds a cell; every choice of a seed fights the same nights (same dice).

Model: { "bulk_kg": 2.0, "up_fill_kg": 1.0, "diet_hold": 0.025, "diet_hold_down": 0.05, "kg_a_week": 0.45, "free_weeks": 2.0, "size_power": 1.2, "size_chin": 1.0, "size_speed": 0.4, "size_cap": 8.0, "drain_cond": 2.0, "drain_chin": 1.5, "drain_speed": 0.8, "drain_power": 0.5, "drain_tank": 3.0, "tank_max": 25.0, "drain_knee": 3.0, "grow": 0.33, "diet_cost": 0.12, "grow_min": 0.4, "miss_slope": 0.2, "miss_max": 0.7, "rung0": 8.0, "rung_move": 10.0, "rung_gap": 0.6, "field_grow": 0.15 }

## 1. Who they are

| Boxer (shape) | Class | Walks | Power | Speed | Stamina (cond.) | Chin | Discipline |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Samira Khan (puncher) | 65 kg | 65.9 kg | 66 | 57 | 60 | 63 | 34 |
| Josh Harper (volume) | 70 kg | 71.4 kg | 63 | 56 | 65 | 64 | 80 |
| Tess Reilly (big chin) | 75 kg | 76.1 kg | 62 | 55 | 64 | 67 | 62 |
| Kira Mensah (drained cutter) | 57 kg | 60.8 kg | 54 | 67 | 58 | 52 | 64 |
| Danny Osei (boxer-puncher) | 60 kg | 61.1 kg | 59 | 62 | 57 | 62 | 60 |

## 2. The cell table

Win, stopped (won inside / lost inside), late = last third of the rounds won, weeks = weeks lost to the diet and to missed scales,
missed = scales missed a run, place = ladder rung at the end (1 is the top; every boxer starts on 8, a class move starts on 10).

### puncher / am (amateur, weighed on the day, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 65 | 0.9 kg | 0.0 % | 0.0 % | -0.5 % | 30 % | 4 / 5 % | 25 % | 1.0 | 0.00 | 9.88 |
| CUT | 65 | 2.9 kg | 1.8 % | 1.3 % | -0.0 % | 23 % | 3 / 6 % | 19 % | 2.0 | 0.00 | 10.45 |
| UP | 70 | 0.0 kg | 0.0 % | 0.0 % | -4.9 % | 30 % | 3 / 5 % | 26 % | 0.0 | 0.00 | 10.98 |
| DOWN | 60 | 5.9 kg | 4.0 % | 3.0 % | +0.6 % | 21 % | 3 / 2 % | 16 % | 8.9 | 2.95 | 11.55 |

Best: **STAY**

### puncher / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 65 | 0.9 kg | 0.0 % | 0.0 % | -4.3 % | 18 % | 13 / 29 % | 12 % | 1.0 | 0.00 | 10.63 |
| CUT | 65 | 2.9 kg | 1.8 % | 0.4 % | -2.9 % | 18 % | 13 / 28 % | 13 % | 2.0 | 0.00 | 10.63 |
| UP | 70 | 0.0 kg | 0.0 % | 0.0 % | -8.5 % | 18 % | 13 / 32 % | 12 % | 0.0 | 0.00 | 11.15 |
| DOWN | 60 | 5.9 kg | 4.0 % | 0.8 % | -1.0 % | 20 % | 17 / 21 % | 13 % | 6.0 | 0.00 | 10.93 |

Best: **STAY**

### volume / am (amateur, weighed on the day, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 70 | 1.4 kg | 0.0 % | 0.0 % | -0.5 % | 36 % | 5 / 3 % | 36 % | 2.0 | 0.00 | 9.45 |
| CUT | 70 | 3.4 kg | 2.1 % | 1.6 % | +0.1 % | 29 % | 4 / 3 % | 31 % | 3.1 | 0.10 | 10.10 |
| UP | 75 | 0.0 kg | 0.0 % | 0.0 % | -3.9 % | 42 % | 4 / 3 % | 39 % | 0.0 | 0.00 | 10.23 |
| DOWN | 65 | 6.4 kg | 4.0 % | 3.0 % | +0.6 % | 32 % | 4 / 3 % | 28 % | 8.1 | 2.10 | 11.18 |

Best: **STAY**

### volume / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 70 | 1.4 kg | 0.0 % | 0.0 % | -4.3 % | 24 % | 19 / 18 % | 26 % | 2.0 | 0.00 | 9.43 |
| CUT | 70 | 3.4 kg | 2.1 % | 0.4 % | -2.6 % | 23 % | 18 / 18 % | 27 % | 3.0 | 0.00 | 9.70 |
| UP | 75 | 0.0 kg | 0.0 % | 0.0 % | -7.6 % | 19 % | 9 / 17 % | 33 % | 0.0 | 0.00 | 10.98 |
| DOWN | 65 | 6.4 kg | 4.0 % | 0.8 % | -1.0 % | 26 % | 22 / 16 % | 28 % | 6.0 | 0.00 | 10.30 |

Best: **STAY**

### big chin / am (amateur, weighed on the day, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 75 | 1.1 kg | 0.0 % | 0.0 % | -0.5 % | 33 % | 3 / 3 % | 32 % | 1.0 | 0.00 | 9.63 |
| CUT | 75 | 3.1 kg | 1.5 % | 1.1 % | -0.1 % | 26 % | 3 / 3 % | 24 % | 3.0 | 0.00 | 10.07 |
| UP | 81 | 0.0 kg | 0.0 % | 0.0 % | -5.3 % | 41 % | 2 / 3 % | 52 % | 0.0 | 0.00 | 10.40 |
| DOWN | 70 | 6.1 kg | 3.0 % | 2.3 % | +0.3 % | 29 % | 3 / 3 % | 19 % | 8.0 | 0.95 | 11.15 |

Best: **STAY**

### big chin / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 75 | 1.1 kg | 0.0 % | 0.0 % | -4.3 % | 15 % | 8 / 12 % | 22 % | 1.0 | 0.00 | 10.25 |
| CUT | 75 | 3.1 kg | 1.5 % | 0.3 % | -3.1 % | 13 % | 8 / 13 % | 21 % | 3.0 | 0.00 | 10.43 |
| UP | 81 | 0.0 kg | 0.0 % | 0.0 % | -8.9 % | 21 % | 9 / 14 % | 27 % | 0.0 | 0.00 | 10.88 |
| DOWN | 70 | 6.1 kg | 3.0 % | 0.6 % | -1.8 % | 21 % | 16 / 13 % | 13 % | 7.0 | 0.00 | 10.80 |

Best: **STAY**

### drained cutter / am (amateur, weighed on the day, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 57 | 3.8 kg | 3.7 % | 2.8 % | +0.5 % | 32 % | 1 / 13 % | 46 % | 3.8 | 1.80 | 10.18 |
| CUT | 57 | 5.8 kg | 6.7 % | 5.1 % | +1.3 % | 15 % | 0 / 46 % | 24 % | 6.7 | 4.70 | 11.23 |
| UP | 60 | 1.8 kg | 0.4 % | 0.3 % | -0.4 % | 38 % | 2 / 9 % | 53 % | 2.0 | 0.00 | 10.65 |
| DOWN | 54 | 6.8 kg | 6.2 % | 4.6 % | +1.2 % | 23 % | 4 / 23 % | 29 % | 9.7 | 4.70 | 11.82 |

Best: **STAY**

### drained cutter / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 57 | 3.8 kg | 3.7 % | 0.7 % | -1.2 % | 20 % | 8 / 44 % | 46 % | 2.0 | 0.00 | 10.43 |
| CUT | 57 | 5.8 kg | 6.7 % | 1.3 % | +1.4 % | 20 % | 11 / 37 % | 43 % | 4.2 | 2.20 | 10.45 |
| UP | 60 | 1.8 kg | 0.4 % | 0.1 % | -4.0 % | 28 % | 7 / 41 % | 54 % | 2.0 | 0.00 | 11.03 |
| DOWN | 54 | 6.8 kg | 6.2 % | 1.2 % | +1.0 % | 23 % | 10 / 37 % | 47 % | 6.7 | 1.70 | 11.30 |

Best: **STAY**

### boxer-puncher / am (amateur, weighed on the day, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 60 | 1.1 kg | 0.0 % | 0.0 % | -0.5 % | 37 % | 3 / 3 % | 40 % | 1.0 | 0.00 | 9.43 |
| CUT | 60 | 3.1 kg | 2.4 % | 1.8 % | +0.1 % | 36 % | 3 / 2 % | 36 % | 2.5 | 0.50 | 9.57 |
| UP | 65 | 0.0 kg | 0.0 % | 0.0 % | -4.9 % | 42 % | 3 / 3 % | 47 % | 0.0 | 0.00 | 10.43 |
| DOWN | 55 | 6.1 kg | 5.0 % | 3.7 % | +0.9 % | 34 % | 2 / 4 % | 31 % | 8.7 | 3.65 | 11.40 |

Best: **STAY**

### boxer-puncher / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 60 | 1.1 kg | 0.0 % | 0.0 % | -4.3 % | 23 % | 10 / 14 % | 35 % | 1.0 | 0.00 | 9.90 |
| CUT | 60 | 3.1 kg | 2.4 % | 0.5 % | -2.4 % | 23 % | 8 / 16 % | 33 % | 2.0 | 0.00 | 10.10 |
| UP | 65 | 0.0 kg | 0.0 % | 0.0 % | -8.6 % | 24 % | 9 / 13 % | 38 % | 0.0 | 0.00 | 10.80 |
| DOWN | 55 | 6.1 kg | 5.0 % | 1.0 % | -0.1 % | 22 % | 12 / 15 % | 32 % | 5.8 | 0.85 | 10.88 |

Best: **STAY**

## 3. Ladder place at the end, every cell (lower is better)

| Cell | STAY | CUT | UP | DOWN | Best |
| :--- | ---: | ---: | ---: | ---: | :--- |
| puncher / am | 9.88 | 10.45 | 10.98 | 11.55 | STAY |
| puncher / pro | 10.63 | 10.63 | 11.15 | 10.93 | STAY |
| volume / am | 9.45 | 10.10 | 10.23 | 11.18 | STAY |
| volume / pro | 9.43 | 9.70 | 10.98 | 10.30 | STAY |
| big chin / am | 9.63 | 10.07 | 10.40 | 11.15 | STAY |
| big chin / pro | 10.25 | 10.43 | 10.88 | 10.80 | STAY |
| drained cutter / am | 10.18 | 11.23 | 10.65 | 11.82 | STAY |
| drained cutter / pro | 10.43 | 10.45 | 11.03 | 11.30 | STAY |
| boxer-puncher / am | 9.43 | 9.57 | 10.43 | 11.40 | STAY |
| boxer-puncher / pro | 9.90 | 10.10 | 10.80 | 10.88 | STAY |

Best counts: { "STAY": 10, "CUT": 0, "UP": 0, "DOWN": 0 }. The most any one choice wins: 10 of 10 cells (bar: 6 or fewer).

## 4. Does each lever move the result? (lever off, 5 seeds, against the same seeds with it on)

| Lever off | Mean change in win share | Biggest change in ladder place | Cells whose best choice changes | Moves it |
| :--- | ---: | ---: | ---: | :--- |
| drain | 3.7 points | 1.20 rungs | 4 of 10 | yes |
| size | 2.9 points | 1.40 rungs | 5 of 10 | yes |
| diet | 1.9 points | 1.00 rungs | 3 of 10 | yes |
| miss | 0.9 points | 0.80 rungs | 2 of 10 | yes |
| rank | 3.1 points | 1.40 rungs | 4 of 10 | yes |

9760 bouts played in 721 s.

RESULT: tools/weight2_probe.gd -> FAIL (levers all move; top choice best in 10 of 10 cells)

## 5. Reading (Claude, S535)

FAIL on the second bar: STAY is best in 10 of 10 cells on ladder place, because a class move starts two rungs lower and six
bouts cannot win that back. On win share UP is first or level in 7 of 10 cells, CUT harder is never best, and the two scales
behave as designed (the same water is 3.0 % dry on a same-day scale, 0.8 % the day after). Every boxer loses most bouts on every
choice (opponents too strong for the ladder to separate anything): a flaw of this run. The reading, and what round 2 changes, are
in `ops/research/DESIGN_WEIGHT2.md` section 4.
