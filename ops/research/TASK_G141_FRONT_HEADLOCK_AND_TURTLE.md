# TASK G141 - GROK - FRONT HEADLOCK AND TURTLE: WHERE STUFFED SHOTS GO (S103)
Owner: grok (Expert mode, never Build). Assigned 2026-09-27 (S103). Deliverable: one markdown answer, which Claude saves
as `research/G141_FRONT_HEADLOCK_AND_TURTLE.md`. Fresh chat.

## Why
G138 ranked three missing MMA states. G139 (fence pin) and G140 (one down, one up) are in hand; this is the third: the
front headlock and the turtle, where most failed shots end up (G138: 15-25% of stuffed shots to front headlock, 10-15%
to turtle). Our engine has neither: a stuffed shot resets to distance or goes straight to a guard. They feed the
guillotine, the back take, the snap-down and the referee stand-up, so they decide fights.

## What would a human do?
A wrestling coach and a FightMetric coder know this moment. The sprawler snaps the head, cuts an angle, and chooses: go
for the guillotine or the D'Arce/anaconda, spin to the back, knee the head (legal only if the man is not grounded), or
let go and stand. The shooter on the bottom chooses: stand up (hand fight, "come up on the fence"), sit out, roll for a
single, re-shoot, or turtle and wait. Answer as that coach and coder would.

## Prefab check
Name any dataset that tags front-headlock or turtle positions or their exits (FightMetric position codes, Sportradar,
academic studies of wrestling transitions, ADCC/BJJ positional datasets such as BJJ-heroes or published grappling
position-transition studies), its licence, and whether the numbers are public.

## Questions (tables, grade every figure S sourced / P proxy / J judgement, cite)
1. Entries: share of stuffed shots that become a front headlock, and a turtle; other entries (a failed guard pull, a
   sweep scramble, a knockdown where the man turtles).
2. Front headlock exits with shares and median seconds: guillotine attempt (and its finish rate), D'Arce/anaconda,
   go-behind / back take, snap-down to the mat, the bottom man stands up, re-shot / single leg, referee stand-up.
3. Turtle exits with shares and seconds: back taken (hooks in), bottom man stands, sit-out / roll to guard, front
   headlock regained, ground-and-pound stoppage from turtle (how often a referee stops a turtled man).
4. Legal strikes in each (Unified Rules 2024 grounded definition): knees to the head of a turtled man are illegal; what
   the top man actually throws; typical strikes per 10 s.
5. Weight class and sex: does any of this change materially?
6. For a simulation: the smallest addition (states, transitions, per-second rates) that plugs into G138/G139/G140's
   machines and reproduces 1-4. Name the acceptance numbers a census should hit, and what can be deferred.
