# GYMLIFE1 result (S429)

Gym-picture people use today's session. New strips are 16 frames, 96x128, in `assets/ui/art/hub_sprites/<stem>_<clip>.png` for all 19 hub bodies. Bake line: `HUBSPRITES done strips=152 failures=0`.

## Clip table

| clip | source clip | frames | loop cut |
| --- | --- | --- | --- |
| bag_combo | pro_combo_punch (1.57 s), bag angle 135, hips held on the first frame | 16 across the whole clip | The end pose is the loop point and is not drawn. Hands return; the full clip's pose gap is 0.344. |
| bag_body | body_hook (2.43 s), angle 135, hips pinned each frame | 16 | 0.374 s to 1.373 s. Full clip pose gap 0.81; this window 0.41. End pose not drawn. |
| bag_upper | rear_uppercut (2.43 s), angle 135, hips pinned each frame | 16 | 0.250 s to 1.185 s. Full clip pose gap 0.81; this window 0.38. End pose not drawn. |
| shadow | slip, then pull, then jab, angle 45, gloves on | 5 + 5 + 6 | slip 0.00–0.560 s (frames 0–4), pull 0.00–0.560 s (frames 5–9), jab 0.00–0.667 s (frames 10–15). Each piece's end pose is not drawn. The native jab closes (pose gap 0). |
| guard_move | pro_block_loop (4.23 s), angle 45 | 16 across the whole clip | End pose gap 0.001. Feet travel about 3 cm. |
| rest_drink | af_drink (1.33 s), angle 45, gloves off | 16 across the whole clip | Pose gap at the end is 0. |
| rest_talk | af_talk (2.93 s), angle 45, gloves off | 16 across the whole clip | Pose gap at the end is 0. |
| stretch | af_crouch_idle (2.93 s), angle 45, gloves off | 16 across the whole clip | Pose gap at the end is 0. |

After paint, each strip is slid so a wide punch stays 2 px off the side and the lowest pixel sits on the jab foot line (y=111).

## MISSING

- Skipping rope. `slip_rope` stands on a mat.
- Speed-bag hands. `speed_bag` stands at a heavy bag.
- Steps in a high guard. `guard_move` is the block loop; the feet barely move.

## Stills

Three pictures, about five seconds apart, on the hidden desktop: `docs/mockups/s429/gymlife1/gym_0.png`, `gym_1.png`, `gym_2.png`. Lucy (heavy bag) is on a bag. Maria (shadow) is on the floor. Dana (roadwork) is not on the floor. `mh_boxer_08` changed spot from `bag_f6` to `bag_f4` between the first and second picture (the walk finished between the samples).

```
PERSON shot=0 id=lucy spot=bag_f1 clip=jab_back frame=8
PERSON shot=0 id=maria spot=bag_floor clip=guard_move frame=9
PERSON shot=0 id=mh_boxer_03 spot=bag_f5 clip=bag_combo frame=11
PERSON shot=0 id=mh_boxer_07 spot=bag_f3 clip=idle_back frame=14
PERSON shot=0 id=mh_boxer_17 spot=bag_f2 clip=bag_body frame=13
PERSON shot=0 id=mh_boxer_08 spot=bag_f6 clip=bag_body frame=3
PERSON shot=1 id=lucy spot=bag_f1 clip=jab_back frame=10
PERSON shot=1 id=maria spot=bag_floor clip=guard_move frame=2
PERSON shot=1 id=mh_boxer_03 spot=bag_f5 clip=bag_combo frame=9
PERSON shot=1 id=mh_boxer_07 spot=bag_f3 clip=idle_back frame=1
PERSON shot=1 id=mh_boxer_17 spot=bag_f2 clip=bag_body frame=11
PERSON shot=1 id=mh_boxer_08 spot=bag_f4 clip=bag_body frame=0
PERSON shot=2 id=lucy spot=bag_f1 clip=jab_back frame=13
PERSON shot=2 id=maria spot=bag_floor clip=guard_move frame=11
PERSON shot=2 id=mh_boxer_03 spot=bag_f5 clip=bag_combo frame=7
PERSON shot=2 id=mh_boxer_07 spot=bag_f3 clip=idle_back frame=5
PERSON shot=2 id=mh_boxer_17 spot=bag_f2 clip=bag_body frame=9
PERSON shot=2 id=mh_boxer_08 spot=bag_f4 clip=bag_body frame=14
```

## Pass lines

```
GYM_WORKOUTS failures=0
GYM_PEOPLE failures=0
GYM_FLOOR_PEOPLE failures=0
GYM_HUB failures=0
GYM_PLACES failures=0
FILE_LIMITS failures=0
NO_PRONOUN failures=0
```

`scripts/ui/GymFloorPeople.gd` is 295 lines.

## What could not be done

- The shadow strip pops where frame 15 (jab's guard) meets frame 0 (slip's lower guard). No blend was invented.
- No clip of stepping while holding a high guard, so `guard_move` stays the block loop.
- A walk on the picture is a straight line through the route tiles between the two spots. It does not follow the plan's bends. A cardio spot has no plan tile, so that change fades instead of walking.
- Desk, rack, treadmill, lockers, treatment and the ring have one working strip (`stand`), so they stay on it. The one-in-five rest only applies where there are two or more working strips.
- The picture has no sofa spot. Film and a rest day use a bench.
- The still harness used short fighter records, so the log has script errors (`offers`, `bout`, `camp`, `rp_child`) from the rest of the home screen. The floor still listed every person, and the three pictures were saved.
