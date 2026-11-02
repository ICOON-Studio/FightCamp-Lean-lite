# TASK_C154 — BLIND contract test for the fighter capsule set

**Owner:** codex
**Model:** `gpt-5.6-luna` (this is a CONTRACT TEST — text and assertions, not
spatial assembly; do NOT set `CODEX_MODEL=gpt-6-astra` for it)
**Test tier:** parse gate, then YOUR ONE NEW TEST ONLY. A new test file cannot
break another test, so **do not run the full suite** — it costs twenty minutes
and buys nothing here.

## This is a BLIND test. That is the whole point.

`Godot/scripts/FighterCapsules.gd` **DOES NOT EXIST YET.** I am writing it in the
next session. You are writing its test **from the contract below and nothing
else**, before the implementation exists, so that the test and the module
disagree where I got it wrong. A test written against my implementation only
ever agrees with it.

**DO NOT create, stub or scaffold `FighterCapsules.gd`.** Your test must fail to
load it right now, and that is correct. Guard the whole test body so it reports
`SKIP — FighterCapsules.gd not present yet` and exits 0 when the module is
absent, and runs every assertion when it is present.

**Read the contract below and the files in `Owned files`. Read NOTHING else.**
Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, any digest,
or `FightPoseSolver.gd`'s internals beyond the four signatures quoted here. Do
not explore to "get oriented".

## The contract

`Godot/scripts/FighterCapsules.gd`, `extends RefCounted`, three public members:

```gdscript
const RADII_M: Dictionary          # capsule name (String) -> radius in METRES (float)
static func bone_map() -> Dictionary
static func build(skel: Skeleton3D, height_scale: float) -> Array
```

- `bone_map()` returns `{ capsule_name: [from_bone_name, to_bone_name] }`, both
  Strings naming bones that exist on the rig.
- `build()` returns an `Array` of `Dictionary`, one per `bone_map()` key, each
  **exactly** `{"name": String, "p0": Vector3, "p1": Vector3, "r": float}`.
  Key names and spelling are the contract — `p0`, `p1`, `r`, lower case.
- **EVERY QUANTITY IS IN METRES.** `height_scale` is the multiplier that converts
  the raw rig into metres; it comes from
  `FighterPhysique.height_scale(mesh_height_m, target_height_m)`.

## THE TRAP THIS TEST EXISTS TO CATCH

**Our rigs are NOT in metres.** Tripo exports at arbitrary scale, and only
`height_scale()` makes them metric. A solver fed centimetres converges
beautifully and means nothing — every bound in `FightPoseSolver.gd` is metres
(`PASS_PEN_M := 0.006`, `PASS_TOUCH_M := 0.012`, `PASS_MAT_M := 0.012`).

So the **metres proof is the most important assertion in this file**. Assert a
known human segment reads a plausible human figure:

| quantity | plausible band (adult male fighter) |
|---|---|
| stature (lowest capsule point to highest) | 1.55 – 2.10 m |
| shoulder to shoulder (acromion span) | 0.30 – 0.55 m |
| hip to knee (femur) | 0.32 – 0.55 m |

Do not gate on an exact number — gate on the band, and **print the measured
value** so a failure says what it actually read.

## What to assert

1. **Completeness** — every key of `bone_map()` appears exactly once in
   `build()`'s output; every key has a radius in `RADII_M`; no extra keys.
2. **Well-formed** — each entry has exactly the four contract keys; `r > 0.0`;
   no `NAN`/`INF` in any component of `p0`/`p1`.
3. **METRES** — the three bands above. Print every measured value.
4. **Radii are plausible in metres** — every radius in `0.02 .. 0.20`. A radius
   of 6.0 means the rig was never scaled.
5. **Non-degenerate** — `p0.distance_to(p1) > 0.01` for every capsule.
6. **No gross self-overlap at rest** — for every pair of capsules that are NOT
   adjacent in `bone_map()` (they share no bone name),
   `FightPoseSolver.capsule_gap(a, b) >= -0.02`. Name the worst pair in the
   failure message.
7. **Determinism** — call `build()` twice on the same skeleton; every component
   of every capsule byte-identical.
8. **BOTH FIGHTERS, AND THEY MUST DIFFER** — see below.

## RULE YOU MUST NOT BREAK: never test identical fighters

Run every assertion on **both** `f01` and `f02`, and then **assert they are NOT
the same fighter**: at least one capsule's length or radius must differ by more
than 1 mm between them. Two fighters built from the same numbers are not a
control group, they are an unreal population, and a test that passes on two
identical rigs is measuring the fixture rather than the module. If f01 and f02
come back identical, **that is a FAIL and you report it**, not something to work
around.

Name the population in the test's own output: print which two rigs were loaded.

## Gate as a CEILING, never an exact count

Report `checks=N failures=M`. The gate is **`failures=0`**. If you find you can
assert more than the eight groups above and they pass, add them and say so —
over-delivery is never a failure here.

## Owned files

- `Godot/tests/fighter_capsules_contract_test.gd` — **CREATE. Yours alone.**
- Read-only, for signatures only:
  - `Godot/scripts/FightPoseSolver.gd` — use ONLY
    `static func capsule_gap(a: Dictionary, b: Dictionary) -> float` (`:128`),
    `static func capsule_low(c: Dictionary) -> float` (`:136`), and the
    constants `PASS_PEN_M` (`:72`), `PASS_TOUCH_M` (`:73`), `PASS_MAT_M` (`:74`).
  - `Godot/scripts/FighterPhysique.gd` — `static func height_scale(
    mesh_height_m: float, target_height_m: float) -> float` (`:87`).
  - `Godot/tests/fight_pose_solver_test.gd` — **read this for HOUSE STYLE ONLY**
    (how a test prints `checks=`/`failures=`, how it loads a rig). Do not copy
    its assertions.

Find the two rigs under `Godot/assets/models/fighters/` — `f01*_rigged.glb` and
`f02*_rigged.glb`. If `f02` does not exist, say so in the digest and run the
single-fighter assertions on `f01`, but still FAIL check 8 explicitly rather
than skipping it.

## Gate

```bash
python Godot/tools/check_scripts.py Godot/tests/fighter_capsules_contract_test.gd
```

Then the one test:

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fighter_capsules_contract_test.gd
```

**The exit code alone is NOT a pass.** A GDScript runtime error leaves rc=0, so
read the output: if you see `SCRIPT ERROR` lines, or your own `checks=` line
never printed, it failed regardless of rc. rc=124 is a hang — suspect a parse
error in something the test loads.

Right now the correct result is the `SKIP` line and rc=0.

## When you are done

Commit and push `master`, write a short digest in
`research/C154_DIGEST.md`, and send one line:

```bash
python Tools/agent_comms.py send --from codex --to claude --subject c154-ready --body "<one line>"
```

**Do NOT edit `HANDOFF.md`.** Commit messages end with
`Co-Authored-By: Codex <noreply@openai.com>`.

## The one trap specific to this task

**`var x := <call>` fails when the call returns Variant** — `.size()` or `.get()`
on an untyped value, or a static on a `load()`ed script. `FightPoseSolver` will
be `load()`ed, so `var gap := FightPoseSolver.capsule_gap(a, b)` is a parse
error. Write the type: `var gap: float = FightPoseSolver.capsule_gap(a, b)`.
This costs a fix cycle every single stage.
