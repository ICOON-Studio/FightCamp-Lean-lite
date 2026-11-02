# Contact and collision: capsules, overlap, contact solver, separation, teleports, DOF

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **Overlap is mostly distance:** ~88% of overlap frames are idle+idle; torsos touched at 0.50 m node gap while POCKET is
  0.80 m and elite guard 1.23 m - `U95_BODY_OVERLAP.md`, `U96_REAL_SPACING.md`; two men cannot stand on the same floor -
  `S4_BODY_RADIUS.md`; the engine keeps the two men apart (S62) - `S62_DIGEST.md`.
- **Capsules:** stature-scaled capsule set, 13 per fighter - `C153_CAPSULE_SET.md`, `S43_THE_CAPSULE_SET.md`; the head is a
  ball, not the neck's problem - `S53_THE_BALL_CAPSULE.md`, `J42_THE_HEAD_AS_A_VOLUME.md`, head radius measured four ways -
  `Q139_HEAD_SPHERE_RADIUS.md`, `Q140_HEAD_COVERAGE.md`; the rib cage is a barrel, not a dome; the flat cap was built,
  measured and did NOT ship - `J43_WHERE_THE_RIB_CAGE_ENDS.md`, `D13_THE_DOME_ON_THE_CHEST.md`, `S54_THE_FLAT_CAP.md`;
  capsule census - `Q132_DIGEST.md`, slenderness - `Q137_SLENDERNESS_CENSUS.md`. Capsule abstraction verdict: the endpoint
  inset is dead (memory `project_capsule_abstraction_verdict`).
- **The contact solver** (surface gaps, three phases) ported and proved on a fixture that can fail - `S42_THE_CONTACT_SOLVER.md`;
  the DOF set on our rig - `S46_THE_DOF_SET.md`; contact offsets derived - `S47_THE_CONTACT_OFFSETS.md`; torso and penetration
  term - `S48_THE_TORSO_AND_THE_HOLD.md`; blind contract - `U151_DIGEST.md`.
- **No body teleports:** six agents' opinions -> one decision: a 3 cm / 10 deg per-frame cap on any root write -
  `OPINION_TELEPORTS_SYNTHESIS.md`; body jumps vs joint pops - `U145_DIGEST.md`, `U146_DIGEST.md`; overlap duration -
  `U147_DIGEST.md`; separation blind contract - `U150_DIGEST.md`; the overlap regression bisect - `U154_DIGEST.md`; wall-aware
  separation (MMA) - `Q202_DIGEST.md`.
- **contact_stop** (a strike stops at the surface) is built and defaults OFF: overlap >3 cm fell from 38.06% to 14.56% of
  frames on one MMA minute - `C191_DIGEST.md`. **hit_physics** experiment: keep OFF - `C188_DIGEST.md`.
- The overlap gate once could not see the overlap it guards - `Q128_DIGEST.md`, `Q129_DIGEST.md`, `Q130_DIGEST.md`.
- **THE CLIPPING GATE (S119, operator: 'find a rule to enforce about clipping'):** no studio publishes a cm tolerance;
  shipped games use a BODY-ONLY push box (limbs excluded), authored strike spacing, IK pins at the contact surface
  (UFC 2 head->hand ray onto collision volumes), physics only as cleanup. Adopted gate: FAIL if any head pair >1 cm for
  >1 frame or any torso pair >2 cm for >3 frames (arms 3 cm/3 f, hips 2 cm/3 f, feet 4 cm/5 f), on any clip or live
  minute - `G147_CLIPPING_RULE_AND_SMOOTHING.md`; instrument `Q213` (tools/q213_clip_gate.gd). Live spacing S119
  (3 min, as_game): median node gap 1.05 m, 20.9% inside POCKET 0.80, 2.1% under 0.60, min 0.31.

