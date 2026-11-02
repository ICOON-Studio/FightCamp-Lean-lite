# TASK Q102 — QWEN — UNREAL 5.8'S OWN CODE: HOW A BODY THAT IS MOVED BY THE GAME KEEPS ITS FEET (OFFSET ROOT BONE AND STRIDE WARPING)

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`, branch
`qwen/q102-ue-root-offset` - Claude creates it from `master` before launch. Push the BRANCH. Stage: S4a (the operator's
"jerky moves" and "bodies overlap") - forecast research.

**Test tier: RESEARCH, NO `.gd` TOUCHED.** No Godot, no test. `python research/Q102_check.py` must exit 0 before
you commit. **IF THE CHECK FAILS, DO NOT COMMIT AND DO NOT PUSH: send the BLOCKED mail (below) with its FAIL lines.**
A reading that fails its check is worth nothing, and Q101 was rejected for pushing with its check failing.

## Owned files

- `research/Q102_UE_ROOT_OFFSET_AND_STRIDE.md` - NEW, 80 lines at most.
- `research/Q102_ue_citations.json` - NEW.

## Why this exists

In our 3D boxing room the GAME moves the two men: it slides both bodies along a line to hold the distance the fight
engine asks for, and the next build also moves a puncher's body up to 28 cm toward his target during a punch and back
after. The walks we own step at 1.74 m/s while the bodies slide a few centimetres a second. The operator watched it
and named "jerky moves". Unreal Engine 5.8 ships two nodes for exactly this - OFFSET ROOT BONE (the mesh lags the moved
capsule and catches up smoothly, and can refuse to slide when the animation is not moving) and STRIDE WARPING (a walk's
steps are lengthened or shortened to match the speed the body really moves) - and their source is installed on this
PC. Read it and write down what the code does, cited line by line. DOCUMENTED means "the installed code says so".
Codex's C118/C119/C121 readings of the same install landed first pass with this exact kind of check.

## What to read - ONLY these (read-only; under `C:/Program Files/Epic Games/UE_5.8/Engine/Plugins/Animation/AnimationWarping/Source/Runtime/`)

- `Public/BoneControllers/AnimNode_OffsetRootBone.h` (209 lines, read whole)
- `Private/BoneControllers/AnimNode_OffsetRootBone.cpp` (633 lines: `grep -n` for `Halflife`, `HalfLife`,
  `MaxTranslationError`, `ClampToTranslationVelocity`, `SpeedRatio`, `EOffsetRootBoneMode`, `Evaluate`, `Update`,
  then read those windows)
- `Public/BoneControllers/AnimNode_StrideWarping.h` (209 lines, read whole)
- `Private/BoneControllers/AnimNode_StrideWarping.cpp` (482 lines: `grep -n` for `StrideScale`, `LocomotionSpeed`,
  `MinRootMotionSpeedThreshold`, `Pelvis`, `Thigh`, `Clamp`, then read those windows)
- Only if a function they call decides an answer (a spring damper, for example): `grep -rn "<function name>"` under
  `C:/Program Files/Epic Games/UE_5.8/Engine/Source/Runtime/` and read that one function.

If any path cannot be read, stop: send the BLOCKED mail with the exact error text.

## Questions - each answered in the digest, each backed by citations

- **O1 The offset and how it decays** (Offset Root Bone): what the offset is (between what and what), how it is
  accumulated each frame, the formula that blends it out over `TranslationHalflife` / `RotationHalfLife` (write the
  function in plain code and name its unit), what `MaxTranslationError` / `MaxRotationError` clamp, and what the four
  `EOffsetRootBoneMode` values do.
- **O2 The no-slide rule and the inputs**: what `bClampToTranslationVelocity` with `TranslationSpeedRatio` does to the
  catch-up speed when the incoming animation has little or no root motion; what `EvaluationMode` Graph vs Manual,
  `TranslationDelta`, `bResetEveryFrame` and `bResetOnTeleport` change.
- **S1 The stride scale** (Stride Warping): how `StrideScale` is computed in Graph mode from `LocomotionSpeed` against
  the animation's root motion speed, what `MinRootMotionSpeedThreshold` and `bDisableIfMissingRootMotion` do, and how
  the IK feet are moved along `StrideDirection` by that scale (formula in plain code).
- **S2 The pelvis and the legs**: how the pelvis is adjusted after the feet move, and what `bCompensateIKUsingFKThighRotation`
  and `bClampIKUsingFKLimits` do.
- **R For our room** (a recommendation, labelled INFERENCE wherever the code does not say it): for two men slid 3-30 cm
  along a line at 0-0.3 m/s, playing in-place walks whose steps are 1.74 m/s, and a puncher moved up to 28 cm toward his
  target over ~0.25 s and back - which node, which settings, and what it would do to the feet.

## Output

`Q102_ue_citations.json`:
`{"defaults": {"FAnimNode_OffsetRootBone.TranslationHalflife": 0.1, ...},
  "citations": [{"id": "O1", "claim": "one sentence", "file": "Engine/Plugins/Animation/AnimationWarping/Source/Runtime/Private/BoneControllers/AnimNode_OffsetRootBone.cpp", "line": 123, "quote": "the exact text of that line, trimmed"}, ...]}`
- `defaults`: EVERY field declared with a default value (`Type Name = value;`) DIRECTLY after a `UPROPERTY(...)` line in
  the two structs `FAnimNode_OffsetRootBone` and `FAnimNode_StrideWarping` (there are 38), keyed `Struct.Field`:
  numbers as numbers (drop the `f`: `1.f` is `1.0`), `true`/`false` as JSON booleans, anything else as the text after
  the `=` (e.g. `"EOffsetRootBoneMode::Interpolate"`, `"{ 0, 0, 1 }"`).
- `citations`: at least THREE for O1 and S1, TWO for O2 and S2, ONE for R. `line` is 1-based; `quote` is at least 15
  non-space characters copied from that line (the check looks within two lines either side). `file` is relative to
  `C:/Program Files/Epic Games/UE_5.8/`.

`Q102_UE_ROOT_OFFSET_AND_STRIDE.md` opens with `## DECISIONS` (at most 10 lines: the offset's decay formula and
defaults, the no-slide rule, the stride-scale formula and its low-speed limit, and what is INFERENCE for our room).
Then one `### O1`, `### O2`, `### S1`, `### S2`, `### R` section: the answer, the formula in plain code, and the
citation ids it rests on. When the digest quotes a default, write it `FieldName = value` with the header's value.

## Commit and send

`git status -s` first. Commit ONLY the two owned files with the paths on the commit line:
`git commit -m "Q102: UE 5.8 Offset Root Bone and Stride Warping, cited" -- research/Q102_UE_ROOT_OFFSET_AND_STRIDE.md research/Q102_ue_citations.json`,
then `git show --stat HEAD` (exactly those 2 files), `git push -u origin qwen/q102-ue-root-offset`, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q102-ready --body <hash>`.
If the check fails: no commit, no push; `python Tools/agent_comms.py send --from qwen --to claude --topic "Q102 BLOCKED" --body "<the FAIL lines>"`.
Do not edit HANDOFF.md, AgentComms/roadmap.json or any other file. Never `git stash`, `reset`, `checkout .`, `clean`,
`rebase` or `merge`. Do not run Godot.

## The trap

A header comment says what a field is FOR; the `.cpp` decides what it DOES (C118 found a header setting the code never
reads). Every answer to O1, O2, S1 and S2 must cite at least one `.cpp` line; where a comment and the code differ, say
so and follow the code. Unreal works in centimetres, seconds and degrees: name the unit at every number. And do not
answer from what you know about Unreal - answer from the lines you read; the check re-finds every quote.
