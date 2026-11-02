# S4g (A) — WHICH FACTOR DECIDES A LEG STRIKE, AND WHAT OPTION B IS ACTUALLY WORTH

Claude, 2026-09-17, on the operator's "A then B". Instrument: `Godot/tools/probe_leg_weight.gd`. **No engine file is
touched.**

## POPULATION

Two men differentiated INSIDE each ruleset and legal for it (operator rules 2026-09-12): **A** 183 cm reach, striker
attributes; **B** 176 cm, grappler attributes. 8 seeds per ruleset, ~12,200 action beats. Boxing is excluded: C85 zeroes
both leg targets **by rule**, so its leg share is structurally 0 and measuring it would measure the rule.

## THE DECOMPOSITION IS CHECKED, NOT ASSERTED

`FightMoves.select` walks `w = role_w × share × region_w × fit × stance_w`. The probe rebuilds that walk and then draws
40,000 rolls through **`select` itself** on the same live set:

| ruleset | band | reconstruction | 40,000 draws through `select` |
|---|---|---:|---:|
| mma | LONG | 11.599% | **11.602%** |
| mma | MID | 11.956% | **11.950%** |
| mma | POCKET | 3.553% | **3.553%** |
| kickboxing | MID | 10.659% | **10.660%** |
| muay_thai | LONG | 12.546% | **12.547%** |

Nine band/stance combinations agree to three decimals. **A first version of this check reported "the decomposition IS
the engine's walk" on 0.000% vs 0.000%** — a pass earned by a band with no leg-capable move in it, comparing nothing to
nothing. It reports `VOID` now, and the same class of defect was caught in S4 (3)'s camera check two days earlier.

**And the first probe was wrong four ways at once**, predicting 1.55% against a delivered 6.55%: it rebuilt the arsenal
instead of reading the one `begin` seats, used `live_set` where the engine uses `live_set_with_reach` (R102 lets the
wrong-distance throw back in), ignored `role_weights`, and forced `standing` on the CLINCH and GROUND bands. Reading the
engine's own seated fighter removed all four guesses.

## FINDING 1 — THREE OF THE FIVE FACTORS ARE IDENTICALLY 1.0

Read off the fighter the engine actually seated:

```
region_weights = { head_neck: 1.0, torso_core: 1.0, left_leg: 1.0, right_leg: 1.0, left_arm: 1.0, right_arm: 1.0 }
role_weights   = { }
fits seen      = 1.0 and 0.114
```

- **`region_w` is flat 1.0.** The fighter's `region_weights` is `_region_bias(plan)`, not `TARGET_WEIGHTS_BY_RULESET`.
- **`role_w` is 1.0 for every candidate** — `_role_weights(plan)` returns an empty map, so the plan biases nothing.
- **`stance_w` is 1.0** on every closed matchup, by design (S4e (3)).
- **`fit` is the ONE live modifier**, 1.0 or 0.114, stamped by `live_set_with_reach` on an out-of-band move.

**So the only thing deciding a leg strike is `share` — the move's own region map from `_regions_for`.**

## FINDING 2 — `TARGET_WEIGHTS_BY_RULESET` NEVER REACHES THE PICKER

This is what three failed attempts were missing. The constant is read **once, at arsenal-build time**, by
`_regions_for` → `_ruleset_spread`, and **only for a node whose target is unnamed** (`kick_damage`). It is not a
runtime multiplier and `select` never sees it.

That is why the earlier 0.12 → 0.25 pass moved the landed share only 7.8% → 9.4%: it re-spread the unnamed kicks and
touched nothing else. The leg engine is a handful of nodes whose own effect words name a leg:

