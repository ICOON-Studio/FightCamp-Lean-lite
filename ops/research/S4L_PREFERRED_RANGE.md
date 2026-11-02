# S4l (B) — what decides the band? A measurement on `FightIntent.preferred_range`

**Status: MEASUREMENT COMPLETE. NOTHING WAS FLIPPED.** No behaviour changed, no
pin moved, no constant was touched. One new read-only tool,
`Godot/tools/probe_preferred_range.gd`.

    godot --headless --path Godot --script tools/probe_preferred_range.gd -- seeds=12

**POPULATION** — boxing, A 183 cm out-boxer against B 176 cm pressure puncher,
differentiated inside the ruleset and legal for it, NOT identical (operator rule
2026-09-12). The same two men and the same seeds (61001..61012) as
`probe_band_occupancy.gd` and `probe_usage_prior.gd`, so all three tables are
directly comparable. **CATALOGUE** `assets/data/technique_catalog.json`, bands
from `match.range_band`. **STATE** the shipped one: `usage_prior` ON (S4k
6466e87a), `body_radius` / `cut_off` / `circle_out` / `between_states` ON.

**TRIPWIRE FIRST.** The probe reconstructs both of S4k's shipped occupancy
tables from its own stream before printing anything else. Worst delta **0.04
points** across all six cells — the instrument sees S4k's world, so everything
below it is commensurate with the numbers already on the record.

---

## 1. B's target is written in the wrong distribution, and that is worth 4.1x

This is the finding that changes what B is.

S4i's solver asked for **40.5% LONG**. It solved over **named throws**. B is
written as *"move position so LONG rises"*, and position is **standing
occupancy**. Those are two distributions over the same three words, and the map
between them is the per-band **throw density** — how many of the six punches a
man throws per in-gate tick he spends at that band. Measured:

| band | of in-gate ticks | of named throws | throws/tick |
| --- | --- | --- | --- |
| LONG | 36.4% | 25.6% | 0.703 |
| MID | 31.7% | 24.3% | 0.768 |
| POCKET | 31.9% | 50.1% | 1.568 |

**POCKET is 2.23x denser per tick stood than LONG.** So a point of position does
not buy a point of named mix. Solving for the standing occupancy that delivers a
40.5% named-throw LONG at the measured densities:

> **LONG must go from 36.4% to 53.1% of in-gate ticks — a 16.7-point move.**

Reading B's target as *40.5 minus the measured 36.4 = a 4.1-point position move*
**undersizes it by 4.1x**. That is the fifth normalisation trap in six stages and
the second caught before it produced a wrong finding.

The one assumption, stated rather than hidden: the densities are taken to hold
fixed while occupancy moves — the same assumption S4i's solver makes about its
conditional shares. It is why 53.1% is a **sizing**, not a prediction, and it has
to be re-measured after any flip.

## 2. The men already stand at LONG more than they throw there

Four denominators, and only the last two are about where the men stand:

| band | of named throws | of action beats | of ALL ticks | of IN-GATE ticks |
| --- | --- | --- | --- | --- |
| LONG | 25.6% | 33.8% | 80.7% | **36.4%** |
| MID | 24.3% | 31.9% | 9.6% | 31.7% |
| POCKET | 50.1% | 34.3% | 9.7% | 31.9% |

**69.6% of standing ticks are outside the 1.10 m strike gate** — ticks at which
no punch of any band could be thrown by either man. Counting those as LONG
occupancy (the "ALL ticks" column, 80.7%) answers a different question from the
beat columns, so the in-gate column is the one commensurate with them. Gap over
every standing tick: p10/p50/p90 = **0.696 / 1.314 / 1.732 m**.

## 3. Inside the strike gate, the "too far — close him down" branch never fires

`decide` picks one of four weight sets before any roll: CORNER, `diff > tol`
(CLOSE 0.7), `diff < -tol` (RETREAT 0.6), and the band between (HOLD 0.6). Which
one fires is roll-free, so it is reportable without touching the stream.

**On decision ticks inside the gate (gap <= 1.10 m), n = 4,548 per man:**

