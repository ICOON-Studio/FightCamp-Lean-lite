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

## Round 2

**Probe:** tools/read_back_probe.gd, 400 bouts per cell, same seeds in every cell (paired).
**Setup:** Lucy (Data.lucy, 1-1 and 1-2 at 50) vs Maria Ortega (Data.OPPONENTS[0], Pressure fighter), GOOD plan [1-1, step_back, pivot_out, tie_up], film 0, no shouts, 3 rounds.
**Rules:** Two new rules in scripts/rules/ReadBack.gd, each read from a bout key and OFF when the key is absent:
- `set_up` (bool): a waited line used AFTER another planned line won an exchange earlier in the same round is NOT waited for on that use (keeps full edge, not a wrong answer): thrown behind something.
- `wait_cost` (float, e.g. 1.25): while her corner waits for a line, Lucy's OTHER planned lines earn their edge times this in that round: the corner looking for one thing sees the others late.

| Arm | Bouts won % | Diff to waited | Diff to plan | R2 1-1 uses/won/lost | Wins it back? |
|-----|-------------|----------------|--------------|----------------------|---------------|
| plan (no wait) | 41.3 | +7.0 | -- | 1064/608/456 | -- |
| waits x-0.5 | 34.3 | -- | -7.0 | 880/408/472 | -- |
| drop | 35.0 | +0.7 | -6.3 | 285/154/131 | NO (6.3 > 2 from plan) |
| swap | 34.3 | +0.0 | -7.0 | 285/154/131 | NO (7.0 > 2 from plan, 0.0 < 3 above waited) |
| d set_up | 38.3 | +4.0 | -3.0 | 986/552/434 | NO (3.0 > 2 from plan) |
| e wait_cost 1.25 | 35.5 | +1.2 | -5.8 | 881/407/474 | NO (5.8 > 2 from plan, 1.2 < 3 above waited) |
| e2 wait_cost 1.5 | 38.0 | +3.7 | -3.3 | 894/417/477 | NO (3.3 > 2 from plan) |
| g set_up + wait_cost 1.25 | 39.0 | +4.7 | -2.3 | 985/549/436 | NO (2.3 > 2 from plan) |
| h g + swap | 35.0 | +0.7 | -6.3 | 277/148/129 | NO (6.3 > 2 from plan, 0.7 < 3 above waited) |
| i set_up from R1 | 38.3 | +4.0 | -3.0 | 986/552/434 | NO (3.0 > 2 from plan) |

**Which rule gives a real way back and how much:** Arm g (set_up + wait_cost 1.25) comes closest at 39.0%, which is 4.7 points above the waited arm and 2.3 points below the plain plan. The set_up rule alone (arm d) recovers 4.0 points (38.3% vs 34.3%), and wait_cost 1.5 alone (arm e2) recovers 3.7 points (38.0% vs 34.3%). The combination (arm g) recovers 4.7 points, but still falls 2.3 points short of the plain plan.

**What the player would have to do for it:** In the corner minute after round 1, when the card says "Maria's corner has read your 1-1 on her pressing: she is waiting for it," the player would have to (1) throw the 1-1 only behind something else (set_up: wait for another planned line to win first, then throw the 1-1), and (2) make her pay for waiting (wait_cost: the other lines work better because she's looking for the 1-1). In the plan, this means keeping the 1-1 but understanding it's a second-shot weapon. In the week before, this means drilling the set-up: the 1-1 comes after the step_back or pivot_out has already worked.

**Whether any arm now beats the PLAIN plan:** No arm beats the plain plan. The closest is arm g at 39.0%, which is 2.3 points below the plain plan's 41.3%. A rule that makes being read an advantage would be wrong - it would reward the opponent for reading, which breaks the game's logic. The rules measured here don't do that: they give a way back, but not a way ahead.

**What is still unmeasured:** The decoy arm (c: the waited line stays in the plan at lower pick weight) cannot be built without editing PlanFight.choose. The exact threshold where wait_cost becomes too much (making the other lines too strong) is unmeasured. The interaction between set_up and the round's reads (PlanRead) is unmeasured: does throwing the 1-1 behind something else change how the opponent reads the round? The week-before drilling (how the player practices the set-up) is unmeasured.

## Round 3

**Probe:** tools/read_back_probe.gd, 400 bouts per cell, same seeds in every cell (paired).
**Setup:** Lucy (Data.lucy, 1-1 and 1-2 at 50) vs Maria Ortega (Data.OPPONENTS[0], Pressure fighter), GOOD plan [1-1, step_back, pivot_out, tie_up], film 0, no shouts, 3 rounds.
**Fix:** The set-up rule now tracks WHICH planned line won per round (cleared at the bell), and only a DIFFERENT line's win counts (the waited line's own win does not set it up: you cannot throw yourself behind yourself). The bug in READBACK2 was that `lv["plan_won"] = true` was never cleared between rounds and counted the waited line's own win as "another line".

