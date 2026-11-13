# TASK GRADE1 - QWEN - centre the plan-line grade (Good / OK / Poor) and wire it into the fight and its forecast

Status: OPEN (S460, Claude main). Discipline: boxing. Model: qwen3-coder.
Why: LineGrade (scripts/rules/LineGrade.gd) grades how well THIS boxer does each plan line from two attributes. Wired as written
(S459) it dropped a right plan's GOOD read in tests/fight_why_test.gd from 384 to 161 of 540: OK = x0.85 cuts every average
boxer's plan by 15 %. The approved design (ops/research/PROGRESSION_MAP_S448.md section 10, row GRADE1) wants the grade to
matter - Good vs Poor on a line worth 2+ wins in 100 - WITHOUT making an average boxer's plan worth less than today.

## Contract
OWNS: scripts/rules/LineGrade.gd, tools/grade_probe.gd, docs/GRADE1_RESULT.md, tests/line_grade_test.gd, scripts/state/LiveRound.gd, scripts/rules/BoutRead.gd, scripts/rules/PlanChain.gd
(LineGrade: the PLUS table + one new static switch. In LiveRound.gd, BoutRead.gd and PlanChain.gd ONLY these call lines:
      LiveRound.gd ~270 `var plan_edge := PlanFight.edge(pick, psit, plan_rate * PerkFight.combo_rate(f, arrow), card_mean)`;
      BoutRead.gd ~242 `e += PLAN_REACH * PLAN_CARRY * PlanFight.edge(pick, sit, ...)`;
      PlanChain.gd ~35 `var e := PlanFight.edge(pick, sit, PlanFight.rate(mv, combos), PlanFight.card_mean(...))`)
RED_TEST: tests/line_grade_test.gd -> LINE_GRADE failures=0 (add a row first that is red on main: "an average boxer's mean
          multiplier over the roster's lines is 1.00 +- 0.03")
REGRESSION (run each, all must end failures=0): line_grade_test, bout_read_test, plan_fight_test, style_name_test, plan_chain_test,
          file_limits_test, golden_path_test. fight_why_test is ALREADY RED on main (384/540 since S450) - report its number on
          main and on your branch; do not change that test.
VISUAL: no
NOT YOURS: every other line of LiveRound.gd / BoutRead.gd / PlanChain.gd, every other file.

## The work
1. A static switch on LineGrade: `static var wired := true`. `LineGrade.attrs_for(f: Dictionary) -> Dictionary` returns
   `Attrs.of(f)` when wired, `{}` when not (LineGrade.edge with `{}` = today's ungraded PlanFight.edge, already coded).
2. Replace the three call lines above with `LineGrade.edge(pick, sit, rate, base, LineGrade.attrs_for(f))` (same arguments, the
   boxer's attrs added; in PlanChain the boxer dictionary is whatever the function already has - read the function; if it has
   none, pass `{}` and say so in the result). LiveRound.gd has a HARD 470-line cap (tests/file_limits_test.gd TIGHT): it is 469
   now. Add the LineGrade preload by folding, never by adding two lines: the file must end at 470 or fewer.
3. tools/grade_probe.gd (headless): for the same seeded bouts fight_why_test uses (copy its setup, 540 bouts), run arms:
   A `wired = false` (today); B the current PLUS {Good 1.2, OK 0.85, Poor 0.35}; C, D, E three CENTRED tables you compute:
   count over the roster's (boxer, planned line) pairs the share of Good / OK / Poor, then pick tables whose share-weighted mean
   is 1.00 (e.g. OK 1.0 with Good / Poor spread +-0.2, +-0.3, +-0.4 around it). Print per arm:
   `ARM <name> good=<x> ok=<y> poor=<z> mean_mult=<m> right_plan_GOOD=<n>/540 win_share=<w>`.
   Then, for the chosen table: two boxers who differ ONLY in the two attributes of one planned line (one Good, one Poor; never two
   identical fighters - they also differ in name and frame), 500 seeded bouts each against the same opponents:
   `GOOD_VS_POOR wins_good=<a> wins_poor=<b> gap_per_100=<g>`. The bar: gap 2+ in 100, and arm C/D/E right_plan_GOOD within 10 of arm A.
4. Set PLUS to the smallest-spread centred table that clears the bar. Write docs/GRADE1_RESULT.md with every ARM line, the
   GOOD_VS_POOR line and the chosen table. If no table clears the bar, set nothing, write the numbers and say so.

## PR body (machine-checked)
RESULT: tests/line_grade_test.gd -> LINE_GRADE failures=0
RESULT: tools/grade_probe.gd -> GRADE_PROBE done
plus every ARM / GOOD_VS_POOR line copied exactly.

## Traps
- Godot headless only, the plain binary (never _console.exe), `--audio-driver Dummy`. Never two identical fighters.
- Do not touch the fight_why bar or its days (the test says why). Do not change Exchanges.GOOD_AT / OK_AT.
- GDScript: no `:=` on a Variant from a Dictionary get (ops/research/GDSCRIPT_TRAPS.md).

## Prior research
- ops/research/INTEGRATION_S459.md row 2 (the 384 -> 161 measurement), PROGRESSION_MAP_S448.md section 10 (GRADE1 bar),
  LineGrade.gd header (S442 LINEGRADE1), tests/fight_why_test.gd header (S434 NOCAMP1: how a grade change moves the bar).

## What would a human do?
Set the average to 1.0 first, so that nothing changes for the middle of the roster, then widen the spread until the difference
between a good and a poor boxer shows up in the results.

## Prefab check
None: LineGrade.edge already exists (S459); this is numbers + three call lines + a probe.

Test command: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tests/line_grade_test.gd`
Probe: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/grade_probe.gd`
