# TASK C118 — CODEX — UNREAL 5.8'S OWN CODE: WHAT A FOOT LOCK DOES WHEN THE LEG CANNOT REACH, AND HOW A POSE IS MIRRORED

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (the foot lock, and the rear hook).

**Test tier: RESEARCH, NO `.gd` TOUCHED.** No Godot, no test, no commit (your sandbox cannot write `.git`; Claude
collects). `python research/C118_check.py` must exit 0 before you send the mail.

## Owned files

- `research/C118_UE_REACH_AND_MIRROR.md` - NEW, 70 lines at most.
- `research/C118_ue_citations.json` - NEW.

## Why this exists

We ship a foot lock built from Unreal Engine 5.8's Foot Placement node (its plant/unplant thresholds, read from the
installed source). Two things it does not yet do: on ~6% of our foot-frames the planted foot is out of the leg's reach,
and our worst frame shows the foot 0.98 m from where the animation put it. Unreal already decides what happens then -
clamp, drop the pelvis, or let go - and those decisions are in its source, on this PC. Separately, our rear hook is a
MIRRORED lead hook and mirroring swaps the stance; Unreal's mirror node mirrors in a particular space with a
per-bone reference correction. Read both, and write down exactly what the code does, cited line by line.
DOCUMENTED means "the installed code says so", never a forum or a guess.

## What to read - ONLY these (read-only; paths under `C:/Program Files/Epic Games/UE_5.8/`)

- `Engine/Plugins/Animation/AnimationWarping/Source/Runtime/Public/BoneControllers/AnimNode_FootPlacement.h` (721 lines)
- `Engine/Plugins/Animation/AnimationWarping/Source/Runtime/Private/BoneControllers/AnimNode_FootPlacement.cpp`
  (large: `grep -n` for `Extension`, `Pelvis`, `Unplant`, `Replant`, `PivotAroundBall`, `HeelLift`, then read windows)
- `Engine/Source/Runtime/Engine/Private/Animation/AnimationRuntime.cpp` - `FAnimationRuntime::MirrorPose`, `:1432-1560`
- `Engine/Source/Runtime/Engine/Classes/Animation/MirrorDataTable.h` and
  `Engine/Source/Runtime/Engine/Private/Animation/MirrorDataTable.cpp` - `FillCompactPoseAndComponentRefRotations`
- `Engine/Source/Runtime/AnimGraphRuntime/Private/AnimNodes/AnimNode_Mirror.cpp` (how the node calls it; root motion)

If any path cannot be read, stop: send `--topic "C118 BLOCKED"` with the exact error text. Do not substitute other files.

## Questions - each answered in the digest, each backed by citations

- **A1** `MaxExtensionRatio` (0.5) and `MinExtensionRatio` (0.2): ratios OF what, applied in which function, and what
  happens to a PLANTED foot whose lock is farther than the leg can reach - the target clamped, the pelvis moved, or
  the foot unplanted? Give the formula as the code computes it.
- **A2** The pelvis: how `PelvisHeightMode`, `MaxOffset`, `MaxOffsetHorizontal` and `HeelLiftRatio` produce the pelvis
  offset, and how that offset is interpolated (spring constants and where they come from).
- **A3** `EFootPlacementLockType::PivotAroundBall`: which point is held, how the foot's rotation is decided around it,
  and what `AnkleTwistReduction` does.
- **A4** EVERY condition that unplants a planted foot, in the order the code tests them (radius, angle, speed,
  extension, curves), and every condition that replants one.
- **B1** How `MirrorPose` mirrors one bone: local or component space, the mirror axis, how the rotation is reflected
  (which quaternion components change sign), and the per-bone reference-rotation correction - as a formula.
- **B2** How a left/right bone PAIR is swapped, and how an unpaired bone (spine, head) and the root are treated.
- **B3** What `AnimNode_Mirror` does with root motion / the root bone's translation.

## Output

`C118_ue_citations.json`:
`{"defaults": {"FFootPlacementPlantSettings.SpeedThreshold": 60.0, ...},
  "citations": [{"id": "A1", "claim": "one sentence", "file": "Engine/Plugins/.../AnimNode_FootPlacement.cpp", "line": 1234, "quote": "the exact text of that line, trimmed"}, ...]}`
- `defaults`: EVERY field with a default value (`Type Name = value;`) declared in the three structs
  `FFootPlacementPlantSettings`, `FFootPlacementPelvisSettings`, `FFootPlacementInterpolationSettings`, keyed
  `Struct.Field`: numbers as numbers (drop the `f`), `true`/`false` as JSON booleans, enums as the text after the
  `=` (e.g. `"EFootPlacementLockType::PivotAroundBall"`).
- `citations`: at least TWO for each of A1-A4, B1 and B2, and one for B3. `line` is 1-based; `quote` is at least 15
  non-space characters copied from that line (the check looks within two lines either side). `file` is relative to
  `C:/Program Files/Epic Games/UE_5.8/`.

`C118_UE_REACH_AND_MIRROR.md` opens with `## DECISIONS` (at most 8 lines: for our foot lock - clamp, pelvis or let
go, with the numbers; for our mirror - the space and the correction). Then one `### A1` ... `### B3` section per
question: the answer, the formula in plain code, and the citation ids it rests on.

## Send

`python research/C118_check.py`, then
`python Tools/agent_comms.py send --from codex --to claude --topic "C118 ready" --body "check PASS"`.
Do not edit any other file. Do not run Godot.

## The trap

A header comment describes what a field is FOR; the `.cpp` decides what it DOES, and they can disagree. Every answer
to A1-A4 must cite at least one `.cpp` line, and where a comment and the code differ, say so and follow the code.
