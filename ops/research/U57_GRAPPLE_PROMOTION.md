# U57 — What the Ground Fight Is Worth on Screen

**Addressed to the operator.** Numbers only; `FightBeatAdapter` was not changed.
This prices five presentation rules so a product ruling can be made the way
U48/U49 priced defence promotion.

**Measured at:** `7304f09`
**Harness:** `Godot/tools/measure_grapple_promotion.gd`
**Method:** 12 bouts × 2 rulesets (`mma`, `bjj`), seeds `611000`–`611011`, pair
`r1_grappler` vs `r1_striker` (same blocks as `fight_beat_grapple_test`).
`defence_promote_every: 0`. One engine run per seed with `grapple_beats: true`
carries every window's `grapple` array; five rules re-rank those same windows
offline (no extra RNG). A second run with the option off asserts verdicts /
scorecards / stoppage ticks are byte-identical. Seam: `carried == log_grapple`
on both rulesets.

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot \
    --script tools/measure_grapple_promotion.gd
```

---

## Asserts

| check | mma | bjj |
|---|---|---|
| bouts produce grapple events | 436 log events | 345 log events |
| every event carried on beat stream | 436 = 436 | 345 = 345 |
| verdicts / scorecards / ticks moved vs option-off | **0** | **0** |
| knockdowns lost under any rule | **0** (all structural) | **0** (all structural) |

Verdict-stability **PASS**. No rule draws RNG or consumes a tick; off/on
fingerprints matched on every seed.

Knockdown zero is **structural** for every rule: `off` and `remainder_only`
never displace a strike; the three `significant_*` rules refuse to displace a
`knockdown` or `shocked` candidate before they consider a grapple.

---

## The table

Denominator = all presented beats under that rule (same window count as `off`).

### mma — 12 bouts, 491 presented beats/rule, 436 grapple events in the log

| rule | grapple shown | % of presented | clean_lost | kd_lost | kd zero | verdicts moved | grapple / bout |
|---|---:|---:|---:|---:|---|---|---:|
| **off** | 0 | 0.0% of 491 | 0 | 0 | structural PASS | 0 | 0.00 |
| **remainder_only** | 1 | 0.2% of 491 | 0 | 0 | structural PASS | 0 | 0.08 |
| **significant_wins** | 16 | 3.3% of 491 | 13 | 0 | structural PASS | 0 | **1.33** |
| **significant_in_remainder_4** | 2 | 0.4% of 491 | 1 | 0 | structural PASS | 0 | 0.17 |
| **significant_in_remainder_2** | 7 | 1.4% of 491 | 4 | 0 | structural PASS | 0 | 0.58 |

Techniques reaching the screen (`technique`, never `technique_name`):

| rule | techniques |
|---|---|
| remainder_only | `grapple_submission_finish` ×1 |
| significant_wins | finish ×6, takedown ×6, throw ×3, sweep ×1 |
| significant_in_remainder_4 | finish ×2 |
| significant_in_remainder_2 | finish ×6, sweep ×1 |

Eligible significant windows (per-fight cadence): 16. Promotions that actually
displaced a strike: wins=15, rem_4=1, rem_2=6.

### bjj — 12 bouts, 323 presented beats/rule, 345 grapple events in the log

| rule | grapple shown | % of presented | clean_lost | kd_lost | kd zero | verdicts moved | grapple / bout |
|---|---:|---:|---:|---:|---|---|---:|
| **off** | 0 | 0.0% of 323 | 0 | 0 | structural PASS | 0 | 0.00 |
| **remainder_only** | 0 | 0.0% of 323 | 0 | 0 | structural PASS | 0 | 0.00 |
| **significant_wins** | 7 | 2.2% of 323 | 6 | 0 | structural PASS | 0 | **0.58** |
| **significant_in_remainder_4** | 0 | 0.0% of 323 | 0 | 0 | structural PASS | 0 | 0.00 |
| **significant_in_remainder_2** | 3 | 0.9% of 323 | 2 | 0 | structural PASS | 0 | 0.25 |

Techniques: wins = finish ×3, throw ×3, takedown ×1; rem_2 = finish ×3.

Eligible significant windows: 7. rem_4 promotions that displaced a strike: **0**
— the every-4th counter is per bout, and with ~0.6 significant windows per bout
the cadence almost never reaches 4 inside one fight. That is a density finding,
not a harness bug.

---

## Ranking (cost of each — no winner)

1. **off** — baseline. Buys nothing on the floor. Costs nothing in strikes.
   Grapple / bout = **0**.

2. **remainder_only** (today's rung-1) — buys the ground only when a 14-second
   window had no strike at all. On this sample that is **one** MMA beat in
   twelve bouts (a submission finish) and **zero** on BJJ. Costs **0** cleans.
   Grapple / bout = **0.08 MMA / 0.00 BJJ**. Safe, and nearly invisible.

3. **significant_in_remainder_4** — defence-rule shape. Buys almost nothing at
   this density: **0.17 / bout MMA**, **0.00 BJJ**. Costs 1 clean on MMA.
   Structurally protects knockdowns. At current significant-window rates the
   every-4th gate is close to `remainder_only`.

4. **significant_in_remainder_2** — middle. **0.58 / bout MMA**, **0.25 BJJ**.
   Costs 4 cleans MMA / 2 BJJ. Still mostly finishes (and one sweep) on MMA.
   Knockdowns untouched by construction.

5. **significant_wins** — densest screen. **1.33 / bout MMA**, **0.58 BJJ**.
   Costs 13 cleans MMA / 6 BJJ (~2–3% of presented beats). Puts takedowns,
   throws, sweeps and finishes on screen. Knockdowns untouched by construction.

---

## The one number that decides it

**Grapple beats shown per bout** on the high-grapple pair:

| rule | mma | bjj |
|---|---:|---:|
| off | 0.00 | 0.00 |
| remainder_only | 0.08 | 0.00 |
| significant_in_remainder_4 | 0.17 | 0.00 |
| significant_in_remainder_2 | 0.58 | 0.25 |
| significant_wins | **1.33** | **0.58** |

Today's rung-1 rule shows the ground **once in twelve MMA bouts**. Allowing a
significant grapple to take a non-knockdown / non-shocked strike slot raises
that to about **one grapple beat per bout** on MMA, for thirteen cleans given
up across the whole sample. The cadence variants sit between those poles; at
this event density `…_remainder_4` barely moves the needle.

The operator rules.
