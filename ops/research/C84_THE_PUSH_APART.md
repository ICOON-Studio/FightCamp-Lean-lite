# C84 — The cost of pushing them apart

## Result

An equal-split minimum-separation constraint costs zero scored strikes by
construction, but it is not a small visual nudge at anatomy-safe distances. At
0.50 m, each fighter's first-order correction is 6.63 cm at the median, 17.86 cm
at P95, and 25.00 cm at maximum. It engages on 136,101 of 3,706,360 recorded
post-advance ticks (3.6721%).

These are **FIRST-ORDER ESTIMATES**, not the corrections a changed fight would
actually experience. The moment a live constraint pushes the fighters apart,
their next distances and decisions change; the real correction sequence then
diverges from the unmodified replay. Winner and scorecard changes cannot be
computed post hoc without editing the engine, which this task expressly forbids.

## Method

`fight_pushapart_test.gd` replayed the same 200 three-round boxing bouts and
seeds 200000–200199 used by Q35 and C82. It did not alter the engine. After each
ordinary `advance_tick`, it observed the two positions and costed the smallest
unclamped equal split that would restore each candidate separation:

- pair correction = `floor - observed separation`
- per-fighter correction = half the pair correction
- tick denominator = every recorded post-advance tick
- native displacement = the sum of both fighters' ordinary per-tick movement

The movement-disturbed bound is total pair correction divided by total native
two-fighter displacement across the same sample. It is a magnitude comparison,
not a prediction of the changed trajectory. It also assumes both corrections
can be split evenly; a live ring-edge clamp could redistribute them.

## Measurements

Across all candidates, native two-fighter displacement was 504,791.541 m over
3,706,360 post-advance ticks.

| candidate floor | ticks affected | share of ticks | affected ticks/bout mean / median / P95 / max | each fighter median | each fighter P95 | each fighter max | pair corrections / native movement |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 0.30 m | 37,179 | 1.0031% | 185.90 / 170.5 / 230.1 / 1,405 | 0.0386 m | 0.1378 m | 0.1500 m | 3,695.242 m / 0.7320% |
| 0.45 m | 108,431 | 2.9255% | 542.15 / 490.5 / 1,655.1 / 2,944 | 0.0523 m | 0.1677 m | 0.2250 m | 14,291.103 m / 2.8311% |
| 0.50 m | 136,101 | 3.6721% | 680.51 / 627.5 / 1,810.5 / 3,097 | 0.0663 m | 0.1786 m | 0.2500 m | 20,356.569 m / 4.0327% |

The constraint pushes both fighters equally in distance. It does not affect
their progress equally. On engaged ticks with exactly one fighter marked
`close`, the outward correction opposed that presser's ordinary movement much
more often and consumed a larger bounded share of the presser's movement:

| floor | exactly-one-presser ticks | presser movement opposed | bounded presser movement cancelled | bounded other movement cancelled |
|---:|---:|---:|---:|---:|
| 0.30 m | 6,928 | 4,433 (63.99%) | 166.331 / 362.157 m (45.93%) | 70.789 / 347.263 m (20.38%) |
| 0.45 m | 19,046 | 15,350 (80.59%) | 699.157 / 1,235.623 m (56.58%) | 234.274 / 1,188.813 m (19.71%) |
| 0.50 m | 27,182 | 21,086 (77.57%) | 1,020.624 / 1,694.608 m (60.23%) | 319.635 / 1,631.680 m (19.59%) |

“Cancelled” is bounded by both the push magnitude and the component of ordinary
movement opposing that push. It does not claim that a live corrected fighter
would have followed the recorded next trajectory. Twenty-five engagements at
each floor had exact recorded overlap, so their outward direction—and therefore
their presser attribution—was unresolved rather than invented.

## Options at a glance

The rejection figures below are the already-established Q35/C82 measurements.
Their 0.60 m candidate is retained rather than interpolating an unmeasured
0.50 m rejection rate.

| approach | candidate | strikes lost | ticks affected | movement disturbed | moves seeded pins? |
|---|---:|---:|---:|---:|:---:|
| Reject strike | 0.30 m | 4.16% | strike-event ticks only; not supplied as a tick share | positions unchanged directly; later fight divergence is at least the rejected events | yes |
| Reject strike | 0.45 m | 9.96% | strike-event ticks only; not supplied as a tick share | positions unchanged directly; later fight divergence is at least the rejected events | yes |
| Reject strike | 0.60 m | 19.90% | strike-event ticks only; not supplied as a tick share | positions unchanged directly; later fight divergence is at least the rejected events | yes |
| Push apart | 0.30 m | 0% by construction | 37,179 / 3,706,360 (1.0031%) | first-order pair correction = 0.7320% of native displacement | yes |
| Push apart | 0.45 m | 0% by construction | 108,431 / 3,706,360 (2.9255%) | first-order pair correction = 2.8311% of native displacement | yes |
| Push apart | 0.50 m | 0% by construction | 136,101 / 3,706,360 (3.6721%) | first-order pair correction = 4.0327% of native displacement | yes |
| Do nothing | current | 0% | 0 | 0 | no |

“Moves seeded pins” means the proposed live behavior would change the seeded
trajectory and therefore can move pinned scorecards/results. This analysis does
not say how many winners would change.

## Recommendation

**Do nothing for now:** a 0.50 m push-apart floor saves every strike but can move
each fighter 17.9 cm at P95 and systematically cancels the presser's progress,
so it risks looking and fighting worse than the rare interpenetration it fixes.
