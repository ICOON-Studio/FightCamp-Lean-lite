# TASK GUARDREV6 - write the guard damage map v6 FROM THE CODE: covering must change who wins the exchange

Kind: research. Discipline: boxing. Model: Fable console in this checkout (maps come from the code, never a chat seat).
RESEARCH ONLY - no game code changes. Do not run Godot.

## Why
Guard map v5 (`ops/research/DESIGN_GUARDDMG1_V5.md`, written from the code in S533) scored Kalli Depth 6 / General design 7 /
Play 5 (`DESIGN_GUARDDMG1_V5_CRITIC_KALLI_KALLI.md`): under the 7+ bar. Kalli's main finding is about the METHOD, not a number:
"every v5 rule acts after the exchange is settled" - the covering cut, the counter, BROKEN and "Jab and move" change
`landed` after `settle` has picked the winner, so the guard moves knockdowns and the referee's look but never who wins rounds.
Real judges score clean punches; a shell that throws nothing loses rounds. Dola's v5 score never came (her app is closed).

## Your job
Write ONE new file `ops/research/DESIGN_GUARDDMG1_V6.md`:
1. "What the game does today" ONLY from code you opened (scripts/rules/GuardWear.gd, GuardNotes.gd, Exchanges.gd and its
   settle, CornerCard.gd, CornerJobs.gd, LineGrade.gd READ ONLY, and what they call). Every CODE line names file + function
   (+ line) and is TRUE today; anything else is ESTIMATE or CUT. Show exactly where `settle` decides the exchange and every
   guard rule that runs before / after it.
2. The core change: the guard enters the exchange edge BEFORE settle (Kalli point 1: a Hands setting High / Normal / Loose,
   or the existing Hands up shout as a timed High), so covering can lose rounds and loose hands can win them. Name the edge
   sum it joins and the sizes as ESTIMATE until a probe sizes them.
3. Walk Kalli's 10-point "To reach 10/10" one by one: built (CODE ref) / take it (how, which number it moves) / refuse (one
   line why). Keep v5's taken items from John's list unless the core change makes them redundant.
4. The table of every menu the mechanic appears on and what each is wired to, CODE TODAY vs TO BUILD.
5. The probe that must pass before any board (Kalli point 10: four opponent types, amateur 3 rounds and pro 4/6 rounds,
   today's rules as the control; no Hands setting best against all four).
Owner rulings to keep: the 3D fight never decides, it shows the settled round; names only in headers; only actionable
information on screen; amateur vs pro differences stay.

## Contract
OWNS: ops/research/DESIGN_GUARDDMG1_V6.md
RED_TEST: none (research)
REGRESSION: tests/guard_wear_test.gd (research only: nothing to rerun unless code is touched)
VISUAL: no

## Rules
Touch ONLY that file. Other sessions have uncommitted edits (LineGrade.gd, LiveRound.gd, StepWire.gd; scripts/fight3d/v2) -
read them, never stage them. `git add -- ops/research/DESIGN_GUARDDMG1_V6.md`, commit to main, push, report in two lines.

## Prior research
`python ops/Tools/prior_research.py guard damage cover`; DESIGN_GUARDDMG1_V5.md, its Kalli critic, GUARDDMG1_V1_CRITIC_JOHN_S533.md.
## What would a human do?
A trainer tells a boxer who shells up: "you're not losing the round on damage, you're losing it because you're not punching."
## Prefab check
None (a design map).
