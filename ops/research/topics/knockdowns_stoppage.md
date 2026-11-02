# Knockdowns, the count, stoppages, the referee, finish rates, one down/one up

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **Knockdown incidence (S):** 35.1% of 8,337 UFC bouts had at least one official KD; combined KDs per fight ~0.41-0.52
  by men's division (J20 **D5** - a knockdown is not a KO) - `J20_THE_VALIDATION_CORPUS.md`. Per-strike KD rate definition
  (Fightnomics 3.9%) is in memory `reference_knockdown_rate_definition`. The engine once ran 1.70 KD/fight (3.3x over) -
  `S25_THE_KNOCKDOWN_ANCHOR.md`; a knockdown that survives the fight and a chin that pays - `S17_CHIN_AND_KNOCKDOWN_LEDGER.md`
  (note: `sim_result["knockdowns"]` counts knockdowns SUFFERED); the atomic-path counter inversion - `Q164_DIGEST.md`.
- **Finish rates (S):** UFC all-time ~53% (not a sport-wide constant); boxing ~47% KO/TKO in BoxRec's modern census (the
  old 25-40% band is too low); kickboxing Glory/Beyond 2024-25 strike stoppages ~33% of 201 bouts - `G108_FINISH_RATES.md`;
  kickboxing finish funnel in our engine - `Q184_DIGEST.md`, `Q186_DIGEST.md`.
- **Stoppages without a knockdown:** a doctor stoppage is ~1% of bouts, not 10% - `K64_STOPPAGES_WITHOUT_A_KNOCKDOWN.md`;
  the standing TKO (the referee steps in) - `S28_THE_STANDING_TKO.md`, `J37_THE_STANDING_STOPPAGE.md`; boxing's outcome mix
  - `K65_THE_DISTANCE_AND_THE_KNOCKDOWN.md`.
- **The count:** J15's 10-25 s knockdown clock is an inherited range, not a measured distribution (searched again, NOT
  FOUND) - `J15_THE_KNOCKDOWN_CLOCK.md`, `K35_THE_COUNT_ACROSS_RULESETS.md`; engine count measured - `Q92_THE_COUNT_MEASURED.md`,
  `C107_KNOCKDOWN_CLOCK.md`; which rulesets let a fighter go to the floor - `K36_THE_FLOOR_BY_RULESET.md`.
- **One down / one up (MMA, after a KD):** v1 acceptance ~35-40% of sequences over by 10 s, ~50-55% by round end -
  `G140_ONE_DOWN_ONE_UP.md`; built in `Q207_DIGEST.md` (merged S113).
- **The referee and the methods:** submission is its own method; the fifth method; referee as a person -
  `G35_REFEREE_AND_METHODS.md`, `J14_THE_REFEREE.md`, `G90_OFFICIALS_AS_PEOPLE.md`; no contest vs technical decision -
  `C48_THE_RESULT_THAT_IS_NOT.md`. Flash knockdowns - `C64_DIGEST.md`; stoppage read - `Q31_THE_STOPPAGE_READ.md`, `C81_DIGEST.md`.

## Open
- **Q207 fight-level check:** KO/TKO given a KD measured 81.5% vs G140's ~63.5% - most KDs end at once through `_go_down`.
  Carried into Q209's census (band 55-72%).

## Engine
`FightRealtime.gd` (`_go_down`, `_run_one_down`, count, stoppage), `FightSimulation.gd` (atomic path), `JudgePanel.gd`.
Tests: `fight_knockdown_count_test`, `fight_stoppage_read_test`, `fight_one_down_test`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (39, newest first, generated)

