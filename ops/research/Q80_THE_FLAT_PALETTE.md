# Q80 — THE FLAT PALETTE: EVERY TECHNIQUE IS THROWN ABOUT AS OFTEN AS EVERY OTHER

## HOW A TECHNIQUE IS CHOSEN

The chain from "a fighter throws" to "this technique" passes through eight
weights. None of them distinguishes one technique from another of the same
role at the same range.

**1. Arsenal filter.** `DEFAULT_ARSENAL_MAX_TIER := 2` (FightMoves.gd:312).
A fighter with no `technique_progress` record — every seeded test, every
generated opponent — knows tier 1 and 2 only. This is the ceiling, not a
suggestion.

**2. Node admission.** `move_from_node` (FightMoves.gd:568) refuses any node
whose `match.role` is not in `STRIKE_ROLES` (`["setup", "damage", "counter"]`,
line 87), or whose `match.effects` intersects `GRAPPLE_EFFECTS` (line 109,
54 names from `takedown` to `disarm_open`), or whose phases produce no valid
stance, or whose regions are empty.

**3. Live set with reach.** `live_set_with_reach` (FightMoves.gd:1163)
filters the arsenal by stance and range band. Every returned move carries a
`fit` factor: 1.0 when the gap suits it, `mismatch_weight` when it does not.
`mismatch_weight` (line 1152) runs from `MISMATCH_MAX := 0.30` at fight_iq 0
to 0.0 at fight_iq 100. Only adjacent bands are reachable — a man in the
pocket cannot throw something that only works at long range.

**4. Role weights from the plan.** `_role_weights` (FightRealtime.gd:1184)
calls `Plans.role_map(plan)` (FightPlans.gd:129) which maps each role in the
plan's `role_priority` to a category. `FIT_WEIGHTS` (FightPlans.gd:29) then
prices that category: PRIMARY 3.0, SECONDARY 1.0, OPPORTUNISTIC 0.5,
AVOID -2.0 (clamped to 0.1 in `_role_weights`, so a man is rarely silent,
never physically unable). **The same weight applies to every technique of
that role** — a jab and a cross that are both `setup` get the same role
weight.

**5. Region bias from the plan.** `_region_bias` (FightRealtime.gd:1199)
reads `Plans.target_bias(plan)` (FightPlans.gd:171) — head / body / legs
multipliers, default 1.0 — and spreads them onto six regions: head_neck,
torso_core, left_leg, right_leg, left_arm, right_arm.

**6. The joint draw.** `select` (FightMoves.gd:452) walks the joint
distribution P(technique) x P(region | technique) in one weighted pass, one
`randf()`. For each (move, region) pair:

    w = role_w * share * region_w * fit

`role_w` is the role weight from step 4. `share` is the move's authored
region probability for that region. `region_w` is the plan's region bias
from step 5. `fit` is from step 3. One roll picks both technique and region;
there is no second draw.

**7. Who throws first.** `throw_share` (FightMoves.gd:376) decides which of
two candidates fires, from per-technique `volume` and `combo_boost` (3x
within `COMBO_WINDOW_S := 0.35` s, line 178-179). Clamped to
`SHARE_FLOOR := 0.05` / `SHARE_CEILING := 0.95` (line 184-185). Nobody is
silenced.

**8. Overall pace.** `volume_weight` (FightMoves.gd:401) scales total output
from conditioning, speed and plan pace (cautious 0.80, balanced 1.0,
aggressive 1.25). It reads CONDITIONING and SPEED, deliberately not power
and not technique (Q41: r(strike_composite_gap, volume_diff) = -0.1248).

**Which weights differ per TECHNIQUE?** None do, directly. The `fit` factor
varies per (technique, band) pair — a hook fits the pocket but not long
range — but it is a function of range, not of the technique's identity.
The `share` (region distribution) is authored per technique in the catalogue,
but it names WHERE a technique can land, not HOW OFTEN it is thrown. Two
setup punches at the same range band with the same region distribution are
thrown equally often. **The palette is flat across techniques of the same
role at the same range.**

## THE PALETTE

