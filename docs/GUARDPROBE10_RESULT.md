# GUARDPROBE10 - guard v9, the guard lines follow the opponent: FAIL twice, on one bar (S537)

Brief: `ops/research/TASK_GUARDREV9.md`. Map: `ops/research/DESIGN_GUARDDMG1_V9.md`. Probe: `tools/guardprobe10.gd` (measurement only, nothing under
scripts/ edited). Two runs on 2026-11-22, both through `godot_slot.py`: run 1 (the sizes and bars written before it, 32,484 bouts, 1,164 s) and
run 2, the one resize the brief allows (32,484 bouts, 1,266 s). This page is the summary and then the two generated pages as the probe wrote them.

## What it means, in plain words
- **The cause probe 9 named is fixed.** With the guard only on the opponent's moments, no answer wins everywhere any more: the most any
  one guard-and-stance pair is best is 3 of 10 opponent cells (probe 9: 6, then 7). The High guard is the answer against the Slugger,
  Elbows in against the Pressure fighter and the Volume puncher, the Light guard against the Out-boxer; against the Counter-puncher
  nothing clearly beats writing no guard line.
- **For every one of the seven boxers the best guard changes with the opponent, far outside the noise** (7 of 7, both runs). Tess: the
  Light guard against the Out-boxer (+14 wins in 100 over no line), Elbows in against the Pressure fighter (+17), the High guard on a
  moved stance against the Slugger (+17.5). The same guard is right against one man and wrong against the next.
- **The boxer's feet still decide which guard is his.** The two Narrow boxers live on the Light guard, the two Wide boxers on the High
  guard, the three Shoulder boxers on Elbows in; each leaves it only against the opponent another guard is built for.
- **A guard line still costs something**: the same line with its feet priced is 4.0 wins in 100 under the line free (4.6 after the
  resize), in 10 of 10 cells. In 9 of 10 cells some guard written without looking at the feet does not beat no guard line.
- **Moving the stance is now a real trade.** The stance not being his yet costs 3.5 wins in 100 on the night. Boxer by boxer the best
  pair is on the natural stance in 28 of 35 cases and on a moved stance in 7 (25 and 10 after the resize): he moves his feet only for
  the opponent the other guard is built for. Probe 9 had the natural stance best in 0 of 10 cells.
- **What fails: the pooled opponent cell is not clear.** Only 1 of 10 cells (2 after the resize; bar 4) has a best pair more than two
  standard errors above every other pair when all seven boxers are pooled. The reason is the mechanic itself: against one opponent the
  right pair is a different one for a Narrow, a Shoulder and a Wide boxer, so the pooled best is an average of three different answers
  and its neighbour (the same guard on the other stance) is 1 to 3 wins behind. Read by natural stance x style the best is clear in 5,
  then 6 of 15 cells; read by boxer every boxer's change is clear.
- **The resize did what it was for and was not enough.** The guard's plus x 1.5 lifted the best pair over no line from +1 to +7 up to
  +1 to +10 wins in 100 and cleared one more cell. Pro cells stay close (+1 to +5): the line fires about as often in six rounds as in three.

## VERDICT: FAIL twice (bar 4 only). By the brief it comes back to Claude; no critic brief was written.

`RESULT: tools/guardprobe10.gd -> FAIL (effects all move; cost -4.0 +- 0.2, 10 cells 3+; top pair best in 3 of 10 cells; 1 of 10 cells clear; best guard changes for 7 of 7 boxers, 7 beyond the noise; natural best in 4 cells, a moved stance in 6)` (run 1)
`RESULT: tools/guardprobe10.gd -> FAIL (effects all move; cost -4.6 +- 0.2, 10 cells 3+; top pair best in 3 of 10 cells; 2 of 10 cells clear; best guard changes for 7 of 7 boxers, 7 beyond the noise; natural best in 3 cells, a moved stance in 7)` (run 2)

