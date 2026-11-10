# Design brief: a week worth playing - combine the old ideas until they are deep (S425)

You are a game designer on FightCamp, a boxing gym management game for PC (one gym, a small roster, amateur to first pro
fight; the player is the head coach and owner; he manages, never throws punches; fights are settled by numbers and shown
in 3D). No-gi BJJ runs beside boxing.

## The owner's words (2026-11-10, verbatim)
- "maybe review combine old ideas to rise their depth to +7 and maybe come with new things ? [...] the focus needs to be
  for the player to have things to do during a week make him anticipate the changes and be more interactive with
  deicions/choices and rewarding for keep playing and progressing"
- "i expect all new mechanics to be wired and shown properly on the correct menus and be deep enough for a critics +7/10"
- On a mechanic a critic had scored 10: "need to improve the depth of the mechanic, , rated 4/10".
He is the playtester: 40 years of games, a boxing and BJJ background. Depth to him is decisions that lead into each
other across the week, the camp, the fight and the career, each option with a case where it is the right one.

## The problem to solve
Single mechanics designed alone keep scoring 4 of 10 on depth with our critics: the cutman (one stop-or-go), the opponent
adapting (only takes points away), who gets the coach's pad nights (worth one week on one card; four reviews, 4 each).
The reviews agree on why: one small stake, dominated options, choices the player hands to the auto-button after a week.
The week itself is where the player lives, and it needs four things:
1. THINGS TO DO each week that are decisions, not upkeep.
2. ANTICIPATION: something set in motion this week that he waits to see land (next Monday, at the weigh-in, on fight night).
3. INTERACTION: choices that answer what the game just showed him, with a visible price before the click.
4. REWARD for playing on: progress he can see and name, that opens new decisions, not only bigger numbers.

## Read first, in this order
1. `ops/research/CRITIC_PACK.md` (the whole game as it is) and `ops/research/CRITIC_ACCESS.md`.
2. The idea pool: `ops/research/S400_REVIEW/MECHANICS_LIST_S401.md`, `MECHANICS_SCORED_S401.md`, `MECHANICS_DECISION_S402.md`,
   `MENU_STRUCTURE_S402.md` (the seven he chose, the sixteen more marked IN, the ones parked for later).
3. What went shallow and why: `ops/research/R55_PADS_DESIGN_MAP.md` with `docs/mockups/s425/pads_v2_critic_coach.md` and
   `pads_v2_critic_simvet.md`; `ops/research/R28_CUTMAN_DESIGN_MAP.md`; `ops/research/R25_ADAPTS_DESIGN_MAP.md`.
4. Measured facts to build on (do not contradict them): the coach's hands bring a card into a boxer's hands one week
   sooner; a plan answer she cannot do yet on fight night costs 2 to 14 wins in 100 (40.0% with all four, 18.7% with no
   plan); a sharper-than-usable combination adds 1 point today; an opponent who waits for your best plan line costs 6.5
   points and nothing wins it back yet.
Do NOT read scripts/ or tests/. Do not read other designers' answers to this brief.

## What to deliver (one markdown page, plain game words, no option letters, under 220 lines)
1. THE WEEK AS PLAYED: Monday to Sunday for a player with two or three boxers, one of them in camp: what he looks at,
   what he decides, what he sets in motion, what he waits for, what lands. Then the same for a quiet week with no fight
   booked (the hardest week to make worth playing).
2. THREE TO FIVE COMBINED MECHANICS, each made by joining ideas from the pool (name the R-numbers joined) and, where it
   earns its place, something new. For each:
   - the decisions in order (before, during the week, fight night, after, across the career) and how one feeds the next;
   - for every option, the case where it is the right one; any option you cannot give a case for, cut it;
   - what the player ANTICIPATES and when it lands; what he is REWARDED with and what that opens;
   - the menus it shows on (Home, Fighters > Overview / Training / Playbook / History, Fights, Club > Money / People /
     Gym, World, the corner minute, the live fight, the week review, The Why) and what each shows;
   - which existing parts of the game it reuses, and what is truly new to build (small, medium, large);
   - the numbers it needs, each marked REAL (with the source), FROM THE GAME, or INVENTED.
3. YOUR OWN KILL LIST: for each mechanic, the strongest objection a hard critic would make (a dominated option, a chore,
   a stake too small, a rule the player never meets) and your answer to it. If you have no answer, say so.
4. THE ORDER TO BUILD, smallest first, where each step already makes the week better on its own.
5. A score for each of your mechanics as a hard critic would give it (depth 0 to 10), and what would take it to 10.
