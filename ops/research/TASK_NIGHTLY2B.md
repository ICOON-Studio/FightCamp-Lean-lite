# TASK NIGHTLY2B - three red tests from the 2026-10-10 nightly that are NOT hangs (S197)
Model: Qwen (qwen3-coder). Worktree E:/FightCamp/wt/NIGHTLY2 (branch codex/nightly2; its .godot import cache is now built - keep it).
Nightly 2026-10-10 @98975f5c (AgentComms/nightly/latest.txt), red and not hangs:
- causation_real_path_test.gd rc=1
- fight_world_live_test.gd engine-error "Can't use get_node() with absolute paths from outside the active scene tree."
- gf1_body_fatigue_tips_test.gd rc=1
For each: run it alone, read the FAIL / SCRIPT ERROR lines, find the cause (git log -p on the files it names since 2026-10-08),
fix the smallest correct thing in the GAME code (or the test only if the test reads something that legitimately moved - say why).
Never weaken an assertion, never delete a test. The get_node error: a node calls get_node("/root/...") before it is in the tree -
use get_node_or_null after the node is inside the tree (is_inside_tree) or move the call to _ready.
Gates: `python Godot/tools/check_scripts.py <touched .gd>`; each test alone with
`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/<name>.gd` (NEVER _console.exe):
exit 0, no SCRIPT ERROR, no FAIL. One Godot process at a time. Commit on codex/nightly2 and push; never master; no windows.
Final message: per test - cause (file:line), fix, the passing output line.
