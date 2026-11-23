# REPEATBITE1 - make repeated combos bite (S539)

Owner Q-S294-306, asked "Repeated-combo penalty fires 3 times in 600 bouts. Make repeats cost more?": "Yes, make it bite".

## Bars (written before the run, not loosened)
(a) SPAM loses 5+ wins in 100 against the counter-puncher and 2+ overall (rule ON v OFF, same bouts);
(b) with the rule ON, a plan with a main weapon (WEAPON) still beats the even spread (SPREAD) against at least two styles;
(c) every (a) effect larger than 2 standard errors;
(d) the read FIRES (a throw into a read, where the live "they have your X now" line would show) in 25 to 60 bouts of 100 for
    SPAM and under 15 for SPREAD;
(e) no variant makes one plan shape the best (ON) against all six styles.

Numbers fixed before the run (tools/repeatbite1_rules.gd): counter chance 0.35 a throw into a read, counter-puncher x1.75,
ring-smart opponent (rating 65+) reads one throw sooner, a counter = the exchange lost (margin -10 or lower). Every throw counts
(plan line or instinct). A = count per round; B = count carries, fades 1 at each bell (the sim has no corner "change it up"
call, so nothing clears it); C = B + night k's opponent filmed night k-1 and starts with that bout's most-thrown move half-read.

Rule copy tools/repeatbite1_rules.gd: counter chance 0.35 a throw into a read (counter-puncher x1.75), ring-smart opponent (rating 65+) reads one throw sooner, a counter = the exchange lost (margin -10 or lower). 60 boxers x 6 opponents x 3 nights = 1080 bouts a plan, played once, every variant on the same bouts.

## A2 - THE COUNTER (count per round), read at 2 throws, one sooner v a ring-smart opponent

| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | bouts the read fires (of 100) | throws into a read a bout | counters a bout |
|---|---|---|---|---|---|---|---|---|---|
| SPAM | Pressure fighter | 180 | 27.2% | 23.9% | -3.3 | 2.7 | 93 | 2.77 | 1.01 |
| SPAM | Counter-puncher | 180 | 20.0% | 13.3% | -6.7 | 3.7 | 99 | 3.67 | 2.18 |
| SPAM | Volume puncher | 180 | 9.4% | 7.2% | -2.2 | 2.2 | 100 | 7.35 | 2.44 |
| SPAM | Boxer-puncher | 180 | 17.8% | 16.1% | -1.7 | 1.9 | 98 | 2.74 | 1.04 |
| SPAM | Out-boxer | 180 | 46.1% | 38.3% | -7.8 | 4.0 | 98 | 4.03 | 1.46 |
| SPAM | Slugger | 180 | 70.6% | 68.9% | -1.7 | 1.9 | 93 | 2.97 | 1.03 |
| SPAM | ALL SIX | 1080 | 31.9% | 28.0% | -3.9 | 1.2 | 97 | 3.92 | 1.53 |
| WEAPON | Pressure fighter | 180 | 40.0% | 36.7% | -3.3 | 2.7 | 93 | 2.98 | 1.05 |
| WEAPON | Counter-puncher | 180 | 26.1% | 17.8% | -8.3 | 4.1 | 98 | 3.76 | 2.26 |
| WEAPON | Volume puncher | 180 | 18.3% | 12.2% | -6.1 | 3.6 | 100 | 7.25 | 2.44 |
| WEAPON | Boxer-puncher | 180 | 20.6% | 17.8% | -2.8 | 2.4 | 96 | 2.93 | 1.06 |
| WEAPON | Out-boxer | 180 | 50.0% | 40.6% | -9.4 | 4.4 | 99 | 4.20 | 1.53 |
| WEAPON | Slugger | 180 | 76.7% | 76.1% | -0.6 | 1.1 | 94 | 3.33 | 1.17 |
| WEAPON | ALL SIX | 1080 | 38.6% | 33.5% | -5.1 | 1.3 | 97 | 4.07 | 1.58 |
| SPREAD | Pressure fighter | 180 | 26.1% | 23.3% | -2.8 | 2.4 | 91 | 2.57 | 0.89 |
| SPREAD | Counter-puncher | 180 | 21.1% | 17.2% | -3.9 | 2.9 | 87 | 1.89 | 1.15 |
| SPREAD | Volume puncher | 180 | 12.8% | 9.4% | -3.3 | 2.7 | 100 | 6.02 | 2.02 |
| SPREAD | Boxer-puncher | 180 | 18.9% | 18.9% | +0.0 | 0.0 | 82 | 1.55 | 0.58 |
| SPREAD | Out-boxer | 180 | 48.3% | 44.4% | -3.9 | 2.9 | 86 | 2.03 | 0.71 |
| SPREAD | Slugger | 180 | 65.0% | 62.8% | -2.2 | 2.2 | 88 | 2.28 | 0.73 |
| SPREAD | ALL SIX | 1080 | 32.0% | 29.4% | -2.7 | 1.0 | 89 | 2.73 | 1.01 |

- (a) SPAM v the counter-puncher -6.7, overall -3.9 -> PASS
- (b) WEAPON beats SPREAD (ON) against: Pressure fighter +13.3, Counter-puncher +0.6, Volume puncher +2.8, Slugger +13.3 -> PASS
- (c) effects v 2 errors: counter-puncher 6.7 v 3.7, overall 3.9 v 1.2 -> PASS
- (d) the read fires in 97 bouts of 100 for SPAM (25-60), 89 for SPREAD (under 15) -> FAIL
- (e) the best plan (ON) by style: { "Pressure fighter": "WEAPON", "Counter-puncher": "WEAPON", "Volume puncher": "WEAPON", "Boxer-puncher": "SPREAD", "Out-boxer": "SPREAD", "Slugger": "WEAPON" } -> PASS

A2 VERDICT: FAIL

## A3 - THE COUNTER (count per round), read at 3 throws, one sooner v a ring-smart opponent

| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | bouts the read fires (of 100) | throws into a read a bout | counters a bout |
|---|---|---|---|---|---|---|---|---|---|
| SPAM | Pressure fighter | 180 | 27.2% | 26.7% | -0.6 | 1.1 | 54 | 0.94 | 0.34 |
| SPAM | Counter-puncher | 180 | 20.0% | 17.8% | -2.2 | 2.2 | 68 | 1.11 | 0.74 |
| SPAM | Volume puncher | 180 | 9.4% | 8.3% | -1.1 | 1.6 | 94 | 2.65 | 1.04 |
| SPAM | Boxer-puncher | 180 | 17.8% | 17.2% | -0.6 | 1.1 | 46 | 0.77 | 0.28 |
| SPAM | Out-boxer | 180 | 46.1% | 42.8% | -3.3 | 2.7 | 76 | 1.45 | 0.49 |
| SPAM | Slugger | 180 | 70.6% | 70.6% | +0.0 | 0.0 | 59 | 1.09 | 0.39 |
| SPAM | ALL SIX | 1080 | 31.9% | 30.6% | -1.3 | 0.7 | 66 | 1.33 | 0.55 |
| WEAPON | Pressure fighter | 180 | 40.0% | 39.4% | -0.6 | 1.1 | 57 | 1.06 | 0.36 |
| WEAPON | Counter-puncher | 180 | 26.1% | 23.3% | -2.8 | 2.4 | 68 | 1.14 | 0.78 |
| WEAPON | Volume puncher | 180 | 18.3% | 16.7% | -1.7 | 1.9 | 94 | 2.67 | 1.03 |
| WEAPON | Boxer-puncher | 180 | 20.6% | 19.4% | -1.1 | 1.6 | 52 | 0.85 | 0.27 |
| WEAPON | Out-boxer | 180 | 50.0% | 46.1% | -3.9 | 2.9 | 81 | 1.57 | 0.53 |
| WEAPON | Slugger | 180 | 76.7% | 76.7% | +0.0 | 0.0 | 62 | 1.37 | 0.51 |
| WEAPON | ALL SIX | 1080 | 38.6% | 36.9% | -1.7 | 0.8 | 69 | 1.44 | 0.58 |
| SPREAD | Pressure fighter | 180 | 26.1% | 26.1% | +0.0 | 0.0 | 47 | 0.86 | 0.33 |
| SPREAD | Counter-puncher | 180 | 21.1% | 21.1% | +0.0 | 0.0 | 19 | 0.23 | 0.17 |
| SPREAD | Volume puncher | 180 | 12.8% | 11.7% | -1.1 | 1.6 | 84 | 1.72 | 0.65 |
| SPREAD | Boxer-puncher | 180 | 18.9% | 18.9% | +0.0 | 0.0 | 19 | 0.23 | 0.07 |
| SPREAD | Out-boxer | 180 | 48.3% | 48.3% | +0.0 | 0.0 | 36 | 0.52 | 0.17 |
| SPREAD | Slugger | 180 | 65.0% | 64.4% | -0.6 | 1.1 | 48 | 0.72 | 0.26 |
| SPREAD | ALL SIX | 1080 | 32.0% | 31.8% | -0.3 | 0.3 | 42 | 0.71 | 0.27 |

