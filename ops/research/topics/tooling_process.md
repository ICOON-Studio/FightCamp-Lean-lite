# Tooling, tests, agents, determinism, codebase health

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **Gates must derive, never copy** (a gate that checks the copy instead of the original drifts) - `U62_WHY_IT_KEEPS_HAPPENING.md`;
  declared-only gates - `U124_DECLARED_ONLY_GATES.md`; the gate that was wrong, so good data was edited to pass it -
  `R136_THE_VALIDATOR_WAS_THE_BUG.md`; the suite that passes when it should fail (exit code alone is not a pass) - `R75_DIGEST.md`.
- **Blind contract tests** written from research, not code, catch real defects (U193, U194, C142, C192-C195, G72/G73).
- **Determinism:** seeded replay needs integer tick time - `C62_REAL_TIME_DETERMINISM.md`; suite isolation - `Q16_DIGEST.md`;
  the suite can run 3.5x faster - `S1C_SUITE_PARALLELISM.md`; which commit turned each test red - `Q199_DIGEST.md`.
- **Codebase health:** codebase census (WEIGHT_CLASSES had four entries vs eight elsewhere) - `Q127_CODEBASE_CENSUS.md`; what
  nothing calls - `Q68_WHAT_NOTHING_CALLS.md`; UIKit dead factories - `C41_UIKIT_DEAD_FACTORY_AUDIT.md`; agent tool access -
  `AGENT_TOOL_ACCESS.md`; testing a pure module without the repo - `SANDBOX_MODULE_TESTING.md`.
- **Process gates (start):** RESEARCH DEFECT, PREFAB DEFECT, PRIOR-RESEARCH DEFECT; the nightly suite at 05:00; max two agents.

## Open
- Nightly suite: 24 reds at 40bec39e (2026-09-27) - triage owed.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (51, newest first, generated)

