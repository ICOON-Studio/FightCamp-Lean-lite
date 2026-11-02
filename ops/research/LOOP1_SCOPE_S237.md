# LOOP1 - one simple core loop, everything else switched off (S237, operator)

## The operator's words (verbatim)
"my opinion is to focus on one simple loop and keep it simple: (no story yet switch that thing off for now) Start a fighter comes in , he is
setting the goals and there is a timeline for that goal ( find my a fight within a month eg ) you set his training and you watch him train ,
you look for a coach to assign to him and watch them work together (this needs to be nicely handled with visuals on gains and atrittion
meters so the player can understand when he need to change the training plan , so big emphasis on this part) , in the meantime the player
needs check the progress according the goal and minor changes due to fatigue ,stress etc , handle other customers and equipment and try to
find the right opponent . then the other features come in with the spying and film and move learning etc until you get to the fight , can we
filter out everything else and keep what wee need only for that ? ask ludo , paul and tell me your opinion"

## The loop, step by step (what the player does, what he sees)
1. **A fighter walks in** - one intake moment: who he is, his record, his numbers, what he wants.
2. **He sets a goal with a deadline** - e.g. "find me a fight within a month". A goal card with a countdown (days left) is on screen
   the whole loop.
3. **You set his training** - the Morning Day Plan (blocks, stations, cues).
4. **You watch him train** - the 3D floor, the day runs.
5. **You find a coach and assign him** - watch them work together (coached blocks).
6. **THE BIG ONE: gains and attrition meters** - per day and per week: what he gained (skill/form/conditioning), what it cost
   (fatigue, wear, niggles, stress). Readable at a glance so the player KNOWS when to change the plan: a gain meter flattening
   + an attrition meter climbing = change the plan.
7. **Check progress against the goal** - am I on track for the deadline? Small daily corrections for fatigue, stress.
8. **Side duties, light** - other members (customers) and equipment wear/repair.
9. **Find the right opponent** - offers / matchmaking against the goal.
10. **Camp extras once a fight is booked** - scouting/spying, film, learning a move for him.
11. **The fight** - watch it; the result feeds the next goal.

## Proposed filter (Claude's draft - Ludo and Paul to correct)
One switch preset `core_loop` (ON in the game): everything not in the loop is OFF, nothing deleted; each comes back by flipping its switch.

| Area | Keep ON (in the loop) | Switch OFF for now |
|---|---|---|
| Story | - | story campaign, story card, story inbox, story wall, chapter beats ("no story yet") |
| Onboarding | one goal card with a countdown | the 11-step tutorial guide card (replaced by the goal card) |
| Training | day_plan, floor_actions, gain_bubbles, load_ledger, career_wear, recovery_rate, form_breakdown, niggles, breakthrough, decision_card (with the K87 6-a-day budget) | floor_events (random floor events), corner_rehearsal, floor_cuts, open_spar_night |
| Coach | coach hire + assign, coached blocks | - |
| Customers + equipment | boxing_floor_members, walk_in_policy, station_wear | gym expansion / zone editing in creation (start from the standard gym) |
| Opponent | offers, matchmaking, booking | promoter traps, away circuit |
| Camp extras | scouting, film room, move cards (after booking) | - |
| Fight | all fight switches (the fight must stay watchable) | MMA, kicks |
| Visual | the 3D floor, rooms the loop uses (office for offers, locker for weigh-in) | street_vista, rooms the loop never visits |

## The new work the loop needs (not built yet)
- **Goal with a deadline** (intake -> goal card -> countdown -> success/fail).
- **The gains and attrition meters** (operator: "big emphasis") - a per-day and per-week read with a clear "change the plan" signal.
