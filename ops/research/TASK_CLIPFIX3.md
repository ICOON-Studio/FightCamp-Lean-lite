# TASK CLIPFIX3 - QWEN (qwen3-coder) - the punch ruler made honest, then the three hanging jabs retimed

Status: OPEN (S438, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: CLIPFIX2 (PR 222, your own run, NOT merged) delivered the ruler and a useful table, with four faults Claude
found at review. This round fixes them and makes the first real clip fix. Read ops/research/TASK_CLIPFIX2.md (the
brief and the eye's table) and docs/CLIPFIX2_RESULT.md on your old branch first.
START: `git checkout origin/qwen/clipfix2 -- tools/punch_form.gd tests/punch_form_test.gd assets/data/punch_form.json docs/CLIPFIX2_RESULT.md`
(if the ref is missing: `git fetch origin qwen/clipfix2:refs/remotes/origin/qwen/clipfix2`), then `git mv docs/CLIPFIX2_RESULT.md docs/CLIPFIX3_RESULT.md`.

## Contract
OWNS: tools/punch_form.gd, tests/punch_form_test.gd, assets/data/punch_form.json, tools/take_fix.gd, tools/jab_retime.gd, scripts/fight3d/BeatClips.gd, scripts/fight3d/FightClips.gd, tests/beat_clips_test.gd, tests/jab_retime_test.gd, assets/anim/baked/fixed/, assets/data/clip_contact.json, assets/data/clip_recovery.json, assets/data/clip_travel.json, docs/CLIPFIX3_RESULT.md
RED_TEST: tests/jab_retime_test.gd -> JAB_RETIME failures=0
REGRESSION: punch_form_test, beat_clips_test, beat_tally_test, short_punch_test, punch_form_rules_test, file_limits_test
VISUAL: no
NOT YOURS: scripts/rules/PunchForm.gd (if a measure in it is wrong, say so in the result file with a failing example;
do not edit it), scripts/fight3d/FightStage.gd, PunchReach.gd, RkClips.gd.

## Part 1 - the four faults in the ruler (fix all four)
1. HIP TURN reads 134 to 178 degrees on six clips. No boxer turns her hips 170 degrees in a cross: the yaw you feed
   PunchForm is wrong (a flipped axis, a bone's roll read as yaw, or the root's facing mixed in). Read the pelvis
   forward vector on the floor plane relative to her facing at the start of the strike window. A straight punch must
   read between 0 and 70; print the six old and new values.
2. BACK reads -1.00 (never back) on four clips, the GOOD rear uppercut among them. The guard reference is wrong:
   take guard_wrist as the punching wrist's position at the FIRST sample of the clip (she starts in guard), in her
   own frame (relative to the pelvis, so a step does not count as "not back"). A clip that truly ends away from
   guard still reads -1 and is named.
3. FITTED BARS. Two bars were placed between a GOOD control and a faulty clip one hundredth apart ("other glove far"
   0.32 passes, 0.33 fails; cross "other glove low" tightened to 0.12 to catch 0.15). That is a bar drawn round the
   answer (S416). Bars come from how a punch is thrown, with margin: other glove no lower than 0.15 m under the chin
   and no further than 0.30 m from it, measured in her own frame. Where the ruler then DISAGREES with the eye's
   table, the row says "ruler disagrees" with its numbers: never move a bar to agree. The two bars you raised
   because a GOOD control failed (hang 0.15, pre-drop held 0.18) may stay, each with its measured reason.
4. A REACH measure is missing: the eye read cross A and cross B as "short". Add `reach_frac`: peak wrist-to-shoulder
   distance divided by the arm's length (upper arm + forearm, from the same samples). A straight punch that lands at
   full reach reads 0.95 or more; print it for all fifteen and bar straights at >= 0.92.
tests/punch_form_test.gd: one row per clip and measure against the bars; the two GOOD controls pass every bar; a
faulty clip must FAIL at least one bar or be listed as "ruler disagrees". The test fails if a control fails, if a
measure is outside its sane range (hip turn over 90, reach_frac over 1.05 or under 0.3), or if punch_form.json is
older than the clips. It does NOT assert a typed verdict table.

## Part 2 - the three hanging jabs retimed (the first real fix)
Measured: pro_left_jab hangs 0.28 s, _b 0.21 s, _c 0.23 s at full reach; the GOOD jab A 0.14 s.
`tools/jab_retime.gd` (headless) writes assets/anim/baked/fixed/<same file name>.res for the three: the frames
where the wrist is within 0.05 m of peak reach are time-compressed to 0.14 s (keys kept, their times scaled inside
that span, everything after shifted earlier; no key deleted outside the span, the clip's length shortens by the same
amount). FightClips loads a take from `fixed/` when one exists there (the one-line lookup; say the line in the
result file). Re-run tools/clip_contact.gd, clip_recovery.gd and clip_travel.gd on the three and commit their rows.
tests/jab_retime_test.gd, red on main: for each of the three, loaded the way the fight loads it, hang_s <= 0.15;
contact_s and peak reach within 5 % of the original take; the pose at the first and the last frame equals the
original's (largest joint difference under 1 cm); no joint moves more than 0.6 m between two 60 Hz samples.
No cut from the pool in this task, no other clip changed.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first. Headless only, never a windowed Godot.
- Do not overwrite a file in assets/anim/baked/.
- The result file says plainly what was NOT done.

## Prior research
ops/research/TASK_CLIPFIX2.md, docs/CLIPFIX2_RESULT.md, ops/research/topics/striking.md.

## What would a human do?
An animator who finds a jab hanging trims the held frames and checks nothing else moved. A ruler that reads a
170 degree hip turn is fixed before anyone trusts its other columns.

## Prefab check
tools/take_fix.gd (S334) edits baked takes; the three clip_*.gd tools re-measure them.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless
--audio-driver Dummy --path . --script res://tests/jab_retime_test.gd` (the plain win64 exe, never the console one).
Parse first: `--check-only` on each touched file. Under 500 lines a script.
RESULT lines for the PR body: `RESULT: tests/jab_retime_test.gd -> JAB_RETIME failures=0` and
`RESULT: tests/punch_form_test.gd -> PUNCH_FORM failures=0`.
