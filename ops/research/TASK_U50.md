# TASK U50 — CURSOR — THE BLIND TEST FOR THE REST FIXER

**Agent:** cursor
**Model:** Composer, medium effort, `-p --force --trust`
**Test tier:** NEW TEST FILE ONLY. Parse gate + that ONE test. **Do NOT run the
full suite** — a new test file cannot break another test, and the suite costs
twenty minutes.

---

## Why this task exists, and why it is BLIND

R108 is retargeting a bought animation clip onto our fighter rig. The clip was
authored on the **UE4 Mannequin, which rests in an A-POSE** (arms angled down);
our rig rests in a **T-POSE** (arms horizontal). Everything about that transfer
is a handful of `Basis` multiplications, and **a single inverted term produces a
pose that is wrong by forty-five degrees on exactly the bones a viewer looks at
first.** It will not crash. It will not fail a name-coverage count. It will just
look broken.

So the module and its test are TWO TASKS from ONE CONTRACT.
**You are writing the test. You will not see the module.**

Claude is writing `Godot/scripts/BoneRestFixer.gd` in parallel. **Do not read
it, do not wait for it, and do not open it if it already exists on disk.** Write
every assertion from the contract below and from the geometry — a test written
against an implementation only ever agrees with that implementation.

If your test and the module disagree when Claude integrates, that is the point
of the exercise and Claude settles it in the module. Say so plainly in your
digest if you believe a contract clause is itself wrong.

---

## Owned files

| file | you may |
|---|---|
| `Godot/tests/bone_rest_fixer_test.gd` | **CREATE.** Yours alone. |

Nothing else. Do **not** create, edit or read `Godot/scripts/BoneRestFixer.gd`.
Do **not** edit `HANDOFF.md`.

---

## THE CONTRACT (exact names, exact argument order)

`Godot/scripts/BoneRestFixer.gd` is a statics-only GDScript with **zero
preloads**. Load it in your test with
`load("res://scripts/BoneRestFixer.gd")` and call the statics through that.

It exposes exactly these three statics. All three take and return `Basis`
(rotation only — no translation, no scale).

### 1. `correction(reference_global: Basis, target_rest_global: Basis) -> Basis`

`reference_global` is the **source rig's** global bone basis in a pose that is
posed to MATCH the target rig's rest pose. (For RamsterZ that pose ships in the
pack as `T_pose.fbx`. It is NOT the source rig's own bind rest — the whole point
is that the source's bind rest is an A-pose and must not be used as the
reference.)

`target_rest_global` is the **target rig's** global bone basis at its own rest.

Returns the constant per-bone correction.

### 2. `retarget_global(source_global: Basis, corr: Basis) -> Basis`

Carries one source-rig global bone basis onto the target rig, using the `corr`
returned by `correction`.

### 3. `to_local(parent_global: Basis, child_global: Basis) -> Basis`

Converts an already-retargeted child global basis into the local basis to be
written on the target skeleton, given the already-retargeted parent global.
For a root bone the caller passes `Basis.IDENTITY` as `parent_global`.

---

## THE PROPERTIES YOUR TEST MUST PIN

Compare bases with a tolerance. **Use `1e-4` on each of the nine components**, or
compare the three basis columns with `Vector3.distance_to(...) < 1e-4`. Do not
use `==` on floats.

### P1 — Identity at the reference pose (this is the defining property)

For any `reference_global` R and any `target_rest_global` Q:

```
retarget_global(R, correction(R, Q))  ==  Q
```

Assert this for at least **four** different (R, Q) pairs, including at least one
where both are non-trivial rotations about different axes, and one where
R == Q (which must give `correction(...) == Basis.IDENTITY`).

### P2 — `to_local` inverts a parent composition

For any parent basis P and any local basis C: `to_local(P, P * C) == C`.
Assert for at least three different (P, C) pairs, at least one with P non-trivial.

### P3 — A CHAIN reproduces its own globals

