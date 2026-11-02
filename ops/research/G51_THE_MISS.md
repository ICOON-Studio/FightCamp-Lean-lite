# G51 — WHAT IS A MISS, AND DOES A SIMULATOR NEED ONE?

Agent: Grok, Expert tier, 134 sources. Research only.
Delivered in chat 2026-09-10; captured verbatim from the browser by Claude and
committed here because Grok has no checkout. Prose is Grok's; headings and this
note are Claude's framing.

**This one is not a refusal. It answers a question Q39 marked NOT DERIVABLE, and
it argues that our engine is missing a primitive.**

---

## THE THREE THINGS THAT MATTER

**1. The significant-strike definition, operationally — Q39 said this was NOT
DERIVABLE and here it is:**

> A strike is **significant** when it is **any strike at distance, OR a power
> strike in the clinch or on the ground.** Excluded: small/short strikes in the
> clinch and on the ground, which still count toward *total* strikes.

**It is a CATEGORY RULE, not a damage judgement.** A range-finding jab at
distance IS significant. A short ground tap is not. That is the whole filter, and
it is one we can implement exactly.

**2. A miss is ONE bucket, and that is very good news for us.** Neither CompuBox
nor UFC Stats distinguishes blocked from slipped from parried from thrown-into-
air. CompuBox has four keys only — jab connect/miss, power connect/miss — and
"does not account for defensive manoeuvres". **We do not need to model block
versus slip separately to be scored against their numbers.**

**3. Our 57.1% is above BOTH official denominators, and identical across two
sports:**

| | real | denominator | ours |
|---|---|---|---|
| Boxing | **~30–32%** | of all punches thrown (CompuBox database-wide) | 57.1% |
| MMA | **~40–42%** | of significant attempts | 57.1% |

Grok's words: *"the fingerprint of a number that is not being modelled."*

## THE TABLE

| Quantity | Source | Exact definition | Real value (denominator named) | Status |
|---|---|---|---|---|
| CompuBox jab connect | CompuBox | Lead-hand straight coded as contacting | ~15–31% **of jabs thrown**; jr-middle class avg 21.8% | MEASURED |
| CompuBox power connect | CompuBox | Any non-jab punch coded as contacting | **36.9% of power punches thrown** | MEASURED |
| CompuBox total connect | CompuBox | (jab+power landed)/(jab+power thrown) | **~30–32% of all punches thrown** (30% all-classes ~2010; 32% across 4,800+ fights ~2012) | MEASURED |
| CompuBox miss | CompuBox | The other two keys | Everything not a connect. **No published split of block / slip / parry / air** | One bucket; subtypes NOT PUBLISHED |
| UFC significant strike | FightMetric glossary | All strikes at distance + power strikes in clinch and on ground | Category rule, not a damage score | **MEASURED (definition official)** |
| UFC total strike | FightMetric | Significant + short/non-power clinch and ground strikes | Always >= significant | MEASURED |
| UFC Str. Acc. | UFC Stats | Significant landed / significant attempted | **~40–42% of significant attempts** | MEASURED |
| UFC SLpM | UFC Stats | Significant landed / minutes | ~3–4 landed/min; **attempts ~7.1 significant per minute** | MEASURED |
| UFC Str. Def. | UFC Stats | Opponent significant misses / opponent significant attempts | Inverse of opponent accuracy; **no cause split** | MEASURED |
| UFC distance head land rate | UFC / Fightnomics | Head strikes at distance / those attempts | **~33% of distance-head attempts** (UFC 2025); Fightnomics distance power-head ~25% | MEASURED |
| UFC ground-body land rate | UFC | Body strikes on ground / those attempts | **~93% of those attempts** | MEASURED |
| UFC distance target mix | Fightnomics | Intended target among distance strikes | **~80 / 10 / 10** head/body/leg of distance strikes | MEASURED |
| Combo vs single accuracy | — | Same strike in combo vs alone | G49's jab 48.8% vs 45.4%, **both of jabs attempted** | **NOT PUBLISHED** at league scale |
| Block vs evade vs air | Both systems | Separate codes | **Neither system publishes this split** | Official: NOT PUBLISHED |

