# TASK TURNPRO10 - write the turning pro map v10 FROM THE CODE

Kind: research. Discipline: boxing. Model: Fable console in this checkout (design maps come from the code, never a chat seat).
RESEARCH ONLY - no game code changes. Do not run Godot.

## Why
Turning pro v9 (`ops/research/DESIGN_TURNPRO1_V9.md`) scored John 6/6/7 (`DESIGN_TURNPRO1_V9_CRITIC_JOHN_JOHN.md`) and Dola
7/8/7 (`DESIGN_TURNPRO1_V9_CRITIC_DOLA_DOLA.md`): John is under the 7+ bar. Since v9 the offer changed in code:
- DEBUTPICK1 (S533, owner Q-286 "Pick to each boxer"): each house picks the debut opponent to fit the boxer
  (scripts/rules/DebutPick.gd, docs/DEBUTPICK1_RESULT.md) - John's point 1 is built.
- TURNPRO6 (S533): the offer's win read is the bout as fought (scripts/rules/DebutRead.gd, DebutOpp.gd, docs/TURNPRO6_RESULT.md).
- S534 (owner review C442/C443): the card names each house's debutant and why it was picked; no rating gap, no aim number;
  morale off the buttons, one MORALE line with the boxer's goal (ProOfferWire.morale_line); scripts/ui/modals/ProOffer.gd.

## Your job
Write ONE new file `ops/research/DESIGN_TURNPRO1_V10.md`:
1. "What the game does today" ONLY from code you opened (ProOffer.gd, ProOfferWire.gd, ProCall.gd, ProDebut.gd, DebutPick.gd,
   DebutRead.gd, DebutOpp.gd, Roster.turn_pro, GymBills, and what they call). Every CODE line names file + function and is
   TRUE today; anything else is ESTIMATE or CUT.
2. Walk John's 13-point "To reach 10/10" and Dola's list one by one: built (CODE ref) / take it (how, which number it moves) /
   refuse (one line why). Owner rulings to keep: amateur bouts need no camp; the debut is 70-80 in 100 for the safer house
   (DEBUTPICK1 owner "78 is fine"); names only in headers; only actionable information on screen (owner C443 "can he do
   anything about them?" - no number the player cannot act on); board text short.
3. The table of every menu the mechanic appears on and what each is wired to, CODE TODAY vs TO BUILD.
4. Depth target 7+ on DEPTH and GENERAL DESIGN: no dominant house across the boxers 46-74; each ask the best pick somewhere.

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V10.md
RED_TEST: none (research)
REGRESSION: tests/debut_pick_test.gd (research only: nothing to rerun unless code is touched)
VISUAL: no

## Rules
Touch ONLY that file. Other sessions have uncommitted edits (LineGrade.gd, LiveRound.gd, StepWire.gd; scripts/fight3d/v2) -
never stage them. `git add -- ops/research/DESIGN_TURNPRO1_V10.md`, commit to main, push, report in two lines.

## Prior research
`python ops/Tools/prior_research.py turning pro debut offer`; v9 + both critics above; docs/TURNPRO6_RESULT.md, docs/DEBUTPICK1_RESULT.md.
## What would a human do?
A manager lays the two contracts side by side and asks which one gets this boxer to a second fight with money in the club.
## Prefab check
None (a design map).
