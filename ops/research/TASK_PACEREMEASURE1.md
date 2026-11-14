# TASK PACEREMEASURE1 - is punch_pace.json stale, and what would a fresh one change? (measure only, headless)

Status: OPEN (S473, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
assets/data/punch_pace.json (37 punch clips: start_s, drive_v, pace, glove tops) was last written 2026-11-12 (626417ad).
S473 re-ran tools/punch_pace.gd (207 lines) and it rewrote most rows, not only the three hard hooks HOOKCAP2 changed:
pro_right_cross_b start_s 0.000 -> 0.207, pro_right_hook 0.20 -> 0.35, several drive_v reshuffled (docs/HOOKCAP2_RESULT.md,
last section). Either the body under the punch changed since (S471-S472 knee band, hips, the PunchReach split), or the tool
is not repeatable. Nobody knows which, so the file cannot be trusted or replaced.

## What to do (measure only - commit no new punch_pace.json)
1. Run tools/punch_pace.gd TWICE (fixed fps 60), saving the json each time to docs/paceremeasure1/run1.json and run2.json
   (copy assets/data/punch_pace.json after each run, then `git checkout -- assets/data/punch_pace.json` to put main's back).
   Are run1 and run2 identical? If not, which fields move and by how much.
2. With run1's file in place (temporarily), run tests/punch_speed_test.gd and tests/hit_frame_test.gd and
   `python tools/speed_ruler_sort.py <log>`; then main's file back and the same two tests. Put main's file back at the end.
3. Write tools/pace_diff.py (stdlib, under 150 lines): two punch_pace.json files -> one line per changed clip and field.
4. docs/PACEREMEASURE1_RESULT.md: (a) repeatable or not, (b) the pace_diff of main v run1, (c) punch_speed (SPEED/FIRST/POP/SYNC)
   and hit_frame failures for main v run1, (d) ONE paragraph: would the fresh file make punches better or worse by these
   numbers, and which clips change most.

## Pass lines
- RESULT: tools/pace_diff.py -> PACE_DIFF clips=<n>
- The result doc with all four parts; `git status` clean of assets/data/punch_pace.json at the end.

## Contract
OWNS: tools/pace_diff.py, docs/PACEREMEASURE1_RESULT.md, docs/paceremeasure1/run1.json, docs/paceremeasure1/run2.json
RED_TEST: tests/punch_speed_test.gd -> PUNCH_SPEED failures= (stays as main: measure only)
REGRESSION: punch_speed_test (PUNCH_SPEED failures=42 on main), hit_frame_test (HIT_FRAME failures unchanged)
VISUAL: no
NOT YOURS: assets/data/punch_pace.json (never committed changed), every script under scripts/, every test, tools/punch_pace.gd.
Runs only through `python ops/Tools/godot_slot.py run --who paceremeasure1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/punch_pace.gd`
(the same for the two tests). Never the _console exe, never a window, never wrapped in `timeout`. One run at a time.

## Prior research
docs/HOOKCAP2_RESULT.md, docs/SPEEDRULER1_RESULT.md, tools/punch_pace.gd header (what start_s and drive_v mean),
ops/research/CROSS_POWER_S439.md, docs/CLASH2_RESULT.md (fixed fps makes runs repeat).
## What would a human do?
Measure twice before trusting either number, then compare the old and the new on the same ruler.
## Prefab check
None: our own data.
