# Scoring, judges, decisions, 10-8s, methods of result

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **Three judges, three cards per round** - `M5_SCORECARD_THREE_JUDGES.md`; `JudgePanel.gd` seats N judges with a small
  anonymous per-bout multiplier on secondary criteria only - `G90_OFFICIALS_AS_PEOPLE.md`; organization rules and judges -
  `J1_ORGANIZATION_RULES_AND_JUDGES.md`; the real-time fight meets the judges - `U22_DIGEST.md` (RoundScoring); scorecard
  screen - `U24_DIGEST.md`, `M4_POST_FIGHT_READ.md`.
- **Each ruleset folds a grapple into its own score** - `G37_THE_ADAPTER_FOLD.md`; Muay Thai - `Q24_MUAY_THAI_ADAPTER.md`;
  wrestling (UWW bands; step-out not scored; submission never a finish) - `U29_DIGEST.md`; clinch per ruleset -
  `G39_THE_CLINCH.md`; judo position points - `R93_DIGEST.md`, `Q76_JUDO_AT_TIME.md`; judo throw scoring - see
  `takedowns_throws.md`.
- **Methods:** submission is its own method; the fifth method - `G35_REFEREE_AND_METHODS.md`, `C72_DIGEST.md`; no contest
  is a fourth result across the whole settlement graph (NC before 2 of 3 / 3 of 5 rounds, technical decision after) -
  `C48_THE_RESULT_THAT_IS_NOT.md`, `C50_DIGEST.md`. 10-8 rounds without a knockdown - `Q164_DIGEST.md`.
- **Outcome mix to hit:** J20 D4 (see `pace_calibration.md`); finish rates by sport - `G108_FINISH_RATES.md`.
- **Explaining the result:** what makes an outcome feel honest - `K70_HONEST_OUTCOMES.md`; the causation card -
  `K71_CAUSATION_CARD.md`; the result screen must lead with THE PLANS - `D50_DIGEST.md`.
- Seeded replay needs integer tick time - `C62_DIGEST.md`.
- **BOOKED-BOUT BOXING (S119, Q212):** on the game's own offer board KO+TKO 46.7%, draws 5.8%; even census pairs
  inflate draws (11.7%). The three judges NEVER disagree - 0 split in 54 decisions (OPEN). Pro draw rate: PROXY 2-3%,
  no sourced figure - `G146_BOXING_DRAW_RATE.md`, `Q212_DIGEST.md`.

## Open
- Judges and referees as people (identity, tendencies) - researched in `G90_OFFICIALS_AS_PEOPLE.md`, not built.

## Engine
`JudgePanel.gd`, `RoundScoring.gd`, `GrappleAdapter.gd`, `JudoBoard.gd`, `FightContract.gd`, `ScorecardRead.gd`,
`FightResultPanel.gd`. Tests: `fight_scoring_test` (red on master - uchi-mata pin), `judge_*`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (45, newest first, generated)

