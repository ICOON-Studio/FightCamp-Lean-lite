## DECISIONS
Use the solver's hard reach clamp as the shipped safety rule; stretching is opt-in.
Use the node defaults: stretch off, 1.2 maximum scale, and component-space targets.
Drive alpha from a strike-contact bool, with a short blend-in and blend-out (INFERENCE).
Use the default HermiteCubic easing (unitless alpha, 0..1).
Put the moving fist target in Effector and a shoulder-relative elbow aim in JointTarget (INFERENCE).
When a target exceeds reach, the hand stops at the maximum reachable point unless stretching is enabled.

### I1
`SolveTwoBoneIK` measures the current upper and lower lengths, then treats `Effector - RootPos` as the reach vector. If its length is at least the (possibly stretched) sum, it places the end at `RootPos + MaxLimbLength * DesiredDir` and the joint at `RootPos + UpperLimbLength * DesiredDir`. Otherwise it solves a triangle: `cosA=(U²+D²-L²)/(2*U*D)`, `angle=acos(cosA)`, `side=U*sin(angle)`, `along=sqrt(U²-side²)` (negated when `cosA<0`), and `joint=Root + along*DesiredDir + side*JointBendDir`; the end remains the effector. Thus a too-close target folds/reverses the upper side when the cosine is negative; there is no separate minimum-distance clamp. A root-coincident effector uses a tiny length and +X direction. The joint target defines the bend plane by `DesiredDir ^ (JointTarget-Root)`; a parallel target gets best perpendicular axes, while a target at the root gets +Y bend and +Z plane normal.

Stretching is linear in reach ratio only between `StartStretchRatio` and `MaxStretchScale`: `s=(MaxStretchScale-1)*clamp((D/(U+L)-StartStretchRatio)/(MaxStretchScale-StartStretchRatio),0,1)`, then both U and L and their sum multiply by `1+s`. Units are centimetres for positions/lengths and unitless for ratios.

Citations: I1, I1, I1, I1.

### I2
The node converts EffectorLocation and JointTargetLocation through `GetTargetTransform` into component space; the default `EffectorLocationSpace` and `JointTargetLocationSpace` are `BCS_ComponentSpace`. It solves the component-space upper, lower, and end transforms. The upper rotation is a delta from old root-to-joint direction to new; the lower rotation is a delta from old joint-to-end direction to new. Their translations become the solved root/joint locations, and the end gets the solved translation.

The solver itself keeps end rotation. `bTakeRotationFromEffectorSpace` replaces it with the effector rotation only for bone/parent-bone space. `bMaintainEffectorRelRot` instead rebuilds it from the original local end transform times the solved lower component transform (and wins because it is the `else if`). With `bAllowTwist=false`, the node removes new twist along `TwistAxis` while retaining the original local twist; this follows the implementation even though the header describes the option as clearing twist.

Citations: I2, I2.

### I3
On update, Float computes `AlphaScaleBias(AlphaScaleBiasClamp(Alpha, dt))`; Bool computes `AlphaBoolBlend.ApplyTo(bAlphaBoolEnabled, dt)`; Curve reads `AnimInstance->GetCurveValue(AlphaCurveName)` and applies the clamp/scale-bias. The result is clamped to unitless 0..1. Below `FAnimWeight::IsRelevant(ActualAlpha)` the control is not updated/evaluated. When relevant, `LocalBlendCSBoneTransforms(BoneTransforms, clamp(ActualAlpha,0,1))` blends the solved component-space transforms with the incoming pose.

`FInputAlphaBoolBlend::ApplyTo` maps enabled to 1.0 and disabled to 0.0. On a bool change it sets blend time to `BlendInTime` when enabling or `BlendOutTime` when disabling, updates by delta time, and returns the eased blended value. Initialization applies the target immediately with zero blend time. Times are seconds; alpha is unitless.

Citations: I3, I3, I3.

### I4
For unitless input `a` (clamped output): HermiteCubic is `SmoothStep(0,1,a)` = `3a²-2a³`; Linear is `clamp(a,0,1)`; Cubic is `CubicInterp(0,0,1,0,a)` = `3a²-2a³`; Sinusoidal is `clamp((sin(a*pi-pi/2)+1)/2,0,1)`. `UE::Anim::DefaultBlendOption` is `HermiteCubic`.

Citations: I4, I4.

### I5
INFERENCE: In the punch graph, compute the opponent-head contact point each frame and feed it as the component-space Effector; feed a shoulder-relative point in the intended elbow-forward direction as JointTarget. Gate a Two Bone IK node with a bool that flips on shortly before contact and off shortly after, using short `BlendInTime`/`BlendOutTime`; the default HermiteCubic curve eases those unitless alpha transitions. The node then blends its solved component-space arm with the clip pose. If the moving target is outside the arm's reach, the documented solver clamps the wrist to full extension; enable stretching only if that behavior is desired (INFERENCE for graph design).

Citations: I5.
