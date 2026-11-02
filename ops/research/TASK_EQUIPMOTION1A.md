# TASK EQUIPMOTION1A - how gym machines move while someone uses them (pure module + headless test)

Repository: ICOON-Studio/FightCamp, branch from `master`. Work on your own `arena/...` branch and open a PR into master; never merge.

## Why
A boxing-club management game (Godot 4.7.2, GDScript). When a fighter or member uses a machine, the machine must move: the treadmill
belt runs, the bike pedals turn, the rowing seat slides, the speed bag rebounds, the skipping rope turns. The heavy bag already has its
own pure module (`Godot/scripts/rules/BagSwing.gd` - read it for the house style). This task is the maths for the rest; the 3D wiring
is a later task.

## Owned files (create both; edit nothing else)
- `Godot/scripts/rules/EquipMotion.gd` - `extends RefCounted`, static funcs only. PURE: no `preload`, no `load(`, no autoload, no
  GameState, no RNG, no Node/scene access, no file access. Results depend only on arguments.
- `Godot/tests/equip_motion_test.gd` - `extends SceneTree`; prints one `PASS <name>` or `FAIL <name>: <detail>` line per check and a
  final `EQUIPMOTION total=<n> fails=<m>`; `quit(0)` only when fails == 0, else `quit(1)`.

## API (exact names)
All times in seconds, distances in metres, angles in radians.
1. `treadmill_belt_offset(t: float, speed_mps: float, belt_loop_m: float = 3.0) -> float` - how far a mark on the belt has travelled
   along the loop, wrapped to [0, belt_loop_m). speed 0 -> 0 always.
2. `bike_crank_angle(t: float, cadence_rpm: float) -> float` - crank angle wrapped to [0, TAU). `bike_fan_angle(t, cadence_rpm,
   gear: float = 3.0) -> float` - the air-bike fan turns `gear` times per crank turn, wrapped to [0, TAU).
3. `rower_stroke(t: float, spm: float) -> Dictionary` - {"seat": 0..1 (0 = catch, front; 1 = finish, back), "handle": 0..1 (same
   meaning), "phase": "drive" or "recovery"}. One stroke = 60/spm seconds; the DRIVE takes 1/3 of it and the RECOVERY 2/3 (the real
   1:2 rhythm). Seat and handle are continuous (no jump between phases); at the finish the handle leads the seat (handle >= seat during
   the second half of the drive).
4. `speed_bag_hit(state: Dictionary, power_0_100: float) -> Dictionary`, `speed_bag_step(state: Dictionary, dt: float) -> Dictionary`,
   `speed_bag_rest() -> Dictionary`, `speed_bag_angle(state: Dictionary) -> float`. A speed bag hit away from the boxer swings to the
   board, rebounds back, swings forward and comes back to the boxer: the classic THREE contacts (back-front-back) per punch. Model it as
   a damped oscillation of angle about straight down, with `contacts` counted each time the bag crosses the board side (angle passes
   +board_angle) and the punch side. After one hit at power 60 the bag makes exactly 3 board/punch contacts and then settles under
   0.05 rad within 1.0 s. Higher power -> larger first swing (monotonic). Every function returns a NEW Dictionary (never mutates input).
5. `rope_angle(t: float, turns_per_min: float) -> float` - skipping rope angle wrapped to [0, TAU).
6. `is_moving(kind: String, rate: float) -> bool` - false when rate <= 0 for "treadmill", "bike", "rower", "rope"; unknown kind ->
   false.

## Real-world numbers the test must use (the module never hard-codes a person's speed)
- Treadmill running 2.5-4.5 m/s; walking 1.3 m/s. Bike cadence 60-110 rpm. Rowing 20-36 strokes per minute. Skipping 120-180 turns
  per minute. Speed bag: a trained boxer lands about 2-4 punches per second.

## Test checks (each its own PASS/FAIL line)
- Treadmill: at 3.0 m/s after 1.0 s the offset is 3.0 mod 3.0 = 0.0 (+-1e-6) and after 0.5 s 1.5; speed 0 -> 0; never outside the loop.
- Bike: 90 rpm -> exactly 1.5 turns per second (angle after 1/3 s = PI, +-1e-6); fan with gear 3 turns 3x faster; wrapped range.
- Rower: at 30 spm one stroke = 2.0 s; drive lasts 0.667 s (+-0.01); seat 0 at t=0, 1 at the end of the drive, back to 0 at 2.0 s;
  sampled every 1 ms the seat never jumps more than 0.01 between samples (continuity); handle >= seat in the late drive.
- Speed bag: power 60 -> 3 contacts, settles < 0.05 rad within 1.0 s; power 90 first swing > power 30 first swing; the input state
  Dictionary is unchanged after hit/step (purity); speed_bag_rest() is at rest.
- Rope: 150 turns/min -> 2.5 turns per second.
- `is_moving` false at 0 for every kind and for an unknown kind; true at a positive rate.
- PURITY: read `res://scripts/rules/EquipMotion.gd` as text in the test and FAIL if it contains `preload`, `load(`, `GameState`,
  `randf`, `randi` or `RandomNumberGenerator`.
- CAN READ WORSE: a deliberately broken copy of one formula inside the test (e.g. a rower with drive 1/2 of the stroke) must fail the
  same rhythm check - assert that the check returns false for it.

## How to run (CI runs it; no LFS models are loaded by this test)
`godot --headless --path Godot --script tests/equip_motion_test.gd` -> `EQUIPMOTION total=<n> fails=0`, exit code 0.

## The one trap
Do not delete or weaken a check to get green - CI's test guard fails a PR whose test lost lines. If a check is wrong, say so in the PR.
