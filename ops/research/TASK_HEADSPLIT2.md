# TASK HEADSPLIT2 - the head-jump ruler says WHEN in the punch each jump falls

Status: OPEN (S508, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
Fight motion week, HEADJUMP1. HEADSPLIT1 (S507) splits each head jump (head travel over 12 cm in one frame) into what
moved it (root / hips / trunk / neck) and compares two films only where their bouts match. Half the jumps (50 of 91 on
s506a) are on a boxer's head while SHE is punching. The next lever (S508) caps her trunk even while her landing glove is
held, then re-lands the glove. To judge it, the ruler must say for each punch-clip jump whether it falls BEFORE her
contact, ON the contact frame, or AFTER it (and how many frames after), because the hold runs from the punch's start
through ~10 frames after contact. The csv already marks contact: column `hold` is "1" on a boxer's contact frames.

## What to build (extend the HEADSPLIT1 files; keep every existing output line and test unchanged)
1. `scripts/rules/HeadSplit.gd` (pure static, ZERO preloads): every jump dict gains `since_contact` (int): for the jumping
   boxer (`who`), the number of frames from that boxer's most recent contact start (a row whose `hold` is "1" while that
   boxer's previous row's `hold` is "0") to row b, counted only while the boxer's clip has not changed since that contact
   start; -1 when there is none in the current clip. Rows without a `hold` column count as "0".
2. A jump's `phase` (String): `pre` when kind is `punch` and since_contact == -1; `contact` when since_contact is 0;
   `post` when 1..12; `late` when > 12; `none` for kinds other than punch.
3. The summary gains `by_phase` {pre, contact, post, late, none: count} and `post_p50_frames` (median since_contact over
   `post` jumps, 0.0 when none).
4. `tools/head_split_probe.gd`: after each existing HEADSPLIT line, ONE new line with the same prefix rule (none, `A `,
   `B `, `A_ALL `, `B_ALL `) exactly
   `HEAD_SPLIT_PHASE pre=<n> contact=<n> post=<n> late=<n> none=<n> post_p50=<x.x>`.
5. `tests/head_split_test.gd`: new fixture cases (String values as the csv writes them): a punch clip with hold 0,0,1,1,0
   and jumps at each step (pre / contact / post); a jump 15 frames after contact (late); a clip change after the contact
   (since_contact resets to -1, phase pre); two boxers interleaved where only one has a contact (the other's punch jump
   stays pre); a react jump (none); no `hold` column at all (all pre/none, no error). Keep the existing cases green.

## Contract
OWNS: scripts/rules/HeadSplit.gd, tests/head_split_test.gd, tools/head_split_probe.gd
RED_TEST: tests/head_split_test.gd -> HEAD_SPLIT_TEST failures=0
REGRESSION: file_limits_test
VISUAL: no - a measuring tool; no game code changes.
NOT YOURS: every other file (the brief too). Never delete or weaken a test. Own branch, commit, push, never merge.
Each file under 500 lines (the test is at 416: put the new fixtures in compact helpers). Never `tools/run_tests.sh`. Never
run Godot windowed. Nothing may open on the owner's monitors. One test:
`godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`.
PR body: `RESULT: tests/head_split_test.gd -> HEAD_SPLIT_TEST failures=0`, `RESULT: tests/file_limits_test.gd -> ...`,
and the probe's output for `-- csv=E:/FightCamp/tmp/fightweek/s506a/shown.csv csv2=E:/FightCamp/tmp/fightweek/s507b/shown.csv`.
s507b has 132 rows with hold "1" (both boxers together).

## Prior research
`scripts/rules/HeadSplit.gd` (HEADSPLIT1, the jump and kind rules), `tools/fight_motion_rulers.py` (contacts = hold
0 -> 1), `scripts/rules/HookPast.gd` (runs per who), `ops/research/S507_DIGEST.md`, `ops/research/GDSCRIPT_TRAPS.md`.

## What would a human do?
An animator scrubbing the film would note, per pop, "on the way in / at the hit / on the way home" - this is that note,
counted.

## Prefab check
None: our own csv and ruler; nothing to download.
