# S308 - Deeper fight: read the clue, make the call, see it work (plan for approval)

Miro (frames 6-11): https://miro.com/app/board/uXjVEV03QWA=/?moveToWidget=3458764688898155785

## His ask (S308, verbatim)
"there need to be clues to the player for what his best options or tactic should be to call out at the end of the round, and it
has to make sense so his choices are making a difference in the fight . there is need to be a timer during rounds and options for
the player to choose from ,like real coaches choose in a real fight . also the rounds should be 3 minutes and callouts from corner
every 25-30 seconds that might impact the outcome . how do we make the game engine deeper while keeping everything easy to
implement so the player understands"

## Why today's calls feel empty (Lean code read S308)
- BoutRules.play_round settles a whole round with one roll; the corner call adds a flat +0.3..+1.0 on a 27-point spread, and the
  call does not depend on what the opponent is doing. No clue can point to a best call because there is none.
- A round is 40 s of 3D (RoundScript.SECONDS); there is no clock and nothing to do while it plays.

## The design
1. A round = 3:00 on the clock = six 30-second exchanges, each settled on its own. Five shouts a round (0:30 .. 2:30); the fight
   slows while the shout bar is up (6 s); no pick = say nothing.
2. The opponent fights one of six ways at a time (Pressing, Boxing at range, Waiting to counter, Loading up, Tiring, Hurt) and
   switches when his coach shouts (his style sets the mix). Each way has a clue line on screen, one best call and one wrong call.
   Two more rows for her own state (tired -> Breathe; hurt -> Tie him up).
3. Eight real calls (Jab and move, Go to the body, Make him lead, Hands up move your head, Let your hands go, Breathe pick your
   shots, Tie him up, Go get him). Each shows Expect / Costs / Needs, an edge chip (Big edge / Small edge / Risky) and a "She can"
   chip (Good / OK / Poor, from the stat it needs).
4. Exchange = paper strength + call fit (best big, wrong negative) x she can do it x she hears it (coachability; the first two
   shouts a round land fully, each extra one half - J55: real corners get two instructions through) + energy + a little luck.
   Most exchanges won takes the round 10-9.
5. Corner minute: one plan for the whole round (bigger effect) + one fix for a habit. Fight IQ: a clever fighter finds the answer
   herself after one exchange. Film study: his clues show one exchange earlier and the card names his habits.
6. Feedback: a tick or cross after each exchange ("The jab kept him off: exchange won 4-1"); the round card counts calls that worked.

Balance targets (harness): good calls turn a 50/50 fight into ~65/35; no call beats a fighter 10 points better; wrong calls lose a
close fight.

## Build order
1. Rules module + tests (exchanges, opponent modes, fit table, execution, hearing). 2. Balance harness. 3. Words (Kalli: clue,
shout, tick/cross lines). 4. Screen: clock, punch count, energy bars, clue line, shout bar, corner card with Expect lines.
5. 3D plays each exchange. 6. Update 9 .exe + a film of a whole fight.

## Needs his call
- Build this plan?
- Round speed: a full 3:00 watched (amateur bout ~11 min with corners), or the 3:00 clock at 2x (90 s a round) with 1x/2x/4x.
