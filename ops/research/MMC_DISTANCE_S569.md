# Mixed Martial Cards (demo) - how its rules handle distance (S569, read-only)

Owner S569: "i dont care now abbout their animations , i care about the way they structured it and their rules".
Source: the installed demo (E:/SteamLibrary/steamapps/common/Mixed Martial Cards Demo), its card module loaded in a
scratch copy with the server stubbed out (no network, no save touched), plus a few tutorial turns played on his screen.
Notes and numbers in our words; nothing of theirs copied into the project. Turn structure: CARDREF1_REFERENCE_GAMES.md s1.

## No range track at all
- The fight has TWO states: standing (68 cards) and grappling (60 cards, its own deck). Nothing is "Long" or "Mid" on
  the board, and nothing is drawn in the ring (the cards carry the pictures).
- Distance lives in three card words:
  - LONG RANGE (only 3 standing attacks: the jab to the face, the thigh roundhouse, the superman punch): "can't be
    countered with a reaction". A counter must be called BEFORE seeing the card (the prediction window): the step-in
    head counter counters only a long range attack and only as a prediction; the short counter hook does not work
    against long range. A long range attack also blocks the clinch that turn.
  - CREATE DISTANCE: "end exchange, opponent gets initiative". Made by a push kick that deals damage, or by Disengage
    (a dodge of any attack, prediction only, costs 3 stamina and one card at the next draw). Pursue (2 stamina) cancels
    it and takes the initiative next turn. Perk Distance Management: you gain initiative after creating distance.
  - CLINCH (1 stamina, "instant"): enter the grappling state; only if no long range attack was played that turn.
- Related: Overwhelm - this exchange he cannot defend or counter as a reaction, and you cannot use long range attacks.
  Off rhythm - you cannot play reaction cards (from biting on a feint, or covering up a head shot).

## What it means
Distance is not where the men stand; it is WHICH ANSWERS ARE ALLOWED. Long range = safe from a seen counter, beaten
only by a read. Creating distance = ending the exchange (and handing the initiative over). Closing = the clinch door.
The exchange (initiative, three answer windows: prediction, reaction, surprise) carries the depth; distance only bends
which windows are open.

## Ours, for comparison (Puncher's chance, order.html)
Three places on a track (Long / Mid / Inside), both men plan up to three moments at once, every punch has a reach list,
steps move the track. LONG1-LONG3 measured that Long is a corridor (the page already "catches the man who steps in",
29-30% of Long beats throw a cross that falls short 75-85%), and the pictures must show the track exactly (the S569
jumps).
