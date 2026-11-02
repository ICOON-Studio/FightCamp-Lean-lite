# D10 — IS A PER-TECHNIQUE THRESHOLD THE RIGHT MODEL FOR IPPON AT ALL

**Agent:** Dola (Cici desktop app, driven by `Tools/cici/cici.py`).
**Landed by Claude, S49, 2026-09-22.** Raw capture:
`_captures/D10_IPPON_DOLA_raw.txt`, taken whole — her answer begins at her
first line and ends at her `Least sure`, both present in the capture.

**Her answer is NO, and she attacks the premise rather than the number.**

---

## THE RULING SHE CITES, AND IT IS THE WHOLE ARGUMENT

> Under IJF rules (effective March 2023), ippon needs **all four** criteria
> present: **speed, force, landing largely on the back, and control maintained
> until landing.** Waza-ari is awarded when **one or more of the four is not
> fully achieved.**
>
> **"No technique is inherently an ippon. Uchi-mata can be ippon; seoi-nage can
> be waza-ari. The name does not decide — the execution does."**

So a per-technique magnitude threshold encodes a rule the sport does not have.
A flawless o-soto-gari is an ippon, and **our old model forbade it.**

## DO THROW FAMILIES DIFFER? YES — IN FREQUENCY, NOT ELIGIBILITY

| throw | share of elite ippons | her note |
|---|---|---|
| uchi-mata | ~18–22% | most frequent ippon throw overall |
| seoi-nage | ~12–16% | high success rate at lighter weights |
| o-soto-gari | ~8–12% | dominant at heavier weights |

> **"These are outcome statistics, not rule thresholds."** The frequency
> difference belongs as a **baseline probability weight**, not a fixed
> magnitude barrier.

**UNSOURCED — THESE THREE ROWS ARE THE WEAK PART OF HER ANSWER.** She gives no
citation for the shares and the capture shows `Searched for 3 keywords · 9
sources` without naming them. Do not put these numbers in the engine as
measured anchors; they are the shape of a claim, not a study. If the baseline
weight is wanted, it is a research task (John), not a figure to lift from here.

## THE MODEL SHE WOULD PUT IN ITS PLACE

```
land_score = baseline_quality x mastery x alignment x landing_quality
```

| component | meaning | do we have it? |
|---|---|---|
| `baseline_quality` | the technique's **potential**, not its final score — the same authored number we already have | YES — the existing effects sum |
| `mastery_norm` | how well this fighter knows this technique | YES — already computed |
| `plan_alignment` | fits the chosen game plan | YES — already computed |
| `landing_quality` | did it land on the back, with speed and control, against a defender who failed to break the fall | **NO — this is the invented part** |

**`landing_quality` is the only new thing, and she derives it from state she
believes we already track:**

| IJF criterion | her proposed computation |
|---|---|
| on the back | angle between the defender's back vector and the ground plane |
| control | attacker pose stability + whether the defender countered or broke |
| speed / force | relative velocity at release x a mass factor |
| defender resistance | energy the defender spent defending — higher means a harder throw |

**Bands:** ippon at **≥ 0.85 x baseline**, waza-ari at **≥ 0.50 and < 0.85**,
no score below 0.50. Two waza-ari still combine to ippon — *"that rule is
correct and stays"* — but its MEANING changes: waza-ari becomes "partial
execution of this technique's potential" rather than "a fixed gap below a
global number".

Her worked example, and note that it is the one that makes the case:

| technique | baseline | mastery | alignment | landing | result |
|---|---|---|---|---|---|
| uchi-mata, perfect | 19 | 1.0 | 1.0 | 1.0 | 19 → **ippon** |
| uchi-mata, lazy | 19 | 0.6 | 0.5 | 0.7 | 3.99 → waza-ari |
| seoi-nage, botched | 25 | 0.9 | 0.4 | 0.5 | 4.50 → waza-ari |
| o-soto-gari, flawless | 16 | 1.0 | 1.0 | 1.0 | 16 → **ippon** |

**Least sure (hers), and she volunteered it:** *"The exact 85% / 50% split
between bands. I have not found a published source quantifying 'partially
lacking' as a percentage — that is the one number I would want to validate
against referee scoring data. Everything else follows directly from the
rules."*

---

## CLAUDE'S INTEGRATION NOTE

**THE ARGUMENT IS SOUND AND THE COST IS NOT WHAT IT LOOKS LIKE.** Three of her
four factors are already computed, so the model reads as cheap. It is not:
**`landing_quality` needs four quantities that the fight engine does not have
in the form she assumes.** "Relative velocity at release", "defender's back
vector against the ground plane" and "attacker pose stability" are 3D pose
quantities. The fight resolves as a text/stat simulation and the 3D room is a
presenter — so this model, taken literally, moves scoring INTO the 3D layer.
That is a much bigger change than swapping a threshold, and it is the thing to
check before anyone starts.

**SO THE FACT TO ESTABLISH FIRST, and it is one grep, not a study:** which of
her four landing-quality inputs exist as engine state today, in any form. If
the answer is "none of them", her model is a design for a fight engine we do
not have, and the useful half is narrower: **drop the per-technique threshold
and make ippon a QUALITY band on the technique's own potential**, with the
quality term built from whatever the engine already knows about how the
exchange went, rather than from pose and velocity.

**HER PREMISE ATTACK IS RIGHT EVEN IF HER MODEL IS UNBUILDABLE.** "Any throw
can be ippon" is a rules fact, not an opinion, and the current model
contradicts it. That much stands on its own and does not wait for the rest.

**AND THE THREE ELITE-IPPON SHARES ARE UNSOURCED — see above.** This is the
project's recorded pattern of a research agent answering with a plausible
table; it does not become an anchor without a named study and a denominator.

**Related:** [`TASK_D10_IPPON.md`](TASK_D10_IPPON.md) is the brief.
