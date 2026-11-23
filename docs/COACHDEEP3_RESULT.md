# COACHDEEP3 - deep coaches v3: bouts pay by rank, falling class nights, the coached combination, style areas (S540)

Task: ops/research/TASK_COACHDEEP3.md. Map: ops/research/DESIGN_COACHDEEP3.md. Probe: tools/coachdeep3.gd + rules copy
tools/coachdeep3_rules.gd (built from coachdeep2). Nothing under scripts/ changes.

## 1. What is probed
COACHDEEP2's setup unchanged (docs/COACHDEEP2_RESULT.md s1: the TEST CLUB, 104 weeks, YOU + Reid + one candidate of five,
2 club sizes = 10 cells, arms LAZY / STAT / CHEM / NEXT / STAR / SMART / CLASS, controls CHEMOFF, ALL_REID / ALL_X, NOHIRE,
the same score in lines and the same departure pricing) with the map's M1-M4:
- M1: each boxing bout pays the club by her place on her regional table at the bout ($450 unranked, $700 ranked 4+, $950 2-3,
  $1,200 number 1). Her ladder points move by LadderRep.change against the opponent's (LadderPoints.rep_of seed); her place =
  RankLine order against her division's rivals (Career.quick_start rows; they do not box each other in the probe). Her next
  year (the departure price) is valued at her band's pay. Leaving.REP_LEAVE_RANKED for a top-5 leaver (Leaving.RANKED_TOP).
  The grappler's bouts pay the unranked $450 (no boxing table).
- M2: class nights pay and pull members at CLASS_RETURN [1, 1, 1, 0.5, 0...].
- M3: her style's combination drilled only on coached places (half chain, half its weakest punch), named as the go-to;
  BoutRead's cache key reads own_combos since 821ddfa63 (the probe's clear_cache workaround was dropped).
- M4: stat pace by style, defence coached half pads half tactics; SMART reads the same.

## 2. Bars (written before any run, not loosened)
COACHDEEP2's nine, word for word (docs/COACHDEEP2_RESULT.md s2), with that page's (h) clarification:
- (a) No single assignment rule is the best arm (by score) in more than 6 of the 10 cells.
- (b) Chemistry moves an outcome by a line (cash $1,000, reputation 3, win less loss 0.5, or morale 5; best arm v CHEMOFF,
  paired) in at least 5 of the 10 cells.
- (c) The right coach differs by boxer (ALL_REID v ALL_X per boxer: at least one boxer prefers each coach) in at least 5 cells.
- (d) The best arm beats LAZY by at least one line of score in at least 5 cells.
- (e) Every effect counted in (b), (c), (d), (h), (i) is larger than 2 standard errors (paired); inside 2 errors does not count.
- (f) (f1) a departure is charged only by game items, the probe prints the mean price and its parts; (f2) in at least 8 of 10
  cells the best arm loses no more boxers than LAZY + 0.10 a career.
- (g) CHEM is the best arm in at most 5 of 10 cells with (b) passing; size by the sweep (1.0 / 0.6 / 0.4 / 0.25, 10 reps,
  the largest with CHEM best in at most 5), the full run at that size is the verdict.
- (h) In the best arm's sampled trade weeks (every 8th; mirror direction when it already runs classes), the class is right
  (> 2 errors) in at least a third AND the boxer is right (< -2 errors) in at least a third.
- (i) Some candidate's best HIRE arm beats the best NOHIRE arm by > 2 errors in one club size and not in the other; and in at
  least one size some hire pays.
Plus the money bar (the task):
- (j) The best plan keeps its ranked boxers: in at least 8 of 10 cells the best arm loses at most 0.10 boxers a career who were
  on the regional table (rank > 0) when they left.
PASS = all ten. Before the verdict, mode=evening measures the coached evening in wins (M3: "measure it in wins first").

## 3. Measured before the verdict
Raw: E:/FightCamp/tmp/coachdeep3/ (sweep2.txt, full.txt; evening.txt and the first sweep stayed in the earlier worker's
scratchpad), all through godot_slot, one run at a time.
- M3 evening in wins (mode=evening, 12 reps, nobody leaves so both arms fight the same opponents; coached on every asked place
  (ALL_REID, ~3.5 places a boxer a week) v never coached, 26 bouts each):
  | Boxer | v2 drill: win chance a bout / wins | v3 combination: win chance a bout / wins |
  |---|---|---|
  | Lucy | +0.119 ± 0.001 / +3.3 ± 0.4 | +0.294 ± 0.002 / +6.1 ± 0.6 |
  | Kira | +0.107 ± 0.002 / +3.5 ± 0.4 | +0.261 ± 0.002 / +7.6 ± 0.7 |
  | Josh | +0.052 ± 0.001 / +1.1 ± 0.3 | +0.184 ± 0.001 / +3.3 ± 0.6 |
  So the coached evening is worth 2.5-3.5x what it was in v2: about +0.05 to +0.08 win chance a bout for each weekly place,
  well past a stat decimal. No size changed.
