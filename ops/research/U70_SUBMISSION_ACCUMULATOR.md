# U70 — Submission accumulator: why ground finishes vanish

Research only. Source: `FightSimulation.gd` line windows named in TASK_U70, BJJ
nodes in `technique_catalog.json` (md5 `8e8cbaf210d19cf8327e7ecc43012af7`), and
S1d measurement header (`measure_ground_seats.gd`).

---

## 1. The mechanism (exact)

### Data shape

Each fighter carries **one** slot:

```gdscript
"submission_attempt": null  # or {"technique_id": String, "strength": float}
```

Initialized at bout start (`:963`). There is **no** per-target map, **no**
per-technique map, **no** decay, **no** round-boundary reset of strength.

### Writes (strength increases)

Only in `_apply_landed_effect`, `"submission"` arm (`:2110–2122`), and **only
when the exchange landed** (`:1463–1464` — missed submissions never touch the
accumulator).

| Line | Action |
| --- | --- |
| `:2111` | Read existing `submission_attempt` |
| `:2113–2114` | **Reset** if empty **or** `technique_id` differs → `strength = 0.0` |
| `:2115` | `strength += magnitude * execution_quality` |
| `:2116` | Write back to actor |
| `:2119` | Increment `submission_attempts_round` (judge counter only) |
| `:2120–2122` | If `strength >= threshold` → `event["submission_finish"] = true` |

Constants:

- `SUBMISSION_BASE_THRESHOLD = 55.0` (`:133`)
- `threshold = 55.0 + defense×0.35 + camp sub_defense` (`:2120`)
- `magnitude = sum(abs(effects))` over all effect keys (`:2649–2654`)

Finish propagation: `:1468–1469` sets `outcome = "finish"`; `_check_stoppage`
`:2697–2698` ends the bout on `submission_finish`.

### Clears

| Line | Trigger | What clears |
| --- | --- | --- |
| `:963` | Bout init | Both fighters → `null` |
| `:2416` | **Any** landed `escape` role by bottom fighter | **Attacker's** slot → `null` |
| `:2419–2420` | Same escape handler | **Opponent's** slot → `null` if non-null |

Escape stand-up success is probabilistic (`:2407–2411`, 10–85% chance to reach
STANDING). **Clear happens regardless of stand-up success** (`:2401–2403`).

### What does NOT clear strength

| Line | Round reset | Clears `submission_attempt`? |
| --- | --- | --- |
| `:2798–2816` | Per-round counters (`submission_attempts_round`, health regen, combo windows) | **No** — strength can carry across rounds |

### Chaining / carry-over

**None by design.** Switching submission technique resets strength to zero
(`:2113–2114`). There is no decay between exchanges on the same technique.
Round breaks preserve strength but do not help if the palette keeps rotating.

---

## 2. The arithmetic

### Threshold for S1d defenders

Fixtures use `defense` 60 (passer, MMA grappler) and 66 (guard player). Camp
`sub_defense` is 0 in fixtures.

| Defender `defense` | Threshold |
| --- | --- |
| 60 | 55 + 21.0 = **76.0** |
| 66 | 55 + 23.1 = **78.1** |

### BJJ submission magnitudes (catalog, sum of all `effects`)

Guard-player palette (7 subs):

| id | submission | other effects | **magnitude** |
| --- | --- | --- | --- |
| `bjj_triangle` | 14 | counter_to_pass 7 | **21** |
| `bjj_armbar` | 11 | arm_isolation 8 | **19** |
| `bjj_kimura` | 11 | shoulder_isolation 8 | **19** |
| `bjj_guillotine` | 12 | front_headlock 6 | **18** |
| `bjj_omoplata` | 11 | sweep_threat 6 | **17** |
| `bjj_cross_collar` | 11 | submission_setup 5 | **16** |

Passer / MMA top palette adds `bjj_rnc` (18), `bjj_americana` (17), `bjj_arm_triangle` (18).

Per landed hit: `Δstrength = magnitude × execution_quality`.

