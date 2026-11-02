# TASK C242 - the boxing guard idle grafts 2.4 s from a 2.2 s source (regression, 10-02 nightly)
Model: gpt-6-luna, medium. Owner: Codex (next free seat). Worktree `E:/FightCamp/wt/C242`, branch `codex/c242-idle-graft-length` (from master).

## The defect
`tests/boxing_idle_binding_test.gd` passed in the 2026-10-01 nightly (HEAD 49f6b3ed) and fails since the 2026-10-02 nightly
(HEAD 86c8150f) and on master today (S144):
`ERROR: actual graft is the whole boxing idle (graft 2.4000 s, source 2.2000 s)` - on both rigs (f01_m_box_welter, f10_m_bare_heavy).
The boxing guard idle is the loop the player sees most of every bout; a 0.2 s mismatch means the graft is not the source take
(padding, a wrong trim, or another take joined in) and can show as a hitch at the loop seam. `fight_strike_whole_test` passes (3678/0).

## Do
1. Bisect 49f6b3ed..master on this ONE test (the only commits touching the graft path in that range: 08b4444f C240 clinch,
   5b49ee5b C231 Cascadeur strike graft, ffc10c4c, 252ff66b, 068b7f00 - check them first, `git bisect run` is fine).
2. Name the commit and the line that changes the idle's length. Fix the cause (the graft must be the whole source take, 2.2 s),
   never the assertion. If the 2.4 s is a deliberate seam/blend from that commit, make the seam live INSIDE the 2.2 s loop.
3. Control arm: the same test at 49f6b3ed must pass in your worktree (proves the instrument reads the old tree right).

## Owned files
`Godot/scripts/FightStagePlayer.gd` (5,671 lines - never read whole: grep `_graft_retargeted` ~2000-2120, `matched_idle_phase`,
`_guard_join_weight`), `Godot/scripts/FightClipBinding.gd` (RULESET_IDLE_BINDINGS ~line 28), `Godot/scripts/FightClipRetarget.gd`
(`_load_fbx` ~988, `is_cascadeur_clip` 120). Test (read only): `Godot/tests/boxing_idle_binding_test.gd`.

## Gates
Parse: `python Godot/tools/check_scripts.py <touched .gd>`. The one test:
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/boxing_idle_binding_test.gd` (exe in
`%LOCALAPPDATA%\Programs\Godot\`) - exit code alone is not a pass; no `ERROR:` line from check(). Then
`python Godot/tools/run_tests.py --only boxing_idle,fight_strike_whole,clip_binding --jobs 2`.
Watchdog before every Godot run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` (RED = 84 C
sustained 10 s; AMBER passes). ONE Godot at a time. If RED, wait and poll every 2 min - do not end the run because it is hot.

## Prior research
C223_DIGEST.md (idle = Mixamo Bouncing_Boxing_Idle via mixamo_pipeline_a, certified palette depends on the guard joins);
J19_THE_JOINS.md (joins into/out of the guard).

## What would a human do?
Bisect, read the one diff that moved the number, fix that.

## Prefab check
n/a (regression in our own code).

## The one trap
The test file and its message are not the bug - do not change the assertion or the tolerance. Never open a viewer or window.
Never edit HANDOFF.md. git add by explicit path, commit, `git push -u origin codex/c242-idle-graft-length`.
