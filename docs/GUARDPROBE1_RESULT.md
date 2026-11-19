# GUARDPROBE1 - guard damage v4 sized (S524)

Run: `python ops/Tools/godot_slot.py run --who guardprobe1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guard_probe.gd`.
Seeds 5000-5199, 200 bouts a cell, six cells. Sweep WEAR_SCALE [0.25, 0.35, 0.45, 0.6] x BLOCK_SHARE [0.5, 0.6, 0.7]; k solved from the damage target. Every number is a
probe-side re-computation from the recorded exchanges: scripts/ was not edited, no damage fed back into a bout. Targets (design s4):
+7..11% total damage; amateur r3 yellow (50-75%), red under 10% of bouts; pro6 last round orange (25-50%), red mostly the mismatch's
loser; a 10-punch flurry, a rope-trapped side and a dry fighter each visibly worse. 'Through' = GuardWear.transmission(kind, guard as
the punch arrives, max, class, combo) x the punch base (jab 1.0, power 2.5, heavy 4.0) over BoutBurn's MIX blocks, over m[damage]. a = ours.

## Population

| cell | code | rounds | limit kg | class | max guard | our boxer (style, paper) | opponents (style) | gap | plan | bouts | stopped |
|---|---|---|---|---|---|---|---|---|---|---|---|
| am3_even | amateur | 3 | 60 | light | 70 | Lucy (Out-boxer, paper 60.0) | Erin (Volume puncher)/Maria (Pressure fighter)/Priya (Counter-puncher) | +0 | jab and move (1-1, step back, pivot, tie up) | 200 | 10 |
| am3_miss | amateur | 3 | 60 | light | 70 | Lucy (Out-boxer, paper 60.0) | Dana (Boxer-puncher) | +9 | jab and move (1-1, step back, pivot, tie up) | 200 | 13 |
| pro4_even | pro | 4 | 75 | middle | 100 | Tess (Pressure fighter, paper 58.1) | Chantelle (Volume puncher)/Siobhan (Boxer-puncher)/Leah (Counter-puncher) | +0 | press behind the cross (1-2, step in, cut off, tie up) | 200 | 24 |
| pro4_miss | pro | 4 | 75 | middle | 100 | Tess (Pressure fighter, paper 58.1) | Victoria (Boxer-puncher) | +9 | press behind the cross (1-2, step in, cut off, tie up) | 200 | 26 |
| pro6_even | pro | 6 | 90 | heavy | 120 | Danny (Boxer-puncher, paper 57.5) | Darnell (Slugger)/Ryan (Out-boxer)/Samir (Counter-puncher) | +0 | feint and hook (2-3, feint, pivot, 1-2) | 200 | 30 |
| pro6_miss | pro | 6 | 90 | heavy | 120 | Danny (Boxer-puncher, paper 57.5) | Adebayo (Pressure fighter) | +9 | feint and hook (2-3, feint, pivot, 1-2) | 200 | 94 |
No two fighters identical: our boxer's seven stats are jittered +/-3 by the bout seed, the opponent a named boxer of another style at its
own rating, each cell on its own written plan. The heavyweight cell boxes at a 90 kg limit (the game's divisions stop at 75): the limit is set
on the bout, height/reach are the game's own BodyFacts body for it. Class = GuardState.wclass; an amateur's max is 70 whatever the class.

Self-check: the replay at the shipped WEAR_SCALE 0.45 / BLOCK_SHARE 0.60 reproduces the game's own GuardState guard at every bell, max |diff| = 0.000000 points.

## Guard, blocks and offline damage - shipped (today) (WEAR_SCALE 0.45, BLOCK_SHARE 0.60)

### 1+2. Guard at each bell (share of max), blocks a round and the guard points they cost (mean a side)

| cell | round | mean a | p10 a | p90 a | mean b | p10 b | p90 b | blocks a | points a | blocks b | points b | bouts |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| am3_even | 1 | 0.481 | 0.340 | 0.617 | 0.551 | 0.422 | 0.664 | 30.15 | 36.33 | 27.06 | 31.44 | 200 |
| am3_even | 2 | 0.225 | 0.000 | 0.412 | 0.318 | 0.139 | 0.495 | 27.26 | 32.69 | 26.65 | 31.00 | 197 |
| am3_even | 3 | 0.064 | 0.000 | 0.203 | 0.149 | 0.000 | 0.339 | 26.43 | 31.21 | 23.75 | 27.66 | 193 |
| am3_miss | 1 | 0.396 | 0.264 | 0.518 | 0.647 | 0.551 | 0.736 | 34.79 | 42.28 | 22.78 | 24.68 | 200 |
| am3_miss | 2 | 0.085 | 0.000 | 0.264 | 0.503 | 0.350 | 0.640 | 32.60 | 39.63 | 22.98 | 24.90 | 198 |
| am3_miss | 3 | 0.010 | 0.000 | 0.000 | 0.386 | 0.197 | 0.535 | 30.40 | 36.58 | 20.57 | 22.28 | 193 |
| pro4_even | 1 | 0.698 | 0.615 | 0.779 | 0.735 | 0.668 | 0.799 | 29.96 | 30.18 | 27.20 | 26.49 | 200 |
| pro4_even | 2 | 0.564 | 0.433 | 0.697 | 0.619 | 0.515 | 0.723 | 27.32 | 27.72 | 26.84 | 26.19 | 196 |
| pro4_even | 3 | 0.423 | 0.263 | 0.587 | 0.546 | 0.409 | 0.677 | 27.88 | 27.85 | 21.97 | 21.42 | 192 |
| pro4_even | 4 | 0.258 | 0.080 | 0.431 | 0.495 | 0.341 | 0.640 | 29.33 | 29.17 | 19.25 | 18.81 | 185 |
| pro4_miss | 1 | 0.651 | 0.568 | 0.741 | 0.785 | 0.721 | 0.842 | 34.06 | 34.90 | 23.09 | 21.48 | 200 |
| pro4_miss | 2 | 0.468 | 0.339 | 0.614 | 0.724 | 0.623 | 0.805 | 32.33 | 33.14 | 22.50 | 20.94 | 199 |
| pro4_miss | 3 | 0.286 | 0.134 | 0.458 | 0.694 | 0.565 | 0.789 | 32.38 | 32.78 | 19.06 | 17.72 | 197 |
| pro4_miss | 4 | 0.103 | 0.000 | 0.277 | 0.674 | 0.533 | 0.784 | 34.23 | 34.41 | 17.30 | 16.07 | 191 |
| pro6_even | 1 | 0.730 | 0.665 | 0.793 | 0.761 | 0.698 | 0.817 | 30.45 | 32.36 | 27.18 | 28.68 | 200 |
| pro6_even | 2 | 0.589 | 0.480 | 0.690 | 0.653 | 0.551 | 0.755 | 29.85 | 31.77 | 26.36 | 27.80 | 199 |
| pro6_even | 3 | 0.463 | 0.318 | 0.589 | 0.568 | 0.434 | 0.699 | 28.10 | 29.53 | 23.48 | 24.75 | 196 |
| pro6_even | 4 | 0.350 | 0.190 | 0.501 | 0.486 | 0.325 | 0.634 | 26.47 | 27.67 | 22.77 | 23.99 | 193 |
| pro6_even | 5 | 0.242 | 0.062 | 0.423 | 0.403 | 0.232 | 0.572 | 25.02 | 26.08 | 22.04 | 23.23 | 185 |
| pro6_even | 6 | 0.148 | 0.000 | 0.346 | 0.321 | 0.103 | 0.513 | 23.96 | 24.95 | 21.02 | 22.12 | 175 |
| pro6_miss | 1 | 0.689 | 0.629 | 0.755 | 0.821 | 0.777 | 0.865 | 34.15 | 37.29 | 24.02 | 21.51 | 200 |
| pro6_miss | 2 | 0.514 | 0.419 | 0.606 | 0.767 | 0.706 | 0.833 | 32.70 | 35.54 | 23.45 | 21.01 | 197 |
| pro6_miss | 3 | 0.355 | 0.226 | 0.480 | 0.729 | 0.644 | 0.806 | 30.34 | 32.65 | 20.63 | 18.48 | 190 |
| pro6_miss | 4 | 0.210 | 0.057 | 0.355 | 0.691 | 0.598 | 0.781 | 28.37 | 29.97 | 19.62 | 17.57 | 182 |
| pro6_miss | 5 | 0.097 | 0.000 | 0.240 | 0.641 | 0.521 | 0.751 | 23.98 | 25.14 | 16.63 | 14.89 | 151 |
| pro6_miss | 6 | 0.035 | 0.000 | 0.122 | 0.583 | 0.445 | 0.712 | 18.80 | 19.64 | 13.23 | 11.84 | 119 |

Colour reached at any bell (share of bouts) and the round it first happened (bouts):

| cell | side | yellow / orange / red |
|---|---|---|
| am3_even | a | yellow 100.0% (r1:200) / orange 98.5% (r1:111 r2:81 r3:5) / red 91.5% (r1:2 r2:109 r3:72) |
| am3_even | b | yellow 100.0% (r1:200) / orange 99.0% (r1:58 r2:123 r3:17) / red 74.5% (r2:61 r3:88) |
| am3_miss | a | yellow 100.0% (r1:200) / orange 100.0% (r1:167 r2:32 r3:1) / red 97.5% (r1:10 r2:163 r3:22) |
| am3_miss | b | yellow 100.0% (r1:190 r2:9 r3:1) / orange 75.5% (r1:6 r2:78 r3:67) / red 13.5% (r2:6 r3:21) |
| pro4_even | a | yellow 99.0% (r1:156 r2:38 r3:4) / orange 91.5% (r2:48 r3:91 r4:44) / red 44.5% (r3:17 r4:72) |
| pro4_even | b | yellow 99.0% (r1:111 r2:80 r3:7) / orange 46.5% (r2:16 r3:47 r4:30) / red 3.0% (r4:6) |
| pro4_miss | a | yellow 100.0% (r1:186 r2:14) / orange 99.0% (r2:125 r3:65 r4:8) / red 85.0% (r2:1 r3:75 r4:94) |
| pro4_miss | b | yellow 77.0% (r1:47 r2:72 r3:26 r4:9) / orange 5.5% (r3:5 r4:6) / red 0.0% (never) |
| pro6_even | a | yellow 100.0% (r1:124 r2:74 r3:2) / orange 95.5% (r2:32 r3:89 r4:55 r5:13 r6:2) / red 72.5% (r3:8 r4:34 r5:55 r6:48) |
| pro6_even | b | yellow 99.5% (r1:80 r2:97 r3:16 r4:5 r5:1) / orange 83.5% (r2:4 r3:45 r4:48 r5:48 r6:22) / red 28.5% (r3:1 r4:7 r5:22 r6:27) |
| pro6_miss | a | yellow 100.0% (r1:177 r2:23) / orange 97.5% (r2:87 r3:93 r4:14 r5:1) / red 90.0% (r3:33 r4:83 r5:51 r6:13) |
| pro6_miss | b | yellow 80.0% (r1:3 r2:67 r3:42 r4:29 r5:16 r6:3) / orange 10.5% (r3:1 r4:1 r5:9 r6:10) / red 0.5% (r6:1) |

### 3. Offline damage through the guard (k=1, nothing fed back)

| cell | through a | through b | real dmg a | real dmg b | % add a | % add b | % add pooled | mean per-bout % |
|---|---|---|---|---|---|---|---|---|
| am3_even | 17727.4 | 15784.2 | 7052.0 | 4970.0 | 251.4% | 317.6% | 278.8% | 296.1% |
| am3_miss | 21586.1 | 12566.6 | 12338.0 | 2154.0 | 175.0% | 583.4% | 235.7% | 252.4% |
| pro4_even | 24352.0 | 19223.2 | 13348.0 | 4496.0 | 182.4% | 427.6% | 244.2% | 257.8% |
| pro4_miss | 29552.4 | 15570.7 | 20360.0 | 2284.0 | 145.1% | 681.7% | 199.3% | 206.5% |
| pro6_even | 42055.2 | 35750.6 | 16024.0 | 9088.0 | 262.5% | 393.4% | 309.8% | 325.4% |
| pro6_miss | 43787.0 | 27578.0 | 21026.0 | 4324.0 | 208.3% | 637.8% | 281.5% | 289.6% |

## Guard, blocks and offline damage - chosen (WEAR_SCALE 0.45, BLOCK_SHARE 0.60)

### 1+2. Guard at each bell (share of max), blocks a round and the guard points they cost (mean a side)

| cell | round | mean a | p10 a | p90 a | mean b | p10 b | p90 b | blocks a | points a | blocks b | points b | bouts |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| am3_even | 1 | 0.481 | 0.340 | 0.617 | 0.551 | 0.422 | 0.664 | 30.15 | 36.33 | 27.06 | 31.44 | 200 |
| am3_even | 2 | 0.225 | 0.000 | 0.412 | 0.318 | 0.139 | 0.495 | 27.26 | 32.69 | 26.65 | 31.00 | 197 |
| am3_even | 3 | 0.064 | 0.000 | 0.203 | 0.149 | 0.000 | 0.339 | 26.43 | 31.21 | 23.75 | 27.66 | 193 |
| am3_miss | 1 | 0.396 | 0.264 | 0.518 | 0.647 | 0.551 | 0.736 | 34.79 | 42.28 | 22.78 | 24.68 | 200 |
| am3_miss | 2 | 0.085 | 0.000 | 0.264 | 0.503 | 0.350 | 0.640 | 32.60 | 39.63 | 22.98 | 24.90 | 198 |
| am3_miss | 3 | 0.010 | 0.000 | 0.000 | 0.386 | 0.197 | 0.535 | 30.40 | 36.58 | 20.57 | 22.28 | 193 |
| pro4_even | 1 | 0.698 | 0.615 | 0.779 | 0.735 | 0.668 | 0.799 | 29.96 | 30.18 | 27.20 | 26.49 | 200 |
| pro4_even | 2 | 0.564 | 0.433 | 0.697 | 0.619 | 0.515 | 0.723 | 27.32 | 27.72 | 26.84 | 26.19 | 196 |
| pro4_even | 3 | 0.423 | 0.263 | 0.587 | 0.546 | 0.409 | 0.677 | 27.88 | 27.85 | 21.97 | 21.42 | 192 |
| pro4_even | 4 | 0.258 | 0.080 | 0.431 | 0.495 | 0.341 | 0.640 | 29.33 | 29.17 | 19.25 | 18.81 | 185 |
| pro4_miss | 1 | 0.651 | 0.568 | 0.741 | 0.785 | 0.721 | 0.842 | 34.06 | 34.90 | 23.09 | 21.48 | 200 |
| pro4_miss | 2 | 0.468 | 0.339 | 0.614 | 0.724 | 0.623 | 0.805 | 32.33 | 33.14 | 22.50 | 20.94 | 199 |
| pro4_miss | 3 | 0.286 | 0.134 | 0.458 | 0.694 | 0.565 | 0.789 | 32.38 | 32.78 | 19.06 | 17.72 | 197 |
| pro4_miss | 4 | 0.103 | 0.000 | 0.277 | 0.674 | 0.533 | 0.784 | 34.23 | 34.41 | 17.30 | 16.07 | 191 |
| pro6_even | 1 | 0.730 | 0.665 | 0.793 | 0.761 | 0.698 | 0.817 | 30.45 | 32.36 | 27.18 | 28.68 | 200 |
| pro6_even | 2 | 0.589 | 0.480 | 0.690 | 0.653 | 0.551 | 0.755 | 29.85 | 31.77 | 26.36 | 27.80 | 199 |
| pro6_even | 3 | 0.463 | 0.318 | 0.589 | 0.568 | 0.434 | 0.699 | 28.10 | 29.53 | 23.48 | 24.75 | 196 |
| pro6_even | 4 | 0.350 | 0.190 | 0.501 | 0.486 | 0.325 | 0.634 | 26.47 | 27.67 | 22.77 | 23.99 | 193 |
| pro6_even | 5 | 0.242 | 0.062 | 0.423 | 0.403 | 0.232 | 0.572 | 25.02 | 26.08 | 22.04 | 23.23 | 185 |
| pro6_even | 6 | 0.148 | 0.000 | 0.346 | 0.321 | 0.103 | 0.513 | 23.96 | 24.95 | 21.02 | 22.12 | 175 |
| pro6_miss | 1 | 0.689 | 0.629 | 0.755 | 0.821 | 0.777 | 0.865 | 34.15 | 37.29 | 24.02 | 21.51 | 200 |
| pro6_miss | 2 | 0.514 | 0.419 | 0.606 | 0.767 | 0.706 | 0.833 | 32.70 | 35.54 | 23.45 | 21.01 | 197 |
| pro6_miss | 3 | 0.355 | 0.226 | 0.480 | 0.729 | 0.644 | 0.806 | 30.34 | 32.65 | 20.63 | 18.48 | 190 |
| pro6_miss | 4 | 0.210 | 0.057 | 0.355 | 0.691 | 0.598 | 0.781 | 28.37 | 29.97 | 19.62 | 17.57 | 182 |
| pro6_miss | 5 | 0.097 | 0.000 | 0.240 | 0.641 | 0.521 | 0.751 | 23.98 | 25.14 | 16.63 | 14.89 | 151 |
| pro6_miss | 6 | 0.035 | 0.000 | 0.122 | 0.583 | 0.445 | 0.712 | 18.80 | 19.64 | 13.23 | 11.84 | 119 |

Colour reached at any bell (share of bouts) and the round it first happened (bouts):

| cell | side | yellow / orange / red |
|---|---|---|
| am3_even | a | yellow 100.0% (r1:200) / orange 98.5% (r1:111 r2:81 r3:5) / red 91.5% (r1:2 r2:109 r3:72) |
| am3_even | b | yellow 100.0% (r1:200) / orange 99.0% (r1:58 r2:123 r3:17) / red 74.5% (r2:61 r3:88) |
| am3_miss | a | yellow 100.0% (r1:200) / orange 100.0% (r1:167 r2:32 r3:1) / red 97.5% (r1:10 r2:163 r3:22) |
| am3_miss | b | yellow 100.0% (r1:190 r2:9 r3:1) / orange 75.5% (r1:6 r2:78 r3:67) / red 13.5% (r2:6 r3:21) |
| pro4_even | a | yellow 99.0% (r1:156 r2:38 r3:4) / orange 91.5% (r2:48 r3:91 r4:44) / red 44.5% (r3:17 r4:72) |
| pro4_even | b | yellow 99.0% (r1:111 r2:80 r3:7) / orange 46.5% (r2:16 r3:47 r4:30) / red 3.0% (r4:6) |
| pro4_miss | a | yellow 100.0% (r1:186 r2:14) / orange 99.0% (r2:125 r3:65 r4:8) / red 85.0% (r2:1 r3:75 r4:94) |
| pro4_miss | b | yellow 77.0% (r1:47 r2:72 r3:26 r4:9) / orange 5.5% (r3:5 r4:6) / red 0.0% (never) |
| pro6_even | a | yellow 100.0% (r1:124 r2:74 r3:2) / orange 95.5% (r2:32 r3:89 r4:55 r5:13 r6:2) / red 72.5% (r3:8 r4:34 r5:55 r6:48) |
| pro6_even | b | yellow 99.5% (r1:80 r2:97 r3:16 r4:5 r5:1) / orange 83.5% (r2:4 r3:45 r4:48 r5:48 r6:22) / red 28.5% (r3:1 r4:7 r5:22 r6:27) |
| pro6_miss | a | yellow 100.0% (r1:177 r2:23) / orange 97.5% (r2:87 r3:93 r4:14 r5:1) / red 90.0% (r3:33 r4:83 r5:51 r6:13) |
| pro6_miss | b | yellow 80.0% (r1:3 r2:67 r3:42 r4:29 r5:16 r6:3) / orange 10.5% (r3:1 r4:1 r5:9 r6:10) / red 0.5% (r6:1) |

### 3. Offline damage through the guard (k=1, nothing fed back)

| cell | through a | through b | real dmg a | real dmg b | % add a | % add b | % add pooled | mean per-bout % |
|---|---|---|---|---|---|---|---|---|
| am3_even | 17727.4 | 15784.2 | 7052.0 | 4970.0 | 251.4% | 317.6% | 278.8% | 296.1% |
| am3_miss | 21586.1 | 12566.6 | 12338.0 | 2154.0 | 175.0% | 583.4% | 235.7% | 252.4% |
| pro4_even | 24352.0 | 19223.2 | 13348.0 | 4496.0 | 182.4% | 427.6% | 244.2% | 257.8% |
| pro4_miss | 29552.4 | 15570.7 | 20360.0 | 2284.0 | 145.1% | 681.7% | 199.3% | 206.5% |
| pro6_even | 42055.2 | 35750.6 | 16024.0 | 9088.0 | 262.5% | 393.4% | 309.8% | 325.4% |
| pro6_miss | 43787.0 | 27578.0 | 21026.0 | 4324.0 | 208.3% | 637.8% | 281.5% | 289.6% |

## 4. The sweep (k solved so the damage lands in +7..11%)

am3 r3 / pro6 r6 = mean guard share at that bell; am3 red = bouts where either side ever reaches red; pro6 rl = of the mismatch's red
bouts, the share where the red side is the one losing. k lo..hi = the six cells' +7..11% intervals intersected (empty = no single k hits
every cell; k used then falls back to the pooled interval). Ranked by targets missed, then distance.