Build a three-link synthetic chain with globals G0, G1, G2 (each a distinct
rotation). Walk it: `L0 = to_local(Basis.IDENTITY, G0)`,
`L1 = to_local(G0, G1)`, `L2 = to_local(G1, G2)`. Then recompose
`L0`, `L0 * L1`, `L0 * L1 * L2` and assert they equal G0, G1, G2.

### P4 — **THE A-POSE CASE. This is the assertion the whole task is for.**

Set up the geometry yourself from this description; do not copy numbers from any
existing file.

Work in a world where **+X is to the character's left**, **+Y is up**,
**+Z is forward**. A bone's *direction* is where its local **+X axis points in
world space** (so at a T-pose the left upper arm's +X points along world +X).

- **Source rig rest (A-pose):** left upper arm's global basis is a rotation that
  puts its +X axis **45° BELOW horizontal**, i.e. pointing along the normalised
  vector `(1, -1, 0)`. Build it as a rotation of `-45°` about the world **Z**
  axis applied to `Basis.IDENTITY`.
- **Source reference pose (`T_pose.fbx` equivalent):** the same bone's global
  basis is `Basis.IDENTITY` — +X exactly horizontal.
- **Target rig rest (T-pose):** the same bone's global basis is also
  `Basis.IDENTITY`.

Now the clip. **A source-rig pose in which the arm is raised 30° ABOVE
horizontal** — global basis = rotation of `+30°` about world Z.

Assert: after `retarget_global(source_pose, correction(reference, target_rest))`,
the resulting basis's **+X column is 30° above horizontal**, i.e. within `1e-4`
of `Vector3(cos(deg_to_rad(30)), sin(deg_to_rad(30)), 0)`.

**And assert the WRONG answer explicitly.** A naive retarget that preserves
*delta-from-rest* instead of absolute orientation lands the arm at
**45° + 30° = 75° above horizontal**. Your test must assert the result is NOT
within `1e-2` of `Vector3(cos(deg_to_rad(75)), sin(deg_to_rad(75)), 0)`, with a
printed line naming 75° as the classic A-pose-onto-T-pose failure. That negative
assertion is what makes this test worth writing.

### P5 — The correction is CONSTANT, not per-frame

Using the P4 geometry, compute `correction(...)` once, then apply it to **five**
different source poses (rotations of −60°, −30°, 0°, +30°, +60° about world Z)
and assert each result's +X column is at that same angle from horizontal. The
correction must never be recomputed per pose.

---

## Output shape

The test is a `SceneTree` script in the repo's existing test idiom. Read
`Godot/tests/` and copy the shape of any recent test file — checks counter,
`failures` counter, a final line, `quit(0)` / `quit(1)`.

**It must print, as its last line before quitting:**

```
BONE_REST_FIXER checks=<N> failures=<M>
```

and it must exit non-zero when `M > 0`.

**If `BoneRestFixer.gd` does not exist yet when you run**, that is expected and
fine. `load()` returns `null`; print

```
BONE_REST_FIXER checks=0 failures=0 (module absent — contract test is standing by)
```

and `quit(0)`. **Do not stub the module to make your own test pass.** A red test
against a missing module is worthless; a green vacuous one is worse.

---

## Gate

```bash
python Godot/tools/check_scripts.py Godot/tests/bone_rest_fixer_test.gd
```

then the one test:

```bash
"$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/bone_rest_fixer_test.gd
```

**Nothing else. No full suite.**

---

## Then

1. `git add -- Godot/tests/bone_rest_fixer_test.gd`
2. Commit (message ends `Co-Authored-By: Cursor <noreply@cursor.com>`), push.
3. `python Tools/agent_comms.py send --from cursor --to claude --subject U50-done
   --body "<hash> checks=N failures=M module-present=yes|no"`
4. Do **not** edit `HANDOFF.md`.

---

## THE ONE TRAP

**You will be tempted to make P4 pass by reasoning backwards from what
`correction()` probably does.** Don't. Derive the expected +X column from the
GEOMETRY — "the arm is 30° above horizontal, therefore its +X column is
`(cos 30°, sin 30°, 0)`" — and let the module agree or disagree with the
geometry. The entire value of this task is that you did not know the
implementation. If the module disagrees, report the numbers; do not adjust the
expectation to match it.
