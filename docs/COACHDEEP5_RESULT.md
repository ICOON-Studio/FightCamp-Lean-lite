# COACHDEEP5 - deep coaches v5: a catchment ceiling on the members, ties printed, chemistry swept below 0.25 (S541)

Task: ops/research/TASK_COACHDEEP5.md. Map: ops/research/DESIGN_COACHDEEP5.md. Probe: tools/coachdeep5.gd + rules copy
tools/coachdeep5_rules.gd (built from coachdeep4). Nothing under scripts/ changes.

## 1. What is probed
COACHDEEP4's setup unchanged (TEST CLUB, 104 weeks, YOU + Reid + one candidate of five, 2 club sizes = 10 cells, arms LAZY /
STAT / CHEM / NEXT / STAR / SMART / CLASS, controls CHEMOFF, ALL_REID / ALL_X, NOHIRE; v4's rank bands and record line kept)
with COACHDEEP4 s5 items 1-3:
- CATCHMENT: members target = min(natural(reputation now) + add + class pull, natural(reputation at START) + add + 12) =
  66 small / 96 big; a won bout's +8 members cannot take the club past it either (map s1.3, added after the trial).
- Chemistry sweep 1.0 / 0.6 / 0.4 / 0.25, then 0.15 / 0.10 only if CHEM is best in more than 5 of 10 at 0.25 (map s2, written
  before any run).
- Ties within 0.01 line printed ("CHEM = SMART"); in bars a and g every tied arm counts as best (map s3: can only make them harder).

## 2. Bars (written before any run, not loosened)
COACHDEEP4's ten, word for word: ops/research/DESIGN_COACHDEEP5.md s4 (= docs/COACHDEEP4_RESULT.md s2), only bar g's size
list extended as map s2 says. PASS = all ten.

## 3. Measured before the verdict
Raw: E:/FightCamp/tmp/coachdeep5/ (trial.txt, trial_rep.txt, trial2.txt, sweep.txt, sweep_ext.txt, diag.txt, full.txt; bar
reader bars.py), godot_slot jobs, 0 script errors. The full run took 63 min (the PC went RED on commit memory beside three
other jobs; v4's took 6).
- ONE-REP TRIAL (feedback loops, map s5), mode=full reps=1 hreps=1 size=0.25:
  - catch=start, ceiling on the target only: **members out of band in 94 arms** - small 74 at week 104 v catchment 66 (peak
    88), big 104 v 96. A won bout's +8 members sat on top of the capped target. STOP rule hit: map s1.3 changed (the ceiling
    holds the members too), trial rerun.
  - catch=rep diagnostic (the ceiling moving with reputation): small 109-128, big 110-150. It caps nothing: reputation, not
    the class nights, grew v4's clubs (v4's ALL_REID / ALL_X arms, 0 class nights, ended at 113-117 small).
  - Rerun (trial2): every arm ends at its catchment (66 / 96), 0 out of band; best arms differ (CHEM = SMART, STAT = STAR,
    CLASS). Neither stop rule hit, so on to the sweep.
- Chemistry sweep (bar g, 10 reps; ties count for each tied arm): 1.0 -> CHEM 7; 0.6 -> 6; 0.4 -> 7; 0.25 -> 6 (CLASS 3,
  STAT 1, STAR 1). CHEM over 5 at 0.25, so the written extension ran: **0.15 -> CHEM 5** (SMART 6, CLASS 3, STAT 1, STAR 1);
  0.10 -> 6. Verdict size **0.15**, the largest with CHEM best in at most 5.
- 10-rep class diagnostic (size 0.15): 45 trade weeks, class right 36 (80%), boxer right 0. **Target missed** (class right
  over two thirds).
- Loop prints at week 104 (full run): members = catchment in every arm (66 / 96); cash small -$18k (K, a $1,000 wage) to
  +$82k (NOHIRE CLASS), big +$17k to +$127k (v4: up to +$165k) - bounded. Chemistry is one-way in the code (traits + a bond
  that grows with coached weeks, cap 0.25; wins move morale and loyalty, not chemistry), as the map said.

## 4. Result: FAIL (bars f, h, j fail; a, b, c, d, e, g, i pass) - 7 of 10
Full run: `mode=full reps=30 hreps=12 size=0.15`, 10 cells. +- = one paired standard error.

