# TASK G140 - GROK - ONE DOWN, ONE UP: THE SECONDS AFTER A KNOCKDOWN OR A STUFFED SHOT (S102)
Owner: grok (Expert mode, never Build). Assigned 2026-09-27 (S102). Deliverable: one markdown answer, which Claude saves
as `research/G140_ONE_DOWN_ONE_UP.md`.

## Why
G138 ranked "one-down / one-up" the second missing MMA state: after almost every standing knockdown, and after some stuffed
shots and slips, one man is on the canvas and the other stands over him. It is short but decides fights: 63.5% of fights
with a knockdown end by KO/TKO. Our engine has no such state - a knockdown either ends it or resets to standing. We need
the real branches and rates before building it.

## What would a human do?
A referee and a cornerman know this moment best. The referee watches for "intelligent defence" to decide a stoppage; the
standing fighter chooses to follow him down (ground-and-pound), stay up and wait, or kick the legs; the downed fighter
upkicks, shells up, grabs a leg, wall-walks or stands straight back up. A FightMetric coder times it and records how it
ends. Answer as that referee/coach would.

## Prefab check
Name any dataset that tags knockdown aftermath or "downed fighter" positions (FightMetric knockdown field, Sportradar,
academic knockdown/stoppage studies), its licence, and whether the numbers are public.

## Questions (tables, grade every figure S sourced / P proxy / J judgement, cite)
1. After a standing knockdown in UFC: how often does the standing man follow him down vs let him up vs stand over?
   Share of knockdowns that end the fight within 10 s / 30 s, and the median time to stoppage when it comes.
2. The downed fighter's responses (upkick, shell, leg grab / single, butt-scoot, stand straight up, wall-walk) - shares,
   and how often each works (back to feet safely).
3. Referee stoppage: what the referee looks for, and how often a knockdown is followed by a stoppage vs a recovery.
   Split flash knockdown vs heavy knockdown if the data allows.
4. Illegal-strike risk in this state (grounded opponent: knees to the head, soccer kicks under Unified Rules) - how often
   fouls happen here and what the referee does.
5. Non-knockdown entries (stuffed shot, slip, sweep attempt, failed guard pull): how often they produce the same
   one-down/one-up position and how long it lasts.
6. Boxing and kickboxing: the count replaces this state - the knockdown rules (standing 8, three-knockdown rule where it
   exists) as they affect a simulation.
7. For a simulation: the smallest state machine (states + transitions + per-second rates) that reproduces the above.
   Name what can be deferred.
