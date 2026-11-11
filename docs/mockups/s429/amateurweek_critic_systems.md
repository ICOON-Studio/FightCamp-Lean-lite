Seat: systems and economy designer of management sims. My 10/10 drawing: `docs/mockups/s429/amateurweek_10_systems.html` (picture: `amateurweek_10_systems.png`).

# AMATEURWEEK1 reviewed: do the offer and the four jobs hold real choices?

Read for this: CRITIC_PACK, CRITIC_ACCESS, the design, FOURSTART1, the scope note S428, and the code it names (BoutRules,
AmateurBooking, Bouts, BoutNight, LiveRound, WeekPhase, WeekPlan, PadWeek, MoveMastery, PlanLines, PlanFight, PlanBoard,
StrikeMap, OppFile, FilmEdge, PeakCamp, RankLine, Combos, GymBills, Sim, Data). "Wins in 100" below is my own arithmetic from
the code's numbers and the pack's measured line (5 points better wins about 72%, so one point is about 4 wins in 100 in an
even fight). It is an estimate; the design's probe must confirm it.

## Scores
| What | Score |
|---|---|
| Depth of the whole design | 3 / 10 |
| The offer: take it or pass | 3 / 10 |
| Job 1, the weight | 2 / 10 |
| Job 2, the tape | 4 / 10 |
| Job 3, one line of the plan | 3 / 10 |
| Job 4, fresh or sharp | 2 / 10 |

The direction is right. The score is low because, with the game's numbers as they stand, each of the five choices has one
answer that is always right, and the total at stake in the fight week is too small to be felt.

## What works
- The big idea is sound: the fight is won between fights and at the offer, and the fight week only chooses. That is how
  amateur boxing works and it suits four fighters.
- The tape costing a shared pad evening is the one job with a real price paid by somebody else. It is the seed of the design.
- "The plan line only works with a punch the fighter owns" is the right kind of link (today's work pays for tomorrow's choice).
- The menus table is complete and the risks section already names the right danger (a checklist).
- Rest after a stoppage, the money warning and the "measure first" build order are all correct.

## Where the design assumes something the game does not do
1. "A cut costs tiredness." It does not. In WeekPlan.day the cut diet only changes kilos; tiredness comes only from session
   load. Sim also switches the cut off by itself once the fighter is 0.15 kg under the limit. So hold or cut has no price.
2. "Tiredness carried into the ring empties the tank (BoutRules)." Only after a camp. `stale_energy` returns 0 when there is
   no camp ("a fight without a camp is not taxed for the club's usual training"). With no camp, fresh or sharp changes
   nothing on the night today.
3. No camp is punished today. `night_edge` gives -1.5 when the camp is empty, and the Why prints "No camp: looked a step slow
   from round 2". The design removes the camp but does not say this goes. If it stays, every amateur bout starts 1.5 down.
4. The tape only runs inside a camp. `Bouts.tape_days` returns at once without a camp with film on. The fight week needs its
   own route to open a tell.
5. The fight-week board is a camp board. The taper's half-length pad evenings need a camp (`camp_on`); without one the
   fighter does full pad nights in fight week and arrives at about 57 tiredness, not about 47. And 8 to 14 days out
   WeekPhase writes the PEAK week (the hardest week, sparring twice), which is wrong for a bout with no camp.
6. "The choice of opponent is the big decision." There is no choice of opponent. One legal offer comes at a time, and a
   pass brings the SAME name back five days later (the turn only moves on after a bout: `opp_index`). Each division has
   three names.
7. "The rank a win or a loss would give" is the same for every opponent. RankLine orders by wins minus losses, then wins.
   Beating the weakest name climbs exactly as far as beating the best.
8. "Owns an answer to the best weapon: yes / no" will say yes almost always. In the answer table every main game has a
   "Beats it" answer that is a step or a jab every starter owns, and steps need no pad time at all (StrikeMap: only
   combinations need learnt punches): she presses -> step back; boxes at range -> cut off the ring or one-two; waits to
   counter -> double jab; loads up -> step back. Also the best weapon is hidden until the tape today, so showing its answer
   on the offer gives away the tape's first find.
9. The plan is kept from fight to fight, and Reid (rating 58) holds six lines. Six lines cover all five situations. So
   "write one line" is done once per fighter and never again.
