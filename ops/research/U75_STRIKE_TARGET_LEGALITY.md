# U75 — Strike target legality by engine ruleset

Cross-reference of `competition_rulesets_v2.json` against the eleven engine rulesets in
`combat_rulesets.json`, with engine enforcement from `FightRealtime.gd`, `FightMoves.gd` and
`FightSimulation.gd`. Verdicts follow on-disk evidence only; gaps are `not_on_disk`, never guessed.

## Ruleset × strike × region

| engine_ruleset | strike | head_neck | torso_core | legs |
|---|---|---|---|---|
| mma | punch | legal_by_exclusion | legal_by_exclusion | legal_by_exclusion |
| mma | kick | legal_by_exclusion | legal_by_exclusion | legal_by_exclusion |
| boxing | punch | legal_by_exclusion | legal_by_exclusion | illegal |
| boxing | kick | not_applicable | not_applicable | not_applicable |
| kickboxing | punch | legal | legal | not_on_disk |
| kickboxing | kick | legal | legal | legal |
| muay_thai | punch | legal | legal | legal |
| muay_thai | kick | legal | legal | legal |
| judo | punch | not_applicable | not_applicable | not_applicable |
| judo | kick | not_applicable | not_applicable | not_applicable |
| freestyle_wrestling | punch | not_applicable | not_applicable | not_applicable |
| freestyle_wrestling | kick | not_applicable | not_applicable | not_applicable |
| greco_roman | punch | not_applicable | not_applicable | not_applicable |
| greco_roman | kick | not_applicable | not_applicable | not_applicable |
| karate | punch | legal_by_exclusion | legal_by_exclusion | illegal |
| karate | kick | legal_by_exclusion | legal_by_exclusion | illegal |
| bjj | punch | not_applicable | not_applicable | not_applicable |
| bjj | kick | not_applicable | not_applicable | not_applicable |
| sambo | punch | not_on_disk | not_on_disk | not_on_disk |
| sambo | kick | not_on_disk | not_on_disk | not_on_disk |
| taekwondo | punch | illegal | legal | not_on_disk |
| taekwondo | kick | legal | legal | illegal |

`illegal_leg_targets`: 2 rows (karate `karate_ashibarai`, taekwondo `tkd_cut_kick`).

## KICKBOXING

The engine `kickboxing` ruleset is mapped to **`kickboxing_wako_k1`** (WAKO K-1 rules).

**Why K-1 and not the other WAKO variants.** The engine's `TARGET_WEIGHTS` gives `left_leg` and
`right_leg` each 0.06 (12% combined) and `combat_rulesets.json` scores low kicks at 0.5 in the
zones block. Of the three full-contact WAKO styles on disk:

- **WAKO full contact** (`kickboxing_wako_full_contact`): `legal_targets` lists
  `leg_ankle_level_sweeps_only` and `restrictions` include `no_kicks_below_waist`. Thigh and
  shin low kicks — the bulk of Q70's kickboxing leg entries (`kickboxing_low_kick`,
  `kickboxing_jab_lowkick`, etc.) — would be **illegal**.
- **WAKO low kick** (`kickboxing_wako_low_kick`): `legal_targets` allow
  `thigh_outside_inside_backside_of_hip` but `restrictions` ban `no_kicks_to_or_under_knee`. Q70
  leg kicks aimed at the calf or ankle would be **illegal**.
- **WAKO K-1** (`kickboxing_wako_k1`): `legal_targets` include
  `legs_any_part_broadest_of_three_styles` — the only variant whose on-disk wording covers the
  full range of leg targets Q70 assigns to kickboxing discipline kicks.

This is a **ruling for Claude**, not a fact: the engine id `kickboxing` does not name a promotion.
If Claude chooses full contact or low kick instead, every Q70 kickboxing `target: leg` row becomes
an `illegal_leg_targets` entry under that mapping.

## THE ENGINE TODAY

### FightRealtime.gd (lines 320–344)

`TARGET_WEIGHTS` is the default six-region distribution (60% head, 28% torso, 6% each leg, 0%
arms). `TARGET_WEIGHTS_BY_RULESET` overrides only **four** rulesets:

- `boxing` — zero leg weights (legs renormalised into head/torso).
- `mma`, `kickboxing`, `muay_thai` — alias `TARGET_WEIGHTS` (legs permitted at 6% each).

The other seven rulesets (`judo`, `freestyle_wrestling`, `greco_roman`, `karate`, `bjj`, `sambo`,
`taekwondo`) fall through to `TARGET_WEIGHTS` default, so the realtime resolver **allows leg
strikes in every ruleset that does not have its own entry**.

### FightMoves.gd (lines 639–686)

`_regions_for` maps technique effect keys to body regions, then **filters out any region whose
ruleset weight is zero** (`region_weights.get(region, 0.0) <= 0.0`). This is the only ruleset-aware
region gate in the move catalogue path: boxing zeroes legs; everything else keeps them. A technique
whose every candidate region is zero-weighted is dropped entirely (`move_from_node`).

`disciplines_for` (lines 265–288) resolves `discipline_tags` through `DISCIPLINE_TAG_ALIASES` and
keeps only tags that exist in `technique_catalog.json`.

### FightSimulation.gd (lines 2204–2298)

`_technique_target_region` reads effect keys (`head_damage`, `body_damage`, `leg_damage`, etc.) and
picks the dominant region. **It does not consult ruleset legality or `TARGET_WEIGHTS`.** When no
effect key hints a region, `_pick_target_region` (lines 2274–2298) falls back to role-weighted
random draws (45% head / 35% body / 10% each arm for damage roles) — again with **no ruleset
filter**. FightSimulation enforces technique-level illegality elsewhere (`technique_legality_matrix`
at line 2708) but not strike **region** legality.

### Disciplines with no engine ruleset

These catalogue discipline ids never appear in any engine ruleset's resolved `disciplines` list, so
their kicks cannot surface in any bout: **arnis**, **capoeira**, **pencak_silat**, **sanda**,
**savate**.

## OPTIONS

**(a) Per-ruleset `strike_targets` block in `combat_rulesets.json`** — both `FightRealtime` and
`FightMoves._regions_for` (and optionally `FightSimulation._technique_target_region`) read the same
authored table. Single source of truth; competition data can seed it but the engine owns the
runtime copy. Consequence: one JSON edit updates all three resolvers; requires a migration pass for
all eleven rulesets.

**(b) Extend `TARGET_WEIGHTS_BY_RULESET` to all eleven + legality filter in FightSimulation** —
realtime and moves already understand region weights; extending the table covers karate, taekwondo,
judo, etc. FightSimulation would need a new filter reading the same weights. Consequence: weights
and legality stay coupled (zero weight = illegal, as `_regions_for` already does), but
`FightSimulation` still needs a separate hook and the weight table conflates targeting **frequency**
with targeting **legality**.

**(c) No region legality in resolvers — remove illegal techniques via `technique_legality_matrix.json`**
— `FightSimulation.gd:2708` already refuses techniques whose matrix status is `illegal`. Consequence:
per-technique maintenance explosion (126+ kicks × 11 rulesets); cannot express "roundhouse to the
leg is legal but roundhouse to the head is not" without splitting techniques; realtime path still
unaffected.

**Recommend (a).** Region legality is a ruleset property, not a technique property or a frequency
tuning knob. A `strike_targets` block beside each ruleset's existing `discipline_tags` keeps
competition sourcing, engine runtime and S2's per-kick targets aligned without overloading
`TARGET_WEIGHTS` or the technique matrix.
