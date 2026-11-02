# TASK C129 — CODEX — UNREAL 5.8'S OWN CODE: STRIDE WARPING - HOW A STEP IS MADE LONGER OR SHORTER WITHOUT THE FEET SLIDING

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (THE MOVE SCRIPT).

**Test tier: RESEARCH, NO `.gd` TOUCHED.** No Godot, no test, no commit (your sandbox cannot write `.git`; Claude
collects). `python research/C129_check.py` must print `C129_CHECK PASS` before you send the ready mail.

## Owned files

- `research/C129_UE_STRIDE_WARPING.md` - NEW, 80 lines at most.
- `research/C129_ue_citations.json` - NEW.

## Why this exists

We are authoring each boxing exchange as ONE two-fighter asset (your C127 read how Unreal plays such a pair). The first
one - a jab landing on the head - exposed a distance problem: the jab we bought is a big STEPPING jab (its hips travel
about 0.26 m, twice the stepping jabs we tracked in real footage), so the glove only meets the face when the two men start
1.54 m apart, where real boxers stand 1.0-1.5 m apart and close a jab's distance by 10-20 cm. We want to SHORTEN that
step to the real distance - move the pelvis and the stepping front foot less - without the feet sliding on the canvas.
Unreal 5.8 ships exactly that as STRIDE WARPING, with source on this PC. Read what the code does, cited line by line.
DOCUMENTED means "the installed code says so".

## What to read - ONLY these (read-only)

Root: `C:/Program Files/Epic Games/UE_5.8/Engine/Plugins/Animation/AnimationWarping/Source/Runtime/`

- `Public/BoneControllers/AnimNode_StrideWarping.h` (209 lines - read whole)
- `Private/BoneControllers/AnimNode_StrideWarping.cpp` (482 lines - `grep -n` for `StrideScale`, `StrideDirection`,
  `Pelvis`, `IKFoot`, `Thigh`, `Clamp`, `LocomotionSpeed`, `RootMotion`, `EvaluateSkeletalControl`, then read windows)
- anything that file calls for the pelvis adjustment (`grep -rn "PelvisAdjustment\|FIKFootPelvisPullDownSolver" Public
  Private` and read only the solver it uses)

If any path cannot be read, stop: send `--topic "C129 BLOCKED"` with the exact error text.

## Questions - each answered in the digest, each backed by citations

- **S1 WHAT IT NEEDS.** The inputs: the IK foot bones and their FK feet, the IK foot root, the pelvis, the thighs; the
  `Mode` (manual stride scale v locomotion speed against root-motion speed) and what `bDisableIfMissingRootMotion` and
  `MinRootMotionSpeedThreshold` do - with an IN-PLACE clip (no root motion) what does it fall back to?
- **S2 THE FEET.** The exact formula that moves each IK foot target: along which direction (`StrideDirection`, the floor
  normal, gravity), relative to what origin (the IK foot root? the pelvis?), scaled by what - in plain code, with units.
- **S3 THE PELVIS.** How the pelvis is pulled down / moved so the legs can reach the warped feet (the solver, its
  settings, what it clamps), in plain code.
- **S4 THE THIGHS AND LIMITS.** What `bCompensateIKUsingFKThighRotation` and `bClampIKUsingFKLimits` do to the IK
  targets, as code.
- **S5 THE ORDER.** In what order the node does feet, pelvis and thighs each frame, and what it writes back (bone
  transforms in component space) - one short list.

## Output

`C129_ue_citations.json`:
`{"defaults": {"FAnimNode_StrideWarping.StrideScale": 1.0, ...}, "citations": [{"id": "S2", "claim": "one sentence",
"file": "Engine/Plugins/Animation/AnimationWarping/Source/Runtime/Private/BoneControllers/AnimNode_StrideWarping.cpp",
"line": 123, "quote": "the exact text of that line, trimmed"}, ...]}`
- `defaults`: EVERY field declared with a default value on the line DIRECTLY after a single-line `UPROPERTY(...)` in
  `FStrideWarpingFootDefinition` and `FAnimNode_StrideWarping` - keyed `Struct.Field`: numbers as numbers (`1.f` is `1.0`,
  `10.0f` is `10.0`), `true`/`false` as JSON booleans, anything else as the text after the `=` (e.g.
  `"FVector::ForwardVector"`, `"{ EWarpingVectorMode::WorldSpaceVector, FVector::UpVector }"`). The check parses the
  header itself and fails on any missing, extra or wrong key.
- `citations`: at least 2 for S1, 3 for S2, 3 for S3, 2 for S4, 1 for S5. `line` is 1-based; `quote` is at least 15
  non-space characters copied from that line (the check looks two lines either side). `file` is relative to
  `C:/Program Files/Epic Games/UE_5.8/`. S2, S3 and S4 must each cite at least one `.cpp` line.

`C129_UE_STRIDE_WARPING.md` opens with `## DECISIONS` (at most 8 lines). Then `### S1` ... `### S5`, each with the
answer, the formula in plain code, the units and the citation ids. Then `### FOR OUR STEPPING JAB` (at most 10 lines):
our jab moves the hips ~0.26 m toward the opponent and steps the front foot; we want the step at 0.5x. Say, step by
step, what Stride Warping would do to the front foot, the rear foot and the pelvis on each frame of that clip, and what
it would NOT fix (mark INFERENCE where the code does not decide).

## Send

`python research/C129_check.py`, then
`python Tools/agent_comms.py send --from codex --to claude --topic "C129 ready" --body "check PASS"`.
Do not edit any other file. Do not run Godot.

## The trap

Stride warping was written for LOCOMOTION: a looping walk or run whose feet plant and lift in a cycle. Our jab is one
step. Read what the code assumes about planted feet and root motion before claiming it applies, and say so where it does
not. Unreal works in centimetres; name the unit at every number.
