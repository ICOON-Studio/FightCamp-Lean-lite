# TASK TURNPRO12 - turning pro map v12 from the code, then re-run the probe (before any critic)

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).

## Why
`docs/TURNPROBE11_RESULT.md` (S534): v11 FAIL, 4 of 15 bars. Today's guarantee house + costs ask is the one answer (+$909);
v11 removed it and put nothing measurable in its place - every purse lever is inside the noise at a quarter share. What is
REAL: the debut win chance (56 vs 76 in 100 between houses), the softer opponent (+4.7 wins in 100) and the house's lean on
the first six pro fights (changes the pick in 44% / 20% of offer sets). Owner bar (S534): 8+ DEPTH and 8+ PLAY after the probe.

## What to write
1. `ops/research/DESIGN_TURNPRO1_V12.md` from `DESIGN_TURNPRO1_V11.md` + the probe's section 5 (all 9 items, in order): the fork
   built on the debut and the first six fights (ticket house = harder debut, step-up fights, a lasting non-dollar reward such as
   ladder position or reputation; guarantee house = safer debut, tune-ups); the win crowd paid as reputation or cut; the read
   counts only weeks past four; the crunch rescue sized to the hole or the crunch cell dropped; the wish given a lasting effect
   or cut; softer and "no ask" each given a cell where they win (a debut loss must leave a mark at week 40); the guarantee purse
   not presented as a lever. CODE file:line for every claim.
2. The weight class at turning pro is OWNED by the WEIGHT2 design (ops/research/TASK_WEIGHTMOVE1.md, running now): v12 only names
   the hook ("the table pick appears on this call") and does not design it.
3. Re-run the probe with the new pass rule (probe section 5 item 3: paired reading against the plain guarantee house, a gap of
   $1,000+ or 3+ wins in 100, ~180 rolls a cell) extending `tools/turnprobe11*.gd` into `tools/turnprobe12*.gd`; the mutant is
   today's costs ask (+$909, the proven one). Results `docs/TURNPROBE12_RESULT.md`. PASS = 12+ of the bars, the audit bars all pass.
   If it fails again, say plainly which part of turning pro cannot be a choice and what to cut (FREE HAND, owner S534).

## Prior research
docs/TURNPROBE11_RESULT.md (read whole), DESIGN_TURNPRO1_V11.md, V10 critics (John 6/7/7, Kalli 6/7/6), docs/DEBUTPICK1_RESULT.md,
docs/TURNPRO6_RESULT.md, DEPTH_AUDIT_S534.md, memory: probe populations and bout dice (Data people + PlanTest scratch nights).

## What would a human do?
A coach picks a promoter on who they will put in front of his boxer, not on a few hundred dollars: a builder who gives soft
tune-ups, or a promoter who throws him in and gets him noticed. The money is the boxer's; the club's gain is the name.

## Prefab check
None: all code exists (Roster, ProOffer, ProLadder, DebutOpp, the probe tools).

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V12.md, tools/turnprobe12.gd, tools/turnprobe12_sum.py, docs/TURNPROBE12_RESULT.md
RED_TEST: tools/turnprobe12.gd (a measurement probe)
REGRESSION: tests/debut_pick_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who turnprobe12 -- <command>` (busy queue: patient). Other sessions
have uncommitted edits (LineGrade.gd, LiveRound.gd, StepWire.gd) - never stage them. No file over 500 lines. Stage explicit
paths, commit to main with the Co-Authored-By line, push, report in two lines (map v12 written; probe PASS/FAIL, bars passed), stop.
