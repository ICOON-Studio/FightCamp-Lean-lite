# TASK BODYPICK1 (S217) - a boxer gets the MetaHuman body nearest his size (pure module + blind test)

Model: cloud Grok (label `grok`, opencode + XAI key) - FIRST TRIAL RUN of this seat. Branch `grok/issue-<n>` from master. Never master.

## Why
The fight now uses all 12 MetaHuman boxer bodies (9 men, 3 women) but picks one by a hash of the athlete id, so a 51 kg flyweight
can walk out in a 101 kg heavyweight body. Each body has a measured size (per-body JSON). Pick the body nearest the athlete's size.

## Do
New file `Godot/scripts/MetaHumanBodyPick.gd` (`extends RefCounted`, no preloads, no autoloads, no randomness):
```gdscript
## pool: Array of Dictionary {"path": String, "weight_kg": float, "height_cm": float}
## athlete: Dictionary - may hold "weight_kg" (float), "height_cm" (float) or "height_m" (float), "athlete_id" or "id" (String)
## avoid: a path that must not be returned if the pool has any other body (the opponent's body)
static func pick(pool: Array, athlete: Dictionary, avoid: String = "") -> String
```
Rules (the contract):
1. Empty pool -> "".
2. Athlete has a positive `weight_kg`: score each body `abs(bw - aw) / aw + 0.5 * abs(bh - ah) / ah` where `ah` is the athlete's
   height in cm (`height_cm`, or `height_m * 100`); with no height use the weight term only. Return the lowest score.
   Bodies whose score is within 0.03 of the best are a TIE: choose among them by `posmod(id.hash(), tie_count)` over the tied
   bodies in pool order (so two equal-size men still vary by identity, deterministically).
3. No usable weight: `pool[posmod(id.hash(), pool.size())]["path"]` (the old behaviour).
4. If the result equals `avoid` and the pool has another body, return the next-best by score (rule 2) or the next index (rule 3).
5. Never return a path that is not in the pool. Same inputs -> same output.

New test `Godot/tests/metahuman_body_pick_test.gd` (extends SceneTree; prints `METAHUMAN_BODY_PICK_TEST PASS (<n> checks)` or FAIL
lines; quits 0/1). Fixture = this exact pool (the real 12 bodies, from Godot/assets/models/metahuman/mh_boxer_NN.json):
men  01 76kg/183 · 02 63/174 · 03 72/179 · 04 94/190 · 05 51/164 · 06 54/170 · 07 61/177 · 08 81/186 · 09 101/195
women 10 51/162 · 11 60/169 · 12 70/178 (paths `res://assets/models/metahuman/mh_boxer_NN.glb`).
Checks: a 51 kg/165 cm man -> 05; a 100 kg/196 cm man -> 09; a 71 kg/180 cm man -> 03; men pool only, an 81 kg/186 cm man with
avoid=08 -> not 08 and the next-best (01 or 04 by score - compute it); a 60 kg woman (women pool) -> 11; empty pool -> "";
no weight -> the hash rule; determinism over 200 ids; every one of 300 random-but-seeded athletes (seeded RandomNumberGenerator
IN THE TEST only, weights 48-110) gets a body whose weight is within 15 kg of his own whenever one exists in the pool;
a mutant check inside the test (score by height only) gives a different answer for at least one case (proves weight matters).

## Run (CI has Godot; pure, no LFS)
`python Godot/tools/check_scripts.py Godot/scripts/MetaHumanBodyPick.gd Godot/tests/metahuman_body_pick_test.gd`
`godot --headless --path Godot --script tests/metahuman_body_pick_test.gd`

## Owned files
- Godot/scripts/MetaHumanBodyPick.gd (new)
- Godot/tests/metahuman_body_pick_test.gd (new)
Claude wires it into FightWorldStage.model_for_skin after merge - do NOT edit FightWorldStage.gd.

## Prior research
MH4_DIGEST.md (the 12-body cast, sizes); FightWorldStage.gd `model_for_skin` (the current hash pick, S217 men/women pools).

## What would a human do?
A casting director gives the heavyweight the big actor and the flyweight the small one; among equals, variety.

## Prefab check
None - 30 lines of internal casting logic.

## The one trap
GDScript: `abs()` returns Variant on mixed types - use `absf`; typed `Array`/`Dictionary` access needs explicit casts
(`float(d["weight_kg"])`); `posmod` for non-negative modulo. Never delete or loosen a test; Claude reads the CI log.
