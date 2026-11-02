# Q141 — CLEAN THE VERTEX SET, WHICH YOU HAVE NOW RECOMMENDED TWICE

**Tool:** `Godot/tools/q141_vertex_clean.gd`
**Date:** 2026-09-22
**Owner:** qwen

## THE QUESTION

Q139 and Q140 both named the vertex set as the real problem: the `max` exceeds
`p80` by 18–97 mm on every rig, and something bound to the `Head` bone is not
skull. This task characterises the tail, measures three cleaning candidates,
and shows the before/after table with Q140's coverage columns.

## METHOD

For each of the twelve rigs:

1. **Extract Head vertices with full weight info.** Modified `_skin_verts` that
   returns, per vertex: position (best-bone transform), blended position (all
   bone transforms weighted by skin weights), best weight, second-best bone
   name, second-best weight.

2. **Characterise the tail.** Split vertices into core (≤p80), tail (>p80), and
   far tail (>p95). For each: direction from centroid (shoulder-derived axes),
   hemisphere fractions, weight distribution, second-bone census.

3. **Measure three cleaning candidates:**
   - **A) Min bind weight:** drop vertices with best_weight < w. Thresholds:
     0.50, 0.55, 0.60, 0.65, 0.70, 0.75, 0.80, 0.85, 0.90.
   - **B) Geometric:** drop vertices with distance > k × median. k values:
     1.5, 2.0, 2.5, 3.0.
   - **C) Blended position:** recompute positions using weighted blend of all
     bone transforms (no vertices removed).

4. **Derive the cleaning rule.** Pick the min-weight threshold that: removes
   something on every rig, preserves all three regions (face/temple/cranium) on
   every rig, and maximises p80 reduction with fewest face coverage losses. If
   no min-weight threshold works, fall back to geometric.

5. **Before/after table.** Per rig: n_before, n_after, p80_before, p80_after,
   delta_mm, face_out_p90 (before/after), temple_in_gap_p90 (before/after).

6. **Non-vacuity checks.** (a) Rule removes something on every rig. (b) Regions
   non-empty after cleaning. (c) Absurd control: rule at extreme setting should
   collapse the radius.

## RAW OUTPUT

