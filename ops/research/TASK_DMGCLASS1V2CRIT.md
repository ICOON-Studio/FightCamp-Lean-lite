# DMGCLASS1V2CRIT - a code-checked critic of the damage classes map v2 (S534, Goose #433 failed)

Kind: research. Model: Fable console in this checkout (owner S534 "dont wait on arena"). Commit to main, push; touch only your file. RESEARCH ONLY - no game code changes,
do not run Godot.

## Your job
Read `ops/research/DESIGN_DMGCLASS1_V2_CRITIC_KALLI.md` - it is the full critic brief (the game's critic pack, then the design
map DMGCLASS1 v2). Do exactly what it asks (scores for DEPTH / GENERAL DESIGN / PLAY, missing / useless options, "To reach 10/10"
list, your 10/10 page described), with ONE addition no chat critic can do: CHECK EVERY "CODE" CLAIM in the map against the repo
(scripts/rules, scripts/state, scripts/ui). For each claim: TRUE (file + function + line) / FALSE (what the code really does) /
NOT FOUND. A map whose CODE lines are false cannot be built as written - say which.

## Deliverable
ONE new file `ops/research/DESIGN_DMGCLASS1_V2_CRITIC_FABLE.md`: the scores, the claim table, the 10/10 list. At the end of the file: the list
of code files you opened.

## Contract
OWNS: ops/research/DESIGN_DMGCLASS1_V2_CRITIC_FABLE.md
RED_TEST: none (research). REGRESSION: none. VISUAL: no

