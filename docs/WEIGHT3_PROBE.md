# WEIGHT3 probe - is reading the opponent's cut worth a plan? (S537, ops/research/TASK_WEIGHT3.md)

The owner moved the weight mechanic's depth from OUR scale to the OPPONENT'S ("Yes, move it", on docs/WEIGHT2_PROBE5.md): our boxer boxes his natural class, and the player reads how much the other man took off
and writes the late rounds of the plan for it. This probe asks whether the fight code pays that. Our boxer is round 5's STAY; the field, its cut and what the cut costs are round 5's model unchanged
(tools/weight2_model.gd: a cut worth 15 % of Stamina or more makes him a fader on the game's own word, a smaller one comes off his rating). Every night is boxed once on each plan with the SAME dice,
so a read is only a choice of which of those bouts counts. Plain bouts, no ladder: the numbers are wins in 100.

Run: `python ops/Tools/godot_slot.py run --who weight3 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/weight3_probe.gd -- mode=pilot seeds=12 out=<csv>`, then `mode=main plans=FLAT,EARLY,S1P5,P3,LG3,B1P5,S1LG5,B1LG5 seeds=40`, then `mode=tank` with the same plans; `python tools/weight3_probe_sum.py --pilot .. --main .. --tank ..`.

What is real: the five boxers, each class's opponents, every bout (BoutNight, the game's fight night), and every plan line: the plan's ROUND row (Push / Take it easy), the corner's call for a round, the shout bar's body aim.
What is scratch: the weight sums (round 5's), and section 3's what-if.

## A correction to the brief before anything else

The brief reads round 5's section 7 as "reading the cut exactly is worth +1.11 rungs". It is the other way round: a ladder place is better when LOWER, and the reading arms finished 0.92 and 1.11 rungs BEHIND blind
(wins 47.1 % blind, 43.4 % range, 42.6 % exact; against the hard cutters 40.5 % -> 24.8 %). Round 5's one reading plan, "Let your hands go" from round 3, lost bouts. So this probe starts by asking which late line, if any, the fight code pays.

## The bars, written before the main run (on the pro scale, round 5's model)

- 1. The read moves the result: boxing the right plan for the man in front of him (exact read) beats the best single plan boxed every night, by more than two standard errors.
- 2. No plan is best in more than 6 of the 10 cells (five boxers x a hard cutter / a man who did not cut that hard).
- 3. A wrong read clearly costs: believing a cutter who is not one (and the reverse) ends more than two standard errors BELOW planning nothing.
- 4. Best against laziest: the exact read wins 3 or more bouts in 100 more than planning nothing.

Bars 1, 3 and 4 are measured split-half: the plans are picked on the even seeds and measured on the odd ones, so a lucky plan cannot pass them.

## 1. Pilot: which late line does the fight code pay against a drained man? (pro, its own seeds, 720 nights x 12 plans)

| Plan | What it is | Against a hard cutter (wins in 100 over FLAT) | Against the rest | Pays MORE against the cutter by |
| :--- | :--- | ---: | ---: | ---: |
| EARLY | Push rounds 1-2 (a 3-rounder: round 1) | -4.4 +- 2.1 | -3.8 +- 1.9 | -0.6 +- 2.8 |
| P3 | Push from round 3 | -14.5 +- 3.1 | -10.9 +- 1.7 | -3.6 +- 3.5 |
| P5 | Push from round 5 | -6.7 +- 2.0 | -5.2 +- 1.4 | -1.5 +- 2.5 |
| PB3 | Push and go to the body from round 3 | -8.4 +- 2.7 | -4.3 +- 1.6 | -4.2 +- 3.2 |
| B3P5 | Body from round 3, Push from round 5 | -1.0 +- 2.2 | -0.7 +- 1.7 | -0.3 +- 2.8 |
| B1P5 | Body all bout, Push from round 5 | +3.4 +- 2.1 | +3.3 +- 2.3 | +0.1 +- 3.1 |
| LG3 | "Let your hands go" from round 3 | -26.3 +- 3.1 | -20.8 +- 2.3 | -5.5 +- 3.8 |
| LG5 | "Let your hands go" from round 5 | -12.1 +- 2.2 | -9.9 +- 1.5 | -2.2 +- 2.7 |
| PLG5 | Push and "Let your hands go" from round 5 | -19.2 +- 2.7 | -12.8 +- 1.8 | -6.4 +- 3.3 |
| S1P3 | Take rounds 1-2 easy, Push from round 3 | +1.7 +- 2.1 | +2.4 +- 2.3 | -0.7 +- 3.1 |
| S1P5 | Take rounds 1-2 easy, Push from round 5 | +5.4 +- 2.2 | +6.1 +- 2.1 | -0.8 +- 3.0 |

Planning nothing wins 51.5 % against the hard cutters and 55.8 % against the rest. The rule set before the main run: the main run carries FLAT, EARLY, the brief's two late lines (P3, LG3), the pilot's two best lines against a hard cutter (S1P5, B1P5),
and two lines the pilot suggested but did not box (S1LG5, B1LG5: rest or body work first, hands late).

## 2. The main run: round 5's model (4800 nights x 8 plans, seeds the pilot never saw)

A hard cutter here is a fader on the game's word (he tires from round 3: Exchanges.next_mode, half his exchanges become "Tiring"); his tank is not touched.

### Pro: weighed the day before, 6 rounds; a hard cutter took off 9 or 10 % (two nights in five)

Does the field's cut show on this instrument?

| Opponent | Nights | Win, planning nothing | Late rounds won (round 3 on) | His tank as round 3 opens | Our tank at the last bell |
| :--- | ---: | ---: | ---: | ---: | ---: |
| hard cutter | 953 | 50.8 % | 54.0 % | 60 | 7 |
| the rest | 1447 | 60.0 % | 56.5 % | 62 | 8 |

What each plan is worth, and to whom:

| Plan | What it is | Against a hard cutter (wins in 100 over FLAT) | Against the rest | Pays MORE against the cutter by |
| :--- | :--- | ---: | ---: | ---: |
| EARLY | Push rounds 1-2 (a 3-rounder: round 1) | -3.5 +- 1.2 | -2.3 +- 1.0 | -1.1 +- 1.6 |
| S1P5 | Take rounds 1-2 easy, Push from round 5 | +8.2 +- 1.4 | +5.5 +- 1.1 | +2.7 +- 1.8 |
| P3 | Push from round 3 | -13.2 +- 1.3 | -11.7 +- 1.2 | -1.5 +- 1.7 |
| LG3 | "Let your hands go" from round 3 | -23.2 +- 1.4 | -23.0 +- 1.2 | -0.2 +- 1.8 |
| B1P5 | Body all bout, Push from round 5 | +2.9 +- 1.1 | +0.8 +- 1.0 | +2.2 +- 1.5 |
| S1LG5 | Take rounds 1-2 easy, "Let your hands go" from round 5 | +4.0 +- 1.3 | +2.1 +- 1.1 | +1.8 +- 1.8 |
| B1LG5 | Body all bout, "Let your hands go" from round 5 | -0.9 +- 1.3 | +0.3 +- 1.1 | -1.3 +- 1.8 |

Win share, cell by cell:

| Boxer | Opponent | Nights | FLAT | EARLY | S1P5 | P3 | LG3 | B1P5 | S1LG5 | B1LG5 | Best | Inside two standard errors of it |
| :--- | :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | :--- | :--- |
| puncher | hard cutter | 189 | 33.9 | 33.3 | 50.8 | 30.2 | 19.6 | 38.6 | 47.6 | 34.4 | **S1P5** | S1LG5 |
| puncher | the rest | 291 | 46.0 | 45.0 | 59.8 | 42.6 | 28.2 | 45.0 | 54.3 | 46.4 | **S1P5** | - |
| volume | hard cutter | 203 | 48.3 | 48.8 | 48.3 | 33.5 | 22.2 | 49.8 | 44.3 | 45.8 | **B1P5** | FLAT, EARLY, S1P5, S1LG5, B1LG5 |
| volume | the rest | 277 | 52.0 | 52.7 | 53.8 | 42.6 | 30.3 | 50.2 | 49.1 | 50.9 | **S1P5** | FLAT, EARLY, B1P5, B1LG5 |
| big chin | hard cutter | 196 | 51.0 | 37.2 | 62.8 | 30.1 | 23.5 | 52.0 | 57.1 | 45.9 | **S1P5** | - |
| big chin | the rest | 284 | 58.8 | 49.6 | 67.3 | 39.4 | 30.3 | 63.4 | 64.1 | 62.3 | **S1P5** | B1P5, B1LG5 |
| drained cutter | hard cutter | 176 | 61.9 | 61.9 | 67.0 | 50.0 | 32.4 | 64.2 | 61.9 | 60.8 | **S1P5** | EARLY, B1P5, B1LG5 |
| drained cutter | the rest | 304 | 74.3 | 74.0 | 78.3 | 61.5 | 47.7 | 75.7 | 73.4 | 70.7 | **S1P5** | B1P5 |
| boxer-puncher | hard cutter | 189 | 59.8 | 56.6 | 67.2 | 45.5 | 41.3 | 65.1 | 64.0 | 63.5 | **S1P5** | B1P5, B1LG5 |
| boxer-puncher | the rest | 291 | 67.7 | 65.6 | 67.4 | 54.3 | 47.4 | 68.4 | 68.7 | 70.4 | **B1LG5** | FLAT, EARLY, S1P5, B1P5, S1LG5 |

Best counts: S1P5 8, B1P5 1, B1LG5 1. The most any one plan wins: S1P5 in 8 of 10 cells. Boxers whose best plan against a hard cutter is clearly not their best against the rest: 0 of 5.

Picked on the even seeds (1200 nights): against a hard cutter **S1P5**, against the rest **S1P5**, the best single plan **S1P5**. Measured on the odd seeds (1200 nights, 459 of them against a hard cutter):

| Arm | What is boxed | Win | Against planning nothing (wins in 100) | Against the best single plan |
| :--- | :--- | ---: | ---: | ---: |
| blind, laziest | FLAT every night | 53.2 % | +0.0 +- 0.0 | -6.2 +- 1.2 |
| blind, early push | EARLY every night | 51.2 % | -2.0 +- 1.2 | -8.2 +- 1.6 |
| blind, best single plan | S1P5 every night | 59.4 % | +6.2 +- 1.2 | +0.0 +- 0.0 |
| blind, the cutter's plan | S1P5 every night | 59.4 % | +6.2 +- 1.2 | +0.0 +- 0.0 |
| exact read | S1P5 on a hard cutter, S1P5 on the rest | 59.4 % | +6.2 +- 1.2 | +0.0 +- 0.0 |
| range read, +- 1.5 % | the same, on the tape's read | 59.4 % | +6.2 +- 1.2 | +0.0 +- 0.0 |
| range read, +- 3 % | the same, on an unscouted read | 59.4 % | +6.2 +- 1.2 | +0.0 +- 0.0 |
| WRONG read | S1P5 on a hard cutter, S1P5 on the rest | 59.4 % | +6.2 +- 1.2 | +0.0 +- 0.0 |

| The brief's own arms (all seeds) | Win | Against planning nothing (wins in 100) |
| :--- | ---: | ---: |
| P3 every night (blind) | 44.0 % | -12.3 +- 0.9 |
| exact read: P3 on a hard cutter, FLAT on the rest | 51.1 % | -5.2 +- 0.5 |
| range read +- 1.5 %: P3 on a read cutter, FLAT else | 51.0 % | -5.3 +- 0.5 |
| WRONG read: FLAT on a hard cutter, P3 on the rest | 49.3 % | -7.0 +- 0.7 |
| LG3 every night (blind) | 33.2 % | -23.1 +- 0.9 |
| exact read: LG3 on a hard cutter, FLAT on the rest | 47.1 % | -9.2 +- 0.6 |
| range read +- 1.5 %: LG3 on a read cutter, FLAT else | 47.5 % | -8.8 +- 0.6 |
| WRONG read: FLAT on a hard cutter, LG3 on the rest | 42.5 % | -13.9 +- 0.7 |
| EARLY every night (blind) | 53.5 % | -2.8 +- 0.8 |

### Championship: weighed three hours before on each of three boxing days, 3 rounds; a hard cutter took off 4 % and it is the third day

Does the field's cut show on this instrument?

| Opponent | Nights | Win, planning nothing | Late rounds won (round 3 on) | His tank as round 3 opens | Our tank at the last bell |
| :--- | ---: | ---: | ---: | ---: | ---: |
| hard cutter | 263 | 52.1 % | 48.0 % | 61 | 14 |
| the rest | 2137 | 51.7 % | 46.5 % | 63 | 14 |

What each plan is worth, and to whom:

| Plan | What it is | Against a hard cutter (wins in 100 over FLAT) | Against the rest | Pays MORE against the cutter by |
| :--- | :--- | ---: | ---: | ---: |
| EARLY | Push rounds 1-2 (a 3-rounder: round 1) | +3.4 +- 1.6 | +2.2 +- 0.8 | +1.3 +- 1.8 |
| S1P5 | Take rounds 1-2 easy, Push from round 5 | +8.7 +- 2.1 | +6.3 +- 0.8 | +2.5 +- 2.2 |
| P3 | Push from round 3 | -2.3 +- 1.4 | -2.6 +- 0.4 | +0.3 +- 1.5 |
| LG3 | "Let your hands go" from round 3 | -2.7 +- 1.4 | -5.7 +- 0.5 | +3.0 +- 1.5 (clear) |
| B1P5 | Body all bout, Push from round 5 | -1.9 +- 1.5 | -1.9 +- 0.5 | +0.0 +- 1.6 |
| S1LG5 | Take rounds 1-2 easy, "Let your hands go" from round 5 | +10.6 +- 2.3 | +4.8 +- 0.8 | +5.8 +- 2.5 (clear) |
| B1LG5 | Body all bout, "Let your hands go" from round 5 | -1.5 +- 1.8 | -3.1 +- 0.6 | +1.6 +- 1.9 |

Win share, cell by cell:

| Boxer | Opponent | Nights | FLAT | EARLY | S1P5 | P3 | LG3 | B1P5 | S1LG5 | B1LG5 | Best | Inside two standard errors of it |
| :--- | :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | :--- | :--- |
| puncher | hard cutter | 53 | 64.2 | 66.0 | 69.8 | 60.4 | 62.3 | 52.8 | 73.6 | 54.7 | **S1LG5** | FLAT, EARLY, S1P5, P3, LG3 |
| puncher | the rest | 427 | 56.9 | 59.7 | 65.1 | 54.1 | 52.2 | 54.6 | 67.0 | 52.9 | **S1LG5** | S1P5 |
| volume | hard cutter | 53 | 47.2 | 50.9 | 56.6 | 45.3 | 45.3 | 45.3 | 60.4 | 49.1 | **S1LG5** | EARLY, S1P5 |
| volume | the rest | 427 | 47.5 | 50.1 | 51.3 | 44.0 | 42.2 | 44.3 | 50.4 | 43.6 | **S1P5** | EARLY, S1LG5 |
| big chin | hard cutter | 50 | 48.0 | 54.0 | 54.0 | 46.0 | 46.0 | 46.0 | 58.0 | 46.0 | **S1LG5** | FLAT, EARLY, S1P5, P3, LG3 |
| big chin | the rest | 430 | 45.3 | 44.2 | 52.1 | 43.0 | 42.8 | 43.7 | 54.0 | 44.9 | **S1LG5** | - |
| drained cutter | hard cutter | 56 | 46.4 | 46.4 | 55.4 | 37.5 | 35.7 | 44.6 | 53.6 | 41.1 | **S1P5** | EARLY, S1LG5 |
| drained cutter | the rest | 424 | 49.3 | 53.1 | 59.0 | 45.3 | 38.2 | 47.6 | 51.4 | 43.2 | **S1P5** | - |
| boxer-puncher | hard cutter | 51 | 54.9 | 60.8 | 68.6 | 60.8 | 58.8 | 62.7 | 68.6 | 62.7 | **S1P5** | EARLY, B1P5, S1LG5, B1LG5 |
| boxer-puncher | the rest | 429 | 59.4 | 62.2 | 62.5 | 59.2 | 54.5 | 58.7 | 59.9 | 58.3 | **S1P5** | FLAT, EARLY, P3 |

Best counts: S1LG5 5, S1P5 5. The most any one plan wins: S1LG5 in 5 of 10 cells. Boxers whose best plan against a hard cutter is clearly not their best against the rest: 0 of 5.

Picked on the even seeds (1200 nights): against a hard cutter **S1LG5**, against the rest **S1P5**, the best single plan **S1P5**. Measured on the odd seeds (1200 nights, 134 of them against a hard cutter):

| Arm | What is boxed | Win | Against planning nothing (wins in 100) | Against the best single plan |
| :--- | :--- | ---: | ---: | ---: |
| blind, laziest | FLAT every night | 49.8 % | +0.0 +- 0.0 | -5.4 +- 1.0 |
| blind, early push | EARLY every night | 51.4 % | +1.7 +- 1.1 | -3.8 +- 1.3 |
| blind, best single plan | S1P5 every night | 55.2 % | +5.4 +- 1.0 | +0.0 +- 0.0 |
| blind, the cutter's plan | S1LG5 every night | 54.4 % | +4.7 +- 1.0 | -0.8 +- 0.7 |
| exact read | S1LG5 on a hard cutter, S1P5 on the rest | 55.2 % | +5.5 +- 0.9 | +0.1 +- 0.2 |
| range read, +- 1.5 % | the same, on the tape's read | 55.4 % | +5.7 +- 0.9 | +0.2 +- 0.2 |
| range read, +- 3 % | the same, on an unscouted read | 55.0 % | +5.2 +- 1.0 | -0.2 +- 0.3 |
| WRONG read | S1P5 on a hard cutter, S1LG5 on the rest | 54.3 % | +4.6 +- 1.0 | -0.8 +- 0.7 |

| The brief's own arms (all seeds) | Win | Against planning nothing (wins in 100) |
| :--- | ---: | ---: |
| P3 every night (blind) | 49.2 % | -2.5 +- 0.4 |
| exact read: P3 on a hard cutter, FLAT on the rest | 51.5 % | -0.2 +- 0.2 |
| range read +- 1.5 %: P3 on a read cutter, FLAT else | 51.1 % | -0.6 +- 0.2 |
| WRONG read: FLAT on a hard cutter, P3 on the rest | 49.5 % | -2.3 +- 0.3 |
| LG3 every night (blind) | 46.4 % | -5.4 +- 0.5 |
| exact read: LG3 on a hard cutter, FLAT on the rest | 51.5 % | -0.3 +- 0.1 |
| range read +- 1.5 %: LG3 on a read cutter, FLAT else | 50.8 % | -0.9 +- 0.2 |
| WRONG read: FLAT on a hard cutter, LG3 on the rest | 46.7 % | -5.1 +- 0.5 |
| EARLY every night (blind) | 54.0 % | +2.3 +- 0.7 |

## 3. What if his cut came off his tank, as ours does? (NOT round 5's model, not in the game; 4800 nights, the same nights and dice)

Our boxer already pays the scale in his tank at the first bell (the bout's "stale", BoutNight._energy). The opponent never does: he starts every bout on a full tank (BoutNight.gd:324).
This arm takes the Stamina cost of HIS cut off HIS tank (at most 25, the cap ours has) from round 2 on, for every cut and not only the hard ones, gives him no fade word, and leaves punch and reading in his rating.
It is the smallest rule that would make a drained man different in the late rounds. It decides nothing here: it says what the next round should build and test.

### Pro: weighed the day before, 6 rounds; a hard cutter took off 9 or 10 % (two nights in five)

Does the field's cut show on this instrument?

| Opponent | Nights | Win, planning nothing | Late rounds won (round 3 on) | His tank as round 3 opens | Our tank at the last bell |
| :--- | ---: | ---: | ---: | ---: | ---: |
| hard cutter | 953 | 55.4 % | 55.1 % | 45 | 8 |
| the rest | 1447 | 58.3 % | 55.6 % | 52 | 8 |

What each plan is worth, and to whom:

| Plan | What it is | Against a hard cutter (wins in 100 over FLAT) | Against the rest | Pays MORE against the cutter by |
| :--- | :--- | ---: | ---: | ---: |
| EARLY | Push rounds 1-2 (a 3-rounder: round 1) | -2.3 +- 1.2 | -3.1 +- 1.0 | +0.8 +- 1.6 |
| S1P5 | Take rounds 1-2 easy, Push from round 5 | +7.5 +- 1.3 | +5.8 +- 1.0 | +1.6 +- 1.7 |
| P3 | Push from round 3 | -12.7 +- 1.3 | -11.7 +- 1.1 | -1.0 +- 1.8 |
| LG3 | "Let your hands go" from round 3 | -23.4 +- 1.4 | -23.5 +- 1.1 | +0.1 +- 1.8 |
| B1P5 | Body all bout, Push from round 5 | +3.3 +- 1.3 | +2.6 +- 0.9 | +0.6 +- 1.6 |
| S1LG5 | Take rounds 1-2 easy, "Let your hands go" from round 5 | +3.0 +- 1.2 | +2.9 +- 1.0 | +0.1 +- 1.6 |
| B1LG5 | Body all bout, "Let your hands go" from round 5 | +0.2 +- 1.3 | -0.2 +- 1.0 | +0.4 +- 1.7 |

Win share, cell by cell:

| Boxer | Opponent | Nights | FLAT | EARLY | S1P5 | P3 | LG3 | B1P5 | S1LG5 | B1LG5 | Best | Inside two standard errors of it |
| :--- | :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | :--- | :--- |
| puncher | hard cutter | 189 | 39.7 | 37.6 | 51.9 | 33.9 | 22.2 | 37.0 | 48.1 | 38.1 | **S1P5** | S1LG5 |
| puncher | the rest | 291 | 43.6 | 41.6 | 54.3 | 38.8 | 23.7 | 43.3 | 52.2 | 41.6 | **S1P5** | S1LG5 |
| volume | hard cutter | 203 | 49.8 | 52.7 | 48.3 | 37.4 | 27.6 | 52.2 | 45.8 | 48.3 | **EARLY** | FLAT, S1P5, B1P5, B1LG5 |
| volume | the rest | 277 | 48.0 | 51.6 | 49.8 | 39.7 | 26.4 | 50.5 | 48.4 | 49.8 | **EARLY** | FLAT, S1P5, B1P5, S1LG5, B1LG5 |
| big chin | hard cutter | 196 | 53.1 | 41.8 | 68.4 | 34.7 | 27.0 | 59.2 | 61.2 | 54.6 | **S1P5** | - |
| big chin | the rest | 284 | 60.2 | 45.4 | 70.4 | 37.7 | 29.6 | 63.4 | 64.4 | 59.5 | **S1P5** | - |
| drained cutter | hard cutter | 176 | 69.3 | 69.9 | 72.7 | 55.1 | 40.3 | 75.6 | 67.6 | 71.0 | **B1P5** | EARLY, S1P5, B1LG5 |
| drained cutter | the rest | 304 | 73.0 | 71.4 | 78.3 | 61.8 | 45.7 | 75.3 | 73.7 | 70.7 | **S1P5** | B1P5 |
| boxer-puncher | hard cutter | 189 | 66.7 | 65.1 | 74.6 | 54.0 | 43.9 | 70.9 | 70.9 | 67.7 | **S1P5** | B1P5 |
| boxer-puncher | the rest | 291 | 65.3 | 64.6 | 66.3 | 53.6 | 47.4 | 70.8 | 66.0 | 67.7 | **B1P5** | B1LG5 |

Best counts: S1P5 6, EARLY 2, B1P5 2. The most any one plan wins: S1P5 in 6 of 10 cells. Boxers whose best plan against a hard cutter is clearly not their best against the rest: 0 of 5.

Picked on the even seeds (1200 nights): against a hard cutter **S1P5**, against the rest **S1P5**, the best single plan **S1P5**. Measured on the odd seeds (1200 nights, 459 of them against a hard cutter):

| Arm | What is boxed | Win | Against planning nothing (wins in 100) | Against the best single plan |
| :--- | :--- | ---: | ---: | ---: |
| blind, laziest | FLAT every night | 54.1 % | +0.0 +- 0.0 | -6.0 +- 1.2 |
| blind, early push | EARLY every night | 51.8 % | -2.2 +- 1.3 | -8.2 +- 1.7 |
| blind, best single plan | S1P5 every night | 60.1 % | +6.0 +- 1.2 | +0.0 +- 0.0 |
| blind, the cutter's plan | S1P5 every night | 60.1 % | +6.0 +- 1.2 | +0.0 +- 0.0 |
| exact read | S1P5 on a hard cutter, S1P5 on the rest | 60.1 % | +6.0 +- 1.2 | +0.0 +- 0.0 |
| range read, +- 1.5 % | the same, on the tape's read | 60.1 % | +6.0 +- 1.2 | +0.0 +- 0.0 |
| range read, +- 3 % | the same, on an unscouted read | 60.1 % | +6.0 +- 1.2 | +0.0 +- 0.0 |
| WRONG read | S1P5 on a hard cutter, S1P5 on the rest | 60.1 % | +6.0 +- 1.2 | +0.0 +- 0.0 |

| The brief's own arms (all seeds) | Win | Against planning nothing (wins in 100) |
| :--- | ---: | ---: |
| P3 every night (blind) | 45.0 % | -12.1 +- 0.9 |
| exact read: P3 on a hard cutter, FLAT on the rest | 52.1 % | -5.0 +- 0.5 |
| range read +- 1.5 %: P3 on a read cutter, FLAT else | 52.1 % | -5.0 +- 0.6 |
| WRONG read: FLAT on a hard cutter, P3 on the rest | 50.1 % | -7.0 +- 0.7 |
| LG3 every night (blind) | 33.7 % | -23.5 +- 0.9 |
| exact read: LG3 on a hard cutter, FLAT on the rest | 47.8 % | -9.3 +- 0.6 |
| range read +- 1.5 %: LG3 on a read cutter, FLAT else | 48.0 % | -9.2 +- 0.6 |
| WRONG read: FLAT on a hard cutter, LG3 on the rest | 43.0 % | -14.2 +- 0.7 |
| EARLY every night (blind) | 54.3 % | -2.8 +- 0.8 |

### Championship: weighed three hours before on each of three boxing days, 3 rounds; a hard cutter took off 4 % and it is the third day

Does the field's cut show on this instrument?

| Opponent | Nights | Win, planning nothing | Late rounds won (round 3 on) | His tank as round 3 opens | Our tank at the last bell |
| :--- | ---: | ---: | ---: | ---: | ---: |
| hard cutter | 263 | 58.2 % | 53.9 % | 45 | 16 |
| the rest | 2137 | 50.6 % | 46.7 % | 58 | 14 |

What each plan is worth, and to whom:

| Plan | What it is | Against a hard cutter (wins in 100 over FLAT) | Against the rest | Pays MORE against the cutter by |
| :--- | :--- | ---: | ---: | ---: |
| EARLY | Push rounds 1-2 (a 3-rounder: round 1) | +1.5 +- 1.9 | +3.0 +- 0.7 | -1.5 +- 2.1 |
| S1P5 | Take rounds 1-2 easy, Push from round 5 | +8.7 +- 2.2 | +7.6 +- 0.8 | +1.1 +- 2.4 |
| P3 | Push from round 3 | -2.7 +- 1.4 | -2.7 +- 0.4 | +0.0 +- 1.4 |
| LG3 | "Let your hands go" from round 3 | -4.6 +- 1.5 | -5.0 +- 0.5 | +0.4 +- 1.6 |
| B1P5 | Body all bout, Push from round 5 | +1.9 +- 1.9 | -0.5 +- 0.5 | +2.4 +- 2.0 |
| S1LG5 | Take rounds 1-2 easy, "Let your hands go" from round 5 | +9.5 +- 2.2 | +6.8 +- 0.8 | +2.7 +- 2.4 |
| B1LG5 | Body all bout, "Let your hands go" from round 5 | +1.1 +- 1.9 | -2.0 +- 0.6 | +3.1 +- 2.0 |

Win share, cell by cell:

| Boxer | Opponent | Nights | FLAT | EARLY | S1P5 | P3 | LG3 | B1P5 | S1LG5 | B1LG5 | Best | Inside two standard errors of it |
| :--- | :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | :--- | :--- |
| puncher | hard cutter | 53 | 71.7 | 75.5 | 79.2 | 67.9 | 66.0 | 71.7 | 77.4 | 71.7 | **S1P5** | FLAT, EARLY, P3, LG3, B1P5, S1LG5, B1LG5 |
| puncher | the rest | 427 | 56.4 | 58.8 | 63.9 | 53.2 | 51.3 | 54.6 | 65.3 | 52.9 | **S1LG5** | S1P5 |
| volume | hard cutter | 53 | 50.9 | 50.9 | 58.5 | 47.2 | 50.9 | 50.9 | 62.3 | 54.7 | **S1LG5** | EARLY, S1P5, B1LG5 |
| volume | the rest | 427 | 46.1 | 50.8 | 52.2 | 43.1 | 41.5 | 45.2 | 51.5 | 44.0 | **S1P5** | EARLY, S1LG5 |
| big chin | hard cutter | 50 | 54.0 | 58.0 | 56.0 | 50.0 | 48.0 | 54.0 | 62.0 | 54.0 | **S1LG5** | FLAT, EARLY, S1P5, B1P5, B1LG5 |
| big chin | the rest | 430 | 44.7 | 45.1 | 52.3 | 41.9 | 41.9 | 43.0 | 55.1 | 43.7 | **S1LG5** | - |
| drained cutter | hard cutter | 56 | 50.0 | 53.6 | 67.9 | 42.9 | 37.5 | 50.0 | 62.5 | 44.6 | **S1P5** | S1LG5 |
| drained cutter | the rest | 424 | 48.8 | 53.1 | 60.4 | 45.0 | 39.4 | 48.8 | 55.2 | 43.6 | **S1P5** | - |
| boxer-puncher | hard cutter | 51 | 64.7 | 60.8 | 72.5 | 70.6 | 66.7 | 74.5 | 74.5 | 72.5 | **B1P5** | FLAT, S1P5, P3, LG3, S1LG5, B1LG5 |
| boxer-puncher | the rest | 429 | 57.1 | 60.4 | 62.5 | 56.6 | 54.3 | 59.2 | 59.9 | 59.0 | **S1P5** | EARLY, B1P5 |

Best counts: S1P5 5, S1LG5 4, B1P5 1. The most any one plan wins: S1P5 in 5 of 10 cells. Boxers whose best plan against a hard cutter is clearly not their best against the rest: 0 of 5.

Picked on the even seeds (1200 nights): against a hard cutter **S1LG5**, against the rest **S1P5**, the best single plan **S1P5**. Measured on the odd seeds (1200 nights, 134 of them against a hard cutter):

| Arm | What is boxed | Win | Against planning nothing (wins in 100) | Against the best single plan |
| :--- | :--- | ---: | ---: | ---: |
| blind, laziest | FLAT every night | 49.4 % | +0.0 +- 0.0 | -6.9 +- 1.0 |
| blind, early push | EARLY every night | 52.1 % | +2.7 +- 1.0 | -4.2 +- 1.3 |
| blind, best single plan | S1P5 every night | 56.3 % | +6.9 +- 1.0 | +0.0 +- 0.0 |
| blind, the cutter's plan | S1LG5 every night | 55.7 % | +6.2 +- 1.0 | -0.7 +- 0.6 |
| exact read | S1LG5 on a hard cutter, S1P5 on the rest | 56.2 % | +6.8 +- 1.0 | -0.2 +- 0.3 |
| range read, +- 1.5 % | the same, on the tape's read | 56.4 % | +7.0 +- 1.0 | +0.1 +- 0.3 |
| range read, +- 3 % | the same, on an unscouted read | 56.1 % | +6.7 +- 1.0 | -0.2 +- 0.3 |
| WRONG read | S1P5 on a hard cutter, S1LG5 on the rest | 55.8 % | +6.4 +- 1.0 | -0.5 +- 0.6 |

| The brief's own arms (all seeds) | Win | Against planning nothing (wins in 100) |
| :--- | ---: | ---: |
| P3 every night (blind) | 48.8 % | -2.7 +- 0.3 |
| exact read: P3 on a hard cutter, FLAT on the rest | 51.2 % | -0.3 +- 0.1 |
| range read +- 1.5 %: P3 on a read cutter, FLAT else | 50.9 % | -0.5 +- 0.2 |
| WRONG read: FLAT on a hard cutter, P3 on the rest | 49.1 % | -2.4 +- 0.3 |
| LG3 every night (blind) | 46.5 % | -4.9 +- 0.5 |
| exact read: LG3 on a hard cutter, FLAT on the rest | 51.0 % | -0.5 +- 0.2 |
| range read +- 1.5 %: LG3 on a read cutter, FLAT else | 50.6 % | -0.9 +- 0.2 |
| WRONG read: FLAT on a hard cutter, LG3 on the rest | 47.0 % | -4.4 +- 0.4 |
| EARLY every night (blind) | 54.3 % | +2.8 +- 0.7 |

## 4. The result

Bar 1 (the read moves the result): exact read against the best single plan +0.0 +- 0.0 wins in 100 -> **NOT MET**.
Bar 2 (no plan best in more than 6 of 10 cells): S1P5 is best in 8 of 10 -> **NOT MET**.
Bar 3 (a wrong read clearly costs): the wrong read against planning nothing +6.2 +- 1.2 -> **NOT MET**.
Bar 4 (best against laziest, 3+ wins in 100): the exact read against planning nothing +6.2 +- 1.2 -> **MET**.
Beside bar 4: the best single plan boxed blind every night is already +6.2 +- 1.2 over planning nothing, so that gain is the plan's, not the read's.
The line that pays most MORE against a hard cutter than against the rest: S1P5, by +2.7 +- 1.8 wins in 100.

The what-if (section 3, pro): exact read against the best single plan +0.0 +- 0.0; the wrong read against planning nothing +6.0 +- 1.2; S1P5 best in 6 of 10 cells; the line that pays most more against a cutter: S1P5 by +1.6 +- 1.7.

RESULT: tools/weight3_probe.gd -> FAIL (bars not met: 1, 2, 3)

## 5. Which lever broke

The plan has no line that a drained man makes better. Three things in the fight code, each visible in the tables above:

1. OUR tank is the limit, not his. Planning nothing, our boxer reaches the last bell of a six-rounder with about 7 of 100 left (14 in a three-rounder). Under 35 the exchange is fought as "Your fighter is tired" whatever the opponent is doing (Exchanges.situation, Exchanges.gd:194-199), and there "Let your hands go" is the WRONG call (Exchanges.gd:132) and a Push backfires (PaceAim.push_gassed, PaceAim.gd:193). So every late push or late hands line from round 3 loses against everybody, cutter or not.
2. A hard cutter is barely a different man. The fade word makes half his exchanges "Tiring" from round 3 (Exchanges.gd:276), but his tank starts full (BoutNight.gd:324) and stands at 60 against 62 as round 3 opens. On the pro scale planning nothing already wins LESS against him than against the rest, because round 5's model also makes him the bigger man in the ring.
3. One plan is best against everyone: take rounds 1-2 easy, push from round 5 (about +6 wins in 100 boxed blind, both scales, both models). A plan that is right whoever is in front of him is a rule to learn once, not a read. That is a balance finding of its own for the plan's ROUND row.

The what-if of section 3 (his cut off his tank) lowers his tank to 45 by round 3 and still fails the same three bars: with our own tank empty there is nothing to spend on him.

What a next round would have to change before the read can pay (design only: not built, not probed): the cut must come off the OPPONENT'S tank (one line, BoutNight.gd:324) AND our own boxer must have something left to spend late - either the six-round tank is refitted so a steady boxer ends near 30, or the tired-fighter state stops outranking a tiring opponent. Until both hold, his cut would be a number on the tape that changes no decision.

