# Paired two-body animation: holds, grips, anchors

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **Two bodies cannot be generated or bought** (see `clips_sources.md`); owned pairs: the RamsterZ 16 _Att/_Vic pairs -
  `C91_PAIRED_CONTENT.md` (their source contact distances are ~0.02-0.04 m, so drift % divides by near-zero - `Q162_DIGEST.md`);
  paired two-body animation survives the trip to Godot - `R106_PAIRED_SURVIVES.md`; how two skeletons share one performance -
  `Q54_PAIRED_IN_GODOT.md`.
- **Cascadeur is the authoring route** (kept, Pro): the GUI is reachable, `auto_posing` is live - `S29_CASCADEUR_GUI_REACHED.md`;
  two bodies authored in contact - `S30_THE_PAIRED_POSE.md`; scripting could not produce a held pose - `C135_CASCADEUR_HELD_POSE.md`.
- **The authored clinch:** hips land within 4%, the arms did not arrive (S31) - `S31_THE_AUTHORED_CLINCH.md`; the grip was
  read one bone off - `S39_THE_GRIP_WAS_READ_ONE_BONE_OFF.md`; grips survive the retarget (+8.8%) - `S34_GRIP_THROUGH_RETARGET.md`;
  worst contact per hold after fixes 15-19% (gate: 30% or better) - `C168_DIGEST.md`, `C169_DIGEST.md`, `C171_DIGEST.md`,
  `C172_DIGEST.md`, `C175_DIGEST.md`; standing clinch grips - `U171_DIGEST.md`.
- **Anchors:** a capsule for collision plus three or four named grip anchors per region - `G70_TYPED_GRIP_ANCHORS.md`,
  `G71_POSE_FRAMES.md`; the hand on the neck sits ~90-140 deg from the spine (judgement) - `J56_WHERE_THE_HAND_GOES_ON_THE_NECK.md`;
  where the hands and feet are in five ground holds (closed-guard failure named) - `G84_WHERE_THE_HANDS_ARE.md`; the paired
  anchor contract - `C150_PAIRED_ANCHOR_CONTRACT.md`; CMU 18/19_05 is the anchor-validation fixture - `R155_CMU_PAIRED_GROUND_TRUTH.md`.
- **The grip solve** did not tighten cage-clinch grips in the live room - `U153_DIGEST.md`; C168 vs U157 grip-goal collision -
  `U161_DIGEST.md`.
- A pasted "paired anchor rig" recipe was assessed: we are not doing it - `RECIPE_2026-09-21_PAIRED_ANCHOR_RIG.md`.

## Open
- **The colour-suit route for two-body holds restarts as `TASK_C222_GRAPPLING_FROM_SUIT_VIDEO.md`** (Codex, after C221):
  the suits tracked both men in both views (C180); the 3D step goes through SAM 3D Body / MHR (legal, `G95_BODY_MODEL_LICENCES.md`).
- The BJJ presentation line (C134 armbar/terminal TAP, C137 sequence NOT visually acceptable, C138 long script) sits on
  unmerged branches - decide merge or retire.
- Head-to-head contact on `mma_dirty_boxing` was 8% (C167: "the arms must arrive"), measured before later retarget changes -
  re-measure before quoting (`C167_DIGEST.md`).

## Engine
`FightClipBinding.gd` (`PAIRED_BINDINGS`), `PairedStagePlayer.gd`, `FightPoseSolver.gd`, `FightClipRetarget.preserve_pair_contacts`.
Tools: `s31_contact_probe.gd`. Tests: `fight_paired_anchor_test`, `fight_hold_binding_test`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (50, newest first, generated)

