# TURNPROBE2 RESULT - measure turning pro's three failing lines the right way

Probe run: 2026-11-19T12:02:04. 30 careers/bot x 5 bots x 2 seed sets = 300 careers, 104 weeks each. Wall time: 1327.0 s.

## Population

- Seeds: [4421, 9001]. Each seed set runs every bot with the same 30 career indices (0..29).
- Stipend split: half (idx < 15) pay the stipend, half on the day job.

## Per-bot summary

| bot | seed_set | stip | n | w52_med | w104_med | signed | door | hf_pick |
|---|---|---|---|---|---|---|---|---|
| YES | 4421 | stip | 15 | 7510 | -2699 | 15 | 0 | 12 |
| YES | 4421 | dayj | 15 | 12110 | -2417 | 1 | 0 | 0 |
| RANK | 4421 | stip | 15 | 2815 | -3165 | 3 | 0 | 0 |
| RANK | 4421 | dayj | 15 | 12110 | -2417 | 0 | 0 | 0 |
| PREP | 4421 | stip | 15 | 6714 | -3172 | 12 | 2 | 12 |
| PREP | 4421 | dayj | 15 | 12110 | -2417 | 0 | 0 | 0 |
| NEVER | 4421 | stip | 15 | 2608 | -3233 | 0 | 6 | 0 |
| NEVER | 4421 | dayj | 15 | 12110 | -2417 | 0 | 0 | 0 |
| AMB | 4421 | stip | 15 | 1170 | -1504 | 15 | 0 | 0 |
| AMB | 4421 | dayj | 15 | 12110 | -2417 | 0 | 0 | 0 |
| YES | 9001 | stip | 15 | 8006 | -1923 | 15 | 0 | 13 |
| YES | 9001 | dayj | 15 | 12110 | -2417 | 0 | 0 | 0 |
| RANK | 9001 | stip | 15 | 2882 | -3049 | 2 | 0 | 0 |
| RANK | 9001 | dayj | 15 | 12110 | -2417 | 0 | 0 | 0 |
| PREP | 9001 | stip | 15 | 6833 | -2823 | 13 | 1 | 13 |
| PREP | 9001 | dayj | 15 | 12110 | -2417 | 0 | 0 | 0 |
| NEVER | 9001 | stip | 15 | 2815 | -2809 | 0 | 3 | 0 |
| NEVER | 9001 | dayj | 15 | 12110 | -2307 | 0 | 0 | 0 |
| AMB | 9001 | stip | 15 | 1370 | -1444 | 15 | 0 | 0 |
| AMB | 9001 | dayj | 15 | 12110 | -2417 | 0 | 0 | 0 |

## Pass lines (design section 7)

### 1. No bot dominates (>60%) at week 104
- FAIL
### 2. PREP beats YES at w104 by $1,500+ (paired diff)
- Paired diffs: 60 careers, median: $0
  - seed 4421 stip idx 0: diff $-1287 (PREP day -1 purse $0, YES day 174 purse $1800)
  - seed 4421 stip idx 1: diff $-1050 (PREP day 174 purse $1800, YES day 174 purse $1800)
  - seed 4421 stip idx 2: diff $-871 (PREP day 244 purse $1800, YES day 174 purse $1800)
- FAIL (constant: ProCall.BAND / ProCall.SECOND_TERMS)
### 3. Stipend timing: YES vs NEVER
- stip w52: YES $7559 vs NEVER $2815
- no-stip w52: NEVER $12110 vs YES $12110
- no-stip w104: YES $-2417 vs NEVER $-2417
- FAIL (constant: ProCall.LOST_CUT_A_WEEK)
### 4. YES debut loses gym money 40-70% (debut's own money)
- seed 4421 stip: 10/15 (67%) debuts lost money
- seed 4421 dayj: 0/1 (0%) debuts lost money
- seed 9001 stip: 6/15 (40%) debuts lost money
- seed 9001 dayj: 0/0 (0%) debuts lost money
- Average: 27% -> FAIL (constant: ProCall.PURSE_FLOOR / ProCall.SHORT_TICKET)
### 5. RANK door closes 10-30%
- 0/60 (0%) -> FAIL
### 6. Debut win rate 65-80% at 1.0, 70-85% at 1.5
- 1.0: 80% (33/41) out
- 1.5: 60% (30/50) out
- FAIL (constant: Roster.PRO_OPP_GAP / ProCall.SOFTER_OPP_ADD)
### 7. Each ask is the best in 10%+ of offers (fork method)
- later2: 23% (7/31)
- later4: 3% (1/31)
- softer: 0% (0/31)
- split: 0% (0/31)
- price: 6% (2/31)
- costs: 68% (21/31)
- no_ask: 0% (0/31)
- FAIL (constant: ProCall ask constants)
### 8. HF picked 25%+, both together 25-50%
- HF: 55% (50/91) ok
- both: 43% (130/300) ok
- PASS (constant: ProCall.BAND)
### 9. AMB morale Steady+ at signing 70%+
- 1/30 (3%) -> FAIL

Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/turn_pro_probe2.gd`

TURNPROBE2 done
