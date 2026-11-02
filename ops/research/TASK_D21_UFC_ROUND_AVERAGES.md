# TASK D21 - DOLA - WHAT A REAL MMA ROUND LOOKS LIKE IN NUMBERS (research only, no code)
Owner: dola. Assigned S76, 2026-09-25. Driven with `python Tools/cici/cici.py send --file ...`.

## Why
S76 shipped the between-round MMA card: significant strikes landed/attempted, takedowns landed/attempted, control time,
knockdowns. Our engine's numbers must be judged against real per-round averages.

## What would a human do?
A UFC Stats / FightMetric analyst quotes the division averages from FightMetric's own definitions: significant strikes
landed and attempted per minute, significant strike accuracy, takedowns attempted and landed per 15 minutes, takedown
accuracy, and ground control share - by weight class.

## Do
For EVERY figure: a URL or DOI to the page that states it, the quoted figure, and SOURCED / NOT FOUND.
1. Significant strikes landed and attempted per minute (or per round), and accuracy %, overall and by weight class.
2. Takedowns attempted and landed per 15 min, and takedown accuracy %, overall and by weight class.
3. Control time as a share of fight time, if FightMetric or a study publishes it.
4. Knockdowns per fight (or per 15 min).

## Deliverable
One markdown table set; Claude saves it verbatim as `research/D21_UFC_ROUND_AVERAGES.md`.
