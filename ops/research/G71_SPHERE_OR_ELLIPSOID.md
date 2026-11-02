# G71 — "AN ELLIPSOID DOES NOT EARN A ROW": NO ENGINE SHIPS ONE, AND THE SPHERE WE SHIPPED IS THE LESS-BAD SPHERE

**Agent:** Grok (grok.com, Expert mode, in-app browser, driven from this console).
**Landed by Claude, S53, 2026-09-22.** 25 minutes of work, **37 sources**.
**Task:** `TASK_G71_SPHERE_OR_ELLIPSOID.md`. It had no checkout, no Godot and no
repository; everything it used was in the brief or found by search.

## THE ONE SENTENCE

> **"(c) Do not add an ellipsoid."**

And the part that defends what S53 shipped, arrived at blind and against the
grain of the question it was asked:

> *"Using lateral as the sphere radius would be **worse**: jabs and crosses would
> pass through the face. **Face under-coverage is more visible than temple
> over-coverage.** That is why the shipped p80/sag choice is the less-bad
> sphere, not a free lunch."*

## Q1 — WHAT THE OVERSIZED SPHERE COSTS, RANKED BY WHAT A VIEWER SEES

Temple overshoot is `sag − lat`: **2.6 cm to 6.4 cm** across the rigs, about
3.5 cm on the reference-sized ones. Contact normals radiate from the skull
centroid, *"so a hook meets a surface that is both early and more frontal than
the real temple."*

1. **Hooks and temple strikes tick early.** The glove stops a glove-width short
   of the mesh, or a glance scores as a clean temple shot. *"Head contact is the
   money shot. This is the visible defect."*
2. **Head-to-head false contact.** Two sagittal spheres steal `2(sag − lat)`
   ≈ **5–13 cm** of lateral clearance, so clinch, slip-past and stacked heads
   bounce when they should slide. Visible, less frequent.
3. **Collar-tie / neck grab blocked** by phantom temple volume. Visible only
   when grab IK or clinch attach fails.

Its own verdict on the ranking: *"(1) does change the picture, but it is
centimetres at broadcast framing, not a tunnel through the face."*

## Q2 — WHAT AN ELLIPSOID COSTS, AND EXACTLY WHERE THE CHEAP TRICK BREAKS

| approach | cost per pair per iteration | implementation risk |
|---|---|---|
| exact iterative (Newton on the quadric) | 10–30 small linear solves, **~50–200×** a capsule pair | high — grazing, local minima, must survive hundreds of solver iterations |
| support mapping / GJK (+ EPA for depth) | 5–15 support evaluations, **~10–40×** a capsule pair | medium — ellipsoid support is closed-form; EPA is the ugly half |
| affine map ellipsoid → unit sphere | intersection cheap and valid; **distance, closest points, depth and normal are not** | high, if used as a distance solver |
| polytope stand-in (12–24-vertex hull, then GJK/SAT) | more than analytic GJK, plus 2–5 mm facet error | low maths, medium wiring |

**THE AFFINE TRICK, AND WHY IT IS A TRAP — this is the most useful paragraph in
the memo:**

> *"Non-uniform scale `S` turns the ellipsoid into a sphere. **The same `S` turns
> the other capsule into an elliptic cylinder with ellipsoidal caps — not a
> capsule.** Segment–segment in that space is therefore the wrong primitive and
> the wrong metric: closest points of the scaled shapes are not the Euclidean
> closest points. Depth is not the back-transformed gap. The contact normal must
> go through `S⁻ᵀ` and be re-unitised; skip that and hooks get a sheared normal.
> Intersection tests survive — an invertible affine preserves overlap. **The
> solver here is not an overlap test.** It drives bodies until declared contacts
> touch and nothing interpenetrates. That needs Euclidean depth and a Euclidean
> normal. Affine does not give them. Treating the sheared capsule as still a
> capsule is the usual silent bug; error scales with the axis ratio, 1.3–1.7 on
> these rigs."*

## Q3 — THE NEGATIVE RESULT, WHICH IS THE ONE TO ACT ON

**None of Chaos, PhysX as Unity exposes it, Bullet or Havok gives a character or
ragdoll pipeline a first-class ellipsoid primitive.**

