# Q164 DIGEST — 10-8 without a knockdown

## What was seen
Boxing bouts score 10-8 rounds at ~25-36% rate, ALL without knockdowns. Real boxing: ~1-2%.

## Measurement (N=40 bouts, 8 rounds each, both arms)
Tool: `tools/q164_round_margins.gd`

### Before fix
| Arm | 10-8 rate | 10-8 with 0 KD | avg point margin | avg damage margin |
|-----|-----------|-----------------|------------------|-------------------|
| RT  | 24.3%     | 24.3%           | 7.6              | 6.43              |
| AT  | 35.8%     | 35.8%           | 11.5             | 11.25             |

### After fix (margin_wide 6→15, damage gate enabled bar=25)
| Arm | 10-8 rate | 10-8 with 0 KD |
|-----|-----------|-----------------|
| RT  | 0.4%      | 0.4%            |
| AT  | 5.4%      | 5.4%            |

## Mechanism found
The task hypothesised the RT fold produces inflated points. **DISPROVED**: the atomic path produces WIDER margins (avg 11.5 vs RT 7.6, ratio 0.7x). Both paths share the same root cause:

1. **`margin_wide=6.0` was set for the historic formula** (damage+control+takedowns×3 ≈ 10-15 pts/round). Boxing's actual scale (damage-only + volume + zones) produces 20-30+ pts/round, so 6.0 fires on nearly every competitive round.

2. **`ten_eight_requires_damage` (ABC 2025 gate) was not enabled for boxing.** The infrastructure existed in `RoundScoring.card()` but the boxing profile didn't use it.

## Fix applied
`assets/data/combat_rulesets.json` boxing profile:
- `margin_wide`: 6.0 → 15.0
- `ten_eight_requires_damage`: false → true
- `ten_eight_damage_bar`: 0.0 → 25.0

## Test state
- **fight_scoring_test**: 3 failures — ALL pre-existing judo (uchi-mata magnitude 19 < ippon threshold 22), unrelated to Q164
- **judge_panel_test**: 2 failures — T11 only (boxing seed 109 went majority→unanimous_draw because 10-8 rounds are now rare; needs seed re-sweep). T4/T8R re-pinned and passing. T5 updated and passing.
- **round_scoring, fight_realtime, career_loop_walk**: pass

## Bugs found (NOT fixed, reported for Claude)
1. **Atomic path knockdown counter inversion** (`FightSimulation.gd:3171-3172`): `knockdowns_a = a["knockdowns_round"]` reads knockdowns A *suffered*, but `card()` expects knockdowns A *scored*. The realtime fold has the correct orientation. The penalty still produces correct results (symmetric comparison) but the detail values are semantically wrong. Fix: swap to `knockdowns_b`/`knockdowns_a` in the detail dict, or swap the fold's orientation.

2. **T11 seed re-sweep needed**: boxing_109 no longer produces a majority decision. The 62-v-64 fixture needs re-scanning to find a new boxing majority seed, or the pair should move to kickboxing (which has majority at seed 182 per the S62 sweep).

## Owned files
- `Godot/tools/q164_round_margins.gd` (new)
- `research/Q164_DIGEST.md` (new)
- `Godot/assets/data/combat_rulesets.json` (boxing profile)
- `Godot/tests/judge_panel_test.gd` (T5 assertion + T4/T8R re-pins)
