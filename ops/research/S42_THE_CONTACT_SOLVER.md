# S42 — the contact solver, ported and proved on a fixture that starts broken

**`Godot/scripts/FightPoseSolver.gd`. Ported from the solver in the operator's
`perchance.org/gro5f7k2s5` BJJ build, read out of its saved source on
2026-09-21. The algorithm ports; its rig does not.**

This is the CORE MODULE only. Wiring it to `PairedStagePlayer` and the authored
holds is the next stage — it moves a shipped path and earns its own suite run.

## Why this and not more data

Four attempts at a paired ground position have failed the same way: C134's four
side-control iterations, Higgsfield's 8-of-8 one-body results, and the two HTML
drafts that came through chat on 2026-09-21. **Both drafts DECLARED contacts and
never solved them** — one ignored `contactPoints` entirely, the other named a
function `solveContacts` that only measured. The difference here is that contact
is a cost with a gradient.

## The one line the drafts got wrong

```gdscript
return d - (float(a["r"]) + float(b["r"]))
```

A target is a **surface gap**, not a centre distance. Draft 2 authored
`torso <-> torso = 0.05 m` centre-to-centre against capsules of radius 0.14 —
asking for 0.23 m of interpenetration, so a solver that reached its target had
succeeded at burying one man inside the other. Every contact in that file was
geometrically impossible in the same way.

## The cost

| term | what it does |
|---|---|
| `W.pen · Σg²` over every A×B capsule pair | overlap, where `g` is the surface gap |
| `W.pen_max · max(g)²` | the WORST overlap specifically |
| `W.mat · Σlow²` per capsule, BOTH bodies | the floor |
| `W.touch · Σ(w·g²)` over declared contacts | with per-contact weight and offset |
| `W.touch_max · max²` | the worst contact error |
| `W.hold · low²` | named capsules that stay planted |
| `W.reg · Σp²` | stay near the authored pose |

**The mat is per-CAPSULE on both bodies, never a per-body root offset.** Both
HTML drafts clamped each fighter independently to the floor, which moves the two
men separately and changes the gap between them — it breaks the pair to fix the
ground.

## The phases

`W_PLACE {pen 0, mat 200, touch 6000, hold 60}` root-only, 2600 evals →
`W_FIT {pen 900, pen_max 4000, mat 1200, touch 1200, touch_max 5000, reg 1e-4}`
all DOFs, 9000 → `W_PLACE` root-only re-lock, 500.

**Penetration is OFF in placement on purpose.** Solving placement and overlap
together makes them fight; get the bodies into the right relative place first.

Descent is coordinate-wise: per DOF, probe `±{1, 0.4, 0.15} × step`, keep the
best improvement, and when a whole sweep fails shrink the step ×0.45 until it
falls under 0.004.

## The fixture STARTS BROKEN, and that is the point

A contact solver tested from an already-good pose reports success for doing
nothing. `fight_pose_solver_test.gd` begins at **0.300 m of torso
interpenetration** and must dig out.

```
SOLVE   evals=618  pen_max=0.0000  touch_max=0.0003  mat_max=0.0000  pairs=4
PENONLY control_pen=0.3000  treatment_pen=0.0000
```

Population: body A torso r=0.14 / arm r=0.06; body B torso r=0.16 / arm r=0.07.
Two different bodies, never one twice.

`checks=21 failures=0`.

## Two findings from the mutant pass, and the first one is about the test

**The first fixture could not prove the penetration term did anything.** Its
single contact happened to pull the bodies apart, so satisfying TOUCH
incidentally resolved the overlap, and a build with penetration deleted still
passed. That is why there is now a second fixture with **no contacts at all**,
where the touch term is identically zero and only penetration can separate
anything — with the placement weights (`pen: 0`) as its control arm:
control 0.3000, treatment 0.0000.

**And a fact about the design, not a hole in the test:** mutating the per-pair
`pen` term alone, or `pen_max` alone, is NOT caught. The two are redundant when
exactly one pair overlaps — whichever survives drives the descent to the same
answer. They separate only when several pairs overlap at different depths, which
is the case `pen_max` exists for. That needs a real authored hold, so it belongs
with the integration stage rather than with a two-capsule fixture.

