# S29 — the gates were fitted to a sample, and the engine was obeying its own model

**Claude · 2026-09-20 · engine stage, ENGINE FIRST arc · continues S28**

## THE SHORT VERSION

S28 proved `FightIntent.preferred_range`'s 1.2 base is **sourced** — Hristovski's jab-reach shape D,
agreeing within 3% with `FightMoves.SCALED_LONG` 1.17 cut from 200 boxing bouts — and that the 1.39
which turned seven tests green was **fitted to a gate**. It handed S29 seven red tests and a
diagnosis: *the men close while idle where a real fighter holds range.*

**Five of the seven were gate defects and the engine was never wrong.** S29 changed **no engine
line**: the entire diff is tests, four new probes, and Q113's collected `ROLE_PRIORITY_FROM_PLAN`,
which is `false` and byte-identical when off.

| test | what it was gating | what it gates now |
|---|---|---|
| `fight_room_positions` | one seed of one pair against a study's population mean | four seeds against the pair's **own** model standoff |
| `fight_beat_range` | hope a no-actor beat occurs in one two-round bout | the branch, called directly, both directions |
| `fight_knockdown_count` | a count in 20 bouts of an **8%** event | knockdowns (29% of bouts) + a searched count |
| `fight_grapple_seam` | a ground strike inside the first **45 s** | runs to the decide arm's own 900 s pump |
| `fight_commitment` | the **sign** of a 0.95-point move at SE 2.40 | a floor derived from the run's own n |

**All five broke on the same commit for the same reason.** S26 put the fight's pace on J20's D1
anchor — about seven landed a minute where the engine had been throwing 6.9× that. Every gate that
had been relying on 6.9× the volume to make a rare event common lost its sample at once, and each
one reported the loss as a defect in the thing it guards.

## STAGE 0 — THE CENSUS REFUSED THE OBVIOUS FIX

`FightIntent.decide` takes an optional `opponent` dictionary. U44 (`24bbc931`, 2026-09-11) filled it
with four bumps: a short man closes, **a long man sits the jab-reach seat and HOLDS**, a kited man
retreats, a man inside longer arms circles. It has exactly **one** live call site,
`FightRealtime.gd:2343`, and that site passes `{}`. It has been dead for nine days, and
`_LONG_HOLD_BUMP` is *literally* the "hold range" behaviour the handover was chasing. **The eighth
piece of correct, tested, unreachable code this area has produced.**

`tools/probe_opponent_read.gd` asks `decide` the same question both ways over a uniform roll sweep
on every decision tick of the shipped engine:

| | MMA | boxing |
|---|---|---|
| any bump live | **67.88%** of decision ticks | 66.64% |
| the answer changes | **73.15%** | 66.64% |
| CLOSE | 11.36% → 20.02% (**+8.66**) | 14.47% → 18.71% (**+4.24**) |
| HOLD | 33.70% → 27.88% (−5.82) | 34.23% → 30.29% (−3.94) |

**It is a global close buff wearing a hold-range label.** The short-man bump fires on exactly
**50.00%** by construction — in any pair, one man has a reach deficit — and is unconditional on
position; the hold bump needs him sitting on the edge and reaches 17.88%. Wiring it would have moved
the gap *the wrong way* while looking exactly like the repair. **DO NOT WIRE IT AS WRITTEN.**

This is the arc's own rule paying for itself a fifth time (S21, S22, S23 ×2, now S29): *measure the
share of events a state would fire on before scaling anything by it.*

## THE PHASE CENSUS, AND WHY THE HANDOVER'S DIAGNOSIS DID NOT SURVIVE IT

The same probe reports what a man is doing between exchanges, on the shipped weights:

| phase | share of decision ticks | CLOSE weight | standing gap |
|---|---|---|---|
| `engage` | 55.38% | 7.52% | **0.730 m** |
| `reset` | 36.94% | 16.91% | 1.355 m |
| `measure` | **7.59%** | 11.65% | 1.141 m |

*(MMA, 12 bouts. Boxing: 48.98 / 44.39 / 6.56%.)*

**Between exchanges the men already hold 1.36 m, which is right.** The tight number is `engage` at
0.730 m, and `engage` is more than half the fight. So "he closes while idle" is not what the engine
does — and `FightBetweenExchanges.MEASURE`, the studying phase, carries **no lean at all** by S4e
(6)'s deliberate choice and is only 7.59% of the fight.

