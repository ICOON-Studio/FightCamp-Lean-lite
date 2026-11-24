# CORNERCMD2 result - the corner commands, round 2 (S545)

**Verdict: FAIL - bars 5, 6 and 8 fail again at both lengths. STOP RULE applies (no round 3 from this page).**
What round 2 fixed: the free recovery is gone (Reset held now ends its rounds at 27-29 wind, like the reader, not 67-81;
Get out held runs dry like PLAN ONLY), bar 3 passes at both lengths, and the reader still pays far over the line:
**+14.6 +-1.7** (3 rounds) and **+22.2 +-1.8** (6 rounds) wins in 100 over PLAN ONLY, **+16.2 / +11.3** over the best fixed pair.
Bars 1, 2, 3, 4, 7 and 9 pass at both lengths.
What still fails, for the coordinator (facts, not a round 3):
- **Bar 8**: Get out of there held against the loader, +18.6 (3 rounds) and +20.2 (6 rounds); Reset held at 6 rounds against
  the mover +17.9, loader +14.3, body puncher +13.8, slow starter +11.9, switch-hitter +11.7; Hands up held against the loader at
  6 rounds +12.1. None of these is free wind any more (below). They are PLAN ONLY's own hole: its one call comes from our
  boxer's stats only (`BoutRules.auto_corner`: "Go to the body" for Samira and Tess), and "Go to the body" is the WRONG call
  against a man who loads up (`Exchanges.MODES.loadup.wrong`). Get out against the loader is +28.6 / +33.6 for Samira and
  +24.3 / +27.9 for Tess, but +2.9 / -0.7 for Lucy, whose plan call is "Jab and move". At 6 rounds PLAN ONLY has no rest call
  at all and Samira and Tess are at 0 wind from the third bell (half of the loader cell's exchanges are "your boxer is tired"),
  so any command that says "breathe" when she is tired beats it.
- **Bar 6**: Cut the ring off is never the right ring stop held (worse than Centre in all 10 cells, -1.4 to -11.9);
  Stay away from the ropes is right in 0 cells at 3 rounds and 4 at 6 rounds (presser +2.6, favourite +2.4, switch +1.2,
  body +0.7, all inside 2 SE). As MOMENT answers the ring is worth nothing either: the reader with the ring held at Centre
  does **+0.8 +-0.8** (3 rounds) and **+0.4 +-0.6** (6 rounds) BETTER than the same reader using it. Section "For the owner" below.
- **Bar 5**: at least two of the three boxers disagree on 3 commands at 3 rounds (Go to the body, Hands up, Reset) and on 1
  at 6 rounds (Hands up); 4 needed. Diagnosis below: the engine follows the grades, the population's grades are close, and a
  command held all bout is set by its wrong moments more than by the grade.

Design page with round 2's table (written before any run): `ops/research/DESIGN_CORNERCMD1.md` "Round 2". Probe
`tools/cornercmd2_probe.gd` (the four changes as flags `ch=1,2,3,4`; `ch=0` = round 1), rules `tools/cornercmd2_rules.gd`,
tables `tools/cornercmd2_sum.py` (`python tools/cornercmd2_sum.py <jsonl> bars` / `ring8`). Raw: `E:/FightCamp/tmp/cornercmd2/`
(`full.jsonl`, `ctl`, `ch2only`, `ch0four`, `readernr`, `loo1..4`; outside the repo). Nothing under scripts/ or tests/ changed.

## Control first (STOP check): all four off reproduces round 1

`ch=0`, the presser at 3 rounds, Lucy and Samira, 70 bouts each, PLAN ONLY and the reader: **all 280 bouts identical** to
round 1's `full.jsonl` (wins 45 / 59 / 36 / 41 of 70, the same outcome string bout by bout). The four step-0 cells at both
lengths with all four off (`ch0four`) reproduce round 1's bar-8 numbers exactly (Get out v presser +13.6, v loader +23.9 at 6;
Reset v mover +14.6 at 6).

## The nine bars, round 1 -> round 2 (10 cells; round 1 two boxers x 70, round 2 three boxers x 70 = 210 a cell and arm; 138,600 bouts)

