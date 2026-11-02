## DECISIONS
Use Dead Blending's per-component velocity clamp: 500.0 cm/s translation, 360.0 degrees/s rotation (converted to radians/s for math), and 4.0 scale-units/s; half-life is `Clamp(H*destination_delta/velocity, Hmin, Hmax)`.
Its default duration is 0.25 s, multiplied by `BlendTimeMultiplier`, with the configured `EAlphaBlendOption` curve; use a request/profile unless defaults are forced.
Inertialization uses a quintic offset that reaches zero with zero first and second derivatives; an away-pointing initial velocity is clamped and the duration may be shortened to prevent overshoot.
Interrupted inertialization stores the unspent duration as deficit and subtracts it from subsequent requests; concurrent requests merge by the minimum duration, per bone.

### D1
Dead Blending extrapolates outgoing bone translation, rotation, and scale, plus curves; root motion is extrapolated as translation/rotation/scale delta velocity when a root-motion provider is present. Bone velocity is `(current outgoing sample - previous outgoing sample) / current sample DeltaTime`; rotation uses shortest-arc rotation-vector velocity, and scale is linear or log/exponential according to `bLinearlyInterpolateScales`. For a channel with decay rate `C = ln(2)/half_life`, translation is `p + (v/C)*(1-exp(-C*t))`; rotation applies the analogous rotation vector, and exponential scale multiplies `exp((v/C)*(1-exp(-C*t)))` by the starting scale. [D1a, D1b]

### D2
For each translation, rotation, and scale component, the half-life is `Clamp(H * (destination - source) / clipped(source_velocity), Hmin, Hmax)`, so the quantity selecting between minimum and maximum is the destination delta divided by the outgoing velocity, component by component. The per-bone velocity clamps are 500.0 cm/s for translation, 360.0 degrees/s for rotation (converted in code to radians/s), and 4.0 scale-units/s. These clamps occur on bone velocities; the shown root-motion velocities are not passed through these three clamps. [D2a, D2b]

### D3
The blend weight is `1 - AlphaToBlendOption(clamp(elapsed_time / max(duration, epsilon), 0, 1), blend_mode, custom_curve)`: it lerps the incoming pose toward the extrapolated outgoing pose. Durations are the shortest tagged request, multiplied by `BlendTimeMultiplier`; a request blend profile fills per-bone durations, otherwise the default profile does, and forced defaults use `BlendTimeMultiplier * DefaultBlendDuration` (0.25 s default). Curves use the same configured mode/custom curve and duration. [D3a, D3b]

### D4
On a new request, the next transition records the node's current output snapshots. Since the snapshot is written after the active blend's `ApplyTo`, the outgoing pose becomes the already blended current output, not the original pre-blend source. [D4a]

### I1
`CalcInertialFloat(x0,v0,t,t1)` returns a quintic `x(t)=A*t^5+B*t^4+C*t^3+D*t^2+v0*t+x0`, with `a0=max(0,(-8*t1*v0-20*x0)/t1^2)`, and coefficients `A=-0.5*(a0*t1^2+6*t1*v0+12*x0)/t1^5`, `B=0.5*(3*a0*t1^2+16*t1*v0+30*x0)/t1^4`, `C=-0.5*(3*a0*t1^2+12*t1*v0+20*x0)/t1^3`, `D=0.5*a0`. It reaches zero with zero velocity and acceleration. If the initial velocity points away (`v0 > 0` after sign normalization), code sets it to zero; for a sufficiently negative velocity it shortens `t1` to `min(t1,-5*x0/v0)` so the offset cannot overshoot below zero. [I1a, I1b]

### I2
When active inertialization is interrupted, the code records `InertializationDeficit = InertializationDuration - InertializationElapsedTime` and applies the prior deficit to reduce the next duration. Each request resolves to `max(request.Duration - AppliedDeficit, 0.0 s)`; multiple requests then merge using the minimum overall duration and minimum per-bone duration (profile-derived where supplied). `InertializationMaxDuration` is the maximum of the main duration and all per-bone durations, controlling deactivation. [I2a, I2b]

### I3
Both nodes handle root motion only through the root-motion provider: Dead Blending blends an extrapolated root translation/rotation/scale delta, while Inertialization applies the root velocity-difference offset using the root bone's duration. A bone absent from either required pose is omitted from the recorded index map and skipped by `ApplyTo`; it is therefore left to the incoming pose. [I3a, I3b]
