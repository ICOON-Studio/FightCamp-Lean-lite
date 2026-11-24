# STYLEPLACE_SCOPE_S551 - opponents that fight in different places, so the written plan can matter

## The decision
Board Q-335 (S551): "The written plan is worth 2 wins in 100. Make opponents fight differently so it matters?" -
owner: **"Yes, scope it"**. This page is the scope. Nothing is built from it before the probe passes and critics score 8.

## The finding it follows (a METHOD finding)
Two probes of plan RULES failed for the same reason (`docs/PLANIMPACT1_RESULT.md`, `docs/PLANIMPACT2_RESULT.md`, checked
in `PLANIMPACT1_CHECK_S549.md` and `PLANIMPACT2_CHECK_S551.md`): the cap is the opponent model, not the plan.
- `Exchanges.STYLE_MODES` (l.156-166): every one of the nine styles plays all four games (press, range, counter,
  loadup); they differ only in the mix.
- `PlanFight.GAME_CARD` (l.25): press and loadup both put the fight on MID, range on LONG, counter on OUTSIDE;
  `LOST_CARD` (l.28): losing to press or loadup both leave her on her OWN ROPES. So every opponent is fought on the same
  four places. INSIDE and the opponent's ropes are reached only through tiredness and hurt, never through a style.
- `PlanFight.ANSWERS` (l.50-54): the best answers to press and to loadup share four of five moves (step_back, slip 2-3,
  roll_out, 1-1). One plan line on mid answers a presser and a slugger alike.
RULE UNTIL THIS IS DONE: no third plan-rule probe (no more "the plan raises X"); the plan screen is not shrunk.

## Direction (Claude's starting point, not yet probed)
Three levers, each a switch in `tools/`, each measured alone, then together. Each must follow real boxing, not a number.
1. A STYLE OWNS A PLACE. The place a game is fought on comes from the style as well as the game: a Slugger loads up
   INSIDE (chest to chest, where his hooks are), a Swarmer and a Stalker press her to her ROPES at once, an Out-boxer's
   counter game stays at LONG, a Counter-puncher waits OUTSIDE. Six places exist already (mid, long, outside, inside,
   own ropes, her ropes); today four are used.
2. PRESS AND LOADUP STOP SHARING THEIR ANSWERS. Against a presser the best answers turn her (pivot out, 1-1, roll out);
   against a loader they take the shot away (slip and counter, tie up, step back). A move that is best for one is only
   "ok" for the other. Each split needs a real-bout reason (John or `REALPLANS_S341.md`), written before the run.
3. THE FILE SAYS WHERE SHE FIGHTS. `OppFile` already names her main game; it would name her PLACE. Then scouting,
   film nights and the plan screen have something specific to say ("she fights inside: plan the inside card") - the
   knowledge mechanic and the plan pay each other instead of each being probed alone.
Not in this scope: new moves, new styles, the corner command grade (COACHMAP2 owns it: one rule is not sold twice),
the card game.

## Phases
| Phase | What | Who | Done when |
|---|---|---|---|
| 0. Paper | For each lever: the tables as they would read, and a count with no bouts - how many lines of the best plan against style X are also best lines against style Y | worker, first hour of the probe | the count is on `DESIGN_STYLEPLACE1.md`, committed before any bout |
| 1. Probe | `TASK_STYLEPLACE1.md`: the levers as switches over PLANIMPACT2's harness, control first | Claude worker, console tab, about 4-5 h | the bars below, each lever alone and together |
| 2. Critics | a code-checked critic first (Arena), then Kalli and Dola | seats | 8 on depth and 8 on play |
| 3. Build | the tables in `scripts/rules`, every reader of GAME_CARD / LOST_CARD / STYLE_MODES (list below), the menus | Claude + a worker | each menu shows it in the .exe, one golden-path walk, his play |

## Bars (written before any run; 1, 2, 4, 5 are PLANIMPACT2's, unchanged)
1. CHOOSING WELL PAYS: best plan - careless plan >= 6 wins in 100 for 3 of 5 boxers.
2. THE PLAN PAYS: best plan - the coach's plan >= 6 for 3 of 5.
3. NOT ONE PLAN: no single plan is the best against more than 3 of 6 styles, for 3 of 5 boxers.
4. CARELESS COSTS: careless - coach's plan <= -3.
5. THE GAME IS NOT REBALANCED BY ACCIDENT: with no plan at all, each boxer's wins against each style stay within 3 of
   today's (control arm); no style becomes a free win or a wall (no cell under 25 or over 85).
6. EVERY PLACE IS FOUGHT ON: each of the six places holds 5% or more of the exchanges over the opponent set; no style
   keeps the fight on one place for more than 70% of a bout.
7. THE FILE CAN SAY IT: one plain line a style ("she loads up inside") that a scouting file with one film gets right
   for 4 of 5 opponents (ModeTells' own rate, measured).
8. PLAY: count how many DIFFERENT plans a player who reads the file writes over one season of opponents (target 3 or
   more; today's answer is one).
A lever that fails bar 5 is dropped, not tuned. If nothing reaches bars 1 and 3: say so, the plan stays as it is, and
the choice goes back to him (cut it or keep it small) - never removed silently.

## Readers of the tables a build must touch (from grep, S551)
`PlanFight.gd` (GAME_CARD l.25, LOST_CARD l.28, ANSWERS l.50, l.166-169), `PlanChain.gd` (l.29, 82, 118), `PlanFile.gd`
(l.58-60), `PlanLines.gd` (l.111), `CoachPlan.gd` (l.38-43), `GuardNotes.gd` (l.16), `OppFile.gd` (l.26, 88, 112-114),
`BoutRead.gd` (l.268), `CornerJobs.gd` (l.61), `ModeTells.gd`, `StepWrong.gd` (l.12, 55), `Exchanges.gd` (l.313).
Menus that would show it: the opponent file, the plan screen (which card is asked for), the film night, the fight
log's place words, the result page's "why". The 3D fight already draws inside and ropes exchanges.

## Feedback loops
- A style that presses to the ropes -> she is on her ropes more -> `GuardNotes` wears her guard more there -> she
  loses more exchanges -> more ropes. Cap: the existing wear cap; print the share of exchanges on own ropes per style
  and stop if any style passes 50%.
- Inside -> body work -> her stamina -> she tires -> "tiring" already puts the fight inside. Print the inside share by
  round; stop if it climbs every round in more than half the bouts.
- The plan answers her place -> wins -> nothing here feeds back into the opponent's style (styles do not learn).
  Confirm in code before the run.
- One-rep trial before any table: one boxer, two styles, 40 bouts, all arms; stop if two arms print the same bouts
  (a switch not wired) or the control does not reproduce PLANIMPACT2 bout for bout.

## Prior research
`docs/PLANIMPACT1_RESULT.md`, `docs/PLANIMPACT2_RESULT.md`, both check pages, `docs/PLANWORTH1_RESULT.md` (a whole
plan +1.7), `ops/research/topics/footwork.md`, `REALPLANS_S341.md` (real fight plans against the answer table),
`STRIKEMAP_S335.md` (the six places), `CARDBOX1_JOHN_BRIEF_JOHN.md` (three real bouts round by round: where each was
fought), `DESIGN_KNOW_STAKES1_V9.md` (what scouting shows).
