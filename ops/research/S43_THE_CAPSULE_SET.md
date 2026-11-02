# S43 — THE CAPSULE SET THE SOLVER SOLVES, IN METRES

**Session:** S43, 2026-09-22. **Stage:** the capsule set, measured off both rigs.

## The rejection criterion, written before the numbers

Decided and recorded before any measurement was taken, per the stage's own gate:

> The set PASSES if, on **both** f01 and f02: C154's blind contract test reaches
> `failures=0` with zero `ERROR:` lines; stature, shoulder span and femur all land
> inside the contract's metres bands; and the worst non-adjacent capsule gap is
> **at or above −0.02 m**. If any of those needs a bound relaxed to pass, the set
> has not passed and the residual is reported instead.

**No bound was relaxed.** Both rigs cleared every criterion.

## What landed

`Godot/scripts/FighterCapsules.gd` — 15 capsules, every quantity in METRES.
`build(skel, height_scale)` returns `{name, p0, p1, r}`, `posed(...)` moves the set
onto the skeleton's current pose, and `body(caps)` hands the solver the
`{caps, cap_map}` shape it wants.

**C154's blind contract test: `checks=246 failures=0`, rc=0, zero error lines.**

| | f01_m_box_welter @1.78 m | f02_m_box_heavy @1.88 m |
|---|---|---|
| stature (band 1.55–2.10) | **1.8471 m** | **1.9507 m** |
| shoulder span (band 0.30–0.55) | **0.3755 m** | **0.4512 m** |
| femur (band 0.32–0.55) | **0.4249 m** | **0.4636 m** |
| worst non-adjacent gap | **+0.0022 m** | **+0.0091 m** |
| interpenetrating pairs | **0** | **0** |
| pairs compared / declared adjacent | 82 / 23 | 82 / 23 |
| skin vertices read | 11,363 | 11,084 |

Population named in the artefact's own output: two different rigs at two different
statures, never one fighter twice.

## The radii are measured, not authored

`tools/probe_capsule_anthropometry.gd` reads every bone rest origin and every
skin-weight radius off both rigs first. At build time a radius is the p80 distance
from the capsule's own segment to the vertices whose dominant bone it is — the
derivation `FightBodyCapsules` already uses, not a second one, because deriving it
twice is the drift S4k paid for.

`RADII_M` is the fallback and it earns its place: **`Neck` carries ZERO skin
vertices on both rigs**, and `shoulder_span` is cross-body, so its skin-weight
radius measures the arm (0.198 m) rather than the shoulder. Those two are authored
and say so in `build_report`'s `sources`.

## THE HEAD WAS MEASURED WRONG AND THE CLAMP HID IT

The p80 about the 0.0594 m `Neck`→`Head` segment returned **0.2166 m**. That is
not how wide the skull is — it is how far the skull sits from that short segment,
because the head's flesh centroid is at y = 0.7658 against the bone's 0.6501. The
sanity clamp then held it at 0.20 m, **which reads like a fat head rather than a
broken derivation.**

The head is now measured as a BLOB about its own vertex centroid — 0.128 m on f01
— and its capsule runs from `Head` to that centroid, so it covers the skull
instead of reaching down into the chest. **A clamp that fires is a derivation to
go and read, never a number to accept.**

## Two torso segments, not three, and why the declarations are forced

A capsule is a segment plus a hemispherical cap, so a chain of joint-to-joint
capsules always overlaps at its junctions. Insetting the endpoints by their own
radius would take the femur from 0.4249 m to 0.187 m — it would stop being the
femur. **Joint-to-joint segments and non-overlapping caps cannot both be had.**

A three-segment torso put `pelvis` **0.2109 m inside `thorax`**. Two segments —
`Hips`→`Chest` and `Chest`→`Neck` — each exceed their own radius and need no such
declaration, which is why that is what shipped.

`shoulder_span` is the unavoidable case: a capsule from one shoulder to the other
**passes through the chest**, because that is what spanning the shoulders means.
It is declared adjacent to `UpperChest`, the bone the girdle is mounted on.

One declaration a heavyweight forced: `thorax`↔`Hips`. On f02 the thorax radius is
0.1909 m and the femur's 0.1423 m, and the `pelvis` link between them is 0.2361 m
— shorter than their combined caps — so the two caps met at −0.0202 m **inside the
volume `pelvis` already owns and is adjacent to both of.** f01, leaner in the
chest, cleared the same pair at +0.0078 m.

**And one declaration is anatomy we do not get to argue with:** the two femurs are
adjacent through `Hips` because **a standing man's thighs touch** — measured
−0.057 m on f01. No honest capsule set reports otherwise.

## THE CONTRACT TEST WOULD HAVE GONE RED ON ITS OWN DEFECTS

Both were invisible while `FighterCapsules.gd` was absent, because the test quit at
its SKIP before reaching either. Neither assertion was changed.