### Consecutive **same-technique** lands to finish

Using representative magnitude **19** (kimura/armbar band) and threshold **76**:

| execution_quality | Δ per land | Lands needed |
| --- | --- | --- |
| 0.60 | 11.4 | **7** |
| 0.75 | 14.25 | **6** |
| 0.90 | 17.1 | **5** |

For weakest sub in guard palette (`bjj_cross_collar`, mag 16) vs defense 66
(threshold 78.1), eq 0.75: 78.1 / 12.0 = **7 lands**.

For strongest (`bjj_triangle`, mag 21), eq 0.75 vs 76: **4 lands** (76/15.75).

**Task anchor `streak_needed_q075 = 6`** uses the median magnitude/threshold
pair (mag 19, threshold 76, eq 0.75).

### Streak probability with palette rotation

**Misses never touch the accumulator** (`:1463–1464`). A miss does not advance
strength and does not reset it. Only a **landed** submission on a **different**
`technique_id` resets (`:2113–2114`). So the finish condition is **n landed
hits on one id** with arbitrary misses between them — not n consecutive
attempts that all land.

Do **not** put landing probability in the streak exponent. \(p_{\text{land}}\)
controls how often a submission **attempt** becomes a land event; it is not a
per-step penalty on an already-landed chain. The rotation penalty applies among
**landed** submission events only.

Conditional on a chain of landed submissions and uniform choice among **k**
submission techniques (see §3 for why this is an approximation):

\[
P(\text{same-id land streak of } n) \approx \left(\frac{1}{k}\right)^{n-1}
\]

The first land picks the id; each of the next \(n-1\) lands must match. A land
of any other id resets strength to zero on that new id.

Using \(n = 6\) (median mag/threshold at eq 0.75):

| Palette size k | \((1/k)^5\) |
| --- | --- |
| **2** (pre-merge) | (½)⁵ = **3.1%** per uninterrupted same-id land chain |
| **7** (guard player) | (1/7)⁵ ≈ **0.004%** |
| **8** (guard player, rounded) | (1/8)⁵ ≈ **0.003%** |

\(p_{\text{land}} \approx 0.52\) (typical: `0.35 + 0.5×0.75 − defense_factor`
with defense 60, `:1408`) still matters — it sets how many submission **attempts**
each bout produces before an escape clear (`:2416–2420`) — but it belongs in the
**attempt budget**, not as \(p^n\) in the streak formula. The first submission
used \(p^6/k^{n-1}\); that counted misses as if they broke the chain, which the
code does not.

With **per-technique persistence** (no reset on switch), the relevant question
becomes total landed subs on one technique regardless of interleaving — S1d's
282 kimura **attempts** (landed or not) over 40 bouts shows the engine generates
pressure; the reset prevents those from compounding on one id.

### S1d check — both observed sub rates

If the arithmetic above is right, it must explain **both** S1d submission counts
without tuning to J20's 17.2%:

| Population | S1d observed | What corrected arithmetic predicts |
| --- | --- | --- |
| **BJJ guard vs passer** | **1 sub / 40 bouts (2.5%)** | ~684 sub attempts / 40 ≈ **17 attempts/bout**; at \(p_{\text{land}}\approx0.52\) ≈ **9 landed subs/bout**. Finish needs **5–6 same-id lands** before a **land** of another sub (threshold 76–78; mag 16–21 at eq 0.75–0.9). Rotation factor \((1/7)^5\)–\((1/8)^5\) ≈ **0.003–0.004% per uninterrupted same-id land chain** — most chains break on the second or third **land** when the palette rotates. Yet PRIMARY-weighted draws (`:2604–2606`, `:99–101`) and kimura-heavy repetition (282 attempts / 40) mean occasional long runs where one id lands 6+ times without an intervening **land** of another sub. **1 finish in 40 is rare but reachable** — not the \(10^{-7}\) the old \(p^6/k^5\) formula implied, which would forbid even a single finish in 40 bouts. |
| **MMA grappler vs striker** | **0 subs / 40 bouts (0%)** | Same reset mechanics and similar top sub palette (RNC/kimura/armbar counts in the same order of tens per 40), but the grappler **wins 0/40** — ground time and sustained top chains are shorter, escape clears fire more often relative to completed land chains, and 40 bouts is long enough for **zero** finishes without contradicting the math. **0% here is the stricter half of the same model**, not a separate bug. |