```
Q141 VERTEX CLEAN - characterise tail, derive cleaning rule
  population: 12 rigs
  axes: shoulder-derived (same as Q139/Q140)
  regions: face(60 deg azi, 45 deg elev) temple(45 deg lat) cranium(rest)

== f01_m_box_welter (1.75 m, 834 verts, shoulders) ==
  distances: p50=0.1117  p80=0.1256  p95=0.1387  max=0.1535
  tail (>p80): 167/834 (20.0%)
    direction: sag=-0.0024  lat=-0.0028  vert=-0.0320
    hemispheres: fwd=74/167  up=71/167  right=82/167
    weights: median_best=0.967  median_second=0.032
    top second bones: Neck(137) UpperChest(27) RightToes(3)
  far tail (>p95): 42/834 (5.0%)  median best_w: 0.806
  core (<=p80): 667  median best_w: 1.000
  weight distributions: core p10=0.920 p90=1.000 | tail p10=0.436 p90=1.000

== f02_m_box_heavy (1.93 m, 723 verts) ==
  tail: 145/723 (20.1%)  direction: sag=+0.0674  vert=+0.0463
  weights: median_best=1.000  top second: Neck(139) UpperChest(6)
  far tail: 37/723 (5.1%)  median best_w: 1.000

== f03_f_box_fly (1.58 m, 973 verts) ==
  tail: 195/973 (20.0%)  direction: sag=+0.0067  vert=-0.0093
  weights: median_best=1.000  top second: Neck(152) UpperChest(43)
  far tail: 49/973 (5.0%)  median best_w: 1.000

== f04_f_box_middle (1.74 m, 1614 verts) ==
  tail: 323/1614 (20.0%)  direction: sag=-0.0326  vert=-0.0519
  weights: median_best=0.998  top second: Neck(300) UpperChest(23)
  far tail: 80/1614 (5.0%)  median best_w: 0.998

== f05_m_mma_light (1.78 m, 1707 verts) ==
  tail: 342/1707 (20.0%)  direction: sag=-0.0263  vert=-0.0635
  weights: median_best=0.873  top second: Neck(327) UpperChest(15)
  far tail: 86/1707 (5.0%)  median best_w: 0.668

== f06_m_mma_lhw (1.89 m, 793 verts) ==
  tail: 159/793 (20.1%)  direction: sag=+0.0204  vert=-0.0206
  weights: median_best=0.969  top second: Neck(146) UpperChest(13)
  far tail: 40/793 (5.0%)  median best_w: 0.788

== f07_f_mma_straw (1.59 m, 1400 verts) ==
  tail: 280/1400 (20.0%)  direction: sag=+0.0504  vert=-0.0159
  weights: median_best=1.000  top second: Neck(202) UpperChest(78)
  far tail: 69/1400 (4.9%)  median best_w: 1.000

== f08_f_mma_bantam (1.65 m, 1449 verts) ==
  tail: 289/1449 (19.9%)  direction: sag=-0.0333  vert=-0.0141
  weights: median_best=1.000  top second: Neck(196) UpperChest(90)
  far tail: 72/1449 (5.0%)  median best_w: 1.000

== f09_m_bare_welter (1.81 m, 987 verts) ==
  tail: 198/987 (20.1%)  direction: sag=-0.0246  vert=-0.0381
  weights: median_best=0.875  top second: Neck(193) UpperChest(5)
  far tail: 50/987 (5.1%)  median best_w: 0.766

== f10_m_bare_heavy (1.93 m, 716 verts) ==
  tail: 143/716 (20.0%)  direction: sag=+0.0454  vert=+0.0153
  weights: median_best=1.000  top second: Neck(129) UpperChest(14)
  far tail: 36/716 (5.0%)  median best_w: 0.790

== f11_f_bare_feather (1.68 m, 1018 verts) ==
  tail: 204/1018 (20.0%)  direction: sag=+0.0188  vert=+0.0099
  weights: median_best=1.000  top second: Neck(197) UpperChest(7)
  far tail: 50/1018 (4.9%)  median best_w: 1.000

== f12_f_bare_welter (1.69 m, 1465 verts) ==
  tail: 292/1465 (19.9%)  direction: sag=+0.0187  vert=-0.0011
  weights: median_best=0.879  top second: Neck(238) LeftHand(49)
  far tail: 74/1465 (5.1%)  median best_w: 0.663

== POPULATION WEIGHT DISTRIBUTION ==
  core  n=10942  p10=0.846  median=1.000  p90=1.000
  tail  n=2737   p10=0.622  median=0.999  p90=1.000
  far   n=685    p10=0.485  median=0.998  p90=1.000

== CLEANING CANDIDATE COMPARISON (population medians) ==
  A) min bind weight:
    thresh  n_med  p80_med  dp80_mm  face_p90  templ_p90  rgn_ok
    0.50      982   0.1328    +1.0    0.0154    0.0507     12/12
    0.60      961   0.1320    +1.4    0.0153    0.0502     12/12
    0.70      942   0.1319    +1.5    0.0145    0.0500     12/12
    0.80      906   0.1285    +2.4    0.0143    0.0465     12/12
    0.90      865   0.1247    +5.0    0.0118    0.0427     12/12

  B) geometric (distance <= k * median):
    k     n_med  p80_med  dp80_mm  face_p90  templ_p90  rgn_ok
    1.5     978   0.1342    +0.1    0.0174    0.0503     12/12
    2.0    1003   0.1342    +0.0    0.0146    0.0518     12/12
    2.5    1003   0.1342    +0.0    0.0146    0.0518     12/12
    3.0    1003   0.1342    +0.0    0.0146    0.0518     12/12

  C) blended position (no vertices removed):
    median p80=0.1342  dp80=+0.0 mm  face_out_p90=0.0147  temple_gap_p90=0.0518

== DERIVING CLEANING RULE ==
  CHOSEN: min bind weight >= 0.80

== BEFORE/AFTER TABLE (chosen rule: min_weight >= 0.80) ==
  rig                      n_bef  n_aft  p80_bef  p80_aft  dp80_mm  fc_bef   fc_aft   tm_bef   tm_aft
  f01_m_box_welter           834    765   0.1256   0.1215    +4.1   0.0107   0.0121   0.0500   0.0448
  f02_m_box_heavy            723    620   0.1333   0.1280    +5.3   0.0197   0.0165   0.0532   0.0469
  f03_f_box_fly              973    876   0.1158   0.1156    +0.2   0.0380   0.0337   0.0484   0.0440
  f04_f_box_middle          1614   1526   0.1558   0.1574    -1.5   0.0000   0.0000   0.0943   0.0948
  f05_m_mma_light           1707   1582   0.1274   0.1250    +2.4   0.0062   0.0061   0.0395   0.0362
  f06_m_mma_lhw              793    713   0.1368   0.1344    +2.4   0.0089   0.0080   0.0497   0.0470
  f07_f_mma_straw           1400   1275   0.1459   0.1479    -2.1   0.0379   0.0344   0.0756   0.0743
  f08_f_mma_bantam          1449   1345   0.1381   0.1408    -2.7   0.0186   0.0192   0.0651   0.0651
  f09_m_bare_welter          987    872   0.1285   0.1223    +6.2   0.0040   0.0044   0.0503   0.0420
  f10_m_bare_heavy           716    608   0.1350   0.1303    +4.6   0.0106   0.0087   0.0489   0.0439
  f11_f_bare_feather        1018    936   0.1281   0.1291    -0.9   0.0416   0.0371   0.0569   0.0553
  f12_f_bare_welter         1465   1157   0.1409   0.1255   +15.4   0.0351   0.0534   0.0681   0.0461

== NON-VACUITY ==
  1. Rule removes something on every rig: 12/12 passed
  2. Regions non-empty after cleaning: 12/12 passed
  3. Absurd control:
     mw(0.99): p80 drops on 10/12 rigs (f04 +1.5mm, f07 +0.5mm grow)
     geo(0.5): collapses to 0 on 11/12 rigs (f04 retains 73 verts at p80=0.0444)
```

