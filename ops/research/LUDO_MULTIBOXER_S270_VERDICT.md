# MULTI-BOXER STATION PUZZLE - verdict (Claude, S270)

Operator idea (board Q-S264-4, verbatim): "no guided yet unitl the loop is proven fun keep it simple but what if 2 or 3 boxers come
into the gym thep player will have to profam each fighter on different stations that might be a good puzzle if you cna show it to
the player good enough to understand his options". Ludo's design: `ludo_rx/LUDO_S270_MULTIBOXER_raw.txt` (22,085 chars, complete).

## The design in plain words
Each morning the player shares ONE coach, ONE ring and a few single-use stations between 2-3 of his boxers who are at different
points of their camps (one fights in 5 days, one in 18, one has no bout). The coach can hold pads for one man per block; the others
train self-directed at 0.40 (the rule already live since this session). Two boxers booked into the ring at the same block spar EACH
OTHER. One board shows all of it: a row per boxer (time blocks across), a coach row at the bottom, conflicts marked before START DAY
(SPEED BAG FULL 1/1, UNSUPERVISED 0.40x - coach with Reyes), each boxer's fight countdown + one-line need + readiness on the left,
and an AUTO-PLAN button (the coach's suggestion) so the player only tweaks. During the day the board shrinks to a strip; only big
moments get floating bubbles (IT CLICKED, heavy fatigue, coach tip). The day ends on one receipt with a column per boxer.

## Why it fits our game (checked on master)
- The starter floor is already Ludo's blueprint: 1 club ring, 2 heavy bags, 1 speed bag, cardio floor, compact weights, focus-mitts
  locker (GameState.generate_starter_boxing_floor, each item carrying station_capacity). No new art needed for the constraint.
- Coachless 0.40, station focus, CHANGE THE PLAN decay, fight dates, readiness, the Day Plan board and the walk-in signing all exist.
- Missing: more than one boxer driven on the floor (the hall plays roster[0]; others are ambient walkers), a multi-row plan, the
  coach-per-block assignment, capacity checks, boxer-vs-boxer spar pairing, AUTO-PLAN, the per-boxer receipt.

## Verdict - Ludo's three slices, in order, each one playtested before the next
1. SLICE 1 - TWO BOXERS: the Day Plan stacks two rows; a coach pill per block flips the coach between them; the other row runs
   self-directed (0.40); both men work their stations on the floor. Test: "does deciding who gets the coach feel like a decision?"
   (the operator plays it + Ziva rates it).
2. SLICE 2 - CAPACITY + SPAR PAIRING + AUTO-PLAN: ring 1 solo / 2 sparring, heavy bags 2, speed bag 1, mitts with the coach only;
   two rows on RING SPAR at one block pair up; AUTO-PLAN fills a conflict-free plan. Test: "3 men planned in under 20 s".
3. SLICE 3 - THREE ON THE FLOOR: all boxers walk to their stations, the coach walks between them, quiet bubbles, the 3-column receipt.

How it gets built: the rules (who may use which station when, coach assignment, conflicts, pairing, AUTO-PLAN) as ONE pure module +
contract test (Arena), then the board and the floor (Ziva holds the Day Plan / floor area), Claude wires and gates on game-camera stills.

## Claude's calls on Ludo's details
- Ludo's numbers (+0.62 POW per block, coach x1.15-1.35, shadowboxing 0.25x, "-$150 sparring fee saved") are illustrations; the
  live training model computes gains. The one new rate a slice needs (a displaced boxer shadowboxing) is measured against the live
  self-directed day before it ships, never copied.
- Demo roster cap of 3 at Calder House (Ludo recommends) - YES, it is what the floor holds; asked on the board with the slice.
- Squads / a second coach for 5+ boxers - full game, not the demo.

## NEEDS THE OPERATOR (board)
- Build slice 1 now? (the new mechanic: more than one boxer trained on the floor)
- Ludo's other two: sparring your own boxers can cause small cuts before a fight; walk-in signing money for boxers 2 and 3.

## DECISION (S270): PARKED - one boxer first
Claude advised keeping one boxer and making the stations deep until the one-boxer day is fun (Ziva rated the gym loop 5.5: the
single-boxer day is not yet visible or readable; the floor drives one boxer, so slice 1 alone is weeks of new layer). Operator in
chat: "ok". Q-S264-6 answered "not now". Reopen when the one-boxer gym loop rates >= 9/10 (ZIVA9); Ludo's design above is the plan.
