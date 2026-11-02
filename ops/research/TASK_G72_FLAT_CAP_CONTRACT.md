# G72 — THE BLIND CONTRACT TEST FOR `CapsuleDistance.gd`

**Owner:** grok (Expert mode, NEVER Build). No checkout, no Godot, no repo.
**Deliverable: ONE GDScript file, pasted back as text in your reply.**

## THIS IS A BLIND TEST AND THAT IS THE ENTIRE POINT

**The module does not exist yet. I am writing it right now, from the same
definition you are reading, and I will not see your test until mine is
finished.** Do not write the module. Do not write a reference implementation
"to check against" and paste it. Write the TEST.

**You are being given a geometric DEFINITION, not a formula.** That is
deliberate. A test written from someone else's formula only ever agrees with
that formula — including its bugs. Derive whatever arithmetic you need yourself,
from the shape described below, and pin exact expected numbers you computed by
hand.

**The most valuable thing you can do is find a case where the definition below
is AMBIGUOUS or CONTRADICTS itself.** That has happened twice on this project
and both times it was worth more than the test. If you find one, write the row
anyway, mark it, and say so at the top of your reply.

## THE SHAPE — READ THIS TWICE, IT IS NOT A CAPSULE

A **capsule** (what we have today) is a cylinder with a HEMISPHERE glued on each
end. Every point within `r` of either endpoint is inside it.

**This module is about the other solid: a FLAT-CAPPED cylinder.** Take the
segment from `p0` to `p1`. Sweep a disk of radius `r` along it, perpendicular to
it. Close each end with a **flat planar disk**, perpendicular to the axis, at
`p0` and at `p1`. No hemisphere anywhere. The top boundary is a **disk at `p1`**,
not a dome through it.

It is a right circular cylinder, closed, treated as a **solid** (its interior
counts as inside).

**Why we are building it:** our chest capsule's hemispherical top cap bulges a
full radius upward from the Neck bone — about 0.14 m, which is the entire length
of a human neck — so the neck is buried inside the chest and nothing can reach
it. A rib cage is a tapered truncated enclosure, not a barrel with a dome on
top. The flat cap is the cheapest possible test of whether the dome's *maths*
was the blocker or the chest's *geometry* was.

## THE MODULE UNDER TEST

`Godot/scripts/CapsuleDistance.gd`. Every function `static`. Zero preloads, no
scene, no autoload, no rig — pure arithmetic over `Vector3` and `float`.

```gdscript
static func flat(q: Vector3, p0: Vector3, p1: Vector3, r: float) -> float
```
The **exact Euclidean signed distance** from the point `q` to the flat-capped
cylinder described above.

- `q` outside the solid → **positive**, the distance to the nearest point of the
  solid's surface.
- `q` inside the solid → **negative**, minus the distance to the nearest surface
  point.
- `q` exactly on the surface → **0.0**.

```gdscript
static func dome(q: Vector3, p0: Vector3, p1: Vector3, r: float) -> float
```
The same signed distance to the ORDINARY CAPSULE (hemispherical caps) — the
shape we have today. It is here so the two can be compared in one place.

### The degenerate cases, decided — these are part of the contract

- **`p0 == p1` → BOTH functions describe a SPHERE of radius `r` centred there,
  and must return the same value.** A zero-thickness disk is not a body part,
  and this codebase promotes the head capsule to a sphere on load, so
  `p0 == p1` is the NORMAL case here, not an exotic one. It must not divide by
  zero and must not return `NAN`.
- **`r <= 0` → treat `r` as `0.0`.** The solid degenerates to the segment
  itself, and both functions return the distance from `q` to that segment.
- **Neither function may EVER return `NAN` or `INF`** for finite inputs. Assert
  this on every row you write; it is the cheapest check here and the one most
  likely to catch a real defect.

## THE INVARIANTS — these are the rows that matter most

**1. THE SUBSET INVARIANT.** The flat-capped cylinder is entirely CONTAINED
inside the capsule with the same `p0`, `p1` and `r` — you cannot add volume by
removing the domes. Therefore, **for every point `q` in space,
`flat(q, ...) >= dome(q, ...)`.** Assert it across a wide grid of points:
inside, outside, above, below, beside, far away, and right at the boundary.
**If your test does not contain this, it has missed the strongest check
available.**

**2. THE BARREL IDENTITY.** For any `q` whose nearest approach is on the
cylindrical side — that is, `q` lies strictly between the two end planes —
**`flat(q, ...)` and `dome(q, ...)` are EQUAL.** The two solids differ only at
the caps. Build points that are clearly in that zone and assert equality to
`1e-6`. Then build points clearly past an end plane and assert the two are
**different** — an identity that holds everywhere is testing nothing.

**3. SYMMETRY.** Swapping `p0` and `p1` must not change either answer for the
same `q`. A distance to a solid does not know which end you named first.

**4. RIGID-MOTION INVARIANCE.** Translate `q`, `p0` and `p1` by the same vector,
or rotate all three about the same point, and both answers must be unchanged to
`1e-5`. This catches an implementation that has quietly assumed the axis is the
Y axis — which is exactly the shape of bug a hand-derived formula produces.

## ROWS YOUR TEST MUST CONTAIN — beyond the four invariants

Put an exact expected number on each of these, computed by hand from the
geometry. State the arithmetic in a comment on the row so a reader can check
your hand-computation without rebuilding it.

1. **Straight up the axis.** `q` on the axis line, a height `h` above `p1`.
   `flat` is exactly `h`. `dome` is `h - r`. **This is the whole point of the
   change** — pin it with `r = 0.14`, `h = 0.10`, and note that the dome reads
   this point as INSIDE (negative) while the flat cap reads it as 0.10 outside.
