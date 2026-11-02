# CORE3 - the three mechanics that make Early Access (S354 design, for the operator's OK)

Operator S354: "focus on 2-3 mechanics (beside the corner onthe fight) to make them a bit fun [...] morning exercises it has to
sum up gains/loses towards a goal [...] the planner for the moves [...] unique combinations [...] also make the fight plan
fun to design". Mockup: Lean docs/mockups/S354_core_loop.png (a fighter's Training tab).

## The loop (one week = one turn of it)
GOAL (camp start) -> MORNINGS build the body -> EVENINGS sharpen moves and combos -> FIGHT PLAN spends the weapons ->
the fight + corner -> PLANNED VS ACTUAL -> adjust next week. Each part feeds the next, and every choice shows its price.

## 1. Mornings: the body plan, summed against the goal
- The camp opens with a GOAL CARD: weight limit by the weigh-in, one stat target, one move to a weapon (FighterGoal already
  sets goals; the camp adds the weight line).
- Each day: one session (the 8 we have: roadwork, heavy bag, speed bag, ladder/skipping, intervals, strength, mobility,
  sparring) + LIGHT / NORMAL / HARD. Each card prints its numbers: stat gain, kg burned, fatigue.
- The GOAL bars move the moment a card or intensity changes: "this week" and "at fight night", target marker, short/ok.
- The price: HARD = more gain and burn, more fatigue; fatigue 80+ doubles injury risk; two HARD days in a row costs the
  next day (the red day of the S353 mockup). Diet (hold / cut) stays the camp setting.
- Real-world numbers (sources in the build brief): running costs about 1 kcal per kg per km; ~7,700 kcal per kg of body
  fat; a safe cut is 0.5-1% of body weight a week, and amateur boxers cutting ~5% in a week show more fatigue and anger
  (J_STRESS_S206); load spikes over 1.5x the usual raise injury risk (TrainingLoad already uses this).
- Week 1 is planned to land NEAR the goal, not on it: the coach's default plan leaves the player one or two dials to turn.

## 2. Evenings: the move and combo lab
- Each evening drills ONE move or combo (pads, partner drills) or is sparring (tests the plan, costs fatigue, can hurt).
- The move's bar fills night by night; the tick at 30 = a weapon in a fight (MoveMastery, unchanged).
- New combos are built only from weapons (the ComboBuilder we have); each shows how often it lands whole against the next
  opponent's game and against other games, its tank cost and its mastery. Numbers come from the fight model (ComboFlow /
  Exchanges), so the lab never promises what the ring will not do.

## 3. The fight plan: design it, then test it
- The plan board we have (arrows per range/situation, WHEN branches), limited to her weapons and learned combos.
- NEW: "Test it" runs 20 quick bouts against the scouted opponent with fight-night form: wins out of 20 and WHERE it breaks
  ("walked down in round 3 when tired"). That is the fun part: design, test, tweak, test again.
- After the real fight the corner card and the report show which arrows fired and worked.

## Planned vs actual (the payoff screen)
The week ends with planned vs actual per goal line, with the one-line reason (rest days, a lost day after two HARD days,
sparring that went well). The coach suggests one change. That is where the player feels each decision mattered.

## Build order (Claude decides; each step a playable build)
1. WeekPlan.gd (pure + test): 7 days x {session, intensity} -> per-day deltas (stats, kg, fatigue) and the goal projection;
   the camp goal card; the Training tab week row with live projections.
2. Planned vs actual at the week review (the sim's real week against the plan).
3. Evenings: one drill per night feeding MoveMastery/combos; the combo lab's effectiveness columns.
4. Fight plan "Test it" (20 sims vs the scouted opponent) + where it breaks.
Parked until these feel right: the BJJ belt road UI, Gym > Training week for all fighters (the per-fighter tab comes first).

## How we know it works
The operator plays one 4-week camp in the .exe: each week's decisions take about two minutes and he can say why he changed
something.
