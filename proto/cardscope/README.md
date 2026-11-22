# proto/cardscope - the bot probe of the card game scope (CARDSCOPE1, S537)

A greybox, not a game: rules and bots only, no page. It measures the fun bars of
`ops/research/DESIGN_CARDGAME_SCOPE.md`. Result: `docs/CARDSCOPE1_PROBE.md`.

```sh
node proto/cardscope/engine.test.mjs        # 32 checks
node proto/cardscope/probe.mjs ladder 2     # the bots, the best fixed line, the fight shape
node proto/cardscope/probe.mjs info 2       # cards shown 0-3, opponent classes, film, corner
node proto/cardscope/probe.mjs cards 2      # what each card is worth by opponent style, the 8-bout run
node proto/cardscope/probe.mjs report       # the bar table (reads out/*.json)
node proto/cardscope/transcript.mjs 7 0 1 3 # one bout, beat by beat
```

Files: `cards.mjs` (cards, numbers, boxers, classes), `rules.mjs` (the exchange in three beats), `bout.mjs` (rounds,
judges, corner), `opponent.mjs` (he lays first and reads you), `bots.mjs` (random, fixed line, greedy, reader,
all-seeing), `probe.mjs` + `report.mjs` (measurements and bars), `calib.mjs`, `diag3.mjs`, `diag4.mjs` (sizing aids on
their own seeds), `runs/` (the three measured runs: tables and raw numbers).
