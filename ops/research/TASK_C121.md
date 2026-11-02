# TASK C121 — CODEX — UNREAL 5.8'S OWN CODE: HOW MOTION WARPING MAKES AN ATTACK ARRIVE AT ITS TARGET

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (the operator's "punches look fake" and "bodies overlap").

**Test tier: RESEARCH, NO `.gd` TOUCHED.** No Godot, no test, no commit (your sandbox cannot write `.git`; Claude
collects). `python research/C121_check.py` must exit 0 before you send the mail.

## Owned files

- `research/C121_UE_MOTION_WARPING.md` - NEW, 70 lines at most.
- `research/C121_ue_citations.json` - NEW.

## Why this exists

The operator watched our 3D boxing match and named "punches look fake" and "bodies overlap" among the worst things on
screen. Our punches are performed IN PLACE: the fist reaches only from 0.80-1.10 m, where real boxers stand 1.23 m
apart and move the hip ~28 cm toward the target in a straight (K50). Shipped games solve "the attack must land where
the target is" with MOTION WARPING: the attacker's root motion is bent, inside a window of the animation, so the
strike arrives at a target transform. Unreal Engine 5.8 ships the plugin with its source on this PC. Read it and write
down exactly what the code does, cited line by line. DOCUMENTED means "the installed code says so".

## What to read - ONLY these (read-only; under `C:/Program Files/Epic Games/UE_5.8/Engine/Plugins/Animation/MotionWarping/Source/MotionWarping/`)

- `Public/RootMotionModifier.h` (539 lines: `grep -n` for `class`, `UPROPERTY`, then read the classes
  `URootMotionModifier` and `URootMotionModifier_Warp`)
- `Private/RootMotionModifier.cpp` (781 lines: `grep -n` for `ProcessRootMotion`, `Update`, `Weight`, `Translation`,
  `Rotation`, `Easing`, `Remaining`)
- `Public/RootMotionModifier_SkewWarp.h` (58 lines, read whole) and `Private/RootMotionModifier_SkewWarp.cpp`
  (460 lines: `grep -n` for `WarpTranslation`, `Skew`, `MaxSpeedClampRatio`, then read windows)
- `Public/AnimNotifyState_MotionWarping.h` (62 lines, read whole)
- `Public/MotionWarpingComponent.h` (300 lines: `grep -n` for `AddOrUpdateWarpTarget`, `WarpTarget`)

If any path cannot be read, stop: send `--topic "C121 BLOCKED"` with the exact error text.

## Questions - each answered in the digest, each backed by citations

- **W1** The window: how a warp is scheduled inside an animation (the notify state's start and end time) and what the
  modifier does each frame inside it - its state machine (`ERootMotionModifierState`) and the weight.
- **W2** Skew warp's translation: the formula that bends the remaining root-motion translation so the root arrives at
  the target location at the window's end; what `bIgnoreZAxis` and `bWarpToFeetLocation` change; what
  `MaxSpeedClampRatio` clamps and to what.
- **W3** Rotation: how `bWarpRotation`, `RotationType`, `RotationMethod`, `WarpRotationTimeMultiplier` and
  `WarpMaxRotationRate` turn the root to face the target, as code (units named).
- **W4** The target: how a warp target is added and read (`AddOrUpdateWarpTarget...`, `WarpTargetName`), and what happens
  when the target moves during the window.
- **W5** What the warp needs from the animation: root motion it can bend (and what happens when a clip has none - an
  in-place clip), `bSubtractRemainingRootMotion`, `WarpPointAnimProvider`.

## Output

`C121_ue_citations.json`:
`{"defaults": {"URootMotionModifier_Warp.bWarpTranslation": true, ...},
  "citations": [{"id": "W1", "claim": "one sentence", "file": "Engine/Plugins/Animation/MotionWarping/Source/MotionWarping/Private/RootMotionModifier.cpp", "line": 123, "quote": "the exact text of that line, trimmed"}, ...]}`
- `defaults`: EVERY field declared with a default value (`Type Name = value;`) DIRECTLY after a `UPROPERTY(...)` line
  in the three classes `URootMotionModifier`, `URootMotionModifier_Warp` and `URootMotionModifier_SkewWarp`, keyed
  `Class.Field`: numbers as numbers (drop the `f`), `true`/`false` as JSON booleans, anything else as the text after
  the `=` (e.g. `"NAME_None"`, `"EMotionWarpRotationType::Default"`).
- `citations`: at least TWO for each of W1, W2, W3 and W5, and one for W4. `line` is 1-based; `quote` is at least 15
  non-space characters copied from that line (the check looks within two lines either side). `file` is relative to
  `C:/Program Files/Epic Games/UE_5.8/`.

`C121_UE_MOTION_WARPING.md` opens with `## DECISIONS` (at most 8 lines: for our punches - how a strike's root would be
warped to arrive at its target, over which window, and what an in-place clip gives the warp to work with). Then one
`### W1` ... `### W5` section per question: the answer, the formula in plain code, and the citation ids it rests on.

## Send

`python research/C121_check.py`, then
`python Tools/agent_comms.py send --from codex --to claude --topic "C121 ready" --body "check PASS"`.
Do not edit any other file. Do not run Godot.

## The trap

A header comment describes what a field is FOR; the `.cpp` decides what it DOES (C118 found a header setting the code
never reads). Every answer to W1-W3 and W5 must cite at least one `.cpp` line; where a comment and the code differ, say
so and follow the code. Unreal works in centimetres and degrees: name the unit at every number.
