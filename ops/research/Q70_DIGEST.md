# Q70 DIGEST

Catalogue commit: c3474a8. 86 kicks found, 59 unlocated (sim resolver DRAW).

Adjudication: body=38, leg=18, spread=16, head=14. Confidence: high=66, medium=19, low=1.

Arm mystery: FOUND. The 20% arm branch in `_pick_target_region` is dead code.
The active pipeline (FightRealtime → FightMoves._regions_for) never produces
arm regions. The old pipeline (FightSimulation._technique_target_region) can
return arms but is not called by FightRealtime.

Reconcile vs R137's 107: 86 in current catalogue (c3474a8). 21-kick gap is
catalogue shrink + stricter classifier (Q70 requires kick_damage or "kick" in
id; R137 likely included discipline-context kicks with only generic `damage`).

Files: research/Q70_KICK_TARGETS.md, research/Q70_kick_targets.json.