And the calibrated instrument, `tools/measure_between_exchanges.gd`, reports **every** quantity
inside its published band on the current tree: exchange spell 1.58 s (JPES clash 1.9 ± 0.9), pause
spell 1.64 s (Ouergui 5.4 ± 4.5 — low in band, and worth its own slice), in-range share 0.490
(Ouergui HIA ~0.40 / Cappai fighting ~0.60), **gap mean 1.105 m boxing and 1.108 m MMA — inside
Schortgen's 1.07–1.39 m.**

**The engine's gap is inside the band. The gate said it was not.**

## THE 5 CM, AND IT IS THE POPULATION

Two instruments, two numbers. The arithmetic settles it without a single further run:

| pair | reaches | each man's `preferred_range` × his own arm | **model standoff** | measured |
|---|---|---|---|---|
| the room's (`DEMO_STYLES`) | 186 / 172 cm | 1.215 m / 0.960 m | **1.087 m** | 1.055 m (12 seeds) |
| the instrument's | 190 / 175 cm | 1.277 m / 0.993 m | **1.135 m** | 1.105 m (12 bouts) |

**Both sit 3 cm under their own pair's model standoff.** The 5 cm between the two instruments is
*the two pairs being different men*, and the room's men are short. Schortgen's 1.23 ± 0.16 m is a
mean over **elite boxers** and the abstract publishes no reaches, so it cannot be put on this pair's
ruler at all. Asserting that a 172 cm-reach man stands where tall men stand is asserting the
population.

**And this is exactly why 1.39 turned the gate green:** it lifts the room pair's model standoff to
≈1.24 m, landing it on Schortgen's mean. The constant was fitted to this gate, as S28 said, and the
arithmetic now shows the mechanism.

## THE SEED SPREAD

`tools/probe_room_gap_seeds.gd`, twelve seeds of the gate's own measurement:

```
1.059  1.067  1.037  1.078  1.066  1.057  1.073  1.036  1.072  1.066  1.084  0.963
n=12  mean 1.055 m  min 0.963  max 1.084  SPREAD 0.121 m
inside Schortgen's band: 4 of 12
```

**The spread is 0.121 m against the 0.011 m the gate was failing by — eleven times.** A one-sample
gate cannot separate a 1% miss from a seed.

## WHAT THE GATES READ NOW

**`fight_room_positions`** derives its expectation from the two men who actually fought — each man's
`preferred_range` times his own arm, bracketed by `FightIntent.tolerance` — over four seeds, and
REPORTS Schortgen with the reaches named. Measured: **1.059 m against a model standoff of 1.087 m,
drift 0.028 m on a ±0.225 m band.** It is stronger than the band it replaces: it fails the moment
the room stops obeying `preferred_range`, which the band could not see, and it cannot be passed by
tuning that constant because moving it moves the target. Three new checks, 24/0.

**`fight_beat_range`** calls `_compute_range_fields` directly — no actor → unknown/0.0, no
`preferred_range` → unknown/0.0, both present → NOT unknown (the direction that stops the first two
passing on a function broken into returning "unknown" for everything). The bout is kept as a report.
189/0.

**`fight_knockdown_count`.** Boxing was never broken. `tools/probe_boxing_knockdowns.gd`, the gate's
own population and seed base, 100 bouts:

```
knockdowns         0.30 a bout, 29.0% of bouts   [J20 D5 0.41-0.52; C107 0.40]
counts started     9 of 100 bouts = 8.0%
outcome mix        DECISION 71 / KO 21 / TKO 8 = 29% KO/TKO  [sport 32-34%]
landed power head  26.8 a bout [J20 10.5-13.3] converting at 1.12% [Fightnomics 3.9%]
```

**The first seed that produces a count is 810026 — six past the end of the twenty the gate reads.**
At 8%, twenty samples miss entirely with probability 0.92²⁰ = **18.9%**. The common event
(knockdowns) is now gated on those twenty bouts; the rare consequence is *searched* with an early
exit — expected cost ~12 bouts, 60-bout ceiling, false-red 0.7%. 47/0.