| node | its region map | source branch |
|---|---|---|
| `muay_thai_low_kick`, `te_kot`, `low_cross_hook`, `kickboxing_low_kick`, `jab_lowkick`, `jab_cross_lowkick` | torso 0.10 / **legs 0.45 + 0.45** | `leg_damage` / `lowline_damage` |
| `muay_thai_thip_khang` | torso 0.70 / legs 0.15 + 0.15 | explicit `target_region` |
| `kickboxing_roundhouse`, `muay_thai_round_kick`, `switch_cross` | head 0.60 / torso 0.28 / **legs 0.06 + 0.06** | `kick_damage` → the ruleset spread |

**A punch cannot produce a leg strike at any weight** — an unnamed-target node falls to
`_ruleset_spread(weights, FALSE)`, head and torso only.

## FINDING 3 — OPTION B IS ANSWERED **NO**, AND THAT IS WHAT A WAS FOR

**A FIRST VERSION OF THIS SECTION SAID B WORKS FOR MMA AT legs ≈ 0.50. THAT WAS WRONG AND IS CORRECTED HERE.** The
pooled figure was computed by summing each band's ABSOLUTE leg and total weight, weighted by band share, and dividing —
a total-weight-weighted mean, not a beat-weighted one. Rebuilt correctly (pool the per-band PERCENTAGES by each band's
share of beats):

| legs in `TARGET_WEIGHTS` | mma | kickboxing | muay thai |
|---:|---:|---:|---:|
| **0.06 (today)** | 6.55% | 5.87% | 7.73% |
| 0.12 | 7.18% | 6.24% | 8.57% |
| 0.25 | 8.06% | 6.82% | 9.71% |
| 0.50 | 8.98% | 7.48% | 10.85% |
| **0.90 (15× today)** | **9.70%** | 8.03% | 11.72% |

**No ruleset reaches J20 D3's 14–18% at any weight.** MMA tops out at 9.70% with the leg weight raised fifteen-fold.
`TARGET_WEIGHTS_BY_RULESET` is not the lever, and **option B should not be built** — which is precisely what option A
was commissioned to find out, before a full re-baseline was spent on it.

## THE GAP IS RECONCILED, AND IT WAS THE INSTRUMENT

MMA predicted 10.33% against a delivered 6.55%. Split per band, **every band already matched**:

| band | beats | delivered leg | walk says |
|---|---:|---:|---:|
| LONG | 1,263 | 11.88% | 11.60% |
| MID | 1,055 | 11.56% | 11.96% |
| POCKET | 933 | 3.64% | 3.55% |
| CLINCH | 307 | 0.00% | 0.00% |
| GROUND | 1,111 | 0.00% | 0.00% |

Beat-weighted, those five give **6.55%** — the delivered figure to the digit. **The engine was right and the pooling
was wrong.** MMA exposed it because CLINCH and GROUND are **30.4% of its beats at zero leg weight** and their absolute
totals are small, so they under-diluted; kickboxing and muay thai "matched" only because they have no such band. That
agreement was luck, not confirmation — and had the gap been waved through as "probably the ground bands", the sweep
built on top of it would have sent a whole re-baseline after a number that does not exist.

## WHERE THE LEVER ACTUALLY IS

Leg weight is almost entirely the low-kick family, whose own region map is `{torso 0.10, legs 0.45 + 0.45}` — already
90% leg. Nothing is left to squeeze there. The pooled share is therefore set by **how much of each live set those nodes
hold, and by how much of the fight happens in a band where they are live at all**.

For MMA, with 30.4% of beats in zero-leg bands, the standing bands would have to run **20.1% leg** to pool to 14%.
They currently run 11.60 (LONG), 11.96 (MID) and **3.55 (POCKET)**. The POCKET hole is the largest single gap and the
most concrete thing to look at next.

So the remaining candidates are **which techniques are live**, not what weight they carry:
- more low-kick-family nodes reaching the POCKET band,
- or option **C**, a leg-seeking term in the walk,
- or accepting that an engine whose fight spends 30% of its beats on the ground cannot match a corpus-wide UFC average
  without matching the corpus's position mix first.

