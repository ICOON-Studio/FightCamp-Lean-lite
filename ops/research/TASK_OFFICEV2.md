# TASK OFFICEV2 - build the office Goals panel and the Fighters/Staff sheets with right-click actions (S538)

Status: DONE (collected df2f87d94; marked S540)

Model: claude-fable-5-2 (headless on the API credit, ops/Tools/sdk_run.py). Discipline: boxing (demo).

## Owner
Q-S294-302 "the office needs a something like a goals tab to see what is pending what each fighter wants , probably fit it in
the dashboard"; "also maybe the fighters and coaches screens inside the desktop , could they be like excel sheets and when
plqayer right clicks on a name can do various actions"; Q-S294-304 on the mockups: "Yes, build them"; review comments C473/C474
"fine", C475 "fine. tooltip on goals give some tips".
The approved pictures ARE the spec: ops/previews/s538_look/office_goals.png, office_sheets.png, office_sheets_menu.png (html
beside them; NOTES.md gives every number's source file:function). Match them.

## Do
1. GOALS panel in the dashboard (scripts/ui/OfficeDesk.gd data + scripts/ui/areas/Office.gd layout) as drawn: left = the club's
   pending items with days left; right = one row per fighter: want, how far (bar + status chip), by when, if it is missed.
   The fighter cards shrink to the chips row as drawn. C475: each goal row's tooltip gives a TIP - what to do this week to
   move it (e.g. "book a bout before Thu 26 Feb: the Fights page"), read from the real state, not generic text.
   The two items the notes mark "would need building" (the reasons behind a mood; a by-date for the belt): leave them out,
   show only what the game tracks.
2. SHEETS: the Fighters and Staff icons open sortable sheets INSIDE the desktop (click a heading to sort, a Columns chooser,
   the test club populates them). Right-click a name opens the context menu of actions that ALREADY exist, each calling the
   same act the game uses today (scripts/ui/RosterActs.gd, the Staff screen's acts); greyed with the reason when not possible
   now. "Release from the club" and the club coach's "Let go" are marked NEEDS BUILDING in the mockup: leave them out of
   this build and list them in the result page as the next ask.
3. Small files: new files for the panel and the sheet (e.g. scripts/ui/OfficeGoals.gd, scripts/ui/OfficeSheet.gd,
   scripts/ui/OfficeMenu.gd); no script over 500 lines; house theme.
4. Tests: tests/office_goals_test.gd and tests/office_sheet_test.gd (red first: sort, columns, right-click lists only real
   acts and each one opens its screen, goal tips non-empty and not the label); office_desk_test, office_screen_test,
   gym_hub_test, golden_path_test stay green. Stills from the real game (tools/layout_snapshot.gd office shots, hidden desktop,
   tools/clean_view.gd save_if_clean; ui=1 for the menu still). Open each and compare with the mockups.
5. docs/OFFICEV2_RESULT.md + `python ops/Tools/review_add.py --stage S538 --rating "built, Claude" --title "Office goals + sheets
   in the game" <stills>`.

## Prior research
ops/previews/s538_look/NOTES.md, ops/research/TASK_OFFICE1.md, memory feedback_tooltips_explain_s532.

## What would a human do?
Build the approved pictures; right-click does only what the game can really do.

## Prefab check
None.

## Contract
OWNS: scripts/ui/OfficeDesk.gd, scripts/ui/areas/Office.gd, scenes/areas/Office.tscn, scripts/ui/OfficeGoals.gd (new),
scripts/ui/OfficeSheet.gd (new), scripts/ui/OfficeMenu.gd (new), tests/office_goals_test.gd (new), tests/office_sheet_test.gd
(new), docs/OFFICEV2_RESULT.md
RED_TEST: tests/office_goals_test.gd, tests/office_sheet_test.gd red on main
REGRESSION: tests/office_desk_test.gd, tests/office_screen_test.gd, tests/gym_hub_test.gd, tests/golden_path_test.gd
VISUAL: office stills from the real game

## Rules
Work in main. Godot ONLY through `python ops/Tools/godot_slot.py run --who officev2 -- ...` (windowed only via
tools/hidden_desktop.py). Read ops/research/GDSCRIPT_TRAPS.md. Commit only your paths (`git add -- <new>` then
`git commit -m ... -- <paths>`), end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two lines, stop.
