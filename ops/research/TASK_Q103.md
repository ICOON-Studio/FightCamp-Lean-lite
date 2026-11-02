# TASK Q103 — QWEN — UNREAL 5.8'S OWN CODE: HOW A BODY TURNS TO FACE WHERE IT MOVES (ORIENTATION WARPING AND STEERING)

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`, branch
`qwen/q103-ue-orientation` - Claude creates it from `master` before launch. Push the BRANCH. Stage: S4 (free-direction
movement) and S4a (the operator's "head, torso and feet facing differently") - forecast research.

**Test tier: RESEARCH, NO `.gd` TOUCHED.** No Godot, no test. `python research/Q103_check.py` must exit 0 before
you commit. **IF THE CHECK FAILS, DO NOT COMMIT AND DO NOT PUSH: send the BLOCKED mail (below) with its FAIL lines.**
Your Q102 passed its check first time and was merged; do the same here.

## Owned files

- `research/Q103_UE_ORIENTATION_WARPING.md` - NEW, 80 lines at most.
- `research/Q103_ue_citations.json` - NEW.

## Why this exists

Our fight engine already moves the two boxers in 2D - circling, stepping in and out - but the 3D room shows them on one
line, facing each other, because we own only forward, back and a few strafe walks. S4 feeds the engine's real positions
and facing into the room. A man circling his opponent keeps his head and chest on the opponent while his legs walk
sideways, and the operator has already flagged "head, torso and feet facing differently" as looking wrong. Unreal 5.8
ships two nodes for this: ORIENTATION WARPING (a walk clip is played in another direction by twisting the lower body
toward the movement and counter-rotating the spine so the upper body keeps facing) and STEERING (the root is turned
toward a target orientation over time). Their source is installed on this PC. Read it and write down what the code
does, cited line by line. DOCUMENTED means "the installed code says so".

## What to read - ONLY these (read-only; under `C:/Program Files/Epic Games/UE_5.8/Engine/Plugins/Animation/AnimationWarping/Source/Runtime/`)

- `Public/BoneControllers/AnimNode_OrientationWarping.h` (256 lines, read whole)
- `Private/BoneControllers/AnimNode_OrientationWarping.cpp` (806 lines: `grep -n` for `LocomotionAngle`,
  `DistributedBoneOrientationAlpha`, `SpineBones`, `IKFoot`, `RotationInterpSpeed`, `CounterCompensate`,
  `MaxCorrectionDegrees`, `MaxRootMotionDeltaToCompensateDegrees`, `MinRootMotionSpeedThreshold`,
  `LocomotionAngleDeltaThreshold`, then read those windows)
- `Public/BoneControllers/AnimNode_Steering.h` (109 lines, read whole) and `Private/BoneControllers/AnimNode_Steering.cpp`
  (174 lines, read whole)

If any path cannot be read, stop: send the BLOCKED mail with the exact error text.

## Questions - each answered in the digest, each backed by citations

- **W1 The angle and the twist**: how the warp angle is found (Graph mode from root motion against `LocomotionDirection`
  / `LocomotionAngle`, Manual mode), how it is split between the root and the spine bones
  (`DistributedBoneOrientationAlpha`, the per-bone weights), and how the IK feet are rotated to stay on the ground -
  formulas in plain code, with units.
- **W2 Smoothing and limits**: what `RotationInterpSpeed`, `CounterCompensateInterpSpeed` and
  `bCounterCompenstateInterpolationByRootMotion` do over time, and what `MaxCorrectionDegrees`,
  `MaxRootMotionDeltaToCompensateDegrees`, `MinRootMotionSpeedThreshold` and `LocomotionAngleDeltaThreshold` cut off.
- **W3 Spaces**: what `WarpingSpace` ComponentTransform / other values and `RotationAxis` change.
- **T1 Steering**: how the node turns the root toward `TargetOrientation` - `ProceduralTargetTime` vs
  `AnimatedTargetTime`, `RootMotionThreshold`, `DisableSteeringBelowSpeed`, `MinScaleRatio` / `MaxScaleRatio` - as code.
- **R For our room** (a recommendation, labelled INFERENCE wherever the code does not say it): a boxer circling his
  opponent at 0.3-0.9 m/s on an engine path with forward, back and strafe walks, head and chest held on the opponent -
  which node, which settings, what it does to the head, chest and feet.

## Output

`Q103_ue_citations.json`:
`{"defaults": {"FAnimNode_OrientationWarping.RotationInterpSpeed": 10.0, ...},
  "citations": [{"id": "W1", "claim": "one sentence", "file": "Engine/Plugins/Animation/AnimationWarping/Source/Runtime/Private/BoneControllers/AnimNode_OrientationWarping.cpp", "line": 123, "quote": "the exact text of that line, trimmed"}, ...]}`
- `defaults`: EVERY field declared with a default value (`Type Name = value;`) DIRECTLY after a `UPROPERTY(...)` line in
  the two structs `FAnimNode_OrientationWarping` and `FAnimNode_Steering` (there are 32), keyed `Struct.Field`: numbers
  as numbers (drop the `f`: `1.f` is `1.0`), `true`/`false` as JSON booleans, anything else as the text after the `=`
  (e.g. `"EWarpingEvaluationMode::Manual"`, `"{ 0.f, 0.f, 0.f }"`).
- `citations`: at least THREE for W1, TWO for W2, W3 and T1, ONE for R. `line` is 1-based; `quote` is at least 15
  non-space characters copied from that line (the check looks within two lines either side). `file` is relative to
  `C:/Program Files/Epic Games/UE_5.8/`.

`Q103_UE_ORIENTATION_WARPING.md` opens with `## DECISIONS` (at most 10 lines). Then one `### W1`, `### W2`, `### W3`,
`### T1`, `### R` section: the answer, the formula in plain code, and the citation ids it rests on. When the digest
quotes a default, write it `FieldName = value` with the header's value.

## Commit and send

`git status -s` first. Commit ONLY the two owned files with the paths on the commit line:
`git commit -m "Q103: UE 5.8 Orientation Warping and Steering, cited" -- research/Q103_UE_ORIENTATION_WARPING.md research/Q103_ue_citations.json`,
then `git show --stat HEAD` (exactly those 2 files), `git push -u origin qwen/q103-ue-orientation`, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q103-ready --body <hash>`.
If the check fails: no commit, no push; `python Tools/agent_comms.py send --from qwen --to claude --topic "Q103 BLOCKED" --body "<the FAIL lines>"`.
Do not edit HANDOFF.md, AgentComms/roadmap.json or any other file. Never `git stash`, `reset`, `checkout .`, `clean`,
`rebase` or `merge`. Do not run Godot.

## The trap

Your Q102's recommendation contradicted its own citations: it said the offset catches up once a slide stops, but with
the velocity clamp on and an in-place clip the cap is zero and it never does. In R, check every sentence against your
W1-W3 answers before you write it. And a header comment says what a field is FOR; the `.cpp` decides what it DOES: every
answer to W1, W2, W3 and T1 must cite at least one `.cpp` line. Unreal works in centimetres, seconds and degrees.
