# proto/cardscope - the bot probe of the card game scope (CARDSCOPE1 and CARDSCOPE2, S537)

A greybox, not a game: rules and bots only, no page. It measures the fun bars of
`ops/research/DESIGN_CARDGAME_SCOPE.md` (sections 4 and 4b). Results: `docs/CARDSCOPE2_PROBE.md` (round 2, this code)
and `docs/CARDSCOPE1_PROBE.md` (round 1: he always led; that code is commit 68c5bf2ed).

Round 2 in one line: the lead changes hands every exchange, both boxers have the same wind and hands, a trap card
(Check hook), habits that rule the face-down card, deck limits, a beginner bot and a table-player bot.

```sh
node proto/cardscope/engine.test.mjs        # 45 checks
node proto/cardscope/probe.mjs fixed 2      # the best fixed line (all 4,096 searched), random
node proto/cardscope/probe.mjs ladder 2     # greedy, reader, all-seeing, beginner, table player, forced answers
node proto/cardscope/probe.mjs info 2       # cards shown 0-3, opponent classes, film, counting, corner
node proto/cardscope/probe.mjs cards 2      # what each card is worth by opponent style, the 8-bout run
node proto/cardscope/probe.mjs breaker 2    # is there a deck that breaks the pro debut?
node proto/cardscope/probe.mjs report       # the bar table (reads out/*.json)
node proto/cardscope/transcript.mjs 7 0 1 3 # one bout, beat by beat
node proto/cardscope/calib.mjs per=40       # sizing aid on its own seeds (300000+); name=value resizes one number
```

The five measuring commands are independent and can run side by side.

Files: `cards.mjs` (cards, numbers, boxers, habits, classes, deck rules), `rules.mjs` (the exchange in three beats),
`bout.mjs` (rounds, who leads, judges, corner), `opponent.mjs` (he leads, hides, keeps his habits, answers, reads you),
`bots.mjs` (random, fixed line, greedy, reader, all-seeing), `bots2.mjs` (beginner, table player), `probe.mjs` +
`probe2.mjs` + `report.mjs` (measurements and bars), `calib.mjs`, `diag.mjs` (sizing aids on their own seeds),
`runs/` (every measured run: tables and raw numbers; `run1-3` are round 1, `r2_*` are round 2).
