# S411 digest (2026-11-09)

Q-S294-135 answered: "Yes, but with fewer words and bigger pictures, like Fighters." Nothing built on the four pages yet: they are briefed and queued.
tools/page_ink.gd turns that sentence into numbers for a seat that cannot see: visible words, share of the screen under people and move pictures, tallest person. Measured on main: Versus 93 / 49% / 830 px; Fighters with eight 164 / 27% / 322; Home 127 / 0 / 0; Fighter Week 326 / 1% / 0; Playbook 270 / 0 / 0. MENU_BUILD_RULES items 19-22 and a bar per page in TASK_MENUHOME2, MENUWEEK2, MENUPLAYBOOK2B, MENUFIGHT1B. Bases rebuilt on current main (claude/menuhome1-main, menuweek1-main, menuplaybook1-main; they were 55 commits behind). Home keeps the S408 gym whole, with notes and next fight pinned round it on one screen: Claude's call, because the concept predates the gym. He has not seen it drawn.
Main's CI is GREEN for the first time in days, 11 min (run 42598106431, 510ae8f3). no_gi_test read a table row S410 replaced. boxer_footwork: switching each modifier off in turn named FighterLife (9.8 without it, 3-4 deg more with it), a rest pose that leans on purpose, so the test turns it off as it does GuardWeave. The bar is unchanged; S408's blame on the re-baked idle was wrong. So in the game a stepping boxer leans 11-15 deg, against the rig's 10.
tools/run_tests.sh prints each test's time as it ends; CI limit 24 min (main had reached 16.6 of 18).
HITREACT3 (PR 118): only two of six stages were measured, the conclusion outruns its table (RETARGET 0.191 m v the finished clip 0.109 m, controls drop as much). Not collected; HITREACT4 (Qwen, running, base qwen/hitreact3) finishes the stages.
FIGHTERMODEL4E (PR 119): plan_bots green, form spread 5 for watched bouts, 16.5 min. NOT mergeable: the first run that finished shows 10 red tests the cancelled runs hid, plus matchmaking_bots. FIGHTERMODEL4F queued (no test numbers changed), then 4B on top (scouting); they merge together. PRs 85, 106, 113, 117, 119 stay open until then.

Evidence: no_gi, boxer_footwork run here; main CI success above; page_ink on six pages, stills opened by Claude (E:/FightCamp/tmp/s411_ink).

HANDOFF
Working commit: on main, pushed (the wrap-up commit follows 510ae8f3). Build exported to Builds/: game unchanged since S410.
Remaining: collect HITREACT4 and MENUHOME2, then the queue; his play of the S410 build; the first real 05:00 full test run (11-10).
Exact next action: roadmap now.next_action; details in NEXT_SESSION_PROMPT.md, S411 block.
