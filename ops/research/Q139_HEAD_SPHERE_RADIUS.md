# Q139 — HOW FAT IS OUR HEAD, REALLY? THE SPHERE RADIUS, MEASURED FOUR WAYS

**Tool:** `Godot/tools/q139_head_sphere.gd`
**Date:** 2026-09-22
**Owner:** qwen

## THE QUESTION

S53 promoted the head to a sphere. The radius ships as `mode: "blob"` — the p80
of every Head-weighted skin vertex's distance to its own centroid. On f01 that
is 0.1256 m; on f02, 0.1333 m. J42's ANSUR II anthropometry puts an honest head
sphere at half Head Length 0.0998 m or half Head Breadth 0.0772 m. **Ours is 28 %
to 66 % larger than either.** Is the radius honest?

## RAW OUTPUT

```
Q139 HEAD SPHERE RADIUS - four ways on twelve rigs
  population: 12 rigs from CaptureFighterRoster.ROSTER
  J42 reference: half Head Length = 0.0998 m, half Head Breadth = 0.0772 m
  ANSUR II male mean stature = 1.755 m (scaling assumption)
  axes: sagittal/lateral from shoulder line via _forward_axis, vertical = Y
  percentiles: over head-weighted skin vertex distances to centroid
  all values in rig's own metres (after height_scale)
  bone_global_rest used (rest pose, not animated pose)

== POPULATION ==
  f01_m_box_welter          1.75 m
  f02_m_box_heavy           1.93 m
  f03_f_box_fly             1.58 m
  f04_f_box_middle          1.74 m
  f05_m_mma_light           1.78 m
  f06_m_mma_lhw             1.89 m
  f07_f_mma_straw           1.59 m
  f08_f_mma_bantam          1.65 m
  f09_m_bare_welter         1.81 m
  f10_m_bare_heavy          1.93 m
  f11_f_bare_feather        1.68 m
  f12_f_bare_welter         1.69 m

== HEAD MEASUREMENTS ==
  rig                      stature n_vert     p50     p80     p95     max  halflen  halfbre halfvert j42_len j42_bre p80/jL  hL/jL  hB/jB  axis_source
  f01_m_box_welter            1.75    834  0.1117  0.1256  0.1387  0.1535   0.1300   0.0921   0.1330  0.0993  0.0768  1.264  1.309  1.198  shoulders
  f02_m_box_heavy             1.93    723  0.1102  0.1333  0.1481  0.1559   0.1379   0.1016   0.1389  0.1098  0.0849  1.215  1.257  1.196  shoulders
  f03_f_box_fly               1.58    973  0.0975  0.1158  0.1397  0.1582   0.1304   0.0808   0.1261  0.0897  0.0694  1.290  1.453  1.164  shoulders
  f04_f_box_middle            1.74   1614  0.1147  0.1558  0.1782  0.2276   0.1466   0.0903   0.1680  0.0989  0.0765  1.576  1.483  1.180  shoulders
  f05_m_mma_light             1.78   1707  0.1186  0.1274  0.1519  0.1727   0.1381   0.1117   0.1466  0.1013  0.0784  1.258  1.363  1.424  shoulders
  f06_m_mma_lhw               1.89    793  0.1215  0.1368  0.1469  0.1645   0.1468   0.1097   0.1453  0.1075  0.0831  1.273  1.366  1.320  shoulders
  f07_f_mma_straw             1.59   1400  0.1182  0.1459  0.1728  0.2425   0.1511   0.0871   0.1613  0.0905  0.0700  1.612  1.670  1.245  shoulders
  f08_f_mma_bantam           1.65   1449  0.1180  0.1381  0.1555  0.1863   0.1425   0.0938   0.1423  0.0939  0.0726  1.471  1.518  1.292  shoulders
  f09_m_bare_welter            1.81    987  0.1165  0.1285  0.1428  0.1601   0.1304   0.1035   0.1362  0.1032  0.0798  1.245  1.264  1.297  shoulders
  f10_m_bare_heavy            1.93    716  0.1179  0.1350  0.1457  0.1534   0.1416   0.1071   0.1402  0.1098  0.0849  1.230  1.290  1.261  shoulders
  f11_f_bare_feather          1.68   1018  0.1045  0.1281  0.1566  0.1737   0.1448   0.0903   0.1379  0.0955  0.0738  1.342  1.517  1.222  shoulders
  f12_f_bare_welter           1.69   1465  0.1170  0.1409  0.1639  0.1811   0.1451   0.0927   0.1349  0.0959  0.0742  1.469  1.513  1.249  shoulders

== AXIS SOURCE SUMMARY ==
  shoulders                                 12 rig(s)

== ROLLUP: RATIO TO J42 (scaled) ==
  p80/j42_len           median=1.281  spread=[1.215, 1.612]  n=12
  halflen/j42_len       median=1.409  spread=[1.257, 1.670]  n=12
  halfbre/j42_bre       median=1.247  spread=[1.164, 1.424]  n=12

SUITE total=1 fails=0
```

