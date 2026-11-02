# TASK C116 — CODEX — THE LEG SOLVE'S CONTRACT TEST, WRITTEN BLIND

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (the foot lock).

**Test tier: A NEW TEST FILE ONLY, AND YOU CANNOT RUN IT.** Your sandbox cannot boot Godot; Claude runs it against
the module. Do not run Godot, do not commit (the sandbox cannot write .git), do not touch any other file.

## Owned file

- `Godot/tests/fight_leg_ik_test.gd` - NEW, yours.

## Why this exists, and why blind

Claude is writing `Godot/scripts/FightLegIK.gd`, the two-bone leg solve the foot lock calls every frame. It is NOT in
this checkout and you must not look for it: a test written against an implementation only agrees with it. You write
the test from the CONTRACT below; Claude runs it against the module. The last sign bug in this project
(Vector3.FORWARD is -Z) passed a test that checked a track against the same wrong axis - so every check here is an
OUTCOME in plain positions and lengths, never an internal axis.

## What to read - ONLY this

`Godot/tests/fight_foot_contacts_test.gd` (read whole) - the house style: `extends SceneTree`, a `_check(ok, label)`
counter, a final `N failure(s)` line, `quit(1)` on any failure. **Load the module with `load()` inside `_init`, not a
top-level `preload`**, so a missing module prints `FAIL module loads` and quits 1 instead of failing to parse.

## THE CONTRACT (exact names, argument order, formulas)

`FightLegIK.gd` is `extends RefCounted`, pure static, zero preloads. Constants:
`MAX_EXTENSION_RATIO := 0.5`, `MIN_EXTENSION_RATIO := 0.2`, `STRAIGHT_MARGIN := 0.0001`.

**`static func reach_limits(animated_reach: float, upper_len: float, lower_len: float, max_ratio: float = 0.5,
min_ratio: float = 0.2) -> Vector2`** - `x` = min reach, `y` = max reach. With `limb = upper_len + lower_len`:
`y = animated_reach` when `animated_reach > limb`, else `animated_reach + (limb - animated_reach) * max_ratio`;
`x = minf(animated_reach, limb * min_ratio)`.

**`static func solve(hip: Vector3, knee: Vector3, ankle: Vector3, target: Vector3, bend_hint: Vector3,
min_reach: float, max_reach: float) -> Dictionary`** returning exactly the keys
`"upper"` (Quaternion), `"lower"` (Quaternion), `"knee"` (Vector3), `"ankle"` (Vector3), `"reach"` (float).
- `upper` and `lower` are GLOBAL rotation deltas: the upper leg's new global basis is `Basis(upper) * old`, the lower
  leg's `Basis(lower) * old`. So the solved positions are exactly
  `knee_out = hip + upper * (knee - hip)` and `ankle_out = knee_out + lower * (ankle - knee)` - and the returned
  `"knee"` / `"ankle"` must equal those.
- With `lab = |knee - hip|`, `lcb = |ankle - knee|`, `d = |target - hip|`:
  `lo = maxf(min_reach, absf(lab - lcb) + STRAIGHT_MARGIN)`, `hi = minf(max_reach, lab + lcb - STRAIGHT_MARGIN)`,
  `hi = maxf(hi, lo)`, `reach = clampf(d, lo, hi)`. The ankle lands on the ray from `hip` through `target` at distance
  `reach` (when `d < 1e-6` the ray is `hip -> ankle` instead).
- The knee bends on the SAME SIDE as the input knee (relative to the hip-ankle line). When the input leg is straight
  (knee on the hip-ankle line), it bends toward `bend_hint`'s component perpendicular to the leg.
- Degenerate input (`lab < 1e-6` or `lcb < 1e-6`): identity quaternions, `knee`/`ankle` returned unchanged,
  `reach = |ankle - hip|`. Never NaN or INF in any output, for any input in this file.

## What the test must check (tolerances: positions and lengths 1e-4, angles 1e-3 rad)

1. `reach_limits` on three cases: animated below limb, equal to limb, above limb (exact formula values).
2. A bent leg (e.g. hip (0,1,0), knee (0,0.55,0.08), ankle (0,0.1,0)) and a reachable target: `ankle` equals the
   target; `|knee - hip|` and `|ankle - knee|` equal the input lengths; `knee`/`ankle` equal the two formulas above.
3. Target equal to the input ankle: both quaternions within 1e-3 rad of identity, outputs equal inputs.
4. Beyond reach: `reach == hi`, `ankle` on the hip->target ray at that distance.
5. Too close (target 1 cm from the hip): `reach == lo`, no NaN.
6. Knee side: moving the target 5 cm toward the hip keeps the solved knee on the input knee's side of the
   hip-ankle line (positive dot of the two perpendicular offsets).
7. A STRAIGHT input leg with a target 20% nearer: the solved knee's perpendicular offset has a positive dot with
   `bend_hint`; repeat with `bend_hint` negated - the knee must go to the other side.
8. Degenerate inputs (`hip == knee`, zero `bend_hint`, `target == hip`): no NaN/INF, the degenerate rule holds.
9. At least 200 seeded random reachable cases (`RandomNumberGenerator`, fixed seed, random leg lengths 0.3-0.6 m,
   random bend, random target inside `[lo, hi]`): every one lands on its target and keeps both lengths. Report the
   worst position error in the output line.
10. Every check prints a label; the file ends with `print("%d checks, %d failure(s)" % [checks, failures])`.

## Deliver

Write the one file. Do not run Godot. Do not commit. Send
`python Tools/agent_comms.py send --from codex --to claude --topic "C116 ready" --body "tests/fight_leg_ik_test.gd written, <N> checks"`.
Do not edit HANDOFF.md.

## The trap

Check OUTCOMES in positions, never the solver's axes or angles: a check like "the rotation axis is +X" can agree with
a wrong implementation. And load the module with `load()` so its absence is a FAIL line, not a parse error that hangs
the headless run.
