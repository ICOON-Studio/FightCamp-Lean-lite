# TASK C117 — CODEX — THE FOOT LOCK'S STATE MACHINE: A CONTRACT TEST, WRITTEN BLIND

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (the foot lock).

**Test tier: A NEW TEST FILE ONLY, AND YOU CANNOT RUN IT.** Your sandbox cannot boot Godot; Claude runs it against
the module. Do not run Godot, do not commit, do not touch any other file.

## Owned file

- `Godot/tests/fight_foot_lock_test.gd` - NEW, yours.

## Why this exists, and why blind

Claude is writing `Godot/scripts/FightFootLock.gd`: per foot, per frame, it decides whether the foot is pinned
(planted), where, when it lets go, and how a released foot springs back to its animation. It is NOT in this checkout
and you must not look for it. You write the test from the CONTRACT below; Claude runs it. C114's contract test passed
30 checks while a degenerate parameter (blend 0) put a lock on a swinging foot, because no check used it - so this
test must exercise every degenerate parameter listed below.

## What to read - ONLY this

`Godot/tests/fight_leg_ik_test.gd` (your C116 file as collected - read whole): the house style, and the collection fix
to copy: **type every Variant result** (`var s: Dictionary = script.new_state()`, `var p: Vector3 = script.step(...)`);
`var x := script.anything(...)` on a `load()`ed script is a PARSE ERROR in Godot 4.7 and hangs the headless run. Load
the module with `load()` inside `_init`.

## THE CONTRACT (exact names, argument order, rules)

`FightFootLock.gd` is `extends RefCounted`, pure static, zero preloads. Constants (Unreal Engine 5.8 Foot Placement
defaults, metres): `UNPLANT_RADIUS_M := 0.35`, `REPLANT_RADIUS_RATIO := 0.35`, `UNPLANT_STIFFNESS := 250.0`.

**`static func new_state() -> Dictionary`** - exactly the keys `"planted"` (false), `"wanted"` (false), `"lock"`,
`"offset"`, `"offset_v"` (all `Vector3.ZERO`).

**`static func step(state: Dictionary, animated: Vector3, wants: bool, delta: float,
unplant_radius: float = 0.35, replant_ratio: float = 0.35, stiffness: float = 250.0) -> Vector3`** - mutates `state`
and returns the foot's OUTPUT position this frame. `horiz(v)` = `Vector2(v.x, v.z).length()`. In this order:

1. **Plant decision** (`was` = state.planted, `wanted_before` = state.wanted):
   - `wants` false: `planted = false`.
   - else if `was`: if `horiz(lock - animated) > unplant_radius`: `planted = false` and `offset = lock - animated`
     (offset_v kept). Otherwise it stays planted.
   - else if not `wanted_before`: `planted = true`, `lock = animated + offset`.
   - else (wanted, released): if `horiz(offset) <= unplant_radius * replant_ratio`: `planted = true`,
     `lock = animated + offset`.
   - then `wanted = wants`.
2. **Output**:
   - planted: `new_offset = lock - animated`; `offset_v = (new_offset - offset) / delta` when `delta > 0` (else
     unchanged); `offset = new_offset`; return `lock`.
   - not planted, `stiffness <= 0` or `delta` would make it NaN: `stiffness <= 0` sets `offset` and `offset_v` to
     ZERO and returns `animated`. `delta <= 0` leaves `offset`/`offset_v` unchanged and returns `animated + offset`.
   - not planted otherwise: a CRITICALLY DAMPED spring pulls `offset` to zero, exactly (closed form, `w = sqrt(stiffness)`,
     `e = exp(-w * delta)`): `x' = (x + (v + w * x) * delta) * e`, `v' = (v - w * (v + w * x) * delta) * e`, per
     component, with x = offset, v = offset_v; store both; return `animated + offset`.

## What the test must check (positions 1e-5 m)

1. `new_state()` has exactly the five keys and zero values.
2. First wanted frame: returns the animated position (offset zero), `planted` true, `lock` equals it.
3. While planted and the animation drifts less than the radius (e.g. 1 cm a frame for 10 frames): the output is the
   SAME lock every frame, and `offset` equals `lock - animated`.
4. Unplant: drift the animation until `horiz` exceeds the radius - `planted` false that frame, and the output that
   frame equals the spring applied to `offset = lock - animated` (compute the expected value with the closed form).
5. Vertical motion never unplants (a 1 m vertical drift with no horizontal drift stays planted: `horiz` ignores y).
6. Spring: from a released state you build by hand (`planted` false, `offset` e.g. (0.3, 0, -0.2), `offset_v` ZERO)
   stepped with the animation still and `wants` FALSE (so it cannot replant), `horiz(offset)` decreases every frame,
   never crosses zero on any axis (critically damped from rest), and is below 1% of its start after 1.0 s at 30 fps.
7. Replant: once `horiz(offset) <= radius * ratio` with `wants` still true, `planted` is true again and `lock`
   equals `animated + offset` at that frame.
8. `wants` false: never planted, output `animated + offset`, and a fresh state returns `animated` exactly.
9. Degenerate parameters, each its own check, no NaN/INF anywhere: `delta = 0` (planted and released),
   `stiffness = 0` (released foot snaps: output == animated, offset ZERO), `unplant_radius = 0` (plants on the first
   wanted frame, releases on the first frame the animation moves horizontally at all), `replant_ratio = 0` (replants
   only when `horiz(offset)` is exactly 0), `replant_ratio = 1`.
10. Determinism: the same 60-frame input sequence run twice gives identical outputs.
11. File ends with `print("%d checks, %d failure(s)" % [checks, failures])` and `quit(1)` on any failure.

## Deliver

Write the one file. Do not run Godot. Do not commit. Send
`python Tools/agent_comms.py send --from codex --to claude --topic "C117 ready" --body "tests/fight_foot_lock_test.gd written, <N> checks"`.
Do not edit HANDOFF.md.

## The trap

Compute every expected value from the CONTRACT's formulas inside the test - never from a number you "know" the module
will print. And check the degenerate parameters one by one: a lock that holds a swinging foot passes every ordinary case.
