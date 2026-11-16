# Damage through the guard (S500, the owner's question)

The owner, 2026-11-16: "the punches and the guards need real numbers for damage and reduction , the guard should negate
the punches damage , if not some damage goes through . do we have such mechanic ? isn't it the way it should be how
other games do this ? Wwhat do you think ?"

## What the game does today
- A punch either LANDS or it does not. Only landed punches count: they score the exchange, mark the face and ribs, drain
  the tank (a body shot greys 1 slice of the tank for the fight), cause hurt moments and knockdowns.
- A blocked punch and a missed punch are the same thing in the numbers: nothing. Blocking costs the blocker nothing and
  costs the puncher only the effort of throwing.
- The GUARD bar on the fight screen is not a shield. It only shows tired shoulders: how far the gloves have sunk.
- Since S500 a punch that does not land is SHOWN caught on the guard most of the time (glove knocked back, the boxer
  rocks, the block sound). That is the picture only.

So: no, there is no damage reduction and no damage through the guard.

## How other games do it (from memory, to be checked by John before any number is fixed)
- Fight Night / UFC games: a block removes most of a punch's damage, a share still goes through, and every blocked
  punch wears the block down; a worn block lets more through and finally breaks.
- Text boxing sims (Title Bout style): each punch is rated, a block or partial block reduces or removes its points.
- Real boxing: punches on the gloves and arms do tire the arms and shoulders, a hard shot on a high guard still shakes
  the head, and body shots on the elbows still take wind. Judges do not score blocked punches.

## What I think we should build (proposal, not built)
1. Every punch has a damage number (it already has a strength: jab, power, big).
2. A punch caught on the guard does a SHARE of that damage: small for a jab, larger for a power punch, largest for a
   big shot. The share is the mechanic's main number and must come from research, not from me.
3. The share grows as the GUARD bar falls. Blocked punches themselves lower the guard bar (arms and shoulders tire), so
   a boxer who only covers up gets worn down: pressure works, which it does not today.
4. A blocked punch never scores for the judges and never knocks down by itself; a hurt moment through the guard only
   from a big shot on a low guard bar.
5. What the player can do about it: a coach's call ("hands up", "move, don't cover"), the fight plan (cover or slip),
   training (guard endurance in shoulders, defence skill deciding block versus slip), the opponent's file (a heavy
   hitter breaks guards).

## Before it is built (the standing rules)
- Research the real shares (John), a design map with every menu it shows on, two fresh critics at depth 7 or more,
  then the owner's yes on the map. It changes the fight's numbers, so the balance harness runs before and after.
