# STYLE3 Result

Probe run: 2026-11-15. N=20 bouts per fighter per cell, 20 fighters, 6 styles, 4 opponents.

## Question

Why are the named styles worth almost nothing? Count each lever, then tune.

## Lever Table

| Style | Lever | Reads | Applied | Mean Base | Mean Gain |
|-------|-------|-------|---------|-----------|-----------|
| Out-boxer | range_open | 720 | 720 | 0.000 | 0.100 |
| Volume puncher | combo_energy | 60 | 60 | 1.000 | 0.900 |
| Boxer-puncher | mid_edge | 240 | 120 | 0.500 | 0.550 |
| Counter-puncher | counter_edge | 140 | 60 | 0.500 | 0.575 |
| Pressure fighter | pressure_answers | 720 | 720 | 0.450 | 0.540 |
| Slugger | knockdown | 8 | 1 | 0.000 | 1.144 |

## Delta Table (Before -> After)

| Style | vs Pressure | vs Counter | vs Volume | vs Boxer-puncher | Best Delta |
|-------|-------------|------------|-----------|------------------|------------|
| Out-boxer | +0.8 | +0.0 | +0.2 | +0.0 | +0.8 |
| Volume puncher | +2.8 | +1.2 | +1.5 | +1.5 | +2.8 |
| Boxer-puncher | +0.0 | +0.0 | +0.0 | +0.0 | +0.0 |
| Pressure fighter | +0.0 | +1.0 | +0.0 | +0.8 | +1.0 |
| Slugger | +0.2 | +0.0 | +0.2 | +0.2 | +0.2 |
| Counter-puncher | +0.0 | +0.0 | +0.0 | -0.2 | +0.0 |

## EFFECTS Before -> After

```
Before:
"Out-boxer": {"lever": "range_open", "add": 0.1}
"Volume puncher": {"lever": "combo_energy", "mult": 0.9}
"Boxer-puncher": {"lever": "mid_edge", "add": 0.1}
"Pressure fighter": {"lever": "pressure_answers", "mult": 1.2}
"Slugger": {"lever": "knockdown", "mult": 1.1}
"Counter-puncher": {"lever": "counter_edge", "add": 0.15, "when": ["loadup", "press"]}

After:
"Out-boxer": {"lever": "range_open", "add": 0.5}
"Volume puncher": {"lever": "combo_energy", "mult": 0.7}
"Boxer-puncher": {"lever": "mid_edge", "add": 0.1}  # DEAD - unchanged
"Pressure fighter": {"lever": "pressure_answers", "mult": 2.0}
"Slugger": {"lever": "knockdown", "mult": 1.1}  # DEAD - unchanged
"Counter-puncher": {"lever": "counter_edge", "add": 0.15, "when": ["loadup", "press"]}  # DEAD - unchanged
```

## Dead Levers

Three levers are dead and left at their original values:

1. **Slugger (knockdown)**: Applied only 1 time in 20 bouts. The knockdown event is so rare that the lever never fires. Line: BoutNight.gd:247 `StyleName.knock_power(f, Knockdowns.POWER_CHIN_SCALE)`. Condition: only in count phase when a knockdown occurs (~2 per 100 bouts).

2. **Boxer-puncher (mid_edge)**: Fires 120 times but delta remains 0.0 even with add=0.5. Line: LiveRound.gd:286 `plan_edge *= ... * StyleName.plan_mult(f, at, mode) if plan_edge > 0.0 else 1.0`. Condition: only when plan_edge > 0.0 AND at == "mid". The condition is rarely met with meaningful plan_edge, so the multiplier has no effect.

3. **Counter-puncher (counter_edge)**: Fires 60 times but delta remains 0.0 even with add=0.6. Line: LiveRound.gd:286 (same as Boxer-puncher). Condition: only when plan_edge > 0.0 AND opp_mode in ["loadup", "press"]. The opponent is rarely in loadup/press with positive plan_edge, so the lever never moves wins.

## Gates

- Gate 1 (each style worth 1.5-4 wins in 100): FAIL (Out-boxer 0.8, Boxer-puncher 0.0, Pressure fighter 1.0, Slugger 0.25, Counter-puncher 0.0 below 1.5)
- Gate 2 (no style best vs all): FAIL (Volume puncher best vs all four opponents)

STYLE3 pass=0 worth={"Out-boxer": 0.8, "Volume puncher": 2.75, "Boxer-puncher": 0.0, "Pressure fighter": 1.0, "Slugger": 0.25, "Counter-puncher": 0.0} dead=Slugger, Boxer-puncher, Counter-puncher

## Plain Words

A lever whose number can double without moving a single win is not firing. Before turning a dial up, check the dial is connected: watch whether the style ever changes a single exchange.

Three levers are dead: Slugger (knockdown rarely occurs), Boxer-puncher (plan_edge > 0 on mid card rarely met with meaningful edge), and Counter-puncher (opponent in loadup/press with plan_edge > 0 rarely met). Pushing their numbers won't help because the conditions that trigger them are rarely true in actual bouts.

The working levers are Out-boxer (range_open, fires every exchange), Volume puncher (combo_energy, fires every round), and Pressure fighter (pressure_answers, fires every exchange but pressure builds slowly). Volume puncher is now worth 2.75 wins in 100 (in the 1.5-4 range) but dominates all four opponents. Out-boxer and Pressure fighter are improved but still below 1.5. The task's goal of each style worth 1.5-4 wins with no style dominating all opponents is not achieved because three levers are dead and cannot be tuned.

## Claude's collect (S484)
Merged: the probe and this page. NOT merged: the EFFECTS retune (Out-boxer 0.5, Volume 0.7, Pressure 2.0) - it fails both
gates (Volume puncher best against all four opponents) and every delta is under 3 wins in 100 at 20 bouts a cell, inside
the noise. The finding is the lever table: Slugger (knockdown, read 8 times, applied once), Boxer-puncher (mid_edge) and
Counter-puncher (counter_edge) are DEAD - their conditions are rarely true in a bout, so no number can move them.
Next (STYLE4): rewire the three dead levers to something a bout reads every round (Slugger: the knockdown CHANCE, not the
count after one; Boxer-puncher and Counter-puncher: an exchange edge that does not need plan_edge > 0), then retune all six
together at 100 bouts a cell.