10. After one bout the opponent's whole file is open and remembered (OppFile.open_all). With three names a division, the
    tape finds nothing from about the fourth bout on.
11. FOURSTART1 gives three of the four fighters a day job with no mornings. Fresh or sharp is a switch on the mornings, so
    for two of the three boxers it does not exist.
12. Small ones: the stoppage ban is 30 days in the code (design: 28). $14,400 of ticket cuts is about a fifth of the yearly
    costs with Reid and one stipend (about $67,000), not "more than a third"; and only three of the four box, so it is
    $10,800 at 8 bouts. A win also adds 8 members and 5 reputation, set when one fighter boxed six times a year; at 24 to 30
    bouts a year that is four to five times as much, and the first unit holds 70 members.

## What each choice is worth, from the code's numbers
| Choice | What it moves | Rough size |
|---|---|---|
| Which opponent | rating 61 against 65 in Tess's division | about 15 to 18 wins in 100. The biggest lever, and the player is not given it |
| Weight | made or missed (miss: bout off, $300, six days to the next offer) | the choice itself is worth nothing: cut when over, hold when under |
| Tape, one evening | +0.4 if a plan line answers the tell found (camp tape gave up to +1.2) | about +2 wins in 100, once; nothing in a rematch |
| What the tape costs | one pad evening: 6 to 10 mastery on one move, a quarter of a new punch | a new punch is worth +0.3 (only six punches exist, so +0.6 in all): about 0.3 wins in 100 for good |
| One plan line | a "Beats it" line is worth 9 in each exchange it comes up (a right shout is 17) | a good plan is 59% against 45% with none: the largest thing in the week, and it costs nothing |
| Fresh | today nothing. With the camp rule switched on: a normal week sits near 60, which is the full 20 off the tank | about 7 wins in 100 on the night |
| Sharp | normal mornings instead of light ones: about 0.35 of a stat point for Tess, 0.6 for Samira, spread over three numbers | about 0.3 wins in 100 for good |
| The whole camp it replaces | no camp -1.5, Hard camp +1.0, peak +1, film +1.2 | best to worst preparation was about 20 wins in 100; the fight week as written is about 2 (plus freshness if switched on) |

Two things follow. The jobs are on wildly different scales (the plan line is worth six tapes; fresh is worth twenty
sharps), so there is nothing to weigh. And the week as a whole moves the result less than one right shout in the corner.

## The dominant plays
1. ALWAYS SAY YES. A pass only delays the same opponent five days. Every bout pays $450 and lifts mood; a win adds 8
   members, a loss takes 1. Even a 15% chance is worth it for the club.
2. IF THERE WERE A CHOICE, ALWAYS THE WEAKEST NAME. Rank counts wins, not whom you beat.
3. WEIGHT: over the line, cut; under it, hold. The game already does half of this itself, and it moves the date so the cut
   makes the scale (`makeable_day`).
4. ALWAYS WATCH THE TAPE. Nothing learnt in fight week arrives in time, a film evening is also a rest for the legs, and the
   price lands on someone else. If the film takes only that fighter's own pad place (section 2 says this) the others even
   gain a place; if it takes the coach's evening (the links paragraph says this) it costs them. The design says both.
5. WRITE ONE PLAN FOR EVERYONE, ONCE: step back from a presser, cut the ring on a mover, double jab a counter-puncher, step
   back from a loader. No pad time needed, fits in six lines, never touched again.
6. ALWAYS FRESH (if tiredness is taxed) or ALWAYS SHARP (if it is not, as today). Either way one answer for every fighter
   and every opponent.
7. ONE ORDER. The line needs the tape, so tape first, line second; weight and legs are set on Monday and left. There is no
   order to choose.
8. FIGHT AS OFTEN AS OFFERS COME. A fight week costs about a third of a stat point and some pad time; it pays money, mood,
   members and rank. Nothing on any screen shows the real price (6% injury a bout, 30 days out if stopped).