| Bar | Needed | Got | |
|---|---|---|---|
| (a) no rule best in more than 6 of 10 | <= 6 | SMART 6, CHEM 5, CLASS 3, STAT 1, STAR 1 (ties counted for each) | PASS |
| (b) chemistry moves a line | >= 5 cells | 6 of 10 (small L, M, S, F; big M, S) | PASS |
| (c) right coach differs by boxer | >= 5 cells | 6 of 10 (small L, M, S; big L, M, S) | PASS |
| (d) best beats LAZY by a line | >= 5 cells | 9 of 10 (not small F: 0.86 +- 0.53) | PASS |
| (e) counted effects > 2 errors | - | applied to b, c, d, h, i | PASS |
| (f1) departure charged by game items only | - | price ~11-22 lines: e.g. big L CLASS 15.6 = cash 0.2, reputation 9.2, record 4.7, Leaving 1.5 | PASS |
| (f2) best arm loses <= LAZY + 0.10 boxers | >= 8 cells | **7 of 10** (big L, F, K: CLASS loses 2.00 v LAZY 0.00) | FAIL |
| (g) CHEM best in <= 5 of 10, (b) passing | a sweep size | CHEM 5 at 0.15, b passes there (6) | PASS |
| (h) class right >= 1/3 AND boxer right >= 1/3 of trade weeks | both | 45 trade weeks: class right 37 (82%), boxer right 0 | FAIL |
| (i) a hire pays in one size, not the other; some hire pays | both | S: +2.1 +- 1.4 small (no), +10.5 +- 5.3 big (yes); K: -39.5 small, +14.7 +- 2.6 big; L, M, F pay in both | PASS |
| (j) best arm loses <= 0.10 ranked boxers | >= 8 cells | **7 of 10** (big L 1.70, big F 1.57, big K 1.87) | FAIL |

f = f1 and f2: f fails on f2.

### 4.1 Score by cell (lines), boxers lost a career, hire v no hire, members at the end
| Cell | best (ties) | best score | LAZY | best lost | LAZY lost | ranked lost | hire - NOHIRE | members / catchment |
|---|---|---|---|---|---|---|---|---|
| small L | CHEM = SMART | 256.4 | 229.2 | 0.00 | 0.00 | 0.00 | 39.4 +- 1.4 | 66 / 66 |
| small M | CHEM = SMART | 252.8 | 109.5 | 0.00 | 1.00 | 0.00 | 35.9 +- 1.5 | 66 / 66 |
| small S | CHEM = SMART | 219.1 | 209.7 | 0.00 | 0.00 | 0.00 | 2.1 +- 1.4 | 66 / 66 |
| small F | STAT = STAR | 219.1 | 218.2 | 0.00 | 0.00 | 0.00 | 2.1 +- 0.5 | 66 / 66 |
| small K | SMART | 177.5 | 162.9 | 0.00 | 0.00 | 0.00 | -39.5 +- 1.5 | 66 / 66 |
| big L | CLASS | 327.4 | 264.6 | 2.00 | 0.00 | 1.70 | 83.5 +- 2.8 | 96 / 96 |
| big M | CHEM = SMART | 279.0 | 144.2 | 0.00 | 1.00 | 0.00 | 35.1 +- 5.4 | 96 / 96 |
| big S | CHEM = SMART | 254.5 | 245.1 | 0.00 | 0.00 | 0.00 | 10.5 +- 5.3 | 96 / 96 |
| big F | CLASS | 292.9 | 253.6 | 2.00 | 0.00 | 1.57 | 49.0 +- 2.9 | 96 / 96 |
| big K | CLASS | 258.6 | 198.3 | 2.00 | 0.00 | 1.87 | 14.7 +- 2.6 | 96 / 96 |

NOHIRE (YOU + Reid): small STAT 217.0 (nobody leaves), big CLASS 243.9 (all three boxers leave; STAT/SMART 242.4).

