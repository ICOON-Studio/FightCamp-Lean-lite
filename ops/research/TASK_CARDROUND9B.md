# TASK CARDROUND9B - card round 9b: the model after two fresh critics (S545)

Seat: ARENA, a NEW chat on the lite mirror ICOON-Studio/FightCamp-Lean-lite, branch main, AFTER round 9 is merged there
(tag `card-r9`). Node + browser only; never Godot. Commit only proto/cardgame/, ops/research/CARDREAL_AUDIT.md (a new
section 9, nothing above it edited) and ops/research/DESIGN_CARDGAME_SCOPE.md. Kind: build (paper rows, engine, tests).
Discipline: the card game (boxer against jiu-jitsu fighter first).

## Why
Two fresh critics read the paper model of round 9 (`ops/research/CARDREAL_AUDIT.md` sections 4 and 7). Kalli scored it
real fight 6, depth 5, play 6 (`CRITIC_CARDREAL_BRIEF_KALLI.md`); Dola 9, 9, 9 (`CRITIC_CARDREAL_BRIEF_DOLA.md`). The bar
is 8 from every critic. Kalli's findings were checked against the paper by Claude; the ones below stand. The largest:
five of the walked bout's turning points are decided by "he had no card for it" (turns 6, 9, 12, 19, 21) - a draw, not
a choice - and the boxer has no road of his own to the ground (no knockdown).

## Do, in this order
1. PAPER FIRST: write section 9 of the audit, "Round 9b: the changed rows", with every row below in the 4c format
   (before and after of EACH man, how long, the other man's window), then the bout of section 7 re-walked turn by turn
   on the changed rows. Commit the paper before any engine code.
2. RED FIRST: one failing test per change below, committed red, then the build.

### The changes (each names where it comes from)
A. THE KNOCKDOWN (Kalli 1; new legal route into pair 3). A punch that lands for 6 or more and leaves him at 10 health
   or under puts him SEATED, the puncher STANDING in leg range. The boxer then chooses on his own turn: Punch down, Follow
   him down, or Walk away (the rows exist). If punches land on a downed man for 2 turns with nothing laid back, the
   referee stops the bout (TKO). The numbers 6, 10 and 2 are first guesses: report how often a bot bout has a knockdown
   and how many bouts end by this stoppage; do not tune.
B. THE BASIC DEFENCES ARE FLOOR MOVES PAID IN WIND (Kalli 2), always available, no card needed:
   Keep your base (against a pull, a trip or a sweep) 2 wind; Escape a hold 2 wind; Up-kick from your back 2 wind;
   Hold the legs (keep the guard closed as he stands or backs away) 2 wind. The CARDS of the same name become the
   stronger version (the Sprawl card also leaves him ON HIS KNEES; the Up-kick card does more damage; the Escape card
   also takes him one layer back). Rename the answer to a pull or a sweep "Keep your base" (Kalli, Dola: a sprawl stops a
   shot, not a sweep). Wind already limits a turn, so the price is the choice: defend, or keep the wind to attack.
C. POSTURE IN THE GUARD, ONE FLAG: UP or BROKEN (Kalli 3). A pull leaves the top man's posture BROKEN. Posture up is a
   move (part of a volley); the Triangle and the Armbar may answer it. Punches to the head from inside the guard need
   posture UP. The hip bump sweep needs posture UP; the scissor sweep works when it is BROKEN. Breaking a triangle or an
   armbar returns to the SAME kind of guard (Dola), posture as it was.
D. A PUNCH FROM INSIDE THE GUARD GIVES UP AN ARM (Kalli 4): that turn the Armbar or the Triangle may answer the punch
   itself. Say it on the punch's line in plain words.
E. PUNCHING DOWN FROM STANDING IN THE GUARD (pair 4) at FULL damage (Kalli 5), answered by Sweep or by an Armbar on the
   punching arm. Standing up in a CLOSED guard opens it, unless the man underneath pays Hold the legs. From pair 4 the
   boxer cannot Back away while the legs are held.
F. THE JIU-JITSU FIGHTER PUNCHES FROM ON TOP (Kalli 6): a rule, no card. From mount or side control, half damage,
   answered by Cover up or Escape. Mount then threatens two things (the punch and the hold).
G. THE BODY-LOCK TRIP (Kalli 9; audit row M20, moved up from "can wait"): a Tie up may be a collar tie or a body lock.
   From a body lock the jiu-jitsu fighter may Trip: he ends PAST THE GUARD (side control), the boxer PINNED; answered by
   Keep your base (he stays standing, the clinch holds). Pull guard stays, from the collar tie.
H. THE ROWS TO FIX (Kalli 7, Dola):
   - The tie must stand through one of the boxer's turns before a pull or a trip (no tie-and-pull in one volley); the
     boxer may answer a Tie up with a Frame (a floor move, 1 wind: the tie fails, both stay at PUNCH) or by hitting him
     on the way in, as today.
   - A failed pull drops the tie.
   - Recover guard: from mount to HALF guard; from side control to guard. (Section 7 turn 20 already says half guard;
     row 4c says guard. The row is wrong.)
   - Get up in open space stays "ends at KICK" (a technical stand-up moves away from him; Kalli's "punching range" is
     NOT taken), with the one punch as he rises when the standing man is in leg range, as written.
I. THE REFEREE (Kalli 8, Dola): the grounded man hears "get up" after ONE empty turn and is stood up after the SECOND;
   a clinch held through a whole exchange with nothing laid is broken to PUNCH; a warning always comes before a point
   off; a pull is an attempt and never counts toward timidity (a Sit down with no tie still does); standing in the
   guard (pair 4) counts as the ground for the stand-up, and that stand-up leaves the boxer STANDING in leg range and
   the other man still down (so the boxer does not skip the up-kick for free).
J. NOT TAKEN: the kneeling in-between state as a picture (Dola; the screen is round 10); pairs 7 and 8 stay in the
   engine and get no word on the first screen (Kalli).

3. THE WALKED BOUT of section 9 replayed as a scripted test, asserting where both men are after each turn. The round 9
   walked-bout test is REWRITTEN to it and listed (old assertion -> new one); no test is deleted.
4. EVERY NEW MOVE NAMES ITS REAL ROW (`real:` = the section 9 row); the round 9 gate test covers them.
5. STATE WORDS (`ui-text.mjs`): posture said in the position line ("He: on his knees in your guard, head pulled down");
   the floor moves listed with their wind price; a move that cannot be played from here says why in words.

## Measure and print in the PR (the three numbers Kalli asked for)
- Over 40 bot bouts each way: the bout's turning points decided by a MISSING answer (a legal answer existed, he could not
  afford or did not hold it). Target: none decided by a missing CARD; "could not afford the wind" is allowed and counted
  apart.
