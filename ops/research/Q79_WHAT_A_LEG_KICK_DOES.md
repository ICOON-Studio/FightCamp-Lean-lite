# Q79 - What a landed leg kick does, in both engines

## SIMULATION

Chain from "the region is chosen" to every number a leg strike changes, in order.

**1. Damage and health.** `_apply_landed_effect` (role "damage" or "counter") computes
`magnitude * 0.55 * execution_quality * power_scale` (line 2113) and subtracts it from
the target's health. The leg region carries no special damage modifier - a leg strike
depletes health the same way a head or torso strike does. Health is floored at 0.0
(`maxf(0.0, ...)` line 2117).

**2. Striking score.** The same damage figure is added to `actor["striking_score"]`
(line 2118). This is what the simulation's judges read via `RoundScoring.damage_points`.

**3. Zone credit.** `_credit_zone_hit` (line 2080) tests `region.find("leg") != -1`
and files the hit under zone `"legs"` (line 2084). Karate and taekwondo scoring
profiles price this zone differently from head_hand and body_hand.

**4. Body condition deterioration.** `_apply_body_condition_deterioration` (line 2365)
reduces the specific leg region's condition by `round(damage * BODY_CONDITION_DAMAGE_SCALE)`
where `BODY_CONDITION_DAMAGE_SCALE = 0.6` (line 311). The result is clamped to 0..100
(line 2371). A band transition (green -> amber -> red) fires a morale penalty of
`MORALE_BODY_COMPROMISED = -3.0` (line 327), but only once per transition, never for
repeated hits within the same band (line 2382).

**5. Mobility factor.** `_mobility_factor` (line 2308) averages the two legs' condition
and maps it onto `MOBILITY_FLOOR..1.0` where `MOBILITY_FLOOR = 0.65` (line 317). This
is the single number downstream consumers read.

**6. Initiative.** `_pick_actor_side` (line 1283) multiplies each fighter's
`(speed + fight_iq)` by `_mobility_factor`. A fighter whose legs have been chopped
wins fewer exchanges. The resulting probability is clamped to 0.25..0.75 (line 1288).

**7. Defense.** The exchange resolution (line 1440) multiplies the defender's
`_defender_defense_factor` by `_mobility_factor(target)`. Worn legs make defensive
reads land less often, so the attacker's success_chance rises (clamped 0.1..0.95,
line 1451).

**8. Stoppage.** Accumulated leg-strike damage depletes health. When health reaches
zero, `_check_stoppage` reads `float(target["health"]) <= 0.0` (line 2939) and fires `_finish_fight` with "KO/TKO".

**What the leg does NOT do in simulation.** `_stamina_penalty_factor` (line 2313) reads
torso_core only. `_head_knockdown_bonus` (line 2319) reads head_neck only. The boxing
knockdown and referee-stoppage paths (lines 2408, 2469) are gated on health and head
condition, not leg condition. A leg strike cannot directly trigger a knockdown or a
referee stoppage in this engine.

## REALTIME

Chain from "the region is chosen" to every number a leg strike changes, in order.

**1. Region wear coefficient.** `ImpactModel.REGION_WEAR_COEFFICIENTS` assigns left_leg
and right_leg a coefficient of 0.8 (line 33), vs 1.0 for head_neck and torso_core and
0.6 for arms. `wear_from` (line 115) multiplies `force * contact_coefficient * 0.8 * 0.6`
to produce the wear for the leg region.

**2. Condition subtraction.** The wear is subtracted from the leg region's condition
at line 1788: `condition[region_key] = clampf(before - float(wear[region_key]), 0.0, FULL_CONDITION)`.
Condition is bounded 0..100.

**3. Target stamina drain.** `Stamina.impact_drain(wear_total, ...)` (line 1833) drains
the target's stamina proportional to the summed wear. A leg strike (coefficient 0.8)
costs more stamina than an arm strike (0.6) but less than a head strike (1.0).

**4. Wear stored on the event.** The wear dictionary is stored as `"wear": wear` on the
impact event (line 1874). This is what `RealtimeRoundStats` reads.

**5. Scoring fold.** `RealtimeRoundStats.fold` (line 136) adds `_wear_sum(event.wear)`
to `striking_score`. The leg wear flows directly to the judges via `Scoring.damage_points`.

**6. Zone credit.** `REGION_TO_ZONE` (line 61) maps both left_leg and right_leg to the
`"legs"` scoring zone. The fold increments `hits["legs"]` (line 137).

**7. Corner recovery.** Between rounds (line 852), `Impact.corner_recovery` restores
each region including the legs at `CORNER_RECOVERY_PER_MIN = 4.0` (ImpactModel line 72),
scaled by conditioning and clamped to the missing amount. Leg wear partially reverses
every rest minute.

**What the leg does NOT do in realtime.** `ImpactModel.shock_chance` (line 119) returns
zero for any region other than head_neck and torso_core. A leg strike therefore cannot
trigger `shocked`, cannot trigger a knockdown (line 1750: `if shocked:`), cannot trigger
a flash knockdown, and cannot trigger the liver delay path. `_maybe_doctor_stoppage`
(line 1022) checks only `head_neck` condition against `DOCTOR_HEAD_CONDITION = 15.0`.
A leg strike cannot directly cause a stoppage in this engine. `FightStoppageRead.fold`
(line 41) reads `head_condition` for its head amplifier; leg wear does not amplify the
corner's stoppage read.

## WHAT MOVES WHEN LEGS DOUBLE

**INFERENCE - labelled.** This section reads code, not bouts. Every direction below is
a structural read of the paths above, not a measured prediction.

### Simulation

