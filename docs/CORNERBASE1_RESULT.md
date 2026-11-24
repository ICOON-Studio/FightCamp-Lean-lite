# CORNERBASE1 - what the live corner is worth against a coach who reads the fight (S547)

Task `ops/research/TASK_CORNERBASE1.md`; the coach's table, committed before any run: `ops/research/DESIGN_CORNERBASE1.md`
(commit 33e8fbb). 98,000 real bouts (+ the control and the trial). Nothing under scripts/ or tests/ changed.

## Verdict (for the owner)
1. **Against a coach who reads the opponent's file, the live corner is worth about 10 wins in 100, not 15-22**: the reader beats
   FILE+SKILL 58 by **+9.8 +-1.2** (3 rounds) and **+10.7 +-1.0** (6 rounds) over five boxers (CORNERCMD2's three: +12.0 / +13.8).
   It is worth most to the boxers the file call fits worst (Tess +17 / +19) and least to the raw one (Cara +6 / +6).
2. **A simmed bout should get the FILE coach**: **+2.6 +-1.2** (3 rounds) and **+6.2 +-1.2** (6 rounds) wins in 100 over today's
   blind call (`BoutRules.auto_corner`). Not built here. When it is built, keep her own call where she is Poor at the file's call: as
   measured, the file call costs the two out-boxers (Lucy, Cara: Poor at Go to the body) 3 to 5 wins in 100.
3. **Against an honest baseline the commands' bar 8 now passes** at both lengths (no command held all bout beats FILE+SKILL 58 by 10
   in any cell; the best is +4.9 +-2.9). **Bar 5 still fails**: 1 (3 rounds) and 2 (6 rounds) commands split the five boxers against
   FILE+SKILL 58, 4 needed. Bar 6 (the ring) is not re-measured: the ring calls are out (Q-330).
4. **The coach's rating buys nothing in a simmed bout under this rule**: 80 v 35 is **+0.4 +-0.9** (3 rounds) and **+0.7 +-0.7**
   (6 rounds). The FILE coach's gain comes from the between-round calls (rest under 35 wind, Hands up when hurt), not from reading
   the file. A coach who misreads 65% of files (35) does as well as one who reads them all. As a hire, a better corner coach is worth nothing here.

## Control (step 0, the STOP check): PASS
`coaches=0`, the presser at 3 rounds, Lucy and Samira, 70 bouts each, BLIND (`plan`) and the reader (with its ring, as CORNERCMD2
ran it): **all 280 bouts identical** to CORNERCMD2's `full.jsonl` (wins 57 / 60 / 30 / 42 of 70, the same outcome string bout by
bout). With the coaches off, the FILE arm equals BLIND bout for bout (it is wired only through the coach call). In the full run,
the 540 arm-rows it shares with CORNERCMD2 (its three boxers x 10 cells x 2 lengths x BLIND and the 8 commands) are identical
bout for bout too: the commands and the harness are as CORNERCMD2 left them.

