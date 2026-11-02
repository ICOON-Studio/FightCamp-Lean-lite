# Footwork, stance, ring position, bearing, movement between exchanges

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **How much fighters move:** ~75-85% of a round is stationary or low intensity (Thomson 2016, Davis) -
  `D22_TIME_MOTION.md`; a coach and a sports scientist measure different things, the operator is closer to the coach -
  `G100_TIME_MOTION.md`; the still man is not frozen (60.1% visibly stepping) - `S15_STILL_MAN.md`, `S10_MOVEMENT_DEGRADES.md`.
- **Footwork economy is ON by default** in boxing, kickboxing and MMA (flipped after measurement) - `Q180_DIGEST.md`,
  `Q181_DIGEST.md`, `Q182_DIGEST.md`, `Q183_DIGEST.md`; its side effects - `U191_DIGEST.md`, `Q196_DIGEST.md`,
  `Q201_DIGEST.md`; honest bands - `Q176_DIGEST.md`-`Q178_DIGEST.md`.
- **Bearing (facing):** a fighter faces his opponent via a turn rate - operator option B, built - `S4E_BEARING_DESIGN.md`,
  `S4E_BEARING.md`; facing measured - `C103_FACING.md`. **Ring position and the cage** - `S4E_RING_POSITION.md`,
  `K63_RING_POSITION_AND_STANCE_STATS.md`, cage size barely moves strikes/round (31-33) - `Q121_CAGE_SIZE.md`.
- **Stance:** `S4E_STANCE.md`, southpaw - `K27_STANCE_AND_THE_SOUTHPAW.md`; a stance switch is a planned change that flips
  closed/open, not a per-round rate - `STANCE_SWITCH_OPINION_GROK.md`, `STANCE_SWITCH_OPINION_DOLA.md`; switches authored in
  Cascadeur - `C173_DIGEST.md`; live stance and kneeling guard - `C174_DIGEST.md`.
- **Between exchanges:** men changed their minds too often, not stood in the wrong place - `S4E_BETWEEN_EXCHANGES.md`;
  what fighters do between punches (footage) - `U109_FOOTAGE_BETWEEN_RATES.md`, `K30_BETWEEN_EXCHANGES_AND_HEAD_IMPACT.md`;
  how fighters move round the ring - `K31_HOW_FIGHTERS_MOVE_AROUND_THE_RING.md`; closing distance - `G79_CLOSING_DISTANCE.md`.
- **Seen footwork in the room:** a shuffle under standing actions - `C215_DIGEST.md`; boxing steps without lifted knees
  (foot rise <=0.10 m) - `U183_DIGEST.md`, step-drag - `U184_DIGEST.md`.

## Open
- **Planted-foot skate gate missed** (p95 wanted <=0.287 m/s): U185 worse, U186 pass on a relabelled instrument, U187 0.981,
  U188 1.18 - `U185_DIGEST.md`-`U188_DIGEST.md`. The instrument itself was audited in Q198. Not merged.
- Travel with a watchable gap - `U89_TRAVEL.md` (send-back, WIP uncommitted).

## Engine
`FightFootwork.gd`, `FightIntent.gd`, `RingSpace.gd`, `FightRealtime.gd` (facing, turn rate), `FightStagePlayer.gd`
(footwork presentation). Tests: `fight_ring_position_test`, `fight_between_exchanges_test`, `*footwork*`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (99, newest first, generated)

