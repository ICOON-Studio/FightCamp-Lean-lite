## DECISIONS
Use the extension correction: pull/roll the foot toward the hip, then clamp the remaining target to max reach; do not unplant because of extension.
Pelvis solve uses the code's all-leg aggregate; heel lift is 0.5 of the capped foot-length correction, horizontal limit is 10, vertical cap is 50, then spring 350/1.
Mirror in object/component-reference space across the table's MirrorAxis, with the per-bone rest-rotation correction.

### A1
`MaxExtensionRatio` is the fraction of remaining reach slack: `DesiredExtension + (LimbLength - DesiredExtension) * MaxExtensionRatio`, unless desired already exceeds L, when it returns desired. `MinExtensionRatio` is `min(DesiredExtension, LimbLength * MinExtensionRatio)`. The functions are `GetMaxLimbExtension` and `GetMinLimbExtension` (A1). A planted foot beyond the computed max is not unplanted: finalization rolls/pulls it toward the hip and then projects it to the max-extension sphere if needed (A1).

### A2
The solver first optionally rebalances horizontally: remove the approach-direction component of the mean aligned-foot offset and multiply by `HorizontalRebalancingWeight`. For each leg it computes desired, max, and min pelvis offsets; `MaxOffsetHorizontal` limits horizontal foot adjustment in the range search, while `MaxOffset` caps the interpolated 3D target. `HeelLiftRatio` moves the IK target toward the FK foot by `min(distance, FootLength) * HeelLiftRatio` before that range search. The final vertical solve is `DesiredOffsetMin + (MinToAvg * MinToMax) / (MinToAvg + MinToMax)` (or the minimum when the divisor is nearly zero), clamped between the aggregate min/max. The target is root-space spring-interpolated with `LinearStiffness` and `LinearDamping` (350 and 1 by default), and the code can overshoot the cap during interpolation. Although the header exposes `PelvisHeightMode`, the `.cpp` never reads it; its loop is over every leg (A2).

### A3
`PivotAroundBall` holds the ball: it builds the ball in world space, creates a transform with the prior foot's ball location `(FootToBall * LastPlantTransformWS).GetLocation()` but the current ball rotation, then converts back through `BallToFoot`. During final alignment, the ankle twist is extracted about the foot-to-ball direction and the aligned rotation is multiplied by a slerp from identity to that twist using `AnkleTwistReduction` (0.75 default). (A3.)

### A4
At each update, `WantsToPlant` first refuses `Unlocked`/zero lock alpha, then requires plant distance `< DistanceToGround` and speed `< SpeedThreshold`; a missing speed curve defaults to `SpeedThreshold`, so it does not pass the strict test. If previously planted, `DeterminePlantType` tests translation radius first, then twist angle; either exceeded condition leaves the type unplanted. If not previously planted and wanted, it plants immediately; otherwise replant requires location within the squared replant radius AND twist within the replant angle. Curves therefore act before radius/angle: disable-leg is recorded, while disable-lock changes lock alpha. Extension is not a plant-state test; it only marks unreachable and corrects the transform in finalization. (A4.)

### B1
`MirrorPose` transforms local translation/rotation into the source parent’s component/reference space, applies `MirrorVector`/`MirrorQuat` across `MirrorAxis`, applies the target-bone rest correction, and transforms back through the target parent. For a source bone `S`, target `T`, parents `Ps/Pt`, and component-space reference rotations `Rs,Rt,RPs,RPt`: `T' = RPt^-1 * MirrorVector(RPs*Tlocal)`; `Q' = RPt^-1 * MirrorQuat(RPs*Qlocal) * (MirrorQuat(Rs)^-1 * Rt)`. Scale is unchanged. The quaternion reflection is the standard axis-plane reflection: X axis `(x,-y,-z,w)`, Y `(-x,y,-z,w)`, Z `(-x,-y,z,w)`. (B1.)

### B2
The mirror table creates reciprocal left/right indices, and `MirrorPose` swaps a pair by computing both new transforms before assigning either. A self-mapped unpaired bone is mirrored in place with itself as source and target; a bone with no table partner remains untouched because neither non-root branch applies. The root is handled separately: if its mirror index is valid, its translation is mirrored and its rotation receives the root reference correction; otherwise it is unchanged. (B2.)

### B3
`AnimNode_Mirror` calls `FAnimationRuntime::MirrorPose` with the table axis, compact mirror map, and component-space reference rotations. Root translation is therefore mirrored by `MirrorPose`; the node does not separately rewrite root motion in `MirrorPoseInPlace`. (B3.)
