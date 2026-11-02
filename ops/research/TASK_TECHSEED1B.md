# TASK TECHSEED1B - fighters enter the world knowing the techniques their level implies (wire TechniqueSeed into GameState)

Model: Arena (cloud). Repo ICOON-Studio/FightCamp, branch from master, your own arena/* branch, PR into master; never merge.
Builds on TECHSEED1A (merged today): `Godot/scripts/rules/TechniqueSeed.gd` - `tier_cap(specialty, bouts)`,
`seed(nodes, stats, specialty, bouts) -> technique_progress`, `discipline_specialty(fighter, discipline)`. Read it first (69 lines).
Found S206 on the profile stills: every fighter enters the world with an EMPTY `technique_progress`, so an experienced boxer's
TECHNIQUES tab reads "LEARNED 0 / 54" with the Jab locked.

## Spec - `Godot/scripts/GameState.gd` (~19k lines - NEVER read it whole; use only these windows)
1. NEW func near `ensure_world_population` (`sed -n 355,395p`):
   `func seed_world_techniques(population: Dictionary) -> bool` - for every athlete in `population["athletes"]` whose
   `technique_progress` is missing or EMPTY: `athlete["technique_progress"] = TechniqueSeed.seed(boxing_nodes, athlete["stats"],
   TechniqueSeed.discipline_specialty(athlete, "boxing"), wins + losses + draws from athlete["record"])`. NEVER touch a non-empty
   progress (the player's training history wins). Returns true when anything changed. The boxing nodes come from
   `res://assets/data/technique_catalog.json` (discipline id "boxing", key "nodes") - load once into a member var with the existing
   `_load_json_dictionary` (`sed -n 336,345p`). Only the boxing tree is seeded (the demo is boxing; other arts later).
2. Call it in the THREE places a world appears: (a) `ensure_world_population` after the featured/organization merges on a loaded
   save (OR the result into `changed`); (b) right after `career["simulation_world"] = WorldPopulation.generate(...)` in
   `ensure_world_population` (~379); (c) the same right after the generate call in the new-career path (`sed -n 3555,3575p`).
3. The player's own starter fighters (the `starter` dicts built just above window (c)) get the same rule when their progress is
   empty - call the same seeding for each starter before it is stored.
4. Signing a fighter from the world into the roster already preserves `technique_progress` (GameState ~9500 preserved keys list) -
   do not change that.

## Test - NEW `Godot/tests/technique_seed_world_test.gd` (SceneTree `_initialize()`, prints `TECHNIQUE_SEED_WORLD total=N fails=M`,
quit(1) on fail). Use the real GameState autoload the way other world tests do (find one: `grep -ln "ensure_world_population\|
begin_new_career" Godot/tests/*.gd | head`). Checks: after a new career, at least one world boxer with boxing specialty >= 40 and
>= 3 bouts has a non-empty progress including boxing_stance_guard and boxing_jab; a world athlete with no boxing specialty has an
empty boxing progress; a fighter whose progress was set by hand (one learned node) is NOT overwritten after
ensure_world_population runs again; seeding is deterministic (two runs of the same seed give identical progress for the same id).
Make it RED on master first (no seeding), then green.

## Owned files
Godot/scripts/GameState.gd (only the new func, its member var and the three/four call sites), new
Godot/tests/technique_seed_world_test.gd. Nothing else.

## Gate
`python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/technique_seed_world_test.gd`, then
`godot --headless --path Godot --script tests/technique_seed_world_test.gd` -> fails=0; CI green on the PR (it also runs the changed
tests). GDScript 4: type every Variant read (`var n: int = int(...)`), `const` not `static const`, `for x in arr`, `dict.has()`.
Never delete or shrink an existing test.

## Prior research
TASK_TECHSEED1A.md, TechniqueSeed.gd, TASK_PROFILE3A.md (the tree states the profile shows).

## What would a human do?
When a pro signs, the gym assumes he can already throw the punches his record shows - you only teach him what is new.

## Prefab check
None.

## The one trap
`ensure_world_population` runs on EVERY world access - the seeding must be a no-op for anyone who already has progress, or it
would overwrite training the player paid for.
