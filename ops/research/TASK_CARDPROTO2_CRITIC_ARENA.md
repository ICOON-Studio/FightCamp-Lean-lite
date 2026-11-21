# TASK CARDPROTO2_CRITIC_ARENA - code-checked critic of the card-game prototype (round 2)

Repo FightCamp-Lean-lite, branch main. You are a FRESH critic, not the author. The only file you add: `ops/research/CARDPROTO2_CRITIC_ARENA.md`. Do not edit proto/. Open a PR.

1. Read `proto/cardgame/README.md`, then `rules.js`, `rules-data.js`, `rules-exchange.js`, `rules-ai.js`.
2. With node, play at least 20 bouts through the real rules (different boxer pairs; AI-vs-AI, random, "always the same card", "always the largest-damage card", and a reading policy that uses the public tell/film information) against the engine AI. Find out: is there a dominant strategy; how much does smart play beat random; do tells, film reads, React/Predict, camp and corner cards change decisions or are some inert (check that each described effect actually changes numbers); are any cards dominated or dead; do defence cards read sensibly; how long is a bout; how swingy is it; do the house rules hold (women never fight men; amateur bouts have a winner).
3. Write the file: scores 0-10 for DEPTH, PLAY (fun), GENERAL; the evidence (numbers from your own runs); missing cards/options; useless cards; then THE ORDERED LIST "TO REACH 10/10" (most important first, specific: card names, numbers, rules). The bar to keep the mechanic is 8+ on DEPTH and 8+ on PLAY, so be honest, not kind.
4. Do not delete or weaken any test. Run `node proto/cardgame/rules.test.mjs` and `node proto/cardgame/rules.round2.test.mjs`; RESULT lines in the PR body.
