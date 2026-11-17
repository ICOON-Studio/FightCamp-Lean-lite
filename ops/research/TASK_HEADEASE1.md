# TASK HEADEASE1 - a ruler for head reactions: when does a hit head peak, and how fast does it come back?

Status: OPEN (S506, Claude main). Discipline: boxing. Model: Qwen (qwen4-max), default.

## Why now
Fight motion week. Blind round r11 (2026-11-17), both critics' SECOND change: head reactions "sized and eased out" -
the furthest point 2-3 frames after contact, then back over 8-12 frames, not a spring snap. HitSnap's settle is an
exponential (tau 0.11 s): the head comes back fastest the frame right after the peak. Claude is changing that curve; we
need a ruler on the film to read before/after (s505b = before).

## What to build
1. `scripts/rules/HeadEase.gd` (new, pure static, ZERO preloads). `analyse(rows: Array) -> Dictionary` over shown.csv rows
   (Strings; columns `frame`, `who`, `clip`, and `<Bone>_x/_y/_z` world metres for Head and Hips).
2. A HIT RUN = consecutive frames of one boxer whose clip contains `hit_by` and none of `gutshot`, `body`, `kidney`,
   `liver` (head shots only). Per frame: `d_cm` = distance (cm) between (Head - Hips) on this frame and (Head - Hips) on
   the run's FIRST frame (the head's move on its own body, so a step back does not count).
3. Per run: `peak_frame` (frames from the run's first frame to its largest d_cm), `peak_cm`, `back_frames` (frames from
   the peak until d_cm first falls under 30% of peak_cm; -1 if it never does inside the run), `max_back_cm` (the largest
   ONE-frame fall of d_cm after the peak: the spring-back speed), `kind` (`jab` / `cross` / `hook` / `uppercut` / `other`
   from the clip name).
4. Summary: `runs`, `peak_frame_p50`, `peak_cm_p50`, `back_frames_p50`, `max_back_cm_p50`, `max_back_cm_p90`,
   `late_share` (runs with peak_frame > 3), `snap_share` (runs with back_frames in 0..4 - came back too fast), and
   `by_kind` {n, peak_cm_p50, back_frames_p50}. Runs shorter than 4 frames are skipped (count them in `skipped`).
5. `tools/head_ease_probe.gd -- csv=<path>`: one line per run (`  run who=.. clip=.. start=.. peak_frame=.. peak=..cm
   back_frames=.. max_back=..cm`), then the last line exactly
   `HEAD_EASE runs=<n> peak_f_p50=<a> peak_p50=<b.b> back_f_p50=<c> max_back_p50=<d.d> max_back_p90=<e.e> late=<x.xx> snap=<y.yy>`.
6. `tests/head_ease_test.gd`: fixtures built in code (no files): a head that moves 12 cm over 2 frames and comes back
   over 10 (peak_frame 2, back_frames ~7-8, not snap); one that peaks at frame 6 (late); one that springs back in 2
   frames (snap, big max_back); a hit run that also slides the hips 20 cm (d_cm stays small: the step is not counted);
   a body-shot clip (not a run); an empty input. Print `HEAD_EASE_TEST failures=<n>`; quit(1) on failures.

## Contract
OWNS: scripts/rules/HeadEase.gd, tests/head_ease_test.gd, tools/head_ease_probe.gd
RED_TEST: tests/head_ease_test.gd -> HEAD_EASE_TEST failures=0
REGRESSION: file_limits_test
VISUAL: no - a measuring tool; no game code changes.
NOT YOURS: every other file (the brief too). Never delete or weaken a test. Own branch, commit, push, never merge.
Each file under 500 lines. Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's
monitors. One test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`.
PR body: `RESULT: tests/head_ease_test.gd -> HEAD_EASE_TEST failures=0`, `RESULT: tests/file_limits_test.gd -> ...`,
and the probe's last line on `E:/FightCamp/tmp/fightweek/s505b/shown.csv` and `E:/FightCamp/tmp/fightweek/r11blind/shown.csv`.

## Prior research
`scripts/rules/PunchEnd.gd`, `scripts/rules/StandOff.gd` and (if merged) `scripts/rules/FreeHand.gd`: csv rows, runs,
`_bone_pos`. `scripts/fight3d/HitSnap.gd` `envelope()` (read only: what is being measured). `ops/research/GDSCRIPT_TRAPS.md`.

## What would a human do?
An animator scrubs the hit frame by frame: the head should be at its furthest on frame 2-3, then drift home over a third
of a second - never jump back the next frame.

## Prefab check
None: loops over csv rows like PunchEnd.

## The one trap
Csv values are Strings - `float()` each, `int()` the frame and who. The film log has BOTH boxers interleaved per frame:
build runs per `who`, never across rows of the other boxer.
