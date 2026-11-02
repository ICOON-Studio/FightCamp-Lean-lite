# TASK G99 - GROK - WHAT A REAL ROUND OF BOXING LOOKS LIKE IN NUMBERS (research only)
Model: Grok Research mode, Expert (never Build). Owner: grok. Assigned S76, 2026-09-25.

## Why
S76 shipped the between-round CompuBox card. On our engine a boxing round reads ~25 punches thrown per fighter, 50-60%
landed, and only ~1 in 5 a jab. The card now shows the player those numbers, so they must be anchored to real ones.

## What would a human do?
A CompuBox analyst or a boxing statistician compares a fight against the published averages for the weight class:
punches thrown per round, jab share, jab and power connect %, and how those move by weight and by round. They quote
CompuBox's own "average fighter" figures, not one famous fight.

## Do
1. CompuBox's published averages per round per fighter: total thrown, total landed %, jabs thrown/landed %, power
   thrown/landed %. By weight class if published, and the round-by-round shape (does output fall late?).
2. Body share of landed power punches, if CompuBox or a study publishes it.
3. Amateur (3x3 min) vs pro, if any source separates them.
Tag every number SOURCED (URL + quoted figure) / JUDGEMENT / NOT FOUND. No invented figures.

## Deliverable
One markdown reply with tables; Claude saves it verbatim as `research/G99_COMPUBOX_AVERAGES.md`.
