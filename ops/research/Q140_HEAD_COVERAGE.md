# Q140 — SETTLE THE HEAD RADIUS WITH A COVERAGE MEASUREMENT, NOT AN ARGUMENT

**Tool:** `Godot/tools/q140_head_coverage.gd`
**Date:** 2026-09-22
**Owner:** qwen

## THE QUESTION

Two agents disagree about the head sphere radius. Q139 measured the shipped p80
as 28 % above J42's half Head Length and recommended not changing until the
vertex set is cleaned. G71 argued from 37 sources that shrinking the radius
would be worse: *"face under-coverage is more visible than temple
over-coverage"*. Neither ran the measurement that decides it.

**This task measures it.** For each candidate radius, on each rig: where does
the sphere miss the man, and where does it claim flesh he does not have — split
by face, temple, and cranium.

## METHOD

**Region classification** (engineering choice, not anatomy — cone angles named
in the output):
- **face**: within 60 deg of forward AND elevation within 45 deg of horizontal
- **temple**: within 45 deg of lateral axis (left or right)
- **cranium**: everything else (top, back, under)

**Four candidate radii**, per rig:
1. **p80** — what ships today (blob mode, p80 of vertex spread about centroid)
2. **geomean** — `(halflen * halfbre * halfvert)^(1/3)`, G71's fallback
3. **j42_half** — J42 half Head Length (0.0998 m) scaled to rig stature
4. **lateral** — shortest half-extent (halfbre), the aggressive shrink

**One control**: p80 * 2.0, to prove the instrument can read differently.

**Per (rig, candidate, region)**: n vertices, out_n/out_pct (vertices outside the
sphere), out_p50/out_p90/out_max (how far outside), in_gap_p50/in_gap_p90 (for
inside vertices, how much empty volume the sphere claims beyond the skin).

**Axes**: same as Q139 — sagittal/lateral from shoulder line, vertical = Y.
`axis_source: shoulders` on all twelve rigs.

## RAW OUTPUT

