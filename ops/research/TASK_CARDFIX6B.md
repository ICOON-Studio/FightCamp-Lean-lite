# TASK CARDFIX6B - card round 6b: make the page play, then the failing bars (S540)

Seat: ARENA (owner S539: card game written by the free seats; Claude coordinates). New Arena chat on the lite mirror, branch main
(round 6 is merged there: proto/cardgame/). Node + browser only; never Godot. Commit only proto/cardgame/ and
ops/research/DESIGN_CARDGAME_SCOPE.md. Keep every test; never delete or weaken one.

## Why
Round 6 (CARDSCOPE6, merged 9815bfe8f) ported the engine into one line with boxing + BJJ, a ladder and a training turn. A fresh
Arena code check said DO NOT MERGE AS IS, and its measured bars fail. This round fixes, in this order:

## Do
1. THE PAGE MUST LOAD AND PLAY (blocking): `proto/cardgame/ui.js` line 2 imports `actions` from `./engine.mjs`, which does not
   export it (it is in plan.mjs) - the module fails to link and nothing renders. Also the card text for the two engine answers
   `@cover` and `@break` (engine.mjs :46-48, not keys of CARDS) crashes `cardText`/`names` in ui.js. Add a node test that IMPORTS
   ui.js's pure helpers (or a jsdom-free smoke: link the module graph with a stub `document`) so a broken import fails CI.
   Then play a whole bout and a ladder step in the page by script and say so.
2. THE TITLE IS WON AT THE TITLE SHOT: career.mjs simulateLadder and ui.js finishBout award the title only on a win at the last
   rung ("Title defence 3" index) check made before resultCareer - a win at "Title shot" must make your boxer champion; the
   defences are defences. Fix both, test it.
3. THE LADDER MUST GET HARDER (L1: 100/100 titles, bar 30-70): `rivalFighter(career, rung)` ignores the rung. Rivals by rung (deck
   upgrades / better picks per rung, real-world: a national title fighter is far better than a club novice). Re-run L1.
4. TRAINING UPGRADES: `train` adds a new stronger copy on a second upgrade of the same card instead of upgrading it (deck grows).
   Upgrade in place; one card in, one card out. L2 must measure real ladder states (from simulateLadder), not the 4 hand-made
   states repeated to 10.
5. The core bars that fail (DESIGN_CARDGAME_SCOPE.md round 6 table): P2 (KO / points-lead / pin shares under 15%, blind-points
   -0.8), P4 (averages 56.5 / 43.5, bar 47-53), P5 (holds end 31.3% of ground bouts, bar 15-30; 17% of holds finish, bar 20-80),
   boxing P6 (49.3%, bar >50). Size, re-run, write every number. P1 must be measured on boxing v BJJ (the slice), not wrestling.
6. Round-6b section in DESIGN_CARDGAME_SCOPE.md (form, table, picks, cuts). Tag `card-r6b`. If the page plays and the core bars
   pass, write READY FOR THE OWNER'S PLAY in the PR body.

## Prior research
DESIGN_CARDGAME_SCOPE.md rounds 5-6, CARDGAME_PLAN_S539.md, OWNER_CARDGAME_INTERVIEW_S537.md, CARDPROTO3_CRITIC_ARENA.md.

## What would a human do?
Open the page first. A game the owner cannot open is not a round.

## Prefab check
None.

## Contract
OWNS: proto/cardgame/, ops/research/DESIGN_CARDGAME_SCOPE.md
RED_TEST: proto/cardgame/engine.test.mjs (node --test)
REGRESSION: proto/cardgame-legacy/rules.test.mjs
VISUAL: none (Claude renders the page and checks it)
