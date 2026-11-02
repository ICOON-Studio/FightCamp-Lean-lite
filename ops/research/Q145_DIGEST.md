# Q145 DIGEST — Does the carried training record hold in every ruleset?

**Branch:** `qwen/q145-record-every-ruleset`
**Date:** 2026-09-23
**Tool:** `Godot/tools/q145_record_every_ruleset.gd`

## Question

S59 made `carry_progress` default to true. Q142 measured it in MMA only. Does
the narrowing produce an EMPTY grapple palette in any of the other ten rulesets?

## Method

- 11 rulesets from `combat_rulesets.json`
- Two different fighters per ruleset (differ by style and stats, both legal)
- 24 bouts each, seeds 563000+i, 3 rounds
- Two arms: `carry_progress=false` (current) vs `carry_progress=true` (carried)
- Ruleset passed as DICTIONARY (not bare id), `state["ruleset_id"]` printed for bout 0

## Results

| ruleset | arm | pal_A | pal_B | empty? | named | unnamed | learned% | KO | TKO | SUB | DEC |
|---|---|---|---|---|---|---|---|---|---|---|---|
| mma | current | 120 | 120 | no | 1694 | 47 | 98.1% | 5 | 2 | 10 | 7 |
| mma | carried | 119 | 104 | no | 1694 | 47 | 100.0% | 5 | 2 | 10 | 7 |
| boxing | both | 6 | 6 | no | 0 | 0 | — | 2 | 0 | 0 | 22 |
| kickboxing | both | 7 | 7 | no | 0 | 0 | — | 7 | 0 | 0 | 17 |
| muay_thai | both | 10 | 10 | no | 0 | 633 | 0.0% | 5 | 0 | 1 | 18 |
| judo | both | 43 | 43 | no | 122 | 746 | 100.0% | 7 | 1 | 0 | 16 |
| freestyle_wrestling | both | 9 | 9 | no | 414 | 769 | 100.0% | 5 | 3 | 2 | 14 |
| greco_roman | both | 9 | 9 | no | 354 | 803 | 100.0% | 5 | 2 | 4 | 13 |
| karate | both | 0 | 0 | YES | 0 | 0 | — | 4 | 2 | 0 | 18 |
| bjj | both | 43 | 43 | no | 1731 | 686 | 100.0% | 10 | 3 | 8 | 3 |
| sambo | both | 9 | 9 | no | 704 | 901 | 100.0% | 9 | 3 | 3 | 9 |
| taekwondo | both | 0 | 0 | YES | 0 | 0 | — | 3 | 0 | 0 | 21 |

## Population

Two different men per ruleset, both legal for that ruleset's disciplines.
They differ by style (untrained branches) and stats. No identical fighters.

**MMA:** wrestle-grappler (grapple 82, untrained kicks/kicking) vs striker (grapple 34, untrained submissions/takedowns)
**Boxing:** pressure boxer (grapple 20) vs out-boxer (grapple 18)
**Kickboxing:** low-kicker (grapple 22) vs volume kicker (grapple 20)
**Muay Thai:** clinch fighter (grapple 56) vs knee-elbow striker (grapple 38)
**Judo:** thrower (grapple 84) vs pinner (grapple 80)
**Freestyle:** snatch wrestler (grapple 84) vs go-behind specialist (grapple 80)
**Greco-Roman:** body-lock thrower (grapple 82) vs arm-throw specialist (grapple 78)
**Karate:** distance karate-ka (grapple 24) vs pressure karate-ka (grapple 28)
**BJJ:** guard passer (grapple 86) vs submission hunter (grapple 82)
**Sambo:** throw-heavy sambist (grapple 82) vs leg-lock sambist (grapple 80)
**Taekwondo:** head-kick specialist (grapple 20) vs volume kicker (grapple 18)

## Reading

**No palette went EMPTY from carry_progress.** The risk that motivated this task
did not materialize. Karate and taekwondo show palette 0 on both arms because
they have no grapple disciplines at all — not because carry_progress emptied them.

**MMA is the only ruleset where carry_progress narrows the palette.** The other
ten rulesets show identical palette sizes on both arms. This suggests the
fighters' training records already cover the tier 1-2 palette for those rulesets,
so carrying the record changes nothing.

**Muay thai: 633 grapple events, ALL unnamed.** The clinch discipline produces
grapple events but they carry no technique ID. This is true on both arms. The
engine is firing grapple events from clinch work, but they are not named.

**Bout outcomes are identical between arms for every ruleset.** Carry_progress
does not change who wins or how.

**Learned% is 100% on both arms for every grappling ruleset except MMA.** In MMA,
the current arm is 98.1% (some events name techniques the fighter didn't train),
and the carried arm is 100.0% (every named event is a learned technique). This
is the S59 improvement: carrying the record ensures every grapple event names
something the fighter actually knows.

## Conclusion

The carried training record is safe across all 11 rulesets. No palette went
empty. MMA benefits from the narrowing (98.1% → 100% learned). The other ten
rulesets are unaffected because their fighters' records already cover the
tier 1-2 palette. Muay thai's 633 unnamed grapple events are a separate issue
(clinch events don't carry technique IDs) and are present on both arms.