1. **`mesh.global_transform` in a `SceneTree._initialize()`.** The tree is not
   running: `get_root()` returns the root Window and **that Window is not itself in
   the tree**, so `add_child` cannot fix it — tried and measured. `global_transform`
   returns IDENTITY and pushes `ERROR: Condition "!is_inside_tree()" is true` once
   per call, eight per rig. The chain is composed by hand now; **identical answer,
   1.850000 m on both rigs**, because these mesh nodes carry an identity transform.
   It would NOT be identical on a rig whose mesh node has a scale.
2. **Neither rig root was freed**, so Godot printed `ERROR: Pages in use exist at
   exit in PagedAllocator`. `free()` and not `queue_free()` — a queued free is
   never processed when the tree is not running.

**`run_tests.py` classifies any line starting `ERROR: ` as `engine-error` and fails
the test on it.** Both forms would have condemned a correct test.

## SUITE: total=326 fails=7 — ONE OVER THE CEILING, AND I CAUSED IT

> **CORRECTED IN S45, SAME DAY. THE HYPOTHESIS BELOW WAS WRONG AND IS LEFT
> STANDING AS THE RECORD OF IT.** The key matched and the writes landed; the
> weight-class name was never the cause. The real one: `ranking_snapshot`'s
> ordered list prepends the champion **only when the division has one**, while a
> contender's `position` was hard-coded to start at 2 — so in a BELTLESS division
> every movement figure was off by one. Measured on `boxing|Flyweight|male`: a
> fighter who gained a place reported **0**, a two-place fall reported **−3**. The
> defect PREDATES U125; the merge only moved the fixture onto the broken path.
> Fixed, control-armed against a belted division (+1 before and after), and the
> suite is back at **total=327 fails=6**. See `Godot/tools/probe_rankings_movement.gd`.
>
> **The lesson is the one worth keeping: a diagnosis in a handover is a hypothesis
> with a head start, not a finding.**

Six are the named baselines: `athlete_development`, `fight_pair_live` (PARKED),
`fight_scoring`, `fight_stage_realism`, `weight_cut`, and `fight_metres` (hang
under `--jobs 6`; it passes alone in about nine minutes).

**The seventh is `rankings_api_test` and it is NEW.** It appeared on the commit
where I merged Cursor's U125 weight-class unification, which takes the ladder from
four classes to eight. Run alone: **44 of its 45 checks pass**; the single failure
is C13, *"rank swap reports positive movement for the fighter who moved up"*
(`rankings_api_test.gd:81`).

What is measured and what is not:

- MEASURED: `_test_week_to_week_movement`'s earlier check, "fixture has two movable
  division contenders", PASSES — so the division is not short of fighters, and this
  is not S29's lost-sample shape.
- MEASURED: only `movement` is wrong. Ownership, the P4P rows, the focused-division
  contract and the fresh-career `movement == null` check all pass.
- **NOT MEASURED, and it is the next thing to do:** whether `movement` is coming
  back `null` rather than a negative number. `int(null)` is 0, so the assertion
  cannot tell those apart. The hypothesis worth testing first is that the ranking
  HISTORY is keyed by a weight-class name U125 changed, in which case movement never
  computes — **and that would be a live defect in the game's rankings arrows, not a
  test problem.** Do not patch the assertion before answering that.

U125 is kept rather than reverted: it fixes four permanently-empty rankings tabs
(its own test measures **8 of 8 ladder classes and 8 of 8 division tabs populated**,
`0 failure(s)`), and that is a shipping bug worth more than a green suite.

## What is NOT done, and it is the wiring

`posed()` exists and C155's blind contract test for it has landed, but **the solver
is not yet applied at `PairedStagePlayer.bind`.** That is deliberate, and S44's
control arm is why: two rigid bodies that may only translate and yaw reach **no
standing hold at all** — all 8 failed, grips 0.12–0.42 m out — and one change, arms
rotating about their own shoulders on a sphere of rest length, took the collar tie
from grip 0.3406 / pen 0.0879 to **pen 0.0000, grip 0.0006, a full pass.** Wiring
the solver with the current rigid DOF set would ship a known failure. The DOF work
is the stage, and D4 has Dola on the spine half of it.

## Files

- `Godot/scripts/FighterCapsules.gd` — the set.
- `Godot/tests/fighter_capsules_contract_test.gd` — C154's witness, two repairs.
- `Godot/tests/fighter_capsules_posed_contract_test.gd` — C155 (Codex, blind).
- `Godot/tools/probe_capsule_anthropometry.gd` — the instrument, run first.
- `Godot/tools/probe_capsule_set.gd` — the full non-adjacent gap table, both rigs.
- `Godot/tools/probe_rankings_movement.gd` — the probe that settled the
  rankings regression. An earlier `probe_rankings_sample.gd` was DELETED: it
  built GameState with `.new()` instead of taking the autoload, so
  `start_new_career` did not exist on it, and it HUNG rather than failing —
  six orphaned Godot processes were still alive 80 minutes later. A probe
  that cannot fail fast is worse than no probe.

## Reproduce

```
python Godot/tools/check_scripts.py Godot/scripts/FighterCapsules.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fighter_capsules_contract_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/probe_capsule_set.gd
```
