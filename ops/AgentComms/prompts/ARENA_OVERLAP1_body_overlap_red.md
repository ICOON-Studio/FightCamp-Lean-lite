Task OVERLAP1 (diagnose and fix a chronic test failure). Repository: Godot 4.7.2 GDScript game, project folder `Godot/`.

WORKFLOW: create your own branch `arena/<this-chat-id>-FightCamp` from master, commit there, push, open a pull request into master. Never push to master, never merge the PR yourself.

SETUP: `bash Tools/cloud_setup.sh` (Godot 4.7.2 to /opt/godot, sets GODOT_EXE), then `$GODOT_EXE --headless --path Godot --import` once (slow).

PROBLEM: `Godot/tests/fight_body_overlap_test.gd` (161 lines) has failed every night since 2026-09-26: "FAIL no refused penetration in 900 frames (worst 0.0029 m hand>head at frame 898, allowance 0.0000 m)". It runs the live fight room (`Godot/scripts/FightWorldLiveScreen.gd`, never read whole - search it) for 900 frames and refuses any body-pair penetration whose class pair is not in the room's `OVERLAP_ALLOWANCE_M`. A glove 2.9 mm inside a head at frame 898 fails it.

TASK: run it alone (`timeout 1800 $GODOT_EXE --headless --path Godot --log-file /tmp/ov.log --script tests/fight_body_overlap_test.gd`), find WHICH frames/parts produce hand>head penetration (instrument the test's `_measure` locally or write a probe `Godot/tools/overlap1_probe.gd` printing per-frame worst pairs), and find the cause in the room's contact handling (the head-protection pass that should push a glove out of a head: search `_stop_posed_contact`, `HEAD_CLEAR_M` in `Godot/scripts/FightContactSolve.gd`, `_correct_refused_head_contact`). Fix the CAUSE in the room/contact code so no glove stays inside a head. Do NOT add an allowance for hand>head, do NOT change the test's thresholds or frame count, do NOT delete checks.

ACCEPTANCE: `fight_body_overlap_test` passes alone; `python3 Godot/tools/check_scripts.py <touched .gd>` passes; `python3 Godot/tools/run_tests.py --only fight_body_overlap,contact,glove,fight_world_live --jobs 2` reports fails=0 (any failing test that also fails on master: say so with master's output). Write `research/OVERLAP1_DIGEST.md`: the per-frame evidence, the cause, the fix, before/after numbers. Paste outputs in the PR. CI must be green; never fix CI by editing a test.