### 4.2 The evening trade (bar h), per cell
| Cell / best arm | trade weeks | class right | boxer right |
|---|---|---|---|
| small L, S, F, K | 0 | - | - |
| small M CHEM | 13 | 11 | 0 |
| big L CLASS | 2 | 1 | 0 |
| big M CHEM | 13 | 13 | 0 |
| big S CHEM | 13 | 8 | 0 |
| big F CLASS | 2 | 2 | 0 |
| big K CLASS | 2 | 2 | 0 |

### 4.3 What v5 fixed, and what it showed
- The ceiling works as a loop cap: members sit at the catchment in every arm, the club-size question is back (bar i passes for
  the first time since v3: the Solid engine room pays only in the big club, the Known name loses money in the small one and
  pays in the big one), and the chemistry rule no longer wins everywhere (a, g pass; b still passes at 0.15).
- In the SMALL club the evening trade has gone: 66 members want 6 class nights, the 12 coach evenings hold 6 pad evenings
  (4 boxers x 3 places) and 6 classes, so no evening is short and there is nothing to trade (0 trade weeks in 4 of 5 cells).
- In the BIG club (96 members, 9 class nights wanted) CLASS wins 3 cells by letting Josh and Kira go: their evenings become
  class nights. Per boxer the CLASS plan is worse (big L: Josh 6.1 v 19.9 lines, Kira 12.1 v 31.7), but the club gains the
  class cash and the two stipends, and by year 2 the ladder (opponents by bout count, as AmateurBooking.experience_match_ok
  does) has outgrown both: kept to the end they carry a losing record and a $250 stipend, a negative next year, so the score
  says let them go. Their departure price is charged (11-22 lines) and still loses to ~9 class nights a week.
- The boxer side of the trade is never right (0 of 45; v4 0 of 117): one pad evening (2 places) for one week moves her wins
  less than 2 errors over 104 weeks, while a class night's ~$117 is paid every time.

## 5. Verdict and what to change (stop here: no critics queued, per the task)
FAIL - 7 of 10 (a, b, c, d, e, g, i pass; f, h, j fail). The catchment ceiling did its job: v4's unbounded loop is closed and
bars a, g, i pass together for the first time.

Can the mechanic reach 8? **The coach part can; the class-night-or-pads evening, as built, cannot.** Bars b, c, d, g, i -
chemistry matters, the right coach differs by boxer, a smart plan beats lazy, the hire depends on club size - now pass
together. Bar h has failed in v3, v4 and v5 in both directions (v3 class right 6 of 109; v4 79%; v5 82%, boxer right 0 in
v4 and v5): one week's pad evening is too small to see, and the class night is either free (small club) or always right
(big club). The bar asks for the trade to be a real question in a third of the weeks each way; four rounds of numbers have
not got it there. My call: the OWNER'S CUT-OR-KEEP QUESTION is the evening trade, not the coaches -

- KEEP COACHES, CUT THE EVENING TRADE AS A DEPTH CLAIM (my recommendation): class nights run on the evenings the boxers do not
  need (a timetable fact the week plan shows), bar h is dropped from this mechanic, and f2/j are fixed by item 1 below. The
  coach map then goes to the critics on chemistry, the right coach per boxer, the plan and the hire.
- KEEP THE TRADE: one more round (v6), and only these, in order:
  1. A KEPT BOXER'S EVENINGS CANNOT BECOME CLASSES WITHOUT HER SAYING SO (bars f2, j): today a boxer short of pads leaves at
     the loyalty floor, so the class plan sheds her for her evenings. Real-world: a club that cuts a carded boxer's sessions
     for kids' classes loses her to the club down the road, and the club's reputation with the other boxers - charge a short
     week below her ask a Leaving-style reputation cost for each teammate (Loyalty teammate_left already exists), so shedding
     her is priced where it happens, not only in her year.
  2. THE TRADE IN THE WEEKS IT MATTERS (bar h): sample the trade in a boxer's fight week (a bout within 2 weeks), where a short
     pad week costs her the film evening and the plan rating (BoutRead), not in every 8th week. This changes bar h's sample -
     a written change in the v6 map before any run.
  If v6 still fails h, the trade is cut.

Owner question to put on the board (Claude, not this session): "Coach evenings: keep the class-night-or-pads trade for one
more round, or cut it and send the coaches to critics?" - options "Cut it, critics next|One more round".