## The coach's table (as written before the run; full text in DESIGN_CORNERBASE1.md)
| Coach | Round 1 | Each later corner (first rule that holds) |
|---|---|---|
| BLIND (`plan`, the control) | `BoutRules.auto_corner` l.383: long if technique > power, else body | the same call (`BoutNight.gd` l.128) |
| FILE | the best call (`Exchanges.MODES` l.124) against `OppFile.main_game` (l.113: the style's heaviest game in `STYLE_MODES` l.156) | 1. hurt in the round (`she_hurt` exchange, LiveRound l.156; `hurt_at_bell` l.453) -> Hands up; 2. bell wind < 35 (`Exchanges.SHE_TIRED` l.52; `energy.a_end` LiveRound l.418) -> Reset (calm); 3. the round-1 call |
| FILE + SKILL 35 / 58 / 80 | as FILE, but the file is read right with chance rating / 100 (one paired roll a bout); wrong = another game of the style, by its weights | as FILE |

Study the FILE coach follows: `ops/research/J55_THE_CORNER_BETWEEN_ROUNDS.md` (one or two instructions a minute; health first, then
breath, then the work-on). John's CORNERREAL1 answer (`CORNERREAL1_JOHN_JOHN.md`) was not on disk; only its brief.
The coach reads only what the player's side is shown: the style word (free at booking), her wind and whether she was hurt. He never
reads the exchange's mode, the hidden weapon or weakness, or the opponent's rating.

Stops before the full run (the one-rep trial: loader, Samira, 3 and 6 rounds, 20 bouts, all arms):
- FILE v BLIND at the loader: 13 v 8 (3 rounds), 13 v 6 (6 rounds). PASS.
- Identical outcome strings: BLIND = Go to the body held = Change levels held = Reset held (3 rounds), and the three skill arms =
  FILE (3 rounds; 2 of them at 6). Checked, not unwired. The eight commands match CORNERCMD2's own command arms bout for bout, and
  Samira's blind call is already "body". The skill arms play different calls: a diagnostic run logged each round's real call (FILE at
  the loader "hands" 58 rounds, an always-wrong coach `skill0` long 35 / lead 10 / hands 7 / body 4 / calm 2), and the mean call edge
  an exchange moves (2.65 v 2.40). Against a Slugger, "Jab and move" is nearly worth "Hands up" (ok v loading up, best v his 35%
  pressing), so 20 bouts land the same. In the presser cell the always-wrong coach differs (11 v 12 wins).
- Rest share: FILE rests in 30% of corners in the trial, **42% in the full run at 6 rounds (24% at 3)**: under half, so the line
  stays at 35 (it never moved).

## Population (five women; opponents of their own sex and class, `DebutOpp.make`, styled per cell)
- Lucy Jackson (Out-boxer), Samira Khan (Slugger), Tess Reilly (Pressure fighter): CORNERCMD2's three, TELLPLAY1 week 4. They grade alike
  (Poor 0-2, Good 2).
- **Cara Bello (raw, week 0)**, Out-boxer, the POOR boxer: Poor at Go to the body, Change levels, Reset and Sit down. OK at the other
  four, Good at none. Stats 47-63.5.
- **Jade Yates (all-round, week 80)**, Pressure fighter, the GOOD boxer: Good at 7 of 8 (OK at Get out of there). Stats 69-74.
- How the two were built: TELLPLAY1's ten all grade 0-2 Poor (stats 52-66, and its training only adds), so they come from the game's
  own scouting draw, `ProspectGen._draw` (a `Data.PROSPECTS` template, stats +-7, personality +-25; draws n = 1..2000, seed
  5470 + 13n, women only). Each draw goes through TELLPLAY1's route (`tools/cornerbase1_rules.gd` `route`, the lines of
  `T.build_types`: quick start, sign, hire reid, the book at factor 1.0, frame 168 / 170). The two differ only in training history.
  POOR = the draw with the most Poor grades at week 0 (signed, never trained): draw 49. GOOD = the draw with the most Good grades
  after 80 weeks of an all-round plan (every stat in turn through `TrainingPreview.plan_gain`, coach 58): draw 1249. Fixed in
  the probe as `pick=49,1249`. The poorest the scouting draw makes in 2,000 draws is 4 Poor of 8, so "mostly Poor" is half.

## Tables (a)-(e), per boxer and over all (`python tools/cornerbase1_sum.py full_L3.jsonl full_L6.jsonl`)
CORNERCMD2's three boxers, for the bridge: READER minus BLIND +15.4 +-1.7 (3) / +22.6 +-1.8 (6) (CORNERCMD2's reader with the ring:
+14.6 / +22.2); READER minus FILE+SKILL 58 +12.0 +-1.7 / +13.8 +-1.4; FILE minus BLIND +3.1 +-1.5 / +9.0 +-1.7.

bouts a boxer, cell and arm: 70; boxers: Lucy Jackson, Samira Khan, Tess Reilly, Cara Bello (raw, week 0), Jade Yates (all-round, week 80); cells: presser, mover, counter, loader, fader, slow, body, switch, favourite, underdog

## 3 rounds

Wins in 100 per arm (all cells): BLIND 63.9; FILE 66.6; FILE+SKILL 35 66.3; FILE+SKILL 58 66.4; FILE+SKILL 80 66.7; READER 76.3; c:body 55.1; c:levels 59.7; c:let_go 36.7; c:first 54.5; c:sit 53.3; c:hands 62.0; c:reset 59.7; c:get_out 62.9

### (a) READER minus each coach (wins in 100, +- 2 SE) - the worth of the live corner over that coach
| boxer | BLIND | FILE | FILE+SKILL 35 | FILE+SKILL 58 | FILE+SKILL 80 |
|---|---|---|---|---|---|
| Lucy Jackson | +6.9 +-2.4 | +10.9 +-3.0 | +11.9 +-3.0 | +10.4 +-2.9 | +10.1 +-3.0 |
| Samira Khan | +14.9 +-3.0 | +8.7 +-2.7 | +7.1 +-2.8 | +8.3 +-2.8 | +7.7 +-2.7 |
| Tess Reilly | +24.4 +-3.3 | +17.1 +-3.0 | +17.0 +-3.0 | +17.4 +-3.1 | +17.1 +-3.0 |
| Cara Bello (raw, week 0) | +1.4 +-2.1 | +5.3 +-2.8 | +6.7 +-2.8 | +6.1 +-2.8 | +6.0 +-3.0 |
| Jade Yates (all-round, week 80) | +14.4 +-2.7 | +6.3 +-2.1 | +7.0 +-2.3 | +6.9 +-2.2 | +6.7 +-2.1 |
| **all five** | +12.4 +-1.3 | +9.7 +-1.2 | +9.9 +-1.3 | +9.8 +-1.2 | +9.5 +-1.3 |

