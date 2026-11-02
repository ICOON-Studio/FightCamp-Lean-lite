# The ground: seats, ground graph, guard/half/side/mount/back, turtle, traps, submissions, GnP

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **The engine model is event + seat + duration** (a position is a seat; a score is an event or a held count) -
  `G34_GRAPPLING_CONTRACT.md`; seats move on the decision cadence, control accrues on the scoring cadence - `R91_DIGEST.md`.
  Each ruleset folds a grapple into its own score - `G37_THE_ADAPTER_FOLD.md`.
- **Seats exist per ruleset** (they were erased by the catalogue merge and restored) - `S1D_GROUND_SEATS.md`; judo ne-waza
  and matte - `Q72_JUDO_NEWAZA.md`, `J26_IJF_MATTE_AND_ENDINGS.md`. Boxing / Muay Thai never go to the ground - `Q153_DIGEST.md`.
- **A position graph already exists**: `GroundGraph.gd` (S57) - edge table, skill-weighted chooser, hold decay - wired
  behind `ground_arm` ("current" default; "decay", "graph", "both") - `S58_THE_GROUND_GRAPH_WIRED.md`. Its skill term once
  scored 0.000 silently because the training record never reached the live fighter (fixed S58). Blind contracts:
  `U139_DIGEST.md`, `U141_DIGEST.md`; bottom-man chooser `U142_DIGEST.md`; hold decay `U140_DIGEST.md`.
- **Traps** (isolated arm from mount) sit on the graph behind `trap_arm`, default OFF - `G72_TRAPS.md`, `Q169_DIGEST.md`,
  `Q170_DIGEST.md`.
- **Real anchors:** UFC LW ~17% of fight time is one man's ground control (Khabib 41%) - `Q75_WHAT_RESISTS_A_STAND_UP.md`,
  `G138_MMA_FIGHT_STATE_TIME_SHARE.md`; 15-25% ground time and ~2.5-3.0 TD attempts / 15 min - `Q165_DIGEST.md`;
  submission ATTEMPTS 0.5-1.0 per fighter per fight (J20 D6). **Q168/Q170's "1.65 per fighter-fight" was PER BOUT
  (0.83 per fighter)** - `G92_SUB_ATTEMPTS_BY_STYLE.md`. Control time is a logged stat (Chimaev 21:40 of 25:00) - `G38_THE_GROUND_FIGHT_READ.md`.
- **No published per-visit or destination-share data exists** for ground seats (what the bottom man's escape leads to,
  where a throw lands): `G75_THE_MAN_UNDERNEATH.md`, `Q26_LANDING_SEATS.md`. So G142/G143/G144's per-second tables are
  J/P grade (coach + analyst judgement anchored on S rows), not measured:
  back control `G142_BACK_CONTROL.md`; guard/half/side/mount `G143_TOP_POSITIONS.md` (Stage A/B hazards, flags, 7.5 bands);
  skill-gap and style multipliers `G144_GROUND_SKILL_GAPS.md` (55% seat-mass cap, finish-given-lock as a second roll).
- **Stuffed shots** go to front headlock 15-25% / turtle 10-15% - `G141_FRONT_HEADLOCK_AND_TURTLE.md`.
- **Two-body ground animation cannot be generated or bought**: Higgsfield one body in 8/8, composed takedowns 0/36
  (`HIGGSFIELD_MMA_PIPELINE_STUDY.md`); no SKU (`R144_*`); operator ruling: single actor per technique. Authored holds via
  Cascadeur/owned pairs: see `paired_holds.md`.

## Open
- **Q208** (Qwen, in flight S114): back seat as a two-stage hazard machine from G142 - sent back for the log contract
  (`back`/`back_end` events) and its census. Check at merge that it does not fight `GroundGraph` under `ground_arm=graph`.
