# TASK RESULTV2 - build the result page v2 as the owner approved it (S538)

Model: claude-fable-5-2 (headless on the API credit, ops/Tools/sdk_run.py). Discipline: boxing (demo).

## Owner
Q-S294-303 "the result page needs more graphics,use tooltips/modals to shorten things"; Q-S294-304 on the mockup: "Yes, build them".
The approved picture IS the spec: ops/previews/s538_look/result_v2.png + result_v2_modal.png, html beside them, notes in
ops/previews/s538_look/NOTES.md (every number's source file:function). Match it.

## Do
1. Summary tab of the result page as drawn: portraits in both header cards; judges' cards as the coloured round grid with
   the legend; WHY IT WAS LOST = icon + one headline + dots, the measured fix with the bar pair and its tooltip; ROUND BY
   ROUND = per round the score, the judges' dots, an up/down bar per exchange, the two energy bars; WHAT IT COST = the body
   figure with head and body counts (ResultMarks / FaceMarks data), times hurt / opponent hurt / standing counts; the bottom
   row of six icon tiles (ticket cut, ladder points, members, what it taught, host favour dots, the plan's clue). Every tile
   and bar has a tooltip that EXPLAINS (never repeats the label). "More: the whole read" opens the modal with every fact in
   words (Close / Esc). Nothing the old page showed is dropped. The other tabs stay as they are.
2. Small files: ResultPage.gd is 382 lines - put the new pieces in new files (e.g. scripts/ui/ResultRounds.gd,
   ResultTiles.gd, ResultRead.gd for the modal); no script over 500 lines. Use the house theme, not new colours.
3. Tests: extend tests/result_tabs_test.gd (the modal opens and holds every fact; every tile has a tooltip) - red first;
   result_defects_test, result_marks_test, golden_path_test stay green. Stills on the hidden desktop through
   tools/layout_snapshot.gd (the result shots), saved via tools/clean_view.gd save_if_clean: a win, a loss on points, a
   stoppage. Open each still yourself and compare with the mockup; fix overlaps/cut text.
4. docs/RESULTV2_RESULT.md: what was built, stills, tests. Post the stills: `python ops/Tools/review_add.py --stage S538
   --rating "built, Claude" --title "Result page v2 in the game" <stills>`.

## Prior research
ops/previews/s538_look/NOTES.md; memory feedback_tooltips_explain_s532, feedback_names_only_in_headers_s448,
project_result_page_fight_only_s440.

## What would a human do?
Build exactly the picture the owner approved; words one hover away.

## Prefab check
None.

## Contract
OWNS: scripts/ui/ResultPage.gd, scripts/ui/ResultRounds.gd (new), scripts/ui/ResultTiles.gd (new), scripts/ui/ResultRead.gd
(new), tests/result_tabs_test.gd, docs/RESULTV2_RESULT.md
RED_TEST: tests/result_tabs_test.gd (modal + tooltips) red on main
REGRESSION: tests/result_defects_test.gd, tests/result_marks_test.gd, tests/golden_path_test.gd
VISUAL: three result stills from the real game

## Rules
Work in main. Another job edits scripts/ui/ResultTabs.gd (PLANFLOW2: the Plan tab) - do not touch ResultTabs.gd. Godot ONLY
through `python ops/Tools/godot_slot.py run --who resultv2 -- ...` (windowed only via tools/hidden_desktop.py). Read
ops/research/GDSCRIPT_TRAPS.md. Commit only your paths (`git add -- <new>` then `git commit -m ... -- <paths>`), end with
`Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two lines, stop.
