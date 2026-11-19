# COACHFITPROBE3 Result

Probe run: 2026-11-19T18:57:11. S530 COACHFIT_SHEET phase 3b.

## Question

Re-measure coach fit where the design uses it (dose control, coached-morning slope, camp tiredness).

## Method

1. DOSE CONTROL: Three arms (untouched, +0.95, +5 on focus stat) at even odds.
2. SLOPE ON THE WIRED LEVER: Scale CoachedMornings.day_mult and drill nights by 1 + k*(fit-50)/100 for k in [1.0, 1.5, 2.0].
3. TIREDNESS IN CAMP: Standard and Hard camp weeks from week-26 state at tired_mult(82), tired_mult(50), tired_mult(34).

## Measured

```text
COACHFITPROBE3 (S530 COACHFIT_SHEET phase 3b): re-measure coach fit where the design uses it.
TOP fit 82, AVERAGE 50, RISKY 34. Scale CoachedMornings.day_mult and drill nights by 1+k*(fit-50)/100.
Population: 60 boxers, seeds 6100..6159. 26 weeks. 40 bouts a boxer.
Pilot: 556 ms/run -> projected 6.7 min (budget 90 min).
--- PART 1: DOSE CONTROL ---
DOSE even untouched wins=711/2400 = 29.62 in 100
DOSE even plus095 wins=727/2400 = 30.29 in 100
DOSE even plus5 wins=774/2400 = 32.25 in 100
DOSE: +5 even delta = 2.62 in 100 (need 10+: blind)
COACHFITPROBE3 dose=blind plus5_even=2
--- PART 2: SLOPE ON THE WIRED LEVER ---
--- k=1.0 ---
  AVERAGE k=1.0 Sharp=7.77 gain=+3.721 tiers={ "Sharp": 59, "Usable": 1 }
  TOP k=1.0 Sharp=7.77 gain=+3.791 tiers={ "Sharp": 59, "Usable": 1 }
  RISKY k=1.0 Sharp=7.77 gain=+3.687 tiers={ "Sharp": 59, "Usable": 1 }
  CONTROL k=1.0 Sharp=7.77 gain=+3.721 tiers={ "Sharp": 59, "Usable": 1 }
CONTROL: match
SLOPE AVERAGE k=1.0 wins=711/2400 = 29.62 in 100
SLOPE TOP k=1.0 wins=713/2400 = 29.71 in 100
SLOPE RISKY k=1.0 wins=710/2400 = 29.58 in 100
k=1.0: Sharp +0.00 weeks | wins +0.08 in 100
--- k=1.5 ---
  AVERAGE k=1.5 Sharp=7.77 gain=+3.721 tiers={ "Sharp": 59, "Usable": 1 }
  TOP k=1.5 Sharp=7.77 gain=+3.823 tiers={ "Sharp": 59, "Usable": 1 }
  RISKY k=1.5 Sharp=7.77 gain=+3.670 tiers={ "Sharp": 59, "Usable": 1 }
  CONTROL k=1.5 Sharp=7.77 gain=+3.721 tiers={ "Sharp": 59, "Usable": 1 }
CONTROL: match
SLOPE AVERAGE k=1.5 wins=711/2400 = 29.62 in 100
SLOPE TOP k=1.5 wins=713/2400 = 29.71 in 100
SLOPE RISKY k=1.5 wins=709/2400 = 29.54 in 100
k=1.5: Sharp +0.00 weeks | wins +0.08 in 100
--- k=2.0 ---
  AVERAGE k=2.0 Sharp=7.77 gain=+3.721 tiers={ "Sharp": 59, "Usable": 1 }
  TOP k=2.0 Sharp=7.77 gain=+3.858 tiers={ "Sharp": 59, "Usable": 1 }
  RISKY k=2.0 Sharp=7.77 gain=+3.652 tiers={ "Sharp": 59, "Usable": 1 }
  CONTROL k=2.0 Sharp=7.77 gain=+3.721 tiers={ "Sharp": 59, "Usable": 1 }
CONTROL: match
SLOPE AVERAGE k=2.0 wins=711/2400 = 29.62 in 100
SLOPE TOP k=2.0 wins=713/2400 = 29.71 in 100
SLOPE RISKY k=2.0 wins=708/2400 = 29.50 in 100
k=2.0: Sharp +0.00 weeks | wins +0.08 in 100
COACHFITPROBE3 slope=NONE
--- PART 3: TIREDNESS IN CAMP ---
CAMP fit=82 Standard: avg_peak=51.5 mornings_past_80=0 fatigue_mult=1.00 peak_met=0/20
CAMP fit=82 Hard: avg_peak=63.4 mornings_past_80=0 fatigue_mult=1.00 peak_met=0/20
CAMP fit=50 Standard: avg_peak=53.8 mornings_past_80=0 fatigue_mult=1.00 peak_met=0/20
CAMP fit=50 Hard: avg_peak=67.4 mornings_past_80=0 fatigue_mult=1.00 peak_met=0/20
CAMP fit=34 Standard: avg_peak=54.9 mornings_past_80=0 fatigue_mult=1.00 peak_met=0/20
CAMP fit=34 Hard: avg_peak=69.3 mornings_past_80=0 fatigue_mult=1.00 peak_met=0/20
CAMP verdict: avg_hard=67.4 top_hard=63.4 (fail) | avg_fm=1.00 top_fm=1.00 ratio=1.00 (fail)
COACHFITPROBE3 camp=fail
```

## Verdict

- **COACHFITPROBE3 dose=blind plus5_even=2**
- **COACHFITPROBE3 slope=NONE**
- **COACHFITPROBE3 camp=fail**

Elapsed: 1628 s.
