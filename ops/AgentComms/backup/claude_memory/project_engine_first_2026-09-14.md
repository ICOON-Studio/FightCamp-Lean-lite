---
name: project_engine_first_2026-09-14
description: "Operator 2026-09-14 night chose ENGINE FIRST: the engine must simulate ring position + cage, stances, real dodges, feints/commitment, between-exchange behaviour before any more clips; the Higgsfield catalog is paused, templates may be adjusted"
metadata: 
  node_type: memory
  type: project
  originSessionId: 5a7d1b2f-c085-4027-8915-a7f0e2ac0dd7
  modified: 2026-09-14T21:00:59.539Z
---

Operator decision, 2026-09-14 near midnight (HANDOFF Direction notes top entry; roadmap `now` = S4e). Asked verbatim "Do you
think we should stop this and focus more on the [engine] because I think no it lacks to simulate positioning stances dodges
etc", Claude agreed and the operator chose the option **"Engine first (Recommended)"**.

What the engine lacked, read from code that night: FightRealtime.gd HAS 2D fixed-point positions (pos_x/pos_y,
`position_of` :644) and FightFootwork close/retreat/circle/hold throttles, but no cage or ring edge was found; no
orthodox/southpaw or stance switch in the real-time engine ('southpaw' only in BalanceState, FightSimulation, FightStageDirector);
a slip exists only as a punch OUTCOME (CONTACT_SLIPPED :119); feints and range-finders resolve as strikes that land (C132);
earlier: slips reach the screen 0.3%, a block never fired in nine bouts; the room shows a gap on one line, not positions.

Same night, before it: the operator's direction to build "a modular catalog of single-actor actions, reactions, and looped
states" assembled by Godot code (two pasted recipes, verbatim in `research/OPERATOR_HIGGSFIELD_CATALOG_RECIPE_2026-09-14.md`),
and after Claude's corrections: "You are free to adjust the templates if you want to for better result, and we continue with
your adjustments". That catalog is PAUSED behind the engine stage, not cancelled.

**Why:** the 3D room can only show what the engine decides; clips for dodges or bounces the engine never calls are waste.
**How to apply:** S4e first - day one assign the research (Codex engine audit, footage rates from the kept tracks, Kalli/John
statistics by position), then build each behaviour with a realism rule, then feed positions/facing into the room, then resume
the catalog (A/B of templates as written v adjusted, one action per job). Never re-ask engine-v-clips. Related:
[[reference_higgsfield]], [[project_higgsfield_mma_study]], [[feedback_assess_pasted_recipes]], [[feedback_ground_tests_in_real_studies]].
