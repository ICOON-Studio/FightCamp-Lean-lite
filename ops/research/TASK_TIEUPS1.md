# TASK_TIEUPS1 - the Tie-ups tab in the ground-move browser (Cursor)
Status: DONE (S338 Tie-ups tab)

Model: Cursor (composer default). Discipline: MMA / wrestling PROTOTYPE outside the boxing demo, operator-approved order
(Q-S294-62 "Yes, in that order": standing chains -> plan board -> wrestler numbers). Repo: **E:\FightCamp\Lean** (worktree
E:\FightCamp\wt\LEAN_TIEUPS1, branch `cursor/tieups1`). Lean rules: its CLAUDE.md, no script over 500 lines, Godot headless
only, nothing opens on the screen.

## Why
`scripts/rules/WrestleChains.gd` (merged S337) holds standing chain wrestling as data: 6 tie-ups, 30 answers (the opponent's
reaction -> our technique -> the finish, points, a link to the next tie-up), and `clip_for(row, transitions)` finds the
GrappleMap moves that show an answer. Nothing on screen uses it yet. The plan (research/WRESTLE_S336.md step 1): a tab
in the ground-move browser (`FightCamp.exe -- jump=grapple`) where a player picks a tie-up, reads its reactions ->
techniques -> finishes, and plays any of them on our two women.

## Spec
1. NEW `scripts/grapple/TieUpPanel.gd` (keep GrappleBrowser.gd under 500 lines; it is 333 now): builds the tab's content as
   static functions taking the browser, so the browser only adds a button and two calls.
2. `scripts/grapple/GrappleBrowser.gd` `_top_bar()`: one more tab button "Tie-ups" AFTER the family tabs (the existing
   "Standing" family tab stays - it lists GrappleMap's standing positions, a different thing).
3. Tie-ups tab, left list (`_list`, where POSITIONS are): the 6 tie-ups from `WrestleChains.TIES`, each a `UI.button2` with
   its name and "<n> answers". The list header reads "TIE-UPS" instead of "POSITIONS" while this tab is open.
4. Picking a tie-up fills the side panel (`_side`): caps "TIE-UP", its name big (same style as a position's title), then
   one `UI.button2` per answer: big line "<technique>", small line "if she <reaction> -> <finish>" plus " (+2)" when
   points > 0. Pressing it plays the FIRST clip `WrestleChains.clip_for(row, graph.transitions)` returns:
   `go_position(int(t["from"]))` then `play_out({"t": t, "reverse": false})` - when t["from"] is null, play its frames from
   their own start (`player.play(db[int(t["id"])], player.men, player.scale, Transform3D.IDENTITY)` as `go_position` does).
   An answer with NO clip is a greyed button whose reason (`why`, the GREYWHY1 argument of UI.button / button2) is
   "No clip of this yet". An answer with a `link` shows a second small button "-> <linked tie-up name>" that opens that
   tie-up (chains: collar tie -> front headlock -> ...).
5. While a clip plays the existing NOW PLAYING block shows (no change); when it lands, the side panel returns to the
   tie-up that was open, not to the GrappleMap position (remember the open tie-up id; `_refresh` checks it).
6. `-- jump=grapple tie=collar_tie` (new optional arg) opens the browser on that tie-up - the still tool uses it.

## Contract
OWNS: Lean/scripts/grapple/TieUpPanel.gd, Lean/scripts/grapple/GrappleBrowser.gd, Lean/tests/tieup_panel_test.gd,
Lean/tools/run_tests.sh (add `tieup_panel_test` to TESTS before golden_path_test)
RED_TEST: tests/tieup_panel_test.gd -> PASS tieup_panel_test
REGRESSION: wrestle_chains_test, grapple_graph_test, grey_reason_test, golden_path_test
VISUAL: yes (Claude renders the tab on the hidden desktop and checks it)

## The test (write it FIRST; red on main)
`tests/tieup_panel_test.gd` (extends SceneTree): instance the browser scene/script the way `jump=grapple` does (read how
Main / the jump handler builds it; headless, no picture needed - 3D nodes may exist), then: a "Tie-ups" button exists in the
top bar; pressing it lists exactly 6 tie-up buttons; picking "collar_tie" shows 5 answer buttons (WrestleChains.answers
count) and the "Snapdown" one has a link button naming "Front headlock"; every answer whose clip_for is empty is disabled
and its tooltip is "No clip of this yet"; every other answer is enabled; pressing an enabled one sets `moving` non-empty.
Ends `PASS tieup_panel_test` / `FAIL <n>`, quit(0/1); a SCRIPT ERROR line is a failure even with exit 0.
Command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/tieup_panel_test.gd`
then the four REGRESSION tests the same way. The plain exe only; stop any Godot run you started that hangs, by its PID.

## Final answer
`RESULT: tests/tieup_panel_test.gd -> PASS tieup_panel_test`, how many of the 30 answers have a clip, the last lines of each
run, the files touched, line counts of GrappleBrowser.gd and TieUpPanel.gd.

## Prior research
searched: wrestling tie-up chain standing -> WRESTLE_S336.md (the plan, 223wrestling.com flowchart structure),
topics/clinch.md, topics/takedowns_throws.md, G82_GRAPPLING_POSITION_TAXONOMY.md. Data already settled in WrestleChains.gd.

## What would a human do?
A wrestling coach teaches chain wrestling from a tie-up: "if she does this, you do that" - one tie-up on the whiteboard, its
reactions down the side, each answer drilled on a partner. The tab is that whiteboard, with the drill played on our women.

## Prefab check
None for Godot; the GrappleMap data (CC0-style public data already in assets/grapplemap) and our own browser are the base.
Nothing new is downloaded.

## The trap
The browser already has a "Standing" FAMILY tab (GrappleMap standing positions) - do not rename or replace it; "Tie-ups" is
a new, separate tab. Never recompute chains on the page: WrestleChains is the one source.
