# TASK C127 — CODEX — UNREAL 5.8'S OWN CODE: HOW TWO CHARACTERS PLAY ONE PAIRED ANIMATION (CONTEXTUAL ANIMATION)

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (THE MOVE SCRIPT - the operator: "There is no cohesion between animations and reactions").

**Test tier: RESEARCH, NO `.gd` TOUCHED.** No Godot, no test, no commit (your sandbox cannot write `.git`; Claude
collects). `python research/C127_check.py` must print `C127_CHECK PASS` before you send the ready mail.

## Owned files

- `research/C127_UE_CONTEXTUAL_ANIMATION.md` - NEW, 90 lines at most.
- `research/C127_ue_citations.json` - NEW.

## Why this exists

Our 3D boxing match plays the thrower's punch and the receiver's hit reaction as two separate clips from different
packs, started on separate timers, then patched body part by body part. The operator watched it and said the motion
has no cohesion. The fix we are building is a MOVE SCRIPT: one exchange (a jab that lands on the head) is ONE asset
for BOTH fighters on ONE clock - the glove meets the head on the contact frame, the reaction starts there, the
distance between the men is part of the asset. Unreal Engine 5.8 ships exactly that system - CONTEXTUAL ANIMATION
("a scene": roles, one animation per role, warp points, selection criteria, IK targets between the two actors) - and
its source is installed on this PC. Read it and write down exactly what the code does, cited line by line.
DOCUMENTED means "the installed code says so". We will copy the parts that fit into our Godot room, so the numbers,
the order of operations and the units matter more than the class names.

## What to read - ONLY these (read-only)

Root: `C:/Program Files/Epic Games/UE_5.8/Engine/Plugins/Experimental/Animation/ContextualAnimation/Source/ContextualAnimation/`

- `Public/ContextualAnimTypes.h` (775 lines: `grep -n "^struct\|UPROPERTY"`, then read the structs
  `FContextualAnimTrack` (:72), `FContextualAnimIKTargetDefinition` (:166), `FContextualAnimWarpPointDefinition` (:344),
  `FContextualAnimSceneBinding` (:459), `FContextualAnimStartSceneParams` (:676), `FContextualAnimQueryResult` (:715))
- `Public/ContextualAnimSceneAsset.h` (508 lines: `FContextualAnimSet` (:133), `FContextualAnimSceneSection` (:158),
  then `grep -n "UFUNCTION\|bool \|FTransform \|float "` in `UContextualAnimSceneAsset`)
- `Public/ContextualAnimSelectionCriterion.h` (read whole, ~150 lines)
- `Public/ContextualAnimSceneActorComponent.h` (398 lines: `grep -n "UFUNCTION\|void \|bool "`)
- `Public/AnimNotifyState_IKWindow.h` and `Public/AnimNotifyState_EarlyOutContextualAnimWindow.h` (read whole)
- `Private/ContextualAnimSceneActorComponent.cpp` (1705 lines - NEVER whole: `grep -n` for `PlayAnimation`,
  `Montage_Play`, `WarpTarget`, `AddOrUpdateWarpTarget`, `IKTarget`, `Sync`, `StartTime`, `LateJoin`, `LeaveScene`,
  `OnMontageBlendingOut`, `MovementMode`, `Collision`, then read 30-60 line windows)
- `Private/ContextualAnimTypes.cpp` (1120 lines: `grep -n` for `CalculateAnimSetForBindings`, `TryCreateBindings`,
  `Sync`, `GetAnimStartTime`, `IKTarget`, `MeshToScene`, `WarpPoint`)
- `Private/ContextualAnimSceneAsset.cpp` (1019 lines: `grep -n` for `PrecomputeData`, `GenerateAlignmentTracks`,
  `GenerateIKTargetTracks`, `Query`, `FindAnimStartTime`, `CalculateWarpPoints`, `MeshToScene`)
- `Private/ContextualAnimSelectionCriterion.cpp` (read the `DoesQuerierPassCondition` bodies)
- `Private/ContextualAnimUtilities.cpp` (1223 lines: `grep -n` for `ExtractRootTransform`, `ExtractRootMotion`,
  `FindAnimStartTime`, `DrawDebug` - read only what an answer below needs)

If any path cannot be read, stop: send `--topic "C127 BLOCKED"` with the exact error text.

## Questions - each answered in the digest, each backed by citations

- **P1 THE PAIRED ASSET.** What one scene asset stores per role (a track: its animation, `MeshToScene`,
  `AnimMaxStartTime`, alignment data, IK target data, selection criteria) and per section / anim set; which role is
  PRIMARY and what the other roles' transforms are relative to; how `MeshToScene` and the alignment tracks are
  computed from the animations (`PrecomputeData`), and at what sample rate.
