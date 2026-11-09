# BOXERLEAN1 - how far does our guard lean against the capture?

## The measure

Neck minus hips, against her facing, in degrees, + = forward. Her facing: horizontal, square to the hip line, on the side her toes point. Same maths both sides (tools/torso_lean_probe.gd, tools/torso_lean_raw.py): `atan2(tor.dot(fwd), tor.y)`.

## SOURCE - the Punch PRO capture (Blender, Box1_M3_Idle.fbx)

49 frames at 30 fps (1.63 s of idle). Both sides read the same (the actor faces the same way throughout).

| side | min | mean | max |
|------|-----|------|-----|
| left | 1.2 | 1.6 | 2.0 |
| right | 1.2 | 1.6 | 2.0 |

The capture leans 1.6° forward on average.

## CLIP - pro_idle baked on MetaHuman, every SkeletonModifier3D off

240 frames at 30 fps (8 s of pure clip, looped).

| body | corner | min | mean | max |
|------|--------|-----|------|-----|
| mh_boxer_01 | red orthodox | 0.5 | 0.9 | 1.3 |
| mh_boxer_02 | blue southpaw | 0.4 | 0.8 | 1.3 |
| mh_boxer_10 | red orthodox | -0.1 | 0.3 | 0.7 |
| mh_boxer_02 | blue southpaw | 0.4 | 0.8 | 1.3 |

The baked clip leans 0.8-0.9° forward on mh_boxer_01, only 0.3° on mh_boxer_10. The capture's 1.6° is not fully reaching the MetaHuman skeleton: the retarget (UE4 mannequin proportions to MetaHuman proportions) loses about half the lean on one body and five-sixths on the other.

## GAME - pro_idle with every modifier on except GuardWeave

Only the frames that actually played pro_idle (the stage cycles guard clips).

| body | corner | frames | min | mean | max |
|------|--------|--------|-----|------|-----|
| mh_boxer_01 | red orthodox | 83 | 0.7 | 1.2 | 2.9 |
| mh_boxer_02 | blue southpaw | 59 | -0.1 | 2.1 | 11.2 |
| mh_boxer_10 | red orthodox | 95 | -0.2 | 0.7 | 6.5 |
| mh_boxer_02 | blue southpaw | 59 | -0.2 | 1.8 | 11.1 |

With the fight's modifiers on (JoinSmoother, TiredSag, GuardTuck, KneeTrack, etc.), the lean climbs. The blue boxer (mh_boxer_02) spikes to 11° - the guard clip and the modifiers stack lean on top of the baked clip. The red boxer stays closer to the clip's own lean.

## In plain words

1. **The capture leans 1.6° forward.** Our baked clip leans less: 0.8-0.9° on mh_boxer_01, only 0.3° on mh_boxer_10. The difference is the retarget - the UE4 mannequin's proportions don't carry the same lean angle onto the MetaHuman skeleton. It is not a layer that adds the difference; the bake itself loses lean.

2. **The fight's procedural layers add lean back, and then some.** With the modifiers on, the mean reaches 1.2-2.1° and the max spikes to 6.5-11.2°. The footwork test's 11.3-14.0° readings live in this range. The lean the test sees is mostly the guard clip plus the modifier stack, not the baked clip alone.

3. **The two bodies differ.** mh_boxer_10 reads 0.3° in CLIP mode where mh_boxer_01 reads 0.9°. The skeleton proportions change how the retargeted animation sits. In GAME mode the gap narrows (0.7 vs 1.2) because the modifiers dominate, but the body still matters.
