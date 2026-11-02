# TASK_C155 — CODEX — THE POSED CAPSULE SET'S CONTRACT TEST, WRITTEN BLIND

**Owner:** codex
**Model:** `gpt-5.6-luna`, MEDIUM effort. (Not astra — this is a contract test,
not 3D animation design.)
**Test tier:** parse gate, then YOUR ONE NEW TEST ONLY. A new test file cannot
break another test, so do NOT run the suite. It costs twenty minutes and buys
nothing here.

## Why you and not me

`FighterCapsules.posed()` exists on master and **I wrote it, so a test I write
against it only ever agrees with it.** You are writing the witness from the
CONTRACT below. Do not read my implementation of `posed` — do not open
`Godot/scripts/FighterCapsules.gd` at all. Everything you need is in this file.

This split has paid off three times running (C142, C152, C154), and C154 is why
this task exists: it caught two real defects the moment its subject landed.

## Owned files

- `Godot/tests/fighter_capsules_posed_contract_test.gd` — CREATE. Yours alone.
- `research/C155_DIGEST.md` — CREATE.

Touch nothing else. Do NOT edit `HANDOFF.md`.

## The contract

`res://scripts/FighterCapsules.gd` is a pure `RefCounted` script — no
`class_name`, load it with `load()`. It exposes:

```
static func build(skel: Skeleton3D, height_scale: float) -> Array
static func posed(skel: Skeleton3D, rest_caps: Array, height_scale: float,
                  world: Transform3D = Transform3D.IDENTITY) -> Array
static func bone_map() -> Dictionary
const RADII_M: Dictionary
```

A CAPSULE is `{"name": String, "p0": Vector3, "p1": Vector3, "r": float}` and
**exactly those four keys**. Every quantity is METRES.

`build` returns the set on the skeleton's REST pose. `posed` returns the same set
moved onto the skeleton's CURRENT pose. What must hold:

1. **SAME NAMES, SAME COUNT.** `posed` returns one capsule per capsule in
   `rest_caps`, with the same names, no extras, no duplicates.
2. **RADII ARE CARRIED UNCHANGED.** A radius comes off the skin and a pose does
   not change how thick a man is. With `world = Transform3D.IDENTITY` and the
   same `height_scale`, every `r` from `posed` equals the `r` from `build` for
   that name, to 1e-6.
3. **ON AN UNPOSED SKELETON, `posed` REPRODUCES `build`.** A freshly loaded rig
   has every bone at its rest pose, so with identity `world` the two sets must
   agree on `p0`, `p1` AND `r`, every capsule, to 1e-5 m. **This is the check
   that matters most — see the trap below.**
4. **A POSE MOVES IT.** Rotate ONE bone (`set_bone_pose_rotation` on
   `LeftUpperArm` by 0.7 rad about Z) and re-run `posed`. The capsules whose
   endpoints depend on that bone MUST move by more than 0.01 m; the capsules on
   the other side of the body (`femur_r`, `shin_r`, `foot_r`) MUST NOT move by
   more than 1e-5 m. **Assert BOTH halves.** A function that moves nothing and a
   function that moves everything are both wrong, and only one of the two
   assertions catches each.
5. **`world` IS APPLIED.** Pass `world = Transform3D(Basis.IDENTITY,
   Vector3(3.0, 0.0, -2.0))` with `height_scale` 1.0 and every endpoint must
   shift by exactly that vector against the identity-world run, to 1e-6.
6. **A `world` WITH SCALE SCALES THE RADIUS TOO.** Pass
   `Transform3D(Basis.IDENTITY.scaled(Vector3(2,2,2)), Vector3.ZERO)` with
   `height_scale` 1.0: every `r` must be 2x the identity-world radius to within
   1%. A radius that ignores the mount scale is the S4 (4) defect that printed
   0.364 m for 0.343 m.
7. **FINITE AND NON-DEGENERATE**, as in C154: every endpoint finite, every
   radius > 0, every segment longer than 0.01 m.
8. **DETERMINISTIC.** Two `posed` calls on the same pose are byte-identical.

## Population — NAME IT IN YOUR OWN OUTPUT

