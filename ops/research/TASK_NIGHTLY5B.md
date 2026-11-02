# TASK NIGHTLY5B (S215) - name the ONE switch of SWITCHALL1 that breaks switch_gate_face_drawn_foe, then fix it

Model: Qwen (qwen3-coder). Worktree E:/FightCamp/wt/NIGHTLY5B (seeded import cache). Never master.

## Setup
In the worktree: `git bisect reset`, then `git fetch origin && git checkout -B qwen/nightly5b origin/master` and `git lfs checkout`.

## Prior research
- TASK_NIGHTLY5.md (full background). S213_DIGEST.md item 6: bisect DONE - first bad commit = 174f3a23 (SWITCHALL1, GameSwitches
  registry), parent 2ea1ca92 good. hands_smooth half already fixed on master (8c333b49).
- The red: `FAIL face_drawn_foe: body-vs-drawn-aim p90 ON 41.2 < OFF 23.8` - the ON arm is now WORSE than OFF.
- Godot/scripts/GameSwitches.gd (the registry), Godot/tools/switch_gate_common.gd (harness: f01 vs f09, seed 92012, sets room
  switches explicitly), tests/switch_gate_face_drawn_foe_test.gd.

## What would a human do?
SWITCHALL1 turned many switches ON at once. Turn them back OFF one at a time (or half the set at a time - binary search) in the
test's ON arm only, re-run, and see which one brings ON p90 back below OFF. That names the culprit. Start with the engine set:
trap/defence/output, separation_strip_velocity, limb_damage, corner_wired, then stage anim layers.

## Do
1. Run the test on your branch first and record the red numbers (headless:
   `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/switch_gate_face_drawn_foe_test.gd`,
   ~3 min). Never `_console.exe`.
2. Binary-search the switches SWITCHALL1 turned ON (diff `git show 174f3a23 -- Godot/scripts/GameSwitches.gd`) - temporary edits only,
   to name the culprit switch. Log every run (switches off, ON p90, OFF p90) in the digest.
3. Fix the CAUSE in the code that switch drives (either the switch leaks into the gate's measurement when it should not, or it really
   makes the face-drawn aim worse - then fix that behaviour). Never loosen a gate threshold; never force a switch in the harness to hide it.
4. Run: the face_drawn_foe test, then `python Godot/tools/run_tests.py --jobs 1 --only switch_gate,game_switches` - nothing green goes red.
5. research/NIGHTLY5B_DIGEST.md: the culprit switch, why, the fix, before/after numbers. `git add -- <files>`; commit; push qwen/nightly5b.

## Owned files
- the file(s) the culprit switch drives (name them in the digest; not GameState.gd unless unavoidable - never read it whole, use grep + sed -n windows)
- research/NIGHTLY5B_DIGEST.md (NEW)

## Prefab check
None - our own fight code.

## Rules
Watchdog before EVERY Godot run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` (exit 1 = RED = wait 5 min, retry).
Headless only, one Godot at a time, `--jobs 1`. Never open image viewers/browsers/explorer. Never master. Parse gate before any test:
`python Godot/tools/check_scripts.py <touched .gd>` (a parse error hangs a headless test).

## The one trap
The exit code is NOT a pass - read the test's own PASS/FAIL line. rc=124 = hang (suspect a parse error).