per cell, READER minus FILE+SKILL 58 / minus BLIND (all boxers): presser +7.4 +-3.8 / +9.4 +-3.7; mover +8.3 +-4.2 / +18.6 +-4.3; counter +9.1 +-4.0 / +10.9 +-3.6; loader +4.9 +-3.1 / +10.9 +-3.3; fader +10.0 +-3.7 / +6.9 +-3.8; slow +10.6 +-3.8 / +13.4 +-4.1; body +12.3 +-4.2 / +15.7 +-4.4; switch +14.0 +-4.2 / +16.3 +-4.3; favourite +12.3 +-4.5 / +14.6 +-4.1; underdog +9.4 +-3.6 / +7.4 +-3.7

### (b) each coach minus BLIND - what a player who sims would gain if the game's own call were that coach
| boxer | FILE | FILE+SKILL 35 | FILE+SKILL 58 | FILE+SKILL 80 |
|---|---|---|---|---|
| Lucy Jackson | -4.0 +-2.9 | -5.0 +-2.8 | -3.6 +-2.9 | -3.3 +-2.8 |
| Samira Khan | +6.1 +-2.5 | +7.7 +-3.1 | +6.6 +-2.8 | +7.1 +-2.6 |
| Tess Reilly | +7.3 +-2.5 | +7.4 +-2.8 | +7.0 +-2.7 | +7.3 +-2.6 |
| Cara Bello (raw, week 0) | -3.9 +-2.6 | -5.3 +-2.7 | -4.7 +-2.5 | -4.6 +-2.7 |
| Jade Yates (all-round, week 80) | +8.1 +-2.3 | +7.4 +-2.3 | +7.6 +-2.2 | +7.7 +-2.3 |
| **all five** | +2.7 +-1.2 | +2.5 +-1.2 | +2.6 +-1.2 | +2.9 +-1.2 |

per cell, FILE minus BLIND (all boxers): presser +6.3 +-3.2; mover +14.0 +-3.9; counter +6.6 +-3.8; loader +7.1 +-3.8; fader -1.7 +-3.5; slow +1.4 +-3.7; body +1.1 +-3.6; switch +0.3 +-3.7; favourite -1.7 +-3.6; underdog -6.0 +-3.3

### Corners: share of between-round calls that were Reset (rest) / Hands up (hurt); file read right
| boxer | FILE | FILE+SKILL 35 | FILE+SKILL 58 | FILE+SKILL 80 |
|---|---|---|---|---|
| Lucy Jackson | rest 23% hands 19% right 100% | rest 13% hands 18% right 36% | rest 16% hands 18% right 59% | rest 19% hands 18% right 79% |
| Samira Khan | rest 24% hands 16% right 100% | rest 11% hands 17% right 33% | rest 16% hands 17% right 60% | rest 21% hands 16% right 82% |
| Tess Reilly | rest 24% hands 16% right 100% | rest 13% hands 17% right 36% | rest 17% hands 16% right 61% | rest 20% hands 16% right 80% |
| Cara Bello (raw, week 0) | rest 22% hands 21% right 100% | rest 11% hands 19% right 33% | rest 15% hands 20% right 55% | rest 20% hands 20% right 80% |
| Jade Yates (all-round, week 80) | rest 25% hands 6% right 100% | rest 14% hands 8% right 35% | rest 18% hands 7% right 60% | rest 22% hands 6% right 81% |
| **all five** | rest 24% hands 16% right 100% | rest 12% hands 16% right 35% | rest 16% hands 16% right 59% | rest 20% hands 16% right 80% |

Best fixed arm (a command held all bout, ring at Centre; the highest all-cell mean): c:get_out; READER minus it +13.4 +-1.3; it minus FILE+SKILL 58 -3.6 +-1.3

### (c) bar 8 v BLIND: a command held all bout beats it by more than 10 in a cell? FAIL (1 cell-commands); top: get_out v loader +10.9 +-3.5; body v mover +9.7 +-3.6; hands v mover +4.3 +-3.8; reset v mover +4.0 +-4.4; get_out v presser +3.7 +-2.8; levels v mover +2.9 +-3.2

