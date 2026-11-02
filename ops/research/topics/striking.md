# Striking: punches, speed, reach, the exchange, combinations

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **Output bands:** MMA pace/accuracy/targets are J20 D1-D3 (`pace_calibration.md`); boxing per fighter per 3-min round:
  thrown 45-56, landed 13-17, connect 27-32%, **jab 40-44% of thrown** - `G99_COMPUBOX_AVERAGES.md`. The jab was starved by
  the two-stage role picker and fixed - `Q203_DIGEST.md`. The jab's share of punches THROWN in pro MMA: NOT FOUND (do not
  use amateur boxing's 35%) - `J27_FREQUENCIES_AND_THROW_DEFENCE.md`.
- **Speed and timing:** measured effector speeds by strike class; contact lasts 11-14 ms - `G75_STRIKE_SPEEDS.md` (onset
  floors wired into `assets/data/strike_speed_anchors.json` by `U165_DIGEST.md`); 12.0 m/s is AUTHORED, not a measured
  human maximum - `C187_DIGEST.md`; an attack lasts 0.7 +/- 0.2 s and ~25% of attacks are multi-punch -
  `K33_INTER_PUNCH_INTERVALS.md`; the interval inside a combination - `G53_THE_COMBINATION_INTERVAL.md`; retract before
  the next attack (~170 ms power) - `J28_HOW_FIGHT_MOVES_FLOW.md`; the punch timeline - `K32_PUNCH_ARRIVAL_AND_RECOVERY.md`,
  `K54_THE_TIMELINE_OF_A_PUNCH.md`.
- **Reach and distance:** cross fist travel 0.66 +/- 0.07 m (Cheraghi 2014) - `G47_PUNCH_REACH_AND_THE_POCKET.md`; hip
  travel only known for the cross (27.8 +/- 6 cm) - `K53_BODY_TRAVEL_PER_PUNCH.md`; boxers stand ~1.23 m apart (feet
  midpoints, Schortgen) - `K50_SPACING_AND_REACH.md`; closing distance - `G79_CLOSING_DISTANCE.md`; at what distance a
  strike happens - `Q43_THE_STRIKING_DISTANCE.md`; `preferred_range` is SCALED by arm length (decided, flipped) -
  `S4M_PREFERRED_RANGE_UNIT.md`.
- **The exchange is not coin flips** - `G49_THE_EXCHANGE.md`; skill moves land rate (attacker technique 20->90 = -14.2 pp
  for the defender) - `R102_DIGEST.md`; what a miss is - `G51_THE_MISS.md`.
- **Jab types** (range-finder / feint / committed): footage feint 14.7 / min - `Q110_FOOTAGE_JAB_TYPES.md`; in the engine -
  `C132_JAB_TYPES_IN_ENGINE.md`; text-to-motion takes - `U107_T2M_JAB_TYPES.md`.
- **Where a punch lands and what it does:** jaw/lower face in lab work - `K52_WHERE_A_PUNCH_LANDS.md`; a hook ~71 g head
  acceleration (Viano 2005) - `K51_THE_HIT_RESPONSE.md` (see `hit_reactions.md`); feet during a punch (cross GRF ~61% lead)
  - `K46_BOXER_FEET_DURING_PUNCHES.md`; torso rotation in a hook (thoracic ROM ~30-47 deg per side) - `K49_TORSO_IN_A_HOOK.md`.
- **Footage measured our way** (torso-length units) - `V1_BOXING_FROM_VIDEO.md`, `Q109_FOOTAGE_POSTURE.md`, `U109`-`U111`.

## Open
- Strikes still read rough in the room: the operator's preview-quality ruling puts the cause in PLAYBACK and placement,
  not the retarget - see `playback_blend.md`. C202 (strike motion diagnosis) did not deliver a fix.

