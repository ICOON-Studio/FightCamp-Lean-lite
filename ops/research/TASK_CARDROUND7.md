# TASK CARDROUND7 - card round 7: the build he can open (PLAY gate) (S541)

Seat: ARENA (owner S539: card game written by the free seats; Claude coordinates). New Arena chat on the lite mirror, branch
main, AFTER CARDFIX6B is merged (start from what it landed). Node + browser only; never Godot. Commit only proto/cardgame/ and
ops/research/DESIGN_CARDGAME_SCOPE.md. Keep every test; never delete or weaken one.

## Why
The owner SIGNED the pre-production plan (board Q-S294-312 "Sign it", S541) and answered Yes to all five: play every build
before balance is done (313), art order wrestling, kickboxing, judo, karate, sambo, MMA last (314), Early Access with four arts
(315), an art may have a bad matchup, never worse than 40-60 (316), try the timed guard once at the three-art build (317).
Plan: ops/research/CARDGAME_PREPROD_S540.md - read section 1 (STOP list), section 3 (first 10 minutes), section 7 (the PLAY
and SHIP gates) and section 12 round 7. This round is the PLAY gate only.

## Do (one thing: the PLAY gate passes and stays passing)
a. A node test that links the page's module graph with a stub document and a scripted player that finishes one bout and one
   ladder step through the page's own calls (a broken import or a crash fails it).
b. `node probe.mjs gate=play` and `gate=ship` print the two tables of plan section 7; P1 and L2 measured on the slice (boxing v
   BJJ, real ladder states from simulateLadder).
c. The play log on the page and a "copy log" button (so the owner can paste a bout to us).
d. The first-10-minutes script of plan section 3 as the opening: two fighters to pick, the first volley is one card, one line
   at the end on why the bout ended.
No rule or number changes beyond CARDFIX6B's list. Section "Round 7" in DESIGN_CARDGAME_SCOPE.md. Tag `card-r7`.

## Done
The PR body says READY FOR THE OWNER'S PLAY with `RESULT: node --test -> <pass line>` and the gate=play table. Claude plays it
by script and opens it; then the owner plays it. His words open round 8 (plan section 12).

## Prior research
CARDGAME_PREPROD_S540.md, DESIGN_CARDGAME_SCOPE.md (round 6/6b), TASK_CARDFIX6B.md.

## What would a human do?
Hand the player a build that opens and plays a whole bout in five minutes, even if balance is rough, and ask what felt wrong.

## Prefab check
None (our own prototype).

## Contract
OWNS: proto/cardgame/, ops/research/DESIGN_CARDGAME_SCOPE.md
RED_TEST: proto/cardgame (node --test)
REGRESSION: none (standalone)
VISUAL: the page opened by Claude and played by script
