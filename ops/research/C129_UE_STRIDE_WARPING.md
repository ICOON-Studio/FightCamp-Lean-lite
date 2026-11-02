## DECISIONS
- Stride warping scales a locomotion foot's horizontal reach; it is not a contact detector.
- Unreal's distances and speeds here are centimetres and centimetres/second.
- Graph mode needs an accumulated root-motion attribute; missing data may return before any warp.
- The pelvis solver preserves FK pelvis-to-foot distances as reach targets, then smooths and caps its move.
- For our jab, 0.5x is a reasonable experiment, but the node's looped-foot/root-motion assumptions are INFERENCE risk.

### S1
It needs valid IK-foot, FK-foot, thigh, pelvis and IK-foot-root references. Manual mode uses `StrideScale`; Graph mode extracts root motion, uses its direction, and computes `LocomotionSpeed / RootMotionSpeed`. With no root-motion attribute, `bDisableIfMissingRootMotion=true` returns without warping; if false, evaluation continues with the manual direction and the initial scale (INFERENCE for exact fallback semantics). A present but zero/slow root-motion speed sets scale to 1.0, then the modifier may interpolate it. Units: scale is dimensionless; speeds are cm/s; bone positions are cm. Citations: S1a, S1b, S1c.

### S2
For each IK foot, let `P=IKFootLocation`, `T=ThighLocation`, `N=FloorNormal`, `G=GravityDirection`, and `D=ActualStrideDirection`. The code intersects the line `T -> T+G` with the floor plane through `P`; if gravity is parallel to the floor it uses `P`. It then projects `P` onto that plane along `D` to get `O`, and writes `Warped=P0+(P-O)*ActualStrideScale`. Thus the foot target moves along the floor-parallel stride direction about a per-leg origin derived from the thigh, foot and floor—not about the pelvis or IK-foot-root. Units: P/T/O/Warped are component-space cm; N/G/D are unit directions; scale is dimensionless. Citations: S2a, S2b, S2c.

### S3
The node measures each FK foot's original pelvis distance `r_i`, collects each warped IK target `q_i`, and calls the solver. Each iteration computes `ideal_i=q_i+normalize(prePelvis-q_i)*r_i`, averages all ideals equally, and stops after `PelvisAdjustmentMaxIter` or when the change is at most `PelvisAdjustmentErrorTolerance`. It spring-updates the displacement, blends it by `PelvisAdjustmentInterpAlpha`, and caps displacement at `PelvisAdjustmentMaxDistance`; it writes only the pelvis location in the returned component-space transform. Defaults are alpha 0.5, max distance 10.0 cm, tolerance 0.01 cm, max iterations 3. Citations: S3a, S3b, S3c.

### S4
When `bCompensateIKUsingFKThighRotation` is true, the thigh is first translated by the pelvis offset, then rotated from the original FK thigh-to-foot direction to the adjusted-thigh-to-warped-IK-foot direction. When `bClampIKUsingFKLimits` is true, if adjusted-thigh-to-IK distance exceeds the original FK thigh-to-foot length, the IK target is replaced by `adjustedThigh + targetDirection * FKLength`. Units: all lengths are cm and rotations are quaternions; the booleans are switches. Citations: S4a, S4b.

### S5
1. Cache each IK-foot transform and resolve component-space floor/gravity directions.
2. Resolve scale (manual or Graph), apply the scale modifier, and in Graph mode scale/override root motion.
3. Warp every IK foot target.
4. Solve and append the pelvis transform.
5. Optionally append translated/rotated thighs and clamp the pending IK targets.
6. Append final IK-foot transforms, then sort `OutBoneTransforms` by compact pose index.
All writes are `FBoneTransform`s in component space: pelvis, optional thighs, then IK feet. Citations: S5a.

### FOR OUR STEPPING JAB
For a frame with the node's scale set to 0.5, the front IK foot is projected to its floor-parallel origin and its offset from that origin is halved; the rear foot is treated identically, so it also halves any stride-direction offset (not necessarily zero movement). The pelvis solver then pulls the pelvis toward the warped targets while trying to retain each original FK pelvis-to-foot distance, smooths it, and caps the displacement at 10.0 cm by default. If enabled, each thigh follows the pelvis offset and rotates toward its warped target; FK-length clamping prevents over-extension. The node also scales Graph root motion, but an isolated jab's one-step timing, planted-foot phase, glove reach, opponent reaction, and whether 0.5 gives the desired 0.13 m hip move are INFERENCE: this locomotion code does not decide them.
