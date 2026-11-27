# TASK OCTAGON1 - the owner's Octagon Tactics design, boxing first: an engine, bots, agent playtests (S570)

Kind: probe (a toy engine + playtests). Model: Opus 5.5 console worker (PC, node only - no Godot) or Arena.
Seat rules: ops/research/WORKER_S566.md. Rule: one art against itself first (S549); mechanics need 8 (critics + agents).

## His words (S570)
He sent two PDFs (ops/research/octagon/Octagon_Tactics_Official_Rulebook.pdf, ..._Complete_MMA_Card_Game.pdf - read
both whole) and asked: "check these and tell me what you think , does it worth for the agents to playtest it ?". Before
that: "For a deep MMA simulation, Dynamic Momentum (Initiative Token) - where the winner of the previous exchange holds
the 'Lead' until they lose an exchange or reset" and "why did you stuck with range , i didnt mention anything about range".

## Claude's read (S570, said to him)
Worth it: text rules, one card a side revealed at once - what agents play well. Fix first: (1) the two PDFs disagree -
7 v 6 exchanges a round; Defend v Feint "ties" in one, "Defender +2, Feinter controls range" in the other; Level-Change
Fake "beats Defend" against the triangle; (2) Defend is too cheap - High Shell (1 STM, SPD 9, blocks every head attack,
+3 STM) and Philly Shell (negates ALL boxing attacks, +2 STM, +1 SPD); (3) too many systems for a first test.

## Do
1. Rules audit: docs/OCTAGON1_RULES.md - every contradiction between the two PDFs and how you resolved it (pick the
   rulebook's version unless it breaks the triangle; say each). Keep his words; change only what is contradictory.
2. Engine, BOXING ONLY: proto/octagon/engine.mjs - the 9 Boxing cards + the 6 Fight IQ cards (Cut the Cage, Circle Out,
   Read Tendency, Second Wind, + Pawing Jab / Head Movement Feint already in boxing), Range Track (Long / Mid / Close),
   Cage Space, the Initiative Token + Combo Bursts, Head / Body health, stamina, Rocked, Cuts. No grappling, no kicks.
   Two fighter profiles from his archetypes, cut to boxing (Out-Fighter's footwork; Pressure: the Muay Thai brawler's
   numbers without kicks) - say how. A 20-card deck from the 15 cards (duplicates allowed, say the lists).
3. Bots: random-legal, a greedy (best immediate value), and a reader (counts his last 3 cards). 1,000 bouts per pairing,
   seed fixed. Measure: wins by profile and by bot; KO / decision share; every card's play rate and win rate when played;
   how often the Initiative holder keeps it (streak lengths) and the comeback share (behind after round 1 -> wins);
   Defend share; dead cards (< 3% when legal) and must-plays (> 40%).
4. Agents play by message (proto/twohands/tools/versus_by_message.mjs is the pattern): Claude (an Opus console), Ziva
   (free model), Dola, John - 2 bouts each against the reader bot; each ends with FUN / DEPTH / CLARITY / VARIETY 1-10 and
   what to change to reach 10.
5. docs/OCTAGON1_RESULT.md: the numbers, the agents' scores and lists, the three changes that would help most, and for
   the owner in plain words what playing it feels like. Last line `OCTAGON1 DONE` or `OCTAGON1 BLOCKED: <why>`.

## Feedback loops
- Initiative -> +2 SPD and combos -> more wins -> keeps Initiative: the snowball. Caps in his rules: Counter beats Attack
  whatever the speed; blocked / countered / Defend loses the Lead. Watch Rocked (auto Initiative) - measure streaks.
- Body damage -> lower stamina cap -> fewer cards -> more damage: capped by the per-5-damage step. Measure comebacks.
- Trial first: 50 bouts random v random to check the engine terminates and every card is legal somewhere.

## Contract
- OWNS: ops/research/octagon/ (notes), proto/octagon/ (new), docs/OCTAGON1_RULES.md, docs/OCTAGON1_RESULT.md
- RED_TEST: none (a new toy)
- REGRESSION: none (nothing of Puncher's chance changes)
- VISUAL: none (text engine); a page only if the numbers and agents say it is worth one

## Prior research
TASK_TYPES1.md (his triangle inside Puncher's chance), MMC_PLAYTEST_S569.md (Mixed Martial Cards, rated 7/10),
INJURY_BADGES_S570.md, the agents' league S567 (versus.mjs, league.mjs), MMCPLAY1.

## What would a human do?
Print the cards, play ten bouts with a friend, then fix what one player always does.

## Prefab check
Not applicable: his design; our engine.

## Not yours
Every Puncher's chance page and rule file. No public push. Never "Ring Switches".
