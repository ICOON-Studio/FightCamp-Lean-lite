# MORNINGSPROBE1 Result

Probe run: 2026-11-18T01:44:32. 40 seeds off 4421, 12 weeks, 10 even bouts a boxer, ability jitter +/-4.0.

Is the coached-morning deal (map 3.5) worth a screen? Solo x1.25, solo on the WEAK SPOT x1.40, shared x1.15 are ESTIMATES. Bar: each policy best on 30-70 of 40 seeds is a real choice; over 70 is dominant.

## Population

The TEST CLUB (scripts/state/TestClub.gd): **Lucy** (women's lightweight), **Kira** (women's featherweight), **Josh** (men's welterweight). Ana the no-gi athlete takes no mornings. Each seed jitters all six fight abilities +/-4.0 (per-seed RNG off 4421); potential as written (Lucy 84, Kira 86, Josh 79). The SAME club faces all three policies and both coach kinds, so the headroom difference is the policy's, not the population's.

Opponents: the ten nearest-rated **distinct** amateurs of the same sex in the region's population (Data.OPPONENTS + MISMATCH + RIVALS + DIVISION_RIVALS), fixed on the boxer's PRE-TRAINING fight power so all three policies face the identical ten. A division's own pool holds only 4-11 fighters. evenness: boxer fight power 59.04 before training, the ten opponents' mean rating 59.10 (240 samples).

## Method

- No bout during the 12 weeks: the coach's BASE week (roadwork, heavy bag, intervals, speed bag light, roadwork, strength, rest) - the SAME ability for all three boxers on a day, so ALL SHARED can pair on it.
- Asks laid day-major (Monday's three boxers in club row order, then Tuesday's), dealt club-wide by CoachedMornings.deal (6 sessional, 7 full-time). It pairs across days; a lone shared becomes solo.
- A FUNDED morning trains the ask's ability at WeekPlan's normal morning rate x CoachedMornings.mult; every unfunded morning runs exactly as the coach wrote it. Minutes, load, kcal and fatigue are unchanged, so the fatigue trace is identical across policies - a control.
- ALL SOLO asks the lowest of the six abilities; WEAK FIRST asks the WEAK SPOT (3+ under the mean) and falls back to shared once the hole closes. The hole is re-read every week.
- Then 10 even bouts a boxer through Bouts.fight_step (ask_probe2's loop), the same dice for every policy, at BoutRules.FRESH_FATIGUE (50) as ask_probe2's boxers are. The 12 weeks' fatigue trace is identical across policies (the sessions' load never changes), so that condition cannot bias the comparison. Best-of-seed is by wins out of 30; a tie splits the best credit.

## Table (per-seed averages over 40 seeds)

pts = all stat points the three boxers gained; weak = points on the ability weakest at the start; power = fight power gained; W/L = the 30-bout record; sess/wk = funded boxer-mornings a week; gain/morn = one funded morning's stat gain.

### SESSIONAL - 6 coached mornings a week

```
  policy      pts    weak   power    W     L    win%  best/100 outright  sess/wk  gain/morn
  ALL_SHARED  58.53   9.29   9.75 12.23 17.77  40.8      9.3        4    12.00     0.151
  ALL_SOLO    63.59  16.88  10.60 12.82 17.18  42.8     19.3        7     6.00     0.249
  WEAK_FIRST  63.59  16.36  10.60 12.50 17.50  41.7     11.3        0     7.08     0.234
```

Seeds tied on wins: 29 of 40. Joint best (a tie counted for each): ALL_SHARED 19, ALL_SOLO 36, WEAK_FIRST 27.

**SESSIONAL: ALL_SHARED 9.3, ALL_SOLO 19.3, WEAK_FIRST 11.3 -> NOT A REAL CHOICE: ALL_SHARED sits outside 12-28 of 40 seeds. Move SHARED (now x1.15) up, or SOLO (x1.25) down.**

### FULL_TIME - 7 coached mornings a week

```
  policy      pts    weak   power    W     L    win%  best/100 outright  sess/wk  gain/morn
  ALL_SHARED  58.87   9.38   9.81 12.28 17.73  40.9     10.7        6    13.00     0.150
  ALL_SOLO    64.32  17.68  10.72 12.85 17.15  42.8     19.7       11     7.00     0.241
  WEAK_FIRST  64.42  16.95  10.74 12.50 17.50  41.7      9.7        1     8.59     0.224
```

Seeds tied on wins: 22 of 40. Joint best (a tie counted for each): ALL_SHARED 19, ALL_SOLO 32, WEAK_FIRST 22.

**FULL_TIME: ALL_SHARED 10.7, ALL_SOLO 19.7, WEAK_FIRST 9.7 -> NOT A REAL CHOICE: WEAK_FIRST sits outside 12-28 of 40 seeds. Move SOLO_WEAK (now x1.40) up, or SHARED (x1.15) down.**

## Finding

- SESSIONAL: ALL SOLO gains MORE total points than ALL SHARED (63.59 vs 58.53) and more on the weakest ability (16.88 vs 9.29). The map's 'shared is the bigger total and solo is the focus' does NOT hold: headroom pays the hole 0.249 a morning against shared's 0.151, so 6 solo mornings a week out-gain 12 shared ones.
- FULL_TIME: ALL SOLO gains MORE total points than ALL SHARED (64.32 vs 58.87) and more on the weakest ability (17.68 vs 9.38). The map's 'shared is the bigger total and solo is the focus' does NOT hold: headroom pays the hole 0.241 a morning against shared's 0.150, so 7 solo mornings a week out-gain 13 shared ones.

## The trap

The morning gain is clamped by headroom (potential - stat, /25, 0.10-1.25): a weak spot far under potential gains more per morning anyway. gain/morn is that read - compare it against the shared row on the week's own abilities.

Reproduce: `python ops/Tools/godot_slot.py run --who morningsprobe1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --log-file E:/FightCamp/tmp/morningsprobe1.log --script res://tools/mornings_probe1.gd`

## S513 reading (Claude, main line) - 40 seeds, and a control at SHARED x1.35
The table above is the 40-seed rerun at the shipped multipliers (Qwen's PR ran 2 seeds). Then SHARED was set to x1.35 for
one 40-seed run (reverted; not shipped): shared's points rose 58.5 -> 61.9 (sessional) and 58.9 -> 62.2 (full time), but
its record did NOT move (40.8 % -> 40.8 %, 40.9 % -> 41.0 %; best on 9.3 -> 9.3 and 10.7 -> 9.8 of 40 seeds).
VERDICT: the multiplier is not the lever. Wins follow WHICH ability a morning trains - solo goes to the hole, shared trains
the coach's day ability for both - so no shared multiplier makes "solo vs shared" a real choice. A design change is needed
before this mechanic is wired: e.g. a shared pair trains the ability BOTH boxers are lowest in (or the pair's shared weak
spot), or shared mornings buy something solo cannot (pad turns / sparring readiness for both). Goes to the club-week map
(DESIGN_CLUBWEEK1) as a design-loop point; CoachedMornings stays unwired and SOLO/SHARED unchanged.
