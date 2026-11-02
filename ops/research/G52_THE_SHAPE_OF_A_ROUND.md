# G52 — WHAT DOES A ROUND LOOK LIKE, MINUTE BY MINUTE?

Agent: Grok, Expert tier, 97 sources. Research only.
Delivered in chat 2026-09-10; captured verbatim from the browser by Claude.
Prose is Grok's; headings and this note are Claude's framing.

**Assigned because R101 produces a burst structure and every number in the
validation corpus is a TOTAL — blind to temporal shape.**

---

## THE HEADLINE, AND THE GRADE TO USE

> **(a) NO.** Usable within-round timelines — minute splits, last-10-s rate,
> metres-in-range, exchange-end causes — **are not published.** The corpus is
> round/bout totals plus intensity-block averages. **A sim can match SLpM and
> still be a drizzle.**

> **(b)** Grade a simulated **MMA 5-minute standing-heavy round** against the
> **UFC PI block: high-intensity 6–36 s, then low/moderate 2–3x that duration,
> repeating.** Expect on the order of **6–10 HI blocks per 5 min** if the mid of
> that band is used (≈15 s HI / 30–45 s LO). Secondary boxing check: **3–7 fight
> sequences per 3-min round** with interruption pauses ~5 s.
> **Do not grade against time-in-range or last-10-s output. Those numbers do not
> exist.**

## THE SAVE THIS STUDY ALREADY MADE

Our engine measures **35% of ticks inside the 1.1 m gate**. Pro boxing notational
work reports **direct contact 35.6% of scheduled fight time**.

**These two numbers are nearly identical and they are NOT the same quantity.**
G52 flags it explicitly: contact-time is not a metre gate, and the MMA
"keeping distance" figure (~130 s of a 300 s round) is *out-of-pocket* time, the
opposite construct.

Matching our 35% to their 35.6% would have been the exact error that cost this
project real time on 2026-09-10 — comparing hand travel against centre-to-centre
separation in one table and inventing a crisis. **Two numbers in the same column
must be the same quantity.** This one is a coincidence and must never be cited as
a validation.

## THE TABLE

| Quantity | Sport | Source | Definition | Value (denominator named) | Status |
|---|---|---|---|---|---|
| Activity : break (A:R) | Boxing, elite amateur | Davis 2015 / Chaabène | Net activity vs clinch + ref stop; **circling/feinting counts as activity** | **~18:1 to 19.3:1 of in-round time.** Novice R1 16:1, R2 8:1, R3 6:1. Elite stop-time 21.5 / 32.3 / 50.2 s of a ~189–201 s round | MEASURED |
| Fight-sequence : pause | Boxing, Olympic 3x3 | Cosma 2024, Tokyo 2020 (73 bouts) | Continuous action between internal pauses | **3–7 fight sequences per 180 s round** (rises R1→R3). Mean length ~25–87 s (welter ~29 s, feather ~56 s). Pauses ~5 s; official stops ~19–22 s. **Only 9.35% of 214 rounds had zero internal pauses** | MEASURED |
| High : low intensity + pauses | MMA | del Vecchio 2011; Miarka; UFC PI | HI vs (LO + in-round pause) | **1:2 to 1:4 of in-round time.** UFC PI: **HI block 6–36 s, then LO 2–3x longer, repeating** inside the 5 min. 77% of UFC fights won inside a 6–36 s HI window | MEASURED |
| HI / LO block lengths | MMA, regional | del Vecchio 2011 | Activity periods and nested sequences | **2–3 activity periods of 53–79 s per round**, split by 8–10 s pauses. Inside: **3–4 standing HI sequences of 6–9 s**; standing LO 15–18 s; ground HI 8–14 s | MEASURED |
| Short attack / clash | Boxing / kickboxing | Šalaj 2016; Ouergui 2014 | Timed active phases | Boxing active phase **1.2±0.8 s**; attack 0.7±0.2 s; clash 1.9±0.9 s. Kickboxing HIA 2.2±1.2 s, pause 5.4±4.3 s; **~25–27 HIA per 3 min round** | MEASURED |
| Direct-contact share | Pro boxing | Russian notational, 12x3 | Contact vs non-contact vs stoppage | **Contact 35.6% of 2160 s scheduled time.** Non-contact 57.5%. Stoppages 6.9% (~46 ref stops/fight, ~3 s each) | MEASURED — **"contact" ≠ our 1.1 m gate** |
| **Time both men inside striking distance (<=1.1 m)** | Both | — | Our engine gate | **No published figure** | **NOT PUBLISHED** |
| MMA "keeping distance" stand-up time | UFC | Miarka 2017, 2814 rounds | Stand-up at distance | ~128–131 s of a 300 s round (bantam/feather) | MEASURED — **wrong construct**, this is out-of-pocket time |
| Striking-time share | MMA sparring | Kirk 2020 | Striking vs non-striking over 3x5 | 128.5 s vs 319 s ≈ **29% of ~448 s bout time**. The popular "~31% of fight time" is **not peer-reviewed** | MEASURED (sparring) / lore |
| **Output change inside one round** (min 1 vs 2 vs last 10 s) | Both | CompuBox; TMA | Rate by minute or last-10-s window | **CompuBox and academic TMA are per-round totals. Last-10-s flurry is coaching/broadcast lore. No population rate.** | **NOT PUBLISHED** |
| Across-round shape | Boxing amateur | Davis 2015 | Stoppages/activity by round | Stops and clinch time rise R1→R3; time to first stop falls 62 s → 31 s | MEASURED (between rounds only) |
| Across-round shape | MMA | Miarka | % low-intensity by round | 5-round fights: low-intensity **79% of that round** vs 75% in 3rd-round endings; 4th rounds 84% vs 76% | MEASURED |
| What closes an exchange | Boxing Olympic | Cosma 2024 | Coded pause cause | Interruptions (head down, holding/illegal), clinch, ref stop. **No frequency table of clean-counter vs step-out vs exhaustion** | Partial / rest **NOT PUBLISHED** |
| **Exchange-ending event distribution** | MMA | — | Share ended by counter / exit / clinch / ref / gassing | **None** | **NOT PUBLISHED** |