## FOUR ANSWERS

### 1. Which of p80, halflen, halfbre is closest to J42?

**None is close, but halfbre is the least wrong.**

| basis | median ratio to J42 | spread | interpretation |
|---|---|---|---|
| p80 / half Head Length | 1.281 | [1.215, 1.612] | 28 % too large, median |
| halflen / half Head Length | 1.409 | [1.257, 1.670] | 41 % too large |
| halfbre / half Head Breadth | 1.247 | [1.164, 1.424] | 25 % too large, tightest |

The p80 is 28 % larger than J42's half Head Length on the median rig, and 61 %
larger on f07 (the worst). Half-breath is the closest match to its own J42
referent, at 25 % above on the median, but 25 % above a skull measurement is
still 25 % of phantom skull.

### 2. Is the p80 inflated by a long tail?

**Yes, on every rig.** The gap between p50 and max tells the story:

| rig | p50 | p80 | max | max − p80 |
|---|---|---|---|---|
| f01 | 0.1117 | 0.1256 | 0.1535 | 0.028 m |
| f04 | 0.1147 | 0.1558 | 0.2276 | **0.072 m** |
| f07 | 0.1182 | 0.1459 | 0.2425 | **0.097 m** |
| f10 | 0.1179 | 0.1350 | 0.1534 | 0.018 m |

On f07 (strawweight female, 1400 head verts) the farthest vertex is 97 mm past
the p80 — nearly 10 cm of something the centroid-to-vertex sphere has to
envelope. On f04 (middleweight female, 1614 verts) it is 72 mm. On f10
(bare-knuckle heavyweight) only 18 mm — the tightest tail in the population,
and still 18 mm of phantom.

**What is out there: NOT DETERMINABLE from vertex positions alone.** The mesh
carries no per-vertex semantic labels (hair vs scalp vs ear vs headguard). The
long tail is consistent with hair, ears, or a headguard mesh extension, but
separating those requires either a labelled vertex map from the generator or a
manual probe on one rig. The p50 is remarkably stable across rigs (0.0975 –
0.1215 m, CV ≈ 7 %) while the max swings from 0.153 to 0.243 m — the core
skull is consistent, the outliers are not.

### 3. Is the head's shape close to a sphere?

**No. The head is an ellipsoid with three measurably unequal semi-axes on every
rig.**