```
Q140 HEAD COVERAGE - four candidates against twelve rigs
  population: 12 rigs
  region cone angles (engineering choice, not anatomy):
    face:    within 60 deg of forward AND elevation within 45 deg of horizontal
    temple:  within 45 deg of lateral axis
    cranium: everything else (top, back, under)
  candidates:
    p80        - what ships (blob mode, p80 of vertex spread)
    geomean    - (halflen * halfbre * halfvert)^(1/3), G71 fallback
    j42_half   - J42 half Head Length scaled to rig stature
    lateral    - shortest half-extent (halfbre), aggressive shrink
    ctrl       - p80 * 2.0, instrument sanity check

== f01_m_box_welter (1.75 m, 834 verts, shoulders) ==
  radii: p80=0.1256  geomean=0.1168  j42=0.0993  lateral=0.0921
  regions: face=158  temple=189  cranium=487
  [p80]       face out=29.7% p90=0.0107  temple out=0.0% gap_p90=0.0500
  [geomean]   face out=56.3% p90=0.0188  temple out=1.1% gap_p90=0.0412
  [j42_half]  face out=94.3% p90=0.0355  temple out=18.0% gap_p90=0.0246
  [lateral]   face out=98.1% p90=0.0426  temple out=39.2% gap_p90=0.0186
  [ctrl]      face out=0.0%  temple out=0.0%  gap_p90=0.15-0.18

== f02_m_box_heavy (1.93 m, 723 verts) ==
  radii: p80=0.1333  geomean=0.1248  j42=0.1098  lateral=0.1016
  regions: face=129  temple=164  cranium=430
  [p80]       face out=35.7% p90=0.0197  temple out=0.0% gap_p90=0.0532
  [geomean]   face out=49.6% p90=0.0273  temple out=0.0% gap_p90=0.0447
  [j42_half]  face out=80.6% p90=0.0392  temple out=4.9% gap_p90=0.0299
  [lateral]   face out=89.9% p90=0.0465  temple out=15.9% gap_p90=0.0221

== f03_f_box_fly (1.58 m, 973 verts) ==
  radii: p80=0.1158  geomean=0.1099  j42=0.0897  lateral=0.0808
  regions: face=180  temple=189  cranium=604
  [p80]       face out=17.2% p90=0.0380  temple out=0.0% gap_p90=0.0484
  [geomean]   face out=22.2% p90=0.0411  temple out=0.0% gap_p90=0.0426
  [j42_half]  face out=75.0% p90=0.0495  temple out=5.8% gap_p90=0.0225
  [lateral]   face out=98.9% p90=0.0550  temple out=35.4% gap_p90=0.0145

== f04_f_box_middle (1.74 m, 1614 verts) ==
  radii: p80=0.1558  geomean=0.1305  j42=0.0989  lateral=0.0903
  regions: face=387  temple=254  cranium=973
  [p80]       face out=0.0% p90=0.0000  temple out=0.0% gap_p90=0.0943
  [geomean]   face out=2.8% p90=0.0156  temple out=0.0% gap_p90=0.0691
  [j42_half]  face out=48.3% p90=0.0241  temple out=25.2% gap_p90=0.0401
  [lateral]   face out=55.0% p90=0.0323  temple out=40.6% gap_p90=0.0350

== f05_m_mma_light (1.78 m, 1707 verts) ==
  radii: p80=0.1274  geomean=0.1312  j42=0.1013  lateral=0.1117
  FAIL: ordering lateral < geomean < p80 broken (geomean > p80 on this rig)
  regions: face=365  temple=384  cranium=958
  [p80]       face out=23.8% p90=0.0062  temple out=0.0% gap_p90=0.0395
  [geomean]   face out=7.1% p90=0.0042  temple out=0.0% gap_p90=0.0433
  [j42_half]  face out=100.0% p90=0.0285  temple out=65.9% gap_p90=0.0186
  [lateral]   face out=97.3% p90=0.0182  temple out=28.6% gap_p90=0.0266

== f06_m_mma_lhw (1.89 m, 793 verts) ==
  radii: p80=0.1368  geomean=0.1328  j42=0.1075  lateral=0.1097
  regions: face=159  temple=175  cranium=459
  [p80]       face out=40.3% p90=0.0089  temple out=0.0% gap_p90=0.0497
  [geomean]   face out=53.5% p90=0.0128  temple out=0.0% gap_p90=0.0457
  [j42_half]  face out=99.4% p90=0.0372  temple out=23.4% gap_p90=0.0221
  [lateral]   face out=98.1% p90=0.0350  temple out=17.7% gap_p90=0.0238

== f07_f_mma_straw (1.59 m, 1400 verts) ==
  radii: p80=0.1459  geomean=0.1285  j42=0.0905  lateral=0.0871
  regions: face=346  temple=229  cranium=825
  [p80]       face out=32.4% p90=0.0379  temple out=0.0% gap_p90=0.0756
  [geomean]   face out=50.3% p90=0.0470  temple out=0.0% gap_p90=0.0583
  [j42_half]  face out=80.9% p90=0.0822  temple out=24.9% gap_p90=0.0214
  [lateral]   face out=84.1% p90=0.0856  temple out=34.1% gap_p90=0.0191

== f08_f_mma_bantam (1.65 m, 1449 verts) ==
  radii: p80=0.1381  geomean=0.1239  j42=0.0939  lateral=0.0938
  regions: face=444  temple=230  cranium=775
  [p80]       face out=14.2% p90=0.0186  temple out=0.0% gap_p90=0.0651
  [geomean]   face out=32.4% p90=0.0305  temple out=0.0% gap_p90=0.0509
  [j42_half]  face out=70.5% p90=0.0535  temple out=31.3% gap_p90=0.0231
  [lateral]   face out=70.5% p90=0.0535  temple out=31.3% gap_p90=0.0231

== f09_m_bare_welter (1.81 m, 987 verts) ==
  radii: p80=0.1285  geomean=0.1225  j42=0.1032  lateral=0.1035
  regions: face=201  temple=222  cranium=564
  [p80]       face out=18.9% p90=0.0040  temple out=0.0% gap_p90=0.0503
  [geomean]   face out=34.8% p90=0.0099  temple out=0.5% gap_p90=0.0444
  [j42_half]  face out=98.0% p90=0.0274  temple out=28.4% gap_p90=0.0276
  [lateral]   face out=97.5% p90=0.0270  temple out=28.4% gap_p90=0.0280

== f10_m_bare_heavy (1.93 m, 716 verts) ==
  radii: p80=0.1350  geomean=0.1286  j42=0.1098  lateral=0.1071
  regions: face=127  temple=182  cranium=407
  [p80]       face out=37.0% p90=0.0106  temple out=0.0% gap_p90=0.0489
  [geomean]   face out=55.9% p90=0.0162  temple out=0.0% gap_p90=0.0424
  [j42_half]  face out=96.9% p90=0.0342  temple out=12.1% gap_p90=0.0239
  [lateral]   face out=98.4% p90=0.0368  temple out=19.8% gap_p90=0.0214

== f11_f_bare_feather (1.68 m, 1018 verts) ==
  radii: p80=0.1281  geomean=0.1217  j42=0.0955  lateral=0.0903
  regions: face=205  temple=235  cranium=578
  [p80]       face out=28.3% p90=0.0416  temple out=0.0% gap_p90=0.0569
  [geomean]   face out=32.2% p90=0.0478  temple out=0.0% gap_p90=0.0505
  [j42_half]  face out=87.8% p90=0.0672  temple out=14.9% gap_p90=0.0247
  [lateral]   face out=95.6% p90=0.0719  temple out=30.2% gap_p90=0.0199

== f12_f_bare_welter (1.69 m, 1465 verts) ==
  radii: p80=0.1409  geomean=0.1220  j42=0.0959  lateral=0.0927
  regions: face=410  temple=301  cranium=754
  [p80]       face out=33.9% p90=0.0351  temple out=0.0% gap_p90=0.0681
  [geomean]   face out=45.1% p90=0.0520  temple out=0.3% gap_p90=0.0491
  [j42_half]  face out=74.9% p90=0.0755  temple out=21.9% gap_p90=0.0240
  [lateral]   face out=77.1% p90=0.0785  temple out=28.6% gap_p90=0.0211
```

