# Kalli - what the player decides DURING a BJJ bout (S427)

Open ops/research/CRITIC_PACK.md and ops/research/CRITIC_ACCESS.md first (the whole game, the Miro board, real screens).
Then scripts/rules/BjjMatch.gd (the live bout's rule) and ops/research/BJJ_DESIGN_V6_S397.md (the design it came from).

## The owner's words (2026-11-10, on a film of the live BJJ bout, review comment C274)
"looks ok but maybe add some options for te player to decide during the fight ? and also add the missing refinement art
and add visual effects"

## What the bout gives the player today (GAME, BjjMatch.gd)
- A 5:00 no-gi match that plays itself in 3D. The player gets 3 calls a match, offered only when the pair settles in a
  heavy position (guard, half guard, side control, mount, back). A call card shows up to 3 options for about 5 seconds:
  her own plan's move, one other move, and "Hold and breathe" (+gas, no risk). Each option shows chance, points, gas, risk.
- In the film he watched, the card offered "Move up (46%)", "Move up (46%)" and "Hold and breathe": two of three options
  were the same decision. When her gas is low the calls are refused ("gassed: no calls"). Between calls he only watches.
- The boxing bout, for comparison, gives a shout each exchange window (graded Good / Risky for the moment, with an energy
  cost in words), a corner minute between rounds (two instructions get through) and a NOW plate when a gap opens.

## The job
Design the decisions a coach at the mat's edge really has in a 5-minute grappling match, as a game. For each decision:
1. WHEN it comes up (a position, a score, the clock, her gas, the opponent's habit) and how often in 5:00. He must not
   wait more than about 30-40 seconds without something to decide, and never be asked the same thing twice running.
2. The OPTIONS (2 to 4), and for each the case where it is the right one. No option that is always right or never right.
3. What it CHANGES in the bout (use the levers BjjMatch already has: odds by kind, gas, the initiative, points,
   advantage, stalling; say plainly when a lever is new) and what the player SEES when it lands.
4. The cost of calling (her gas, her trust in the corner, a limited number) so that calling is itself a choice.
Think of: pace (push / hold / stall with a lead and the referee's stalling warning), points against submission hunting,
defending a lead in the last minute, answering the opponent's best move once it has shown twice, a reset to the feet,
riding out a deep submission or tapping, and what the corner may say at the 2:30 mark. Use real coaching: what a real
corner shouts in a no-gi match and what the IBJJF / ADCC rules allow (name the rule; mark anything unverified CHECK).
Tag every number REAL (source), GAME (file) or INVENTED.

Then:
5. The camp link: which of these choices are bought earlier in the week (a drilled escape, a game plan from the mat
   tree, scouting her opponent), so the live choices have stakes that started on Monday.
6. The menus: every screen each decision shows on and what it reads from (the live bout, the mat tree, fight prep, the
   after-bout Why).
7. The smallest version worth building first, then the order.
8. Your own kill list: the hardest objection to each decision and your answer.
9. A score as a hard critic would give the depth (0 to 10) and the concrete changes that take it to 10.

Write the whole page as plain markdown TEXT in your reply, nothing as an attachment; in parts if it is long
("part 1 of n").