- (a) SPAM v the counter-puncher -2.2, overall -1.3 -> FAIL
- (b) WEAPON beats SPREAD (ON) against: Pressure fighter +13.3, Counter-puncher +2.2, Volume puncher +5.0, Boxer-puncher +0.6, Slugger +12.2 -> PASS
- (c) effects v 2 errors: counter-puncher 2.2 v 2.2, overall 1.3 v 0.7 -> PASS
- (d) the read fires in 66 bouts of 100 for SPAM (25-60), 42 for SPREAD (under 15) -> FAIL
- (e) the best plan (ON) by style: { "Pressure fighter": "WEAPON", "Counter-puncher": "WEAPON", "Volume puncher": "WEAPON", "Boxer-puncher": "WEAPON", "Out-boxer": "SPREAD", "Slugger": "WEAPON" } -> PASS

A3 VERDICT: FAIL

## B2 - THE MEMORY (count carries, fades 1 a bell), read at 2 throws, one sooner v a ring-smart opponent

| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | bouts the read fires (of 100) | throws into a read a bout | counters a bout |
|---|---|---|---|---|---|---|---|---|---|
| SPAM | Pressure fighter | 180 | 27.2% | 21.1% | -6.1 | 3.6 | 97 | 4.71 | 1.74 |
| SPAM | Counter-puncher | 180 | 20.0% | 9.4% | -10.6 | 4.6 | 99 | 7.16 | 4.35 |
| SPAM | Volume puncher | 180 | 9.4% | 6.7% | -2.8 | 2.4 | 100 | 9.73 | 3.36 |
| SPAM | Boxer-puncher | 180 | 17.8% | 12.8% | -5.0 | 3.2 | 99 | 5.40 | 2.07 |
| SPAM | Out-boxer | 180 | 46.1% | 30.0% | -16.1 | 5.5 | 98 | 7.46 | 2.61 |
| SPAM | Slugger | 180 | 70.6% | 63.3% | -7.2 | 3.9 | 99 | 5.55 | 1.94 |
| SPAM | ALL SIX | 1080 | 31.9% | 23.9% | -8.0 | 1.6 | 99 | 6.67 | 2.68 |
| WEAPON | Pressure fighter | 180 | 40.0% | 29.4% | -10.6 | 4.6 | 98 | 5.07 | 1.87 |
| WEAPON | Counter-puncher | 180 | 26.1% | 9.4% | -16.7 | 5.6 | 100 | 7.34 | 4.46 |
| WEAPON | Volume puncher | 180 | 18.3% | 10.0% | -8.3 | 4.1 | 100 | 9.62 | 3.33 |
| WEAPON | Boxer-puncher | 180 | 20.6% | 15.6% | -5.0 | 3.2 | 99 | 5.53 | 2.06 |
| WEAPON | Out-boxer | 180 | 50.0% | 33.9% | -16.1 | 5.5 | 99 | 7.58 | 2.67 |
| WEAPON | Slugger | 180 | 76.7% | 70.6% | -6.1 | 3.6 | 98 | 5.84 | 2.05 |
| WEAPON | ALL SIX | 1080 | 38.6% | 28.1% | -10.5 | 1.9 | 99 | 6.83 | 2.74 |
| SPREAD | Pressure fighter | 180 | 26.1% | 19.4% | -6.7 | 3.7 | 96 | 4.23 | 1.56 |
| SPREAD | Counter-puncher | 180 | 21.1% | 13.9% | -7.2 | 3.9 | 96 | 3.82 | 2.32 |
| SPREAD | Volume puncher | 180 | 12.8% | 7.8% | -5.0 | 3.2 | 100 | 7.92 | 2.81 |
| SPREAD | Boxer-puncher | 180 | 18.9% | 17.2% | -1.7 | 1.9 | 92 | 3.06 | 1.18 |
| SPREAD | Out-boxer | 180 | 48.3% | 39.4% | -8.9 | 4.2 | 94 | 3.91 | 1.39 |
| SPREAD | Slugger | 180 | 65.0% | 59.4% | -5.6 | 3.4 | 96 | 4.21 | 1.44 |
| SPREAD | ALL SIX | 1080 | 32.0% | 26.2% | -5.8 | 1.4 | 96 | 4.52 | 1.78 |

- (a) SPAM v the counter-puncher -10.6, overall -8.0 -> PASS
- (b) WEAPON beats SPREAD (ON) against: Pressure fighter +10.0, Volume puncher +2.2, Slugger +11.1 -> PASS
- (c) effects v 2 errors: counter-puncher 10.6 v 4.6, overall 8.0 v 1.6 -> PASS
- (d) the read fires in 99 bouts of 100 for SPAM (25-60), 96 for SPREAD (under 15) -> FAIL
- (e) the best plan (ON) by style: { "Pressure fighter": "WEAPON", "Counter-puncher": "SPREAD", "Volume puncher": "WEAPON", "Boxer-puncher": "SPREAD", "Out-boxer": "SPREAD", "Slugger": "WEAPON" } -> PASS

B2 VERDICT: FAIL

## B3 - THE MEMORY (count carries, fades 1 a bell), read at 3 throws, one sooner v a ring-smart opponent

| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | bouts the read fires (of 100) | throws into a read a bout | counters a bout |
|---|---|---|---|---|---|---|---|---|---|
| SPAM | Pressure fighter | 180 | 27.2% | 25.0% | -2.2 | 2.2 | 81 | 2.38 | 0.89 |
| SPAM | Counter-puncher | 180 | 20.0% | 14.4% | -5.6 | 3.4 | 95 | 4.24 | 2.63 |
| SPAM | Volume puncher | 180 | 9.4% | 7.2% | -2.2 | 2.2 | 99 | 5.40 | 1.93 |
| SPAM | Boxer-puncher | 180 | 17.8% | 14.4% | -3.3 | 2.7 | 83 | 2.69 | 1.02 |
| SPAM | Out-boxer | 180 | 46.1% | 36.1% | -10.0 | 4.5 | 97 | 4.76 | 1.64 |
| SPAM | Slugger | 180 | 70.6% | 67.8% | -2.8 | 2.4 | 84 | 3.17 | 1.13 |
| SPAM | ALL SIX | 1080 | 31.9% | 27.5% | -4.4 | 1.2 | 90 | 3.77 | 1.54 |
| WEAPON | Pressure fighter | 180 | 40.0% | 34.4% | -5.6 | 3.4 | 84 | 2.61 | 0.94 |
| WEAPON | Counter-puncher | 180 | 26.1% | 18.3% | -7.8 | 4.0 | 96 | 4.31 | 2.69 |
| WEAPON | Volume puncher | 180 | 18.3% | 13.9% | -4.4 | 3.1 | 99 | 5.35 | 1.87 |
| WEAPON | Boxer-puncher | 180 | 20.6% | 17.8% | -2.8 | 2.4 | 87 | 2.79 | 1.00 |
| WEAPON | Out-boxer | 180 | 50.0% | 40.6% | -9.4 | 4.4 | 97 | 4.91 | 1.73 |
| WEAPON | Slugger | 180 | 76.7% | 74.4% | -2.2 | 2.2 | 83 | 3.59 | 1.27 |
| WEAPON | ALL SIX | 1080 | 38.6% | 33.2% | -5.4 | 1.4 | 91 | 3.92 | 1.58 |
| SPREAD | Pressure fighter | 180 | 26.1% | 23.9% | -2.2 | 2.2 | 72 | 2.03 | 0.77 |
| SPREAD | Counter-puncher | 180 | 21.1% | 18.3% | -2.8 | 2.4 | 57 | 1.28 | 0.78 |
| SPREAD | Volume puncher | 180 | 12.8% | 10.6% | -2.2 | 2.2 | 91 | 3.52 | 1.29 |
| SPREAD | Boxer-puncher | 180 | 18.9% | 18.9% | +0.0 | 0.0 | 50 | 0.90 | 0.32 |
| SPREAD | Out-boxer | 180 | 48.3% | 46.7% | -1.7 | 1.9 | 64 | 1.60 | 0.60 |
| SPREAD | Slugger | 180 | 65.0% | 61.7% | -3.3 | 2.7 | 74 | 2.08 | 0.71 |
| SPREAD | ALL SIX | 1080 | 32.0% | 30.0% | -2.0 | 0.9 | 68 | 1.90 | 0.75 |

- (a) SPAM v the counter-puncher -5.6, overall -4.4 -> PASS
- (b) WEAPON beats SPREAD (ON) against: Pressure fighter +10.6, Volume puncher +3.3, Slugger +12.8 -> PASS
- (c) effects v 2 errors: counter-puncher 5.6 v 3.4, overall 4.4 v 1.2 -> PASS
- (d) the read fires in 90 bouts of 100 for SPAM (25-60), 68 for SPREAD (under 15) -> FAIL
- (e) the best plan (ON) by style: { "Pressure fighter": "WEAPON", "Counter-puncher": "WEAPON", "Volume puncher": "WEAPON", "Boxer-puncher": "SPREAD", "Out-boxer": "SPREAD", "Slugger": "WEAPON" } -> PASS

B3 VERDICT: FAIL

## C2 - THE FILM (memory + last bout's top move half-read), read at 2 throws, one sooner v a ring-smart opponent

| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | bouts the read fires (of 100) | throws into a read a bout | counters a bout |
|---|---|---|---|---|---|---|---|---|---|
| SPAM | Pressure fighter | 180 | 27.2% | 20.0% | -7.2 | 3.9 | 98 | 5.26 | 1.97 |
| SPAM | Counter-puncher | 180 | 20.0% | 5.6% | -14.4 | 5.2 | 100 | 7.93 | 4.83 |
| SPAM | Volume puncher | 180 | 9.4% | 6.7% | -2.8 | 2.4 | 100 | 9.73 | 3.36 |
| SPAM | Boxer-puncher | 180 | 17.8% | 12.8% | -5.0 | 3.2 | 99 | 6.05 | 2.33 |
| SPAM | Out-boxer | 180 | 46.1% | 29.4% | -16.7 | 5.6 | 98 | 8.21 | 2.91 |
| SPAM | Slugger | 180 | 70.6% | 61.1% | -9.4 | 4.4 | 99 | 6.19 | 2.18 |
| SPAM | ALL SIX | 1080 | 31.9% | 22.6% | -9.3 | 1.8 | 99 | 7.23 | 2.93 |
| WEAPON | Pressure fighter | 180 | 40.0% | 28.3% | -11.7 | 4.8 | 98 | 5.57 | 2.07 |
| WEAPON | Counter-puncher | 180 | 26.1% | 5.6% | -20.6 | 6.0 | 100 | 8.10 | 4.94 |
| WEAPON | Volume puncher | 180 | 18.3% | 10.0% | -8.3 | 4.1 | 100 | 9.62 | 3.33 |
| WEAPON | Boxer-puncher | 180 | 20.6% | 14.4% | -6.1 | 3.6 | 99 | 6.16 | 2.30 |
| WEAPON | Out-boxer | 180 | 50.0% | 33.9% | -16.1 | 5.5 | 99 | 8.28 | 2.93 |
| WEAPON | Slugger | 180 | 76.7% | 68.9% | -7.8 | 4.0 | 99 | 6.45 | 2.27 |
| WEAPON | ALL SIX | 1080 | 38.6% | 26.9% | -11.8 | 2.0 | 99 | 7.36 | 2.97 |
| SPREAD | Pressure fighter | 180 | 26.1% | 17.8% | -8.3 | 4.1 | 98 | 4.76 | 1.77 |
| SPREAD | Counter-puncher | 180 | 21.1% | 11.1% | -10.0 | 4.5 | 97 | 4.48 | 2.72 |
| SPREAD | Volume puncher | 180 | 12.8% | 7.8% | -5.0 | 3.2 | 100 | 7.92 | 2.81 |
| SPREAD | Boxer-puncher | 180 | 18.9% | 17.2% | -1.7 | 1.9 | 92 | 3.42 | 1.32 |
| SPREAD | Out-boxer | 180 | 48.3% | 39.4% | -8.9 | 4.2 | 96 | 4.39 | 1.60 |
| SPREAD | Slugger | 180 | 65.0% | 57.2% | -7.8 | 4.0 | 97 | 4.74 | 1.64 |
| SPREAD | ALL SIX | 1080 | 32.0% | 25.1% | -6.9 | 1.5 | 97 | 4.95 | 1.98 |

- (a) SPAM v the counter-puncher -14.4, overall -9.3 -> PASS
- (b) WEAPON beats SPREAD (ON) against: Pressure fighter +10.6, Volume puncher +2.2, Slugger +11.7 -> PASS
- (c) effects v 2 errors: counter-puncher 14.4 v 5.2, overall 9.3 v 1.8 -> PASS
- (d) the read fires in 99 bouts of 100 for SPAM (25-60), 97 for SPREAD (under 15) -> FAIL
- (e) the best plan (ON) by style: { "Pressure fighter": "WEAPON", "Counter-puncher": "SPREAD", "Volume puncher": "WEAPON", "Boxer-puncher": "SPREAD", "Out-boxer": "SPREAD", "Slugger": "WEAPON" } -> PASS

C2 VERDICT: FAIL

## C3 - THE FILM (memory + last bout's top move half-read), read at 3 throws, one sooner v a ring-smart opponent

| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | bouts the read fires (of 100) | throws into a read a bout | counters a bout |
|---|---|---|---|---|---|---|---|---|---|
| SPAM | Pressure fighter | 180 | 27.2% | 24.4% | -2.8 | 2.4 | 84 | 2.72 | 1.03 |
| SPAM | Counter-puncher | 180 | 20.0% | 13.3% | -6.7 | 3.7 | 97 | 5.08 | 3.12 |
| SPAM | Volume puncher | 180 | 9.4% | 6.7% | -2.8 | 2.4 | 99 | 6.09 | 2.16 |
| SPAM | Boxer-puncher | 180 | 17.8% | 14.4% | -3.3 | 2.7 | 86 | 3.17 | 1.19 |
| SPAM | Out-boxer | 180 | 46.1% | 32.8% | -13.3 | 5.1 | 98 | 5.39 | 1.87 |
| SPAM | Slugger | 180 | 70.6% | 65.6% | -5.0 | 3.2 | 90 | 3.66 | 1.34 |
| SPAM | ALL SIX | 1080 | 31.9% | 26.2% | -5.6 | 1.4 | 92 | 4.35 | 1.79 |
| WEAPON | Pressure fighter | 180 | 40.0% | 33.3% | -6.7 | 3.7 | 88 | 3.00 | 1.09 |
| WEAPON | Counter-puncher | 180 | 26.1% | 16.1% | -10.0 | 4.5 | 98 | 5.16 | 3.19 |
| WEAPON | Volume puncher | 180 | 18.3% | 12.8% | -5.6 | 3.4 | 100 | 6.02 | 2.05 |
| WEAPON | Boxer-puncher | 180 | 20.6% | 17.2% | -3.3 | 2.7 | 91 | 3.27 | 1.20 |
| WEAPON | Out-boxer | 180 | 50.0% | 37.2% | -12.8 | 5.0 | 97 | 5.47 | 1.93 |
| WEAPON | Slugger | 180 | 76.7% | 72.8% | -3.9 | 2.9 | 91 | 4.12 | 1.48 |
| WEAPON | ALL SIX | 1080 | 38.6% | 31.6% | -7.0 | 1.6 | 94 | 4.50 | 1.82 |
| SPREAD | Pressure fighter | 180 | 26.1% | 23.3% | -2.8 | 2.4 | 77 | 2.38 | 0.89 |
| SPREAD | Counter-puncher | 180 | 21.1% | 17.8% | -3.3 | 2.7 | 69 | 1.88 | 1.14 |
| SPREAD | Volume puncher | 180 | 12.8% | 9.4% | -3.3 | 2.7 | 95 | 4.08 | 1.48 |
| SPREAD | Boxer-puncher | 180 | 18.9% | 18.9% | +0.0 | 0.0 | 56 | 1.16 | 0.41 |
| SPREAD | Out-boxer | 180 | 48.3% | 45.0% | -3.3 | 2.7 | 69 | 1.89 | 0.71 |
| SPREAD | Slugger | 180 | 65.0% | 60.6% | -4.4 | 3.1 | 79 | 2.40 | 0.83 |
| SPREAD | ALL SIX | 1080 | 32.0% | 29.2% | -2.9 | 1.0 | 74 | 2.30 | 0.91 |

- (a) SPAM v the counter-puncher -6.7, overall -5.6 -> PASS
- (b) WEAPON beats SPREAD (ON) against: Pressure fighter +10.0, Volume puncher +3.3, Slugger +12.2 -> PASS
- (c) effects v 2 errors: counter-puncher 6.7 v 3.7, overall 5.6 v 1.4 -> PASS
- (d) the read fires in 92 bouts of 100 for SPAM (25-60), 74 for SPREAD (under 15) -> FAIL
- (e) the best plan (ON) by style: { "Pressure fighter": "WEAPON", "Counter-puncher": "SPREAD", "Volume puncher": "WEAPON", "Boxer-puncher": "SPREAD", "Out-boxer": "SPREAD", "Slugger": "WEAPON" } -> PASS

C3 VERDICT: FAIL

## P2 - DIAGNOSTIC: C counting only the plan's own lines (added after the A-C run), read at 2 throws, one sooner v a ring-smart opponent

| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | bouts the read fires (of 100) | throws into a read a bout | counters a bout |
|---|---|---|---|---|---|---|---|---|---|
| SPAM | Pressure fighter | 180 | 27.2% | 27.2% | +0.0 | 0.0 | 2 | 0.03 | 0.01 |
| SPAM | Counter-puncher | 180 | 20.0% | 13.9% | -6.1 | 3.6 | 71 | 2.69 | 1.62 |
| SPAM | Volume puncher | 180 | 9.4% | 9.4% | +0.0 | 0.0 | 7 | 0.09 | 0.02 |
| SPAM | Boxer-puncher | 180 | 17.8% | 16.1% | -1.7 | 1.9 | 52 | 1.62 | 0.57 |
| SPAM | Out-boxer | 180 | 46.1% | 41.1% | -5.0 | 3.2 | 67 | 2.51 | 0.92 |
| SPAM | Slugger | 180 | 70.6% | 70.0% | -0.6 | 1.1 | 3 | 0.04 | 0.01 |
| SPAM | ALL SIX | 1080 | 31.9% | 29.6% | -2.2 | 0.9 | 34 | 1.16 | 0.53 |
| WEAPON | Pressure fighter | 180 | 40.0% | 38.3% | -1.7 | 1.9 | 52 | 1.11 | 0.38 |
| WEAPON | Counter-puncher | 180 | 26.1% | 15.0% | -11.1 | 4.7 | 80 | 3.26 | 1.94 |
| WEAPON | Volume puncher | 180 | 18.3% | 16.1% | -2.2 | 2.2 | 81 | 2.76 | 0.99 |
| WEAPON | Boxer-puncher | 180 | 20.6% | 17.8% | -2.8 | 2.4 | 62 | 2.12 | 0.76 |
| WEAPON | Out-boxer | 180 | 50.0% | 43.3% | -6.7 | 3.7 | 76 | 3.00 | 1.07 |
| WEAPON | Slugger | 180 | 76.7% | 75.0% | -1.7 | 1.9 | 63 | 2.17 | 0.74 |
| WEAPON | ALL SIX | 1080 | 38.6% | 34.3% | -4.4 | 1.2 | 69 | 2.40 | 0.98 |
| SPREAD | Pressure fighter | 180 | 26.1% | 26.1% | +0.0 | 0.0 | 1 | 0.01 | 0.01 |
| SPREAD | Counter-puncher | 180 | 21.1% | 20.0% | -1.1 | 1.6 | 42 | 1.13 | 0.69 |
| SPREAD | Volume puncher | 180 | 12.8% | 12.8% | +0.0 | 0.0 | 24 | 0.39 | 0.11 |
| SPREAD | Boxer-puncher | 180 | 18.9% | 18.9% | +0.0 | 0.0 | 12 | 0.22 | 0.08 |
| SPREAD | Out-boxer | 180 | 48.3% | 47.8% | -0.6 | 1.1 | 21 | 0.37 | 0.14 |
| SPREAD | Slugger | 180 | 65.0% | 65.0% | +0.0 | 0.0 | 1 | 0.01 | 0.01 |
| SPREAD | ALL SIX | 1080 | 32.0% | 31.8% | -0.3 | 0.3 | 17 | 0.35 | 0.17 |

