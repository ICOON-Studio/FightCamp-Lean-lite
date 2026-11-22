# TASK LOOKMOCK538 - three mockups for the owner's look: result page with more graphics, office goals panel, office sheets with right-click (S538)

Model: claude-fable-5-2 (headless on the API credit, ops/Tools/sdk_run.py). Mockups only: nothing under scripts/ changes.

## Owner (S538, verbatim)
- Result page (Q-S294-303): "the result page needs more graphics,use tooltips/modals to shorten things"
- Office (Q-S294-302): "the office needs a something like a goals tab to see what is pending what each fighter wants ,
  probably fit it in the dashboard"

## Do
1. Result page v2 mockup: ops/previews/s538_look/result_v2.html at 1920x1080, rendered with
   `python tools/render_mockup.py <html> <png>`. Start from the real page (ops/previews/p4pbuild1/21_result_real.png, the
   code scripts/ui/ResultPage.gd, ResultTabs.gd, ResultCause.gd, ResultScorecard.gd, ResultMarks.gd) and keep every fact it
   shows (none dropped - moved behind a hover or a "more" modal is fine). Replace text with graphics: judges' cards as a
   small round-by-round bar strip, the "why it was lost" as one headline + an icon, the plan test as a bar pair (already),
   damage as the body/face marks (ResultMarks), money/ladder/members as icon tiles. Long sentences go into tooltips (drawn
   as one open hover in the mockup) or a modal (drawn as a second still, result_v2_modal.png). Game words, no jargon; names
   only in headers (memory feedback_names_only_in_headers_s448). Use the house look (docs/menu_prototype.html palette,
   scripts/ui theme colours).
2. Office goals mockup: ops/previews/s538_look/office_goals.html + .png. The office dashboard (docs/previews/office1_desktop_real.png,
   scripts/ui/OfficeDesk.gd) gets a GOALS panel fitted INTO the dashboard (not a new screen): what is pending for the club
   (the NEEDS list's items, entries closing, bills) and what each fighter wants (scripts/rules/FighterGoal.gd and the
   fighter's wants/mood reasons - read what the game really tracks; show only what exists or say in a note what would need
   building). One row per fighter: portrait chip, the want, progress toward it, the deadline, what happens if it is missed.
   Draw it with the TEST CLUB (four fighters: three boxers in different classes + one BJJ) so it is populated.
   Say in a side note which panel shrinks to make room.
2b. Owner (S538, verbatim): "also maybe the fighters and coaches screens inside the desktop , could they be like excel sheets
   and when plqayer right clicks on a name can do various actions". Mockup ops/previews/s538_look/office_sheets.html + .png
   (and office_sheets_menu.png with the right-click menu open): the Fighters and Staff (coaches) icons open a SHEET inside the
   desktop - one row per person, sortable columns (Football Manager squad-view style: our words, nothing copied), the test
   club populated. Columns = what the game really tracks (read scripts/state/Roster.gd, the fighter dict, scripts/ui/RosterActs.gd,
   the Staff screen code): for fighters e.g. class, record, rank, stamina, mood, want, next bout, stipend; for coaches e.g.
   role, wage, what they run, fit. A right-click on a name opens a context menu of the actions the game ALREADY has for that
   person (list them from RosterActs.gd / the Staff screen acts: book a bout, plan, training, release, hire/fire, ...) - each
   action names the screen it opens; mark any action that would need building. One header row with a column chooser.
3. ops/previews/s538_look/NOTES.md: for each mockup, what moved where, what each tooltip/modal holds, and the data source
   (file:function) for every number drawn.
4. Put both on the map: `python ops/Tools/opsboard/map_board.py gallery s538_look "Result page v2 + office goals (your look)"
   --row "NOW" ops/previews/s538_look/*.png` (check its docstring for the exact form).

## Prior research
memory feedback_serious_sim_look_menu_structure_s430, feedback_menu_recipe_hades_ux_s442, feedback_only_actionable_info_s398,
feedback_tooltips_explain_s532; `python ops/Tools/prior_research.py result page office goals`.

## What would a human do?
A sports-sim UI designer shows the result as a few big pictures and numbers; the explanation sits one hover away.

## Prefab check
None.

## Contract
OWNS: ops/previews/s538_look/ (new)
RED_TEST: none (mockup)
REGRESSION: none
VISUAL: the four PNGs (open each yourself before committing)

## Rules
Open every PNG you render with the file tool and fix overlaps/cut text before committing. No app windows. Commit only your
paths (`git add -- <new>` then `git commit -m ... -- <paths>`), end with `Co-Authored-By: Claude Opus 5.5
<noreply@anthropic.com>`, push, report in two lines, stop.
