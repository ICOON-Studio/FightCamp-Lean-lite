# TASK HEADAIM2B - QWEN (qwen3-coder) - the head aim, round 2: a ruler that holds, and joins

Status: OPEN (S417, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).
Source: Claude read PR 145 (HEADAIM2). The idea is right and the game code is close. The measurement is void and one part of the code is wrong. Everything in ops/research/TASK_HEADAIM2.md still stands; this page only lists what to fix.

## Contract
BASE: qwen/headaim2
OWNS: scripts/fight3d/PunchReach.gd, scripts/fight3d/FightStage.gd, scripts/fight3d/BeatFire.gd, scripts/fight3d/MoveStudio.gd, scripts/fight3d/MovePlayer.gd, tests/head_aim_test.gd, tools/head_aim_shown_probe.gd, docs/HEADAIM2_RESULT.md
RED_TEST: tests/head_aim_test.gd -> HEAD_AIM failures=0
REGRESSION: beat_clips_test, short_punch_test, golden_path_test
VISUAL: yes

## Prior research
ops/research/TASK_HEADAIM2.md (the whole job and every bar). docs/HEADAIM2_RESULT.md on the base branch (the void table). ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Stand the two boxers at the fight's distance before EVERY punch, throw one punch, look, reset.

## Prefab check
Nothing new: fix what is there.

## Why the round-1 table is void (read docs/HEADAIM2_RESULT.md on the base and see it)
1. `flat` (glove to face, horizontal) reads 0.2 m on the first row and climbs to 2.3 m by the last row of a setup, then 2.4 to 3.6 m in the next setup. The boxers stand 0.9 m apart. Each clip moved the boxers and nothing put them back, so most rows measure a punch thrown from across the ring.
2. The level setup (same height, the EASY case) fails 21 of 36 with the aim on, up to 0.246 m, while the two hard setups pass at 0.000. A ruler that reads the easy case worse than the hard one is broken.
3. tests/head_aim_test.gd line 115: `var noaim_dy: float = min_dy  # placeholder`. The `noaim` column was never measured, so the INSTRUMENT check and the DEPTH control compare a number with itself.
4. "A punches A" ran on a stage built for A and B.

## Fix the ruler
- ONE FRESH FightStage PER SETUP, built with that setup's two models, freed after. Print both models and heights on a `PAIR` line.
- BEFORE EVERY CLIP: both boxers back to `Vector3(0, 0, -gap_m * 0.5)` and `Vector3(0, 0, gap_m * 0.5)`, facing each other, `stage.guard()` on both, wait until the guard is playing, THEN play and aim. Print the flat distance between the two Hips joints at arming on every row (`gap=`).
- A row is VALID only if `gap` is within 0.05 m of `stage.gap_m` and `flat` at contact is between 0.0 and 0.7 m. Print `VOID` rows and count them as failures. Do not drop them.
- The `noaim` numbers come from a second process (`-- noaim`) writing `user://head_aim_noaim.json`; the aim-on process reads that file and fails loudly if it is missing. The test's header says to run `-- noaim` first.
- The INSTRUMENT check as the brief wrote it: with `noaim`, the jab in "A punches B" must FAIL the height bar. Print the number.
- If, on a valid ruler, the level setup still misses with the aim on, that is a real finding: report the clip and the number. Do not tune the bar, do not add a tolerance, an ease or an offset inside the read.

## Fix the code (scripts/fight3d/PunchReach.gd)
`_height_only` and `_aim_target_y` are ONE flag and ONE height for the whole modifier, but `disarm()` puts a cut-off punch in `_fades` and keeps solving it for FADE_S. So today:
- a LANDED punch that is fading while the next punch is armed height-only is solved height-only: its glove leaves the face in one frame;
- a height-only punch that is fading while the next punch is armed by `arm()` has no valid target and returns: its hand snaps back to the raw clip;
- two height-only punches in a row: the fading one takes the new punch's height.
Each reach must carry its own mode: store `height_only` and `y` in the `_fades` entry at `disarm()` and pass them into `_reach` as arguments. No member flag is read inside `_reach`.

## Add to tests/head_aim_test.gd: the joins
On a fresh stage, same height. Four pairs, the second punch started 0.30 s after the first one's contact: landed jab then un-landed cross; un-landed jab then landed cross; un-landed jab then un-landed jab (same hand); landed jab then un-landed jab (same hand). For each: the largest one-frame move of BOTH wrists over the pair, aim on, is at most the `noaim` run's largest plus 0.03 m. Print `JOIN <pair> jump=<m> noaim_jump=<m>`.

## Rules
As TASK_HEADAIM2.md. Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script> [-- noaim]`. MovePlayer.gd must not grow. No images. No fixed he or she.

## The one trap
A boxer moved by setting `boxers[i]["pos"]` is only placed when the stage composes the scene. Read the Hips joints' WORLD positions after a frame and print the gap: believe the print, not the assignment.

## Result lines (PR body)
RESULT: tests/head_aim_test.gd -> HEAD_AIM failures=0
RESULT: tests/beat_clips_test.gd -> BEATCLIPS failures=0
RESULT: tests/short_punch_test.gd -> SHORT_PUNCH failures=0
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0
