# TURNGAP1 RESULT - the debut's opponent gap -> win chance curve

Probe run: 2026-11-20T01:02:16. 20 boxers x 8 gaps x 10 seeds. Wall time: 823.5 s.

## Override proof (one boxer, each gap)

| gap | night | deal_gap | opp_rating | expected_opp_rating | ok |
|---|---|---|---|---|---|
| -4.0 | 65.9 | -4.0 | 69.9 | 69.9 | YES |
| -2.0 | 65.9 | -2.0 | 67.9 | 67.9 | YES |
| -1.0 | 65.9 | -1.0 | 66.9 | 66.9 | YES |
| 0.0 | 65.9 | 0.0 | 65.9 | 65.9 | YES |
| 1.0 | 65.9 | 1.0 | 64.9 | 64.9 | YES |
| 2.0 | 65.9 | 2.0 | 63.9 | 63.9 | YES |
| 4.0 | 65.9 | 4.0 | 61.9 | 61.9 | YES |
| 8.0 | 65.9 | 8.0 | 57.9 | 57.9 | YES |

## Per-gap win share (all boxers)

| gap | wins | total | win_share |
|---|---|---|---|
| -4.0 | 71 | 200 | 35.5% |
| -2.0 | 82 | 200 | 41.0% |
| -1.0 | 134 | 200 | 67.0% |
| 0.0 | 157 | 200 | 78.5% |
| 1.0 | 158 | 200 | 79.0% |
| 2.0 | 158 | 200 | 79.0% |
| 4.0 | 167 | 200 | 83.5% |
| 8.0 | 193 | 200 | 96.5% |

## Per-boxer win share median [p10..p90]

| gap | median | p10 | p90 |
|---|---|---|---|
| -4.0 | 40.0% | 19.0% | 40.0% |
| -2.0 | 40.0% | 39.0% | 50.0% |
| -1.0 | 80.0% | 29.0% | 80.0% |
| 0.0 | 90.0% | 29.0% | 90.0% |
| 1.0 | 90.0% | 29.0% | 90.0% |
| 2.0 | 90.0% | 29.0% | 90.0% |
| 4.0 | 90.0% | 75.0% | 90.0% |
| 8.0 | 100.0% | 100.0% | 100.0% |

## BoutRead at signing (what the offer would say)

| gap | likely | band_lo | band_hi |
|---|---|---|---|
| -4.0 | 31.8% | 2.5% | 71.8% |
| -2.0 | 40.2% | 6.2% | 78.3% |
| -1.0 | 45.3% | 8.6% | 81.8% |
| 0.0 | 50.5% | 11.4% | 85.1% |
| 1.0 | 55.2% | 14.5% | 88.0% |
| 2.0 | 59.6% | 18.0% | 90.6% |
| 4.0 | 67.6% | 25.8% | 94.9% |
| 8.0 | 80.5% | 44.8% | 99.0% |

## Gap targets

- Gap for 65-80% win share: -1.0
- Gap for 70-85% win share: 0.0

Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/turn_gap_probe.gd`

TURNGAP1 done
