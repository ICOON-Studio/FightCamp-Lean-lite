# TURNGAP1 RESULT - the debut's opponent gap -> win chance curve

Probe run: 2026-11-19T21:12:09. 20 boxers x 8 gaps x 10 seeds. Wall time: 373.0 s.

## Population
- 20 boxers built from Career.quick_start() played forward to the moment of their first pro offer
- Each boxer's career is deep-copied once per gap; the gap is set on the offer terms WHERE THE DEAL READS IT (ProOfferWire.signed duplicates it into the deal)
- 10 day-offsets per boxer per gap (BoutNight seeds its RNG from c.day)
- Gaps: -4, -2, -1, 0, 1, 2, 4, 8 (negative = stronger opponent, positive = weaker)

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

Override confirmed: the gap flows through to the opponent rating at Roster.gd line 306.

## Per-gap win share (all boxers)

| gap | wins | total | win_share |
|---|---|---|---|
| -4.0 | 70 | 200 | 35.0% |
| -2.0 | 60 | 200 | 30.0% |
| -1.0 | 140 | 200 | 70.0% |
| 0.0 | 160 | 200 | 80.0% |
| 1.0 | 160 | 200 | 80.0% |
| 2.0 | 150 | 200 | 75.0% |
| 4.0 | 150 | 200 | 75.0% |
| 8.0 | 190 | 200 | 95.0% |

## Per-boxer win share median [p10..p90]

| gap | median | p10 | p90 |
|---|---|---|---|
| -4.0 | 0.0% | 0.0% | 100.0% |
| -2.0 | 0.0% | 0.0% | 100.0% |
| -1.0 | 100.0% | 0.0% | 100.0% |
| 0.0 | 100.0% | 0.0% | 100.0% |
| 1.0 | 100.0% | 0.0% | 100.0% |
| 2.0 | 100.0% | 0.0% | 100.0% |
| 4.0 | 100.0% | 0.0% | 100.0% |
| 8.0 | 100.0% | 100.0% | 100.0% |

High per-boxer variance: the day-offset seed moves individual outcomes a lot, but the aggregate is stable.

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

BoutRead.likely underestimates the actual win rate at every gap. The coach's single-read (at the middle of the rating range) is lower than what the sim delivers. The band covers the truth at most gaps.

## Gap targets

- Gap for 65-80% win share: -1.0 (70% actual)
- Gap for 70-85% win share: 0.0 (80% actual)

## Interpretation

The current default gap (1.0 for Bow Lane, 1.5 for Harrow & Finch) gives ~80% and ~75% win rates respectively. The target of 65-80% is reached at gap -1.0 (opponent 1 point stronger than the boxer). The v5 change from 1.0 to 1.6 moved in the wrong direction (weaker opponent, easier debut).

Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/turn_gap_probe.gd`

TURNGAP1 done