- Chemistry sweep (bar g, 10 reps): size 1.0 -> CHEM best 7 (STAT 2, CLASS 1); 0.6 -> CHEM 6 (CLASS 2, STAT 2); 0.4 -> CHEM 7
  (CLASS 3); 0.25 -> CHEM 4 (CLASS 3, STAT 3). The first two sizes ran before the low-memory stop; 0.4 and 0.25 were resumed
  with the probe's new `sizes=` argument (191 s). Picked: **0.25**, the only size with CHEM best in at most 5.
- Before the resumed runs the probe's `BoutRead.clear_cache()` before each bout was dropped: BoutRead's cache key reads
  own_combos and the book since 821ddfa63, so a drilled combination re-reads by itself.

## 4. Result: FAIL (bars f2, h, j fail; a, b, c, d, e, f1, g, i pass)
Full run: `mode=full reps=30 hreps=12 size=0.25`, 10 cells, 303 s, 0 script errors. ± = one paired standard error.

| Bar | Needed | Got | |
|---|---|---|---|
| (a) no rule best in more than 6 of 10 | <= 6 | CHEM 4, CLASS 3, STAT 3 | PASS |
| (b) chemistry moves a line | >= 5 cells | 7 of 10 (not small L, F, K) | PASS |
| (c) right coach differs by boxer | >= 5 cells | 6 of 10 (L, M, S in both sizes) | PASS |
| (d) best beats LAZY by a line | >= 5 cells | 9 of 10 (big F: STAT 218.7 v LAZY 218.5) | PASS |
| (e) counted effects > 2 errors | - | applied to b, c, d, h, i, j | PASS |
| (f1) departure charged by game items only | - | as v2, plus her band's pay for the lost year | PASS |
| (f2) best arm loses <= LAZY + 0.10 boxers | >= 8 cells | 7 of 10 (small L, F, K: CLASS loses 2.0) | FAIL |
| (g) CHEM best in <= 5 of 10, (b) passing | size 0.25 | CHEM 4, (b) 7 | PASS |
| (h) class right >= 1/3 AND boxer right >= 1/3 of trade weeks | both | 109 trade weeks: class right 6 (6%), boxer right 53 (49%) | FAIL |
| (i) a hire pays in one size, not the other; some hire pays | both | F ($480): +3.5 ± 0.5 big, -4.8 ± 4.3 small; L and M pay in both | PASS |
| (j) best arm loses <= 0.10 ranked boxers | >= 8 cells | 7 of 10 (small L, F, K: 2.0, 1.97, 2.0) | FAIL |

### 4.1 Score by cell (lines), boxers lost a career, hire v no hire, which coach for which boxer
| Cell | best | best score | LAZY | best lost | LAZY lost | ranked lost | hire - NOHIRE | ALL_REID - ALL_X per boxer |
|---|---|---|---|---|---|---|---|---|
| small L | CLASS | 242.4 | 209.4 | 2.00 | 0.00 | 2.00 | 32.7 ± 4.3 | Ana 0.0±0.0 / Josh -6.8±1.2 / Kira 9.6±1.5 / Lucy 12.6±2.2 |
| small M | STAT | 236.0 | 102.6 | 0.00 | 1.00 | 0.00 | 26.3 ± 1.4 | Ana -125.0±1.8 / Josh 0.1±0.5 / Kira 2.5±0.9 / Lucy 7.3±1.6 |
| small S | CHEM | 194.7 | 187.0 | 0.00 | 0.00 | 0.00 | -15 ± 1.2 | Ana 0.0±0.0 / Josh -3.9±1.1 / Kira 20.7±2.6 / Lucy 13.7±2.3 |
| small F | CLASS | 204.9 | 195.2 | 2.00 | 0.00 | 1.97 | -4.8 ± 4.3 | Ana 0.0±0.0 / Josh 3.2±0.6 / Kira 7.7±1.6 / Lucy 9.4±1.3 |
| small K | CLASS | 169.9 | 140.2 | 2.00 | 0.00 | 2.00 | -39.7 ± 3.8 | Ana 0.0±0.0 / Josh -10.3±1.5 / Kira -0.2±0.9 / Lucy -2.6±0.5 |
| big L | CHEM | 255.4 | 232.7 | 0.00 | 0.00 | 0.00 | 40.1 ± 1.2 | Ana 0.0±0.0 / Josh -6.8±1.2 / Kira 9.6±1.5 / Lucy 12.6±2.2 |
| big M | STAT | 257.6 | 128.0 | 0.00 | 1.00 | 0.00 | 42.4 ± 1.4 | Ana -125.0±1.8 / Josh 0.1±0.5 / Kira 2.5±0.9 / Lucy 7.3±1.6 |
| big S | CHEM | 217.4 | 210.4 | 0.00 | 0.00 | 0.00 | 2.1 ± 1.2 | Ana 0.0±0.0 / Josh -3.9±1.1 / Kira 20.7±2.6 / Lucy 13.7±2.3 |
| big F | STAT | 218.7 | 218.5 | 0.00 | 0.00 | 0.00 | 3.5 ± 0.5 | Ana 0.0±0.0 / Josh 3.2±0.6 / Kira 7.7±1.6 / Lucy 9.4±1.3 |
| big K | CHEM | 173.9 | 163.6 | 0.00 | 0.00 | 0.00 | -41.4 ± 1.5 | Ana 0.0±0.0 / Josh -10.3±1.5 / Kira -0.2±0.9 / Lucy -2.6±0.5 |

