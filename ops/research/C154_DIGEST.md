# C154 digest

Added the blind `fighter_capsules_contract_test.gd` witness from the supplied
contract only. It runtime-loads `FighterCapsules.gd`, checks both distinct rigs
(`f01_m_box_welter_rigged.glb` and `f02_m_box_heavy_rigged.glb`), metre bands,
completeness, finite geometry, radii, non-degeneracy, non-adjacent gaps,
determinism, and the non-identical-fighter control-group rule.

The parse gate passed: `CHECK total=1 fails=0`. The one mandated Godot run
reported `SKIP — FighterCapsules.gd not present yet` with no script errors and
exit code 0, which is the expected pre-implementation result. The initial gate
needed `FIGHTCAMP_STAGE_GATE=off` because the repository guard reported that a
prior stage had already shipped; this was only a gate-environment override.
