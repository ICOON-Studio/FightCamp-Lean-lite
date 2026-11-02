# Q134 DIGEST — THE DEPTH QUESTION, ASKED OF A LIMB FOR THE FIRST TIME

**Agent:** qwen. **Branch:** `qwen/q134-limb-depth`. **Date:** 2026-09-22.

## The question

S48 derived the thorax radius from chest DEPTH instead of the isotropic p80 and
it worked. S48 tried the same on the pelvis and the corpus went 3/13 → 1/13,
with nearly every new worst pair a LEG pair. Nobody had ever asked the depth
question of a limb. Q134 asks it.

## What was built

Extended `Godot/tools/s48_thorax_depth.gd` to take the capsule list as a
`CAPSULE_ROWS` constant at the top of the file (8 rows: thorax, pelvis, plus
femur_l/r, shin_l/r, upper_arm_r, forearm_r). The derivation itself is
unchanged — same shoulder-line lateral, same segment up, same cross-product
forward. Added `breadth - depth` as a printed metric per capsule.

## The raw numbers

### Trunk (S48 confirmed)

| Capsule | Rig | iso p80 | depth p80 | breadth p80 | breadth−depth | seg len |
|---------|-----|---------|-----------|-------------|---------------|---------|
| thorax  | f01 | 0.1607  | 0.1231    | 0.1502      | **+0.0271**   | 0.2824  |
| thorax  | f02 | 0.1909  | 0.1418    | 0.1803      | **+0.0385**   | 0.3054  |
| pelvis  | f01 | 0.1703  | 0.1157    | 0.1527      | **+0.0370**   | 0.2195  |
| pelvis  | f02 | 0.1946  | 0.1402    | 0.1752      | **+0.0350**   | 0.2361  |

Trunk is **wider than deep** (breadth > depth by 3–4 cm). Positive
breadth−depth. The S48 derivation is correct in direction.

### Legs (Q134 new data)

| Capsule | Rig | iso p80 | depth p80 | breadth p80 | breadth−depth | seg len |
|---------|-----|---------|-----------|-------------|---------------|---------|
| femur_l | f01 | 0.1187  | 0.1084    | 0.0868      | **−0.0217**   | 0.4249  |
| femur_l | f02 | 0.1400  | 0.1287    | 0.0975      | **−0.0312**   | 0.4636  |
| femur_r | f01 | 0.1179  | 0.1058    | 0.0862      | **−0.0197**   | 0.4251  |
| femur_r | f02 | 0.1423  | 0.1286    | 0.1017      | **−0.0269**   | 0.4636  |
| shin_l  | f01 | 0.0787  | 0.0687    | 0.0484      | **−0.0203**   | 0.4150  |
| shin_l  | f02 | 0.0911  | 0.0799    | 0.0553      | **−0.0246**   | 0.4224  |
| shin_r  | f01 | 0.0807  | 0.0688    | 0.0486      | **−0.0202**   | 0.4150  |
| shin_r  | f02 | 0.0899  | 0.0779    | 0.0566      | **−0.0213**   | 0.4202  |

Legs are **deeper than wide** (depth > breadth by 2–3 cm). Negative
breadth−depth. The oval is oriented the OPPOSITE way from the trunk: the long
axis of a thigh's cross-section runs front-to-back (quadriceps/hamstrings), not
side-to-side.

### Arms (Q134 new data — axis suspect)

| Capsule     | Rig | iso p80 | depth p80 | breadth p80 | breadth−depth | seg len |
|-------------|-----|---------|-----------|-------------|---------------|---------|
| upper_arm_r | f01 | 0.0702  | 0.0556    | 0.0036      | **−0.0520**   | 0.2508  |
| upper_arm_r | f02 | 0.0878  | 0.0799    | 0.0077      | **−0.0721**   | 0.2425  |
| forearm_r   | f01 | 0.0574  | 0.0416    | 0.0163      | **−0.0253**   | 0.2340  |
| forearm_r   | f02 | 0.0696  | 0.0541    | 0.0133      | **−0.0408**   | 0.2940  |

The arm breadth values are implausibly small (3.6 mm for an upper arm on f01).
The shoulder-derived lateral axis is not the right axis for arm cross-sections.
The upper_arm_r forward axis differs wildly between rigs: f01
(−0.005, 0.894, 0.447) vs f02 (0.009, 0.000, 1.000) — a 0.89 difference in Y.
The forearm_r forward axis is more stable: f01 (0.003, 0.958, −0.287) vs f02
(−0.002, 0.976, −0.217). The arm numbers are reported but should not drive
design decisions without a limb-specific axis derivation.

## Forward axis stability between rigs

**Legs: excellent.** The forward axes match between rigs to within 0.02 on every
component:
- femur: ≈ (0.0, −0.06, 0.998) on both rigs
- shin: ≈ (0.0, −0.15, 0.989) on both rigs

The shoulder-derived lateral transfers cleanly to legs.

**Arms: poor.** The upper_arm forward differs by 0.89 in Y between rigs. The
shoulder-derived lateral does not transfer cleanly to arms — the arm's own rest
pose dominates the cross product, and the two rigs have different arm rest
poses.

## The one-line answer

**Limbs are NOT round.** They are meaningfully anisotropic (2–3 cm of
breadth−depth on legs, consistent between rigs), but the anisotropy is in the
OPPOSITE direction from the trunk: limbs are deeper front-to-back than they are
wide side-to-side, while the trunk is wider side-to-side than it is deep
front-to-back. A depth-derived capsule on a limb would shrink it (depth <
isotropic), and the shrinkage is comparable in magnitude to the trunk's (1–3 cm
on legs vs 4–5 cm on trunk). The leg collisions from S48's pelvis attempt are
NOT caused by over-wide limb capsules — the limbs' isotropic radii are already
larger than their depth radii, so the limbs are not the ones claiming excess
lateral space. The fix for the leg collisions is the authored stances, not the
limb capsule radii.

## What this means for S49

1. **Depth derivation on limbs is anatomically valid** — the axis is stable,
   the anisotropy is real, and the direction (depth > breadth) makes anatomical
   sense (quadriceps/hamstrings vs medial/lateral).
2. **But it would shrink limbs, not grow them** — a depth-derived femur on f02
   goes from 0.1423 → 0.1286 m (10% reduction). This would reduce the
   medial-to-lateral extent of the leg capsules, which is the direction that
   causes leg-leg collisions.
3. **The trunk and limbs are one fix** — narrowing the trunk (S48's thorax
   derivation) brings bodies closer together; narrowing the limbs (depth
   derivation) makes the legs thinner side-to-side. Both work in the same
   direction for the leg collision problem.
4. **The arm axis needs its own derivation** — the shoulder lateral does not
   transfer to arms. If arm capsules need depth treatment, the axis must come
   from the arm's own geometry, not the shoulder line.

## Files changed

- `Godot/tools/s48_thorax_depth.gd` — added `CAPSULE_ROWS` constant, 6 limb
  rows, breadth−depth print, updated header.
- `research/Q134_DIGEST.md` — this file.

## Gate

```
check_scripts.py: total=1 fails=0
probe:            fails=0
run_tests.py --only capsule: total=2 fails=0
```