- **Chaos:** sphere, capsule, box, tapered capsule, convex, level set. Physics-
  asset autogen is the first four. No ellipsoid.
- **PhysX:** sphere, capsule, box, plane, convex, mesh, heightfield. PhysX 5
  added `PxConvexCore::Ellipsoid` as a **core-plus-margin convex — not a
  character primitive and not what Unity exposes.**
- **Bullet:** no ellipsoid. The documented workaround is `btMultiSphereShape`
  plus non-uniform scale — *"the same affine lie as Q2."*
- **Havok:** sphere, capsule, box, cylinder, convex, mesh. No ellipsoid in the
  public create API.

> *"They omit it because the narrowphase is a closed-form pair table, characters
> are already capsules and spheres, and **an ellipsoid does not earn a row**."*

## Q4 — THE RECOMMENDATION, AND ITS FALLBACK

**Do not add an ellipsoid.** Represent the head as a **short sagittal capsule**:
`r` = that rig's **lateral** half-extent, `p0`–`p1` along the measured sagittal
axis, length `2(sag − lat)`. *"Temples exact, face and occiput covered by the
caps, hot path unchanged, every number taken from that fighter's vertices so it
scales with stature."*

**Fallback**, if that reads as a bone-segment reject: keep the sphere, radius =
the **geometric mean of the three half-extents** (or the p50 vertex-to-centroid),
per rig. *"Never sag/p80, never a constant in metres."*

## ITS SELF-OBJECTION, AND ITS FLIP-MEASUREMENT

> *"The sagittal capsule is still not the skull. Vertical half-extent exceeds
> lateral on every rig and exceeds sag on f04/f07; a capsule with `r = lat` is
> short on the crown and the jaw. ... Temple overshoot on the shipped sphere is
> not '3.5 cm nobody will see': **the solver holds the whole upper body that far
> out on a hook, which is pocket distance, not a spark.** GJK for one shape
> against capsules is a known, bounded piece of work, not a week of research.
> Engines omit ellipsoids because they simulate crates and ragdolls, not a
> contact-driven striking solver whose only job is the head."*

**The measurement it names as the one that would flip its own answer:** a side-on
capture where, on two or more rigs, glove-to-rendered-mesh gap at the damage tick
on a clean hook **exceeds one glove width (~8–10 cm)** after the sagittal-capsule
or geometric-mean-sphere change is made. *"If that film exists, build GJK
ellipsoid–capsule and stop. Until it does, do not put a non-closed-form primitive
on the 225-pair inner loop."*

---

## THE COLLISION WITH OUR OWN BAND RULE, WHICH CLAUDE FOUND AND GROK ANTICIPATED

**G71's primary recommendation is classified `BALL` by the module S53 shipped
this afternoon, and would therefore be promoted straight back to a sphere.**

On f01: `r = lat = 0.0921`, `L = 2(0.1300 − 0.0921) = 0.0758`, so
**`r/L = 1.215` — `BALL`**, and `SPHERES_ON_LOAD` would collapse it.

Grok anticipated exactly this (*"if a sagittal capsule still reads as a
bone-segment reject"*) and its fallback covers it. But the collision is worth
more than the workaround, because **it names a real limitation in C164's
contract:**

> `BALL` means *"the radius has swallowed the segment"*, which is the right test
> for a capsule **DERIVED from two bone positions** — where `r > L` means the
> derivation produced something that was never a capsule. It is the **wrong**
> test for a capsule **DESIGNED with `r > L` on purpose**, where the short
> segment is doing deliberate work along a measured axis.

So if a designed short capsule is ever built, `CapsuleShape` needs to
distinguish **derived** from **authored**, or `SPHERES_ON_LOAD` needs to be a
property of the capsule's provenance rather than of its ratio. Nothing to do
today — the head is still promoted and nothing authored exists — but it is the
first real hole anyone has found in the band contract, and it was found by
taking two agents' answers seriously at the same time.

**Geometric mean on f01**, for whoever picks this up:
`(0.1300 × 0.0921 × 0.1330)^(1/3) = 0.1168 m`, against the **0.1256 m** shipped
today — about **7% smaller**. That is the fallback, it is one line in
`build_report`'s blob branch, and it has not been measured against exposure.
