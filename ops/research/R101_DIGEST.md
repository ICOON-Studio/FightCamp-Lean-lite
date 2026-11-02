# R101 — THE FIGHT READS THE CATALOGUE

Claude, 2026-09-10. Stage: R101. Engine: `FightRealtime.gd` + new
`FightMoves.gd`. Harnesses: `Godot/tools/measure_r101.gd`,
`Godot/tools/find_r101_seeds.gd` (both in `tools/`, so the suite pays nothing).

## What landed

`technique_catalog.json` has held 272 nodes across 15 disciplines since the
beginning of the project and the real-time fight engine had never read one.
`grep -c "technique_progress\|discipline_proficiency" FightRealtime.gd` was
**zero**. The engine picked a body REGION and a FORCE and that was its entire
vocabulary: "a strike landed on the leg" meant force arrived at a leg, and
nothing knew what threw it.

Two defects closed, and **the ordering is the whole point**:

1. **`FightRealtime.gd:1287` was `rng.randf() < 0.5`** — an unweighted coin
   flip deciding who throws next, every impact, for the life of the project.
   It is now a threshold computed from state already in hand.
2. **The region was rolled from a shared table before anything knew what was
   thrown.** Now the fighter selects a move whose range band fits the gap and
   whose role fits his plan, and **the region falls out of the move.**

**It cost no extra draws.** The actor pick is still one `rng.randf()`; only the
threshold moved. The region roll is still one `rng.randf()`, but it now walks
the JOINT distribution over (technique, region) pairs — P(technique) ×
P(region | technique) — and an empty live set spends the SAME roll on the old
table. Seven draws per built impact still holds and R82's byte-exact replay is
untouched: `fight_realtime_test.gd` passes 359 checks including the
stream-replay assertion, and `judge_panel_test` still shows boxing seed 91500
replaying byte-for-byte.

## The before-picture moved, measurably

`tools/measure_r101.gd`, 40 bouts per ruleset, real rulesets loaded from
`combat_rulesets.json`. Q40's column is the *before*.

| quantity | Q40 before | boxing | mma | kickboxing | muay thai |
|---|---|---|---|---|---|
| mean run length (throws in a row by one man) | 1.993 | **2.664** | **2.710** | **2.649** | **2.729** |
| runs of exactly 1 | 50.1% | 39.5% | 39.1% | 40.1% | 38.9% |
| bursts SHARED between both men | 74.0% | **64.1%** | **64.0%** | **66.8%** | **68.0%** |
| named techniques (share of impacts) | n/a — none existed | 100% | 100% | 100% | 80.6% |
| distinct techniques thrown | 0 | 8 | 21 | 14 | 5 |

Combinations exist now. A fair coin cannot produce a run of four; the engine
produces one in about 9% of runs.

## Where the palette put the strikes

| | boxing | mma | kickboxing | muay thai |
|---|---|---|---|---|
| head | 68.0% | 42.8% | 52.2% | 51.8% |
| torso | 32.0% | 45.7% | 27.2% | 45.1% |
| legs | **0.0%** | 11.5% | 20.6% | 3.1% |
| bands (LONG/MID/POCKET) | 35 / 33 / 32 | 27 / 26 / 25 | 35 / 32 / 33 | 28 / 26 / 27 |
| position distance / clinch / ground | 100 / 0 / 0 | 78 / 7 / 15 | 100 / 0 / 0 | 80 / 6 / 14 |

Denominator on every percentage above: **scored impacts**, not ticks.

- **Boxing's exact-zero leg rule now holds BY CONSTRUCTION**, not by a zeroed
  table. Boxing's catalogue contains no leg technique, and a technique whose
  every target is illegal under a ruleset is dropped from that palette
  entirely. C85 made the rule; R101 made it structural.
- Boxing's 68.0 / 32.0 is C85's 15/22 : 7/22 to within a tenth of a point. The
  head share did not drift.
- MMA's 11.5% legs sits on C85's measured 12.4%.
- **All three standing bands occur in every ruleset**, asserted by occurrence
  rather than permitted. The boundaries are Q43's measured terciles of the
  engine's own scored-strike distribution (0.70 m and 0.93 m; MMA 0.712/0.929,
  boxing 0.695/0.932), carried as SCALED distances — separation over the
  thrower's own arm length — so the gate is reach-aware, which is G47's
  complaint about the flat 1.10 m gate.

## The band trap, avoided

The catalogue speaks LONG / MID / POCKET. G47's anatomy speaks long 1.1–1.5 m,
pocket 0.6–1.1 m, clinch ≲0.5–0.6 m. **They are two different three-band
vocabularies and the middle band has a different name in each.** `STRIKE_RANGE`
is 1.1 m and `_run_impact` refuses everything above it, so a literal mapping
onto G47's metres would have made **LONG structurally unreachable** — and a jab
is a LONG/MID technique and the most thrown punch in boxing. The boundaries are
cut from the engine's own measured distribution instead, labelled AUTHORED, and
every reachable band is asserted by occurrence.