*(The 26.8 landed power head strikes against J20's 10.5–13.3, converting at 1.12% against
Fightnomics' 3.9%, is the same 2× denominator and same under-conversion S25/R151 recorded for MMA.
They partly cancel, which is why the outcome mix lands at 29%. That is Q113's role-mix question —
S30 — not this gate's.)*

**`fight_grapple_seam`.** The DECIDE arm pumps seed 77321 to 900 s and passes; the PLAY arm stopped
at 45 s and reported `routed=0` for a seam the decide arm had just proved. The window now runs to
the decide arm's own pump. **A gate that waits as long as its own evidence-gatherer is a gate about
the seam; one that stops earlier is a gate about the clock.** 57/0.

**`fight_commitment` S4E5-6** demanded `connect%` rise strictly, from six bouts. With the
denominator published: **52.30 → 51.35, −0.95 points against a standard error of 2.40 on n=891/849**
— four tenths of one standard error. The rule's own label already said *"the SIZE is J24's NOT FOUND
and is not bounded here"*, so it was gating the sign of an effect nobody has a magnitude for. The
mechanism stays gated exactly (off suppresses nothing, on suppresses 28); the rate now has a floor
derived from the run's own n, so it still fails if commitment genuinely makes the answering man
connect less. PASS.

## THE RE-PINS, AND WHOSE THEY ARE

`grapple_adapter` (6 Muay Thai striking numbers) and `judge_panel` (13 cards) were re-pinned.
**S29 caused neither.** The cause is `1ebff04f` — the 1.39 → 1.2 revert, the only commit touching
`Godot/scripts` between S28's baseline and here — plus S28's own standing TKO ending some bouts
earlier. Every value was taken from the test's own printed **ACTUAL** (the FAIL line reads
`expected=OLD actual=NEW`; reading it the other way round silently re-pins the old value and disarms
the tripwire), and every one reproduced across two runs.

## WHAT IS STILL OPEN

- **The pause spell is 1.64 s against Ouergui's 5.4 s mean** — inside the ±4.5 band, so not a gate
  failure, but 0.30× the mean and worth its own slice. `MEASURE` is the phase that would hold it and
  it is the one phase with no lean. S4e (6) left it deliberately; the measurement has changed since.
- **The role mix** — Q113 landed the fix behind `ROLE_PRIORITY_FROM_PLAN`, default OFF. It moves the
  D3 split, the pace and the knockdown anchors together, which is why it is flipped at integration
  with all three measured at once.
- **Schortgen's athletes' reaches.** Without them the study cannot be converted to any pair's ruler.
  That is a research question, not an engine one, and it is the only thing standing between this
  gate and a genuine outside anchor.

## K65 CAME BACK INSIDE THE HOUR AND CONFIRMED THE CALL FROM OUTSIDE

The Schortgen question was assigned to Kalli **mid-stage**, not filed as an open question — the
standing rule is that a question put to the operator is research that was not assigned in time.
It came back the same session. Full row: `research/K65_THE_DISTANCE_AND_THE_KNOCKDOWN.md`.

**DOCUMENTED: Schortgen's 1.23 ± 0.16 m is 33 elite French national boxers, 18 FEMALE and 15 MALE,
over 32 fights, measured as feet-midpoint separation on the ring plane. Arm span, reach, height,
mass and weight class: NOT FOUND.** Kalli's own unprompted note:

> *"Your sims at ~1.06–1.09 m for 186/172 cm reach are not 'wrong' relative to Schortgen until
> Schortgen's body sizes exist; they are uncomparable."*

So S29's decision is now **sourced rather than inferred**, and the sample is *worse* for this
comparison than the stage assumed: it is majority female and mixed-sex, and this game's own
standing rule is that females never fight males. One thing it confirms in the other direction — the
landmark is feet-midpoint on the ring plane, which is exactly what `_flat(node.position)` measures,
so the two instruments agree on *what* and differ only on *whom*. That is why Schortgen stays
REPORTED beside the reaches rather than dropped.

**AND A SECOND FINDING THIS STAGE DID NOT GO LOOKING FOR, WHICH IS S30/S31's.** Boxing's outcome
mix is **DOCUMENTED** (Velasco et al. 2019, US 2017, n=1,690): **decision 46.5%, TKO 35.1%,
KO 18.1%, DQ 0.2% — KO+TKO 53.2%.** Our engine measured **29.0%** this session. That is a far
bigger gap than the 32–34% MMA figure S29 was loosely comparing against.

**Read the variance before treating it as a target.** The same paper records **67.1% of North
Carolina bouts ending in TKO/KO against 38.5% in Nevada** — a 28-point spread between two US states
is matchmaking, not the sport, and the all-US figure folds every level together. Kalli's
instruction: *"Do not blend Velasco's all-US 53% KO+TKO with HW-title snippets or MMA knockdown
maths."* **The honest reading is that 29% is below even Nevada's 38.5%, the closest thing in the
row to a regulated well-matched population, so the gap is real and the target is a BAND.**

Boxing knockdowns per bout, the share of bouts with one, and the knockdowns ÷ landed-power-head-
punches analogue of the UFC's 3.9% are all **NOT FOUND** — CompuBox publishes per-fight punch
totals and no league ratio. **Fightnomics' 3.9% remains the only conversion anchor this project
has, and it is a UFC figure**, so a boxing conversion rate can be reported and never gated.
