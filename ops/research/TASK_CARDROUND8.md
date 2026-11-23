# TASK CARDROUND8 - card round 8: the guide (the owner did not understand the design) (S541)

Seat: ARENA (owner S539: card game written by the free seats; Claude coordinates). New Arena chat on the lite mirror
ICOON-Studio/FightCamp-Lean-lite, branch main (round 7 is merged: proto/cardgame/). Node + browser only; never Godot. Commit only
proto/cardgame/ and ops/research/DESIGN_CARDGAME_SCOPE.md. Keep every test; never delete or weaken one.

## Why (the owner's play, S541)
He played round 7 (docs/playtest/CARD_R7_OWNER_LOG_S541.md - read it whole) and said: **"i didnt understand the design , maybe a
guide would be useful"**. His log: lost bout 1 by knockout at Club with no warning; Cover up 7 of 12 answers; Step in/in/out/out/in
in 4 s (the ranges were not understood); one turn ended with no card (wind not understood); first answer took 41 s.
This round does ONE thing: he understands the game while he plays his first bout. The plan's round 8 (cards as data, pictures)
moves to round 9; balance stays round 10.

## Do
1. A GUIDED FIRST BOUT (plan section 3, "the first 10 minutes"): the first bout of a new career runs with a coach line at each
   new thing, the first time it happens, pointing at the element on screen (a highlight + one or two plain sentences, a "Got it"
   button, never more than one line on screen at once):
   his volley face up and what an answer is; WIND (what it is, the number, that it refills each turn, why a card is greyed);
   the RANGE strip KICK - PUNCH - CLINCH - GROUND (where you are, which cards work at each range, what Step in / Step out does and
   costs); laying cards and End turn; POINTS and HEALTH and the three ways to win (knockout, a points lead of N, a hold);
   the bell and the rounds. Lines are generated from the engine's numbers (no number typed in text).
2. The first bout's opponent is THE OTHER ART (plan section 3: "against the other art") at the softest club deck, so the first
   bout teaches the two arts' difference; it may still be lost, but not by a knockout before the guide's last line.
3. A LOW-HEALTH WARNING: when the incoming volley as laid would take your health to 0 (or under 25%), the answer table says so
   in red before you pick ("This volley knocks you out unless you answer").
4. A "How to play" button on every screen: one page, plain words, the rules in 10 lines max with a small picture of the range
   strip; the same lines as the guide.
5. A switch to turn the guide off; it is ON for a new career by default and off after the first bout.
6. Tests: the scripted player sees each guide line exactly once in the first bout (in order), none in bout 2; the warning shows
   when and only when the laid volley would KO. PLAY gate stays 6/6. Section "Round 8" in DESIGN_CARDGAME_SCOPE.md. Tag `card-r8`.

## Done
PR body: READY FOR THE OWNER'S PLAY, the RESULT lines (`node --test` pass line, gate=play table), and the guide's lines listed in
order. Claude plays it by script and by hand, then the owner plays it.

## Prior research
CARDGAME_PREPROD_S540.md sections 3 and 7; docs/playtest/CARD_R7_OWNER_LOG_S541.md; the owner's interview "Show me everything"
(every result previewed); CARDREF2 s4 (tutorials in the reference games).

## What would a human do?
A coach stands beside a new fighter in his first spar and says one thing at a time, at the moment it matters.

## Prefab check
None (our own prototype; the guide is text and CSS highlights).

## Feedback loops
None: a guide changes no rule or number. The first-bout opponent change is the only game change; say its win rate in the PR.

## Contract
OWNS: proto/cardgame/, ops/research/DESIGN_CARDGAME_SCOPE.md
RED_TEST: proto/cardgame (node --test)
REGRESSION: none (standalone)
VISUAL: the page opened by Claude and the first bout played with the guide on
