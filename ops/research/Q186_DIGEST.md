# Q186 DIGEST — WHY KICKBOXERS ARE NOT GETTING HURT (KB HEAD DAMAGE PER MINUTE)

Owner: qwen. Branch `qwen/q186-kb-head-damage`. 2026-09-26.

## The cause (per-bout numbers hide per-minute cause)

Q184 found KB finishes at 6.7% vs Glory's 33% (G108, n=201). The per-minute
strike rate is the same (KB 8.2/min, boxing 7.8/min), so the gap is not volume.

The census (90 bouts per ruleset, 30 seeds × 3 matchups) found:

| Metric | Boxing (n=90, 1896 min) | Kickboxing (n=90, 790 min) |
|---|---|---|
| Head strikes/min | 5.0 (punch 3.3) | 4.2 (punch 2.6, kick 0.6) |
| Shock/head strike (punch) | 0.0287 | 0.0267 |
| Shock/head strike (kick) | n/a | 0.0239 |
| Shocked % (punch) | 2.26% | 1.78% |
| KD/100 head strikes (punch) | 0.24 | 0.10 |
| Avg head condition at bell | 63.2 | 85.1 |
| Finish % | 35.6% | 6.7% |

**Per-strike force is identical** (punch ~0.66 both rulesets). **Per-strike wear
is identical** (~1.37 both). The engine treats all techniques identically in
the shock formula — a head kick and a jab with the same force produce the same
shock. Two causes:

1. **No technique-class differentiation.** In real KB, head kicks are the
   primary fight-ending weapon (~70% of Glory KOs from kicks, G108). The
   engine's `ImpactModel.shock_chance` has no technique-class input.
2. **Head accumulates wear too slowly in 9-minute bouts.** Boxing's 24 minutes
   at the same per-strike wear reaches head condition 63.2. KB's 9 minutes
   only reaches 85.1, making 91% of KB knockdowns flash-class (instant
   recovery) because the head is still "healthy" (>80).

## The fix (KB-scoped, two levers)

### Lever 1: Technique-class shock multiplier

`TECHNIQUE_SHOCK_MULTIPLIER` in FightRealtime.gd — applied AFTER
`ImpactModel.shock_chance` and the broken-base gain, only when `ruleset_id ==
"kickboxing"`. Boxing and MMA are byte-identical.

```
punch: 1.5, kick: 4.0, knee: 3.0, elbow: 2.0, combination: 1.0, movement: 1.0
```

### Lever 2: KB head wear multiplier

`KB_HEAD_WEAR_MULTIPLIER = 2.5` — applied to `head_neck` wear only, only in
kickboxing. Matches the 10 oz glove / 3-round format where heads deteriorate
faster than boxing's 16 oz / 8-round format.

### Corner stoppage redesign

Tied to EVIDENCE, not a raw condition number:
- Threshold raised from 75 to 80
- Requires `knockdowns_total > 0` (a knockdown in the bout)
- A corner acts on what they SEE — a man who was dropped and whose head is
  going — not on an abstract meter

## Results

| Metric | Before | After | Target |
|---|---|---|---|
| KB finish % | 6.7% | **28.9%** | 20-40% ✓ |
| KB KO % | 2.2% | 17.8% | — |
| KB standing TKO % | 0% | 11.1% | — |
| KB shocks/bout | 0.79 | 1.79 | — |
| KB KD/bout | 0.04 | 0.18 | — |
| KB flash KD % | 91% | 25% | — |
| KB head at bell | 85.1 | 52.8 | — |
| Boxing finish % | 35.6% | **35.6%** | unchanged ✓ |
| MMA finish % | 40.0% | **40.0%** | unchanged ✓ |

## Test results

- `fight_kb_corner_stoppage_test.gd`: 4/4 PASS (updated for Q186 evidence rule)
- Parse gate: 3/3 PASS (FightRealtime.gd, corner stoppage test, census tool)
- Tier tests: pre-existing failures from GameState.gd TitleHonours parse error
  (not caused by Q186). fight_scoring_test and fight_realtime_test were already
  failing on 2026-09-26 master per the task file.

## Files touched

- `Godot/scripts/FightRealtime.gd` — TECHNIQUE_SHOCK_MULTIPLIER,
  KB_HEAD_WEAR_MULTIPLIER, KB-scoped shock application, KB-scoped head wear
  application, corner stoppage redesign
- `Godot/tests/fight_kb_corner_stoppage_test.gd` — updated for new threshold
  (80) and evidence rule (knockdowns_total > 0)
- `Godot/tools/q186_kb_head_damage_census.gd` — new census tool, per-technique-
  class head strike effectiveness

## Anchors

- G108 (Glory, n=201): 33% finish rate — KB now at 28.9%, in band
- Smith et al. 2009 (UFC KO analysis): head kicks 3-5× punch KO probability
  per strike — addressed by technique-class multiplier
- Boxing 35.6% and MMA 40.0% unchanged (KB-scoped fix)