- **Q209** (held): guard/half/side/mount from G143, **built ON GroundGraph** (hazards = when/how often; graph = which edge;
  G144 replaces the graph's skill term). Blind bands ready: `U194_DIGEST.md`.
- A whole-ground fight-level census of mixed pairs against G143 7.5 and G144 section 5 (after Q209).
- Whether `ground_arm=graph` becomes the default (never decided; S58 measured it against its control).

## Engine
`Godot/scripts/FightRealtime.gd` (`_grapple_ground`, `_move_seat`, `_finish_submission`, back seat), `GroundGraph.gd`,
`GrappleSeat.gd`, `GrappleResolve.gd`, `GrappleAdapter.gd`, `JudoBoard.gd`. Tests: `ground_trap_test`, `fight_back_control_test`,
`fight_back_bands_contract_test` (U193), `fight_ground_bands_contract_test` (U194), `grapple_*`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (115, newest first, generated)

- `U194_DIGEST.md` (2026-09-27) - U194 digest — blind ground seat bands (cursor, S114)
- `Q196_DIGEST.md` (2026-09-27) - Q196 DIGEST — footwork economy vs submissions/judo throws
- `M37_DRESSING_THE_GENERATED_FIGHTER.md` (2026-09-27) - M37 DRESSING THE GENERATED FIGHTER, PER RULESET
- `G144_GROUND_SKILL_GAPS.md` (2026-09-27) - G144 - How a grappling skill gap moves the ground (Grok, collected S114)
- `G143_TOP_POSITIONS.md` (2026-09-27) - G143 - Mount, side control, half guard, guard: the rest of the ground (Grok, collected S113)
- `G142_BACK_CONTROL.md` (2026-09-27) - G142 - Back control: from hooks-in to the tap or the escape (Grok, collected S112)
- `G141_FRONT_HEADLOCK_AND_TURTLE.md` (2026-09-27) - G141 - Front headlock and turtle: where stuffed shots go (S103)
- `G138_MMA_FIGHT_STATE_TIME_SHARE.md` (2026-09-27) - G138 - Where a Unified-Rules MMA fight spends its time
- `C138_BJJ_LONG_SCRIPT.md` (2026-09-27) - C138 — BJJ long script
- `C137_BJJ_SEQUENCE.md` (2026-09-27) - C137 second run — demonstration delivered, visual result UNFINISHED
- `C135_CASCADEUR_HELD_POSE.md` (2026-09-27) - C135 - Cascadeur did not produce a bindable side control
- `C134_TERMINAL_PRESENTATION.md` (2026-09-27) - C134 terminal mount TAP and animated separation
- `C134_CONTACTS_CONT5.md` (2026-09-27) - C134 continuation 5: contact remeasurement
- `C134_BJJ_PRESENTATION.md` (2026-09-27) - C134 continuation 5 - contacts remeasured; visual acceptance still NOT met
- `C134_ARMBAR_RETARGET.md` (2026-09-27) - C134 armbar: lost travel is proven; live contact acceptance remains open
- `Q171_DIGEST.md` (2026-09-25) - Q171 DIGEST — the pace anchor D1: ground significance override
- `Q170_DIGEST.md` (2026-09-25) - Q170 Digest — TRAPS round 5: the trap you can reach (round 2)
- `G92_SUB_ATTEMPTS_BY_STYLE.md` (2026-09-25) - G92 - Submission attempts by style (Grok, VERBATIM)
- `G92_BRIEF.md` (2026-09-25) - 
- `D17_LEG_LIMITS_CITED.md` (2026-09-25) - D17 - leg limits, cited or relabelled (Dola, 2026-09-25)
- `C199_DIGEST.md` (2026-09-25) - C199 — corrected legal MMA closed-guard baseline
- `U156_DIGEST.md` (2026-09-24) - U156 — stature: engine, mount target, tape measure
- `U151_DIGEST.md` (2026-09-24) - U151 — FightPoseSolver blind contract + mount BEFORE probe
- `Q169_DIGEST.md` (2026-09-24) - Q169 Digest — TRAPS slice 1: the isolated arm from mount
- `Q168_SUBMISSION_BASELINE.md` (2026-09-24) - Q168 Submission Baseline for TRAPS
- `Q167_DIGEST.md` (2026-09-24) - Q167_DIGEST — tag every bound strike clip: START, CONTACT, RECOVER-TO-GUARD
- `Q166_DIGEST.md` (2026-09-24) - Q166 Digest Round 2 — MEASUREMENTS
- `Q165_DIGEST.md` (2026-09-24) - Q165 Digest - "no ground game at all, no take down"
- `Q163_DIGEST.md` (2026-09-24) - Q163 DIGEST - what unit are the RamsterZ sources in? Fix the probe, re-measure the holds
- `Q162_DIGEST.md` (2026-09-24) - Q162 DIGEST - do the eight RamsterZ family holds lose their grips in the game?
- `Q159_DIGEST.md` (2026-09-24) - Q159 DIGEST - Apply G82 lie list to family bindings, then striking FAMILY class
- `Q158_DIGEST.md` (2026-09-24) - Q158 DIGEST - SEE what Q157 bound, then do the same for the 186 striking NONE
- `G84_WHERE_THE_HANDS_ARE.md` (2026-09-24) - G84 - where the hands and feet are in five ground holds (Grok) - collected S63, 2026-09-24
- `G82_GRAPPLING_POSITION_TAXONOMY.md` (2026-09-24) - G82 - the grappling POSITION TAXONOMY: an independent audit of the 21 owned holds (Grok)
- `G73_THE_MECHANISM_AUDIT.md` (2026-09-24) - G73 - THE MECHANISM AUDIT
- `G72_TRAPS.md` (2026-09-24) - G72 - TRAPS
- `C183_DIGEST.md` (2026-09-24) - Scope and declaration
- `C182_DIGEST.md` (2026-09-24) - C182 - checkpoint, not an accepted turtle delivery
- `C170_DIGEST.md` (2026-09-24) - C170 - rejected closed-guard revision, 2026-09-24
- `U143_DIGEST.md` (2026-09-23) - U143 DIGEST — Name the control family (grapple namer)
- `U142_DIGEST.md` (2026-09-23) - U142 digest — bottom-man ground chooser
- `U141_DIGEST.md` (2026-09-23) - U141 digest — ground chooser wiring contract (blind)
- `U140_DIGEST.md` (2026-09-23) - U140 digest — hold decay shape (`cursor/u140-decay-shape`)
- `U139_DIGEST.md` (2026-09-23) - U139 digest — blind `GroundGraph` contract test
- `S58_THE_GROUND_GRAPH_WIRED.md` (2026-09-23) - S58 — THE GROUND GRAPH, WIRED AND MEASURED AGAINST ITS OWN CONTROL
- `Q153_DIGEST.md` (2026-09-23) - Q153 DIGEST — per-ruleset ground policy; Muay Thai/boxing never stay on the ground
- `Q152_DIGEST.md` (2026-09-23) - Q152 DIGEST — Judo and Muay Thai grapple naming coverage
- `Q147_DIGEST.md` (2026-09-23) - Q147 DIGEST — Grapple Naming Contract Test
- `G76_TWO_FAILURES_AND_WHAT_ELSE.md` (2026-09-23) - G76 - TWO FAILURES AND WHAT ELSE (Grok, Expert) - RAW CAPTURE OF THE CHAT ANSWER
- `G75_THE_MAN_UNDERNEATH.md` (2026-09-23) - G75 - THE MAN UNDERNEATH (Grok, Expert), verbatim
- `C174_DIGEST.md` (2026-09-23) - C174 ? the live stance and upright kneeling guard
- `C171_DIGEST.md` (2026-09-23) - C171 - standing hold queue
- `C169_DIGEST.md` (2026-09-23) - C169 — per-hold results
- `R144_LINE2_MARTIAL_ARTS_MASTER_RESOLVED.md` (2026-09-22) - R144 LINE 2 CLOSED — "MARTIAL ARTS MASTER" HAS NO GROUND WORK, AND NEITHER PACK SOLVES THE GRAPPLING WALL
- `Q128_DIGEST.md` (2026-09-22) - Q128 Digest — THE OVERLAP GATE CANNOT SEE THE OVERLAP IT GUARDS
- `PERCHANCE_BJJ_SIM_2026-09-22.md` (2026-09-22) - The perchance BJJ sim holds two bodies in contact. The defect is pose identity.
- `C168_SIDE_CONTROL.md` (2026-09-22) - C168 - One authored side-control hold
- `C168_DIGEST.md` (2026-09-22) - C168 - side control contact fix
- `R155_CMU_PAIRED_GROUND_TRUTH.md` (2026-09-21) - R155 — CMU paired mocap: what is actually there, measured
- `J33_WHAT_THE_SPORT_MEASURES.md` (2026-09-21) - J33 — What the Sport Actually Measures About a Fighter
- `DOLA_V4_SOLVER_BRIEF.md` (2026-09-21) - v4 — three changes, and the first one is why nothing else matters
- `S22_THE_SCRAMBLE.md` (2026-09-20) - S22 — A scramble costs the man who was put on the floor
- `R144_LINE12_SKU_SEARCH.md` (2026-09-20) - R144 lines 1–2 — the ground-hold SKU search: two leads checked, both negative
- `C137_PAIRED_BJJ_IN_GAME.md` (2026-09-20) - C137 - one synchronised two-fighter BJJ sequence, playing in FightCamp
- `C134_CONTINUE_3.md` (2026-09-20) - C134 — CONTINUATION 3 — CODEX — **NO SCOPE BOUND**
- `C134_CONTINUE_2.md` (2026-09-20) - C134 — CONTINUATION 2 — CODEX
- `C134_CONTINUE.md` (2026-09-20) - C134 — CONTINUATION 1 — CODEX
- `S8_GROUND_CENSUS.md` (2026-09-18) - S8 — THE GROUND GAME, COUNTED, AND A RETRACTION
- `S6C_GROUND_STRIKES.md` (2026-09-18) - S6C — the ground strike gets a path, and a film stops shrinking the man
- `S6B_CLIP_CONTENT.md` (2026-09-18) - S6b — WHAT THE UNBOUND CLIPS ACTUALLY ARE
- `S12_GROUND_HOLD.md` (2026-09-18) - S12 — the ground hold, and where the fight actually is when it is on the floor
- `R144_LINE3_AUTHORING_COST.md` (2026-09-18) - R144 LINE 3 - AUTHOR THE GROUND FILM IN BLENDER, PRICED IN TIME
- `OPERATOR_HIGGSFIELD_CATALOG_RECIPE_2026-09-14.md` (2026-09-14) - Operator direction, 2026-09-14 night: a modular single-actor catalog, assembled by Godot code
- `U87_GETUP.md` (2026-09-13) - U87 get-up digest
- `U85_GUARD_RETURN.md` (2026-09-13) - DECISIONS
- `Q91_GROUND_PATHS.md` (2026-09-13) - DECISIONS
- `Q90_GROUND_UNDER_STRIKING_RULES.md` (2026-09-13) - DECISIONS
- `Q86_STANCE_TAKES.md` (2026-09-13) - DECISIONS
- `Q81_FAILED_SCRAMBLE_CARRY.md` (2026-09-13) - Q81 — A FAILED STAND-UP SHOULD NOT WIPE THE CHOKE
- `Q75_WHAT_RESISTS_A_STAND_UP.md` (2026-09-13) - Q75 — What resists a stand-up
- `Q74_SUBMISSION_TARGETS.md` (2026-09-13) - Q74 — Submission Target-Region Census
- `K36_THE_FLOOR_BY_RULESET.md` (2026-09-13) - K36 — WHEN A FIGHTER GOES TO THE FLOOR: WHICH RULESETS LET THE FIGHT CONTINUE THERE, AND FOR HOW LONG
- `J26_IJF_MATTE_AND_ENDINGS.md` (2026-09-13) - J26 — JOHN — MATTE, NE-WAZA LENGTH, AND HOW JUDO BOUTS END
- `C109_ROUND_LENGTH_DEFAULT.md` (2026-09-13) - DECISIONS
- `U70_SUBMISSION_ACCUMULATOR.md` (2026-09-12) - U70 — Submission accumulator: why ground finishes vanish
- `U60_JUDO_BJJ_TECHNIQUES.md` (2026-09-12) - U60 / U60B — Judo & Brazilian Jiu-Jitsu: the real vocabulary
- `U60_INPUT_BJJ_BELT_CHECKLIST.md` (2026-09-12) - INPUT FOR U60 — the operator's BJJ belt progression checklist, and what it misses
- `S1D_GROUND_SEATS.md` (2026-09-12) - S1d — THE GROUND HAD NO SEATS: WHAT THE MERGE ERASED, WHAT CAME BACK, WHAT IT EXPOSED
- `R136_THE_VALIDATOR_WAS_THE_BUG.md` (2026-09-12) - R136 — THE GATE WAS WRONG, SO GOOD DATA WAS EDITED TO PASS IT
- `Q72_JUDO_NEWAZA.md` (2026-09-12) - Q72 - Judo's ground is held out of S1d: the rules and the seats it needs
- `Q71_BOXING_EVASION.md` (2026-09-12) - Q71 — Boxing can slip now: which nodes, and what the test should derive
- `U57_GRAPPLE_PROMOTION.md` (2026-09-11) - U57 — What the Ground Fight Is Worth on Screen
- `Q55_THE_GROUND_CAMERA.md` (2026-09-11) - Q55 — THE GROUND CAMERA
- `Q51_ELEVATION_AND_MATERIAL.md` (2026-09-11) - Q51 — ELEVATION AND MATERIAL ON A DARK GROUND
- `Q50_GI_AND_KIT.md` (2026-09-11) - Q50 — THE GI AND THE SHIN GUARDS: WHAT TO BUY ON 2026-09-14
- `U29_DIGEST.md` (2026-09-10) - U29 DIGEST — GrappleAdapter blind contract test
- `R91_DIGEST.md` (2026-09-10) - R91 DIGEST — THE GRAPPLE REACHES THE FIGHT (2026-09-10)
- `Q25_GROUND_READ_AUDIT.md` (2026-09-10) - Q25 — THE GROUND FIGHT READ, AUDITED AGAINST WHAT WE ACTUALLY BUILT
- `Q23_DIGEST.md` (2026-09-10) - Q23 DIGEST — FightHudRead carries the seat
- `Q22_DIGEST.md` (2026-09-10) - Q22 DIGEST — GrappleAdapter.gd
- `Q19_DIGEST.md` (2026-09-10) - Q19 Digest — GrappleSeat.gd
- `G41_NOT_ROUNDS.md` (2026-09-10) - G41 — JUDO, WRESTLING AND BJJ ARE NOT ROUNDS
- `G38_THE_GROUND_FIGHT_READ.md` (2026-09-10) - G38 — THE GROUND FIGHT READ
- `G37_THE_ADAPTER_FOLD.md` (2026-09-10) - G37 — THE ADAPTER FOLD: HOW EACH RULESET SCORES A GRAPPLE
- `C76_DIGEST.md` (2026-09-10) - C76 — BJJ contest length
- `C75_ANIMATION_SOURCES.md` (2026-09-10) - C75 — Animation sources beyond Ludo
- `C70_DIGEST.md` (2026-09-10) - C70 — grappling blind-test audit
- `G34_GRAPPLING_CONTRACT.md` (2026-09-09) - G34 — Grappling contract for the real-time tick engine
- `C55_THE_PATH.md` (2026-09-08) - C55 — THE PATH: HOW A FIGHTING CAREER IS ACTUALLY WALKED
- `C54_WHAT_A_FEDERATION_COSTS.md` (2026-09-08) - C54 — What a Federation Costs the Player
- `C52_THE_TOURNAMENT_AND_THE_GRADE.md` (2026-09-08) - C52 — The Tournament and the Grade
- `C52_DIGEST.md` (2026-09-08) - C52 DIGEST — The Tournament and the Grade
- `C46_THE_BELTS_OWNER.md` (2026-09-08) - C46 — The Belt's Owner, Discipline by Discipline
- `J2_THE_FEDERATION_PATHWAY.md` (2026-09-06) - J2 — The Federation Pathway: How You Get In, and Who Pays
- `SHOT_LIST_GROUND.md` (untracked) - SHOT LIST - GROUND (generated S114 from `GroundGraph.EDGES`; regenerate when the graph changes)