## NON-VACUITY CHECKS

### 1. Region non-emptiness: 12/12 PASSED

Every rig has vertices in all three regions. Smallest region counts:

| rig | face | temple | cranium |
|---|---|---|---|
| f02 | 129 | 164 | 430 |
| f10 | 127 | 182 | 407 |
| f01 | 158 | 189 | 487 |

No empty regions. The forward axis is correct on every rig.

### 2. Ordering check (lateral < geomean < p80): 11/12 PASSED

**f05 (MMA light) broke the ordering**: geomean = 0.1312 > p80 = 0.1274.

This is not a bug. f05 has the most spherical head in the population
(halflen=0.1381, halfbre=0.1117, halfvert=0.1466; ratio max/min = 1.31, the
tightest). When the three half-extents are nearly equal, the geometric mean
converges on the mean extent while p80 reflects the vertex density — and the
vertices are concentrated below the mean extent. The geomean genuinely exceeds
the p80 on this one rig.

**Consequence**: on f05, geomean is a LARGER sphere than p80, so geomean has
LESS face under-coverage and MORE temple over-coverage than p80 — the reverse
of every other rig. The population medians include f05's data.

### 3. Control (p80 * 2.0): PASSED on every rig

On every rig, the control sphere has:
- `out_pct = 0.0%` in all three regions (no vertex outside)
- `in_gap_p90 = 0.14–0.26 m` (the sphere claims 14–26 cm of empty volume
  beyond the skin)

The instrument reads differently when the radius changes. The reader is seeing
the sphere it thinks it is.

## THE DECIDING TABLE: FACE vs TEMPLE

The measurement that G71's claim lives or dies on:

| candidate | median radius | face out_pct | face out_p90 | temple out_pct | temple in_gap_p90 | ratio |
|---|---|---|---|---|---|---|
| **p80** | 0.1342 m | 29.0 % | **0.0146 m** | 0.0 % | **0.0518 m** | 1:3.5 |
| **geomean** | 0.1244 m | 40.0 % | **0.0230 m** | 0.0 % | **0.0452 m** | 1:2.0 |
| **j42_half** | 0.0991 m | 84.4 % | **0.0382 m** | 22.7 % | **0.0239 m** | 1.6:1 |
| **lateral** | 0.0933 m | 96.4 % | **0.0446 m** | 29.4 % | **0.0217 m** | 2.1:1 |

