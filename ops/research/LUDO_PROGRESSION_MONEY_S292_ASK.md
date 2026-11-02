FIGHTCAMP (boxing gym manager, PC deep sim, Steam EA demo) - LEAD DESIGNER ROUND S292: PROGRESSION PACE vs GOALS, and THE FIRST MONTHS' MONEY.
Context: the operator decided D48 "fighter path first": the demo is quick start (a built London club gym) -> a walk-in amateur signs -> a coach
signs -> training weeks on the gym floor -> book an amateur bout 3 weeks out -> camp -> fight night -> the result -> the next goal. Our
golden-path test now plays that whole path 10/10. Two design numbers are wrong on it and I need your verdict WITH NUMBERS. Please give the
longest, most complete answer you can (tables, exact values, formulas, rationale, edge cases) - do not cut it short.

=== PART A - PROGRESSION FEELS FAINT (the operator's pillar 1: "the feeling of progression") ===
Measured facts:
- Stats are 0-100 (a fresh amateur ~50-65, potential ~70-90). The training pace is ~0.6 points per week on the stat a full week focuses on
  (calibrated so one lived floor day = the weekly program; ~30 points a year at most, less near potential: headroom factor
  clamp((potential - stat)/20, 0.15, 1.0); coach factor 0.5 + rating/100*0.7).
- On the golden path, one full week at the gym read on the week review: conditioning +0.3, power +0.1.
- YOUR goal archetypes (Ludo r102 section C1) ask for much more:
    Make the Weight 14 days: weight to the class limit, chin >= 65 floor, conditioning >= 60 floor (floors, mostly already met)
    Debut inside a month 28 days: book a bout + conditioning 65
    Southpaw Answer 21 days: technique +6, speed +5   (= ~2 points/week on two stats at once)
    Upset the Gatekeeper 35 days: conditioning 72 and fight IQ 68 (start +4 minimum)
  ON_TRACK needs 100% two days early. At 0.6/week, Southpaw is ~3x out of reach; the player can never win it by training.
Questions:
A1. Which is wrong - the training pace or the goal targets? Give the pace you want (points/week on a focused stat, and on a secondary stat)
    for an amateur in his first year, and how it should slow with age/potential. Benchmark it against real amateur boxers' development
    timelines (how long from novice to a regional champion, to turning pro).
A2. If targets change: rewrite the four archetypes with exact target deltas and days that a well-run plan meets ~70% of the time.
A3. What does the player SEE so a week of +0.6 still FEELS like progress (Football Manager / Punch Club / Motorsport Manager precedent):
    sub-stat bars, "points toward next level" fill, move mastery unlocks, sparring results, coach lines? Specify the week-review card's
    rows and what animates.
A4. Any other progression channel for the first 5 weeks (move mastery, combo unlocks, amateur ranking points, reputation) and its numbers.

=== PART B - THE FIRST MONTHS' MONEY ===
Measured on the golden path (quick start, after today's fix that puts every non-pro amateur on a $250/week club stipend):
- Start cash $25,000. The gym is fully built (training floor, ring, office, reception, lockers, physio, store).
- Weekly: coach wage $1,090 + fighter stipend $250 + upkeep $500 = $1,840 out; membership dues $384 in (24 members x $16/week).
- Members grow from the walk-in funnel: 6 -> 24 by week 4 -> ~37 by week 10 (dues ~$592/week).
- Amateur bouts pay no purse (real: club shows are fundraisers). Side-income offers exist (sponsor/wall/bag deals, ~$250-300/deal/week).
- Net is -$1,456/week: the bank lasts ~10-12 weeks, i.e. broke in month three, before the boxer can turn pro.
Questions:
B1. Real London boxing/fitness club benchmarks: members of a 450-1,000 m2 club gym in its first 3 months, monthly fee, class/PT income,
    coach pay (full-time head coach vs sessional), rent/upkeep. Give the numbers with ranges.
B2. Your verdict for the demo's first 12 weeks: the target cash curve (week 0, 4, 8, 12), and which levers set it (member count and
    growth, dues, classes/personal training, coach wage or a sessional/part-time first coach, upkeep). Exact values.
B3. When should the player first feel money pressure, and what decision does it force (a choice, not a slow bleed)?
B4. How does the boxer's path pay the gym before he turns pro (amateur success -> members join, sponsor deals, coaching fees)?

End with ONE short verdict table: each number we should change, from -> to, and why.
