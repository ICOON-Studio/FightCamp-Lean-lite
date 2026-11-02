## DECISIONS

- Orientation Warping twists lower body toward movement and counter-rotates the spine so the upper body keeps facing.
- Steering rotates the root bone toward a target orientation via spring-damper on root motion.
- For the circling boxer, Orientation Warping alone handles head/chest-on-opponent with feet on the circle. INFERENCE:
  Steering is not needed because it rotates the whole body uniformly and would undo the head/torso split.

### W1

**Graph mode** extracts the root-motion delta translation, flattens it onto the rotation plane, and computes the warp
angle as the signed angle between root-motion direction and locomotion forward around the rotation axis [W1-line297].
If a `LocomotionDirection` vector is pinned, it is un-rotated into root-bone local space; otherwise `LocomotionAngle`
(degrees) is converted via `FQuat(RotationAxisVector, LocomotionAngleRadians)` [W1-line241].

**Manual mode** takes `OrientationAngle` in degrees directly.

**Distribution** (DistributedBoneOrientationAlpha, default 0.5):

- Root bone: `RootOffset = ActualOrientationAngleRad * DistributedBoneOrientationAlpha` [W1-line605].
- Each spine bone counter-rotates: `-ActualOrientationAngleRad * DistributedBoneOrientationAlpha * Weight` [W1-line629].
  Weights are assigned top-down so the chain sums to 1.0.
- IK foot root: `ActualOrientationAngleRad * (1 - DistributedBoneOrientationAlpha)` [W1-line639].
- IK foot bones: same magnitude, negated, so feet stay flat on the ground [W1-line660].

### W2

**RotationInterpSpeed** (default 10): `FInterpTo(Actual, Target, DeltaSeconds, RotationInterpSpeed)` [W2-line377],
clamped per frame to +/- `MaxCorrectionDegrees` (default 180) * DeltaSeconds [W2-line152].

**CounterCompensateInterpSpeed** (default 45): each frame the root-motion delta angle is accumulated into a target,
then `FInterpTo(0, target, DeltaSeconds, CounterCompensateInterpSpeed)` is added to the actual angle, preserving
animated root motion through the interpolation [W2-line340].

**Gates**:
- `MinRootMotionSpeedThreshold` (default 10 cm/s): below it, target snaps to 0 and interpolation eases back [W2-line277].
- `LocomotionAngleDeltaThreshold` (default 90 deg): if |warp angle| exceeds it, locomotion direction is inverted to
  avoid 180-degree over-rotation [W2-line293].
- `MaxRootMotionDeltaToCompensateDegrees` (default 45 deg): skips counter-compensation when the instantaneous root-motion
  delta exceeds it, treating it as a pivot [W2-line336].

### W3

**WarpingSpace** enum: `ComponentTransform` (default), `RootBoneTransform` (for use with OffsetRootBone),
`CustomTransform` (external pin) [W3-line22].

**RotationAxis** (default `EAxis::Z`): `GetAxisVector` maps X/Y/Z to unit vectors; all rotations use
`FQuat(RotationAxisVector, angle)` [W3-line153]. Default Z means yaw twist on the vertical axis.

### T1

Steering reads the root bone rotation, computes `DeltaToTarget = RootBoneRotation.Inverse() * TargetOrientation`,
then optionally samples the animation's predicted root motion over `AnimatedTargetTime` (default 2 s). If the predicted
yaw exceeds `RootMotionThreshold` (default 1 deg), the root-motion yaw is scaled by
`Ratio = clamp(YawToTarget / PredictedYaw, MinScaleRatio, MaxScaleRatio)` (defaults 0.5, 1.5) [T1-line147].
Remaining error is corrected by `CriticalSpringDamperQuat` over `ProceduralTargetTime` (default 0.2 s) [T1-line119].
`DisableSteeringBelowSpeed` (default 1 cm/s) gates the entire node [T1-line93].

### R

For a boxer circling at 0.3-0.9 m/s with forward/back/strafe walk clips, head and chest held on the opponent:

- **Use Orientation Warping in Manual mode.** Compute `OrientationAngle` = signed angle from actor forward to the
  vector toward the opponent (positive = opponent is to the right). Feed it to `OrientationAngle`.
- **DistributedBoneOrientationAlpha = 0.5** (default): root and IK feet take half the twist, spine counter-rotates
  the other half.
- **SpineBones**: list the spine chain (pelvis through upper chest). Weights auto-distribute to sum to 1.
- **IKFootRootBone + IKFootBones**: feet follow the circle direction; counter-rotation keeps them flat.
- **RotationInterpSpeed = 10** (default) smooths the transition; **MaxCorrectionDegrees = 180** (default) is generous
  enough for a 90-degree circle.

**Result**: head and chest (via spine counter-rotation) stay on the opponent; feet turn toward the circle direction
via the IK foot root. The walk clip plays sideways through the twisted lower body. INFERENCE: Steering is not needed
here because it would rotate the whole body uniformly, undoing the head/torso split that Orientation Warping provides.