## Does it hold for 8 to 10 bouts a year, four fighters?
No, not as written. Three boxers at 8 to 10 bouts is 24 to 30 fight weeks a year, plus Ana's open nights: a fight week in
more than half of all weeks, often two at once. That is about 110 job clicks and 27 weigh-in stops a year. By the third
month each opponent's file is open, the plan is written, the weight answer is known and fresh is always right, so all of
them are filled the same way. The quiet week that takes one click is gone and nothing replaces it. "Two fight weeks in the
same week" is listed as a link but nothing is at stake when it happens: the coach has enough evenings for two films, and
there is one of you on fight night but no rule about whose corner you are in.

## Missing and useless options, menu by menu
| Menu | Useless as designed | Missing | What each missing option would change |
|---|---|---|---|
| Home | "Fight week: 2 of 4 done": a count of chores, it asks to be filled to 4 | the one open choice with its price; a clash flag when two fight weeks share the coach or the night; "Reid runs this week" | the row becomes a decision; a routine bout costs one click |
| Fights | "owns an answer: yes / no" (nearly always yes); the rank line (same for every name); Pass (same name back in five days) | two or three names on the show's bout sheet; the date (this show or the next); what the bout costs (injury chance, days out if stopped, the building week lost); home or away money; a Ready / Building switch per fighter | whom to fight, when, and how often become choices with rank, money and risk pulling apart |
| Bout page | four boxes always, even when a box holds no choice (weight safe, file open) | each box priced in one unit (the tank at the first bell, or wins in 100); the bill for the week shown BEFORE Accept; pull out and its $300 | the player says yes knowing the price; boxes appear only when they hold a choice |
| Training week board | the fresh or sharp switch for a day-job fighter (no mornings) | a third week shape; the number each shape gives on the night; what the days 8 to 14 out are; which evening the film takes and who loses the place | the week shape depends on the opponent, not on habit |
| Tape room | the film in a rematch (file already open); the spot-the-tell step thirty times a year with no skip | "what to look for" (weapon, habit, or when the opponent fades); a short version for a known opponent | one evening, one question: the answer feeds a different job each time |
| Playbook, Game plan | "owns it: yes" on a step; a forced line when the kept plan already answers | which lines are ready this week and which have gone stale; the price of a wrong read (a line that walks into it costs 7) | the plan needs upkeep in pad places, so it competes with learning |
| The guide | "Keep the legs fresh": it says the always-right answer out loud | one line that names the trade ("Film on Wednesday costs Samira's pads. Worth it against a stranger.") | the guide teaches weighing, not obeying |
| Continue button | the weigh-in stop when the scale is safe (one button, no choice, 27 times a year) | a stop on the day the bout sheet closes; a stop when two corners clash | stops only where a choice is |
| Fight night, result, the Why | "which jobs counted" without sizes | the size of each ("legs: 14 off the tank, round 3 lost"); the road not taken ("the tape would have shown the counter left") | the Why teaches the next fight week |
| Week review | nothing | the cost to the others in the thing lost ("Samira's uppercut: usable a week later"); the month's total of pad places spent on film | the shared evenings become a running account |

## To reach 10/10 (most important first)
1. GIVE THE PLAYER THE CHOICE OF OPPONENT, AND MAKE THE CHOICES PULL APART. Each club show posts a bout sheet with up to
   three legal names for a fighter (grow each division from three names to eight; Region already lists five). They differ on
   four things shown side by side: (a) rank: a win over a name above takes that place, a win over a name below adds a win
   and no climb, a loss to a name below drops two places, a loss to a name above costs nothing; (b) money: $450 only on a
   home show, +$150 when the opponent is in the top five, nothing and a $40 van on an away show; (c) the file: known or a
   stranger; (d) the chance to be stopped. The sheet stays open until three days before the show. Passing a whole show is
   free; passing the same club twice in a row means that club does not call for eight weeks.
2. PUT ALL THE JOBS ON ONE SCALE AND SET THE STAKES BEFORE ANY SCREEN. Target for the probe: the best fight week against
   the laziest is worth 10 to 12 wins in 100, and no single job more than half of it. To get there: remove the -1.5 and the
   "no camp" Why line for amateurs; switch the heavy-legs rule on without a camp but softer (1 off the tank for each point
   of tiredness over 50, not 2, at most 20, the game's own cap); make the cut cost legs (+1 tiredness for each day on the
   cut diet, about 6 off the tank after nine days); show every job's price as "tank at the first bell" so they add up on
   one bar.