## What the research bought, and what it refused

- **G49** — condition on time since THIS fighter's last throw, then his own
  baseline volume share. Not who just landed (counter-recommended), not a
  momentum flag (weakly evidenced at strike grain), not who is pressing.
- **G50** — REFUSED "pressure" outright. Over ~7,300 scored rounds movement
  pressure added essentially nothing once punch features were controlled. The
  term is gone from the design and no code was written for it.
- **G51** — significant = any strike at DISTANCE plus POWER strikes in clinch
  and on the ground. A category rule over range and position, never damage.
- **G52 / Q42** — the round is a drizzle; the shape is graded, not assumed.
- **J21** — the atomic choice is a NAMED TECHNIQUE gated by range and position,
  live set 5–15, selection = situation gates the legal set then weighted
  preference, style is weights not a different algorithm.
- **J20** — the validation corpus.
- **M19** — when a named technique has no clip, play the matching-region
  reaction on the receiver and NEVER another technique's clip. U43 built it.
- **Q43** — the separation distribution nobody had looked at below 0.6 m. The
  floor is 0.000–0.001 m; 68–72% of impact ticks sit above the 1.1 m gate and
  produce nothing.
- **G53** — the interval inside a combination. **0.35 s** (Piorkowski, Lees &
  Barton 2011, ten competition boxers, alternating-hand four-punch sequences,
  contact-to-contact over three intervals). Everything else it was asked for
  came back NOT PUBLISHED, and it refused the combination-trigger question as
  coaching lore.

## THE FINDINGS, none of them tuned away

**1. Our combination counts sit inside Davis's band for the wrong reason, and
this is a denominator trap.** Davis 2015 (elite amateur, 3×3 min) counts about
**10 two-punch combinations per boxer per round**, band 9–11. We measure
**11.79** for boxing — apparently in band. But we also throw **81.7 times per
boxer per round**, roughly three to four times an elite amateur's output. Per
throw we combine LESS than a real amateur, not more; the count only looks right
because two errors point in opposite directions. **Do not cite this as
validation.** Four-or-more-punch combinations are 3.18 per boxer per round
against Davis's 0.5–1.3, which is the same fact seen from the other side.

The throw rate is not R101's to fix: it is the unmodelled-miss number G51
already specified as the next stage.

**2. `significant` is 100% of impacts in every ruleset that names a technique,
and that is not a useful discriminator.** FightMetric's rule is any strike at
distance plus power strikes in clinch and on the ground — and every clinch and
ground technique our palette knows is a POWER role (`mma_guard_gnp`,
`mma_dirty_boxing`, `muay_thai_clinch_knees`). **The engine cannot currently
emit a non-significant strike.** Real UFC significant strikes are a subset of
total strikes; ours are all of them. Reported, not papered over — the missing
half is the short clinch/ground strike, which is the next stage's territory.

**3. Muay Thai's catalogue has no low kick.** Legs are 3.1% of muay thai
impacts, and the 3.1% comes from `muay_thai_round_kick`'s generic `kick_damage`
spread, not from a leg technique — because there isn't one. The low kick is
muay thai's signature and `technique_catalog.json` does not contain it. This is
a DATA gap, not an engine gap, and it is not fixed here.

**4. Muay Thai's live set is five techniques and one of them is 40% of its
output.** `muay_thai_horizontal_elbow` is 10,111 of 25,685 named throws. J21's
live-set band is 5–15; muay thai sits at the floor of it because most of its
tier-1/2 nodes are `control` or `adaptation` roles that do not throw. Reported.

**5. Muay Thai leaves 19.4% of its impacts unnamed** — its clinch and ground
impacts, where its catalogue clinch nodes are all `control` role. The fallback
is honest (the old region table, same roll, no extra draw) but it means a fifth
of a muay thai fight still has no technique.

**6. Role alone does not identify a strike.** Filtering on setup/damage/counter
let `wrestling_duck_under`, `mma_sprawl_fronthead`, `wrestling_level_change`
and `mma_jab_levelchange` into the striking palette — the engine was about to
log a duck-under as a blow landing on a head. A technique carrying a grappling
effect is now excluded whatever its role is called.

**7. The catalogue's `mma` discipline has no standing striking damage at all.**
Its damage nodes are clinch (`mma_dirty_boxing`) and ground (`mma_guard_gnp`,
`mma_elbow_gnp`). It is the MMA-specific layer and it sits ON TOP of the base
disciplines; an MMA palette of `["mma"]` alone leaves a man unable to punch
standing up. MMA therefore draws on boxing, kickboxing, muay thai, wrestling
and BJJ as well.

