# R86 DIGEST — THE TIRED MAN FIGHTS WORSE, AND TWELVE ROUNDS STOP BEING A MASSACRE

Owner: Claude. Base `940fcdf` (suite `total=202 fails=0`).
Files: `Godot/scripts/FightRealtime.gd`, `Godot/scripts/ImpactModel.gd`,
`Godot/tests/fight_realtime_test.gd`, `Godot/tests/impact_model_test.gd`.

A man's tank emptied and nothing read it. A twelve-round fight was stopped
100% of the time. Both are closed, and the second one closed with a mechanism
rather than with a tuned constant.

---

## Everything below was MEASURED, twice — before and after

Same probe, same seeds, same two fighters, run against the engine at `940fcdf`
and again after each change. R84's sweep reproduced exactly on the baseline
(5.43 shocks, 0.68 knockdowns, 27 of 120 stopped, head min 49.7), which is what
makes the two columns comparable.

### The standard bout — 120 fights, 3×5

| Figure | R84 (`940fcdf`) | R86 | |
| --- | --- | --- | --- |
| impacts / fight | 815.8 | **749.0** | −8%, the output multiplier |
| shocks / fight | 5.43 | **5.21** | |
| knockdowns / fight | 0.68 | **0.55** | |
| **stopped** | **27 of 120 — 22.5%** | **22 of 120 — 18.3%** | inside the 15–30% band |
| went the distance | 93 | 98 | |
| `head_neck` at the bell | min 49.7, mean 62.4 | **min 68.1, mean 76.1** | |
| stamina at the bell | min 57.7, mean 62.8 | 58.8 / 64.4 | unchanged |

### The championship distance — 120 fights, 12×5

| Figure | R84 | R86 |
| --- | --- | --- |
| **stopped** | **40 of 40 — 100%** | **73 of 120 — 60.8%** |
| **went the distance** | **0** | **47 — 39.2%** |
| methods | 21 doctor, 19 KO | 72 KO, 1 TKO, 47 decision |
| `head_neck` at the bell | (nobody reached it) | min 18.2, mean 40.0 |

**The head, round by round, is the whole story.** It used to be a straight
line and is now a curve that flattens:

| | R1 | R2 | R3 | R4 | R6 | R8 | R10 | R12 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| R84 | 86.7 | 75.3 | 64.7 | 54.0 | 34.1 | 15.7 | — | — |
| R86 | 86.5 | 80.2 | 75.0 | 69.9 | 60.5 | 52.4 | 44.1 | **35.9** |

−10.5 a round, dead flat, against −13.5 in round one easing to −4.3.

---

## A. Fatigue reaches the fight

`FightStamina.fatigue_fraction()` had **zero consumers outside its own test** —
the fifth piece of correct, tested, unreachable code this area has produced.
G31's four multipliers are now wired into `_run_impact`: the ACTOR's tank
drives technique, power and output, the TARGET's drives defence.

**U23 decided the shape, and it is quoted rather than paraphrased.** Cursor's
teardown found no shipped sim publishes a "tired men miss more" accuracy curve.
Fight Night is the landmark on **defence**, UFC 3 on **vulnerability**, and
those two plus Undisputed spend the tired man on **rate** and **power**. So
output, defence and power are the supported steals. `technique_multiplier` is
**our invention and is labelled one in the source** — and it still adds no miss
chance: it moves the same contact ladder every technician already climbs, so a
tired man's blows slide from clean toward glancing rather than into thin air.

### The one ordering change, and why it was needed

The attempt gate used to be the FIRST draw and the actor the second — so the
engine decided whether a blow was thrown before it decided who threw it, and a
gate that does not know the thrower cannot read the thrower's tank. The two are
swapped. **Seven draws per built impact still holds**; a REJECTED attempt now
costs two draws instead of one, and both are still taken unconditionally at the
top of the function. Nothing moved inside an `if`.

The swap moves every seeded fight, which is why the sweep above is quoted in
two columns and why three pinned test seeds had to be re-found (below).

### Proven to occur, not merely to be called

The task named the failure mode exactly: a test that checks
`technique_multiplier` was called is the test that passes while nothing runs.
So it is measured three ways.

**Whole fights, distance-only** (a sweep that keeps stopped fights measures
survivor bias, not fatigue) — punches thrown per fight:

| | R1 | R2 | R3 |
| --- | --- | --- | --- |
| 3×5 | 305.1 | 266.9 | **246.4** (−19.2%) |
| 12×5 | 301.9 | 261.0 | … R12 **222.8** (−26.2%) |

**The same man fresh and empty, down the real `_run_impact`** — because a 3×5
only empties a man to about 60, which is fatigue 0.40, and every exponent in
G31's curve is above 1.0 so the first half of the tank costs him very little.
Each channel is measured on the fighter that isolates it: output, technique and
power against an opponent with defence 0, and defence against a real defender.

**Round-to-round accuracy barely moves and that is the honest result** — clean
lands run 25.8% in round one against 25.2% in round three of a 3×5. The
dominant channel by a distance is OUTPUT: a tired man throws a fifth less. That
is exactly what U23 says the shipped sims do, and it is the reason this reads
as fatigue rather than as a man suddenly becoming a worse fighter.

---

