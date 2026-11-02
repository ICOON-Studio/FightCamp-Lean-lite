# Q124 — Extrema Audit Report

## 1. How many extrema, across how many documents?

**57 extrema across 15 documents** (52 high confidence, 5 low confidence),
found in a corpus of 1,363 markdown files in `research/`.

The 15 documents with extrema:

| Document | Extrema | Kind |
|---|---:|---|
| S39_THE_GRIP_WAS_READ_ONE_BONE_OFF.md | 12 | min, p0, closest, max |
| C100_RETARGET_BY_FRAME.md | 10 | max, worst, largest |
| C149_CMU_SOURCE.md | 8 | min, max, worst |
| C102_SILHOUETTE_FIX.md | 4 | maxima, max |
| C103_FACING.md | 4 | worst, largest |
| C137_PAIRED_BJJ_IN_GAME.md | 4 | max, largest |
| BRIEF_DOLA_CLINCH_POSE.md | 3 | closest, minimum |
| C101_OFFSET_OR_MOTION.md | 2 | largest, maximum |
| C99_SOURCE_SKELETON.md | 2 | largest |
| C98_FIGHTER_SKINNING.md | 2 | min, max |
| C84_THE_PUSH_APART.md | 1 | maximum |
| C87_THE_RETARGET_LADDER.md | 1 | largest |
| C91_PAIRED_CONTENT.md | 1 | worst |
| C92_STRIKING_CONTENT.md | 1 | worst |
| U98_CLIPS_VS_VIDEO.md | 1 | peak |

The low-confidence entries (5) are C84 (simulation-derived, not a direct clip
load), C91/C92 (dead-air measurements from clip files — not animation data
affected by resample), and C98 (skinning ratios from mesh geometry, not
animation frames).

## 2. Which ten are the most load-bearing?

Grep for each value across `research/`, `Godot/tests/`, `Godot/tools/`:

| Value | Hits | Where cited | Load-bearing? |
|---|---:|---|---|
| **0.099** (S39 min) | 27 | S39, BRIEF, Q122, RECIPE, TASK_Q124, TASK_U122, FightClipRetarget.gd | **YES** — in a script comment and 6+ research docs |
| **19.64°** (C100 max) | 22 | TASK_C100–C103, R141, C100–C102, C101 tripwire | **YES** — gates 4 task files and the R108 tripwire |
| **0.766 m** (BRIEF/C149 min) | 7 | BRIEF, S34, RECIPE (×2), Q83 | **YES** — the clinch separation anchor |
| **0.1455 m** (S39 resample) | 5 | S39, FightClipRetarget.gd, TASK_C151, TASK_Q124, TASK_U122 | **YES** — in a script comment, the central resample finding |
| **36.81°** (C100 worst) | 5 | C100 (×4), C102 | Moderate — within C100/C102 only |
| **0.130 m** (C149 corrected min) | 2 | C149 only | Low — new figure, not yet cited |
| **14.001°** (C102 residual max) | 2 | C102 only | Low — within C102 only |
| **0.239 m** (BRIEF closest) | 2 | BRIEF only | Low — used to disprove a wrong trial selection |
| **0.501 m** (C137 largest step) | 1 | C137 only | Low — single-phase measurement |
| **8.833 s** (C92 worst dead air) | 1 | C92 only | Low — content audit, not animation data |

**The top four are load-bearing.** 0.099 and 19.64 appear in script comments
and gate task files — changing them would require updating code and multiple
documents. 0.766 is the clinch separation anchor used by the recipe and S34.
0.1455 is the central resample-damage finding, embedded in a script comment.

## 3. Which are already known to be safe?

A figure measured from a clip whose native rate is 30 Hz or below loses nothing
to a 30 Hz bake. The census U122 is measuring native rates; until it reports,
the following can be cleared by clip stem:

| Clip stem | Extrema at risk | What U122 needs to show |
|---|---|---|
| 18/19_05 (CMU mocap) | min 0.1407→0.1455 (+3.4%) | Native rate was 120 Hz — **already known unsafe**, S39 proved it |
| 22/23_17 (CMU mocap) | min 0.099 (unchanged at 30 Hz) | Native rate was 120 Hz — safe for THIS figure because the grip is sustained over 620 frames |
| H2H_HitReaction01.FBX | max 19.64° | Need native rate; if ≤30 Hz, safe |
| H2H_Haymaker_InPlace.FBX | max 36.81° | Need native rate; likely 30 Hz (UE4 Mannequin source) |
| H2H_SlipLeft.FBX | max 30.28° | Need native rate |
| H2H_KnockDown02.FBX | max 179.89° facing | Need native rate |
| Paired_FullMount_* (BJJ) | largest steps, dead air | Need native rate; likely 30 Hz (game asset) |
| RamsterZ FBX clips (all) | C100/C101/C102/C103 extrema | Need native rate per clip |
| CMU source (ASF/AMC) | C149 min/max | **120 Hz** — all C149 extrema are unsafe at 30 Hz |

**Only 22/23_17's minimum is known safe by argument** (sustained grip, not a
single-frame dip). Every other extremum needs its clip's native rate from U122
to be cleared.

## 4. Which figures did you EXCLUDE, and why?

### Threshold language (not measurements)

The word "minimum" appears ~200 times in the corpus as a threshold or rule:
- "a minimum of three sources" — citation rule
- "minimum viable" — design constraint
- "minimum graduation period" — IBJJF/IJF age/time rules (C52, C55)
- "minimum tolerance from 13" — UWW age rule (C56)
- "minimum technical standards" — IMMAF pathway rule
- "max 2/category" — judo entry quota (C57)
- "max FPS", "max iterations", "max distance" — engine/code parameters
- "Verified minimum 15" — catalog count threshold (C75)

None of these are measurements; a resample cannot touch a rule.

### Literature values (not clip loads)

- K29 (bout time-motion): all figures from published studies (JPES, JSC, etc.)
- K50 (spacing): Schortgen 2023, Cheraghi 2014, Atha 1985 — real-world measurements
- K30, K32, K46–K54: literature on punch kinematics, not Godot clip loads
- C54 (federation costs): USD prices from WT/FIAS documents
- J12, J13, M11: aging/career figures from broadcast and medical literature
- Q115 (clinch distance): video tracking of real fights, not clip loads

### Code descriptions (not measurements)

- C118, C119, C123, C127, C129: UE source-code analysis; "max", "min" describe
  algorithm parameters (MaxExtensionRatio, MinDistance, etc.), not measurements
- C5_DIGEST: GameState.gd formula description ("minimum body readiness")
- C110: engine frame analysis, not clip measurement

### Video tracking (not clip loads)

- U109, U110, U111: MediaPipe tracking of YouTube boxing videos; extrema are
  from real-world footage, not animation files through Godot
- Q115: pair_world.py tracking of broadcast footage

### Simulation-derived (not direct clip loads)

- C84 (push-apart): extrema from engine replay of 200 bouts; the clips are
  played at 30 fps but the extrema are corrections from a constraint, not
  animation quantities. Included as low confidence.

### Content audits (dead air, not animation data)

- C91, C92: dead-air measurements from clip files; these measure silence in
  audio/video files, not animation frame data. A resample does not change dead
  air. Included as low confidence.

### Mesh geometry (not animation)

- C98 (skinning ratios): vertex-weight ratios from FBX meshes; these are
  static rigging properties, not animation-frame quantities. A resample does
  not change skinning weights. Included as low confidence.

---

## Gate output

```
CHECK 1 PASS: docs_scanned=1363 >= actual=1363
CHECK 2 PASS: all 57 quotes verified
CHECK 3 PASS: all kinds in allowed vocabulary
CHECK 4 PASS: all values parse as numbers
CHECK 5 PASS: high_confidence=52
CHECK 6 PASS: summary counts match (extrema=57, high=52, docs=15)

ALL CHECKS PASSED
```