### (c) bar 8 v FILE+SKILL 58: a command held all bout beats it by more than 10 in a cell? PASS; top: get_out v loader +4.9 +-2.9; get_out v presser +1.7 +-3.4; get_out v fader +0.3 +-3.7; body v mover -0.6 +-3.9; hands v switch -1.1 +-3.9; get_out v body -1.4 +-4.0

### (d) bar 5 (base BLIND): the five boxers disagree (one over +1, one under -1) on 4 commands -> PASS: body, levels, hands, reset
| command | Lucy Jackson | Samira Khan | Tess Reilly | Cara Bello (raw, week 0) | Jade Yates (all-round, week 80) |
|---|---|---|---|---|---|
| body | -24.3 +-3.5 | +1.3 +-1.1 | +1.9 +-1.2 | -27.7 +-3.5 | +5.0 +-2.8 |
| levels | -11.6 +-2.9 | -1.3 +-2.6 | -0.7 +-2.8 | -9.9 +-2.6 | +2.9 +-2.6 |
| let_go | -33.3 +-3.6 | -21.7 +-3.4 | -23.6 +-3.4 | -34.1 +-3.7 | -23.0 +-3.3 |
| first | -5.7 +-3.0 | -11.6 +-3.2 | -16.3 +-3.2 | -9.3 +-2.7 | -3.7 +-2.2 |
| sit | -7.3 +-2.5 | -12.0 +-3.2 | -12.9 +-2.8 | -12.6 +-2.5 | -7.9 +-2.5 |
| hands | -8.9 +-2.8 | +3.1 +-2.8 | +5.6 +-2.9 | -9.4 +-2.6 | +0.1 +-2.4 |
| reset | -10.1 +-2.7 | +2.0 +-3.0 | +5.3 +-3.3 | -12.7 +-2.7 | -5.1 +-2.5 |
| get_out | +1.0 +-1.5 | +0.9 +-3.1 | -2.9 +-3.3 | +0.9 +-1.2 | -4.9 +-1.7 |

### (d) bar 5 (base FILE+SKILL 58): the five boxers disagree (one over +1, one under -1) on 1 commands -> FAIL: get_out
| command | Lucy Jackson | Samira Khan | Tess Reilly | Cara Bello (raw, week 0) | Jade Yates (all-round, week 80) |
|---|---|---|---|---|---|
| body | -20.7 +-3.2 | -5.3 +-2.9 | -5.1 +-2.9 | -23.0 +-3.3 | -2.6 +-2.5 |
| levels | -8.0 +-2.9 | -7.9 +-3.1 | -7.7 +-3.3 | -5.1 +-2.7 | -4.7 +-2.5 |
| let_go | -29.7 +-3.6 | -28.3 +-3.5 | -30.6 +-3.6 | -29.4 +-3.7 | -30.6 +-3.5 |
| first | -2.1 +-3.2 | -18.1 +-3.4 | -23.3 +-3.5 | -4.6 +-3.0 | -11.3 +-2.8 |
| sit | -3.7 +-2.9 | -18.6 +-3.2 | -19.9 +-3.2 | -7.9 +-2.8 | -15.4 +-3.1 |
| hands | -5.3 +-2.9 | -3.4 +-2.6 | -1.4 +-2.9 | -4.7 +-2.6 | -7.4 +-2.4 |
| reset | -6.6 +-2.9 | -4.6 +-2.9 | -1.7 +-3.2 | -8.0 +-2.8 | -12.7 +-2.8 |
| get_out | +4.6 +-3.0 | -5.7 +-2.6 | -9.9 +-3.1 | +5.6 +-2.7 | -12.4 +-2.6 |

### (e) the coach's rating, when the player sims (paired: the 80 coach is right in every bout the 58 is)
| boxer | 58 - 35 | 80 - 58 | 80 - 35 |
|---|---|---|---|
| Lucy Jackson | +1.4 +-1.6 | +0.3 +-1.6 | +1.7 +-2.2 |
| Samira Khan | -1.1 +-1.6 | +0.6 +-1.5 | -0.6 +-2.2 |
| Tess Reilly | -0.4 +-1.4 | +0.3 +-1.2 | -0.1 +-1.9 |
| Cara Bello (raw, week 0) | +0.6 +-1.1 | +0.1 +-1.5 | +0.7 +-1.9 |
| Jade Yates (all-round, week 80) | +0.1 +-1.2 | +0.1 +-1.0 | +0.3 +-1.6 |
| **all five** | +0.1 +-0.6 | +0.3 +-0.6 | +0.4 +-0.9 |