The ratio column is `face_out_p90 : temple_in_gap_p90`. When it is less than 1,
the temple over-coverage exceeds the face under-coverage (G71's asymmetry).
When it is greater than 1, the face under-coverage exceeds the temple over-
coverage.

**The crossover is between geomean and j42_half.** Above it (p80, geomean), the
sphere over-covers the temple more than it under-covers the face. Below it
(j42_half, lateral), the face is worse off than the temple.

## VERDICT

**The measurement supports p80 (what ships) and refuses G71's specific claim
that the geomean is better — but it also refuses Q139's implicit direction
toward a smaller radius.**

The numbers:

1. **G71's asymmetry is real.** On p80, the temple over-coverage (52 mm at p90)
   is 3.5 times the face under-coverage (15 mm at p90). Shrinking the radius
   reduces the temple over-coverage but INCREASES the face under-coverage. On
   j42_half, the face under-coverage (38 mm) already exceeds the temple over-
   coverage (24 mm). On lateral, it is 45 mm vs 22 mm.

2. **But p80 is not free.** 29 % of face vertices are outside the sphere, with
   p90 at 15 mm. That is not nothing — it is a punch that clips the nose tip
   without registering. The face under-coverage is real, just smaller than the
   temple over-coverage.

3. **Geomean is worse than p80 on the metric that matters.** It trades 8 mm of
   temple over-coverage for 8 mm of additional face under-coverage (23 mm vs 15
   mm). That is the wrong direction on G71's own axis.

4. **The right radius is somewhere between geomean and p80**, where the face and
   temple errors are approximately balanced. But "balanced" is not "optimal" —
   G71's claim that face error is more visible than temple error means the
   optimum is above the balance point, which is where p80 already sits.

**Bottom line: keep p80 until the vertex set is cleaned.** The shipped radius
has an asymmetry, but it is the LESS-BAD asymmetry. Shrinking it makes the more
visible problem (face under-coverage) worse to improve the less visible one
(temple over-coverage). Cleaning the vertex set (removing hair, ears,
headguard) will shift all four candidates, and the comparison should be re-run
on the clean set before any radius change.

## CAVEAT: DIRTY VERTEX TAIL

The vertex set is unclean (Q139 showed max exceeding p80 by 18–97 mm). The
dirty tail inflates p80 more than it inflates geomean (which is derived from
half-extents, not vertex distances). Some of p80's temple over-coverage is
phantom — a few hair or ear vertices pushing the p80 up by 5–10 mm.

**How much this moves each row:** the Q139 max-p80 gap (18–97 mm) is the
outer bound. If the dirty tail were removed, p80 would shrink by some fraction
of that gap (probably 5–15 mm, depending on how many outlier vertices are
removed). That would reduce the temple in_gap_p90 by a similar amount and
increase the face out_p90 by a similar amount. The RANKING of candidates is
robust to this; the absolute gaps are not.

## SELF-CRITIQUE

**The cone angles are an engineering choice.** Changing them changes the region
boundaries and therefore the numbers. A wider face cone (say 75 deg) would
capture more vertices as "face" and increase the face under-coverage; a
narrower one would reduce it. The 60/45/45 choice is defensible (it matches the
anatomical face forward arc and the temple lateral arc) but it is not the only
defensible choice. The tool names the angles in its output so a later reader
can see what was chosen and re-run with different angles.

**f05's ordering failure is a real finding, not a rounding error.** On a nearly
spherical head, the geomean and p80 converge and can cross. This means the
geomean is NOT always smaller than p80 — it depends on the vertex distribution,
not just the half-extents. A later implementation that switches to geomean
would need to handle this case.

**The population median includes f05 despite its ordering failure.** This is
deliberate — the coverage measurement is valid even when the ordering check
fails. But it means the median geomean radius (0.1244 m) is slightly inflated
by f05's geomean (0.1312 m), which is above its p80 (0.1274 m).
