# TASK PUNCHSNAP1 - ARENA - the maths of a punch's POWER read: one pure module + its test

Status: OPEN (S439, Claude main). Discipline: boxing.
Source: the operator watched the rear cross on a side film and said: "the punches do not feel like they have power,
not sure if it is the clips issue"; and of the jab: "the torso needs to follow the hands movement to show the power
behind the shot". The game already measures a punch's FORM (scripts/rules/PunchForm.gd: elbow, reach, hang, hip turn).
Nothing measures what makes a punch read as POWERFUL: how the fist speeds up and stops, whether the body loads first,
whether the trunk leads the hand. THIS task is that maths, pure, on sampled joint positions. No animation files, no
scenes, no skeleton: the samples are plain dictionaries, and the tests build them by hand.

## Contract
OWNS: scripts/rules/PunchSnap.gd, tests/punch_snap_test.gd
RED_TEST: tests/punch_snap_test.gd -> PUNCH_SNAP failures=0
REGRESSION: punch_form_rules_test, file_limits_test
VISUAL: no
NOT YOURS: every other file. scripts/rules/PunchForm.gd is read for its sample format and style, never edited.

## The sample format (the same one PunchForm.gd reads; read its top 60 lines and tests/punch_form_rules_test.gd)
`samples` is an Array of Dictionaries in time order, uneven time gaps allowed. Keys, all Vector3 in metres, world
space, plus `t` in seconds: `shoulder`, `elbow`, `wrist` (the punching arm), `l_shoulder`, `r_shoulder` (both
shoulder joints), `l_hip`, `r_hip`, `pelvis`, `chest`, `head`, `l_foot`, `r_foot`. A missing key reads as
Vector3.ZERO and the measure that needs it returns its "no data" value (say which in a comment); never an error.
`facing` is a unit Vector3 on the floor plane pointing at the opponent. `contact_t` is the time the punch lands.

## The job: scripts/rules/PunchSnap.gd (pure, static, under 300 lines, zero preloads)
Each function documented with one line saying what a boxing coach would call it.
1. `fist_speed(samples, facing) -> Array` of {t, v}: the fist's speed toward the target (m/s), by central differences
   that are correct on uneven time gaps (the ends one-sided).
2. `peak_speed(samples, facing) -> Dictionary` {t, v}.
3. `speed_at_contact_frac(samples, facing, contact_t) -> float`: the fist's speed at contact divided by its peak
   speed. A punch that is still near top speed when it lands reads heavy (1.0); one that peaked early and is coasting
   reads as a push (toward 0). Interpolate to contact_t.
4. `peak_lead_s(samples, facing, contact_t) -> float`: contact_t minus the time of peak speed (positive = the fist
   peaked BEFORE contact and is slowing; near 0 or slightly negative = it lands at full speed).
5. `stop_s(samples, facing, contact_t, frac = 0.2) -> float`: seconds from contact until the fist's forward speed
   first falls under `frac` of its peak: a snap stops at once, a push drifts on. -1 when it never does.
6. `straighten_s(samples, from_deg = 100.0, to_deg = 160.0) -> float`: seconds the elbow takes to open from `from_deg`
   to `to_deg` on the way out (the first such run before the largest reach), edges interpolated. -1 if the arm never
   passes both. The elbow angle is the angle at `elbow` between `shoulder` and `wrist`.
7. `windup_m(samples, facing, contact_t) -> Dictionary` {back_m, at_t}: how far the fist travels AWAY from the target
   (negative along facing, relative to the pelvis) before it starts forward: the load. 0 when it only ever goes forward.
8. `turn_deg(a0, b0, a1, b1) -> float`: the signed turn (degrees, -180..180, floor plane) of the line a->b between two
   moments; and `shoulder_turn_deg(samples, t0, contact_t, punching_right: bool)` and
   `hip_turn_signed_deg(samples, t0, contact_t, punching_right: bool)`: the shoulder line's and the hip line's turn
   from t0 to contact, SIGNED so that the punching side going toward the target is positive (a turn the wrong way is
   negative, never folded to positive). Both must be independent of which way the boxer faces in the world.
