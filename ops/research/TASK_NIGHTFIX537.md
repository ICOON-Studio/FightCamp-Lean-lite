# TASK NIGHTFIX537 - the 11-22 nightly reds (S537)

Model: claude-fable-5-2 (headless on the API credit). Discipline: boxing (demo).
ops/AgentComms/nightly/latest.txt (05:00, 2026-11-22) has these red: tips_test, words_on_screens_test ("bout says 'Scouting
report'"), rokoko_clips_test, human_feet_test, head_aim_test. Since then main merged s537/steppay3 + s535/dmgfix and switched
the v2 leg bakes OFF (scripts/fight3d/v2/CrossLegs.gd, Stance.gd, Drive.gd `off := true`).

## Do
1. Run the five on main now: `python ops/Tools/godot_slot.py run --who nightfix -- env TESTS="tips_test words_on_screens_test
   rokoko_clips_test human_feet_test head_aim_test" JOBS=2 sh tools/run_tests.sh > <file> 2>&1`; read each FAIL line.
2. For each still red: find whether the TEST or the GAME is wrong (git log -S / blame on the asserted text). Fix the game when
   it shows a word or a defect the test rightly forbids (S422 game words; S532 tooltips explain); fix the test only when the
   game changed on purpose (cite the commit). Animation tests: never add a correction layer in scripts/fight3d (S510 METHOD);
   if one fails because the leg bakes are off, make it SKIP the way tests/player2_test.gd `_layer` does, citing owner S537
   "ok switch off".
3. Rerun the five + golden_path_test green. docs/NIGHTFIX537_RESULT.md: each test, cause, fix, file:line.

## Rules
Godot only through godot_slot, one run at a time. No script over 500 lines. Never stage LineGrade.gd, LiveRound.gd,
StepWire.gd, MHRig.gd, tools/export.sh. `git add -- <new>` then `git commit -m ... -- <your paths>` with `Co-Authored-By:
Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two lines, stop.
