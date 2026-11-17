# TASK HOOKPAST2 - the fling ruler also reads every held punch, not only the ones that reached 85 % of their reach

Status: OPEN (S507, Claude main). Discipline: boxing. Model: Qwen (qwen4-max), default.

## Why now
Fight motion week. S507 filmed the hook fix (s507a / s507b). HookPast (HOOKPAST1) did NOT list the worst stepping hook
(pro_left_hook_ft, who 1, run start frame 3213): its glove stopped 0.29-0.34 m from the other head, so the run never had
a hold frame with the hand at CONTACT_REACH of its furthest reach, and the run was not counted. By hand (S507): from the
run's FIRST frame with `hold` > 0, the punching hand's largest one-frame speed over the next 12 frames was 14.7 m/s on
s506a, 14.1 on s507a, 9.7 on s507b. That number is the one the next fixes are judged on.

## What to build
1. `scripts/rules/HookPast.gd` (edit, stays pure static, ZERO preloads, under 500 lines): a second reading,
   `held(rows: Array) -> Dictionary`, over the SAME punch runs (PUNCH_WORDS / EXCLUDE_WORDS, per `who`, >= 3 frames) and
   the same punching-hand rule. For every run with ANY frame whose `hold` > 0: from the first such frame k0, the hand's
   largest one-frame speed over frames k0+1 .. k0+12 (or the run's end), m/s at 30 fps (metres per frame * 30).
   Per run: clip, who, start frame, `speed_mps`, `speed_frame` (frames after k0). Summary: `runs`, `over6` (speed > 6.0),
   `over9` (speed > 9.0), `p50`, `p90`, `worst` (the 5 fastest: clip, who, start, speed_mps, speed_frame).
   `analyse()` is unchanged (its tests stay green, its line stays the same).
2. `tools/hook_past_probe.gd`: after its existing output, one line per held worst run
   (`  held clip=<c> who=<w> start=<f> speed=<s.s>m/s at=<n>`), then exactly
   `HOOK_HELD runs=<n> over6=<a> over9=<b> p50=<x.x> p90=<y.y>`.
3. `tests/hook_past_test.gd` (edit, never delete a check): fixtures for `held`: a run whose glove stops 0.3 m short of
   the other head but has hold frames, then moves 0.35 m in one frame 4 frames after the first hold (speed 10.5, counted
   over6 and over9, at=4); a run that comes home at 3 m/s (not counted); a run with no hold frame (not in `runs`); both
   boxers interleaved; an empty input.

## Contract
OWNS: scripts/rules/HookPast.gd, tests/hook_past_test.gd, tools/hook_past_probe.gd
RED_TEST: tests/hook_past_test.gd -> HOOK_PAST_TEST failures=0
REGRESSION: file_limits_test
VISUAL: no - a measuring tool; no game code changes.
NOT YOURS: every other file (the brief too). Never delete or weaken a test. Own branch, commit, push, never merge.
Each file under 500 lines. Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's
monitors. One test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`.
PR body: `RESULT: tests/hook_past_test.gd -> HOOK_PAST_TEST failures=0`, `RESULT: tests/file_limits_test.gd -> ...`, and
the probe's HOOK_PAST and HOOK_HELD lines on `E:/FightCamp/tmp/fightweek/s506a/shown.csv` and
`E:/FightCamp/tmp/fightweek/s507b/shown.csv`. Expected roughly (S507 hand count): worst pro_left_hook_ft who 1 start
3213 at 14.7 (s506a) and 9.7 (s507b); over6 3 (s506a) and 4 (s507b).

## Prior research
`scripts/rules/HookPast.gd` (its runs, hand rule, contact rule), `ops/research/S507_DIGEST.md` ("FILMED"),
`ops/research/GDSCRIPT_TRAPS.md`.

## What would a human do?
A coach does not care whether the hook touched the chin: if the fist flies off somewhere fast after the punch is
stopped, it is a swing.

## Prefab check
None: the same loops as HookPast.

## The one trap
Both boxers are interleaved per frame - build runs per `who`. Csv values are Strings - `float()` each. The first hold
frame may be the hit-stop (two frames with the same clip_t): count speed from the frame AFTER it.
