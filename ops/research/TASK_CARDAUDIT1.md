# CARDAUDIT1 - every card and step of the card game against how a real fight goes (S544)

Kind: research. Model: claude-opus-5-5 (console tab). Commit with a pathspec (`git commit -m "..." -- <your file>`), do
not push; touch only your file. RESEARCH ONLY - no code changes in `proto/cardgame`, no Godot. Estimate: 60 minutes.
Discipline: the card game (its own prototype, boxer against jiu-jitsu fighter first).

## Why
The owner played round 8 (`ops/research/CARD_R8_OWNER_PLAY_S543.md`): "this is has not been given enough thought , how the
boxer jabs when he is in the ground , its like very quickly drafted without any attention to how a a real fight is done."
The scope is `ops/research/CARDREAL_SCOPE_S543.md`; this task is its phase 2. Phase 1 is done:
`ops/research/CARDREAL1_JOHN_BRIEF_JOHN.md` (John's memo, with Claude's source check at the top - read that note first).

## Your job
1. Read the engine as it is: `proto/cardgame/engine.mjs` (313 lines), `cards.mjs` (114), `plan.mjs`, `career.mjs`,
   `guide.mjs`, `ui-text.mjs`. Write down the position model the code really has (the one shared switch, its values, which
   card or step changes it, for whom), with file and line for each statement.
2. THE AUDIT TABLE - one row for EVERY card in `cards.mjs` and EVERY step or rule in `engine.mjs` that changes position,
   allows a strike, or ends an exchange. Columns: card or step (file:line) | what the code does (both fighters, before and
   after) | the row of John's memo it should follow (section number, e.g. 1c step 4) | verdict REAL / WRONG / MISSING-LINK |
   for WRONG: what a fight does instead and the smallest rule change that makes it true.
   - REAL = a referee, a coach and John's memo would all recognise the move as written.
   - WRONG = the code lets something happen that a fight does not (the owner's example: the man on top stands up and the
     man on his back is on his feet in the same instant, and is hit by a jab and cross).
   - Then a second list, MISSING: real options from the memo that the game lacks (refusing to follow a grappler down, the
     referee's stand-up, the up-kick, sweeping a fighter who is standing up, the wall walk, a pull needs a grip first...).
     For each: is it needed for boxer against jiu-jitsu fighter to look like a fight, or can it wait?
3. THE NEW POSITION MODEL, on paper only. Each fighter has an OWN position (standing / seated / on the back / on the knees
   / in guard on top / in guard on the bottom / past the guard), plus what joins them (apart, clinch, on the fence). Write:
   - the legal pairs of positions (which combinations exist; which do not);
   - for each move, the before and after of EACH fighter, how many turns it takes, and what the other fighter may do in
     that window (this is where getting up becomes a move that costs a turn and can be punished);
   - the rule set, taken from the memo's "one honest mixed rule set" (unified MMA): which strikes are legal on a grounded
     fighter, the referee's stand-up, the timidity rule. Where the memo marks a rule CHECK, say which reading you took.
   - which of today's 47 engine tests (`engine.test.mjs`) the new model breaks, by name, and why each should break.
4. A SIZE CHECK: count today's cards and steps, and the new model's. If the new model needs more than about one and a
   half times today's cards for the boxer against jiu-jitsu fighter pairing, say what to leave out and why - the owner
   could not read the first screen at today's size.
5. A FIRST-BOUT WALK: write one whole bout, boxer against jiu-jitsu fighter, as a list of turns on the new model, in
   plain fight words (no B0 / T1 codes). After each turn: where each man is. Mark any turn where you would ask "how is
   that possible?". There should be none; if there is one, the model is not finished.

## Deliverable
ONE new file `ops/research/CARDREAL_AUDIT.md`: the model as coded, the audit table, the MISSING list, the new position
model, the size check, the walked bout, then the list of files you opened. Finish by saying DONE with the counts
(REAL / WRONG / MISSING).

## Feedback loops
None: a read-only audit; nothing in the game or the prototype changes. (For the model you write on paper: name any move
that returns both fighters to the state it started from at no cost - a free loop a bot would spin in - and its cap.)

## Prior research
`ops/research/CARDREAL1_JOHN_BRIEF_JOHN.md` (phase 1, the sequences and rule sets), `ops/research/CARDREAL_SCOPE_S543.md`,
`ops/research/CARD_R8_OWNER_PLAY_S543.md` and `CARD_R8_CLAUDE_PLAY_S542.md`, `ops/research/DESIGN_CARDGAME_SCOPE.md` (the
six arts), `ops/research/topics/ground.md` and `topics/clinch.md` (the canonical pages), `proto/grapplemap/README.md` (the
public-domain GrappleMap slice: real ground positions and the transitions between them).

## What would a human do?
A jiu-jitsu coach reads each card and says where both bodies are before and after. If the coach would stop the drill and
say "no, he is still on his back", the row is WRONG.

## Prefab check
GrappleMap (public domain) is already in `proto/grapplemap`: use its position names and transitions where they fit,
instead of inventing ground positions.

## Contract
OWNS: ops/research/CARDREAL_AUDIT.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: none
