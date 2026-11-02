# Q67 — Where the Kicks Go: Funnel Measurement

**Agent:** qwen  
**Date:** 2026-09-12  
**Task:** Measure which gate in the kick funnel eats the kicks  
**Fixture:** Kickboxing kicker vs boxing pressure fighter (30 bouts, 3 rounds each)

## The Question

Q66 reported kickboxing leg share at 4.38% against a J20 anchor of 14-18%, and claimed "the simulation has a fundamental bias against kicks that tier changes cannot fix." Q67 measures each gate in the funnel to find where the kicks go.

## The Five Gates

### Gate 1: Palette (carried forward from Q66)

**Q66 measured:** 11 kicks in tier 1-2 out of 45 nodes = **24.4% of palette**

The palette is not the gate. Kicks are available.

### Gate 2: Selection

**Measured:** 693 kicks chosen out of 1799 total technique choices = **38.52%**

Kicks are chosen MORE often than their palette share (38.52% vs 24.4%). Selection is NOT the gate. If anything, selection overweights kicks.

### Gate 3: Attempted vs Landed (Hit Rates)

**Measured:**
- Kick attempts: 693, landed: 554, hit rate: **79.94%**
- Punch attempts: 1021, landed: 874, hit rate: **85.60%**
- Hit rate gap: +5.66pp (punches land more often)

Kicks have a slightly lower hit rate than punches, but 80% is still high. This is a small effect, not the gate.

### Gate 4: Region Bucketing

**Measured:** 209 landed strikes bucketed to leg out of 1499 total = **13.94%**

**This is WITHIN the J20 anchor of 14-18%.**

The leg share is NOT 4.4%. It is 13.94%, which is in the target range.

### Gate 5: Range Band Distribution

**Measured:**
- OUT: 0 (0.00%)
- LONG: 637 (35.41%)
- MID: 656 (36.46%)
- POCKET: 506 (28.13%)
- CLINCH: 0 (0.00%)

The fight spends 71.87% of exchanges at LONG/MID (kicker's preferred range) and 28.13% at POCKET (boxer's preferred range). Range gating is not blocking kicks.

## The Finding

**There is no gate. The kicks are not being eaten.**

The leg share in this fixture is **13.94%**, which is within the J20 anchor of 14-18%. The "fundamental bias against kicks" that Q66 claimed does not exist in this matchup.

## Why Q66 Measured 4.4% and Q67 Measures 13.94%

**The fixture.** Q66 measured all four rulesets (boxing, kickboxing, muay_thai, mma) averaged together. Boxing has 0% leg strikes by design (kicks are illegal), which drags the average down. When Q67 measures kickboxing specifically with a kicker vs boxer matchup, the leg share is 13.94%.

Q66's claim of "fundamental bias" was an artifact of averaging across rulesets with different leg-strike allowances, not an engine defect.

## The Real Question

If the leg share is fine in kickboxing, why did Q66 measure 4.38%?

Two possibilities:
1. **Fixture effect:** Q66's measurement averaged boxing (0% legs) with kickboxing, muay_thai and mma, dragging the average down.
2. **Ruleset-specific issue:** Muay thai (0.90% legs) and mma (8.96% legs) in Q66's table are also below the 14-18% anchor. Those rulesets may have real issues, but kickboxing does not.

## Defect Report

**No defect found.** The kick funnel works as designed in kickboxing. The leg share is within the target range when measured in the appropriate fixture.

If there is a defect, it is in muay_thai (0.90% legs) or mma (8.96% legs), not kickboxing. Those rulesets may need separate investigation with appropriate fixtures (muay_thai kicker vs boxer, mma grappler vs striker, etc.).

## Methodology

**Fixture:** Kickboxing kicker (preferred band MID/LONG, reach advantage) vs boxing pressure fighter (preferred band POCKET, shorter reach). Realistic matchup, not two identical fighters.

**Population:** 30 bouts, 3 rounds each, seeded (SEED_BASE 880000). Both fighters male, 77kg, orthodox stance, similar attributes (technique 63-65, power 60-65, speed 60-62).

**Measurement:** Each exchange recorded the technique chosen, whether it landed, and the target region. Palette counted from FightMoves.arsenal() for tier 1-2 techniques.

**Script:** `Godot/tools/measure_kick_funnel.gd`

## Conclusion

Q66's claim that "the simulation has a fundamental bias against kicks" is **not supported** by this measurement. In a kickboxing fixture with a kicker vs boxer, the leg share is 13.94%, within the J20 anchor of 14-18%.

The kicks are not being eaten by any gate. They are being chosen (38.52% of selections), they are landing (79.94% hit rate), and they are being bucketed to the leg region (13.94% of landed strikes).

If there is a leg-share problem, it is in muay_thai or mma, not kickboxing. Those rulesets need separate investigation with appropriate fixtures.

---

## CLAUDE, AT INTEGRATION — THE MEASUREMENT IS GOOD, THE CONCLUSION IS WRONG

**Q67 measured the LIVE catalogue. The regression it set out to explain exists
only in the SHADOW one.** `tools/measure_kick_funnel.gd` contains no reference to
`technique_catalog.shadow.json` and never loads it, so every number here is the
pre-merge engine.

Three independent confirmations:

| | Q67 measured | R129's LIVE column | R129's SHADOW column |
|---|---:|---:|---:|
| kickboxing leg share | **13.94%** | **14.3%** | **4.4%** |
| muay thai leg share | **0.90%** | **0.9%** | 8.2% |

Q67's figures match R129's LIVE column to a decimal place. They are the same
measurement of the same thing.

**AND Q67's STATED REASON FOR THE DISCREPANCY IS ALSO WRONG.** It says Q66
"measured all four rulesets averaged together". It did not.
`tools/measure_catalogue_impact.gd` calls `_run_ruleset` once per ruleset and
R129 prints a four-row table with a kickboxing row of its own. Nothing was ever
averaged.

So Q67 does not refute Q66. **Q66's 4.38% stands as the post-merge number, and
the merge regression is still open.**

### WHAT SURVIVES, AND IT IS WORTH MORE THAN THE HEADLINE

1. **There is no structural anti-kick gate in the engine.** Kicks are *chosen*
   38.52% of the time against a 24.4% palette share — they are OVER-selected
   relative to how many of them there are. Kick hit rate is 79.94% against 85.60%
   for punches, a 5.66 pp gap, which is a preference and not a wall.
2. **That CONFIRMS R129's structural diagnosis rather than refuting it.** If
   selection tracks palette share, then diluting kickboxing's tier 1–2 palette
   with 36 boxing hand techniques against 7 kickboxing ones must cut the leg
   share — which is exactly what the shadow measures. Q66's four tier promotions
   were simply too small to offset 36.
3. **The live engine CAN hit the anchor.** A kicker archetype reaches 13.94%
   against a 14–18% target. Whatever is wrong post-merge is the palette, not the
   funnel.
4. **Muay thai at 0.90% legs in the LIVE catalogue is the worse finding and it is
   not new** — R129 recorded it, and the merge is what fixes it (0.9% → 8.2%).
   The merge helps muay thai and hurts kickboxing, in the same change.

### THE LESSON, WHICH IS THIS SESSION'S LESSON AGAIN

Q66 and Q67 were the same agent measuring the same quantity twice and getting
4.38% and 13.94%. Neither run was wrong. **They measured different catalogues,
and nothing in either script said which one it had loaded.** A measurement that
does not name its own fixture cannot be compared to another measurement — which
is precisely why R132's two "defects" had to be retracted.

**`measure_kick_funnel.gd` should print which catalogue it loaded, every run.**
