# TASK G100 - GROK - HOW MUCH DO FIGHTERS ACTUALLY MOVE? (research only)
Model: Grok, Research mode (never Build). Assigned S77, 2026-09-25, by Claude.

## Why
Operator, 2026-09-25, verbatim: "usually fighters are a lot more static ... you are moving them too much, they will
drain out energy, stamina, the mostly stay in place and try to exchange" and "they need side stepping faking and all
this things while their body doesnt move much the posture is changing thinking about their next burst/move".
Our engine, measured (tools/s77_camera_probe.gd, 60 s, boxing): each man is travelling faster than 0.25 m/s in
72-84% of frames and covers ~50 m per minute; MMA 41-47%, ~33 m/min. We have no real-world number to hold it to.

## What would a human do?
Answer FIRST: what does a boxing / MMA coach teach about economy of movement - when to stay in the pocket, when to
reset, how a fighter "stays busy" without walking (feints, head movement, weight shifts, level changes)? What does a
sports scientist measure in a time-motion analysis, and how?

## Questions - numbers, each SOURCED (paper/dataset, year, n) or marked PROXY/JUDGEMENT
1. Time-motion analyses of boxing (amateur and pro) and MMA/UFC: share of round time STATIONARY vs low-intensity
   movement vs high-intensity (bursts); work:rest ratios; mean burst and pause durations.
2. Distance covered per round (m) by a fighter, and steps per minute, from GPS/video tracking studies if any.
3. How it varies: style (pressure fighter vs out-boxer vs counter-puncher), weight class, round 1 vs late rounds.
4. Side steps / pivots per minute and typical size (cm); feints per minute (hand, shoulder, foot, level change).
5. Rhythm: typical cycle "hold ground -> burst (step in, exchange, step out) -> reset", with seconds per phase.
6. The energy side: metabolic cost of footwork vs standing guard, if measured.

## Deliverable
One markdown memo; Claude saves it as `research/G100_TIME_MOTION.md`. A final table of numbers FightCamp
can gate on (share moving, m/min, bursts/min, burst s, pause s, side steps/min, feints/min), each tagged.