- (a) SPAM v the counter-puncher -6.1, overall -2.2 -> PASS
- (b) WEAPON beats SPREAD (ON) against: Pressure fighter +12.2, Volume puncher +3.3, Slugger +10.0 -> PASS
- (c) effects v 2 errors: counter-puncher 6.1 v 3.6, overall 2.2 v 0.9 -> PASS
- (d) the read fires in 34 bouts of 100 for SPAM (25-60), 17 for SPREAD (under 15) -> FAIL
- (e) the best plan (ON) by style: { "Pressure fighter": "WEAPON", "Counter-puncher": "SPREAD", "Volume puncher": "WEAPON", "Boxer-puncher": "SPREAD", "Out-boxer": "SPREAD", "Slugger": "WEAPON" } -> PASS

P2 VERDICT: FAIL

## P3 - DIAGNOSTIC: C counting only the plan's own lines (added after the A-C run), read at 3 throws, one sooner v a ring-smart opponent

| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | bouts the read fires (of 100) | throws into a read a bout | counters a bout |
|---|---|---|---|---|---|---|---|---|---|
| SPAM | Pressure fighter | 180 | 27.2% | 27.2% | +0.0 | 0.0 | 0 | 0.00 | 0.00 |
| SPAM | Counter-puncher | 180 | 20.0% | 16.1% | -3.9 | 2.9 | 50 | 1.60 | 0.93 |
| SPAM | Volume puncher | 180 | 9.4% | 9.4% | +0.0 | 0.0 | 0 | 0.00 | 0.00 |
| SPAM | Boxer-puncher | 180 | 17.8% | 16.7% | -1.1 | 1.6 | 28 | 0.81 | 0.33 |
| SPAM | Out-boxer | 180 | 46.1% | 42.2% | -3.9 | 2.9 | 45 | 1.50 | 0.56 |
| SPAM | Slugger | 180 | 70.6% | 70.6% | +0.0 | 0.0 | 0 | 0.00 | 0.00 |
| SPAM | ALL SIX | 1080 | 31.9% | 30.4% | -1.5 | 0.7 | 21 | 0.65 | 0.30 |
| WEAPON | Pressure fighter | 180 | 40.0% | 39.4% | -0.6 | 1.1 | 23 | 0.42 | 0.15 |
| WEAPON | Counter-puncher | 180 | 26.1% | 22.8% | -3.3 | 2.7 | 54 | 1.78 | 1.04 |
| WEAPON | Volume puncher | 180 | 18.3% | 17.2% | -1.1 | 1.6 | 54 | 1.57 | 0.59 |
| WEAPON | Boxer-puncher | 180 | 20.6% | 18.9% | -1.7 | 1.9 | 36 | 0.95 | 0.37 |
| WEAPON | Out-boxer | 180 | 50.0% | 45.6% | -4.4 | 3.1 | 50 | 1.67 | 0.60 |
| WEAPON | Slugger | 180 | 76.7% | 75.6% | -1.1 | 1.6 | 43 | 1.27 | 0.45 |
| WEAPON | ALL SIX | 1080 | 38.6% | 36.6% | -2.0 | 0.9 | 43 | 1.27 | 0.53 |
| SPREAD | Pressure fighter | 180 | 26.1% | 26.1% | +0.0 | 0.0 | 0 | 0.00 | 0.00 |
| SPREAD | Counter-puncher | 180 | 21.1% | 21.1% | +0.0 | 0.0 | 21 | 0.48 | 0.28 |
| SPREAD | Volume puncher | 180 | 12.8% | 12.8% | +0.0 | 0.0 | 7 | 0.08 | 0.02 |
| SPREAD | Boxer-puncher | 180 | 18.9% | 18.9% | +0.0 | 0.0 | 2 | 0.03 | 0.02 |
| SPREAD | Out-boxer | 180 | 48.3% | 48.3% | +0.0 | 0.0 | 6 | 0.12 | 0.05 |
| SPREAD | Slugger | 180 | 65.0% | 65.0% | +0.0 | 0.0 | 0 | 0.00 | 0.00 |
| SPREAD | ALL SIX | 1080 | 32.0% | 32.0% | +0.0 | 0.0 | 6 | 0.12 | 0.06 |

- (a) SPAM v the counter-puncher -3.9, overall -1.5 -> FAIL
- (b) WEAPON beats SPREAD (ON) against: Pressure fighter +13.3, Counter-puncher +1.7, Volume puncher +4.4, Slugger +10.6 -> PASS
- (c) effects v 2 errors: counter-puncher 3.9 v 2.9, overall 1.5 v 0.7 -> PASS
- (d) the read fires in 21 bouts of 100 for SPAM (25-60), 6 for SPREAD (under 15) -> FAIL
- (e) the best plan (ON) by style: { "Pressure fighter": "WEAPON", "Counter-puncher": "WEAPON", "Volume puncher": "WEAPON", "Boxer-puncher": "WEAPON", "Out-boxer": "SPREAD", "Slugger": "WEAPON" } -> PASS

P3 VERDICT: FAIL

## Verdicts

- A2 FAIL (a true, b true, c true, d false, e true)
- A3 FAIL (a false, b true, c true, d false, e true)
- B2 FAIL (a true, b true, c true, d false, e true)
- B3 FAIL (a true, b true, c true, d false, e true)
- C2 FAIL (a true, b true, c true, d false, e true)
- C3 FAIL (a true, b true, c true, d false, e true)
- P2 FAIL (a true, b true, c true, d false, e true)
- P3 FAIL (a false, b true, c true, d false, e true)

## Verdict: NO variant passes - nothing built (written after the run, S539)

| variant | (a) SPAM v counter-puncher / overall | (b) | (c) | (d) fires SPAM / SPREAD (of 100) | (e) | verdict |
|---|---|---|---|---|---|---|
| A2 counter, per round, read at 2 | -6.7 / -3.9 PASS | PASS | PASS | 97 / 89 FAIL | PASS | FAIL |
| A3 counter, per round, read at 3 | -2.2 / -1.3 FAIL | PASS | PASS | 66 / 42 FAIL | PASS | FAIL |
| B2 memory, read at 2 | -10.6 / -8.0 PASS | PASS | PASS | 99 / 96 FAIL | PASS | FAIL |
| B3 memory, read at 3 | -5.6 / -4.4 PASS | PASS | PASS | 90 / 68 FAIL | PASS | FAIL |
| C2 film, read at 2 | -14.4 / -9.3 PASS | PASS | PASS | 99 / 97 FAIL | PASS | FAIL |
| C3 film, read at 3 | -6.7 / -5.6 PASS | PASS | PASS | 92 / 74 FAIL | PASS | FAIL |
| P2 (diagnostic) C on plan lines only, at 2 | -6.1 / -2.2 PASS | PASS | PASS | 34 / 17 FAIL | PASS | FAIL (SPREAD 2 over) |
| P3 (diagnostic) C on plan lines only, at 3 | -3.9 / -1.5 FAIL | PASS | PASS | 21 / 6 FAIL | PASS | FAIL |

What the tables say:

1. **The counter does bite now** - unlike REPEATREAD1's margin tax, a countered exchange is a lost exchange, and SPAM loses
   6-14 wins in 100 against the counter-puncher (A2, B2-C3). Bar (a) is reachable.
2. **But it punishes everyone, not the repeater** (bar d). Counting every throw, the read fires in 89-97 bouts of 100 for the
   varied plan too, and the varied plan loses 3-7 wins in 100. What she throws most is her instinct move for each range (the
   jab at long range, etc.), not the plan the player wrote. The player cannot vary what he never chose, so this would be a
   tax on fighting, not a choice. WEAPON is hit hardest of all (A2 -5.1, B2 -10.5 overall): a main weapon that fires is
   exactly what gets read, which pushes the player toward no plan.