- `U89_TRAVEL.md` (2026-09-27) - SEND-BACK 6
- `U191_DIGEST.md` (2026-09-27) - U191 Digest — footwork economy side effects (S99/S100)
- `U188_DIGEST.md` (2026-09-27) - U188 digest — below the baseline (S94)
- `U187_DIGEST.md` (2026-09-27) - U187 digest — planted means planted (S92)
- `U186_DIGEST.md` (2026-09-27) - U186 digest — feet carry the body (S90)
- `U185_DIGEST.md` (2026-09-27) - U185 digest — planted-foot slide instrument + kneel (S90)
- `U184_DIGEST.md` (2026-09-27) - U184 digest — boxing footwork step-drag (idle-bound travel)
- `Q201_DIGEST.md` (2026-09-27) - Q201 Digest - What Did Footwork Economy Actually Move?
- `Q200_DIGEST.md` (2026-09-27) - Q200 Digest — Fix the four defects Q199B found
- `Q197_DIGEST.md` (2026-09-27) - Q197 DIGEST - Where does a thrown man land, and does footwork economy move it?
- `Q196_DIGEST.md` (2026-09-27) - Q196 DIGEST — footwork economy vs submissions/judo throws
- `Q195_DIGEST.md` (2026-09-27) - Q195 Digest - Who Moved the Pinned Bouts?
- `C215_DIGEST.md` (2026-09-27) - C215 - footwork that is seen
- `C134_RETARGET_CONT4.md` (2026-09-27) - C134 continuation 4: fix paired travel at the runtime retarget source
- `U183_DIGEST.md` (2026-09-26) - U183 digest — boxing footwork without lifted knees
- `U178_DIGEST.md` (2026-09-26) - U178 Digest — MMA leg-strike share (footwork ON)
- `S92_FREE_SOUND_AND_MUSIC.md` (2026-09-26) - S92 - FREE SOUND AND MUSIC: GENERATORS AND PACKS (Claude, 2026-09-26)
- `Q183_DIGEST.md` (2026-09-26) - Q183 Digest - Footwork Switch Decided On Every Anchored Row (incl. leg share)
- `Q182_DIGEST.md` (2026-09-26) - Q182 Digest - Footwork Economy Per-Ruleset Default + Boxing/KB Tuned
- `Q181_DIGEST.md` (2026-09-26) - Q181 Digest - The Footwork Default, Powered
- `Q180_DIGEST.md` (2026-09-26) - Q180 Digest - Should Footwork Economy Be On By Default?
- `G107_CROWD_SOURCES.md` (2026-09-26) - G107_CROWD_SOURCES
- `Q178_DIGEST.md` (2026-09-25) - Q178 Digest - Footwork Pass 3: Honest Bands
- `Q177_DIGEST.md` (2026-09-25) - Q177 DIGEST — Footwork economy pass 2: G100-sourced phase lengths
- `Q176_DIGEST.md` (2026-09-25) - Q176 DIGEST — Footwork Economy
- `G100_TIME_MOTION.md` (2026-09-25) - G100 — How much do fighters actually move?
- `D22_TIME_MOTION.md` (2026-09-25) - D22 — HOW MUCH DO FIGHTERS ACTUALLY MOVE?
- `C204_DIGEST.md` (2026-09-25) - C204 - alive stance, default OFF
- `U160_DIGEST.md` (2026-09-24) - U160 digest — strike speed caps and hands while stepping
- `U149_DIGEST.md` (2026-09-24) - U149 digest — distance by phase (unchanged tree baseline for S62)
- `G83_CLINCH_DISTANCE_AND_THIRD_CAMERA.md` (2026-09-24) - G83 - the clinch floor per seat, and the third camera (Grok) - FULL, collected S62 2026-09-24
- `STANCE_SWITCH_OPINION_GROK.md` (2026-09-23) - Stance-switch opinion - Grok (Expert), verbatim
- `STANCE_SWITCH_OPINION_DOLA.md` (2026-09-23) - Stance-switch opinion - Dola, RAW CAPTURE
- `G79_CLOSING_DISTANCE.md` (2026-09-23) - G79 - how close do real fighters get, and how fast? (Grok, collected S61 2026-09-23)
- `C174_DIGEST.md` (2026-09-23) - C174 ? the live stance and upright kneeling guard
- `C173_DIGEST.md` (2026-09-23) - C173 - stance switches authored in Cascadeur
- `RECIPE_2026-09-21_FIGHT_ANIMATION_PIPELINE.md` (2026-09-21) - Pasted recipe, 2026-09-21 — "fight animation pipeline"
- `Q121_CAGE_SIZE.md` (2026-09-21) - Q121 - What cage size does to the fight
- `Q115_CLINCH_DISTANCE.md` (2026-09-21) - Q115 — How far apart are two men in a clinch?
- `S28_THE_STANDING_TKO.md` (2026-09-20) - S28 — the standing TKO: the referee steps in, and the read that told him was already built
- `S23_THE_WEAK_LINE.md` (2026-09-20) - S23 — A man driven down his own base gets it back
- `K65_THE_DISTANCE_AND_THE_KNOCKDOWN.md` (2026-09-20) - K65 — Schortgen's athletes, and boxing's outcome mix
- `K63_RING_POSITION_AND_STANCE_STATS.md` (2026-09-20) - K63 — RING AND CAGE POSITION, STANCE AND DEFENCE: THE STATISTICS THAT ACTUALLY EXIST
- `C133_ENGINE_POSITION_STANCE_DEFENCE.md` (2026-09-20) - C133 - what the engine has for position, stance, defence, feints and the gaps
- `S16_LEGWORK_EQUIPMENT.md` (2026-09-19) - S16 — LEGWORK IN THE GYM: the equipment that trains footwork
- `S15_STILL_MAN.md` (2026-09-18) - S15 — THE STILL MAN: nothing is owed, and here is the measurement that says so
- `S10_MOVEMENT_DEGRADES.md` (2026-09-18) - S10 step 1 - a `movement`-class degrade, and what the body was doing
- `S4J_BOXMIND_DISTANCE.md` (2026-09-17) - S4J — Does BoxMind publish the distance mix? (fetch, then the decision)
- `S4E_BETWEEN_EXCHANGES.md` (2026-09-16) - S4e (6) — THE TIME BETWEEN EXCHANGES: WHAT THE ENGINE HAD, WHAT IT HAS NOW, AND WHAT IS STILL OPEN
- `S4E_STANCE.md` (2026-09-15) - S4e (3) — STANCE: WHAT THE ENGINE HAD, WHAT IT HAS NOW, AND WHAT IS STILL OPEN
- `S4E_RING_POSITION.md` (2026-09-15) - S4e (1) — RING POSITION AND THE CAGE: WHAT THE ENGINE DID, WHAT IT DOES NOW, AND WHAT IS STILL WRONG
- `S4E_BEARING_DESIGN.md` (2026-09-15) - S4e (4) — BEARING: WHICH WAY A FIGHTER IS FACING, AND WHY IT IS THE PIECE THAT TIES THE THREE PIPELINES TOGETH
- `S4E_BEARING.md` (2026-09-15) - S4e (4) — BEARING: A FIGHTER FACES HIS OPPONENT, AND GETTING THERE TAKES TIME
- `V1_BOXING_FROM_VIDEO.md` (2026-09-14) - DECISIONS
- `U98_CLIPS_VS_VIDEO.md` (2026-09-14) - DECISIONS
- `U92_PLANT_CENSUS.md` (2026-09-14) - DECISIONS
- `U91_STANCE_ENTRY.md` (2026-09-14) - U91 — nearest idle phase at return-to-stance (TRACE)
- `U108_CLIP_BEHAVIOUR.md` (2026-09-14) - U108 - what every owned clip does
- `Q98_TAKE_STANCE.md` (2026-09-14) - DECISIONS
- `Q105_HAND_STEPS.md` (2026-09-14) - DECISIONS
- `Q102_UE_ROOT_OFFSET_AND_STRIDE.md` (2026-09-14) - DECISIONS
- `OPERATOR_HIGGSFIELD_CATALOG_RECIPE_2026-09-14.md` (2026-09-14) - Operator direction, 2026-09-14 night: a modular single-actor catalog, assembled by Godot code
- `K62_WATCH_LIST_BETWEEN_PUNCHES.md` (2026-09-14) - K62 - Watch list 7: what fighters do between punches
- `K55_WATCH_LIST.md` (2026-09-14) - K55 — Watch list: YouTube clips for frame-by-frame punch study
- `K50_SPACING_AND_REACH.md` (2026-09-14) - K50 — HOW FAR APART BOXERS STAND, AND HOW FAR A PUNCH GOES INTO THE MAN IT HITS
- `K48_HIT_BOXER_FEET.md` (2026-09-14) - K48 — WHEN A PUNCH LANDS: HOW FAR THE MAN WHO TAKES IT MOVES HIS FEET
- `K47_MIRRORED_STRIKES_IN_SHIPPED_GAMES.md` (2026-09-14) - K47 — REAR HOOKS AND SOUTHPAWS IN SHIPPED FIGHTING GAMES: MIRRORED, LAYERED, OR AUTHORED?
- `K46_BOXER_FEET_DURING_PUNCHES.md` (2026-09-14) - K46 — A BOXER'S FEET DURING A PUNCH: WHAT MOVES, WHAT STAYS, BY HOW MUCH
- `K45_LAYERED_STRIKES.md` (2026-09-14) - K45 — A PUNCH WHILE STEPPING: UPPER/LOWER-BODY LAYERING IN GODOT 4.7, WITHOUT LOSING OUR JOINS
- `J30_MOVE_SCRIPT_METHOD.md` (2026-09-14) - J30 — How to Write a Move Script for Two-Fighter Combat Sports Animation
- `C129_UE_STRIDE_WARPING.md` (2026-09-14) - DECISIONS
- `C127_UE_CONTEXTUAL_ANIMATION.md` (2026-09-14) - DECISIONS
- `BAKEOFF_BLENDER_RETARGET.md` (2026-09-14) - RETARGET BAKE-OFF 1 — OURS AGAINST BLENDER 5.2.1 + THE RETARGET ADD-ON (Claude, 2026-09-14)
- `U84_STRIDE_SPEED.md` (2026-09-13) - DECISIONS
- `U79_ONLY_A_BLOW_LANDS.md` (2026-09-13) - U79 — Only a blow lands: footwork the realtime engine throws as a strike
- `U72_DEFENCE_ANSWERS.md` (2026-09-13) - U72 — Which incoming action each defence answers
- `Q86_STANCE_TAKES.md` (2026-09-13) - DECISIONS
- `Q85_PLAYBACK_MECHANICS.md` (2026-09-13) - Q85 — THE FIVE PLAYBACK MECHANICS S4a's TRANSITIONS STAND ON
- `K31_HOW_FIGHTERS_MOVE_AROUND_THE_RING.md` (2026-09-13) - K31 — KALLI — HOW FIGHTERS MOVE AROUND THE RING: DIRECTION, DISTANCE, AND WHO GOES WHERE
- `K30_BETWEEN_EXCHANGES_AND_HEAD_IMPACT.md` (2026-09-13) - K30 — KALLI — WHAT A FIGHTER DOES BETWEEN EXCHANGES, AND HOW A HIT MOVES HIS HEAD
- `K29_THE_REAL_BOUT_MEASURED.md` (2026-09-13) - K29 — THE REAL BOUT, MEASURED (Kalli)
- `J29_STANCE_AND_FOOTWORK_DEMOS.md` (2026-09-13) - J29 — Amateur Stance and Footwork Demos We Are Allowed to Use
- `C94_LOCOMOTION_CONTENT.md` (2026-09-13) - C94 locomotion shelf measurement
- `Q71_BOXING_EVASION.md` (2026-09-12) - Q71 — Boxing can slip now: which nodes, and what the test should derive
- `R102_DIGEST.md` (2026-09-11) - R102 — THE EXCHANGE HAS TWO SIDES, AND A DISTANCE
- `Q48_ONE_CLIP_TWELVE_BODIES.md` (2026-09-11) - Q48 — ONE CLIP, TWELVE DIFFERENT BODIES
- `Q43_THE_STRIKING_DISTANCE.md` (2026-09-10) - Q43 — AT WHAT DISTANCE DOES A STRIKE ACTUALLY HAPPEN?
- `Q37_THE_MOVEMENT.md` (2026-09-10) - 
- `Q33_DIGEST.md` (2026-09-10) - Q33 DIGEST — 815fe06
- `M18_THE_FOOTWORK.md` (2026-09-10) - M18 — THE FOOTWORK (settle J18 circle claim against M14 HOME)
- `M16_READ_AT_DISTANCE.md` (2026-09-10) - M16 — READ AT DISTANCE (punch TYPE legibility at M14 HOME)
- `K27_STANCE_AND_THE_SOUTHPAW.md` (2026-09-10) - K27 — STANCE AND THE SOUTHPAW
- `J18_THE_OTHER_SEVENTY_PERCENT.md` (2026-09-10) - J18 — THE OTHER SEVENTY PERCENT (locomotion for the ticks that are not a punch)
- `U18_WHAT_MAKES_A_FIGHT_FEEL_REAL.md` (2026-09-09) - U18 — What makes a fight feel real
- `U18_DIGEST.md` (2026-09-09) - U18 DIGEST — what makes a fight feel real
- `R80_DIGEST.md` (2026-09-09) - R80 digest — The burst under the named technique, and the stance that matters
- `Q15_DIGEST.md` (2026-09-09) - Q15 Digest — FightIntent.gd
- `K13_DIGEST.md` (2026-09-05) - K13 DIGEST — CAREER CREATION study (Kalli)
- `K53_BODY_TRAVEL_PER_PUNCH.md` (untracked) - Body travel per punch, and the distance each punch is thrown from
