# TASK C122 — CODEX — UNREAL 5.8'S OWN CODE: HOW A TWO BONE IK PUTS A HAND ON A TARGET, AND HOW ITS STRENGTH IS BLENDED IN AND OUT

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (the operator's "punches look fake").

**Test tier: RESEARCH, NO `.gd` TOUCHED.** No Godot, no test, no commit (your sandbox cannot write `.git`; Claude
collects). `python research/C122_check.py` must exit 0 before you send the mail.

## Owned files

- `research/C122_UE_TWO_BONE_IK.md` - NEW, 80 lines at most.
- `research/C122_ue_citations.json` - NEW.

## Why this exists

The operator watched our 3D boxing match and named "punches look fake". Measured (Q97): our jabs and crosses pass
0.3-0.4 m BELOW the opponent's head at contact and hooks pass 0.3 m wide, because every punch is a bought clip
performed against nobody. The next build bends the striking arm toward the real target inside the contact window -
an analytic two-bone solve on shoulder, elbow and wrist, faded in before contact and out after. Unreal Engine 5.8
ships exactly that as the Two Bone IK node, with its alpha blending, and its source is installed on this PC. Read it
and write down what the code does, cited line by line. DOCUMENTED means "the installed code says so". Your C118, C119
and C121 readings of the same install all landed first pass; this is the same shape.

## What to read - ONLY these (read-only; under `C:/Program Files/Epic Games/UE_5.8/Engine/Source/Runtime/`)

- `AnimationCore/Private/TwoBoneIK.cpp` (186 lines, read whole) and `AnimationCore/Public/TwoBoneIK.h` (90 lines)
- `AnimGraphRuntime/Private/BoneControllers/AnimNode_TwoBoneIK.cpp` (279 lines, read whole) and
  `AnimGraphRuntime/Public/BoneControllers/AnimNode_TwoBoneIK.h` (126 lines)
- `AnimGraphRuntime/Private/BoneControllers/AnimNode_SkeletalControlBase.cpp` (284 lines: `grep -n` for
  `ActualAlpha`, `AlphaInputType`, `IsRelevant`, `LocalBlendCSBoneTransforms`, then read windows) and
  `AnimGraphRuntime/Public/BoneControllers/AnimNode_SkeletalControlBase.h` (140 lines)
- `Engine/Classes/Animation/InputScaleBias.h` (334 lines: the struct `FInputAlphaBoolBlend`, lines ~284-325) and
  `Engine/Private/Animation/InputScaleBias.cpp` (435 lines: `grep -n` for `FInputAlphaBoolBlend::ApplyTo`)
- `Engine/Public/AlphaBlend.h` (257 lines: `DefaultBlendOption`, `EAlphaBlendOption`) and
  `Engine/Private/AlphaBlend.cpp` (348 lines: `grep -n` for `AlphaToBlendOption`)

If any path cannot be read, stop: send `--topic "C122 BLOCKED"` with the exact error text.

## Questions - each answered in the digest, each backed by citations

- **I1 The solve** (`TwoBoneIK.cpp`): given root (shoulder), joint (elbow) and end (wrist) positions, a joint target
  and an effector, where the code puts the elbow and the wrist - the formula, in plain code. What happens when the
  effector is BEYOND the limb's reach, and when it is too CLOSE; what `bAllowStretching`, `StartStretchRatio` and
  `MaxStretchScale` do to the lengths; how the joint target picks the bend plane and what happens when it is
  degenerate (parallel to the reach direction, or at the root).
- **I2 The node** (`AnimNode_TwoBoneIK.cpp`): what space the effector and joint target are read in (the default),
  how the solved positions become the three bones' new transforms (which rotations are recomputed and how), and what
  `bTakeRotationFromEffectorSpace`, `bMaintainEffectorRelRot` and `bAllowTwist` change about the END bone's (the
  hand's) rotation.
- **I3 The strength** (`AnimNode_SkeletalControlBase.cpp`, `InputScaleBias.cpp`): the three `AlphaInputType` paths
  (float, bool, curve) that produce `ActualAlpha`; how `ActualAlpha` blends the solved bone transforms with the pose
  that came in (the call and its space); the relevance threshold under which nothing is applied; and how
  `FInputAlphaBoolBlend::ApplyTo` ramps the alpha over `BlendInTime` / `BlendOutTime` when its bool flips.
- **I4 The easing** (`AlphaBlend.cpp`): the `AlphaToBlendOption` formula for `HermiteCubic`, `Linear`, `Cubic` and
  `Sinusoidal`, and which one `UE::Anim::DefaultBlendOption` is.
- **I5 For our punch** (a recommendation, labelled INFERENCE wherever the code does not say it): with these nodes,
  how a shipped graph would put a fist on a moving target inside a strike's contact window - the effector, the joint
  target, the alpha source and its ramp - and what the code does when the target is out of the arm's reach.

## Output

`C122_ue_citations.json`:
`{"defaults": {"FAnimNode_TwoBoneIK.MaxStretchScale": 1.2, ...},
  "citations": [{"id": "I1", "claim": "one sentence", "file": "Engine/Source/Runtime/AnimationCore/Private/TwoBoneIK.cpp", "line": 123, "quote": "the exact text of that line, trimmed"}, ...]}`
- `defaults`: EVERY member initialised in the constructor initializer lists (`: Name(value)` / `, Name(value)`, the
  lines between the constructor's signature and its `{`) of `FAnimNode_TwoBoneIK` (in the `.cpp`),
  `FAnimNode_SkeletalControlBase` and `FInputAlphaBoolBlend` (inline in their headers), keyed `Struct.Member` -
  including the `#if WITH_EDITORONLY_DATA` ones - PLUS the key `UE::Anim::DefaultBlendOption` with the value
  `AlphaBlend.h` gives it. Numbers as numbers (drop the `f`: `1.f` is `1.0`), `true`/`false` as JSON booleans,
  anything else as the text inside the parentheses (e.g. `"BCS_ComponentSpace"`, `"FVector::ZeroVector"`).
- `citations`: at least THREE for I1 and I3, TWO for I2 and I4, ONE for I5. `line` is 1-based; `quote` is at least
  15 non-space characters copied from that line (the check looks within two lines either side). `file` is relative
  to `C:/Program Files/Epic Games/UE_5.8/`.

`C122_UE_TWO_BONE_IK.md` opens with `## DECISIONS` (at most 10 lines: for our punches - the solve's reach rule, the
default stretch, the alpha ramp and its easing, what is INFERENCE). Then one `### I1` ... `### I5` section per
question: the answer, the formula in plain code, and the citation ids it rests on.

## Send

`python research/C122_check.py`, then
`python Tools/agent_comms.py send --from codex --to claude --topic "C122 ready" --body "check PASS"`.
Do not edit any other file. Do not run Godot.

## The trap

A header comment says what a field is FOR; the `.cpp` decides what it DOES (C118 found a header setting the code never
reads). Every answer to I1-I4 must cite at least one `.cpp` line; where a comment and the code differ, say so and follow
the code. Unreal works in centimetres and degrees and its alphas are unitless 0..1: name the unit at every number.
