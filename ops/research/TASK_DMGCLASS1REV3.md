# TASK DMGCLASS1REV3 - write the stoppages-by-class-and-sex map v3 FROM THE CODE

Kind: research. Discipline: boxing. Model: Fable console in this checkout (maps come from the code, never a chat seat).
RESEARCH ONLY - no game code changes. Do not run Godot.

## Why
Map v2 (`ops/research/DESIGN_DMGCLASS1_V2.md`) scored 5 / 6 / 4 in a code-checked critic
(`ops/research/DESIGN_DMGCLASS1_V2_CRITIC_FABLE.md`; earlier Dola 9/9, Kalli 6/6/5). Its two findings:
- DEPTH 5: class adds no choice, it re-prices five existing ones. The critic's missing options: a division read at signing,
  a division line on the towel row, a style read naming the division, moving up / down a class (name it as the follow-up),
  the Why line after the fight.
- GENERAL DESIGN 6: about ten CODE claims were false (its claim table, F1-F13). F13 (a towel retirement wore the chin) is
  FIXED on main in S534 (BoutFinish: no wear on "RTD") - say so, do not repeat it.

## Your job
Write ONE new file `ops/research/DESIGN_DMGCLASS1_V3.md`:
1. "What the game does today" ONLY from code you opened (Knockdowns.gd round_counts / puncher_chance, ClassDamage if it
   exists, BoutFinish.gd, Towel.gd, Attrs.wear_stoppage, Injuries.gd, Data.gd classes, WorldSim.rounds_for, and what they
   call). Every CODE line names file + function (+ line) and is TRUE today; anything else is ESTIMATE or CUT. Fix every
   FALSE claim in the critic's table.
2. Walk the critic's "To reach 10/10" list and missing options one by one: take it (how, which number it moves) / refuse
   (one line why). The goal: class becomes a DECISION (signing, the towel, the camp), not only a hidden multiplier.
3. The table of every menu the mechanic appears on and what each is wired to, CODE TODAY vs TO BUILD.
4. The probe that sizes the numbers before any board (bounds, not exact counts; today's rules as the control).
Owner rulings to keep: females never fight males; booking matches weight class; names only in headers; only actionable
information on screen; real-world evidence for every number (cite it).

## Contract
OWNS: ops/research/DESIGN_DMGCLASS1_V3.md
RED_TEST: none (research)
REGRESSION: tests/towel_wire_test.gd (research only: nothing to rerun unless code is touched)
VISUAL: no

## Rules
Touch ONLY that file. Other sessions have uncommitted edits (LineGrade.gd, LiveRound.gd, StepWire.gd) - never stage them.
`git add -- ops/research/DESIGN_DMGCLASS1_V3.md`, commit to main, push, report in two lines, then stop.

## Prior research
`python ops/Tools/prior_research.py stoppage weight class knockdown`; v2 and its critics above.
## What would a human do?
A matchmaker says: "at heavyweight one punch changes everything; at flyweight they go the distance - pick your boxer for it."
## Prefab check
None (a design map).
