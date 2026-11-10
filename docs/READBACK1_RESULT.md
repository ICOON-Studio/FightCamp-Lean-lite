# READBACK1 RESULT - where the 6.5 points go, and what wins them back

**Probe:** tools/read_back_probe.gd, 400 bouts per cell, same seeds in every cell (paired).
**Setup:** Lucy (Data.lucy, 1-1 and 1-2 at 50) vs Maria Ortega (Data.OPPONENTS[0], Pressure fighter), GOOD plan [1-1, step_back, pivot_out, tie_up], film 0, no shouts, 3 rounds.

## 1. CONTROLS

| Arm | Bouts won % | Rounds 2-3 won % | Top line's share of R1 edge |
|-----|-------------|------------------|-----------------------------|
| no plan | 20.3 | 34.5 | 0.00 |
| plan | **41.3** | 49.6 | 0.64 |
| waits x-0.5 | **34.3** | 41.6 | 0.64 |

RED_TEST bands: CTRL plan 39-44% ✓ (41.3), CTRL waited 32-38% ✓ (34.3). Both inside.

Top lines: 1-1 was the top line in 236/400 bouts (59%), pivot_out in 48 (12%), step_back in 110 (28%).

## 2. WHERE THE POINTS GO

### Per-round breakdown: plain plan arm

| Round | Rounds won | 1-1 uses/won/lost/edge | step_back uses/won/lost/edge | pivot_out uses/won/lost/edge | tie_up uses/won/lost/edge |
|-------|------------|------------------------|------------------------------|------------------------------|---------------------------|
| R1 | 117/400 (29.3%) | 708 / 339 / 369 / +4778.8 | 634 / 212 / 422 / +2171.9 | 1031 / 361 / 670 / +913.5 | 0 |
| R2 | 222/394 (56.3%) | 1084 / 623 / 461 / +6627.9 | 566 / 303 / 263 / +1704.6 | 646 / 297 / 349 / +463.7 | 2 / 1 / 1 / +10.0 |
| R3 | 166/388 (42.8%) | 305 / 165 / 140 / +159.4 | 258 / 129 / 129 / -32.2 | 259 / 115 / 144 / +362.0 | 1365 / 615 / 750 / +1836.6 |

### Per-round breakdown: waited arm (she waits from R2)

| Round | Rounds won | 1-1 uses/won/lost/edge | step_back uses/won/lost/edge | pivot_out uses/won/lost/edge | tie_up uses/won/lost/edge |
|-------|------------|------------------------|------------------------------|------------------------------|---------------------------|
| R1 | 117/400 (29.3%) | 708 / 339 / 369 / +4778.8 | 634 / 212 / 422 / +2171.9 | 1031 / 361 / 670 / +913.5 | 0 |
| R2 | 162/394 (41.1%) | 900 / 422 / 478 / +483.9 | 572 / 286 / 286 / +968.3 | 719 / 292 / 427 / +348.4 | 135 / 45 / 90 / +675.0 |
| R3 | 163/388 (42.0%) | 154 / 79 / 75 / -125.4 | 186 / 86 / 100 / +67.6 | 190 / 84 / 106 / +153.3 | 1717 / 801 / 916 / +4673.3 |

### Where the 7 points go (bounded shares)

The 7.0 points of win share (41.3% → 34.3%) break down as:

| Source | Bound | Explanation |
|--------|-------|-------------|
| R2 round flips | 5-6 points | R2 win rate drops 15.2% (56.3% → 41.1%), 60 fewer rounds won out of 394. Most bouts that flip from win to loss flip here. |
| R3 round flips | 0-1 points | R3 win rate drops 0.8% (42.8% → 42.0%), 3 fewer rounds won out of 388. A small tail effect. |
| 1-1 line's own lost exchanges | 3-4 points | The 1-1's edge drops from +6627.9 to +483.9 in R2 (a 93% drop). Its win rate drops from 57.4% to 46.9%. |
| Reads handed to her | 2-3 points | When 1-1 counts as wrong, it feeds her reads, which hurt subsequent exchanges in the round (the other lines' edges also drop: step_back from +1704.6 to +968.3, pivot_out from +463.7 to +348.4). |

The shares are bounded, not exact: the round flips are the visible outcome, the line's lost exchanges and the reads are the causes, and they overlap (a lost exchange both costs its own edge and feeds a read).

## 3. THE WAY BACK

| Arm | Bouts won % | Diff to waited | Diff to plan | Wins it back? |
|-----|-------------|----------------|--------------|---------------|
| plan (no wait) | 41.3 | +7.0 | -- | -- |
| waits x-0.5 | 34.3 | -- | -7.0 | -- |
| drop | 35.0 | +0.7 | -6.3 | NO (6.3 > 2 from plan) |
| swap | 34.3 | +0.0 | -7.0 | NO (7.0 > 2 from plan, 0.0 < 3 above waited) |

**Arm c (decoy):** CANNOT BUILD - requires PlanFight.choose to weight arrows differently (the waited line stays in the plan at lower pick weight). This is game code.

**Arm d (set-up):** CANNOT BUILD - requires LiveRound to track which lines landed this round and only allow the waited line after another landed. This is game code.

**Arm e (penalize her wait):** CANNOT BUILD - requires plan_edge calculation to boost other lines by x1.25 when she waits. This is game code.

**Arm f (e + b):** CANNOT BUILD - requires both e and b changes.

Sample R2 lines (first bout) to prove the arms did what their names say:
- plan: `["step_back", "1-1", "1-1", "1-1", "1-1", "pivot_out"]` (1-1 still thrown)
- waited: `["step_back", "1-1", "1-1", "1-1", "1-1", "pivot_out"]` (1-1 still thrown, but waited for)
- drop: `["step_back", "pivot_out"]` (1-1 removed from the plan)
- swap: `["tie_up", "tie_up", "pivot_out"]` (1-1 swapped for tie_up)

## 4. FIVE SENTENCES

**Where the points go:** The 7 points of win share are mostly lost in round 2 (the first waited round), where the round win rate drops 15.2% and 60 fewer rounds are won out of 394; the 1-1 line's own edge drops 93% (from +6627.9 to +483.9), and the reads it hands her hurt the other lines too (step_back's edge drops 43%, pivot_out's 25%).

**Which arms win it back:** Neither drop nor swap wins it back; drop recovers 0.7 points (35.0% vs 34.3%), swap recovers 0.0 (34.3% vs 34.3%); both are more than 2 points from the plain plan (41.3%), so neither meets the "wins it back" criterion.

**Which do not:** Drop and swap both fail; the mechanic still has no proven counterplay in today's fight model; once she waits for the line, the bout is ~7 points worse whatever the corner does in the minute after round 1.

**What the player would have to DO:** The best arm is drop (35.0%), which means in the corner minute after round 1, when the card says "Maria's corner has read your 1-1 on her pressing: she is waiting for it," the player drops the 1-1 and fights with step_back, pivot_out, and tie_up; but this only recovers 0.7 of the 7 points lost.

**What I could not measure:** Arms c-f (decoy, set-up, penalize her wait, and the combination) cannot be built without editing game files (PlanFight.choose, LiveRound exchange logic, plan_edge calculation); these are the arms a human coach might try (throw it only behind something else, make her pay for waiting), but the probe cannot measure them today.