| man | CORNER | too far | in band | too close |
| --- | --- | --- | --- | --- |
| A | 4.6% | **0.0%** | **0.0%** | 95.4% |
| B | 1.4% | **0.0%** | 32.3% | 66.3% |

Pooled, the *too close* branch fires on **80.8%** of in-gate decision ticks. A is
never once content where he can punch: his hold window is [1.156, 1.736] m and
the gate ends at 1.10 m, so the window and the gate do not overlap at all.

**Whenever these two men are close enough to fight, they are both trying to back
off.** The band a beat lands in is therefore the profile of a *crossing*, not of
a standoff anybody chose.

## 4. Why: `preferred_range` is compared in metres and defined in arm lengths

`FightIntent.preferred_range` (`FightIntent.gd:30`) returns a base of 1.2 joined
to Hristovski's shape D≈1.2 — a **scaled** distance, separation over the man's
own arm. `contested_range` (`FightIntent.gd:49`) treats it that way explicitly:
it compares `own_preferred` against `Moves.scaled_distance(...)`, and its own
comment says *"Gap, in the fighter's own arm lengths"*. `SCALED_LONG := 1.17` and
`SCALED_MID := 0.88` are in that same unit.

`FightRealtime._run_decision` (`FightRealtime.gd:1797`) passes
`separation(state)` — **metres** — into `decide` as `distance`, against that same
`preferred`. `FightBeatAdapter._compute_range_fields` then reads it back out as
`range_m`. So the codebase already contains both readings.

| man | arm m | pref | read A (metres, today) | read B (arm lengths) |
| --- | --- | --- | --- | --- |
| A | 0.8052 | 1.446 | 1.446 m | 1.164 m |
| B | 0.7744 | 1.296 | 1.296 m | 1.004 m |

Under read A both men want a standoff **beyond the 1.10 m strike gate**, which is
why the CLOSE branch is unreachable in-gate. **37 of the 37 featured athletes on
disk with a recorded reach have `preferred` > 1.10** under read A, so this is not
a property of the fixture.

Converting first (read B) moves the in-gate branch census a long way:

| man | reading | in band | too close |
| --- | --- | --- | --- |
| A | A (today) | 0.0% | 95.4% |
| A | B | **32.8%** | 62.5% |
| B | A (today) | 32.3% | 66.3% |
| B | B | **63.8%** | 34.8% |

**This is a measurement of the size of the discrepancy, not a recommendation to
flip it.** Read B is a re-baseline: it moves where both men stand on every
decision tick, so it takes the heavy tier and a full re-measure of the
conditional shares S4i's solver reweights.

## 5. Which term of the formula dominates: reach, by 4.2x

`preferred = 1.2 + (reach-150)/50*0.3 + (tech-50)/50*0.2 - (power-50)/50*0.2`

The coefficient is not the answer; the coefficient times the spread the
population actually has is. Over the **37 featured real athletes on disk with a
recorded reach**:

| term | min | p50 | max | span |
| --- | --- | --- | --- | --- |
| reach | 0.060 | 0.175 | 0.396 | **0.336** |
| technique | 0.144 | 0.176 | 0.196 | 0.052 |
| power | -0.192 | -0.160 | -0.112 | 0.080 |
| preferred | 1.276 | 1.396 | 1.620 | 0.344 |

**Reach dominates: 4.20x the next widest term (power) and 6.46x the narrowest
(technique).** The whole formula spans 0.344 and reach supplies 0.336 of it.
Technique and power are, in this population, decoration.

**A DATA HOLE FOUND ON THE WAY: 63 of the 100 featured athletes carry
`reach_cm: 0`.** That is a missing value, not a 0 cm reach — the formula reads it
as -0.9 and clamps `preferred` to its 0.4 floor. They are excluded from the table
above and counted here rather than silently averaged in. Anything that sizes a
position change against the featured roster has to exclude them too.

## 6. The gap is bimodal: he barely moves, or he crosses a whole band

|Δgap| over one decision interval (10 ticks, 0.50 s), both men:

- p50 **0.035 m**, p90 **0.629 m**, max **1.691 m**
- **29.6%** of intervals move the gap less than 1 cm
- **37.8%** (A) / 36.2% (B) move it further than that man's *entire reachable
  LONG window*

The band windows in metres, inside the gate, are not three equal seats — the cuts
are scaled by the thrower's arm while `STRIKE_RANGE` is a flat 1.10 m:

| man | LONG | MID | POCKET | floor |
| --- | --- | --- | --- | --- |
| A | 0.942–1.100 (0.158 m) | 0.709–0.942 (0.234 m) | 0.388–0.709 (0.321 m) | 0.388 |
| B | 0.906–1.100 (0.194 m) | 0.681–0.906 (0.225 m) | 0.388–0.681 (0.294 m) | 0.388 |

**LONG is the narrowest reachable window by construction**, at about half
POCKET's width for A. A band narrower than a p90 step is crossed, not occupied.

## 7. A third of beats are not scored where he decided

Band at the beat against the band at that actor's last decision, both read with
his own reach:

| decided at | beat LONG | beat MID | beat POCKET | n |
| --- | --- | --- | --- | --- |
| LONG | 1426 | 694 | 218 | 2338 |
| MID | 220 | 689 | 411 | 1320 |
| POCKET | 124 | 290 | 1171 | 1585 |

**Same band on only 62.7% of 5,243 beats.** Decisions run at 2 Hz and impacts at
10 Hz, so up to 0.5 s of travel sits between the two — and section 6 says how far
that is. The leak is asymmetric: of beats decided at LONG, 39% land closer, while
only 8% of beats decided at POCKET land at LONG. **The drift runs inward**, which
is a second mechanism pushing the named mix toward POCKET independently of where
the men chose to stand.

---

## What this says about B

B is not "turn up `preferred_range` a little". Four separate things move the
band, and they are now sized against each other:

1. **The unit** (§4) — the largest single lever, and the only one that is a
   correction rather than a new authored number. It puts both men's hold window
   inside the gate for the first time.
2. **The gate geometry** (§6) — `STRIKE_RANGE` is a flat 1.10 m against
   arm-scaled band cuts, which makes LONG the narrowest reachable window for
   every fighter and makes it narrower the longer his arms are.
3. **The decision/impact drift** (§7) — 37.3% of beats are scored in a band the
   actor was not standing in, and the drift runs inward.
4. **The formula's own terms** (§5) — reach dominates 4.2x, so a coefficient
   change is a reach change in disguise. This is the *weakest* of the four levers
   and the roadmap's original reading of B.

**Nothing here should be flipped without a re-baseline.** Each of 1–3 moves where
the men stand on every tick, so each invalidates the conditional shares S4i's
solver reweights and the seeds pinned against them. The sizing in §1 is the
figure to hold any candidate against: **in-gate LONG occupancy 36.4% -> 53.1%**,
not 36.4% -> 40.5%.

## Re-finds and open questions

- **NOT re-opened**: S4k's prior (settled), the band-conditioned prior (S4i
  answered NO), the BoxMind fetch (S4j closed NO).
- **OPEN, and new**: whether `preferred_range` was ever *intended* as metres. The
  evidence on disk is split — `contested_range`'s comment and the Hristovski
  join say arm lengths, `FightBeatAdapter`'s `range_m` says metres, and
  `fight_intent_test.gd` pins neither (it passes the same number as both
  arguments at `:86`). Whichever way it is resolved, one of the two call sites is
  wrong today.
- **OPEN**: the 63 featured athletes with no reach. Not this stage's to fix, but
  any career-side position work will hit it.

## Verification

    python Godot/tools/check_scripts.py Godot/tools/probe_preferred_range.gd
    godot --headless --path Godot --script tests/fight_intent_test.gd
    godot --headless --path Godot --script tools/probe_preferred_range.gd -- seeds=12

Parse gate 0 fails; `FIGHT_INTENT_TEST PASS`; probe tripwire worst delta 0.04
points. No `Godot/scripts/` file was edited, so no re-baseline and no suite run
was owed by this stage.