| rig | halflen | halfbre | halfvert | ratio max/min |
|---|---|---|---|---|
| f01 | 0.1300 | 0.0921 | 0.1330 | 1.44 |
| f02 | 0.1379 | 0.1016 | 0.1389 | 1.37 |
| f03 | 0.1304 | 0.0808 | 0.1261 | 1.62 |
| f04 | 0.1466 | 0.0903 | 0.1680 | **1.86** |
| f05 | 0.1381 | 0.1117 | 0.1466 | 1.31 |
| f06 | 0.1468 | 0.1097 | 0.1453 | 1.34 |
| f07 | 0.1511 | 0.0871 | 0.1613 | **1.85** |
| f08 | 0.1425 | 0.0938 | 0.1423 | 1.52 |
| f09 | 0.1304 | 0.1035 | 0.1362 | 1.32 |
| f10 | 0.1416 | 0.1071 | 0.1402 | 1.32 |
| f11 | 0.1448 | 0.0903 | 0.1379 | 1.60 |
| f12 | 0.1451 | 0.0927 | 0.1349 | 1.56 |

On every rig, **halfbre is the shortest axis** — the head is narrower
temple-to-temple than it is long (forehead-to-occiput) or tall (vertex-to-
chin). The max/min ratio ranges from 1.31 (f05) to 1.86 (f04). A sphere would
be 1.00. Even the most spherical rig (f05, MMA light) is 31 % off.

**This is an argument against the sphere S53 shipped.** J42 said a head is an
ellipsoid with three unequal semi-axes; the mesh confirms it on all twelve
rigs. A single radius cannot capture a shape whose axes differ by 30–86 %.

### 4. Recommendation

**Do not change the radius derivation until the vertex set is cleaned.** The p80
is 28 % above J42 on the median rig, but the halfbre is 25 % above on its own
axis — both are inflated by the same vertex set that includes hair, ears and
whatever the generator put on the skull. Changing the percentile (say from p80
to p50) would reduce the radius by ~10 % but would not fix the underlying
problem: the vertex set is not the cranial vault, it is the head surface. The
right fix is to **filter the vertex set to cranial-vault-only vertices** (or to
derive the radius from a bone-measurement pipeline rather than skin vertices at
all), and THEN choose the percentile. Doing it the other way around — picking a
percentile first — tunes a number that measures the wrong thing.

## SELF-CRITIQUE: WHY THIS MEASUREMENT MAY SETTLE NOTHING

The strongest case against taking this table at face value:

**A Tripo mesh generator's idea of a "head" has no anthropometric meaning
whatsoever.** ANSUR measures living humans with calipers on named landmarks —
glabella, opisthocranion, euryon. The mesh vertices are whatever the generator
decided was "head" when it wrapped a surface around a skeleton. There is no
guarantee that the vertex labelled "Head" by the skin-weight mapping corresponds
to the cranial vault ANSUR measures. It might include the face, the neck base,
the ears, the hair, or a headguard. It might exclude the occiput. The generator
has no concept of "head length" or "head breadth" — it has a vertex cloud and a
weight map, and the shape that emerges is an artifact of the generation process,
not a measurement.

**Comparing p80 of vertex distance to ANSUR caliper distance is comparing a
sculpture to a person.** The sculpture might be 28 % larger because the
generator added hair, or because it models the skull differently, or because
the weight map bleeds into the neck. None of those is a "head radius" in the
anthropometric sense, and none of them is wrong — they are just different
things. The table measures what the mesh IS, not what a head IS.

**What would settle it:**
1. **Landmark probe:** identify 3–5 named vertices on one rig (top of skull,
   forehead, occiput, left temple, right temple) and measure the distances
   between them. If those match ANSUR within 10 %, the mesh IS a head and the
   radius problem is real. If they do not, the mesh is a sculpture and the
   radius problem is a category error.
2. **Generator documentation:** what does Tripo put in the Head weight bucket?
   Does it include hair? Ears? The task says NOT DETERMINABLE from vertex
   positions alone — the generator's own docs would settle it in one line.
3. **A/B with a known-good mesh:** import a scan or CAD model with known
   cranial dimensions and run the same tool. If it also reads 28 % high, the
   measurement pipeline is biased; if it reads within 5 %, the Tripo meshes
   are the problem.

Until one of those lands, this table is a measurement of what the mesh
generator produced, not of what a human head is. The numbers are real; the
comparison to ANSUR is not.
