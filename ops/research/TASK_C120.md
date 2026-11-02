# TASK C120 — CODEX — DEAD BLENDING'S CONTRACT TEST, WRITTEN BLIND FROM UNREAL 5.8'S CODE

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (the joins - the operator's "jerky moves").

**Test tier: A NEW TEST FILE ONLY, AND YOU CANNOT RUN IT.** Your sandbox cannot boot Godot; Claude runs it against the
module and breaks the module on purpose to prove every check bites. Do not run Godot, do not commit, do not touch any
other file.

## Owned file

- `Godot/tests/fight_dead_blend_test.gd` - NEW, yours.

## Why this exists, and why blind

The operator watched the 3D fight and named "jerky moves" among the worst things on screen; our joins between clips
turn joints at 2-3.4x the speed of the performance itself. Your C119 read Unreal 5.8's Dead Blending node. Claude will
write `Godot/scripts/FightDeadBlend.gd`, a pure GDScript port of its math, and it is NOT in this checkout - do not look
for it. You write the test from the CONTRACT below, and wherever the contract says "as Unreal", from the installed
Unreal code itself (`C:/Program Files/Epic Games/UE_5.8/`, read-only; the lines are named). Two readings of one source
that agree are worth far more than a test written against the implementation.

## What to read - ONLY these

- `Godot/tests/fight_foot_lock_test.gd` (your C117 file as collected - read whole): the house style and the rule that
  saves a pass: **type every Variant result** (`var q: Quaternion = script.from_rotation_vector(v)`); `var x :=
  script.f(...)` on a `load()`ed script is a PARSE ERROR in Godot 4.7 and hangs the headless run. `load()` the module
  inside `_init`.
- `C:/Program Files/Epic Games/UE_5.8/Engine/Source/Runtime/Engine/Private/Animation/AnimNode_DeadBlending.cpp`
  lines `82-260` (helpers), `360-420` (velocity, clamp, half-lives), `575-600` (the blend).
- `C:/Program Files/Epic Games/UE_5.8/Engine/Source/Runtime/Core/Private/Math/UnrealMath.cpp` lines `1454-1506`
  (`TQuat::Log`, `TQuat::Exp`); `.../Core/Public/Math/Quat.h` lines `1193-1205` and `1274-1291`.
- `C:/Program Files/Epic Games/UE_5.8/Engine/Source/Runtime/Engine/Private/AlphaBlend.cpp` line `247` (HermiteCubic).

## THE CONTRACT (exact names, argument order, rules)

`FightDeadBlend.gd` is `extends RefCounted`, pure static, zero preloads. Units are Godot's: metres, radians, seconds.
Constants: `HALF_LIFE_S := 1.0`, `HALF_LIFE_MIN_S := 0.05`, `HALF_LIFE_MAX_S := 1.0`, `MAX_ROTATION_SPEED := TAU`
(radians per second - Unreal's 360 degrees), `MAX_TRANSLATION_SPEED := 5.0` (m/s - Unreal's 500 cm/s),
`BLEND_S := 0.25`, `SMALL := 1e-8` (`UE_SMALL_NUMBER`), `KINDA_SMALL := 1e-4` (`UE_KINDA_SMALL_NUMBER`).

1. **`static func rotation_vector(q: Quaternion) -> Vector3`** - as Unreal's `ToRotationVector` = `2 * Log(q).xyz`:
   if `absf(q.w) < 1.0`: `a = acos(q.w)`, `s = sin(a)`; if `absf(s) >= SMALL` return `Vector3(q.x, q.y, q.z) * (2 * a / s)`.
   Otherwise return `Vector3(q.x, q.y, q.z) * 2`. No sign flip: a quaternion with `w < 0` gives an angle above PI.
2. **`static func from_rotation_vector(v: Vector3) -> Quaternion`** - as Unreal's `MakeFromRotationVector` =
   `Exp(v / 2)`: `a = (v / 2).length()`, `s = sin(a)`, `w = cos(a)`; xyz = `(v / 2) * (s / a)` when `absf(s) >= SMALL`,
   else `v / 2` unscaled.
3. **`static func shortest_arc_with(q: Quaternion, other: Quaternion) -> Quaternion`** - as `EnforceShortestArcWith`:
   `q` when `other.dot(q) >= 0.0`, else `-q` (all four components negated).
4. **`static func clip_magnitude(x: float) -> float`** - as `ClipMagnitudeToGreaterThanEpsilon` with `KINDA_SMALL`:
   `0 <= x < KINDA_SMALL` -> `KINDA_SMALL`; `-KINDA_SMALL < x < 0` -> `-KINDA_SMALL`; otherwise `x`.
5. **`static func decay_half_life(src_dst_diff: float, src_velocity: float, half_life: float = HALF_LIFE_S,
   half_life_min: float = HALF_LIFE_MIN_S, half_life_max: float = HALF_LIFE_MAX_S) -> float`** -
   `clampf(half_life * (src_dst_diff / clip_magnitude(src_velocity)), half_life_min, half_life_max)`.
6. **`static func translation_velocity(prev: Vector3, curr: Vector3, dt: float, max_speed: float =
   MAX_TRANSLATION_SPEED) -> Vector3`** - `Vector3.ZERO` when `dt <= SMALL`; else `(curr - prev) / dt`, then clamped to
   length `max_speed` (direction kept, as `GetClampedToMaxSize`).
7. **`static func rotation_velocity(prev: Quaternion, curr: Quaternion, dt: float, max_speed: float =
   MAX_ROTATION_SPEED) -> Vector3`** - `Vector3.ZERO` when `dt <= SMALL`; else `d = shortest_arc_with(curr *
   prev.inverse(), Quaternion.IDENTITY)`, `rotation_vector(d) / dt`, clamped to length `max_speed`.
8. **`static func translation_half_lives(src: Vector3, dst: Vector3, velocity: Vector3, half_life: float = HALF_LIFE_S,
   half_life_min: float = HALF_LIFE_MIN_S, half_life_max: float = HALF_LIFE_MAX_S) -> Vector3`** - per component,
   `decay_half_life((dst - src).c, velocity.c, ...)`.
9. **`static func rotation_half_lives(src: Quaternion, dst: Quaternion, velocity: Vector3, half_life, half_life_min,
   half_life_max) -> Vector3`** (same defaults) - `diff = rotation_vector(shortest_arc_with(dst * src.inverse(),
   Quaternion.IDENTITY))`, then per component `decay_half_life(diff.c, velocity.c, ...)`.
10. **`static func extrapolate_translation(translation: Vector3, velocity: Vector3, half_lives: Vector3, t: float) ->
    Vector3`** - as `ExtrapolateTranslation` but with the EXACT exponential (Unreal's `InvExpApprox` is a speed
    approximation we do not copy): if `velocity.length_squared() <= SMALL` return `translation`; else per component
    `C = ln(2) / maxf(half_lives.c, SMALL)`, `offset.c = (velocity.c / maxf(C, SMALL)) * (1 - exp(-C * t))`; return
    `translation + offset`.
11. **`static func extrapolate_rotation(rotation: Quaternion, velocity: Vector3, half_lives: Vector3, t: float) ->
    Quaternion`** - the same offset vector as rule 10 built from `velocity` and `half_lives`; return `rotation` when
    `velocity.length_squared() <= SMALL`, else `from_rotation_vector(offset) * rotation` (the offset applied on the
    LEFT, as Unreal).
12. **`static func blend_alpha(elapsed: float, duration: float = BLEND_S) -> float`** - the weight of the EXTRAPOLATED
    pose: `x = clampf(elapsed / maxf(duration, SMALL), 0.0, 1.0)`; return `1.0 - x * x * (3.0 - 2.0 * x)`
    (Unreal's default `HermiteCubic` is `SmoothStep(0, 1, x)`).
13. **`static func blend_translation(incoming: Vector3, extrapolated: Vector3, alpha: float) -> Vector3`** -
    `incoming.lerp(extrapolated, alpha)`.
14. **`static func blend_rotation(incoming: Quaternion, extrapolated: Quaternion, alpha: float, direction: Quaternion)
    -> Array`** - returns `[rotation: Quaternion, direction: Quaternion]`: `diff = shortest_arc_with(extrapolated *
    incoming.inverse(), direction)`; the new direction is `diff`; `rotation = from_rotation_vector(rotation_vector(diff)
    * alpha) * incoming`. A new blend starts with `direction = Quaternion.IDENTITY`.

## What the test must check (positions 1e-6 m, angles 1e-6 rad, unless a check says otherwise)

Each check carries a one-line comment naming the Unreal line it derives from, or the contract rule where it is ours.

1. The eight constants, exactly.
2. `rotation_vector` / `from_rotation_vector` round-trip for rotations of 0.3, 1.0, 2.5 rad about non-axis-aligned
   axes; `rotation_vector(Quaternion(axis, 3.0))` has length 3.0 along `axis`; a `w < 0` quaternion gives an angle
   ABOVE PI (no silent flip); identity -> `Vector3.ZERO`; `from_rotation_vector(Vector3.ZERO)` -> identity.
3. `shortest_arc_with`: dot >= 0 keeps, dot < 0 negates all four; dot exactly 0 keeps.
4. `clip_magnitude`: 0 -> +KINDA_SMALL, -1e-5 -> -KINDA_SMALL, 5e-5 -> +KINDA_SMALL, 0.5 and -0.5 unchanged.
5. `decay_half_life`: velocity toward the destination gives `half_life * diff / velocity` inside the clamp; opposite
   signs give `half_life_min`; a tiny velocity gives `half_life_max`; custom min/max respected.
6. Velocities: a 0.1 m step in 0.1 s is 1 m/s; a 1 m step in 0.1 s is clamped to exactly 5 m/s along the step;
   `dt` 0 and negative -> ZERO. A 30-degree turn in 1/30 s is clamped to TAU rad/s; a 5-degree turn in 1/30 s is not;
   a turn given through a NEGATED `curr` quaternion gives the same velocity (the shortest-arc rule).
7. Half-lives per component, including one component toward, one away, one with zero velocity.
8. Extrapolation: `t = 0` returns the input exactly; zero velocity returns the input for any `t`; as `t` grows the
   offset approaches `velocity * half_life / ln(2)` per component and never passes it; the rotation version equals
   `from_rotation_vector(offset) * rotation` and differs from `rotation * from_rotation_vector(offset)` for a
   non-commuting pair (the side matters).
9. `blend_alpha`: 1.0 at 0, 0.5 at half the duration, 0.0 at and after the end, 1.0 for negative elapsed; duration 0
   gives 0.0 for any positive elapsed (the SMALL guard, no NaN); 0.84375 at a quarter (`1 - smoothstep(0.25)`).
10. Blends: alpha 1 returns the extrapolated pose, alpha 0 the incoming, alpha 0.5 the halfway rotation about the
    diff's axis; a diff past 180 degrees with `direction` identity takes the SHORT way, and with `direction` set to the
    previous frame's long-way diff it keeps the LONG way (Unreal's direction tracking); the returned direction is the
    diff actually used.
11. DEGENERATE PARAMETERS (C114's lesson: 30 checks passed while blend 0 put a lock on a swinging foot): half-life 0,
    duration 0, `dt` 0, velocity exactly zero, `t` negative, alpha outside 0..1 - each gives a finite result (no NaN,
    no INF) and the value the rules above imply.

## When done

Write only `Godot/tests/fight_dead_blend_test.gd` (a `SceneTree` script printing `N failure(s)` and exiting 1 on any
failure, like your C117). Then `python Tools/agent_comms.py send --from codex --to claude --topic "C120 ready" --body
"tests/fight_dead_blend_test.gd written, N checks"`. Do not commit.

## The trap

Two quaternion traps. Godot's `Quaternion * Quaternion` applies the RIGHT operand first, like Unreal's; and
`Quaternion(axis, angle)` needs a NORMALIZED axis - an unnormalized one silently builds a different rotation, and a
test built on it agrees with nothing.
