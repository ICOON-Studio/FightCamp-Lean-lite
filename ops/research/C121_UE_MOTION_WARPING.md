## DECISIONS
For a punch, schedule a modifier over the attack's notify window `[StartTime, EndTime)` and name the opponent's warp target.
Use SkewWarp to bend the attacker's extracted root translation so the root reaches the target transform by the window end.
Keep `bIgnoreZAxis` enabled for a level boxing strike; this preserves the current Z position (centimetres).
Use `bWarpToFeetLocation` when the foot/root contact point, rather than the actor root, is the alignment point.
An in-place clip supplies no translatable root motion; the modifier then synthesizes a delta toward the target using the window blend.
Rotation can be Slerp, clamped Slerp, constant-rate, or scale; all rotation values below are degrees unless stated otherwise.

### W1
`UAnimNotifyState_MotionWarping` passes the animation, start time, and end time to create the modifier. Each update copies playback position, blend `Weight`, and play rate from the context. A Waiting modifier becomes Active when `PreviousPosition >= StartTime && PreviousPosition < EndTime`; it is removed at/past `EndTime`, and Active modifiers receive the update callback. On activation, code snapshots the current transform and extracts total root motion over the window. The effective window is animation time in seconds, not a distance or frame count.

Plain state/weight logic: `PreviousPosition = Context.PreviousPosition; CurrentPosition = Context.CurrentPosition; Weight = Context.Weight;` then `Waiting -> Active` inside `[StartTime, EndTime)`.

Citations: W1-notify, W1-update, W1-active.

### W2
SkewWarp extracts `RootMotionTotal` from `PreviousPosition` to `EndTime` and the frame delta to `min(CurrentPosition, EndTime)`. With animated translation, it transforms the target into mesh/root space, subtracts any configured remaining post-notify translation, then calls `WarpTranslation`. That function constructs a sync space along the remaining root-motion direction, computes the target-vs-root scale and yaw/pitch shear, and applies `ScaleMatrix * ShearXAlongYMatrix * ShearXAlongZMatrix` to the current delta. Thus successive deltas are scaled/sheared toward the remaining target so the accumulated root arrives at the target at the window end (translation units are centimetres).

`bIgnoreZAxis` sets target Z to current Z, and in sync space sets target Z to `0`; the clamp then uses 2D size. `bWarpToFeetLocation == false` zeroes the mesh translation offset's Z before target conversion, so alignment uses the actor/root location rather than the feet offset. If `MaxSpeedClampRatio > 0`, the result is clamped to `AnimationSpeed * MaxSpeedClampRatio`, using `Size2D` when Z is ignored and 3D `Size` otherwise; the ratio is dimensionless and speed is centimetres per animation second.

Plain core formula: `WarpedTranslation = WarpTranslation(I, DeltaTranslation, TotalTranslation, TargetLocation) + ExtraRootMotion.GetLocation();` then `|WarpedTranslation| <= |DeltaTranslation| * MaxSpeedClampRatio` (2D or 3D according to `bIgnoreZAxis`).

Citations: W2-extract, W2-skew, W2-options, W2-clamp.

### W3
When `bWarpRotation` is true, `WarpRotation` derives the target relative to the current rotation and the base visual offset. `RotationType::Default` matches the target rotation (plus `AdditionalRotationOffset`); `Facing` builds a rotation from the actor toward the target in the XY plane, also plus the offset. `RotationMethod::Scale` computes yaw/pitch degree differences and scales the animation delta, clamping each to `WarpMaxRotationRate * DeltaSeconds` degrees. Other methods interpolate with `Alpha = clamp((DeltaSeconds * PlayRate) / ((EndTime - PreviousPosition) * WarpRotationTimeMultiplier), 0, 1)`; non-Slerp methods cap the angular step at `abs(degrees-to-radians(DeltaSeconds * PlayRate * WarpMaxRotationRate))`. The resulting correction is multiplied onto the frame's root-motion rotation.

`WarpRotationTimeMultiplier` changes the time remaining used by Slerp/clamped Slerp (dimensionless); `WarpMaxRotationRate` is degrees per second. ConstantRate selects the target when within the cap and otherwise advances by the capped angle. `bWarpRotation` only gates this rotation path; paused root motion returns identity rotation, while paused warping returns the unwarped delta.

Plain interpolation: `Alpha = clamp((DeltaSeconds * PlayRate) / ((EndTime - PreviousPosition) * WarpRotationTimeMultiplier), 0, 1)`.

Citations: W3-target, W3-scale, W3-time, W3-cap.

### W4
The component exposes `AddOrUpdateWarpTarget`, plus helpers from a transform, component, location, or location-and-rotation. The target is found by `WarpTargetName`. A component target can follow its component (and optional bone/socket) while warping; the header warns this can be one frame late without tick prerequisites. On every active modifier update, code reads the target transform. If it changes, `CachedTargetTransform` is replaced and `OnTargetTransformChanged` resets the actual start time and current start transform, so the remaining warp retargets from the actor's current location/rotation.

Citations: W4-api, W4-follow, W4-read, W4-change.

### W5
The modifier needs an animation with extractable root motion: SkewWarp extracts total and per-frame root motion and bends that translation. If the clip has no translation in the window, code enters a separate add-motion path: it linearly blends from `StartTransform` to the target using the selected `AddTranslationEasingFunc`/curve, computes a frame delta, and adds any post-window root motion. Therefore an in-place clip gives the warp a target and timing but no translation trajectory to bend; the code synthesizes the approach instead (centimetres).

`bSubtractRemainingRootMotion` extracts root motion from `EndTime` to the animation's play length and subtracts its translation/rotation from the target calculation, making arrival occur at animation finish rather than notify end. `WarpPointAnimProvider` is not merely descriptive: `Static` or `Bone` causes code to calculate and cache the root-to-warp-point transform at `EndTime`, then apply it to the game target; `None` skips that animation point.

Citations: W5-root, W5-add, W5-remaining, W5-provider.
