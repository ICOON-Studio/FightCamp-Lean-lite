# S4m (B) — the unit on `preferred_range`, decided and corrected

**Status: DECIDED, FLIPPED, RE-BASELINED.** `FightIntent.preferred_range` is in
**ARM LENGTHS**, not metres. `FightRealtime._run_decision` was handing `decide`
a METRE gap; it now converts through `FightMoves.scaled_distance`.
`FightBeatAdapter`'s `range_m` was publishing the same arm-length number under a
metre name; it now multiplies by the man's own arm. Three tests pin the unit
against a quantity measured in it, six occurrence pins across three test files
were RE-FOUND by their own sweeps, and one gated rule is left RED on purpose
with its finding written down.

    godot --headless --path Godot --script tools/probe_preferred_range.gd -- seeds=12

**POPULATION** — boxing, A 183 cm out-boxer against B 176 cm pressure puncher,
differentiated inside the ruleset and legal for it, NOT identical (operator rule
2026-09-12). Same two men and same seeds (61001..61012) as S4i/S4k/S4l, so every
table below is directly comparable to theirs. **CATALOGUE**
`assets/data/technique_catalog.json`, bands from `match.range_band`. **STATE**
the shipped one: `usage_prior` ON, `body_radius` / `cut_off` / `circle_out` /
`between_states` ON.

---

## 1. The verdict, and the evidence that decides it

S4l left the two readings open and said one of the two call sites is wrong. It
is the metre one. Three of the four pieces of evidence are *definitional* and
live inside `FightIntent` itself; the two on the other side are a call site and
a field name.

**For arm lengths:**

1. `contested_range` (`FightIntent.gd:49`) compares `own_preferred` directly
   against a value built out of `FightMoves.scaled_distance`, and its own
   comment says *"Gap, in the fighter's own arm lengths"*.
2. `decide` requires it too, one level deeper: `absf(distance - edge) <= tol`
   (`:123`) weighs `distance` against that same `edge`. `edge` is intrinsically
   arm-scaled and **cannot be converted the other way** — which is why the
   conversion has to happen at the call site.
3. The base 1.2 is Hristovski's jab-reach shape D≈1.2, and `SCALED_LONG` is
   1.17, cut from 200 boxing bouts. Those two numbers agree to 3% because they
   are the same quantity. Under a metre reading nothing holds them together.

**For metres:** `_run_decision` passed `separation(state)`; `_compute_range_fields`
published the result as `range_m`. A call site and a label.

**And the measured consequence settles it.** Under the metre reading, all 37
featured athletes with a recorded reach wanted a standoff beyond the 1.10 m
strike gate, so inside the gate the CLOSE branch of `decide` fired on **0.0%** of
decision ticks and the "too close" branch on **80.8%**: whenever the two men were
close enough to fight, both were trying to back off. A branch that no real
athlete can reach is a defect whatever it does to a target.

## 2. What was changed

| file | change |
| --- | --- |
| `FightRealtime.gd:1797` | `decide` is handed `Moves.scaled_distance(gap, reach_cm)`, not `gap` |
| `FightIntent.gd:30/:39/:81` | the unit is named on `preferred_range`, `tolerance` and `decide` |
| `FightIntent.gd:114` | `opponent["preferred"]` arrives in HIS arms and is converted to ours |
| `FightBeatAdapter.gd:467` | `range_m` / `actor_range_m` / `target_range_m` are multiplied by each man's own arm |

The `opponent` path is dormant in the engine (`_run_decision` passes `{}`), but
it compared our man's gap against the opponent's seat on the opponent's ruler.
Left alone, the flip would have turned one unit bug into a subtler one. The two
arms' ratio is the two reaches' ratio — `ARM_FRACTION` cancels — so it is one
multiply.

`FightBeatAdapter`'s clamp stays in arm lengths, where `PREFERRED_RANGE_MIN/MAX`
live, so `range_source` is byte-identical to what it has always reported; only
the published metres changed. No screen reads the beat's `range_m` today.

## 3. What it did — measured, not predicted

**The men are in the fight now.** The single biggest effect is not on the band
mix at all:

