You are a fresh, blind reviewer. Score a MEASURED simulation of no-gi Brazilian jiu-jitsu matches for a game. You have no
other context: judge only what is below, against what you know of real no-gi competition (IBJJF rules, women's divisions).

THE GAME. FightCamp (Steam, PC) is a boxing + no-gi BJJ gym manager. The player coaches Ana, a woman competing in women's
no-gi divisions, from white belt to black. Each week the player picks what Ana drills (moves on a map of 49 positions and
135 arrows between them; a move is grey, then "felt" at mastery 15, then "owned" at 30). Ana enters opens (IBJJF rules,
single elimination). Every match is simulated and every opponent is generated on the same maths.

THE ENGINE AS BUILT (the thing you score):
- A match is a walk on the position map in beats of ~33 s (9 beats in a 5-min white match, 18 in a 10-min black match).
  The side with the initiative either attempts one arrow or holds. A hit moves the position, scores IBJJF points and keeps
  the initiative; a miss slides down a "bad" arrow (only as far as the defender owns the answer) or resets, and the
  initiative passes.
- Odds of an arrow = its even-field base rate (from published attempt-to-success tables) x the attacker's mastery of the
  move / the defender's mastery of the best answer, then levers added on the logit scale: MAT TIME (one hidden level for
  the belt and the classes towards the next belt; a senior attacker gets +MAT_ATT x the gap, a senior defender +MAT_DEF x
  the gap), the BODY (strength, flexibility, explosiveness, composure, read by the kind of move, side against side, capped
  +-0.25), both GAS TANKS (an attempt costs gas, a hold breathes), FORM on the day (one draw a side a match, sd 0.25).
- A landed submission still has to beat a FINISH GATE: an escape chance by tier (white/blue 10%, purple ~22%, brown/black
  50%) moved by the mat-time gap; an escaped one is an advantage.
- The bell, IBJJF order: points, advantages, fewer penalties, then a REFEREE DECISION for the more offensive athlete (a
  tally of attempts by kind, a miss counting half, plus time on top; inside 45-55% a weighted call). Stalling: a hold off a
  pin (not mount, back, side control, knee on belly, north-south) counts; every 2nd one is a penalty, IBJJF ladder.
- Opponents: one of five games (Wrestler, Guard player, Passer, Half-guard player, Leg locker) = a body shape with noise, a
  lane weighting and a go-to route; a belt owns 8-12 moves at white, 25-36 at blue, 40-50 at black; their time at the belt
  is their class share 0.5-0.9.

