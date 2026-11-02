# Pace, output, round shape, time shares: the validation anchors

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **J20 is the validation corpus for MMA** (`J20_THE_VALIDATION_CORPUS.md`), six anchors, population = UFC:
  **D1** pace: ~2.8-3.8 significant strikes landed per fighter per minute, **combined ~6-8 / min**;
  **D2** accuracy ~40-49% (red 47.9%, blue 43.7%);
  **D3** landed target mix ~61-65% head / 19-23% body / **14-18% leg**;
  **D4** outcomes all-time ~47% decision / ~33% KO/TKO / ~19% sub (modern 51.1 / 31.7 / 17.2; HW KO/TKO ~52%, WSW decision ~67%);
  **D5** 35.1% of bouts with >=1 KD, combined 0.41-0.52 KD/fight; **D6** takedowns, accuracy ~35-40%.
  Round averages per round - `D21_UFC_ROUND_AVERAGES.md`; what UFCStats officially measures - `J33_WHAT_THE_SPORT_MEASURES.md`.
- **Boxing (CompuBox) bands** per fighter per 3-min round: thrown 45-56, landed 13-17, connect 27-32%, **jab 40-44% of
  thrown** - `G99_COMPUBOX_AVERAGES.md`; engine boxing output - `U174_DIGEST.md`.
- **Where an MMA fight spends its time** (J/P): distance / clinch (mostly fence) / ground; LW ~17% ground control -
  `G138_MMA_FIGHT_STATE_TIME_SHARE.md`; engine census after the clinch fix: pooled distance 73.1% / clinch 2.5% / ground
  24.4%, 1.41 TD/5 min, 51.8% landed - `Q205_DIGEST.md` (populations named there; the fence split came in Q206).
- **Pace history:** the fight ran 6.9x too fast until damage/fatigue were decoupled from the tick - `S26_THE_PACE.md`,
  `S27_THE_DAMAGE_HALF.md`; D1 sat at 8.31/min above band and was brought back by the ground significance override and
  clinch volume - `Q171_DIGEST.md`, `Q172_DIGEST.md`. The gates were once fitted to a sample - `S29_THE_GATES_THAT_WERE_FITTED.md`.
- **Round shape and rhythm** - `G52_THE_SHAPE_OF_A_ROUND.md`, `Q42_THE_ROUND_SHAPE.md`, `Q88_ENGINE_RHYTHM.md`,
  `Q94_ENGINE_PACE.md`; how much fighters move (~75-85% of a round stationary/low intensity) - `D22_TIME_MOTION.md`,
  `G100_TIME_MOTION.md`; our outputs in UFC units - `Q39_OUR_NUMBERS.md`, `Q44_THE_PUBLISHED_UNITS.md`.
- **Rule:** never measure identical fighters; name the population in the output (CLAUDE.md).

## Open
- The nightly suite (`AgentComms/nightly/latest.txt`) is the live check of every anchor test; `fight_pace_anchor_test`
  reads D1. Re-measure the whole J20 set after Q209 changes ground time.

## Engine
`FightRealtime.gd`, `FightSimulation.gd`, `RealtimeRoundStats.gd`. Tests: `fight_pace_anchor_test`, `fight_stage_realism_test`,
`boxing_output_test`. Tools: `q205_mma_state_time_census.gd`, `q184_kb_finish_funnel.gd`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (39, newest first, generated)

