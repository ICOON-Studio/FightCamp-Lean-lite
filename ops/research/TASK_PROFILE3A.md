# TASK PROFILE3A - technique tree states for the fighter profile (pure module + blind test)

Model: Arena (cloud, pure module + test). Repo: ICOON-Studio/FightCamp, branch from master. Approved: operator board Q-S204-3
"yes build PROFILE3" (Ludo r39 s1 ADAPT + r40 section A.2 display states).

## What it is
The profile's TECHNIQUES tab shows the real 54-node boxing tree (Godot/assets/data/technique_catalog.json, discipline "boxing",
`nodes`). Every node is drawn in exactly one STATE. This task builds only the rules that decide the state and the text the row
shows; the screen comes later.

## Data you read (shapes, verified on master)
- Catalogue node: {"id": "boxing_lead_hook", "name": "Lead Hook", "kind": "move"|"skill"|"sequence", "tier": 1..4,
  "branch": "fundamentals"|"straight_punching"|"hooks_bodywork"|"defense_counters"|"footwork_ring"|"combinations"|"infighting",
  "requires": {"attributes": {"power": 30, "technique": 30}, "prerequisites": ["boxing_one_two"], "reps": 112}, ...}
- Fighter attributes: Dictionary of the sim keys (power, technique, speed, defense, conditioning, fight_iq, grapple, ...) 0-100.
- Fighter progress (athlete["technique_progress"]): {node_id: {"reps_completed": int, "weeks_trained": int, "learned": bool,
  "learned_week": int, ...}} - a missing id = never trained.
- Certified list: Array of node ids (Godot/assets/data/certified_moves.json boxing.strikes + boxing.guards).
- Assignments: {node_id: {"station": String, "hours_per_week": float}} - what the training plan has the fighter drilling.

## Spec - NEW `Godot/scripts/rules/TechniqueTree.gd`, `extends RefCounted`, `class_name TechniqueTree`, static funcs only
PURE: no preload/load, no GameState, no Node, no file access, no randomness; never mutate an argument (deep-copy).
States (String constants): "locked", "available", "learning", "learned", "not_in_build".
1. `static func node_state(node: Dictionary, attrs: Dictionary, progress: Dictionary, certified: Array, assignments: Dictionary,
   demo: bool) -> Dictionary` returns {"id","name","tier","branch","state","certified": bool, "missing": Array of Strings,
   "learn_pct": float 0..1, "learned_week": int (-1 if not learned), "station": String, "hours_per_week": float}:
   - learned (progress[id].learned true) -> "learned" ALWAYS (learning is permanent, even if attributes later drop).
   - else, NOT IN THIS BUILD: `demo` true AND node.kind == "move" or "sequence" AND id not in certified -> "not_in_build".
     ("skill" nodes - stance, footwork concepts, guards that are not clips - are never "not_in_build".)
   - else missing = one String per unmet requirement, in this order: each prerequisite id not learned as
     "needs <prerequisite NAME>" (look the name up in the `nodes_by_id` given - see 2; fall back to the id), then each attribute
     below its minimum as "needs <attr> <min> (has <value>)". Non-empty -> "locked".
   - else assignments has the id -> "learning"; otherwise -> "available".
   - learn_pct = clamp(reps_completed / requires.reps, 0, 1) when requires.reps > 0, else 0.0 (learned -> 1.0).
2. `static func index(nodes: Array) -> Dictionary` id -> node (deep copies). node_state takes an optional last parameter
   `nodes_by_id: Dictionary = {}` used only for prerequisite names.
3. `static func tree(nodes: Array, attrs: Dictionary, progress: Dictionary, certified: Array, assignments: Dictionary, demo: bool,
   branch_order: Array) -> Array` -> one entry per branch in `branch_order` that has nodes: {"branch", "rows": Array of node_state
   results sorted by tier then name, "learned": int, "total": int}. Nodes whose branch is not in branch_order go in a final
   "other" entry.
