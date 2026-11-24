# CARDBOX_SCOPE_S549 - the card game is tested as boxer v boxer first; arts are mixed only when every art is in

Source: the owner's play of round 9b on 2026-11-24, playing the jiu-jitsu fighter against the boxer, standing at
punching range with five cards he could not lay. His words:

> "THE CARD GAME DOESNT MAKE SENSE. If the fight is MMA bjj fighter has no strikes . tO MAKE IT bETTER BREAKDOWN A real
> mma fight and make it workwith card logic. the real test should be a boxer vs boxer , donot mix classes untill all arts
> cards are ingame."

## The finding (a METHOD finding)
1. The test pairing was wrong. Rounds 7 to 9b were all gated on boxing against jiu-jitsu. That is an MMA bout between
   two men who each know one art: the jiu-jitsu man has no strike on his feet, the boxer has nothing on the floor. Every
   round patched that mismatch (sit down, Frame, Keep your base, the up-kick) instead of asking whether ONE art plays
   as its own sport.
2. Boxer against boxer was never looked at. Measured today (`node proto/cardgame/mirror.mjs`, 400 bot bouts):

   | What | Measured | A real boxing bout |
   |---|---|---|
   | How it ends | knockout 400 of 400 | most bouts go to the cards |
   | The man who goes first | wins 30.5% | no such edge |
   | Combinations (the boxer's "one rule") | 0.02 a bout | the centre of the sport |
   | Body hook | 0.10 a bout | a tenth to a third of punches |
   | Where the turns are | 81% at punching range, 14% long | range is fought for all night |
   | Decisions a bout | 67.9 (the page's bar is 22.5-45) | - |
   | Sprawl, Escape (3 of 15 cards) | never used | not boxing |
   | Health left at the end | 1.7 of 42 a man | - |

   So the one pairing the game could have got right first is a race to zero that the second man wins.

## The rule until this is done
- No work on the mixed boxing v jiu-jitsu game: no slice, no balance, no critic round. Rounds 9 and 9b stay on main
  as they are (the floor model is kept for later); the Frame-price question (Q-331) is withdrawn.
- The card page and its gates test ONE art against itself. A second art is added only as its own mirror bout.
  Arts meet only when every art of the scope has its cards in the game.

## The plan
| Phase | What | Who | Done when |
|---|---|---|---|
| 1. A real boxing bout, broken down | Three real bouts round by round (one out-boxer v pressure fighter, one that ends by stoppage, one close decision): what each man does each exchange - range, the jab, the lead, the counter, the body, the clinch and break, a knockdown and the count, tiredness, the bell, how the judges score a round. Then the same as card logic: what a turn is, what a card is, what the other man's window is. Our own words and numbers; sources named. | John (research), Claude (the card logic page) | `CARDBOX1_BREAKDOWN.md`: every exchange of one walked round has a card-logic line and no "how is that possible?" turn |
| 2. Boxer v boxer on paper | The boxing deck and rules from phase 1: what today's game lacks (round scoring by judges, the count, the clinch and the referee's break, feints, footwork and the ropes, punches that set up punches, tiredness over rounds) and what goes (the three floor cards). One whole bout walked on paper. | Claude; two fresh critics, one code-checked | the walked bout reads as a boxing match to the owner; critics 8+ on depth |
| 3. Build and measure | The engine and page for boxer v boxer only. Bars: goes to the cards in 40-70% of bot bouts; going first wins 45-55%; every card of the deck laid in 2%+ of the bouts where it was legal; a combination in most bouts; 22-45 decisions. | Claude (Arena if a slice fits) | the bars, then HIS PLAY of boxer v boxer |
| 4. The next art, alone | The same three phases for the next art as its own sport (his pick: kickboxing, wrestling, judo, jiu-jitsu, karate). | as above | its mirror bout passes its bars and his play |
| 5. MMA | Only when every art is in: a real MMA bout broken down the same way; every fighter then has strikes, takedowns and a floor game, weighted by his art. | - | not before phase 4 is done for every art |

## Not decided here (his call when phase 2 is on paper)
- Which art comes second.
- Whether the ladder page keeps its training and rungs while only boxing is playable (my reading: yes, unchanged).

## Feedback loops
- Scoring a round on punches landed -> the leader can coast -> fewer punches: capped by the judges scoring ring
  generalship and by tiredness returning with rest; measured in phase 3 (the share of empty turns).
- A knockdown -> a hurt man -> more knockdowns: capped by the count, the bell and the three-knockdown stop.
- One-rep trial before the full run: 20 bot bouts printed turn by turn before any 400-bout table.

## Prior research
`CARDREAL_AUDIT.md` (the position model, kept), `CARDREAL1_JOHN_BRIEF_JOHN.md` (boxer v jiu-jitsu, real-fight memo),
`CARDREF2_MARTIAL_ARTS.md`, `CARDGAME_PREPROD_S540.md` (the signed plan: its slice order is replaced by this page),
`research/topics/body_damage.md` and `plans_corner.md` (the 3D game's own boxing numbers - the card game should not
contradict them).
