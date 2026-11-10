# TASK KDFIX4 - CURSOR (Grok 4.7 High) - a downed boxer's upper body sways, round 4: settle or sway, and block_meet

Status: OPEN (S424, Claude main). Discipline: boxing. Model: grok-4.7-high (moved from Qwen to run beside LEGTREMBLE4). Animation item (operator S401).
Source: the operator after watching fights, 2026-11-10: "the upeer boddy moves left and right when the fighter is knockdedown".
Start your branch FROM qwen/kdfix3 (3f227d73).

## What Claude read in KDFIX3 (S424)
- Real progress: chest side travel on a knockdown 1.91 cm (KDFIX2) -> 0.76 cm. The fall clip alone (all layers off) 0.18 cm.
- tests/knockdown_still_test.gd failed 3 (bar: within 0.5 cm of the floor). The PR text said the 0.58 cm left "comes from the
  fall clip's own settling, not from the layers" - that is not what the numbers say: with every layer off it reads 0.18, so
  the 0.58 is a layer. Do not write that again without a run that shows it.
- KDFIX3 skipped the brief's step 3: travel in the FIRST 0.5 s vs AFTER it. That split is the question: a one-time unwinding
  while the layers ease out (EASE_OFF_S 0.4 s) is a settle the eye reads as the fall; travel after 0.5 s is the sway he saw.
- block_meet_test failed 2 on the branch and was called "pre-existing". It is not: last night's full run on main (a5d7f66b)
  passed all 239 tests, block_meet_test among them. GuardWeave's new "ease pos toward zero" may move the guard of a boxer
  who is NOT down. Find it.

## Contract
OWNS: scripts/fight3d/FighterLife.gd, scripts/fight3d/GuardWeave.gd, scripts/fight3d/TiredSag.gd, scripts/fight3d/KnockdownLayers.gd, scripts/fight3d/BoxerBuild.gd, tests/knockdown_still_test.gd, tools/knockdown_probe.gd, docs/KDFIX1_RESULT.md
RED_TEST: tests/knockdown_still_test.gd -> KNOCKDOWN_STILL failures=0
REGRESSION: block_meet_test, knockdowns_test, knockdown_ring_test, bout_stoppage_test, fight_flow_test, golden_path_test, head_aim_test, guard_weave_test, fighter_pose_test
BASE: qwen/kdfix3
VISUAL: Claude films a knockdown and a knockout after the merge. Do not render.

## The job
1. In tools/knockdown_probe.gd print, for the knockdown and the knockout, with all layers on and with each layer off in turn
   (FighterLife, GuardWeave, TiredSag): chest side travel in 0-0.5 s and in 0.5-5 s. One table.
2. Whichever layer still writes AFTER 0.5 s on a downed boxer: find why (print its weight each frame while down) and stop it.
3. The test's bar measures the window the player sees as a sway: travel AFTER 0.5 s within 0.5 cm of the floor's travel in
   the same window (the fall clip alone). Print the 0-0.5 s settle too, and keep a bar on it: the settle with all layers on
   is at most 3x the floor's settle (say in the PR body what it reads). The control stays: all-on vs all-off must differ by
   3x on the KDFIX2 tree (run it there once and say so).
4. block_meet_test: run it on qwen/kdfix2, on qwen/kdfix3 and on yours. Name the commit that turned it red and the check
   (TOUCH_FAIL / GY_FAIL line). Fix it so it is green again without touching block_meet_test.gd.
5. docs/KDFIX1_RESULT.md: a "Round 4" section with the table and five sentences.

## Prior research
Branch qwen/kdfix3 commit message and docs/KDFIX1_RESULT.md Round 3; scripts/fight3d/KnockdownLayers.gd; tests/block_meet_test.gd
(`_attach` ~line 276); ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Watch a boxer land on the canvas: a body settles once as it lands; after that it lies still. Measure the two apart.

## Prefab check
None: our own layers.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`.
No file over 500 lines. Never "he" or "she" in text. A RESULT line reports the real pass line; never call a red test
pre-existing without the main run that shows it red.

## Result lines (PR body)
RESULT: tests/knockdown_still_test.gd -> KNOCKDOWN_STILL failures=0
RESULT: tests/block_meet_test.gd -> BLOCK_MEET failures=0
RESULT: tests/fighter_pose_test.gd -> the test's own pass line
