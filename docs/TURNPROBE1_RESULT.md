# TURNPROBE1 RESULT - do the two promoters, the one ask and the timing make a real choice?

Probe run: 2026-11-19T03:57:17. 30 careers/bot x 5 bots x 2 seed sets = 300 careers, 104 weeks each. Wall time: 1140.4 s.

## Population

- Seeds: [4421, 9001]. Each seed set runs every bot with the same 30 career indices (0..29).
- Stipend split: half (idx < 15) pay the stipend, half on the day job.
- One boxer (Lucy from quick_start), Reid hired, FirstWeek skipped. No cash floor (money is the measurement).
- Bots answer c.pro_offer every day (trap: check_pro runs after bouts and week end only).

## Per-bot summary

| bot | seed_set | stip | n | w52_med | w52_p25 | w52_p75 | w104_med | w104_p25 | w104_p75 | signed | door | hf_pick | both_ever |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| YES | 4421 | stip | 15 | 7510 | 6472 | 7965 | -2699 | -4013 | -1477 | 15 | 0 | 12 | 12 |
| YES | 4421 | dayj | 15 | 12110 | 12110 | 12477 | -2417 | -2417 | -2022 | 1 | 0 | 0 | 1 |
| RANK | 4421 | stip | 15 | 2815 | 2482 | 3027 | -3035 | -3233 | -2028 | 4 | 0 | 0 | 14 |
| RANK | 4421 | dayj | 15 | 12110 | 12110 | 12110 | -2417 | -2417 | -2417 | 0 | 0 | 0 | 0 |
| PREP | 4421 | stip | 15 | 6720 | 5965 | 6979 | -3172 | -3583 | -1410 | 13 | 1 | 13 | 13 |
| PREP | 4421 | dayj | 15 | 12110 | 12039 | 12529 | -2417 | -2469 | -1791 | 0 | 0 | 0 | 0 |
| NEVER | 4421 | stip | 15 | 2608 | 1810 | 2815 | -3233 | -3233 | -2383 | 0 | 5 | 0 | 8 |
| NEVER | 4421 | dayj | 15 | 12110 | 12110 | 12110 | -2417 | -2417 | -2417 | 0 | 0 | 0 | 0 |
| AMB | 4421 | stip | 15 | 1170 | 1170 | 1273 | -1505 | -1537 | -1415 | 15 | 0 | 0 | 14 |
| AMB | 4421 | dayj | 15 | 12110 | 11474 | 12110 | -2417 | -2417 | -1972 | 0 | 0 | 0 | 0 |
| YES | 9001 | stip | 15 | 8007 | 6711 | 8639 | -1923 | -2891 | -1036 | 15 | 0 | 13 | 13 |
| YES | 9001 | dayj | 15 | 12110 | 12110 | 12110 | -2417 | -2417 | -2417 | 0 | 0 | 0 | 0 |
| RANK | 9001 | stip | 15 | 2815 | 2815 | 3015 | -3049 | -3222 | -2533 | 2 | 0 | 0 | 14 |
| RANK | 9001 | dayj | 15 | 12110 | 12110 | 12469 | -2417 | -2417 | -1559 | 0 | 0 | 0 | 0 |
| PREP | 9001 | stip | 15 | 6833 | 6182 | 7359 | -2677 | -3701 | -1608 | 14 | 1 | 14 | 14 |
| PREP | 9001 | dayj | 15 | 12110 | 12110 | 12110 | -2417 | -2417 | -2417 | 0 | 0 | 0 | 0 |
| NEVER | 9001 | stip | 15 | 2815 | 2610 | 3015 | -2976 | -3233 | -2507 | 0 | 4 | 0 | 14 |
| NEVER | 9001 | dayj | 15 | 12110 | 12110 | 13055 | -2307 | -2417 | -1661 | 0 | 0 | 0 | 2 |
| AMB | 9001 | stip | 15 | 1370 | 1170 | 2578 | -1437 | -1546 | -1241 | 15 | 0 | 0 | 12 |
| AMB | 9001 | dayj | 15 | 12110 | 12110 | 12110 | -2417 | -2417 | -2417 | 0 | 0 | 0 | 0 |

## Best bot at week 104 (share of careers)

- seed 4421 stip: YES 4/15 (27%), RANK 0/15 (0%), PREP 1/15 (7%), NEVER 0/15 (0%), AMB 10/15 (67%)
- seed 4421 dayj: YES 7/15 (47%), RANK 2/15 (13%), PREP 4/15 (27%), NEVER 0/15 (0%), AMB 2/15 (13%)
- seed 9001 stip: YES 4/15 (27%), RANK 1/15 (7%), PREP 2/15 (13%), NEVER 0/15 (0%), AMB 8/15 (53%)
- seed 9001 dayj: YES 4/15 (27%), RANK 5/15 (33%), PREP 1/15 (7%), NEVER 3/15 (20%), AMB 2/15 (13%)

## Debut win rate by opponent gap

- 1.0 under: 35/42 (83%)
- 1.5 under: 30/52 (58%)

## Ask pick shares (YES bot)

- later2: 0/31 (0%)
- later4: 5/31 (16%)
- softer: 0/31 (0%)
- split: 0/31 (0%)
- price: 1/31 (3%)
- costs: 25/31 (81%)

## AMB morale at signing

- Steady+ (>=50): 0/30 (0%)

## Pass lines (design section 7)

### 1. No bot dominates (>60%) at week 104
- FAIL
### 2. PREP beats YES at w104 by $1,500+
- diff $0 -> FAIL (constant: ProCall.BAND / ProCall.SECOND_TERMS)
### 3. Stipend timing: YES vs NEVER
- stip w52: YES $7559 vs NEVER $2815 -> YES leads
- no-stip w52: NEVER $12110 vs YES $12110 -> YES leads
- no-stip w104: YES $-2417 vs NEVER $-2417 -> NEVER leads
- FAIL (constant: ProCall.LOST_CUT_A_WEEK)
### 4. YES debut loses gym money 40-70%
- 0/31 (0%) -> FAIL (constant: ProCall.PURSE_FLOOR / ProCall.SHORT_TICKET)
### 5. RANK door closes 10-30%
- 0/60 (0%) -> FAIL (constant: Roster.PRO_RETURN_WINS / ProCall.AGE_STOP)
### 6. Debut win rate 65-80% at 1.0, 70-85% at 1.5
- 1.0: 83% (35/42) out
- 1.5: 58% (30/52) out
- FAIL (constant: Roster.PRO_OPP_GAP / ProCall.SOFTER_OPP_ADD)
### 7. Each ask is the best in 10%+ of offers
- later2: 0%
- later4: 16%
- softer: 0%
- split: 0%
- price: 3%
- costs: 81%
- FAIL (constant: ProCall ask constants)
### 8. HF picked 25%+, both together 25-50%
- HF: 55% (52/94) ok
- both: 44% (131/300) ok
- PASS (constant: ProCall.BAND)
### 9. AMB morale Steady+ at signing 70%+
- 0/30 (0%) -> FAIL (constant: ProCall.morale / Recruit.ambition)

Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/turn_pro_probe.gd`

TURNPROBE1 done