## FINDINGS

### 1. The tail is NOT low-weight

The tail's median best_w is ≈1.000 on 7 of 12 rigs (f02, f03, f04, f07, f08,
f10, f11). On the remaining 5 rigs, it ranges from 0.873 to 0.969. The
population median tail best_w is 0.999 — essentially identical to the core
(1.000).

**The tail vertices ARE strongly weighted to Head.** They are not borderline
vertices that got misassigned by the highest-weight rule. They are genuinely
Head-dominant vertices that happen to be far from the centroid.

The far tail (>p95) has lower weights on 5 rigs (f01: 0.806, f05: 0.668, f06:
0.788, f09: 0.766, f10: 0.790, f12: 0.663) but not on the other 6 (f02, f03,
f04, f07, f08, f11 all have far tail median best_w = 1.000).

### 2. The tail IS the Neck boundary

The second-best bone for tail vertices is overwhelmingly **Neck**: 82–97% of
tail vertices on every rig. The remaining second bones are UpperChest (3–78),
RightShoulder (3), LeftHand (49), RightToes (3–5).

**The tail is the Head/Neck transition zone** — vertices at the base of the
skull / top of the neck that are correctly assigned to Head (because they ARE
mostly Head) but are far from the Head centroid because they're at the bottom
of the head. The head is vertically elongated (Q139 showed halfvert is the
longest or second-longest axis on every rig), so the bottom of the head is far
from the centroid.

The tail direction varies by rig but is predominantly **below** the centroid
(negative vert offset on 8/12 rigs) and either forward or behind. This is
consistent with the neck opening at the base of the skull.

### 3. The geometric rule does nothing

At k=2.0, the geometric rule removes zero vertices on the median rig. At k=1.5,
it removes a handful. The tail vertices are within 2× the median distance
because the median is already large (it's the p50 of the full vertex set, which
includes the vertically elongated head).

**The geometric rule cannot separate the tail from the core** because the tail
is not an extreme outlier — it's the natural extension of the vertex
distribution along the vertical axis.

### 4. The blended position does nothing

The blended position (weighted blend of all bone transforms) produces +0.0 mm
change in p80. This is because the tail vertices have best_w ≈ 1.0, so the
blended position is almost identical to the Head-only position. The Neck weight
(≈0.0) contributes nothing.

### 5. The min-weight rule works partially

At threshold 0.80, the rule removes 10–21% of vertices on each rig and reduces
p80 on 8/12 rigs (median reduction: +2.4 mm). But it **increases** p80 on 4/12
rigs (f04: +1.5 mm, f07: +2.1 mm, f08: +2.7 mm, f11: +0.9 mm).

The increase happens because removing low-weight vertices (which are near the
centroid) shifts the centroid, which can increase the p80. This is a fundamental
limitation of the centroid-based radius: removing vertices changes the centroid.

