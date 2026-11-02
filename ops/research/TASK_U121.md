# TASK_U121 — `fight_lean_survives_test`: 18 failures, one assertion, in mesh units

**Owner: Cursor.  Model: composer-2.5, medium effort.**
**Test tier: ONE TEST, possibly one script. Parse gate what you touch, then that
test, then `run_tests.py --only lean` and `--only pose`. DO NOT run the full
suite — 320 tests, ~25 min at `--jobs 6`.**

---

## WHAT IS RED AND WHAT IS NOT

`Godot/tests/fight_lean_survives_test.gd` reports **`checks=85 failures=18`**.

**It is PRE-EXISTING.** Reproduced identically on the pre-session tree
(`4e9ef150`, before the U119 merge and before S36 touched anything), so nothing
in S36 caused it. The handover's "four genuine reds" list was simply short by
one — this is a fifth.

**Exactly one assertion class fails, and it is `C5`:**

```
FAIL C5 victim t=4.000 hips_y=0.036 in [0.6,1.3]
C144_SAMPLE t=4.000 lean_deg=54.851/41.660 horizontal_deg=164.237 hips_m=0.034/0.036
C144_LEAN attacker_min=51.506 attacker_max=55.086 victim_min=39.195 victim_max=41.660 bound_deg=12.0
```

18 = **2 fighters × 9 samples**, so it fails on every sample for both bodies —
a constant, not a glitch.

**EVERYTHING ELSE PASSES**, and that matters: `C2`/`C3` want lean ≥ 12° and get
51–55° and 39–41°; `C4` wants the two spines opposed and gets 164°. The pose
plumbing through `FightPoseBridge` is working. Only the HEIGHT is wrong.

## THE HYPOTHESIS, AND IT IS SPECIFIC

**The test never applies the fighter mount scale, so its hips are in MESH UNITS
while its bound is in METRES.**

- `MIN_HIPS_M = 0.6`, `MAX_HIPS_M = 1.3` — metres, in the source.
- The test loads `f01_m_box_welter_rigged.glb` and `f02_m_box_heavy_rigged.glb`
  **directly**. It never calls `FightWorldStage.mount`, which is the only place
  `FighterPhysique.height_scale()` gets applied.
- `_point()` (`:131`) composes ancestor `Node3D` transforms, so it would pick a
  scale up if one were there — but on a freshly loaded GLB every node reads
  `(1, 1, 1)`, because these are Tripo exports at arbitrary scale. `f05`'s mesh
  is 1.850 tall and `f06`'s is **1.000**; nothing in the file says which.

**THIS EXACT TRAP HAS NOW COST THREE PASSES.** `FightBodyCapsules.gd:148` carries
the warning in capitals ("SKELETON-LOCAL TO METRES IS THE `scale` FACTOR AND IT
IS NOT OPTIONAL"), S4 (4) lost a pass to it, and on 2026-09-21
`tools/probe_cmu_grip.gd` reported a **+139.7%** retarget drift that was almost
entirely one fighter being measured at half size — the real figure is +8.8%.

**BUT 0.034 IS SMALLER THAN A SCALE ERROR ALONE EXPLAINS, AND THAT IS THE PART
TO MEASURE FIRST.** A hip sits around 55% of stature; on a mesh 1.0–1.85 tall
that is 0.55–1.0 in mesh units, not 0.034. So either the Hips carry no height at
all in this sampling path (the retarget writes rotation plus ONE Hips position
track — see `FightClipRetarget.CARRY_BONE` and `hip_carry`, which needs a
`reference_fbx_path` to do anything), or the bridge returns something other than
what the bound assumes. **Find out which before changing a number.**

## WHAT TO DELIVER

1. **A measurement first.** Print, for `f01` and `f02`: the mesh AABB height,
   `FighterPhysique.height_scale()` against the athlete's stature, the rig's
   REST hips height in skeleton-local units, and the hips height the test
   actually samples. Five numbers, one line each. **The fix follows from those
   and must not be guessed at.**
2. **Then the fix**, which will be one of:
   - the test should mount through `FightWorldStage.mount` (or apply the same
     scale) so its metres are real metres; **or**
   - the retarget in this path is not carrying hip height at all, and the bug is
     upstream of the test; **or**
   - the bound was authored against a number that never existed, in which case
     say so plainly and derive the right one.
3. **Say which of the three it was, with the numbers**, in the digest.

## OWNED FILES

- `Godot/tests/fight_lean_survives_test.gd`
- `Godot/scripts/FightPoseBridge.gd` — read it; change it only if the
  measurement puts the bug there.
- Read-only for context: `Godot/scripts/FighterPhysique.gd` (small),
  `Godot/scripts/FightWorldStage.gd` (~120 lines, read whole),
  `Godot/scripts/FightClipRetarget.gd` — **1,095 lines, never open it whole**;
  read `sed -n '482,600p'` for `CARRY_BONE` and `hip_carry`.

## GATE

```
python Godot/tools/check_scripts.py <every .gd you touched>
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_lean_survives_test.gd
python Godot/tools/run_tests.py --only lean
python Godot/tools/run_tests.py --only pose
```

Ceiling, never an exact count: `fight_lean_survives_test` must reach
**failures=0**, and no other test in those subsets may go red. If you cannot get
to zero honestly, land the MEASUREMENT and say what it shows — a correct
diagnosis is worth more than a green test bought by moving a bound.

## THE TRAP SPECIFIC TO THIS TASK

**Do not fix this by widening `MIN_HIPS_M` / `MAX_HIPS_M` to swallow 0.034.**
That turns a real unit bug into a permanently meaningless assertion, and the
bound is the only thing in this test that knows a fighter is a human being. If
the numbers say the bound is wrong, derive the new one from the mesh scale and
say where it came from.

Second trap: `Skeleton3D.get_bone_global_pose()` returns the REST pose in an
`_initialize`-stepped run. That is why this test goes through `FightPoseBridge`
in the first place — its header says "never skeleton rest poses". Do not
"simplify" it back onto the skeleton.
