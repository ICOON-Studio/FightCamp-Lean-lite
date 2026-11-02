# TASK C115 — CODEX — COUNT THE PIPELINE COMPILATIONS IN EVERY LIVE FRAME (K43's FIRST SUSPECT)

Model: `gpt-5.6-luna`, medium (the only setting). Owner: codex. Main checkout, launched by Claude through
`Tools/codex_task.cmd`. Stage: S4a step (1) SMOOTH LIVE RUN - instrument work.

**Test tier: ONE TOOL FILE EDITED + ONE CHECK EXTENDED.** Parse gate on the tool, ONE 10-second HEADLESS smoke run,
then the check. No suite, no windowed run. No commit: your sandbox cannot write `.git`; Claude commits.

## Owned files

- `Godot/tools/measure_live_frames.gd` - yours (you wrote it in C112); edit it.
- `research/C112_check.py` - extend it (Claude wrote it; the additions below are yours).
- `research/C112_live_frames_smoke.json` - rewritten by the smoke run.

## Why this exists

Kalli's K43 (`research/K43_GODOT_FRAME_PACING.md` - read ONLY its `## DECISIONS` section, 6 lines) named the
first stutter to look for in the live room: a one-shot spike when a skinned mesh or material is drawn for the first
time, which Godot 4.4+ counts as pipeline compilations. Your C112 instrument times every frame but cannot see them.

## The change

1. Find the monitors: in a tiny throwaway script (do not commit it) print every `Performance` constant whose name
   contains `PIPELINE` (`ClassDB.class_get_integer_constant_list("Performance")` and
   `ClassDB.class_get_integer_constant("Performance", name)`) - names and values as Godot 4.7.2 has them. Use exactly
   those; do not guess names.
2. In the tool, each frame, read each of those monitors with `Performance.get_monitor(...)` and record the frame's
   total as the INCREASE over the previous frame (they are running counts) - one int per frame, in a NEW top-level
   array `"pipeline_compilations"` beside `"frames"` (do NOT add a column: `columns` stays exactly as C112's check pins).
   Record the constant names used in `population.pipeline_monitors`.
3. In `summary`: `pipeline_compilations_total`, `pipeline_frames` (frames with a count > 0), and
   `hitches.on_pipeline` (hitch frames - C112's definition - that have a count > 0).
4. In `C112_check.py` `check_run`: `pipeline_compilations` must be a list of non-negative ints, one per frame; the three
   summary figures must equal what the check recomputes from that list and the rows; `population.pipeline_monitors`
   must be a non-empty list of strings. Keep every existing pin.

## Gate - from the repo root

1. `python Godot/tools/check_scripts.py Godot/tools/measure_live_frames.gd`
2. `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tools/measure_live_frames.gd --timeout 300 -- seconds=10 label=smoke`
   (or the console exe from Python `subprocess.run(..., timeout=300)` with output to a file - never a PowerShell pipe).
3. `python research/C112_check.py smoke` exits 0.

Headless draws nothing, so the smoke counts may all be 0 - that is expected and proves only the plumbing.

## When done

Your last message: the owned files, the monitor names found, the check's last line. Claude commits.

## The trap

The monitors are running totals since startup: a frame's figure is the difference from the previous frame, never the
raw value - the raw value would put every compilation of the whole run on every later frame.
