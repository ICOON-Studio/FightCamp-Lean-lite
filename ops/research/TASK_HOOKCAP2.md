# TASK HOOKCAP2 - the hard hooks' glove is twice real speed: cap their playback pace (headless)

Status: OPEN (S473, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
docs/SPEEDRULER1_RESULT.md (S473): punch_speed_test's SPEED check catches the hard hooks far over their band:
pro_left_hook_hard 14.5 m/s, pro_right_hook_hard 17.6, pro_right_hook_hard_ft 19.5 (assets/data/punch_pace.json
`top_shown`; their `pace` 1.31 / 1.34 / 1.62). Real punches top out near 11.5 m/s (ops/research/CROSS_POWER_S439.md:
crosses 6-11.5). On screen that is a glove that jumps. The pace comes from BeatClips.speed (scripts/fight3d/BeatClips.gd
line ~204: clampf(far / IMPACT_S[move], 1.0, 2.0)) - it speeds a clip up to land on the beat, with no look at how fast
the glove then travels.

## What to do
1. In BeatClips.speed, after the existing clamp, cap the pace so the glove's shown top speed stays at or under
   TOP_MAX_MS := 11.5: if punch_pace.json's row for the clip has `top_clip` (its top at pace 1) and top_clip * pace >
   TOP_MAX_MS, pace = max(1.0, TOP_MAX_MS / top_clip). Read the row the way the file already reads punch_pace.json
   (PACE_PATH, line ~292). One const, one comment naming this task. Nothing else in the file changes.
2. A clip whose top_clip is already over 11.5 at pace 1 (right_hook_hard_ft 19.5) stays at 1.0: name those in the
   result doc (they need a slower take, not code).
3. Run punch_speed_test before and after (fixed fps) and hit_frame_test; write docs/HOOKCAP2_RESULT.md: per hard hook,
   pace and top speed before/after; the SPEED / SYNC / total counts before/after.

## Pass lines
- punch_speed_test: SPEED failures on lead_hook / rear_hook fall; SYNC stays 0; total not above 41.
- RESULT: tests/punch_speed_test.gd -> PUNCH_SPEED failures=

## Contract
OWNS: scripts/fight3d/BeatClips.gd, docs/HOOKCAP2_RESULT.md
RED_TEST: tests/punch_speed_test.gd -> PUNCH_SPEED failures=
REGRESSION: punch_speed_test (failures <= 41, SYNC 0), hit_frame_test (HIT_FRAME failures unchanged from main)
VISUAL: no
NOT YOURS: every other script, every test, assets/data/punch_pace.json (read it, never write it). No bar changed.
Runs only through `python ops/Tools/godot_slot.py run --who hookcap2 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/punch_speed_test.gd`
(never the _console exe, never a window, never wrapped in `timeout`). One run at a time. Nothing opens on a monitor.
BeatClips.gd is 321 lines: stay under 500.

## Prior research
docs/SPEEDRULER1_RESULT.md (the sort), ops/research/CROSS_POWER_S439.md (real speeds), docs/CLASH2_RESULT.md (fixed fps),
the S470 hook cap memory (the hit ruler read a frame early - fixed).
## What would a human do?
Slow the one punch that looks too fast, leave the rest alone, and check the hit still lands on its beat.
## Prefab check
None: our own pacing rule.
