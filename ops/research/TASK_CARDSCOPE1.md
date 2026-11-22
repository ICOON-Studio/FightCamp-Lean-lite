# TASK CARDSCOPE1 - the whole scope of the card game, designed to 10/10 fun before more building (S537)

Model: claude-fable-5-2 (Agent SDK, API credit). Discipline: boxing (demo). RESEARCH + DESIGN + PROBE: no edits to proto/cardgame.
OWNER S537: "how can we use the best model to map the whole scope of the card game and build an 10/10 fun game ?" -> the plan
(scope study, probe with bots of different skill, two critics on the plan, then phased build) -> "yes go ahead with the scope
study". METHOD (CLAUDE.md item 8): rounds 1-4 patched critic lists and stalled at 4-5/10 (CARDPROTO3_CRITIC_SDK.md 5/5/5:
one no-read combo wins 78%, 81% of bouts end 5-0, Predict is a trap, five systems change nothing). The patch loop is stopped;
no new patch round until this scope is approved.

**OWNER S537, widening it: "it can be any variation of a card game as long it can reach 10/10".** The form is open: a
deckbuilder, a poker/Balatro-like hand game, a lane/tactics card game, a bluffing duel, a roguelike run, or a mix. Compare at
least three different forms on paper (step 2b) and pick the one most likely to reach 10/10 fun for a boxing bout inside a gym
manager; the current prototype's form gets no preference.

## Read first
proto/cardgame/README.md and its rules-*.js (what exists), ops/research/CARDPROTO*_CRITIC_*.md (every critic so far),
ops/research/JOHN_CARDGAMES_RESEARCH_JOHN.md, TASK_CARDPROTO1.md (the original intent), ops/research/CRITIC_PACK.md (the
game the card game lives in: a boxing gym manager; the cards are how a bout is fought), memory: names only in headers, game
words not jargon, only actionable info on screen.

## Do
1. **What makes the best ones fun** - Slay the Spire, Balatro, Inscryption, Monster Train, Hand of Fate, Punch Club, plus any
   boxing/fight card or tactics game you find. For each: the decision per turn, how information is hidden/revealed, how a
   skilled player beats a weak one, comebacks, variance, the run/meta loop, what keeps a session going. Our own words and
   numbers only (no copied text/art). REA on installed games only if the owner names one.
2b. **Three forms compared** (in the scope page, before the chosen design): for each form, one bout described in plain words,
   what the player decides, where skill shows, its risk; then the pick and why. The probe (step 4) may greybox the top two.
2. **The scope page** `ops/research/DESIGN_CARDGAME_SCOPE.md`: the WHOLE game, plain words:
   - the core decision each exchange and why it is hard (a real read of the opponent, not a fixed best line);
   - how the boxer's stats, style, camp and corner (from the manager game) feed the deck - the link to the rest of FightCamp;
   - information: what the player sees of the opponent (tells, film, corner reads) and how reading pays;
   - momentum, damage, knockdowns, the scorecard: how close fights and comebacks happen (target: most bouts decided late);
   - the run/meta: a ladder of bouts, one deck carried, picks after wins, what grows and what is lost;
   - every card/system with what it changes - anything that changes nothing is cut;
   - what to KEEP from proto/cardgame and what to throw away (be blunt).
3. **Fun as numbers** (written BEFORE the probe, each a bar): e.g. a reading bot beats a fixed-line bot by 15+ points; a
   good bot beats a random bot by 30+; no single card/combo above 60% win when the opponent reads; 5-0 cards under 35% of
   bouts; at least 30% of bouts turn after round 3; every card picked by the good bot in some matchup and skipped in another;
   a run of 8 bouts has 3+ meaningful deck choices.
4. **Greybox probe** `proto/cardscope/` (new folder, plain node .mjs, its own tests): the core exchange + scoring as written in
   the scope, and 4 bots (random, fixed best line, greedy damage, reader using only public info). Measure every bar.
   `docs/CARDSCOPE1_PROBE.md`: bar table PASS/FAIL. One resize allowed; if it still fails, say which part of the design is
   the cause and change the design (FREE HAND), re-probe once.
5. **Critic brief** for two fresh critics on the SCOPE (not on the old prototype): `ops/research/CARDSCOPE1_CRITIC_KALLI.md`
   (CRITIC_PACK + the scope page + the probe table; DEPTH/PLAY/GENERAL /10; the list to reach 10/10) and queue it:
   `cd ops && python Tools/seat_queue.py add --seat kalli --brief research/CARDSCOPE1_CRITIC_KALLI.md`.
   The second critic is a later SDK job (not you).
6. **A phased build plan** at the end of the scope page: phases of ~1 job each, each with its test and its fun bar.

## Rules
No edits to proto/cardgame or the game (scripts/). Node only, never Godot. Scripts under 500 lines. `git add -- <new>` then
`git commit -m ... -- <your paths>` with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, pull --no-rebase
--no-edit, push. Report in two lines: the probe verdict and the one sentence that makes the design fun. Stop.

## Prior research / What would a human do / Prefab check
Above. A designer plays the best games in the genre, writes what the player decides and why it is hard, then proves it with
bots before anyone builds art. Prefab: none (rules are ours).
