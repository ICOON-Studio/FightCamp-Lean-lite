# COACHDEEP2 - deep coaches v2: the owner's 24 answers, departure priced, chemistry sized (S539)

Task: ops/research/TASK_COACHDEEP2.md. Owner's answers: ops/research/COACHDEEP_GRILL_S539.md (wins over v1). Map:
ops/research/DESIGN_COACHDEEP2.md. Probe: tools/coachdeep2.gd + rules copy tools/coachdeep2_rules.gd. Nothing under scripts/ changes.

## 1. What is probed
The TEST CLUB (TestClub.make on Career.quick_start: Lucy, Kira, Josh, Ana) run 104 weeks by the v2 club: YOU (every rating
8, 2 evenings, no wage - Q19), Luke Reid converted (Q18: pads 15, the rest 9-11, a personality, $450, 5 evenings) and ONE
hired coach from five candidates priced by band (Q17: two locals $200 / $250, two solid $480 / $550, a known name $1,000).
An evening is 2 boxers on pads or 1 class (Q13). A boxer asks ClubDeal.ASK places (3, +2 in her fight week); Ana asks only
when a coach knows BJJ. A class night pays ClubDeal.class_cash ($117) up to the nights the members fill (one a night per 12
members, ESTIMATE from StaffRoles' 1:10-12 note) and lifts the members' target by his teaching (ESTIMATE).
Cells: 5 candidates x 2 club sizes (small: 30 members, the target as Membership.natural_members; big: 70 members, target
+30) = 10 cells. Arms (rules a player could use each week): LAZY, STAT, CHEM, NEXT, STAR, SMART (as v1) and CLASS (class
nights first up to what the members fill, then pads by SMART). Controls: CHEMOFF, ALL_REID / ALL_X, NOHIRE (YOU + Reid).
Loyalty is the game's (Loyalty.MOVES short / short_running / full_week / bout_won / bout_lost, value() from the trait);
two weeks under Loyalty.LEAVES_UNDER = she leaves (stand-in for the two talks), charged as Leaving.gd charges it.
Score in lines as v1 ($1,000, 3 reputation, 0.5 win less loss, 5 morale) + cash now complete (dues, class nights, tickets,
wages, the stipends the test club pays) + each boxer still at the club at week 104 valued at her next year in the game's
money and reputation (13 bouts at her last win chance: ticket cut, stipend, WIN/LOSS_REPUTATION).

## 2. Bars (written before the run, not loosened)
- (a) No single assignment rule is the best arm (by score) in more than 6 of the 10 cells.
- (b) Chemistry moves an outcome by a line (cash $1,000, reputation 3, win less loss 0.5, or morale 5; best arm v CHEMOFF,
  paired) in at least 5 of the 10 cells.
- (c) The right coach differs by boxer (ALL_REID v ALL_X per boxer: at least one boxer prefers each coach) in at least 5 cells.
- (d) The best arm beats LAZY by at least one line of score in at least 5 cells.
- (e) Every effect counted in (b), (c), (d), (h), (i) is larger than 2 standard errors (paired); inside 2 errors does not count.
- (f) A departure is priced by the game: (f1) charged in the score only by game items (Leaving.REP_LEAVE / REP_LEAVE_RANKED,
  Loyalty "teammate_left" on team-mates under SETTLED_AT, the stipend stopping, her lost bouts, her lost next year), no flat
  number; the probe prints the mean price and its parts; and (f2) the v1 failure is gone: in at least 8 of 10 cells the best
  arm loses no more boxers than LAZY + 0.10 a career.
- (g) Chemistry sized so CHEM (pair by chemistry) is the best arm in at most 5 of 10 cells, with (b) still passing. The size
  is picked by a sweep (chemistry x 1.0 / 0.6 / 0.4 / 0.25, 10 reps, diagnostic) as the LARGEST size with CHEM best in at
  most 5 cells there; the full run at that size is the verdict.
- (h) The evening trade is real: in the cell's best arm, sampled weeks (every 8th) where one more class night means one pad
  evening fewer (no free evening, members fill another class): CLASS minus PAD paired over reps; of all sampled trade weeks
  across the 10 cells, the class is right (> 2 errors) in at least a third AND the boxer is right (< -2 errors) in at least a third.
- (i) Hiring pays in one club size and not in the other: some candidate X whose best HIRE arm beats the best NOHIRE arm by
  > 2 errors in one size and does not (difference <= 2 errors) in the other. And the COACHHIRE1 trap is not back: in at least
  one size some hire pays at all.
PASS = all nine.

Clarified after a 2-rep smoke run (E:/FightCamp/tmp/coachdeep2/smoke.txt) and before the sweep or any verdict run, bars
unchanged: (h) is also measured in the mirror direction when the best arm already runs class nights and a boxer is short
(one class night handed back to pads; CLASS minus PAD = the base run minus the flipped run), because a class-first arm
never has a class to add. Two game rules the smoke had missed were added: members are capped by
StaffRoles.coaching_cap (VOLUNTEER_MEMBERS + COACH_MEMBERS a coach, you included) and the reputation that feeds
Membership.natural_members stays 0-100.

## 3. Result: FAIL (bars a, c, f2, h fail; b, d, e, g, i pass)
Raw: E:/FightCamp/tmp/coachdeep2/full.jsonl (10 cells, 30 reps, hreps 12, 343 s, 0 script errors), sweep
E:/FightCamp/tmp/coachdeep2/sweep.txt (285 s), both through godot_slot, one run at a time. ± = one paired standard error.

| Bar | Needed | Got | |
|---|---|---|---|
| (a) no rule best in more than 6 of 10 | <= 6 | CLASS 8, CHEM 2 | FAIL |
| (b) chemistry moves a line | >= 5 cells | 8 of 10 (none in small L, small F) | PASS |
| (c) right coach differs by boxer | >= 5 cells | 4 of 10 (M twice only through Ana; K twice through Josh); 2 of 10 without Ana | FAIL |
| (d) best beats LAZY by a line | >= 5 cells | 10 of 10 (+37 to +138 lines) | PASS |
| (e) counted effects > 2 errors | - | applied | PASS |
| (f1) departure charged by game items only | - | Leaving.REP_LEAVE(_RANKED), teammate_left, stipend stops, lost bouts, lost year | PASS |
| (f2) best arm loses <= LAZY + 0.10 boxers | >= 8 cells | 2 of 10 (the M cells; elsewhere the best arm loses 2.0-3.0 of 3 boxers) | FAIL |
| (g) CHEM best in <= 5 of 10, (b) passing | sweep 1.0/0.6/0.4/0.25 | CHEM best 2 at every size, so size 1.0; full run CHEM 2 | PASS (trivially: CLASS crowds it out) |
| (h) class right >= 1/3 AND boxer right >= 1/3 of trade weeks | both | 47 trade weeks: class right 28 (60%), boxer right 1 (2%) | FAIL |
| (i) a hire pays in one size, not the other; some hire pays | both | F (solid film, $480): +19.1 ± 3.2 big, -11.8 ± 3.7 small; L ($200) pays in both | PASS |

### 3.1 Score by arm (lines), and boxers lost a career
| Cell | LAZY | STAT | CHEM | NEXT | STAR | SMART | CLASS | best | best lost | LAZY lost |
|---|---|---|---|---|---|---|---|---|---|---|
| small L | 126.7 | 171.9 | 172.2 | 167.9 | 171.9 | 172.2 | 251.9 | CLASS | 2.97 | 0.00 |
| small M | 31.0 | 161.5 | 163.0 | 160.7 | 161.5 | 161.5 | 118.8 | CHEM | 0.00 | 1.00 |
| small S | 128.3 | 131.0 | 133.0 | 84.0 | 131.0 | 133.0 | 165.2 | CLASS | 2.03 | 0.00 |
| small F | 137.3 | 138.9 | 137.0 | 118.6 | 138.9 | 138.8 | 207.2 | CLASS | 2.90 | 0.00 |
| small K | 81.5 | 75.3 | 90.8 | 75.9 | 75.3 | 90.8 | 133.6 | CLASS | 2.17 | 0.00 |
| big L | 151.8 | 194.9 | 195.2 | 191.0 | 194.9 | 195.2 | 289.9 | CLASS | 3.00 | 0.00 |
| big M | 58.8 | 183.8 | 185.2 | 182.9 | 183.8 | 183.8 | 150.1 | CHEM | 0.00 | 1.00 |
| big S | 153.5 | 156.2 | 157.0 | 109.2 | 156.2 | 157.0 | 228.9 | CLASS | 3.00 | 0.00 |
| big F | 162.0 | 163.5 | 161.2 | 143.3 | 163.5 | 163.5 | 251.8 | CLASS | 3.00 | 0.00 |
| big K | 106.7 | 99.5 | 114.8 | 100.1 | 99.5 | 114.8 | 186.8 | CLASS | 3.00 | 0.00 |

NOHIRE (YOU + Reid, 7 evenings): best is CLASS in both sizes (small 219.0, big 232.7 lines) against 118-125 for every pad-first
rule; CLASS loses all three boxers in every career there too.

### 3.2 The price of a departure in the best arm (lines, mean over departures)
| Cell | best | departures | price | of it: next year's cash | next year's reputation | Leaving's reputation | who |
|---|---|---|---|---|---|---|---|
| small L | CLASS | 89 | -1.15 | -7.15 | 4.71 | 1.28 | Josh 30, Kira 29, Lucy 30 |
| small M | CHEM | 0 | 0 | 0 | 0 | 0 | - |
| small S | CLASS | 61 | 0.81 | -7.15 | 6.69 | 1.27 | Josh 2, Kira 30, Lucy 29 |
| small F | CLASS | 87 | -2.3 | -7.15 | 3.58 | 1.28 | Josh 30, Kira 30, Lucy 27 |
| small K | CLASS | 65 | 2.18 | -7.15 | 8.06 | 1.27 | Josh 5, Kira 30, Lucy 30 |
| big L | CLASS | 90 | 0.13 | -7.15 | 6.26 | 1.02 | Josh 30, Kira 30, Lucy 30 |
| big M | CHEM | 0 | 0 | 0 | 0 | 0 | - |
| big S | CLASS | 90 | -0.44 | -7.15 | 5.6 | 1.11 | Josh 30, Kira 30, Lucy 30 |
| big F | CLASS | 90 | -0.67 | -7.15 | 5.4 | 1.08 | Josh 30, Kira 30, Lucy 30 |
| big K | CLASS | 90 | 0.02 | -7.15 | 6.04 | 1.13 | Josh 30, Kira 30, Lucy 30 |

The game's own price of an amateur leaving is about zero: her next year's reputation (+3.6 to +8.1 lines) and Leaving's
-2 reputation (+1.0 to +1.3) are cancelled by the stipend she stops costing ($250 a week for 52 weeks against 13 ticket cuts
of $450: -7.15 lines). The best plans run every evening as a class and let the boxers walk.

### 3.3 Which coach for which boxer (ALL_REID minus ALL_X, per boxer, lines)
| Cell | per boxer |
|---|---|
| small L | Ana 0.0±0.0 / Josh 0.2±0.4 / Kira 19.2±2.0 / Lucy 28.5±2.5 |
| small M | Ana -126.2±1.7 / Josh 2.3±0.8 / Kira 6.8±1.3 / Lucy 8.7±2.3 |
| small S | Ana 0.0±0.0 / Josh 1.9±0.7 / Kira 28.9±2.4 / Lucy 30.8±2.7 |
| small F | Ana 0.0±0.0 / Josh 4.3±0.8 / Kira 12.9±1.5 / Lucy 9.5±1.7 |
| small K | Ana 0.0±0.0 / Josh -5.7±0.8 / Kira 8.7±1.4 / Lucy 7.5±1.7 |
| big L | Ana 0.0±0.0 / Josh 0.2±0.4 / Kira 19.2±2.0 / Lucy 28.5±2.5 |
| big M | Ana -126.2±1.7 / Josh 2.3±0.8 / Kira 6.8±1.3 / Lucy 8.7±2.3 |
| big S | Ana 0.0±0.0 / Josh 1.9±0.7 / Kira 28.9±2.4 / Lucy 30.8±2.7 |
| big F | Ana 0.0±0.0 / Josh 4.3±0.8 / Kira 12.9±1.5 / Lucy 9.5±1.7 |
| big K | Ana 0.0±0.0 / Josh -5.7±0.8 / Kira 8.7±1.4 / Lucy 7.5±1.7 |

Reid (pads 15 for $450) is the better coach for Lucy and Kira in every cell and for Josh in six (the known name wins Josh
in the other two; the locals' cells read no difference for him): pads drive technique and
defence (0.7 of the week's pace), so the pads number decides; the candidates' edges (conditioning, film, motivation) are too
small to win a boxer back.

### 3.4 Hire v no hire (best HIRE arm minus best NOHIRE arm)
| Cell | score (lines) | cash ($) |
|---|---|---|
| small L | 33.0 ± 3.5 | 18406 ± 1455 |
| small M | -56.0 ± 4.4 | -70131 ± 861 |
| small S | -53.7 ± 3.8 | -36869 ± 1529 |
| small F | -11.8 ± 3.6 | -25748 ± 1664 |
| small K | -85.3 ± 4.3 | -80647 ± 1408 |
| big L | 57.2 ± 2.0 | 50428 ± 1388 |
| big M | -47.6 ± 4.1 | -64206 ± 358 |
| big S | -3.9 ± 4.6 | 2740 ± 2423 |
| big F | 19.1 ± 3.2 | 14455 ± 1875 |
| big K | -46.0 ± 4.0 | -42444 ± 2152 |

## 4. Diagnostics (not the verdict; 10 reps, hreps 6; bars unchanged)
| Run | best arms | (b) cells | (c) cells | (f2) cells | (h) class / boxer right of trade weeks |
|---|---|---|---|---|---|
| verdict | CLASS 8, CHEM 2 | 8 | 4 | 2 | 28 / 1 of 47 |
| class night x 0.25 ($29) | CLASS 8, NEXT 2 | 6 | 4 | 2 | 26 / 2 of 37 |
| stipend off | CHEM 8, STAT 2 | 10 | 4 | 10 | 121 / 0 of 121 |
| both | CHEM 4, STAT 3, NEXT 2, CLASS 1 | 9 | 4 | 9 | 75 / 9 of 105 |
Hire v no hire with the stipend off: sL:54±1 sM:44±2 sS:14±2 sF:19±1 sK:-27±2 bL:70±1 bM:59±2 bS:31±1 bF:37±1 bK:-10±2. With both: sL:6±6 sM:5±2 sS:-36±2 sF:-29±1 sK:-77±2 bL:20±1 bM:22±2 bS:-18±1 bF:-11±1 bK:-59±2.

Read: (1) the stipend is why the best plan sheds boxers - with it off nobody leaves (f2 10 of 10) - but then pairing by
chemistry is best in 8 of 10 (bar g would need chemistry shrunk, measured again). (2) The class night still wins the margin:
even with the stipend off it is right in every one of 121 trade weeks, and with both changes the boxer is right in only 9 of
105. One coached evening is worth about 0.2-0.3 of a stat point to a boxer at the decided pace (1.0 a focused week), against
$117 and members for a class. (3) Bar (c) never moves (4 of 10 in every run): it is a roster problem (Reid best at the
number that decides), not a money problem.

## 5. Verdict and what to change (stop here: no critics queued, per the task)
FAIL. Coaches-as-people cannot matter while, in the game's own numbers, a boxer is a cost and a class is income. Before a v3
probe, in this order:
1. PRICE THE BOXER (money, the owner's call): an amateur on the club's $250 stipend returns $112 a week in ticket cuts. Either
   the stipend is the boxer's day job by default (DayJob exists) and the club's only for a chosen few, or an amateur's bouts
   pay by her rank (the regional ladder already ranks her), or her wins bring members who stay (BoutRules.WIN_MEMBERS walks
   back to the reputation target in weeks). Without one of these, any coaching rule that lets boxers go wins.
2. CLASS NIGHTS WITH FALLING RETURNS: the members fill one class night per 12 members here (9 nights at 110 members). A club
   runs a timetable: the 1st-3rd class nights full, the 4th half, the 5th+ nothing new. Then the 2nd coach's evenings are
   only worth classes in a big club (bar i keeps passing for the right reason).
3. A COACHED EVENING WORTH MORE THAN A STAT DECIMAL: what only a coach gives must be on the evening - the fight-week plan and
   film (already: tapes, plan rating), moves and combos learned (BoutRead reads OwnCombos.all_mastery, BoutRead.gd:196), and
   the short (Loyalty "short" -3, "short_running" -6). Measure the evening's worth in wins before resizing anything.
4. A ROSTER WHERE NO ONE COACH IS BEST: the area weights must follow the boxer (a pressure fighter's week is half
   conditioning, an out-boxer's pads), and the candidates' edges must be in the areas that decide her fights; Reid at pads 15
   for $450 beats every candidate for the two out-boxers.
5. Then shrink chemistry again with the stipend question settled (with the stipend off, CHEM is best in 8 of 10).
