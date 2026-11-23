# TASK CARDROUND9 - card round 9: the engine on the real-fight position model (S544)

Seat: ARENA (owner S539: the card game is written by the free seats; Claude coordinates). New Arena chat on the lite
mirror ICOON-Studio/FightCamp-Lean-lite, branch main (round 8 is merged: proto/cardgame/). Node + browser only; never
Godot. Commit only proto/cardgame/ and ops/research/DESIGN_CARDGAME_SCOPE.md. Kind: build (engine + tests + state words).
Discipline: the card game (boxer against jiu-jitsu fighter first).

## Why (the owner's play of round 8, S543)
"this is has not been given enough thought , how the boxer jabs when he is in the ground , its like very quickly drafted
without any attention to how a a real fight is done." Traced: the bout has ONE shared position, so `Let him up` puts
BOTH men on their feet and a jab and a cross follow in the same volley. We researched real bouts
(`ops/research/CARDREAL1_JOHN_BRIEF_JOHN.md`) and audited every card and rule (`ops/research/CARDREAL_AUDIT.md`: REAL 60,
WRONG 18, MISSING-LINK 5). **Read the audit whole before any code: its section 4 is the spec of this round**, section 2
names every row to fix with its smallest rule change, section 5 names the tests that must change, section 7 is one
whole bout walked turn by turn.

## Do, in this order
1. RED FIRST. Add the owner's case as a test that fails on today's engine: the boxer is in the jiu-jitsu fighter's
   guard and stands up - the jiu-jitsu fighter is STILL ON HIS BACK, and no jab or cross can be laid at him in that
   volley. Commit it red, then build.
2. THE STATE (audit 4a, 4b): each fighter has an OWN position (standing, seated, on his back, on his knees, in guard on
   top, guard underneath, past the guard, pinned) and a JOIN (apart at KICK or PUNCH; with one man down: in or out of
   leg range; clinch and who holds the tie; entangled). Only the eight legal pairs exist; the engine refuses the rest.
   `stand()` and `ground()` no longer move both men: every change names whose position moves.
3. THE MOVES (audit 4c, row by row): Tie up (new BJJ card), Step out of the clinch (answerable), Pull guard (needs his
   tie; answerable by Sprawl -> he ends seated), Sit down (no tie), Follow him down, Walk away, Punch down (the cross,
   half damage), Get up (ends his volley; one punch as he rises if the standing man is in leg range), Stand up in the
   guard (ends his volley; Sweep or an arm attack answers), Back away (Up-kick or Sweep answers), Up-kick (new BJJ
   card; only at a STANDING man in leg range), ground punches from on top (hook and cross: weak in the guard, full past
   it), Recover guard, Escape and Break free that STAY on the ground (the holder one layer back).
   "Ends his volley" = nothing more can be laid after it that turn. Steps that leave contact, go to the ground or rise
   from it are answerable like cards.
4. THE RULE SET (audit 4d, unified MMA): the referee stands up a ground pair where nobody works; stands up the grounded
   man who will not engage, then a warning, then a point off (timidity); the bell ends the round and any hold.
