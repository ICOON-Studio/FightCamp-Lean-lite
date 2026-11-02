# TASK ANIM-INERT1 - FightInertialize (pure) + Ludo's transition table as data (cloud Qwen)

Part of ANIM-SMOOTH2 (`research/TASK_ANIM_SMOOTH2.md`, spec item 2). Operator S192: "the animations are not feeling smooth".
Create ONLY these three files; edit nothing else:
- `Godot/scripts/FightInertialize.gd` - `extends RefCounted`, static funcs only, ZERO preloads, no nodes, no RNG.
- `Godot/assets/data/anim_transitions.json` - Ludo's round-10 table, transcribed EXACTLY from
  `research/LUDO_ANIMATION_S192.md` section "LUDO ROUND 10": every row -> {"from": class, "to": [classes], "blend":
  "inertialize"|"pose_match"|"cut", "duration_s": float, "exit_frac": float, "chain": bool}, plus "never_blend" and
  "never_interrupt" lists from his "Strict Transition Constraints".
- `Godot/tests/anim_inert1_test.gd` - `extends SceneTree`, prints `ANIM_INERT1_TEST FAILS=<n>`, quits 1 on any fail.

## Owned files
- `Godot/scripts/FightInertialize.gd` (NEW)
- `Godot/assets/data/anim_transitions.json` (NEW)
- `Godot/tests/anim_inert1_test.gd` (NEW)
- `AgentComms/messages/*` (the agent's done note)

## API (exact)
- `static func capture(prev: Quaternion, prev_vel: Vector3, next: Quaternion) -> Dictionary` -> {"offset": Quaternion (prev * next.inverse()),
  "vel": Vector3 (angular velocity rad/s, carried)}.
- `static func offset_at(state: Dictionary, t: float, half_life: float, duration: float) -> Quaternion` - the decaying offset at time t
  since the switch: a critically damped decay of the offset angle using the carried velocity at t=0 (Holden "dead blending" /
  inertialization: x(t) = (x0 + (v0 + x0*k) * t) * exp(-k*t), k = ln2/half_life), clamped to identity at t >= duration.
- `static func apply(state: Dictionary, next_now: Quaternion, t: float, half_life: float, duration: float) -> Quaternion`
  = offset_at(...) * next_now.
- `static func rule(table: Dictionary, from_class: String, to_class: String) -> Dictionary` -> the matching row or {} (unknown pair).

## Acceptance (the test)
1. A 30-degree offset with zero velocity decays below 1 degree by t = 4 half-lives (half_life 0.05) and is exactly identity at t >= duration.
2. With v0 in the direction of motion, the offset angle at t = 0.01 s is LARGER than at t = 0 (momentum carried - no dead stop).
3. A "cut" row: rule() returns blend "cut", duration 0.
4. The JSON loads; rows JAB->CROSS (0.09, exit 0.52, chain true), ANY NON-STAGGER->HIT_REACT (0.04), GET_UP->GUARD_IDLE (0.35) are
   present with Ludo's numbers; "-> KNOCKDOWN" is in never_blend; an unknown pair returns {}.
Mutants you must run and report (each must FAIL the test): (a) offset_at ignores v0; (b) decay uses t instead of exp; (c) the table
JAB->CROSS duration typo 0.9.
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/anim_inert1_test.gd` (Linux: the Godot 4.7.2 headless binary
from Tools/cloud_setup.sh) -> `ANIM_INERT1_TEST FAILS=0`, no SCRIPT ERROR. Push your branch; open a PR; never master.