| | metre reading | arm reading |
| --- | --- | --- |
| standing ticks inside the 1.10 m gate | **30.4%** | **56.0%** |
| gap p10 / p50 / p90 over standing ticks | 0.696 / 1.314 / 1.732 m | **0.516 / 1.041 / 1.559 m** |
| in-gate "too close" branch, pooled | 80.8% | 84.9% |
| A in-gate "in band" | 0.0% | **29.5%** |
| B in-gate "in band" | 27.0% | **55.7%** |

A's hold window is [0.930, 1.399] m and the gate ends at 1.10 m, so for the first
time it overlaps the space he can punch in — and that overlap is exactly his LONG
band (0.942–1.100 m).

**And B's target moved AWAY.** This is the finding, and it is reported rather
than smoothed over:

| band | of named throws (before) | of named throws (after) | of IN-GATE ticks (before) | of IN-GATE ticks (after) |
| --- | --- | --- | --- | --- |
| LONG | 25.6% | **20.1%** | 36.4% | **30.3%** |
| MID | 24.3% | 23.3% | 31.7% | 29.5% |
| POCKET | 50.1% | **56.7%** | 31.9% | **40.2%** |

The solver's requirement did not move — `probe_band_occupancy.gd` re-run on the
new stream still asks for **42.0% LONG free / 40.5% MID-pinned**, residual 3.0
points — so the shortfall **widened from about 15 points to 21.9**. Re-sized at
the new densities (LONG 0.662, MID 0.789, POCKET 1.410 named throws per in-gate
tick, POCKET/LONG **2.13x**), B now needs in-gate LONG occupancy to go
**30.3% → 54.1%, a 23.8-point move**. S4l's 53.1% was computed at the old
densities and is superseded, exactly as it said it would be.

