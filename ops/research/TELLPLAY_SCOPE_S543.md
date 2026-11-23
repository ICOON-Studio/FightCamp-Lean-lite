# TELLPLAY_SCOPE_S543 - a tell must change how the opponent fights (the root under "the honest card solves it")

Source: `docs/TURNPROBE18_RESULT.md` (S543, 33,631 reads of the game's own win read, ten boxer types x 180 opponent files),
checked in code by the coordinator (`scripts/rules/BoutRead.gd` `_games` reads only the style and "walks in"; `OppFile.gd`
WEAPON_ANSWERS / WEAKNESS_ANSWERS name a situation for each tell that nothing in the opponent's game mix reads).

## PHASE 1 MEASURED (S544): FAIL - and the root is one level lower
`docs/TELLPLAY1_RESULT.md` (60,000 real bouts + 66,000 reads): making the opponent play a tell's situation more often
(rule A) moves a player's line by 0.1-0.8 points in the ring. Bar 1 fails 0 of 10 types. So the line is not small
because the situation is rare.
- RULE A IS NOT BUILT. Phases 2-4 below are void as written.
- CHECKED IN CODE (coordinator, S544), two corrections to the worker's "why": (1) a 58 coach reads ONE card
  (`CoachPlan.READ_AT` [50, 70]), so "the coach already wrote the answer" holds for that card only; (2) the probe's arm
  was the coach's arrows PLUS one player line, but in the game the coach writes only when the player's plan is empty
  (`BoutNight.gd` l.197-200) - one written line may switch the coach's plan off.
- NOT YET KNOWN: what a WHOLE player-written plan is worth today against the coach's, in real bouts (S397 said +12 to
  +16 for one opponent; the engine has changed). The owner's S354 "make the fight plan fun to design" stands on it.
  NEXT: `TASK_PLANWORTH1.md`, a measurement. Its numbers go to the owner; until then no design round whose central idea
  is a plan line the player adds, and no question to him built on TELLPLAY1's "why".
- A SEEN DEFECT, fixed apart from the dilemma: the read shows the fade answer at +7 to +15, the fight pays +0.9
  (`BoutRead._game_edge_of` l.247-248, `_round_edges` l.378: the worker's rule B "chain"). After the v17 merge.
- JUDGE ON THE REAL BOUT: the read can over-read a line 4 to 8 times. A probe's verdict comes from `BoutNight.play_out`
  (paired dice, the SE printed), the read only beside it.

## The finding (a METHOD finding: it sits under several mechanics, not one)
- A plan line the player writes against an opponent's weapon or weakness adds a median **0.2 to 1.1 points** of win chance
  over the coach's own plan. For 7 of 10 boxer types the best and the worst line are under 4 points apart.
- One tell is the exception and too strong: an opponent who fades. "Combinations inside when the opponent tires" adds
  7 to 15 points (`BoutRead.PLAN_REACH` x `PLAN_CARRY`, no fire share).
- WHY: a weapon or a weakness on the file does not make the opponent fight that way more often. The opponent's game mix
  comes from the style alone, so the line that answers the tell fires in a small share of the exchanges.
- WHO the opponent is moves the read a lot (same rating: 58% to 97% across files at a tune-up's aim), but the card prints
  that number. Reading the file is then reading a printed number: TURNPROBE16's "the honest card solves the decision".
- This agrees with what is already measured: a whole plan against no plan is worth 13 points (DEPTH_AUDIT_S534 row 25).
  What is small is the PLAYER's part on top of the coach's plan.

## What it sits under
| Mechanic | What was failing | How this explains it |
|---|---|---|
| Turning pro v11-v18 | the pick between two bouts is two prices | the matchup cannot be answered by the player, only read off the card |
| Scouting the opponent (KNOWMISREAD, the file's tells) | a wrong read of the file costs little | what a found tell is worth in the ring is about a point |
| Film night, the opponent's file | "always watch"; the answer differs but barely pays | the same |
| The push switch (PUSHPROBE2, DEPTHPRICE1A) | one rule is best ("push while wind is above 45") | nothing about THIS opponent changes when to push |

## The rule until this is built
No new design round whose central idea is "the player answers the opponent's tell" (turning pro's matchup rule, scouting the
opponent's file, the push switch's openings) until TELLPLAY1 is measured. Rounds that do not lean on it may go on.

## The plan
| Phase | What | Done when |
|---|---|---|
| 1. TELLPLAY1 (probe, now) | Two flagged local rules on the game's own read AND the real bout: (A) a tell's situation gets a weight in the opponent's game mix; (B) the fade answer comes under the 10-point cap. | Bars in `TASK_TELLPLAY1.md` pass, the read and the bout agree, the balance of today's bouts moves under 2 points |
| 2. Critics | Two fresh critics, one code-checked, on the measured rule: 8 DEPTH, 8 PLAY | two 8s, else one more round or back to the owner |
| 3. Build | The rule in `scripts/rules` with a red-first test; the film panel, the opponent's file and the plan board show "plays this more"; the tests pinned to exact bout results re-pinned with evidence | the owner plays a build where a found tell changes the plan and the fight |
| 4. Then | Turning pro v18 rule 1 (the matchup), what a misread file costs, the push switch's openings | each on its own probe |

Not in this scope: signing a prospect on uncertain reads (KNOW_STAKES v9 is about the prospect, not the opponent's file).
Also not in this scope: turning pro v17 as the owner approved it (Q-S294-320 "Yes, build it"; probe PASS 6 of 6) does not
depend on this and can be built and played while phase 1 runs.