- **P2 SELECTION.** How the scene picks which anim set to play for where the two actors stand now: the order the
  criteria run in, the exact math of `Distance` and `Cone` (what distance, measured from what to what, 2D or 3D, the
  units, and what `MinDistance = 0` / `MaxDistance = 0` mean), and what happens when no set passes.
- **P3 START AND SYNC.** How the two animations start together: do both montages start on the same frame and at what
  start time; what `AnimMaxStartTime` and the query's start time do (a scene joined LATE, from a later frame of the
  animation, when the actor is already where that frame wants him); how `bSyncAnimations` keeps the two animations'
  positions locked while they play - every tick or once, and which one follows which.
- **P4 ALIGNMENT.** How each actor gets from where he stands to where the asset wants him: the warp points and warp
  target names, how the warp target transform is computed from the primary actor and `MeshToScene`, which window of
  the animation the warp runs over (the motion-warping notify), and what happens to movement mode and collision while
  the scene plays.
- **P5 CONTACT.** How one actor's bone is put on the other actor's bone: `FContextualAnimIKTargetDefinition`
  (goal, bone, target role, target bone, provider), how the IK target transform is computed each frame, and how the
  IK window notify blends the IK in and out (the alpha curve and its times).
- **P6 LEAVING.** What ends a scene or lets an actor out early (`AnimNotifyState_EarlyOutContextualAnimWindow`,
  `LeaveScene`, montage blend-out) and what is restored.

## Output

`C127_ue_citations.json`:
`{"defaults": {"FContextualAnimTrack.AnimMaxStartTime": 0.0, ...},
  "citations": [{"id": "P1", "claim": "one sentence", "file": "Engine/Plugins/Experimental/Animation/ContextualAnimation/Source/ContextualAnimation/Private/ContextualAnimSceneAsset.cpp", "line": 123, "quote": "the exact text of that line, trimmed"}, ...]}`
- `defaults`: EVERY field declared with a default value (`Type Name = value;`) on the line DIRECTLY after a
  single-line `UPROPERTY(...)` in these eight: `FContextualAnimTrack`, `FContextualAnimIKTargetDefinition`,
  `FContextualAnimWarpPointDefinition`, `FContextualAnimStartSceneParams`, `FContextualAnimSet`,
  `FContextualAnimSceneSection`, `UContextualAnimSelectionCriterion_Cone`, `UContextualAnimSelectionCriterion_Distance`
  - keyed `Struct.Field`: numbers as numbers (drop the `f`: `1.f` is `1.0`), `true`/`false` as JSON booleans,
  anything else as the text after the `=` (e.g. `"NAME_None"`, `"INDEX_NONE"`, `"nullptr"`,
  `"EMovementMode::MOVE_Walking"`). The check parses the headers itself and fails on any missing, extra or wrong key.
- `citations`: at least 2 for P1, 2 for P2, 3 for P3, 3 for P4, 2 for P5, 1 for P6. `line` is 1-based; `quote` is at
  least 15 non-space characters copied from that line (the check looks within two lines either side). `file` is
  relative to `C:/Program Files/Epic Games/UE_5.8/`. P2, P3, P4 and P5 must each cite at least one `.cpp` line.

`C127_UE_CONTEXTUAL_ANIMATION.md` opens with `## DECISIONS` (at most 10 lines). Then one `### P1` ... `### P6` section
per question: the answer, the formula or order of operations in plain code, the units, and the citation ids it rests
on. Then `### FOR OUR BOXING PAIRS` (at most 12 lines): our engine resolves "fighter A's jab lands on B's head" on one
tick, with the two men standing wherever the fight left them (1.0-1.5 m apart, not exactly facing). Say, step by
step, what Contextual Animation would do with a jab-lands-head asset - which set it selects and by what distance
test, where each man is warped to and over which window, when each animation starts and how the two stay in step,
and how the glove would be put on the head at contact. Mark anything the code does not decide as INFERENCE.

## Send

`python research/C127_check.py`, then
`python Tools/agent_comms.py send --from codex --to claude --topic "C127 ready" --body "check PASS"`.
Do not edit any other file. Do not run Godot.

## The trap

A header comment says what a field is FOR; the `.cpp` decides what it DOES (C118 found a header setting the code never
reads). Where a comment and the code differ, say so and follow the code. Unreal works in centimetres, degrees and
seconds, and its "forward" is +X: name the unit at every number and never convert silently.
