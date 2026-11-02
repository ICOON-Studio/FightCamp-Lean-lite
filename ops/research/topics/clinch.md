# The clinch: standing, fence, Muay Thai, clinch breaks

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **How much clinch:** UFC clinch ~18% of total fight time (2013; 16% in 2001) - `J32_WHAT_A_REAL_CLINCH_IS.md`; 13.36% of
  fight time in MUTUAL clinch (91 lower-weight bouts) - `K38_THE_CLINCH_BY_SPORT.md`, `Q172_DIGEST.md`. Boxing clinches about
  10% of round time, 5-6 s per clinch (Davis et al. 2015, elite amateurs) - `K38_THE_CLINCH_BY_SPORT.md`.
- **The fence:** most MMA clinch time is against the cage; it is split from open clinch as its own seat (drift, exits,
  wall-walk) - `G138_MMA_FIGHT_STATE_TIME_SHARE.md`, `G139_THE_FENCE_CLINCH.md`, built in `Q206_DIGEST.md` (merged S113).
  G139 anchors: UFC TD success 39% since 2008, 1.5 attempts / 5 min; shots ~50% of attempts, upper-body clinch <10%.
- **What a clinch scores, what breaks it, what a throw from it is worth, per ruleset** - `G39_THE_CLINCH.md` (MMA: no
  published clinch point); Muay Thai adapter `Q24_MUAY_THAI_ADAPTER.md`; blind folds `C73_DIGEST.md`, `C74_DIGEST.md`;
  breaks `J38_THE_CLINCH_BREAK.md`. Muay Thai clinch vocabulary `Q65_MUAY_THAI_TECHNIQUES.md`; why boxers never clinched
  (fixed) `Q93_WHY_BOXERS_NEVER_CLINCH.md`; boxing/kickboxing holding `Q174_DIGEST.md`.
- **Clinch geometry:** two men in a clinch sit at ~0.80 m (floor-position band) - `Q115_CLINCH_DISTANCE.md`; a clinch sways
  at ~0.4 s - `Q116_CLINCH_MOTION.md`; two engine floors (clinch vs strike) - `G83_CLINCH_DISTANCE_AND_THIRD_CAMERA.md`;
  arm geometry from paired mocap - `Q123_CLINCH_ARM_GEOMETRY.md`.
- **Clinch volume** closes the D1 pace gap - `Q172_DIGEST.md`, `Q173_DIGEST.md`; clinch landing work showed NO leg-vs-body
  difference (CI straddles zero) - `Q175_DIGEST.md`.
- **Authored clinch holds**: the hips land, the arms did not arrive (S31); grip passes - `S31_THE_AUTHORED_CLINCH.md`,
  `U171_DIGEST.md`, `C172_DIGEST.md`; see `paired_holds.md`.

## Open
- NOT FOUND anywhere (do not re-commission without a new source idea): MMA clinch EPISODE duration, how a clinch ENDS as
  shares, Muay Thai clinch episode duration, grip-type frequency in competition - `J34_CLINCH_THE_MISSING_NUMBERS.md`;
  boxing clinches per round - `Q173_DIGEST.md`.
- Clinch takedowns vs the ground seats: the fight-level census after Q209 (see `ground.md`).

## Engine
`FightRealtime.gd` (clinch + fence seat, `_near_wall`), `GrappleSeat.gd` ("fence" seat), `GrappleResolve.gd`,
`GrappleAdapter.gd`. Tests: `fight_fence_pin_test` (Q208 branch), `grapple_clinch_contract_test`, `fight_realtime_test`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (53, newest first, generated)

