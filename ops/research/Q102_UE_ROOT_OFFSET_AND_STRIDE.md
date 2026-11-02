## DECISIONS

Offset = Component − Simulated. Decay: `alpha = Clamp(1 − exp(−0.693·dt/halflife), 0, 1)`; `Simulated += Lerp(0, Offset, alpha)`. TranslationHalflife = 0.1 s, RotationHalfLife = 0.2 s. MaxTranslationError (cm, default −1.0 = disabled) clamps the gap. No-slide: when `bClampToTranslationVelocity`, catch-up ≤ TranslationSpeedRatio (0.5) × root-motion speed/frame. Stride scale (Graph): `LocomotionSpeed / RootMotionSpeed`; below MinRootMotionSpeedThreshold (10.0 cm/s) → 1.0. Foot warped: `ScaleOrigin + (Foot − ScaleOrigin) × StrideScale`. Pelvis pulled down by IK solver; thigh rotated to preserve leg shape. R is INFERENCE — the code does not name our room.

### O1

The offset is `ComponentTransform − SimulatedTransform`. Each Evaluate frame in Interpolate or Release mode, a damp alpha is computed from an implicit spring damper and the simulated position lerps toward the component:

```
Halflife = Max(Halflife, dt)                              // s
alpha    = Clamp(1 − InvExpApprox(0.69314718056·dt / (Halflife + ε)), 0, 1)
delta    = Lerp(0, ComponentTranslation − SimulatedTranslation, alpha)  // cm
SimulatedTranslation += delta
```

alpha is dimensionless; halflife and dt are seconds; offset and delta are cm. `MaxTranslationError` (cm, default −1.0 = disabled) clamps the final gap: if `|gap| > MaxTranslationError`, it is clamped to that magnitude [O1-4]. `MaxRotationError` (degrees, default −1.0 = disabled) does the same for rotation.

Six `EOffsetRootBoneMode` values (cpp lines 36–63): Accumulate (extract root motion, counter component delta), Interpolate (extract root motion, decay via damper), LockOffsetAndConsumeAnimation (lock offset, still consume root motion), LockOffsetIncreaseAndConsumeAnimation (lock, only consume root motion that shrinks offset), LockOffsetAndIgnoreAnimation (lock, ignore root motion), Release (lock, decay via damper).

Citations: [O1-1] DamperImplicit, [O1-2] DampenAlpha from TranslationHalflife, [O1-3] Lerp blend, [O1-4] MaxTranslationError clamp.

### O2

`bClampToTranslationVelocity` with `TranslationSpeedRatio` (default 0.5) caps catch-up speed:

```
MaxDelta = TranslationSpeedRatio × |RootMotionTranslationDelta|   // cm
if |TranslationOffsetDelta| > MaxDelta:
    TranslationOffsetDelta = MaxDelta × normalize(TranslationOffsetDelta)
```

When the animation has little or no root motion, MaxDelta → 0 and the offset cannot decay — the mesh refuses to slide. This is the no-slide rule.

`EvaluationMode` Graph reads root motion from the anim graph attribute stream; Manual uses `TranslationDelta` / `RotationDelta` pins. `bResetEveryFrame` (default false) calls Reset() when the update counter is out of sync. `bResetOnTeleport` (default false): snap simulated to component when component moves more than TeleportDistanceThreshold.

Citations: [O2-1] ClampToTranslationVelocity gate, [O2-2] MaxDelta formula, [O2-3] ResetOnTeleport, [O2-4] ResetEveryFrame.

### S1

In Graph mode, stride scale is the ratio of locomotion speed to animation root-motion speed:

```
RootMotionSpeed = |RootMotionTranslationDelta| / dt    // cm/s
if RootMotionSpeed <= MinRootMotionSpeedThreshold or ≈ 0:
    ActualStrideScale = 1.0
else:
    ActualStrideScale = LocomotionSpeed / RootMotionSpeed
```

MinRootMotionSpeedThreshold (default 10.0 cm/s) prevents unnatural strides at start/stop. `bDisableIfMissingRootMotion` (default true) exits early if the graph has no root-motion attribute.

Each IK foot is warped along StrideDirection from a scale origin (foot projected onto the floor plane through the thigh):

```
ScaleOrigin = Project(IKFoot, plane(Thigh, FloorNormal), StrideDirection)
WarpedLocation = ScaleOrigin + (IKFootLocation − ScaleOrigin) × ActualStrideScale
```

Citations: [S1-1] StrideScale ratio, [S1-2] MinRootMotionSpeedThreshold gate, [S1-3] WarpedLocation, [S1-4] bDisableIfMissingRootMotion.

### S2

After feet warp, the pelvis is pulled down by `PelvisIKFootSolver.Solve` to maintain foot contact and prevent leg over-extension. The solver receives FK foot-to-pelvis distances and warped IK foot locations.

`bCompensateIKUsingFKThighRotation` (default true): rotates each thigh bone to preserve leg shape. Rotation = `FQuat::FindBetweenNormals(InitialDir, TargetDir)` where InitialDir is thigh→FK-foot and TargetDir is thigh→IK-foot after pelvis offset.

`bClampIKUsingFKLimits` (default true, requires bCompensateIKUsingFKThighRotation): if IK foot-to-thigh distance exceeds FK foot-to-thigh distance, clamp IK foot back to FK length along TargetDir.

Citations: [S2-1] PelvisIKFootSolver.Solve, [S2-2] bCompensateIKUsingFKThighRotation, [S2-3] bClampIKUsingFKLimits, [S2-4] ClampedFootLocation.

### R

INFERENCE — the code does not name our room. For two men slid 3–30 cm along a line at 0–0.3 m/s, playing in-place walks at 1.74 m/s:

**Offset Root Bone** in Interpolate mode, TranslationHalflife = 0.1 s: the 3–30 cm body slides produce an offset that decays in ~0.5 s (5 halflives). With `bClampToTranslationVelocity = true` and TranslationSpeedRatio = 0.5, catch-up is capped at 0.5 × root-motion speed — but our walks are in-place (no root motion along the slide axis), so the offset does NOT decay during the slide. The mesh lags the capsule smoothly instead of jerking. When the slide stops, the damper catches up over ~0.5 s.

**Stride Warping** in Graph mode: body speed 30 cm/s, walk root-motion speed ≈ 174 cm/s → StrideScale ≈ 0.17. Feet barely leave their scale origin — the walk becomes a shuffle, correct for a body barely moving. Below MinRootMotionSpeedThreshold (10 cm/s), stride snaps to 1.0 (natural).

For the punch-dash (28 cm over 0.25 s ≈ 112 cm/s): StrideScale ≈ 0.64, steps shorten to 64 %. Offset Root Bone absorbs the 28 cm gap over ~0.5 s. Combined: Offset Root Bone removes the jerk, Stride Warping shortens steps. Feet stay on the floor.
