# Design & Balance Review — FightCamp KM1

Reviewer #2 (Design & Balance). Evidence reviewed 2026-09-29.

---

## 1. What the evidence says the game is

FightCamp is a gym-management / combat-sports simulator whose balance lives in two layers: a real-time, ruleset-aware fight engine (`FightRealtime.gd`, `ImpactModel.gd`) and a weekly career loop (`GameState.gd`). The current vertical slice supports boxing, kickboxing, muay thai and MMA in the real-time engine, plus judo, taekwondo and freestyle wrestling on the atomic engine (`FightSimulation.gd`).

The fight engine is now calibrated to the J20 UFC/CompuBox corpus by default: the throw gate ships at `THROW_GATE_CALIBRATED` (0.06), the damage model ships with `WEAR_SCALE 3.0` / `HEAD_SHOCK_BASE 0.10`, and recovery is bounded at `RECOVERY_FLOOR 0.05` / `RECOVERY_CEILING 0.45`. The career loop accrues payroll/upkeep monthly, credits membership dues weekly, and settles fights with purses, win bonuses, reputation, ranking points and a flat post-fight fatigue hit.

### Missing material

- **No exported .exe** — balance is judged from code, tests and research docs, not from the operator's watch loop.
- **No full nightly suite log** in the worktree, so the 23 reds reported for 2026-09-28 could not be independently confirmed.
- **No division/sex-specific test fixtures** — every fight test uses generic ~83kg male pairings, while J20 says weight class and sex are not footnotes.
- **No fresh probe of kickboxing/muay thai finish shares** against G108's Glory 33.3% KO/TKO rate.
- **No end-to-end 52-week economic simulation** to verify that starting cash, purses and staff costs produce the intended scarcity curve.
- **No `HANDOFF.md` slice read**, per brief rules.

---

## 2. Strengths to protect

1. **Seeded, deterministic real-time core with isolated RNG streams.** `FightRealtime.gd` keeps separate primes for movement, decision, impact, stoppage, judge, trauma, grapple, evasion, feint, ground-significance and corner rolls. Adding randomness to one subsystem does not shift another's sequence, which is the only way regression baselines stay stable.
2. **Pace calibration is now the default and is gated.** `fight_pace_anchor_test.gd` reports 7.41 combined significant strikes landed/min (J20 D1: 6–8) and 47.71% accuracy (J20 D2: 43–49%).
3. **Occurrence-floor tests prevent dead code.** `fight_realtime_test.gd` asserts that guards, knockdowns, shocks, trauma marks, corner reads and takedowns actually happen in real bouts (378 checks, 0 failures).
4. **Ruleset-aware scoring is solid.** `judge_panel_test.gd` and `fight_scoring_test.gd` pass, covering ten-point-must, ippon, points, senshu, split/majority/unanimous decisions and the ABC damage gate.
5. **Career economy separates fighter wallet from gym cash.** `_apply_fight_result` pays the athlete, books manager/cut-coach shares, tracks career earnings and applies body-readiness damage before a separate injury flag is set.
6. **Corner recovery is a flat, bounded per-minute credit.** `ImpactModel.CORNER_RECOVERY_PER_MIN = 4.0` intentionally avoids giving the most damaged fighter the biggest recovery, making 12-round boxing survivable without abolishing damage.

---

## 3. Findings

### F1 — MMA target mix misses J20 D3 on every axis

- **What:** Real-time MMA landed target mix is **head 46.5% / body 39.1% / leg 14.5%**; J20 D3 documents **61–65% head / 19–23% body / 14–18% leg**. Body is roughly double the real band; head is far below it.
- **Where:** `Godot/scripts/FightRealtime.gd:_run_impact` target selection; lever identified in S26 as `FightMoves.gd:_regions_for`.
- **Evidence / repro:** `Godot/tests/fight_realtime_test.gd` output: `C85 REPORT: MMA landed mix head 46.5% / body 39.1% / leg 14.5% against J20 D3's DOCUMENTED 61-65 / 19-23 / 14-18`.
- **Why it matters:** D3 is one of the six primary validation metrics. The wrong mix makes MMA look like a body-kickboxing hybrid and undermines head-strike and knockdown realism.
- **Severity:** High.
- **Confidence:** High.
- **Specific fix:** Rebalance technique selection / target-region weights so head lands ~60–65%, body ~20% and legs ~15–18%. Re-measure with `fight_realtime_test.gd` and `tools/probe_balance_anchors.gd`.
- **Effort:** Medium.
- **CONFIRMED.**

