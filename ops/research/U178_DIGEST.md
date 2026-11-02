# U178 Digest — MMA leg-strike share (footwork ON)

## Population
Q183 MMA census fixtures: three style-differentiated pairings (striker/grappler, counter/wrestler, thai kicker/scrambler) × 30 seeds, `footwork_economy` ON.

## Where legs were lost (before fix)
Instrument: `Godot/tools/u178_leg_share_census.gd` (baseline at `MMA_LEG_REGION_SELECT_MULT` absent).

| Metric | Value | Divisor |
|--------|-------|---------|
| Leg share of landed **significant** strikes | **6.3%** (571/9002) | all sig landed |
| Leg-target kick attempts | 21.3% of kicks | all kick attempts |
| Leg kick land rate | 54.1% | leg-target kick attempts |
| Leg kicks by band | 32% LONG / 45% MID / 23% POCKET | leg-target kick attempts |

**Diagnosis:** Legs were lost at **technique selection**, not range. Kicks are thrown at LONG/MID, but ~79% of kick attempts aimed at head/torso; `TARGET_WEIGHTS` and plan `target_bias` alone do not move the delivered mix enough (see FightRealtime comment at :835).

## Fix (MMA-only)
`FightRealtime` passes `mma_leg_region_mult` / `mma_body_kick_mult` into `FightMoves.select` (joint walk). Leg boost applies only at **LONG/MID** bands (kicking range), with a small body-kick down-weight.

## After fix (same census)
| Metric | Before → After |
|--------|----------------|
| Leg share of landed SIG | **6.3% → 13.5%** (1269/9384) |
| Leg-target kick attempts | 21.3% → **36.8%** of kicks |
| C85 fixture (sig landed, seeds 17001–17020) | **~5% landed-all → 13.6% sig** |

Head remains the **top** sig target bucket on the C85 fixture; kickboxing ruleset does not receive the MMA selection keys.

## Tests
`fight_realtime_test.gd` C85: MMA leg share gated on **significant** landed strikes in J20 D3 band 12–18%; head > body and head > leg.

## U178B — leg share without losing bout m/min (2026-09-26)

### Mechanism (measured before fix)
U178 joint-walk `mma_leg_region_mult` at 2.55 reweighted **P(technique)** as well as P(region|technique). That desynced downstream RNG; on Q177 MMA seed 4242 it did **not** cut standing `fe_cooldown` share (~64% of standing ticks either way) or standing m/min (~21 vs ~20). It **inflated ground stance share** in the bout m/min **divisor** (active fight seconds): standing 77%→53%, ground ticks 3400→8029, so bout m/min 14.6→11.2 while leg sig share rose.

### Fix (selection stage)
`FightMoves._select_mma_technique_then_region`: technique marginal uses MMA region mult **only on standing kicks at LONG/MID**; region pass on the chosen move with the same rule; one `roll`, golden-ratio split for region (same pattern as ROLE_PRIORITY stage 2). `MMA_LEG_REGION_SELECT_MULT` stays 2.55.

### After U178B (same instruments)
| Gate | Result |
|------|--------|
| C85 MMA sig leg share (20 seeds) | **13.6%** (12–18% band) |
| `fight_footwork_economy_test` MMA ON seed 4242 | **16.1 m/min** (floor 12) |
| `fight_realtime_test` | **6 fails** (JUDO rows only; same ceiling as pre-U178B master) |
