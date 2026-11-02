# TASK NIGHTLY2 - the fight tests that HANG since the 10-10 nightly: find the one cause, fix it (S197)
Model: Codex gpt-6.1-sol, MEDIUM. Worktree E:/FightCamp/wt/NIGHTLY2, branch codex/nightly2 (from master).
Why now: operator S197 wants the game playable tomorrow; the fight is the game. Nightly 2026-10-10 @98975f5c
(AgentComms/nightly/latest.txt): SUITE total=627 fails=13, up from 599/7 on 10-09 @f219ad5f. NEW and clustered:
HANG (timeout): fight_body_layers_live_test, fight_identity_test, fight_locomotion_test, fight_pair_live_test (parked on purpose,
ignore), fight_realtime_test, fight_room_ring_bounds_test, fight_room_positions_test, fight_room_walkout_test.
Also: causation_real_path_test rc=1, fight_stage_realism_test rc=1 (old, known), fight_world_live_test engine-error
("Can't use get_node() with absolute paths from outside the active scene tree"), fighter_reachability_contract_test (old, KM3),
gf1_body_fatigue_tips_test rc=1.

## What to do
1. Run fight_realtime_test.gd ALONE on master (command below, timeout 300 s). If it passes alone, it is contention - then run
   2 of the hang set together with `python Godot/tools/run_tests.py --only fight_room --jobs 2` and report. If it hangs alone:
   an idle hang (~0.15 core, no I/O) is a SCRIPT ERROR that killed `_run` (parse error or runtime error before quit) - read stderr.
2. Bisect `git log 98975f5c ^f219ad5f` (commits between the green 10-09 and the red 10-10 nightly) on ONE hanging test:
   `git bisect run` with a script that runs the test with a 240 s timeout. Name the commit and the line.
3. Fix at the cause (smallest correct change; most S196 work sits behind OFF switches - check a switch default or an
   unconditional preload/await added to a shared script such as FightRealtime.gd, GameState.gd, LudoFightHud, ApronShouts,
   RefereeStyle, CardAutofire). Never weaken a test, never raise a timeout to pass.
4. Then fix causation_real_path_test, fight_world_live_test and gf1_body_fatigue_tips_test if they are new since 10-09.

## Owned files
Whatever the bisect names. FightRealtime.gd and GameState.gd (19,168 lines) are NEVER read whole: grep + `sed -n` windows <= 200 lines.

## Gates
- Parse: `python Godot/tools/check_scripts.py <touched .gd>`
- One test: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/fight_realtime_test.gd`
  (NEVER _console.exe). Pass = exit 0, no SCRIPT ERROR, no FAIL line, prints its total line.
- Related: `python Godot/tools/run_tests.py --only fight_ --jobs 2` (never --jobs >2; never the full suite): every hang above gone.
- Worktree may lack .import files: a test failing ONLY on a missing import -> say so, Claude re-runs on master.

## Prior research
memory: "An idle Godot tool is a script error", "Headless Godot: non-console exe", nightly history in roadmap.json NIGHTLY1.
## What would a human do?
Bisect between the last green and first red nightly, read the culprit diff.
## Prefab check
n/a (our own regression).
## The one trap
A hang hides its error: always capture stderr, and suspect a parse error first (a parse error hangs a headless test).
Commit on codex/nightly2 and push; never master; no windows, no audio. Final message: the culprit commit + line, the fix, test outputs.