## Open
- Whether `contact_stop` goes ON by default (needs the census against J20 pace and the operator's eye).
- C211 (neck reach / collision refit / grip anchors) stopped incomplete - `C211_DIGEST.md`.

## Engine
`FightPoseSolver.gd`, `FightSeparation.gd`, `FightCapsules` / capsule data, `FightWorldLiveScreen.gd` (`_update_pair`,
`_correct_refused_overlap`), `FightRealtime._run_separation`. Tests: `fight_body_overlap_test`, `fight_separation_test`,
`fight_contact_stop_test`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (114, newest first, generated)

- `Q202_DIGEST.md` (2026-09-27) - Q202 DIGEST - Wall-aware separation push (MMA only)
- `C217_DIGEST.md` (2026-09-27) - C217 - active-ragdoll nervous system prototype
- `C211_DIGEST.md` (2026-09-27) - C211 fourth run - STOP: fixed surface anchors conflict with retained skin
- `C136_REBAKED_PAIRS.md` (2026-09-27) - C136 - owned pairs rebaked; contact and position refusals retained
- `C134_TERMINAL_PRESENTATION.md` (2026-09-27) - C134 terminal mount TAP and animated separation
- `C134_CONTACTS_CONT5.md` (2026-09-27) - C134 continuation 5: contact remeasurement
- `C134_BJJ_PRESENTATION.md` (2026-09-27) - C134 continuation 5 - contacts remeasured; visual acceptance still NOT met
- `C134_ARMBAR_RETARGET.md` (2026-09-27) - C134 armbar: lost travel is proven; live contact acceptance remains open
- `U181_DIGEST.md` (2026-09-26) - U181 — skipping clip contact + cardio floor bind
- `C212_DIGEST.md` (2026-09-26) - C212 Mixamo training audition
- `C198_DIGEST.md` (2026-09-25) - C198 standing motion
- `U165_DIGEST.md` (2026-09-24) - U165 digest — strikes that READ (G75 onset→impact floors)
- `U161_DIGEST.md` (2026-09-24) - U161 digest — C168 vs U157 grip goal collision
- `U154_DIGEST.md` (2026-09-24) - U154 digest — overlap regression bisect + single-frame hip budget
- `U151_DIGEST.md` (2026-09-24) - U151 — FightPoseSolver blind contract + mount BEFORE probe
- `U150_DIGEST.md` (2026-09-24) - U150 digest — FightSeparation blind contract (Part 1)
- `Q167_DIGEST.md` (2026-09-24) - Q167_DIGEST — tag every bound strike clip: START, CONTACT, RECOVER-TO-GUARD
- `Q162_DIGEST.md` (2026-09-24) - Q162 DIGEST - do the eight RamsterZ family holds lose their grips in the game?
- `Q156_DIGEST.md` (2026-09-24) - Q156 separation A/B digest
- `G86_PHYSICS_HIT_REACTIONS.md` (2026-09-24) - G86 - physics-driven hit reactions over animation, in Godot 4 (Grok, delivered S65 2026-09-24)
- `D9_LOST_DOLA_RECONSTRUCTION.md` (2026-09-24) - D9 - closed as LOST; Dola's reconstruction filed for the record (S63, 2026-09-24)
- `C191_DIGEST.md` (2026-09-24) - C191 - what still clips
- `C188_DIGEST.md` (2026-09-24) - C188 — struck-segment physics experiment, NOT ACCEPTED
- `C186_DIGEST.md` (2026-09-24) - C186 - hand writers inside one clip
- `C170_DIGEST.md` (2026-09-24) - C170 - rejected closed-guard revision, 2026-09-24
- `U147_DIGEST.md` (2026-09-23) - U147 digest — overlap duration at >3 cm
- `U146_DIGEST.md` (2026-09-23) - U146 digest — no body teleports
- `Q155_DIGEST.md` (2026-09-23) - Q155 digest — U147 persist-trigger push is inert, removed
- `Q144_METRES_HANG.md` (2026-09-23) - Q144 — Does `fight_metres_test.gd` actually hang?
- `OPINION_TELEPORTS_SYNTHESIS.md` (2026-09-23) - Body teleports - six opinions, one decision (Claude, S60, 2026-09-23)
- `OPINION_TELEPORTS_QWEN.md` (2026-09-23) - Opinion: body teleports - Qwen (qwen3-coder, read-only run, 2026-09-23 S60)
- `OPINION_TELEPORTS_JOHN.md` (2026-09-23) - OPINION — HOW TO STOP FIGHTERS' BODIES TELEPORTING, PERMANENTLY
- `OPINION_TELEPORTS_GROK.md` (2026-09-23) - Opinion: body teleports - Grok (Expert), verbatim
- `OPINION_TELEPORTS_DOLA.md` (2026-09-23) - Opinion: body teleports - Dola (RAW CAPTURE, cici read, 2026-09-23 S60)
- `OPINION_TELEPORTS_CURSOR.md` (2026-09-23) - Opinion: body teleports - Cursor (Composer, read-only run, 2026-09-23 S60)
- `OPINION_TELEPORTS_CODEX.md` (2026-09-23) - Opinion: body teleports - Codex (gpt-5.6-luna, read-only run, 2026-09-23 S60)
- `G77_GENERATE_TWO_BODIES.md` (2026-09-23) - G77 - generate two-person grappling without filming (Grok, Expert, verbatim)
- `C175_DIGEST.md` (2026-09-23) - C175 - knee-on-belly against the checked still
- `C172_DIGEST.md` (2026-09-23) - C172 - the four missed holds and clinch contact
- `C169_DIGEST.md` (2026-09-23) - C169 — per-hold results
- `U138_DIGEST.md` (2026-09-22) - U138 digest — last two sweep copies
- `U137_DIGEST.md` (2026-09-22) - U137 digest — `ApproachSweep.gd` and probe conversion
- `U136_DIGEST.md` (2026-09-22) - U136 digest — capsule overlay on the fighter
- `U124_DECLARED_ONLY_GATES.md` (2026-09-22) - U124 — Declared-only gates census
- `S54_THE_FLAT_CAP.md` (2026-09-22) - S54 — THE FLAT CAP IS BUILT, MEASURED, AND DOES NOT SHIP
- `S53_THE_BALL_CAPSULE.md` (2026-09-22) - S53 — THE HEAD IS A BALL, AND IT WAS NEVER THE NECK'S PROBLEM
- `S52_THE_PRESENT_RATIO.md` (2026-09-22) - S52 — THE PRESENT RATIO, AND WHAT IT REFUSED ON ITS FIRST USE
- `S48_THE_TORSO_AND_THE_HOLD.md` (2026-09-22) - S48 — THE TORSO CAPSULE AND THE PENETRATION TERM
- `S47_THE_CONTACT_OFFSETS.md` (2026-09-22) - S47 — THE CONTACT OFFSETS, DERIVED. AND WHY IT WAS NOT THE OFFSETS.
- `S47B_PERCHANCE_TORSO_CONTROL.md` (2026-09-22) - S47B — PERCHANCE'S OWN TORSO, AS AN INDEPENDENT CONTROL
- `S46_THE_DOF_SET.md` (2026-09-22) - S46 — THE DOF SET, MEASURED ON OUR OWN RIG
- `S43_THE_CAPSULE_SET.md` (2026-09-22) - S43 — THE CAPSULE SET THE SOLVER SOLVES, IN METRES
- `Q140_HEAD_COVERAGE.md` (2026-09-22) - Q140 — SETTLE THE HEAD RADIUS WITH A COVERAGE MEASUREMENT, NOT AN ARGUMENT
- `Q139_HEAD_SPHERE_RADIUS.md` (2026-09-22) - Q139 — HOW FAT IS OUR HEAD, REALLY? THE SPHERE RADIUS, MEASURED FOUR WAYS
- `Q139_DIGEST.md` (2026-09-22) - Q139 DIGEST — HEAD SPHERE RADIUS, MEASURED FOUR WAYS ON TWELVE RIGS
- `Q138_SPAN_SENSITIVITY.md` (2026-09-22) - Q138 SPAN SENSITIVITY
- `Q138_DIGEST.md` (2026-09-22) - Q138 DIGEST — span sensitivity sweep
- `Q137_SLENDERNESS_CENSUS.md` (2026-09-22) - Q137 — Slenderness Census: Which Capsules Are Actually Balls, Across All Twelve Rigs
- `Q137_DIGEST.md` (2026-09-22) - Q137 DIGEST
- `Q132_DIGEST.md` (2026-09-22) - Q132 DIGEST - Capsule Census: Every Capsule, Every Rig
- `Q131_DIGEST.md` (2026-09-22) - Q131 DIGEST — thorax sensitivity probe: is the live overlap the same capsule defect?
- `Q130_DIGEST.md` (2026-09-22) - Q130 DIGEST — THE 51 FRAMES NOBODY REFUSED
- `Q129_DIGEST.md` (2026-09-22) - Q129 Digest — Make the Overlap Gate's Fight Actually Start
- `Q128_DIGEST.md` (2026-09-22) - Q128 Digest — THE OVERLAP GATE CANNOT SEE THE OVERLAP IT GUARDS
- `Q127_CODEBASE_CENSUS.md` (2026-09-22) - Q127 — Codebase Census
- `PERCHANCE_BJJ_SIM_2026-09-22.md` (2026-09-22) - The perchance BJJ sim holds two bodies in contact. The defect is pose identity.
- `M31_CAPSULE_OVERLAY_LOOK.md` (2026-09-22) - M31_CAPSULE_OVERLAY_LOOK.md
- `M21_WHAT_IT_LOOKS_LIKE.md` (2026-09-22) - M21 — WHAT IT LOOKS LIKE
- `J44_ABOVE_THE_NOTCH.md` (2026-09-22) - J44 — HOW FAR ABOVE THE STERNAL NOTCH DOES THE SHOULDER GIRDLE SIT?
- `J43_WHERE_THE_RIB_CAGE_ENDS.md` (2026-09-22) - J43 — WHERE DOES A RIB CAGE ACTUALLY END, AND IS A DOME THE RIGHT TOP FOR IT?
- `J42_THE_HEAD_AS_A_VOLUME.md` (2026-09-22) - J42 — IS A HEAD A CAPSULE? THE SKULL AND NECK AS COLLISION VOLUMES
- `G72_G73_BLIND_CAPSULE_CONTRACTS.md` (2026-09-22) - G72 / G73 — TWO BLIND CONTRACTS, AND BOTH FOUND A DEFECT IN THE CONTRACT
- `G61_IS_ENGINE_FIRST_RIGHT.md` (2026-09-22) - G61 — Is the engine-first bet right? Grok says: for grappling yes, for striking no.
- `D8_THE_ENDPOINT_STACKING.md` (2026-09-22) - D8 — DOLA'S ENDPOINT STACKING RULE, AND WHY IT COLLIDES WITH OUR OWN HEADER
- `D4_SPINE_DOF.md` (2026-09-22) - D4 — THE SPINE DOF, AND DOLA'S CLAIM OF 13/13
- `D13_THE_DOME_ON_THE_CHEST.md` (2026-09-22) - D13 — "IT IS A BARREL, NOT A RIB CAGE": THE FLAT CAP, AND STOP ASSERTING ON THE NECK
- `D12_DIFFERENT_HUMANS.md` (2026-09-22) - D12 — "WE ARE NOT MEASURING DIFFERENT ENGINES, WE ARE MEASURING DIFFERENT HUMANS"
- `D11_HEAD_CAP_ANSWER.md` (2026-09-22) - D11 — THE HEAD CAP, AND THE CONTROL THAT SEPARATES "CLEARED" FROM "ERASED"
- `C168_DIGEST.md` (2026-09-22) - C168 - side control contact fix
- `C167_DIGEST.md` (2026-09-22) - C167 - The arms must arrive
- `C166_DIGEST.md` (2026-09-22) - C166 — Approach sweep contract
- `C164_DIGEST.md` (2026-09-22) - C164 digest — capsule shape blind contract
- `C159_DIGEST.md` (2026-09-22) - C159 digest
- `C155_DIGEST.md` (2026-09-22) - C155 digest
- `C154_DIGEST.md` (2026-09-22) - C154 digest
- `S42_THE_CONTACT_SOLVER.md` (2026-09-21) - S42 — the contact solver, ported and proved on a fixture that starts broken
- `S30_THE_PAIRED_POSE.md` (2026-09-21) - Two bodies, in contact, authored in Cascadeur - and the channel that made it possible
- `Q122_CMU_CONTACT_CENSUS.md` (2026-09-21) - Q122 — CMU Paired-Corpus Contact Census
- `DOLA_V4_VERDICT.md` (2026-09-21) - Dola's v4 solver — it renders, it converges, and every pass is vacuous
- `DOLA_V4_SOLVER_BRIEF.md` (2026-09-21) - v4 — three changes, and the first one is why nothing else matters
- `DOLA_DOF_BRIEF.md` (2026-09-21) - I ran the corpus. The poses are good. The solver cannot reach them.
- `C153_CAPSULE_SET.md` (2026-09-21) - C153 — stature-scaled capsules for a standing clinch
- `C134_CONTINUE_5.md` (2026-09-20) - C134 — CONTINUATION 5 — CODEX — THE CONTACTS, WITH THE RETARGET FINALLY CORRECT
- `S4_BODY_RADIUS.md` (2026-09-16) - S4 (4) — TWO MEN CANNOT STAND ON THE SAME FLOOR
- `U97_R7_R8.md` (2026-09-14) - DECISIONS
- `U95_BODY_OVERLAP.md` (2026-09-14) - DECISIONS
- `Q97_CONTACT_MISS.md` (2026-09-14) - DECISIONS
- `Q107_MOCAP_CHAIN.md` (2026-09-14) - DECISIONS
- `Q106_SPIKES.md` (2026-09-14) - DECISIONS
- `K58_COMBAT_MOVE_SCRIPTS.md` (2026-09-14) - K58 — How combat games script a move before they animate it
- `K50_SPACING_AND_REACH.md` (2026-09-14) - K50 — HOW FAR APART BOXERS STAND, AND HOW FAR A PUNCH GOES INTO THE MAN IT HITS
- `J30_MOVE_SCRIPT_METHOD.md` (2026-09-14) - J30 — How to Write a Move Script for Two-Fighter Combat Sports Animation
- `C132_JAB_TYPES_IN_ENGINE.md` (2026-09-14) - C132 - the three jabs in the engine
- `C113_CONTACT_CLEARANCE.md` (2026-09-14) - DECISIONS
- `K37_ABSOLVER_FRAMES.md` (2026-09-13) - K37 — ABSOLVER'S MOVES IN FRAMES: HOW LONG AN ATTACK TAKES, HOW IT CHAINS, HOW A HIT IS RECOVERED FROM
- `K33_INTER_PUNCH_INTERVALS.md` (2026-09-13) - K33 — KALLI — HOW FAST ONE FIGHTER'S PUNCHES FOLLOW EACH OTHER IN A REAL BOUT
- `Q69_RENAME_COLLISIONS.md` (2026-09-12) - Collisions
- `Q49_FOOT_PLANTING.md` (2026-09-11) - Q49 — THE ONE FIX Q48 SAID TO BUY: FOOT PLANTING
- `Q35_THE_COLLISION_FLOOR.md` (2026-09-10) - Q35 — The Collision Floor
- `Q34_THE_METRES.md` (2026-09-10) - Q34 — The Metres
- `G53_THE_COMBINATION_INTERVAL.md` (2026-09-10) - G53 — THE INTERVAL INSIDE A COMBINATION
- `G52_THE_SHAPE_OF_A_ROUND.md` (2026-09-10) - G52 — WHAT DOES A ROUND LOOK LIKE, MINUTE BY MINUTE?
- `G47_PUNCH_REACH_AND_THE_POCKET.md` (2026-09-10) - G47 — PUNCH REACH AND THE POCKET, IN METRES
- `C84_THE_PUSH_APART.md` (2026-09-10) - C84 — The cost of pushing them apart
