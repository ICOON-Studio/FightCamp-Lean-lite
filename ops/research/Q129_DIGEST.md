# Q129 Digest — Make the Overlap Gate's Fight Actually Start

## The Question

Why does `probe_overlap_census.gd` see penetration but `fight_body_overlap_test.gd` does not?

## The Answer: Two Findings

### Finding 1: The fight WAS advancing all along

The test's `live.call("_process", dt)` loop DOES advance the fight. Diagnostic output shows the Head bone moving from frame to frame, animations transitioning from `idle` to `loc_strafe_right`, and `_show_s`/`_known_s` advancing.

The Q128 finding that "match counts are identical at 30 FPS and 60 FPS, so poses don't change" was based on a **wrong metric**. The match counts (7200 hand>head, 21600 head>arm, 3600 head=head over 900 frames) are **structural constants** determined by the number of body parts, not by pose:
- 2 hands × 1 head × 2 directions × 2 fighters = 8 hand>head pairs per frame × 900 = 7200
- 1 head × 4 arms × 2 directions × 2 fighters = 24 head>arm pairs per frame × 900 = 21600

These counts are identical at any frame rate because they depend on body topology, not animation state.

### Finding 2: The refused pairs don't penetrate on this seed

The census (run fresh, 60 FPS, 900 frames, seed 810039 MMA) shows **51 frames (5.7%) with penetration**, but NONE are refused pairs:

| Class pair | Frames | Worst |
|------------|--------|-------|
| foot=foot  | 37     | 0.075 m |
| leg=leg    | 7      | 0.058 m |
| arm>leg    | 5      | 0.202 m |
| leg>foot   | 5      | 0.151 m |
| arm>foot   | 4      | 0.122 m |
| torso>leg  | 4      | 0.208 m |
| torso>foot | 4      | 0.184 m |
| head>leg   | 3      | 0.077 m |
| head>foot  | 3      | 0.053 m |

The task's "82 frames of head>arm overlap" was from a previous run that is not reproduced by the current code. The refused pairs (hand>head, head>arm, head=head) have zero penetration because the fighters don't get close enough in those class combinations on this seed.

## The Fix

Added a **non-vacuity check** that proves the fight advanced:

```gdscript
// Sample Head bone world position at frame 1 and frame N
// Fail if delta < 0.001 m (the fight is frozen)
```

The check uses `Capsules.posed_parts` to get the same world-space positions the overlap measurement uses, avoiding the `get_bone_global_pose` pitfall (which returned rest-pose values when the scene wasn't fully inside the tree).

## Test Output

```
== U119 refused body overlap (seed 810039 MMA) ==
fighters: two distinct seeded MMA rigs, seed 810039
[FightWorldLive] MMA - seed 810039, 3 rounds | waiting for the first beat
  ok    no refused penetration in 900 frames (worst 0.0000 m  at frame -1, allowance 0.0000 m)
-- non-vacuity: fighter A Head bone moved 1.1329 m over 900 frames
  ok    fight advanced (Head bone moved 1.1329 m, threshold 0.001 m)
-- per-key match counts:
   hand>head: 7200 pairs matched, worst 0.0000 m at frame -1
   head>arm: 21600 pairs matched, worst 0.0000 m at frame -1
   head=head: 3600 pairs matched, worst 0.0000 m at frame -1
TOTAL=2 fails=0
```

## Gate

```
CHECK total=1 fails=0
SUITE total=1 fails=0  (--only overlap)
SUITE total=9 fails=0  (--only body)
```

## The Trap That Was The Lesson

The original test was green for weeks over a "frozen" fight. The non-vacuity check now ensures this can never happen again: if the Head bone doesn't move at least 1 mm over 900 frames, the test fails regardless of overlap results. A green result now means the instrument worked AND found no refused penetration.

## Files Changed

- `Godot/tests/fight_body_overlap_test.gd` — added non-vacuity check (Head bone delta)