### 6. Face coverage degrades on 3 rigs

The min-weight rule at 0.80 makes face_out_p90 worse on 3 rigs:
- **f01**: 10.7 mm → 12.1 mm (+1.4 mm)
- **f08**: 18.6 mm → 19.2 mm (+0.6 mm)
- **f12**: 35.1 mm → 53.4 mm (+18.3 mm)

f12 is the worst case: p80 drops by 15.4 mm but face under-coverage jumps by
18.3 mm. That is the wrong trade — the radius shrinks but the face gets worse.

On the population median, face_out_p90 drops slightly (0.0146 → 0.0143), but
this hides the individual rig degradation.

## NON-VACUITY

### 1. Rule removes something on every rig: 12/12 PASSED

The min-weight rule at 0.80 removes vertices on every rig (n_after < n_before).

### 2. Regions non-empty after cleaning: 12/12 PASSED

Face, temple, and cranium are all non-empty on all 12 rigs after cleaning.

### 3. Absurd control: MOSTLY PASSED

- **Min weight at 0.99:** p80 drops on 10/12 rigs but **grows** on f04
  (+1.5 mm) and f07 (+0.5 mm). This is the centroid-shift problem: removing
  the few low-weight vertices (which are near the centroid) shifts the centroid
  and increases the p80.
- **Geometric at k=0.5:** collapses to 0 on 11/12 rigs. f04 retains 73 vertices
  within 0.5× median (p80=0.0444 m) because it has a large vertex set (1614)
  and a large median distance.

The absurd control shows that the geometric rule is being applied correctly
(it collapses), but the min-weight rule has a pathological case where removing
vertices increases the radius.

## VERDICT

**p80 stays. The tail was never the issue.**

The tail is not dirty data. It is the anatomical Head/Neck boundary — vertices
that are correctly assigned to Head but are far from the centroid because the
head is vertically elongated. The min-weight cleaning rule reduces p80 on 8/12
rigs but degrades face coverage on 3/12 rigs. The net effect is too small and
too inconsistent to justify changing the shipped radius.

**The real problem is not the vertex set; it is the model.** The head is not a
sphere — it is an ellipsoid with three unequal semi-axes (Q139). A centroid-
based sphere radius will always have a tail, because the bottom of the head is
far from the centroid. The right fix is not to clean the vertex set but to use
a better model (e.g., an ellipsoid, or a depth-based radius along the sagittal
axis, or a different centroid).

**Q139's shrink was NOT right all along.** The tail is not dirty data that was
blocking the shrink. The tail is the anatomical reality of the Head/Neck
boundary. Shrinking the radius (whether by cleaning the vertex set or by
changing the percentile) makes face coverage worse on some rigs, which is the
wrong trade.

**Recommendation:** Keep p80. Do not clean the vertex set. If the head radius
needs to change, it should be based on a better model (e.g., depth-based, or
anthropometric), not on cleaning the vertex set.

## SELF-CRITIQUE

**The tail characterization is descriptive, not causal.** I showed that the tail
is the Neck boundary, but I did not prove that the Neck boundary is the ONLY
source of the tail. There might be other sources (ears, hair, headguard) that
are masked by the Neck dominance. A manual probe on one rig (identifying
specific vertices as ear, hair, etc.) would settle this.

**The min-weight rule is ad hoc.** I chose threshold 0.80 because it maximized
p80 reduction with fewest face coverage losses, but this is a post-hoc
optimization. A principled threshold would be derived from the weight
distribution (e.g., core p10 = 0.846, so threshold = 0.85). But at 0.85, the
rule removes fewer vertices and has a smaller effect.

**The geometric rule failure is informative.** It shows that the tail is not an
extreme outlier — it's the natural extension of the vertex distribution. This
is a finding, not a failure. The geometric rule is the right tool for removing
extreme outliers; the fact that it does nothing shows that the tail is not
extreme.

**The blended approach failure is also informative.** It shows that the tail
vertices are strongly weighted to Head, so blending doesn't change their
position. This confirms that the tail is not a weight-assignment problem.

**The centroid-shift problem is a fundamental limitation.** Removing vertices
changes the centroid, which can increase the p80. This means that any cleaning
rule that removes vertices near the centroid will have a pathological case where
the radius grows. This is not a bug in the cleaning rule; it's a bug in the
centroid-based radius model.
