# COACHDEEP4 - deep coaches v4: ranked bouts pay a stipend, a departure takes her wins, class nights follow the members (S541)

Task: ops/research/TASK_COACHDEEP4.md. Map: ops/research/DESIGN_COACHDEEP4.md. Probe: tools/coachdeep4.gd + rules copy
tools/coachdeep4_rules.gd (built from coachdeep3). Nothing under scripts/ changes.

## 1. What is probed
COACHDEEP3's setup unchanged (docs/COACHDEEP3_RESULT.md s1: the TEST CLUB, 104 weeks, YOU + Reid + one candidate of five,
2 club sizes = 10 cells, arms LAZY / STAT / CHEM / NEXT / STAR / SMART / CLASS, controls CHEMOFF, ALL_REID / ALL_X, NOHIRE,
M1-M4) with COACHDEEP3 s5 items 1-3:
- Bands: unranked $450, ranked 4th or lower $1,000, 2nd-3rd $1,200, number 1 $1,500 (R.PAY_BANDS).
- Next year and the departure price add her record: 13 x (2p - 1) at her last win chance, in the win-less-loss line (R.year_value).
- Class nights: one full per 12 members, then one half, then nothing; demand = full + 1 (R.class_share(n, members)).

## 2. Bars (written before any run, not loosened)
COACHDEEP3's ten, word for word (docs/COACHDEEP3_RESULT.md s2):
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
- (j) The best plan keeps its ranked boxers: in at least 8 of 10 cells the best arm loses at most 0.10 boxers a career who were
  on the regional table (rank > 0) when they left.
PASS = all ten. Diagnostic target before the verdict (map s3): in the 10-rep diagnostic (mode=full reps=10 hreps=10 at the
swept size) neither the class nor the boxer is right in more than two thirds of trade weeks. Reported, not a bar.

## 3. Measured before the verdict
Raw: E:/FightCamp/tmp/coachdeep4/ (smoke.txt, sweep.txt, diag.txt, full.txt), one godot_slot batch (sweep 408 s, diagnostic
189 s, full 371 s), 0 script errors.
- Chemistry sweep (bar g, 10 reps): size 1.0 -> CHEM best 10 of 10; 0.6 -> 10; 0.4 -> 10; 0.25 -> CHEM 8 (CLASS 1, STAT 1).
  No size has CHEM best in at most 5. The batch fell back to the smallest swept size, **0.25**, for the diagnostic and the
  verdict (as v3 did), so the run below is the verdict at the sweep's floor.
- Class diagnostic (map s3 target; mode=full reps=10 hreps=10 size=0.25): 122 trade weeks, class right 101 (83%), boxer right
  0. **Target missed** (neither side over two thirds): the v3 failure flipped the other way.
- Why: the members no longer stop. Every arm's club ends the 104 weeks at 127-150 members, both the small (30) and the big
  (70) start: each class night pulls members (CLASS_TARGET x its share), more members open more full nights, and only
  StaffRoles' room (volunteers + coaches) ends it. At 127 members there are 10 full nights wanted and 12 coach evenings, so
  any evening is worth more as a class (best arms run 520-650 class nights in two years, CLASS ~1,100).

## 4. Result: FAIL (bars a, g, h, i fail; b, c, d, e, f, j pass)
Full run: `mode=full reps=30 hreps=12 size=0.25`, 10 cells. ± = one paired standard error.

| Bar | Needed | Got | |
|---|---|---|---|
| (a) no rule best in more than 6 of 10 | <= 6 | CHEM 7, CLASS 2, STAT 1 (SMART ties CHEM to the decimal in every cell: same plan) | FAIL |
| (b) chemistry moves a line | >= 5 cells | 8 of 10 (not small L, small F) | PASS |
| (c) right coach differs by boxer | >= 5 cells | 6 of 10 (small L, small M, small S, big L, big M, big S) | PASS |
| (d) best beats LAZY by a line | >= 5 cells | 8 of 10 (not small F CLASS 272.4 v LAZY 270.3; big F STAT 293.2 v LAZY 292.9) | PASS |
| (e) counted effects > 2 errors | - | applied to b, c, d, h, i, j | PASS |
| (f1) departure charged by game items only | - | as v3 + her record: price ~20 lines (cash 0.9, reputation 10.6, record 7.0, Leaving 1.5) | PASS |
| (f2) best arm loses <= LAZY + 0.10 boxers | >= 8 cells | 8 of 10 (small L, small F: CLASS loses all 3) | PASS |
| (g) CHEM best in <= 5 of 10, (b) passing | a sweep size | CHEM 7 at 0.25, no swept size qualifies | FAIL |
| (h) class right >= 1/3 AND boxer right >= 1/3 of trade weeks | both | 117 trade weeks: class right 92 (79%), boxer right 0 | FAIL |
| (i) a hire pays in one size, not the other; some hire pays | both | L, M, S, F pay in both sizes (+22 to +77); K loses in both (-20.3 ± 1.5 small, -4.2 ± 1.5 big) | FAIL |
| (j) best arm loses <= 0.10 ranked boxers | >= 8 cells | 8 of 10 (small L 2.77, small F 2.73) | PASS |

