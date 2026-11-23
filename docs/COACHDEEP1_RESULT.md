# COACHDEEP1 - coaches as people: the first probe (S539)

Task: ops/research/TASK_COACHDEEP1.md. Design map: ops/research/DESIGN_COACHDEEP1.md. Probe: tools/coachdeep1.gd + the rules
copy tools/coachdeep1_rules.gd. Nothing under scripts/ changes.

## 1. What is probed (the core lever only)
Two coaches with different attributes, playbooks and personalities share SIX coached evenings a week between the TEST CLUB's
four fighters, who want EIGHT (two pad nights each). The player's choice each week: which coach takes which boxer. The probe
asks whether that choice is real: does it depend on the coaches and the boxers, does chemistry move results, and does a
thought-out week beat "everyone gets the same".

Population: TestClub.make on Career.quick_start (Lucy wlw Out-boxer, Kira wfw Out-boxer aged 18, Josh mww Pressure fighter,
Ana no-gi), their own personalities. Cells: the 10 pairs of five coaches (A pad man, B engine room, C mat and gloves - the only
one who knows BJJ, D film room, E fire starter). 104 weeks, a bout every 4 weeks each (staggered), her division's named rivals
(Data.DIVISION_RIVALS) in rising order, each three times. The fight is the game's read (BoutRead.chance), with her corner's
plan written by CoachPlan.write at his tactics rating and his film opening OppFile tells; the dice fall on the fight day.
Paired arms: one rng per (rep, fighter, bout, event), the same in every arm. 30 reps a cell.

Arms (assignment rules, every week): LAZY (everyone the same: each coach's evenings split evenly over all four), STAT (best
pads/conditioning numbers first), CHEM (best chemistry + playbook fit first), NEXT (whoever boxes soonest gets the best
tactics + film), STAR (highest potential gets the best pads), SMART (expected learning: numbers x chemistry x fit x youth x
mood). Controls: CHEMOFF (the cell's best arm with chemistry and the bond set to 0) and ALL_x (one coach takes all four,
capacity ignored: which coach is right for each boxer).