The old formula's fatal mismatch: \(0.52^6/8^5 \approx 6\times10^{-7}\) per
window × even hundreds of windows per 40 bouts ⇒ expected finishes ≪ 1 — yet S1d
recorded **one**. Removing \(p^n\) from the streak exponent and applying
\((1/k)^{n-1}\) only among **lands** fixes that inconsistency while keeping the
palette-rotation story.

### `_weighted_choice` — is "roughly evenly" fair?

`:2547–2646`. Weight = `tactical_base × execution_quality × stamina ×
vulnerability × range_fit × stance_fit`.

- Submission on top in GROUND gets `vulnerability × 1.15` (`:2604–2606`) — boosts
  weight, not landing rate.
- Plan alignment (`PRIMARY` vs `SECONDARY`) differs by technique and corner
  emphasis; grappling/finish plans mark submission `PRIMARY` (`:99–101`).
- Discipline proficiency varies per technique → execution_quality differs (~±10%
  weight spread among subs from same fighter).
- Many non-submission candidates (control, transition, pass, sweep) share the
  same draw — submissions are **not** 1/k of all ground exchanges.

**Verdict:** Among submission-role candidates when the fighter is attacking on
the ground, weights are **same order of magnitude** but not uniform — PRIMARY
subs are overweighted ~1.5–2× vs SECONDARY. "Roughly evenly" is fair for an
order-of-magnitude streak estimate, not for exact rates.

---

## 3. Other suppressors (ranked)

| Rank | Cause | Mechanism | Estimated impact |
| --- | --- | --- | --- |
| **1** | **Single-slot reset on technique switch** | `:2113–2114` + S1 tripled ground sub palette (7–9 subs per fixture vs ~2 pre-merge) | **Dominant.** Turns hundreds of landed subs (S1d: kimura 282, etc.) into **1 finish / 40** BJJ bouts. Streak math §2 shows k=8 makes same-id streak astronomically unlikely. |
| **2** | **High finish threshold + multi-effect magnitude** | Need **5–7 same-id lands** (misses between them are free) at threshold 76–78; magnitude sums isolation/setup keys, so each land adds ~12–16 at eq 0.75 | **High.** Even k=2 at n=6 gives \((1/2)^5\) ≈ **3.1%** per uninterrupted same-id land chain — rotation alone can eat an otherwise viable chain. |
| **3** | **Escape clears both accumulators** | `:2416–2420` on every landed escape, ~40–60% stand-up | **Moderate.** Bottom guard player knows `bjj_frame_escape`, `bjj_shrimp_escape`; each escape attempt wipes top player's progress even when the hold continues. |
| **4** | **Missed subs do not accumulate** | `:1463` gate | **Moderate.** ~48% of submission attempts miss at fixture stats; effective lands halved. |
| **5** | **Stamina / tier gating** | `:2483–2486` MIN_STAMINA, MORALE_TIER | **Low** in long ground exchanges; matters late-round. |
| **6** | **MMA striker survival** | Grappler wins 0/40 — likely top-time + decision path, not sub-specific | **Contextual** for D4 MMA population, not pure BJJ. |

**Not a suppressor:** round reset does **not** clear strength (`:2811` only
resets `submission_attempts_round`), so cross-round carry is slightly **helpful**,
not harmful.

---

## 4. Three options

### (a) Per-target accumulator with partial carry on switch

Replace the single slot with e.g. `submission_pressure: {left_arm: 42.0, …}`
keyed to `_technique_target_region` submission targets (`:2244–2252`: 40% left
arm, 40% right arm, 10% left leg, 10% right leg).

