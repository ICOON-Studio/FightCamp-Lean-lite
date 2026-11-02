# C98 fighter skinning measurements

All values below are `MEASURED` by `python Godot/tools/audit_fighter_skinning.py`.
Ratios are dimensionless; shares are fractions of vertices. The neighborhood
sample is the radius specified by C98.

| Fighter | Arm/H | Leg/H | Forearm/upper | Shin/thigh | Shoulder/H | Hip/H |
|---|---:|---:|---:|---:|---:|---:|
| f01 m box welter | .2724 | .4719 | .9332 | .9768 | .2109 | .1016 |
| f02 m box heavy | .2864 | .4713 | 1.2194 | .9111 | .2400 | .1121 |
| f03 f box fly | .2710 | .4780 | 1.0390 | .9375 | .1875 | .1094 |
| f04 f box middle | .2796 | .4865 | 1.0345 | .8814 | .2031 | .1211 |
| f05 m mma light | .2802 | .4655 | 1.1686 | .9726 | .2109 | .1094 |
| f06 m mma lhw | .2814 | .4772 | 1.2371 | .9413 | .2461 | .1173 |
| f07 f mma straw | .2800 | .4976 | .9829 | .9497 | .1957 | .1253 |
| f08 f mma bantam | .2844 | .4808 | 1.0190 | .9425 | .1953 | .1250 |
| f09 m bare welter | .2783 | .4677 | .9778 | .9539 | .2188 | .1094 |
| f10 m bare heavy | .2906 | .4678 | 1.0348 | .9434 | .2595 | .1297 |
| f11 f bare feather | .2829 | .4242 | .8445 | .9318 | .2115 | .1254 |
| f12 f bare welter | .2982 | .4355 | .9541 | .8828 | .1875 | .1094 |
| Roster min | .2710 | .4242 | .8445 | .8814 | .1875 | .1016 |
| Roster max | .2982 | .4976 | 1.2371 | .9768 | .2595 | .1297 |
| Spread | .0271 | .0734 | .3926 | .0955 | .0720 | .0281 |

`MEASURED`: every fighter has 22 skin joints and `weight_sum_bad=0.000000`.
All reported shares are within [0, 1]. Shoulder and hip neighborhoods are
non-empty. Raw POSITION-y heights are 1.85 m (f01, f02, f05, f09, f10),
1.75 m (f03, f04, f07, f11, f12), and 1.00 m (f06, f08). `MEASURED`: f06 and
f08 therefore fall outside the requested 1.4--2.2 sanity band. `MEASURED`:
their root mesh/skin nodes have no scale field, so this is a POSITION-unit or
asset-scale discrepancy, not a node scale that this audit can apply.

## Pooled joint neighborhoods

Pooled shares are vertex-count weighted across the twelve fighters. `Worst`
names the fighter with the largest value for each corresponding share.

| Joint | pooled n | Rigid | Multi (>=3) | Bleed | Worst rigid / multi / bleed |
|---|---:|---:|---:|---:|---|
| LeftUpperArm (shoulder) | 2,122 | .0000 | .5603 | .0617 | f01 / f09 / f12 |
| RightUpperArm (shoulder) | 2,250 | .0009 | .6693 | .1133 | f11 / f08 / f12 |
| LeftLowerArm (elbow) | 2,173 | .2319 | .0267 | .0000 | f12 / f06 / tie |
| RightLowerArm (elbow) | 2,154 | .1300 | .0385 | .0000 | f11 / f06 / tie |
| LeftUpperLeg (hip) | 7,603 | .2100 | .1129 | .0184 | f05 / f12 / f12 |
| RightUpperLeg (hip) | 7,774 | .2140 | .1217 | .0297 | f09 / f12 / f11 |
| LeftLowerLeg (knee) | 4,862 | .3826 | .0010 | .0039 | f09 / f01 / f12 |
| RightLowerLeg (knee) | 4,864 | .3209 | .0006 | .0103 | f01 / f10 / f12 |

## WHAT THIS SAYS ABOUT THE TWO CAUSES

`MEASURED`: rigid binding is not concentrated at shoulders: pooled shoulder
rigid shares are 0.0000 and 0.0009. It is present at hips (0.2100 and 0.2140)
and is higher at elbows/knees, especially knees (0.3209--0.3826).

`MEASURED`: bleed is concentrated more at shoulders and hips than at elbows
or knees: shoulder pooled bleed is 0.0617--0.1133, hip is 0.0184--0.0297,
elbow is 0, and knee is 0.0039--0.0103. `INFERENCE`: shoulder bleed is a
credible model-side source of visible shoulder artifacts; these numbers alone
do not prove what the operator will see in the Animation Lab.

`MEASURED`: arm_to_height spans .2710--.2982 (spread .0271), while
leg_to_height spans .4242--.4976 (spread .0734). `MEASURED`: forearm/upper-arm
has the widest listed arm-related variation, .8445--1.2371 (spread .3926).
`INFERENCE`: the twelve bodies are fairly close in total arm-to-height but
more separated in leg-to-height; a rotation-only punch may therefore land at
different places. `NOT FOUND`: the clips' source skeleton (UE4 Mannequin) was
not measured here, so mismatch against that source is out of scope; no source
comparison is estimated.