**8. Every fighter in every seeded test carries no `technique_progress`.** A
strict "only what he trained" rule would have made the entire stage emit
nothing everywhere, which is the exact condition five pieces of correct,
tested, unreachable code have shipped in. The default arsenal — his ruleset's
disciplines at tier 1 and 2 — is AUTHORED and labelled. Where a real athlete
carries a progress record it is authoritative and NARROWS the set.

## The rebaseline, once, deliberately

The operator ruled: land C85 first, rebaseline ONCE after R101. Done, in one
commit. Nothing was re-pinned to make a red card green; every bout was run twice
and pinned only where the two runs agreed (T4/T8R asserts exactly that).
**`judge_panel_test`: 0 failures.** Ten of the eleven pinned bouts moved;
`muay_thai_17` is a round-one KO and finishes before anything the palette
changed can accumulate.

**The direction is not the one to assume, and this is the stage's sharpest
lesson.** An earlier cut used a GUESSED 1.2 s combination window. Under it,
`boxing_23` and `boxing_9` stopped being eight-round decisions and became
knockouts, and it would have been easy to write that up as "combinations make
boxing more violent, which is realistic". Then G53 measured the real interval
at 0.35 s. At the measured window both are decisions again — and `boxing_7`,
pinned since R85 as a round-one KO that turned in no cards at all, now goes the
full eight rounds. **The guess was doing the damage, not the idea.** A stage
that had not asked for the number would have shipped the guess and called its
consequence a finding.

**T11 is not a pin and was not treated as one.** It asserts the judge panel is
not decorative and needs a non-unanimous verdict to EXIST. C85 took boxing seed
25 from MAJORITY to UNANIMOUS and R101 took kickboxing seed 77 from SPLIT to
UNANIMOUS, so both halves died. They were RE-FOUND by scanning 600 bouts on the
same 62-v-64 fixture, not relaxed and not deleted: **boxing seed 20 is a
MAJORITY** (5 majorities and 2 splits in 300 seeds) and **kickboxing seed 186 is
a SPLIT** (exactly one in 300). Both are now pinned bouts in their own right,
and the three judges hand in different cards on one round of the split.

Four occurrence pins in `fight_realtime_test.gd` were re-found the same way,
each with its sweep recorded in the test so the next person to move a constant
re-runs the identical search (`tools/find_r101_seeds.gd`):

- **the knockdown window** — 19001..19040 gives 195 shocks and 19 knockdowns
  across 16 of 40 seeds, so the old window went quiet rather than the feature
  dying. All four pinned seeds are now hits, which is stronger than before.
- **the three-knockdown TKO** — swept over R84's and R86's identical range so
  the three numbers are one column of the same quantity: **R84 19, R86 8, R101
  17**. More reachable than R86, reported rather than tuned.
- **judo's ippon seeds and its third-shido seeds** — both families moved. Judo
  has no palette at all (no entry in `RULESET_DISCIPLINES`, so no judo throw is
  ever named and its region roll is byte-identical), but the actor threshold
  applies to EVERY ruleset, so who throws moved and the damage feeding the board
  moved with it. Seed 94017 crossed families — it was an ippon seed and is now a
  shido one, which is what "a seed is only meaningful with the exact engine that
  produced it" looks like in practice.
## The trap that was kept out

Our engine measures 35% of ticks inside the 1.1 m gate; pro boxing reports
35.6% direct contact time. **Those are not the same quantity.** The near-match
is a coincidence and citing it as validation would repeat the
hand-travel-versus-separation error. Q42 recorded the warning and R101 does not
cite it.

## What R101 deliberately did NOT do

- It did not let the catalogue become a second engine. Of 140 effect keys it
  reads **three families** — head, body and leg damage — and reads them as a
  TARGET hint, never as a number. `ImpactModel.make_impact` still prices every
  blow in this game.
- It did not emit misses. That adds a draw, breaks the seven-draw contract and
  moves every seeded fight again; G51 already specifies it as its own stage.
- It did not touch `FightSimulation.gd`. Judo, taekwondo and freestyle
  wrestling still ride it by R85's ruling.

## The one thing that nearly shipped and was caught by measuring

The first region rule read a plain `damage` effect as "head shot". That took
boxing from C85's 68% head to **88%** and turned a twelve-round bout into a
certain knockout — 16 of 16 stopped, 13 by KO, against R86's measured 60.8%. A
generic `damage` key says a technique HURTS; it does not say where it lands,
and reading a target out of it is inventing one. Only an EXPLICIT target effect
now moves a technique off the ruleset's own split.