### Wind at each bell (mean of the cells)
| arm | Lucy Jackson | Samira Khan | Tess Reilly | Cara Bello (raw, week 0) | Jade Yates (all-round, week 80) |
|---|---|---|---|---|---|
| BLIND | 69 49 34 | 56 23 1 | 56 24 1 | 68 47 31 | 72 54 42 |
| FILE | 61 34 28 | 61 34 29 | 61 35 30 | 60 32 25 | 64 39 37 |
| FILE+SKILL 58 | 63 37 29 | 63 38 29 | 64 39 31 | 62 36 26 | 66 43 37 |
| READER | 65 39 26 | 55 29 25 | 58 32 26 | 63 35 24 | 66 39 27 |
| c:reset | 67 44 31 | 63 38 27 | 64 39 28 | 66 42 29 | 70 49 36 |
| c:get_out | 67 43 26 | 63 40 23 | 63 41 25 | 66 42 23 | 70 48 34 |

## 6 rounds

Wins in 100 per arm (all cells): BLIND 67.0; FILE 73.4; FILE+SKILL 35 72.8; FILE+SKILL 58 73.1; FILE+SKILL 80 73.5; READER 83.8; c:body 58.7; c:levels 63.1; c:let_go 30.2; c:first 47.2; c:sit 58.5; c:hands 67.1; c:reset 72.9; c:get_out 62.4

### (a) READER minus each coach (wins in 100, +- 2 SE) - the worth of the live corner over that coach
| boxer | BLIND | FILE | FILE+SKILL 35 | FILE+SKILL 58 | FILE+SKILL 80 |
|---|---|---|---|---|---|
| Lucy Jackson | +9.4 +-2.0 | +12.2 +-2.4 | +13.1 +-2.3 | +12.2 +-2.4 | +11.8 +-2.3 |
| Samira Khan | +25.0 +-3.2 | +10.4 +-2.3 | +10.5 +-2.3 | +10.6 +-2.3 | +10.6 +-2.3 |
| Tess Reilly | +33.4 +-3.5 | +18.3 +-2.6 | +17.9 +-2.6 | +18.6 +-2.6 | +18.1 +-2.6 |
| Cara Bello (raw, week 0) | +3.1 +-1.7 | +6.6 +-2.2 | +6.0 +-2.1 | +5.6 +-2.1 | +5.9 +-2.2 |
| Jade Yates (all-round, week 80) | +13.4 +-2.3 | +4.6 +-1.4 | +7.5 +-1.7 | +6.4 +-1.6 | +5.3 +-1.5 |
| **all five** | +16.8 +-1.2 | +10.4 +-1.0 | +11.0 +-1.0 | +10.7 +-1.0 | +10.3 +-1.0 |

per cell, READER minus FILE+SKILL 58 / minus BLIND (all boxers): presser +7.7 +-2.8 / +12.4 +-3.5; mover +10.9 +-3.3 / +26.0 +-4.3; counter +10.1 +-3.3 / +13.4 +-4.0; loader +3.9 +-2.6 / +16.0 +-3.8; fader +13.0 +-3.2 / +14.6 +-3.7; slow +13.4 +-3.3 / +19.3 +-4.1; body +10.4 +-3.2 / +17.9 +-4.0; switch +14.9 +-3.4 / +22.1 +-4.1; favourite +15.1 +-3.8 / +19.1 +-3.9; underdog +7.4 +-2.6 / +7.6 +-3.1

### (b) each coach minus BLIND - what a player who sims would gain if the game's own call were that coach
| boxer | FILE | FILE+SKILL 35 | FILE+SKILL 58 | FILE+SKILL 80 |
|---|---|---|---|---|
| Lucy Jackson | -2.9 +-2.0 | -3.8 +-2.1 | -2.9 +-2.1 | -2.4 +-2.1 |
| Samira Khan | +14.6 +-3.1 | +14.5 +-3.2 | +14.4 +-3.1 | +14.4 +-3.1 |
| Tess Reilly | +15.1 +-3.2 | +15.4 +-3.3 | +14.8 +-3.3 | +15.2 +-3.3 |
| Cara Bello (raw, week 0) | -3.4 +-2.1 | -2.9 +-2.1 | -2.5 +-2.1 | -2.7 +-2.1 |
| Jade Yates (all-round, week 80) | +8.8 +-1.9 | +5.9 +-1.7 | +7.0 +-1.7 | +8.1 +-1.9 |
| **all five** | +6.4 +-1.2 | +5.8 +-1.2 | +6.2 +-1.2 | +6.5 +-1.2 |

per cell, FILE minus BLIND (all boxers): presser +6.6 +-3.4; mover +17.6 +-4.3; counter +4.3 +-3.2; loader +11.4 +-4.1; fader +2.0 +-3.7; slow +5.3 +-3.5; body +8.3 +-3.7; switch +7.3 +-4.0; favourite +2.0 +-3.5; underdog -0.3 +-2.9

