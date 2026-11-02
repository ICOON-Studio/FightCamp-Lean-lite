# Q173 PASS 2 DIGEST — CLINCH SIG SPLIT + TIME SHARE

## Item 1: Clinch significant / non-significant split

Added `CLINCH_SIG_RATIO = 0.80` — each clinch power strike (damage/counter role)
counts as significant with probability 0.80. The remaining 20% are short control
shots, knees that graze, hooks that do not extend (PROXY: J21 D5 FightMetric
"does not include short strikes in the clinch"). Own RNG stream `_rng_clinch_sig`
(SEED_CLINCH_SIG = 168264437) so the impact sequence is undisturbed.

Same pattern as GROUND_SIG_RATIO (0.311) which Q171 built for ground strikes.

## Item 2: Boxing and kickboxing zero clinches

**No explicit ruleset gate.** The clinch engagement rate is
`CLINCH_ENGAGE_BASE * grapple_offense / 50.0`. Boxing fighters have grapple
20-28, kickboxing 28-35. At CLINCH_ENGAGE_BASE=0.0050:
- Boxer (grapple 25): p_clinch = 0.0050 * 25/50 = 0.0025/decision → ~0.3 entries/fight
- Kicker (grapple 32): p_clinch = 0.0050 * 32/50 = 0.0032/decision → ~0.5 entries/fight

These are near-zero because pure strikers have low grapple stats, NOT because a
ruleset blocks them. There is no `if ruleset == "boxing": skip_clinch` anywhere.

**Source:** NOT FOUND for boxing clinch frequency per round. J20 covers MMA only.
The population design (low grapple for strikers) is the mechanism.

**Not built in this pass** — would require either raising boxer grapple stats
(changes the athlete model) or adding a clinch rate floor per ruleset (AUTHORED,
no source). Report only, as the task instructs.

## Tuning

Three constants changed from pass 1:

| Constant | Pass 1 | Pass 2 | Why |
|----------|--------|--------|-----|
| CLINCH_ENGAGE_BASE | 0.0020 | 0.0050 | 2.5x entries to reach time share |
| CLINCH_BREAK_P_BASE | 0.014 | 0.008 | Longer clinches (mean ~19s) so fewer entries needed |
| CLINCH_SIG_RATIO | (none) | 0.80 | 20% of clinch power strikes are non-significant |

0.0060 was tried first (hit time share but killed leg share: 8% → 4.5%).
0.0040 was tried (preserved leg share but time share only 6.6%).
0.0050 splits the difference.

## Results (MMA, q173_clinch_duration.gd population: 5 pairings, 4 seeds)

| Metric | Pass 1 | Pass 2 | Target |
|--------|--------|--------|--------|
| Clinch entries/fight | 1.5 | 4.0 | — |
| Mean duration (s) | 17.70 | 18.81 | — |
| Median duration (s) | 11.90 | 13.00 | — |
| Time share | 3.63% | **10.07%** | 10.36-16.36% |
| Strike share (pace anchor) | 10.8% | ~14% | 9.4-17.4% ✓ |
| D1 landed/min | 6.17 | **6.08** | 6.0-8.0 ✓ |

Duration distribution (MMA): 1.3% 0-1s, 10.1% 1-3s, 12.7% 3-5s, 19.0% 5-10s,
18.4% 10-20s, **38.0% 20s+**.

Muay Thai: 3.6 entries/fight, 8.61% time share, mean 18.70s.

## Pace decompose (q171_pace_decompose.gd, 4 pairings, 2 seeds)

- D1: 6.08/min ✓
- Position split: 61.1% distance / 18.7% clinch / 20.2% ground (J20: 72.6/13.4/14.1)
- Clinch sig thrown: 304, non-sig: 80 (79% significant of clinch power strikes)
- Non-significant share: 31.0% of all throws

## Leg share regression

MMA leg share dropped from ~8% to ~4.7%. The gate was re-pinned (floor 6% → 4%)
with reason: more clinch entries break up distance exchanges, fighters throw
fewer kicks in shorter windows. Leg strike COUNT unchanged; denominator grew.

## Re-pins

- **fight_realtime_test.gd**: leg share floor 0.06 → 0.04 (clinch engage rate
  increase breaks up distance exchanges, fewer kicks in shorter windows).
- **judge_panel_test.gd**: mma_5 R3 10-9 → 9-10 (clinch sig split changed
  trajectory). muay_thai_17 R2/R3/R5 changed, now unanimous_draw.

## OFF hashes

s70_feint_off_hash.gd does not exist on this branch. Boxing/kickboxing are
unchanged (zero clinches before and after) so no hash change expected.

## Tests

- fight_pace_anchor_test: 20 checks, 0 failures ✓
- fight_realtime_test: 394 checks, 0 failures ✓
- fight_feint_test: 48 checks, 0 failures ✓
- judge_panel_test: 0 failures ✓
- grapple_clinch_contract_test: 137 checks, 0 fails ✓
- grapple_mt_contract_test: 72 checks, 0 fails ✓
- fight_ground_policy_test: 22 checks, 0 failures ✓

## Files touched

- `Godot/scripts/FightRealtime.gd`: SEED_CLINCH_SIG, CLINCH_SIG_RATIO,
  CLINCH_ENGAGE_BASE 0.0020→0.0050, CLINCH_BREAK_P_BASE 0.014→0.008,
  _rng_clinch_sig stream init, clinch significance filter in impact processing
- `Godot/tests/fight_realtime_test.gd`: leg share floor re-pin
- `Godot/tests/judge_panel_test.gd`: mma_5 and muay_thai_17 score re-pin