NOHIRE (YOU + Reid): every pad-first rule 206-215 lines, nobody leaves; CLASS 182 (small) / 189 (big) and loses all three
boxers. So without a hire the boxers win now; v2 had CLASS first there by 100 lines.

### 4.2 The small club with a cheap or weak hire (small L, F, K)
CLASS is best and lets Josh and Kira go (30 of 30 careers each; both ranked when they leave). Small L, CLASS v CHEM: cash
+$1,549, reputation -18.4, win less loss +10.9 (33.6 v 22.7), class nights 923 v 633. The margin is win less loss: Lucy keeps
every coached evening and wins more, and the two who left stop taking losses. A departure costs only 1.6-3.8 lines (her
band's next year: cash -1.7 to -2.0 lines, i.e. a ranked year at ~$660-750 a bout still does not pay $13,000 of stipend;
reputation +1.9 to +3.9; Leaving +1.7).

### 4.3 The evening trade (bar h), per cell
| Cell / best arm | trade weeks | class right | boxer right |
|---|---|---|---|
| small L CLASS | 6 | 2 | 0 |
| small M STAT | 13 | 0 | 2 |
| small S CHEM | 12 | 0 | 11 |
| small F CLASS | 8 | 2 | 0 |
| small K CLASS | 5 | 2 | 0 |
| big L CHEM | 13 | 0 | 10 |
| big M STAT | 13 | 0 | 2 |
| big S CHEM | 13 | 0 | 10 |
| big F STAT | 13 | 0 | 8 |
| big K CHEM | 13 | 0 | 10 |

The v2 failure flipped: the coached combination made a pad evening worth more than a class night almost everywhere a
boxer stays. The class is right only in the three small CLASS cells.

## 5. Verdict and what to change (stop here: no critics queued, per the task)
FAIL - 7 of 10 bars pass (a, b, c, d, e, g, i); f (its f2 half), h and j fail. The owner's pick works where it was aimed: in 7 of 10 cells
and both NOHIRE clubs the best plan keeps every boxer, chemistry and the coach-for-boxer choice now matter (b, c pass for the
first time together), and no rule wins everywhere. Three things left, in this order:
1. A RANKED YEAR MUST PAY ITS STIPEND (bars f2, j). The best arms' boxers fight at ~$740 a bout (most ranked 4th or lower), 13
   bouts = ~$9,600 against $13,000 of stipend. Move the "ranked 4th or lower" band from $700 to $1,000 (= the stipend at a
   bout every 4 weeks) and 2-3 to $1,200, number 1 to $1,500 (~80 tickets: a regional name above the 55-60 small-hall line);
   unranked stays $450. One probe knob, then rerun.
2. THE DEPARTURE PRICE MUST SEE THE WINS SHE TAKES WITH HER (bar f2): today a losing boxer leaving raises win less loss. Price
   her lost bouts at her last win chance in the score's win-less-loss line (expected wins minus losses of her next 13), not
   only her pay and reputation, so shedding a boxer is never a win-record gain.
3. CLASS NIGHTS BY CLUB SIZE (bar h): the class is right in 6 of 109 trade weeks. Let the falling returns follow the members
   (one full class night per 12 members, then the half night, then nothing) instead of a fixed [1, 1, 1, 0.5]: in a big club
   the 4th and 5th class still pay, so a second coach's evening is a real trade there. Target before the rerun: neither side
   right in more than two thirds of trade weeks in the 10-rep diagnostic.
Then the same ten bars, size by the sweep again.
