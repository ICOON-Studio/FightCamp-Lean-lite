# TASK R151 — JOHN — WHAT IS FIGHTMETRIC'S "3.9% KNOCKDOWN RATE" A SHARE OF?

**Agent:** John (deep research) · **Model:** research mode, no shell, no repo checkout
**Assigned:** 2026-09-20 by Claude, out of S26
**Deliverable:** `research/R151_THE_KNOCKDOWN_DENOMINATOR.md` — send the file back; you land
your own research files and you never edit `HANDOFF.md`.

---

## THE PROBLEM IN ONE PARAGRAPH

Our validation corpus (J20, which you wrote) carries two figures about knockdowns that **cannot
both be a share of the same thing**, and an engine calibration stage has now run into the
contradiction. Section F quotes a FightMetric knockdown rate of **3.9%**, described as a share of
landed power head strikes, and falling by round **5.3% → 2.4% → 1.5%**. Section A and section B
together say a UFC bout averages **71.3 combined significant strikes landed** of which **63% go to
the head** — about **44.9 landed head strikes a fight**. Section F also says a bout averages
**0.41–0.52 knockdowns**. But 0.41–0.52 knockdowns over 44.9 landed head strikes is about
**1.0%**, not 3.9% — a factor of four apart.

**We need to know which denominator the 3.9% is a share of**, because our engine's per-strike
knockdown rate is judged against it and the two readings give opposite verdicts: against 3.9% the
engine is four times too gentle, against ~1.0% it is roughly correct.

## THE QUESTION, IN THE ORDER THAT SETTLES IT

1. **What exactly is the 3.9% figure's denominator in the original FightMetric/UFC source?**
   Candidates, and we want to know which — or that it is none of these:
   - landed **power** head strikes (what section F currently says),
   - landed **significant** head strikes including jabs,
   - **attempted** head strikes rather than landed,
   - **distance-only** head strikes, excluding clinch and ground,
   - all landed significant strikes to any region,
   - something else entirely.
2. **Is it the same corpus and era as the 0.41–0.52 knockdowns-per-bout figure?** If one is a
   1990s-2010s all-history mean and the other is modern, the ratio between them is meaningless and
   that is itself the answer.
3. **Does the by-round fall (5.3 / 2.4 / 1.5%) share that denominator**, or is it a different
   statistic again? A rate that falls 3.5× across three rounds is a strong claim and we would like
   to know what it is a rate of before trying to reproduce its shape.
4. **What is the per-landed-head-strike knockdown rate, if anyone publishes it directly?** That is
   the number our engine can be compared against without arithmetic in between.

## WHAT MAKES THIS ANSWERABLE RATHER THAN A GUESS

You wrote J20's section F, so **your own sources are the starting point** — go back to the exact
page or paper the 3.9% came from and read its definition, rather than re-deriving it. If the
original source does not state a denominator explicitly, **say so plainly**: "the source asserts
3.9% and does not define its denominator" is a complete and useful answer, and it tells us to stop
using the figure as an anchor.

## RULES

- **Label every claim** with J20's own grading vocabulary: **DIRECT** (a definition read off an
  official/primary source this session), **INHERITED** (a secondary aggregate), **INFERENCE**
  (your arithmetic, marked as yours), **NOT FOUND** (searched, nothing).
  A number with no denominator stated in its source is **NOT FOUND**, not INFERENCE.
- **Quote the definition verbatim** where you find one, with the URL and the date you opened it.
  A paraphrase of a definition is how this contradiction got into J20 in the first place.
- **Do not reconcile the two figures by picking the one that suits us.** If they genuinely disagree,
  the deliverable is "they disagree, here is why, here is which one is safe to anchor on".
- **No repo paths, no git, no test commands** — you have no checkout and none of this needs one.
- If a figure turns out to be unusable as an anchor, say what SHOULD be anchored on instead.

## WHY IT MATTERS, SO YOU CAN JUDGE YOUR OWN SCOPE

S25 refused to scale a knockdown constant because doing so would have hidden a volume error; S26
then fixed the volume and knockdowns fell to **0.333 a fight against the 0.41–0.52 anchor**, with
**30.0% of bouts carrying one against 35.1%** — both close, with no knockdown constant ever
touched. The one figure that still says the engine is badly wrong is the 3.9%, and it is the one
figure whose denominator we cannot verify. **If the 3.9% is not what we think it is, there is no
knockdown defect left to fix** and the next stage is something else entirely.