- `Q199_DIGEST.md` (2026-09-27) - Q199 Digest: Which Commit Turned Each Test Red
- `S92_FREE_SOUND_AND_MUSIC.md` (2026-09-26) - S92 - FREE SOUND AND MUSIC: GENERATORS AND PACKS (Claude, 2026-09-26)
- `Q187_DIGEST.md` (2026-09-26) - Q187_DIGEST — blind contract test for DrillMastery + FloorEvents
- `Q185_DIGEST.md` (2026-09-26) - Q185 Digest — Training Preview Contract Test
- `M35_ART_PROVENANCE_AND_REPLACEMENTS.md` (2026-09-26) - M35 - WHERE EVERY PICTURE CAME FROM, AND WHAT REPLACES THE ONES WE CANNOT SHIP
- `C210_DRILL_MOTION_SOURCES.md` (2026-09-26) - C210 — Where real gym-drill motion can come from
- `G95_BRIEF.md` (2026-09-25) - G95 - CAN A COMMERCIAL GAME USE A HUMAN BODY MODEL TO MAKE ITS ANIMATION? (Grok research brief)
- `G95_BODY_MODEL_LICENCES.md` (2026-09-25) - G95 - body-model licences and legal two-person mocap routes (Grok, 2026-09-25)
- `U154_DIGEST.md` (2026-09-24) - U154 digest — overlap regression bisect + single-frame hip budget
- `J46_YOUR_OWN_PROMOTION.md` (2026-09-24) - J46 - YOUR OWN PROMOTION
- `J45_OUR_OWN_CHARACTER_CREATOR.md` (2026-09-24) - J45 — Can we SHIP our own character creator? Licences of the open body bases
- `G85_OUR_OWN_CHARACTER_CREATOR.md` (2026-09-24) - G85 - can we ship our own character creator? Licences of the open body bases (Grok, delivered)
- `G81_PHYSIQUE_FROM_NUMBERS.md` (2026-09-24) - G81 - the fighter's NUMBERS become a Character Creator BODY: sliders, values, licence (Grok)
- `C195_DIGEST.md` (2026-09-24) - C195 — blind feint contract test
- `C194_DIGEST.md` (2026-09-24) - C194 — blind gym-market contract test
- `C193_DIGEST.md` (2026-09-24) - C193 blind body-map contract test
- `C192_DIGEST.md` (2026-09-24) - C192 digest
- `U148_DIGEST.md` (2026-09-23) - U148 digest — blind CC skin contract test (Cursor)
- `U139_DIGEST.md` (2026-09-23) - U139 digest — blind `GroundGraph` contract test
- `Q147_DIGEST.md` (2026-09-23) - Q147 DIGEST — Grapple Naming Contract Test
- `Q127_CODEBASE_CENSUS.md` (2026-09-22) - Q127 — Codebase Census
- `C165_DIGEST.md` (2026-09-22) - C165 — Elevation-banded exposure contract
- `AGENT_TOOL_ACCESS.md` (2026-09-20) - AGENT TOOL ACCESS — what is on this machine, how to drive it, and what is missing
- `K43_GODOT_FRAME_PACING.md` (2026-09-14) - K43 — WHY A GODOT 4 3D SCENE STUTTERS ON WINDOWS, AND WHICH SETTINGS MAKE IT SMOOTH
- `K41_EXPORT_LICENCES.md` (2026-09-14) - K41 — KALLI — CAN ANIMATION WE RETARGET IN UNREAL, CASCADEUR OR ROKOKO SHIP IN A GODOT GAME?
- `C45_ASSET_IMPORT_POLICY.md` (2026-09-13) - C45 asset import policy
- `U64_DIGEST.md` (2026-09-12) - U64 DIGEST — blind catalogue contract test
- `S1C_SUITE_PARALLELISM.md` (2026-09-12) - THE SUITE CAN RUN 3.5x FASTER, AND THE ONE THING THAT BROKE IS UNDERSTOOD
- `Q68_WHAT_NOTHING_CALLS.md` (2026-09-12) - Q68 — WHAT IS IN THIS GAME THAT NOTHING CALLS
- `U47_DIGEST.md` (2026-09-11) - U47 DIGEST — blind presenter contract test
- `Q30_THE_PRELOAD_THAT_COMPILED_TO_NOTHING.md` (2026-09-10) - Q30 — THE PRELOAD THAT COMPILED TO NOTHING
- `Q18_DIGEST.md` (2026-09-10) - Q18_DIGEST — FightHudRead: one pure fold
- `C83_DIGEST.md` (2026-09-10) - C83 — FightClipSlice blind contract test
- `C80_DIGEST.md` (2026-09-10) - C80 — FightStageDirector blind contract test
- `C78_DIGEST.md` (2026-09-10) - C78 Digest
- `C77_DIGEST.md` (2026-09-10) - C77 digest
- `U26_DIGEST.md` (2026-09-09) - U26 digest — GrappleResolve.gd
- `R88_DIGEST.md` (2026-09-09) - R88 — THE LAST INERT MODULE, AND THE BEAT A CUT NEVER LEFT
- `R87_DIGEST.md` (2026-09-09) - R87 — THE INERT MODULES GET A CONSUMER
- `R82_DIGEST.md` (2026-09-09) - R82 digest — Stage 1: the real-time core, and the proof that it replays
- `R75_DIGEST.md` (2026-09-09) - R75 digest — The suite that passes when it should fail
- `Q16_DIGEST.md` (2026-09-09) - Q16 Digest — Suite isolation for concurrent agents
- `Q14_DIGEST.md` (2026-09-09) - Q14 digest
- `C67_DIGEST.md` (2026-09-09) - C67 — blind grappling contract test
- `C63_DIGEST.md` (2026-09-09) - C63 digest
- `C62_REAL_TIME_DETERMINISM.md` (2026-09-09) - C62 — Can a real-time fight still replay?
- `R72_DIGEST.md` (2026-09-08) - R72 — THE SIGNATURE IS NOT THE LICENCE
- `C41_UIKIT_DEAD_FACTORY_AUDIT.md` (2026-09-08) - C41 — UIKit dead-factory audit
- `SANDBOX_MODULE_TESTING.md` (2026-09-07) - Testing a pure module with Godot but no repo (Grok / Kalli / Maria / John)
- `C31_THE_CORNER.md` (2026-09-07) - C31 — The corner: who is licensed to be there, and what they do
- `KALLI_ASSETS.md` (2026-09-04) - Kalli research renders — licence line