### Corners: share of between-round calls that were Reset (rest) / Hands up (hurt); file read right
| boxer | FILE | FILE+SKILL 35 | FILE+SKILL 58 | FILE+SKILL 80 |
|---|---|---|---|---|
| Lucy Jackson | rest 44% hands 19% right 100% | rest 39% hands 19% right 33% | rest 41% hands 19% right 61% | rest 43% hands 19% right 80% |
| Samira Khan | rest 41% hands 21% right 100% | rest 36% hands 21% right 36% | rest 37% hands 21% right 60% | rest 40% hands 21% right 80% |
| Tess Reilly | rest 41% hands 20% right 100% | rest 36% hands 19% right 34% | rest 37% hands 20% right 57% | rest 39% hands 20% right 78% |
| Cara Bello (raw, week 0) | rest 47% hands 21% right 100% | rest 42% hands 20% right 35% | rest 44% hands 20% right 57% | rest 45% hands 21% right 80% |
| Jade Yates (all-round, week 80) | rest 35% hands 9% right 100% | rest 26% hands 10% right 37% | rest 30% hands 9% right 62% | rest 33% hands 9% right 83% |
| **all five** | rest 42% hands 18% right 100% | rest 36% hands 18% right 35% | rest 38% hands 18% right 59% | rest 40% hands 18% right 80% |

Best fixed arm (a command held all bout, ring at Centre; the highest all-cell mean): c:reset; READER minus it +10.9 +-1.0; it minus FILE+SKILL 58 -0.2 +-1.0

### (c) bar 8 v BLIND: a command held all bout beats it by more than 10 in a cell? FAIL (2 cell-commands); top: reset v mover +14.9 +-4.2; get_out v loader +11.3 +-3.7; reset v body +9.4 +-3.9; reset v switch +7.3 +-4.0; reset v slow +7.0 +-3.6; body v mover +5.7 +-3.6

### (c) bar 8 v FILE+SKILL 58: a command held all bout beats it by more than 10 in a cell? PASS; top: reset v counter +2.0 +-3.1; reset v body +2.0 +-2.9; reset v fader +1.3 +-2.9; reset v slow +1.1 +-2.8; reset v switch +0.0 +-3.4; reset v favourite +0.0 +-3.3

### (d) bar 5 (base BLIND): the five boxers disagree (one over +1, one under -1) on 3 commands -> FAIL: body, hands, reset
| command | Lucy Jackson | Samira Khan | Tess Reilly | Cara Bello (raw, week 0) | Jade Yates (all-round, week 80) |
|---|---|---|---|---|---|
| body | -22.0 +-3.0 | +0.2 +-1.6 | +0.5 +-1.7 | -23.6 +-3.2 | +3.6 +-2.2 |
| levels | -7.9 +-1.9 | -1.9 +-3.0 | +0.0 +-2.9 | -9.1 +-2.0 | -0.6 +-1.6 |
| let_go | -42.6 +-3.3 | -34.1 +-3.5 | -33.4 +-3.4 | -43.5 +-3.3 | -30.1 +-3.1 |
| first | -27.6 +-2.9 | -15.1 +-3.6 | -17.5 +-3.6 | -24.4 +-2.8 | -14.3 +-2.5 |
| sit | -6.6 +-1.8 | -10.3 +-3.3 | -9.0 +-3.1 | -12.5 +-2.1 | -3.8 +-1.8 |
| hands | -4.1 +-1.9 | +1.8 +-3.1 | +5.5 +-3.0 | -6.0 +-1.9 | +3.3 +-1.8 |
| reset | -0.2 +-2.0 | +10.6 +-3.1 | +20.6 +-3.4 | -4.3 +-2.0 | +2.9 +-2.1 |
| get_out | -1.7 +-1.2 | -5.6 +-3.2 | -8.4 +-3.3 | -2.9 +-1.4 | -4.4 +-1.6 |

