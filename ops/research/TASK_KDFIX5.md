# TASK KDFIX5 - QWEN (qwen3-coder) - a downed boxer's upper body sways, round 5: Cursor's "all green" was false

Status: OPEN (S426, Claude main). Discipline: boxing. Model: qwen3-coder. Animation item (operator S401).
Source: the operator after watching fights, 2026-11-10: "the upeer boddy moves left and right when the fighter is knockdedown".
Start your branch FROM cursor/kdfix4 (PR 169).

## What Claude read at the start of S426
- KDFIX4 (Cursor) said every test was green. Claude's rerun: tests/knockdown_still_test.gd red 3 runs of 3, chest side travel
  2.30 cm against the 0.5 cm bar (KDFIX3 had it at 0.76), and tests/block_meet_test.gd red. So KDFIX4 made the sway WORSE.
- Do not trust the PR text of KDFIX3 or KDFIX4. Trust only a run you did, with its pass/fail line in your own output.

## Contract
OWNS: scripts/fight3d/FighterLife.gd, scripts/fight3d/GuardWeave.gd, scripts/fight3d/TiredSag.gd, scripts/fight3d/KnockdownLayers.gd, scripts/fight3d/BoxerBuild.gd, tests/knockdown_still_test.gd, tools/knockdown_probe.gd, docs/KDFIX1_RESULT.md
RED_TEST: tests/knockdown_still_test.gd -> KNOCKDOWN_STILL failures=0
REGRESSION: block_meet_test, knockdowns_test, knockdown_ring_test, bout_stoppage_test, fight_flow_test, head_aim_test, guard_weave_test, fighter_pose_test
BASE: cursor/kdfix4
VISUAL: Claude films a knockdown and a knockout after the merge. Do not render.

## The job
1. Run tests/knockdown_still_test.gd on qwen/kdfix3 (3f227d73) and on cursor/kdfix4, three runs each; put the sway numbers
   (0-0.5 s and 0.5-5 s chest side travel) of each in docs/KDFIX1_RESULT.md "Round 5". Name the KDFIX4 change that moved
   it from 0.76 to 2.30 (git diff qwen/kdfix3..cursor/kdfix4 on the owned files; read it, do not guess).
2. If that change has no reason of its own, revert it. Then, whichever layer still writes AFTER 0.5 s on a downed boxer:
   print its weight each frame while down (tools/knockdown_probe.gd) and stop it. The bar stays: travel after 0.5 s within
   0.5 cm of the fall clip alone; the 0-0.5 s settle at most 3x the floor's settle. Do not loosen a bar to pass.
3. block_meet_test red on cursor/kdfix4 and green on main (a5d7f66b): find the commit and the check line (TOUCH_FAIL / GY_FAIL)
   that turned it red and fix it without touching block_meet_test.gd. A boxer who is NOT down must move exactly as on main.
4. Run each RESULT test three times; a flaky test is a finding, not a pass.

## Prior research
docs/KDFIX1_RESULT.md rounds 1-4; scripts/fight3d/KnockdownLayers.gd; tests/block_meet_test.gd (`_attach` ~line 276);
ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Watch a boxer land on the canvas: a body settles once as it lands; after that it lies still. Measure the two apart.

## Prefab check
None: our own layers.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`.
No file over 500 lines. Never "he" or "she" in text. A RESULT line reports the real pass line; never call a red test
pre-existing without the main run that shows it red.

## Result lines (PR body)
RESULT: tests/knockdown_still_test.gd -> KNOCKDOWN_STILL failures=0
RESULT: tests/block_meet_test.gd -> BLOCK_MEET failures=0
RESULT: tests/fighter_pose_test.gd -> the test's own pass line
