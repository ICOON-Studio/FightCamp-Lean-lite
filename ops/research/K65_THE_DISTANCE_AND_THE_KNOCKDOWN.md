# K65 — Schortgen's athletes, and boxing's outcome mix

**Kalli · 2026-09-20 · assigned and answered inside the hour, during S29**

Assigned because S29 hit a question mid-stage rather than after it: `fight_room_positions` was
failing a 186/172 cm-reach pair against Schortgen's 1.23 ± 0.16 m, and the gate could not be judged
without knowing who Schortgen measured. Raw transcript captured separately; the rows below are
Kalli's, with its own labels kept.

## Q1 — WHO SCHORTGEN MEASURED. **DOCUMENTED, AND IT SETTLES S29.**

> **33 elite French national boxers (18 F / 15 M), 32 fights, distance = feet-midpoint separation
> on the ring plane. Arm span, reach, height, mass, weight class: NOT FOUND. Stop treating 1.23 m
> as a target for specific reaches.**

And Kalli's own note, unprompted:

> *"Your sims at ~1.06–1.09 m for 186/172 cm reach are not 'wrong' relative to Schortgen until
> Schortgen's body sizes exist; they are uncomparable."*

**That is an independent confirmation of what S29 had already decided from the arithmetic**, and it
arrived from outside the session. It is the third time in two days that assigning the research
returned a verdict on the same day (R151 corrected me, K64 corrected me, K65 confirms me) — and the
value is the same in all three cases: it stopped being my opinion.

**TWO THINGS IT ADDS THAT S29 DID NOT HAVE.**

1. **The sample is 18 FEMALE and 15 MALE — majority female, mixed sex.** The room's pair is two
   men. That is a second population mismatch stacked on the reach one, and it is the more serious
   of the two: this project's own standing rule is that females never fight males, so a mixed-sex
   mean is not a figure any of our bouts can be compared to directly.
2. **The landmark is FEET-MIDPOINT SEPARATION ON THE RING PLANE**, and that is good news: it is
   exactly what `fight_room_positions` measures — `_flat(node.position)` drops Y and takes the X/Z
   distance. So the two instruments agree on *what* is being measured even though they disagree on
   *whom*. The landmark was the other way this comparison could have been wrong, and it is not.

**CONSEQUENCE, AND IT IS NOW SOURCED RATHER THAN INFERRED:** Schortgen's 1.23 ± 0.16 m cannot be
put on any specific pair's ruler and must never be a gate. `fight_room_positions` REPORTS it beside
the reaches and gates the pair's own derived standoff. Do not re-open this.

## Q2 — BOXING'S OUTCOME MIX. **DOCUMENTED, AND OUR ENGINE IS WELL UNDER IT.**

> **US 2017, n = 1,690 — decision 46.5%, TKO 35.1%, KO 18.1%, DQ 0.2%** (Velasco et al. 2019).

**KO + TKO = 53.2%.** S29 measured our boxing at **29.0%** (DECISION 71 / KO 21 / TKO 8 over 100
bouts, `tools/probe_boxing_knockdowns.gd`). That is a far larger gap than the 32–34% MMA figure
S29 was loosely comparing against, and it is a real finding.

**BUT READ THE VARIANCE BEFORE TREATING 53.2% AS A TARGET,** because Kalli reported it in the same
breath and it is the whole caveat:

> **"67.1% of bouts in North Carolina ended in a TKO/KO outcome, while 38.5% of bouts in Nevada
> ended in a TKO/KO outcome."** (DOCUMENTED, Velasco 2019)

A 28-point spread between two US states is **matchmaking, not the sport** — a journeyman-vs-prospect
club circuit stops far more often than a regulated championship one. The all-US 53.2% folds every
level of professional boxing together. Kalli's own instruction:

> *"Do not blend Velasco's all-US 53% KO+TKO with HW-title snippets or MMA knockdown maths."*

**So the honest reading: our 29% is below even Nevada's 38.5%, which is the closest thing in the
row to a regulated, well-matched population.** There is a real gap, it is worth a stage, and the
target is a BAND (38.5–67.1% observed across states) rather than the 53.2% point estimate.

## THE NOT FOUNDS, which are the reliable content

| quantity | result |
|---|---|
| Schortgen's athletes' arm span / reach / height / mass / weight class | **NOT FOUND** |
| knockdowns per bout, professional boxing | **NOT FOUND** |
| share of pro boxing bouts containing a knockdown | **NOT FOUND** |
| knockdowns ÷ landed power head punches, boxing (the UFC 3.9% analogue) | **NOT FOUND** — CompuBox publishes landed/thrown jabs and power punches per fight, but no league ratio of knockdowns to landed power head shots |
| KO% / TKO% / decision% **by weight class** for pro boxing | **NOT FOUND** in opened primaries |

**So Fightnomics' 3.9% stays the only conversion anchor this project has, and it is a UFC figure.**
Boxing has no published equivalent. A boxing conversion rate can therefore be reported but never
gated against a source, and that limitation belongs beside any boxing damage work.

One UNVERIFIED_SECONDARY row worth keeping: PMID 37990916 (*Physician and Sportsmedicine*, 2023,
DOI 10.1080/00913847.2023.2285716) associates KO/TKO rate with weight class, sex and a Fight
Exposure Score — heavyweights, males and debutants higher. The PubMed page timed out, so no
percentages were copied. **If that full text is ever opened it is the weight-class table this row
is missing.**
