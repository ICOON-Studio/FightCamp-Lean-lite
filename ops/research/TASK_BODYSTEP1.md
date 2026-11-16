# TASK BODYSTEP1 - a landed punch moves the hit boxer back a little (the rule only, no wiring)

Status: OPEN (S498, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
FIGHT MOTION WEEK (owner S496: "The fight looks terrible should we stop this project ?"). Two blind critics scored the
filmed bout 4/10. Their second fault: "a landed punch gets no reaction". Their first: bodies inside each other. Measured
S498: a hit never moves the hit boxer's place on the canvas (nothing in `scripts/fight3d/HitImpact.gd` or `RangeLive.gd`
does), so after a body shot the puncher and the folded boxer stay 0.8-1.0 m apart at the hips and their heads meet.
A real boxer gives ground when hit: a jab barely, a clean power shot a half step, a body shot a short step back.
This task is the RULE as pure numbers with its test. Claude wires it into the fight afterwards.

## What to build
1. `scripts/fight3d/HitStep.gd` (new, `extends RefCounted`, pure static, no preloads, under 90 lines):
   - `const BACK_M := {"jab": 0.03, "power": 0.10, "body": 0.16, "big": 0.22}` (metres the hit boxer gives)
   - `const OVER_S := {"jab": 0.12, "power": 0.20, "body": 0.22, "big": 0.30}` (seconds the step takes)
   - `const MAX_MPS := 1.4` (the step never moves her faster than this)
   - `static func kind(move: String, big: bool) -> String`: "big" when `big`; else "body" when `move` contains "body" or
     "kidney"; else "jab" when `move` contains "jab"; else "power".
   - `static func back_m(move: String, big: bool, room_m: float = 99.0) -> float`: BACK_M of the kind, never more than
     `room_m` (the room behind her to the ropes; negative room counts as 0).
   - `static func over_s(move: String, big: bool) -> float`: OVER_S of the kind, lengthened when needed so that
     `back_m / over_s` times 1.5 (the ease's top speed) stays at or under MAX_MPS.
   - `static func at(t: float, over: float) -> float`: how much of the step is done `t` seconds after the hit, 0 to 1:
     0 at t <= 0, 1 at t >= over, smoothstep between (`u * u * (3 - 2u)`); `over <= 0` returns 1.
   - `static func moved(move: String, big: bool, t: float, room_m: float = 99.0) -> float`: `back_m * at(t, over_s)`.
   - `-- nohitstep` in `OS.get_cmdline_user_args()` = the control arm: `back_m` returns 0.
2. `tests/hit_step_test.gd` (new, `extends SceneTree`, prints `PASS`/`FAIL` lines and `HIT_STEP failures=<n>`, calls
   `quit(failures)`): kind() for jab / cross / hook / uppercut / body_hook / pro_kidney_shot / big; back_m ordered
   jab < power < body < big; room caps it (room 0.05 -> 0.05, room -1 -> 0); at() is 0, 0.5 at the middle, 1, and never
   decreases over 20 samples; moved() ends exactly at back_m; the top speed (largest step between samples 1/60 s apart,
   divided by 1/60) is at or under MAX_MPS + 0.01 for every kind; at(0.1, 0.0) is 1.

## Contract
OWNS: scripts/fight3d/HitStep.gd, tests/hit_step_test.gd
RED_TEST: tests/hit_step_test.gd -> HIT_STEP failures=0
REGRESSION: file_limits_test
VISUAL: no - a pure rule; Claude wires it and films the bout.
NOT YOURS: every other file. Never delete or weaken a test. Work on your own branch, open a PR into main, never merge.
Run one test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd` (Godot 4.7.2).
Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's monitors.
PR body: `RESULT: tests/hit_step_test.gd -> HIT_STEP failures=0` and `RESULT: tests/file_limits_test.gd -> FILE_LIMITS failures=0`.

## Prior research
`ops/research/S498_DIGEST.md` (causes found: point 3), `E:/FightCamp/tmp/fightweek/r0/critic_animator.md` point 2 and
the fix list point 1 ("push the roots apart ... spread the correction over 4-6 frames ... hand it to the footwork rig
as a step"). `ops/research/GDSCRIPT_TRAPS.md` before writing GDScript (typed `:=` from a Dictionary read is a parse error:
write `var x: float = float(D[k])`).

## What would a human do?
A boxer hit clean to the body takes a short step back to breathe; a jab moves his head, not his feet; a big shot
sends him back a full half step. Nobody is thrown: the step is quick but never a slide faster than a walk.

## Prefab check
None: a small table and an ease inside our own fight.

## The one trap
`over_s` must lengthen, not `back_m` shrink, when the speed cap bites; and smoothstep's top speed is 1.5 times the
average, which is where the 1.5 comes from. Do not wire anything: no other file changes.