- The share of the jiu-jitsu fighter's grounded turns where the boxer's three choices (Follow him down, Walk away, Punch
  down) differ by under 10% in the pilot's value: the choice is real when no one of them wins every time. Print the
  share each is picked.
- Bout length in turns, and the share of turns each art spends down.

## Feedback loops
- Floor defences cost wind -> less wind to attack -> the other man attacks more -> more defences to pay: capped by wind
  refill per turn (unchanged) and by the referee (a man who only defends on the ground for 2 turns is stopped or stood
  up). Print the share of turns where a fighter ends at 0 wind; STOP and report if it passes 25%.
- Knockdown -> punches down -> lower health -> another knockdown: capped by the referee's stoppage (2 turns of punches
  with nothing back). Print knockdowns per bout; STOP and report if the boxer wins over 70% by this route.
- Hold the legs <-> Stand up in the guard: each side pays 2 wind a turn; the referee's idle rule does not see it as
  idle. Cap: Hold the legs may be paid at most 2 turns in a row, then the guard opens. Test it with two bots that only
  do this.
- Frame <-> Tie up: 1 wind against a card; no cap needed (the tie costs a card). Print how often a bout has over 6 ties.
- ONE-REP TRIAL FIRST: the re-walked bout green, then ONE bot bout each way printed turn by turn in the PR and read by
  you for any turn a referee would not recognise, BEFORE the 40-bout measure.

## Balance
Not tuned (round 11). Report the win rate both ways before and after; outside 30-70, name the ONE number you would
move and why, and move nothing else.

## Done
PR body: READY FOR CLAUDE'S PLAY; the RESULT lines (`node --test` pass line, the play gate table 6 of 6); the table of
rewritten tests; section 9's rows; the three measures; the two printed bot bouts; the win rates; what you left out and
why. Tag `card-r9b`. Claude then plays BOTH arts by hand and sends the paper's section 9 to two fresh critics.

## Prior research
`ops/research/CARDREAL_AUDIT.md` (sections 4 and 7: the model this round changes), `CRITIC_CARDREAL_BRIEF_KALLI.md` and
`CRITIC_CARDREAL_BRIEF_DOLA.md` (the two critics, whole), `CARDREAL1_JOHN_BRIEF_JOHN.md` (the memo; row M20 the trip),
`TASK_CARDROUND9.md` (the round this builds on), `CARD_R8_OWNER_PLAY_S543.md` (his words).

## What would a human do?
A jiu-jitsu coach and a boxing coach watch the same bot bout. Neither stops it to say "he would have defended that" or
"he would have hit him there". Build until neither does.

## Prefab check
GrappleMap (public domain) in `proto/grapplemap`: its names for the posture-broken guard, half guard and side control.

## Contract
OWNS: proto/cardgame/, ops/research/CARDREAL_AUDIT.md, ops/research/DESIGN_CARDGAME_SCOPE.md
RED_TEST: proto/cardgame (node --test: one red test per change A-I before the build)
REGRESSION: none (standalone)
VISUAL: Claude plays both arts by hand on the page