Mutants, all red against a green unmutated control:

| mutant | caught |
|---|---|
| gap measured centre-to-centre, not surface | RED (7) |
| penetration never enters the cost | RED (4) |
| accept every probe — a random walk | RED (5) |
| mat measured from the centre line | RED (1) |
| segment distance degraded to start-point | RED (2) |

`S42_MUTANTS total=5 red=5 missed=0`.

**A sixth mutant was withdrawn as a proven no-op**, and it corrected a comment I
had written in `refine`: `pen_max`, `touch_max` and `mat_max` are tracked
OUTSIDE the weighted sums, so which weight set the verdict uses changes no
reported extremum. The comment now says what the re-evaluation actually buys.

## What is NOT done

- Nothing is wired. `PairedStagePlayer` still uses plain corrections.
- The capsule set for our 22-bone rig is not authored — radii per bone, and
  which bones become capsules at all.
- No authored hold has been solved yet. The first real test is the clinch,
  which Q114 put at 19.6% of grapple events and which Cascadeur has delivered
  one take of.

---

# ADDENDUM — partner-IK GRIPS, added after reading the source build's own format

**Operator instruction 2026-09-21: "add the partner ik grips to the solver".
Done on `FIGHTCAMP_STAGE_GATE=off`, said out loud: this is not a new stage, it
completes the S42 port. The build we ported FROM has grips, so our copy was
incomplete, and `FightPoseSolver` is wired to nothing, so no shipped path moves.**

A GRIP is `{body, cap, on_cap, blend, off, w}`: the DISTAL END of `cap` on
`body` is placed on the other body's `on_cap`, at the point `blend` along it.
It is the shape the source build uses — `ik:{ handL: GA("B.neck", 0.5) }`.

## Why a contact could not already express it

A contact says "these two surfaces are `off` apart", which a hand satisfies
from ANY direction and ANYWHERE along the target. A grip has a PLACE.

**Measured on the fixture, and this is the whole argument:** body B's torso runs
0.58 m from y=0.38 to y=0.96. Solving the CONTACT alone puts the hand in a
legal, fully-satisfied position **0.4036 m away from where the grip wants it**.
With the grip term: **0.0000 m**, and `pen_max` stays 0.0000, so it did not buy
the place by overlapping.

```
GRIP control_grip=0.4036  treatment_grip=0.0000 (arm->torso)  pen=0.0000
```

`checks=29 failures=0`.

## THE TEST WAS MEASURING WITH THE SOLVER'S OWN FUNCTION

Every grip assertion asked `grip_gap` — the same function the solver minimises —
whether the solver had succeeded. **The `grip-blend-ignored` mutant passed all
of them**: force `blend` to 0.5 and the solver and the check agree with each
other, both wrong together. A gate that reads its subject cannot fail.

The repair is an assertion DERIVED in the test from raw geometry: `blend: 0.0`
names the torso's `p0`, so the solved hand must end up nearer `p0` than `p1`.
That check alone is what turns the mutant red (it fails by exactly 1).

## Mutants, all red against a green unmutated control

| mutant | |
|---|---|
| contact gap centre-to-centre | RED (7) |
| penetration never enters the cost | RED (4) |
| accept every probe — a random walk | RED (9) |
| mat measured from the centre line | RED (1) |
| **grip always reports itself perfect** | **RED (3)** |
| **grip gap centre-to-centre** | **RED (3)** |
| **grip blend thrown away** | **RED (1)** |
| segment distance degraded to start-point | RED (2) |

`S42_MUTANTS total=8 red=8 missed=0`.

**And a second design fact, the same shape as the penetration pair:** zeroing
only `W_FIT`'s grip weights is NOT caught, because `W_PLACE` carries
`grip: 6000` and phases 1 and 3 use it — placement alone drives a grip home.
That is correct behaviour (a grip is largely a placement problem), and it means
the two grip weights are not independently testable on a single-grip fixture.