## THE PROSE, CONDENSED

**1. Work-to-pause, denominators named.** Boxing's 18:1 is **activity vs
stoppage, not punching vs circling** — circling, feinting and breathing are
*inside* the 18. Real internal pauses in Olympic boxing are ~5 s interruptions
plus rising clinch/stop time. **MMA's denominator is different**: HI vs (LO +
pause) inside the 5 min, at 1:2 to 1:4. **That is the UFC PI 6–36 s on / 2–3x off
cycle, not an 18:1 boxing clock** — do not carry one sport's ratio to the other.

**2. Exchanges per round depend entirely on the coding unit.** Olympic boxing
fight sequences: 3–7 per 3 min, tens of seconds each, packed with many 2–5 punch
sequences. Kickboxing HIAs: ~25 per 3 min at ~2 s each. MMA activity periods: 2–3
per 5 min at 53–79 s, each containing a handful of 6–9 s standing HI bursts.
**There is no single published "exchange" definition that matches a combination
window.**

**3. Inside one round.** Between-round change is measured; **minute-by-minute and
last-10-s output are not**. The ten-second clapper flurry is lore.

**4. Time in range.** Not published at any metre gate. **Do not grade our 35%
against a number that does not exist.**

**5. What ends an exchange.** Measured in Olympic boxing only as *pause type*.
**No distribution of clean counter vs step-out vs exhaustion.** MMA: not
published.

**6. 3 min vs 5 min is not the same shape stretched.** Boxing: a few long
sequences that fragment and pick up pauses as the round and the bout age. MMA:
the HI/LO cycle repeats plus clinch/ground state changes; **4th/5th rounds add
more low-intensity share, not more burst density.**

## WHAT R101 TAKES FROM THIS

1. **There is now a gradeable target and it is not a total:** 6–10 HI blocks per
   5-minute round, HI 6–36 s, LO 2–3x the HI. Q40's harness should be extended to
   report it once R101 lands.
2. **The burst is tens of seconds and contains many short exchanges** — 3–4
   standing HI sequences of 6–9 s inside a 53–79 s activity period. So the combo
   window (~1 s, G49) and the burst (~6–36 s) are **two different timescales**,
   and R101 must not conflate them.
3. **Do not grade against time-in-range or last-10-s output.** Both NOT PUBLISHED.
4. **Do not carry boxing's 18:1 to MMA.** Different denominators, different
   constructs.
5. **A pause is normal, not a defect:** only 9.35% of 214 Olympic rounds had zero
   internal pauses.
