# TASK WEIGHT2R5 - weight probe round 5: the critics' lists (code-checked 6/7/6, Kalli 6/7/5) before the next critics

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Bar (owner S534): 8+ DEPTH and 8+ PLAY from two fresh critics, after the probe. Round 4 passed the probe bar (cd9a84dbe,
docs/WEIGHT2_PROBE4.md) but both critics stopped at 6: `ops/research/DESIGN_WEIGHT2_V2_CRITIC_FABLE.md` (code-checked, section
7 "To reach 10/10") and `ops/research/DESIGN_WEIGHT2_V2_CRITIC_KALLI_KALLI.md`.

## Do (the code-checked critic's items 1-4 first, in its order; then Kalli's PLAY points)
1. Probe the real choice: the same kilos by DIET, by WATER, MIX or carried UP, for a boxer 3 / 4 / 5 / 6 % over his line,
   water first up to the free 2 %. Bar: inside ONE scale the best policy changes with how far over he is AND with the boxer
   (Stamina over / under 60, Discipline 34 and 80). One policy winning every cell = it is a rule, not a choice.
2. Frame back on: stop erasing height and reach; draw the opponent's from his class (AttrGen.body), each division its own region
   sheet. DOWN = taller with longer arms; UP = shorter, no cut. Bar: DOWN best or tied for a jabber, UP for a chin with no reach.
3. The field cuts too: a pro opponent who rings 7.2 % over has cut ~8 %; charge him John's table, let his Stamina fall late,
   put his cut on the tape as a range (Knowledge) the plan can read. Refit the field after.
4. The design's scales: club show (one hour, gap rule, no walkover), championship (three hours, +1.9 %, walkover, weighed each
   boxing day), pro. Drop the hybrid.
5. Kalli PLAY 5 ("nothing pulls the player back on a Monday"): say which of 1-4 makes the week's diet a weekly decision; if
   none, propose the smallest change that does (not a new system).
6. `docs/WEIGHT2_PROBE5.md` (round 4's tables + the policy table of item 1), map `ops/research/DESIGN_WEIGHT2_V2.md` updated
   (round 5 note, CODE file:line kept), `ops/research/TASK_WEIGHT2V2CRIT.md` inputs moved to probe 5. Do NOT run a critic.
   PASS = round 4's bars still hold AND items 1-2's bars hold. FAIL -> which item broke; it comes back to Claude.

## Prior research
docs/WEIGHT2_PROBE3.md, docs/WEIGHT2_PROBE4.md, ops/research/JOHN_WEIGHT2_RESEARCH_JOHN.md (verify each number on its
source line), the two critic files above, memory project_s535_weight_deep_guard_plan_line.

## What would a human do?
A coach decides how a boxer makes weight - eat less for weeks, or dry out at the end - by who the boxer is and how far he is
over, and picks a class by who he would meet there: taller men below, stronger men above.

## Prefab check
None.

## Contract
OWNS: tools/weight2_probe.gd, docs/WEIGHT2_PROBE5.md, ops/research/DESIGN_WEIGHT2_V2.md, ops/research/TASK_WEIGHT2V2CRIT.md
RED_TEST: tools/weight2_probe.gd (a measurement probe)
REGRESSION: tests/golden_path_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who weight2r5 -- <command>`. Commit ONLY your paths with
`git commit -m "..." -- <paths>` (other consoles stage in this checkout). Never stage LineGrade.gd, LiveRound.gd, StepWire.gd,
MHRig.gd, tools/export.sh. Commit to main with the Co-Authored-By line, push, report in two lines, stop.
