# GYMLIFE2 - the gym picture's three leftover faults

## How a pose gap is computed

The same number as the GYMLIFE1 table. Take the six bones Hips, Head, LeftHand, RightHand, LeftFoot, RightFoot. Subtract the hips' sideways shift (X and Z) from every bone, then add up the six straight-line distances, in metres. A printed 0.81 is that sum, to two decimals: the full body_hook clip measures 0.816 here, and the window 0.374 s to 1.373 s measures 0.408 (the table says 0.41). The baker writes this sum as `gap` in the `.json` beside each shadow strip, and the old cut's sum as `before`.

## Join table

mh_boxer_01. The other 18 bodies sit in the same place: slip to pull stays at 0.004 to 0.005, pull to jab at 0.619 to 0.688, jab back to slip at 0.712 to 0.786.

| join | old cut | before | this cut | after |
| --- | --- | --- | --- | --- |
| slip to pull | slip 0.448 s to pull 0.000 s | 1.914 | slip 0.600 s to pull 0.600 s | 0.005 |
| pull to jab | pull 0.448 s to jab 0.000 s | 1.274 | pull 0.533 s to jab 0.333 s | 0.682 |
| jab back to slip | jab 0.556 s to slip 0.000 s | 1.714 | jab 0.167 s to slip 0.533 s | 0.779 |

The strip is 16 frames at 96 by 128. Six slip frames (0.533, 0.450, 0.360, 0.280, 0.480, 0.600), four pull frames (0.600, 0.560, 0.540, 0.533), six jab frames (0.333, 0.250, 0.150, 0.050, 0.100, 0.167). The other seven strips were not re-baked.

No guard frame was inserted between the jab and the slip or the pull. The closest pair is already the join, and a search of the 208 owned clips (every 0.05 s) found no frame within 0.536 of both a slip pose and a jab pose. A step graph of 7,216 samples, stepping only when the gap was 0.10 or less, never left a 16-pose slip neighbourhood to reach a jab. One extra frame cannot split a 0.68 gap into two gaps of 0.10.

## The three bars

Each number on main was read before this change. The shadow row's "before" is the old cut, measured on the same skeleton. The walk and the button were printed by the test against the code on main.

| bar | on main | now |
| --- | --- | --- |
| shadow, worst join | 1.914 (no join file, so the test was red) | 0.786 |
| walk, bent route, worst distance from the polyline | 79.51 px | 0.00 px |
| walk, straight route (control) | 0.00 px | 0.00 px |
| button overlap, worst share of the person | 0.4071 (mh_boxer_11 on bag_floor, seed 1, 6 people) | 0.0000 (6 people) |

The walk on main was the straight line between the two spots. The control, a route with no bend, was already on that line. After the change the test walks 40 seeded bent routes out of 810, and 316 straight ones, and every recorded point stays on the polyline. A cardio spot still fades, because it has no plan tile.

## Pass lines

```
RESULT: tests/gym_life2_test.gd -> GYM_LIFE2 failures=0
RESULT: tests/gym_workouts_test.gd -> GYM_WORKOUTS failures=0
RESULT: tests/gym_people_test.gd -> GYM_PEOPLE failures=0
RESULT: tests/gym_floor_people_test.gd -> GYM_FLOOR_PEOPLE failures=0
RESULT: tests/gym_hub_test.gd -> GYM_HUB failures=0
RESULT: tests/gym_places_test.gd -> GYM_PLACES failures=0
RESULT: tests/file_limits_test.gd -> FILE_LIMITS failures=0
RESULT: tests/no_pronoun_test.gd -> NO_PRONOUN failures=0
```

The new test goes red if a join file is missing, a strip is not 16 frames at 96 by 128, the slip-to-pull gap is over 0.10, a jab join is over 0.80, a bent walk leaves the polyline by more than 6 px, or a placed person covers a button by more than a tenth of their area.

## Stills

`docs/mockups/s435/gymlife2/`, 1920 by 1080, five seconds apart. `gym_5s.png` is the bend: mh_boxer_11 walking from bag_f1 toward bag_floor, 2 px from the corner, clip `walk`, frame 7.

gym_0s.png

- id=mh_boxer_03 spot=tread_1 clip=stand frame=11 rect=(1259.5, 653.5, 114.2, 152.3)
- id=mh_boxer_11 spot=bag_f1 clip=jab_back frame=5 rect=(619.6, 441.6, 103.0, 137.3)
- id=mh_boxer_07 spot=bag_f2 clip=idle_back frame=14 rect=(694.3, 441.6, 103.0, 137.3)
- id=mh_boxer_17 spot=bag_f6 clip=bag_body frame=10 rect=(994.2, 441.6, 103.0, 137.3)
- id=mh_boxer_08 spot=bag_f7 clip=bag_body frame=0 rect=(1058.9, 441.6, 103.0, 137.3)
- id=mh_boxer_13 spot=tread_2 clip=stand frame=8 rect=(1329.8, 653.5, 114.2, 152.3)

gym_5s.png

- id=mh_boxer_03 spot=tread_1 clip=stand frame=4 rect=(1259.5, 653.5, 114.2, 152.3)
- id=mh_boxer_11 spot=bag_f1 clip=walk frame=7 rect=(814.6, 458.1, 103.9, 138.5)
- id=mh_boxer_07 spot=bag_f2 clip=idle_back frame=1 rect=(694.3, 441.6, 103.0, 137.3)
- id=mh_boxer_17 spot=bag_f6 clip=bag_body frame=8 rect=(994.2, 441.6, 103.0, 137.3)
- id=mh_boxer_08 spot=bag_f7 clip=bag_body frame=13 rect=(1058.9, 441.6, 103.0, 137.3)
- id=mh_boxer_13 spot=tread_2 clip=stand frame=1 rect=(1329.8, 653.5, 114.2, 152.3)

gym_10s.png

- id=mh_boxer_03 spot=tread_1 clip=stand frame=14 rect=(1259.5, 653.5, 114.2, 152.3)
- id=mh_boxer_11 spot=bag_floor clip=stretch frame=14 rect=(851.0, 586.8, 110.7, 147.6)
- id=mh_boxer_07 spot=bag_f2 clip=idle_back frame=6 rect=(694.3, 441.6, 103.0, 137.3)
- id=mh_boxer_17 spot=bag_f6 clip=bag_body frame=7 rect=(994.2, 441.6, 103.0, 137.3)
- id=mh_boxer_08 spot=bag_f7 clip=bag_body frame=13 rect=(1058.9, 441.6, 103.0, 137.3)
- id=mh_boxer_13 spot=tread_2 clip=stand frame=11 rect=(1329.8, 653.5, 114.2, 152.3)

## What could not be done

The bar of 0.10 on every join, including the wrap, cannot be met with the clips we own. The slip and the pull do share a pose (gap 0.005). The jab does not: the closest pull-to-jab pair is 0.682 and the closest jab-to-slip pair is 0.779 on mh_boxer_01, and the worst body reaches 0.786. The test locks the slip-to-pull join at 0.10 and a jab join at 0.80, which the old cuts (1.27 and above) would fail.

The slip and pull pieces are the short stretch around that shared pose, so the join does not pop. They do not play the whole slip or the whole pull. No new motion was made.
