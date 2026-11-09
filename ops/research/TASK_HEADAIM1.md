# TASK HEADAIM1 - QWEN (qwen3-coder) - do the punches aim at the head

Status: OPEN (S416, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).
Source: the operator, on a straight punch in the move preview: "this punch does not aim for the head". In the picture the fist meets the partner's raised gloves at about shoulder height.

## Contract
OWNS: tools/head_aim_probe.gd, docs/HEADAIM1_RESULT.md
RED_TEST: tests/beat_clips_test.gd -> BEATCLIPS failures=0
REGRESSION: beat_clips_test
VISUAL: no

## Prior research
tools/clip_contact.gd (the fight's jab gap, the frame a punch connects). tools/hand_path_probe.gd (the right way to read a hand: inside skeleton_updated, modifiers off, max_fps 30). scripts/fight3d/BeatClips.gd PUNCH (which clips play). scripts/fight3d/MovePlayer.gd (how the preview places the two bodies; the fight uses its own spacing). ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Freeze the punch at full extension and look at where the fist is against the other boxer's chin.

## Prefab check
tools/clip_contact.gd already finds the contact frame.

## The job
You measure. You change no clip and no game code.
tools/head_aim_probe.gd, headless, two boxers of the same height and of different height (mh_boxer_10 and a boxer at least 8 cm taller or shorter; print both heights). For every punch clip that plays (jab, cross, lead_hook, rear_hook, lead_uppercut, rear_uppercut, plain takes and their variants not in OFF_TAKES), at the contact frame from tools/clip_contact.gd's method, print, as shares of body height: the fist's height against the target's Head joint, against its chin (Head joint minus 0.06 of body height) and its sideways miss from the Head joint. Do this twice: in the fight's own spacing, and in the MovePlayer preview's spacing.
docs/HEADAIM1_RESULT.md: one row per clip and setup. Then one paragraph of numbers only: how many head punches end below the chin by more than 0.04 of body height, in the fight and in the preview, and whether a clip does in one setup and not the other. No proposed fix.

## Rules
scripts/ and assets/ are out of bounds. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script tools/head_aim_probe.gd`. No file over 500 lines. No images.

## The one trap
Prove the ruler first. pro_left_jab's hand reach in tools/hand_path_probe.gd is 0.441 of body height (docs/REARHAND1_RESULT.md's control): reproduce it within 0.01 and print `READ_CHECK`. If it misses, stop and report. A body punch must not be counted as a head punch: body_hook is out.

## Result lines (PR body)
RESULT: tests/beat_clips_test.gd -> BEATCLIPS failures=0
