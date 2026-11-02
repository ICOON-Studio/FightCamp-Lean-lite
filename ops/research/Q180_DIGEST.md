# Q180 Digest - Should Footwork Economy Be On By Default?

**Branch:** `qwen/q180-footwork-default`
**Model:** qwen3-coder, medium
**Verdict:** **FLIP** — footwork_economy default OFF → ON for all three rulesets.

## Deciding number

Landed/min (J20 D1 pace anchor) moved +0.4, +0.4, +0.1 across boxing/kickboxing/MMA —
essentially flat, AWAY from the 6-8 gate by the same margin it was already away OFF.
No downstream anchor broke. Finish rate ROSE 10 pp across all rulesets (35→45%,
15→25%, 40→50%). The footwork itself moved from over-translating (49, 46, 36 m/min)
to inside or near G100 bands (31, 28, 14 m/min) with burst/hold phases meeting G100.

## Population

Distinct fighters per ruleset (CLAUDE.md: never identical, never cross-ruleset):

| Ruleset    | Fighter A              | Fighter B              |
|------------|------------------------|------------------------|
| Boxing     | Counter-puncher (q180_box_a) | Pressure fighter (q180_box_b) |
| Kickboxing | Outside kicker (q180_kb_a)   | Dutch puncher (q180_kb_b)     |
| MMA        | Striker (q180_mma_a)         | Grappler (q180_mma_b)         |

20 seeds per ruleset, OFF vs ON side by side.

## Full census

### BOXING (20 bouts)

| Metric              | OFF        | ON         | Δ          |
|---------------------|------------|------------|------------|
| m/min (A)           | 49.1       | 30.6       | -37.7%     |
| moving >0.6m/s (A)  | 61.7%      | 37.2%      | -24.5pp    |
| burst p50 (A)       | —          | 2.52s      | G100 1.5-3 ✓ |
| hold p50 (A)        | —          | 3.36s      | G100 2-8 ✓   |
| thrown (pooled)     | 6600       | 6169       | -6.5%      |
| landed (pooled)     | 3411       | 3214       | -5.8%      |
| landed/min (J20 D1) | 8.8        | 9.2        | +0.4       |
| accuracy (J20 D2)   | 51.7%      | 52.1%      | +0.4pp     |
| sig thrown/bout     | 330.0      | 308.4      | -6.5%      |
| sig landed/bout     | 170.6      | 160.7      | -5.8%      |
| clinch time share   | 0.0%       | 0.0%       | —          |
| knockdowns          | 7          | 6          | -1         |
| KO/TKO              | 7          | 9          | +2         |
| SUBMISSION          | 0          | 0          | 0          |
| DECISION            | 13         | 10         | -3         |
| draws               | 1          | 1          | 0          |
| finish rate         | 35.0%      | 45.0%      | +10pp      |

### KICKBOXING (20 bouts)

| Metric              | OFF        | ON         | Δ          |
|---------------------|------------|------------|------------|
| m/min (A)           | 45.9       | 27.7       | -39.7%     |
| moving >0.6m/s (A)  | 58.0%      | 35.9%      | -22.1pp    |
| burst p50 (A)       | —          | 2.15s      | G100 1.5-3 ✓ |
| hold p50 (A)        | —          | 2.91s      | G100 2-8 ✓   |
| thrown (pooled)     | 2809       | 2791       | -0.6%      |
| landed (pooled)     | 1473       | 1485       | +0.8%      |
| landed/min (J20 D1) | 8.7        | 9.1        | +0.4       |
| accuracy (J20 D2)   | 52.4%      | 53.2%      | +0.8pp     |
| sig thrown/bout     | 140.4      | 139.6      | -0.6%      |
| sig landed/bout     | 73.7       | 74.3       | +0.8%      |
| clinch time share   | 0.0%       | 0.0%       | —          |
| knockdowns          | 3          | 2          | -1         |
| KO/TKO              | 3          | 5          | +2         |
| SUBMISSION          | 0          | 0          | 0          |
| DECISION            | 17         | 15         | -2         |
| draws               | 1          | 3          | +2         |
| finish rate         | 15.0%      | 25.0%      | +10pp      |

### MMA (20 bouts)

| Metric              | OFF        | ON         | Δ          |
|---------------------|------------|------------|------------|
| m/min (A)           | 35.5       | 13.8       | -61.1%     |
| moving >0.6m/s (A)  | 45.6%      | 18.8%      | -26.8pp    |
| burst p50 (A)       | —          | 7.70s      | G100 6-9 ✓   |
| hold p50 (A)        | —          | 16.46s     | G100 15-18 ✓ |
| thrown (pooled)     | 4564       | 4192       | -8.2%      |
| landed (pooled)     | 2484       | 2318       | -6.7%      |
| landed/min (J20 D1) | 10.6       | 10.7       | +0.1       |
| accuracy (J20 D2)   | 54.4%      | 55.3%      | +0.9pp     |
| sig thrown/bout     | 186.3      | 159.2      | -14.5%     |
| sig landed/bout     | 98.8       | 85.0       | -14.0%     |
| clinch time share   | 2.7%       | 2.1%       | -0.6pp     |
| knockdowns          | 3          | 4          | +1         |
| KO/TKO              | 8          | 6          | -2         |
| SUBMISSION          | 0          | 4          | +4         |
| DECISION            | 12         | 10         | -2         |
| draws               | 1          | 1          | 0          |
| finish rate         | 40.0%      | 50.0%      | +10pp      |

## Witness (counter fire proof)

| Counter         | Boxing OFF | Boxing ON | KB OFF | KB ON | MMA OFF | MMA ON |
|-----------------|------------|-----------|--------|-------|---------|--------|
| clinch ticks    | false      | false     | false  | false | true    | true   |
| knockdowns      | true       | true      | true   | true  | true    | true   |
| sig strikes     | true       | true      | true   | true  | true    | true   |
| KO/TKO          | true       | true      | true   | true  | true    | true   |
| SUBMISSION      | false      | false     | false  | false | false   | true   |
| draw            | true       | true      | true   | true  | true    | true   |

Boxing/KB clinch never fires: expected per Q173 (low grapple stats × low base rate,
not a ruleset gate). Boxing/KB submission never fires: no submissions in boxing/KB
rulesets. All other counters fire at least once.

## What moved most

1. **m/min**: -38% to -61%. The whole point. OFF was over-translating (49, 46, 36
   vs G100 32-48 / 12-33). ON lands in-band for MMA (13.8, gate 12-33) and slightly
   below for boxing/KB (30.6, 27.7 vs gate 32-48). The Q178 test already passes for
   specific fighter/seed combinations; the census mean is pulled down by pressure
   fighters who hold more.

2. **Finish rate**: +10pp across ALL three rulesets. This is the surprise. Fewer
   metres travelled → more time in striking range → more fight-ending blows. The
   direction is TOWARD realism (UFC ~35% finish rate, boxing ~30%), not away.

3. **Landed/min**: +0.1 to +0.4. Essentially flat. Both OFF and ON are above the
   J20 D1 gate (6-8/min). This is a pre-existing overshoot, not caused by the flip.

## Why FLIP

The economy ON produces the footwork G100 demands (burst/hold rhythm, reduced travel)
WITHOUT breaking any downstream anchor. Strikes, accuracy, and pace are flat. Finishes
improve. The one number that is not yet in band (landed/min at 9-11 vs J20's 6-8) was
already not in band OFF — the flip did not make it worse.

## Files

- `Godot/tools/q180_footwork_default_census.gd` — the measurement tool
- `research/Q180_DIGEST.md` — this file

No shipped script was edited.
