# WEIGHT2 probe, ROUND 2 - weight as one mechanic, measured on a greybox before any build (S535 WEIGHTMOVE1)

Round 1 (commit 875376421) FAILED: STAY best in 10 of 10 cells. Round 2 changes: a class move costs one rung (was two); size also
makes the opponent worth more or less in the exchanges (size_rating); opponents eased (opp_off) so the ladder can rise; 12 bouts on a 20-rung ladder.

Run: python ops/Tools/godot_slot.py run --who weight2 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/weight2_probe.gd -- seeds=20 bouts=12 abl=3

What is real: the five boxers (Data.PROSPECTS), their opponents (Data's region sheets), and every bout (BoutNight.play_out,
the game's fight night). What is scratch: the weight model below. Every number in it is an ESTIMATE waiting for John.
Each run = 12 bouts on a 20-rung ladder; 20 seeds a cell; every choice of a seed fights the same nights (same dice).

Model: { "bulk_kg": 2.0, "up_fill_kg": 1.0, "diet_hold": 0.025, "diet_hold_down": 0.05, "kg_a_week": 0.45, "free_weeks": 2.0, "size_power": 1.2, "size_chin": 1.0, "size_speed": 0.4, "size_cap": 8.0, "drain_cond": 2.0, "drain_chin": 1.5, "drain_speed": 0.8, "drain_power": 0.5, "drain_tank": 3.0, "tank_max": 25.0, "drain_knee": 3.0, "grow": 0.33, "diet_cost": 0.12, "grow_min": 0.4, "miss_slope": 0.2, "miss_max": 0.7, "rung0": 10.0, "rung_move": 11.0, "rung_gap": 1.2, "rung_max": 20.0, "field_grow": 0.15, "size_rating": 0.35 }

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
missed = scales missed a run, place = ladder rung at the end (1 is the top; every boxer starts on 10, a class move starts on 11).

### puncher / am (amateur, weighed on the day, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 65 | 0.9 kg | 0.0 % | 0.0 % | -0.5 % | 43 % | 8 / 3 % | 29 % | 1.0 | 0.00 | 11.32 |
| CUT | 65 | 2.9 kg | 1.8 % | 1.3 % | -0.0 % | 39 % | 8 / 4 % | 26 % | 2.0 | 0.00 | 12.23 |
| UP | 70 | 0.0 kg | 0.0 % | 0.0 % | -4.9 % | 39 % | 6 / 4 % | 31 % | 0.0 | 0.00 | 13.35 |
| DOWN | 60 | 5.9 kg | 4.0 % | 3.0 % | +0.6 % | 37 % | 9 / 2 % | 23 % | 11.4 | 5.40 | 15.10 |

Best: **STAY**

### puncher / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 65 | 0.9 kg | 0.0 % | 0.0 % | -4.3 % | 31 % | 27 / 16 % | 20 % | 1.0 | 0.00 | 11.93 |
| CUT | 65 | 2.9 kg | 1.8 % | 0.4 % | -2.9 % | 33 % | 29 / 14 % | 19 % | 2.0 | 0.00 | 11.30 |
| UP | 70 | 0.0 kg | 0.0 % | 0.0 % | -8.5 % | 31 % | 26 / 17 % | 19 % | 0.0 | 0.00 | 13.45 |
| DOWN | 60 | 5.9 kg | 4.0 % | 0.8 % | -1.0 % | 36 % | 32 / 10 % | 22 % | 6.0 | 0.00 | 11.43 |

Best: **CUT**

### volume / am (amateur, weighed on the day, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 70 | 1.4 kg | 0.0 % | 0.0 % | -0.5 % | 47 % | 8 / 2 % | 48 % | 2.0 | 0.00 | 10.20 |
| CUT | 70 | 3.4 kg | 2.1 % | 1.6 % | +0.1 % | 45 % | 8 / 3 % | 44 % | 3.1 | 0.15 | 10.85 |
| UP | 75 | 0.0 kg | 0.0 % | 0.0 % | -3.9 % | 48 % | 7 / 3 % | 47 % | 0.0 | 0.00 | 11.10 |
| DOWN | 65 | 6.4 kg | 4.0 % | 3.0 % | +0.6 % | 48 % | 9 / 2 % | 43 % | 9.7 | 3.70 | 12.78 |

Best: **STAY**

### volume / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 70 | 1.4 kg | 0.0 % | 0.0 % | -4.3 % | 36 % | 27 / 8 % | 37 % | 2.0 | 0.00 | 9.82 |
| CUT | 70 | 3.4 kg | 2.1 % | 0.4 % | -2.6 % | 41 % | 30 / 8 % | 35 % | 3.0 | 0.00 | 8.78 |
| UP | 75 | 0.0 kg | 0.0 % | 0.0 % | -7.6 % | 33 % | 18 / 10 % | 42 % | 0.0 | 0.00 | 11.90 |
| DOWN | 65 | 6.4 kg | 4.0 % | 0.8 % | -1.0 % | 44 % | 34 / 6 % | 37 % | 6.0 | 0.00 | 8.85 |

Best: **DOWN**

### big chin / am (amateur, weighed on the day, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 75 | 1.1 kg | 0.0 % | 0.0 % | -0.5 % | 45 % | 6 / 2 % | 38 % | 1.0 | 0.00 | 10.85 |
| CUT | 75 | 3.1 kg | 1.5 % | 1.1 % | -0.1 % | 43 % | 6 / 2 % | 34 % | 3.0 | 0.00 | 11.25 |
| UP | 81 | 0.0 kg | 0.0 % | 0.0 % | -5.3 % | 50 % | 4 / 3 % | 53 % | 0.0 | 0.00 | 10.88 |
| DOWN | 70 | 6.1 kg | 3.0 % | 2.3 % | +0.3 % | 44 % | 7 / 2 % | 28 % | 9.1 | 2.10 | 12.80 |

Best: **UP**

### big chin / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 75 | 1.1 kg | 0.0 % | 0.0 % | -4.3 % | 38 % | 17 / 7 % | 34 % | 1.0 | 0.00 | 10.05 |
| CUT | 75 | 3.1 kg | 1.5 % | 0.3 % | -3.1 % | 37 % | 18 / 6 % | 33 % | 3.0 | 0.00 | 10.10 |
| UP | 81 | 0.0 kg | 0.0 % | 0.0 % | -8.9 % | 38 % | 15 / 9 % | 35 % | 0.0 | 0.00 | 11.50 |
| DOWN | 70 | 6.1 kg | 3.0 % | 0.6 % | -1.8 % | 36 % | 24 / 8 % | 26 % | 7.0 | 0.00 | 11.45 |

Best: **STAY**

### drained cutter / am (amateur, weighed on the day, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 57 | 3.8 kg | 3.7 % | 2.8 % | +0.5 % | 46 % | 4 / 10 % | 54 % | 5.5 | 3.45 | 12.32 |
| CUT | 57 | 5.8 kg | 6.7 % | 5.1 % | +1.3 % | 42 % | 7 / 19 % | 60 % | 11.1 | 9.05 | 14.88 |
| UP | 60 | 1.8 kg | 0.4 % | 0.3 % | -0.4 % | 50 % | 3 / 7 % | 57 % | 2.0 | 0.00 | 10.90 |
| DOWN | 54 | 6.8 kg | 6.2 % | 4.6 % | +1.2 % | 42 % | 7 / 10 % | 61 % | 14.1 | 9.05 | 15.88 |

Best: **UP**

### drained cutter / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 57 | 3.8 kg | 3.7 % | 0.7 % | -1.2 % | 44 % | 14 / 21 % | 60 % | 2.0 | 0.00 | 9.07 |
| CUT | 57 | 5.8 kg | 6.7 % | 1.3 % | +1.4 % | 53 % | 21 / 15 % | 61 % | 7.2 | 5.20 | 10.82 |
| UP | 60 | 1.8 kg | 0.4 % | 0.1 % | -4.0 % | 44 % | 13 / 23 % | 63 % | 2.0 | 0.00 | 9.93 |
| DOWN | 54 | 6.8 kg | 6.2 % | 1.2 % | +1.0 % | 50 % | 24 / 16 % | 63 % | 8.9 | 3.95 | 10.88 |

Best: **STAY**

### boxer-puncher / am (amateur, weighed on the day, 3 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 60 | 1.1 kg | 0.0 % | 0.0 % | -0.5 % | 47 % | 7 / 3 % | 49 % | 1.0 | 0.00 | 10.38 |
| CUT | 60 | 3.1 kg | 2.4 % | 1.8 % | +0.1 % | 45 % | 8 / 2 % | 42 % | 2.9 | 0.90 | 11.13 |
| UP | 65 | 0.0 kg | 0.0 % | 0.0 % | -4.9 % | 47 % | 4 / 3 % | 50 % | 0.0 | 0.00 | 11.57 |
| DOWN | 55 | 6.1 kg | 5.0 % | 3.7 % | +0.9 % | 52 % | 9 / 1 % | 45 % | 12.4 | 7.35 | 14.32 |

Best: **STAY**

### boxer-puncher / pro (pro, weighed the day before, 6 rounds)

| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| STAY | 60 | 1.1 kg | 0.0 % | 0.0 % | -4.3 % | 38 % | 17 / 8 % | 46 % | 1.0 | 0.00 | 9.95 |
| CUT | 60 | 3.1 kg | 2.4 % | 0.5 % | -2.4 % | 40 % | 21 / 10 % | 45 % | 2.0 | 0.00 | 9.35 |
| UP | 65 | 0.0 kg | 0.0 % | 0.0 % | -8.6 % | 39 % | 15 / 11 % | 49 % | 0.0 | 0.00 | 10.80 |
| DOWN | 55 | 6.1 kg | 5.0 % | 1.0 % | -0.1 % | 48 % | 27 / 5 % | 47 % | 6.8 | 1.75 | 9.85 |

Best: **CUT**

## 3. Ladder place at the end, every cell (lower is better)

| Cell | STAY | CUT | UP | DOWN | Best |
| :--- | ---: | ---: | ---: | ---: | :--- |
| puncher / am | 11.32 | 12.23 | 13.35 | 15.10 | STAY |
| puncher / pro | 11.93 | 11.30 | 13.45 | 11.43 | CUT |
| volume / am | 10.20 | 10.85 | 11.10 | 12.78 | STAY |
| volume / pro | 9.82 | 8.78 | 11.90 | 8.85 | DOWN |
| big chin / am | 10.85 | 11.25 | 10.88 | 12.80 | UP |
| big chin / pro | 10.05 | 10.10 | 11.50 | 11.45 | STAY |
| drained cutter / am | 12.32 | 14.88 | 10.90 | 15.88 | UP |
| drained cutter / pro | 9.07 | 10.82 | 9.93 | 10.88 | STAY |
| boxer-puncher / am | 10.38 | 11.13 | 11.57 | 14.32 | STAY |
| boxer-puncher / pro | 9.95 | 9.35 | 10.80 | 9.85 | CUT |

Best counts: { "STAY": 5, "CUT": 2, "UP": 2, "DOWN": 1 }. The most any one choice wins: 5 of 10 cells (bar: 6 or fewer).

## 4. Does each lever move the result? (lever off, 3 seeds, against the same seeds with it on)

| Lever off | Mean change in win share | Biggest change in ladder place | Cells whose best choice changes | Moves it |
| :--- | ---: | ---: | ---: | :--- |
| drain | 2.3 points | 2.00 rungs | 4 of 10 | yes |
| size | 3.6 points | 5.00 rungs | 5 of 10 | yes |
| diet | 1.5 points | 1.67 rungs | 1 of 10 | yes |
| miss | 1.7 points | 2.50 rungs | 1 of 10 | yes |
| rank | 1.7 points | 2.50 rungs | 3 of 10 | yes |

15167 bouts played in 650 s.

RESULT: tools/weight2_probe.gd -> PASS (levers all move; top choice best in 5 of 10 cells)
