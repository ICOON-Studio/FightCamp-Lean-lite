# CARDREAL_SCOPE_S543 - the card game follows how a real fight goes, before anything else is added

Source: the owner's play of round 8 (`CARD_R8_OWNER_PLAY_S543.md`). His words: "this is has not been given enough thought ,
how the boxer jabs when he is in the ground , its like very quickly drafted without any attention to how a a real fight is
done." Checked in the code by the coordinator (`proto/cardgame/engine.mjs`).

## The finding (a METHOD finding)
- The bout's position is ONE shared switch for both fighters: kick / punch / clinch / ground, and on the ground who is on
  top and a number. A move changes it for both at once. So the man on top "stands up" and the man on his back is on his
  feet in the same instant, for free, and is punched in the same volley.
- Eight rounds were gated on tests that the rules agree with themselves (47 of 47) and on whether a bout can be finished
  (play gate 6 of 6). Nothing ever asked "is this how it happens in a fight?", move by move.
- The same gap is why the first screen could not be read: the cards speak in the switch's codes (B0, T1), not in what the
  two bodies are doing.

## The rule until this is done
No round 9 feature, screen or balance work on the card game. The next card work is the three phases below, in order.

## The plan
| Phase | What | Who | Done when |
|---|---|---|---|
| 1. How it really goes | For the six arts of the card scope, every change of position between two fighters as it happens in a real bout: who is where before and after (each fighter separately: standing, seated, on the back, on the knees, on top), how long it takes, what the other fighter can do meanwhile, and what the rules of the bout allow (strikes on a grounded opponent, the referee's stand-up, pulling guard). Starts with boxer against jiu-jitsu fighter. Sources named; clips where they exist; the public-domain GrappleMap for the ground. | John (research), with GrappleMap (`proto/grapplemap`) | `ops/research/CARDREAL1_JOHN_BRIEF_JOHN.md`, sources checked by Claude |
| 2. The audit | Every card and step in `engine.mjs` / `cards.mjs` against phase 1, one row each: REAL / WRONG (what a fight does instead) / MISSING (a real option the game lacks). The position model rewritten on paper so each fighter has an own position and getting up is a move that takes a turn and can be punished. | a code-reading worker (console tab) + one critic who has not seen the game | `ops/research/CARDREAL_AUDIT.md`, every WRONG row with its fix |
| 3. Round 9 | The engine on the new position model, the WRONG rows fixed, then the seven screen fixes of `CARD_R8_OWNER_PLAY_S543.md` in plain fight words. Claude plays BOTH arts by hand before the owner is asked, and writes down each move that does not look like a fight. | Arena (code), Claude (plays) | the owner plays a bout and nothing in it makes him ask how that is possible |

Card-game gate from now on: beside the tests and the play gate, a REAL-FIGHT check - each new or changed move names the
row of phase 1 it follows.