- `J56_WHERE_THE_HAND_GOES_ON_THE_NECK.md` (2026-09-27) - J56 - Where the hand goes on the neck (Grok Expert, ex-John; collected S94 2026-09-27)
- `G136_JUDO_GRIP_TO_THROW.md` (2026-09-27) - G136 - JUDO: FROM GRIP TO THROW (Grok, collected S100 2026-09-27)
- `C211_DIGEST.md` (2026-09-27) - C211 fourth run - STOP: fixed surface anchors conflict with retained skin
- `C138_BJJ_LONG_SCRIPT.md` (2026-09-27) - C138 — BJJ long script
- `C135_CASCADEUR_HELD_POSE.md` (2026-09-27) - C135 - Cascadeur did not produce a bindable side control
- `C134_RETARGET_CONT4.md` (2026-09-27) - C134 continuation 4: fix paired travel at the runtime retarget source
- `Q193_DIGEST.md` (2026-09-26) - Q193 Digest — Flip ROLE_PRIORITY_FROM_PLAN, Measured Against All Three Anchors
- `U171_DIGEST.md` (2026-09-25) - U171 digest — standing clinch grips (pass 1)
- `Q171_DIGEST.md` (2026-09-25) - Q171 DIGEST — the pace anchor D1: ground significance override
- `U161_DIGEST.md` (2026-09-24) - U161 digest — C168 vs U157 grip goal collision
- `U157_DIGEST.md` (2026-09-24) - U157 digest — why the grip solve loosened the cage clinch
- `U153_DIGEST.md` (2026-09-24) - U153 digest — live-room grip witness (S63 solve in the bout)
- `U152_DIGEST.md` (2026-09-24) - U152 digest (Cursor)
- `U151_DIGEST.md` (2026-09-24) - U151 — FightPoseSolver blind contract + mount BEFORE probe
- `Q162_DIGEST.md` (2026-09-24) - Q162 DIGEST - do the eight RamsterZ family holds lose their grips in the game?
- `Q161_DIGEST.md` (2026-09-24) - Q161 DIGEST - Render the RamsterZ holds
- `Q160_DIGEST.md` (2026-09-24) - Q160 DIGEST - SEE the 8 holds the family map leans on, and price the 66-technique striking gap
- `G84_WHERE_THE_HANDS_ARE.md` (2026-09-24) - G84 - where the hands and feet are in five ground holds (Grok) - collected S63, 2026-09-24
- `D16_LEG_DOFS_FOR_GRIPS.md` (2026-09-24) - D16 - the leg degrees of freedom for foot and shin grips (Dola) - collected S63, 2026-09-24
- `G77_GENERATE_TWO_BODIES.md` (2026-09-23) - G77 - generate two-person grappling without filming (Grok, Expert, verbatim)
- `PERCHANCE_BJJ_SIM_2026-09-22.md` (2026-09-22) - The perchance BJJ sim holds two bodies in contact. The defect is pose identity.
- `M26_TECHNIQUE_MODAL_STATES.md` (2026-09-22) - M26_TECHNIQUE_MODAL_STATES.md
- `J39_SOLO_GRAPPLING_DEMONSTRATION.md` (2026-09-22) - J39 — Does a solo demonstration of a grappling technique read?
- `G71_POSE_FRAMES.md` (2026-09-22) - G71 — THE ANCHORS FOLLOW THE BONE, THE CONES STAY IN THE TRUNK
- `G70_TYPED_GRIP_ANCHORS.md` (2026-09-22) - G70 — NAMED GRIP ANCHORS ON THE HEAD AND NECK
- `D14_THE_SHOULDER_RIM.md` (2026-09-22) - D14 — THE RIM, RETRACTED IN PART; AND THE FIVE ANCHORS AS ARITHMETIC
- `C168_SIDE_CONTROL.md` (2026-09-22) - C168 - One authored side-control hold
- `U112_VIDEO_MOTION.md` (2026-09-21) - U112 — paired 3D joint streams from broadcast footage
- `S39_THE_GRIP_WAS_READ_ONE_BONE_OFF.md` (2026-09-21) - S39 — 22/23_17 reads 0.099, and the conversion was never the fault
- `S34_GRIP_THROUGH_RETARGET.md` (2026-09-21) - S34 — Does the grip survive the retarget? **Mostly yes: 1.3–2.3 cm of drift.**
- `S31_THE_AUTHORED_CLINCH.md` (2026-09-21) - The first hold this project authored instead of buying — and the one thing that did not survive
- `S30_THE_PAIRED_POSE.md` (2026-09-21) - Two bodies, in contact, authored in Cascadeur - and the channel that made it possible
- `RECIPE_2026-09-21_PAIRED_ANCHOR_RIG.md` (2026-09-21) - RECIPE, pasted by the operator 2026-09-21 — a paired anchor rig in Blender
- `RECIPE_2026-09-21_FULL_SYSTEM_CLAIM.md` (2026-09-21) - RECIPE 2, pasted by the operator 2026-09-21 — "Core System Complete"
- `R155_CMU_PAIRED_GROUND_TRUTH.md` (2026-09-21) - R155 — CMU paired mocap: what is actually there, measured
- `R144_LINES1_2_THE_CATALOGUE_AND_THE_STORE.md` (2026-09-21) - R144 lines 1 and 2 — what can actually be BOUGHT for paired grappling
- `Q123_CLINCH_ARM_GEOMETRY.md` (2026-09-21) - Q123 — Clinch Arm Geometry from the Paired Corpus
- `Q122_CMU_CONTACT_CENSUS.md` (2026-09-21) - Q122 — CMU Paired-Corpus Contact Census
- `DOLA_ROUND3_BRIEF.md` (2026-09-21) - The file you sent does not run. I repaired it and ran it anyway.
- `C150_PAIRED_ANCHOR_CONTRACT.md` (2026-09-21) - C150 paired-anchor contract witness
- `C143_CLINCH_BINDING_CONTRACT.md` (2026-09-21) - C143 — authored clinch hold binding contract
- `C141_HOLD_BINDING_CONTRACT.md` (2026-09-21) - C141 held-position binding contract
- `S26_THE_PACE.md` (2026-09-20) - S26 — J20's D1 pace anchor: the fight was 6.9× too fast, and the lever was one bare literal
- `S25_THE_KNOCKDOWN_ANCHOR.md` (2026-09-20) - S25 — J20's D5 knockdown anchor: the miss is real, and it is not the knockdown
- `C137_PAIRED_BJJ_IN_GAME.md` (2026-09-20) - C137 - one synchronised two-fighter BJJ sequence, playing in FightCamp
- `U85_GUARD_RETURN.md` (2026-09-13) - DECISIONS
- `R106_PAIRED_SURVIVES.md` (2026-09-11) - R106 — PAIRED TWO-BODY ANIMATION SURVIVES THE TRIP TO GODOT
- `Q54_PAIRED_IN_GODOT.md` (2026-09-11) - Q54 — HOW TWO SKELETONS SHARE ONE PERFORMANCE
- `C91_PAIRED_CONTENT.md` (2026-09-11) - C91 - What the thirty-two paired clips actually contain
- `G46_TWO_BODIES_IN_SPACE.md` (2026-09-10) - G46 — TWO BODIES IN SPACE
