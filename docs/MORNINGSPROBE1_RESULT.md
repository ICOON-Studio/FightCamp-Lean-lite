# MORNINGSPROBE1 Result

Probe run: 2026-11-17T23:24:52. 2 seeds off 4421, 12 weeks, 10 even bouts a boxer, ability jitter +/-4.0.

Is the coached-morning deal (map 3.5) worth a screen? Solo x1.25, solo on the WEAK SPOT x1.40, shared x1.15 are ESTIMATES. Bar: each policy best on 30-70 of 2 seeds is a real choice; over 70 is dominant.

## Population

The TEST CLUB (scripts/state/TestClub.gd): **Lucy** (women's lightweight), **Kira** (women's featherweight), **Josh** (men's welterweight). Ana the no-gi athlete takes no mornings. Each seed jitters all six fight abilities +/-4.0 (per-seed RNG off 4421); potential as written (Lucy 84, Kira 86, Josh 79). The SAME club faces all three policies and both coach kinds, so the headroom difference is the policy's, not the population's.

Opponents: the ten nearest-rated **distinct** amateurs of the same sex in the region's population (Data.OPPONENTS + MISMATCH + RIVALS + DIVISION_RIVALS), fixed on the boxer's PRE-TRAINING fight power so all three policies face the identical ten. A division's own pool holds only 4-11 fighters. evenness: boxer fight power 58.89 before training, the ten opponents' mean rating 58.97 (12 samples).

## Method

- No bout during the 12 weeks: the coach's BASE week (roadwork, heavy bag, intervals, speed bag light, roadwork, strength, rest) - the SAME ability for all three boxers on a day, so ALL SHARED can pair on it.
- Asks laid day-major (Monday's three boxers in club row order, then Tuesday's), dealt club-wide by CoachedMornings.deal (6 sessional, 7 full-time). It pairs across days; a lone shared becomes solo.
- A FUNDED morning trains the ask's ability at WeekPlan's normal morning rate x CoachedMornings.mult; every unfunded morning runs exactly as the coach wrote it. Minutes, load, kcal and fatigue are unchanged, so the fatigue trace is identical across policies - a control.
- ALL SOLO asks the lowest of the six abilities; WEAK FIRST asks the WEAK SPOT (3+ under the mean) and falls back to shared once the hole closes. The hole is re-read every week.
- Then 10 even bouts a boxer through Bouts.fight_step (ask_probe2's loop), the same dice for every policy, at BoutRules.FRESH_FATIGUE (50) as ask_probe2's boxers are. The 12 weeks' fatigue trace is identical across policies (the sessions' load never changes), so that condition cannot bias the comparison. Best-of-seed is by wins out of 30; a tie splits the best credit.

## Table (per-seed averages over 2 seeds)

pts = all stat points the three boxers gained; weak = points on the ability weakest at the start; power = fight power gained; W/L = the 30-bout record; sess/wk = funded boxer-mornings a week; gain/morn = one funded morning's stat gain.

### SESSIONAL - 6 coached mornings a week

```
  policy      pts    weak   power    W     L    win%  best/100 outright  sess/wk  gain/morn
  ALL_SHARED  58.36   7.12   9.73 18.00 12.00  60.0      0.5        0    12.00     0.149
  ALL_SOLO    64.28  17.23  10.71 18.50 11.50  61.7      1.0        0     6.00     0.259
  WEAK_FIRST  64.15  16.62  10.69 17.50 12.50  58.3      0.5        0     6.58     0.248
```

Seeds tied on wins: 2 of 2. Joint best (a tie counted for each): ALL_SHARED 1, ALL_SOLO 2, WEAK_FIRST 1.

**SESSIONAL: ALL_SHARED 0.5, ALL_SOLO 1.0, WEAK_FIRST 0.5 -> NOT A REAL CHOICE: ALL_SHARED sits outside 1-1 of 2 seeds. Move SHARED (now x1.15) up, or SOLO (x1.25) down.**

### FULL_TIME - 7 coached mornings a week

```
  policy      pts    weak   power    W     L    win%  best/100 outright  sess/wk  gain/morn
  ALL_SHARED  58.79   7.12   9.80 18.00 12.00  60.0      1.0        1    13.00     0.150
  ALL_SOLO    65.18  18.49  10.86 18.00 12.00  60.0      0.5        0     7.00     0.251
  WEAK_FIRST  65.10  17.53  10.85 17.50 12.50  58.3      0.5        0     8.00     0.237
```

Seeds tied on wins: 1 of 2. Joint best (a tie counted for each): ALL_SHARED 1, ALL_SOLO 1, WEAK_FIRST 1.

**FULL_TIME: ALL_SHARED 1.0, ALL_SOLO 0.5, WEAK_FIRST 0.5 -> NOT A REAL CHOICE: ALL_SOLO sits outside 1-1 of 2 seeds. Move SOLO (now x1.25) up, or SHARED (x1.15) down.**

## Finding

- SESSIONAL: ALL SOLO gains MORE total points than ALL SHARED (64.28 vs 58.36) and more on the weakest ability (17.23 vs 7.12). The map's 'shared is the bigger total and solo is the focus' does NOT hold: headroom pays the hole 0.259 a morning against shared's 0.149, so 6 solo mornings a week out-gain 12 shared ones.
- FULL_TIME: ALL SOLO gains MORE total points than ALL SHARED (65.18 vs 58.79) and more on the weakest ability (18.49 vs 7.12). The map's 'shared is the bigger total and solo is the focus' does NOT hold: headroom pays the hole 0.251 a morning against shared's 0.150, so 7 solo mornings a week out-gain 13 shared ones.

## The trap

The morning gain is clamped by headroom (potential - stat, /25, 0.10-1.25): a weak spot far under potential gains more per morning anyway. gain/morn is that read - compare it against the shared row on the week's own abilities.

Reproduce: `python ops/Tools/godot_slot.py run --who morningsprobe1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --log-file E:/FightCamp/tmp/morningsprobe1.log --script res://tools/mornings_probe1.gd`