`f01_m_box_welter_rigged.glb` at target height **1.78 m** and
`f02_m_box_heavy_rigged.glb` at **1.88 m**. Two different rigs at two different
statures. **Never one fighter twice** — that is an unreal population and it
measures the fixture rather than the engine. Print the population line.

Get `height_scale` from
`FighterPhysique.height_scale(raw_mesh_height, target_height)`.

## THE TRAP, AND IT IS THE WHOLE REASON CHECK 3 EXISTS

**`get_bone_global_pose()` RETURNS THE REST POSE HEADLESS.** The skeleton is
never processed in a `--headless --script` run, so any measurement taken through
it reports rest whatever the animation is doing. If `posed` were implemented with
it, check 3 would pass perfectly and check 4 would fail — which is exactly the
pair of results that tells you the function is inert rather than correct.

**So check 4 is not optional and it is not a nicety.** Write it first.

## A SECOND TRAP THAT WILL COST YOU THE RUN IF YOU MISS IT

**A `SceneTree` script's `_initialize()` runs BEFORE the tree is running.**
`get_root()` returns the root Window but that Window is not itself in the tree,
so `add_child` does not put anything in the tree either — it was tried and
measured on 2026-09-22.

Two consequences, both of which failed C154 before they were fixed:

- **NEVER call `global_transform`** on your instantiated rig. It returns IDENTITY
  and pushes `ERROR: Condition "!is_inside_tree()" is true` once per call.
  Compose the chain by hand: walk `get_parent()` up to your root multiplying
  `transform`.
- **`free()` every rig you instantiate**, not `queue_free()`. A queued free is
  never processed because the tree is not running, and Godot prints `ERROR: Pages
  in use exist at exit in PagedAllocator` at exit.

**`run_tests.py` classifies ANY line starting `ERROR: ` as `engine-error` and
fails the test on it.** Your test can be perfectly correct and still be condemned
for either of these.

## A THIRD TRAP — YOUR DIAGNOSTICS MUST NOT USE THE RUNNER'S WORDS

`run_tests.py` reads the LOG for self-reported failure
(`Godot/tools/run_tests.py:136-140`): any line starting `FAIL`/`FAILED`, any
`failures=N` with N>0, any `N failure(s)`. If you print a deliberate negative
control's outcome using those words you condemn your own passing test. C141 and
C142 both did. Use `checks_failed=` for anything intentional.

End with `checks=N failures=0` and `quit(1 if failures > 0 else 0)`.

## SKIP CLEANLY IF THE SUBJECT IS ABSENT

If `FileAccess.file_exists("res://scripts/FighterCapsules.gd")` is false, or the
script has no `posed` method, print `SKIP — FighterCapsules.posed not present`
and `quit(0)`. That is what makes this file committable and green from the first
minute. It should NOT skip on master today — `posed` is there. **If it skips, say
so loudly in your digest: that means you could not see the method and the whole
run proved nothing.**

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/fighter_capsules_posed_contract_test.gd
```

then

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fighter_capsules_posed_contract_test.gd
```

Ceiling: `failures=0`, rc=0, and **zero lines starting `ERROR:`**. Report the
real numbers.

## PROVE THE TEST WITH MUTANTS BEFORE YOU BELIEVE IT

A green contract test proves nothing until you have seen it go red. Copy
`FighterCapsules.gd` to **`/tmp/mutant_capsules.gd`** — NOT into `Godot/scripts/`
and NOT to the real path; you are pinned to the main checkout and a scratch file
at the real path lands exactly where the implementation lives (this happened on
C150). Break it four ways and confirm your test catches each:

1. return the rest endpoints unchanged (the inert-function mutant)
2. drop the `world` translation
3. leave the radius unscaled when `world` has a scale
4. mirror left and right (swap the `_l` and `_r` endpoint bones)

Report which mutant each check caught. **A mutant your test does not catch is a
check you have not written.** And if a mutant pattern does not MATCH the file,
say `PATTERN-MISS` — that is not a caught defect, and it is only distinguishable
from a pass if you print the two differently.

## Deliver

Commit both files, push, write the digest, and send one line with
`python Tools/agent_comms.py send --from codex --to claude --subject c155-ready`.
Do NOT edit `HANDOFF.md`.