4. `static func summary(tree_rows: Array) -> Dictionary` -> {"learned": int, "total": int, "line": "LEARNED %d / %d"}.
5. `static func next_to_learn(tree_rows: Array, limit: int = 3) -> Array` -> ids of "available" nodes, lowest tier first, then
   highest learn_pct, then name; at most `limit`.
6. `static func stage_camera(node: Dictionary) -> String` -> "low" when the id contains "body" or "liver", "side" when it contains
   "hook" or "uppercut" (and not body), else "front34". (The 3D stage frames each move this way - Ludo r39.)
7. PLAN WEIGHTS: const WEIGHTS := ["primary", "situational", "suppressed"]; `static func can_weight(row: Dictionary) -> bool` true
   only for state "learned" (you can only plan with what he has learned).

## Test - NEW `Godot/tests/technique_tree_test.gd` (extends SceneTree, `_initialize()`, prints `TECHNIQUE_TREE total=N fails=M`,
quit(1) on any fail; reference the module with `const TechniqueTree = preload("res://scripts/rules/TechniqueTree.gd")`).
Write it from THIS contract (blind). Load the REAL catalogue in the test (FileAccess.get_file_as_string on
res://assets/data/technique_catalog.json, JSON.parse_string) so the 54 nodes are real; certified ids as a literal copied from
certified_moves.json. TWO DIFFERENT fighters (never identical): a novice (all attributes 25, nothing learned) and a veteran
(power 40, technique 42, speed 38, defense 36, conditioning 35, fight_iq 37; learned: stance_guard, jab, cross, one_two, slip).
Checks at least: 54 nodes, 7 branches in order; novice: boxing_stance_guard "locked"? (it needs defense 22 - novice has 25 ->
"available"), boxing_jab "locked" with "needs Stance and High Guard"; veteran: boxing_jab "learned", boxing_lead_hook
"available" (one_two learned, power/technique met), boxing_overhand (uncertified? check the list - it IS certified) ...;
demo=true makes an uncertified "move" node (pick one from the real data, e.g. boxing_shovel_hook) "not_in_build" while demo=false
makes it "locked"/"available"; a "skill" node is never not_in_build; a learned node stays "learned" when attributes drop to 0;
learning + learn_pct with an assignment and reps; missing-list ORDER; summary line; next_to_learn order and limit;
stage_camera for body hook / rear hook / jab; can_weight; no argument mutated (deep compare before/after);
an inline MUTANT (the attribute check with `>` instead of `>=`) must fail one of your checks; a source scan of TechniqueTree.gd
for "preload", "load(", "GameState", "randf", "randi", "RandomNumberGenerator", "FileAccess" (must be absent).

## Owned files
Godot/scripts/rules/TechniqueTree.gd (new), Godot/tests/technique_tree_test.gd (new). Nothing else.

## Gate
Parse: `python Godot/tools/check_scripts.py Godot/scripts/rules/TechniqueTree.gd Godot/tests/technique_tree_test.gd`
Run: `godot --headless --path Godot --script tests/technique_tree_test.gd` -> `TECHNIQUE_TREE total=N fails=0`. CI on your PR green.
Work ONLY on your own arena/* branch; open the PR yourself; never merge, never touch master, never delete or shrink a test.
GDScript 4 syntax: `const`, never `static const`; `for x in arr`, never `for var x`; `dict.has(k)`; `dict.is_empty()`;
FileAccess.get_file_as_string, not File; String.find, not search; a SceneTree test uses `_initialize()`, not `_ready()`.

## Prior research
Ludo r40 section A.2 (the 5 display states) - but Ludo's A.3 prerequisite table is INVENTED: use the catalogue's own requires.
ProfileTechniques.gd (existing groups/summary/next_unlocks - this module supersedes it for the new screen; do not edit it).

## What would a human do?
Football Manager's attribute/trait screens: a rules layer decides each item's status and the reason text, the UI only paints it.

## Prefab check
None - our catalogue format; ~150 lines of GDScript.

## The one trap
"skill" nodes (Stance and High Guard, Breathing, Finding the Range, Parry, Slip...) are not animation clips: treating every
uncertified node as "not in this build" would lock the whole tree in the demo, because the Jab needs Stance and High Guard.