| WEAR_SCALE | BLOCK_SHARE | am3 r3 | am3 red | pro6 r6 | pro6 rl | k lo | k hi | k used | misses |
|---|---|---|---|---|---|---|---|---|---|
| 0.45 | 0.60 | 0.152 | 98.5% | 0.265 | 83.4% | 0.0351 | 0.0355 | 0.0353 | 2 |
| 0.25 | 0.60 | 0.646 | 1.3% | 0.813 | 0.0% | 0.0408 | 0.0406 | 0.0396 | 3 |
| 0.25 | 0.50 | 0.685 | 0.0% | 0.842 | 0.0% | 0.0439 | 0.0428 | 0.0422 | 3 |
| 0.35 | 0.70 | 0.197 | 98.0% | 0.334 | 85.3% | 0.0303 | 0.0298 | 0.0294 | 3 |
| 0.45 | 0.50 | 0.177 | 98.0% | 0.309 | 83.5% | 0.0380 | 0.0374 | 0.0369 | 3 |
| 0.45 | 0.70 | 0.053 | 99.0% | 0.105 | 90.1% | 0.0282 | 0.0286 | 0.0284 | 3 |
| 0.60 | 0.50 | 0.029 | 99.3% | 0.069 | 96.9% | 0.0351 | 0.0358 | 0.0354 | 3 |
| 0.60 | 0.60 | 0.026 | 99.3% | 0.060 | 99.0% | 0.0326 | 0.0341 | 0.0334 | 3 |
| 0.60 | 0.70 | 0.002 | 100.0% | 0.008 | 99.5% | 0.0264 | 0.0278 | 0.0271 | 3 |
| 0.35 | 0.50 | 0.412 | 42.0% | 0.594 | 100.0% | 0.0408 | 0.0397 | 0.0393 | 4 |
| 0.35 | 0.60 | 0.362 | 65.0% | 0.546 | 100.0% | 0.0377 | 0.0375 | 0.0367 | 4 |
| 0.25 | 0.70 | 0.508 | 19.5% | 0.689 | 0.0% | 0.0331 | 0.0323 | 0.0319 | 4 |