**AND THE COMPARISON IS ONLY LEGITIMATE FOR MMA.** J20 D3 is 8,375 **UFC** fights. Holding kickboxing and muay thai to
a UFC leg share is a category error — a muay thai bout's real leg share is far higher, and we have no published figure
for either. That is K63's Q3, written and **unrunnable from a cloud container** (no web egress, verified 2026-09-17).
**Do not tune kickboxing or muay thai toward 14–18%.**

## FINDING 4 — THE POCKET HOLE, DIAGNOSED: THERE IS NO IN-BAND LEG OFFENCE AT ALL

POCKET runs **3.55%** leg against MID's 11.96% on the same palette. The cause is not the weights and not the picker.

**Of the 63 leg-capable nodes in the four striking disciplines, 25 carry LONG, 35 carry MID and exactly TWO carry
POCKET** — `muay_thai_te_khao` and `muay_thai_te_khrueng_khaeng`. And both are authored with an explicit
`target_region` of `["head"]` and `["body"]`, which `_regions_for` takes in preference to the effect words, so **neither
produces a leg strike**. `te_khao`'s region map comes out `{head_neck 0.85, torso_core 0.15}` despite carrying
`kick_damage`, and that is correct: the catalogue says it is a knee to the head.

**So the engine has ZERO in-band leg offence at POCKET.** Every leg-capable move that appears there is admitted only by
R102's `live_set_with_reach` mismatch path at **`fit = 0.114`** — an 89% discount — which is exactly the gap:

| band | live set | leg-capable moves | their `fit` | leg share |
|---|---:|---:|---|---:|
| LONG | 52 | 10 | mostly **1.00** | 11.60% |
| MID | 56 | 10 | **1.00** | 11.96% |
| **POCKET** | 54 | 10 | **0.114, every one** | **3.55%** |

**THERE IS NO ENGINE BUG HERE.** The catalogue's own claim is that a low kick is a LONG/MID technique, and the engine
implements it faithfully. Whether that claim is right — whether a calf or low kick belongs inside the pocket — is a
CONTENT question with no study behind it, and inventing the answer is the defect this project names most often. It is
K63's territory and K63 cannot be run from a cloud container.

### What answering it "yes" would be worth, measured

Giving every leg-capable node the POCKET band and changing nothing else (an arsenal copy; `live_set_with_reach` reads
`bands` off the move, so no engine change):

| ruleset | today | POCKET opened | J20 14–18% |
|---|---:|---:|---|
| mma | 6.55% | **10.12%** | STILL SHORT |
| kickboxing | 5.87% | **13.26%** | still short, just |
| muay thai | 7.73% | **11.61%** | STILL SHORT |

**This is the largest single lever anyone has found** — +3.6 points for MMA and +7.4 for kickboxing, against the weight
sweep's +3.2 for a fifteen-fold weight rise. **And it is still not enough for MMA.**

### Which leaves the position mix, and it is the honest conclusion

MMA spends **30.4% of its beats in CLINCH and GROUND, where the leg share is zero by construction**. With 69.6%
standing, the standing bands must average **20.1%** leg to pool to 14%. Opening POCKET brings all three standing bands
to roughly 12%. Nothing inside the technique picker closes the rest.

So the remaining honest options are a leg-seeking term in the walk (option **C**), or accepting that an engine whose
fight spends nearly a third of its beats on the floor cannot match a corpus-wide UFC average **without first matching
that corpus's position mix** — which is K63 Q1 and Q3, and is unmeasured.

## FINDING 5 — THE RESEARCH ALREADY EXISTS, IT IS OURS, AND IT CORRECTS THE PREVIOUS SECTION

The question "is a 30.4% ground-and-clinch share realistic?" was asked and answered inside this repo. **J20 §C** is
exactly that table, and three of its rows settle it:

