# TASK G142 - GROK - BACK CONTROL: FROM HOOKS-IN TO THE TAP OR THE ESCAPE (S104)
Owner: grok (Expert mode, never Build). Assigned 2026-09-27 (S104). Deliverable: one markdown answer, which Claude saves
as `research/G142_BACK_CONTROL.md`. Fresh chat.

## Why
G139 (fence), G140 (one down, one up) and G141 (front headlock / turtle) cover G138's three missing MMA states, and
G141 hands its commonest exits - the go-behind and the turtle back-take (~30% of turtle resolutions) - to "back control".
Our engine has a `back` ground seat, but its rates were never checked against real fights: how long a man keeps the
back, how often the rear-naked choke comes, how often it finishes, and how the bottom man escapes. The RNC is ~39% of
UFC submissions, so this seat decides fights.

## What would a human do?
A BJJ black belt coaching MMA and a FightMetric coder know this seat. The top man takes a seatbelt and hooks (or a body
triangle), flattens or rides upright, hand-fights the wrist, punches the open side of the head, and finishes with the
RNC (or a neck crank / short choke). The bottom man two-on-ones the choking hand, clears a hook, slides his hips to
the mat side, turns in to guard or top, or stands up on the fence with the man on his back. The referee stands them up
only if nothing happens. Answer as that coach and coder would.

## Prefab check
Name any dataset that tags back control, its duration or its exits (UFCStats control time, Sportradar `backControl`
position and control-time fields, BJJ positional studies, ADCC / BJJ Heroes transition data, academic MMA submission
studies), its licence, and whether the numbers are public.

## Questions (tables, grade every figure S sourced / P proxy / J judgement, cite)
1. Entries: where back takes come from in MMA (turtle, go-behind from a front headlock, scramble, a standing back take
   against the fence, off a failed sweep), with shares.
2. Duration: median and spread of a back-control visit in UFC; how it differs with hooks vs body triangle, flat vs upright,
   on the fence vs open mat.
3. Exits with shares and median seconds: RNC attempt (and its finish-given-attempt rate), other chokes, the bottom man
   escapes to guard / turns into top / stands up, the top man falls off to mount, ground-and-pound stoppage from the
   back, referee stand-up, the round ends.
4. Strikes: what the top man throws from the back, landed per 10 s, and how often a back-control GnP stops a fight.
5. Weight class and sex: does any of this change materially?
6. For a simulation: the smallest per-second hazard table for a `back` seat that reproduces 1-4, plugged into G141's
   FHL/TURTLE exits. Name the acceptance numbers a census should hit, and what can be deferred.