---

### F2 — Boxing output is inside the test bands but sits low

- **What:** With `boxing_output` ON, the engine reports **40.3 thrown/round**, **25.5% connect** and **35.3% jab share**. The sourced bands are 45–56 thrown/round, 27–32% connect and 40–44% jab share (G99). Feints are 5.4/min against G86's 6–14/min.
- **Where:** `Godot/scripts/FightRealtime.gd` constants `BOXING_OUTPUT_CLOSE_BIAS` through `BOXING_OUTPUT_FOOTWORK_MULT` (`:107-114`); `Godot/tests/boxing_output_test.gd`.
- **Evidence / repro:** Run `boxing_output_test.gd` → `FIGURES ON thrown/rd 40.3 connect 25.5% jab share 35.3%`; `feints/min ON 5.4 (G86 6-14)`.
- **Why it matters:** A boxer who lands 25% and throws 40 punches per round feels less active and less accurate than TV boxing. The test bands are generous; the population is at the lower edge.
- **Severity:** Medium.
- **Confidence:** High.
- **Specific fix:** Tune `BOXING_OUTPUT_RANGE_MULT`, `BOXING_OUTPUT_CONTACT_LADDER` or the throw gate to center on ~48 thrown/round, ~30% connect and ~42% jab share. Re-pin the judge scorecards and re-run the suite.
- **Effort:** Small–Medium.
- **CONFIRMED.**

---

### F3 — Takedown volume is low and accuracy is high vs J20 D6

- **What:** Over 100 bouts `fight_realtime_test.gd` reports **384 takedown attempts** (3.84 combined/fight) with **200 kept** (52.1% accuracy). J20 D6 documents **3.69–7.49 attempts per fighter-fight** and **35–40%** accuracy.
- **Where:** `Godot/scripts/FightRealtime.gd` grapple/takedown path around `:2130-2296` and the `R91` grapple constants.
- **Evidence / repro:** `fight_realtime_test.gd` output: `R91 TAKEDOWNS bouts=100 attempts=384 kept=200 ...`.
- **Why it matters:** If takedowns are too easy and too rare, MMA bouts read as kickboxing matches and wrestlers underperform against the corpus.
- **Severity:** Medium.
- **Confidence:** High.
- **Specific fix:** Increase per-decision-tick attempt probability or reduce success probability; align to J20 per-division bands. Add a takedown-rate occurrence test to the suite.
- **Effort:** Medium.
- **CONFIRMED.**

---

### F4 — Post-fight fatigue is a flat +30 regardless of bout length or damage

- **What:** `_apply_fight_result` adds **30 fatigue** to every fighter after every settled bout. A 12-round decision and a 30-second KO receive the same penalty.
- **Where:** `Godot/scripts/GameState.gd:15195` (`athlete["fatigue"] = clampi(fatigue + 30, 0, 100)`).
- **Evidence / repro:** Code read; `athlete_development_test.gd` passes but does not exercise this scaling.
- **Why it matters:** Training/rest scheduling is a core management verb. A flat penalty removes differentiation between wars and quick wins, and it ignores the body-damage data already recorded in `final_body_condition`.
- **Severity:** Medium.
- **Confidence:** High.
- **Specific fix:** Scale the fatigue increase by `duration_seconds`/rounds and by total damage received, keeping the current 30 as a cap for short bouts.
- **Effort:** Small.
- **CONFIRMED.**

---

### F5 — Kickboxing head-wear multiplier lacks an external anchor

