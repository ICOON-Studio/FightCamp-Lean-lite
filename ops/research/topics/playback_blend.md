# Playback: beats, joins, blends, presenter, degrade/substitute

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **Why the room looks rough** (operator 2026-09-24; C189's control arm): not the retarget. #1 the simulation placing bodies
  and the walk layer spliced onto the legs; #2 seeking into and cutting clips at 20 Hz beats - `C189_DIGEST.md`. Shipped fight
  games let the CLIP own a committed strike's timing and warp WHERE it lands, not WHEN - `G87_PREVIEW_QUALITY.md`; native strike
  timing + bounded placement - `C190_DIGEST.md`; reactions play whole on the blow - `U159_DIGEST.md`.
- **A hidden logic layer decides, a presentation layer shows** (every studio) - `J49_MECHANICS_MEET_PRESENTATION.md`.
- **Presentation split** (exact / substitute / degrade): EXACT rose 29.2% -> 47.3% once the clip row was treated as a
  translation problem - `S13_CLIP_ROW.md`, `S9_PRESENTATION_SPLIT.md`, `S15_PRESENTATION_SPLIT.md`, `S14_SUBSTITUTE_COLUMN.md`;
  the missing clip - `M19_THE_MISSING_CLIP.md`.
- **Godot blending:** linear weight, per-bone slerp; `custom_speed` does not stretch the blend - `Q84_HOW_GODOT_BLENDS.md`,
  `Q85_PLAYBACK_MECHANICS.md`. Blend length: the industry publishes no timings - `G57_THE_BLEND_LENGTH.md`,
  `K34_NBA2K_TRANSITIONS.md`, `J19_THE_JOINS.md`. Unreal defaults read from its source (dead blending, motion warping,
  two-bone IK, stride warping, motion matching) - `C119_UE_JOINS.md`, `C121_UE_MOTION_WARPING.md`, `C122_UE_TWO_BONE_IK.md`,
  `C123_UE_MOTION_MATCHING.md`, `C129_UE_STRIDE_WARPING.md`.
- **Joins and jerk:** the top 1% of jerk is mostly join_active (88%), then warp, then gap walk - `U99_JERK.md`; cut-ended joins
  carry most of the over-bound share - `U90_JOIN_PAIRS.md`; body jumps vs joint pops - `U145_DIGEST.md`; no body teleports -
  `U146_DIGEST.md`, `OPINION_TELEPORTS_SYNTHESIS.md` (3 cm / 10 deg per-frame cap on root writes).
- **The beat and the clip:** a clip is 0.82 s and the engine ticks at 20 Hz - `G42_CLIP_TIME_VS_TICK_TIME.md`; a 3-s reaction
  on a 1-s beat - `G56_THE_BEAT_AND_THE_CLIP.md`; layered strikes - `K45_LAYERED_STRIKES.md`, `S4_BODY_LAYERS.md`.
- **HOW SMOOTH IS SMOOTH (S119):** continuity of pose and velocity, not long cross-fades: locomotion/idle 200-300 ms,
  into a strike 80-150 ms, strike-to-strike <=100 ms or pose-match, reaction additive <=150 ms, hit-stop 1-3 frames;
  >~400 ms is the documented quality cliff and long blends at close range put gloves through heads -
  `G147_CLIPPING_RULE_AND_SMOOTHING.md` (Bollo GDC 2018, UE docs).
- **Gloves and anything following a hand read the FINAL pose** (skeleton_updated + get_bone_global_pose): the active
  ragdoll and FighterFist are SkeletonModifier3Ds that get_bone_pose never sees (S119, fb7efb7a).

## Open
- Standing motion (C198, several passes) and the strike-motion diagnosis (C202) are not accepted; the verdict is the
  operator's eye (`OPERATOR_WATCH_TAKE1_VERDICT.md`).

## Engine
`FightStagePlayer.gd`, `FightStageDirector.gd`, `FightBeatAdapter.gd`, `FightWorldLiveScreen.gd`, `BoneTrackGraft.gd`,
`FightClipSlice.gd`. Tests: `fight_stage_presenter_contract_test` (parked red), `fight_stage_technique_fidelity_test`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (52, newest first, generated)

- `U173_DIGEST.md` (2026-09-25) - U173 digest — defender model slice 2 (anticipate + counter)
- `U172_DIGEST.md` (2026-09-25) - U172 digest — defence_model slice 1 (pass 2 gate)
- `J49_MECHANICS_MEET_PRESENTATION.md` (2026-09-25) - J49 - HOW THE INDUSTRY JOINS MECHANICS, ANIMATION AND UI
- `U158_DIGEST.md` (2026-09-24) - U158 digest — kick playback and smoother walk
- `U145_DIGEST.md` (2026-09-24) - U145 digest — body jumps vs local joint pops
- `Q169_DIGEST.md` (2026-09-24) - Q169 Digest — TRAPS slice 1: the isolated arm from mount
- `C196_DIGEST.md` (2026-09-24) - C196 — FEINTS slice two: rate
- `C187_DIGEST.md` (2026-09-24) - C187 - pelvis layer joins and the fist ceiling
- `C185_DIGEST.md` (2026-09-24) - C185 - hands and abrupt motion
- `C134_CONTINUE_4.md` (2026-09-20) - C134 — CONTINUATION 4 — CODEX — **BLENDER AND HIGGSFIELD ARE YOURS NOW**
- `S9_PRESENTATION_SPLIT.md` (2026-09-18) - S9 — THE PRESENTATION SPLIT (exact, substitute, degrade)
- `S15_PRESENTATION_SPLIT.md` (2026-09-18) - S15 — THE PRESENTATION SPLIT (exact, substitute, degrade)
- `S14_SUBSTITUTE_COLUMN.md` (2026-09-18) - S14 — THE SUBSTITUTE COLUMN: A MISLABEL CORRECTED, AND A COUNTER THE CLOCK CANNOT AFFORD
- `S14_PRESENTATION_SPLIT.md` (2026-09-18) - S14 — THE PRESENTATION SPLIT (exact, substitute, degrade)
- `S13_PRESENTATION_SPLIT.md` (2026-09-18) - S13 — THE PRESENTATION SPLIT (exact, substitute, degrade)
- `S13_CLIP_ROW.md` (2026-09-18) - S13 — THE CLIP ROW WAS MOSTLY A TRANSLATION PROBLEM
- `S10_MOVEMENT_DEGRADES.md` (2026-09-18) - S10 step 1 - a `movement`-class degrade, and what the body was doing
- `R144_LINE3_AUTHORING_COST.md` (2026-09-18) - R144 LINE 3 - AUTHOR THE GROUND FILM IN BLENDER, PRICED IN TIME
- `S4E_MOVE_ANATOMY.md` (2026-09-16) - WHAT A MOVE NEEDS, WHICH LIMB THROWS IT, WHERE IT LANDS — AND WHY MOVES DO NOT BLEND
- `S4A_CLOUD_BLENDER.md` (2026-09-16) - S4 (A) — THE BLENDER HALF OF THE PIPELINE RUNS WITHOUT THE OPERATOR'S PC
- `U99_JERK.md` (2026-09-14) - DECISIONS
- `U90_JOIN_PAIRS.md` (2026-09-14) - DECISIONS
- `Q99_R3_SOURCES.md` (2026-09-14) - Q99 - R3 source bucketing
- `K45_LAYERED_STRIKES.md` (2026-09-14) - K45 — A PUNCH WHILE STEPPING: UPPER/LOWER-BODY LAYERING IN GODOT 4.7, WITHOUT LOSING OUR JOINS
- `K42_ROKOKO_BLENDER_RETARGET.md` (2026-09-14) - K42 — KALLI — ROKOKO STUDIO LIVE FOR BLENDER: CAN WE RETARGET WITH IT, HEADLESS, ON BLENDER 5.2?
- `J31_AI_ANIMATION_PIPELINE.md` (2026-09-14) - J31 — AI Generators + Scripts + Blender: Will This Pipeline Work for Us?
- `HIGGSFIELD_MMA_PIPELINE_STUDY.md` (2026-09-14) - Higgsfield + scripts + Blender for realistic real-time MMA animation (study, COMPLETE)
- `C121_UE_MOTION_WARPING.md` (2026-09-14) - DECISIONS
- `C119_UE_JOINS.md` (2026-09-14) - DECISIONS
- `BAKEOFF_BLENDER_RETARGET.md` (2026-09-14) - RETARGET BAKE-OFF 1 — OURS AGAINST BLENDER 5.2.1 + THE RETARGET ADD-ON (Claude, 2026-09-14)
- `Q85_PLAYBACK_MECHANICS.md` (2026-09-13) - Q85 — THE FIVE PLAYBACK MECHANICS S4a's TRANSITIONS STAND ON
- `Q84_HOW_GODOT_BLENDS.md` (2026-09-13) - Q84 — How Godot 4.7.2 blends
- `K34_NBA2K_TRANSITIONS.md` (2026-09-13) - K34 — KALLI — HOW NBA 2K MOVES FROM ONE ANIMATION TO THE NEXT, IN ITS DEVELOPERS' OWN WORDS
- `G57_THE_BLEND_LENGTH.md` (2026-09-13) - G57 — THE BLEND LENGTH: HOW LONG A FIGHT GAME'S CROSSFADE IS, AND WHEN IT IS ZERO
- `C106_TOOL_POPULATIONS.md` (2026-09-13) - DECISIONS
- `U47_DIGEST.md` (2026-09-11) - U47 DIGEST — blind presenter contract test
- `R103_DIGEST.md` (2026-09-11) - R103 DIGEST — THE BEAT PLAYS A CLIP, AND IT PLAYS THE RIGHT ONE
- `Q57_VARIETY_WITHOUT_BUYING.md` (2026-09-11) - Q57 — MAKING A HUNDRED CLIPS LOOK LIKE FIVE HUNDRED
- `Q52_MOTION_SPEC.md` (2026-09-11) - Q52 — THE NUMBERS BEHIND MOTION
- `G56_THE_BEAT_AND_THE_CLIP.md` (2026-09-11) - G56 — A Three-Second Reaction on a One-Second Beat
- `U43_DIGEST.md` (2026-09-10) - U43 DIGEST — the beat learns the technique
- `U40_DIGEST.md` (2026-09-10) - U40 DIGEST — three punches sliced from combo_jab_cross_hook
- `R97_DIGEST.md` (2026-09-10) - R97 — THE BEAT ADAPTER, AND THE THREE DEFECTS UNDER IT
- `Q36_THE_BEAT_FITS.md` (2026-09-10) - 
- `M19_THE_MISSING_CLIP.md` (2026-09-10) - M19 — THE MISSING CLIP (presenter when R101 names a technique we have no clip for)
- `J19_THE_JOINS.md` (2026-09-10) - J19 — THE JOINS (what turns fourteen clips into a fight)
- `G42_CLIP_TIME_VS_TICK_TIME.md` (2026-09-10) - G42 — THE CLIP IS 0.82 s AND THE ENGINE TICKS AT 20 Hz
- `C83_DIGEST.md` (2026-09-10) - C83 — FightClipSlice blind contract test
- `R88_DIGEST.md` (2026-09-09) - R88 — THE LAST INERT MODULE, AND THE BEAT A CUT NEVER LEFT
- `M12_THE_BEAT.md` (2026-09-07) - M12 — THE BEAT: THE MOMENT THE GYM SAYS YES
- `C1_DIGEST.md` (2026-09-04) - C1 — fight-night playback data
- `C123_UE_MOTION_MATCHING.md` (untracked) - DECISIONS