- `Q205_DIGEST.md` (2026-09-27) - Q205 - MMA State Time Share Census
- `Q173_DIGEST.md` (2026-09-27) - Q173 PASS 2 DIGEST — CLINCH SIG SPLIT + TIME SHARE
- `Q172_DIGEST.md` (2026-09-27) - Q172 DIGEST — clinch volume: the last D1 gap
- `G138_MMA_FIGHT_STATE_TIME_SHARE.md` (2026-09-27) - G138 - Where a Unified-Rules MMA fight spends its time
- `C211_DIGEST.md` (2026-09-27) - C211 fourth run - STOP: fixed surface anchors conflict with retained skin
- `Q193_DIGEST.md` (2026-09-26) - Q193 Digest — Flip ROLE_PRIORITY_FROM_PLAN, Measured Against All Three Anchors
- `Q183_DIGEST.md` (2026-09-26) - Q183 Digest - Footwork Switch Decided On Every Anchored Row (incl. leg share)
- `U174_DIGEST.md` (2026-09-25) - U174 digest — boxing_output (CompuBox bands)
- `Q171_DIGEST.md` (2026-09-25) - Q171 DIGEST — the pace anchor D1: ground significance override
- `G99_COMPUBOX_AVERAGES.md` (2026-09-25) - G99 - CompuBox round averages (Grok, verbatim)
- `D21_UFC_ROUND_AVERAGES.md` (2026-09-25) - D21 - UFC round averages (Dola) - RAW TRANSCRIPT CAPTURE, not a curated deliverable
- `U161_DIGEST.md` (2026-09-24) - U161 digest — C168 vs U157 grip goal collision
- `G70_PLAN_AND_CORNER.md` (2026-09-24) - G70 - PLAN AND CORNER; COACH LINES THAT LIE
- `G70_BRIEF.md` (2026-09-24) - FIGHTPLAN_DESIGN - PASS 3 (Grok, Research mode) - S66, 2026-09-24
- `M24_GAS_INSTRUMENT.md` (2026-09-22) - M24_GAS_INSTRUMENT.md
- `J36_WHAT_THE_ENGINE_KNOWS.md` (2026-09-22) - J36 — What the Engine Already Knows That the Player Never Sees
- `G71_POSE_FRAMES.md` (2026-09-22) - G71 — THE ANCHORS FOLLOW THE BONE, THE CONES STAY IN THE TRUNK
- `G70_TYPED_GRIP_ANCHORS.md` (2026-09-22) - G70 — NAMED GRIP ANCHORS ON THE HEAD AND NECK
- `D14_THE_SHOULDER_RIM.md` (2026-09-22) - D14 — THE RIM, RETRACTED IN PART; AND THE FIVE ANCHORS AS ARITHMETIC
- `RECIPE_2026-09-21_PAIRED_ANCHOR_RIG.md` (2026-09-21) - RECIPE, pasted by the operator 2026-09-21 — a paired anchor rig in Blender
- `J33_WHAT_THE_SPORT_MEASURES.md` (2026-09-21) - J33 — What the Sport Actually Measures About a Fighter
- `C150_PAIRED_ANCHOR_CONTRACT.md` (2026-09-21) - C150 paired-anchor contract witness
- `S27_THE_DAMAGE_HALF.md` (2026-09-20) - S27 — the damage half: what the pace calibration needs beside it
- `S26_THE_PACE.md` (2026-09-20) - S26 — J20's D1 pace anchor: the fight was 6.9× too fast, and the lever was one bare literal
- `S25_THE_KNOCKDOWN_ANCHOR.md` (2026-09-20) - S25 — J20's D5 knockdown anchor: the miss is real, and it is not the knockdown
- `Q94_ENGINE_PACE.md` (2026-09-14) - DECISIONS
- `C122_UE_TWO_BONE_IK.md` (2026-09-14) - DECISIONS
- `C118_UE_REACH_AND_MIRROR.md` (2026-09-14) - DECISIONS
- `U85_GUARD_RETURN.md` (2026-09-13) - DECISIONS
- `Q88_ENGINE_RHYTHM.md` (2026-09-13) - DECISIONS
- `Q44_THE_PUBLISHED_UNITS.md` (2026-09-11) - Q44 — THE PUBLISHED UNITS
- `Q42_THE_ROUND_SHAPE.md` (2026-09-10) - Q42 — The Round Shape at the PI Grain
- `Q41_SKILL_AND_OUTPUT.md` (2026-09-10) - Q41 — Skill and Output: Can the Engine Distinguish a Better Striker?
- `Q39_OUR_NUMBERS.md` (2026-09-10) - Q39 — Our Engine's Outputs, in UFC Units
- `Q32_DIGEST.md` (2026-09-10) - Q32 DIGEST — Beat stream measurement over 200 boxing bouts
- `Q32_BEAT_STREAM.md` (2026-09-10) - Q32 — Beat Stream Measurement
- `J20_THE_VALIDATION_CORPUS.md` (2026-09-10) - J20 — THE VALIDATION CORPUS
- `G46_TWO_BODIES_IN_SPACE.md` (2026-09-10) - G46 — TWO BODIES IN SPACE
- `Q13_DIGEST.md` (2026-09-09) - Q13 DIGEST — RingSpace.gd