- **What:** `KB_HEAD_WEAR_MULTIPLIER := 2.5` scales all kickboxing head wear to compress damage into 9-minute bouts. The comment calls it a calibration but cites no study or test.
- **Where:** `Godot/scripts/FightRealtime.gd:362` and applied at `:5028`.
- **Evidence / repro:** Code read; G108 documents Glory-class kickboxing KO/TKO at **33.3%** (n=201, 2024–2025). No test pins kickboxing finish share.
- **Why it matters:** Kickboxing is part of the stand-up v1 promise. A 2.5× scalar may over- or under-compress the finish rate; without a gate it is unmeasurable.
- **Severity:** Medium.
- **Confidence:** High.
- **Specific fix:** Add a kickboxing finish-rate occurrence test against G108 and tune the multiplier to land near 30–35% KO/TKO.
- **Effort:** Medium.
- **CONFIRMED.**

---

### F6 — Career starting cash, purses and grade fee are authored without a visible break-even curve

- **What:** Starting cash is **$25,000**, grade fee is **$150**, and tier purses are local **$600/$400**, regional **$1,400/$1,000**, featured **$3,200/$2,400**. Payroll/upkeep accrue monthly; membership dues credit weekly.
- **Where:** `Godot/scripts/GameState.gd:123` (`STARTING_CASH`), `:129` (`GRADE_FEE`), `:210-214` (`FIGHT_TIERS`), `:7070` (`_settle_billing`), `:7605` (`advance_week`).
- **Evidence / repro:** Code read; no 52-week economic probe was run for this review.
- **Why it matters:** If weekly payroll outruns local purses, the player is either forced toward higher tiers before the roster is ready or must grind membership income. The intended scarcity curve is not visible in the constants.
- **Severity:** Medium.
- **Confidence:** Medium.
- **Specific fix:** Build a cash-flow model or run a 52-week simulation to verify break-even at each tier; adjust purses, membership dues or staff salaries accordingly.
- **Effort:** Medium.
- **ASSUMPTION.**

---

### F7 — Ranking / fame / reputation deltas may outpace purse growth

- **What:** A win adds **+24 ranking points**, a loss **-6**. Tier reputation rewards are **3 / 7 / 14**. Fame deltas are computed by `AthleteDevelopment.compute_fight_fame_delta` and confirmed by `athlete_development_test.gd`. A few early wins can unlock higher tiers while purses stay small.
- **Where:** `Godot/scripts/GameState.gd:15080-15082`, `:210-214`; `athlete_development_test.gd` fame-delta check.
- **Evidence / repro:** Code read; tests pass.
- **Why it matters:** A fighter can become famous and highly ranked on $600 purses, making the economy feel disconnected from progression.
- **Severity:** Low–Medium.
- **Confidence:** Medium.
- **Specific fix:** Gate tier unlocks on both reputation/fame and average purse/earnings, or scale reputation/fame rewards with opponent quality.
- **Effort:** Small–Medium.
- **ASSUMPTION.**

---

### F8 — S26/S27 research docs say the damage half is unshipped, but the code has already applied it

- **What:** `S27_THE_DAMAGE_HALF.md` states "No engine constant's shipped value was changed" and lists verified values for a future stage. Current code already ships those values: `ImpactModel.WEAR_SCALE = 3.0`, `HEAD_SHOCK_BASE = 0.10`, `FightRealtime.RECOVERY_FLOOR = 0.05`, `RECOVERY_CEILING = 0.45` and `throw_gate_base = THROW_GATE_CALIBRATED (0.06)`.
- **Where:** `Godot/scripts/ImpactModel.gd:39, :77`; `Godot/scripts/FightRealtime.gd:366-367, :613`; `research/S27_THE_DAMAGE_HALF.md:219-225`.
- **Evidence / repro:** Compare the constants in code to the "verified" column in S27.
- **Why it matters:** Stale research docs create a real risk that a future reviewer treats the live constants as experimental and reverts them, or duplicates the tuning work. The occurrence-floor suite that S27 said was blocking (`fight_realtime_test.gd`) now passes (378 checks, 0 failures).
- **Severity:** Medium.
- **Confidence:** High.
- **Specific fix:** Update S26/S27 digests to reflect the shipped values and the passing suite; remove the set/restore dance in `fight_pace_anchor_test.gd` if the calibrated default is permanent.
- **Effort:** Small.
- **CONFIRMED.**

