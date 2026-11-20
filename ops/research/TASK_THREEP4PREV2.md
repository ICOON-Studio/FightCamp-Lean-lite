# TASK THREEP4PREV2 - the three P4P mechanics, design map v2 FROM THE CODE

Kind: research (design map)
Status: OPEN (S532, Claude main). Discipline: boxing. Model: Arena (cloud). Work on FightCamp-Lean-lite main, your own
arena/ branch, a PR into main there; never merge. RESEARCH ONLY - no game code changes. Do not run Godot.

## Why a v2
The three mechanics of `ops/research/DESIGN_THREE_FROM_P4P_S531.md` (the coach's read on a bout offer; a beaten opponent
asking to train at your gym; the corner's eye in the top-down fight view) are BUILT (S531). Two critics:
- Dola `ops/research/DESIGN_THREEP4P_CRITIC_DOLA_DOLA.md`: depth 8, general 8, play 9 (its "To reach 10/10" near the end).
- Arena `ops/research/DESIGN_THREEP4P_CRITIC_ARENA.md`: depth 6, general 7, play 8, with a CODE CHECK of 12 rows where
  the built code does less than the map said (the read never uses style or the plan; the ask is not tied to a coaching
  moment; the ring shade is a win streak, not space; a passed opponent is not remembered; names in body text).
The owner's bar (S425): 7+ depth AND 7+ general design from both critics before the board.

## Your job
Write `ops/research/DESIGN_THREEP4P_V2.md`:
1. Section 1 "what the game does today" ONLY from code you opened (each CODE line names file + function + line, and is
   TRUE). Start from Arena's CODE CHECK table - re-open each file and confirm or correct each row.
2. For each mechanic: the CHANGES to the built code that answer BOTH critics' "To reach 10/10" lists (do it, or one line
   why not), each tagged ESTIMATE, each naming the function it changes and the number the player's choice moves.
   Arena's list leads where they disagree about the code; Dola's where it is about play.
3. Depth: at least three real choices per mechanic with a trade-off and no dominant pick (e.g. the read must sometimes
   say pass and be right; beating weak opponents must not be the best way to recruit).
4. The menu table: menu | CODE TODAY | TO BUILD, for every screen the three touch (amateur offer list card, the bout
   page, pro rows and debut offers, the top-down view, the corner minute, the result's Why, reception, Home's needs).
5. Plain words; names only in headers; "your boxer", "the opponent"; no she/her for the player's boxer.

## Deliverable
ONE new file `ops/research/DESIGN_THREEP4P_V2.md`; in the PR body the list of code files you opened. A PR adding only it.

## Contract
OWNS: ops/research/DESIGN_THREEP4P_V2.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
DESIGN_THREE_FROM_P4P_S531.md; both critics above; P4P read (S531, research/topics or PNP files via prior_research.py "pound for pound").
## What would a human do?
A designer replays a month with the built features, notes each moment the advice was wrong or the reward unearned, and
fixes those before adding anything.
## Prefab check
None (a design map).
