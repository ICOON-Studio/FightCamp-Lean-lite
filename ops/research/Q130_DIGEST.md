# Q130 DIGEST — THE 51 FRAMES NOBODY REFUSED

## Census population

- **Seed:** 810039
- **Discipline:** MMA
- **Frames:** 900 (30 FPS in test, 60 FPS in probe — frame numbers differ by 2x)
- **Threshold:** 0.020 m (FightBodyCapsules.THRESHOLD_M)
- **Fighters:** body_a vs body_b (two distinct seeded MMA rigs)
- **Ruleset:** class_pair_key ranks classes hand(0) < head(1) < arm(2) < torso(3) < leg(4) < foot(5)
- **Catalogue:** 17 capsule defs + 3 sphere defs = 20 parts per fighter

## Distribution by class pair (probe at 60 FPS)

| class pair | frames | pct   | p50    | p90    | worst  | worst_f | same_body? |
|------------|--------|-------|--------|--------|--------|---------|------------|
| foot=foot  | 37     | 4.1%  | 0.0528 | 0.0661 | 0.0749 | f813    | no         |
| leg=leg    | 7      | 0.8%  | 0.0339 | 0.0556 | 0.0580 | f116    | no         |
| arm>leg    | 5      | 0.6%  | 0.0791 | 0.1651 | 0.2019 | f106    | no         |
| leg>foot   | 5      | 0.6%  | 0.0766 | 0.1329 | 0.1506 | f114    | no         |
| arm>foot   | 4      | 0.4%  | 0.0782 | 0.1113 | 0.1224 | f106    | no         |
| torso>leg  | 4      | 0.4%  | 0.1031 | 0.2060 | 0.2080 | f106    | no         |
| torso>foot | 4      | 0.4%  | 0.0988 | 0.1790 | 0.1838 | f106    | no         |
| head>leg   | 3      | 0.3%  | 0.0681 | 0.0756 | 0.0773 | f106    | no         |
| head>foot  | 3      | 0.3%  | 0.0423 | 0.0509 | 0.0531 | f106    | no         |

**Total:** 51 frames with ANY penetration (5.7% of 900).

## Deepest specific part pairs (probe at 60 FPS)

| part pair | frames | worst  | worst_f | same_body? |
|-----------|--------|--------|---------|------------|
| A:UpperChest-Neck vs B:RightLowerLeg-RightFoot | 4 | 0.2080 | f106 | no |
| A:LeftShoulder-LeftUpperArm vs B:RightLowerLeg-RightFoot | 4 | 0.2019 | f106 | no |
| A:UpperChest-Neck vs B:RightFoot-RightToes | 4 | 0.1838 | f106 | no |
| A:Chest-UpperChest vs B:RightLowerLeg-RightFoot | 4 | 0.1622 | f107 | no |
| A:LeftUpperArm-LeftLowerArm vs B:RightLowerLeg-RightFoot | 5 | 0.1585 | f104 | no |

**Cluster:** frames 104–108 (60 FPS) / 52–54 (30 FPS) contain most of the deepest penetrations. This is a specific move (takedown entry or guard pass) where fighter A's upper body penetrates fighter B's leg/foot guard.

## Threshold decision

**Bar:** 0.05 m (5 cm) — penetration visible at normal zoom.

**Rationale:** The original THRESHOLD_M (0.02 m) counts any overlap, but a viewer does not see 2 cm of interpenetration in a render. 5 cm is the depth where capsules visibly intersect. All 9 class pairs in the census exceed this threshold (worst depths range from 5.3 cm to 20.8 cm).

**Decision:** Add all 9 pairs to REFUSED_PAIRS. The original 3 (hand>head, head>arm, head=head) plus the 9 new ones = 12 refused pairs total.

## RED results (test at 30 FPS)

The gate now refuses 12 pairs. On seed 810039, **9 pairs fail** (the original 3 are clean):

| pair | worst (m) | frame | status |
|------|-----------|-------|--------|
| torso>leg | 0.1966 | f53 | **FAIL** |
| arm>leg | 0.1897 | f53 | **FAIL** |
| torso>foot | 0.1709 | f53 | **FAIL** |
| leg>foot | 0.1361 | f57 | **FAIL** |
| leg=leg | 0.1268 | f544 | **FAIL** |
| arm>foot | 0.1145 | f53 | **FAIL** |
| head>leg | 0.0809 | f52 | **FAIL** |
| foot=foot | 0.0643 | f544 | **FAIL** |
| head>foot | 0.0323 | f53 | **FAIL** |
| hand>head | 0.0000 | — | ok |
| head>arm | 0.0000 | — | ok |
| head=head | 0.0000 | — | ok |

**The RED is the deliverable.** The gate was green while 5.7% of frames had visible penetration. Now it refuses those pairs and fails on the frames where they occur. The fix (separating the bodies, not just the hands) is a separate task.

## Files touched

- `Godot/tools/probe_overlap_census.gd` — extended with same_body? column, specific part-pair table, census population header
- `Godot/tests/fight_body_overlap_test.gd` — expanded REFUSED_PAIRS from 3 to 12
- `research/Q130_DIGEST.md` — this file

## Test results

- Parse gate: `CHECK total=2 fails=0` ✓
- `run_tests.py --only overlap`: `SUITE total=1 fails=1` (fight_body_overlap_test.gd FAIL — expected)
- `run_tests.py --only body`: `SUITE total=9 fails=1` (same test, 8 others pass)

## Trap check

**Same-body pair reported as cross-body?** No. All pairs in the census are cross-body (A vs B) by construction — the probe iterates `posed_a` vs `posed_b`. The `same_body?` column is "no" for every row. The deepest penetrations are A:UpperChest-Neck vs B:RightLowerLeg-RightFoot (torso vs leg, different fighters), not two thighs on the same man.

**Non-vacuity:** Head bone moved 1.13 m over 900 frames — the fight advanced, the overlap check is not vacuous.