| Bar | 3 rounds: round 1 -> round 2 | 6 rounds: round 1 -> round 2 |
|---|---|---|
| (1) no fixed arm best in more than 6 of 10 cells | PASS (Get out 5) -> **PASS** (PLAN ONLY 4) | PASS (Reset 6) -> **PASS** (Reset + Cut 5) |
| (2) reader - best fixed pair >= 3; reader - PLAN ONLY >= 5 | PASS +10.3 / +9.7 -> **PASS +16.2 +-1.7 / +14.6 +-1.7** | PASS +13.3 / +18.2 -> **PASS +11.3 +-1.2 / +22.2 +-1.8** |
| (3) 8 of 10 commands are the reader's pick in 5%+ | FAIL 7 -> **PASS 8** (Let your hands go 3%, Hands up 4%) | PASS 9 -> **PASS 8** (Let your hands go 3%, Hands up 3%) |
| (4) the worst command held loses 4+ in 6+ cells | PASS 10 -> **PASS 10** | PASS 10 -> **PASS 10** |
| (5) the boxers disagree on 4+ commands | FAIL 2 -> **FAIL 3** (body -24.3 / +1.3 / +1.9; hands -8.9 / +3.1 / +5.6; reset -10.1 / +2.0 / +5.3) | FAIL 2 -> **FAIL 1** (hands -4.1 / +1.8 / +5.5) |
| (6) Cut and Ropes each the right ring stop in 2+ cells | FAIL (Centre 9, Ropes 1) -> **FAIL (Centre 10)** | FAIL (Centre 9, Ropes 1) -> **FAIL (Centre 6, Ropes 4, Cut 0)** |
| (7) always Let your hands go / Sit down 3+ cells behind with worse wind or head | PASS 10 / 10 -> **PASS 10 / 10** | PASS 10 / 10 -> **PASS 10 / 10** |
| (8) no command held adds more than 10 in any cell | FAIL +13.6 (Get out, presser) -> **FAIL +18.6 (Get out, loader)** | FAIL +23.9 (Get out, loader) -> **FAIL +20.2 (Get out, loader)**; Reset over 10 in 5 cells |
| (9) coach at 75 within 3 of the reader, at 40 3+ behind (tuned rule) | PASS -0.4 / -10.3 -> **PASS -0.4 +-0.4 / -9.4 +-1.6** | PASS -0.7 / -9.0 -> **PASS -0.6 +-0.6 / -7.5 +-1.1** |

The two new prints:
- **Wind at every bell, Reset held** (mean of cells; Lucy / Samira / Tess, 6 rounds): 67 44 31 28 28 28 / 63 38 27 27 28 28 /
  64 39 28 28 29 29 - round 1 had 81 78 79 76 73 68. **STOP flag clear: it drops under 60** (lowest bell mean 27). The reader:
  64 37 26 26 26 25 / 54 28 25 26 28 29 / 57 31 26 27 29 29. RESET CHECK: Reset held is at most +12 over the reader's wind at any
  bell (must be under +15: PASS); it beats PLAN ONLY by more than 10 in 5 cells at 6 rounds (FAIL, the bar-8 cells above).
- **Wind at every bell, Get out held**: 67 43 26 12 3 0 (Lucy) / 63 40 23 10 2 0 / 63 41 25 11 3 0 - it runs dry like PLAN ONLY
  (69 49 34 22 14 7 / 56 23 1 0 0 0). STOP flag clear.
- **Cut held against the mover, our wind at each bell** (6 rounds): Lucy 67 43 27 14 6 0; Samira and Tess 53-54 18 0 0 0 0.
- **Ring stop held, per cell** (wins in 100 over Centre): see the two tables below.

## What each change moved (leave-one-out: the same dice, 35 bouts a boxer and cell, the arms the change is aimed at; "off" = the other three on)

1. **Honest wind** - Reset held's bells **79 77 79 76 73 68 -> 65 40 28 28 28 28**; Get out held's last bell 7 -> 0; Get out held over
   PLAN ONLY (all cells) +2.6 -> -0.8 (3 rounds), -0.2 -> -5.3 (6 rounds). But Reset held over PLAN ONLY went UP at 6 rounds,
   +8.0 -> +11.0: with the refill only when tired, the corner's minute no longer sends her out on "calm" (`Combos.round_spend`
   0.8 of the punches) and she boxes on the plan's call when fresh. The free recovery is gone; the bar-8 gain stayed.
