# WEIGHT2V2CRIT - a code-checked critic of the weight map v2 (S535; inputs moved to probe round 4 in S536)

Kind: research. Model: Fable console in this checkout. Commit to main, push; touch only your file. RESEARCH ONLY - no game code
changes, do not run Godot.

## Your job
Read `ops/research/DESIGN_WEIGHT2_V2_CRITIC_KALLI.md` - it is the full critic brief (the game's critic pack, then the design
map WEIGHT2 v2). That brief's copy of the map is the ROUND 3 one: for the map itself read the current file
`ops/research/DESIGN_WEIGHT2_V2.md` (round 4: the "ROUND 4" note at the top, 3.1, 3.2, 3.5, section 4.6, risks 8 to 10). Do exactly what it asks (scores for DEPTH / GENERAL DESIGN / PLAY, missing / useless options, "To reach 10/10"
list, your 10/10 page described), with THREE additions no chat critic can do:

1. CHECK EVERY "CODE" CLAIM in the map (`ops/research/DESIGN_WEIGHT2_V2.md` sections 1, 3 and 5: every `File.gd:line`)
   against the repo (scripts/rules, scripts/state, scripts/ui, scripts/world, scripts/fight3d/v2/ArmBuild.gd). For each claim:
   TRUE (file + function + line) / FALSE (what the code really does) / NOT FOUND. A map whose CODE lines are false cannot be
   built as written - say which. Do not cite by line the files that carry other sessions' uncommitted edits (LineGrade.gd,
   LiveRound.gd, StepWire.gd, MHRig.gd, Player2.gd). Claims about branch `s535/dmgfix` (men's 65 kg, `pro_rules`): check with
   `git grep -n <word> s535/dmgfix -- <file>`, never by switching branch.
2. CHECK EVERY NUMBER tagged SOURCED / DERIVED / ESTIMATE / NOT FOUND in the map's section 2 and 3 against John's own line in
   `ops/research/JOHN_WEIGHT2_RESEARCH_JOHN.md`: SAME / CHANGED (his number, the map's number) / TAG CHANGED / NOT IN JOHN.
3. CHECK THE PROBE against the map: read `tools/weight2_probe.gd` (SCALES, MODEL, _walk, _setup, _run, _fit, _best, _diff,
   _ties) and `docs/WEIGHT2_PROBE4.md` (round 4, 40 seeds; `docs/WEIGHT2_PROBE3.md` is the round before, for the change).
   Does the probe's model do what section 3 says (the free 2 %, the per-scale costs, CUT harder as 4 % of body by water, the
   amateur regain as a share of body mass and the pro's as a share of the water he took off, the diet's weeks and the training
   kept, the walkover, two misses, the refusal and the wait)? Does section 4.6 report the tables honestly (ties called ties,
   what the amateur result rests on, DOWN best in no cell, what was not probed)? Check the five PASS bars against the output
   yourself. Name anything the probe makes true by construction (start with: the pro field rings 7.2 % over the line and STAY
   on it; the cutter's CUT is her STAY; the regain divisor of 8 %).

## Deliverable
ONE new file `ops/research/DESIGN_WEIGHT2_V2_CRITIC_FABLE.md`: the scores (the bar is 8 DEPTH and 8 PLAY, owner S534), the
code-claim table, the number table, the probe check, the 10/10 list (most important first, specific enough to build). At the
end of the file: the list of code files you opened.

## Prior research
`DESIGN_WEIGHT2.md` (v1 and probe rounds 1 and 2), `DESIGN_DMGCLASS1_V3_CRITIC_FABLE.md` (the form of this review),
`DEPTH_AUDIT_S534.md` (five maps passed critics and failed when measured: score what is measured, not what is promised).

## What would a human do?
Open every cited line before believing a sentence about it, and score the mechanic the player would get, not the paragraph.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_WEIGHT2_V2_CRITIC_FABLE.md
RED_TEST: none (research). REGRESSION: none. VISUAL: no
