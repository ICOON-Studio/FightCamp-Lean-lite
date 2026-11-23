# TELLPLAY1 - a tell changes how the opponent fights: measured (S543)

**Verdict: FAIL - bar 1 (THE PLAYER'S LINE PAYS): 0 of 10 types, on the read and in the real bout. Stop.** Making the opponent
play a tell's situation more often (rule A at its start size: x1.5 of its share and at least +10 points) moves a player's
line over the coach's plan by a median of **0.0-2.1 points** on the read and **0.1-0.8 points in the real bout** per
situation. The method this task tested (TURNPROBE18's "a tell must make the opponent play its situation") is not enough: the
line is small because the coach's plan already answers the situation, not only because the situation is rare.

**The second finding is bigger, and it is a defect in today's read:** the one line TURNPROBE18 measured as strong - "combinations
inside when the opponent tires", +7 to +15 - is worth **+0.9 points in the real bout** (60,000 paired bouts; 2 SE 0.4). The read
over-reads it by 4 to 8 times: `BoutRead._game_edge_of` adds the tiring line at `PLAN_REACH x PLAN_CARRY` = 1.425 of its edge in
every tiring exchange with no fire share (`BoutRead.gd:247-248`). Rule B as "chain" (the tiring line walked on the card chain at
its fire share, like the other situations) brings the read to +2.2 against the bout's +0.9 (bar 5 PASS) and the best fade line
to 7.1 points at most (bar 2 PASS). The card the player sees today promises a fade answer the fight does not pay.

Design page: `ops/research/DESIGN_TELLPLAY1.md` (code read today, the two rules, the screens, the loops, the bars written before
the runs). Probe: `tools/tellplay1_probe.gd` (stages trial / read / bout_lines / bout_base), the flagged copies
`tools/tellplay1_rules.gd`, tables `tools/tellplay1_sum.py`. Raw: `E:/FightCamp/tmp/tellplay1/*.jsonl`. Nothing under scripts/ or
tests/ changed.

## The bars (coach 58, week 4, the same-rated man, the 4-round debut card)

| Bar | Today (rules off) | Rule A on, B off | Rule A on, B chain (the B pick) | Rule A on, B carry 0.95 |
|---|---|---|---|---|
| (1) the player's line pays: 4 of 5 situations at a median 3+, 6 of 10 types | 0 of 10 | 0 of 10 | **0 of 10 - FAIL** | 0 of 10 |
| (2) never a win button: no line over 10 | 14.4 (FAIL) | 14.4 (FAIL) | **7.1 - PASS** | 9.8 (PASS) |
| (3) the wrong line costs: worst-line median -2 or lower, 6 of 10 types | 1 of 10 | 3 of 10 | **2 of 10 - FAIL** | 3 of 10 |
| (4) the file must be read: no line best on more than half the files | PASS | PASS | **PASS** | PASS |
| (5) the read is the fight: best line's bout gain within 3 of the read, per situation | tiring +6.7 off (FAIL) | tiring +6.7 (FAIL) | **all five within 1.3 - PASS** | tiring +4.2 (FAIL) |
| (6) the game did not move (real bouts, coach's plan) | - | **not run** (below) | | |
| (7) the coach still matters (40 / 58 / 75) | - | **58 only; 40 and 75 not run** (below) | | |

Bars 6 and 7 were not run: from 22:42 the owner's game (ArcheAge, 5.5-7.7 GB) held the PC with memory AMBER then RED (95-99%
RAM) for the rest of the task, and the brief says wait. The verdict does not depend on them: bar 1 fails on both instruments.
The probe stages are ready (`stage=bout_base n=60 files=5`, about 15 minutes; `stage=read a=on b=chain coach=40|75`, about 4
minutes each).

## Bar 5: the read against the real bout (rule A on; 10 types x 3 files a situation x 200 paired bouts, line on and off)

| Situation | read: today | read: B chain | read: B carry 0.95 | real bout | 2 SE |
|---|---|---|---|---|---|
| press | 0.1 | 0.1 | 0.1 | 0.1 | 0.2 |
| range | 1.3 | 1.3 | 1.3 | 0.8 | 0.3 |
| counter | 0.2 | 0.2 | 0.2 | 0.6 | 0.2 |
| loadup | 0.3 | 0.3 | 0.3 | 0.1 | 0.3 |
| tiring (the fade) | 7.6 | 2.2 | 5.2 | **0.9** | 0.4 |

(Points of win chance, the read's best line in that situation on that file, mean over the 30 files. The bout changes few
results: 0-16 of 200 paired bouts differ, so 2 SE is 0.2-0.4 points - a 3-point difference is far outside the noise.)
The fade by type in the bout: Lucy -0.5, Kira 0.0 (no inside combination drilled), Samira 0.8, Tess 2.2, Danny -0.2, Josh 2.0,
Nell 0.5, Reece 0.0, Bayo 0.8, Kai 3.7.

## The read, per type and situation

### Rules OFF (today, the control arm), coach 58 (read_off)

| Type | press: median / max (files) | range: median / max (files) | counter: median / max (files) | loadup: median / max (files) | tiring: median / max (files) | sits >= 3 | worst line median | most-often best line (files of 180) | usual median |
|---|---|---|---|---|---|---|---|---|---|
| Lucy Jackson | 0.0 / 1.6 (84) | 1.2 / 3.9 (60) | 0.2 / 0.6 (30) | 0.0 / 1.2 (30) | 11.1 / 13.4 (36) | 1 | -1.7 | 1-2@range (60) | 56.8 |
| Kira Mensah | 0.0 / 0.0 (84) | 1.0 / 2.9 (60) | 0.3 / 0.6 (30) | 0.0 / 0.0 (30) | 0.0 / 0.0 (36) | 0 | -0.1 | 1-2@range (70) | 43.0 |
| Samira Khan | 0.2 / 0.4 (84) | 0.0 / 0.2 (60) | 0.0 / 0.0 (30) | 0.2 / 0.3 (30) | 8.7 / 10.4 (36) | 1 | -0.8 | step_back@press (84) | 31.8 |
| Tess Reilly | 0.2 / 0.5 (84) | 0.0 / 0.4 (60) | 0.0 / 0.0 (30) | 0.1 / 0.2 (30) | 7.5 / 8.9 (36) | 1 | -1.0 | step_back@press (84) | 33.0 |
| Danny Osei | 0.0 / 1.3 (84) | 0.9 / 3.4 (60) | 0.2 / 0.7 (30) | 0.0 / 1.2 (30) | 11.0 / 13.4 (36) | 1 | -1.9 | 2-3@range (43) | 51.4 |
| Josh Harper | 0.3 / 0.5 (84) | 0.0 / 0.3 (60) | 0.0 / 0.0 (30) | 0.1 / 0.3 (30) | 7.7 / 9.5 (36) | 1 | -0.9 | step_back@press (84) | 41.8 |
| Nell Ward | 0.0 / 2.0 (84) | 0.7 / 3.8 (60) | 0.2 / 0.4 (30) | 0.0 / 1.4 (30) | 10.2 / 14.0 (36) | 1 | -3.6 | 2-3@range (51) | 59.8 |
| Reece Doyle | 0.0 / 0.0 (84) | 1.1 / 3.0 (60) | 0.3 / 0.4 (30) | 0.0 / 0.0 (30) | 0.0 / 0.0 (36) | 0 | -0.1 | 1-2@range (70) | 47.2 |
| Bayo Adams | 0.2 / 0.4 (84) | 0.0 / 0.3 (60) | 0.0 / 0.0 (30) | 0.1 / 0.2 (30) | 8.5 / 10.5 (36) | 1 | -0.8 | step_back@press (84) | 37.3 |
| Kai Turner | 0.3 / 0.6 (84) | 0.0 / 0.5 (60) | 0.0 / 0.0 (30) | 0.1 / 0.4 (30) | 12.5 / 14.4 (36) | 1 | -0.7 | step_back@press (84) | 33.0 |

Bar 1 (4 of 5 situations at a median 3+): **0 of 10 types** (pass 6). Bar 2 (no line over 10): max **14.4** (Kai Turner vs Pressure fighter / Stops people / Fades after round 2: 3b-3@inside when tiring) -> FAIL. Bar 3 (worst line median -2 or lower): **1 of 10** (pass 6). Bar 4 (no line best on more than half the files): PASS. Mix STOP cases (a lived-on game under 5%): 8.

Mix stops: ('Lucy Jackson', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.177, 0.049); ('Samira Khan', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.168, 0.048); ('Tess Reilly', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.174, 0.049); ('Danny Osei', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.172, 0.049); ('Josh Harper', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.172, 0.049); ('Nell Ward', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.179, 0.049); ('Bayo Adams', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.171, 0.049); ('Kai Turner', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.177, 0.049)

### Rule A on, rule B off, coach 58 (read_on)

| Type | press: median / max (files) | range: median / max (files) | counter: median / max (files) | loadup: median / max (files) | tiring: median / max (files) | sits >= 3 | worst line median | most-often best line (files of 180) | usual median |
|---|---|---|---|---|---|---|---|---|---|
| Lucy Jackson | 0.0 / 2.3 (84) | 2.1 / 6.6 (60) | 0.4 / 0.8 (30) | 0.0 / 1.8 (30) | 11.1 / 13.4 (36) | 1 | -3.5 | 1-2@range (60) | 57.3 |
| Kira Mensah | 0.0 / 0.0 (84) | 1.7 / 4.8 (60) | 0.4 / 0.8 (30) | 0.0 / 0.0 (30) | 0.0 / 0.0 (36) | 0 | -0.1 | 1-2@range (70) | 42.9 |
| Samira Khan | 0.2 / 0.5 (84) | 0.0 / 0.6 (60) | 0.0 / 0.0 (30) | 0.2 / 0.4 (30) | 8.7 / 10.6 (36) | 1 | -1.1 | step_back@press (81) | 30.8 |
| Tess Reilly | 0.3 / 0.5 (84) | 0.0 / 0.8 (60) | 0.0 / 0.0 (30) | 0.2 / 0.4 (30) | 7.5 / 8.9 (36) | 1 | -1.4 | step_back@press (83) | 33.5 |
| Danny Osei | 0.0 / 2.0 (84) | 1.6 / 5.7 (60) | 0.4 / 0.9 (30) | 0.0 / 2.0 (30) | 11.1 / 13.4 (36) | 1 | -2.6 | 3b-3@inside@tiring (36) | 53.0 |
| Josh Harper | 0.3 / 0.5 (84) | 0.0 / 0.8 (60) | 0.0 / 0.0 (30) | 0.2 / 0.4 (30) | 7.7 / 9.5 (36) | 1 | -1.5 | step_back@press (82) | 42.2 |
| Nell Ward | 0.0 / 3.2 (84) | 1.5 / 5.5 (60) | 0.3 / 0.7 (30) | 0.0 / 2.5 (30) | 10.2 / 14.0 (36) | 1 | -5.3 | 2-3@range (48) | 58.9 |
| Reece Doyle | 0.0 / 0.0 (84) | 1.7 / 4.9 (60) | 0.4 / 0.8 (30) | 0.0 / 0.0 (30) | 0.0 / 0.0 (36) | 0 | -0.1 | 1-2@range (70) | 46.8 |
| Bayo Adams | 0.2 / 0.4 (84) | 0.0 / 0.8 (60) | 0.0 / 0.0 (30) | 0.2 / 0.3 (30) | 8.5 / 10.5 (36) | 1 | -1.3 | step_back@press (82) | 36.9 |
| Kai Turner | 0.3 / 0.7 (84) | 0.0 / 1.1 (60) | 0.0 / 0.0 (30) | 0.2 / 0.5 (30) | 12.5 / 14.4 (36) | 1 | -1.4 | step_back@press (84) | 33.1 |

Bar 1 (4 of 5 situations at a median 3+): **0 of 10 types** (pass 6). Bar 2 (no line over 10): max **14.4** (Kai Turner vs Pressure fighter / Stops people / Fades after round 2: 3b-3@inside when tiring) -> FAIL. Bar 3 (worst line median -2 or lower): **3 of 10** (pass 6). Bar 4 (no line best on more than half the files): PASS. Mix STOP cases (a lived-on game under 5%): 8.

Mix stops: ('Lucy Jackson', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.177, 0.049); ('Samira Khan', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.168, 0.048); ('Tess Reilly', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.174, 0.049); ('Danny Osei', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.172, 0.049); ('Josh Harper', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.172, 0.049); ('Nell Ward', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.179, 0.049); ('Bayo Adams', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.171, 0.049); ('Kai Turner', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.177, 0.049)

### Rule A on, rule B = chain, coach 58 (read_chain)

| Type | press: median / max (files) | range: median / max (files) | counter: median / max (files) | loadup: median / max (files) | tiring: median / max (files) | sits >= 3 | worst line median | most-often best line (files of 180) | usual median |
|---|---|---|---|---|---|---|---|---|---|
| Lucy Jackson | 0.0 / 2.3 (84) | 2.1 / 6.6 (60) | 0.4 / 0.9 (30) | 0.0 / 1.8 (30) | 0.2 / 0.2 (36) | 0 | -1.7 | 1-2@range (70) | 57.1 |
| Kira Mensah | 0.0 / 0.0 (84) | 1.7 / 4.8 (60) | 0.4 / 0.9 (30) | 0.0 / 0.0 (30) | 0.0 / 0.0 (36) | 0 | -0.1 | 1-2@range (70) | 43.0 |
| Samira Khan | 0.2 / 0.5 (84) | 0.0 / 0.6 (60) | 0.0 / 0.0 (30) | 0.2 / 0.4 (30) | 3.6 / 4.3 (36) | 1 | -1.0 | step_back@press (81) | 30.7 |
| Tess Reilly | 0.3 / 0.5 (84) | 0.0 / 0.8 (60) | 0.0 / 0.0 (30) | 0.2 / 0.4 (30) | 5.1 / 5.9 (36) | 1 | -1.3 | step_back@press (83) | 33.5 |
| Danny Osei | 0.0 / 2.0 (84) | 1.5 / 5.7 (60) | 0.4 / 0.9 (30) | 0.0 / 2.0 (30) | 0.1 / 0.2 (36) | 0 | -2.3 | 2-3@range (34) | 52.6 |
| Josh Harper | 0.3 / 0.5 (84) | 0.0 / 0.8 (60) | 0.0 / 0.0 (30) | 0.2 / 0.4 (30) | 3.4 / 4.2 (36) | 1 | -1.3 | step_back@press (82) | 42.2 |
| Nell Ward | 0.0 / 3.2 (84) | 1.4 / 5.5 (60) | 0.3 / 0.7 (30) | 0.0 / 2.5 (30) | 0.0 / 0.0 (36) | 0 | -4.1 | 2-3@range (56) | 58.8 |
| Reece Doyle | 0.0 / 0.0 (84) | 1.7 / 4.9 (60) | 0.4 / 1.0 (30) | 0.0 / 0.0 (30) | 0.0 / 0.0 (36) | 0 | -0.1 | 1-2@range (70) | 46.8 |
| Bayo Adams | 0.2 / 0.4 (84) | 0.0 / 0.8 (60) | 0.0 / 0.0 (30) | 0.2 / 0.3 (30) | 3.3 / 4.2 (36) | 1 | -1.2 | step_back@press (82) | 36.9 |
| Kai Turner | 0.3 / 0.7 (84) | 0.0 / 1.1 (60) | 0.0 / 0.0 (30) | 0.2 / 0.5 (30) | 6.2 / 7.1 (36) | 1 | -0.6 | step_back@press (84) | 33.1 |

Bar 1 (4 of 5 situations at a median 3+): **0 of 10 types** (pass 6). Bar 2 (no line over 10): max **7.1** (Kai Turner vs Pressure fighter / Never stops throwing / Fades after round 2: 3b-3@inside when tiring) -> PASS. Bar 3 (worst line median -2 or lower): **2 of 10** (pass 6). Bar 4 (no line best on more than half the files): PASS. Mix STOP cases (a lived-on game under 5%): 8.

Mix stops: ('Lucy Jackson', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.177, 0.049); ('Samira Khan', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.168, 0.048); ('Tess Reilly', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.174, 0.049); ('Danny Osei', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.172, 0.049); ('Josh Harper', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.172, 0.049); ('Nell Ward', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.179, 0.049); ('Bayo Adams', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.171, 0.049); ('Kai Turner', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.177, 0.049)

### Rule A on, rule B = carry 0.95, coach 58 (read_c095)

| Type | press: median / max (files) | range: median / max (files) | counter: median / max (files) | loadup: median / max (files) | tiring: median / max (files) | sits >= 3 | worst line median | most-often best line (files of 180) | usual median |
|---|---|---|---|---|---|---|---|---|---|
| Lucy Jackson | 0.0 / 2.3 (84) | 2.1 / 6.6 (60) | 0.4 / 0.8 (30) | 0.0 / 1.8 (30) | 7.7 / 9.1 (36) | 1 | -3.0 | 1-2@range (60) | 57.3 |
| Kira Mensah | 0.0 / 0.0 (84) | 1.7 / 4.8 (60) | 0.4 / 0.8 (30) | 0.0 / 0.0 (30) | 0.0 / 0.0 (36) | 0 | -0.1 | 1-2@range (70) | 42.9 |
| Samira Khan | 0.2 / 0.5 (84) | 0.0 / 0.6 (60) | 0.0 / 0.0 (30) | 0.2 / 0.4 (30) | 5.8 / 7.2 (36) | 1 | -1.1 | step_back@press (81) | 30.8 |
| Tess Reilly | 0.3 / 0.5 (84) | 0.0 / 0.8 (60) | 0.0 / 0.0 (30) | 0.2 / 0.4 (30) | 5.0 / 6.0 (36) | 1 | -1.3 | step_back@press (83) | 33.5 |
| Danny Osei | 0.0 / 2.0 (84) | 1.6 / 5.7 (60) | 0.4 / 0.9 (30) | 0.0 / 2.0 (30) | 7.7 / 9.1 (36) | 1 | -2.5 | 3b-3@inside@tiring (36) | 53.0 |
| Josh Harper | 0.3 / 0.5 (84) | 0.0 / 0.8 (60) | 0.0 / 0.0 (30) | 0.2 / 0.4 (30) | 5.2 / 6.4 (36) | 1 | -1.4 | step_back@press (82) | 42.2 |
| Nell Ward | 0.0 / 3.2 (84) | 1.5 / 5.5 (60) | 0.3 / 0.7 (30) | 0.0 / 2.5 (30) | 7.1 / 9.5 (36) | 1 | -4.3 | 2-3@range (48) | 58.9 |
| Reece Doyle | 0.0 / 0.0 (84) | 1.7 / 4.9 (60) | 0.4 / 0.8 (30) | 0.0 / 0.0 (30) | 0.0 / 0.0 (36) | 0 | -0.1 | 1-2@range (70) | 46.8 |
| Bayo Adams | 0.2 / 0.4 (84) | 0.0 / 0.8 (60) | 0.0 / 0.0 (30) | 0.2 / 0.3 (30) | 5.7 / 7.2 (36) | 1 | -1.3 | step_back@press (82) | 36.9 |
| Kai Turner | 0.3 / 0.7 (84) | 0.0 / 1.1 (60) | 0.0 / 0.0 (30) | 0.2 / 0.5 (30) | 8.5 / 9.8 (36) | 1 | -1.3 | step_back@press (84) | 33.1 |

Bar 1 (4 of 5 situations at a median 3+): **0 of 10 types** (pass 6). Bar 2 (no line over 10): max **9.8** (Kai Turner vs Pressure fighter / Never stops throwing / Fades after round 2: 3b-3@inside when tiring) -> PASS. Bar 3 (worst line median -2 or lower): **3 of 10** (pass 6). Bar 4 (no line best on more than half the files): PASS. Mix STOP cases (a lived-on game under 5%): 8.

Mix stops: ('Lucy Jackson', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.177, 0.049); ('Samira Khan', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.168, 0.048); ('Tess Reilly', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.174, 0.049); ('Danny Osei', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.172, 0.049); ('Josh Harper', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.172, 0.049); ('Nell Ward', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.179, 0.049); ('Bayo Adams', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.171, 0.049); ('Kai Turner', 'Out-boxer', 'Long jab', 'Walks in straight', 'counter', 0.177, 0.049)

## The mix moves with the tell (the one-rep trial: Lucy Jackson against six Boxer-puncher files)

| File (weapon / weakness) | tell -> game | mix off: press / range / counter / loadup | mix on |
|---|---|---|---|
| Body hooks / Leaves the chin open | weapon: press | 30 / 30 / 20 / 20 | 45 / 24 / 15 / 17 |
| Long jab / Leaves the chin open | weapon: range | 29 / 31 / 20 / 20 | 23 / 46 / 15 / 16 |
| Right hand over the jab / chin | weapon: counter | 29 / 30 / 20 / 20 | 27 / 24 / 31 / 18 |
| Heavy right hand / chin | weapon: loadup | 29 / 31 / 20 / 20 | 27 / 24 / 19 / 30 |
| Stops people / Fades after round 2 | weakness: tiring (rule B, not the mix) | 30 / 30 / 20 / 21 | same |
| Stops people / chin | none | 29 / 30 / 20 / 20 | same |

Trial checks: the mix changes with the tell (yes); the control arm reproduces TURNPROBE18 (the local copy of the read equals
`BoutRead.round_edges` to the hundredth on every type - "control" rows - and Lucy's fade line read 12.4, TURNPROBE18 11.1 median /
13.4 max); no line over 10 with rule B on (yes, today's B gives 12.4). A real bout cost 18 ms.

**Feedback-loop STOP flag:** one file, an Out-boxer with a "Long jab" (range) and "Walks in straight" (press), drops his counter
game from 17-18% to 4.8-4.9% of the mix with rule A on - under the 5% the page set for a game a style lives on. That file
alone; it would need a floor (no game under 5%) if rule A were ever built.

## Why it fails (plain words)

1. The coach already wrote the answer. `CoachPlan.write` puts the best answer the boxer can throw on every card the style
   fights on (`CoachPlan.gd:65-85`). A tell's situation is one of those games, so a line the player adds there either repeats the
   coach's move (gain 0.0: "step back when pressed" on 84 files) or is a second-best move (a small loss). Playing that game
   more often scales a gain of about zero.
2. Where a line does beat the coach (range, "1-2" for the out-boxers, "2-3" for Danny and Nell), it is worth about 1-2 points on
   the read at a 46% range share, and under 1 in the ring. To pay 3 points it would need two to three times the share, which
   takes the other games under 5% (the STOP above) and moves today's fights.
3. The fade line was the only strong answer, and the fight does not pay it: the read adds it in every tiring exchange at 1.425
   of its edge; the ring fires it only when she stands on the inside card. In the bout it is +0.9.
4. In the real bout a single line changes 0-8% of results. The plan's worth (DEPTH_AUDIT_S534 row 25: a whole plan against
   none, 13 points) sits in the coach's plan, not in the player's one line on top.

## The one change that would fix bar 1 (not built, not measured; the coordinator's call)

Let a found tell give the player something the coach's plan does not already have: **a line written against a FOUND tell's
situation fires at a "tape" edge over the coach's card answer** - e.g. `LineGrade.edge` read against the card's mean of the
moves the coach did NOT pick (today `PlanFight.card_mean` includes the coach's own best answer, so a copy of it scores 0), or the
coach's plan leaving the tell's situation unanswered until the tape is read (`CoachPlan.write` answers the style's cards, not
the file's tells). Either is an engine change in the ring and the read, needing its own probe on BOTH instruments. Per the
measurement above, rule A on its own (the mix) should not be built: it moves the line under 1 point in the ring.

**Separately, a seen defect, fixable now and smaller:** the read's fade answer. Change `BoutRead._game_edge_of` (l.247-248) to add
the line only for "she_tired" (drop "tiring" from the `sit in ["tiring", "she_tired"]` test), and in `BoutRead._round_edges` (l.378)
pass `["she_tired"]` as `PlanChain.walk`'s skip list, so the tiring line walks the card chain at its fire share like every other
situation (rule B "chain": read 2.2 against the bout's 0.9, max 7.1). That brings the card's promise down to what the fight
pays. Tests that read these terms and would need checking (grep of tests/ for next_mode, _games, STYLE_MODES / MODE_V,
PLAN_REACH / PLAN_CARRY; not run): `tests/corner_jobs_test.gd`, `tests/exchanges_test.gd`, `tests/fight_analysis_test.gd`, `tests/place_edge_test.gd`, `tests/plan_bots_test.gd`, `tests/tell_worth_test.gd`, `tests/week_opp_test.gd`, and `tests/bout_read_test.gd` (chance() against real bouts within 0.06).

## The tuned numbers (before -> after)

- Rule A: start size x1.5 / +10 points of share (cap 85%), one raise per situation. Not tuned further: at the start size the
  line moves 0.1-0.8 in the ring; a larger weight scales a gain near zero and already trips the 5% floor on one file. Before ->
  after: none (FAIL at the start size, the brief's estimate).
- Rule B: 1.425 (today) -> "chain" (the tiring line on the card chain, `PLAN_CARRY` 1.9 x fire share). carry 0.95 was the
  alternative: under the cap (9.8) but still +4.2 over the bout. Chain is the smaller change (one list, one condition) and the
  only one the bout agrees with.

## Earlier measurements of a tell's worth (prior_research.py tell film plan answer worth)

This AGREES with `BoutRules.FILM_PER_ANSWER` 0.4 power points a found tell the plan answers (at most 1.2): a found tell is worth
about one point in the ring, through the film edge or a line. It agrees with `tests/tell_worth_test.gd` / `TellWorth` in its
shape (worth = a use's worth x how often the situation comes up), and DISAGREES with the read's own fade answer and with the
TELLPLAY scope's "the fade answer alone adds 7-15": that number was the read's, and the fight pays under 1.

## Population and sizes

Ten types (TURNPROBE18's, week 4, pro-ready books): Lucy Jackson, Kira Mensah, Samira Khan, Tess Reilly, Nell Ward (women);
Danny Osei, Josh Harper, Reece Doyle, Bayo Adams, Kai Turner (men); six styles, stats differ (printed in each run's first line).
Opponents: their own sex and class (DebutOpp.make), 6 styles x 6 weapons x 5 weaknesses = 180 files, the same-rated man.
Reads: 16,704-16,714 per arm, four arms (3-4 minutes each). Real bouts: 60,000 (bar 5, 24.5 minutes on one slot), the game's
`BoutNight.play_out` (`fight_step` "start" + the auto corner's rounds through LiveRound, as `tests/bout_read_test.gd` plays it),
paired dice (bout k = career day 50000 + 7k in every arm), the coach's plan written by the game at the first bell (Reid, 58).

## Honest limits

- Bars 6 and 7 not run (the owner's game held the PC). Bar 6 matters only if rule A were built; bar 7 (coach 40 / 75) would
  show whether a weak coach leaves the player more to add - likely yes, since a 40 coach writes fewer arrows (`CoachPlan.reads`).
- The bout files per situation are three per type, picked by an even spread of the list; for "tiring" all three carry the
  "Never stops throwing" weapon (the spread fell on the same weapon), three styles each.
- One week (4), one rating (the same-rated man), one line at a time on top of the coach's plan, as TURNPROBE18.
- Rule A raises a game named by two tells once; compounding was not tried. The tiring situation was left to rule B (next_mode
  already plays the fade).
- The mirror: rule A writes only the opponent's `mode_bias`; `ProReadWire` (the pro corner reading our boxer) is untouched and
  rule A as written would not apply to our boxer.
