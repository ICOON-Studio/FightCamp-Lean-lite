# C48 digest

C48 found that NC is not a missing string; it is a missing fourth result across the settlement graph. The live path maps empty `winner_side` to draw (`GameState.gd:11319-11323`), `_apply_fight_result` defaults missing results to loss (`:11478`), and the Grand Prix treats every non-win as opponent victory/elimination (`:8867-8952`). World watched and auto-resolved paths are W/L-only (`WorldPopulation.gd:968-1008`, `:1659-1697`).

The cheapest honest build is an additive explicit `no_contest` type, with no winner, no W/L/D/ranking/belt mutation, but with physical mileage preserved. `technical_decision` is scored and wraps the existing card outcome. The build-facing seam list is in `C48_THE_RESULT_THAT_IS_NOT.md`; the result evidence is ABC MMA/boxing and Nevada NAC 467.579/.770. No tests or parse gate were run.
