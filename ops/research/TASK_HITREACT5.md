# TASK HITREACT5 - QWEN (qwen3-coder) - the gap between the last bake stage and the saved clip

Status: OPEN (S411, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).

## Contract
BASE: qwen/hitreact4
OWNS: tools/hit_react_stages.gd, docs/HITREACT3_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
docs/HITREACT3_RESULT.md as HITREACT4 left it, and docs/HITREACT2_RESULT.md (same-window comparison). Reviewed by Claude S411. The stages RAW to FIT are useful: every clip keeps about 84% of the raw head travel, which matches the shorter neck, and no stage after RETARGET moves it. The SAVED column does not follow: WEAK clips fall to 49-57% of RAW, CONTROL clips go UP to 94-121%.
The report calls that gap "a measurement artefact" from interpolation at 30 FPS. No row shows that, and interpolation cannot raise a number to 121%. Remove the claim unless this round proves it. Also remove "The WEAK clips look worse because they're played more often": nothing measured it.

## What would a human do?
Lay the last machine's output and the finished part side by side, frame by frame, over the same stretch of the job.

## Prefab check
tools/hit_react_stages.gd (FIT series, CLIP_SETTINGS), tools/hit_react_probe.gd (reads the saved clip), docs/HITREACT2_RESULT.md (how the matching window was found), tools/owned_mocap_bake.gd (where the saved clip is written and any trim).

## The job
Same six clips. The lead to test first: head travel is measured from the FIRST frame of what is read. The stages read the whole take; a saved clip may start later, at a different frame, so its zero differs. That alone could move a reading either way. Test it before any other idea.
1. For each clip print: frame count and length of the FIT series, and of the saved clip's tracks; which source frames the saved clip covers.
2. Read the saved clip's Head, UpperChest, Hips and Neck directly from its keys, with no AnimationPlayer. Agrees with hit_react_probe within 0.005 m? If not, the probe is the fault: say so.
3. Measure every stage from RAW to FIT again over the saved clip's own frame window and from its own first frame. New table, as metres and % of RAW.
4. Frame by frame, FIT against SAVED over that window: the head position relative to UpperChest, the largest difference and its frame. If they match, the gap was the window. If they do not, name the first frame and the bones where they part, then read tools/owned_mocap_bake.gd from FIT to the save and list every step that could do it.
5. Rewrite the plain-words section from those rows. Name no cause without the row that shows it. Propose nothing to change in the game.

## Rules
scripts/ and tests/ are out of bounds: this task only measures. Do not re-bake or overwrite any clip in assets: write any test bake under E:/FightCamp/tmp/hitreact5. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`, headless, --audio-driver Dummy, --fixed-fps 30, Engine.max_fps = 30. tools/hit_react_stages.gd is at 492 lines: put new code in a new file only if the brief's OWNS allows, otherwise cut unused code first; no file over 500 lines.

## The one trap
Two readings of the same clip that disagree mean one is reading the wrong thing. Do not average them or pick the one you like: find which, and why.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
