# TASK PLANFLOW2 - plan chart: main bet, how often each line fired, save/load a plan; probe "repeat it and get read" (S538)

Status: DONE (collected 1ec898481; marked S540)

Model: claude-fable-5-2 (headless on the API credit, ops/Tools/sdk_run.py). Discipline: boxing (demo).

## Owner (S538, Q-S294-301, verbatim)
"yes add those , and maybe add a penalty if some combos are repeated too often the have a bigger chance to be read by the
opponent for a counter punch"

"Those" = the three extras the plan chart's own row named (PLANFLOW1, built S482 c6477e419, scripts/ui/PlanChart.gd 499 lines,
PlanChartShapes.gd, GamePlan.gd, GamePlanRows.gd):
1. A MAIN BET: the player marks one line as the plan's main bet (the thing the plan stands on); the result page's Plan tab says
   whether the bet paid (it fired, it won its exchanges).
2. USES: after a fight, each line on the chart shows how often it fired and won (the bout already records exchanges - find
   where the result page's "The plan" tab and "The plan's clue" read them; do not count twice).
3. SAVE / LOAD: save the current plan under a name, load a saved plan onto a boxer (only lines that boxer can fire; say which
   were dropped and why). Saved with the career (Career resource / save file - follow how other per-career lists save).

## Do
A. Build 1-3 (approved). PlanChart.gd is at 499 lines: put new UI in new small files (no script over 500 lines). Every new
   control has a tooltip that explains, never repeats the label (memory feedback_tooltips_explain_s532). Golden path:
   extend tests/plan_chart_test.gd to mark a bet, save, clear, load, and a fought bout showing uses. Stills of the chart with a
   bet and uses on the hidden desktop (`python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed
   --resolution 1920x1080 --script res://tools/layout_snapshot.gd -- <out_dir>`; save via tools/clean_view.gd save_if_clean).
B. The repeat penalty is a NEW MECHANIC: owner rule S534 - probe it on a greybox FIRST, never build it before. Greybox
   (tools/repeatread_probe.gd, flagged local copy, nothing under scripts/ changed for B): when one combo/line is used past a
   share of the exchanges, the opponent reads it - her counter chance on that line rises with the share (find the counter
   roll in scripts/rules/Exchanges.gd / Player2 / the plan's exchange resolution; a boxer with high ring IQ or a
   counter-puncher reads faster; the read fades if you switch). Population: 60+ fighters, all differ, against the six styles.
   Bars fixed BEFORE the run: (a) a one-line spam plan loses 5+ wins in 100 against counter-punchers and 2+ overall;
   (b) the best plan is not "never repeat" either (a plan with a clear main weapon still beats a flat even spread somewhere);
   (c) the effect is larger than the cell's error. Write docs/REPEATREAD1_RESULT.md. PASS: write ops/research/DESIGN_REPEATREAD1.md
   (the rule, where it shows: plan chart warning, result page "she read your double jab", the menus table) and
   ops/research/CRITIC_REPEATREAD1_BRIEF.md (opens with CRITIC_PACK.md + CRITIC_ACCESS.md; depth and play /10; the list to
   reach 10); queue it: `python ops/Tools/seat_queue.py add --seat kalli --brief research/CRITIC_REPEATREAD1_BRIEF.md`.
   FAIL: say what would have to change. Check first whether something like it exists (scripts/rules/Adaptation.gd has
   REPEAT_HOLD for corner changes; Knowledge/"habit" reads) and reuse it rather than add a layer.
C. docs/PLANFLOW2_RESULT.md: what was built, stills, tests, the probe verdict.

## Prior research
docs/PLANFLOW1* (git log --grep PLANFLOW1), research/topics/defence.md, ops/research/DEPTH_SCOPE_S534.md,
`python ops/Tools/prior_research.py plan chart main bet save load`.

## What would a human do?
A coach builds the plan around one weapon but warns: throw the same double jab every time and a smart opponent times it.

## Prefab check
None.

## Contract
OWNS: scripts/ui/PlanChart.gd, scripts/ui/PlanBet.gd (new), scripts/ui/PlanSaves.gd (new), scripts/ui/GamePlan.gd,
scripts/ui/ResultTabs.gd (Plan tab: bet + uses only), scripts/state/Career.gd (saved plans only), tests/plan_chart_test.gd,
tests/plan_saves_test.gd (new), tools/repeatread_probe.gd (new), docs/PLANFLOW2_RESULT.md, docs/REPEATREAD1_RESULT.md,
ops/research/DESIGN_REPEATREAD1.md, ops/research/CRITIC_REPEATREAD1_BRIEF.md
RED_TEST: tests/plan_saves_test.gd red on main
REGRESSION: tests/plan_chart_test.gd, tests/golden_path_test.gd, the save/load test
VISUAL: stills of the chart (bet + uses) and the result Plan tab

## Rules
Work in main. Godot ONLY through `python ops/Tools/godot_slot.py run --who planflow2 -- <godot.exe> --headless --audio-driver
Dummy --path . --script res://...` (windowed only via tools/hidden_desktop.py); long output to a file. Read
ops/research/GDSCRIPT_TRAPS.md. Commit only your paths (`git add -- <new>` then `git commit -m ... -- <paths>`), end with
`Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two lines, stop.
