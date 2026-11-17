# TASK SPLIT500B - QWEN (qwen3-coder) - bring the three grapple files and MatTreeInfo under the 500-line limit

Status: OPEN (S510, Claude main). Discipline: BJJ (the test club's BJJ fighter, in scope since S428). Model: qwen3-coder.
Source: CLAUDE.md rule 5, no script over 500 lines. `tests/file_limits_test.gd` lists these four as KNOWN_EXCEPTIONS
"split by another task", but no task ever split them: scripts/grapple/GrapplePlayer.gd 651, GrappleBrowser.gd 602,
GrappleFinish.gd 574, scripts/ui/MatTreeInfo.gd 502 lines. A pure refactor: no behaviour changes.

## Contract
OWNS: scripts/grapple/GrapplePlayer.gd, scripts/grapple/GrapplePlayerKit.gd, scripts/grapple/GrappleBrowser.gd, scripts/grapple/GrappleBrowserKit.gd, scripts/grapple/GrappleFinish.gd, scripts/grapple/GrappleFinishKit.gd, scripts/ui/MatTreeInfo.gd, scripts/ui/MatTreeInfoKit.gd, tests/file_limits_test.gd
RED_TEST: tests/file_limits_test.gd -> FILE_LIMITS failures=0
REGRESSION: bjj_clash_test, bjj_coach_test, bjj_finish_test, bjj_mat_test, bjj_match_test, bjj_tree_ui_test, grapple_attacker_test, grapple_contact_test, grapple_fix_test, grapple_pose_test, grapple_timing_test, theatre_test, move_tip_test, halo_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py split refactor grapple`. TASK_SPLIT500.md (S405) is the same job on Main.gd and
LiveRound.gd: same method. Read ops/research/GDSCRIPT_TRAPS.md before writing GDScript (autoload order, reused names,
Variant `:=`).

## What would a human do?
Lift one coherent block out of each file into a new `<Name>Kit.gd` next to it, change no behaviour, and prove it with the
tests that already play the BJJ mat.

## Prefab check
None needed (a refactor of our own code).

## The job
1. Each of the four files ends at 470 lines or fewer (room for the next change). Move one coherent group of functions
   (for example: in GrapplePlayer the pose/blend helpers, in GrappleBrowser the list building, in GrappleFinish the
   finish table reads, in MatTreeInfo the text builders) to the new Kit file as static functions taking the owner node
   (`player: Node`, etc.) or plain values. Keep every public name that other scripts or tests call on the original
   file, as a one-line forward.
2. In tests/file_limits_test.gd: remove these four from KNOWN_EXCEPTIONS and add them to TIGHT at 470. Leave the other
   exceptions (fight3d files, Sim.gd) as they are: another owner works on fight3d now.
3. Change no number, no text, no signal, no node path, and the ORDER of every rng call.

## Do
1. Change tests/file_limits_test.gd FIRST and run it on main: it must fail on the four files.
2. Make it pass inside OWNS.
3. Run every REGRESSION test. Do not change any number or threshold in an existing test. If one goes red, stop and put
   what you measured in the PR body.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`, `--fixed-fps 60`. Parse check before any test. No
screens opened. Nothing outside OWNS; never touch scripts/fight3d/ (the animation session owns it). PR body:
`RESULT: tests/file_limits_test.gd -> FILE_LIMITS failures=0`, plus one RESULT line per REGRESSION test.

## The one trap
A moved function that read member variables (`self.x`) must get them through the owner argument, and a Dictionary or
Array the original changes in place must be passed, never copied. A `preload` of the new Kit file in a script that is
itself preloaded by the Kit makes a cyclic load: the Kit takes the owner as `Node`, never preloads the owner's script.
