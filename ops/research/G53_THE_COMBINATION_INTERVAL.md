# G53 — THE INTERVAL INSIDE A COMBINATION

Grok, Expert tier, 2026-09-10. **120 sources.** Delivered as chat text in the
in-app browser; Grok has no checkout, so Claude captured and committed it.

Asked because R101 was about to author two constants — how long the combination
window is, and how much being inside it raises a man's share — and G49 had
already said honestly that P(same thrower next) is NOT PUBLISHED.

**One of the two came back measured. The other came back refused, and the
refusal is the useful half.**

---

## 1. Inter-punch interval inside one combination

**Fight-footage contact-to-contact inside a combination is NOT PUBLISHED.**

The only measured figure is lab, dummy, prescribed 4-punch sequences, not a
bout. Piorkowski, Lees & Barton 2011 (*Sports Biomechanics*): 10 competition
orthodox boxers.

- Alternating-hand ("in-synch") 4-punch: CONTACT of punch 1 to CONTACT of punch
  4 = **1.04–1.06 s**. That is three intervals → mean contact-to-contact
  **≈ 0.35 s**.
- Same-hand ("out-of-synch") **1.35 ± 0.27 s** for the same span → **≈ 0.45 s**.
- Combination ACTION-to-CONTACT was *shorter* than a single maximal punch
  (in-synch 320–321 ms vs single 607 ± 221 ms).
- Hooks take longer ACTION-to-CONTACT than straights in that study
  (477 ± 203 ms vs 357 ± 178 ms, all modes).

Stanley et al. 2018 (bag, single punches, not combinations): jab delivery
405 ± 150 ms, cross 495 ± 150 ms, lead hook 657 ± 145 ms. So a hook is slower to
deliver than a jab or cross in the lab.

Jab-cross vs hook interval inside a *live* combination: **NOT PUBLISHED.** The
"0.15–0.25 s jab-to-cross window" circulating in coaching writeups is not a
cited measurement.

## 2. How many punches is a combination

**Share of combinations that are 2 / 3 / 4 / 5+: NOT PUBLISHED in boxing or
MMA.** What is published is counts per boxer per round, not a length
distribution.

Boxing, Davis et al. 2013, novice amateur, 3×2 min, n=32, **denominator = one
boxer in one round**: winners R1 2-punch 11.0 ± 3.3, 4-or-more 1.1 ± 1.4;
losers R1 2-punch 8.3 ± 5.9, 4-or-more 0.5 ± 0.9. Triple-punch combinations are
listed as a winner/loser discriminator; no raw 3-punch count in the abstracts.

Davis 2015 elite amateur (3×3 min): 2-punch combinations **≈ 9.5 / 11.4 / 10.2
per boxer** in R1/R2/R3.

Thomson 2012 (pro, WCPAS IX) coded 2-, 3- and 4-punch combinations by type;
modal type was jab-straight (jab-jab in middleweights); 12 types covered 43–64%
of combinations depending on weight. No 2 vs 3 vs 4 split.

Secondary CompuBox "2.1–2.8 punches per combination" / "2–4 cover 90%" is not a
paper.

MMA: Miarka-style TMA counts strikes attempted/landed, not combination length.
MMA punch-count distribution of a combination: **NOT PUBLISHED.**

## 3. Does the interval stretch later in the combination

**NOT PUBLISHED.** Piorkowski reports only first-contact to fourth-contact, not
interval 1 vs interval 3. No fight study splits punch-two-after-one from
punch-four-after-three.

## 4. What the other man does during one

**How often a combination is interrupted by a return shot: NOT PUBLISHED.**

Closest measured split is a 3-bout amateur pilot (Kapounková, "Analysis of a
Boxing Match," 2016). Mean uncontested attack 0.7 ± 0.2 s; attack with opponent
contra-attack 0.9 ± 0.2 s; clash 1.9 ± 0.9 s. In one tabulated match, of
active-phase events: individual attack 25.4%, attack+contra 11.9%, clash 62.7%.
**That is phase type, not "share of combinations that take a return."**

Davis records block-and-counter combinations as a separate class (novice winners
2.8 ± 1.1 vs losers 0.1 ± 0.2 over three rounds) — the defender starts after a
block, not a punch fired inside the other man's burst.

> P(same thrower next) remains unpublished. The engine's 74% shared bursts is
> the coin flip; there is no measured interruption rate to put in its place.

## 5. What starts a combination

**REFUSED.** Landed jab, ropes, stance change as combo triggers are coaching
lore. No notational paper reports a measured antecedent for "combination starts
here." Range gating the action set is G49; do not invent a second trigger.

## 6. The one check

**Intra-combination structure (window length, same-thrower persistence, 2/3/4/5+
mix) is ungradeable against a published intra-combo quantity. That quantity does
not exist.**

If you still want one published number to land a simulated round near, use
Davis 2015 elite amateur: **~10 two-punch combinations per boxer per 3-minute
round (band ~9–11)**, and 4-or-more rare (~0.5–1.3 per round) from the 2013
novice tables. Source: Davis notational video analysis, **denominator = one
boxer, one round**. That grades how often short combinations appear, not the
milliseconds inside them.

For the two constants: the only measured contact-to-contact proxy is ~0.35 s
(lab, alternating hands, dummy). How much being inside that window raises share
vs baseline volume: **NOT PUBLISHED. Shape is yours; both magnitudes are
yours.**

---

## What R101 did with it

- **`FightMoves.COMBO_WINDOW_S = 0.35`** — Piorkowski's alternating-hand
  interval, carried with the honest label that it is a LAB figure on a
  prescribed sequence, not a bout measurement. It replaced a guessed 1.2 s.
- **`FightMoves.COMBO_BOOST = 3.0` stays AUTHORED** — G53 says the magnitude is
  unpublished, so it is labelled as ours.
- **Davis's ~10 two-punch combinations per boxer per round became a measured
  quantity in `tools/measure_r101.gd`** against exactly that denominator. The
  result is a finding, not a pass: we land at 11.79 for boxing, apparently in
  band, but we throw 81.7 times per boxer per round against an elite amateur's
  far lower output — so per throw we combine LESS, and the count only looks
  right because two errors point opposite ways. See `R101_DIGEST.md`.
- **The guessed 1.2 s window was doing real damage.** Under it, two pinned
  boxing bouts became knockouts and a third stayed a round-one KO. At the
  measured 0.35 s all three are decisions. Asking for the number changed the
  engine's behaviour, not just its documentation.
