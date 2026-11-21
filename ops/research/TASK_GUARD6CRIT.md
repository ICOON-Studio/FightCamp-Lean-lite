# GUARD6CRIT - a code-checked critic of the guard damage map v6 (S534)

Kind: research. Model: Arena (cloud, lite mirror). Your own arena/ branch, a PR into main; never merge. RESEARCH ONLY - no game
code changes, do not run Godot.

## Your job
Read `ops/research/DESIGN_GUARDDMG1_V6_CRITIC_KALLI.md` - it is the full critic brief (the game's critic pack, then the design
map GUARDDMG1 v6). Do exactly what it asks (scores for DEPTH / GENERAL DESIGN / PLAY, missing / useless options, "To reach 10/10"
list, your 10/10 page described), with ONE addition no chat critic can do: CHECK EVERY "CODE" CLAIM in the map against the repo
(scripts/rules, scripts/state, scripts/ui). For each claim: TRUE (file + function + line) / FALSE (what the code really does) /
NOT FOUND. Above all check the map's core: where the exchange is settled today, and whether a Hands setting before settle
can be built as the map says. A map whose CODE lines are false cannot be built as written - say which. If a claim shows a live
game defect (the game wrong against its own rule), list it first.

## Deliverable
ONE new file `ops/research/DESIGN_GUARDDMG1_V6_CRITIC_ARENA.md`: the scores, the claim table, the 10/10 list. PR body: the list
of code files you opened.

## Contract
OWNS: ops/research/DESIGN_GUARDDMG1_V6_CRITIC_ARENA.md
RED_TEST: none (research). REGRESSION: none. VISUAL: no