- `Q207_DIGEST.md` (2026-09-27) - Q207 Digest — One Down / One Up
- `Q174_DIGEST.md` (2026-09-27) - Q174 DIGEST — The Boxing and Kickboxing Clinch (Holding, and the Referee's Break)
- `G140_ONE_DOWN_ONE_UP.md` (2026-09-27) - G140 - One down, one up: the seconds after a knockdown or a stuffed shot (S102)
- `Q184_DIGEST.md` (2026-09-26) - Q184 Digest - Kickboxing Finishes 6.7% vs Glory 33%: Funnel Census + Corner Stoppage Mechanism
- `G127_THE_SHAPES_THAT_MAKE_A_FIGHTER.md` (2026-09-26) - G127 - THE SHAPES THAT MAKE ONE FIGHTER LOOK UNLIKE ANOTHER
- `G108_FINISH_RATES.md` (2026-09-26) - G108_FINISH_RATES
- `Q164_DIGEST.md` (2026-09-24) - Q164 DIGEST — 10-8 without a knockdown
- `G90_BRIEF.md` (2026-09-24) - G90 - OFFICIALS AS PEOPLE, AND COACHES RANKED (Research, no code) - FightCamp, 2026-09-24
- `J37_THE_STANDING_STOPPAGE.md` (2026-09-22) - J37 — THE STANDING STOPPAGE
- `S28_THE_STANDING_TKO.md` (2026-09-20) - S28 — the standing TKO: the referee steps in, and the read that told him was already built
- `S25_THE_KNOCKDOWN_ANCHOR.md` (2026-09-20) - S25 — J20's D5 knockdown anchor: the miss is real, and it is not the knockdown
- `K65_THE_DISTANCE_AND_THE_KNOCKDOWN.md` (2026-09-20) - K65 — Schortgen's athletes, and boxing's outcome mix
- `K64_STOPPAGES_WITHOUT_A_KNOCKDOWN.md` (2026-09-20) - K64 — stoppages that arrive WITHOUT a knockdown
- `AGENT_TOOL_ACCESS.md` (2026-09-20) - AGENT TOOL ACCESS — what is on this machine, how to drive it, and what is missing
- `S17_CHIN_AND_KNOCKDOWN_LEDGER.md` (2026-09-19) - S17 — A knockdown that survives the fight, and a chin that pays for it
- `R148_THREE_RULINGS.md` (2026-09-19) - R148 — THREE OPERATOR RULINGS, AND WHAT EACH ONE COSTS
- `U87_GETUP.md` (2026-09-13) - U87 get-up digest
- `U83_PELVIS_BY_TREE.md` (2026-09-13) - DECISIONS
- `Q92_THE_COUNT_MEASURED.md` (2026-09-13) - DECISIONS
- `Q87_HIP_CARRY.md` (2026-09-13) - DECISIONS
- `K35_THE_COUNT_ACROSS_RULESETS.md` (2026-09-13) - K35 — THE KNOCKDOWN COUNT: DOES THE ROUND CLOCK RUN, AND WHICH RULESETS COUNT AT ALL
- `C107_KNOCKDOWN_CLOCK.md` (2026-09-13) - DECISIONS
- `C103_FACING.md` (2026-09-13) - C103 — facing relations
- `R135_THE_TAGS_AND_THE_ROLE_DISAGREE.md` (2026-09-12) - R135 — THE COUNTER MECHANIC IS HALF-BUILT ALREADY, AND THE TAGS DISAGREE WITH IT
- `Q46_THE_RECEIVERS_DEMAND.md` (2026-09-11) - Q46 — The Receiver's Demand, Which Nobody Has Counted
- `Q31_THE_STOPPAGE_READ.md` (2026-09-10) - Q31 — THE STOPPAGE READ
- `M15_THE_KNOCKDOWN_FRAME.md` (2026-09-10) - M15 — THE KNOCKDOWN FRAME
- `J19_THE_JOINS.md` (2026-09-10) - J19 — THE JOINS (what turns fourteen clips into a fight)
- `J15_THE_KNOCKDOWN_CLOCK.md` (2026-09-10) - J15 — THE KNOCKDOWN CLOCK (how long is a knockdown, and what fills the time)
- `J14_THE_REFEREE.md` (2026-09-10) - J14 — THE REFEREE (who is not in our model at all)
- `G35_REFEREE_AND_METHODS.md` (2026-09-10) - G35 — The Referee, and the Fifth Method
- `C81_DIGEST.md` (2026-09-10) - C81 DIGEST — ASK FOR THE STOPPAGE READ
- `U20_DAMAGE_IN_REAL_TIME.md` (2026-09-09) - U20 — Damage in real time, on a body that already exists
- `R84_DIGEST.md` (2026-09-09) - R84 DIGEST — SCORING, STOPPAGE AND RESULT ON THE REAL-TIME CORE
- `C64_DIGEST.md` (2026-09-09) - C64 digest — reachable flash knockdowns
- `C48_THE_RESULT_THAT_IS_NOT.md` (2026-09-08) - C48 — THE RESULT THAT IS NOT A RESULT
- `C31_THE_CORNER.md` (2026-09-07) - C31 — The corner: who is licensed to be there, and what they do
- `G8_DIGEST.md` (2026-09-04) - G8 — fight record stats
- `C123_UE_MOTION_MATCHING.md` (untracked) - DECISIONS