9. `chain_order(samples, facing, contact_t, punching_right) -> Dictionary` {hip_t, shoulder_t, fist_t, ordered: bool}:
   the times of the fastest hip turn, the fastest shoulder turn and the fist's peak speed; `ordered` is true when
   hip_t <= shoulder_t <= fist_t (a punch thrown from the ground up; an arm punch has the fist first).
10. `weight_m(samples, facing, t0, contact_t) -> Dictionary` {pelvis_m, chest_m, head_m}: how far each travels toward
    the target from t0 to contact (interpolated at both ends).
11. `rear_heel_lift_m(samples, t0, contact_t, punching_right) -> float`: how far the punching-side foot rises (y) at
    most between t0 and contact, above its height at t0.
12. `read(samples, facing, contact_t, t0, punching_right) -> Dictionary`: all of the above in one Dictionary, plain
    numbers only, keys named as the functions.

## The test FIRST: tests/punch_snap_test.gd (extends SceneTree, prints `PUNCH_SNAP failures=N`, quits with N)
Build samples by hand from simple motion you can compute exactly (constant speed, constant acceleration, a stop, a
rotation about the vertical axis by a known angle). Never two identical punches in one comparison. Assert at least:
- fist_speed on constant 4 m/s reads 4.0 at every sample (even AND uneven time gaps, to 0.01);
- a fist that accelerates evenly into contact reads speed_at_contact_frac >= 0.95 and peak_lead_s within one sample
  gap of 0; a fist that peaks at 40 % of the way and coasts reads frac < 0.6 and peak_lead_s > 0.05;
- stop_s: a dead stop within one sample reads <= one sample gap; a fist that keeps drifting at half speed reads -1;
- straighten_s: an elbow opening 100 -> 160 degrees linearly over 0.10 s reads 0.10 (to 0.005); never reaching 160 = -1;
- windup_m: 0.12 m back then forward reads 0.12; forward only reads 0;
- shoulder_turn_deg: a shoulder line turned 30 degrees with the punching shoulder forward reads +30 for a right-hand
  punch AND for a left-hand punch built as its mirror; turned the wrong way reads -30; the whole scene rotated 90 and
  180 degrees in the world (facing rotated with it) reads the same numbers; a turn from 170 to -170 reads 20, not 340;
- chain_order: hips then shoulders then fist = ordered; fist first = not ordered;
- weight_m and rear_heel_lift_m on known travels, with t0 and contact_t falling BETWEEN samples (interpolation);
- empty and one-sample arrays: no error, the documented "no data" values;
- MUTANTS, run inside the test: a copy of two measures with a deliberate bug each (for example a sign flipped, the
  interpolation dropped) must FAIL the same asserts; print `MUTANT caught` for each; an uncaught mutant is a failure.

## Traps
- GDScript 4: type every variable read from a Dictionary (`var v: Vector3 = s.get("wrist", Vector3.ZERO)`), `:=` on a
  Variant is an error in this project's settings. `%%` for a literal percent in a format string.
- A test that only your own function can pass is not a test: every expected number comes from the motion you built,
  written as arithmetic in the test, never copied from the function's output.
- Do NOT delete, skip or weaken any existing test to go green. Do not touch CI files.
- No animation assets exist in this mirror: a test that loads a .res, .glb or a scene will fail in CI.

## Prior research
scripts/rules/PunchForm.gd and its test (the house style for this kind of module).

## What would a human do?
A boxing coach judging power on film looks for four things: the body loads before the hand goes; hips, then
shoulders, then fist; the fist is still speeding up when it lands; it stops dead and comes home. The module is those
four looks as numbers.

## Prefab check
None applies: this is arithmetic on positions. PunchForm.gd shows the conventions.

Test command: `godot --headless --audio-driver Dummy --path . --script res://tests/punch_snap_test.gd`. Parse first:
`--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/punch_snap_test.gd -> PUNCH_SNAP failures=0`.