3. **Counting only the plan's own lines is the right shape and almost passes** (P2, added as a diagnostic after the A-C run,
   bars unchanged): SPAM gets read in 34 bouts of 100 and loses 6.1 v the counter-puncher and 2.2 overall, the varied plan is
   read in 17 (bar: under 15) and loses 0.3. It fails (d) by 2 bouts of 100, so by the rule it is not built. P3 bites too little.
4. Bars (b) and (e) held in every variant: a main weapon still beats the spread against 3-5 styles, and no plan shape is best
   against all six (the counter-puncher, boxer-puncher and out-boxer flip to SPREAD under the memory variants).

What would have to change to pass (for the owner's call, not done here): P2 is the candidate - the read follows the PLAN's
repeated line, remembered across rounds and from the opponent's film. To bring the varied plan's 17 under 15 without loosening
a bar, the count should exclude a line that is the plan's answer for a DIFFERENT situation each time (a spread plan's lines
repeat because two situations share a move), or the read should need the line to have WON its earlier uses (an opponent
studies what hurts him). Either is a new rule to probe in a REPEATBITE2, on the same population and these bars.

Greybox limits: a counter changes the exchange's result and margin only (not damage, hurt or knockdowns after it), so the
real effect would be somewhat larger; stopped bouts keep their result in every arm; the sim has no corner "change it up" call,
so B/C's clear was never exercised. Probe: tools/repeatbite1.gd + tools/repeatbite1_rules.gd; run
`godot --headless --script res://tools/repeatbite1.gd -- boxers=60 nights=3` (3,240 bouts, ~3.5 min). Nothing under scripts/ changed.


---

# REPEATBITE2 - the plan-line counter refined: P2 + R1 / R2 (S539, TASK_REPEATBITE2)

Bars (a)-(e) unchanged from REPEATBITE1, written into tools/repeatbite2.gd before the run. Same population (60 boxers x 6
styles x 3 nights = 1080 bouts a plan), same recorded bouts and dice, counter numbers unchanged (tools/repeatbite1_rules.gd).
R1 = a line counts per move AND situation ("every time I press, she throws the one-two"); R2 = only a use that WON counts.
The R variants' film is the last bout's most-counted read key under their own rule; P2 keeps REPEATBITE1's film.
Probe: tools/repeatbite2.gd + tools/repeatbite2_rules.gd (`-- boxers=60 nights=3`, ~3.5 min, through godot_slot).
The P2 control reproduces REPEATBITE1's P2 exactly (34 / 17 fires, -6.1 / -2.2), so the probe is the same game.

Rule copy tools/repeatbite1_rules.gd: counter chance 0.35 a throw into a read (counter-puncher x1.75), ring-smart opponent (rating 65+) reads one throw sooner, a counter = the exchange lost (margin -10 or lower). 60 boxers x 6 opponents x 3 nights = 1080 bouts a plan, played once, every variant on the same bouts.

### P2 - P2

| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | bouts the read fires (of 100) | throws into a read a bout | counters a bout |
|---|---|---|---|---|---|---|---|---|---|
| SPAM | Pressure fighter | 180 | 27.2% | 27.2% | +0.0 | 0.0 | 2 | 0.03 | 0.01 |
| SPAM | Counter-puncher | 180 | 20.0% | 13.9% | -6.1 | 3.6 | 71 | 2.69 | 1.62 |
| SPAM | Volume puncher | 180 | 9.4% | 9.4% | +0.0 | 0.0 | 7 | 0.09 | 0.02 |
| SPAM | Boxer-puncher | 180 | 17.8% | 16.1% | -1.7 | 1.9 | 52 | 1.62 | 0.57 |
| SPAM | Out-boxer | 180 | 46.1% | 41.1% | -5.0 | 3.2 | 67 | 2.51 | 0.92 |
| SPAM | Slugger | 180 | 70.6% | 70.0% | -0.6 | 1.1 | 3 | 0.04 | 0.01 |
| SPAM | ALL SIX | 1080 | 31.9% | 29.6% | -2.2 | 0.9 | 34 | 1.16 | 0.53 |
| WEAPON | Pressure fighter | 180 | 40.0% | 38.3% | -1.7 | 1.9 | 52 | 1.11 | 0.38 |
| WEAPON | Counter-puncher | 180 | 26.1% | 15.0% | -11.1 | 4.7 | 80 | 3.26 | 1.94 |
| WEAPON | Volume puncher | 180 | 18.3% | 16.1% | -2.2 | 2.2 | 81 | 2.76 | 0.99 |
| WEAPON | Boxer-puncher | 180 | 20.6% | 17.8% | -2.8 | 2.4 | 62 | 2.12 | 0.76 |
| WEAPON | Out-boxer | 180 | 50.0% | 43.3% | -6.7 | 3.7 | 76 | 3.00 | 1.07 |
| WEAPON | Slugger | 180 | 76.7% | 75.0% | -1.7 | 1.9 | 63 | 2.17 | 0.74 |
| WEAPON | ALL SIX | 1080 | 38.6% | 34.3% | -4.4 | 1.2 | 69 | 2.40 | 0.98 |
| SPREAD | Pressure fighter | 180 | 26.1% | 26.1% | +0.0 | 0.0 | 1 | 0.01 | 0.01 |
| SPREAD | Counter-puncher | 180 | 21.1% | 20.0% | -1.1 | 1.6 | 42 | 1.13 | 0.69 |
| SPREAD | Volume puncher | 180 | 12.8% | 12.8% | +0.0 | 0.0 | 24 | 0.39 | 0.11 |
| SPREAD | Boxer-puncher | 180 | 18.9% | 18.9% | +0.0 | 0.0 | 12 | 0.22 | 0.08 |
| SPREAD | Out-boxer | 180 | 48.3% | 47.8% | -0.6 | 1.1 | 21 | 0.37 | 0.14 |
| SPREAD | Slugger | 180 | 65.0% | 65.0% | +0.0 | 0.0 | 1 | 0.01 | 0.01 |
| SPREAD | ALL SIX | 1080 | 32.0% | 31.8% | -0.3 | 0.3 | 17 | 0.35 | 0.17 |

- (a) SPAM v the counter-puncher -6.1, overall -2.2 -> PASS
- (b) WEAPON beats SPREAD (ON) against: Pressure fighter +12.2, Volume puncher +3.3, Slugger +10.0 -> PASS
- (c) effects v 2 errors: counter-puncher 6.1 v 3.6, overall 2.2 v 0.9 -> PASS
- (d) the read fires in 34 bouts of 100 for SPAM (25-60), 17 for SPREAD (under 15) -> FAIL
- (e) the best plan (ON) by style: { "Pressure fighter": "WEAPON", "Counter-puncher": "SPREAD", "Volume puncher": "WEAPON", "Boxer-puncher": "SPREAD", "Out-boxer": "SPREAD", "Slugger": "WEAPON" } -> PASS

P2 VERDICT: FAIL

### P2+R1 - P2 + R1 (count per move and situation)

| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | bouts the read fires (of 100) | throws into a read a bout | counters a bout |
|---|---|---|---|---|---|---|---|---|---|
| SPAM | Pressure fighter | 180 | 27.2% | 27.2% | +0.0 | 0.0 | 1 | 0.01 | 0.01 |
| SPAM | Counter-puncher | 180 | 20.0% | 18.9% | -1.1 | 1.6 | 48 | 1.25 | 0.77 |
| SPAM | Volume puncher | 180 | 9.4% | 9.4% | +0.0 | 0.0 | 0 | 0.00 | 0.00 |
| SPAM | Boxer-puncher | 180 | 17.8% | 17.8% | +0.0 | 0.0 | 16 | 0.27 | 0.07 |
| SPAM | Out-boxer | 180 | 46.1% | 46.1% | +0.0 | 0.0 | 31 | 0.62 | 0.21 |
| SPAM | Slugger | 180 | 70.6% | 70.6% | +0.0 | 0.0 | 3 | 0.04 | 0.01 |
| SPAM | ALL SIX | 1080 | 31.9% | 31.7% | -0.2 | 0.3 | 16 | 0.36 | 0.18 |
| WEAPON | Pressure fighter | 180 | 40.0% | 39.4% | -0.6 | 1.1 | 16 | 0.23 | 0.08 |
| WEAPON | Counter-puncher | 180 | 26.1% | 23.9% | -2.2 | 2.2 | 49 | 1.29 | 0.79 |
| WEAPON | Volume puncher | 180 | 18.3% | 17.8% | -0.6 | 1.1 | 53 | 1.02 | 0.36 |
| WEAPON | Boxer-puncher | 180 | 20.6% | 20.6% | +0.0 | 0.0 | 23 | 0.40 | 0.14 |
| WEAPON | Out-boxer | 180 | 50.0% | 50.0% | +0.0 | 0.0 | 37 | 0.73 | 0.23 |
| WEAPON | Slugger | 180 | 76.7% | 76.7% | +0.0 | 0.0 | 21 | 0.31 | 0.12 |
| WEAPON | ALL SIX | 1080 | 38.6% | 38.1% | -0.6 | 0.5 | 33 | 0.66 | 0.29 |
| SPREAD | Pressure fighter | 180 | 26.1% | 26.1% | +0.0 | 0.0 | 1 | 0.01 | 0.01 |
| SPREAD | Counter-puncher | 180 | 21.1% | 20.0% | -1.1 | 1.6 | 48 | 1.27 | 0.78 |
| SPREAD | Volume puncher | 180 | 12.8% | 12.8% | +0.0 | 0.0 | 24 | 0.39 | 0.11 |
| SPREAD | Boxer-puncher | 180 | 18.9% | 18.9% | +0.0 | 0.0 | 18 | 0.32 | 0.09 |
| SPREAD | Out-boxer | 180 | 48.3% | 47.8% | -0.6 | 1.1 | 28 | 0.61 | 0.21 |
| SPREAD | Slugger | 180 | 65.0% | 65.0% | +0.0 | 0.0 | 1 | 0.01 | 0.01 |
| SPREAD | ALL SIX | 1080 | 32.0% | 31.8% | -0.3 | 0.3 | 20 | 0.43 | 0.20 |

- (a) SPAM v the counter-puncher -1.1, overall -0.2 -> FAIL
- (b) WEAPON beats SPREAD (ON) against: Pressure fighter +13.3, Counter-puncher +3.9, Volume puncher +5.0, Boxer-puncher +1.7, Out-boxer +2.2, Slugger +11.7 -> PASS
- (c) effects v 2 errors: counter-puncher 1.1 v 1.6, overall 0.2 v 0.3 -> FAIL
- (d) the read fires in 16 bouts of 100 for SPAM (25-60), 20 for SPREAD (under 15) -> FAIL
- (e) the best plan (ON) by style: { "Pressure fighter": "WEAPON", "Counter-puncher": "WEAPON", "Volume puncher": "WEAPON", "Boxer-puncher": "WEAPON", "Out-boxer": "WEAPON", "Slugger": "WEAPON" } -> FAIL

P2+R1 VERDICT: FAIL

### P2+R2 - P2 + R2 (only won uses count)

| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | bouts the read fires (of 100) | throws into a read a bout | counters a bout |
|---|---|---|---|---|---|---|---|---|---|
| SPAM | Pressure fighter | 180 | 27.2% | 27.2% | +0.0 | 0.0 | 1 | 0.01 | 0.01 |
| SPAM | Counter-puncher | 180 | 20.0% | 17.8% | -2.2 | 2.2 | 16 | 0.44 | 0.25 |
| SPAM | Volume puncher | 180 | 9.4% | 9.4% | +0.0 | 0.0 | 2 | 0.02 | 0.01 |
| SPAM | Boxer-puncher | 180 | 17.8% | 17.8% | +0.0 | 0.0 | 23 | 0.46 | 0.14 |
| SPAM | Out-boxer | 180 | 46.1% | 42.8% | -3.3 | 2.7 | 40 | 1.24 | 0.46 |
| SPAM | Slugger | 180 | 70.6% | 70.6% | +0.0 | 0.0 | 5 | 0.07 | 0.01 |
| SPAM | ALL SIX | 1080 | 31.9% | 30.9% | -0.9 | 0.6 | 15 | 0.38 | 0.15 |
| WEAPON | Pressure fighter | 180 | 40.0% | 39.4% | -0.6 | 1.1 | 21 | 0.48 | 0.16 |
| WEAPON | Counter-puncher | 180 | 26.1% | 22.2% | -3.9 | 2.9 | 23 | 0.58 | 0.35 |
| WEAPON | Volume puncher | 180 | 18.3% | 16.7% | -1.7 | 1.9 | 51 | 1.15 | 0.47 |
| WEAPON | Boxer-puncher | 180 | 20.6% | 19.4% | -1.1 | 1.6 | 27 | 0.57 | 0.21 |
| WEAPON | Out-boxer | 180 | 50.0% | 47.8% | -2.2 | 2.2 | 44 | 1.22 | 0.42 |
| WEAPON | Slugger | 180 | 76.7% | 76.1% | -0.6 | 1.1 | 54 | 1.72 | 0.58 |
| WEAPON | ALL SIX | 1080 | 38.6% | 36.9% | -1.7 | 0.8 | 37 | 0.95 | 0.36 |
| SPREAD | Pressure fighter | 180 | 26.1% | 26.1% | +0.0 | 0.0 | 0 | 0.00 | 0.00 |
| SPREAD | Counter-puncher | 180 | 21.1% | 20.6% | -0.6 | 1.1 | 6 | 0.10 | 0.08 |
| SPREAD | Volume puncher | 180 | 12.8% | 12.8% | +0.0 | 0.0 | 2 | 0.02 | 0.00 |
| SPREAD | Boxer-puncher | 180 | 18.9% | 18.9% | +0.0 | 0.0 | 2 | 0.03 | 0.01 |
| SPREAD | Out-boxer | 180 | 48.3% | 48.3% | +0.0 | 0.0 | 8 | 0.13 | 0.04 |
| SPREAD | Slugger | 180 | 65.0% | 65.0% | +0.0 | 0.0 | 0 | 0.00 | 0.00 |
| SPREAD | ALL SIX | 1080 | 32.0% | 31.9% | -0.1 | 0.2 | 3 | 0.05 | 0.02 |

