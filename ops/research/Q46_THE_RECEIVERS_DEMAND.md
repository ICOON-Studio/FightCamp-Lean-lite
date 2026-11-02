# Q46 — The Receiver's Demand, Which Nobody Has Counted

**Measured at:** `92a513b`
**Harness:** `Godot/tools/measure_receiver_demand.gd`
**Method:** 40 bouts per ruleset through `FightBeatAdapter` (begin / advance_beat /
is_fight_over), same two welterweights as Q45, seeds 46000–46039. Real rulesets
loaded from `combat_rulesets.json`. Receiver role assigned by
`FightStageDirector.role_for_react(region, contact)` — contact first, region
second (the G42 guarantee). Knockdown override: when `beat["knockdown"]` is
true, the role becomes `"knockdown"` regardless of what `role_for_react` returns.

**Denominator:** shown beats (action beats from FightBeatAdapter). Every
percentage in this document names its denominator on the same line.

## Part 1 — The six receiver roles, counted

### Pooled (all four rulesets, denominator = 9,715 shown beats)

| role | count | % of shown |
|---|---|---|
| react_head | 5,525 | 56.9% |
| react_body | 3,609 | 37.1% |
| react_leg | 370 | 3.8% |
| knockdown | 107 | 1.1% |
| idle | 75 | 0.8% |
| slip | 16 | 0.2% |
| block | 13 | 0.1% |

**react_head and react_body together cover 94.0% of all receiver demand.**
react_leg is a distant third at 3.8%. The other four roles combined are 2.2%.

### Per ruleset

#### Boxing (denominator = 3,549 shown beats)

| role | count | % |
|---|---|---|
| react_head | 2,388 | 67.3% |
| react_body | 1,071 | 30.2% |
| react_leg | 0 | **0.0%** |
| knockdown | 54 | 1.5% |
| idle | 25 | 0.7% |
| slip | 1 | 0.0% |
| block | 10 | 0.3% |

Boxing has zero leg reactions. This is correct: boxing does not kick. The
engine's targeting leaks leg strikes into boxing (R99's finding), but on shown
beats the adapter's choosing rule (knockdown > shocked > highest wear) selects
head and body impacts, and no leg-targeting blow survives to a shown beat in
40 bouts.

#### MMA (denominator = 2,350 shown beats)

| role | count | % |
|---|---|---|
| react_head | 1,154 | 49.1% |
| react_body | 951 | 40.5% |
| react_leg | 197 | 8.4% |
| knockdown | 17 | 0.7% |
| idle | 25 | 1.1% |
| slip | 5 | 0.2% |
| block | 1 | 0.0% |

#### Kickboxing (denominator = 1,476 shown beats)

| role | count | % |
|---|---|---|
| react_head | 846 | 57.3% |
| react_body | 449 | 30.4% |
| react_leg | 158 | 10.7% |
| knockdown | 13 | 0.9% |
| idle | 7 | 0.5% |
| slip | 2 | 0.1% |
| block | 1 | 0.1% |

#### Muay Thai (denominator = 2,340 shown beats)

| role | count | % |
|---|---|---|
| react_head | 1,137 | 48.6% |
| react_body | 1,138 | 48.6% |
| react_leg | 15 | 0.6% |
| knockdown | 23 | 1.0% |
| idle | 18 | 0.8% |
| slip | 8 | 0.3% |
| block | 1 | 0.0% |

Muay thai is the outlier: head and body are almost perfectly split (48.6% each),
with almost no leg reactions. This is because muay thai's shown techniques are
dominated by horizontal elbow (head, 26.2%), teep (body/head, 20.3%),
straight knee (body, 17.4%), round kick (body, 17.1%), and switch kick body
(body, 9.4%). The round kick, despite its name, targets body more often than
leg on shown beats.

### Contact distribution on shown beats (denominator = 9,715)

