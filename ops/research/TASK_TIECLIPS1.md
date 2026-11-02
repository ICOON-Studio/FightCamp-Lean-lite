# TASK_TIECLIPS1 - the last 3 tie-up answers get their GrappleMap clip (Qwen)

Model: Qwen (qwen3-coder). Discipline: MMA / wrestling PROTOTYPE (operator Q-S294-64 "Yes, boxing and wrestling now").
Repo: **E:\FightCamp\Lean** (worktree E:\FightCamp\wt\LEAN_TIECLIPS1, branch `qwen/tieclips1`). Lean rules: its CLAUDE.md,
no script over 500 lines, Godot headless only, nothing opens on the screen. Operator S338: agents work on animation.

## Why
`scripts/rules/WrestleChains.gd` (92 lines) `ANSWERS` has 3 rows with `"clip": []`, so the Tie-ups tab says "No clip of
this yet": wrist_control "posts a hand on the mat" -> Go-behind; front_headlock "stays flat on the mat" -> Go-behind;
front_headlock "digs for a leg" -> Shuck. GrappleMap (public domain, `assets/grapplemap/graph.json`, 1485 transitions)
already HAS fitting transitions - found by Claude:
- id 946 "to back": standing arm drag on front leg side -> standing behind w/ body lock (wrist control go-behind)
- id 1385 "cartwheel to back": sprawl w/ head&arm vs turtle -> mounted turtle w/ seatbelt (front headlock, she stays flat)
- id 1353 "sprawl and circle to back": coming up on distant single -> ... (she digs for a leg: sprawl, shuck, circle behind)
The keyword match (`clip_for`, title substring or tag) cannot pick 946: "to back" is a substring of many titles.

## Spec
1. `clip_for(row, transitions)`: a keyword that starts with `#` matches the transition whose `id` equals the rest
   (`"#946"` -> id "946") exactly, and nothing else. Every other keyword works as today. Order of the result: as today.
2. The 3 rows: wrist_control Go-behind `"clip": ["#946"]`; front_headlock Go-behind `"clip": ["#1385"]`; Shuck
   `"clip": ["#1353"]`. No other row changes.
3. Check each pick against the graph before you commit: print each transition's from/to position titles (positions[]
   `id`/`title`) and confirm 946 starts standing, 1385 starts from the sprawl/head&arm position, 1353 from the leg attack.
   If one of them is wrong, choose the nearest fitting transition by the same test and say which and why in the answer.

## Contract
OWNS: Lean/scripts/rules/WrestleChains.gd, Lean/tests/tie_clips_test.gd, Lean/tests/wrestle_chains_test.gd (only its
`clip_hits >= 18` bound may rise to the new count - never lower)
(do NOT edit tools/run_tests.sh - Claude adds the test to the list at merge)
RED_TEST: tests/tie_clips_test.gd -> PASS tie_clips_test
REGRESSION: wrestle_chains_test, tieup_panel_test, tieup_plan_test, plan_board_test
VISUAL: yes (Claude renders `-- jump=grapple tie=front_headlock` on the hidden desktop and plays the three answers)

## The test (write it FIRST; red on main)
`tests/tie_clips_test.gd` (extends SceneTree): load graph.json the way tests/wrestle_chains_test.gd does;
1. every ANSWERS row finds >= 1 clip via clip_for (main: 3 rows find none -> red);
2. `clip_for({"clip": ["#946"]}, transitions)` returns exactly one transition, id "946";
3. `clip_for({"clip": ["#99999"]}, transitions)` returns [];
4. a plain keyword still works: `clip_for({"clip": ["snapdown"]}, ...)` returns >= 1.
Ends `PASS tie_clips_test` / `FAIL <n>`, quit(0/1); a SCRIPT ERROR line is a failure even with exit 0.
Command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/tie_clips_test.gd`
then the four REGRESSION tests the same way. The plain exe only; stop any Godot run you started that hangs, by its PID.

## Final answer
`RESULT: tests/tie_clips_test.gd -> PASS tie_clips_test`, the from -> to position titles of the 3 picks, the last lines of
each run, files touched + line counts.

## Prior research
searched: grapplemap go-behind shuck -> BJJ_SOURCES_S334.md (GrappleMap format, public domain), WRESTLE_S336.md (the
reaction picks the branch), TASK_TIEUPS1 (S338, the clip keywords).

## What would a human do?
A wrestling coach shows the go-behind from where the tie-up actually is: from the front headlock he spins behind as she
lies flat; when she shoots from under the headlock he sprawls, shucks her head by and circles to her back.

## Prefab check
GrappleMap (public domain) already holds these motions; nothing new is authored or downloaded.

## The trap
Never add a plain keyword "to back" or "behind": it matches dozens of unrelated transitions and the first one plays.