## Engine
`FightRealtime.gd` (`_run_impact`, `STRIKE_RANGE`), `FightMoves.gd` (picker, role weights), `FightIntent.gd`
(`preferred_range`), `FightRange.gd`. Data: `strike_speed_anchors.json`. Tests: `boxing_output_test`, `fight_strike_whole_test`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (108, newest first, generated)

- `Q203_DIGEST.md` (2026-09-27) - Q203 DIGEST — Three realism reds that are not pins
- `Q101_FM1_TAKES.md` (2026-09-27) - DECISIONS
- `G142_BACK_CONTROL.md` (2026-09-27) - G142 - Back control: from hooks-in to the tap or the escape (Grok, collected S112)
- `G135_FAMOUS_TRAINERS_WHAT_ONLY_THEY_TEACH.md` (2026-09-27) - G135 FAMOUS TRAINERS AND WHAT ONLY THEY TEACH
- `S81_PUNCH_CLUB_2_SURVEY.md` (2026-09-26) - S81 - COMPETITOR SURVEY: Punch Club 2: Fast Forward (Steam app 1161590; demo 2362100)
- `Q192_DIGEST.md` (2026-09-26) - Q192 Digest — Do the fight plans make different fighters? (And the MMA jab row)
- `Q186_DIGEST.md` (2026-09-26) - Q186 DIGEST — WHY KICKBOXERS ARE NOT GETTING HURT (KB HEAD DAMAGE PER MINUTE)
- `C209_DIGEST.md` (2026-09-26) - C209 — stopped at the drill gate; one skipping candidate, no finished station clips
- `U174_DIGEST.md` (2026-09-25) - U174 digest — boxing_output (CompuBox bands)
- `Q170_DIGEST.md` (2026-09-25) - Q170 Digest — TRAPS round 5: the trap you can reach (round 2)
- `G99_COMPUBOX_AVERAGES.md` (2026-09-25) - G99 - CompuBox round averages (Grok, verbatim)
- `G97_BROADCAST_LAYER.md` (2026-09-25) - G97 - How a fight broadcast tells the story (Grok, Expert, collected S75 2026-09-25)
- `C202_DIGEST.md` (2026-09-25) - C202 ? diagnosis only; no production fix accepted
- `U160_DIGEST.md` (2026-09-24) - U160 digest — strike speed caps and hands while stepping
- `U149_DIGEST.md` (2026-09-24) - U149 digest — distance by phase (unchanged tree baseline for S62)
- `G86_FEINTS.md` (2026-09-24) - G86 - FEINTS
- `G75_STRIKE_SPEEDS.md` (2026-09-24) - G75 - STRIKE SPEEDS
- `G75_BRIEF.md` (2026-09-24) - G75 - STRIKE SPEEDS: how fast and how long each real strike is (Grok, research) - S67, 2026-09-24
- `C187_DIGEST.md` (2026-09-24) - C187 - pelvis layer joins and the fist ceiling
- `G79_CLOSING_DISTANCE.md` (2026-09-23) - G79 - how close do real fighters get, and how fast? (Grok, collected S61 2026-09-23)
- `Q135_DIGEST.md` (2026-09-22) - Q135 DIGEST — SOUND PASS 2
- `Q133_DIGEST.md` (2026-09-22) - Q133 DIGEST - Wire every clip we already own to a technique id
- `G67_MOTION_ARCHETYPES.md` (2026-09-22) - G67 — THE MOTION ARCHETYPE MAP, AND THE PROMPT FOR EACH ONE
- `D7_D9_NECK_REACHABILITY.md` (2026-09-22) - D7 — IS YOUR NECK REACHABLE (restated under D9, and the thing we lost)
- `U109_FOOTAGE_BETWEEN_RATES.md` (2026-09-21) - U109 - what fighters do between punches, measured
- `S29_CASCADEUR_GUI_REACHED.md` (2026-09-21) - The Cascadeur GUI route is open, and `auto_posing` is a live object in it
- `DOLA_DOF_BRIEF.md` (2026-09-21) - I ran the corpus. The poses are good. The solver cannot reach them.
- `C145_THE_NAVIGATION_GRAPH.md` (2026-09-21) - C145 — The navigation graph
- `S29_THE_GATES_THAT_WERE_FITTED.md` (2026-09-20) - S29 — the gates were fitted to a sample, and the engine was obeying its own model
- `S19_BALANCE_REACHES_THE_FIGHT.md` (2026-09-19) - S19 — BALANCE REACHES THE FIGHT (R150 stages 0 and 1)
- `U56_TECHNIQUE_DEMAND.md` (2026-09-18) - U56 — TECHNIQUE DEMAND (what reaches a presented beat)
- `S15_ROUTE.md` (2026-09-18) - S15 — THE ROUTE: a walking man stops being counted as a failed puncher
- `S4M_PREFERRED_RANGE_UNIT.md` (2026-09-17) - S4m (B) — the unit on `preferred_range`, decided and corrected
- `S4I_BAND_OCCUPANCY.md` (2026-09-17) - S4i (B) — THE RESIDUAL IS POSITION, NOT THE PRIOR
- `S4F_STRIKE_OPENERS.md` (2026-09-17) - S4f — THE FIVE PUNCHES NOBODY THREW, AND THE ONE NOBODY COULD SEE
- `V1_BOXING_FROM_VIDEO.md` (2026-09-14) - DECISIONS
- `U98_CLIPS_VS_VIDEO.md` (2026-09-14) - DECISIONS
- `U97_R7_R8.md` (2026-09-14) - DECISIONS
- `U96_REAL_SPACING.md` (2026-09-14) - DECISIONS
- `U94_HOOK_GLOBAL.md` (2026-09-14) - DECISIONS
- `U93_HOOK_SPLICE.md` (2026-09-14) - DECISIONS
- `U91_STANCE_ENTRY.md` (2026-09-14) - U91 — nearest idle phase at return-to-stance (TRACE)
- `U90_JOIN_PAIRS.md` (2026-09-14) - DECISIONS
- `U107_T2M_JAB_TYPES.md` (2026-09-14) - U107 - text-to-motion jab types on our fighter
- `U106_HIGGSFIELD_JAB.md` (2026-09-14) - U106 - a Higgsfield jab on our fighter
- `U105_ROOM_AS_FOOTAGE.md` (2026-09-14) - U105 - the live room measured like footage
- `U101_RETIME.md` (2026-09-14) - DECISIONS
- `Q98_TAKE_STANCE.md` (2026-09-14) - DECISIONS
- `Q97_CONTACT_MISS.md` (2026-09-14) - DECISIONS
- `Q96_PHANTOM_LANDINGS.md` (2026-09-14) - DECISIONS
- `Q110_FOOTAGE_JAB_TYPES.md` (2026-09-14) - Q110 - the three jabs in footage
- `Q108_FOOTAGE_BATCH3.md` (2026-09-14) - Q108 - footage batch 3 folded into the two-man table
- `Q107_MOCAP_CHAIN.md` (2026-09-14) - DECISIONS
- `Q104_REACTION_DIRECTION.md` (2026-09-14) - DECISIONS
- `MOVE_SCRIPT_BOXING.md` (2026-09-14) - MOVE SCRIPT - BOXING (v0, Claude, 2026-09-14)
- `K62_WATCH_LIST_BETWEEN_PUNCHES.md` (2026-09-14) - K62 - Watch list 7: what fighters do between punches
- `K61_WATCH_LIST_JAB_TYPES.md` (2026-09-14) - K61 - Watch list 6: the range-finder, the feint and the committed jab
- `K60_WATCH_LIST_5.md` (2026-09-14) - K60 - Watch list 5: the man who gets hit
- `K57_WATCH_LIST_3.md` (2026-09-14) - K57 — Watch list 3: punches landing in super slow motion (the hit and the reaction)
- `K55_WATCH_LIST.md` (2026-09-14) - K55 — Watch list: YouTube clips for frame-by-frame punch study
- `K54_THE_TIMELINE_OF_A_PUNCH.md` (2026-09-14) - The timeline of a punch: when feet, hips, shoulders and fist move, and when the body comes back
- `K52_WHERE_A_PUNCH_LANDS.md` (2026-09-14) - K52 - WHERE A PUNCH LANDS: THE POINT ON THE HEAD, THE ARM AT IMPACT, AND HOW FAR A GLOVE GOES IN
- `K51_THE_HIT_RESPONSE.md` (2026-09-14) - K51 — WHAT A HIT MAN'S HEAD AND BODY DO IN THE FIRST HALF-SECOND
- `K50_SPACING_AND_REACH.md` (2026-09-14) - K50 — HOW FAR APART BOXERS STAND, AND HOW FAR A PUNCH GOES INTO THE MAN IT HITS
- `K49_TORSO_IN_A_HOOK.md` (2026-09-14) - K49 — THE TORSO IN A HOOK: HOW FAR THE HIPS AND CHEST TURN, AND WHERE THE FIST ARRIVES
- `K48_HIT_BOXER_FEET.md` (2026-09-14) - K48 — WHEN A PUNCH LANDS: HOW FAR THE MAN WHO TAKES IT MOVES HIS FEET
- `K47_MIRRORED_STRIKES_IN_SHIPPED_GAMES.md` (2026-09-14) - K47 — REAR HOOKS AND SOUTHPAWS IN SHIPPED FIGHTING GAMES: MIRRORED, LAYERED, OR AUTHORED?
- `K46_BOXER_FEET_DURING_PUNCHES.md` (2026-09-14) - K46 — A BOXER'S FEET DURING A PUNCH: WHAT MOVES, WHAT STAYS, BY HOW MUCH
- `K45_LAYERED_STRIKES.md` (2026-09-14) - K45 — A PUNCH WHILE STEPPING: UPPER/LOWER-BODY LAYERING IN GODOT 4.7, WITHOUT LOSING OUR JOINS
- `C132_JAB_TYPES_IN_ENGINE.md` (2026-09-14) - C132 - the three jabs in the engine
- `C118_UE_REACH_AND_MIRROR.md` (2026-09-14) - DECISIONS
- `C113_CONTACT_CLEARANCE.md` (2026-09-14) - DECISIONS
- `U86_SINGLE_PUNCHES.md` (2026-09-13) - U86 — Single punches come home
- `U75_STRIKE_TARGET_LEGALITY.md` (2026-09-13) - U75 — Strike target legality by engine ruleset
- `Q77_STRIKE_TARGETS.md` (2026-09-13) - Q77 Strike Targets
- `K39_POSE_TRACKER_ACCURACY.md` (2026-09-13) - K39 — CAN A 2D POSE TRACKER MEASURE HOW FAST A FIGHTER'S JOINTS TURN?
- `K33_INTER_PUNCH_INTERVALS.md` (2026-09-13) - K33 — KALLI — HOW FAST ONE FIGHTER'S PUNCHES FOLLOW EACH OTHER IN A REAL BOUT
- `K32_PUNCH_ARRIVAL_AND_RECOVERY.md` (2026-09-13) - K32 — KALLI — HOW LONG A PUNCH TAKES TO ARRIVE, AND HOW LONG A HIT MAN TAKES TO COME BACK
- `J28_HOW_FIGHT_MOVES_FLOW.md` (2026-09-13) - J28 — How Fight Moves Flow
- `J24_WHAT_A_STOP_HIT_COSTS_WHEN_IT_FAILS.md` (2026-09-13) - J24 — WHAT A STOP-HIT COSTS WHEN IT FAILS
- `R137_THE_KICKS_CANNOT_REACH_THE_LEGS.md` (2026-09-12) - R137 — 65% OF KICKS ARE STRUCTURALLY INCAPABLE OF HITTING A LEG
- `Q73_PHASE_BLIND_DEFENCE.md` (2026-09-12) - Q73 — A SHRIMP ESCAPE BLOCKS A JAB: THE PHASE-BLIND DEFENCE BONUS
- `R103_DIGEST.md` (2026-09-11) - R103 DIGEST — THE BEAT PLAYS A CLIP, AND IT PLAYS THE RIGHT ONE
- `R102_DIGEST.md` (2026-09-11) - R102 — THE EXCHANGE HAS TWO SIDES, AND A DISTANCE
- `U43_DIGEST.md` (2026-09-10) - U43 DIGEST — the beat learns the technique
- `U42_DIGEST.md` (2026-09-10) - U42 DIGEST — audit a clip before we pay for it
- `U41_DIGEST.md` (2026-09-10) - U41 DIGEST — mirror three right hands into six
- `U40_DIGEST.md` (2026-09-10) - U40 DIGEST — three punches sliced from combo_jab_cross_hook
- `U39_DIGEST.md` (2026-09-10) - U39 DIGEST — the stage plays a beat
- `R91_DIGEST.md` (2026-09-10) - R91 DIGEST — THE GRAPPLE REACHES THE FIGHT (2026-09-10)
- `Q43_THE_STRIKING_DISTANCE.md` (2026-09-10) - Q43 — AT WHAT DISTANCE DOES A STRIKE ACTUALLY HAPPEN?
- `Q40_THE_EXCHANGE_WE_HAVE.md` (2026-09-10) - Q40 — The Exchange We Have
- `M17_THE_REACTION.md` (2026-09-10) - M17 — THE REACTION (spend M16 freed slots)
- `M16_READ_AT_DISTANCE.md` (2026-09-10) - M16 — READ AT DISTANCE (punch TYPE legibility at M14 HOME)
- `M13_THE_FIGHT_SCREEN.md` (2026-09-10) - M13 — THE FIGHT SCREEN THAT MUST NOT PICK A PUNCH
- `J19_THE_JOINS.md` (2026-09-10) - J19 — THE JOINS (what turns fourteen clips into a fight)
- `J18_THE_OTHER_SEVENTY_PERCENT.md` (2026-09-10) - J18 — THE OTHER SEVENTY PERCENT (locomotion for the ticks that are not a punch)
- `G53_THE_COMBINATION_INTERVAL.md` (2026-09-10) - G53 — THE INTERVAL INSIDE A COMBINATION
- `G51_THE_MISS.md` (2026-09-10) - G51 — WHAT IS A MISS, AND DOES A SIMULATOR NEED ONE?
- `G49_THE_EXCHANGE.md` (2026-09-10) - G49 — A FIGHT IS NOT A SEQUENCE OF COIN FLIPS
- `G48_THE_IK_BOUND.md` (2026-09-10) - G48 — HOW FAR CAN YOU WARP A PUNCH BEFORE IT BREAKS?
- `G47_PUNCH_REACH_AND_THE_POCKET.md` (2026-09-10) - G47 — PUNCH REACH AND THE POCKET, IN METRES
- `G43_THE_FIGHT_CAMERA.md` (2026-09-10) - G43 — THE CAMERA, WHEN MOST PUNCHES ARE NOT DRAWN
- `C72_DIGEST.md` (2026-09-10) - C72 — The fifth method reaches the record
- `R81_DIGEST.md` (2026-09-09) - R81 digest — The camp under the burst, and the hand skill steadies
- `C64_DIGEST.md` (2026-09-09) - C64 digest — reachable flash knockdowns
- `K22_RANGE_READ.md` (2026-09-06) - K22 — THE RANGE, HOW IT READS (Kalli)
- `K53_BODY_TRAVEL_PER_PUNCH.md` (untracked) - Body travel per punch, and the distance each punch is thrown from
