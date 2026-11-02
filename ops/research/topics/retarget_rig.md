# Retargeting, rigs, skeletons, rest poses, bakes

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **KEEP OUR RETARGET** (`FightClipRetarget.gd`): it copies source joint angles within 0.15 deg and facing within 1-3 deg
  and beat Blender 5.2.1 - `BAKEOFF_BLENDER_RETARGET.md`; Godot's own retarget compared - `Q82_GODOT_RETARGET_VS_OURS.md`;
  Unreal with mismatched proportions - `Q125_UNREAL_PROPORTION_RETARGET.md`; no free Unity tool beats it -
  `K40_FREE_UNITY_ANIMATION_TOOLS.md`.
- **The retarget is NOT why strikes look rough** (operator's preview-quality ruling; C189's control arm: whole vendor clips
  on our fighter match the vendor mannequin) - `C189_DIGEST.md`, `G87_PREVIEW_QUALITY.md`; see `playback_blend.md`.
- **One canonical rig:** f01's measured near-T rest, identity local bases, one skeleton definition, per-body proportions -
  `C200_RIG_SPEC.md`, `C200_DIGEST.md`, `C201_DIGEST.md`. Fighter rigs are not in metres (Tripo export scale).
- **Proportion fixes:** silhouette-matched rest - `C102_SILHOUETTE_FIX.md`; the rest gap carried into every frame (the +367%
  was three faults) - `S40_THE_REST_GAP_IS_CARRIED_INTO_EVERY_FRAME.md`; the girdle fix ships - `S41_THE_GIRDLE_IS_IN_THE_GAME.md`;
  the 2->3 spine split - `U117_THE_SPINE_SPLIT.md`; girdle anthropometry (ANSUR II) - `J41_SHOULDER_GIRDLE_PROPORTIONS.md`,
  `J44_ABOVE_THE_NOTCH.md`.
- **Cascadeur clips retarget** (CASCY_TO_UE4; skinned glTF via Skeleton3D; UpperChest inherits Chest; a T-pose is NOT
  required) - `U113_CASCADEUR_EXPORT.md`, `U114_CASCADEUR_RETARGET.md`, `U115_MOVING_CLIP_AND_GAP.md`, blind contract
  `C142_CASCY_RETARGET_CONTRACT.md`. Grips mostly survive the retarget - `S34_GRIP_THROUGH_RETARGET.md`.
- **Bake rate:** glTF resamples to Godot's bake_fps; measure at file-native key times - `U122_BAKE_RATE_CENSUS.md`,
  `C151_BAKE_RATE_CONTRACT.md`. The Blender half runs headless - `S4A_CLOUD_BLENDER.md`, `C111_RETARGET_ADDON_API.md`.
- Licences: an Unreal-exported retarget of our mesh and licensed clips may ship in Godot - `K41_EXPORT_LICENCES.md`.

## Open
- Bought clips run faster than humans on some classes (median kick ratio 1.62) - `U162_DIGEST.md`, `U163_DIGEST.md`, `U164_DIGEST.md`.

## Engine
`FightClipRetarget.gd` (`CASCY_TO_UE4`, `UE4_TO_OURS`, silhouette corrections), the C200 rig spec, `Godot/tools/*bake*`.
Tests: `fight_cascy_retarget_test`, `*retarget*`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (54, newest first, generated)

