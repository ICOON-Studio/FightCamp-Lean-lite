# Dola's v4 solver — it renders, it converges, and every pass is vacuous

**Delivered 2026-09-21 via `Tools/cici/cici.py` (no paste relay), saved verbatim
as `DOLA_V4_SOLVER_DELIVERED.html`, 15,598 bytes. Run here in the in-app browser
over `python -m http.server`.**

## What it got right, and it is the first draft that did

- **It renders.** Drafts 1-3 did not. Import map present, `OrbitControls`
  resolves, no undefined identifiers, no console errors.
- **Surface gap, not centre distance.** Zero `dist:` fields; every contact is
  `off: 0.00`. This was the defect that made every earlier draft's targets
  geometrically impossible.
- **Three-phase descent, faithfully.** `runPhase('Root Placement', …, false)` ->
  `runPhase('Full Refine', …, true)` -> `runPhase('Root Polish', …, false)`,
  probes at `±{1, 0.4, 0.15} × step`, `step *= 0.45` on a failed sweep, floor at
  0.004, budget 15,000.
- **Descent only.** `if (trial.cost < curr.cost)` — an uphill probe is never
  accepted. Draft 3 was a random walk that never reverted.
- **It reports the worst offending pair by name**, which is what tells you
  whether the pose or the solver is at fault.

Results, all five poses:

| pose | pen | touch | mat | evals | |
|---|---|---|---|---|---|
| sideControl | 0.0000 | 0.0001 | 0.0000 | 1505 | PASS |
| closedGuard | 0.0000 | 0.0003 | 0.0000 | 1508 | PASS |
| armbar | 0.0000 | 0.0002 | 0.0000 | 2375 | PASS |
| rearNaked | 0.0000 | 0.0003 | 0.0000 | **1508** | PASS |

## THE TELL: two different poses returned byte-identical results

`closedGuard` and `rearNaked` agree to the last digit **including the evaluation
count**. Two different problems cannot take the same number of steps by chance.

## Why: the bodies cannot bend, and most of the DOFs are inert

```js
function buildCapsules(state) {
  const T = new THREE.Vector3(state.x, state.y, state.z);
  const Y = state.yaw;
  for (const [name, def] of Object.entries(LIMBS)) {
    out[name] = { p0: rot(def.p0), p1: rot(def.p1), r: def.r, name };
  }
}
```

Every capsule is read from a FIXED module-level `LIMBS` table and only
translated and yawed **as one rigid block**.

Grepping every occurrence of `limbs` in the file gives 7 hits: it is created by
`zeroLimbs()` (263-264), cloned on copy (254), and listed as DOFs (286).
**It is never read.** `.pitch` and `.roll` likewise appear only in the DOF list.

So:

- **Effective DOFs are 8** — `x, y, z, yaw` × 2 bodies — not the "6 root
  DOF/body, 3-phase solve" the UI panel advertises.
- **Phase 2 is functionally identical to phase 1.** The limb and pitch/roll DOFs
  cannot change the cost, so the descent correctly rejects every one of them.
- **The pose table holds no joint angles at all** — each entry is
  `{x, y, z, yaw}` per body plus one or two contacts. `sideControl` and `mount`
  even share a display name.

**So every "pose" is two identical rigid statues slid and spun until one declared
capsule pair touches.** There is no armbar, no guard, no choke. Reaching
`pen = 0.0000` under those conditions is trivial, and it is why the numbers look
perfect.

## What it is nonetheless worth, and it is not nothing

**It is an independent confirmation of the cost function.** Surface gap with
radii subtracted, the three-phase schedule, descent-only acceptance, the
per-capsule mat term and worst-pair reporting all converge to sub-millimetre on
a real search, in an implementation that shares no code with
`FightPoseSolver.gd`. That is the second opinion S43 wanted before betting its
integration on this design, and it passed.

**And it locates the hard part exactly where S43 already puts it: the DOF set.**
Dola's solver fails because her bodies cannot bend. Ours can — C153 specifies 13
stature-scaled capsules driven by 22 real bones, and `FightPoseSolver.descend`
takes its DOF list from the caller. The difference between a positioning demo
and a grappling pose is entirely in what the parameters are allowed to move.

## What NOT to copy

- Do not copy the pose table. It is rigid-body placement, not posing.
- Do not trust a DOF list as evidence that a DOF does anything. **Assert that
  perturbing each parameter changes the cost**, or a dead parameter will sit in
  the list forever looking like capability. This is the same family as S41's
  frame-count non-vacuity check passing while the measurement was a constant.

---

# ADDENDUM — the perchance build's own pose format, read after its 20:06 save

**`saveCount` went 0 -> 1 at 2026-09-21T20:06:11Z and the source grew
178,146 -> 201,590 chars. This is the real thing, and it is the best-built
artefact this project has examined.**

Constants that appeared with that save: `CAP_DEFS`, `LIMB_R`, `LIMB_AXIS`
(per-limb capsule radii), `JOINT_PARENT` (joint hierarchy), `SELF_SKIP`
(adjacent-capsule exclusion), `SUP`/`PRONE` (supine and prone orientations,
`...SUP` used 11 times), `LSQ_O`/`LSQ_REG`, and 22 fully specified poses.

## The ground poses ARE authored on the floor

```js
sideControl: {
  mob:[0.68,0.32],
  hold:{ A:["kneeL","kneeR"], B:["spine","pelvis"] },
  touch:[{ x:"chest", y:"chest", w:1, off:0 }],
  A: P({ head:[1,0,0], front:[0,-1,0], root:[-0.39,0.40,-0.29],
         hipL:[48,0,0,48], ankL:[-90,0],
         ik:{ handL:GA("B.neck",0.5), handR:GA("B.pelvis",0.15) } }),
  B: P({ ...SUP, root:[0,0.128,0.10], neck:[16,0,0],
         ik:{ handL:GA("A.chest",0.70), handR:GA("A.chest",0.28) } })
}
```

B is SUPINE with his root at 0.128 m, spine and pelvis held to the mat; A is
cross-body, front facing down, knees planted, hands on B's neck and pelvis.
Mount is the same shape. **Every frame that was caught showing two men standing
was a TRANSITION frame** - the view fast-forwards between positions, and
sampling it at intervals measures the journey, not the destination. Operator's
correction, and it was right.

## THE ONE THING OUR PORT DOES NOT HAVE: PARTNER IK

```js
ik:{ handL: GA("B.neck", 0.5), handR: GA("B.pelvis", 0.15) }
```

A hand is pinned to a NAMED CAPSULE ON THE OTHER BODY with a blend weight.
`FightPoseSolver` has `contacts` (a/b/off/w) and `holds` (body/cap) - the same
shapes - but nothing that says "this hand goes THERE on him".

**That is the difference between a grip and two limbs that merely fail to
overlap**, and a contact term alone cannot express it: a contact says "these two
surfaces are `off` apart", which a hand satisfies from any direction. A grip has
a PLACE.

S43 should decide whether to add it. The cheap form is a third array beside
`contacts` and `holds` - `grips: [{body, cap, target_body, target_cap, blend}]` -
costed the same way, as a squared distance from the hand capsule's end to a
point interpolated along the target capsule.
