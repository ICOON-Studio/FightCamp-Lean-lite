# Q191 DIGEST — DOES A HIRED PARTNER ACTUALLY FIGHT LIKE THE OPPONENT?

**Status:** Complete. Instrument built, run, findings reported.
**Date:** 2026-09-26.
**Branch:** `qwen/q191-partner-likeness`.
**Owned files:** `Godot/tools/q191_partner_likeness.gd`, this digest.

## Population

10 (fighter, opponent) pairs per ruleset (boxing, kickboxing, mma), both men built by `FightOpponentGenerator.generate_offer_opponent`, the opponent given a real `fight_plan` from `FightPlans.plans_for_ruleset`. Three arms per pair, same fighter, all run as light spars:

- **REFERENCE:** fighter vs the opponent himself (with his fight_plan).
- **MATCHED:** fighter vs `SparPartnerMarket.candidates(fighter, spec, level, seed)[0]` with spec = opponent's stance, height, discipline, and `fight_plan` copied from the opponent — exactly as `GameState.get_spar_partner_offers` does.
- **CONTROL:** fighter vs `candidates(fighter, {}, level, seed)[0]` with NO fight_plan copied.

Per bout the OTHER man's (B side) profile is folded from `FightBroadcast.round_stats`: output/min, jab share, power share, kick share (KB/MMA), td attempts/round. Normalised L1 distance MATCHED→REF and CONTROL→REF per ruleset.

## Liveness check (the trap)

Before reporting any "no difference", the instrument shows that the profile columns MOVE between two very different boxing opponents (pressure fighter vs out-boxer): L1 = 0.051. A dead column would read 0.000. The columns are alive.

## Three-arm table

| Ruleset     | Matched closer | p50 matched | p50 control | Verdict            |
|-------------|---------------|-------------|-------------|--------------------|
| Boxing      | 5/10          | 0.050       | 0.047       | NO CLEAR ADVANTAGE |
| Kickboxing  | 7/10          | 0.045       | 0.055       | MATCHED WINS       |
| MMA         | 5/10          | 0.065       | 0.074       | MIXED (p50 edge)   |

## What it means for the feature

The sparring-partner market (S87/S88) sells "a man who fights like him". The finding is:

- **Kickboxing: the feature works.** 7/10 pairs have the matched partner fighting closer to the opponent than a random partner. p50 distance is 0.045 vs 0.055 (18% closer). The fight_plan copy + stance/height match produces a measurably similar fighter.
- **Boxing: the feature is weak.** 5/10 is a coin flip, p50 is nearly equal (0.050 vs 0.047). The matched partner fights no more like the opponent than a random one. This may be because boxing plans are more similar to each other (all four are punch-based variations) so the fight_plan copy moves the profile less.
- **MMA: mixed.** 5/10 by count, but p50 is 0.065 vs 0.074 (12% closer). The variance in MMA (striker vs grappler vs wrestler) is high, and the partner's own stats/technique palette (randomly generated) may swamp the fight_plan signal.

## Recommendation

The feature delivers what it sells in kickboxing, partially in MMA, and not reliably in boxing. If the operator wants to strengthen it:

1. **Tighten the stat match.** The partner's stats are currently generated from scratch (SparPartnerMarket._generate_stats). Jittering them toward the opponent's stats (not just stance/height) would increase likeness.
2. **Copy the technique palette.** The partner's technique_progress is his own random draw. Copying the opponent's learned techniques (or a subset) would make him throw the same shots.
3. **Boxing may need plan differentiation.** If all four boxing plans produce similar profiles, the plan copy is not a strong lever. Measuring the L1 between plans (as the liveness check does for two of them) would show whether the plans are distinct enough.

## Raw output

