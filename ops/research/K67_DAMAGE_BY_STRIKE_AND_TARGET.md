# K67 — What real data exists on damage by strike family and target region

**Kalli, 2026-09-21. Transcribed into the repo by Claude** (Kalli has no
checkout). The full reply lives in Kalli's chat; the capture below preserves the
findings, the sources and the negative results. Where a line was clipped by the
transcript reader it is marked `[clipped]`.

**Kalli's own closing line:** *"K67 complete. No multipliers recommended. The
evidence that exists is almost all finish composition and one head-specific
per-strike KD rate."*

That is the headline. **It refused to convert finish shares into per-strike
multipliers, because the task forbade inventing numbers — and it was right to.**

## WHAT HAS NO NUMBER — findings, not unfinished work

Kalli's own framing. Every one of these was searched for and does not exist as a
published figure:

- **Per-landed-strike finish or knockdown rates by strike family** — punch vs
  elbow vs knee vs kick, and head-kick vs body-kick vs leg-kick. The 3.9%
  Fightnomics figure is head-POOLED power strikes at distance.
- **Per-landed-strike stoppage rates by target for body and leg.** Head has the
  3.9% KD rate; body and leg have no equivalent.
- **Body-shot / liver-shot share of UFC finishes** as a published aggregate.
- **Cut / laceration cause split** — elbows vs punches vs incidental clashes.
  Doctor-stoppage papers give laceration prevalence among stoppages, not weapon
  attribution.
- **Cut rate or doctor-stoppage rate per landed elbow.**
- **Leg-kick TKO rate**, per bout or per landed leg strike.
- **Any quantitative measure of cumulative mobility loss from leg kicks.**
  *"Video and journalism document that leg-kick TKOs happen. That is not a
  rate."* UFC Stats logs leg strikes landed/attempted only; linking those to a
  stoppage needs video coding nobody has published.
- **A published conversion from finish-method shares into per-strike
  multipliers** — Kalli notes doing that conversion would be inventing a number.

## WHAT DOES EXIST, AND WHAT EACH THING CAN AND CANNOT SUPPORT

| usable shape | supports | does NOT support |
|---|---|---|
| Fightnomics **3.9% KD per landed distance power head** | head-targeted standing power damage → KD | family-specific rates; body/leg; clinch/ground |
| Finish-method shares (**punches ≫ kicks ≈ elbows ≈ knees** among stoppages) | a prior over which weapon shows up when fights end | relative hardness of one landed elbow vs one landed hook |
| Doc-stoppage: **facial lacerations dominate** doctor stops | cuts are a real stoppage channel | elbow-specific cut frequency |
| Concussion finals **~90%+ head-targeted** | body and leg are rare FINAL targets | relative accumulation damage of body/leg work |

## SOURCES

- **Kuhn, R.** — Fightnomics / Fightnomics Snapstats. Distance knockdown rate
  3.9% of landed distance power head strikes; KD/10 min; conditional finish
  after KD. FightMetric-era UFC.
- **Miarka B. et al. (2022).** Concussion vs. resignation by submission.
  *Frontiers in Neurology*, DOI `10.3389/fneur.2022.941829`. Tables 2–4: ending
  technique frequencies and final target.
- **Miarka B. et al. (2019).** A 12-Year Cohort Study of Doc-Stoppage in
  Professional MMA. *Int J Sports Physiol Perform*, DOI
  `10.1123/ijspp.2017-0131`. Facial >90%; lacerations 80%; n = 220 + 220.
- **Hutchison M.G. et al. (2014).** Head Trauma in Mixed Martial Arts.
  *Am J Sports Med*, DOI `10.1177/0363546514526151`. KO implement shares;
  mandible 53.9%.
- **Follmer B. et al. (2019).** Head Trauma Exposure in MMA Varies According to
  Sex and Weight Class. *Sports Health*, DOI `10.1177/1941738119827966`.
  Punches **75% male / 58.3% female** of KO/TKO finishes.
- **Twenty Years in the Octagon (2026).** *Applied Sciences* 16(4):2034, DOI
  `10.3390/app16042034`. Punch share of KO/TKO **77.4% → 86.1%**; kick share
  **20.5% → 11.3%** across UFC era windows.
- **Exploratory analysis of fight-ending punches in the UFC (2024/2025).**
  *Int J Sports Science & Coaching* / Edith Cowan University. 264 punch-ended
  UFC KO/TKOs 2020–22; **hooks ~51%** `[clipped]`.
- **UFC Stats / FightMetric data model** — significant strikes by head/body/leg
  and distance/clinch/ground; `result_details` free-text finish descriptors.
  Existence confirmed; **no published elbow-cut roll-up** `[clipped]`.

## THE TRAP THIS TASK WAS WRITTEN AROUND, AND IT HELD

"Knockout percentage" is almost always reported **per BOUT**, and a damage model
needs it **per LANDED STRIKE**. A source saying "43% of UFC fights end by KO/TKO"
says nothing about how hard an elbow is relative to a hook. Kalli kept the
denominators separate throughout and flagged the per-bout forms as such.

## WHAT THIS MEANS FOR THE ENGINE

**Exactly one row of a strike × target damage table can be sourced**: head,
standing, power — 3.9% KD per landed strike. Everything else is either a finish
COMPOSITION share (which describes what ends fights, not what one strike does) or
absent entirely.

**The operator ruled on this on 2026-09-21, verbatim: *"whatever isnt sourced or
we lack data we approximate to the game scale"*.** So the table gets built, and
every row carries its provenance:

- `SOURCED` — a published per-landed-strike figure with its denominator.
- `SHAPED` — derived from a finish-composition share, which constrains the
  ORDERING of values but not their magnitude.
- `APPROXIMATED` — no public number exists; the value is authored to the game's
  scale and is a tuning knob, labelled so nobody later mistakes it for evidence.

A row that does not say which of the three it is must not be added.