5. THE OTHER FOUR ARTS keep working on the new state with the audit's small fixes only: the three judo throws land at
   side control (`to: 2`), Hold-down only past the guard, a stood grip or tie makes the answer 1 wind dearer instead of
   impossible (also the sambo throw behind his punch), the karate man is held by a grip like anyone, a pin that runs
   out ends in the referee's stand-up apart at KICK. Rows marked "can wait" (the fence, the turtle, the knees after a
   stuffed shot) stay out. The points-lead ending STAYS (the owner's call, not this round).
6. EVERY MOVE NAMES ITS REAL ROW: each card and step in the data carries `real: "<audit 4c row or memo section>"`, and a
   test fails if one has none. This is the card game's REAL-FIGHT gate from now on.
7. STATE IN PLAIN FIGHT WORDS, no codes: `ui-text.mjs` says where EACH man is ("You: standing, out of reach of his
   feet. He: on his back.") and names each button by the state (Step in over a grounded man reads "Follow him down",
   Step out reads "Walk away"; Pull guard reads "Sit down" with no tie). Replace the one-switch strip by these two
   lines; no new screen layout in this round (the screen is round 10, after two fresh critics on the model).
   The guide's lines that speak of the strip are rewritten to match, still generated from the engine.
8. THE PILOT AND THE LADDER: `plan.mjs` values a place by the new pair, `career.mjs` reads training states from the new
   positions (re-measure; say the numbers before and after in the PR).

## Tests (never delete one; a test whose MEANING the audit calls wrong is REWRITTEN to the real meaning and listed)
- The seven tests of audit section 5, each rewritten to the new meaning; the PR lists each: old assertion -> new one.
- New: every row of 4c (before and after of EACH man, the answer window); every legal pair reachable; every illegal
  pair refused; the timidity cap (sit down three times in a round = a point off); the bell ends a hold.
- THE WALKED BOUT: audit section 7 replayed as a scripted test, turn by turn, asserting where both men are after each
  turn exactly as the audit writes it. If the engine cannot follow a turn, the engine is wrong, not the bout - unless
  you can name the memo row that says otherwise (then say so in the PR; do not bend the test silently).
- The PLAY gate stays 6 of 6 (bots finish bouts in both pairings' directions); `node --test` all green.

## Feedback loops
- Sit down -> the boxer walks away -> the referee stands him up -> the start again, at no cost: capped by the timidity
  count (warning the second time in a round, a point off the third). Test it with a bot that only sits.
- Pull guard -> stand out (two moves) -> get up -> pull again: each pull costs a Tie up card and wind, each stand-out
  gives two answer windows; print how often a bot bout repeats it and STOP if any bout passes 6 pulls.
- On top, lay nothing -> stand-up -> again: today's one-turn stand-up stays.
- Getting up ends the volley -> the man down falls behind in tempo -> more time down. Print the share of turns each art
  spends down; STOP and report if either art spends over 60% of a bout on the ground against the other.
- ONE-REP TRIAL FIRST: the walked bout test green, then ONE bot bout each way printed turn by turn in the PR, read by
  you for any turn a referee would not recognise, BEFORE the 6-bout gate.

## Balance
Not tuned in this round (that is round 11). Report the boxer v jiu-jitsu win rate both ways after the change; if it is
outside 30-70, name the one number you would move and why, and move nothing else.

## Done
PR body: READY FOR CLAUDE'S PLAY; the RESULT lines (`node --test` pass line, the play gate table); the table of
rewritten tests; the real-row table (move -> audit row); the two printed bot bouts; the win rates; what you left out.
Tag `card-r9`. Claude then plays BOTH arts by hand and writes down each move that does not look like a fight, before the
owner is asked.

## Prior research
`ops/research/CARDREAL_AUDIT.md` (the spec), `ops/research/CARDREAL1_JOHN_BRIEF_JOHN.md` (the memo, with the source
check at its top), `ops/research/CARDREAL_SCOPE_S543.md`, `ops/research/CARD_R8_OWNER_PLAY_S543.md` (his words; its seven
screen fixes are round 10, not this round), `proto/grapplemap/README.md` (public-domain position names).

## What would a human do?
A jiu-jitsu coach watching the bot bout stops it at the first turn where a body is somewhere it could not be. Build
until the coach never stops it.

## Prefab check
GrappleMap (public domain) is in `proto/grapplemap`: use its position names where they fit.

## Contract
OWNS: proto/cardgame/, ops/research/DESIGN_CARDGAME_SCOPE.md
RED_TEST: proto/cardgame (node --test: the owner's case, red on main before the build)
REGRESSION: none (standalone)
VISUAL: Claude plays both arts by hand on the page
