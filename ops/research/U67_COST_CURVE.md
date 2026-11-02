U67 fitted_on=judo,muay_thai relation=linear in attribute-sum within tier, mean-preserving scale fit_quality=muay_thai r=0.83 avg tier; judo r=0.41 avg tier (t2 uncorrelated r=0.05)
U67 retuned_disciplines=boxing,kickboxing,karate nodes_changed=252 commits=3
U67 tier_mean_before=78/181/313/526 tier_mean_after=78/181/313/526
U67 bjj=left_alone_needs_authoring
U67 boxing nodes=54 reps_before=45..320 reps_after=30..364 tests_moved=athlete_development (6->1 fail: boxing_jab already_learned in 4th loop)
U67 kickboxing nodes=25 reps_before=45..320 reps_after=36..325 tests_moved=none
U67 karate nodes=173 reps_before=60..820 reps_after=53..959 tests_moved=none

## Fit measurement

Within each tier, `requires.reps` correlates with the node's attribute-sum (sum of
`requires.attributes` values). Muay thai fits strongly (tier mean |r| 0.72–0.88).
Judo fits at t1 and t4 but tier 2 is essentially flat against attribute-sum
(r=0.05) — discipline gate there tracks prerequisites more than attributes. The
retune averages both exemplars' tier linear slopes, then mean-preserves each
target tier so redistribution does not inflate the tree.

## Discipline gate

Both fields moved together. Reps use the linear fit; discipline uses rank spread
around the tier mean at the exemplar coefficient-of-variation (judo/muay_thai
average per tier). Flat gates on differentiated tiers were the trap — leaving
them flat would preserve identical unlock timing.

## boxing_stance_guard

Honest curve yields **30 reps** (was 45). One session delivers 22 reps; two
sessions (44) now completes it. The pre-existing athlete_development failure
(45 > 44 one-week delivery) is resolved. A new failure remains: `boxing_jab`
learns in two sessions (32 reps) so the test's fourth `train_technique` call
returns `already_learned` instead of `learned` — not targeted, a consequence of
tier-1 redistribution.

## BJJ

Attribute-sums are 1/1/3/1 per tier — no signal to derive from. Left unchanged;
needs separate authoring.