## 5. The setting the probe recommends

`RESULT: tools/guard_probe.gd -> wear_scale=0.45 block_share=0.60 k=0.0353 damage_plus=9.0/7.7/10.4% amateur_r3=0.152 pro_last=0.265 red_amateur=98.5% all_targets=no`

### WEAR_SCALE 0.45, BLOCK_SHARE 0.60, k 0.0353 (closest)

Damage added at that k: 9.0/7.7/10.4% (amateur 3 / pro 4 / pro 6). Per cell: am3_even 9.8%, am3_miss 8.3%, pro4_even 8.6%, pro4_miss 7.0%, pro6_even 10.9%, pro6_miss 9.9%.

The three the design asks to see visibly worse, on these cells' own recorded blocks (guard points and damage per exchange):
- a 10-punch flurry (every block the 3rd+ punch of one combination; 41211 exchanges where 10+ were thrown): guard 5.57 -> 7.43 (x1.333), damage x1.292.
- a rope-trapped side (the same exchanges, defender on the ropes): guard wear x1.124.
- a dry fighter (condition 60, under the design's 70 line): guard wear x1.103, damage x1.003.

Targets this setting misses:
- amateur r3 guard below yellow (0.152)
- amateur red in 98.5% of bouts (target under 10%)

### WEAR_SCALE 0.25, BLOCK_SHARE 0.60, k 0.0396 (second closest)

Damage added at that k: 8.5/7.5/10.4% (amateur 3 / pro 4 / pro 6). Per cell: am3_even 9.2%, am3_miss 7.9%, pro4_even 8.3%, pro4_miss 6.8%, pro6_even 10.7%, pro6_miss 10.0%.

The three the design asks to see visibly worse, on these cells' own recorded blocks (guard points and damage per exchange):
- a 10-punch flurry (every block the 3rd+ punch of one combination; 41211 exchanges where 10+ were thrown): guard 3.10 -> 4.13 (x1.333), damage x1.296.
- a rope-trapped side (the same exchanges, defender on the ropes): guard wear x1.124.
- a dry fighter (condition 60, under the design's 70 line): guard wear x1.103, damage x1.002.

Targets this setting misses:
- no single k puts all six cells in +7..11% (k 0.0408..0.0406 empty, pooled 0.0372..0.0420); at k=0.0396: am3_even 9.2%, am3_miss 7.9%, pro4_even 8.3%, pro4_miss 6.8%, pro6_even 10.7%, pro6_miss 10.0%
- pro6 last round above orange (0.813)
- pro6 mismatch red not mostly the loser (0.0% of 0 red bouts)

## 6. Findings

- The raw offline damage at k=1 is far larger than +7..11%: an exchange settles 4-6 landed punches a side, BoutBurn derives thrown = landed /
  0.33 and BLOCK_SHARE of the rest are blocks - far more blocks than the design's per-punch table assumed. k reconciles them, scaling the leak only.
- WEAR_SCALE and BLOCK_SHARE set where the guard sits at each bell; k sets how much of a blocked punch lands - the colour and damage targets are
  independent. Nothing here changes a result: the guard is still shown only. Step 3 takes these numbers; GUARD_EDGE is still to size.
- No grid setting hits every target: the amateur and pro6 colour targets pull apart (amateur max 70 with +15% wear depletes faster in share terms than heavy max 120). The closest leaves amateur r3 at 0.152 (red in 98.5%) and pro6 r6 at 0.265; meeting both needs an amateur-specific lever (max guard or recovery), not WEAR_SCALE / BLOCK_SHARE alone.
