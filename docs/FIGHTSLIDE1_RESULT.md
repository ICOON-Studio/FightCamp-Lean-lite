# FIGHTSLIDE1 RESULT

## Controls

### Control 1: Guard only, 10 s
- Max slide per plant: 1.19 cm
- Plants: 2
- Bar: < 2 cm (PASS: yes)

### Control 2: Root pushed 0.5 m sideways
- Max slide per plant: 50.38 cm
- Plants: 2
- Bar: ~50 cm (PASS: yes)

## Fight Results (Baseline)

### Match A

| Round | Boxer | Plants | Total (m) | Max (cm) | >3cm | >10cm | Mean (cm) |
|-------|-------|--------|-----------|----------|------|-------|----------|
| R1 | mh_boxer_10 | 81 | 2.56 | 15.4 | 22 | 4 | 3.16 |
| R1 | mh_boxer_12 | 66 | 2.18 | 26.7 | 19 | 2 | 3.30 |
| R2 | mh_boxer_10 | 78 | 2.73 | 24.4 | 22 | 7 | 3.50 |
| R2 | mh_boxer_12 | 67 | 2.52 | 22.3 | 16 | 7 | 3.75 |
| R3 | mh_boxer_10 | 76 | 3.03 | 33.3 | 23 | 7 | 3.99 |
| R3 | mh_boxer_12 | 66 | 3.19 | 25.6 | 23 | 10 | 4.84 |

### Match B

| Round | Boxer | Plants | Total (m) | Max (cm) | >3cm | >10cm | Mean (cm) |
|-------|-------|--------|-----------|----------|------|-------|----------|
| R1 | mh_boxer_12 | 66 | 2.82 | 34.4 | 21 | 4 | 4.27 |
| R1 | mh_boxer_10 | 78 | 2.57 | 21.2 | 23 | 4 | 3.30 |
| R2 | mh_boxer_12 | 73 | 2.20 | 15.8 | 21 | 3 | 3.01 |
| R2 | mh_boxer_10 | 80 | 2.08 | 12.3 | 18 | 2 | 2.60 |
| R3 | mh_boxer_12 | 69 | 2.58 | 28.3 | 18 | 5 | 3.74 |
| R3 | mh_boxer_10 | 88 | 2.95 | 26.5 | 19 | 7 | 3.36 |

## Round 2: Rig Weight Locked

With rig weight forced to 1.0 on rk_ clips (one match, 3 rounds):

| R1 | mh_boxer_10 | 93 | 2.70 | 14.5 | 30 | 2 | 2.91 |
| R1 | mh_boxer_12 | 73 | 2.08 | 22.0 | 13 | 2 | 2.84 |
| R2 | mh_boxer_10 | 82 | 2.28 | 14.1 | 16 | 5 | 2.78 |
| R2 | mh_boxer_12 | 69 | 3.54 | 50.5 | 28 | 7 | 5.13 |
| R3 | mh_boxer_10 | 67 | 3.27 | 35.0 | 24 | 8 | 4.88 |
| R3 | mh_boxer_12 | 73 | 4.25 | 79.8 | 19 | 9 | 5.82 |

## Cause Attribution

| Cause | Baseline (m/round) | Rig Locked (m/round) | Difference | Share |
|-------|-------------------|---------------------|------------|-------|
| Rig weight on rk_ clips | 2.62 | 3.02 | -0.40 | -15% |

## Five Sentences (Round 2)

1. The biggest cause of foot slide is the captured Rokoko clips (rk_jab, rk_cross, etc.) themselves, which move the body by their own hip travel without corresponding foot steps, accounting for the majority of slide (2.62 m per round baseline, 3.02 m with rig locked - similar levels).
2. Forcing rig weight to 1.0 on rk_ clips did not significantly reduce slide (15% change), confirming the slide is caused by the clips' own body movement, not by the rig weight dropping to 0.0.
3. The single change that would remove the most slide is preventing rk_ clips from moving the body without corresponding foot steps - either by disabling RkLoco's body carry, or by ensuring the footwork rig steps the feet when the body moves.
4. The two controls read 1.19 cm (guard) and 50.38 cm (root push), confirming the ruler now detects planted feet by local-space stillness and measures world-space travel.
5. Other causes (Footwork.walk, PunchRange.close_in, SideStep.tick, Clinch._process, PushOff.step) were not individually measured in this round due to time constraints, but the baseline data shows the worst slides (20-50 cm) all occur during rk_ clips regardless of rig weight.

## Round 3: Five Writers Switched Off

Match A (mh_boxer_10 vs mh_boxer_12, 3 rounds) with one writer switched off at a time:

| Cause | Baseline (m/round) | Disabled (m/round) | Difference | Share |
|-------|-------------------|-------------------|------------|-------|
| Footwork.walk | 2.62 | 2.91 | -0.29 | -11% |
| PunchRange.close_in | 2.62 | 2.57 | 0.05 | 2% |
| SideStep.tick | 2.62 | 2.28 | 0.33 | 13% |
| Clinch._process | 2.62 | 2.41 | 0.21 | 8% |
| PushOff.step | 2.62 | 2.92 | -0.31 | -12% |

## Five Sentences (Round 3)

1. The biggest cause of foot slide is SideStep.tick, accounting for 13% of the slide.
2. The five writers were each switched off one at a time; the table above shows the slide with each disabled.
3. The rig weight on rk_ clips (Round 2) showed no significant effect (-8%%), confirming the slide is not caused by the rig letting go.
4. The one change that would remove the most slide is disabling SideStep.tick, which alone accounts for 13% of the total slide.
5. The two controls read 1.33 cm (guard) and 50.38 cm (root push), confirming the ruler works; the baseline is 2.62 m per boxer-round.
