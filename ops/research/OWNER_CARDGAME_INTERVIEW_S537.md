# The owner on the card game - interview S537 (2026-11-22)

His answers, verbatim where quoted. Every card-game scope, critic and build job reads this first; it outranks a critic's
taste.

- **Card games he enjoyed:** "breachway, hearthstone, clutchtime, rune coliseum, starless abyss, mma arena, monster train,
  mixed martial cards demo, kungfu card" and "i also like a lot ironbound". These are the reference set - study what each
  does well (our words and numbers only; nothing copied). Two are fight-sport card games (MMA Arena, Mixed Martial Cards):
  closest to ours.
- **How one bout should feel:** "Fast and punchy" (picked over chess-like reading and tense gamble). Quick turns, lots of
  action, a bout under ~5 minutes. Depth must come without slow sums.
- **Where it lives:** "its standalone prototype" - a standalone game for now; the link to the gym game is not the goal.
- **Help on screen:** "Show me everything" - preview damage and results as each card is placed; the skill is the choice,
  never the arithmetic.
- **Form:** any card-game variation, "as long it can reach 10/10" (earlier the same day).

- **More martial arts (later the same day):** "since the card game has no 3d animation requirements for the fight it can use
  the current things we have for other martial arts, include bjj, wrestling, judo, karate, mma, sambo, this might give enough
  depth and fun and replayability, however i would like to see animations if possible". So: styles from several disciplines
  meet in the card game (each with its own cards, range and win conditions - a takedown, a submission, a points throw, a
  knockout), MMA as the meeting ground; reuse what the repo already has for BJJ/wrestling/MMA (rules, data, clips). And
  ANIMATION where possible: a short move clip or animated card when a card resolves (our bought/owned clips rendered to
  sprites or short loops, or Ludo-made animations) - never a blocker for the rules.

- **A direction idea (later the same day):** "use action points for each limb maybe for a turn". Each limb (lead arm, rear
  arm, lead leg, rear leg; perhaps hips/core for grappling) has its own points a turn; a card spends the limb it uses (a jab
  the lead arm, a roundhouse the rear leg, a double-leg both arms + legs, a guard pull the hips). It fits the six styles: a
  boxer is arm-rich, a karateka leg-rich, a grappler spends everything at once. Damage or fatigue could take points off a
  limb (a hurt lead leg = fewer kicks). CARDSCOPE4 probes it against the single wind pool; his idea, his "maybe" - keep it
  only if it measures better.

- **Asynchronous battles with other players (end of S537):** "also consider asynchronous battle options with other players for
  the card game, what do you think ?". Claude's view: a good fit, as a LATER layer, in the "ghost" style (Super Auto Pets,
  Backpack Battles, The Bazaar): your fighter + deck is saved as a snapshot; other players fight it, an AI plays it for you;
  you see the results later. Needs: rules an AI pilot plays well (we need that for opponents anyway), a small server or Steam
  leaderboard/cloud to store snapshots, matchmaking by rank, and a check against tampered decks. CARDSCOPE4 keeps it in mind
  (an AI that pilots any deck; a deck/fighter that saves as a small file) and puts it in the build plan after the run works;
  it does not build it now.

## What this changes in the S537 scope (Claude)
- CARDSCOPE1's bout (twelve exchanges, 5-8 min, a three-beat puzzle) is too slow for "fast and punchy": a bout of ~5 min,
  fewer and faster turns, full previews.
- Phase 8 "the link" leaves the plan; a standalone run is the product.
- The reference set replaces the brief's list (Slay the Spire, Balatro, ...) as the games to beat.

- **Kickboxing too (S538):** "also include kickboxing for the card game". A seventh art beside boxing, karate, judo, wrestling,
  BJJ, sambo (MMA = the meeting ground). Its own cards and mechanic, distinct from karate (karate: in-and-out point scoring
  from kick range; kickboxing: trading punch-kick combinations, leg kicks that wear movement, clinch knees, no takedowns).

- **Progression and a different approach (S538):** "include ladders and championships etc , people love to see how they progress
  in ladder and learn skills for fighters , take decisions on training , check if any other similar games exist out there if
  we are missing something out or we could also take a different approach similars to expedition 33". So: the run between
  bouts carries a LADDER and CHAMPIONSHIPS (rank shown, belts), fighters LEARN SKILLS (new cards / upgrades), and the player
  makes TRAINING DECISIONS between bouts. A market check of similar games (what we miss), and Clair Obscur: Expedition 33's
  approach (turn-based with real-time reactions: dodge/parry timing on the enemy's turn) weighed as an alternative form.