3. FRESH OR SHARP BECOMES THREE WEEK SHAPES WHOSE BEST PICK DEPENDS ON THE OPPONENT. Add a round-1 number, "sharp": pad or
   sparring work in the last five days keeps it; a full rest week loses it (about 2 points, in round 1 only). Rest up: full
   tank, flat in round 1, gains +0.1. Tick over: 8 off the tank, sharp, gains +0.3. Stay sharp: 20 off the tank, sharp, the
   week's full gains (+0.5): the pick for training through a safe bout. Rest up and Tick over cost about the same on
   average, one early and one late, so the right one depends on the opponent: against a slow starter you want round 1,
   against one who fades you want the tank in round 3. The opponent's file already holds both ("Slow to start", "Fades
   after round 2"). A day-job fighter gets the same three shapes on the evenings.
4. THE TAPE ANSWERS ONE QUESTION THE PLAYER PICKS. One evening, one of three: the best weapon (feeds the plan line), a habit
   (feeds the corner's read on the night), or when the opponent fades or starts slow (feeds the week shape). Say plainly
   that the film takes REID'S evening, both pad places, and show the loser's cost in their own thing ("Samira's uppercut:
   usable a week later"). Files go stale: a tell is good for six months, then the rival may have changed one (a news line
   says so), so a rematch a year later is worth a film again.
5. THE PLAN NEEDS UPKEEP, AND STEPS STOP BEING FREE BEST ANSWERS. A line counts in full only if the fighter walked it on a
   pad place in the last 14 days (one place walks two lines); otherwise it runs at 80% (the game's own "not drilled"
   number). With two pad places a week, a boxer keeps four lines ready OR learns, not both. A step or a tie-up is a "Works"
   answer; only a learnt punch or combination can be "Beats it". Then "owns an answer" is a real yes or no and the book
   built between fights is what the offer is judged on.
6. MAKE HOW OFTEN TO FIGHT A CHOICE. Each boxer gets a switch on the Fights page: Ready, Building until a date, Resting.
   The offer shows the bout's true price in three lines: injury chance (6%), days out if stopped (30), the building week it
   costs (about a third of a stat point and two pad places). Set a win's members and reputation for 24 to 30 bouts a year
   (about +3 members and +2 reputation away, +8 and +5 only at a home show) once MONEYFOUR1 reports.
7. SHOW THE WEEK'S BILL BEFORE ACCEPT, ON ONE SCREEN. The Bout page shows, for the name picked, the scale, Reid's evenings
   and the legs as three budgets, and one line "on the night with these picks": tank at the bell, sharp or flat, lines
   ready, scale margin, the win band. Accept is pressed with the price in view. This is the screen I drew.
8. ROUTINE BOUTS COST ONE CLICK. "Reid runs this week" fills the standard week (cut if over, tick over, no film for a known
   opponent). A box appears only when it holds a choice. The weigh-in stops the clock only when the margin is under 0.2 kg.
   Home shows the open choice and its price, never "2 of 4 done".
9. TWO FIGHT WEEKS AT ONCE MUST COST SOMETHING. One film evening a week from Reid, so two boxers in fight week cannot both
   have one. If two boxers fight on different shows the same night, the player picks a corner; Reid takes the other and his
   shouts are right about 6 times in 10.
10. A WEIGHT CHOICE WORTH MAKING. Three ways when over: cut from today (legs pay), cut later and sweat the last day (8 off
    the tank, tight on the scale), or ask the other corner for a kilo (about even odds, a favour owed to that club). And a
    standing choice between fights: the weight a boxer walks at decides whether a seven-day offer can be taken at all; show
    "can take a bout in 7 days: yes / no" on the fighter card.
11. FIX THE BOARD RULES THE CODE NEEDS: a fight-week phase that halves pad evenings without a camp; a plain base week for
    the days 8 to 14 out; the tape route without a camp; the stoppage ban one number (30 days) in design and code.
12. THE WHY CLOSES THE LOOP WITH SIZES: "Legs: 14 off the tank, round 3 lost." "The film line came up 4 times and won 3."
    "No film: the counter left was a surprise in round 1." And the Monday review keeps the running account of pad places
    given to film.