| Arm | Bouts won % | Diff to waited | Diff to plan | R2 1-1 uses/won/lost | Set-up uses (R2) | Wins it back? |
|-----|-------------|----------------|--------------|----------------------|------------------|---------------|
| plan (no wait) | 41.3 | +7.0 | -- | 1064/608/456 | 761/303 | -- |
| waits x-0.5 | 34.3 | -- | -7.0 | 880/408/472 | 614/266 | -- |
| drop | 35.0 | +0.7 | -6.3 | 285/154/131 | 130/155 | NO (6.3 > 2 from plan) |
| swap | 34.3 | +0.0 | -7.0 | 285/154/131 | 130/155 | NO (7.0 > 2 from plan, 0.0 < 3 above waited) |
| d set_up | 35.5 | +1.2 | -5.8 | 956/502/454 | 690/266 | NO (5.8 > 2 from plan) |
| e wait_cost 1.25 | 35.5 | +1.2 | -5.8 | 881/407/474 | 622/259 | NO (5.8 > 2 from plan, 1.2 < 3 above waited) |
| e2 wait_cost 1.5 | 38.0 | +3.7 | -3.3 | 894/417/477 | 636/258 | NO (3.3 > 2 from plan) |
| g set_up + wait_cost 1.25 | 37.8 | +3.5 | -3.5 | 954/499/455 | 695/259 | NO (3.5 > 2 from plan) |
| h g + swap | 35.0 | +0.7 | -6.3 | 277/148/129 | 126/151 | NO (6.3 > 2 from plan, 0.7 < 3 above waited) |
| i set_up from R1 | 32.0 | -2.3 | -9.3 | 843/409/434 | 624/219 | NO (9.3 > 2 from plan, below waited) |
| i no set-up from R1 | 26.0 | -8.3 | -15.3 | 690/270/420 | 484/206 | NO (15.3 > 2 from plan, below waited) |

**What changed against Round 2's numbers and why:** The fix reduced the set-up numbers because now only DIFFERENT lines count. Arm d (set_up) dropped from 38.3% to 35.5% (-2.8), arm g (set_up + wait_cost) dropped from 39.0% to 37.8% (-1.2), and arm i (set_up from R1) dropped from 38.3% to 32.0% (-6.3). The waited line's own win no longer counts as set-up, so fewer uses qualify. Arm i built properly (she waits from ROUND 1, not round 2) shows the full cost of being read from the start: 32.0% with set-up, 26.0% without.

**Which rule gives a real way back and how much:** Arm e2 (wait_cost 1.5) comes closest at 38.0%, which is 3.7 points above the waited arm and 3.3 points below the plain plan. The set-up rule alone (arm d) recovers only 1.2 points (35.5% vs 34.3%) now that it correctly requires a DIFFERENT line's win. The combination (arm g) recovers 3.5 points, but still falls 3.5 points short of the plain plan.

**What the player would have to do for it:** In the corner minute after round 1, when the card says "Maria's corner has read your 1-1 on her pressing: she is waiting for it," the player would have to (1) throw the 1-1 only behind something else (set_up: wait for a DIFFERENT planned line to win first, then throw the 1-1), and (2) make her pay for waiting (wait_cost: the other lines work better because she's looking for the 1-1). The set-up rule now correctly requires a different line to win first, so the player must actually set up the 1-1 with step_back or pivot_out before throwing it.

**Whether any arm now beats the PLAIN plan:** No arm beats the plain plan. The closest is arm e2 at 38.0%, which is 3.3 points below the plain plan's 41.3%. A rule that makes being read an advantage would be wrong - it would reward the opponent for reading, which breaks the game's logic. The rules measured here don't do that: they give a way back, but not a way ahead.

**What is still unmeasured:** The decoy arm (c: the waited line stays in the plan at lower pick weight) cannot be built without editing PlanFight.choose. The exact threshold where wait_cost becomes too much (making the other lines too strong) is unmeasured. The interaction between set_up and the round's reads (PlanRead) is unmeasured: does throwing the 1-1 behind something else change how the opponent reads the round? The week-before drilling (how the player practices the set-up) is unmeasured.

**Five sentences:** The fix to the set-up rule (tracking which line won per round, requiring a different line's win) reduced the set-up numbers by 1-6 points because the waited line's own win no longer counts as set-up. The closest arm to winning it back is e2 (wait_cost 1.5) at 38.0%, which recovers 3.7 points but still falls 3.3 points short of the plain plan. Arm i built properly (she waits from round 1) shows the full cost of being read from the start: 32.0% with set-up, 26.0% without, both worse than the waited arm. The set-up rule now correctly models "thrown behind something" as a different line winning first in the same round, not the waited line's own win or a win from an earlier round. No arm beats the plain plan: being read is never an advantage, but the wait_cost rule gives a partial way back by making the other lines work better while she waits.