Over the DEFAULT arsenal (tier <= `DEFAULT_ARSENAL_MAX_TIER` = 2), nodes
admitted by `move_from_node` (role in STRIKE_ROLES, no GRAPPLE_EFFECTS key,
at least one non-weapon phase):

| Ruleset    | Nodes | Names leg | Only leg | Unnamed |
|------------|-------|-----------|----------|---------|
| boxing     |    14 |         0 |        0 |      14 |
| kickboxing |    26 |         4 |        3 |      15 |
| muay_thai  |    40 |         6 |        3 |      19 |
| mma        |    54 |        10 |        6 |      22 |

- **Nodes**: total striking techniques in the default arsenal.
- **Names leg**: techniques whose `match.target_region` includes `"leg"`.
- **Only leg**: techniques whose `match.target_region` is exactly `["leg"]`.
- **Unnamed**: techniques whose `match.target_region` is empty — they can
  land anywhere the region roll puts them, including the leg.

Disciplines drawn per ruleset (via `discipline_tags` in `combat_rulesets.json`
and `DISCIPLINE_TAG_ALIASES` at FightMoves.gd:237):
- boxing: boxing
- kickboxing: boxing, kickboxing
- muay_thai: muay_thai, boxing (clinch tag resolves to no known discipline)
- mma: boxing, kickboxing, muay_thai, wrestling, judo, brazilian_jiu_jitsu, sambo, mma

**INFERENCE — expected leg share if every technique is equally likely:**

If every node in the palette has the same probability of being thrown, the
leg share is `names_leg / nodes`:

- boxing: 0 / 14 = **0%**
- kickboxing: 4 / 26 = **15.4%**
- muay_thai: 6 / 40 = **15.0%**
- mma: 10 / 54 = **18.5%**

This is the arithmetic share of techniques that CAN reach a leg, not a
prediction of what real fighters do. It is the quantity the engine produces
when no per-technique frequency weight exists — and it is the reason the
realtime leg share barely moved after S2 named every kick's target.

Note: the `unnamed` column is large (14-22 per ruleset). These techniques
have no `target_region`, so the region roll decides where they land. They
CAN land on a leg via the region roll, but they are not counted in
`names_leg`. The true "can reach a leg" share is therefore higher than
`names_leg / nodes` — but only `names_leg` is the deterministic, authored
leg reach.

## WHAT REAL BOUTS SAY

**On-disk figures, quoted verbatim:**

1. **UFC target mix (landed significant strikes).** J20 cites the Fight
   Algorithm Volume Machine (8,555 UFC fights):
   > "League ~61–65% head / 19–23% body / 14–18% leg"

   And the same source's league-average line:
   > "63% head / 23% body / 14% leg"

   **Definition:** share of significant strikes by target region (head /
   body / leg), landed. This is the quantity the engine's 65.3 / 28.2 / 3.2
   split should match.

2. **UFC significant-strike pace.** J20 cites Fight Algorithm Division Meta
   (8,375 fights, 12 divisions, 1993-2025):
   > "2.8–3.8 significant strikes landed per fighter per minute"

   Combined bout ~6-8 landed/min. Career tails 1.0-8.7.

3. **CompuBox scoring keys.** G45 describes CompuBox (on-air since 1985):
   > "four keys: jab thrown/landed, power thrown/landed"

   CompuBox does not break down punch types beyond jab vs power. It tallies
   volume, not damage or technique identity.

4. **Combination types (pro boxing).** G53 cites Thomson 2012 (WCPAS IX):
   > "modal type was jab-straight (jab-jab in middleweights); 12 types covered 43–64%"

   of combinations depending on weight class.

5. **Amateur boxing punch frequencies.** J21 cites Thomson & Lamb 2016
   (92 English amateurs, 183 punches/bout):
   > "Jab | 64 (60–68) | ~35%"

   Rear-hand cross 39 (~21%), lead hook 49 (~27%), rear hook 23 (~13%),
   lead uppercut 5 (~3%), rear uppercut 8 (~4%). **The jab is the single
   most thrown punch at 35%, but the distribution is not extreme: four
   punch types each exceed 10%.**

