# CLUBWEEK v3: review by a sports-management systems designer (blind, S432)

Read: CRITIC_PACK.md, CRITIC_ACCESS.md, CLUBWEEK_MAP_V3_S431.md (whole), the three drawings (clubweek_v3, fightweek_v3, road_v3).
Checked in code: `scripts/rules/Attrs.gd` (overall = value-weighted mean, as the map says), `scripts/rules/CornerTrust.gd`
(mood only changes how much of the corner is taken in; Low below 30), `scripts/rules/GameMoney.gd` and `DuesLevers.gd`
(evening classes pay $350 a week with a coach).

## 1. Depth: 6 / 10
The links are real and good (four fighters fight over the same pad places and mornings; favours tie the sheet, the scale and the
pull-outs together; the sheet has no best card), but the most-used price, mood, buys almost nothing in the code, the money has no
lever on the weekly board, and no screen shows which decision moved the win chance most.

What is strong:
- A shared shortage across four people. Asked is always above owned, so every Monday is a real trade between people, not a form.
  This is the Football Manager feeling: "who gets the coach this week" is a squad decision.
- The amateur fight week sits on the same board as everyone else's week. The bout costs the club something visible (pad places,
  a film evening) instead of living in its own mini-game.
- The bout sheet: home money, a rank above away, or the unknown with a wide band; a redraw rule so no card wins every line.
- Favours as a second currency that bends terms but never buys a win. Earned by helping, spent on the sheet and the scale. This
  is the best new idea in the map and it is grounded in how club coaches really work.
- The other corner has a week too (their tank), and a corner that has seen your winning line. Opponents stop being static.
- The road strip explains amateur to professional in one screen with the club's own two people on it.

What holds it under 7:
1. Mood is priced everywhere and does almost nothing. The map prices about 15 options in mood (+5, -3, -8, -10, -20). In the code
   mood only changes how much of the corner's word gets through on fight night (Fired up 1.05 to Low 0.7), plus BJJ stripe calls.
   So "mood -3 a week until seated" or "a broken promise -10" costs nothing in the week itself. A third of the prices on the board
   are paper. This is the single biggest depth gap.
2. The money is not on the board. The map says one paid seat runs the bank down about $100 a week, but the Club week board offers
   no way to earn. The code already has evening classes at $350 a week with a coach. The map turns all of Coach's evenings into
   pad places and never says what happens to the classes. That is both a hole and a missed decision.
3. Many small decisions, little weight. The map's own target (TANKPRICE1) is that the whole fight week, best against laziest, is
   worth 10 to 12 wins in 100. The bill holds about twelve decisions (scale, film, film question, four lines, finish a punch,
   southpaw rounds, shape of the week, corner, Coach runs it, kilo, hold). Spread over twelve, most choices are worth under one
   win in 100. A player cannot feel that, so they will press "Coach runs it".
4. No lever readout. The bill shows two overlapping win-chance ranges (30-42 against 34-46). The player cannot see that their week
   was better, nor which choice did it. Football Manager's lesson: show the size of each lever where the decision is made.
5. Ana (the grappler) has one real choice a week (3 or 5 classes) and one a month (who corners). The map admits it. The owner asked
   for one BJJ fighter in the four: today Ana is decoration with a calendar.
6. "Coach's score: 3 right, 1 wrong" is never defined. Right by what measure? As written it cannot be built.
7. Every price is a first guess. The map is honest about it (nine probes), but depth is unproven until the probes say a choice
   moves something a player can feel.

