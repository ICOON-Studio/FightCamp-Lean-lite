# S4i (B) — THE RESIDUAL IS POSITION, NOT THE PRIOR

S4h closed with one open question and labelled it undiagnosed: with `usage_prior` ON the jab is still 8 points short
of J21 and the lead hook overshoots by 5, and the stated suspicion was that **"the prior is unconditional on BAND"**.
That was a hypothesis. This stage measured it. **It is right about the mechanism and wrong about the fix.**

Nothing was changed. No switch was flipped, no pin moved, no engine file was edited. The instrument is
`Godot/tools/probe_band_occupancy.gd` and it only reads.

## POPULATION

The **same two men and the same seeds as `tools/probe_usage_prior.gd`**, so the two tables compose: A, 183 cm
out-boxer (power 60 / technique 72 / speed 68 / defense 58) against B, 176 cm pressure puncher (power 70 /
technique 55 / speed 54 / defense 62), 12 seeded boxing bouts from seed 61001. Differentiated inside boxing and legal
for it, not identical (operator rule 2026-09-12).

**They differ on the axis this stage is about, and that had to be checked rather than assumed.** `preferred_range` is
not a field a fixture can forget to set — `FightIntent.preferred_range` (`FightIntent.gd:30`) *derives* it from stats
and reach, so A stands off at **1.446 m** and B at **1.296 m**. Both are beyond `FightRealtime.STRIKE_RANGE` (1.1 m,
`FightRealtime.gd:314`), so neither man can throw from where he would rather be; both must close to punch.

CATALOGUE: `assets/data/technique_catalog.json`, bands from `match.range_band`.
STUDY: Thomson & Lamb 2016 via J21 — 92 English amateurs, 183 punches a bout, six named types with 95% CIs. DOCUMENTED.

## WHY BAND CAN SKEW THE MIX AT ALL

The six punches J21 documents are **not available everywhere**:

| punch | authored bands | usage |
|---|---|---:|
| jab, cross | LONG, MID | 2.04, 1.24 |
| lead hook, rear hook | MID, POCKET | 1.56, 0.73 |
| lead uppercut, rear uppercut | POCKET | 0.16, 0.26 |

So where the fight stands decides which of the six can be drawn, and a prior that is flat across bands cannot correct
for it. That is the mechanism S4h guessed at, and it is real.

## FINDING 1 — THE BAND FILTER IS A BIAS, NOT A GATE

**239 of 2,655 named throws (9.0%) are out of their authored band.** A jab is thrown at POCKET 107 times, a cross 69,
the hooks reach LONG 56 times between them, and the uppercuts reach MID 7. These arrive through R102's mismatch path
at fit 0.114 (S4g Finding 1). `range_band` therefore expresses a preference the picker can overrule, which is worth
knowing before anyone reasons about it as a constraint.

## FINDING 2 — THE PRIOR MOVES *WHAT* IS THROWN AND NOT *WHERE*

Occupancy over all action beats is **byte-identical with the switch off and on**: LONG 33.8%, MID 31.9%, POCKET 34.3%,
CLINCH and GROUND 0.0% (boxing). The throw count still moves 4,900 → 5,243, reproducing S4h exactly.

**`usage_prior` and position are orthogonal levers.** Turning the prior on cannot move occupancy, and moving occupancy
does not need the prior turned on.

## FINDING 3 — ALL-BEAT OCCUPANCY IS FLAT BY CONSTRUCTION, AND SAYS NOTHING

33.8 / 31.9 / 34.3 is not a fact about fighting. `SCALED_LONG := 1.17` and `SCALED_MID := 0.88` are **Q43's measured
terciles of the engine's own scored-strike distribution** (`FightMoves.gd:166-185`) — the cut was defined to make the
three standing bands equally occupied, so it delivers thirds whatever the fighters do.

**The engine's band occupancy currently encodes no claim about where a real boxing match is fought.** It cannot be
right or wrong, because nothing ever measured what it should be. That question has never been asked.

## FINDING 4 — THE UNIT TRAP, CAUGHT BY A TRIPWIRE

The six punches are **about twice as dense per beat at POCKET as at LONG** — 74.0% of POCKET beats are one of the six
against 38.3% at LONG. So the two occupancies are not the same number:

| | LONG | MID | POCKET |
|---|---:|---:|---:|
| all action beats | 33.8% | 31.9% | 34.3% |
| **named throws** (679 / 646 / 1330) | **25.6%** | **24.3%** | **50.1%** |