A line = $1,000, 3 reputation, 0.5 of a win less loss, or 5 morale (the task's own units). Score = the sum in lines.

## 2. Bars (written before the run, not loosened)
- (a) No single assignment rule is the best arm (by score) in more than 6 of the 10 cells.
- (b) Chemistry moves an outcome by a line (cash $1,000, reputation 3, win less loss 0.5, or morale 5; best arm v CHEMOFF,
  paired) in at least 5 of the 10 cells.
- (c) The right coach differs by boxer (ALL_x v ALL_y per boxer: at least one boxer prefers each coach) in at least 5 cells.
- (d) The best arm beats LAZY by at least one line of score in at least 5 cells.
- (e) Every effect counted in (b), (c) and (d) is larger than 2 standard errors (paired); a cell whose effect is inside
  2 errors does not count.
PASS = all five.

## 3. Result: PASS on all five bars
Raw: E:/FightCamp/tmp/coachdeep1/full.jsonl (10 cells, 30 reps, 347 s, 0 script errors), run through godot_slot. Scores are
in lines (mean over 30 paired careers); ± is one standard error of the paired difference.

| Bar | Needed | Got | |
|---|---|---|---|
| (a) no rule best in more than 6 of 10 | <= 6 | CHEM 6, SMART 2, STAT 1, STAR 1 | PASS (on the edge) |
| (b) chemistry moves a line | >= 5 cells | 10 of 10 | PASS |
| (c) the right coach differs by boxer | >= 5 cells | 9 of 10 (CD fails) | PASS |
| (d) best beats LAZY by a line | >= 5 cells | 10 of 10 (+10.8 to +20.0) | PASS |
| (e) every counted effect > 2 errors | - | applied in (b), (c), (d) | PASS |

### 3.1 Score by arm (lines)
| Cell | LAZY | STAT | CHEM | NEXT | STAR | SMART | best | best − LAZY (lines) |
|---|---|---|---|---|---|---|---|---|
| AB | 109.8 | 125.0 | 124.4 | 109.9 | 111.4 | 118.7 | STAT | +15.2 ± 3.3 |
| AC | 112.1 | 120.9 | 131.8 | 117.3 | 123.8 | 126.6 | CHEM | +19.7 ± 3.3 |
| AD | 111.8 | 118.9 | 118.9 | 113.3 | 123.9 | 121.2 | STAR | +12.1 ± 2.5 |
| AE | 108.2 | 115.7 | 128.2 | 108.3 | 115.7 | 122.6 | CHEM | +20.0 ± 2.7 |
| BC | 105.5 | 104.8 | 119.6 | 111.7 | 118.9 | 120.0 | SMART | +14.5 ± 2.9 |
| BD | 106.7 | 102.8 | 121.3 | 114.8 | 102.8 | 121.3 | CHEM | +14.5 ± 2.2 |
| BE | 101.0 | 113.5 | 117.6 | 102.8 | 102.1 | 112.3 | CHEM | +16.6 ± 2.1 |
| CD | 110.2 | 119.8 | 125.4 | 112.2 | 117.7 | 125.4 | CHEM | +15.2 ± 2.4 |
| CE | 111.6 | 111.6 | 121.8 | 110.7 | 117.0 | 122.4 | SMART | +10.8 ± 2.2 |
| DE | 106.3 | 107.8 | 125.2 | 107.3 | 115.4 | 125.2 | CHEM | +18.9 ± 2.2 |

### 3.2 Chemistry on v off (the cell's best arm, paired)
| Cell | best arm | cash $ | reputation | win less loss | morale | lines moved (> 1 line and > 2 errors) |
|---|---|---|---|---|---|---|
| AB | STAT | -975.0 ± 305.2 | +4.6 ± 1.7 | +2.2 ± 0.5 | +7.5 ± 1.0 | rep, wl, morale |
| AC | CHEM | +0.0 ± 0.0 | +3.5 ± 1.3 | +1.0 ± 0.4 | +4.9 ± 0.4 | rep, wl |
| AD | STAR | +0.0 ± 0.0 | +7.2 ± 1.5 | +2.1 ± 0.4 | +7.0 ± 0.2 | rep, wl, morale |
| AE | CHEM | +0.0 ± 0.0 | +4.7 ± 1.5 | +1.3 ± 0.4 | +8.3 ± 0.4 | rep, wl, morale |
| BC | SMART | -15.0 ± 15.0 | +3.3 ± 1.1 | +1.0 ± 0.3 | +5.1 ± 0.1 | rep, wl, morale |
| BD | CHEM | +345.0 ± 190.2 | +3.8 ± 1.4 | +0.8 ± 0.5 | +9.3 ± 0.5 | rep, morale |
| BE | CHEM | -1290.0 ± 244.8 | +2.2 ± 1.1 | +1.8 ± 0.3 | +1.6 ± 0.6 | cash, wl |
| CD | CHEM | +0.0 ± 0.0 | +3.0 ± 0.9 | +0.9 ± 0.3 | +5.1 ± 0.2 | rep, wl, morale |
| CE | SMART | +0.0 ± 0.0 | +2.6 ± 0.8 | +0.7 ± 0.2 | +5.3 ± 0.2 | wl, morale |
| DE | CHEM | +0.0 ± 0.0 | +4.2 ± 1.2 | +1.2 ± 0.4 | +8.5 ± 0.2 | rep, wl, morale |

### 3.3 Which coach for which boxer (ALL_first minus ALL_second, per boxer score in lines)
| Cell | Lucy | Kira | Josh | Ana | coaches preferred (significant) | differs? |
|---|---|---|---|---|---|---|
| AB | +24.9 ± 2.5 | +15.2 ± 2.1 | +2.1 ± 0.6 | -3.8 ± 1.0 | Ana B, Josh A, Kira A, Lucy A | yes |
| AC | +7.4 ± 2.2 | +9.6 ± 1.6 | +4.3 ± 0.9 | -18.8 ± 1.8 | Ana C, Josh A, Kira A, Lucy A | yes |
| AD | +9.0 ± 1.7 | +14.5 ± 1.7 | +4.7 ± 0.8 | -4.1 ± 1.2 | Ana D, Josh A, Kira A, Lucy A | yes |
| AE | +16.1 ± 2.4 | +12.2 ± 1.7 | -6.4 ± 0.9 | +7.9 ± 1.5 | Ana A, Josh E, Kira A, Lucy A | yes |
| BC | -17.5 ± 1.7 | -5.6 ± 1.9 | +2.2 ± 1.0 | -15.1 ± 1.8 | Ana C, Josh B, Kira C, Lucy C | yes |
| BD | -15.9 ± 1.9 | -0.7 ± 1.8 | +2.5 ± 1.0 | -0.3 ± 1.3 | Josh B, Lucy D | yes |
| BE | -8.8 ± 1.6 | -3.0 ± 1.9 | -8.5 ± 1.0 | +11.7 ± 1.7 | Ana B, Josh E, Lucy E | yes |
| CD | +1.6 ± 1.0 | +4.9 ± 0.5 | +0.4 ± 0.6 | +14.8 ± 1.3 | Ana C, Kira C | no |
| CE | +8.7 ± 1.1 | +2.6 ± 0.7 | -10.7 ± 1.2 | +26.7 ± 2.2 | Ana C, Josh E, Kira C, Lucy C | yes |
| DE | +7.1 ± 1.4 | -2.3 ± 0.6 | -11.0 ± 1.2 | +12.0 ± 2.0 | Ana D, Josh E, Kira E, Lucy D | yes |

## 4. Read it honestly (what the PASS does not prove)
1. Bar (a) passes on the edge, and the two rules that use chemistry (CHEM, SMART) are best in 8 of 10 cells. "Pair by
   chemistry" is close to a dominant rule of thumb. It is not the best everywhere (STAT in AB, STAR in AD), but a critic
   should judge whether 6 of 10 is a choice or a solved puzzle.
2. Chemistry's size is mine (learning x (1 + 0.30 x chemistry), morale +3 a week): an ESTIMATE. Bar (b) shows the lever CAN
   move a line at these sizes; it does not show the sizes are right. Halve them and (b) may still pass on morale only.
3. Leaving is too cheap in the score. In the best arms one boxer leaves in many careers, and it is always Kira (heart 36,
   18, mostly losing bouts): check run E:/FightCamp/tmp/coachdeep1/who.jsonl (cells AC, BC, BE: Kira left 13-30 of 30
   under CHEM and SMART in all three cells and under STAT in BE; never under LAZY in those three - in the full run LAZY loses a boxer only in BD). Her bouts were mostly losses, so losing her costs the score little. Diagnostic
   (not the verdict, bars unchanged): charging 10 lines a departure leaves the best rules CHEM 6, STAR 2, SMART 1, STAT 1 and
   best > LAZY in 10 of 10; charging 20 lines spreads them further (STAR 4, CHEM 2, STAT 2, SMART 1, NEXT 1), best > LAZY
   in 10 of 10. The game must price a departure (Loyalty.leaves, the stipend sunk, the boxer's future) before build.
4. Bar (c) leans on Ana: a coach who does not know BJJ cannot teach her, so she always prefers the BJJ coach. Without Ana the
   right coach differs by boxer in 5 of 10 cells (AE, BC, BD, CE, DE) - exactly the bar. Coach A (Pads 15, patient) is the
   better coach for all three boxers in AB, AC and AD: an all-round good coach solves the pair. Wages must scale with ability.
5. Not probed: cutman, the other corner, hiring prices, wages (both coaches are paid in every arm, so wages cancel), the
   pro side. Cash moves only by weigh-in misses and departures (ticket cuts), so cash is the weakest line here.
6. Greybox simplifications: Ana's match is a logistic on the gap (no BJJ read in BoutRead); training is a rules copy of the
   decided pace (1.0 a focused week at a 58 coach, headroom clamp) with CoachAreas.lift and MoveMastery.gain from the game.

## 5. What this means for the design
The core lever is real at these sizes: who coaches whom moves 11-20 lines over two years against "everyone the same", and
the right answer depends on the people. Before build: (1) price a boxer leaving; (2) give wages by ability so one coach is
not best for all; (3) shrink chemistry until "pair by chemistry" is best in at most half the cells while (b) still passes -
a second probe round, measured. Critics are queued on the map (ops/research/CRITIC_COACHDEEP1_BRIEF.md: kalli, dola).