- `Q204_DIGEST.md` (2026-09-27) - Q204 DIGEST — Judo: one standing attack in eight scores, not one in five
- `G136_JUDO_GRIP_TO_THROW.md` (2026-09-27) - G136 - JUDO: FROM GRIP TO THROW (Grok, collected S100 2026-09-27)
- `G131_HOW_OFTEN_A_JUDO_THROW_SCORES.md` (2026-09-27) - G131 - HOW OFTEN A JUDO THROW SCORES (Grok, collected S96 2026-09-27)
- `DECISION_LEDGER.md` (2026-09-27) - DECISION LEDGER - operator rulings that were made and then ignored (S114 audit, 2026-09-27)
- `D50_DIGEST.md` (2026-09-27) - D50 - Dola: fresh eyes on the whole result screen (S102 render)
- `Q164_DIGEST.md` (2026-09-24) - Q164 DIGEST — 10-8 without a knockdown
- `G90_OFFICIALS_AS_PEOPLE.md` (2026-09-24) - G90 - OFFICIALS AS PEOPLE, AND COACHES RANKED
- `G90_BRIEF.md` (2026-09-24) - G90 - OFFICIALS AS PEOPLE, AND COACHES RANKED (Research, no code) - FightCamp, 2026-09-24
- `OPINION_TELEPORTS_SYNTHESIS.md` (2026-09-23) - Body teleports - six opinions, one decision (Claude, S60, 2026-09-23)
- `OPINION_TELEPORTS_JOHN.md` (2026-09-23) - OPINION — HOW TO STOP FIGHTERS' BODIES TELEPORTING, PERMANENTLY
- `K71_CAUSATION_CARD.md` (2026-09-22) - K71_CAUSATION_CARD.md
- `K70_HONEST_OUTCOMES.md` (2026-09-22) - K70 - WHAT MAKES A SIMULATED FIGHT OUTCOME FEEL HONEST
- `S4J_BOXMIND_DISTANCE.md` (2026-09-17) - S4J — Does BoxMind publish the distance mix? (fetch, then the decision)
- `S4E_DEFENCE_MOVEMENT.md` (2026-09-15) - S4e (2) — DEFENCE AS A MOVEMENT DECISION: WHAT THE ENGINE DID, WHAT IT DOES NOW, AND WHAT IS STILL WRONG
- `U77_THE_LIMB_THAT_SCORES.md` (2026-09-13) - U77 — The limb that scores
- `U74_JUDO_THROWS_OVERSCORE.md` (2026-09-13) - U74 — A landed judo throw is nearly always a score
- `Q76_JUDO_AT_TIME.md` (2026-09-13) - Q76 — A judo bout at time is decided by things judo does not score
- `S1_RECONCILIATION.md` (2026-09-12) - S1 RECONCILIATION — 21 red to 12, and why the rest is one decision
- `R130_UNREAD_EFFECTS_DECISION_SHEET.md` (2026-09-12) - 
- `U29_DIGEST.md` (2026-09-10) - U29 DIGEST — GrappleAdapter blind contract test
- `R92_DIGEST.md` (2026-09-10) - R92 DIGEST — THE ADAPTER BETWEEN THE FOLD AND THE JUDGES, AND THE CLINCH SEAT (2026-09-10)
- `R91_DIGEST.md` (2026-09-10) - R91 DIGEST — THE GRAPPLE REACHES THE FIGHT (2026-09-10)
- `R90_DIGEST.md` (2026-09-10) - R90 DIGEST — THE GRAPPLE ARC CONVERGES
- `Q24_MUAY_THAI_ADAPTER.md` (2026-09-10) - Q24 — MUAY THAI ADAPTER: WHAT THE CLINCH SCORES, AND WHAT THE ADAPTER MUST REFUSE
- `G50_WHO_IS_PRESSING.md` (2026-09-10) - G50 — WHO IS PRESSING, AND CAN IT BE MEASURED?
- `G39_THE_CLINCH.md` (2026-09-10) - G39 — THE CLINCH: WHAT IT SCORES, WHAT BREAKS IT, WHAT A THROW FROM IT IS WORTH
- `G37_THE_ADAPTER_FOLD.md` (2026-09-10) - G37 — THE ADAPTER FOLD: HOW EACH RULESET SCORES A GRAPPLE
- `G35_REFEREE_AND_METHODS.md` (2026-09-10) - G35 — The Referee, and the Fifth Method
- `C82_THE_STRIKE_BAND.md` (2026-09-10) - C82 - The strike band costing
- `C74_DIGEST.md` (2026-09-10) - C74 digest — Muay Thai grapple fold
- `C72_DIGEST.md` (2026-09-10) - C72 — The fifth method reaches the record
- `U24_DIGEST.md` (2026-09-09) - U24 digest — the scorecard screen
- `U22_DIGEST.md` (2026-09-09) - U22 Digest — the real-time fight meets the judges it already has
- `R84_DIGEST.md` (2026-09-09) - R84 DIGEST — SCORING, STOPPAGE AND RESULT ON THE REAL-TIME CORE
- `C62_DIGEST.md` (2026-09-09) - C62 digest
- `Q10_DIGEST.md` (2026-09-08) - Q10 DIGEST — Medal Table Test
- `C50_DIGEST.md` (2026-09-08) - C50 — The fourth result
- `C48_THE_RESULT_THAT_IS_NOT.md` (2026-09-08) - C48 — THE RESULT THAT IS NOT A RESULT
- `C48_DIGEST.md` (2026-09-08) - C48 digest
- `R49_DIGEST.md` (2026-09-07) - R49 — THE DECISION THAT SURVIVES THE RING, AND THE GRUDGE SHELF
- `C30_DIGEST.md` (2026-09-07) - C30 — The Bout That Can Be Read Again
- `M5_SCORECARD_THREE_JUDGES.md` (2026-09-06) - M5 — THE SCORECARD: THREE JUDGES, ONE DECISION
- `M4_POST_FIGHT_READ.md` (2026-09-06) - M4 — THE POST-FIGHT READ, THE VISUAL LANGUAGE
- `J3_THE_DECISION_QUEUE.md` (2026-09-06) - J3 — The Decision Queue: What We Have To Rule On Next
- `J1_ORGANIZATION_RULES_AND_JUDGES.md` (2026-09-06) - J1 — Organization Rules and Judges
