# TASK C124 — CODEX — GLOVES AND ARMS STOP AT CONTACT: THE CONTACT SOLVE'S CONTRACT TEST, WRITTEN BLIND

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (the operator, 2026-09-14: "Gloves/arms still pass through").

**Test tier: A NEW TEST FILE ONLY.** You cannot run Godot or write `.git` (sandbox): write the test, then STOP. Claude
runs it, proves it against deliberate breaks of the module, and commits. Do not open `Godot/scripts/FightContactSolve.gd`
- the test is written from THIS contract, blind, so it agrees with the contract rather than with the code.

## Owned files

- `Godot/tests/fight_contact_solve_test.gd` - NEW. `extends SceneTree`; all work in `_initialize()`; `load()` the module
  there (no top-level `preload`); print `ok  <name>` / `FAIL <name>: <detail>` per check, then
  `TOTAL=<n> fails=<m>` and `quit(1 if m > 0 else 0)`. At least 40 checks.

## The contract (`res://scripts/FightContactSolve.gd`, `extends RefCounted`, all functions static)

A PART is a Dictionary `{"name": String, "class": String, "a": Vector3, "b": Vector3, "radius": float}` in world metres:
a capsule from `a` to `b` with that radius; a sphere has `a == b`.

- `const MOVABLE := ["LeftHand", "RightHand", "LeftLowerArm-LeftHand", "RightLowerArm-RightHand"]`
- `static func pair_contact(p: Dictionary, q: Dictionary, fallback: Vector3 = Vector3(1, 0, 0)) -> Dictionary`
  returns `{"depth": float, "normal": Vector3, "point_p": Vector3, "point_q": Vector3}`: `point_p` / `point_q` are the
  closest points between segment p (a..b) and segment q; `depth = p.radius + q.radius - |point_p - point_q|` (positive =
  overlapping); `normal` is the unit vector from `point_q` to `point_p`, or `fallback.normalized()` when
  `|point_p - point_q| < 1e-6`.
- `static func is_movable(part) -> bool`: true exactly when `part.name` is in MOVABLE.
- `static func arm_of(part) -> String`: `""` for a part that is not movable, otherwise the FIRST LETTER of its name
  (`"L"` or `"R"`).
- `static func hand_pushes(parts_a: Array, parts_b: Array, origin_a: Vector3, origin_b: Vector3) -> Dictionary`
  returns `{"a": {"L": Vector3, "R": Vector3}, "b": {"L": Vector3, "R": Vector3}, "contacts": int}`:
  1. Pairs are visited A's parts in list order, each against B's parts in list order. A pair where NEITHER part is
     movable is skipped (not counted).
  2. The fallback normal is the direction from `origin_b` to `origin_a` with its y set to 0, normalised - or
     `Vector3(1, 0, 0)` when that flattened vector's length < 1e-6. It is passed as `pair_contact(pa, pb, fallback)`.
  3. A pair with `depth <= 0` is skipped (not counted); every other pair adds 1 to `contacts`.
  4. `share` is 0.5 when BOTH parts are movable, 1.0 otherwise. If A's part is movable, A's arm (`arm_of`) is resolved
     with `normal` and `required = depth * share`; if B's part is movable, B's arm is resolved with `-normal` and the
     same `required`.
  5. RESOLVE (per side, per arm, a running total starting at `Vector3.ZERO`): `left = required - total.dot(normal)`;
     when `left > 0`, `total += normal * left`; otherwise the total is unchanged.

## What the test must cover (each with exact expected numbers, tolerance 1e-5)

- `pair_contact`: two spheres overlapping along X (depth and normal both ways); two spheres apart (negative depth);
  exactly touching (depth 0); crossing capsules (closest points mid-segment); a sphere inside a capsule's axis (closest
  points coincide -> the fallback, normalised - pass a NON-unit fallback); parallel capsules.
- `is_movable` / `arm_of` for all four movable names and for `Head`, `Chest-UpperChest`, `LeftUpperArm-LeftLowerArm`
  (NOT movable - an upper arm is fixed).
- `hand_pushes`: a glove into a fixed head (the glove's arm takes the WHOLE depth, the head's side gets nothing); glove
  on glove (each side takes half, opposite directions); forearm on glove; two contacts on ONE arm along the same normal
  (the total is the larger requirement, not the sum); two contacts along perpendicular normals (the total covers both
  - a vector sum); a second contact already covered by the first (adds nothing); a fixed-on-fixed overlap (skipped,
  `contacts` unchanged); a pair that only touches (depth 0, skipped); the coincident fallback using the two origins
  (and the `Vector3(1,0,0)` case when the origins coincide or differ only in y); B's push is the exact negative
  direction of A's for a symmetric glove-on-glove; list ORDER changes the result for two conflicting contacts (build one
  case where visiting order matters and assert the order-specific total); `contacts` counts exactly the resolved pairs.

## Send

`python Tools/agent_comms.py send --from codex --to claude --topic "C124 ready" --body "test written, not run"`. Do not
edit any other file. Do not run Godot.

## The trap

Write expected values by hand from the formulas - never by calling the module you are testing. A test that computes
its expectation with the same function passes against any bug (C114 and C117 each passed 30 checks against a broken
module). Claude will run your test against deliberate breaks of the module (half-share on fixed contacts, the resolve
summing instead of projecting, the wrong normal sign for B, the fallback not normalised, upper arms movable); every one
of them must fail at least one of your checks.