- (a) SPAM v the counter-puncher -2.2, overall -0.9 -> FAIL
- (b) WEAPON beats SPREAD (ON) against: Pressure fighter +13.3, Counter-puncher +1.7, Volume puncher +3.9, Boxer-puncher +0.6, Slugger +11.1 -> PASS
- (c) effects v 2 errors: counter-puncher 2.2 v 2.2, overall 0.9 v 0.6 -> PASS
- (d) the read fires in 15 bouts of 100 for SPAM (25-60), 3 for SPREAD (under 15) -> FAIL
- (e) the best plan (ON) by style: { "Pressure fighter": "WEAPON", "Counter-puncher": "WEAPON", "Volume puncher": "WEAPON", "Boxer-puncher": "WEAPON", "Out-boxer": "SPREAD", "Slugger": "WEAPON" } -> PASS

P2+R2 VERDICT: FAIL

### P2+R1R2 - P2 + R1 (count per move and situation) + R2 (only won uses count)

| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | bouts the read fires (of 100) | throws into a read a bout | counters a bout |
|---|---|---|---|---|---|---|---|---|---|
| SPAM | Pressure fighter | 180 | 27.2% | 27.2% | +0.0 | 0.0 | 1 | 0.01 | 0.01 |
| SPAM | Counter-puncher | 180 | 20.0% | 19.4% | -0.6 | 1.1 | 7 | 0.11 | 0.08 |
| SPAM | Volume puncher | 180 | 9.4% | 9.4% | +0.0 | 0.0 | 0 | 0.00 | 0.00 |
| SPAM | Boxer-puncher | 180 | 17.8% | 17.8% | +0.0 | 0.0 | 4 | 0.04 | 0.01 |
| SPAM | Out-boxer | 180 | 46.1% | 46.1% | +0.0 | 0.0 | 9 | 0.14 | 0.04 |
| SPAM | Slugger | 180 | 70.6% | 70.6% | +0.0 | 0.0 | 0 | 0.00 | 0.00 |
| SPAM | ALL SIX | 1080 | 31.9% | 31.8% | -0.1 | 0.2 | 3 | 0.05 | 0.02 |
| WEAPON | Pressure fighter | 180 | 40.0% | 40.0% | +0.0 | 0.0 | 5 | 0.08 | 0.03 |
| WEAPON | Counter-puncher | 180 | 26.1% | 25.6% | -0.6 | 1.1 | 9 | 0.13 | 0.08 |
| WEAPON | Volume puncher | 180 | 18.3% | 17.8% | -0.6 | 1.1 | 25 | 0.41 | 0.16 |
| WEAPON | Boxer-puncher | 180 | 20.6% | 20.6% | +0.0 | 0.0 | 6 | 0.07 | 0.03 |
| WEAPON | Out-boxer | 180 | 50.0% | 50.0% | +0.0 | 0.0 | 12 | 0.17 | 0.04 |
| WEAPON | Slugger | 180 | 76.7% | 76.7% | +0.0 | 0.0 | 16 | 0.25 | 0.11 |
| WEAPON | ALL SIX | 1080 | 38.6% | 38.4% | -0.2 | 0.3 | 12 | 0.18 | 0.07 |
| SPREAD | Pressure fighter | 180 | 26.1% | 26.1% | +0.0 | 0.0 | 0 | 0.00 | 0.00 |
| SPREAD | Counter-puncher | 180 | 21.1% | 20.6% | -0.6 | 1.1 | 6 | 0.10 | 0.08 |
| SPREAD | Volume puncher | 180 | 12.8% | 12.8% | +0.0 | 0.0 | 2 | 0.02 | 0.00 |
| SPREAD | Boxer-puncher | 180 | 18.9% | 18.9% | +0.0 | 0.0 | 2 | 0.03 | 0.01 |
| SPREAD | Out-boxer | 180 | 48.3% | 48.3% | +0.0 | 0.0 | 8 | 0.13 | 0.04 |
| SPREAD | Slugger | 180 | 65.0% | 65.0% | +0.0 | 0.0 | 0 | 0.00 | 0.00 |
| SPREAD | ALL SIX | 1080 | 32.0% | 31.9% | -0.1 | 0.2 | 3 | 0.05 | 0.02 |

- (a) SPAM v the counter-puncher -0.6, overall -0.1 -> FAIL
- (b) WEAPON beats SPREAD (ON) against: Pressure fighter +13.9, Counter-puncher +5.0, Volume puncher +5.0, Boxer-puncher +1.7, Out-boxer +1.7, Slugger +11.7 -> PASS
- (c) effects v 2 errors: counter-puncher 0.6 v 1.1, overall 0.1 v 0.2 -> FAIL
- (d) the read fires in 3 bouts of 100 for SPAM (25-60), 3 for SPREAD (under 15) -> FAIL
- (e) the best plan (ON) by style: { "Pressure fighter": "WEAPON", "Counter-puncher": "WEAPON", "Volume puncher": "WEAPON", "Boxer-puncher": "WEAPON", "Out-boxer": "WEAPON", "Slugger": "WEAPON" } -> FAIL

P2+R1R2 VERDICT: FAIL

## Verdicts

- P2 FAIL (a true, b true, c true, d false, e true)
- P2+R1 FAIL (a false, b true, c false, d false, e false)
- P2+R2 FAIL (a false, b true, c true, d false, e true)
- P2+R1R2 FAIL (a false, b true, c false, d false, e false)

## REPEATBITE2 pick: NO variant passes - nothing built

| variant | (a) SPAM v counter-puncher / overall | (b) | (c) | (d) fires SPAM / SPREAD (of 100) | (e) | verdict |
|---|---|---|---|---|---|---|
| P2 (control) | -6.1 / -2.2 PASS | PASS | PASS | 34 / 17 FAIL | PASS | FAIL (SPREAD 2 over) |
| P2+R1 same situation | -1.1 / -0.2 FAIL | PASS | FAIL | 16 / 20 FAIL | FAIL (WEAPON best v all six) | FAIL |
| P2+R2 won uses only | -2.2 / -0.9 FAIL | PASS | PASS | 15 / 3 FAIL | PASS | FAIL |
| P2+R1R2 both | -0.6 / -0.1 FAIL | PASS | FAIL | 3 / 3 FAIL | FAIL (WEAPON best v all six) | FAIL |

What the tables say:

1. **Both rules cut the repeater harder than the varied plan.** Each was meant to spare SPREAD; each also starves SPAM's read.
   R2 does bring SPREAD to 3 bouts of 100 (bar under 15), but SPAM falls to 15 (bar 25-60) and its cost to -0.9 overall
   (bar 2+): a SPAM line that loses often is never "studied", so the worst habit is the one that goes unpunished.
2. **R1 points the wrong way.** SPAM's one weapon is thrown into whatever situation comes, so keying the read on
   move + situation splits its count four ways (34 -> 16 fires); SPREAD's lines are each tied to one situation
   ("when pressed", ...), so splitting costs them nothing, and the film now starts on a real plan line - SPREAD is read MORE
   (17 -> 20). With the counter gone from SPAM, WEAPON becomes the best plan against all six styles (bar e).
3. **P2 alone stays the closest** (fails only on SPREAD 17 v under 15). The gap is not in what counts toward the read but
   in how fast any plan line reaches 2: a 3-round bout has ~18 exchanges and a 4-line spread still repeats each line ~2-3
   times. Neither refinement separates "one line, many times" from "four lines, a few times each".

What would have to change (for the owner's call, not done here): a read threshold that scales with the plan's SHARE -
the read needs a line to be most of the plan's throws so far (e.g. 50%+ of planned throws in the bout and at least 2),
not a raw count - separates SPAM (one line = all of it) from SPREAD (each line ~25%) by construction. That is a new rule;
by the S534 order it is probed on this same greybox and these bars before anything is built. Nothing under scripts/ changed.
