# FightCamp card ladder — round 7 (the PLAY gate)

The playable page is `index.html` + `ui.js` + `ui-text.mjs` (pure card text and the printed-numbers check) + `playlog.mjs`
(pure play log) + `ui-helpers.js`. It imports the measured cardscope5 port (`cards.mjs`, `sized.json`, `engine.mjs`,
`plan.mjs`) and the career layer in `career.mjs`. Browser code uses ES modules and a static HTTP server; do not open the
page from `file://` because JSON module imports are blocked by browser origin policy. `ui.test.mjs` plays the page
through the stub document in `uidom.mjs`.

## Run and test

```sh
node --test "proto/cardgame/*.test.mjs"      # engine, page and ladder tests (40)
node proto/cardgame-legacy/rules.test.mjs     # the retained pre-round-6 rules (32 checks)
node proto/cardgame/probe.mjs gate=play       # the PLAY gate table (plan section 7), out/gate-play.{txt,json}
node proto/cardgame/probe.mjs gate=ship       # the SHIP gate table (PLAY + the full sheet), out/gate-ship.{txt,json}
node proto/cardgame/probe.mjs all per=200 seed=500000000 tag=r7  # the round-6b fixed bar sheet, re-measurable anytime
node proto/cardgame/ladder-probe.mjs          # L1 and L2 on the ladder's own states, out/r6ladder.json
```

The gates are the two tables of plan section 7 (`ops/research/CARDGAME_PREPROD_S540.md`): `gate=play` is what the owner
plays (module graph links, a scripted player finishes a bout and a ladder step through the page's own calls, the printed
numbers equal the engine's, D1, the pairing inside 40-60, no crash in 1,000 bot bouts); `gate=ship` is PLAY plus P2, P4,
P5, P6, P10, L1, L2, the beginner and P1, with P1 and L2 measured on the slice (boxing v BJJ, real ladder states from
`simulateLadder`). Both take `per=`/`seed=` (protocol: per=200 seed=500000000) and exit 0 on a pass, 1 on a fail.

The page keeps a play log (every decision, its seconds, where the player stopped; `playlog.mjs`) and the verdict screen
has one **Copy play log** button so the owner can paste a bout back to us. The opening follows the first-10-minutes
script (plan section 3): two fighters to pick (two lines each: where he wins, his one rule), the first bout's first
volley is one card, and the verdict says in one line why the bout ended.

The old Arena rules and all pre-round-6 rule tests are retained under `proto/cardgame-legacy/` so the old test suite
remains runnable. The round-7 page does not load those rules. `out/r6core.*` and `out/r6b.*` are the round-6/6b measured
probes; `out/gate-play.*` and `out/gate-ship.*` are round 7's. The fixed bars and results are recorded in
`ops/research/DESIGN_CARDGAME_SCOPE.md` sections 4f, 6f, 6g and 6h.

This slice offers boxing and BJJ only. It intentionally does not ship the other five styles, asynchronous play,
animation or critic results. Round 7 passes the PLAY gate; the SHIP gate still fails four clauses (P2's points-blind,
P6's boxing mechanic, P10's boxing line and the beginner's two lines) — reported in 6h and handed to round 9's
hand-sizing, not tuned here.
