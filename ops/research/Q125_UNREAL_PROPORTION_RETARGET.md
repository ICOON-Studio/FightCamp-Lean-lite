# Q125 — What Unreal Does When the Source Skeleton Is Not the Target's Shape

Root: `UE_5.8/Engine/Plugins/Animation/IKRig/Source/IKRig/` (abbreviated `IKRig/` below).
All line references are into that tree. Every numeric claim cites `file:line` and quotes the line.

---

## A1. Does UE copy translation at all, or only rotation?

**Both.** The FK chain op carries an `EFKChainTranslationMode` enum with six modes
(`FKChainsOp.h:154-162`):

| Enumerator | Meaning |
|---|---|
| `None` **(default)** | Target bone translations left at retarget pose. |
| `GloballyScaled` | Source translation × whole-body scale from pelvis height ratio. |
| `Absolute` | Source translation copied verbatim (world-space). |
| `StretchBoneLengthUniformly` | Each target bone's local offset scaled by the source chain's temporal stretch ratio. |
| `StretchBoneLengthNonUniformly` | Same, but per-bone via spline param. |
| `OrientAndScale` | Per-bone: target ref length × source temporal stretch, re-oriented to source direction. |

Default: `TranslationMode = EFKChainTranslationMode::None` (`FKChainsOp.h:219`).
Default rotation mode: `Interpolated` (`FKChainsOp.h:203`).

The **global scale** used by `GloballyScaled` is a **single whole-body scalar** —
not per-chain. It is computed once in PelvisMotionOp from the two pelvis heights
and returned as a uniform `FVector`:

```
PelvisMotionOp.cpp:223  const float ScaleFactor = Source.InitialHeightInverse * Target.InitialHeight;
PelvisMotionOp.cpp:224  GlobalScaleFactor.Set(ScaleFactor, ScaleFactor, ScaleFactor);
```

`GetGlobalScaleVector()` multiplies that by `ScaleHorizontal` / `ScaleVertical`
user knobs (`PelvisMotionOp.cpp:265`).

## A2. What reference length is that ratio taken from?

**Pelvis height in the retarget pose** (the UE "retarget pose" — their T/A-pose
reference, NOT the current animated pose).

```
PelvisMotionOp.cpp:196  Source.InitialHeightInverse = 1.0f / InitialHeight;
```

where `InitialHeight` is `SourceSkeleton.RetargetPoses.GetGlobalRetargetPose()[pelvis].Z`.
The ratio is `Target.InitialHeight / Source.InitialHeight` — a single scalar,
computed once at `Initialize()`, applied to every bone every frame.

For `StretchBoneLengthUniformly` the ratio is different: it is the **source
chain's own temporal stretch** (`FKChainsOp.cpp:409-411`):

```
double SourceChainLengthInitial = BoneChain->GetChainLength(SourceChain.BoneChain->RefPoseGlobalTransforms);
double SourceChainLengthCurrent = BoneChain->GetChainLength(SourceChain.CurrentGlobalTransforms);
double StretchRatio = SourceChainLengthInitial < UE_KINDA_SMALL_NUMBER ? 1.0f : SourceChainLengthCurrent / SourceChainLengthInitial;
```

This is source-only — it does NOT compare source to target. It makes the target
chain breathe with the source chain's own extension changes over time.

For `OrientAndScale` the per-bone formula is
`TargetRefLength × (SourceCurrentLength / SourceRefLength)` (`FKChainsOp.cpp:460-462`):
the target's own ref-pose bone length scaled by the source bone's temporal stretch.

## A3. What does UE do when the target limb is too short to reach the goal?

The LimbSolver (`LimbSolver.cpp:613-615`) checks reachability:

```
if (FVector::DistSquared(RootLocation, GoalLocation) >= FMath::Square(LimbLength))
{
    SolveStraightLimb(InOutLinks, GoalLocation);
}
```

`SolveStraightLimb` (`LimbSolver.cpp:212`) places every link along the
root→goal direction at its own rest length. The limb **extends fully toward the
goal but does NOT stretch past its rest length** — the end lands at
`root + direction × LimbLength`, short of the goal. The chain is **not allowed
to stretch past its summed bone lengths**. The IK precision default is
`ReachPrecision = 0.01f` cm (`LimbSolver.h:19`).

## A4. Shipped default numbers

| Parameter | Value | Unit | File:line |
|---|---|---|---|
| `TranslationMode` | `None` | enum | `FKChainsOp.h:219` |
| `RotationMode` | `Interpolated` | enum | `FKChainsOp.h:203` |
| `EnableFK` | `true` | bool | `FKChainsOp.h:191` |
| `RotationAlpha` | `1.0` | scalar | `FKChainsOp.h:209` |
| `TranslationAlpha` | `1.0` | scalar | `FKChainsOp.h:225` |
| `BlendToSource` | `0.0` | scalar | `IKChainsOp.h:86` |
| `Extension` | `1.0` | scalar | `IKChainsOp.h:134` |
| `ScaleVertical` (IK) | `1.0` | scalar | `IKChainsOp.h:126` |
| `MatchSourceLength` | `0.0` | scalar | `StretchChainOp.h:59` |
| `ScaleChainLength` | `1.0` | scalar | `StretchChainOp.h:63` |
| `bEnabled` (Stretch) | `false` | bool | `StretchChainOp.h:53` |
| `SourceScaleFactor` | `1.0` | scalar | `ScaleSourceOp.h:27` |
| `FloorConstraintWeight` | `0.0` | scalar | `PelvisMotionOp.h:38` |
| `ScaleHorizontal` | `1.0` | scalar | `PelvisMotionOp.h:101` |
| `ScaleVertical` (Pelvis) | `1.0` | scalar | `PelvisMotionOp.h:105` |
| `GroundFalloffHeightPercent` | `0.9` | scalar | `PelvisMotionOp.h:59` |
| `ReachPrecision` | `0.01` | cm | `LimbSolver.h:19` |
| `MaxIterations` | `12` | count | `LimbSolver.h:31` |
| `MinRotationAngle` | `15` | degrees | `LimbSolver.h:40` |
| `ReachStepAlpha` | `0.7` | scalar | `LimbSolver.h:52` |

## A5. Which one thing fixes a hand that lands 0.36 m too far out?

**StretchChainOp, `MatchSourceLength = 1.0`.** It lerps the target chain's
current length toward the source chain's current length
(`StretchChainOp.cpp:78-79`) and scales every bone vector in the target chain
by the resulting multiplier (`StretchChainOp.cpp:85`). This is a per-chain
scalar applied to bone positions — **no IK solve required.** It directly
shortens the target arm to match the source arm's length, eliminating the
proportion mismatch that causes the 0.36 m overshoot. Cost: the target chain's
shape is now source-proportioned; children of the chain are re-parented
(`StretchChainOp.cpp` propagates to `AllChildrenOfChain`).

---

## Falsifiable control

**ScaleGoalsOp** and **LimbSolver.cpp** say nothing about proportion mismatch.
ScaleGoalsOp is a manual knob on IK goal position (vertical / horizontal /
along-chain scaling) with no reference to source or target proportions.
LimbSolver is a pure IK solver — it takes a goal and a limb, and when the goal
is unreachable it straightens the limb; it has no concept of two skeletons
having different proportions.
