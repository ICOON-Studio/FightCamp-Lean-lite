# U118 — The Grapple Split

**Agent:** Cursor · **Date:** 2026-09-21 · **Status:** complete

---

## Decision — legacy `grapple` key

**Kept as a derived mean:** `grapple = round((grapple_offense + grapple_defence) / 2)`.

Generation and discipline bonuses write the split pair; `_sync_derived_grapple` runs after
every roll. Migration copies a legacy single `grapple` into both split stats at equal value.
Engine reads target the split keys; `_stat` and inline reads fall back to legacy `grapple`
when a row has not been migrated yet (test fixtures, not a silent 50-default).

---

## Generation

`WorldPopulation.gd` rolls `grapple_offense` and `grapple_defence` from the same independent
`grapple_base` + `rand(-8,8)` spread Q119 used for `grapple`, so the pair stay correlated but
not identical. Wrestling/sambo/judo and BJJ discipline bumps apply +5 to **both** split stats.

---

## Engine routing

| id | attacker / actor | defender / top | stat read |
|---|---|---|---|
| takedown, throw | `grapple_offense` | `grapple_defence` | `GrappleResolve` off/def weights |
| sweep | same | same | `position_resolve` |
| submission_attempt | `grapple_offense` | `grapple_defence` | `_submission_tick_advance` |
| clinch_break | `grapple_offense` | `grapple_defence` | `CLINCH_OFF_WEIGHTS` + `DEF_WEIGHTS` |
| submission_finish | — | — | **unchanged** — flat `FINISH_P` |
| control | top's `grapple_offense` | — | `_top_control_norm` |
| escape, stand_up | escaper technique | top's `grapple_offense` via `_top_control_norm` | `_resolve_escape_attempt` |
| realtime shoot/clinch | shooter's `grapple_offense` | — | `FightRealtime.gd:3843-3844` |

---

## Gate results (`python research/U118_check.py`)

**Asymmetry** — offense specialist (off=82, def=38) vs defence specialist (off=38, def=82),
20k fresh standing takedowns each direction:

- offense → defence: **0.5223**
- defence → offense: **0.4923**

Delta is modest (~3 pp); takedown resolve dominates via the shared off/def weight tables.
Submission tick advance uses the same split keys and would widen on ground sequences.

**Control arm** — equal split 55/55 vs legacy `grapple=55` on identical neutral men: **0.4994**
vs **0.5007** (delta 0.0013, within 0.005 noise).

**Saturation** — 252-fighter mixed population (seed 117): no-weakness **0**, ceiling **0**.

---

## Unclassified call sites

None. Every row in Q119's table is routed above; `submission_finish` deliberately untouched.