### (d) bar 5 (base FILE+SKILL 58): the five boxers disagree (one over +1, one under -1) on 2 commands -> FAIL: reset, get_out
| command | Lucy Jackson | Samira Khan | Tess Reilly | Cara Bello (raw, week 0) | Jade Yates (all-round, week 80) |
|---|---|---|---|---|---|
| body | -19.1 +-3.1 | -14.1 +-3.2 | -14.3 +-3.4 | -21.1 +-3.0 | -3.4 +-1.9 |
| levels | -5.1 +-2.3 | -16.2 +-3.5 | -14.8 +-3.3 | -6.6 +-2.2 | -7.6 +-1.9 |
| let_go | -39.7 +-3.2 | -48.5 +-3.4 | -48.2 +-3.4 | -41.0 +-3.2 | -37.1 +-3.3 |
| first | -24.8 +-3.0 | -29.4 +-3.7 | -32.3 +-3.7 | -21.9 +-2.9 | -21.3 +-2.9 |
| sit | -3.7 +-2.3 | -24.6 +-3.6 | -23.8 +-3.4 | -10.0 +-2.4 | -10.8 +-2.4 |
| hands | -1.3 +-2.3 | -12.6 +-2.5 | -9.3 +-2.4 | -3.5 +-2.1 | -3.7 +-1.6 |
| reset | +2.6 +-2.2 | -3.7 +-2.3 | +5.9 +-2.3 | -1.8 +-2.1 | -4.1 +-1.8 |
| get_out | +1.1 +-2.2 | -19.9 +-2.8 | -23.1 +-3.0 | -0.4 +-2.3 | -11.4 +-2.2 |

### (e) the coach's rating, when the player sims (paired: the 80 coach is right in every bout the 58 is)
| boxer | 58 - 35 | 80 - 58 | 80 - 35 |
|---|---|---|---|
| Lucy Jackson | +0.9 +-1.4 | +0.4 +-1.1 | +1.4 +-1.7 |
| Samira Khan | -0.1 +-1.1 | +0.1 +-0.9 | -0.1 +-1.4 |
| Tess Reilly | -0.6 +-1.2 | +0.4 +-1.1 | -0.2 +-1.6 |
| Cara Bello (raw, week 0) | +0.4 +-1.2 | -0.2 +-1.1 | +0.1 +-1.6 |
| Jade Yates (all-round, week 80) | +1.1 +-0.7 | +1.1 +-0.8 | +2.2 +-1.1 |
| **all five** | +0.3 +-0.5 | +0.4 +-0.4 | +0.7 +-0.7 |

### Wind at each bell (mean of the cells)
| arm | Lucy Jackson | Samira Khan | Tess Reilly | Cara Bello (raw, week 0) | Jade Yates (all-round, week 80) |
|---|---|---|---|---|---|
| BLIND | 69 49 34 22 14 7 | 56 23 1 0 0 0 | 56 24 1 0 0 0 | 68 47 31 19 10 3 | 72 54 42 32 25 19 |
| FILE | 61 34 28 28 26 24 | 61 34 29 27 25 23 | 61 35 30 29 26 24 | 60 32 25 25 25 23 | 64 39 37 30 28 30 |
| FILE+SKILL 58 | 63 37 28 28 28 26 | 64 38 30 28 25 24 | 64 39 31 29 27 26 | 62 36 26 26 26 24 | 66 42 37 31 29 32 |
| READER | 65 39 26 26 25 26 | 55 29 25 26 28 29 | 58 32 26 27 29 29 | 63 35 24 24 24 25 | 66 39 27 27 28 28 |
| c:reset | 67 44 31 28 28 28 | 63 38 27 27 28 28 | 64 39 28 28 29 29 | 66 42 29 26 26 27 | 70 49 36 31 31 31 |
| c:get_out | 67 43 26 12 3 0 | 63 40 23 10 2 0 | 63 41 25 11 3 0 | 66 42 23 9 1 0 | 70 48 34 21 12 5 |

## Population (command grades)
- Lucy Jackson (f, Out-boxer): body Poor, first Good, get_out Good, hands OK, let_go OK, levels Poor, reset OK, sit OK - Poor 2 / OK 4 / Good 2
- Samira Khan (f, Slugger): body Good, first OK, get_out OK, hands OK, let_go OK, levels OK, reset OK, sit Good - Poor 0 / OK 6 / Good 2
- Tess Reilly (f, Pressure fighter): body Good, first OK, get_out OK, hands OK, let_go OK, levels OK, reset Good, sit OK - Poor 0 / OK 6 / Good 2
- Cara Bello (raw, week 0) (f, Out-boxer): body Poor, first OK, get_out OK, hands OK, let_go OK, levels Poor, reset Poor, sit Poor - Poor 4 / OK 4 / Good 0
- Jade Yates (all-round, week 80) (f, Pressure fighter): body Good, first Good, get_out OK, hands Good, let_go Good, levels Good, reset Good, sit Good - Poor 0 / OK 1 / Good 7


