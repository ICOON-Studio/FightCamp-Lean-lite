# CARDSCOPE4 greybox (S538): the rally on a four-range strip, six martial arts

Plain node, no build. The design and the result: `ops/research/DESIGN_CARDGAME_SCOPE.md` sections 3S, 4d, 6d.

- `cards.mjs` every number, card and deck (the `SIZED` block holds the numbers the measured run used)
- `engine.mjs` the rules: strip, one answer, volleys, three clocks, the hold race, the six own mechanics
- `plan.mjs` the pilots: one AI pilot for any deck (public information), the impatient line, a script per style
- `probe.mjs` the bars: `node probe.mjs p3|p1|p2|p5|p6|p4|p10|r3|all per=200 seed=500000000 tag=name` (writes `out/`)
- `tune.mjs` the sizing search (sizing seeds only); `report.mjs` prints the card table; `diag.mjs a b seed` one bout
- `engine.test.mjs` the rules test: `node --test proto/cardscope4/engine.test.mjs` (node 24 takes no folder here)
- `measured/` the measured run's raw lines; `turn_mock.html` / `.png` one turn with every number (a mockup)

Verdict of round 4: FAIL (5 of 7 core bars; P5 clause 1 and P6 fail). The wind pool beat limb points (P3).
