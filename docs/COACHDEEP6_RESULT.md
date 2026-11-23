# COACHDEEP6 - deep coaches v6: classes take the free evenings, the evening trade is cut (S542)

Task: ops/research/TASK_COACHDEEP6.md. Map: ops/research/DESIGN_COACHDEEP6.md (written before any run). Probe:
tools/coachdeep6.gd + rules copy tools/coachdeep6_rules.gd (built from coachdeep5). Nothing under scripts/ changes.
Raw: E:/FightCamp/tmp/coachdeep6/ (trial.txt, sweep.txt, sweep_ext.txt, full.txt, bars.py, extra.py), all through
godot_slot (who COACHDEEP6), watchdog GREEN at each start, 0 script errors. Trial 8 s, sweep + full run 5.5 min.

## 1. What is probed
v5's setup unchanged (TEST CLUB, 104 weeks, YOU + Reid + one candidate of five, 2 club sizes = 10 cells; controls CHEMOFF,
ALL_REID / ALL_X, NOHIRE; rank bands, record line, catchment 66 / 96, ties printed) with the map's three changes:
- Classes run only on the coach evenings no kept boxer needs (places dealt first; a free evening becomes a class night if the
  members fill it, never past class_demand). A timetable fact, not a choice.
- The CLASS arm is gone: arms LAZY / STAT / CHEM / NEXT / STAR / SMART. No plan sheds a boxer for her evenings.
- Bar h (trade weeks) dropped; no trade sampling in the probe.

## 2. Bars (map s4, written before any run, not loosened)
v5's a, b, c, d, e, f, g, i, j word for word; bar a's arm list without CLASS. PASS = all nine.

## 3. Measured before the verdict
- ONE-REP TRIAL (feedback loops, map s6), mode=full reps=1 size=0.15: members at week 104 = catchment in every arm (66 small,
  96 big; 0 out of the catchment + 5 band); class nights run past wanted: 0 arms; best arms differ (CHEM = SMART 6, STAT = STAR 2,
  SMART 2). No stop rule hit. Already visible: SMART tied-best in 8 of 10.
- New loop (free evenings -> class nights -> cash -> hire -> evenings), per arm over 104 weeks: small club runs 4.7-5.9 class
  nights a week v 5.9 wanted; big club 4.8-6.2 v 8.9 wanted - the big club is ~2.7 nights short of what its members want,
  because the free evenings run out first. Cash at week 104: small -$84k (K, $1,000 a week) to +$66k, big -$59k to +$101k;
  NOHIRE (YOU + Reid, 1.25 class nights) $35k small / $60k big. Bounded: a class night is never run past demand and pays
  nothing past it (class_share). In the probe the hire is fixed per cell, so the loop stays open; in the game the cap is the
  catchment's class demand (6 / 9 nights).
- Chemistry -> learning -> wins: one-way in the code, v6 does not touch it (traits + a bond that grows with coached weeks, cap
  0.25; wins move morale and loyalty, separate lines).
- Chemistry size (map s4, written before the run): at 0.15 CHEM best in **6** of 10 (> 5), so 0.10 ran: CHEM **8** of 10
  (sweep, 10 reps). Neither qualifies: the verdict runs at **0.10** and bar g fails, as the map says.

## 4. Result: FAIL - 7 of 9 (a and g fail; b, c, d, e, f, i, j pass)
Full run: `mode=full reps=30 size=0.10`, 10 cells. +- = one paired standard error.

| Bar | Needed | Got | |
|---|---|---|---|
| (a) no rule best in more than 6 of 10 | <= 6 | **SMART 8**, CHEM 6, STAT 2, STAR 2 (ties counted for each) | FAIL |
| (b) chemistry moves a line | >= 5 cells | 6 of 10 | PASS |
| (c) right coach differs by boxer | >= 5 cells | 6 of 10 (L, M, S in both sizes) | PASS |
| (d) best beats LAZY by a line | >= 5 cells | 8 of 10 (not F: 0.45 +- 0.63 in both sizes) | PASS |
| (e) counted effects > 2 errors | - | applied to b, c, d, i | PASS |
| (f1) departure charged by game items only | - | only LAZY in M loses a boxer (Ana, 30 of 30): 23.6 lines = cash 5.9, reputation 10.4, record 6.7, Leaving 0.7 | PASS |
| (f2) best arm loses <= LAZY + 0.10 boxers | >= 8 cells | **10 of 10** (the best arm loses nobody in any cell) | PASS |
| (g) CHEM best in <= 5 of 10, (b) passing | a sweep size | 0.15 -> 6, 0.10 -> 8 (sweep); full run at 0.10: 6 | FAIL |
| (i) a hire pays in one size, not the other; some hire pays | both | S: +2.5 +- 1.4 small (no), +12.4 +- 1.4 big (yes); K loses in both (-38.7, -28.8); L, M, F pay in both | PASS |
| (j) best arm loses <= 0.10 ranked boxers | >= 8 cells | **10 of 10** | PASS |