- `Q101_FM1_TAKES.md` (2026-09-27) - DECISIONS
- `C136_REBAKED_PAIRS.md` (2026-09-27) - C136 - owned pairs rebaked; contact and position refusals retained
- `C134_RETARGET_CONT4.md` (2026-09-27) - C134 continuation 4: fix paired travel at the runtime retarget source
- `C134_ARMBAR_RETARGET.md` (2026-09-27) - C134 armbar: lost travel is proven; live contact acceptance remains open
- `G125_REGENERATING_THE_FIGHTERS.md` (2026-09-26) - G125 - REGENERATING THE FIGHTERS ON TRIPO PRO, AND HOW PROMOTIONS SHOOT ROSTER PORTRAITS
- `C201_DIGEST.md` (2026-09-25) - C201 digest ? one rig definition, per-body proportions
- `C200_RIG_SPEC.md` (2026-09-25) - C200 canonical fighter rig v1
- `C200_DIGEST.md` (2026-09-25) - C200 digest - one rig / one import convention
- `U162_DIGEST.md` (2026-09-24) - U162 — retarget speed census (Cursor, S66)
- `U157_DIGEST.md` (2026-09-24) - U157 digest — why the grip solve loosened the cage clinch
- `S46_THE_DOF_SET.md` (2026-09-22) - S46 — THE DOF SET, MEASURED ON OUR OWN RIG
- `Q141_VERTEX_CLEAN.md` (2026-09-22) - Q141 — CLEAN THE VERTEX SET, WHICH YOU HAVE NOW RECOMMENDED TWICE
- `Q132_DIGEST.md` (2026-09-22) - Q132 DIGEST - Capsule Census: Every Capsule, Every Rig
- `J44_ABOVE_THE_NOTCH.md` (2026-09-22) - J44 — HOW FAR ABOVE THE STERNAL NOTCH DOES THE SHOULDER GIRDLE SIT?
- `J41_SHOULDER_GIRDLE_PROPORTIONS.md` (2026-09-22) - J41 — SHOULDER GIRDLE PROPORTIONS
- `U122_BAKE_RATE_CENSUS.md` (2026-09-21) - U122 — Bake-rate census (file-native KeyTime / glTF sampler times)
- `U117_THE_SPINE_SPLIT.md` (2026-09-21) - U117 — the 2→3 spine split, done properly
- `U116_LEAN_SURVIVES.md` (2026-09-21) - U116 — does the clinch lean survive the retarget?
- `U115_MOVING_CLIP_AND_GAP.md` (2026-09-21) - U115 — Moving Cascadeur clip retarget, and the gap gate instrument
- `U114_CASCADEUR_RETARGET.md` (2026-09-21) - U114 — Cascadeur retarget: the three repairs
- `U113_CASCADEUR_EXPORT.md` (2026-09-21) - NO-GO — Cascadeur GLB cannot enter `FightClipRetarget` as-is; needs GLB loader + Cascy rename map + Cascy refe
- `S41_THE_GIRDLE_IS_IN_THE_GAME.md` (2026-09-21) - S41 — the girdle fix is on the shipped path, and the first re-baseline was a tautology
- `S40_THE_REST_GAP_IS_CARRIED_INTO_EVERY_FRAME.md` (2026-09-21) - S40 — the +367% was three faults, and bone proportions was the smallest of them
- `S34_GRIP_THROUGH_RETARGET.md` (2026-09-21) - S34 — Does the grip survive the retarget? **Mostly yes: 1.3–2.3 cm of drift.**
- `RECIPE_2026-09-21_PAIRED_ANCHOR_RIG.md` (2026-09-21) - RECIPE, pasted by the operator 2026-09-21 — a paired anchor rig in Blender
- `Q126_PAIR_GAP_BASELINE.md` (2026-09-21) - Q126 — pair-gap baseline (BEFORE S41 girdle change)
- `Q125_UNREAL_PROPORTION_RETARGET.md` (2026-09-21) - Q125 — What Unreal Does When the Source Skeleton Is Not the Target's Shape
- `Q124_EXTREMA_AUDIT.md` (2026-09-21) - Q124 — Extrema Audit Report
- `C152_SILHOUETTE_SEGMENT_CONTRACT.md` (2026-09-21) - C152 silhouette segment contract
- `C151_BAKE_RATE_CONTRACT.md` (2026-09-21) - C151 — blind bake-rate contract
- `C142_CASCY_RETARGET_CONTRACT.md` (2026-09-21) - C142 Cascy retarget contract
- `C134_CONTINUE_5.md` (2026-09-20) - C134 — CONTINUATION 5 — CODEX — THE CONTACTS, WITH THE RETARGET FINALLY CORRECT
- `Q103_UE_ORIENTATION_WARPING.md` (2026-09-14) - DECISIONS
- `Q102_UE_ROOT_OFFSET_AND_STRIDE.md` (2026-09-14) - DECISIONS
- `Q100_FM1_RIG.md` (2026-09-14) - DECISIONS
- `K42_ROKOKO_BLENDER_RETARGET.md` (2026-09-14) - K42 — KALLI — ROKOKO STUDIO LIVE FOR BLENDER: CAN WE RETARGET WITH IT, HEADLESS, ON BLENDER 5.2?
- `K41_EXPORT_LICENCES.md` (2026-09-14) - K41 — KALLI — CAN ANIMATION WE RETARGET IN UNREAL, CASCADEUR OR ROKOKO SHIP IN A GODOT GAME?
- `K40_FREE_UNITY_ANIMATION_TOOLS.md` (2026-09-14) - K40 — KALLI — WHICH FREE UNITY TOOLS COULD FIX OUR RETARGETING AND ANIMATION, AND STILL LAND IN GODOT?
- `C111_RETARGET_ADDON_API.md` (2026-09-14) - DECISIONS
- `BAKEOFF_BLENDER_RETARGET.md` (2026-09-14) - RETARGET BAKE-OFF 1 — OURS AGAINST BLENDER 5.2.1 + THE RETARGET ADD-ON (Claude, 2026-09-14)
- `U81_TRIPTYCH.md` (2026-09-13) - U81/U82 — Retarget triptych sheets (S4a)
- `R141_WHY_THE_CLIPS_LOOK_BAD.md` (2026-09-13) - R141 — S4a: WHY THE BOUGHT CLIPS LOOK BAD
- `Q82_GODOT_RETARGET_VS_OURS.md` (2026-09-13) - Q82 — Godot 4.7.2 Engine Retarget vs Ours
- `K28_ONE_CLIP_TWELVE_BODIES.md` (2026-09-13) - K28 — ONE CLIP, TWELVE DIFFERENT BODIES
- `C99_SOURCE_SKELETON.md` (2026-09-13) - C99 source skeleton
- `C102_SILHOUETTE_FIX.md` (2026-09-13) - C102 — Silhouette-matched rest study
- `C100_RETARGET_BY_FRAME.md` (2026-09-13) - DECISIONS
- `R108_THE_REST_POSE.md` (2026-09-11) - R108 — The Rest Pose, and the First Retargeted Clip
- `Q63_THE_THIRTEENTH_FIGHTER.md` (2026-09-11) - Q63 — The Thirteenth Fighter: What Made the Twelve, and What a Gi Costs
- `Q54_PAIRED_IN_GODOT.md` (2026-09-11) - Q54 — HOW TWO SKELETONS SHARE ONE PERFORMANCE
- `Q49_FOOT_PLANTING.md` (2026-09-11) - Q49 — THE ONE FIX Q48 SAID TO BUY: FOOT PLANTING
- `C87_THE_RETARGET_LADDER.md` (2026-09-11) - C87 — The Retarget Ladder
- `Q29_DIGEST.md` (2026-09-10) - Q29 DIGEST — the clip graft is one module now
- `C58_THE_TWELVE_SEEN.md` (2026-09-09) - C58 — The Twelve, Seen