| contact | count | % |
|---|---|---|
| clean | 9,035 | 93.0% |
| glancing | 505 | 5.2% |
| absorbed | 71 | 0.7% |
| missed | 75 | 0.8% |
| slipped | 16 | 0.2% |
| blocked | 13 | 0.1% |

**R102 comparison:** R102 measured muay thai at 11.1% slip and 1.6% block on
BUILT IMPACTS. On shown beats, muay thai slips 0.3% and blocks 0.0%. Boxing
slips 0.0% and blocks 0.3%. The adapter's choosing rule (knockdown > shocked >
highest wear) preferentially selects clean and glancing impacts — blocked and
slipped blows carry less wear and are dropped at a higher rate. **The shown-beat
denominator is the one that matters for clip purchases, and it tells a very
different story from the built-impact denominator.**

### Knockdown, flash knockdown, and shocked

| ruleset | shown beats | knockdown | % | flash_kd | shocked |
|---|---|---|---|---|---|
| boxing | 3,549 | 54 | 1.5% | 44 | 317 |
| mma | 2,350 | 17 | 0.7% | 12 | 152 |
| kickboxing | 1,476 | 13 | 0.9% | 9 | 108 |
| muay thai | 2,340 | 23 | 1.0% | 20 | 204 |
| **pooled** | **9,715** | **107** | **1.1%** | **85** | **781** |

A knockdown appears in 1.1% of shown beats pooled. Per fight: boxing averages
1.35 knockdowns/bout, MMA 0.43, kickboxing 0.33, muay thai 0.58.

## Part 2 — The combined purchase curve

### What we own

FightClipBinding.BINDINGS contains 7 entries: `strike_head`, `jab`, `cross`,
`hook_rear`, `jab_lead`, `cross_lead`, `hook_lead`. The thrower techniques that
map to owned clips via TECHNIQUE_CLIP_ALIASES:

- `boxing_jab` → `jab` ✓
- `boxing_cross` → `cross` ✓
- `boxing_lead_hook` → `hook_lead` ✓

Three distinct techniques owned. Their mirrors (`jab_lead`, `cross_lead`,
`hook_rear`) are separate clip bindings but the same three techniques.

**No receiver role has a clip.** `react_head`, `react_body`, `react_leg`,
`block`, `slip`, `knockdown` are all unbound.

### Combined top-30 (denominator = 19,430 = 2 × 9,715 shown beats)

| rank | side | slot | count | % of demand | cumulative |
|---|---|---|---|---|---|
| 1 | receiver | react_head | 5,525 | 28.4% | 28.4% |
| 2 | receiver | react_body | 3,609 | 18.6% | 47.0% |
| 3 | thrower | boxing_jab | 910 | 4.7% | 51.7% |
| 4 | thrower | boxing_double_jab | 857 | 4.4% | 56.1% |
| 5 | thrower | boxing_rear_uppercut | 820 | 4.2% | 60.3% |
| 6 | thrower | muay_thai_horizontal_elbow | 771 | 4.0% | 64.3% |
| 7 | thrower | boxing_lead_uppercut | 756 | 3.9% | 68.2% |
| 8 | thrower | boxing_lead_hook ✓ | 743 | 3.8% | 72.0% |
| 9 | thrower | boxing_overhand | 736 | 3.8% | 75.8% |
| 10 | thrower | muay_thai_teep | 597 | 3.1% | 78.9% |
| 11 | thrower | muay_thai_straight_knee | 525 | 2.7% | 81.6% |
| 12 | thrower | muay_thai_round_kick | 515 | 2.7% | 84.2% |
| 13 | thrower | boxing_cross ✓ | 413 | 2.1% | 86.3% |
| 14 | receiver | react_leg | 370 | 1.9% | 88.3% |
| 15 | thrower | boxing_slip_counter | 354 | 1.8% | 90.1% |
| 16 | thrower | muay_thai_switch_kick_body | 283 | 1.5% | 91.5% |
| 17 | thrower | kickboxing_front_kick | 235 | 1.2% | 92.7% |
| 18 | thrower | kickboxing_roundhouse | 208 | 1.1% | 93.8% |
| 19 | thrower | mma_guard_gnp | 153 | 0.8% | 94.6% |
| 20 | thrower | kickboxing_jab_cross_lowkick | 149 | 0.8% | 95.4% |
| 21 | thrower | kickboxing_jab_lowkick | 141 | 0.7% | 96.1% |
| 22 | thrower | kickboxing_low_kick | 133 | 0.7% | 96.8% |
| 23 | thrower | kickboxing_body_kick | 123 | 0.6% | 97.4% |
| 24 | receiver | knockdown | 107 | 0.6% | 98.0% |
| 25 | receiver | idle | 75 | 0.4% | 98.3% |
| 26 | thrower | mma_dirty_boxing | 68 | 0.3% | 98.7% |
| 27 | receiver | slip | 16 | 0.1% | 98.8% |
| 28 | receiver | block | 13 | 0.1% | 98.8% |