## 2. Options
Missing:
- Coach's evening: pads (2 pad places) OR the members' class (about $117 a night, the code's $350 a week split over 3 evenings).
- A "Talk" with a fighter whose mood is Flat or Low (calm, promise a date, or the truth), with a visible effect.
- Ana: which division to enter at the open (stay white with a better medal chance, or ask to be promoted first); Ana teaching the
  members' beginners class for dues.
- On every option chip: its size in wins in 100 (or dollars), and on the bill a ranked list of the three biggest levers.
- The sparring pair as a pick on the Club week board (the map has the rule; the drawing has no place to choose it).
- What happens at the end of a 4-week seat block: renew, pass it to another fighter, or let it lapse (the map only says it ends).

Useless or near-useless (cut or fold):
- HOLD on the scale: a dice roll at 0.1 to 0.2 kg with nothing to decide that "Eat less" does not already cover. Fold into Eat less.
- Overtime asked: yes costs a Saturday, no costs -3 mood (which does nothing today). Cut until mood has teeth; then keep as a twist.
- Coach's score (right / wrong): undefined. Define it (the deal's forecast against the week's actual gain) or cut it.
- The senior holding pads with a mood curve (+3, then -2 a week from week 5): too fine to read. Keep the pad place at 0.7, drop the curve.
- Ask a kilo for the opponent's boxer (their tank +5) beside Ask a kilo for yours: two kilo rules in one fight week. Keep one.
- "Watch" mornings for a trial fighter: fine as a rule, but it is a fourth use of a coached morning on an already full board. Make it
  automatic (a trial fighter's ranges close after 2 weeks in the gym) unless a probe shows it is a real choice.
- Hatched job cells (five "Office" or "Shift" cells per row): information with no action. Keep them, but dimmer and narrower.

## 3. New mechanics (only ones that make this scope deeper)
1. MOOD WITH TEETH (needed now). Decide: who goes short, whom to promise, whom to talk to. Changes: Fired up fighters train alone at
   0.7 instead of 0.6; Flat at 0.5; Low skips 1 alone morning in 2 and passes the next sheet; three weeks Low and the fighter asks to
   train at a rival club (a talk, a dated promise, or let them go). Going short 3 weeks in 4 costs mood. Real-world basis: small
   clubs lose boxers to the club down the road when the coach's time goes elsewhere; Football Manager's "unhappy with playing time".
2. COACH'S EVENINGS: PADS OR CLASS (needed now). Decide: each of Coach's 3 evenings runs pads (2 pad places) or the members' class
   (about $117 and member goodwill). Changes: cash against training, every week, on the same board. Real-world basis: amateur club
   coaches split nights between fitness or beginners classes that pay the rent and the squad session.
3. ANA'S OPEN: DIVISION AND TEACHING (needed now, small). Decide: enter the white-belt division (higher medal chance, members on a
   medal) or ask to be promoted to blue first (lower chance, the belt road shorter); and whether Ana teaches one beginners class
   (dues, minus one class of training). Real-world basis: IBJJF-style divisions by belt, the "sandbagging" pressure to promote, and
   club grapplers teaching fundamentals classes.
4. A SEASON FRAME FOR THE CLUB (not needed now; after the week). Three club targets for the season (a boxer at the nationals, a
   professional win, a medal for Ana) with reputation on the line. It gives the weekly trades a direction. Already AGREED as "three
   club goals a year" in the pack; wait until the week is played.

## 4. To reach 10/10 (most important first)
1. Give mood consequences in training and booking: alone mornings 0.7 / 0.6 / 0.5 / skip 1 in 2 by mood band; Low passes the next
   sheet; 3 weeks Low = asks to leave (talk, promise, let go). Going short 3 weeks in 4 = -4 mood a week. Without this, cut mood
   from every price on the board.
2. Put the evening classes on the board: each Coach evening is pads or class ($117), shown on a counter beside pad places with the
   week's cash. Rewrite MONEYFOUR2 to include it; the target is that one seat plus one class night leaves the bank level.
3. Show each option's size: every chip on the board and the bill prints its worth (wins in 100 or dollars, from the probes); the bill
   ranks the three biggest levers; the two win chances become one number, "your week: +4 in 100 over Coach's", with its parts.
4. Cut the bill to the decisions that each move 1.5 wins in 100 or more after TANKPRICE1: keep scale, film, which four lines, shape of
   the week, corner; fold Hold into Eat less; drop the second kilo rule; make "Watch" automatic. Fewer, heavier choices.
5. Define Coach's score as forecast against actual (the deal Coach would have made against yours, in mastery points and wins in 100)
   or cut it.
6. Give Ana the division choice and the teaching class; show Ana's open on the bout sheet tab like a boxer's bout.
7. Add the sparring pair picker and the seat renewal (renew / pass on / lapse) to the Club week board.
8. Run SHORTWEEK1, ROTATWIST1, WEAKFIND1, SHEETDEAL1 and TANKPRICE1 before any screen; each must show its choice is worth feeling,
   or the choice goes.
9. Make the job cells narrower and dim so the eye lands on the choices.

## 5. Is the mechanic set complete for this version?
Yes, with the list applied. The shared shortage, the fight week inside the club week, the bout sheet, favours, the road and the
professional camp cover every weekly and bout decision from the first amateur bout to the first professional fight. What is missing
is consequence (mood), a money lever on the board, and a BJJ choice, not more systems. After those three, anything new is width.
The set stays complete only if the probes confirm the sizes; any choice under about 1.5 wins in 100 should be cut, not decorated.

## 6. My 10/10
`docs/mockups/s432/critics/v3_sim_10.html` rendered to `docs/mockups/s432/critics/v3_sim_10.png`: the Club week board with Coach's
evenings as pads or class, a mood watch with what Low costs, each pull's worth in wins in 100, a ranked "biggest levers" panel, Ana's
division choice and teaching class, and one line comparing your deal with Coach's.
