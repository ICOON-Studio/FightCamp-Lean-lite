# Card round 8 (the guide) - Claude's by-hand play, S542 (2026-11-23)

Played in the built-in browser at http://127.0.0.1:8799/ (proto/cardgame on main, after PR 449 merged by diff): the boxer,
training skipped, the first bout against the BJJ novice, the guide on. Arena had played it by script only (no browser there).

## What works
- The six coach lines fire in the brief's order, each ringing its element (his volley, wind, the strip, the hand, the
  score strip; the bell line was not reached in this short play). "Got it" is the only live control while a line is up.
- node --test 47/47 and gate=play PASS 6/6 on main.

## Fixed in S542 (fb893e2bf)
- The BJJ novice pulls guard in volley 1, so the boxer's first turn is on the ground: all five cards in the hand were
  disabled but drawn exactly like live cards (opacity 1, pointer cursor, no reason). Now a dead card is greyed and says
  why: "Works at PUNCH range - the bout is not there now." / "An answer: you lay it against his volley, not in your own
  turn." / "Costs N wind - you have M."
- The strip said "on top, rung 0" (rung is also the career ladder's word). Now "you are on top" / "you are underneath".

## For round 9 (not fixed here - the free seat writes the code)
1. NO LINE FOR THE GROUND. The first thing a new boxer meets is being pulled to the ground with one live button, "Let him
   up - 2 wind", that no line explains. The range line talks about Step in / Step out, which are not on screen there. Ask:
   a coach line the first time the bout goes to the ground, saying what the player can do from there in his art.
2. THE STRIP AND THE HAND DISAGREE. After "Let him up" the strip still lights GROUND while the punches become live: the
   hand reads the bout as it will stand after the laid steps (S.pj), the strip as it stands now. Ask: the strip shows both
   ("GROUND now -> PUNCH after your volley") or the laid steps show as a row "Your volley so far".
3. A CARD DID LESS THAN PRINTED WITH NO REASON. A Cross printed "4 damage + 1 point" took 2 health and scored 0 against a
   man pulling guard. The page says "Cards resolve exactly as previewed unless an answer stops them" - the log must say
   what cut it (guard, range, an answer).
4. FOUR COACH CARDS IN THE FIRST TEN SECONDS (his volley, then wind + strip + hand back to back before the first card is
   laid). Ask: one line per player action, the next line only after he has acted.
5. THE TRAINING SCREEN HAS NO LINE AT ALL and comes before the first bout.
6. Arena's own table: the BJJ side's first bout is hard for a careful player (24.5% for "a reader", 0% for the page's
   scripted line) against 57.8% for the boxer. The first bout should be winnable by a player who follows the coach, in
   either art.
