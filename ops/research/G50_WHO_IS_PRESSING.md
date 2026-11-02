# G50 — WHO IS PRESSING, AND CAN IT BE MEASURED?

Agent: Grok, Expert tier, 99 sources. Research only.
Delivered in chat 2026-09-10; captured verbatim from the browser by Claude and
committed here because Grok has no checkout. Prose is Grok's; headings and this
note are Claude's framing.

**Assigned because G49's own verdict named a term this game cannot evaluate.
The answer is a REFUSAL, and it changes R101's design before a line was written.**

---

## THE HEADLINE

**"Who is pressing" is a narrator's word.** No athletic commission, no official
stats provider, no public UFC Stats field and no CompuBox key measures it.

And the strongest single finding, because it is a *measured negative* rather
than an absence:

> **In a boxing judging study over ~7,300 scored rounds, "movement pressure"
> (time advancing / forcing the opponent back) had essentially NO relationship
> to judge scores once punch features were included.**

So pressure is not merely unmeasured — where somebody did measure it, it did not
carry information that the punches did not already carry.

**R101 therefore does NOT build a pressure term.** G49's recommended conditional
loses its third clause. What survives is better evidenced and simpler.

## THE CANDIDATES TABLE

| Measure | Source | Exact definition | Status |
|---|---|---|---|
| Ring generalship / ring control | ABC Boxing Judge Manual | "The thinking boxer… controlled the action… puts themselves in position to score and not be scored upon. Running and simply avoiding action should not be rewarded." | Judging criterion. **NOT PUBLISHED as a number.** |
| Effective aggressiveness (boxing) | Same manual | "Taking the fight to their opponent… being aggressive and getting positive results." Being beaten to the punch "is not effective aggressiveness." | Criterion. **NOT PUBLISHED as a number.** Walking forward alone is explicitly *not* it. |
| ABC boxing scoring list | ABC Regulatory Guidelines (2005) | Score on: clean punching, effective aggressiveness, ring generalship, defense. **No weights, no formula.** | List only. **NOT PUBLISHED as metrics.** |
| Historical ring generalship | NYSAC 1929 rules | Foresee and neutralize attack; "force an opponent to adopt a style… at which he is not particularly skillful." | Historical wording. **NOT PUBLISHED as a number.** |
| Fighting area control / "octagon control" | ABC Unified Rules of MMA (Plan C) | "Who is dictating the pace, place and position of the bout." Plans B and C "are not taken into consideration unless Plan A is weighed as being even." | Criterion. **NOT PUBLISHED as a number.** Decides ~1% of rounds. |
| Effective aggressiveness (MMA, Plan B) | Same rules | "Aggressively making attempts to finish the fight." Chasing with no result is not scored (2017 clarification). | Criterion. **NOT PUBLISHED as a number.** |
| UFC Stats / FightMetric **control time** | UFCStats.com `ctrl` | Time in a controlling position: ground top/dominant ride or clinch pin vs fence. | **MEASURED** (seconds, per round). **But it is NOT standing pressure** — it is positional hold after a clinch or takedown. |
| UFC Stats "octagon control" standing field | UFCStats tables | **No such column exists.** | **NOT PUBLISHED.** Broadcast phrase, not a stat. |
| FightMetric heatmaps / motion track (2015 demo) | FightMetric / Genauer interviews | Per-round share of time in centre; % of movement coded advance vs retreat. Example: Johnson 29% advance / 13% retreat vs Dariush 14% / 27%. | **MEASURED in a short internal experiment.** Never became an ongoing field. |
| CompuBox | CompuBox methodology | Four keys only: jab connect/miss, power connect/miss. **No position, no direction, no ropes.** | **MEASURED** punches. Pressure: **NOT PUBLISHED.** |
| Video "pressure" features | Boxing judging ML study, ~7.3k scored rounds (Jabbr/DeepStrike) | Distance pressure = time in close proximity. Movement pressure = time advancing / forcing back. Positional pressure = time with opponent on ropes/corners. | **MEASURED inside that paper only.** **Movement pressure had essentially no relationship to judge scores once punch features were in.** |
| "Pressure fighter" | Coaching / broadcast | Career style: walks forward, high volume, forces the pocket. | Label. **NOT PUBLISHED as an operational measure.** |

## 1. MEASURED QUANTITY OR COMMENTARY?

**Mostly commentary plus a judging word.** Official texts never define "who is
pressing". They define *effective aggression* and *control of place/pace/
position*, and they **explicitly forbid scoring forward motion that does not
produce effect**.