**The gaps:**

- J20's 14-18% is the share of SIGNIFICANT STRIKES that land on a leg,
  across whole bouts and both men. It is NOT "half of kicks are leg kicks"
  or any per-technique frequency. Converting one to the other requires
  knowing the total kick rate and the leg-kick rate separately, and neither
  is on disk for MMA.
- CompuBox's jab/power split is boxing-only and does not name hooks,
  uppercuts, or body vs head.
- The amateur boxing punch distribution (J21, Thomson & Lamb 2016) is the
  only per-technique frequency figure on disk, and it is amateur boxing,
  not MMA.
- No file on disk holds a per-technique frequency distribution for MMA,
  kickboxing, or muay thai bouts.

## OPTIONS

### (a) Authored per-technique frequency weight in the catalogue

Add a `match.frequency` field to each technique node (e.g. 1.0 default,
2.0 for the jab, 0.3 for a spinning elbow). `FightMoves.select` reads it
and multiplies into the weight: `w = role_w * share * region_w * fit * freq`.

**Data needed:** Per-technique throw rates from real MMA/kickboxing/muay thai
/boxing bouts. Not on disk (see `not_on_disk`). One outside query to find
UFC per-technique frequency data, CompuBox-style breakdowns for kickboxing
and muay thai.

**What changes:** `select` gains one multiplication. The catalogue gains one
authored field per node. Seeded tests would show non-flat technique
distributions: jabs exceeding hooks, low kicks exceeding spinning elbows,
matching the real-bout shape.

**What it moves:** The leg share, the head/body/leg split, the jab share of
punches, the combination type distribution. Every technique-frequency
observation the validation corpus cites.

### (b) Frequency derived from tier and role

Tier 1 fundamentals (jab, cross) are thrown more than tier 2 specialty
techniques (spinning elbow, rolling elbow). A `tier_weight` of
`1.0 / tier` or `2.0 / (tier + 1)` would make tier 1 techniques roughly
twice as frequent as tier 2.

**Data needed:** None new — tier is already authored. But the mapping from
tier to frequency is assumed, not measured.

**What changes:** `select` multiplies by a tier-derived weight. No catalogue
change.

**What it moves:** Tier 1 techniques (jab, cross, low kick, teep) would be
thrown more than tier 2 (spinning attacks, advanced elbows). But within
tier 1, the palette is STILL flat — a jab and a cross are both tier 1
setup, so they remain equal. This cannot produce a 35% jab share.

### (c) Frequency set by the fighter's style / plan

The plan already carries `role_priority` (which roles are PRIMARY vs
SECONDARY) and `target_bias` (head/body/legs multipliers). Extending the
plan with per-technique emphasis — "this fighter is a jab-and-cross man" —
would let two fighters with the same arsenal throw very different
distributions.

**Data needed:** Fighter-specific technique frequencies, or at minimum
style-archetype distributions (pressure fighter vs counter-striker vs
grappler). Not on disk for this game's fighters.

**What changes:** The plan schema gains a technique-emphasis map. `select`
reads it. Plan generation assigns emphasis from the fighter's record.

**What it moves:** Between-fighter variation in technique distribution. But
within a fighter, the same flat-palette problem recurs unless the emphasis
map is per-technique — which is option (a) with the weight on the plan
instead of the catalogue.

### Recommendation

**Option (a).** The flat palette is a per-technique problem — every
technique of a role is equally likely — and it needs a per-technique answer.
An authored `match.frequency` in the catalogue is the most direct lever:
it maps one-to-one onto the real-bout observations J20 assembled (target
mix, pace, per-technique frequency), it is readable and auditable, and it
costs one multiplication in `select`. Options (b) and (c) are partial:
(b) cannot distinguish techniques within a tier, and (c) moves the problem
to the plan without solving it. Option (a) also composes with (b) and (c)
later — a tier weight or plan emphasis can multiply into the same `w`
without conflict.

The prerequisite is the outside query: per-technique frequency data for
MMA, kickboxing, muay thai and boxing bouts. The `not_on_disk` list is
that query's scope.
