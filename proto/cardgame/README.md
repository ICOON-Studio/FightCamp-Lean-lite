# FightCamp card ladder — round 6b

The playable page is `index.html` + `ui.js` + `ui-text.mjs` (pure card text) + `ui-helpers.js`. It imports the measured cardscope5 port (`cards.mjs`, `sized.json`, `engine.mjs`, `plan.mjs`) and the career layer in `career.mjs`. Browser code uses ES modules and a static HTTP server; do not open the page from `file://` because JSON module imports are blocked by browser origin policy. `ui.test.mjs` plays the page through the stub document in `uidom.mjs`.

## Run and test

```sh
node --test "proto/cardgame/*.test.mjs"      # engine, page and ladder tests (36)
node proto/cardgame-legacy/rules.test.mjs     # the retained pre-round-6 rules (32 checks)
node proto/cardgame/probe.mjs all per=200 seed=500000000 tag=r6b   # the fixed bars, out/r6b.{txt,json}
node proto/cardgame/ladder-probe.mjs          # L1 and L2 on the ladder's own states, out/r6ladder.json
```

The old Arena rules and all pre-round-6 rule tests are retained under `proto/cardgame-legacy/` so the old test suite remains runnable. The round-6 page does not load those rules. The old card tables/balance scripts remain archival only. `out/r6core.*` is the round-6 measured core probe; `out/r6b.*` and `out/r6ladder.json` are round 6b's; the fixed bars and results are recorded in `ops/research/DESIGN_CARDGAME_SCOPE.md` sections 4f, 6f and 6g.

This slice offers boxing and BJJ only. It intentionally does not ship the other five styles, asynchronous play, animation or critic results. Round-6b probes still fail three fixed clauses (P2's points clock, P4 at the protocol seed, P6's boxing mechanic); this is not marked ready for owner play. Visual screenshots were not produced in the Linux workspace because the repository renderer requires Windows Edge and this environment has no browser executable.
