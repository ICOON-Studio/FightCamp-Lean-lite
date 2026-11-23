# TASK CARDSCOPE6 - card round 6: one line, a two-art slice with a ladder and a training turn, playable in a browser (S539)

Seat: ARENA (owner S539: the card game is written by the free seats - Arena code, Dola/Kalli critics, Ludo art; Claude
coordinates). New Arena chat on the lite mirror; then a second fresh Arena chat code-checks the PR. Node + browser only.

## Why
Owner S539 "ok" to ops/research/CARDGAME_PLAN_S539.md (read it first, then OWNER_CARDGAME_INTERVIEW_S537.md): one prototype
line, a two-art vertical slice, the owner plays a private browser link every round, critics after his play.

## Do
1. Read round 5's result (DESIGN_CARDGAME_SCOPE.md round 5 section, proto/cardscope5/, NOTES_S538_PEER.md) and pick the
   grappling art for the slice: the one whose own mechanic changes the pilot's turn most (P6) and that the blind judge names
   best. Write the pick and the numbers.
2. ONE LINE: bring the cardscope5 engine (rules, cards, plan, the probe harness) into proto/cardgame/ as its rules, replacing
   Arena's rules-*.js; keep Arena's playable page (index.html, ui.js, ui-helpers.js) and rewire it to the engine. Two arts only
   (boxing + the pick). Remove the dead files from proto/cardgame/ (they stay in git history); keep proto/cardscope*/ as the record.
   No file over 500 lines.
3. The first run layer (JOHN_CARDGAME_MARKET_S538_JOHN.md section 5, items 1 and 3): a LADDER with visible rungs (club, area,
   national, title shot, title defences 1-3), a rank number, a loss costs a rung; and a TRAINING TURN between bouts (pick 1 of
   4: each adds or upgrades one card, an energy cost, a failure chance printed on the card, no stat decay). "Show me everything"
   (owner S537): previews of damage and results on every card.
4. Probe: the round-5 core bars (P1-P6, P10, D1) for the two arts, unchanged, plus: (L1) a run of the ladder by the pilot takes
   20-40 minutes and wins the title in 30-70 of 100 runs; (L2) every training option is the right pick in at least one state and
   none in more than 6 of 10. Bars written before the run.
5. Tag the commit `card-r6` (git tag, push the tag). Write the round-6 section of DESIGN_CARDGAME_SCOPE.md: form, table, picks,
   cuts. If the core bars pass, say "READY FOR THE OWNER'S PLAY" in the report; Claude publishes the play link. Then queue
   critics only AFTER Claude says the owner played (do not queue them yourself).

## Prior research
CARDGAME_PLAN_S539.md, OWNER_CARDGAME_INTERVIEW_S537.md, JOHN_CARDGAME_MARKET_S538_JOHN.md (Dola's copy is unverified ideas),
DESIGN_CARDGAME_SCOPE.md, CARDPROTO3_CRITIC_ARENA.md (bugs found in Arena's rules: the clinch smother deleted the same call, the
repeat-card counter backwards - do not carry them).

## What would a human do?
Make one fight fun with two styles, give it a ladder to climb, put it in front of the boss.

## Prefab check
None.

## Contract
OWNS: proto/cardgame/, ops/research/DESIGN_CARDGAME_SCOPE.md
RED_TEST: proto/cardgame/engine.test.mjs (node --test)
REGRESSION: none (standalone)
VISUAL: the page opened at 1920x1080 and at phone width via tools/render_mockup.py, stills in ops/previews/card_r6/, opened and checked

## Rules
node only; long output to a file. Nothing opens on the owner's monitors (render stills headless only). Commit only your paths,
push, report in two lines, stop. End with `python ops/Tools/idle_guard.py ok CARDSCOPE6-done`.
