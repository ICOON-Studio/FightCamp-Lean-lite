# TASK KNEERULER1 - do both knee rulers read the raw take as the take? (measure only, headless)

Status: OPEN (S474, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
docs/KNEESWEEP2_RESULT.md (read the S474 follow-up at the end): with the footwork rig on, every setting that brings the
rear knee onto the take's line in tests/guard_knee_test.gd (+0.0291, knee out of the hip-ankle-foot plane) pushes the rear
valgus in tests/boxer_footwork_test.gd past its bar 20 (the take's own 17.8 deg, tools/stance_raw.py). The take reads both
at once, so one ruler may misread it inside the game. Check each ruler on the RAW take (rig off) in the game.

## What to do (measure only)
1. Plane ruler, rig off: `<godot> --headless --path . --audio-driver Dummy --fixed-fps 30 --script res://tools/knee_plane_probe.gd -- off=all`
   and the same with the rig on (no `off=`). Record each boxer's lead and rear mean. Compare with tools/knee_plane_raw.py
   (the take outside the game: lead -0.0065, rear +0.0291).
2. Valgus ruler, rig off: copy the valgus maths that tests/boxer_footwork_test.gd uses (find the function that fills
   r[i]["valgus"], around line 262-300) into a NEW probe tools/knee_valgus_probe.gd (under 200 lines) that plays the same
   guard idle with the rig off (the way knee_plane_probe.gd's `off=all` does it) and prints per boxer the worst and mean rear
   and lead valgus over settled guard frames. Run it rig off and rig on.
3. Write docs/KNEERULER1_RESULT.md: a table (ruler, rig off / on, boxer, lead, rear) and ONE paragraph: does each ruler read
   the raw take as the take's own numbers (plane +0.029 rear; valgus about 17.8 rear)? Which one misreads, and by how much?

## Pass lines
RESULT: docs/KNEERULER1_RESULT.md -> KNEERULER rows=8

## Contract
OWNS: docs/KNEERULER1_RESULT.md, tools/knee_valgus_probe.gd
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures= (unchanged: measure only)
REGRESSION: guard_knee_test, boxer_footwork_test (both unchanged from main)
VISUAL: no
NOT YOURS: every script under scripts/ and tests/ (no edit at all).
Runs only through `python ops/Tools/godot_slot.py run --who kneeruler1 -- <godot> ...`. Never the _console exe, never a
window, never wrapped in `timeout`. One run at a time. Read ops/research/GDSCRIPT_TRAPS.md first.

## Prior research
docs/KNEESWEEP1_RESULT.md, docs/KNEESWEEP2_RESULT.md, docs/PELVIS1_RESULT.md, tools/knee_plane_probe.gd header,
tools/knee_plane_raw.py, tools/stance_raw.py, ops/research/KNEEPLANE_S408.md.
## What would a human do?
Before tuning the leg against two tape measures, hold both tapes against the reference and see which one is off.
## Prefab check
None: our own rulers.
