# TASK MMCPLAY1 - our agents play Mixed Martial Cards in the background and report on its structure (S569)

Kind: playtest. Model: Opus 5.5 console worker (PC). Discipline: reference game (read-only use of the installed demo).
Owner S569: "can you make the agents play it in the background ?" (Mixed Martial Cards), after "i care about the way they
structured it and their rules". Seat rules: ops/research/WORKER_S566.md. Owner rule (global CLAUDE.md, reference games):
read-only use of the installed files; findings written as notes and numbers in OUR words; nothing of theirs (code, card
text, art) copied into the repo; never touch his saves (never his save slot - S539).

## What exists (S569, Claude)
Their rules are plain JS modules in the demo's app.asar (`dist/src/*.js`, ESM, obfuscated names but readable values).
Claude's scratch tools: an asar reader + extractor and dumps, at
C:/Users/user/AppData/Local/Temp/claude/85dc671c1b886d43/8b174ee4-9dc0-4845-bcd2-07a5d6b9d181/scratchpad/
(asar_list.mjs, asar_extract.mjs, mmc_dump*.mjs, mmc_exports.mjs; read them). Loading `dist/src/cards.js` works once
`dist/src/index.js` (their SERVER: express, Steam, saves) is replaced by a 4-function stub (getPlayerData, getSteamworks,
handleGameOver, savePlayersData). `logic.js` exports the match loop: gameTick, gameActions, playCard, runAIStep,
startExchange, stopExchange, restTime, checkWinConditions, createDeck, getAIState ...; `templateDecks.js` the decks;
`ai.js` needs the `uuid` package (stub `v4` with crypto.randomUUID). ops/research/MMC_DISTANCE_S569.md and
CARDREF1_REFERENCE_GAMES.md s1 = what we know of their rules.

## Do
1. ops/research/mmc_harness/ (OUR code only): `extract.mjs` copies dist/ from the INSTALLED app.asar into
   E:/FightCamp/wt_tmp/mmc_x (never into the repo), writes the stubs (index.js, uuid, any other server package), and
   `match.mjs` builds a match the way their server does (read index.server's game creation: which state object, which
   decks, which ticks) - first AI v AI, 20 bouts, printing each turn in one line (initiator, card, mode, answers, damage,
   who holds the initiative, create distance / clinch events) and the result. Must run with no network, no Steam, no
   save written anywhere (check: no file under the install folder or %APPDATA% changes).
2. `play_cli.mjs`: one side their AI, the other side driven by text (the hand, the window - prediction / reaction /
   surprise - and the legal plays printed; a play read from stdin or a file), like proto/twohands/tools/play_cli.mjs.
   A `play_by_message.mjs` for chat seats as ours (proto/twohands/tools/play_by_message.mjs).
3. The playtest: you play 3 bouts yourself; then send it to the seats the owner has ticked as available (see `start`'s
   AGENTS line: Ziva, Kalli, John, Maria, Dola through ops/Tools/gbot.py / seat_queue.py as the S557/S567 leagues did -
   read ops/research/versus/ and TASK_ALLPLAY*.md for how they were driven), 2 bouts each. Each reports: fun / depth /
   clarity 1-10, and what in the STRUCTURE (initiative, the three answer windows, long range, create distance, the feint
   mode, the clinch door) makes decisions interesting or dead.
4. docs/MMCPLAY1_RESULT.md: the AI v AI numbers (initiative changes an exchange, how often each window is used, long
   range share, create distance share, feints bitten/called), each seat's verdict, and FIVE plain lines for the owner:
   what of their structure would make Puncher's chance better, and what would not. Last line `MMCPLAY1 DONE` or
   `MMCPLAY1 BLOCKED: <why>`.

## Feedback loops
None: a playtest of a finished game; no rule of ours changes.

## Prior research
ops/research/MMC_DISTANCE_S569.md, CARDREF1_REFERENCE_GAMES.md, docs/MMCTOY1_RESULT.md (when it lands: our toy of their
distance rules), the S557 / S567 agent leagues.

## What would a human do?
Play it a lot and keep notes of every moment a choice felt real or fake, then say which rule caused it.

## Prefab check
Their own AI plays one side; our play_cli / play_by_message patterns drive the other.

## Contract
- OWNS: ops/research/mmc_harness/* (our code only), docs/MMCPLAY1_RESULT.md, ops/research/mmcplay1/* (seat reports)
- RED_TEST: none (a playtest)
- REGRESSION: none (nothing of ours changes)
- VISUAL: none

## Not yours
Everything under proto/, scripts/, tests/. The installed game folder and its saves: read only. Never commit their files.
