# TASK PUNCHFORM1 - QWEN (qwen3-coder) - the maths of a punch's form: one pure module + its test

Status: OPEN (S438, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: the operator S437 on the fight's punches: "the fists have no power , are the animationsbad ?". Claude read 15
punch clips frame by frame and named each fault (ops/research/TASK_CLIPFIX1.md has the table). This task is the PURE
half of the ruler that will measure those faults: the arithmetic on sampled joint positions. The half that loads the
clips is Cursor's (CLIPFIX1) and is NOT this task. No scene, no skeleton, no clip, no preload of any other script.

## Contract
OWNS: scripts/rules/PunchForm.gd, tests/punch_form_rules_test.gd
RED_TEST: tests/punch_form_rules_test.gd -> PUNCH_FORM_RULES failures=0
REGRESSION: file_limits_test
VISUAL: no

## The module (static functions only, `extends RefCounted`, under 300 lines)
Input: `samples`, an Array of Dictionaries, one per frame, in time order:
`{"t": seconds, "shoulder": Vector3, "elbow": Vector3, "wrist": Vector3, "other_wrist": Vector3, "head": Vector3,
"pelvis_yaw": radians, "lead_knee": Vector3}` (shoulder / elbow / wrist are the PUNCHING arm), plus
`facing: Vector3` (unit, horizontal: the way she faces), `contact_t: float`, `guard_wrist: Vector3` (the punching
wrist's place in guard), `head_top_y: float`.
Functions, each returning a float (or a small Dictionary where two numbers are asked):
- `elbow_deg(s)`: the angle at the elbow in degrees, 180 = straight arm.
- `reach(s, facing)`: wrist minus shoulder, along `facing`, metres.
- `peak(samples, facing)`: `{"t", "reach", "elbow_deg"}` at the largest reach.
- `hang_s(samples, facing, within := 0.05)`: seconds of the single continuous run around the peak where reach stays
  within `within` of the peak reach (interpolate the run's two edges linearly between samples; do not just count frames).
- `other_glove(samples, t0, t1)`: `{"low_m": the most the other wrist goes under the chin (chin = head.y - 0.10;
  positive = below), "far_m": its largest distance from the chin point}` over t0..t1.
- `pre_drop(samples, contact_t, deep := 0.25)`: `{"depth_m": the most the wrist goes under its own shoulder before
  contact (positive = below), "held_s": seconds it stays more than `deep` below}`.
- `finish_over_head(samples, head_top_y)`: the wrist's highest y minus head_top_y (positive = above her head).
- `bow_m(samples, contact_t, facing)`: at contact (interpolated), head minus lead_knee along `facing`.
- `hip_turn_deg(samples, t0, contact_t)`: pelvis yaw change in degrees, the short way round (wrap at 180).
- `back_s(samples, contact_t, guard_wrist, within := 0.10)`: seconds from contact until the wrist is first back
  within `within` of guard_wrist; -1.0 if it never is.
- `measure(samples, facing, contact_t, guard_wrist, head_top_y, t0)`: one Dictionary with all of the above.
Empty or one-sample input never errors: every function returns 0.0 (back_s -1.0).

## The test (written FIRST; it must fail before the module exists)
Hand-built sample lists with known answers, each bar named in the failure line:
1. A straight arm reads 180, a right angle 90, a folded arm under 40 (tolerance 0.5).
2. A jab that snaps out and back (peak for one sample) hangs under 0.05 s; the same jab held 0.30 s at the peak reads
   0.30 within 0.02; a punch that reaches the peak twice with a dip between counts only the run around the peak.
3. Samples at uneven time gaps give the same hang as even ones (within 0.02).
4. The other glove 0.20 m under the chin reads 0.20; at the chin reads 0.0 or less.
5. A wrist dropped 0.40 m under the shoulder for 0.20 s before contact reads depth 0.40, held 0.20; a drop AFTER
   contact is not counted.
6. A wrist 0.15 m above the head top reads +0.15; one that stops at chin height reads negative.
7. Head 0.12 m in front of the lead knee at contact reads 0.12; facing turned 90 degrees still reads along facing.
8. Yaw from 170 to -170 degrees reads 20, not 340.
9. back_s: back at 0.35 s reads 0.35 within 0.02; never back reads -1.0.
10. Empty and one-sample input: no error, the zero answers.
11. MUTANTS (prove the test can fail): in the test itself, feed measure() a list where the fault is present and check
    the number is over the bar it should break (hang 0.33 > 0.13; elbow 120 < 150; finish +0.2 > 0).
Print `PUNCH_FORM_RULES failures=N` and quit with 1 when N > 0.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (Variant `:=` inference on Dictionary reads: type the variable; `%%`).
- No ease, clamp, smoothing or offset inside a measure (S416): the numbers are the geometry, nothing else.
- Do not write the bars (150 degrees, 0.13 s) into the module: bars live in Cursor's test.

## Prior research
ops/research/topics/striking.md, ops/research/TASK_CLIPFIX1.md.

## What would a human do?
A coach watching a punch frame by frame checks six things: did the arm straighten, did it come straight back, where
was the other hand, did the hand drop first, where did it finish, did the back bend. This module is those six checks
as arithmetic.

## Prefab check
No asset or library applies; scripts/rules/ShortPunch.gd shows the house style for a pure path module and its test.

Test command: `<godot.exe> --headless --audio-driver Dummy --path . --script res://tests/punch_form_rules_test.gd`
(the plain win64 exe, never the console one). Parse first: `--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/punch_form_rules_test.gd -> PUNCH_FORM_RULES failures=0`.