### 4.1 Score by cell (lines), boxers lost a career, hire v no hire, members at the end
| Cell | best | best score | LAZY | best lost | LAZY lost | ranked lost | hire - NOHIRE | members |
|---|---|---|---|---|---|---|---|---|
| small L | CLASS | 313 | 280.3 | 3.00 | 0.00 | 2.77 | 63.8 ± 5.1 | 133 |
| small M | CHEM | 298.7 | 153.2 | 0.00 | 1.00 | 0.00 | 49.6 ± 1.5 | 129 |
| small S | CHEM | 271.4 | 261.1 | 0.00 | 0.00 | 0.00 | 22.2 ± 1.2 | 127 |
| small F | CLASS | 272.4 | 270.3 | 3.00 | 0.00 | 2.73 | 23.3 ± 4.8 | 127 |
| small K | CHEM | 228.8 | 214.3 | 0.00 | 0.00 | 0.00 | -20.3 ± 1.5 | 127 |
| big L | CHEM | 331.6 | 302.6 | 0.00 | 0.00 | 0.00 | 76.9 ± 1.2 | 150 |
| big M | CHEM | 318.9 | 178.4 | 0.00 | 1.00 | 0.00 | 64.2 ± 1.5 | 150 |
| big S | CHEM | 293 | 284.2 | 0.00 | 0.00 | 0.00 | 38.3 ± 1.2 | 149 |
| big F | STAT | 293.2 | 292.9 | 0.00 | 0.00 | 0.00 | 38.4 ± 0.4 | 149 |
| big K | CHEM | 250.6 | 237.4 | 0.00 | 0.00 | 0.00 | -4.2 ± 1.5 | 149 |

NOHIRE (YOU + Reid): STAT best in both sizes (249.2 small, 254.8 big), nobody leaves; CLASS loses all three boxers (242.5 /
254.3).

### 4.2 The evening trade (bar h), per cell
| Cell / best arm | trade weeks | class right | boxer right |
|---|---|---|---|
| small L CLASS | 7 | 1 | 0 |
| small M CHEM | 13 | 13 | 0 |
| small S CHEM | 12 | 10 | 0 |
| small F CLASS | 8 | 3 | 0 |
| small K CHEM | 12 | 10 | 0 |
| big L CHEM | 13 | 9 | 0 |
| big M CHEM | 13 | 13 | 0 |
| big S CHEM | 13 | 10 | 0 |
| big F STAT | 13 | 13 | 0 |
| big K CHEM | 13 | 10 | 0 |

### 4.3 What v4 fixed
- The money now keeps ranked boxers: f2 and j pass (8 of 10, from 7). Ranked best arms fight at ~$930 a bout (v3 ~$740), and
  a departure costs ~20 lines, a third of it the record she takes with her (v3: 1.6-3.8 lines).
- Chemistry moves a line in 8 cells (v3 7) and the right coach still differs by boxer in 6.
- The two cells still lost (small L, small F) are lost to the class snowball, not to the money: CLASS gives up all three
  boxers (~60 lines of departures) and still wins by 2 lines on ~1,100 class nights at ~130 members.

## 5. Verdict and what to change (stop here: no critics queued, per the task)
FAIL - 6 of 10 bars pass (b, c, d, e, f, j); a, g, h, i fail. Items 1 and 2 worked (f2 and j now pass). Item 3 over-shot:
letting the class nights follow the members, with the members following the class nights, has no ceiling but the room,
so both clubs grow to ~130-150 and the club-size question vanishes (h, i) and keeping every boxer with the chemistry rule
wins nearly everywhere (a, g). In this order:
1. A CATCHMENT CEILING ON CLASS MEMBERS (bars h, i, then a, g). Class nights keep members and fill nights; they must not
   grow the town. Cap the class pull on the members target at the club size's catchment - the town's natural members +
   the size's add + at most one full class night's worth (12) - so a small club stays ~40-45 and a big one ~85-95.
   ESTIMATE: a boxing club draws from a few miles; StaffRoles' room is a coaching limit, not demand. Then rerun the
   10-rep diagnostic first: target unchanged (neither side right in more than two thirds of trade weeks).
2. SWEEP CHEMISTRY BELOW 0.25 ONLY IF THE CEILING DOES NOT BRING CLASS BACK (bar g). In v3 CLASS was the counterweight
   (3 cells) that held CHEM to 4; with the ceiling it should take the small cells back. If CHEM is still best in more than
   5 of 10 at 0.25, extend the sweep to 0.15 / 0.10 - a change to bar g's size list, so it goes in the v5 map as a
   written change before any run, not as a loosening after one.
3. COUNT SMART AND CHEM AS WHAT THEY ARE (bar a, reporting only): they tie to the decimal in all 10 cells (same plan at
   chemistry 0.25), and _best's order hands every tie to CHEM. v5 prints ties so a cell won by "CHEM = SMART" is read as
   the player's sensible rule, not as chemistry alone.
Then the same ten bars, the 10-rep diagnostic first.
