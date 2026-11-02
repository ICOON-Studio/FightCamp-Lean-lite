# The file you sent does not run. I repaired it and ran it anyway.

Two bugs, both of which opening the file once would have caught.

**1. It throws before any pose is selected.** The `LIMBS` table writes `jnt:`,
and `buildCapsules` reads `def.joint`:

```
head: { …, parent:'torso', jnt:[0,0.85,0] }        // written
const joint = new THREE.Vector3(...def.joint)      // read
```

`Uncaught TypeError: def.joint is not iterable` at line 654 — the initial
preview call. The page renders the mat and nothing else.

**2. The directional light is never added.** Line 562:

```js
scene.add(new THREE.DirectionalLight(0xffffff, 1.2).position.set(3,4,2));
```

`.position.set()` returns the `Vector3`, so that adds a vector to the scene.

So the thirteen-row table in your reply did not come from running that file.
I need you to not do that again: if a number is in the report, it came off a
run, and if it did not run, say so. A crash reported honestly costs me two
minutes; a fabricated table costs me the whole verification.

## What your file actually does, repaired

I changed `def.joint` → `def.jnt` and hoisted the light. Nothing else.

| pose | you reported | actual |
|---|---|---|
| Collar Tie | pen 0.0000, grip 0.0006, PASS | pen **0.0928**, grip **0.2775**, FAIL |
| Sprawl | hold lift 0.0000, "grounded ✅" | hold lift **0.3883** |
| Front Headlock | hold lift 0.0000, "grounded ✅" | hold lift **0.0789** |
| Closed Guard | PASS | **FAIL** (pen 0.0119) |
| Rear Naked Choke | PASS | **FAIL** (pen 0.0309) |

Claimed 6 passes, actual 3.

## Credit where it is due — two of the three fixes are real

**All-pairs penetration is implemented correctly.** Your `pen` now equals my
independent all-pairs audit on every single row. That is exactly right, and it
is *why* closed guard and rear naked choke now fail — the honest measurement
catches what declared-contacts-only scoring was hiding. Do not undo that.
Dropping `mob` was also right.

## The one thing to fix: a shoulder is TWO angles, not one

```js
// Apply rotation around joint — single angle = Y-axis at shoulder
const q = new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0,1,0), limbRot);
```

A rotation about **Y** swings the arm **horizontally**. It cannot raise a hand
to neck height — which is the entire content of a collar tie. That is why the
pose did not land.

It also means three of your nine limb DOFs are dead weight: `head`, `neck` and
`torso` sit on the Y axis through their own joint, so their DOF moves the
geometry by **exactly zero**. `rLeg` and `back` move 7 mm.

I measured this on the repaired file — displacement from a 0.35 perturbation:

```
F1.pitch  0.34822    F1.limbs.rArm  0.09054    F1.limbs.head   0
F1.roll   0.34822    F1.limbs.lArm  0.09054    F1.limbs.neck   0
F1.yaw    0.13232    F1.limbs.rLeg  0.00696    F1.limbs.torso  0
```

**Give every limb two angles — azimuth and elevation — and preserve the segment
length exactly.** Rotate the rest direction by elevation about X, then azimuth
about Y, and place the distal end at `p0 + rotated_direction`. I tested exactly
this on your round-1 cost function and the collar tie went to `pen 0.0000,
grip 0.0006` — a full pass. It is the whole fix for that pose.

## Then, and only then, the spine

With two-angle shoulders the other seven poses floor at grip ~0.10–0.12 with
penetration 0.06–0.08 m. That floor is the rigid torso: a cylinder cannot put a
head outside a hip, flatten a back, or get a chest over a head. So after the
shoulders, split `torso` into two segments with a bend between them.

Do the shoulders first and send that. Do not do both at once.

## Before you send

**Open the file and press SOLVE on at least the collar tie.** If it throws, fix
it and try again. Report the numbers you actually see, and if a pose fails, say
it failed and name the pair that fights. I will run it here either way.
