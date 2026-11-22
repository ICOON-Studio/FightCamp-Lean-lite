# TASK PLANREADSHOW1 - show the "opponents adjust" rule the game already has (S538)

Model: claude-fable-5-2 (Code Mode terminal tab, owner's subscription). Discipline: boxing (demo).

## Why
Owner Q-S294-301: "maybe add a penalty if some combos are repeated too often the have a bigger chance to be read by the opponent
for a counter punch". The probe (docs/REPEATREAD1_RESULT.md, PLANFLOW2 1b2976832) FAILED as a new layer - and found the game
already has the rule, silent: scripts/rules/PlanRead.gd ADJUST (S396 "opponents adjust", wired at scripts/state/LiveRound.gd:255):
a right answer loses 30% of its edge for every use after the first two in a round. No screen says so. Owner rule S425: every
mechanic wired AND shown. So: show it, add no new rule.

## Do
1. Read PlanRead.gd (ADJUST), LiveRound.gd around :255, and where the bout records exchanges and plan uses (the result page's
   Plan tab - scripts/ui/ResultTabs.gd; the plan chart's new "uses" - PLANFLOW2's files).
2. Record per bout, per line: the uses where ADJUST bit and the edge it lost (in the bout record the result page already reads;
   no change to the fight's outcome - a determinism check: same seed, same result before and after).
3. Show it, game words, no names in body text (names only in headers):
   - the live fight feed: on the first bite in a round, one line like "She has your one-two now: it pays less this round";
   - the result page Plan tab: per line, "read after 2 uses in round 2: paid 30% less" + its tooltip explaining the rule and the
     fix (a second answer for the same moment, or drill it sharper);
   - the plan chart: a warning chip on a plan where one answer covers most of the likely moments ("leans on one answer: an
     opponent adjusts after two uses a round"), with a tooltip that explains, never repeats the label.
4. Tests: one red-first test (tests/plan_read_shown_test.gd) that a bout where ADJUST bites shows the line on the Plan tab and in
   the feed; determinism; plan_chart_test, result_tabs_test, golden_path_test green. Stills from the real game on the hidden
   desktop (result Plan tab, plan chart with the chip), opened and checked; `python ops/Tools/review_add.py --stage S538 --rating
   "built, Claude" --title "Opponents adjust: shown" <stills>`.
5. docs/PLANREADSHOW1_RESULT.md.

## Prior research
docs/REPEATREAD1_RESULT.md "What this means"; memory feedback_mechanics_wired_shown_7plus_s425, feedback_tooltips_explain_s532,
feedback_names_only_in_headers_s448.

## What would a human do?
A corner man between rounds: "he's timing your one-two now - mix in the double jab".

## Prefab check
None.

## Contract
OWNS: scripts/state/LiveRound.gd (recording only, near :255), scripts/ui/ResultTabs.gd (Plan tab), scripts/ui/PlanChart.gd or a new
scripts/ui/PlanLean.gd, the fight feed file that prints live lines (find it), tests/plan_read_shown_test.gd (new),
docs/PLANREADSHOW1_RESULT.md
RED_TEST: tests/plan_read_shown_test.gd red on main
REGRESSION: tests/plan_chart_test.gd, tests/result_tabs_test.gd, tests/golden_path_test.gd, tests/plan_test_it_test.gd
VISUAL: result Plan tab + plan chart stills

## Rules
Work in main; Godot only through `python ops/Tools/godot_slot.py run --who planreadshow1 -- ...`; windowed only via
tools/hidden_desktop.py. No script over 500 lines. Read ops/research/GDSCRIPT_TRAPS.md. Commit only your paths (`git commit -m
... -- <paths>`), end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push. When done run
`python ops/Tools/idle_guard.py ok PLANREADSHOW1-done`, report in two lines, stop.
