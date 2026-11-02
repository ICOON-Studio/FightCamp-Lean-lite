# C61 — The skill that narrows, not only raises

## Finding before the mechanism

I ran 200 seeded Boxing bouts per Technique level (20/40/60/80/95), with all
other stats, learned actions, fixtures, and opponent held constant. The
existing flat roll raises the mean but does not narrow the across-seed spread:

| Technique | Land rate mean | Land-rate SD | Landed damage mean | Landed damage SD | Round margin mean | Round margin SD |
|---:|---:|---:|---:|---:|---:|---:|
| 20 | .60614 | .07841 | 6.52775 | 3.54139 | -.03011 | 1.85121 |
| 40 | .61764 | .08275 | 6.67808 | 3.60371 | .00846 | 1.85286 |
| 60 | .62673 | .08384 | 6.80149 | 3.68323 | .01964 | 1.85683 |
| 80 | .63569 | .08541 | 6.90151 | 3.77047 | .11324 | 1.84854 |
| 95 | .64418 | .08637 | 6.98327 | 3.83568 | .21169 | 1.84521 |

The answer before Part 2 is therefore mean only: skill was not repeatability.

## Opt-in mechanism

`options.get("consistency", false)` is stored on `fight_state`. When enabled,
the action roll uses a separate generator seeded from the bout seed, leaving
the historic `_rng` stream untouched. The roll is uniform over an interval
containing the existing `success_chance`; its total width is 1.0 at the skill
floor and 0.35 at the skill ceiling. This preserves the original landing
probability while reducing execution spread. The floor is no more random than
the old [0, 1] roll; the ceiling remains non-deterministic.

The separate `_weighted_choice` `execution_quality` remains unchanged: it is
action-selection weighting, not the execution roll measured here.

## Cost with `consistency: true`

| Technique | Land rate mean | Land-rate SD | Landed damage mean | Landed damage SD | Round margin mean | Round margin SD |
|---:|---:|---:|---:|---:|---:|---:|
| 20 | .60763 | .07544 | 6.57038 | 3.50080 | -.08346 | 1.84544 |
| 40 | .62068 | .07910 | 6.70119 | 3.58772 | .02542 | 1.83959 |
| 60 | .62823 | .08033 | 6.82218 | 3.65826 | .04830 | 1.85411 |
| 80 | .63355 | .08100 | 6.95444 | 3.73233 | .16604 | 1.84462 |
| 95 | .64222 | .08315 | 7.06498 | 3.77698 | .23960 | 1.83044 |

In a separate 500-bout high-vs-low matchup (Technique 95 versus 20), the high
skill fighter won 368/500 (73.6%) with the term OFF and 370/500 (74.0%) with it
ON. This sample does not turn the matchup into a disproportionate 90/10
result; the operator can decide whether the modest narrowing is desirable.

## Verification and follow-up

The default and explicit-off paths are covered as byte-identical seeded logs,
cards, and results. `judge_panel_test.gd` preserved all ten pinned cards.
Focused results: fight simulation 253 checks/0 failures, judge panel 0
failures, and combo chains 0 failures. The full-suite gate remains the stated
baseline of `total=190 fails=2` from Q11's migration regression.

R80's burst texture remains flat regardless of skill. Narrowing burst jitter is
the explicitly named follow-up and is out of scope here.
