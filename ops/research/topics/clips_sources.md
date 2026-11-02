# Clips and where they come from: owned packs, Higgsfield, text-to-motion, Mixamo, CMU, Cascadeur, buying

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **Coverage (re-measured S114):** 534 motion techniques; 158 own a clip (EXACT 26 + NEAR 132, 29.6%), 315 borrow a family
  clip, 14 gap, **47 play nothing** - `Q133_DIGEST.md` (what was wired), `Q157_DIGEST.md` (grappling by family),
  `Q158_DIGEST.md`, `Q159_DIGEST.md`, `Q160_DIGEST.md` (the 66-technique striking gap is already priced). 162 passive skills
  never need a clip.
- **Owned:** RamsterZ Hand to Hand Set (124 FBX, bound) - `R107_HAND_TO_HAND_SET.md`; what every owned clip does -
  `U108_CLIP_BEHAVIOUR.md`; the owned inventory - `Q47_THE_OWNED_INVENTORY.md`; the 32 paired clips - `C91_PAIRED_CONTENT.md`.
- **Buying is OFF** until our playback matches the vendor reels (operator 2026-09-24). Martial Arts Master has no ground work -
  `R144_LINE2_MARTIAL_ARTS_MASTER_RESOLVED.md`; no paired grappling SKU exists - `R144_LINES1_2_THE_CATALOGUE_AND_THE_STORE.md`;
  judo pack audited - `R140_THE_JUDO_ANIMSET.md`; store shortlist - `R142_ASSET_STORE_SHORTLIST.md`.
- **Higgsfield:** image first, check the still, THEN animate - `HIGGSFIELD_PROMPT_LOG.md` (every job, verbatim); two bodies
  fail (one body 8/8; composed takedowns 0/36) - `HIGGSFIELD_MMA_PIPELINE_STUDY.md`, `G76_TWO_FAILURES_AND_WHAT_ELSE.md`,
  `G77_GENERATE_TWO_BODIES.md`; Kimodo text-to-motion 0.1 credit, one body - `C207_DIGEST.md`, `U106_HIGGSFIELD_JAB.md`,
  `U107_T2M_JAB_TYPES.md`. Operator 2026-09-22: grappling = a single actor performing the technique.
- **THE OPERATOR'S CURRENT PATH: Higgsfield -> Blender via the Higgsfield plugin's `higgsfield_blender` MCP** (S72,
  2026-09-25; 18 `bl_*` tools, bridge on 127.0.0.1:9876, Blender 5.2.1 open with the plugin enabled). Higgsfield makes
  reference video and assets; Blender builds and shows the motion in the operator's scene - `TASK_C199_SUIT_CLIPS_TO_3D.md`.
  Ground reference videos (Seedance 2.0: mount, closed guard, front headlock; most ACCEPTED) - `_captures/ground_video/README.md`.
  `bl_generate_3d` / `bl_image_to_3d` / `bl_generate_image` spend credits OUTSIDE `Tools/higgsfield/budget.py` - a task must
  ledger them by hand.
