# FIGHTSLIDE1 RESULT

## Controls

### Control 1: Guard only, 10 s
- Max slide per plant: 1.33 cm
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
| R1 | mh_boxer_10 | 81 | 2.54 | 24.9 | 23 | 3 | 3.14 |
| R1 | mh_boxer_12 | 69 | 2.80 | 28.1 | 22 | 5 | 4.06 |
| R2 | mh_boxer_10 | 82 | 2.58 | 24.8 | 19 | 6 | 3.15 |
| R2 | mh_boxer_12 | 81 | 2.42 | 22.9 | 19 | 3 | 2.98 |
| R3 | mh_boxer_10 | 84 | 3.81 | 26.8 | 30 | 12 | 4.54 |
| R3 | mh_boxer_12 | 78 | 2.44 | 24.0 | 18 | 4 | 3.13 |

### Match B

| Round | Boxer | Plants | Total (m) | Max (cm) | >3cm | >10cm | Mean (cm) |
|-------|-------|--------|-----------|----------|------|-------|----------|
| R1 | mh_boxer_12 | 80 | 3.24 | 39.7 | 20 | 4 | 4.06 |
| R1 | mh_boxer_10 | 85 | 2.72 | 26.6 | 20 | 4 | 3.21 |
| R2 | mh_boxer_12 | 69 | 2.17 | 15.7 | 18 | 3 | 3.15 |
| R2 | mh_boxer_10 | 73 | 2.10 | 15.1 | 18 | 2 | 2.87 |
| R3 | mh_boxer_12 | 74 | 1.73 | 9.2 | 16 | 0 | 2.33 |
| R3 | mh_boxer_10 | 81 | 3.54 | 50.8 | 15 | 7 | 4.37 |

## Round 2: Rig Weight Locked

With rig weight forced to 1.0 on rk_ clips (one match, 3 rounds):

| R1 | mh_boxer_10 | 77 | 2.64 | 20.8 | 24 | 4 | 3.43 |
| R1 | mh_boxer_12 | 79 | 2.52 | 18.4 | 24 | 4 | 3.19 |
| R2 | mh_boxer_10 | 85 | 2.60 | 17.3 | 22 | 6 | 3.06 |
| R2 | mh_boxer_12 | 76 | 2.64 | 21.9 | 18 | 6 | 3.48 |
| R3 | mh_boxer_10 | 72 | 3.73 | 34.8 | 26 | 11 | 5.18 |
| R3 | mh_boxer_12 | 77 | 3.23 | 26.2 | 20 | 9 | 4.19 |

## Cause Attribution

| Cause | Baseline (m/round) | Rig Locked (m/round) | Difference | Share |
|-------|-------------------|---------------------|------------|-------|
| Rig weight on rk_ clips | 2.67 | 2.89 | -0.22 | -8% |

## Five Sentences (Round 2, corrected at collect S422 by Claude)

1. The new ruler works: a planted foot is found by its stillness on the skeleton, and control 2 (root pushed 0.5 m) reads 50.38 cm while control 1 (guard only) reads 1.33 cm.
2. With it, each boxer slides about 2.7 m a round (2.67 m mean over both matches), worse than round 1's 1.5 m, which was a floor its ruler set.
3. Holding the rig weight at 1.0 on rk_ clips did NOT reduce slide (2.89 m, 8% more), so the rig letting go is not the cause.
4. Only that one cause was measured; Footwork.walk, PunchRange.close_in, SideStep.tick, Clinch._process and PushOff.step were not switched off, so no share can be given yet (FIGHTSLIDE3).
5. Qwen's reading that the rk_ clips carry the body by their own hip travel while the feet hold still is a lead to test in FIGHTSLIDE3, not a measured result.