## B. The twelve-round massacre — and why `WEAR_SCALE` was the wrong instrument

**A did not close it.** With fatigue wired and nothing else, 40 of 40
championship fights were still stopped. Reported here rather than assumed,
because the task asked for exactly that check before part B was touched.

**And no value of `WEAR_SCALE` could have closed it.** The head fell 10.5
points a round on a near-perfect straight line, so 12 rounds cost ~126 points
of a 100-point tank. A scale factor is **linear in rounds**: any cut deep
enough to let twelve rounds survive also takes the 3×5 far below the 15–30%
stoppage band the task set as the regression floor, and propping that back up
means re-tuning `HEAD_SHOCK_BASE` and `KNOCKDOWN_FROM_SHOCK_*` against each
other — three constants chasing each other's tails. **`WEAR_SCALE` is
unchanged at 0.6.**

### The corner — the only lever that is not linear in rounds

A 3×5 has two corners; a 12×5 has eleven. That asymmetry is the entire fix,
and it is why the standard bout barely moved while the championship distance
changed completely.

**It is a steal, not an invention.** R85R drove Undisputed first-hand: its
corner HUD shows health **"only partially recovers"**, +1 to +2 a minute, and
the red fighter read 65% at the round-7 corner and 80% at the round-9 one —
health is **not monotonic** across the bout in a shipped boxing sim either.
That same AI bout **went the full twelve and produced a decision**.

**And the minute already existed in this engine.** `_close_round` has been
handing a man his wind back through `FightStamina.rest_recovery` since R84 and
doing nothing at all for his body. `ImpactModel.corner_recovery` is the other
half of the same minute, guarded on there being another round to come by the
same condition, for the same reason: after the final bell there is no corner.

**A flat credit, never a fraction of the deficit.** A fraction hands the most
damaged man the biggest recovery, which is backwards — and it would quietly
repeal the doctor's rule. `CORNER_RECOVERY_PER_MIN = 4.0` at conditioning 50,
scaled by `conditioning / 50` (`FightStamina._recover_scale`'s own shape, so
the corner does not disagree with the wind it restores in the same sixty
seconds about who recovers well). Against a measured ~10.5 points of head a
round, a corner gives back roughly 40% of a round's damage. The **rate is
authored**, the way R44's membership rate is; Undisputed's +1..+2 is the anchor
for the shape, not for our number.

**The scorecards are untouched by it, and that is on purpose.** `RoundScoring`
folds the LOG — the wear each blow actually did — not the body it did it to. A
man whose corner patches him up still lost the round he lost, because judges
score what happened in the round. Nothing is double-counted and no card moved
for any reason but the changed impact stream.

---

## THREE THINGS THAT MOVED AND ARE REPORTED, NOT TUNED AWAY

**1. The three-knockdown TKO got rarer: 8 of 400, against R84's 19 of 400.**
The corner keeps a chin's head healthier and `KNOCKDOWN_FROM_SHOCK_WEAR` reads
off exactly that, so knockdowns fall — and three-in-one-round falls much faster
than linearly. The rule still fires and is still gated. It was not tuned back
up, because 2% for three knockdowns in a round between a 100-power bomber and a
defenceless man is not obviously wrong.

**2. The doctor stoppage no longer fires between two ordinary men over twelve
rounds — 0 of 120, against R84's 21 of 40.** Heads now end at min 18.2, just
above the threshold of 15. It remains reachable and is still asserted, in the
bomber-vs-glass-jaw matchup the R84 gate uses. This is the same judgement R84
made about the 3×5: **15 is a medical rule, not a rate to hit.**

**3. Three pinned TKO seeds had to be re-found.** R84 found 77072/77105/77135
by sweeping 77000..77399; the draw swap moved every seeded fight and all three
stopped being TKOs. Re-swept the same range and re-pinned 77057/77108/77123.
**The search is now recorded in the test** — a pinned seed without its search
written down costs the next person a cycle, which is what it cost this one.

**Finding 3 is untouched and still open.** A split or majority decision is
still arithmetically impossible: damage is the only non-zero weight and judge
bias may not perturb it. That needs grappling, not tuning.

---

## Gates

`fight_realtime_test.gd`: **159 checks, PASS** (was 122). Four new gates:

* **seven draws per built impact, two per rejected attempt** — counted by
  replaying the stream against a second generator restored to the same
  position, not by trusting the comment above `_run_impact`
* **a tired man measurably fights worse** — whole fights round 1 vs round 3
  over distance-only fights, plus the same man fresh and empty down the real
  `_run_impact`, plus the defender's own channel on its own matchup
* **the corner actually gives condition back** — a head that goes back up, is
  never healed past whole, and rises at most once per corner (so nothing is
  credited after the last bell)
* **a championship distance reaches a decision, and is still dangerous** —
  both directions, because the second is the half that would go unnoticed

`impact_model_test.gd`: **53 checks, PASS** (was 33). `corner_recovery`'s
contract: nothing for a whole region, capped at what is missing, flat across
damage levels, more for a longer rest and a fitter man, and safe on
NAN/INF/negative input.

The R82 replay gate is unmoved and green — log, bodies, scorecards, result and
stoppage all byte-identical across two runs of a seed.

## Test command

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd
```