On landed sub: add to that region. On switch to a different submission targeting
the **same** region, keep fraction α (e.g. 0.5–0.7) of existing pressure; on
new region, start fresh or small seed.

| Rulesets | All that use `"submission"` arm: **BJJ, MMA, sambo, judo** (same code path) |
| --- | --- |
| Rough predicted sub rate | Pure BJJ guard vs passer: **8–15%** (still below sport IBJJF sub-heavy cards, above today's 2.5%). MMA grappler top control vs striker: **5–12%** when fight hits ground. |
| Pros | Models real chains (kimura → armbar on same arm). Palette expansion helps rather than hurts. |
| Cons | Needs region↔technique mapping rules; tuning α and threshold together. |

### (b) Per-technique strength map (no reset on switch)

`submission_attempts: {technique_id: strength}` — each id accumulates
independently; finish when **any** entry crosses threshold (or sum weighted).

| Rulesets | Same universal arm |
| --- | --- |
| Rough predicted sub rate | BJJ: **5–10%** (kimura 282 lands could eventually finish if same id repeats ~6×; rotation still splits progress). MMA: **3–8%**. |
| Pros | Minimal conceptual change; fixes the obvious reset bug. |
| Cons | Does not model cross-technique chains; with k=8, progress stays fragmented unless one technique dominates the draw. |

### (c) Lower threshold only

Halve threshold (55 → 28) or reduce defense coefficient.

| Rulesets | Same arm |
| --- | --- |
| Rough predicted sub rate | Would push **every** ruleset toward finish spam; BJJ possibly **40%+**, MMA **20%+** if combined with current reset bug fix |
| Pros | One-line change. |
| Cons | Does not fix palette-rotation logic; tuning to J20 17.2% is wrong population anyway (see trap). Over-finishes pure BJJ while still under-finishing if reset remains. |

---

## 5. Recommendation: **(a) per-target with partial carry**

**Why not (c):** J20 D4 **17.2%** is modern UFC **standard divisions**
(2019–May 2026, all matchups, standing + ground). Pure **BJJ rules** bouts and
**MMA grappler-vs-striker** are different populations — a pure BJJ card may
rightly run **10–20%+** subs; an MMA striker who never gets taken down should
run **near 0%**. Tuning one threshold to 17.2% across rulesets guarantees
wrong behaviour somewhere.

**Why not (b) alone:** S1 expanded the palette so fighters rotate attacks. Per-
technique maps without carry still require the draw to repeat the same id 5–6
times — the S1d log shows variety (32 distinct ground techniques), which is
realistic visually but toxic to (b).

**Why (a):** Submission targets already exist in the engine (arm/leg regions).
Partial carry lets kimura → armbar → triangle on one arm compound — the intended
gameplay S1's catalog was built for. Pair with a **slight** threshold review
after implementation, not before.

---

## 6. Population anchors (trap compliance)

| Anchor | Population | Use for |
| --- | --- | --- |
| J20 D4 **17.2% sub** | Modern UFC standard divisions, all bout types | MMA **league-wide** outcome mix — not a single BJJ ruleset bout |
| S1d **2.5% sub** (1/40) | BJJ guard vs passer, catalogue md5 above | **Regression floor** — anything that stays here is broken |
| S1d **0% sub, 0/40 grappler wins** | MMA grappler vs striker | Grappler **should** finish some fights they dominate on the ground; 0% signals accumulator + possibly top-time/decision path |

Do not tune to 17.2% on pure BJJ fixtures.

---

## Summary numbers (for mail)

- **clears:** 2 runtime clear sites (+ init): escape handler clears actor + opponent (`:2416–2420`); no decay; no round clear of strength
- **streak_needed_q075:** **6** same-id lands (mag 19, threshold 76; misses between them do not reset)
- **p_streak_k2:** ≈ **3.1%** per same-id land chain \((1/2)^5\), n=6
- **p_streak_k8:** ≈ **0.003%** per same-id land chain \((1/8)^5\), n=6
- **recommend:** **a** (per-target accumulator, partial carry on switch)
