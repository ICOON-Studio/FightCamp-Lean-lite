# FIGHTWEEKPROBE1 result (S450): what the tank and a flat round 1 are worth in wins

Brief: ops/research/TASK_FIGHTWEEKPROBE1.md. Qwen's run died silently after a draft (no process, no output); Claude rewrote the probe
(tools/fightweek_probe.gd) and ran it on main after BODYFACTS1 (our fighters carry height and reach) and before FIRELEVEL3.

Run: `python ops/Tools/godot_slot.py run --who S450-FIGHTWEEKPROBE1 -- <Godot_v4.7.2-stable_win64.exe> --headless --audio-driver Dummy
--path . --script res://tools/fightweek_probe.gd -- nb=400` (924 s, 71 cells, 400 bouts a cell, the real bout: Bouts.fight_step +
LiveRound, the ask_probe2 loop). RESULT: `FIGHTWEEK_PROBE done cells=71`.

## Method, and two fixes to the draft
- The tank: bout["stale"] = energy off at the first bell (BoutNight._peak keeps it; BoutNight._energy subtracts it).
- The flat round 1: the SAME opponent as a southpaw twin, so LiveRound's stance_edge gives our orthodox, never-faced boxer -0.6 in round
  1 only. The draft compared two different opponents and never applied the flat to "Rest up"; both fixed.
- The pairs: since S398 an opponent's rating builds attributes fought exchange by exchange, so "fight power + 0.5" is not an even fight
  (Lucy won ~5 in 100). Each pair is CALIBRATED on win share at tank 0, sharp: EVEN Priya Nair 53.0 (45 %), EDGE Erin Doyle 55.3
  (67-70 %), UNDER Maria Ortega 58.7 (29-38 %), three different boxers; men's lightweight Danny Osei vs Dean Clarke 52.0 (50-55 %).
- Noise: one cell of 400 has a standard error of about 2.5 wins in 100; the seed rows show a spread of up to 9 across three seeds.

## 1. Tank price curve (win %, 400 bouts a cell)
| Energy off at the bell | 0 | 4 | 8 | 12 | 16 | 20 | 25 |
|---|---|---|---|---|---|---|---|
| EVEN | 45 | 48 | 46 | 43 | 35 | 38 | 37 |
| EDGE | 69 | 69 | 65 | 66 | 61 | 57 | 53 |
| UNDER | 38 | 35 | 31 | 32 | 26 | 25 | 26 |
| men's EVEN | 55 | - | 48 | 49 | - | - | 43 |

The tank costs almost nothing over the first 8 points (0 to 4 wins, inside the noise) and about 0.7-1.0 win a point from 12 to 20. It is
CURVED. The whole 25 costs 8 (even), 16 (edge), 12 (under), 12 (men). Stoppages barely move; the loss comes on the cards (r3_lost).

## 2. Round-1 price (tank 0)
| Pair | sharp: win / round 1 won | flat (-0.6): win / round 1 won |
|---|---|---|
| EVEN | 44 / 44 | 43 / 42 |
| EDGE | 71 / 47 | 70 / 47 |
| UNDER | 36 / 28 | 35 / 27 |
| men's EVEN | - | 52 / 45 |

A flat round 1 at 0.6 is worth about 1 win in 100 and moves round 1 itself by 0-2. It is NOT the "coin-flip round becomes 4 in 10" the
map assumed. 0.3 and 1.0 need a rule change (NEVER_FACED is a const): FIGHTWEEKPROBE2 measures a flat at 1.0, 2.0 and 3.0 through a
FightWeek round-1 key.

## 3. The three week shapes
| Pair | Rest up (tank 0, flat) | Tick over (8, sharp) | Train through (12, sharp) | best - worst |
|---|---|---|---|---|
| EVEN | 48 | 45 | 44 | 4 |
| EDGE | 71 | 67 | 65 | 6 |
| UNDER | 32 | 31 | 30 | 2 |

Rest up wins for ALL three pairs: the shapes are a lookup on fight night (the flat costs less than 8 points of tank). The spread, 2 to 6,
is half the target's 10 to 12.

## 4. Seed spread
EVEN tank 0 / 8 / 12 / 25: spreads 6, 8, 9, 8 across seeds 4421-4423; flat 8. UNDER: 3, 1, 3, 3; flat 4. The headlines hold their
order on every seed (tank 0 > 12 > 25), but single steps of 4 points are inside the noise.

## Answers
- One point of tank: about 0.1 win in 100 near 0 (flat to 8 off), about 0.7-1.0 near 12-20. Curved.
- A flat round 1 at 0.6: about 1 win in 100.
- Does one shape win for every pair? YES, Rest up: the shapes are a lookup and the design must change.
- Prices that make best-minus-laziest 10-12 in 100: the flat round 1 must be worth about 4-5 (a round-1 edge near 2.0-2.5, to be
  measured by FIGHTWEEKPROBE2), and the week's load must carry a real fight-night CREDIT as well as a cost (Tick over: sharp AND the
  banked half week as a small edge, e.g. +1 on lines ready), so Tick over beats Rest up on an even or edge bout and Rest up wins only
  when tiredness is high. The load stops' tank costs (8 and 12) can stay: they sit on the flat part of the curve.

## FIGHTWEEKPROBE2 (S450, `-- nb=400 probe2=1`, 462 s, 24 cells): a flat round 1 through bout["r1_flat"]
LiveRound now subtracts bout["r1_flat"] (default 0) from round 1's base edge: the fight week's FLAT, measured before it is built.
| Flat round 1 | 0 | 1.0 | 2.0 | 3.0 |
|---|---|---|---|---|
| EVEN: win / round 1 won | 49 / 48 | 48 / 46 | 46 / 43 | 45 / 41 |
| EDGE | 72 / 55 | 71 / 52 | 70 / 49 | 69 / 46 |
| UNDER | 33 / 27 | 32 / 25 | 31 / 23 | 29 / 20 |
Shapes with Rest up flat at 2.0 (win %): EVEN Rest up 45 / Tick over 6 off 45 / Tick over 8 off 45 / Train through 42; EDGE 70 / 69 / 67 /
67; UNDER 26 / 28 / 27 / 26. No shape wins every pair; every gap is inside the noise.
Conclusion: a fight week's fight-night levers top out at about 5 wins in 100 in this engine. The 10-12 target moves to the SEASON (the
banked work against the fresh night), measured by FIGHTWEEKPROBE3 through the career harness (AMATEURWEEK1 map v4 section 4b).
RESULT: `FIGHTWEEK_PROBE done cells=24` (probe2), `FIGHTWEEK_PROBE done cells=71` (probe 1).
