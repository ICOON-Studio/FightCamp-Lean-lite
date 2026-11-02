# TASK_G60T — The blind contract test for `FightAnchorIK`

**Owner: Qwen.  Model: qwen3-coder, `--yolo`, medium.**
**Test tier: ONE NEW TEST FILE, NO SCRIPT EDITED — parse gate plus that one
test. A new test file cannot break another test, so DO NOT run the full suite
(318 tests, ~18 min).**

---

## THIS IS A BLIND TEST AND THAT IS THE WHOLE POINT

Grok is writing `Godot/scripts/FightAnchorIK.gd` from a contract. **You are
writing its test from the SAME contract, without reading Grok's code.** A test
written against an implementation only ever agrees with it; a test written
against the contract can disagree, and when two blind halves disagree that
collision is the finding.

**If `Godot/scripts/FightAnchorIK.gd` exists when you start, DO NOT OPEN IT.**
Write the test from this file alone. If your test fails against the delivered
module, that is a RESULT — report it with the numbers, do not adjust your
assertions to match.

## THE CONTRACT YOU ARE TESTING

```gdscript
class_name FightAnchorIK

static func solve(root: Vector3, upper_len: float, lower_len: float,
        target: Vector3, pole: Vector3) -> Dictionary
```

Returns exactly five keys: `"mid"` (Vector3), `"tip"` (Vector3), `"reachable"`
(bool), `"reach"` (float, `upper_len + lower_len`), `"error"` (String, `""` on
success).

```gdscript
static func chain_rotations(root: Vector3, mid: Vector3, tip: Vector3,
        rest_mid: Vector3, rest_tip: Vector3) -> Dictionary
```

Returns `{"upper": Quaternion, "lower": Quaternion, "error": String}`.

### The five cases

1. **In range** (`abs(upper_len - lower_len) <= d <= reach`): `"tip"` lands on
   `target`, `"reachable"` is `true`.
2. **Out of reach** (`d > reach`): the chain extends straight at the target —
   `"mid"` = `root + dir * upper_len`, `"tip"` = `root + dir * reach` —
   `"reachable"` is `false` and **`"error"` is still `""`**.
3. **Too close** (`d < abs(upper_len - lower_len)`): `"tip"` at
   `root + dir * abs(upper_len - lower_len)`, `"reachable"` `false`.
4. **`target` at `root`** (within `1e-6`): no division by zero, a deterministic
   direction, `"reachable"` `false`, `"error"` = `"target at root"`.
5. **Non-positive `upper_len` or `lower_len`**: `"mid"` and `"tip"` both equal
   `root`, `"reachable"` `false`, `"reach"` `0.0`, `"error"` =
   `"non-positive bone length"`.

### The invariants — these are the heart of the test

- `root.distance_to(mid) == upper_len` to **1e-4**, in EVERY case, clamped ones
  included.
- `mid.distance_to(tip) == lower_len` to **1e-4**, in every case.
- When `"reachable"` is true, `tip.distance_to(target) <= 1e-4`.
- **No component of any returned Vector3 or Quaternion is NAN or INF, ever.**
  Test this explicitly with `is_nan()` / `is_inf()` on each component — a
  degenerate solver returns NaN rather than throwing, and a test that only
  compares distances will pass, because every comparison against NaN is false.
- **Purity**: call `solve` twice with identical arguments and assert the results
  are identical.

### The pole cases, which are where such solvers break

- A `pole` PARALLEL to the root→target axis leaves no bend direction. The module
  must still return a finite answer with `"error"` = `""`.
- A vertical axis with `pole` also vertical is the second degenerate case.
- Assert that a pole pointing one way and the opposite pole put `"mid"` on
  OPPOSITE sides of the root→target line — that is what a pole is FOR, and a
  solver that ignores it passes every distance check while bending the elbow the
  wrong way.

## PROVE THE TEST WITH MUTANTS BEFORE YOU CALL IT DONE

A contract test that cannot fail is worthless, and this project has shipped one:
C117 passed 30 checks against a lock on a swinging foot. So **write a throwaway
mutant module and run your test against it** — at least four separate breakages,
each of which your test must catch:

1. a solver that returns `tip = target` always, even out of reach,
2. one that ignores `pole` entirely (always bends the same way),
3. one that returns `mid` at the midpoint of root→target (so bone lengths are
   wrong),
4. one that returns NaN for the degenerate pole.

**Report which mutants your test caught.** If a mutant survives, your test is
incomplete — fix the test, not the mutant.

## WHERE IT GOES

- `Godot/tests/fight_anchor_ik_test.gd` (new, yours)
- Mutants live in your scratch directory and are **not** committed.

Follow the shape of an existing test in `Godot/tests/`: read ONE of them for the
harness conventions — how it prints `FAIL` lines and its final
`N failure(s)` line — and copy that shape exactly. The runner fails a test on a
real script error, on its own `FAIL` line, on no output of its own, or on a
non-zero exit code.

**Load the module with `load()` inside your test function, never a top-level
`preload`** — a top-level preload of a file that does not exist yet is a parse
error, and a parse error HANGS a headless test until its timeout instead of
failing it. Type the result explicitly: `var ik = load("res://scripts/FightAnchorIK.gd")`
then `var out: Dictionary = ik.solve(...)`.

**A `callv` with the wrong arity returns `{}`, not `null`** — so
`if result != null` passes and the assertion measures nothing. That cost C146
three vacuous assertions. Check `result.has("mid")`, never `result != null`.

## GATE

```
python Godot/tools/check_scripts.py Godot/tests/fight_anchor_ik_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_anchor_ik_test.gd
```

If `FightAnchorIK.gd` has not landed yet, your test will fail to load it — that
is expected. Say so and commit the test anyway; Claude runs it against the real
module at integration.

## WHEN DONE

Commit, push, and send one line with
`python Tools/agent_comms.py send --from qwen --to claude --subject g60t-done`.
Do NOT edit `HANDOFF.md`.

## Owned files
`Godot/tests/fight_anchor_ik_test.gd` (collected 2026-09-21, tag collected/g60t-anchor-ik-test).
