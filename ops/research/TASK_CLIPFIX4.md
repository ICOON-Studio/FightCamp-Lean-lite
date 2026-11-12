# TASK CLIPFIX4 - QWEN (qwen3-coder) - the punch ruler and the three retimed jabs: every defect of the two reviews

Status: OPEN (S438, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: CLIPFIX3 (PR 223, your run, NOT merged). Two blind reviewers re-ran your tool and tests. The retime itself is
clean and the game plays the fixed takes; the ruler and both tests are not honest yet. THE SPEC OF THIS TASK IS
ops/research/CLIPFIX3_REVIEW_S438.md: read it whole, fix EVERY numbered defect in both halves, and answer each by
its number in docs/CLIPFIX4_RESULT.md (fixed: what you did and the new numbers / not fixed: why).
START: `git fetch origin qwen/clipfix3:refs/remotes/origin/qwen/clipfix3` then
`git checkout origin/qwen/clipfix3 -- tools/punch_form.gd tools/jab_retime.gd tests/punch_form_test.gd tests/jab_retime_test.gd assets/data/punch_form.json assets/anim/baked/fixed scripts/fight3d/FightClips.gd docs/CLIPFIX3_RESULT.md`
and `git mv docs/CLIPFIX3_RESULT.md docs/CLIPFIX4_RESULT.md`. Do NOT take that branch's clip_contact / clip_recovery /
clip_travel rows: re-measure them (below).

## Contract
OWNS: docs/CLIPFIX4_RESULT.md, tools/punch_form.gd, tests/punch_form_test.gd, assets/data/punch_form.json, tools/take_fix.gd, tools/jab_retime.gd, scripts/fight3d/BeatClips.gd, scripts/fight3d/FightClips.gd, tests/beat_clips_test.gd, tests/jab_retime_test.gd, assets/anim/baked/fixed/, assets/data/clip_contact.json, assets/data/clip_recovery.json, assets/data/clip_travel.json
RED_TEST: tests/jab_retime_test.gd -> JAB_RETIME failures=0
REGRESSION: punch_form_test, beat_clips_test, beat_tally_test, short_punch_test, punch_form_rules_test, file_limits_test
VISUAL: no
NOT YOURS: scripts/rules/PunchForm.gd (if a measure in it is wrong, say so in the result file with a failing example;
do not edit it), scripts/fight3d/FightStage.gd, PunchReach.gd, RkClips.gd.


## The decisions already taken (do not reopen)
1. The shoulder is the UpperArm joint (LeftUpperArm / RightUpperArm), never the collarbone bone. Re-measure all 15.
2. Guard references (the punching wrist AND the other glove) are the pose at the clip's FIRST frame, relative to the
   pelvis. Back-to-guard searches to the clip's end. Both GOOD controls must read a real time.
3. Bars are the brief's: other glove far 0.30, cross hip turn >= 20, hook pre-drop <= 0.25 come back. Only hang
   (0.15) and pre-drop held (0.18) keep their measured raise. A catch closer than 2 % of the bar to the bar is
   printed as "on the line", not as a catch. A faulty clip the bars do not catch is a "ruler disagrees" row in the
   result file with the eye's fault and the numbers; the test FAILS when a clip that is on neither list clears all
   bars, when a control fails, when punch_form.json is older than any take it measures, or when a measure is out of
   its sane range.
4. The retime keeps the punch's timing: the compressed span starts at the peak sample (the hold AFTER full reach),
   never during the extension. contact_s stays within one frame (0.017 s) of the original. Hang on the RULER's own
   measure (PunchForm.hang_s on the game-loaded take) is <= 0.14 for all three; the test and the ruler use that one
   number. Ease the time scale over two keys at each edge of the span.
5. tests/jab_retime_test.gd loads the ORIGINAL take beside the fixed one (as `o_<name>` through
   FightClips._add_baked) and compares the two: original hang > 0.15 (its own red "before"), contact by
   clip_contact.gd's measure within one frame, peak reach within 2 %, first and last pose within 1 cm over ALL
   bones, the worst 60 Hz step of any bone no more than the original's x (original hang / 0.14) + 0.01 m.
6. After the final takes: run tools/clip_contact.gd, clip_recovery.gd and clip_travel.gd and commit ONLY the three
   jab rows exactly as the tools print them.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first. Headless only. Never overwrite a file in assets/anim/baked/.
- A test that compares a thing with itself prints 0.0 % on every row: if you see that, the test is broken.
- Write the result file last, from the final run's numbers, never from an earlier run.

## Prior research
ops/research/CLIPFIX3_REVIEW_S438.md, ops/research/TASK_CLIPFIX3.md, ops/research/TASK_CLIPFIX2.md (the eye's table).

## What would a human do?
An animator trims the hold after the punch has landed, not the punch; and checks the trimmed take against the
original, side by side, before calling it done.

## Prefab check
tools/clip_contact.gd holds the contact measure to reuse; tools/take_fix.gd shows how a baked take is edited.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless
--audio-driver Dummy --path . --script res://tests/jab_retime_test.gd` (the plain win64 exe, never the console one).
Parse first: `--check-only` on each touched file. Under 500 lines a script.
RESULT lines for the PR body: `RESULT: tests/jab_retime_test.gd -> JAB_RETIME failures=0` and
`RESULT: tests/punch_form_test.gd -> PUNCH_FORM failures=0`.
