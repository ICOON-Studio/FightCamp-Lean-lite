# Reference read: a fighting deckbuilder demo (Mixed Martial Cards, Steam demo) - S536

Owner S536: "a demo of this is installed on e, you can use rea to figure it out and get ideas for the card deckbuilder".
Method (owner REA rule, CLAUDE.md global): read-only inspection of the installed files; notes and numbers in our own words;
nothing of theirs (art, code, text) copied into the project. The demo is an Electron app; its card data and rules
(`dist/src/cards.js`, `logic.js`) are string-encrypted and were NOT decrypted. Everything below comes from the readable
frontend bundle's field names and the names of its art files - enough for the design's shape, not its numbers.
Not played yet: a hidden-desktop playthrough (tools/hidden_play.py) would give card texts and pacing if we need them.

## What the design is made of (INFERRED from field and file names)
1. FOUR CARD TYPES: attack, counter, defence, instant (an instant is played outside your own turn - a reaction).
2. A READ SYSTEM, the heart of it: each exchange is answered by PREDICT (commit early, guess what is coming) or REACT
   (answer what you see, safer, needs speed), or PASS - including passing "off rhythm" (breaking the timing). Cards carry
   COMMITTED (you cannot back out), FEINT and FULL POWER marks. So the guess is a skill with a cost, not a coin flip.
3. PUNCH SHAPES decide the answers: straight, looping and vertical trajectories, long range or not, takedown or not. A
   defence answers a SHAPE (a slip answers straights, a duck answers loopers, a lean back answers range), so the hand you
   hold is a set of answers to shapes, and reading the opponent's favourite shape pays.
4. TWO HEALTH BARS (head and body, kept apart) plus stamina, a grappling meter, stress, cuts, position and control: damage
   has a place, and body work pays later (stamina).
5. COACH CARDS: strategy, make adjustments, read body language - the corner is part of the deck.
6. PROGRESSION: upgraded versions of cards, perk medals, fame / money / rank, team banners - a career around the bouts.
7. A DECISION TIMER on the exchange, and a "simultaneous exchange" card (both land).
8. Card names are plain fight words (jab to the body, liver shot, short counter, step-in counter, panic block, ready for
   impact, smell blood, pursue, disengage, chin check, protect the body, high guard) - the deck reads like a fight.

## What to take for our boxing card game (Claude's call - for the coordinator's next brief)
- KEEP our simultaneous reveal, ADD the predict / react choice per exchange: predicting beats the read cleanly and costs
  stamina or exposes you if wrong; reacting is safe but only works with enough Speed. This turns our "read pays" into a
  decision every exchange, tied to our Speed and Knowledge (film) stats.
- PUNCH SHAPES as the resolution key (straight / looping / uppercut, range), replacing a flat beats-table: defences answer
  shapes. Our film habits then name a shape ("loops his right when tired") - the read is concrete.
- HEAD and BODY damage apart; body damage drains stamina for later rounds (our game already does this: LiverRibs, body
  load) - the card game should mirror it.
- A COMMITTED / FEINT mark on a few cards: a feint costs a card and tells you what he answers with.
- INSTANTS as our corner's "shout" (one per round, out of turn) - matches the game's 30-second call.
- COACH CARDS between rounds - we already have corner cards; keep them few and costly.
- Do NOT take: MMA breadth (kicks, takedowns, submissions) before boxing reaches 8; a real-time decision timer (the
  owner plays a manager game - a timer is optional, off by default).

## Played on the hidden desktop (S536, owner "yes play the demo on the hidden desktop"; tutorial, first exchanges, muted)
Observed, in our words (shots outside git: E:/FightCamp/tmp/mmc_play/):
- FRAME: a coach's tutorial and a clipboard of career goals (learn basics, a training arc, a licence test, a first fight).
  Three bars a fighter: health, a second health bar (pink - head or "mind"), stamina.
- THE EXCHANGE: the side with the INITIATIVE plays one attack card face up; its MODE (normal / full power, and feint
  later) stays hidden until the defender has answered. The defender REACTS with a defence or counter card; the hand
  LIGHTS UP the cards that work against the shown attack (the game teaches the read). If the attacker feinted, a
  reactor goes OFF RHYTHM. Defend successfully and the INITIATIVE passes to you - momentum swings on reads.
- FULL POWER: double damage for 50 % more stamina; if it is countered you take double damage and are DAZED.
- BASIC ACTIONS: free (0 stamina) cards that return to the hand every turn (a half block for head or body), so you are
  never empty-handed; real cards cost stamina.
- CARD FACE: stamina cost, attack shape (straight ...), target body part, two damage numbers, keyword effects - e.g. "long
  range: cannot be answered by a reaction", "injure body: later body hits drain more stamina".
- A PREDICTION PHASE exists before the attack (skipped in the tutorial).

## What this changes for our card game (Claude, S536)
- Our v1 reveals both cards at once. Theirs shows the ATTACK first and hides only its MODE - that makes the defender's
  choice a read of intent (is it a feint? full power?) instead of a blind guess, and it is far more readable. Strongly
  worth testing in round 2: attack shown, mode hidden; defend, and the initiative passes.
- INITIATIVE that passes on a good defence gives a fight rhythm (pressure, then the counter) a boxing coach recognises.
- FREE basic block cards stop a bad hand from deciding a round.
- FULL POWER's risk (countered = double damage + dazed) is the cleanest "trade that depends on the moment" we have seen.

## Open
Card counts per type, starting deck size, how upgrades are earned, what stress and resolve do, how prediction works.
The demo saved its tutorial progress in its own user folder (normal for a game; nothing of ours touched).