> Grok: "That is the same class of problem as momentum: a narrator term sitting
> on top of other observables."

## 2. THE ACTUAL OPERATIONALISATIONS

- **Boxing judges:** four *unweighted* criteria. Effective aggressiveness
  **requires results**; ring generalship is dictating terms, **not mileage**.
- **MMA judges:** Plan A damage/effect; Plan B attempts to finish; Plan C
  pace/place/position. **B and C only if A is even — empirically they decide
  ~1% of rounds.**
- **UFC Stats:** control time is a clinch/ground clock, **not octagon geography**.
- **CompuBox:** punch counts only.

The only standing-pressure numbers that exist anywhere are research/demo work.

## 3. RING GENERALSHIP AND OCTAGON CONTROL

Neither was ever turned into a public time series correlating with outcomes as an
official stat. UFC "octagon control" on broadcasts is the Plan C phrase, **not a
UFC Stats field**.

Control time is the nearest official number and is **the wrong object**:
**a third of UFC decisions since 2015 were won by the fighter with LESS control
time.** Even that clock is not a score.

FightMetric's founder said judges "certainly value" the man moving forward —
**an interview claim, not a validation study.** The paper that actually measured
advancing-time against scorecards found it did not predict judges once punches
were controlled.

## 4. WHICH DIRECTION DOES IT RUN? — NOT SEPARABLE

Official rules *separate* them: pressure without effect is not scored; effect
without walking forward can win the round. **That is a legal separation, not a
causal proof.**

Published data cannot show that pressure causes volume. Forward motion is either
uncounted (CompuBox, UFC Stats standing) or, where counted, adds almost nothing
after punches. **NOT SEPARABLE in the literature that exists.**

## 5. MAN OR MOMENT? — THREE DIFFERENT OBJECTS, NONE OFFICIAL

1. Career style label ("pressure fighter") — coaching.
2. Per-round judging impression — official, qualitative, **secondary**.
3. Second-by-second kinematics — **only experimental tracking**.

**There is no published standing-pressure series at fight frequency.**

## 6. WHAT DOES PRESSURE COST?

Activity cost is **MEASURED** and it is high for everyone: sparring ~70%
VO2peak; amateur 3x3 fights ~89% VO2max equivalent, lactate often 12–18 mmol.

**The pressure premium is NOT PUBLISHED** — there is no published split of extra
VO2, lactate or counter-rate for the man walking forward versus the man circling
or countering in a live bout. Extra fuel burn and extra counters while closing
are **coaching lore**.

## 7. THE ONE OBSERVABLE, IF WE IMPLEMENT ONLY ONE

**Signed range-rate: who is reducing separation.** Free from the two positions we
already have at 20 Hz.

**How wrong it is, in Grok's own words:**

> Official rules say this is not effective aggression; the one large boxing
> feature study says advancing-time does not track scorecards once punches are
> known; UFC control time (a different object) does not track decisions either.
> It is the least-invented proxy and **it will call a man "pressing" while he is
> being walked onto counters. That error is the reason the commissions wrote
> "effective" in front of the word.**

## VERDICT (Grok's own words)

**(a)** **Narrator's word.** Judging criteria name effective aggression and
place/pace/position; **no commission or official stats provider measures "who is
pressing."**

**(b)** **Signed closing of distance** (who is reducing metres between the two
bodies).

## WHAT R101 TAKES FROM THIS

1. **DO NOT BUILD A PRESSURE TERM.** G49's conditional had three clauses; this
   removes the third. Not because it is hard, but because where it was measured
   it carried no information the punches did not already carry.
2. **The surviving conditional is:** time since this fighter's last throw (the
   burst / combination window), and his own baseline volume share — which comes
   from the MAN (attributes, fight plan, pace), not from the geometry.
3. **Range still gates the action set** (Hristovski, via G49). That is unaffected
   and remains the `range_band` bridge.
4. **If we ever want the term back, it is signed range-rate and nothing else** —
   computed from two positions we already have, costing no new state, and it must
   be labelled AUTHORED with this study's caveat attached: it calls a man
   pressing while he is being walked onto counters.
5. **"Effective" is the load-bearing word.** Both rulebooks refuse to score
   aggression without result. Any future pressure work must gate on effect, which
   the engine already has in `ImpactModel`.

## THE PATTERN, TWICE IN ONE DAY

G49 refused momentum; G50 refuses pressure. **Both were asked sceptically and
both came back negative, and both refusals made the design smaller.** That is
the forecast-research rule working exactly as intended: the question was answered
before the build stalled on it, and R101 is simpler and better evidenced than the
version that would have been written on intuition.