**Why it went that way, and it is not a paradox.** Under the metre reading both
men stood outside the gate 69.6% of the time, and `band_for` calls everything
above the LONG cut LONG, so the old LONG share was partly *unreachability*
counted as range. Correcting the unit lets them in, and inside the gate the
geometry decides: LONG is the narrowest reachable window by construction
(A 0.158 m against POCKET's 0.321 m) while the p90 gap step over one decision
interval is 0.629 m — four times LONG's width. **A band narrower than a step is
crossed, not occupied.**

## 4. The new finding S4n inherits: the reach term is a SECOND normalisation

`preferred = 1.2 + (reach-150)/50*0.3 + …` — and the unit is *already* the gap
over the man's own arm. Dividing by reach and then adding a term proportional to
reach counts it twice, so the longer a man's arms the further outside his own
reach he wants to stand.

Over the 37 featured athletes with a recorded reach:

- **37 of 37** have `preferred` above `SCALED_LONG` 1.17 — every one of them
  prefers a standoff **outside his own longest striking band**.
- **18 of 37 (49%)** still want a seat beyond the 1.10 m gate after the
  correction, down from 37 of 37 before it. Seat in metres min / p50 / max =
  **0.898 / 1.090 / 1.540** (Jon Jones 1.608 arm lengths = 1.518 m; Usyk 1.521 =
  1.326 m).
- 63 of the 100 featured athletes carry `reach_cm: 0` — a MISSING value, clamped
  to the 0.4 floor. Excluded above and still open.

So the correction halved the defect and the residue is lever 4, which S4l ranked
weakest on the reasoning *"reach dominates 4.2x, so a coefficient change is a
reach change in disguise"*. Under the corrected unit that reasoning inverts: it
is not a coefficient to taste, it is **the same double-count as the unit itself**,
one level down. That reranks S4n's two candidates — the reach term and the gate
geometry (`STRIKE_RANGE` a flat 1.10 m against arm-scaled band cuts, so LONG is
narrowest for every fighter and narrower the longer his arms) — and they are the
same defect wearing two hats: a flat metre gate against an arm-scaled band table.

## 5. The re-baseline: six pins RE-FOUND, nothing relaxed

`fight_realtime_test` was **green at HEAD** (394 checks) and went red with five
internal failures on the flip — verified by reverting the three scripts and
re-running, not assumed. All four pins are OCCURRENCE or WINDOW pins and each was
re-found by the sweep tool already built for it. R85: re-find, never re-pin.

| pin | was | now | the sweep |
| --- | --- | --- | --- |
| `_test_the_fight_ends` | 7003 | **7001** | `find_s4e2_seeds.gd -- distance`, same 7001..7040 |
| `_test_the_doctor_actually_stops_one` | 4403 4408 4417 | **4400 4401 4402** | `find_s4f_seeds.gd -- doctor`, same 4400..4499 |
| judo window (BOTH judo tests) | 93017..93040 | **93018..93041** | `find_s4_4_seeds.gd -- judowindow`, same 93000..93199 |
| `grapple_adapter_test` MT witness | 93029 | **93014** | `find_r102_seeds.gd -- mt`, same 93000..93399 |
| `judge_panel_test` T4/T8R | 12 of 13 cards | parsed from the printed actual | the test's own two agreeing runs |
| `judge_panel_test` T11 | boxing 476 / kickboxing 603 | **boxing 436 / kickboxing 396** | `find_s4f_seeds.gd -- panelwide`, same 301..900 |

**Base rates, before any narration:**

- **Doctor: 23 of 100**, against 75 KOs and 2 TKOs — the identical 23 of 100 S4k
  found, on different seeds. As reachable as it was.
- **Judo: 48 throws over 200 bouts** (was 42), seats half 34 / side 13 / guard 1,
  bands not_scored 35 / yuko 13. The throw got MORE common, which is what a
  correction that puts the men inside the gate should do. The window slid by ONE.
- **Final bell: 20 of 40**, against 30 of 40 before. **THE PROPERTY GOT RARER**
  and that is a real consequence of the correction, not a moved seed: the men
  fight inside the gate half again as often, so more bouts end early. Still
  one-in-two, so 7001 is not a pin living on luck — but it is on the record.
- **MT witness: 21 of 400** one-throw unanimous decisions (was 20). The card is
  **30-24 unanimous** for a FOURTH witness seed running without a digit moving.
  The tally underneath moved a long way, though: SUBMISSION 186 / DECISION 155 /
  KO 59 of 400, against S4k's 132 / 221 / 47. The men stand closer, so the
  clinch is reached far more often. Recorded, and deliberately not what the
  witness pins.
- **Judge panel: 5 stoppages before, 5 after** among the 13 pinned bouts. Four
  swaps in both directions (boxing_23 and kickboxing_13 KO → DECISION,
  boxing_9 and mma_11 DECISION → KO). No KO surge to explain, and a selected
  sample could not have measured one anyway. All twelve moved cards were PARSED
  out of the test's printed actual by script, never transcribed.
- **Panel families: boxing 2 splits / 11 majorities, kickboxing 2 splits /
  7 majorities** over the same 301..900. Both families still occur in both
  rulesets so T11 keeps one per ruleset. Boxing splits did thin, 5 → 2, which is
  recorded because a family thinning is a fact about the engine even when the
  pin survives.

## 5b. R16 IS RED ON PURPOSE, AND IT IS THE STAGE'S SECOND FINDING

`fight_ring_position_test`'s R16 — *cutting a man off does not make him harder to
catch* — is a GATED A/B of the engine against itself, and the cage half now
fails. It is **not re-pinned, not loosened and not tuned**, and the suite carries
it as a sixth red.

| arm | before | after |
| --- | --- | --- |
| ring | -0.329 → **-0.488** (cut-off helps) | -0.346 → **-0.393** (still helps, by a third as much) |
| cage | -0.320 → **-0.342** (helps) | -0.301 → **-0.258** (**hurts**) |

Measured on the same twenty seeds with bearing and the between-exchange phases
held off in both arms, exactly as before — my change is in `_run_decision` and
applies to both arms identically, so the A/B is still isolated.

**The arithmetic names the culprit.** `_run_movement` aims at
`toward + _other_velocity(other) * _cut_off_lead(fighter)`, and `toward` is the
raw displacement — *its length is the gap*. A fixed lead TIME added to a
gap-length vector rotates the aim further off the direct line the closer the two
men are: the gap p50 fell 21% (1.314 → 1.041 m), so the same lead rotates about
26% further, and the cage has the floor for that wasted path to cost something.
**`CUT_OFF_LEAD_S := 0.45` was calibrated, implicitly, against a gap distribution
this correction moved.**

Re-sizing it is authoring a number, which this stage explicitly is not, and
choosing a value until the rule goes green is what R85 forbids. So it is
reported. It belongs with the other two constants the correction unseated — the
reach term in `preferred_range` (§4) and the flat `STRIKE_RANGE` against
arm-scaled band cuts — and they are one family: **an authored constant whose
only other length scale is the gap is calibrated against the gap distribution,
whether or not anybody wrote that down.**

## 6. The pins that make the unit falsifiable

S4l's rule: *a test that uses one value for two quantities cannot fail on their
units.* `fight_intent_test.gd:86` passed 1.32 as both `distance` and `preferred`,
which is consistent under either reading and therefore evidence for neither.
Three new assertions weigh the number against something measured in the unit it
claims:

1. **`fight_intent_test`** — the baseline seat sits within 0.05 of
   `FightMoves.SCALED_LONG`; the seat handed over converted reads HOLD and the
   same seat handed over in metres does not; a 200 cm man's seat reaches a 160 cm
   man only once it is converted (RETREAT count 0 without the conversion).
2. **`fight_realtime_test._test_the_gap_reaches_decide_in_arm_lengths`** — the
   engine-level signature. At least 45% of standing ticks inside the gate: the
   metre reading measures 30.4%, the corrected one 50.0% on this three-seed
   fixture (56.0% over the probe's twelve). A FLOOR, not a pin on 56.0.
3. **`fight_beat_range_test`** — `range_m` equals the seat in metres to within a
   millimetre, plus a discriminator asserting the two readings are more than
   0.05 apart on this fixture, so the pin above cannot pass vacuously.

## 7. Verification

    python Godot/tools/check_scripts.py Godot/scripts/FightIntent.gd Godot/scripts/FightRealtime.gd Godot/scripts/FightBeatAdapter.gd
    godot --headless --path Godot --script tests/fight_intent_test.gd
    godot --headless --path Godot --script tests/fight_beat_range_test.gd
    godot --headless --path Godot --script tests/fight_realtime_test.gd
    godot --headless --path Godot --script tools/probe_preferred_range.gd -- seeds=12
    python Godot/tools/run_tests.py --timeout 1200 --jobs 4

Parse gate 0 fails. `FIGHT_INTENT_TEST PASS`; `fight_beat_range_test TOTAL=251
fails=0`; `FIGHT_REALTIME_TEST PASS (409 checks)`, `S4M_IN_GATE share=50.0%`;
`judge_panel_test: 0 failure(s)`; `grapple_adapter_test TOTAL=125 fails=0`.

**`SUITE total=303 fails=6`.** Five are master's own and untouched by this stage
(`athlete_development`, `fight_pair_live`, `fight_stage_presenter_contract`,
`fight_scoring`, `fight_stage_realism` — the same five S4k recorded). **The sixth
is `fight_ring_position` R16 and it is this stage's, left red on purpose with the
finding written down (§5b) rather than tuned away.** That is ONE OVER the stage's
stated ceiling of five, and it is said here plainly rather than bought back by
relaxing a gate.

The `probe_preferred_range` tripwire reads **6.56 points against S4k's shipped
tables and that is CORRECT** — it is the re-baseline arriving, and the tables it
was reconstructing are the ones section 3 replaces.

## 8. Open, and not this stage's

- **The reach double-count** (section 4) — 18 of 37 real athletes still seat
  themselves outside the gate. S4n.
- **The gate geometry** — `STRIKE_RANGE` is a flat metre against arm-scaled band
  cuts. Same defect, other hat. S4n.
- **`CUT_OFF_LEAD_S`** — R16's cage half is red until it is re-sized against the
  new gap distribution (§5b). S4n, and it is the one that is currently costing a
  gated rule.
- **The decision/impact drift** — 63.3% of beats are scored in the band the
  actor was standing in (was 62.7%); the drift still runs inward.
- **63 featured athletes with `reach_cm: 0`** — a missing value read as a reach.
- **NOT re-opened**: S4k's prior (settled), the band-conditioned prior (S4i: NO),
  the BoxMind fetch (S4j: closed NO).
