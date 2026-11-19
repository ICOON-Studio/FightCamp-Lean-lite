# COACHFITPROBE2 Result

Probe run: 2026-11-19T17:26:24. S529 COACHFIT_SHEET phase 2.

## Question

Can a coach fit be felt inside the cap?

## Method

- SLOPE: `1.0 + k * (fit - 50) / 100.0` for k in [1.0, 1.5, 2.0, 3.0], through `CoachFit.capped()`.
- TIREDNESS: camp week at tired_mult(80) vs tired_mult(35), then 4-round bout.

## Measured

```text
COACHFITPROBE2 (S529 COACHFIT_SHEET phase 2): can a coach fit be felt inside the cap?
TOP fit 82: CoachFit.gain_mult(82)=1.320 (must equal 1.32: yes). Probe gain at fit 82 for k in [1.0, 1.5, 2.0, 3.0]: [1.32, 1.48, 1.64, 1.96].
fit 50: gain_mult=1.000 tired_mult=1.000 (both must be 1.000: yes). tired_mult(80)=0.925 tired_mult(35)=1.038.
Population: 60 boxers, seeds 6100..6159. Part 1: 26 weeks. Part 2: 40 bouts a boxer per arm.
Pilot: 294 ms/run, 48.2 ms/bout -> projected 19.0 min (budget 90 min).
--- k=1.0 ---
CONTROL determinism: match
  AVERAGE k=1.0 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
  TOP k=1.0 Sharp=6.23 gain=+4.483 eve+=40.53 capped=0
  CONTROL k=1.0 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
CONTROL: match
TRAINBALANCE AVERAGE wins=724/2400 = 30.17 in 100
TRAINBALANCE TOP wins=726/2400 = 30.25 in 100
k=1.0: Sharp +1.53 weeks (OUT) | wins +0.08 in 100 (OUT)
--- k=1.5 ---
CONTROL determinism: match
  AVERAGE k=1.5 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
  TOP k=1.5 Sharp=6.12 gain=+4.932 eve+=56.88 capped=0
  CONTROL k=1.5 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
CONTROL: match
TRAINBALANCE AVERAGE wins=724/2400 = 30.17 in 100
TRAINBALANCE TOP wins=751/2400 = 31.29 in 100
k=1.5: Sharp +1.65 weeks (OUT) | wins +1.12 in 100 (OUT)
--- k=2.0 ---
CONTROL determinism: match
  AVERAGE k=2.0 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
  TOP k=2.0 Sharp=3.00 gain=+5.257 eve+=48.98 capped=2682
  CONTROL k=2.0 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
CONTROL: match
TRAINBALANCE AVERAGE wins=724/2400 = 30.17 in 100
TRAINBALANCE TOP wins=768/2400 = 32.00 in 100
k=2.0: Sharp +4.77 weeks (OUT) | wins +1.83 in 100 (OUT)
--- k=3.0 ---
CONTROL determinism: match
  AVERAGE k=3.0 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
  TOP k=3.0 Sharp=3.00 gain=+5.257 eve+=48.98 capped=2682
  CONTROL k=3.0 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
CONTROL: match
TRAINBALANCE AVERAGE wins=724/2400 = 30.17 in 100
TRAINBALANCE TOP wins=768/2400 = 32.00 in 100
k=3.0: Sharp +4.77 weeks (OUT) | wins +1.83 in 100 (OUT)
COACHFITPROBE2 slope=NONE
--- TIREDNESS ---
  boxer 0: fat_start=40.2 | fit80 fat_end=68.6 last_bell=68.2 r3=68.2 | fit35 fat_end=70.4 last_bell=64.6 r3=64.6 | ahead=3.6 r3_down=3.6
  boxer 1: fat_start=41.1 | fit80 fat_end=67.7 last_bell=69.9 r3=69.9 | fit35 fat_end=70.2 last_bell=64.8 r3=64.8 | ahead=5.1 r3_down=5.1
  boxer 2: fat_start=44.3 | fit80 fat_end=65.1 last_bell=74.7 r3=74.7 | fit35 fat_end=69.9 last_bell=65.2 r3=65.2 | ahead=9.5 r3_down=9.5
TIREDNESS n=20: ahead=6.6 (8..12: OUT) r3_down=6.6 (15..20: OUT)
COACHFITPROBE2 tired=fail ahead=6.6 r3_down=6.6
```

## Verdict

- **COACHFITPROBE2 slope=NONE**
- **COACHFITPROBE2 tired=fail ahead=6.6 r3_down=6.6**

Elapsed: 953 s.
