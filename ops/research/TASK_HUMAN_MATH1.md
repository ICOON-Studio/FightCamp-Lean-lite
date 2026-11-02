# TASK HUMAN-MATH1 - pure animation maths for Ludo's "humanlike" plan, round 11 (cloud seat)

Operator S192: "ask ludo what is missing to make the animations like humanlike and do whatever it says". Ludo's numbers of record:
`research/LUDO_ANIMATION_S192.md` section "LUDO ROUND 11" (read it). Codex will wire these into the fight later; this task
is ONLY the pure maths + tests. Create ONLY these files; edit nothing else:
- `Godot/scripts/FightHitAdditive.gd`, `Godot/scripts/FightFlinch.gd`, `Godot/scripts/FightLookAt.gd`,
  `Godot/scripts/FightPunchCurve.gd`, `Godot/scripts/FightGloveSpring.gd` - each `extends RefCounted`, static funcs only, ZERO
  preloads, no nodes, no RNG, every Ludo number a named `const` with a one-line comment quoting Ludo.
- `Godot/tests/human_math1_test.gd` - `extends SceneTree`, prints `HUMAN_MATH1_TEST FAILS=<n>`, quits 1 on any fail.

## Owned files
- `Godot/scripts/FightHitAdditive.gd`, `Godot/scripts/FightFlinch.gd`, `Godot/scripts/FightLookAt.gd`, `Godot/scripts/FightPunchCurve.gd`, `Godot/scripts/FightGloveSpring.gd` (NEW)
- `Godot/tests/human_math1_test.gd` (NEW)
- `AgentComms/messages/*` (the agent's done note)

## API (exact)
1. FightHitAdditive (Ludo rank 1)
   - `snap_angle_deg(damage: float) -> float` = damage x 0.42, capped at 24.
   - `is_full_interrupt(damage: float) -> bool` = damage > 25.
   - `push_cm(damage: float) -> float` = 1.2 .. 4.5 cm, linear in damage over 0..25, clamped.
   - `envelope(t: float) -> float` (0..1 weight at t seconds after contact): rises to 1.0 over 0.045 s, then a spring-damped return
     (zeta 0.85) that is below 0.05 by t = 0.045 + 0.180 and exactly 0 at t >= 0.045 + 0.180 + 0.1.
2. FightFlinch (Ludo rank 3)
   - `triggers(head: Vector3, glove: Vector3, glove_vel: Vector3, defender_is_hit: bool) -> bool`: true when the glove is within
     0.28 m of the head (horizontal-plane cylinder, |dy| <= 0.30 m), speed > 2.5 m/s, and not defender_is_hit.
   - `retreat(head: Vector3, glove: Vector3) -> Vector3` = normalize(head - glove) x 0.065 m (zero vector when coincident).
   - `chin_tuck_deg() -> float` = 8.0. `envelope(t: float) -> float`: 0 -> 1 over 0.060 s (smoothstep), 1 -> 0 over the next 0.160 s.
3. FightLookAt (Ludo rank 5)
   - `aim(forward: Vector3, to_target: Vector3) -> Vector2` (yaw, pitch degrees to turn), clamped to yaw +-42, pitch +-22.
   - `split(yaw_pitch: Vector2) -> Dictionary` {"head": 70%, "neck": 30%} of each angle.
   - `step(current: Vector2, vel: Vector2, target: Vector2, dt: float) -> Dictionary` {"pos", "vel"}: critically damped spring,
     omega 14 rad/s; a 30 deg step settles within 1 deg in <= 0.5 s with zero overshoot.
   - `target_weights() -> Dictionary` {"chest": 0.8, "glove": 0.2}.
4. FightPunchCurve (Ludo rank 6)
   - `remap(u: float) -> float` normalized clip time -> normalized pose time: extension 0..0.45 driven by an acceleration exponent
     2.8 (u' = (u/0.45)^2.8 x 0.45 mapped so pose time reaches the impact pose exactly at u = 0.45), monotonic non-decreasing,
     remap(0) = 0, remap(1) = 1.
   - `impact_hold_s() -> float` = 1.0 / 60.0. `retraction_s() -> float` = 0.22.
   - `extension_ratio(ext_s: float, ret_s: float) -> bool` = ret/ext within 1.6..2.0 (Ludo's 1:1.6 to 1:2.0).
5. FightGloveSpring (Ludo rank 9)
   - `step(offset: Vector3, vel: Vector3, target: Vector3, dt: float) -> Dictionary` {"offset", "vel"}: spring omega 28 rad/s,
     zeta 0.72, result offset clamped to length <= 0.018 m.

## Acceptance (the test, one block per module)
- HitAdditive: 10 dmg -> 4.2 deg; 80 dmg -> 24 deg; 30 dmg -> interrupt; push 0 -> 1.2 cm, 25 -> 4.5 cm; envelope peak 1.0 at 45 ms,
  < 0.05 at 225 ms, 0 at 325 ms.
- Flinch: glove 20 cm away at 3 m/s -> true; 35 cm away -> false; 20 cm at 2 m/s -> false; defender_is_hit -> false; retreat length
  0.065 and points away from the glove; envelope 1.0 at 60 ms, 0 at 220 ms.
- LookAt: a target 90 deg to the side clamps to yaw 42; split 70/30; spring settles a 30 deg step in <= 0.5 s, never overshoots.
- PunchCurve: remap(0)=0, remap(1)=1, monotonic over 200 samples, remap(0.45) = the impact pose time; ratio 0.12/0.22 -> true,
  0.12/0.30 -> false.
- GloveSpring: a 5 cm target is clamped to 1.8 cm; after a sudden target change the offset overshoots then settles (zeta < 1).
Mutants you must run and report (each must FAIL the test): (a) snap factor 0.24 instead of 0.42; (b) flinch radius 0.38; (c) look-at
pitch clamp 42; (d) remap not monotonic (drop the clamp); (e) glove clamp removed.
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/human_math1_test.gd` (Linux: the Godot 4.7.2 headless
binary from Tools/cloud_setup.sh) -> `HUMAN_MATH1_TEST FAILS=0`, no SCRIPT ERROR. Push your branch; open a PR; never master.