- **Decision rate.** More leg strikes means more damage absorbed by the legs and less
  by the head. Since knockdowns and referee stoppages are head-gated (lines 2408, 2469),
  shifting damage from head to leg moves fights AWAY from KO/TKO and TOWARD decision.
  Bounded: health depletion at 0 still ends the fight regardless of where the damage
  landed, so the shift is partial, not total.

- **Stoppages (KO/TKO).** Expected to DECREASE. The head takes fewer hits, so fewer
  knockdowns and fewer referee stoppages. The three-knockdown TKO (line 2456) becomes
  rarer. Bounded: cannot go below zero knockdowns.

- **A slower fighter.** The mobility feedback (line 1283, 1440) compounds: a slower
  fighter hit on the legs loses initiative, which means the opponent acts first more
  often, which means more incoming strikes, which means the defense_factor is lower
  (line 1440), which means more of them land. The loop is bounded by MOBILITY_FLOOR
  at 0.65 (line 2309) and by the initiative clamp at 0.25..0.75 (line 1288). A slower
  fighter cannot be reduced below 25% initiative or below 0.65 mobility.

- **Judges' scores.** `striking_score` accumulates the same damage regardless of region
  (line 2118), so the raw damage-points figure does not change per strike. But the
  zone split changes: more hits in "legs", fewer in "head_hand" and "body_hand". Under
  karate/taekwondo profiles that price zones differently, this changes the scorecard.
  Under boxing, the zone split does not matter for points.

### Realtime

- **Decision rate.** Expected to INCREASE. Leg wear contributes to `striking_score`
  (line 136) but cannot trigger knockdowns or stoppages. More leg strikes means more
  scoring without more finish pathways. The fight is more likely to go the distance.
  Bounded: the finish rate cannot go below what head shots already produce.

- **Stoppages.** Expected UNCHANGED or slightly DOWN. The stoppage pathways (knockdown
  from shock, doctor stoppage, three-knockdown rule) are all head-gated. Leg strikes
  do not feed any of them. If leg strikes displace head strikes, finishes decrease.
  If they are additive (more total strikes), finishes stay the same.

- **A slower fighter.** In the realtime engine, the slower fighter's plan bias feeds
  `_region_bias` (line 1197) which sets the leg weight. A plan that targets legs more
  gets more wear on the opponent's legs, which scores via `striking_score` but does
  not slow the opponent through a mobility mechanism (there is no `_mobility_factor`
  in the realtime engine). The slower fighter benefits ONLY through scoring, not
  through the initiative/defense feedback the simulation provides.

- **Judges' scores.** `striking_score` rises with accumulated leg wear. The ten-point-
  must system reads `damage_points` off this score (line 796). A round with heavy leg
  work scores the attacker higher, but the damage-per-strike is 80% of a head strike's
  wear (coefficient 0.8 at ImpactModel line 33), so the per-strike scoring is lower.
  Corner recovery (line 852) partially undoes leg wear between rounds at 4.0/min, so
  early-round leg work scores less in later rounds.

### What is bounded so it cannot run away

| Consequence | Bound | Value |
|---|---|---|
| Simulation mobility | MOBILITY_FLOOR | 0.65 |
| Simulation initiative | clamp | 0.25..0.75 |
| Simulation defense | success_chance clamp | 0.1..0.95 |
| Simulation body condition | clampi | 0..100 |
| Simulation morale | one-shot per band | -3.0 per transition |
| Realtime region condition | clampf | 0.0..100.0 |
| Realtime wear per strike | force clamp * coefficients | max ~0.48 per clean leg hit |
| Realtime corner recovery | CORNER_RECOVERY_PER_MIN | 4.0/min |

## ANCHORS ON DISK

### What IS on disk (J20_THE_VALIDATION_CORPUS.md)

- **Outcome mix** (line 42, D4): All-time clean ~47% decision / ~33% KO/TKO / ~19% sub.
  Modern standard divisions (2019-May 2026): 51.1 / 31.7 / 17.2. HW KO/TKO ~52%;
  WSW decision ~67%. **A doubled leg share that pushes fights toward decision is
  checkable against this.**

- **Knockdown rate** (line 43, D5): 35.1% of 8,337 UFC bouts had at least one official
  KD. Mean combined KDs/fight ~0.41-0.52 by division. **If doubling legs reduces
  knockdowns (simulation, head-gated), the new rate is checkable against 35.1%.**

- **Target mix** (line 41, D3): League ~61-65% head / 19-23% body / 14-18% leg.
  Division spread on head is only ~4 points. **This is what S2 aims at; Q79's census
  is the denominator for reading the moved number.**

- **Decision rate** (line 157): 47.3% clean-result decision rate across 8,597 fights.
  **Checkable after S2.**

- **Pace** (line 29): Engine was measured at 2.26x real fighter pace. **Doubled legs
  add volume if they are additive; the pace figure is the check.**

### What is NOT on disk

- **A leg-kick stoppage rate.** No published figure maps a leg-strike volume to a
  stoppage probability. The simulation's stoppage paths are head-gated and the
  realtime's are head-gated too; there is no real-fight "leg-kick TKO rate" on disk
  to check against.

- **A mobility loss from leg damage.** No published study gives a numeric mapping from
  accumulated leg strikes to a reduction in movement speed, initiative or defensive
  effectiveness. The simulation's MOBILITY_FLOOR of 0.65 is authored, not sourced.

- **A leg-wear scoring weight.** No published figure says a leg strike should score
  0.8 of a head strike's wear. The ImpactModel coefficient is authored.

- **A corner recovery rate for legs.** No published figure says the leg should recover
  at the same 4.0/min as the head. The CORNER_RECOVERY_PER_MIN is a flat rate applied
  uniformly to all regions.