- **The colour-suit route (C180/C199): Higgsfield video of two fighters in per-segment colour suits -> segment tracker ->
  3D solve in Blender via the MCP.** The tracker passed its Python gate on a closed-guard suit clip - `C180_DIGEST.md`. The
  video-to-body-model chain is NOT PROVEN - stopped at row 2 (calibrated views, joint markers, body-model solve not done) -
  `C199_DIGEST.md`; operator 2026-09-25: copy the WHOLE studio pipeline, not one piece of it (memory
  `feedback_copy_the_whole_industry_pipeline`; the two-person fitters CloseInt/BUDDI are in `G76_TWO_FAILURES_AND_WHAT_ELSE.md`;
  SMPL-X licence is the operator's call). C199 produced an authored MMA closed-guard pair that reads right from the game angle.
  Branch tagged `retired/c199-suit-clips-to-3d`. PAUSED since 09-25 - nobody holds it.
- **Free sources:** CMU mocap (commercial use allowed, no resale of the data) - `C149_CMU_SOURCE.md`,
  `R155_CMU_PAIRED_GROUND_TRUTH.md`; used for the calm, lying and seated idles - `C219_DIGEST.md`, `C220_DIGEST.md`. Mixamo
  training clips usable with edits - `C212_DIGEST.md`, `D27_FRESH_EYES_MIXAMO.md`; no training take is owned -
  `C210_DRILL_MOTION_SOURCES.md`; sources beyond Ludo - `C75_ANIMATION_SOURCES.md`.
- **Cascadeur** (kept, Pro) is the only route to authored two-body holds - `S29_CASCADEUR_GUI_REACHED.md`, `S30_THE_PAIRED_POSE.md`.
- **Scale:** hundreds of clips without an animator - `G58_MOTION_AT_SCALE.md`, `R124_HUNDREDS_OF_CLIPS.md`,
  `Q57_VARIETY_WITHOUT_BUYING.md`; motion archetypes and prompts - `G67_MOTION_ARCHETYPES.md`.
- Body-model licences (SMPL-X is non-commercial; the operator has not ruled) - `G95_BODY_MODEL_LICENCES.md`.
- **RAMSTERZ vs MIXAMO JAB (S119):** operator prefers the RamsterZ look. RamsterZ H2H_JabInPlace failed slip on the old
  Tripo rigs (C223 run 3), was replaced, then PASSED every smoothness row once the pipeline was fixed (joins 0.27 cm vs
  Mixamo 2.1) but sits out on speed only (16 m/s > jab band 9.5). Route: RamsterZ sources + run 9's strike_warp into
  band - `C223_DIGEST.md`, `tools/s119_showreel.gd -- compare_jab`.

## Open
- **CORRECTION S114 (operator):** the Blender-MCP AUTHORING method is proven (C199_Hold, contacts fixed, exported); its game
  integration was never done - `TASK_C222` step 1. The video-to-3D solve below is optional research, not the route.
- The 3D solve (S114): blocked by (1) Blender MCP disconnected, (2) no calibration in generated video, (3) BUDDI needs banned SMPL-X,
  (4) SAM 3D Body never tried. Fix is binding on C221/C222: SAM 3D Body, a calibration take per clip, two-panel disagreement
  measured, a fixed cleanup row, `SHOT_LIST_GROUND.md`.
- The suit route: resume only with the whole studio chain written as a table (step / our equivalent / cheapest test / status)
  and the weakest link tested free first.
- **C221** (Codex, in flight S114): clips for the 47 moves that play nothing. A move is done only when it PLAYS in a bout
  (`technique_roles()` extended) and passes two rigs; the first Kimodo take failed both and stayed unbound.

- **kimodo.cpp** (S278, operator sent https://github.com/localai-org/kimodo.cpp): a local GGML/C++ runner of the SAME NVIDIA Kimodo
  model we ran through Higgsfield (47 boxing takes, all rejected - S128/C221). New only: free local runs, Apache-2.0 code, SOMA and G1
  weights under the NVIDIA Open Model License (commercial use permitted; the SMPL-X checkpoint is research-only). Limits read on the
  README: Linux build only, Vulkan text encoder ~10 GiB VRAM, output = a skeleton-only GLB (SOMA 30 joints, no mesh) to retarget onto
  MetaHuman. Not a fight-clip source (same model, same failure); possible later for ambient gym people (walk, sit, stretch) if a
  prefab clip is missing. Fight motion stays Rokoko + ActionForge (S274).

## Engine
`FightClipBinding.gd` (`PAIRED_BINDINGS`, `technique_roles()`), `FightClipRetarget.gd`, `assets/anim/`, `Tools/higgsfield/`
(budget ledger). Census: `tools/q133_clip_coverage.gd`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (70, newest first, generated)

- `D40_FRESH_EYES_THE_GENERATED_CARDS.md` (2026-09-27) - D40 - Fresh eyes: are these fighter cards? (Dola, collected S94 2026-09-27)
- `C219_DIGEST.md` (2026-09-27) - C219 — calm room idles
- `C135_CASCADEUR_HELD_POSE.md` (2026-09-27) - C135 - Cascadeur did not produce a bindable side control
- `S92_ASSET_STORE_SEARCH_GYM_PROPS_AND_STAFF.md` (2026-09-26) - S92 - ASSET STORE SEARCH: FIGHT-GYM PROPS AND STAFF (Claude, 2026-09-26)
- `M35_ART_PROVENANCE_AND_REPLACEMENTS.md` (2026-09-26) - M35 - WHERE EVERY PICTURE CAME FROM, AND WHAT REPLACES THE ONES WE CANNOT SHIP
- `HIGGSFIELD_PROMPT_LOG.md` (2026-09-26) - Higgsfield prompt log - every job, its prompt verbatim, what it cost and what came back
- `D27_FRESH_EYES_MIXAMO.md` (2026-09-26) - D27_FRESH_EYES_MIXAMO (Dola, collected by Claude S83, 2026-09-26)
- `C212_DIGEST.md` (2026-09-26) - C212 Mixamo training audition
- `C210_DRILL_MOTION_SOURCES.md` (2026-09-26) - C210 — Where real gym-drill motion can come from
- `G95_BODY_MODEL_LICENCES.md` (2026-09-25) - G95 - body-model licences and legal two-person mocap routes (Grok, 2026-09-25)
- `U164_DIGEST.md` (2026-09-24) - U164 digest — are bought strike clips faster than humans?
- `U163_DIGEST.md` (2026-09-24) - U163 digest — take-four kick/hand speed (vendor-world)
- `Q157_DIGEST.md` (2026-09-24) - Q157 DIGEST - Grappling clip coverage by family
- `G87_PREVIEW_QUALITY.md` (2026-09-24) - G87 - the SAME clips look smooth in the vendor reel and rough in our fight: why (Grok, delivered S65 2026-09-2
- `C189_DIGEST.md` (2026-09-24) - C189 — whole vendor clips on our fighter, Round 2
- `C181_DIGEST.md` (2026-09-24) - C181 digest - Higgsfield loop
- `C180_DIGEST.md` (2026-09-24) - C180 digest — per-segment suit tracker
- `C173_DIGEST.md` (2026-09-23) - C173 - stance switches authored in Cascadeur
- `R144_LINE2_MARTIAL_ARTS_MASTER_RESOLVED.md` (2026-09-22) - R144 LINE 2 CLOSED — "MARTIAL ARTS MASTER" HAS NO GROUND WORK, AND NEITHER PACK SOLVES THE GRAPPLING WALL
- `Q133_DIGEST.md` (2026-09-22) - Q133 DIGEST - Wire every clip we already own to a technique id
- `J42_THE_HEAD_AS_A_VOLUME.md` (2026-09-22) - J42 — IS A HEAD A CAPSULE? THE SKULL AND NECK AS COLLISION VOLUMES
- `J40_FIGHT_AUDIO_SHORTLIST.md` (2026-09-22) - J40 — FIGHT AUDIO SHORTLIST
- `U115_MOVING_CLIP_AND_GAP.md` (2026-09-21) - U115 — Moving Cascadeur clip retarget, and the gap gate instrument
- `U114_CASCADEUR_RETARGET.md` (2026-09-21) - U114 — Cascadeur retarget: the three repairs
- `U113_CASCADEUR_EXPORT.md` (2026-09-21) - NO-GO — Cascadeur GLB cannot enter `FightClipRetarget` as-is; needs GLB loader + Cascy rename map + Cascy refe
- `U112_VIDEO_MOTION.md` (2026-09-21) - U112 — paired 3D joint streams from broadcast footage
- `U109_FOOTAGE_BETWEEN_RATES.md` (2026-09-21) - U109 - what fighters do between punches, measured
- `S30_THE_PAIRED_POSE.md` (2026-09-21) - Two bodies, in contact, authored in Cascadeur - and the channel that made it possible
- `S29_CASCADEUR_GUI_REACHED.md` (2026-09-21) - The Cascadeur GUI route is open, and `auto_posing` is a live object in it
- `R155_CMU_PAIRED_GROUND_TRUTH.md` (2026-09-21) - R155 — CMU paired mocap: what is actually there, measured
- `Q122_CMU_CONTACT_CENSUS.md` (2026-09-21) - Q122 — CMU Paired-Corpus Contact Census
- `C149_CMU_SOURCE.md` (2026-09-21) - C149 CMU source measurement
- `C144_LEAN_CONTRACT.md` (2026-09-21) - C144 - Lean-survival blind contract
- `U111_FOOTAGE_ROWS_REMEASURED.md` (2026-09-20) - U111 — Two rows U109 and U110 got wrong, re-measured
- `U110_FOOTAGE_COMMIT_WINDOW.md` (2026-09-20) - U110 — Rear-Hand and Kick Commitment Window
- `R144_LINE12_SKU_SEARCH.md` (2026-09-20) - R144 lines 1–2 — the ground-hold SKU search: two leads checked, both negative
- `C134_CONTINUE_4.md` (2026-09-20) - C134 — CONTINUATION 4 — CODEX — **BLENDER AND HIGGSFIELD ARE YOURS NOW**
- `ASSET_REPORT_2026-09-20.md` (2026-09-20) - FightCamp asset report — 2026-09-20
- `AGENT_TOOL_ACCESS.md` (2026-09-20) - AGENT TOOL ACCESS — what is on this machine, how to drive it, and what is missing
- `U107_T2M_JAB_TYPES.md` (2026-09-14) - U107 - text-to-motion jab types on our fighter
- `U106_HIGGSFIELD_JAB.md` (2026-09-14) - U106 - a Higgsfield jab on our fighter
- `U105_ROOM_AS_FOOTAGE.md` (2026-09-14) - U105 - the live room measured like footage
- `Q110_FOOTAGE_JAB_TYPES.md` (2026-09-14) - Q110 - the three jabs in footage
- `Q109_FOOTAGE_POSTURE.md` (2026-09-14) - Q109 - the fold, measured
- `Q108_FOOTAGE_BATCH3.md` (2026-09-14) - Q108 - footage batch 3 folded into the two-man table
- `Q107_MOCAP_CHAIN.md` (2026-09-14) - DECISIONS
- `OPERATOR_HIGGSFIELD_CATALOG_RECIPE_2026-09-14.md` (2026-09-14) - Operator direction, 2026-09-14 night: a modular single-actor catalog, assembled by Godot code
- `K61_WATCH_LIST_JAB_TYPES.md` (2026-09-14) - K61 - Watch list 6: the range-finder, the feint and the committed jab
- `K58_COMBAT_MOVE_SCRIPTS.md` (2026-09-14) - K58 — How combat games script a move before they animate it
- `K41_EXPORT_LICENCES.md` (2026-09-14) - K41 — KALLI — CAN ANIMATION WE RETARGET IN UNREAL, CASCADEUR OR ROKOKO SHIP IN A GODOT GAME?
- `J31_AI_ANIMATION_PIPELINE.md` (2026-09-14) - J31 — AI Generators + Scripts + Blender: Will This Pipeline Work for Us?
- `HIGGSFIELD_MMA_PIPELINE_STUDY.md` (2026-09-14) - Higgsfield + scripts + Blender for realistic real-time MMA animation (study, COMPLETE)
- `C132_JAB_TYPES_IN_ENGINE.md` (2026-09-14) - C132 - the three jabs in the engine
- `R142_ASSET_STORE_SHORTLIST.md` (2026-09-13) - R142 — THE UNITY SALE SHORTLIST: 25 PACKAGES, WHAT TO BUY, WHAT TO COMBINE, WHAT WE WOULD USE
- `S1C_SUITE_PARALLELISM.md` (2026-09-12) - THE SUITE CAN RUN 3.5x FASTER, AND THE ONE THING THAT BROKE IS UNDERSTOOD
- `R140_THE_JUDO_ANIMSET.md` (2026-09-12) - R140 — THE JUDO PACK, PRICED AND AUDITED FROM THE LISTING
- `R124_HUNDREDS_OF_CLIPS.md` (2026-09-12) - R124 — HOW TO GET TO HUNDREDS OF CLIPS WITHOUT BUYING HUNDREDS OF CLIPS
- `G58_MOTION_AT_SCALE.md` (2026-09-12) - G58 — HOW YOU GET TO HUNDREDS OF CLIPS WITHOUT AN ANIMATOR
- `U46_MOTIFECT_AUDITION.md` (2026-09-11) - U46 — Motifect (and Mixamo) free-pack audition
- `R107_HAND_TO_HAND_SET.md` (2026-09-11) - R107 — `HAND TO HAND SET`, AND THE RECEIVER GAP IS CLOSED
- `R105_MARTIAL_ARTS_MASTER.md` (2026-09-11) - R105 — `MARTIAL ARTS MASTER`, READ FROM ITS OWN MANIFEST
- `Q50_GI_AND_KIT.md` (2026-09-11) - Q50 — THE GI AND THE SHIN GUARDS: WHAT TO BUY ON 2026-09-14
- `Q47_THE_OWNED_INVENTORY.md` (2026-09-11) - Q47 — THE INVENTORY OF EVERY CLIP WE ACTUALLY OWN
- `U30_DIGEST.md` (2026-09-10) - U30 digest — Ops Board
- `J17_THE_CLIP_COUNT.md` (2026-09-10) - J17 — THE CLIP COUNT (how many striking animations a shipped fighter actually carries)
- `C75_ANIMATION_SOURCES.md` (2026-09-10) - C75 — Animation sources beyond Ludo
- `C71_DIGEST.md` (2026-09-10) - C71 digest
- `R75_DIGEST.md` (2026-09-09) - R75 digest — The suite that passes when it should fail
- `Q16_DIGEST.md` (2026-09-09) - Q16 Digest — Suite isolation for concurrent agents
- `C8_DIGEST.md` (2026-09-05) - C8 Digest — SCOUTING read API + shortlist
