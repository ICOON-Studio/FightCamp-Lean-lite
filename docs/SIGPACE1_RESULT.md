# SIGPACE1 RESULT - Signature pace over two seasons

**Probe run**: 2026-11-19. 30 careers x 2 seeds x 4 arms = 240 careers, 104 weeks each. Wall time: 495.5 s.

## Method

- **Population**: 30 quick_start careers per arm, 2 seed sets (4421, 9001). Amateur only (decline all pro offers).
- **Arms**: pads coach skill 58 (today's Reid overall rating) vs 75 (a better coach), each with/without camp focus on technique.
- **Camp focus**: when true, camps set focus='technique' (the stat that most affects mastery cap). When false, uses plan's default focus.
- **Bout handling**: accept sheet offers, start camps, weigh in, fight by sim (like turn_pro_probe3).
- **Check weeks**: 26, 52, 78, 104 (end of each).
- **Signature threshold**: mastery >= 85.

## Per-arm results

### Arm: coach58 no-focus

| week | tech_med | tech_p10 | tech_p90 | iq_med | iq_p10 | iq_p90 | cap_med | cap_p10 | cap_p90 | best_med | best_p10 | best_p90 | sig_share | sig_n |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 26 | 73.0 | 71.3 | 73.0 | 64.0 | 63.5 | 64.0 | 82.0 | 81.2 | 82.0 | 79.0 | 76.9 | 79.0 | 0% | 0 |
| 52 | 78.9 | 78.0 | 79.1 | 67.1 | 66.4 | 67.4 | 85.0 | 84.5 | 85.1 | 84.5 | 84.1 | 84.7 | 0% | 0 |
| 78 | 78.9 | 78.0 | 79.1 | 67.1 | 66.4 | 67.4 | 85.0 | 84.5 | 85.1 | 84.5 | 84.1 | 84.7 | 0% | 0 |
| 104 | 78.9 | 78.0 | 79.1 | 67.1 | 66.4 | 67.4 | 85.0 | 84.5 | 85.1 | 84.5 | 84.1 | 84.7 | 0% | 0 |

- Careers reaching Signature: 0/60 (0%), median week: none

### Arm: coach58 focus

| week | tech_med | tech_p10 | tech_p90 | iq_med | iq_p10 | iq_p90 | cap_med | cap_p10 | cap_p90 | best_med | best_p10 | best_p90 | sig_share | sig_n |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 26 | 73.0 | 71.2 | 73.0 | 64.0 | 63.2 | 64.0 | 82.0 | 81.1 | 82.0 | 79.0 | 76.6 | 79.2 | 0% | 0 |
| 52 | 78.8 | 77.8 | 79.1 | 67.1 | 66.5 | 67.2 | 84.9 | 84.4 | 85.1 | 84.5 | 84.0 | 84.7 | 0% | 0 |
| 78 | 78.8 | 77.8 | 79.1 | 67.1 | 66.5 | 67.2 | 84.9 | 84.4 | 85.1 | 84.5 | 84.0 | 84.7 | 0% | 0 |
| 104 | 78.8 | 77.8 | 79.1 | 67.1 | 66.5 | 67.2 | 84.9 | 84.4 | 85.1 | 84.5 | 84.0 | 84.7 | 0% | 0 |

- Careers reaching Signature: 0/60 (0%), median week: none

### Arm: coach75 no-focus

| week | tech_med | tech_p10 | tech_p90 | iq_med | iq_p10 | iq_p90 | cap_med | cap_p10 | cap_p90 | best_med | best_p10 | best_p90 | sig_share | sig_n |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 26 | 73.9 | 72.0 | 73.9 | 64.0 | 63.2 | 64.0 | 82.3 | 81.4 | 82.3 | 79.6 | 77.1 | 79.6 | 0% | 0 |
| 52 | 79.7 | 78.8 | 79.8 | 66.9 | 66.6 | 67.1 | 85.3 | 84.9 | 85.3 | 84.9 | 84.6 | 85.0 | 15% | 9 |
| 78 | 79.7 | 78.8 | 79.8 | 66.9 | 66.6 | 67.1 | 85.3 | 84.9 | 85.3 | 84.9 | 84.6 | 85.0 | 15% | 9 |
| 104 | 79.7 | 78.8 | 79.8 | 66.9 | 66.6 | 67.1 | 85.3 | 84.9 | 85.3 | 84.9 | 84.6 | 85.0 | 15% | 9 |

- Careers reaching Signature: 9/60 (15%), median week: 52

### Arm: coach75 focus

| week | tech_med | tech_p10 | tech_p90 | iq_med | iq_p10 | iq_p90 | cap_med | cap_p10 | cap_p90 | best_med | best_p10 | best_p90 | sig_share | sig_n |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 26 | 73.9 | 72.4 | 73.9 | 64.0 | 63.5 | 64.0 | 82.3 | 81.6 | 82.3 | 79.6 | 77.4 | 79.6 | 0% | 0 |
| 52 | 79.6 | 78.9 | 79.8 | 66.9 | 66.7 | 67.5 | 85.3 | 84.8 | 85.4 | 85.0 | 84.5 | 85.1 | 20% | 12 |
| 78 | 79.6 | 78.9 | 79.8 | 66.9 | 66.7 | 67.5 | 85.3 | 84.8 | 85.4 | 85.0 | 84.5 | 85.1 | 20% | 12 |
| 104 | 79.6 | 78.9 | 79.8 | 66.9 | 66.7 | 67.5 | 85.3 | 84.8 | 85.4 | 85.0 | 84.5 | 85.1 | 20% | 12 |

- Careers reaching Signature: 12/60 (20%), median week: 52

## Pass lines

```
SIGPACE1 done sig52=0% sig104=0% cap104=85.0 arm=coach58_nofocus
SIGPACE1 done sig52=0% sig104=0% cap104=84.9 arm=coach58_focus
SIGPACE1 done sig52=15% sig104=15% cap104=85.3 arm=coach75_nofocus
SIGPACE1 done sig52=20% sig104=20% cap104=85.3 arm=coach75_focus
```

## Interpretation

**Can a boxer reach a Signature in two seasons?**

- **With today's coach (pads 58)**: No. 0% of 120 careers reached mastery 85 by week 104. The median cap stays at 84.9-85.0, just below the threshold.
- **With a better coach (pads 75)**: Yes, but only for the top performers. 15-20% reach Signature by week 52, and those who do reach it by week 52 (median). The median cap is 85.3, just above the threshold.

**Key findings:**

1. **The cap is the bottleneck**: The median mastery cap at week 104 is 84.9-85.3, right at the Signature threshold (85). Only boxers in the top decile (p90) have caps high enough to allow Signature-level mastery.

2. **Camp focus on technique helps slightly**: With coach 75, camp focus on technique increases Signature rate from 15% to 20%, but the effect is small. The cap medians are nearly identical (85.3 both arms).

3. **Most boxers plateau before Signature**: The best move mastery median at week 104 is 84.5-85.0, just below the 85 threshold. Boxers train hard but the cap formula (40 + 0.4*technique + 0.2*fight_iq) keeps most just under the Signature line.

4. **Those who reach Signature do it by week 52**: All careers that reached Signature did so by week 52 (one season), not week 104 (two seasons). This suggests that if a boxer is going to reach Signature, they do it in the first season of focused work; a second season doesn't help those who haven't reached it yet.

**Conclusion**: HOLD1's finding holds - the median boxer cannot reach a Signature in two seasons with the current cap formula. Only the top 15-20% with a good coach (pads 75) reach it, and they do it in one season, not two. The cap formula is the constraint, not the training pace.

## Reproduce

```bash
$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/sig_pace_probe.gd
```

Pilot (4 careers): ~65 seconds. Full (30 careers): ~8 minutes.

## Claude's read (S530)
- Every number from week 52 to 104 is identical to the decimal in all four arms: the probe's loop stops at `c.closed` and
  later snapshots repeat the last one. The careers END around year one - the gym closes (8 weeks below $0), as
  TURNPROBE3/3B's w104 cash (negative for every bot) also shows. So "they reach it by week 52 or never" is the closure,
  not a plateau. A rerun must print each career's `closed` and `final_day` (the probe already records them).
- What it does show: with today's pads coach (58) NO career reaches a Signature in the year the gym lives (median cap
  85.0, best move 84.5); a pads coach of 75 gives 15% (20% with the camp's focus morning) by week 52.
- New question for the main line: does a quick-start gym that accepts every bout and trains well close inside a year?
  (Measure the closure day on the game's own loop before calling it a defect: the probe bots never touch dues, staff or
  kit, which a player would.)