```
--- boxing (10 pairs, 8 rounds, 4 plans available) ---
  pair  0  plan=boxing_out_boxer                ref=[5.35 0.32 0.68 0.00 0.00]  M=0.007  C=0.051  M<C
  pair  1  plan=boxing_pressure                 ref=[7.10 0.09 0.91 0.00 0.00]  M=0.006  C=0.067  M<C
  pair  2  plan=boxing_boxer_puncher            ref=[5.74 0.20 0.80 0.00 0.00]  M=0.048  C=0.049  M<C
  pair  3  plan=boxing_counter_puncher          ref=[6.96 0.25 0.75 0.00 0.00]  M=0.055  C=0.016  C<=M
  pair  4  plan=boxing_out_boxer                ref=[5.67 0.20 0.80 0.00 0.00]  M=0.080  C=0.039  C<=M
  pair  5  plan=boxing_pressure                 ref=[4.53 0.00 1.00 0.00 0.00]  M=0.116  C=0.109  C<=M
  pair  6  plan=boxing_boxer_puncher            ref=[6.16 0.26 0.74 0.00 0.00]  M=0.008  C=0.034  M<C
  pair  7  plan=boxing_counter_puncher          ref=[5.26 0.21 0.79 0.00 0.00]  M=0.052  C=0.018  C<=M
  pair  8  plan=boxing_out_boxer                ref=[5.48 0.28 0.72 0.00 0.00]  M=0.054  C=0.047  C<=M
  pair  9  plan=boxing_pressure                 ref=[6.65 0.07 0.93 0.00 0.00]  M=0.021  C=0.048  M<C
  SUMMARY  matched_closer=5/10  p50_matched=0.050  p50_control=0.047

--- kickboxing (10 pairs, 3 rounds, 3 plans available) ---
  pair  0  plan=kickboxing_dutch_pressure       ref=[7.82 0.16 0.84 0.07 0.00]  M=0.037  C=0.036  C<=M
  pair  1  plan=kickboxing_thai_kicker          ref=[7.36 0.19 0.81 0.12 0.00]  M=0.065  C=0.050  C<=M
  pair  2  plan=kickboxing_counter_striker      ref=[5.91 0.15 0.85 0.03 0.00]  M=0.045  C=0.037  C<=M
  pair  3  plan=kickboxing_dutch_pressure       ref=[8.09 0.16 0.84 0.13 0.00]  M=0.045  C=0.110  M<C
  pair  4  plan=kickboxing_thai_kicker          ref=[6.45 0.18 0.82 0.24 0.00]  M=0.098  C=0.149  M<C
  pair  5  plan=kickboxing_counter_striker      ref=[3.78 0.11 0.89 0.00 0.00]  M=0.036  C=0.098  M<C
  pair  6  plan=kickboxing_dutch_pressure       ref=[7.91 0.22 0.78 0.18 0.00]  M=0.053  C=0.060  M<C
  pair  7  plan=kickboxing_thai_kicker          ref=[6.64 0.25 0.75 0.13 0.00]  M=0.032  C=0.034  M<C
  pair  8  plan=kickboxing_counter_striker      ref=[6.64 0.15 0.85 0.03 0.00]  M=0.016  C=0.020  M<C
  pair  9  plan=kickboxing_dutch_pressure       ref=[8.18 0.09 0.91 0.15 0.00]  M=0.057  C=0.095  M<C
  SUMMARY  matched_closer=7/10  p50_matched=0.045  p50_control=0.055

--- mma (10 pairs, 3 rounds, 4 plans available) ---
  pair  0  plan=mma_sprawl_and_brawl            ref=[9.66 0.09 0.91 0.30 0.67]  M=0.070  C=0.074  M<C
  pair  1  plan=mma_wrestle_gnp                 ref=[10.53 0.05 0.95 0.03 0.33]  M=0.093  C=0.084  C<=M
  pair  2  plan=mma_submission_grappler         ref=[10.47 0.10 0.90 0.02 0.67]  M=0.038  C=0.071  M<C
  pair  3  plan=mma_clinch_boxer                ref=[7.83 0.04 0.96 0.10 0.33]  M=0.060  C=0.117  M<C
  pair  4  plan=mma_sprawl_and_brawl            ref=[8.36 0.02 0.98 0.14 2.00]  M=0.045  C=0.125  M<C
  pair  5  plan=mma_wrestle_gnp                 ref=[4.89 0.07 0.93 0.00 0.33]  M=0.087  C=0.080  C<=M
  pair  6  plan=mma_submission_grappler         ref=[8.41 0.13 0.87 0.01 0.00]  M=0.071  C=0.069  C<=M
  pair  7  plan=mma_clinch_boxer                ref=[11.46 0.04 0.96 0.05 0.67]  M=0.057  C=0.067  M<C
  pair  8  plan=mma_sprawl_and_brawl            ref=[10.76 0.07 0.93 0.16 2.67]  M=0.087  C=0.074  C<=M
  pair  9  plan=mma_wrestle_gnp                 ref=[8.35 0.09 0.91 0.13 1.00]  M=0.045  C=0.015  C<=M
  SUMMARY  matched_closer=5/10  p50_matched=0.065  p50_control=0.074

--- LIVENESS CHECK (boxing, two very different opponents) ---
  pressure  out/min=6.32  jab=0.11  power=0.89  kick=0.00  td/rd=0.00
  out-boxer out/min=7.18  jab=0.23  power=0.77  kick=0.00  td/rd=0.00
  L1 between them = 0.051 (if 0.000 the column is dead)
```
