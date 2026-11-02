# S46 — THE DOF SET, MEASURED ON OUR OWN RIG

**Session:** S46, 2026-09-22. **Stage:** collect D5, then build the arm+spine DOF
set and prove it here.

## The rejection criterion, written before the numbers

> D5 reports 5/13 standing holds arms-only and 13/13 with a two-axis waist hinge.
> The port PASSES if our rig reproduces that shape — a materially worse arms-only
> arm and a materially better spine arm — under all-pairs scoring, with no bound
> relaxed. If it does not, the residual is reported with the DOF set that produced
> it and no bound is widened to rescue it.

**No bound was relaxed. It did not reproduce.**

## What landed

- `Godot/scripts/FightPoseDOF.gd` — the piece between `FighterCapsules` (rest
  capsules in metres) and `FightPoseSolver` (which takes a `build` Callable and
  knows nothing about what a parameter means). Twelve parameters per body: root
  x/y/z/yaw, spine flex/side, shoulder elevation/azimuth per arm, elbow flexion
  per arm. Pure — no autoloads, no scene preloads, no `class_name`.
- `Godot/tools/s46_dof_set.gd` — the measurement: thirteen poses under three DOF
  sets, scored on every capsule pair.
- One correctness fix in `FightPoseSolver.descend` (below).

## The headline: D5 does not transfer

| | Dola's rig | f01 vs f02, ours |
|---|---|---|
| arms only | **5/13** | **3/13** |
| arms + spine | **13/13** | **4/13** |
| arms + spine + elbow | not measured | **3/13** |

**The +1 from the spine is one pose crossing a bound by 0.7 mm.** `closed_guard`
passes at `pen_max` 0.0053 m against a 0.0060 m bound and fails at 0.0067 m the
moment a legitimate extra DOF is added. A pass count that flips on the third
decimal place of a bound is inside the method's own noise, not a result — so the
honest reading is that **the DOF set does not change what passes.**

## But the mechanism D5 describes is real, and it is not decoration

What moves, and by a lot, is the **residual**:

| pose | arms only | + spine | + spine + elbow |
|---|---|---|---|
| underhook `pen_m` | 0.1042 | 0.0613 | **0.0239** (−77%) |
| underhook `grip_m` | 0.0307 | 0.0058 | 0.0043 (−86%) |
| over_under `pen_m` | 0.0180 | 0.0034 | **0.0007** |
| single_leg `pen_m` | 0.0119 | 0.0348 | **0.0053** |
| front_headlock `grip_m` | 0.0989 | 0.0439 | **0.0267** (−73%) |

Both joints do what they are supposed to do. Neither is enough.

## Why the numbers do not transfer — two independent reasons, both measured

### 1. Her fighter is half our size, and both are judged on the same absolute metres

| quantity | dola | f01 | f02 | ratio f01/dola |
|---|---|---|---|---|
| stature m | 1.0000 | **1.8471** | 1.9507 | **1.847** |
| arm reach m | 0.3002 | 0.4848 | 0.5365 | 1.615 |
| leg m | 0.4005 | 0.8401 | 0.8838 | 2.098 |
| torso m | 0.3500 | 0.5019 | 0.5415 | 1.434 |

Both rigs are scored against `pen<=0.006`, `grip<=0.012`, `touch<=0.012` m —
because ours were ported from the same ~1 m source build hers descends from. **A
0.012 m grip bound on a 1.85 m man is a 0.0065 m bound on a 1.00 m man.** D5's
eight cleared poses landed at grip 0.0073–0.0118 m; scaled onto our body that band
is **0.0135–0.0218 m**, outside our bound before the solver starts.

This is not a reason to widen the bound. It is a reason to stop quoting her
absolute metres as if they were ours.

### 2. She has nine limbs and we have fifteen capsules, scored all-pairs

Her collar tie reports `pen 0.0000`. Ours reports **0.1274 m between `forearm_r`
and `thorax`** — while the grip sits 6 mm from its target. The overlap she cannot
see is the operator's actual complaint about the 3D fight.

## The finding that decides the next stage: it is not the limbs

`pen_pair` names the worst-penetrating pair on every pose, and it is not random:

| pose | worst pen pair | `pen_m` |
|---|---|---|
| collar_tie | `forearm_r`/`thorax` | 0.1274 |
| double_collar | `forearm_l`/`thorax` | 0.0707 |
| rear_naked | `forearm_r`/`thorax` | 0.0935 |
| front_headlock | `upper_arm_r`/`thorax` | 0.1261 |
| closed_guard | `pelvis`/`pelvis` | 0.0067 |
| side_control | `femur_l`/`pelvis` | 0.0062 |

**Arm-through-torso and torso-to-torso.** No limb DOF can resolve those, because
the pose's own contact spec pins the two pelvises 0.02–0.03 m apart — offsets
authored against a 1.00 m body and applied unchanged to a 1.85 m one. Two men
whose chests are 0.50 m of torso each cannot stand 0.03 m apart at the hips
without one being inside the other.

**So the next thing to derive is the contact offsets, not another joint.**

## The control arm, and the bug it had

The arms-only arm is the same twenty-four-slot vector, the same schedule, the same
weights and the same all-pairs scoring — the four spine DOFs simply get a zero
range and a zero step.

**That control was handicapped and it took a re-run to see it.** `descend` probed
every DOF in its index set six times per sweep, frozen ones included, so the
arms-only arm burned budget on candidates it could not move and hit the evaluation
ceiling with fewer USEFUL evaluations than the arm it was controlling for. A
control that is given less of the resource than its test arm is not a control.
`FightPoseSolver.descend` now skips zero-step DOFs, and reads its step-floor from
the first LIVE DOF rather than from `idx[0]` — which was 0.0 whenever a frozen DOF
sat at the head of the set, breaking the descent on its first unproductive sweep.

Solver test unchanged at `checks=30 failures=0`; `s42_mutants` `total=8 red=8
missed=0` with the unmutated control green.

## Non-vacuity — could this instrument have read differently?

Asserting that a table has thirteen rows is not a check; thirteen rows of nothing
is still thirteen rows. What is asserted instead:

- the two arms differ on **13/13** poses,
- 0.30 rad of spine flex moves f01's head **0.1347 m** and his right foot
  **0.0000 m** (the base is below the waist, so it must not move),
- 1.20 rad of elbow flex moves his right wrist **0.2563 m** and his right shoulder
  **0.0000 m** (a joint that moves its own parent is a mislabelled shoulder),
- the forearm is **0.234043 m** before and after flexion — a rotation, never a
  stretch bought to gain reach.

## Population

**f01_m_box_welter at 1.78 m against f02_m_box_heavy at 1.88 m** — two different
rigs at two different statures, named in the artefact's own output. Never one
fighter twice, and never two men from one stat block.

## The command

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s46_dof_set.gd
```