### 4.1 Score by cell (lines over two years)
| Cell | best (ties) | best | LAZY | best - LAZY | best - worst plan (worst) | chemistry on - off | hire - NOHIRE | class nights run / wanted |
|---|---|---|---|---|---|---|---|---|
| small L | CHEM = SMART | 255.9 | 229.2 | 26.7 +- 1.9 | 12.4 +- 1.4 (NEXT) | 2.5 +- 0.7 | 40.2 +- 1.5 | 5.93 / 5.93 |
| small M | CHEM = SMART | 251.7 | 108.9 | 142.8 +- 2.0 | 3.6 +- 0.9 (NEXT) | 3.4 +- 1.0 | 35.9 +- 1.5 | 4.97 / 5.92 |
| small S | CHEM = SMART | 218.3 | 208.6 | 9.7 +- 1.3 | 30.7 +- 3.2 (NEXT) | 2.5 +- 0.7 | 2.5 +- 1.4 | 5.93 / 5.93 |
| small F | STAT = STAR | 217.6 | 217.2 | 0.4 +- 0.6 | 17.7 +- 2.1 (NEXT) | 3.1 +- 0.7 | 1.8 +- 0.4 | 5.92 / 5.92 |
| small K | SMART | 177.1 | 161.8 | 15.3 +- 1.3 | 3.5 +- 1.2 (STAT) | 1.2 +- 0.5 | -38.7 +- 1.4 | 5.93 / 5.93 |
| big L | CHEM = SMART | 291.3 | 264.6 | 26.7 +- 1.9 | 12.3 +- 1.4 (NEXT) | 2.5 +- 0.7 | 50.1 +- 1.5 | 6.24 / 8.93 |
| big M | CHEM = SMART | 277.9 | 143.6 | 134.3 +- 2.0 | 3.7 +- 0.9 (NEXT) | 3.4 +- 1.0 | 36.7 +- 1.5 | 5.00 / 8.93 |
| big S | CHEM = SMART | 253.6 | 244.0 | 9.7 +- 1.3 | 30.6 +- 3.2 (NEXT) | 2.5 +- 0.7 | 12.4 +- 1.4 | 6.24 / 8.93 |
| big F | STAT = STAR | 253.0 | 252.6 | 0.4 +- 0.6 | 17.6 +- 2.1 (NEXT) | 3.1 +- 0.7 | 11.8 +- 0.4 | 6.24 / 8.92 |
| big K | SMART | 212.4 | 197.2 | 15.3 +- 1.3 | 3.5 +- 1.2 (STAT) | 1.2 +- 0.5 | -28.8 +- 1.5 | 6.24 / 8.93 |
NOHIRE best: STAT, small 215.8, big 241.2, nobody leaves.

### 4.2 What the numbers show
- Cutting the trade did what v5 s5 said: f2 and j pass 10 of 10 (they failed only because CLASS shed Josh and Kira).
- With the trade gone, **the boxer side of every cell is the same in both club sizes** (best - LAZY, plan spread, chemistry,
  per-boxer coach: identical to the decimal). Club size now changes only the class money, so it reaches only the hire.
  The 10 cells are 5 distinct coaching puzzles, and one rule, SMART (the coach whose areas, specialties, fit and chemistry suit
  her most), is best or tied-best in 4 of the 5; in the fifth (the film-room coach F) every plan except NEXT ties with LAZY.
  CHEM = SMART ties are the same plan to the decimal: at 0.10-0.15 chemistry rarely changes who gets whom. That is bar a's fail.
- The M cells' huge LAZY gap (134-143 lines) is one boxer: the BJJ fighter left with no BJJ coach in the round robin. "Put the
  mat coach on the mat fighter" is not a choice; without it best - LAZY is 0.4-27 lines over two years.

## 5. What is left to decide now the trade is gone, with its measured size
- WHO COACHES WHOM: real per boxer (bar c: Reid v the candidate differs by boxer in 6 of 10, e.g. small S: Kira +23.9, Josh
  -6.2 lines with Reid) - but one rule finds it. The sizes: best - LAZY 0.4-27 lines over two years (9.7-27 in 6 of 10), the
  plan spread best - worst 3.5-30.7 lines; chemistry on v off 1.2-3.4 lines (one to three lines in two years: the bond / clash
  word matters, but rarely changes the pairing).
- THE PLAN: a solved puzzle - SMART best or tied in 8 of 10, a rule a player would find in a few weeks and the game could
  offer as "Auto: best fit". NEXT (feeding the fight week) is the worst plan in 8 cells.
- THE HIRE BY CLUB SIZE: the real choice left, and a big one. Local L +40 / +50, mat coach M +36 / +37 (it also keeps the BJJ
  fighter), engine room S +2.5 small (no) / +12.4 big, film room F +1.8 / +11.8, the known name K -39 small / -29 big at
  $1,000 a week. The big club is ~2.7 class nights short of its members a week, so a hire's evenings are worth more there.
  This is a once-a-season decision, not a weekly one.

## 6. Verdict (stop here: no critic brief, per the task)
FAIL - 7 of 9 (a and g). Can the coach mechanic reach 8 without the trade? **Not as a weekly who-coaches-whom choice.** The
measured weekly choice is solved by one rule in 8 of 10 cells and gives 1-27 lines over two years; chemistry at the size that
keeps it from dominating (0.10-0.15) moves 1-3 lines and rarely changes the pairing. What does carry depth is the HIRE (who
to bring in, when the club is big enough: -39 to +50 lines, and it flips with club size) and the per-boxer fit (bar c) -
which a critic would score as staff management, not a weekly puzzle.

My call for the owner's cut-or-keep: **keep coaches as people, cut the weekly assignment as a depth claim.** Coaches stay
(ratings, playbook, chemistry word, wages by band, the hire by club size - the part that measured real); the week plan
pairs them by fit automatically with a "change" option, and the class nights fill the free evenings as a shown fact. The
alternative - one more round to make the weekly pairing deep - would need a NEW scarcity (fewer coach evenings than boxers
ask, so someone is short every week) and that is the evening trade again under another name, which failed four rounds.

Owner question for the board (the coordinator, not this session): "Coaches: keep as people with hiring, drop the weekly
pairing as a choice?" - options "Keep, auto-pair|Cut coaches depth".

Not done (FAIL): ops/research/CRITIC_COACHDEEP6_BRIEF.md was not written and nothing was queued for kalli or dola; no Arena
code-checked critic is owed until a version passes.
