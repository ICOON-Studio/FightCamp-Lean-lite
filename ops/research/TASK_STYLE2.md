# TASK STYLE2 - make each named style worth 1.5 to 4 wins in 100 (tune StyleName.EFFECTS), and redo the road to a style

Status: OPEN (S481, Claude main). Discipline: boxing. Model: Goose (cloud).

## Why now
STYLE1 (ops/research/STYLE1_RESULT.md, tools/style1_probe.gd + tools/style1_probe_rules.gd on main) measured the six named
styles at 0 to 1.3 wins in 100 against their best opponent; the progression map's bar (PROGRESSION_MAP_S448.md M4) is 1.5 to
4. Its Part B ran a simplified career model, not tools/prog_probe.gd's week loop, so "no style is ever held" is unproven.

## What to do
1. PART A, tuned. Copy tools/style1_probe.gd Part A into tools/style2_probe.gd (under 500 lines; reuse
   tools/style1_probe_rules.gd by preload, do not edit it). N = 40 bouts a fighter per cell (say the dice on one delta).
   Change ONLY the numbers in scripts/rules/StyleName.gd EFFECTS (the "add" / "mult" values; never the levers, never the
   "when" lists) until every style's best delta is 1.5 to 4 in 100 and no style is the best against all four opponents.
   Keep each change the smallest that lands in the band. Print the 6 x 4 table before and after.
2. PART B, on the game's loop. Use tools/prog_probe.gd + tools/prog_probe_rules.gd's week loop (arm B, seeds 4481-4483,
   two seasons; COPY what you need, do not edit them) and record per career the first week each style is held
   (MoveTree.styles_held), the style named (StyleName.monday) and two_held. If no style is ever held, find the reason in
   the loop (which of the three moves never reaches 60, and how close it gets) and say it in plain words.
3. docs/STYLE2_RESULT.md: both tables, the EFFECTS before -> after, and one paragraph in plain words.
Summary line: `STYLE2 pass=<0|1> worth=<style:best_delta,...> held=<style:median weeks or never,...>`

## Pass lines
- RESULT: tools/style2_probe.gd -> STYLE2 pass=1
- RESULT: tests/style_name_test.gd -> its pass line (update ONLY the expected EFFECTS numbers if it pins them)

## Contract
OWNS: tools/style2_probe.gd, docs/STYLE2_RESULT.md, scripts/rules/StyleName.gd (EFFECTS numbers only)
RED_TEST: tools/style2_probe.gd -> STYLE2 pass=1 (STYLE1 on main reads every best delta under 1.5)
REGRESSION: tests/style_name_test.gd, tests/style_wire_test.gd, tests/learn_slots_test.gd
VISUAL: no
NOT YOURS: every other script under scripts/, every other test, tools/style1_probe*.gd, tools/prog_probe*.gd.
Run: `godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/style2_probe.gd` (Godot 4.7.2).
Work on your own branch, open a PR, never merge. Never delete or skip a test to go green.

## Prior research
ops/research/STYLE1_RESULT.md; ops/research/PROGRESSION_MAP_S448.md M4; docs/PICKSPREAD1_RESULT.md (punches beat steps:
a style whose set is mostly steps may read weak for that reason - say so).
## What would a human do?
Give each style a real, felt edge against the opponent it suits, small enough that no style is simply best.
## Prefab check
None: our own rules.
