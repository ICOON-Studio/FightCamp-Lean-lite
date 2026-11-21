# TASK GUARDREV7 - guard map v7: the guard as a WHEN-line of the fight plan, sized from the v6 probe (map + probe)

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).

## Why (docs/GUARDPROBE6_RESULT.md, S535)
v6 FAIL: a FIXED Hands setting is never right - NORMAL best in 12 of 12 cells; High and Loose each cost more over a bout than
they give. The READ arm (High when your boxer is hurt or she loads up, Loose when she tires or is hurt) beats NORMAL in 10
of 12 cells, but only by 0.5 to 4 wins in 100. The per-exchange table shows why: High +4.7 vs loading up and +5.9 when your
boxer is hurt; Loose +5.8 vs a tiring and +4.5 vs a hurt opponent; every wrong use costs 5 to 13.
Claude's decision (FREE HAND, owner S534): the guard is no longer a setting for the bout. It is an action of the fight plan's
WHEN-lines (the plan flowchart / LineGrade path), so reading the moment is the skill. Owner bar: 8+ DEPTH and 8+ PLAY after the probe.

## What to write
1. `ops/research/DESIGN_GUARDDMG1_V7.md` from v6 + the probe: remove the fixed Hands setting; add High / Loose as plan-line
   actions on the situations the probe measured (loading up, pressing, range, counter, tiring, hurt, your boxer tired / hurt);
   size the per-exchange gains so the RIGHT read beats NORMAL by 5+ in 100 in at least 8 of 12 cells and a WRONG read loses 5+;
   say how the player learns which moment is which (knowledge read, film night, the Why after the fight). CODE file:line for every
   claim; read scripts/rules/LineGrade.gd and scripts/state/LiveRound.gd as they are (another session's uncommitted STEPPAY2
   edits are in them - read, never stage).
2. Probe v7: extend `tools/guardprobe6.gd` into `tools/guardprobe7.gd`: arms NORMAL, READ-right, READ-wrong (lines on the wrong
   moments), READ-noisy (right 70% of the time). PASS = READ-right beats NORMAL by 5+ in 8 of 12 cells, READ-wrong loses 5+ in 8
   of 12, READ-noisy still beats NORMAL in 6+ of 12, and no single line is best in more than 7 of 12 cells. `docs/GUARDPROBE7_RESULT.md`.

## Prior research
docs/GUARDPROBE6_RESULT.md (whole), DESIGN_GUARDDMG1_V6.md + critics (Arena 6/7/5, Kalli + John SQ273/274), GUARDV4 built parts
(bar, wear, leak, clinch, Hands up habits), PLANFLOW1 + WHYGRADE1 notes in roadmap, DEPTH_AUDIT_S534.md.

## What would a human do?
A corner never says "keep your hands high all night". He says "when he loads up, tight guard; when he slows, let your hands go."

## Prefab check
None: all code exists.

## Contract
OWNS: ops/research/DESIGN_GUARDDMG1_V7.md, tools/guardprobe7.gd, docs/GUARDPROBE7_RESULT.md
RED_TEST: tools/guardprobe7.gd (a measurement probe)
REGRESSION: tests/golden_path_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who guardprobe7 -- <command>` (busy queue: patient). Never stage
LineGrade.gd, LiveRound.gd, StepWire.gd. No file over 500 lines. Stage explicit paths, commit to main with the Co-Authored-By
line, push, report in two lines (map v7; probe PASS/FAIL with the bars), stop.
