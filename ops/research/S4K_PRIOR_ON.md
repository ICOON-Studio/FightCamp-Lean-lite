# S4K — `usage_prior` ON BY DEFAULT, AND WHAT THE RE-BASELINE COST

Option A, greenlit by the operator 2026-09-17. One switch
(`FightRealtime.gd:556`, `options.get("usage_prior", …)` `false` -> `true`), then
the re-baseline that switch was always going to cost.

**STATUS: SHIPPED.** The engine now runs with the per-technique usage prior on.
`usage_prior: false` still returns the pre-S4k engine byte for byte, which is what
both probes pass to get their OFF arm.

---

## 1. WHAT IT BOUGHT, AND IN WHICH UNITS

`S4H_CATALOGUE_FIELDS.md:44` measured the J21 thrown-mix error over 12 seeded
boxing bouts at **57.9 points with the prior OFF and 22.2 with it ON**. That is
the whole case for A and it was already made; this stage did not re-measure it.

What this stage DID measure is the thing S4i left open and the roadmap flagged as
the unit trap.

### THE TRAP, SETTLED: named-throw occupancy is NOT all-beat occupancy

S4i reported band occupancy **byte-identical** off and on and the roadmap read
that as "the prior does not move occupancy". It is true in ALL-BEAT units and
FALSE in the units B's target is written in.

`tools/probe_band_occupancy.gd`, same 12 seeds, same two men, one run:

| band | all-beat OFF | all-beat ON | **named-throw OFF** | **named-throw ON** | delta |
| --- | --- | --- | --- | --- | --- |
| LONG | 33.8% | 33.8% | **20.1%** | **25.6%** | +5.5 pts |
| MID | 31.9% | 31.9% | **21.4%** | **24.3%** | +3.0 pts |
| POCKET | 34.3% | 34.3% | **58.6%** | **50.1%** | -8.5 pts |

The all-beat column does not move a digit. The named-throw column moves 8.5
points. Both are correct: the prior changes WHICH technique is thrown, never
WHERE the men stand, and the six punches are about twice as dense per beat at
POCKET as at LONG - so a pure change of mix reweights the named table while the
all-beat table sits still. **"Occupancy" is not one quantity, and a probe that
prints one of them settles nothing about the other.**

The instrument now prints BOTH, side by side, with the delta
(`_print_named_occupancy`), so the next reader cannot take the wrong one.

### AND B'S TARGET SURVIVES UNCHANGED

This was the live risk: B is sized as **LONG 25.6% -> ~40%**, and if A moved
25.6% then B's target was derived against a baseline that no longer exists.

It did not. **25.6% IS the prior-ON figure** - it always was, which the tripwire
already implied (S4i's solver reconstructs S4h's ON column to 0.00 points) and
this run confirms directly by printing both arms. 20.1% is the number B would
have been sized against had B gone first, and nobody ever used it.

So the figure to carry into S4l is the one already written down, and it is now
the SHIPPED state rather than a hypothetical:

- measured LONG **25.6%**, MID 24.3%, POCKET 50.1% (named throws);
- free solve LONG 53.5% / MID 0.5% / POCKET 46.0%, residual **3.9 pts**;
- **MID PINNED** at its measured 24.3%: LONG **40.5%** / POCKET 35.2%, residual
  **4.9 pts**. The corner is worth 1.0 of the 18.3-point win, so report the
  pinned variant - which is where the ~40% comes from.

Tripwire read **0.00 points** on all six punches again, so the reweighting is
sound in the same sense S4i established it.

### THE THROW COUNT

| | OFF | ON |
| --- | --- | --- |
| action beats | 4,900 | **5,243** (+7.0%) |
| of which the six named punches | 2,233 | **2,655** (+18.9%) |
| feints | 712 | 725 |

Everything that rides a bout's course - damage, stamina, bout length, stoppages,
verdicts - moves with those 343 extra beats. That is the whole of the
re-baseline below.

---

## 2. THE RE-BASELINE: FOUR TESTS, ALL RE-FOUND, NOTHING RELAXED

Discovery run over the 69 tests that reach `FightRealtime` or one of its sixteen
consumers: **7 red, 3 of them master's own** (`fight_pair_live` and
`fight_stage_presenter_contract` red on purpose while the jab pair is parked,
`fight_stage_realism` red on master). Four were the flip's.

### 2a. `fight_realtime_test` - two occurrence seeds, RE-FOUND by sweep

- **The doctor stoppage.** 4406/4409/4410 stopped stopping fights.
  `tools/find_s4f_seeds.gd -- doctor`, the SAME 4400..4499 unchanged, returns
  **23 doctor stoppages against 74 KOs and 3 TKOs**, where S4f found 25 against
  75 KOs. The rule is as reachable as it was. First three ascending: **4403 4408
  4417**, heads 8.5 / 8.0 / 12.1 at the stop.
- **The corner's `defence` instruction.** This pin is a FORMULA, not a seed list,
  so it is re-found by SLIDING THE BASE - picking seeds to match would be
  choosing the population. `find_s4f_seeds.gd -- corner` answers **81000** (was
  81004): lowest head 26.7 against the rule's 28.0, `defence` 1, all three
  urgencies, varied 14 of 24. It is the FIRST base tried, so nothing was hunted.

