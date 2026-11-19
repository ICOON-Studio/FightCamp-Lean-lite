# TURNPROBE3B RESULT - rerun with fork fixes + day-job question (TURNPROBE3B)

Probe run: 2026-11-19T19:47:41. 30 careers/bot x 6 bots x 2 seed sets = 360 careers, 104 weeks each. Wall time: 1783.0 s.

## Population

- Seeds: [4421, 9001]. Each seed set runs every bot with the same 30 career indices (0..29).
- Stipend split: half (idx < 15) pay the stipend, half on the day job.
- Bots: YES, RANK, PREP, NEVER, AMB, TERMS08 (refuses when terms factor < 0.8).

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
| TERMS08 | 4421 | stip | 15 | 7377 | -2362 | 15 | 0 | 12 |
| TERMS08 | 4421 | dayj | 15 | 12110 | -2417 | 0 | 0 | 0 |
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
| TERMS08 | 9001 | stip | 15 | 7232 | -2634 | 15 | 0 | 14 |
| TERMS08 | 9001 | dayj | 15 | 12110 | -2417 | 0 | 0 | 0 |

## Pass lines (design section 7)

### 1. No bot dominates (>60%) at week 104
- Population: 30 careers/bot x 6 bots x 2 seed sets = 360 careers. Objective: gym cash at w104. Seeds: [4421, 9001].
- PASS
### 2. PREP beats YES at w104 by $1,500+ (paired diff)
- Population: 120 paired careers (YES vs PREP, same seed/idx/stip). Objective: gym cash at w104. Seeds: [4421, 9001].
- Paired diffs: 60 careers, median: $0
  - seed 4421 stip idx 0: diff $-1287 (PREP day -1 purse $0, YES day 174 purse $1800)
  - seed 4421 stip idx 1: diff $-1050 (PREP day 174 purse $1800, YES day 174 purse $1800)
  - seed 4421 stip idx 2: diff $-871 (PREP day 244 purse $1800, YES day 174 purse $1800)
- FAIL (constant: ProCall.BAND / ProCall.SECOND_TERMS)
### 3. Stipend timing: YES vs NEVER
- Population: YES and NEVER bots, stipend and day-job splits. Objective: gym cash at w52 and w104. Seeds: [4421, 9001].
- stip w52: YES $7559 vs NEVER $2815
- no-stip w52: NEVER $12110 vs YES $12110
- no-stip w104: YES $-2417 vs NEVER $-2417
- FAIL (constant: ProCall.LOST_CUT_A_WEEK)
### 4. YES debut loses gym money 40-70% (STIPEND DEBUTS ONLY)
- Population: YES bot careers with stipend (idx < 15) that signed. Objective: gym cash change from signing to week after debut vs paired NEVER same span. Seeds: [4421, 9001].
- seed 4421 stip: 10/15 (67%) stipend debuts lost money
- seed 9001 stip: 6/15 (40%) stipend debuts lost money
- Average: 53% -> PASS (constant: ProCall.PURSE_FLOOR / ProCall.SHORT_TICKET)
### 5. RANK door closes 10-30%
- Population: RANK bot careers. Objective: door closed (3 declines). Seeds: [4421, 9001].
- 0/60 (0%) -> FAIL
### 6. Debut win rate PAIRED (same boxer at gaps 0.7, 1.0, 1.5)
- Population: YES bot careers that signed, forked at each gap. Objective: debut win rate per gap. Seeds: [4421, 9001].
- gap 0.7: 94% (29/31)
- gap 1.0: 94% (29/31)
- gap 1.5: 94% (29/31)
- FAIL (constant: Roster.PRO_OPP_GAP / ProCall.SOFTER_OPP_ADD)
### 7. Each ask is the best in 10%+ of offers (fork method)
- Population: YES bot offer snapshots. Objective: which ask yields most gym cash + boxer purse. Seeds: [4421, 9001].
- later2: 19% (6/31)
- later4: 0% (0/31)
- softer: 0% (0/31)
- split: 0% (0/31)
- price: 6% (2/31)
- costs: 74% (23/31)
- no_ask: 0% (0/31)
- price share: 6% (2/31), mean gym cash edge when best: $150
- no_ask reproducibility (twice from one snapshot, same dollar): 100% (31/31)
- FAIL (constant: ProCall ask constants)
### 8. HF picked 25%+, both together 25-50%
- Population: all signed careers (HF pick), all careers (both called). Objective: house choice distribution. Seeds: [4421, 9001].
- HF: 63% (76/121) ok
- both: 43% (156/360) ok
- PASS (constant: ProCall.BAND)
### 9. AMB morale Steady+ at signing 70%+
- Population: AMB bot careers that signed. Objective: morale >= 50 at signing. Seeds: [4421, 9001].
- 1/30 (3%) -> FAIL
### Declines (TERMS08 bot: refuses when terms factor < 0.8)
- Population: TERMS08 bot careers. Objective: how many reach 3 declines (door shut). Seeds: [4421, 9001].
- 0/60 careers reached third decline

## Day-job question (TURNPROBE3B)

For every career at w104: wins, losses, best rank reached, day of first pro call (or none).

| half | n | median_wins | median_losses | best_rank_med | first_call_med | ever_called |
|---|---|---|---|---|---|---|
| stipend | 180 | 10.0 | 3.0 | 3 | d174 | 180/180 |
| day-job | 180 | 6.0 | 2.0 | 4 | d167 | 3/180 |

**Summary**: stipend median wins=10.0 best_rank=3, day-job median wins=6.0 best_rank=4

Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/turn_pro_probe3.gd`

TURNPROBE3B done