- `Q206_DIGEST.md` (2026-09-27) - Q206 - Fence Pin: Split Fence Pin Off Generic Clinch
- `Q175_DIGEST.md` (2026-09-27) - Q175 DIGEST — LAND THE CLINCH WORK (Q173 + Q174)
- `Q174_DIGEST.md` (2026-09-27) - Q174 DIGEST — The Boxing and Kickboxing Clinch (Holding, and the Referee's Break)
- `Q173_DIGEST.md` (2026-09-27) - Q173 PASS 2 DIGEST — CLINCH SIG SPLIT + TIME SHARE
- `Q172_DIGEST.md` (2026-09-27) - Q172 DIGEST — clinch volume: the last D1 gap
- `G139_THE_FENCE_CLINCH.md` (2026-09-27) - G139 - The Fence Clinch
- `G138_MMA_FIGHT_STATE_TIME_SHARE.md` (2026-09-27) - G138 - Where a Unified-Rules MMA fight spends its time
- `U172_DIGEST.md` (2026-09-25) - U172 digest — defence_model slice 1 (pass 2 gate)
- `U171_DIGEST.md` (2026-09-25) - U171 digest — standing clinch grips (pass 1)
- `J50_HOW_A_DEFENDER_DEFENDS.md` (2026-09-25) - J50 — How a Defender Defends (block, evade, and everything in between)
- `U157_DIGEST.md` (2026-09-24) - U157 digest — why the grip solve loosened the cage clinch
- `U149_DIGEST.md` (2026-09-24) - U149 digest — distance by phase (unchanged tree baseline for S62)
- `Q156_DIGEST.md` (2026-09-24) - Q156 separation A/B digest
- `G83_CLINCH_DISTANCE_AND_THIRD_CAMERA.md` (2026-09-24) - G83 - the clinch floor per seat, and the third camera (Grok) - FULL, collected S62 2026-09-24
- `C172_DIGEST.md` (2026-09-23) - C172 - the four missed holds and clinch contact
- `U133_DIGEST.md` (2026-09-22) - U133 — Arena art pass 5 (cursor)
- `U132_DIGEST.md` (2026-09-22) - U132 — Arena art pass 4 (cursor)
- `J38_THE_CLINCH_BREAK.md` (2026-09-22) - J38 — THE CLINCH BREAK: What Breaks a Clinch, With the Numbers
- `J34_CLINCH_THE_MISSING_NUMBERS.md` (2026-09-22) - J34 — CLINCH: THE MISSING NUMBERS
- `U118_THE_GRAPPLE_SPLIT.md` (2026-09-21) - U118 — The Grapple Split
- `U116_LEAN_SURVIVES.md` (2026-09-21) - U116 — does the clinch lean survive the retarget?
- `S31_THE_AUTHORED_CLINCH.md` (2026-09-21) - The first hold this project authored instead of buying — and the one thing that did not survive
- `Q123_CLINCH_ARM_GEOMETRY.md` (2026-09-21) - Q123 — Clinch Arm Geometry from the Paired Corpus
- `Q116_CLINCH_MOTION.md` (2026-09-21) - Q116 — A clinch is not a statue: how much does it move, and how fast?
- `Q115_CLINCH_DISTANCE.md` (2026-09-21) - Q115 — How far apart are two men in a clinch?
- `J32_WHAT_A_REAL_CLINCH_IS.md` (2026-09-21) - J32 — What a Real Clinch Is, in Numbers
- `C153_CAPSULE_SET.md` (2026-09-21) - C153 — stature-scaled capsules for a standing clinch
- `C146_THE_BLIND_SPLIT_CONTRACT.md` (2026-09-21) - C146 — Blind grapple offence/defence contract
- `C143_CLINCH_BINDING_CONTRACT.md` (2026-09-21) - C143 — authored clinch hold binding contract
- `BRIEF_DOLA_CLINCH_POSE.md` (2026-09-21) - BRIEF — one clinch pose, posed for real
- `K63_RING_POSITION_AND_STANCE_STATS.md` (2026-09-20) - K63 — RING AND CAGE POSITION, STANCE AND DEFENCE: THE STATISTICS THAT ACTUALLY EXIST
- `C133_ENGINE_POSITION_STANCE_DEFENCE.md` (2026-09-20) - C133 - what the engine has for position, stance, defence, feints and the gaps
- `S4E_DEFENCE_MOVEMENT.md` (2026-09-15) - S4e (2) — DEFENCE AS A MOVEMENT DECISION: WHAT THE ENGINE DID, WHAT IT DOES NOW, AND WHAT IS STILL WRONG
- `K56_WATCH_LIST_2.md` (2026-09-14) - K56 — Watch list 2: kicks, knees, elbows, clinch, takedowns, throws, ground (by discipline)
- `U80_DEFENCE_CURVE.md` (2026-09-13) - U80 — Defence cap replaced with diminishing-returns curve
- `U76_DEFENCE_BY_REGION.md` (2026-09-13) - U76 — Which regions each striking defence answers
- `U73_DEFENCE_CAP.md` (2026-09-13) - U73 — Defence bonus saturation in the generated-opponent population
- `U72_DEFENCE_ANSWERS.md` (2026-09-13) - U72 — Which incoming action each defence answers
- `Q93_WHY_BOXERS_NEVER_CLINCH.md` (2026-09-13) - DECISIONS
- `Q91_GROUND_PATHS.md` (2026-09-13) - DECISIONS
- `Q78_JUDO_SAMBO_ESCAPES.md` (2026-09-13) - Q78 — Judo and Sambo Escapes and Defences That Do Not Exist
- `K38_THE_CLINCH_BY_SPORT.md` (2026-09-13) - K38 — HOW OFTEN AND HOW LONG FIGHTERS CLINCH, SPORT BY SPORT
- `J27_FREQUENCIES_AND_THROW_DEFENCE.md` (2026-09-13) - J27 — Frequencies and throw defence
- `Q73_PHASE_BLIND_DEFENCE.md` (2026-09-12) - Q73 — A SHRIMP ESCAPE BLOCKS A JAB: THE PHASE-BLIND DEFENCE BONUS
- `Q65_MUAY_THAI_TECHNIQUES.md` (2026-09-12) - Q65 — MUAY THAI: THE FULL TECHNIQUE VOCABULARY
- `Q58_THE_GRAPPLE_BEAT.md` (2026-09-11) - Q58 — WHAT A GRAPPLE BEAT WOULD HAVE TO CARRY
- `G54_WHAT_IS_DEFENCE.md` (2026-09-11) - G54 — WHAT IS DEFENCE, MEASURABLY?
- `R93_DIGEST.md` (2026-09-10) - R93 DIGEST — G39's PER-SEAT BANDS, THE CLINCH FOLD, AND THE STALL DECIDED (2026-09-10)
- `R92_DIGEST.md` (2026-09-10) - R92 DIGEST — THE ADAPTER BETWEEN THE FOLD AND THE JUDGES, AND THE CLINCH SEAT (2026-09-10)
- `Q24_MUAY_THAI_ADAPTER.md` (2026-09-10) - Q24 — MUAY THAI ADAPTER: WHAT THE CLINCH SCORES, AND WHAT THE ADAPTER MUST REFUSE
- `G39_THE_CLINCH.md` (2026-09-10) - G39 — THE CLINCH: WHAT IT SCORES, WHAT BREAKS IT, WHAT A THROW FROM IT IS WORTH
- `C73_DIGEST.md` (2026-09-10) - C73 digest — G39 clinch fold blind contract
- `C39_DIGEST.md` (2026-09-07) - C39 digest — amateur circuit plumbing