THE MEASURED TABLE (1000 simulated matches a cell, seeded; "higher wins" = the higher belt's win share, the lower belt's
rules and clock; even = same belt, random athletes):
Columns: sub/pts/adv/pen/dec = share of matches ended by submission, points, advantages, penalties, referee decision; B subs / A subs = the higher (or second) side's submission wins / the other's; pts/match; 0-0 = share ending 0-0 on points; att/athlete = attempts per athlete; sub att = submission attempts per athlete; pens = penalties per match.
- white vs white (even) | sub 0.22 pts 0.53 adv 0.14 pen 0.03 dec 0.07 | B subs 0.12 A subs 0.10 | pts/match 4.4 | 0-0 0.27 | att/athlete 2.9 sub att 0.7 pens 0.66
- blue vs white: higher wins 0.882 | sub 0.44 pts 0.44 adv 0.08 pen 0.01 dec 0.02 | B subs 0.42 A subs 0.02 | pts/match 4.3 | 0-0 0.19 | att/athlete 2.9 sub att 0.7 pens 0.23
- purple vs white: higher wins 0.961 | sub 0.65 pts 0.32 adv 0.03 pen 0.01 dec 0.01 | B subs 0.64 A subs 0.01 | pts/match 4.4 | 0-0 0.17 | att/athlete 2.5 sub att 0.7 pens 0.13
- brown vs white: higher wins 0.975 | sub 0.76 pts 0.22 adv 0.02 pen 0.00 dec 0.00 | B subs 0.75 A subs 0.00 | pts/match 3.8 | 0-0 0.22 | att/athlete 2.2 sub att 0.7 pens 0.08
- black vs white: higher wins 0.990 | sub 0.83 pts 0.15 adv 0.01 pen 0.00 dec 0.00 | B subs 0.83 A subs 0.00 | pts/match 3.5 | 0-0 0.22 | att/athlete 2.1 sub att 0.7 pens 0.07
- blue vs blue (even) | sub 0.50 pts 0.41 adv 0.03 pen 0.01 dec 0.06 | B subs 0.26 A subs 0.24 | pts/match 5.5 | 0-0 0.12 | att/athlete 3.5 sub att 1.1 pens 0.07
- purple vs blue: higher wins 0.723 | sub 0.56 pts 0.36 adv 0.03 pen 0.00 dec 0.05 | B subs 0.45 A subs 0.11 | pts/match 5.4 | 0-0 0.16 | att/athlete 3.3 sub att 1.0 pens 0.06
- brown vs blue: higher wins 0.878 | sub 0.66 pts 0.29 adv 0.01 pen 0.00 dec 0.03 | B subs 0.61 A subs 0.05 | pts/match 5.2 | 0-0 0.14 | att/athlete 3.1 sub att 1.0 pens 0.05
- black vs blue: higher wins 0.936 | sub 0.74 pts 0.22 adv 0.01 pen 0.00 dec 0.02 | B subs 0.73 A subs 0.02 | pts/match 4.7 | 0-0 0.15 | att/athlete 2.8 sub att 0.9 pens 0.04
- purple vs purple (even) | sub 0.50 pts 0.42 adv 0.04 pen 0.01 dec 0.04 | B subs 0.26 A subs 0.24 | pts/match 6.1 | 0-0 0.13 | att/athlete 3.9 sub att 1.2 pens 0.07
- brown vs purple: higher wins 0.763 | sub 0.55 pts 0.39 adv 0.02 pen 0.01 dec 0.03 | B subs 0.46 A subs 0.09 | pts/match 5.8 | 0-0 0.14 | att/athlete 3.8 sub att 1.2 pens 0.06
- black vs purple: higher wins 0.873 | sub 0.59 pts 0.36 adv 0.02 pen 0.00 dec 0.04 | B subs 0.55 A subs 0.04 | pts/match 5.4 | 0-0 0.16 | att/athlete 3.6 sub att 1.1 pens 0.06
- brown vs brown (even) | sub 0.47 pts 0.46 adv 0.03 pen 0.00 dec 0.05 | B subs 0.23 A subs 0.24 | pts/match 5.2 | 0-0 0.16 | att/athlete 4.8 sub att 1.7 pens 0.05
- black vs brown: higher wins 0.643 | sub 0.47 pts 0.45 adv 0.03 pen 0.00 dec 0.06 | B subs 0.35 A subs 0.12 | pts/match 5.3 | 0-0 0.18 | att/athlete 4.8 sub att 1.7 pens 0.06
- black vs black (even) | sub 0.56 pts 0.40 adv 0.02 pen 0.00 dec 0.02 | B subs 0.30 A subs 0.26 | pts/match 6.3 | 0-0 0.16 | att/athlete 5.7 sub att 2.2 pens 0.06
- white four-stripe vs fresh white: four-stripe wins 0.780 | sub 0.22 pts 0.47 adv 0.24 pen 0.02 dec 0.04 | B subs 0.20 A subs 0.03 | pts/match 3.8 | 0-0 0.35 | att/athlete 2.6 sub att 0.7 pens 0.93
- blue four-stripe vs fresh blue: four-stripe wins 0.726 | sub 0.51 pts 0.40 adv 0.02 pen 0.01 dec 0.06 | B subs 0.42 A subs 0.09 | pts/match 5.1 | 0-0 0.12 | att/athlete 3.4 sub att 1.0 pens 0.06
- purple four-stripe vs fresh purple: four-stripe wins 0.703 | sub 0.47 pts 0.47 adv 0.03 pen 0.00 dec 0.03 | B subs 0.36 A subs 0.11 | pts/match 6.1 | 0-0 0.12 | att/athlete 3.9 sub att 1.1 pens 0.08
- brown four-stripe vs fresh brown: four-stripe wins 0.748 | sub 0.50 pts 0.42 adv 0.04 pen 0.00 dec 0.05 | B subs 0.42 A subs 0.08 | pts/match 4.8 | 0-0 0.20 | att/athlete 4.6 sub att 1.6 pens 0.05
- black four-stripe vs fresh black: four-stripe wins 0.680 | sub 0.59 pts 0.35 adv 0.03 pen 0.00 dec 0.03 | B subs 0.44 A subs 0.16 | pts/match 5.8 | 0-0 0.17 | att/athlete 5.5 sub att 2.0 pens 0.07
- STYLE white (row vs column: the column's win share) columns: Wrestler, Guard player, Passer, Half-guard player, Leg locker
- style white  Wrestler             -   0.61  0.54  0.55  0.55  | mean 0.44, furthest 0.39 vs Guard player
- style white  Guard player       0.39    -   0.42  0.42  0.42  | mean 0.59, furthest 0.61 vs Wrestler
- style white  Passer             0.46  0.58    -   0.51  0.50  | mean 0.49, furthest 0.42 vs Guard player
- style white  Half-guard player  0.45  0.58  0.50    -   0.50  | mean 0.49, furthest 0.42 vs Guard player
- style white  Leg locker         0.45  0.58  0.50  0.50    -   | mean 0.49, furthest 0.42 vs Guard player
- STYLE purple (row vs column: the column's win share) columns: Wrestler, Guard player, Passer, Half-guard player, Leg locker
- style purple Wrestler             -   0.54  0.56  0.51  0.53  | mean 0.47, furthest 0.44 vs Passer
- style purple Guard player       0.46    -   0.54  0.50  0.48  | mean 0.50, furthest 0.46 vs Passer
- style purple Passer             0.44  0.46    -   0.44  0.44  | mean 0.56, furthest 0.56 vs Wrestler
- style purple Half-guard player  0.49  0.50  0.56    -   0.47  | mean 0.49, furthest 0.44 vs Passer
- style purple Leg locker         0.47  0.52  0.56  0.53    -   | mean 0.48, furthest 0.44 vs Passer

REAL NUMBERS USED AS BARS (with sources' solidity):
- No-gi black belt, IBJJF No-Gi Worlds: 45% by submission (218-257 matches; women 54-56%, men 39-42%) - medium.
- Referee decisions at IBJJF Worlds black: ~7% - medium. Advantages decide ~2.4% of no-gi black matches - weak.
- Belt gap: no published number. Proxy from no-gi ratings: a 100 gap wins 66-75%, 200 -> 76-84%, 300 -> 85-90%, 400+ ->
  90-93% - medium-strong.
- First scorer wins ~75-89% (gi black) - medium. Match lengths white 5 ... black 10 min - strong.

SCORE each part 0-10 (8 = ship as built; below 8 say the ONE change that would make it an 8, concretely):
A. What a belt means (the across-belt table and the four-stripe vs fresh rows).
B. How matches end (submission / points / advantages / penalties / referee shares by belt).
C. The referee and stalling (decision rates, penalties per match).
D. Pace (attempts per athlete, submission attempts per athlete, points per match, 0-0 rate).
E. Styles (the style matrix).
Then one line: the single biggest realism fault you see in the table, and whether it can be fixed by tuning numbers or
needs a change to how a beat works. Be concrete and brief (under 450 words).

