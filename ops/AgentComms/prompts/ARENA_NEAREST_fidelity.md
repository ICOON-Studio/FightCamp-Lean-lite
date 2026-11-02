Task NEAREST (find the cause of a red test; keep it honest). Repository: Godot 4.7.2 GDScript game, project folder `Godot/`.

WORKFLOW: create your own branch `arena/<this-chat-id>-FightCamp` from master, commit there, push, open a pull request into master. Never push to master, never merge the PR yourself. Do not delete or weaken any existing test.

SETUP: `bash Tools/cloud_setup.sh` (Godot 4.7.2 to /opt/godot, sets GODOT_EXE). If the download is blocked, build Godot 4.7.2-stable from source (a previous Arena chat did this), then `$GODOT_EXE --headless --path Godot --import` once. The boxing clips and fighter bodies this test loads are plain git files (not LFS), so it runs in your sandbox.

PROBLEM: `Godot/tests/fight_stage_technique_fidelity_test.gd` (603 lines) is red every night with exactly one failure, line 457: `FAIL  the NEAREST branch is reached by the fixture (got 0)`. Read the file header (R103) - it asserts BY OCCURRENCE that each presenter branch is actually taken on its fixture. The NEAREST branch = a technique we own no clip for plays the clip `FightStagePlayer.NEAREST_CLIP` names for it (`Godot/scripts/FightStagePlayer.gd` line 2498, 5668 lines - read windows only). Likely cause (VERIFY, do not assume): since that floor was written, the boxing palette gained its own clips - e.g. `boxing_rear_uppercut`, `boxing_lead_uppercut`, `boxing_catch_counter` are certified moves now (`Godot/assets/data/certified_moves.json`, bindings in `Godot/scripts/FightClipBinding.gd`) - so the fixture fight never throws a technique that still lacks a clip, and NEAREST_CLIP may hold stale entries for moves that now have their own clip. Also check the synthetic block at lines ~530-545, which uses `boxing_rear_uppercut` as its "no clip" example.

TASK:
1. Prove the cause: print, for the fixture, which techniques were thrown and which of them had no own clip; list which NEAREST_CLIP keys now have their own bound clip.
2. Fix it honestly: (a) remove NEAREST_CLIP entries for techniques that now have their own certified clip (a technique with its own clip must play its own clip - the test's other checks assert that); (b) make the fixture REACH the NEAREST branch again with a technique that truly has no own clip (pick one from the remaining NEAREST_CLIP keys; if the natural fixture fight never throws one, add a synthetic beat the way the S99/Q200 "synthetic clipless beat" does in this same file), and point the lines ~530-545 example at such a technique. Keep the floor `nearest > 0` exactly as it is.
3. Nothing else changes.

ACCEPTANCE (paste outputs in the PR):
- `$GODOT_EXE --headless --path Godot --script tests/fight_stage_technique_fidelity_test.gd` reports no FAIL lines; paste the before (master) and after summary including the "NEAREST branch" line.
- `python3 Godot/tools/check_scripts.py scripts/FightStagePlayer.gd tests/fight_stage_technique_fidelity_test.gd` passes.
- `python3 Godot/tools/run_tests.py --only fight_stage,fight_world_live,clip_binding --jobs 2` reports fails=0 except tests already red on master (run on master first, paste both).
CI must be green; never fix CI by editing a test's assertions or thresholds.