2. **On the top disk, inside the rim.** `q` in the top plane, at radial offset
   `d < r` from the axis. `flat` is `0.0` — it is on the surface.
3. **On the top plane, outside the rim.** Radial offset `d > r`, still in the
   top plane. `flat` is `d - r`.
4. **THE RIM QUADRANT — THE ROW THAT SEPARATES A CORRECT IMPLEMENTATION FROM A
   PLAUSIBLE ONE.** `q` both ABOVE the top plane and OUTSIDE the rim radius.
   The nearest point of the solid is on the **rim circle** — the edge where the
   barrel meets the top disk. Work out that distance yourself and pin it. **A
   wrong implementation will hand back the distance to a sphere centred at
   `p1`, which is smaller.** Use `r = 0.14`, radial offset `0.20`, height above
   the plane `0.20`, and give the exact expected value to six decimals. Write at
   least three rows in this quadrant at different offsets.
5. **Deep inside.** `q` at the solid's centre. The answer is negative and its
   magnitude is the distance to the NEAREST surface — which may be a cap or the
   barrel, whichever is closer. Build one case where the cap is nearer and one
   where the barrel is nearer, and pin both.
6. **Just inside a cap** and **just inside the barrel** — both negative, both
   small, and the signs must not flip.
7. **The sphere case** (`p0 == p1`): `flat` and `dome` agree; a point at
   distance `d` from the centre reads `d - r`.
8. **`r = 0`**: both are the plain point-to-segment distance, clamped to the
   segment — so a point beyond an end measures to that ENDPOINT, never to the
   infinite line. Include a point beyond each end.
9. **A far-away point**, several metres off, where both answers are large and
   nearly equal — a sanity row that catches a sign error at scale.

## THE FILE — exact shape, because it runs in a harness you cannot see

`Godot/tests/capsule_distance_contract_test.gd`.

```gdscript
extends SceneTree

func _initialize() -> void:
    var M: GDScript = load("res://scripts/CapsuleDistance.gd") as GDScript
    if M == null:
        print("SKIP: CapsuleDistance.gd is absent - this contract test is blind"
            + " and the module has not been written yet.")
        print("SUITE total=0 fails=0")
        quit(0)
        return
    # ... your checks ...
    print("checks=%d checks_failed=%d" % [checks, bad])
    print("SUITE total=1 fails=%d" % (1 if bad > 0 else 0))
    quit(0 if bad == 0 else 1)
```

**`load()` INSIDE `_initialize()`, never a top-level `preload`** — a top-level
preload of a missing script is a compile error and hangs the harness instead of
skipping.

**Call the statics through `Callable(M, "flat").call(...)`**, and **type every
result**: `var d: float = float(Callable(M, "flat").call(q, p0, p1, r))`.

### THE TRAP THAT HAS CONDEMNED FOUR PASSING TESTS ON THIS PROJECT

Our runner reads the LOG for self-reported failure. **Any line starting `FAIL`
or `FAILED`, any `failures=N` with `N > 0`, and any `N failure(s)` marks the
test RED even when it exits 0 and even when it passed.**

So: **never print the words `FAIL`, `FAILED`, `failures=` or `failure(s)`.**
Report with **`checks=` and `checks_failed=`**. When a row is wrong, print
`BAD row <n>: expected <x> got <y>` — that vocabulary is safe.

### THE OTHER GDSCRIPT TRAPS, WHICH COST A FIX CYCLE EACH

- `var x := <call>` **fails when the call returns Variant** — and a static on a
  `load()`ed script always does. **Write the type**: `var d: float = ...`.
- **Reusing a variable name inside one function is a parse error**, even across
  separate `if` or `for` blocks. Give every loop and every row its own names.
- `%` inside a format string must be `%%`.
- Godot 4.7 GDScript. `Vector3(x, y, z)`, `.length()`, `.normalized()`,
  `.dot()`, `.cross()`, `.distance_to()`, `absf()`, `maxf()`, `minf()`,
  `sqrt()`, `is_nan()`, `is_inf()`, `is_equal_approx()`.
- **Do not use `is_equal_approx` for a tolerance you care about.** Its tolerance
  at 0.926 is about 9.3e-6, which is tighter than a table quoted to three
  decimals — that condemned 6 rows of a previous contract test here. Compare
  with an explicit `absf(got - want) <= 1e-6` and name the epsilon.

## WHAT YOU DO NOT HAVE, SO DO NOT REACH FOR IT

No repository, no Godot, no ability to run this. **Do not attempt to clone
anything and do not ask for repo access** — you have neither a token nor a
checkout, and the repo is 1.7 GB and private. Write the file, reason the numbers
out by hand, and paste it as text. I run it here.

Do not `preload` anything. Do not reference `FighterCapsules`, `ApproachBand`,
`FightPoseSolver` or any other project file — this test touches
`CapsuleDistance.gd` and nothing else.

## NOW ARGUE AGAINST YOURSELF

After the file, in **at most twelve lines**, answer this:

**"What is the strongest case that the flat cap is the WRONG shape for a human
chest, and what single measurement would settle it?"**

The agent who proposed the flat cap attacked her own answer and was right to:
*"flat caps fail the shoulder girdle — grazing the shoulder will now CATCH
instead of sliding"*, and harder, *"we are editing the body to please the
metric. When the shoulder blocks the clavicle, will we flatten the shoulder
too?"*

**Take that seriously rather than reassuring me.** If you think she is right,
say so plainly. Name ONE measurement — something computable from a rig's own
skin vertices and its capsules — that would decide it. One measurement, not a
programme of work.
