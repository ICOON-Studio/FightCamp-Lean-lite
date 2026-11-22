# WEIGHT2V2CRIT - a code-checked critic of the weight map v2 (S535; inputs moved to probe round 5 in S536)

Kind: research. Model: Fable console in this checkout. Commit to main, push; touch only your file. RESEARCH ONLY - no game code
changes, do not run Godot.

## Your job
Read `ops/research/DESIGN_WEIGHT2_V2_CRITIC_KALLI.md` - it is the full critic brief (the game's critic pack, then the design
map WEIGHT2 v2). That brief's copy of the map is the ROUND 3 one: for the map itself read the current file
`ops/research/DESIGN_WEIGHT2_V2.md` (round 5: the "ROUND 5" note at the top, section 4.7, the risks it adds; round 4 is the note above it and 4.6). You are a FRESH critic:
do not open the round 4 critics (`DESIGN_WEIGHT2_V2_CRITIC_FABLE.md`, `DESIGN_WEIGHT2_V2_CRITIC_KALLI_KALLI.md`) before you have scored. Do exactly what it asks (scores for DEPTH / GENERAL DESIGN / PLAY, missing / useless options, "To reach 10/10"
list, your 10/10 page described), with THREE additions no chat critic can do:

1. CHECK EVERY "CODE" CLAIM in the map (`ops/research/DESIGN_WEIGHT2_V2.md` sections 1, 3 and 5: every `File.gd:line`)
   against the repo (scripts/rules, scripts/state, scripts/ui, scripts/world, scripts/fight3d/v2/ArmBuild.gd). For each claim:
   TRUE (file + function + line) / FALSE (what the code really does) / NOT FOUND. A map whose CODE lines are false cannot be
   built as written - say which. Do not cite by line the files that carry other sessions' uncommitted edits (LineGrade.gd,
   LiveRound.gd, StepWire.gd, MHRig.gd, Player2.gd). Claims about branch `s535/dmgfix` (men's 65 kg, `pro_rules`): check with
   `git grep -n <word> s535/dmgfix -- <file>`, never by switching branch.
2. CHECK EVERY NUMBER tagged SOURCED / DERIVED / ESTIMATE / NOT FOUND in the map's section 2 and 3 against John's own line in
   `ops/research/JOHN_WEIGHT2_RESEARCH_JOHN.md`: SAME / CHANGED (his number, the map's number) / TAG CHANGED / NOT IN JOHN.
3. CHECK THE PROBE against the map: round 5's probe is three files - `tools/weight2_model.gd` (SCALES, MODEL, plan_choice,
   plan_policy, cost, night, bout, run, best, diff, ties), `tools/weight2_probe.gd` (_fit and round 4's tables) and
   `tools/weight2_round5.gd` (policy, frame, field, scales) - and its output is `docs/WEIGHT2_PROBE5.md`
   (`docs/WEIGHT2_PROBE4.md` is the round before, for the change).
   Does the probe's model do what section 3 says (the free 2 %, the per-scale costs, CUT harder as 4 % of body by water, the
   amateur regain as a share of body mass and the pro's as a share of the water he took off, the diet's weeks and the training
   kept, the walkover, two misses, the refusal and the wait)? Does section 4.7 (round 5: FAIL) report the tables honestly (ties called ties,
   what the amateur result rests on, DOWN best in no cell, what was not probed)? Check the PASS bars against the output
   yourself (round 4's five as shares of 15 cells, item 1's policy bar, item 2's frame bar: they are written at the top of
   the output, before the tables). Round 5 adds four things to check: water first up to the free 2 % and the SAME kilos by
   DIET / WATER / MIX / UP (section 5); the opponent's height and reach from the class boxed at, and the average worth of a
   class of frame taken back out of a move (section 0 and 6); the field's own cut, its fade and the tape read (section 7);
   the three scales - club show with the gap rule, championship weighed on each of three days, pro (section 8). Name
   anything the probe makes true by construction (start with: the field's cut spread and the fade line are estimates; a
   club-show opponent weighs 1 % under the line; the carry of 0.74 a boxing day; the regain divisor of 8 %).

## Deliverable
ONE new file `ops/research/DESIGN_WEIGHT2_V2_CRITIC_FABLE_R5.md`: the scores (the bar is 8 DEPTH and 8 PLAY, owner S534), the
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
OWNS: ops/research/DESIGN_WEIGHT2_V2_CRITIC_FABLE_R5.md
RED_TEST: none (research). REGRESSION: none. VISUAL: no
