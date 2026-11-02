# v4 — three changes, and the first one is why nothing else matters

Your solver runs and never converges on the ground positions, and the reason is
not the search. It is that the targets you are solving toward are impossible.

## 1. A CONTACT TARGET IS A SURFACE GAP, NOT A CENTRE DISTANCE

`measureContactError` compares `pA.distanceTo(pB)` against `cp.dist`, and both
are **centre-to-centre**. But the bodies are capsules with radius. Torso radius
0.14, arm 0.06, leg 0.07, head 0.11. So:

| pose | contact | target | radii sum | what it demands |
|---|---|---|---|---|
| sideControl / mount | torso↔torso | 0.05 | 0.28 | **0.23 m of overlap** |
| closedGuard | rArm↔torso | 0.10 | 0.20 | 0.10 m |
| closedGuard | rLeg↔torso | 0.12 | 0.21 | 0.09 m |
| armbar | rLeg↔rArm | 0.04 | 0.13 | 0.09 m |
| rearNaked | rArm↔neck | 0.04 | 0.17 | 0.13 m |
| mount | rLeg↔rHip | 0.06 | 0.14 | 0.08 m |

Every single one. **Reaching your target means burying one man inside the
other**, and your penetration metric cannot see it because it is
`dist < (cp.dist - cp.tol)` — a fraction of the authored target, never the radii.

Fix, and it is one line:

```js
const gap = segmentDistance(a.p0, a.p1, b.p0, b.p1) - (a.r + b.r) - (cp.off || 0);
```

`gap < 0` is interpenetration, by exactly that depth. `off` is the wanted
clearance in metres, `off: 0` means touching. Re-author every `dist:` as an
`off:` — for a torso-to-torso chest contact that is `off: 0.0`, not `0.05`.

**And measure capsule to capsule, not point to point.** `getWorldPosition`
returns a limb's CENTRE. Two crossed forearms have centres far apart and
surfaces touching. Use closest distance between the two SEGMENTS (Ericson
5.1.9); a point test cannot represent a limb.

## 2. THE SOLVER MUST BE ABLE TO MOVE THE ROOT

`solveContactsIterative` only ever writes `def.limbs[limb][3+axis]` — limb
rotations. But how the two bodies sit **relative to each other** is a root
problem: position and yaw. You cannot reach side control by rotating elbows.

Add the 6 root DOFs per body (x, y, z, yaw, pitch, roll) and solve them FIRST,
in their own phase, with the penetration term switched **off**. Placement and
overlap fight each other if you solve them together — get the bodies into the
right relative place, then resolve the overlap, then re-lock the root:

```
phase 1  root DOFs only, {pen: 0,   mat: 200,  touch: 6000}     ~2600 evals
phase 2  all DOFs,       {pen: 900, penMax: 4000, mat: 1200,
                          touch: 1200, touchMax: 5000, reg: 1e-4} ~9000 evals
phase 3  root DOFs only, phase-1 weights                          ~500 evals
```

`penMax` and `touchMax` are penalties on the WORST value, alongside the sums.
Without them a sum of squares happily trades one catastrophic overlap for a
dozen small ones, because it cannot tell the difference.

## 3. ONLY ACCEPT A MOVE THAT LOWERS THE COST

```js
const dir = Math.random()>0.5?1:-1;
def.limbs[limb][3+axis] += dir*STEP;     // never reverted
```

This perturbs at random and **never undoes a bad move**. Keeping a `bestState`
snapshot does not make it a descent — the working pose accumulates noise
regardless of whether cost improved. That is a random walk, and 200 of them is
nothing.

Use coordinate descent: for each DOF in turn, try `±{1, 0.4, 0.15} × step`, keep
only the best improvement, and when a whole sweep improves nothing, shrink the
step by ×0.45 and sweep again. Stop when step < 0.004. Budget ~12,000
evaluations per pose, not 200.

## 4. TWO SMALLER ONES

**The bone aliases hide errors.** `parts.neck = parts.head`,
`parts.back = parts.torso`, `parts.shoulder = parts.torso`,
`parts.rHip = parts.rLeg`. So `rearNaked`'s `torso→back` and a `torso→torso`
contact are literally the same measurement. Either give those parts real
capsules or delete the contacts that name them — an alias is not a fix.

**The mat must be per-capsule, on both bodies, inside the cost.** Right now each
fighter's root is clamped to the floor independently, before the solve:

```js
pose.F1.root[1] += MAT_SURFACE_Y - ly1;
pose.F2.root[1] += MAT_SURFACE_Y - ly2;
```

Moving the two men separately **changes the gap between them** — it breaks the
pair to fix the ground. And the solver then moves limbs afterwards with nothing
re-checking the floor. Make it a cost term: for every capsule of both bodies,
`low = min(p0.y, p1.y) - r`, and penalise `low < 0`.

## WHAT TO REPORT

Per pose, after solving: worst penetration depth in metres, worst contact error
in metres, worst mat violation in metres, and the evaluation count. Pass is
`pen ≤ 0.006`, `touch ≤ 0.012`, `mat ≤ 0.012`.

**Do not widen the tolerances to make a pose pass.** If a pose will not solve,
report its residual numbers and which capsule pair is the worst offender
(`penTx`-style, name both). A pose that needs its bounds relaxed has not passed,
and knowing which pair fights is what tells you whether the authored pose is
wrong rather than the solver.

## THE TEST THAT SETTLES IT

Start each ground pose from a deliberately BROKEN state — the two bodies
overlapping — and require the solver to dig out. A solver validated from an
already-good pose reports success for doing nothing.

Then orbit the camera through at least three azimuths (0°, 90°, 200°) on every
ground position. A pair that reads as contact from one angle and as two men in
separate rooms from another is framed, not solved.