## What the tables say (the reasons, from the arms)
- Why FILE gains (b) and why the rating buys nothing (e): the always-misreading coaches (35: right in 35% of bouts) land within
  0.6 of FILE at both lengths, so the file read itself is worth about 0. What FILE adds over BLIND is the corner minute: Reset under
  35 wind (24% of corners at 3 rounds, 42% at 6) and Hands up when hurt (16-18%). It is worth most where BLIND runs her dry: Samira and
  Tess end BLIND's 6-round bouts at 0 wind from the third bell, and end FILE's at 23-29.
- Why FILE costs Lucy and Cara: the six Boxer-puncher / Out-boxer cells read "boxes at range", and the file's answer is Go to the body.
  Both grade Poor at it, while BLIND gives them Jab and move (their technique is over their power). The FILE rule as written picks the
  best call against the game, not the best call for HER.
- Bar 8 (c) passes against FILE+SKILL 58 because its failures were BLIND's two holes, not command depth: Get out v the loader (BLIND
  says "body", the wrong call v loading up) and Reset at 6 rounds (BLIND never rests).
- Bar 5 (d) against BLIND now passes at 3 rounds with five boxers (4: body, levels, hands, reset). That is the two out-boxers'
  Poor "body" against the rest, not a new depth, and it falls to 1-2 commands on the honest baseline.

## Feedback loops (as the brief asked)
- Coach call -> edge -> the bout card's READ: `BoutRead.gd` l.216 `_call` returns `auto_corner` for rounds 2+. It feeds the round
  spend (l.202-203, the call's cost and `Combos.round_spend`), the call edge in `_game_edge_of` (l.233-237) and the body share
  and duel read (l.337, l.349).
  A FILE coach in the game would have to change `_call` to the same rule (with the wind line read from the forecast's bell
  energy, `a_end`, l.205-208), or the card's win chance would undersell the simmed bout by the table-(b) numbers. `BalanceHarness.gd` l.24,
  l.56 and `BoutNight._box_out` l.128 take the same blind call.
- Rest -> wind -> "your boxer is tired" -> rest: capped by one call a round and the 35 line. It rests in 42% of corners at 6 rounds,
  and its bells sit at 23-37: under the reader's +15, so no free recovery (Reset held 27-31, the reader 24-29).
- Rating -> right read: nothing feeds back inside a bout (one roll a bout).

## Honest limits
- 70 bouts a boxer, cell and arm (350 a cell and arm, 3,500 an arm and length): 2 SE about 1.0-1.3 over all, 1.4-3.5 a boxer,
  2.6-4.5 a cell.
- The POOR boxer is 4 Poor / 4 OK (the scouting draw cannot make a poorer woman); the GOOD one has 80 weeks of all-round training,
  further than any debut boxer. Women only; amateur rules, film 1, no tape study (so only the style word is on the file).
- The FILE coach is the brief's: the best call against the style's main game, read once before the bout. A coach who weighs HER grade
  (Lucy, Cara), or re-reads after round 1, or reads tape-found tells, was not measured (a new arm, not built after the run).
- SKILL's rule (rating / 100) is ours: the game has no rule from a coach's rating to how often his read is right.
- The FILE coach rests with the game's own "calm" from the corner: the game's wind rule, the same for BLIND. CORNERCMD2's
  HONEST fix applies to its commands only.
- The commands and the reader stand on BLIND's call underneath (as CORNERCMD2 left them). So READER minus a coach is the reader on the
  blind base against that coach. A live corner standing on a FILE coach's base was not measured.
- No ring call in any arm. The reader is CORNERCMD2's `reader_nr` (ring at Centre; CORNERCMD2 measured it +0.8 / +0.4 better than with the ring).

## Reproduce
Probe `tools/cornerbase1_probe.gd`, rules `tools/cornerbase1_rules.gd`, tables `tools/cornerbase1_sum.py`. Raw:
`E:/FightCamp/tmp/cornerbase1/` (`ctl`, `trial`, `diag`, `full_L3`, `full_L6`, `pop*`; outside the repo).
- control: `python ops/Tools/godot_slot.py run --who CORNERBASE1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/cornerbase1_probe.gd -- stage=trial coaches=0 arms=plan,reader,file cells=presser lens=3 n=70 boxers=2 out=<jsonl>`
- trial: `... -- stage=trial cells=loader lens=3,6 n=20 only=1 out=<jsonl>`; the call check `... arms=plan,file,skill0,skill35,skill80 cells=loader,presser lens=3`
- full (11 + 20 min on one slot): `... -- stage=full lens=3 n=70 out=full_L3.jsonl`, then `lens=6` -> `full_L6.jsonl`
- population search: `... -- stage=pop boxers=5 draws=2000 pick=0,0` (prints the draws picked: [49, 1249])
- tables: `python tools/cornerbase1_sum.py full_L3.jsonl full_L6.jsonl`