## 1. WHAT IS COUNTED AS LANDED

**Boxing — CompuBox.** Two ringside operators, one fighter each, **four keys**:
jab connect, jab miss, power connect, power miss. A jab is the lead-hand
straight; **everything else is a "power punch" regardless of force** (Canobbio:
they called it power "because it sounds better than non-jab"). It records thrown
and landed only — **not damage, not cleanliness, not judging criteria.**

**MMA — FightMetric / UFC Stats.** Significant = all strikes at distance +
power strikes in clinch and on ground. Not included: "small, short strikes in the
clinch and on the ground", which remain in *total* strikes. FightMetric built it
because a power/non-power split mixed unlike events, so they regrouped by **range
plus close-range power**. **Scored from video with slow motion, not live.**

## 2. HOW A MISS IS CODED — ONE BUCKET

- **CompuBox has no fifth key for "blocked."** A glove pickup, a slip, a punch
  into air, a range-finder that never arrives — all `miss` unless the operator
  hits connect.
- **UFC Stats is the same on the published side.** Str. Def. is opponent
  misses / opponent significant attempts, and the public metric **does not say
  whether the failure was a block, parry, slip, step or poor aim.**

**One caveat that cuts the other way:** some FightMetric coding treats contact on
the guard/forearm as a **landed** significant strike if the blow touched — the
known complaint about blocked leg kicks counting as landed. So "miss" in UFC
units is nearer to *"did not contact anything they coded as the opponent"* than
to *"did not hit the intended target clean."*

Amateur research templates (Thomson/Davis) sometimes code hit / air / blocked
separately. **Those are not CompuBox or UFC Stats.**

A punch thrown at nobody to hold range is an attempt if the operator treats it as
committed. **Neither shop publishes a "probe vs committed" rule.**

## 3. THE REAL NUMBERS

**Boxing (CompuBox), denominators named:**
- Database-wide total accuracy **~30–32% of punches thrown**.
- Power **36.9% of power punches thrown**.
- Jab **~20–25% of jabs thrown** (jr-middle avg 21.8%); elite outliers both ways.
- Output, *not* accuracy: ~23 jabs thrown per round; combined landed ~34/round
  for two heavyweights.
- Amateur notational (different coder): **winners 33% hit of punches thrown,
  losers 23%**; winners also lower %Air.

Kick accuracy is not a CompuBox object. Head/body/leg accuracy is **not** a
standard CompuBox public split.

**MMA (UFC Stats / FightMetric):**
- Significant accuracy **~40–42% of significant attempts**.
- **Attempts ~7.1 significant per minute** (2008+). The published SLpM band of
  3–4 is just **0.42 x 7.1 ≈ 3.0** — that is the arithmetic tying J20 together.
- Distance-head **~33% of those attempts**; ground-body **~93% of those
  attempts**. **Accuracy rises as the target drops and as range closes.**
- Distance target mix **~80/10/10 head/body/leg of distance strikes**.
- Clinch/ground accuracy is much higher than distance, **which is why a
  wrestler's career Str. Acc. is not comparable to a kickboxer's without a mix
  adjustment** — UFC now publishes "expected accuracy" for exactly that reason.
- **Kick-vs-punch accuracy as a league table: NOT PUBLISHED.**

## 4. THROWER, RECEIVER, OR EXCHANGE

Published box scores **attribute accuracy to the thrower** (connect % / Str.
Acc.) and **avoidance to the receiver** (opponent connect % / Str. Def.).
CompuBox plus/minus is literally thrower connect minus opponent connect.

**But the literature treats the event as an exchange.** UFC's 2025 accuracy piece
is explicit: a distance-head shot lands ~33% because the opponent is moving and
guarding, **not because the thrower is 67% incompetent**. Fightnomics: accuracy
fell then plateaued as offence and defence improved together.

## 5. TARGET AND COMBINATIONS