✓ = we already own a clip for this slot.

### Coverage curve

| top-N | coverage |
|---|---|
| 1 | 28.4% |
| 3 | 51.7% |
| 5 | 60.3% |
| 10 | 78.9% |
| 14 | 88.3% |
| 20 | 95.4% |
| 28 | 98.8% |

**28 slots cover 98.8% of all demand.** The remaining 1.2% is techniques with
fewer than 10 occurrences across 160 bouts.

### How many of the top 10 do we own?

**2 of top 10.** `boxing_jab` (#3) and `boxing_lead_hook` (#8). `boxing_cross`
is at #13, just outside the top 10.

Q45's "14 clips for 90.3%" covered throwers only. The combined curve shows
14 slots cover 88.3% of the doubled demand — but the first two slots are
receiver roles we own zero of, so the honest picture is: **we need at least 14
purchases to reach 88% coverage, and only 3 of those 14 are already owned.**

## Part 3 — The one-clip question

**If exactly one clip could be added, which slot covers the most shown beats?**

### Pooled

**react_head** — 5,525 shown beats (28.4% of combined demand, 56.9% of shown
beats on the receiver side alone).

### Per ruleset

| ruleset | top receiver role | count | % of that ruleset's shown |
|---|---|---|---|
| boxing | react_head | 2,388 | 67.3% |
| mma | react_head | 1,154 | 49.1% |
| kickboxing | react_head | 846 | 57.3% |
| muay thai | react_body | 1,138 | 48.6% |

**Boxing, MMA and kickboxing all answer react_head. Muay thai answers
react_body** — the near-perfect 48.6/48.6 head-body split means the body
reaction edges out head by one beat (1,138 vs 1,137). The one-clip answer does
NOT generalise from boxing to muay thai.

## Summary for the operator

1. **The receiver is the bigger purchase than the thrower.** react_head alone
   (5,525 beats) outnumbers any single thrower technique (best is boxing_jab
   at 910). The top-2 slots in the combined curve are both receiver roles.
2. **Two reaction clips (react_head + react_body) cover 94.0% of all receiver
   demand.** Adding them to the 3 owned thrower techniques gives 5 clips
   covering the top 5 slots (51.7% of combined demand).
3. **react_leg is ruleset-dependent.** Zero in boxing, 8-11% in MMA and
   kickboxing. A boxing-only stage can skip it; an MMA stage cannot.
4. **Block and slip footage is nearly irrelevant on shown beats.** Combined
   they are 0.3% of shown beats. The adapter's choosing rule drops them.
5. **Knockdown footage is needed in 1.1% of shown beats** — low but not zero,
   and a knockdown the player did not see is the one drop that reads as a bug.
6. **The honest purchase curve pools both bodies.** Q45's "14 clips for 90.3%"
   was thrower-only. The combined curve needs 14 slots for 88.3% of the
   doubled demand, and only 3 of those 14 are already owned.