| Bar (all must pass, written before run 1) | Run 1 | Run 2 (the guard's plus x 1.5) |
| :--- | :--- | :--- |
| 1 Every effect moves the result (2+ bouts in 100 change) | PASS: fit 2.9, step speed 2.4, legs 7.1, moved stance 6.9, not owned 6.1 | PASS: 4.0, 2.3, 7.4, 7.0, 6.2 |
| 2 A guard line costs something measurable | PASS: 4.0 +- 0.2 under free; 10 of 10 cells | PASS: 4.6 +- 0.2; 10 of 10 |
| 3 No pair best in more than 5 of 10 opponent cells | PASS: 3 | PASS: 3 |
| 4 Four or more opponent cells clear of the noise | **FAIL**: 1 (Volume puncher / am) | **FAIL**: 2 (Pressure fighter / pro, Volume puncher / am) |
| 5 The best guard changes with the opponent's style for every boxer | PASS: 7 of 7, all 7 beyond two standard errors | PASS: 7 of 7, all 7 |
| 6 The natural stance is best in some cells and beaten in others | PASS: best in 4, beaten in 6 | PASS: 3 and 7 |

Self-checks, both runs: the probe's walk with every guard size off is the game's own bout in 42 of 42 (the two generated boxers included);
the copied guard walk differs from the game's by 0.000000; no attribute copy was rebuilt.
Before run 1 a 2-seed smoke run checked that the script parses and the self-checks hold; no size or bar was changed after it.

## The cheap build, costed (probe 9's way 4, as the brief asks on a second FAIL)
What it is: v7's guard line stays a plan line; the natural stance does one thing, it sets the line's grade word (in his feet Good, a step
off OK, two steps Poor). No moved stance, no pad card, no "not owned", no step or leg price.
| Piece | Files | Size | Seat |
| :--- | :--- | :--- | :--- |
| The stance trait | new `scripts/rules/Stance.gd` (`natural`, `steps`) + unit test | about 40 lines + test | Qwen |
| The guard line | new `scripts/rules/HandsLine.gd` (the table, `points`, the grade from `Stance.steps`) + unit test | about 90 lines + test | Qwen / Arena |
| The wire | `LiveRound.gd` beside the plan line's worth (249), `PlanBoard.validate` (one guard line) | about 15 lines, by Claude | Claude |
| The plan chart row | new `scripts/ui/PlanChartHands.gd` (PlanChart.gd is at 499 lines) | about 150 lines | Grok Dev |
| The words | fighter page header (stance), the corner's eye and the Why line (`PlanRecord`, `FightWhy`) | about 40 lines | Grok Dev |
| Tests | two unit tests, one golden-path walk with a guard line | | with the above |
About one session of Claude's time and three seat tasks; no new fight rule, nothing in scripts/fight3d.
What probe 10 says it would be worth: sections 4 and 5 below are close to its effect (a guard in his feet at full value, a step off at
half, two steps at nothing): the right guard for this boxer against this opponent is +3 to +17 wins in 100 over no line, the wrong one
loses. What it gives up: moving the stance (7 to 10 of 35 best answers were on a moved stance) and the price of the first bouts in it.

## The ways on (for Claude)
1. **Build v9 as mapped and judge it by boxer.** Bars 1, 2, 3, 5 and 6 pass twice; the failed bar asks for one answer per opponent for
   all boxers at once, which this mechanic by design does not have. This needs Claude's call on the bar, not another resize.
2. **The cheap build** above: the same per-boxer, per-opponent choice with no stance to move. Smaller, and it keeps most of what passed.
3. **One more probe with the cells cut by natural stance x style** (15 cells, 6 clear at the run-2 sizes at 80 to 120 bouts a cell;
   more generated boxers would settle the rest). Only worth it if way 1 needs the proof.
My recommendation: way 1 with run 2's sizes, sent to the two critics; the cheap build if a critic finds the moved stance not worth its menus.

---

# GUARDPROBE10 - guard v9: the guard lines follow the opponent (S537), sizes run 1

Run: python ops/Tools/godot_slot.py run --who guardrev9 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guardprobe10.gd -- seeds=40 abl=20 size=1

What is real: five boxers (Data.PROSPECTS), their opponents (Data's region sheets, by style and sex, re-rated -3.4 amateur / -6.5 pro as stanceprobe1 fitted) and every bout (the game's fight night, walked exchange by exchange).
What is scratch: two generated boxers (a Narrow man and a Wide man on a prospect's sheet, own stats and style), the three guards and their table, the feet's price, the shifted stance's layer and its not-owned price. Every arm of a seed fights the same night (same dice): 280 bouts a pair and cell = 7 boxers x 40 seeds. A draw is half a win.

Sizes (set before the run): the plus kept at 0 / 1 / 2 steps from the guard's stance [1.0, 0.5, 0.0]; High and Elbows in out of their feet 4.0 points off the exchange a step; Light out of its feet 4.0 energy after the exchange a step. A shifted stance: { "power": 5.0, "slip": 5.0, "chin": 5.0, "feet": 3.0, "drain": 1.5 } a step; not owned yet: footwork and foot speed -4.0, 2.0 energy a round.
The guards (one a plan, one line): High guard WHEN the opponent loads up (its feet: Wide); Elbows in WHEN the opponent presses (Shoulder); Light guard WHEN the opponent boxes at range (Narrow). Table, moment -> [High, Elbows in, Light]: { "loadup": [9.0, -2.0, -10.0], "press": [-4.0, 8.0, -3.0], "range": [-8.0, -5.0, 8.0], "counter": [-3.0, -3.0, -8.0], "tiring": [-9.0, -4.0, 5.0], "hurt": [-9.0, -4.0, 5.0] }.

Self-check 1: the walk with every guard size off gives the same bout as BoutNight.play_out in 42 of 42 bouts. Self-check 2: the copied guard walk against the game's, max |diff| = 0.000000. Attribute copies the game would have rebuilt (must be 0): 0.

## 1. Who they are

| Boxer | Style | Power | Speed | Natural stance | In his feet | One step off | Two steps off |
| :--- | :--- | ---: | ---: | :--- | :--- | :--- | :--- |
| Kira Mensah | Out-boxer | 54 | 67 | Narrow | Light guard | Elbows in | High guard |
| Leon Ward (generated) | Out-boxer | 55 | 65 | Narrow | Light guard | Elbows in | High guard |
| Samira Khan | Slugger | 66 | 57 | Wide | High guard | Elbows in | Light guard |
| Marcus Doyle (generated) | Slugger | 68 | 57 | Wide | High guard | Elbows in | Light guard |
| Tess Reilly | Pressure fighter | 62 | 55 | Shoulder | Elbows in | High guard, Light guard | - |
| Danny Osei | Boxer-puncher | 59 | 62 | Shoulder | Elbows in | High guard, Light guard | - |
| Josh Harper | Pressure fighter | 63 | 56 | Shoulder | Elbows in | High guard, Light guard | - |

## 2. Every opponent cell: wins in 100 bouts by pair (+- one standard error)

### Out-boxer / am

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 48.9 +- 3.0 | - | 0.0 |
| High guard | 49.3 +- 3.0 | 46.8 +- 3.0 | 1.5 |
| Elbows in | 50.7 +- 3.0 | 49.6 +- 3.0 | 1.1 |
| Light guard | 45.4 +- 3.0 | 52.1 +- 3.0 | 5.1 |

Best: **Light guard, a step toward it** (52.1); inside two standard errors of it: no guard line; High guard, natural stance; High guard, a step toward it; Elbows in, natural stance; Elbows in, a step toward it.

### Out-boxer / pro

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 54.8 +- 2.8 | - | 0.0 |
| High guard | 56.3 +- 2.8 | 52.5 +- 2.9 | 1.3 |
| Elbows in | 55.4 +- 2.8 | 49.8 +- 2.8 | 1.1 |
| Light guard | 51.2 +- 2.9 | 53.4 +- 2.8 | 5.3 |

Best: **High guard, natural stance** (56.3); inside two standard errors of it: no guard line; Elbows in, natural stance; Light guard, a step toward it.

### Pressure fighter / am

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 44.3 +- 3.0 | - | 0.0 |
| High guard | 43.6 +- 3.0 | 41.8 +- 3.0 | 2.2 |
| Elbows in | 47.5 +- 3.0 | 50.4 +- 3.0 | 6.6 |
| Light guard | 44.6 +- 3.0 | 45.0 +- 3.0 | 0.9 |

Best: **Elbows in, a step toward it** (50.4); inside two standard errors of it: Elbows in, natural stance.

### Pressure fighter / pro

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 55.7 +- 2.8 | - | 0.0 |
| High guard | 53.6 +- 2.8 | 52.0 +- 2.8 | 2.1 |
| Elbows in | 57.3 +- 2.8 | 52.1 +- 2.8 | 6.8 |
| Light guard | 55.2 +- 2.8 | 50.5 +- 2.8 | 1.1 |

Best: **Elbows in, natural stance** (57.3); inside two standard errors of it: no guard line; Light guard, natural stance.

### Counter-puncher / am

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 45.7 +- 3.0 | - | 0.0 |
| High guard | 46.4 +- 3.0 | 47.5 +- 3.0 | 1.7 |
| Elbows in | 46.4 +- 3.0 | 45.4 +- 3.0 | 1.0 |
| Light guard | 45.4 +- 3.0 | 44.3 +- 3.0 | 2.3 |

Best: **High guard, a step toward it** (47.5); inside two standard errors of it: no guard line; High guard, natural stance; Elbows in, natural stance; Elbows in, a step toward it; Light guard, natural stance; Light guard, a step toward it.

### Counter-puncher / pro

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 55.9 +- 2.7 | - | 0.0 |
| High guard | 55.4 +- 2.7 | 53.6 +- 2.8 | 1.7 |
| Elbows in | 57.0 +- 2.7 | 52.7 +- 2.7 | 1.2 |
| Light guard | 54.5 +- 2.7 | 52.1 +- 2.8 | 2.4 |

Best: **Elbows in, natural stance** (57.0); inside two standard errors of it: High guard, natural stance; Light guard, natural stance.

### Volume puncher / am

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 54.3 +- 3.0 | - | 0.0 |
| High guard | 55.7 +- 3.0 | 55.4 +- 3.0 | 1.4 |
| Elbows in | 56.8 +- 3.0 | 59.6 +- 2.9 | 5.2 |
| Light guard | 47.9 +- 3.0 | 51.1 +- 3.0 | 3.6 |

Best: **Elbows in, a step toward it** (59.6) - CLEAR.

### Volume puncher / pro

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 57.9 +- 2.8 | - | 0.0 |
| High guard | 57.7 +- 2.8 | 57.7 +- 2.8 | 1.1 |
| Elbows in | 60.7 +- 2.8 | 59.6 +- 2.8 | 5.5 |
| Light guard | 54.3 +- 2.9 | 54.1 +- 2.8 | 3.4 |

Best: **Elbows in, natural stance** (60.7); inside two standard errors of it: High guard, a step toward it; Elbows in, a step toward it.

### Slugger / am

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 48.6 +- 3.0 | - | 0.0 |
| High guard | 52.9 +- 3.0 | 54.6 +- 3.0 | 4.3 |
| Elbows in | 52.1 +- 3.0 | 55.4 +- 3.0 | 4.9 |
| Light guard | 47.5 +- 3.0 | 47.9 +- 3.0 | 1.0 |

Best: **Elbows in, a step toward it** (55.4); inside two standard errors of it: High guard, natural stance; High guard, a step toward it.

### Slugger / pro

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 57.0 +- 2.8 | - | 0.0 |
| High guard | 58.2 +- 2.8 | 60.5 +- 2.8 | 4.5 |
| Elbows in | 58.4 +- 2.8 | 58.4 +- 2.8 | 4.9 |
| Light guard | 57.7 +- 2.8 | 55.2 +- 2.9 | 1.1 |

Best: **High guard, a step toward it** (60.5); inside two standard errors of it: no guard line; High guard, natural stance; Elbows in, natural stance; Elbows in, a step toward it; Light guard, natural stance.

## 3. The summary by opponent cell

| Cell | Today's game (20 seeds) | No guard line | Best pair | Wins | Against no line | Inside the noise of the best |
| :--- | ---: | ---: | :--- | ---: | ---: | :--- |
| Out-boxer / am | 50.0 | 48.9 | Light guard, a step toward it | 52.1 | +3.2 +- 2.3 | no guard line; High guard, natural stance; High guard, a step toward it; Elbows in, natural stance; Elbows in, a step toward it |
| Out-boxer / pro | 52.9 | 54.8 | High guard, natural stance | 56.3 | +1.4 +- 0.9 | no guard line; Elbows in, natural stance; Light guard, a step toward it |
| Pressure fighter / am | 45.0 | 44.3 | Elbows in, a step toward it | 50.4 | +6.1 +- 2.1 | Elbows in, natural stance |
| Pressure fighter / pro | 55.4 | 55.7 | Elbows in, natural stance | 57.3 | +1.6 +- 1.4 | no guard line; Light guard, natural stance |
| Counter-puncher / am | 45.7 | 45.7 | High guard, a step toward it | 47.5 | +1.8 +- 1.9 | no guard line; High guard, natural stance; Elbows in, natural stance; Elbows in, a step toward it; Light guard, natural stance; Light guard, a step toward it |
| Counter-puncher / pro | 56.1 | 55.9 | Elbows in, natural stance | 57.0 | +1.1 +- 0.5 | High guard, natural stance; Light guard, natural stance |
| Volume puncher / am | 54.3 | 54.3 | Elbows in, a step toward it | 59.6 | +5.4 +- 1.4 | CLEAR |
| Volume puncher / pro | 56.4 | 57.9 | Elbows in, natural stance | 60.7 | +2.9 +- 1.2 | High guard, a step toward it; Elbows in, a step toward it |
| Slugger / am | 50.0 | 48.6 | Elbows in, a step toward it | 55.4 | +6.8 +- 1.8 | High guard, natural stance; High guard, a step toward it |
| Slugger / pro | 55.4 | 57.0 | High guard, a step toward it | 60.5 | +3.6 +- 1.8 | no guard line; High guard, natural stance; Elbows in, natural stance; Elbows in, a step toward it; Light guard, natural stance |

Best counts: Light guard, a step toward it 1; High guard, natural stance 1; Elbows in, a step toward it 3; Elbows in, natural stance 3; High guard, a step toward it 2. The most any one pair wins: 3 of 10 cells (bar: 5 or fewer).
Cells with a clear best (every other pair more than two standard errors under it, seed by seed): 1 of 10 (bar: 4 or more).
Cells whose best pair is on the natural stance (or no line): 4 of 10; on a stance moved a step: 6 of 10 (bar: 1 or more each way).

## 4. What a guard line costs: the same line free (v7's rule, no feet) against paid, on the natural stance

| Cell | High: free | paid | the feet cost | Elbows in: free | paid | the feet cost | Light: free | paid | the feet cost |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Out-boxer / am | +2.9 | +0.4 | -2.5 +- 1.1 | +4.3 | +1.8 | -2.5 +- 0.9 | +12.1 | -3.6 | -15.7 +- 2.2 |
| Out-boxer / pro | +2.9 | +1.4 | -1.4 +- 0.6 | +1.4 | +0.5 | -0.9 +- 0.5 | +7.3 | -3.6 | -10.9 +- 2.1 |
| Pressure fighter / am | +1.8 | -0.7 | -2.5 +- 1.4 | +11.1 | +3.2 | -7.9 +- 1.8 | +1.1 | +0.4 | -0.7 +- 0.5 |
| Pressure fighter / pro | +1.4 | -2.1 | -3.6 +- 1.0 | +3.4 | +1.6 | -1.8 +- 1.0 | +2.0 | -0.5 | -2.5 +- 0.9 |
| Counter-puncher / am | +4.6 | +0.7 | -3.9 +- 1.2 | +1.4 | +0.7 | -0.7 +- 0.5 | +5.4 | -0.4 | -5.7 +- 1.6 |
| Counter-puncher / pro | +1.3 | -0.5 | -1.8 +- 0.6 | +1.6 | +1.1 | -0.5 +- 0.6 | +2.7 | -1.4 | -4.1 +- 1.6 |
| Volume puncher / am | +1.4 | +1.4 | +0.0 +- 0.5 | +6.1 | +2.5 | -3.6 +- 1.2 | +4.6 | -6.4 | -11.1 +- 1.9 |
| Volume puncher / pro | +0.7 | -0.2 | -0.9 +- 0.7 | +6.6 | +2.9 | -3.8 +- 1.1 | +2.5 | -3.6 | -6.1 +- 1.7 |
| Slugger / am | +11.1 | +4.3 | -6.8 +- 1.5 | +10.0 | +3.6 | -6.4 +- 1.5 | +1.4 | -1.1 | -2.5 +- 0.9 |
| Slugger / pro | +7.7 | +1.3 | -6.4 +- 1.3 | +3.0 | +1.4 | -1.6 +- 1.1 | +2.7 | +0.7 | -2.0 +- 1.3 |

(free and paid are against no guard line, wins in 100, all seven boxers; a boxer in the guard's feet pays nothing.) Pooled over the cells and the three guards: paid against free -4.0 +- 0.2 wins in 100 (bar: 2.0 or more under, beyond two standard errors). Cells where some guard is 3+ under its free twin: 10 of 10 (bar: 3 or more). Cells where some paid guard on the natural stance does not beat no guard line at all: 9 of 10.

## 5. By boxer: his best pair against each opponent style (amateur + pro, 80 bouts a pair)

| Boxer | Natural | Out-boxer | Pressure fighter | Counter-puncher | Volume puncher | Slugger | Guards that are his best | Changes beyond the noise |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |  :--- | :--- |
| Kira | Narrow | Light guard, natural (65.0, +11.3) | Light guard, natural (75.0, +3.1) | Light guard, natural (51.2, +3.1) | Elbows in, a step (50.6, +4.4) | Elbows in, a step (82.5, +3.8) | Light guard, Elbows in | yes (Out-boxer vs Slugger: +15.6 +- 5.5) |
| Leon | Narrow | Light guard, natural (52.5, +6.3) | Light guard, natural (66.3, +3.1) | Light guard, natural (48.8, +7.5) | Light guard, natural (66.9, +4.4) | no guard line (74.4, +0.0) | Light guard, no guard line | yes (Counter-puncher vs Slugger: +7.5 +- 3.2) |
| Samira | Wide | High guard, natural (61.9, +3.1) | no guard line (31.3, +0.0) | High guard, natural (53.8, +6.3) | no guard line (48.1, +0.0) | High guard, natural (44.4, +12.5) | High guard, no guard line | yes (Volume puncher vs Slugger: +12.5 +- 4.3) |
| Marcus | Wide | High guard, natural (61.3, +3.1) | High guard, natural (32.5, +1.9) | no guard line (59.4, +0.0) | High guard, natural (58.8, +1.9) | High guard, natural (53.8, +13.8) | High guard, no guard line | yes (Counter-puncher vs Slugger: +13.8 +- 4.0) |
| Tess | Shoulder | Light guard, a step (54.4, +6.9) | Elbows in, natural (50.0, +15.0) | Elbows in, natural (50.0, +2.5) | High guard, a step (69.4, +8.8) | High guard, a step (42.5, +12.5) | Light guard, Elbows in, High guard | yes (Out-boxer vs Pressure fighter: +21.9 +- 5.7) |
| Danny | Shoulder | Light guard, a step (56.3, +5.6) | Elbows in, natural (80.0, +1.3) | Elbows in, natural (53.1, +3.8) | Elbows in, natural (71.3, +7.5) | Elbows in, natural (81.9, +2.5) | Light guard, Elbows in | yes (Out-boxer vs Volume puncher: +11.3 +- 3.8) |
| Josh | Shoulder | Elbows in, natural (53.1, +5.0) | High guard, natural (40.6, +1.3) | Light guard, natural (66.9, +4.4) | Elbows in, natural (63.7, +9.4) | High guard, a step (43.8, +8.8) | Elbows in, High guard, Light guard | yes (Counter-puncher vs Volume puncher: +16.9 +- 4.9) |

(each cell: best pair (wins in 100, against no guard line). The change: the best pair against one style over the best pair against another, on both styles' bouts; a swing more than two standard errors = beyond the noise. The best of several pairs on the same bouts flatters it a little.)
Boxers whose best guard is not the same against all five styles: 7 of 7 (bar: all). Boxers for whom that change is beyond the noise: 7 of 7 (bar: 4 or more).
Of the 35 boxer x style cells the best pair is on the natural stance (or no line) in 28 and on a stance moved a step in 7.

### By natural stance x opponent style (the boxers of a stance pooled)

| Natural stance | Out-boxer | Pressure fighter | Counter-puncher | Volume puncher | Slugger |
| :--- | :--- | :--- | :--- | :--- | :--- | 
| Narrow | Light guard, natural (58.8) CLEAR | Light guard, natural (70.6) CLEAR | Light guard, natural (50.0) CLEAR | Elbows in, a step (58.4) | Light guard, natural (76.9) |
| Shoulder | Light guard, a step (54.2) | Elbows in, natural (56.7) CLEAR | Elbows in, natural (55.2) | Elbows in, natural (66.0) | High guard, a step (55.2) |
| Wide | High guard, natural (61.6) | High guard, natural (31.6) | High guard, natural (56.6) | High guard, natural (53.4) | High guard, natural (49.1) CLEAR |

Stance x style cells with a clear best: 5 of 15 (no bar; read beside bar 4).

## 6. Does each effect move the result? (the effect off on its test pairs, 20 seeds, the same dice as with it on)

| Effect off | Test pairs | Bouts whose result changed, in 100 | Wins in 100 with it off against on | Moves it (2 in 100 or more) |
| :--- | :--- | ---: | ---: | :--- |
| the plus kept by the feet | High guard, natural stance; Light guard, natural stance | 2.9 | +2.1 +- 0.3 | yes |
| High / Elbows in out of their feet: step speed | High guard, natural stance; Elbows in, natural stance | 2.4 | +2.1 +- 0.3 | yes |
| Light out of its feet: the legs | Light guard, natural stance | 7.1 | +3.4 +- 0.6 | yes |
| a shifted stance changes the boxer | High guard, a step toward it; Light guard, a step toward it | 6.9 | +0.2 +- 0.4 | yes |
| a stance not owned yet: slow feet, energy | High guard, a step toward it; Elbows in, a step toward it | 6.1 | +3.5 +- 0.4 | yes |

(all seven boxers are in every row; a boxer in the guard's feet has nothing to switch off, so the shares are diluted by them.)

## 7. Bars (written in the probe before the run)

- 1 every effect moves the result: PASS.
- 2 a guard line costs something measurable: -4.0 +- 0.2 wins in 100 against free, 10 cells 3+ under = PASS.
- 3 no pair best in more than 5 of 10 cells: 3 = PASS.
- 4 four or more cells clear of the noise: 1 = FAIL.
- 5 the best guard changes with the opponent's style for every boxer: 7 of 7 change, 7 beyond the noise = PASS.
- 6 the natural stance is best in some cells and beaten in others: best in 4, beaten in 6 of 10 = PASS.

32484 bouts played in 1164 s.

RESULT: tools/guardprobe10.gd -> FAIL (effects all move; cost -4.0 +- 0.2, 10 cells 3+; top pair best in 3 of 10 cells; 1 of 10 cells clear; best guard changes for 7 of 7 boxers, 7 beyond the noise; natural best in 4 cells, a moved stance in 6)

---

# GUARDPROBE10 - guard v9: the guard lines follow the opponent (S537), sizes run 2

Run: python ops/Tools/godot_slot.py run --who guardrev9 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guardprobe10.gd -- seeds=40 abl=20 size=2

What is real: five boxers (Data.PROSPECTS), their opponents (Data's region sheets, by style and sex, re-rated -3.4 amateur / -6.5 pro as stanceprobe1 fitted) and every bout (the game's fight night, walked exchange by exchange).
What is scratch: two generated boxers (a Narrow man and a Wide man on a prospect's sheet, own stats and style), the three guards and their table, the feet's price, the shifted stance's layer and its not-owned price. Every arm of a seed fights the same night (same dice): 280 bouts a pair and cell = 7 boxers x 40 seeds. A draw is half a win.

Sizes (set before the run): the plus kept at 0 / 1 / 2 steps from the guard's stance [1.0, 0.5, 0.0]; High and Elbows in out of their feet 4.0 points off the exchange a step; Light out of its feet 4.0 energy after the exchange a step. A shifted stance: { "power": 5.0, "slip": 5.0, "chin": 5.0, "feet": 3.0, "drain": 1.5 } a step; not owned yet: footwork and foot speed -4.0, 2.0 energy a round. The table's plus values x 1.5.
The guards (one a plan, one line): High guard WHEN the opponent loads up (its feet: Wide); Elbows in WHEN the opponent presses (Shoulder); Light guard WHEN the opponent boxes at range (Narrow). Table, moment -> [High, Elbows in, Light]: { "loadup": [9.0, -2.0, -10.0], "press": [-4.0, 8.0, -3.0], "range": [-8.0, -5.0, 8.0], "counter": [-3.0, -3.0, -8.0], "tiring": [-9.0, -4.0, 5.0], "hurt": [-9.0, -4.0, 5.0] }.

Self-check 1: the walk with every guard size off gives the same bout as BoutNight.play_out in 42 of 42 bouts. Self-check 2: the copied guard walk against the game's, max |diff| = 0.000000. Attribute copies the game would have rebuilt (must be 0): 0.

## 1. Who they are

| Boxer | Style | Power | Speed | Natural stance | In his feet | One step off | Two steps off |
| :--- | :--- | ---: | ---: | :--- | :--- | :--- | :--- |
| Kira Mensah | Out-boxer | 54 | 67 | Narrow | Light guard | Elbows in | High guard |
| Leon Ward (generated) | Out-boxer | 55 | 65 | Narrow | Light guard | Elbows in | High guard |
| Samira Khan | Slugger | 66 | 57 | Wide | High guard | Elbows in | Light guard |
| Marcus Doyle (generated) | Slugger | 68 | 57 | Wide | High guard | Elbows in | Light guard |
| Tess Reilly | Pressure fighter | 62 | 55 | Shoulder | Elbows in | High guard, Light guard | - |
| Danny Osei | Boxer-puncher | 59 | 62 | Shoulder | Elbows in | High guard, Light guard | - |
| Josh Harper | Pressure fighter | 63 | 56 | Shoulder | Elbows in | High guard, Light guard | - |

## 2. Every opponent cell: wins in 100 bouts by pair (+- one standard error)

### Out-boxer / am

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 48.9 +- 3.0 | - | 0.0 |
| High guard | 49.6 +- 3.0 | 47.1 +- 3.0 | 1.5 |
| Elbows in | 51.4 +- 3.0 | 49.6 +- 3.0 | 1.1 |
| Light guard | 48.2 +- 3.0 | 55.7 +- 3.0 | 5.1 |

Best: **Light guard, a step toward it** (55.7); inside two standard errors of it: Elbows in, natural stance.

### Out-boxer / pro

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 54.8 +- 2.8 | - | 0.0 |
| High guard | 56.8 +- 2.8 | 53.9 +- 2.9 | 1.3 |
| Elbows in | 56.1 +- 2.8 | 50.5 +- 2.8 | 1.1 |
| Light guard | 53.0 +- 2.9 | 56.3 +- 2.8 | 5.3 |

Best: **High guard, natural stance** (56.8); inside two standard errors of it: no guard line; High guard, a step toward it; Elbows in, natural stance; Light guard, natural stance; Light guard, a step toward it.

### Pressure fighter / am

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 44.3 +- 3.0 | - | 0.0 |
| High guard | 44.6 +- 3.0 | 43.2 +- 3.0 | 2.2 |
| Elbows in | 52.1 +- 3.0 | 54.6 +- 3.0 | 6.6 |
| Light guard | 45.7 +- 3.0 | 45.7 +- 3.0 | 0.9 |

Best: **Elbows in, a step toward it** (54.6); inside two standard errors of it: Elbows in, natural stance.

### Pressure fighter / pro

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 55.7 +- 2.8 | - | 0.0 |
| High guard | 54.1 +- 2.8 | 53.9 +- 2.8 | 2.1 |
| Elbows in | 58.6 +- 2.7 | 55.7 +- 2.8 | 6.8 |
| Light guard | 55.4 +- 2.8 | 51.1 +- 2.8 | 1.0 |

Best: **Elbows in, natural stance** (58.6) - CLEAR.

### Counter-puncher / am

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 45.7 +- 3.0 | - | 0.0 |
| High guard | 47.5 +- 3.0 | 48.9 +- 3.0 | 1.7 |
| Elbows in | 46.8 +- 3.0 | 45.4 +- 3.0 | 1.0 |
| Light guard | 46.8 +- 3.0 | 46.1 +- 3.0 | 2.3 |

Best: **High guard, a step toward it** (48.9); inside two standard errors of it: no guard line; High guard, natural stance; Elbows in, natural stance; Elbows in, a step toward it; Light guard, natural stance; Light guard, a step toward it.

### Counter-puncher / pro

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 55.9 +- 2.7 | - | 0.0 |
| High guard | 56.6 +- 2.7 | 55.2 +- 2.8 | 1.7 |
| Elbows in | 57.1 +- 2.7 | 52.9 +- 2.8 | 1.1 |
| Light guard | 55.5 +- 2.7 | 53.4 +- 2.8 | 2.4 |

Best: **Elbows in, natural stance** (57.1); inside two standard errors of it: High guard, natural stance; High guard, a step toward it; Light guard, natural stance.

### Volume puncher / am

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 54.3 +- 3.0 | - | 0.0 |
| High guard | 55.4 +- 3.0 | 55.4 +- 3.0 | 1.4 |
| Elbows in | 58.2 +- 3.0 | 62.5 +- 2.9 | 5.2 |
| Light guard | 49.6 +- 3.0 | 55.0 +- 3.0 | 3.6 |

Best: **Elbows in, a step toward it** (62.5) - CLEAR.

### Volume puncher / pro

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 57.9 +- 2.8 | - | 0.0 |
| High guard | 57.7 +- 2.8 | 59.1 +- 2.8 | 1.1 |
| Elbows in | 62.3 +- 2.7 | 62.7 +- 2.7 | 5.5 |
| Light guard | 53.9 +- 2.9 | 55.5 +- 2.8 | 3.4 |

Best: **Elbows in, a step toward it** (62.7); inside two standard errors of it: High guard, a step toward it; Elbows in, natural stance.

### Slugger / am

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 48.6 +- 3.0 | - | 0.0 |
| High guard | 55.4 +- 3.0 | 57.9 +- 3.0 | 4.3 |
| Elbows in | 57.5 +- 3.0 | 57.5 +- 3.0 | 4.9 |
| Light guard | 47.5 +- 3.0 | 47.9 +- 3.0 | 0.9 |

Best: **High guard, a step toward it** (57.9); inside two standard errors of it: High guard, natural stance; Elbows in, natural stance; Elbows in, a step toward it.

### Slugger / pro

| | natural stance | a step toward it (not owned) | line fired a bout (natural) |
| :--- | ---: | ---: | ---: |
| no guard line | 57.0 +- 2.8 | - | 0.0 |
| High guard | 60.4 +- 2.7 | 62.5 +- 2.7 | 4.5 |
| Elbows in | 60.0 +- 2.7 | 60.4 +- 2.7 | 4.9 |
| Light guard | 58.2 +- 2.9 | 55.5 +- 2.9 | 1.1 |

Best: **High guard, a step toward it** (62.5); inside two standard errors of it: High guard, natural stance; Elbows in, natural stance; Elbows in, a step toward it.

## 3. The summary by opponent cell

| Cell | Today's game (20 seeds) | No guard line | Best pair | Wins | Against no line | Inside the noise of the best |
| :--- | ---: | ---: | :--- | ---: | ---: | :--- |
| Out-boxer / am | 50.0 | 48.9 | Light guard, a step toward it | 55.7 | +6.8 +- 2.5 | Elbows in, natural stance |
| Out-boxer / pro | 52.9 | 54.8 | High guard, natural stance | 56.8 | +2.0 +- 1.1 | no guard line; High guard, a step toward it; Elbows in, natural stance; Light guard, natural stance; Light guard, a step toward it |
| Pressure fighter / am | 45.0 | 44.3 | Elbows in, a step toward it | 54.6 | +10.4 +- 2.3 | Elbows in, natural stance |
| Pressure fighter / pro | 55.4 | 55.7 | Elbows in, natural stance | 58.6 | +2.9 +- 1.4 | CLEAR |
| Counter-puncher / am | 45.7 | 45.7 | High guard, a step toward it | 48.9 | +3.2 +- 2.0 | no guard line; High guard, natural stance; Elbows in, natural stance; Elbows in, a step toward it; Light guard, natural stance; Light guard, a step toward it |
| Counter-puncher / pro | 56.1 | 55.9 | Elbows in, natural stance | 57.1 | +1.3 +- 0.6 | High guard, natural stance; High guard, a step toward it; Light guard, natural stance |
| Volume puncher / am | 54.3 | 54.3 | Elbows in, a step toward it | 62.5 | +8.2 +- 1.8 | CLEAR |
| Volume puncher / pro | 56.4 | 57.9 | Elbows in, a step toward it | 62.7 | +4.8 +- 1.7 | High guard, a step toward it; Elbows in, natural stance |
| Slugger / am | 50.0 | 48.6 | High guard, a step toward it | 57.9 | +9.3 +- 2.4 | High guard, natural stance; Elbows in, natural stance; Elbows in, a step toward it |
| Slugger / pro | 55.4 | 57.0 | High guard, a step toward it | 62.5 | +5.5 +- 1.8 | High guard, natural stance; Elbows in, natural stance; Elbows in, a step toward it |

Best counts: Light guard, a step toward it 1; High guard, natural stance 1; Elbows in, a step toward it 3; Elbows in, natural stance 2; High guard, a step toward it 3. The most any one pair wins: 3 of 10 cells (bar: 5 or fewer).
Cells with a clear best (every other pair more than two standard errors under it, seed by seed): 2 of 10 (bar: 4 or more).
Cells whose best pair is on the natural stance (or no line): 3 of 10; on a stance moved a step: 7 of 10 (bar: 1 or more each way).

## 4. What a guard line costs: the same line free (v7's rule, no feet) against paid, on the natural stance

| Cell | High: free | paid | the feet cost | Elbows in: free | paid | the feet cost | Light: free | paid | the feet cost |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Out-boxer / am | +4.6 | +0.7 | -3.9 +- 1.3 | +5.0 | +2.5 | -2.5 +- 0.9 | +16.1 | -0.7 | -16.8 +- 2.3 |
| Out-boxer / pro | +3.2 | +2.0 | -1.3 +- 0.8 | +2.1 | +1.3 | -0.9 +- 0.6 | +11.6 | -1.8 | -13.4 +- 2.1 |
| Pressure fighter / am | +3.2 | +0.4 | -2.9 +- 1.4 | +15.0 | +7.9 | -7.1 +- 1.8 | +2.9 | +1.4 | -1.4 +- 0.7 |
| Pressure fighter / pro | +3.2 | -1.6 | -4.8 +- 1.2 | +6.8 | +2.9 | -3.9 +- 1.1 | +2.1 | -0.4 | -2.5 +- 0.9 |
| Counter-puncher / am | +6.4 | +1.8 | -4.6 +- 1.4 | +2.1 | +1.1 | -1.1 +- 0.6 | +8.6 | +1.1 | -7.5 +- 1.8 |
| Counter-puncher / pro | +2.9 | +0.7 | -2.1 +- 0.8 | +1.1 | +1.3 | +0.2 +- 0.4 | +5.9 | -0.4 | -6.3 +- 1.5 |
| Volume puncher / am | +2.1 | +1.1 | -1.1 +- 0.6 | +9.3 | +3.9 | -5.4 +- 1.5 | +9.3 | -4.6 | -13.9 +- 2.1 |
| Volume puncher / pro | +1.6 | -0.2 | -1.8 +- 0.7 | +8.8 | +4.5 | -4.3 +- 1.2 | +3.0 | -3.9 | -7.0 +- 1.8 |
| Slugger / am | +14.3 | +6.8 | -7.5 +- 1.6 | +11.8 | +8.9 | -2.9 +- 1.0 | +2.1 | -1.1 | -3.2 +- 1.1 |
| Slugger / pro | +8.6 | +3.4 | -5.2 +- 1.5 | +5.7 | +3.0 | -2.7 +- 1.3 | +2.5 | +1.3 | -1.3 +- 1.3 |

(free and paid are against no guard line, wins in 100, all seven boxers; a boxer in the guard's feet pays nothing.) Pooled over the cells and the three guards: paid against free -4.6 +- 0.2 wins in 100 (bar: 2.0 or more under, beyond two standard errors). Cells where some guard is 3+ under its free twin: 10 of 10 (bar: 3 or more). Cells where some paid guard on the natural stance does not beat no guard line at all: 7 of 10.

## 5. By boxer: his best pair against each opponent style (amateur + pro, 80 bouts a pair)

| Boxer | Natural | Out-boxer | Pressure fighter | Counter-puncher | Volume puncher | Slugger | Guards that are his best | Changes beyond the noise |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |  :--- | :--- |
| Kira | Narrow | Light guard, natural (69.4, +15.6) | Light guard, natural (76.3, +4.4) | Light guard, natural (53.1, +5.0) | Light guard, natural (54.4, +8.1) | Elbows in, a step (83.8, +5.0) | Light guard, Elbows in | yes (Out-boxer vs Slugger: +20.6 +- 5.5) |
| Leon | Narrow | Light guard, natural (58.1, +11.9) | Light guard, natural (68.1, +5.0) | Light guard, natural (52.5, +11.3) | Elbows in, a step (69.4, +6.9) | Elbows in, natural (77.5, +3.1) | Light guard, Elbows in | yes (Counter-puncher vs Slugger: +14.4 +- 4.1) |
| Samira | Wide | High guard, natural (61.3, +2.5) | Elbows in, natural (35.0, +3.8) | High guard, natural (55.6, +8.1) | Elbows in, a step (53.8, +5.6) | High guard, natural (45.0, +13.1) | High guard, Elbows in | yes (Counter-puncher vs Volume puncher: +16.3 +- 5.2) |
| Marcus | Wide | High guard, natural (63.7, +5.6) | Elbows in, a step (35.0, +4.4) | High guard, natural (63.7, +4.4) | Elbows in, a step (59.4, +2.5) | High guard, natural (57.5, +17.5) | High guard, Elbows in | yes (Out-boxer vs Volume puncher: +17.5 +- 5.1) |
| Tess | Shoulder | Light guard, a step (61.9, +14.4) | Elbows in, natural (51.9, +16.9) | High guard, natural (49.4, +1.9) | High guard, a step (70.6, +10.0) | High guard, a step (47.5, +17.5) | Light guard, Elbows in, High guard | yes (Out-boxer vs Pressure fighter: +31.9 +- 6.1) |
| Danny | Shoulder | Light guard, a step (59.4, +8.8) | Elbows in, natural (83.1, +4.4) | Elbows in, natural (53.8, +4.4) | Elbows in, natural (71.9, +8.1) | Elbows in, natural (83.1, +3.8) | Light guard, Elbows in | yes (Out-boxer vs Slugger: +13.1 +- 4.6) |
| Josh | Shoulder | Elbows in, natural (53.1, +5.0) | Elbows in, natural (45.6, +6.3) | Light guard, natural (66.9, +4.4) | Elbows in, natural (67.5, +13.1) | High guard, a step (49.4, +14.4) | Elbows in, Light guard, High guard | yes (Counter-puncher vs Volume puncher: +20.6 +- 5.3) |

(each cell: best pair (wins in 100, against no guard line). The change: the best pair against one style over the best pair against another, on both styles' bouts; a swing more than two standard errors = beyond the noise. The best of several pairs on the same bouts flatters it a little.)
Boxers whose best guard is not the same against all five styles: 7 of 7 (bar: all). Boxers for whom that change is beyond the noise: 7 of 7 (bar: 4 or more).
Of the 35 boxer x style cells the best pair is on the natural stance (or no line) in 25 and on a stance moved a step in 10.

### By natural stance x opponent style (the boxers of a stance pooled)

| Natural stance | Out-boxer | Pressure fighter | Counter-puncher | Volume puncher | Slugger |
| :--- | :--- | :--- | :--- | :--- | :--- | 
| Narrow | Light guard, natural (63.7) CLEAR | Light guard, natural (72.2) | Light guard, natural (52.8) CLEAR | Light guard, natural (61.9) | Elbows in, a step (78.8) |
| Shoulder | Light guard, a step (58.1) CLEAR | Elbows in, natural (60.2) CLEAR | Elbows in, natural (55.2) | Elbows in, natural (67.9) | High guard, a step (59.2) |
| Wide | High guard, natural (62.5) | Elbows in, natural (34.1) | High guard, natural (59.7) CLEAR | Elbows in, a step (56.6) | High guard, natural (51.2) CLEAR |

Stance x style cells with a clear best: 6 of 15 (no bar; read beside bar 4).

## 6. Does each effect move the result? (the effect off on its test pairs, 20 seeds, the same dice as with it on)

| Effect off | Test pairs | Bouts whose result changed, in 100 | Wins in 100 with it off against on | Moves it (2 in 100 or more) |
| :--- | :--- | ---: | ---: | :--- |
| the plus kept by the feet | High guard, natural stance; Light guard, natural stance | 4.0 | +2.5 +- 0.3 | yes |
| High / Elbows in out of their feet: step speed | High guard, natural stance; Elbows in, natural stance | 2.3 | +1.6 +- 0.2 | yes |
| Light out of its feet: the legs | Light guard, natural stance | 7.4 | +3.6 +- 0.6 | yes |
| a shifted stance changes the boxer | High guard, a step toward it; Light guard, a step toward it | 7.0 | +0.1 +- 0.4 | yes |
| a stance not owned yet: slow feet, energy | High guard, a step toward it; Elbows in, a step toward it | 6.2 | +3.6 +- 0.4 | yes |

(all seven boxers are in every row; a boxer in the guard's feet has nothing to switch off, so the shares are diluted by them.)

## 7. Bars (written in the probe before the run)

- 1 every effect moves the result: PASS.
- 2 a guard line costs something measurable: -4.6 +- 0.2 wins in 100 against free, 10 cells 3+ under = PASS.
- 3 no pair best in more than 5 of 10 cells: 3 = PASS.
- 4 four or more cells clear of the noise: 2 = FAIL.
- 5 the best guard changes with the opponent's style for every boxer: 7 of 7 change, 7 beyond the noise = PASS.
- 6 the natural stance is best in some cells and beaten in others: best in 3, beaten in 7 of 10 = PASS.

32484 bouts played in 1266 s.

RESULT: tools/guardprobe10.gd -> FAIL (effects all move; cost -4.6 +- 0.2, 10 cells 3+; top pair best in 3 of 10 cells; 2 of 10 cells clear; best guard changes for 7 of 7 boxers, 7 beyond the noise; natural best in 3 cells, a moved stance in 7)
