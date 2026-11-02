# TASK TECHSEED1A - the techniques a fighter already knows when he enters the game (pure module + blind test)

Model: Qwen (cloud seat, issue label `qwen`). Repo ICOON-Studio/FightCamp, branch qwen/issue-<n>, PR into master; never merge.
Found S206 on the profile stills: fighters enter the world with an EMPTY `technique_progress`, so an experienced boxer's TECHNIQUES tab
reads "LEARNED 0 / 54" with even the Jab locked. A fighter's existing skill must show. This task is ONLY the pure rule; wiring it into
world generation / signing (GameState) is a later Claude task.

## Data (read, do not edit)
- Catalogue: `Godot/assets/data/technique_catalog.json`, discipline "boxing", `nodes`: {"id", "name", "tier" 1..4, "branch",
  "kind", "requires": {"attributes": {stat: min}, "prerequisites": [ids], "reps": n}}.
- A fighter: `stats` {power, technique, speed, defense, conditioning, fight_iq, ...} 0-100; `specialties` {discipline: 0-100} (how
  skilled he is in each art, e.g. {"boxing": 72}); `record` {wins, losses, draws}; `age`.
- A progress entry when learned: {"reps_completed": <node reps>, "weeks_trained": 0, "last_trained_week": -1,
  "live_rounds_completed": 0, "learned": true, "learned_week": 0} (the shape `Godot/scripts/AthleteDevelopment.gd` train_technique
  writes - open lines 320-380 to confirm, do not edit).

## Spec - NEW `Godot/scripts/rules/TechniqueSeed.gd` (`extends RefCounted`, `class_name TechniqueSeed`, static, PURE: no preload/
load, no GameState, no Node, no files, no randomness; never mutate arguments)
1. `static func tier_cap(specialty: int, bouts: int) -> int` - the highest tier a fighter of this skill and experience knows:
   specialty < 20 -> 0 (knows nothing); 20-39 -> 1; 40-59 -> 2; 60-79 -> 3; >= 80 -> 4; then experience caps it: bouts < 3 -> at
   most 1; bouts < 10 -> at most 2; bouts < 25 -> at most 3 (bouts = wins + losses + draws). Exception: specialty >= 60 with 0 bouts
   (a strong amateur pedigree recorded only as specialty) -> at most 2.
2. `static func seed(nodes: Array, stats: Dictionary, specialty: int, bouts: int) -> Dictionary` -> a NEW technique_progress
   dict: every node with tier <= tier_cap whose attribute minimums the stats meet AND whose prerequisites are all in the result
   (iterate to a fixed point, lowest tier first) gets the learned entry above. Nodes that fail stay out (not an "unlearned" entry).
3. `static func discipline_specialty(fighter: Dictionary, discipline: String) -> int` -> fighter.specialties[discipline] or 0.

## Test - NEW `Godot/tests/technique_seed_test.gd` (SceneTree `_initialize()`, prints `TECHNIQUE_SEED total=N fails=M`, quit(1) on
fail, `const TechniqueSeed = preload("res://scripts/rules/TechniqueSeed.gd")`). Blind, from this contract; load the REAL catalogue
in the test (FileAccess.get_file_as_string + JSON.parse_string). THREE DIFFERENT fighters (never identical): a karate specialist with
no boxing specialty (-> {} learned), a 6-bout boxer with specialty 55 and mid stats (-> only T1-T2, Stance and Jab included, no T3),
a 30-bout boxer with specialty 85 and high stats (-> includes T4 nodes whose stat minimums he meets). Checks at least: tier_cap table
incl. the amateur exception; every learned node's prerequisites are also learned (closure); every learned node's attribute minimums
are met; no node above tier_cap; entry shape exact; inputs not mutated; an inline MUTANT (prerequisite check skipped) must fail a
check; a source scan for preload / load( / GameState / randf / randi / Node / FileAccess in TechniqueSeed.gd (must be absent).

## Owned files
The two new files only. GDScript 4: `const` (never `static const`), `for x in arr`, `dict.has()`, `is_empty()`, `_initialize()`.
Gate: `python Godot/tools/check_scripts.py <both>`, then the test -> fails=0; CI green. Never delete or shrink a test. No LFS models.

## Prior research
TASK_PROFILE3A.md (tree states), AthleteDevelopment.gd train_technique (the learned entry), S206 tab still (the defect).

## What would a human do?
A scout signing a 10-fight pro assumes he throws a jab, a cross and a hook already - you list what his level implies, not zero.

## Prefab check
None - 70 lines.

## The one trap
The catalogue lists nodes in no particular order - a single pass misses a node whose prerequisite comes later in the list;
iterate until nothing changes.