2. **Round 1 has a call** - on its own (`ch=2` v `ch=0`, the four step-0 cells, 140 bouts a cell): **Get out v the presser at 3
   rounds +13.6 -> +9.3 (it removes 4.3 of the +13.6)**; v the loader +12.9 -> +15.0 at 3 rounds and +23.9 -> +20.4 at 6; Reset v
   the mover +14.6 -> +15.0 at 6. With the other three on, off -> on moves the reader +14.3 -> +14.9 (3) and +20.7 -> +19.7 (6),
   inside the noise.
3. **The ring moves the fight** - best ring stop by cell (35 bouts) off -> on: 3 rounds Centre 9 + Ropes 1 -> Centre 10; 6 rounds
   Centre 6 + Ropes 2 + Cut 2 -> Centre 5 + Ropes 5 (the full 70 bouts: Centre 6, Ropes 4). Ropes held -2.0 -> -1.5 (3) and
   -1.8 -> +0.0 (6); Cut held -5.9 -> -5.4 (3) and -2.3 -> -4.3 (6). The mechanism fires (Stay away from the ropes moved 65 of the
   rope exchanges in the 60-bout trial, Cut put 139 on the opponent's count) but it is worth about nothing at the score.
4. **Grades wider + the loading-up rule** - the reader over PLAN ONLY **+11.7 -> +14.9** (3 rounds) and +17.4 -> +19.7 (6): the
   reader's own boxer's commands pay more. Bar 5 on the 35-bout subset: 3 -> 4 at 3 rounds (Go to the body joins), 2 -> 2 at 6.
   The reader's Be first share at loading up 9% -> 14% (3), Hands up unchanged at 3-4%: only Tess's own answer is Hands up.

## For the owner: the ring slot (bar 6 failed twice - STOP RULE)

Two rounds, two rule sets (round 1 a flat edge; round 2 the ring moving the fight: the opponent's ropes count and his range game
for Cut, our ropes count and the own-ropes card for Stay away), the same answer:
- **Held** (the slider left on one stop all bout), Cut the ring off is never right: worse than Centre in every cell, -1.4 to -11.9
  wins in 100, also against the mover it is for (-1.4 at 3 rounds, -3.6 at 6). Stay away from the ropes is never more than +2.6
  (the presser at 6 rounds) and loses up to -3.8 (the mover). Centre is the best stop in 10 of 10 cells at 3 rounds, 6 at 6.
- **As moment answers** (the reader slides it every exchange): the reader picks Cut 21-33% and Ropes 20-31% of the exchanges a
  command is on, and is **+0.8 +-0.8 / +0.4 +-0.6 better WITHOUT the ring** (same dice, 2,100 bouts a length).
- Why (code read): the place is already decided by the duel ladder and the plan's steps (`RingDuel.step`, `StepWire`); a rope
  exchange is +-5 points (`PlaceEdge.ROPES`) and comes every third count, so a command that adds to a count is worth about 1
  point an exchange - and Cut also takes away the opponent's range game, the moment where our boxers' best call ("Go to the
  body") lives, so the boxers it should help lose their best moments.

The question for him, with these numbers: **cut it as a held slider, keep the two ring calls as moment answers, or cut both.**
On these numbers the moment answers measured +0 (worse by 0.4-0.8, inside the noise), so "keep them as moment answers" would be
kept for the look of the corner, not for depth. (Claude's recommendation, as the developer: cut both from the corner; the ring
stays where it already pays, the plan's step lines - STEPPAY4's cut_off +4.75 against the Out-boxer.)

## Bar 5 (failed twice - STOP RULE): too-close grades or an engine that ignores them?

Grades per command (word, multiplier after change 4) and the edge a best moment gives (17 x mult x heard):

| command | Lucy Jackson (Out-boxer, heard 0.95) | Samira Khan (Slugger, 0.86) | Tess Reilly (Pressure fighter, 0.81) |
|---|---|---|---|
| Go to the body | Poor 0.25 -> 4.0 | Good 1.25 -> 18.2 | Good 1.25 -> 17.2 |
| Change levels | Poor 0.25 -> 4.0 | OK 0.76 -> 11.1 | OK 1.25 (61.99) -> 17.1 |
| Let your hands go | OK 1.12 -> 18.1 | OK 0.60 -> 8.7 | OK 0.78 -> 10.7 |
| Be first | Good 1.25 -> 20.2 | OK 0.72 -> 10.5 | OK 0.62 -> 8.5 |
| Sit down | OK 1.10 -> 17.8 | Good 1.25 -> 18.2 | OK 1.04 -> 14.3 |
| Hands up | OK 0.80 -> 12.9 | OK 0.60 -> 8.7 | OK 0.77 -> 10.6 (her own at loading up) |
| Reset | OK 0.60 -> 9.7 | OK 0.60 -> 8.7 | Good 1.25 -> 17.2 |
| Get out of there | Good 1.25 -> 20.2 | OK 0.60 -> 8.7 | OK 0.60 -> 8.2 |
| ring Cut / Ropes | Poor / Good | OK / Poor | OK / Poor |

**Both, and the bar's instrument as well:**
- The engine does NOT ignore the grades: where the grades differ, the held results split by them - Go to the body Poor (Lucy,
  4.0) v Good (Samira, Tess, 17-18): held -24.3 v +1.3 / +1.9 (3 rounds), -22.0 v +0.2 / +0.5 (6); Reset Good (Tess) v OK: +20.6
  v -0.2 / +10.6 at 6 rounds; and the reader, who uses each boxer's own commands, is worth +9.4 (Lucy), +23.9 (Samira), +33.3
  (Tess) at 6 rounds.
- The grades ARE close in this population: of the 24 fight grades, 15 are OK, 2 Poor (both Lucy's), 7 Good; for five of the
  eight commands no boxer is Poor. Three boxers built by the same week-4 training (TELLPLAY1's types) are not far apart.
- And held all bout, a command's sign is set by its wrong moments, not by the grade: Let your hands go, Be first and Sit down
  held lose 7 to 43 for every boxer whatever her grade (they are wrong in a third of the moments and cost wind). Bar 5 asks a
  held command to be positive for one boxer; only commands with almost no wrong moment against a cell's game can be.

## Bar 8 (failed twice - STOP RULE): the command and the cells, no further tuning

Over +10 on PLAN ONLY, held all bout (210 bouts a cell, +- 2 SE): 3 rounds - **Get out of there v the loader +18.6 +-5.4**.
6 rounds - **Get out of there v the loader +20.2 +-5.7**, **Reset v the mover +17.9 +-6.0, v the loader +14.3, v the body
puncher +13.8, v the slow starter +11.9, v the switch-hitter +11.7**, **Hands up v the loader +12.1 +-5.8**. Read above: the
opponent (Slugger, "walks in straight") plays loading up or pressing in 1,571 of the 2,683 exchanges where our boxer is neither tired
nor hurt (6 rounds, PLAN ONLY), the plan's call for
Samira and Tess is the wrong one there, and at 6 rounds the plan never rests a boxer who is out of wind.

## Per cell, 3 rounds (wins in 100, (difference over PLAN ONLY +- 2 SE); three boxers, 210 bouts a cell and arm)

| cell | plan | push45 | reader | coach40 | coach58 | coach75 | alt | best single | worst single | best pair |
|---|---|---|---|---|---|---|---|---|---|---|
| presser | 60.5 | 62.9 (+2.4+-3.9) | 74.3 (+13.8+-5.1) | 66.2 (+5.7+-3.7) | 68.1 (+7.6+-5.5) | 73.8 (+13.3+-5.1) | 53.3 (-7.1+-5.4) | c:get_out 67.6 (+7.1+-4.5) | c:let_go 33.3 (-27.1+-6.3) | p:get_out+ropes 67.6 (+7.1+-4.7) |
| mover | 53.3 | 53.3 (+0.0+-4.7) | 70.5 (+17.1+-5.6) | 60.5 (+7.1+-4.5) | 63.8 (+10.5+-4.6) | 70.5 (+17.1+-5.7) | 53.3 (+0.0+-4.7) | c:body 60.0 (+6.7+-3.9) | c:let_go 32.4 (-21.0+-5.9) | p:reset+cut 56.2 (+2.9+-5.7) |
| counter | 61.0 | 60.5 (-0.5+-4.4) | 71.4 (+10.5+-5.2) | 66.2 (+5.2+-3.4) | 70.0 (+9.0+-5.0) | 70.0 (+9.0+-5.2) | 55.2 (-5.7+-5.3) | c:reset 60.0 (-1.0+-5.0) | c:let_go 32.9 (-28.1+-6.5) | p:reset+cut 58.6 (-2.4+-5.1) |
| loader | 61.4 | 59.0 (-2.4+-4.1) | 77.1 (+15.7+-5.0) | 69.0 (+7.6+-3.9) | 74.3 (+12.9+-4.8) | 77.1 (+15.7+-5.0) | 60.5 (-1.0+-5.4) | c:get_out 80.0 (+18.6+-5.4) | c:let_go 35.7 (-25.7+-6.3) | p:get_out+ropes 79.0 (+17.6+-5.4) |
| fader | 67.1 | 66.7 (-0.5+-4.6) | 74.3 (+7.1+-5.7) | 71.9 (+4.8+-4.2) | 72.4 (+5.2+-5.6) | 73.8 (+6.7+-5.7) | 56.2 (-11.0+-5.9) | r:ropes 64.8 (-2.4+-3.7) | c:let_go 32.4 (-34.8+-6.7) | p:get_out+ropes 60.5 (-6.7+-5.7) |
| slow | 60.5 | 60.0 (-0.5+-5.0) | 75.2 (+14.8+-5.4) | 63.8 (+3.3+-3.9) | 69.5 (+9.0+-5.0) | 74.3 (+13.8+-5.3) | 51.4 (-9.0+-5.2) | c:reset 58.6 (-1.9+-5.4) | c:let_go 31.4 (-29.0+-6.4) | p:hands+ropes 57.1 (-3.3+-4.8) |
| body | 49.0 | 51.0 (+1.9+-4.3) | 69.5 (+20.5+-5.7) | 56.7 (+7.6+-4.8) | 65.2 (+16.2+-5.3) | 69.5 (+20.5+-5.7) | 48.6 (-0.5+-5.0) | c:reset 54.8 (+5.7+-5.8) | c:let_go 31.0 (-18.1+-6.0) | p:reset+ropes 53.3 (+4.3+-5.9) |
| switch | 52.4 | 55.7 (+3.3+-5.1) | 71.0 (+18.6+-5.4) | 55.2 (+2.9+-4.3) | 63.3 (+11.0+-4.9) | 69.5 (+17.1+-5.2) | 48.6 (-3.8+-5.4) | c:hands 56.2 (+3.8+-5.4) | c:let_go 27.6 (-24.8+-6.8) | p:hands+ropes 52.4 (+0.0+-5.1) |
| favourite | 46.2 | 48.1 (+1.9+-3.8) | 63.8 (+17.6+-5.6) | 52.4 (+6.2+-4.5) | 60.0 (+13.8+-5.1) | 64.3 (+18.1+-5.7) | 40.0 (-6.2+-5.2) | c:hands 47.6 (+1.4+-5.8) | c:let_go 23.8 (-22.4+-6.2) | p:hands+ropes 44.8 (-1.4+-5.5) |
| underdog | 73.3 | 71.0 (-2.4+-3.7) | 83.3 (+10.0+-5.0) | 74.8 (+1.4+-2.9) | 79.0 (+5.7+-4.4) | 83.3 (+10.0+-5.0) | 65.2 (-8.1+-4.8) | r:ropes 72.4 (-1.0+-2.7) | c:let_go 42.4 (-31.0+-6.5) | p:hands+ropes 71.9 (-1.4+-5.0) |

## Per cell, 6 rounds

| cell | plan | push45 | reader | coach40 | coach58 | coach75 | alt | best single | worst single | best pair |
|---|---|---|---|---|---|---|---|---|---|---|
| presser | 64.5 | 66.4 (+1.9+-4.7) | 84.0 (+19.5+-5.1) | 77.6 (+13.1+-5.4) | 80.7 (+16.2+-5.0) | 84.0 (+19.5+-5.1) | 61.2 (-3.3+-5.3) | c:reset 73.3 (+8.8+-5.5) | c:let_go 27.1 (-37.4+-6.3) | p:reset+cut 74.0 (+9.5+-5.2) |
| mover | 50.0 | 49.5 (-0.5+-4.7) | 79.5 (+29.5+-6.1) | 68.8 (+18.8+-6.4) | 75.0 (+25.0+-6.1) | 78.1 (+28.1+-6.1) | 56.0 (+6.0+-5.1) | c:reset 67.9 (+17.9+-6.0) | c:let_go 14.3 (-35.7+-5.7) | p:reset+cut 70.2 (+20.2+-6.1) |
| counter | 65.2 | 63.6 (-1.7+-4.5) | 82.9 (+17.6+-5.7) | 76.2 (+11.0+-5.4) | 80.2 (+15.0+-5.4) | 83.1 (+17.9+-5.7) | 64.3 (-1.0+-5.0) | c:reset 74.0 (+8.8+-4.9) | c:let_go 24.5 (-40.7+-6.3) | p:reset+ropes 73.3 (+8.1+-4.9) |
| loader | 58.1 | 56.9 (-1.2+-4.9) | 85.0 (+26.9+-5.8) | 76.4 (+18.3+-5.9) | 83.1 (+25.0+-5.8) | 84.5 (+26.4+-5.9) | 65.0 (+6.9+-5.7) | c:get_out 78.3 (+20.2+-5.7) | c:let_go 27.1 (-31.0+-5.7) | p:get_out+ropes 78.6 (+20.5+-5.7) |
| fader | 63.1 | 61.0 (-2.1+-4.8) | 83.8 (+20.7+-5.7) | 74.3 (+11.2+-5.8) | 81.2 (+18.1+-5.6) | 83.3 (+20.2+-5.7) | 59.0 (-4.0+-6.0) | c:reset 69.5 (+6.4+-5.5) | c:let_go 18.8 (-44.3+-6.5) | p:reset+cut 69.3 (+6.2+-5.8) |
| slow | 58.1 | 59.3 (+1.2+-4.9) | 83.1 (+25.0+-5.7) | 74.0 (+16.0+-5.8) | 77.6 (+19.5+-5.5) | 81.7 (+23.6+-5.7) | 57.6 (-0.5+-4.8) | c:reset 70.0 (+11.9+-5.1) | c:let_go 18.8 (-39.3+-5.8) | p:reset+cut 70.0 (+11.9+-5.2) |
| body | 55.7 | 54.8 (-1.0+-5.4) | 78.8 (+23.1+-5.9) | 74.5 (+18.8+-5.7) | 77.1 (+21.4+-5.8) | 77.6 (+21.9+-5.9) | 54.8 (-1.0+-5.1) | c:reset 69.5 (+13.8+-5.7) | c:let_go 21.2 (-34.5+-6.8) | p:reset+cut 70.2 (+14.5+-5.8) |
| switch | 51.4 | 50.7 (-0.7+-5.4) | 77.6 (+26.2+-5.8) | 68.8 (+17.4+-5.7) | 73.6 (+22.1+-5.4) | 77.1 (+25.7+-5.7) | 51.7 (+0.2+-5.3) | c:reset 63.1 (+11.7+-5.8) | c:let_go 18.6 (-32.9+-6.6) | p:reset+cut 64.3 (+12.9+-5.8) |
| favourite | 47.4 | 51.2 (+3.8+-4.9) | 70.5 (+23.1+-5.6) | 62.6 (+15.2+-5.2) | 66.4 (+19.0+-5.4) | 69.3 (+21.9+-5.5) | 44.8 (-2.6+-4.5) | c:reset 56.0 (+8.6+-5.2) | c:let_go 13.1 (-34.3+-6.0) | p:reset+cut 56.0 (+8.6+-5.2) |
| underdog | 80.7 | 77.4 (-3.3+-4.0) | 90.7 (+10.0+-4.3) | 87.6 (+6.9+-4.3) | 89.5 (+8.8+-4.2) | 91.0 (+10.2+-4.4) | 76.0 (-4.8+-4.6) | c:reset 82.1 (+1.4+-4.2) | c:let_go 43.6 (-37.1+-6.1) | p:reset+cut 83.8 (+3.1+-4.4) |

## Held all bout, per boxer (over PLAN ONLY, all ten cells)

| command | 3 rounds: Lucy / Samira / Tess | 6 rounds: Lucy / Samira / Tess |
|---|---|---|
| c:body | -24.3+-3.5 / +1.3+-1.1 / +1.9+-1.2 | -22.0+-3.0 / +0.2+-1.6 / +0.5+-1.7 |
| c:levels | -11.6+-2.9 / -1.3+-2.6 / -0.7+-2.8 | -7.9+-1.9 / -1.9+-3.0 / +0.0+-2.9 |
| c:let_go | -33.3+-3.6 / -21.7+-3.4 / -23.6+-3.4 | -42.6+-3.3 / -34.1+-3.5 / -33.4+-3.4 |
| c:first | -5.7+-3.0 / -11.6+-3.2 / -16.3+-3.2 | -27.6+-2.9 / -15.1+-3.6 / -17.5+-3.6 |
| c:sit | -7.3+-2.5 / -12.0+-3.2 / -12.9+-2.8 | -6.6+-1.8 / -10.3+-3.3 / -9.0+-3.1 |
| c:hands | -8.9+-2.8 / +3.1+-2.8 / +5.6+-2.9 | -4.1+-1.9 / +1.8+-3.1 / +5.5+-3.0 |
| c:reset | -10.1+-2.7 / +2.0+-3.0 / +5.3+-3.3 | -0.2+-2.0 / +10.6+-3.1 / +20.6+-3.4 |
| c:get_out | +1.0+-1.5 / +0.9+-3.1 / -2.9+-3.3 | -1.7+-1.2 / -5.6+-3.2 / -8.4+-3.3 |
| r:cut | -5.1+-1.9 / -5.4+-2.0 / -6.9+-2.1 | -5.3+-1.4 / -4.8+-2.6 / -5.8+-2.8 |
| r:ropes | -1.6+-1.6 / -1.6+-1.2 / -1.4+-1.1 | -1.0+-1.2 / +0.1+-1.7 / +0.6+-1.9 |
| push45 | +1.7+-2.1 / +1.6+-2.6 / -2.3+-2.5 | -1.9+-1.6 / -0.5+-3.0 / +1.4+-3.1 |
| reader | +7.3+-2.4 / +13.6+-2.9 / +22.9+-3.3 | +9.4+-2.0 / +23.9+-3.3 / +33.3+-3.5 |
| alt | -11.0+-2.8 / -3.0+-2.9 / -1.7+-2.9 | -4.7+-2.1 / -5.1+-2.9 / +8.6+-3.2 |

## The ring stop held, per cell (wins in 100; Centre = PLAN ONLY)

3 rounds

| cell | Centre | Cut the ring off | Stay away from the ropes | right stop | by |
|---|---|---|---|---|---|
| presser | 60.5 | 53.3 (-7.1+-3.8) | 60.5 (+0.0+-1.4) | Centre | +0.0 |
| mover | 53.3 | 51.9 (-1.4+-2.5) | 49.5 (-3.8+-3.0) | Centre | +1.4 |
| counter | 61.0 | 58.1 (-2.9+-2.7) | 59.5 (-1.4+-1.6) | Centre | +1.4 |
| loader | 61.4 | 49.5 (-11.9+-4.5) | 61.0 (-0.5+-1.7) | Centre | +0.5 |
| fader | 67.1 | 57.6 (-9.5+-4.5) | 64.8 (-2.4+-3.7) | Centre | +2.4 |
| slow | 60.5 | 55.2 (-5.2+-3.4) | 57.6 (-2.9+-2.7) | Centre | +2.9 |
| body | 49.0 | 44.3 (-4.8+-3.2) | 49.0 (+0.0+-1.9) | Centre | +0.0 |
| switch | 52.4 | 48.1 (-4.3+-4.1) | 50.0 (-2.4+-2.1) | Centre | +2.4 |
| favourite | 46.2 | 42.4 (-3.8+-3.0) | 45.2 (-1.0+-2.3) | Centre | +1.0 |
| underdog | 73.3 | 66.2 (-7.1+-3.8) | 72.4 (-1.0+-2.7) | Centre | +1.0 |

6 rounds

| cell | Centre | Cut the ring off | Stay away from the ropes | right stop | by |
|---|---|---|---|---|---|
| presser | 64.5 | 59.5 (-5.0+-4.6) | 67.1 (+2.6+-2.5) | Ropes | +2.6 |
| mover | 50.0 | 46.4 (-3.6+-4.2) | 48.3 (-1.7+-3.3) | Centre | +1.7 |
| counter | 65.2 | 59.8 (-5.5+-4.0) | 64.0 (-1.2+-2.2) | Centre | +1.2 |
| loader | 58.1 | 50.2 (-7.9+-4.7) | 56.7 (-1.4+-3.5) | Centre | +1.4 |
| fader | 63.1 | 55.5 (-7.6+-4.5) | 62.6 (-0.5+-2.8) | Centre | +0.5 |
| slow | 58.1 | 55.5 (-2.6+-3.9) | 57.4 (-0.7+-2.4) | Centre | +0.7 |
| body | 55.7 | 48.8 (-6.9+-4.3) | 56.4 (+0.7+-3.4) | Ropes | +0.7 |
| switch | 51.4 | 49.3 (-2.1+-3.8) | 52.6 (+1.2+-3.2) | Ropes | +1.2 |
| favourite | 47.4 | 44.5 (-2.9+-4.5) | 49.8 (+2.4+-2.7) | Ropes | +2.4 |
| underdog | 80.7 | 71.9 (-8.8+-4.5) | 78.3 (-2.4+-3.1) | Centre | +2.4 |

## The one-rep trial and the walks

- All four off: 280 of 280 bouts as round 1 (above). All four on, one bout a cell, arm and boxer (1,980 bouts): no arm equals PLAN
  ONLY in every cell (every command changes something); Stay away from the ropes cleared 65 rope exchanges, Cut put 139 on the
  opponent's count.
- Walks (exchange by exchange, `stage=walk`): Lucy v the mover, reader, 3 rounds - round 1 opens on her plan's call ("Jab and
  move", wrong at range: -14.3), the reader takes Be first / Get out / Cut and Reset only once she is tired (round 3, wind 31):
  edge 9.7 there, nothing earlier. Cut held: its wrong moments read -4.8 (press, Lucy Poor x commit 1.0), right moments 0 at the
  edge, as designed. Reset held v the presser, 6 rounds: the refill only on she_tired exchanges.

## Feedback loops (checked)

- Command -> edge -> won exchange -> a better moment: capped by bar 8, which fails on matchups (above), not on a loop.
- Reset when tired -> wind back -> not tired -> no refill: works as designed - Reset held now sits at the reader's wind (27-29 at
  every bell from the third), never over +12 of it.
- Cut -> his room -> more rope exchanges -> our wind: Cut held v the mover ends at 0 wind by the third bell for Samira and Tess
  (0.5 an exchange on top of their own drain); the loop is capped by the tank, and Cut does not pay anyway.
- Alternating Let your hands go / Reset ("alt") stays far behind the reader: -19.8 +-1.8 (3) and -22.6 +-1.6 (6).
- Grades wider -> the player trains what pays: outside this probe (training is not simulated here).

## Honest limits

- 210 bouts a cell and arm (three boxers x 70): 2 SE is 4-6 points on one cell, 1.2-1.8 over all cells. The leave-one-out runs
  are 35 bouts a boxer and cell (2 SE about 2.2-2.5 over all cells): they size each change, they do not decide a bar.
- Three boxers, all women from TELLPLAY1's week-4 types (Lucy Jackson Out-boxer, Samira Khan Slugger, Tess Reilly Pressure
  fighter - Tess picked as the third because she is another style and the only woman whose own answer at loading up is Hands
  up), one coach (58) writing the plan, film 1, amateur rules, opponents of their own sex and class re-styled by cell.
- PLAN ONLY's call is `BoutRules.auto_corner` (stats only). Two bar-8 failures are that call being wrong against the loader;
  with a plan call from the opponent's file the bar would read differently (round 1's diagnostic `stage=fix` tried it under the
  old wind; not re-run here - the STOP rule forbids a round-3 rule).
- The commands are local rules (`tools/cornercmd2_rules.gd`); round 1's limits on them stand (a command with a built call shouts
  it every exchange; a new command takes its edge on the base; head only on a lost 30 s).
- Change 2 opens round 1 by copying `fight_step("start")`'s steps in the probe with the plan's call; the game itself still opens
  round 1 on no call (`BoutNight.gd` l.77).

## Reproduce

`python ops/Tools/godot_slot.py run --who CORNERCMD2 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/cornercmd2_probe.gd -- stage=full n=70 lens=3,6 out=<jsonl>`
(77 min on one slot); control `stage=trial ch=0 arms=plan,reader cells=presser lens=3 n=70 boxers=2 coach_a=0 coach_b=100`;
change 2 alone `stage=full ch=2 boxers=2 cells=presser,mover,counter,loader arms=<plan + the ten singles>,reader` (and `ch=0`);
ring as moment answers `arms=plan,reader,reader_nr`; leave-one-out `n=35 ch=<three of 1,2,3,4> arms=<the change's arms>`.
