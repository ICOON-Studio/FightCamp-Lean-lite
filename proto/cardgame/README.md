# FightCamp card ladder — round 6

The playable page is `index.html` + `ui.js` + `ui-helpers.js`. It imports the measured cardscope5 port (`cards.mjs`, `sized.json`, `engine.mjs`, `plan.mjs`) and the career layer in `career.mjs`. Browser code uses ES modules and a static HTTP server; do not open the page from `file://` because JSON module imports are blocked by browser origin policy.

## Run and test

```sh
node --test proto/cardgame/engine.test.mjs
node proto/cardgame-legacy/rules.test.mjs
node proto/cardgame/probe.mjs all per=200 seed=500000000 tag=r6core
node proto/cardgame/ladder-probe.mjs
```

The old Arena rules and all pre-round-6 rule tests are retained under `proto/cardgame-legacy/` so the old test suite remains runnable. The round-6 page does not load those rules. The old card tables/balance scripts remain archival only. `out/r6core.txt` and `.json` are the round-6 measured core probe; the fixed bars and result are recorded in `ops/research/DESIGN_CARDGAME_SCOPE.md` sections 4f and 6f.

This slice offers boxing and BJJ only. It intentionally does not ship the other five styles, asynchronous play, animation or critic results. Round-6 probes fail multiple fixed bars; this is not marked ready for owner play. Visual screenshots were not produced in the Linux workspace because the repository renderer requires Windows Edge and this environment has no browser executable.