- **`Fight-time share distance / clinch / ground, modern UFC-wide` = NOT FOUND** — explicitly searched across UFC
  Stats, the Record Book, peer-reviewed time-motion work and the Fight Algorithm. **The time-share number does not
  exist publicly**, so no amount of web access would have produced it.
- **The STRIKE-position split IS documented**: distance **72.6%** / clinch **13.4%** / ground **14.1%** over 8,555
  fights; by division, combined clinch+ground runs BW 22.9% to HW 33.0%.
- And J20 warns in as many words: *"Distance / clinch / ground on a UFC Stats fight page are a split of **significant
  strikes**, not a split of fight minutes. Do not validate a time-share against a strike-share."*

**A BEAT IS A STRIKE, NOT A MINUTE**, so our 30.4% is comparable to the strike split and not to a time share — and the
previous section's reading of it as a position-time problem was wrong.

### Measured on the population J20 actually uses

| | ours | J20 league (8,555 fights) |
|---|---:|---:|
| distance | **69.6%** | 72.6% |
| clinch | **6.6%** | 13.4% |
| ground | **23.8%** | 14.1% |

Distance is close. **Ground is 1.7× too high and clinch is half what it should be** — a real discrepancy, and its own
slice, but *not* the leg lever: moving distance 69.6% → 72.6% gains the leg share **0.28 points**.

### AND EVERY BEAT THIS ENGINE EMITS IS SIGNIFICANT

Measured: 4,669 action beats, **4,669 of them significant**. `is_significant` is true at distance and true for a POWER
role anywhere, and every ground strike the MMA palette throws is `role: damage` (`mma_guard_gnp` is the most-thrown
technique in the ruleset). **The engine has no non-significant strike population at all**, where real UFC has a large
one — Sonnen threw 320 total against 89 significant vs Silva. That is a modelling gap in its own right and it is
recorded here rather than folded into this stage.

### THE GAP, CORRECTLY NORMALISED AT LAST

Our leg strikes come **entirely from distance** — clinch and ground are 0% leg by construction. So:

- our leg share within distance = 6.55% / 0.696 = **9.41%**
- real leg-within-distance = 14–18% / 0.726 = **19.3% – 24.8%** (ground and clinch strikes are ~0% leg in reality too)

**The true gap is 9.41% against 19.3–24.8% — a factor of 2.0 to 2.6, entirely inside distance striking.** Every earlier
figure in this document compared populations that were not the same, which is the rule this project states most often
and the one it has now broken twice in one stage.

Nothing found so far closes a 2× gap: the region weights buy +3.2 points at fifteen-fold, opening POCKET buys +3.6,
and the position mix buys +0.28. What remains is the **composition of the distance palette itself** — roughly 46
punch/knee/elbow candidates against 10 leg-capable ones — or option **C**, a leg-seeking term.

## FINDING 6 — THE CAUSE IS THE FLAT PALETTE, Q80 FOUND IT FIRST, AND J21 ALREADY HAS THE BOUND

### The catalogue is NOT the problem

| discipline | throwable striking nodes | full-leg | share | tier 1-2 share |
|---|---:|---:|---:|---:|
| muay thai | 75 | 19 | **25.3%** | 23.1% |
| kickboxing | 21 | 6 | **28.6%** | 30.8% |
| boxing | 36 | **0** | 0.0% | 0.0% |
| mma (own nodes) | 5 | 0 | 0.0% | 0.0% |

Real leg-within-distance is 19.3–24.8%. **Muay thai's and kickboxing's own catalogues already sit at or above it.**
The dilution is the discipline mix: `disciplines_for` gives every striking ruleset **boxing**, whose 36 throwable nodes
carry no leg capability at all, so MMA's MID live set lands at 6 full-leg of 56 candidates.

### But the real cause is one level up, and it was already written down

**`Q80_THE_FLAT_PALETTE.md` — "EVERY TECHNIQUE IS THROWN ABOUT AS OFTEN AS EVERY OTHER"** — documented this chain
already. Its words: eight weights, and *"none of them distinguishes one technique from another of the same role at the
same range"*. **This stage did not discover that. It measured it.**

