# TASK BUILD1 - the fighter's body as a Breachway ship: equip discipline cards per body part, the deck you fight with (S569)

Kind: design. Model: Opus 5.5 or Fable console worker (no PC load: design + critics + one small greybox probe).
Discipline: Puncher's chance (boxing first; kickboxing next - one art against itself first, S549).
Seat rules: ops/research/WORKER_S566.md. Rule: MECHANICS NEED 8 (CLAUDE.md): probe the lever on a greybox FIRST, then two
fresh critics (one code-checked) at 8+ on DEPTH and PLAY, then build.

## His words (S569, verbatim)
"maybe Try scaling health and the other parameters to start at 50 (or 75) and possible to reach 100 later (these games
usually have health starting from 200 or 100 or 40-50) , the energy management should be part of the decision making
(maybe lower health limits your stamina pool orr something) . Also consider this analogy with breachway : A fighters
body similar as spaceship with variations , then you can equip different discipline cards depending on your fighter and
choices or progression so you will have those moves as your deck in the fight like you do in breachway for each module
, and you got to be careful which moves can blend and flow etc . You may increase attacking action pool ,or defensive and
body conditioning , analogy with the core and card mechanics increase your earned resources in breachway."
Also S569: combining cards ("drag one ontop of another to create the blend of them"; "we can use it as unique feature so
that the player drafts his deck on the spot , and of course not all move can be combined with others") - TASK_RULES569
idea 4.

## The design to write (ops/research/DESIGN_BUILD1.md)
1. Read Breachway first (installed: E:/SteamLibrary - REA read-only, owner rule; our earlier notes in
   CARDREF1_REFERENCE_GAMES.md and ops/research/topics): how a ship's modules give cards, how the core and the modules
   raise resources (energy a turn, hand size), how a build differs from another. Our words, nothing of theirs copied.
2. The map: the fighter's body = the ship. Parts (lead arm, rear arm, legs, core/torso, head + conditioning). Each part
   holds N discipline cards (boxing punches on the arms, footwork on the legs, guard and clinch on the core...). The
   fight deck = what the parts hold. Progression (training weeks, the career) adds slots, upgrades cards, raises the
   pools: an attack pool (actions a beat / stamina a beat), a defence pool, conditioning (health and stamina ceilings) -
   his scaling idea: start at 50 (or 75), grow toward 100.
3. Blend and flow: which cards combine (TASK_RULES569 idea 4's table) and which follow each other well (a jab sets up the
   cross) - the deck-building decision.
4. How it plugs into what exists: the hand of cards on order.html (picture cards), the strip, the gym side of FightCamp
   (training raises the pools: the career and the fight finally meet), the styles (each style = a starting build).
5. `## Feedback loops` (gate, S541): stronger build -> more wins -> more progression -> stronger build: the cap on each
   loop (opponents scale, slots are scarce, upgrades cost training weeks).
6. A greybox probe: two builds (an outboxer and a pressure fighter) at 50-point pools v the mirror on today's rules
   engine (balance.mjs with a tweak that only resizes the pools and the hand) - do the builds play differently, and does
   the 50 -> 75 -> 100 growth change outcomes the way a career should?
7. Two fresh critics (CRITIC_PACK first) score DEPTH and PLAY (8+ to stay), with their To reach 10/10 lists and drawn
   10/10 pages. A lower score = another round, never the board.

## Feedback loops
- Stronger build -> more wins -> more progression (slots, upgrades, bigger pools) -> stronger build. Caps to design and
  show in the probe: opponents scale with the ladder (their pools grow too), slots are scarce (a new slot costs camp weeks,
  not wins), upgrades cost training weeks the gym must pay for, and every pool has a ceiling of 100.
- Low health -> smaller stamina pool -> fewer actions -> more damage taken -> lower health (his "lower health limits your
  stamina pool"): the downward spiral needs a floor (a minimum pool, the round-break recovery) - measure how often a man
  who falls behind in health ever comes back (bar: at least the boxing page's comeback share).
- Trial first: ONE rep (N=12, seed 1) of each build before the full probe; stop if the two builds' plan mixes are the same.

## Prior research
ops/research/MMC_PLAYTEST_S569.md (style decks with the plan written on them; the rest as a plan pick),
ops/research/CARDREF1_REFERENCE_GAMES.md, ops/research/DESIGN_CARDGAME_SCOPE.md (the card-game rounds S537-S550),
ops/research/JOHN_CARDGAMES_RESEARCH_JOHN.md, memory: card game one art first (S549), innovative not another
deckbuilder (S551: "there are 1 million deckbuilding games" - the body-as-ship map must be the innovation).

## What would a human do?
A coach builds a fighter: you cannot teach everything, so each fighter carries a short list of weapons that suit his
body and his style, and camp is where the list grows.

## Prefab check
Not applicable (our design; Breachway is a reference, read not copied).

## Contract
- OWNS: ops/research/DESIGN_BUILD1.md, ops/research/s558_balance/build1_*.json, ops/research/s558_balance/results/build1_*.txt,
  ops/research/BUILD1_CRITIC_*.md
- RED_TEST: none (design)
- REGRESSION: node proto/twohands/tools/rules_test.mjs (nothing of the page changes)
- VISUAL: the critics' drawn 10/10 pages (tools/render_mockup.py)

## Not yours
Every page and rule file. No public push. Never "Ring Switches".