**Target changes accuracy — measured.** MMA: head at distance hardest, legs
easiest, body between; ground/clinch much easier than distance. Boxing: CompuBox
publishes no stable head/body accuracy table.

**Combinations: NOT PUBLISHED at league scale.** No CompuBox or UFC Stats table
of "same strike alone vs inside a combination". Coaching literature treats the
combination as the tool that occupies the guard so the later shot lands.
Kinematic papers show single maximal punches are *faster at contact* than combo
punches but do not measure live connect %. **G49's jab split (48.8% vs 45.4%,
both of jabs attempted) is a real data point, not a replicated official finding.**

## 6. DO SERIOUS MODELS EMIT MISSES? — YES

> **Holmes, McHale & Żychaluk (2023, International Journal of Forecasting):** MMA
> as a **Markov chain**. From standing, fighter *i* attempts a strike at a chosen
> target; that strike lands with a modelled probability **or it does not; a miss
> returns the chain to Standing.** Ground strikes have the same attempt -> land/
> miss fork with different probabilities. **Attempt rates and land rates are
> estimated as separate skills.**

That is the model class used for forecasting against bookmakers.

**What folding buys:** one fewer roll; the landed count can be matched after the
fact.

**What folding LOSES — and this is our engine today:**

1. **The official denominator.** Accuracy, SLpM-style rates and Str. Def. cannot
   be produced without attempts.
2. **Pace.** Fightnomics and judging research both use attempts, not only lands.
   Judges give some credit to committed misses.
3. **The significant-vs-total filter.** You cannot mark a short ground tap as
   "total only" if the only events that exist are lands.
4. **Technique naming.** A miss is *how a named technique fails*. Without it,
   "jab" and "cross" only exist when they succeed.
5. **Defence as a visible and numeric object.** No miss means no slip, no block,
   no opponent connect %.
6. **Reconstructability.** You can invent attempts after the fact, **but then
   accuracy is a costume — which is why 57.1% is identical in boxing and MMA.**
7. **Viewer grammar.**

> Both designs can match a landed total. **Only the attempt-then-land design can
> be scored against CompuBox or UFC Stats.**

## 7. WHAT A VIEWER SEES

**Yes — the miss is a large part of what a fight looks like.** Amateur templates
split %Hit vs %Air because spectators read dominance from clean connects *and*
from punches that miss. CompuBox exists as broadcast furniture because
thrown-and-landed is the picture commentators talk over.

> **"A simulator that only emits lands will look like two men taking turns being
> hit."**

## VERDICT (Grok's own words)

**(a)** A strike is "significant" when FightMetric codes it as **any strike at
distance, or a power strike in the clinch or on the ground** — not because it was
damaging.

**(b)** **Emit misses explicitly.** Folding can match landed counts; it cannot
match the official denominators or the visible fight.

**(c)** Official stats hang accuracy on the thrower and defence on the receiver;
**the evidence is the exchange. Do not give the miss to one man only.**

## WHAT THIS MEANS FOR US — AND WHAT IT IS *NOT*

**It is a recommendation to reverse U23's "no miss roll" ruling.** That ruling was
made when the engine was much simpler and it is now the thing standing between us
and every published rate we want to be judged against.

**But adding a miss is NOT R101's scope and must not be smuggled into it.**
R101 replaces the coin flip and makes the engine name a technique. A miss roll:

- **adds a draw**, which breaks the documented seven-draws-per-built-impact
  contract and moves every seeded fight a second time;
- changes what `_run_impact` even means — today it is only ever called for a blow
  that happens;
- needs `ImpactModel` to stay the one place a blow is priced (C63's ruling).

**So this is the next stage, proposed on evidence, not a widening of this one.**
It should land as its own cycle, with its own single re-pin, and the significant-
strike filter from (a) should land with it — because that filter is what makes
the accuracy comparable in the first place.

**The cheap half can come earlier:** the significant/total *classification* is a
category rule over range and position, and the engine already knows both. That
part costs no extra draw.