---

### F9 — Real-time tests use generic 83kg male fixtures while J20 says division and sex matter

- **What:** J20 sections 3.3 and D4 show decision, finish, knockdown and takedown rates vary strongly by weight class and sex. The occurrence-floor tests use fixed wrestler/out-striker, pressure/counter, etc., all around 82–84kg men.
- **Where:** `Godot/tests/fight_realtime_test.gd`, `Godot/tests/fight_pace_anchor_test.gd`; `research/J20_THE_VALIDATION_CORPUS.md`.
- **Evidence / repro:** Read test fixtures and J20 division tables.
- **Why it matters:** A single population cannot validate division/sex-specific targets. A strawweight women's bout would be judged against lightweight men's numbers.
- **Severity:** Medium.
- **Confidence:** High.
- **Specific fix:** Add parameterized fixtures by weight class and sex to the occurrence-floor suite; compare each sub-population to the matching J20 band.
- **Effort:** Medium–Large.
- **ASSUMPTION.**

---

### F10 — Stoppage thresholds (doctor / referee / corner) are authored without cited anchors

- **What:** `DOCTOR_HEAD_CONDITION := 15.0`, `REFEREE_STOPPAGE_SEVERITY := 0.48`, and the corner-stoppage logic set the finish mix. The recovery band is now anchored to J20's 63.5% KD→KO/TKO conditional, but these other thresholds are not tied to external data.
- **Where:** `Godot/scripts/FightRealtime.gd:372, :475, :3026, :3106, :3129`.
- **Evidence / repro:** Code read; G108/J20 provide outcome shares but not the body-condition thresholds that produce them.
- **Why it matters:** Stoppage thresholds shape the finish mix; without anchors, tuning them is guesswork and regressions are hard to catch.
- **Severity:** Medium.
- **Confidence:** Medium.
- **Specific fix:** Derive thresholds from UFC/BoxRec stoppage timing distributions, or add occurrence tests that pin the resulting KO/TKO/sub/decision shares by ruleset.
- **Effort:** Medium.
- **PREFERENCE.**

---

## 4. Summary table

| Finding | Area | Severity | Confidence | Effort | Status |
|---|---|---|---|---|---|
| F1 MMA target mix misses J20 D3 (head low, body high) | Fight engine | High | High | Medium | CONFIRMED |
| F2 Boxing output low in volume, connect and jab share | Fight engine | Medium | High | Small–Medium | CONFIRMED |
| F3 Takedown volume low, accuracy high vs J20 D6 | Fight engine | Medium | High | Medium | CONFIRMED |
| F4 Post-fight fatigue is flat +30 | Career loop | Medium | High | Small | CONFIRMED |
| F5 Kickboxing head-wear multiplier unanchored | Fight engine | Medium | High | Medium | CONFIRMED |
| F6 Starting cash/purses/grade fee lack break-even curve | Economy | Medium | Medium | Medium | ASSUMPTION |
| F7 Ranking/fame/reputation may outpace purse growth | Progression | Low–Medium | Medium | Small–Medium | ASSUMPTION |
| F8 S26/S27 docs stale: damage half is already shipped | Documentation | Medium | High | Small | CONFIRMED |
| F9 No division/sex-specific fixtures | Test coverage | Medium | High | Medium–Large | ASSUMPTION |
| F10 Stoppage thresholds lack external anchors | Fight engine | Medium | Medium | Medium | PREFERENCE |

---

## 5. Bottom line

The real-time fight engine has crossed the most important calibration threshold: pace and per-strike damage now land near the J20 anchors, and the occurrence-floor suite passes. The largest remaining balance risk is the **MMA target mix**, which is off every published band and will distort everything downstream — head-strike counts, knockdown incidence and finish shares — until the technique-selection lever is fixed.

The career layer is structurally sound but its numbers feel authored rather than modelled. A flat post-fight fatigue penalty and an unverified early-game cash-flow curve are the clearest places where management decisions could feel arbitrary rather than consequential. Updating the S26/S27 research docs to match the shipped constants is the cheapest high-value action; without that, the next reviewer is likely to re-litigate work that is already live.