Delivered technique distribution against a uniform draw over the live set:

| ruleset | techniques | top-1 | uniform | ratio |
|---|---:|---:|---:|---:|
| boxing | 16 | 9.6% | 6.2% | **1.31×** |
| kickboxing | 27 | 7.4% | 3.7% | 1.61× |
| muay thai | 42 | 3.3% | 2.4% | **1.30×** |

**The engine throws in proportion to how many techniques it knows, not how often a fighter would use them.** That is
why all four levers failed: unlocking the catalogue adds punches and kicks proportionally; region weights decide WHERE
a blow lands, not WHICH is thrown; POCKET changes what is live, not the proportionality; the position mix is worth
0.28 points. **The leg share simply IS the leg fraction of the palette**, because the draw is flat.

### And the bound is DOCUMENTED, for boxing, with 95% CIs

J21 carries Thomson & Lamb (2016, *Int J Perf Anal Sport*, 92 English amateurs, 183 punches a bout, PMID-linked):

| punch | ours | J21 | ratio |
|---|---:|---:|---:|
| jab | 15.6% | **35.0%** | **0.45×** |
| rear cross | 16.6% | 21.0% | 0.79× |
| lead hook | 20.3% | 27.0% | 0.75× |
| rear hook | 19.3% | 13.0% | 1.48× |
| lead uppercut | 14.5% | **3.0%** | **4.82×** |
| rear uppercut | 13.7% | **4.0%** | **3.43×** |

*(the six named punches only, renormalised to those six; 2,233 throws over 12 seeded boxing bouts)*

Ours spans **13.7–20.3%**; the real one spans **3–35%**. **The jab is less than half what it should be and the
uppercuts are three to five times too many** — and J21 says in as many words: *"Uppercuts are a named technique and a
tiny share."*

**This is a better-founded defect than the leg share itself**: it is boxing, our best-studied ruleset, the figures are
DIRECT with confidence intervals, and it needs no new research.

### What S4g concludes

The leg share is not a weights problem, a catalogue-content problem, or a position-mix problem. It is **the flat
palette**, and the fix is a **per-technique usage prior** — a frequency the catalogue does not carry and `select` has
no term for. One change would move the jab share, the uppercut share and the leg share together, and for boxing it can
be validated against a published table rather than tuned to a target.

**That is option C, but not as the roadmap wrote it.** Not "a leg-seeking term" — a usage prior, which is a model of
how fighters choose, not a thumb on the scale for one region.

## Open

1. **Does a low kick belong at POCKET range?** Finding 4 turns the biggest lever in the engine into one content
   question with NO STUDY behind it. Calf and low kicks from close range are real, but the bound is not ours to invent.
2. **Our ground share of significant strikes is 23.8% against a documented 14.1%, and clinch 6.6% against 13.4%.**
   Real, its own slice, and NOT the leg lever (worth 0.28 points).
3. **Every beat the engine emits is significant.** Real UFC has a large non-significant population (Sonnen 320 total /
   89 significant). A modelling gap of its own.
2. **No published leg share exists for kickboxing or muay thai** (K63 Q3, unrunnable here). Their targets are unknown,
   not missed.
4. **The usage prior exists for boxing (J21) and for nothing else.** Muay thai, kickboxing and MMA per-technique
   frequencies are not in our research; whether they are published at all is unknown.
5. `fit` is the only live modifier and it is R102's distance judgement — whether it *should* be carrying the whole walk
   alone is a design question nobody has asked.
4. `role_weights` being empty means the fight plan biases nothing in technique choice. That is either a gap or a
   deliberate simplification, and it is not written down either way.

## Re-running it

```
godot --headless --path Godot --script tools/probe_leg_weight.gd -- seeds=8
```