### 2b. `judge_panel_test` - 12 cards re-pinned, T11 RE-FOUND

The card table is a REPRODUCIBILITY record, not an occurrence assertion: T4/T8R
runs every bout twice and pins only where the two runs agree, so a card moving
with the engine is the record doing its job. All twelve were parsed out of the
test's own printed actual by script, never transcribed - the FAIL line prints
`key ACTUAL != EXPECTED` and reading it the other way round silently re-pins the
old card.

**THE BASE RATE, BEFORE ANY NARRATION** (the trap S4f's own record names: five of
eleven pins once became KOs with a tidy story attached). Stoppages among the 13
pinned bouts: **4 before, 4 after.** One swap, in opposite directions - `mma_5`
went KO -> DECISION and `kickboxing_13` went DECISION -> KO. There is no KO surge
to explain, and had there been one, these pins are a SELECTED sample and could
not have measured it.

**T11 is not a pin.** It needs a SPLIT and a MAJORITY to EXIST, so it was
RE-FOUND by re-running S4f's widened sweep unchanged - same 62-v-64 fixture, same
301..900 per ruleset, `find_s4f_seeds.gd -- panelwide`:

| | S4f | S4k |
| --- | --- | --- |
| boxing splits | 3 (381 454 659) | **5 (476 499 519 521 623)** |
| boxing majorities | 10 | 11 |
| kickboxing majorities | 9 (345 first) | **3 (603 628 885)** |
| kickboxing splits | 1 (513) | 2 (787 867) |

Both families got no rarer, so the pair stays ONE RULESET EACH and the
cross-ruleset coverage S4 (4) had to give up is still recovered: the SPLIT is
**boxing 476**, the MAJORITY **kickboxing 603**, each the first hit ascending in
its own ruleset.

### 2c. `grapple_adapter_test` - the muay thai witness, re-found a 13th time

93049 stopped landing its one throw. `find_r102_seeds.gd -- mt`, same
93000..93399, returns **20 one-throw unanimous decisions**; **93029** is the
first ascending. Card **30-24 unanimous to A** - unchanged for the third witness
seed running, which is the reassuring part: the card is a property of the
matchup, not the seed. Tally moved with it: SUBMISSION 132 / DECISION 221 / KO 47
of 400, against S4f's 140 / 206 / 54.

Muay thai's phantom submissions (132 of 400 under a ruleset that does not allow
them) are still there, still Q90's, and deliberately NOT what this witness pins.

### 2d. `fight_room_positions_test` S4-2-1 - A REAL DEFECT, NOT A PIN

This one is worth the space, because the honest answer was not "re-find".

S4-2-1 asserts the two men never occupy the same floor, and it went 0.00% ->
**0.04% of frames inside 0.343 m**. The gate reads the RENDERED node positions,
and three things sit between the engine's two 2D points and those nodes. Rather
than guess which, `tools/probe_room_floor.gd` (new, read-only) prints all three:

```
PROBE frames=5402 inside=2 share=0.037% floor=0.3429 m engine_radius_sum=0.3527 m
PROBE min node gap=0.3296 m   min engine gap=0.3536 m   max summed warp=0.1997 m
PROBE worst inside frame=3696 node=0.3296 engine=0.3592 warp_a=0.0000 warp_b=0.0296
PROBE engine kept its own floor: YES (min engine gap 0.3536 vs radius sum 0.3527)
```

**The engine kept its word and the arithmetic names the culprit to the digit:**
0.3592 engine minus 0.0296 of lean is 0.3296, which is the worst frame exactly.
The STRIKE WARP - each man's lean into his own punch, applied in
`_place_bodies` AFTER the engine's push-apart - is capped per man
(`WARP_MAX_T * torso_m`) and **never against the pair**. The engine's radius sum
(0.3527) clears the meshes' floor (0.3429) by 1 cm, and two leans at the engine's
minimum ate that centimetre.

So the defect PREDATES the flip and the flip made it reachable: more punches, and
the six are POCKET-dense, so the men arrive at the engine's minimum mid-lean far
more often.

**THE FIX IS IN THE PICTURE, WHERE THE DEFECT IS.** `_floor_clamped` scales both
warps down by the same FRACTION - so a jab and a cross thrown together still read
as a jab and a cross - just far enough that the rendered gap clears the two men's
own summed torso radius, plus a 1 mm guard band for the same reason
`_resolve_bodies` carries its 1.2 mm quantiser slack. The warp STATE is
untouched, so `warp_offsets()` still reports what the animation asked for, which
is what the measure tools read. After: **inside=0, min node gap 0.3439 m.**

`FightBodyCapsules.torso_radius` is new and exists because that number was being
derived in two places that could drift apart - the gate that measures the floor
and the room that has to respect it.

---

## 3. WHAT IS NOT IN THIS STAGE

- **B** (move position so LONG rises) - S4l, and it is now sized against a
  measured, shipped 25.6%.
- **C**, and a band-conditioned prior, which S4i answered NO.
- Muay thai's phantom submissions (Q90).
- The out-of-band leak: 239 of 2,655 named throws land outside their authored
  bands through R102's mismatch path, so band is a BIAS and not a GATE. Recorded
  by the probe, unchanged by this stage.
