# TASK C123 — CODEX — UNREAL 5.8'S OWN CODE: MOTION MATCHING, AND HOW TWO CHARACTERS ARE MATCHED TOGETHER

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (the operator's "jerky moves") and S5 (transitions) - forecast research.

**Test tier: RESEARCH, NO `.gd` TOUCHED.** No Godot, no test, no commit (your sandbox cannot write `.git`; Claude
collects). `python research/C123_check.py` must exit 0 before you send the mail.

## Owned files

- `research/C123_UE_MOTION_MATCHING.md` - NEW, 80 lines at most.
- `research/C123_ue_citations.json` - NEW.

## Why this exists

The operator watched our 3D boxing match and named "jerky moves"; their standing direction is that transitions between
animations must feel natural, "do whatever it takes". Today each fighter plays one bought clip per action and our code
joins them (inertialization, your C119). MOTION MATCHING instead searches a database of poses every few frames for the
one that best continues the current motion - and Unreal 5.8's Pose Search plugin also matches SEVERAL characters
together (interaction assets: one man's punch and the other man's reaction chosen and aligned as a pair). Motion
CAPTURE is ruled out for us; motion matching is NOT. Its source is installed on this PC. Read it and write down what
the code does, cited line by line. DOCUMENTED means "the installed code says so". Your C118-C122 readings of this
install all landed first pass; this is the same shape, on a bigger plugin - read by `grep -n` and windows.

## What to read - ONLY these (read-only; under `C:/Program Files/Epic Games/UE_5.8/Engine/Plugins/Animation/PoseSearch/Source/Runtime/`)

- `Public/PoseSearch/AnimNode_MotionMatching.h` (235 lines, read whole) and `Private/AnimNode_MotionMatching.cpp`
  (549 lines: `grep -n` for `Search`, `BlendTime`, `PoseJumpThresholdTime`, `PoseReselectHistory`,
  `SearchThrottleTime`, `Continuing`, `Blend`, then read windows)
- `Public/PoseSearch/PoseSearchLibrary.h` (305 lines) and `Private/PoseSearchLibrary.cpp` (1,531 lines: `grep -n` for
  `UpdateMotionMatchingState`, `ContinuingPose`, `bJump`, `PoseJumpThresholdTime`, `PoseReselectHistory`, then windows)
- `Public/PoseSearch/PoseSearchDatabase.h` (799 lines: `grep -n` for `UPROPERTY`, `CostBias`, `Search`) and
  `Private/PoseSearchDatabase.cpp` (`grep -n` for `CostBias`, `ComputeCost`, `SearchContinuingPose`, `Search(`)
- `Public/PoseSearch/PoseSearchCost.h` (103 lines, read whole)
- `Public/PoseSearch/PoseSearchSchema.h` (221 lines) and `Public/PoseSearch/PoseSearchFeatureChannel_Pose.h` (96 lines),
  with `Private/PoseSearchFeatureChannel_Pose.cpp` (`grep -n` for `Weight`, `Velocity`, `BuildQuery`)
- `Public/PoseSearch/PoseSearchInteractionAsset.h` (104 lines) with `Private/PoseSearchInteractionAsset.cpp` (611 lines),
  `Public/PoseSearch/PoseSearchInteractionLibrary.h` (114 lines) with `Private/PoseSearchInteractionLibrary.cpp` (922
  lines), and `Private/PoseSearchInteractionIsland.cpp` (1,969 lines: `grep -n` only, then windows)

If any path cannot be read, stop: send `--topic "C123 BLOCKED"` with the exact error text.

## Questions - each answered in the digest, each backed by citations

- **M1 When it searches and when it jumps**: how often the node searches (`SearchThrottleTime`), how the CONTINUING pose
  competes with the search result (`ContinuingPoseCostBias`, `LoopingCostBias`, `BaseCostBias`), and what
  `PoseJumpThresholdTime` and `PoseReselectHistory` forbid - as code, with units.
- **M2 The cost**: how a candidate's cost is computed from the query and the database's feature vectors (the formula;
  what `DataPreprocessor` Normalize does to it), what the pose channel puts in the vector (which bones, positions or
  velocities, `bUseCharacterSpaceVelocities`, `Weight`), and what `PoseSearchMode` PCAKDTree changes about the search.
- **M3 The jump**: what happens when the search picks a different pose - `BlendTime`, `BlendOption`, whether the blend is
  inertial or a crossfade in this node (the blend stack), and where in the new clip playback starts.
- **M4 Two or more characters**: what an interaction asset holds (roles, one animation per role), how an interaction
  search scores the characters TOGETHER and hands each its role, how the characters are aligned to each other
  (`WarpingBankingWeight`, `MinimalTranslationWeight`, the warp), and what an "island" is.
- **R For our two boxers** (a recommendation, labelled INFERENCE wherever the code does not say it): with ~13 bought
  clips per man (stance, walks, jab, cross, two hooks, body shot, reactions, block, slip, knockdown), what a motion
  matching database and a strike/reaction interaction asset would be, and what the code needs that we lack.

## Output

`C123_ue_citations.json`:
`{"defaults": {"FAnimNode_MotionMatching.BlendTime": 0.2, ...},
  "citations": [{"id": "M1", "claim": "one sentence", "file": "Engine/Plugins/Animation/PoseSearch/Source/Runtime/Private/PoseSearchLibrary.cpp", "line": 123, "quote": "the exact text of that line, trimmed"}, ...]}`
- `defaults`: EVERY field declared with a default value (`Type Name = value;`) DIRECTLY after a `UPROPERTY(...)` line in
  `FAnimNode_MotionMatching`, `UPoseSearchDatabase`, `UPoseSearchSchema`, `UPoseSearchFeatureChannel_Pose` and
  `UPoseSearchInteractionAsset` (there are 58), keyed `Class.Field`: numbers as numbers (drop the `f`: `1.f` is `1.0`),
  `true`/`false` as JSON booleans, anything else as the text after the `=` (e.g. `"FFloatInterval(0.f, 0.f)"`).
- `citations`: at least THREE for M1, M2 and M4, TWO for M3, ONE for R. `line` is 1-based; `quote` is at least 15
  non-space characters copied from that line (the check looks within two lines either side). `file` is relative to
  `C:/Program Files/Epic Games/UE_5.8/`.

`C123_UE_MOTION_MATCHING.md` opens with `## DECISIONS` (at most 10 lines: when the node jumps, the cost formula, the
jump's blend, how two characters are matched and aligned, and what is INFERENCE). Then one `### M1` ... `### M4` and
`### R` section: the answer, the formula in plain code, and the citation ids it rests on. When the digest quotes a
default, write it `FieldName = value` with the header's value.

## Send

`python research/C123_check.py`, then
`python Tools/agent_comms.py send --from codex --to claude --topic "C123 ready" --body "check PASS"`.
Do not edit any other file. Do not run Godot.

## The trap

A header comment says what a field is FOR; the `.cpp` decides what it DOES (C118 found a header setting the code never
reads). Every answer to M1-M4 must cite at least one `.cpp` line; where a comment and the code differ, say so and follow
the code. Pose Search is large and partly EXPERIMENTAL in 5.8 - answer only from lines you read, and say "not found in
the files read" rather than filling a gap from memory. Unreal works in centimetres, seconds and degrees: name the unit.