A reweighting of conditional shares is a distribution over **named throws**, so comparing it to the all-beat mix
understates the LONG shortfall by eight points. S4g put two normalisation errors of exactly this shape on its own
record; this one was caught because the probe carries a tripwire that reconstructs the delivered mix from
(conditional shares × measured occupancy) and requires it to reproduce the directly measured one. **Worst delta 0.00
points** — it rebuilds S4h's 27.2 / 16.8 / 32.2 / 17.1 / 2.4 / 4.3 exactly, which also cross-validates S4h.

## FINDING 5 — REWEIGHTING POSITION ALONE TAKES 22.2 POINTS TO 4.9

Each punch's share of the six *given* the band, measured with the prior on:

| punch | at LONG | at MID | at POCKET |
|---|---:|---:|---:|
| jab | 58.2% | 34.1% | 8.0% |
| cross | 33.6% | 23.1% | 5.2% |
| lead hook | 4.9% | 26.6% | 48.8% |
| rear hook | 3.4% | 15.2% | 25.1% |
| lead uppercut | 0.0% | 0.5% | 4.6% |
| rear uppercut | 0.0% | 0.6% | 8.3% |

Grid-searching the standing simplex for the occupancy that puts these measured shares onto J21:

| band | measured | required | shortfall |
|---|---:|---:|---:|
| LONG | 25.6% | 53.5% | **+27.9 pts** |
| MID | 24.3% | 0.5% | −23.8 pts |
| POCKET | 50.1% | 46.0% | −4.1 pts |

**Total absolute error 22.2 → 3.9 points, with the prior untouched.**

The free solve drives MID to a corner, and a corner is the fit preferring the two extreme bands — not a claim that a
real fight is never had at mid range. So the robustness check pins MID where it is measured and frees only LONG and
POCKET: **LONG 40.5%, POCKET 35.2%, residual 4.9 points.** The corner is worth 1.0 of the 18.3-point win, so it is
not load-bearing. **The finding survives without it.**

## WHAT S4i CONCLUDES

1. **S4h's open question is answered.** The residual is band occupancy — but the per-band conditional shares are
   already close to right, so the fix is not a band-conditioned prior. Conditioning the prior on band would be tuning
   the catalogue to compensate for a positioning defect, which is the thumb-on-the-scale S4g refused for legs.
2. **The engine punches too little at long range.** LONG needs to rise from 25.6% of named throws to about 40%, with
   MID unchanged — roughly 1.6×.
3. **It is the same conclusion S4g reached for the leg share, from the other end.** S4g: "an engine whose fight spends
   nearly a third of its beats on the floor cannot match a corpus-wide UFC average without first matching that
   corpus's position mix." Two independent measurements, on two different questions, now land on position.
4. **And there is no measurement to aim at.** The real band occupancy of a boxing match is not in our research. That
   is K63's territory (ring and cage position statistics), written and not launched.

## Open

1. **What IS the band occupancy of a real bout?** Until something measures it, the 40% LONG figure above is what
   J21's punch mix *implies*, not an observed target — a derived quantity, and it must never be quoted as a
   measurement.
   **AND THE LEAD IS ALREADY OURS, AS IT WAS FOR S4g.** J21 §1 names **BoxMind** (Wang et al., arXiv:2601.11492v2,
   08 Mar 2026; Tsinghua / Beijing Sport University / Chinese Boxing Federation), whose atomic punch event carries
   `distance ∈ {Long, Mid, Close}` and which aggregates to eighteen indicators — **the first of them "distance
   mix"**. That is this exact quantity, from Olympic-validated notation. What is NOT known is whether the paper
   publishes the distance-mix *numbers* or only defines the indicator; J21 cites it for the unit of analysis, not
   for a table. **Fetching https://arxiv.org/html/2601.11492v2 and reading for a distance-mix table is the cheapest
   next move in the project**, and it needs no agent and no Windows box.
   K63 does NOT cover this. Its Q3 asks for the UFC's distance/clinch/ground split, which is a coarser axis — our
   boxing bout is 100% "distance" under that definition and the question would come back unanswered.
2. **Both men prefer to stand outside the strike gate** (1.446 m and 1.296 m against `STRIKE_RANGE` 1.1 m) and yet
   half the punching happens at POCKET. What closes the distance, and whether it over-closes, is unmeasured.
3. **At LONG and MID about 61% of throws are not one of the six named punches; at POCKET only 26% are.** The boxing
   arsenal fires fourteen striking techniques and J21 names six. What the other eight are, and whether their band
   spread is authored or accidental, is not looked at here.
4. `usage` still covers 2.0% of throwable nodes, and J21 is boxing-only. Nothing in this stage changes that.

## Re-running it

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/probe_band_occupancy.gd
```

Add `-- seeds=N` for a wider population. No script is edited by this probe and no test can be broken by it, so the
tier is the parse gate plus the probe itself — not the suite (CLAUDE.md test tiers).
