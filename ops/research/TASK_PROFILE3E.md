# TASK PROFILE3E - fight-plan technique weights (PRIMARY / SITUATIONAL / SUPPRESSED) as a pure module + blind test

Model: Arena (cloud, pure module + test). Repo ICOON-Studio/FightCamp, branch from master, your own arena/* branch, PR into master;
never merge. Approved: operator board Q-S204-3 "yes build PROFILE3" (Ludo r39 s1 decision 2: the profile's technique rows carry a
fight-plan weight; Claude's verdict: it writes into the EXISTING fight plan, never a second plan system).

## What exists (read, do not edit)
- `Godot/scripts/FightPlanSetup.gd` (242 lines): the fight plan = five sliders (range, pace, target, grappling, risk), each -1..1.
  It has NO per-technique weights - this task adds them as a separate, small layer the sim can read later.
- `Godot/scripts/rules/TechniqueTree.gd` (merged today): `can_weight(row)` is true only for LEARNED techniques; `const WEIGHTS :=
  ["primary", "situational", "suppressed"]`.
- Technique catalogue nodes (`Godot/assets/data/technique_catalog.json`, discipline boxing) carry `match.usage` (a float, e.g. 1.56)
  - the sim's base selection weight for that technique.

## Spec - NEW `Godot/scripts/rules/PlanWeights.gd` (`extends RefCounted`, `class_name PlanWeights`, static funcs, PURE: no preload/
load, no GameState, no Node, no files, no randomness; never mutate arguments - return new values)
`const MULTIPLIER := {"primary": 1.5, "situational": 1.0, "suppressed": 0.25}` (Claude's tunable defaults: a suppressed punch is
rare, never impossible - a perfect opening still gets taken). `const DEFAULT := "situational"`. `const MAX_PRIMARY := 3`.
1. `static func set_weight(weights: Dictionary, technique_id: String, weight: String, learned_ids: Array) -> Dictionary` ->
   {"ok": bool, "reason": String, "weights": Dictionary (new)}. Refuse (ok false, weights unchanged) when: weight not in MULTIPLIER
   ("UNKNOWN WEIGHT"), technique not in learned_ids ("NOT LEARNED YET"), or it would make a 4th "primary" ("THREE PRIMARIES MAX -
   demote one first"). Setting "situational" REMOVES the key (default is implicit).
2. `static func weight_of(weights: Dictionary, technique_id: String) -> String` -> stored weight or DEFAULT.
3. `static func apply(usage: Dictionary, weights: Dictionary) -> Dictionary` - usage = {technique_id: base usage float}; returns a
   new dict with each value multiplied by its weight's MULTIPLIER; ids in weights but not in usage are ignored.
4. `static func share(usage_after: Dictionary, technique_id: String) -> float` - that technique's fraction of the total (0..1; 0 when
   the total is 0) - what the profile row can show as "about 1 in N punches".
5. `static func prune(weights: Dictionary, learned_ids: Array) -> Dictionary` - drop entries for techniques no longer in learned_ids.

## Test - NEW `Godot/tests/plan_weights_test.gd` (SceneTree `_initialize()`, prints `PLAN_WEIGHTS total=N fails=M`, quit(1) on fail,
`const PlanWeights = preload("res://scripts/rules/PlanWeights.gd")`). Blind, from this contract. Two DIFFERENT fighters as literal
learned lists + usage tables (copy 6-8 real `match.usage` values for real ids from the catalogue, e.g. boxing_jab, boxing_cross,
boxing_one_two, boxing_lead_hook, boxing_body_hook, boxing_slip_counter). Checks at least: each refusal reason; the 3-primary cap
(and that demoting one frees a slot); situational removes the key; weight_of default; apply multiplies exactly and ignores unknown
ids; share sums to 1.0 over all ids (1e-6) and is 0 for an empty table; suppressing the jab lowers its share but never to 0;
prune; inputs never mutated (deep compare before/after); an inline MUTANT (suppressed multiplier 0.0) must fail a check; a source
scan of PlanWeights.gd for preload / load( / GameState / randf / randi / Node / FileAccess (must be absent).

## Owned files
Godot/scripts/rules/PlanWeights.gd (new), Godot/tests/plan_weights_test.gd (new). Nothing else.

## Gate
`python Godot/tools/check_scripts.py Godot/scripts/rules/PlanWeights.gd Godot/tests/plan_weights_test.gd`, then
`godot --headless --path Godot --script tests/plan_weights_test.gd` -> `PLAN_WEIGHTS total=N fails=0`. CI green on the PR.
GDScript 4 syntax: `const` (never `static const`), `for x in arr` (never `for var x`), `dict.has()`, `is_empty()`,
`_initialize()` in SceneTree tests. Never delete or shrink an existing test. No LFS models.

## Prior research
LUDO_ROUND39_VERDICT_S205.md (decision 2 + "no second plan system"), LUDO_ROUND41_S206_reply1.txt s1.3 (the weight selector on
learned rows), FightPlanSetup.gd (the existing plan).

## What would a human do?
A corner tells his fighter "lead with the jab, keep the overhand for when he drops his hand" - a short list of favourites and
a few shots held back, never a ban.

## Prefab check
None - 60 lines.

## The one trap
"situational" is the DEFAULT - storing it makes every save carry 54 keys; it must remove the key instead.
