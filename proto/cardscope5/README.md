# CARDSCOPE5 greybox (S538 to S539): the rally on a four-range strip, seven martial arts, each with its own rule of play

Plain node, no build. The design and the result: `ops/research/DESIGN_CARDGAME_SCOPE.md` sections 3T, 4e, 6e.

- `cards.mjs` every number, card and deck; `sized.json` holds the numbers and deck counts the measured run used
- `engine.mjs` the rules: strip, one answer, volleys, three clocks, the hold (a submission has a price, a pin has none), the seven own mechanics
- `plan.mjs` the pilots: one AI pilot for any deck (public information), the impatient line, a script per style
- `probe.mjs` the bars: `node probe.mjs p1|p2|p5|p6|p4|p10|r3|all per=200 seed=500000000 tag=name` (writes `out/`)
- `tune.mjs` the first sizing search (one seed, first improvement); `tune2.mjs` the second (screened on three seeds, kept only if better on four others; numbers and deck counts); sizing seeds only
- `report.mjs` prints the card table; `diag.mjs a b seed` one bout; `run5.sh` the chain as run
- `engine.test.mjs` the rules test: `node --test proto/cardscope5/engine.test.mjs`
- `measured/` the measured run's raw lines; `turn_mock.html` / `.png` one turn with every number (a mockup)

Verdict of round 5: FAIL (4 of 7 core bars). P5 (the hold's printed rule: 100%) and P6's first clause (each mechanic
changes the line: 57 to 96%) now pass; P4 (19 of 21 pairings), P6's blind judge (48.5%; 89.0% at its best reading) and
one clause of P2 fail.
