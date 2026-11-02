# Fight plans, the corner, between rounds, coach calls

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **Fight plans:** five sliders move the bout; the opponent's coach plans too; the result screen shows THE PLANS (S99-S101);
  plans must actually differ (15 of 34 had flat target_bias) - `G68_FIGHT_PLAN_DIFFERENTIATION.md`; what the engine reads off
  a plan - `G69_FIGHT_PLAN_SIM_READ.md`; plan and corner as one - `G70_PLAN_AND_CORNER.md`; plans make different fighters -
  `Q192_DIGEST.md`; plan roles for boxing only, KB/MMA byte-identical - `Q193_DIGEST.md`, `Q194_DIGEST.md`; blind reads contract -
  `U192_DIGEST.md`; original design - `FIGHT_PLANS_RESEARCH.md`.
- **The corner (rules):** a corner is a commission-licensed assignment - three seconds, a chief second, a cutman, referee
  authority - `C31_THE_CORNER.md`, `C32_DIGEST.md`.
- **The corner minute (design):** a Motorsport Manager pit stop - body figure, 45 s bar, the nose-blow card - built S97, ON
  by default S98 - `S96_MOTORSPORT_MANAGER_SETUP_TO_THE_CORNER.md`, `G133_TUNING_LOOPS_AND_THE_CORNER_CLOCK.md`,
  `G132_LIVE_DAMAGE_AND_THE_CORNER.md`; player views `D44`-`D47`.
- **Does the corner change the next round:** national-championship coaches give ~8 cues per rest; G137 sizes the effect at
  +3 and the game reads +2 - `G137_DOES_THE_CORNER_CHANGE_THE_NEXT_ROUND.md`.
- **Words:** what a coach says on Monday - `G119_WHAT_A_COACH_SAYS_ON_MONDAY.md`; corner card - `K72_CORNER_CARD.md`; mic
  corner calls - `D18_MIC_CORNER_CALLS.md`, `D19_SOURCE_THE_CORNER.md`; the between-round surface - `G65_BETWEEN_ROUND.md`;
  what a manager does mid-fight - `G44_WHAT_A_MANAGER_DOES_MID_FIGHT.md`.

## Open
- The corner-between-rounds study for John (J55) is held while the shell-less agents are OFF.

## Engine
`FightPlans.gd`, `CornerPanel.gd`, the corner pit-stop screen, `FightRealtime.gd` plan reads. Test: `plan_reads_contract_test`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (41, newest first, generated)

- `U192_DIGEST.md` (2026-09-27) - U192 digest — plan + corner reads blind contract
- `S96_MOTORSPORT_MANAGER_SETUP_TO_THE_CORNER.md` (2026-09-27) - S96 - MOTORSPORT MANAGER'S SETUP LOOP, AND WHAT IT BECOMES IN THE FIGHT CAMP AND THE CORNER
- `G137_DOES_THE_CORNER_CHANGE_THE_NEXT_ROUND.md` (2026-09-27) - G137 - DOES THE CORNER CHANGE THE NEXT ROUND? (Grok, collected S101 2026-09-27)
- `G133_TUNING_LOOPS_AND_THE_CORNER_CLOCK.md` (2026-09-27) - G133 - TUNING LOOPS AND THE CORNER CLOCK (Grok, collected S96 2026-09-27)
- `G132_LIVE_DAMAGE_AND_THE_CORNER.md` (2026-09-27) - G132 - LIVE DAMAGE AND THE CORNER (Grok, collected S96 2026-09-27)
- `D49_DIGEST.md` (2026-09-27) - D49 DIGEST - fresh eyes on the plan-outcome lines
- `D48_DIGEST.md` (2026-09-27) - D48 DIGEST - post-match screens that prove the plan mattered
- `D47_DIGEST.md` (2026-09-27) - D47 DIGEST - Dola (player view) on the plan setup and the corner read, collected S101 2026-09-27. Verbatim rep
- `D45_THE_PIT_STOP_CORNER_FRESH_EYES.md` (2026-09-27) - D45 THE PIT-STOP CORNER, FRESH EYES
- `D44_THE_CORNER_MINUTE_PLAYER_VIEW.md` (2026-09-27) - D44 - THE CORNER MINUTE, PLAYER VIEW (Dola, collected S96 2026-09-27; second send - the first got no answer)
- `U176_DIGEST.md` (2026-09-26) - U176 — both corners wear ruleset gloves
- `Q194_DIGEST.md` (2026-09-26) - Q194 Digest — Plan Roles for Boxing Only, KB/MMA Byte-Identical
- `Q193_DIGEST.md` (2026-09-26) - Q193 Digest — Flip ROLE_PRIORITY_FROM_PLAN, Measured Against All Three Anchors
- `Q192_DIGEST.md` (2026-09-26) - Q192 Digest — Do the fight plans make different fighters? (And the MMA jab row)
- `Q184_DIGEST.md` (2026-09-26) - Q184 Digest - Kickboxing Finishes 6.7% vs Glory 33%: Funnel Census + Corner Stoppage Mechanism
- `G119_WHAT_A_COACH_SAYS_ON_MONDAY.md` (2026-09-26) - G119_WHAT_A_COACH_SAYS_ON_MONDAY (Grok, collected by Claude S86, 2026-09-26)
- `K77_HANDBOOK_WORDS.md` (2026-09-25) - K77 - THE WORDS: HANDBOOK LINES AND COACH LINES IN ONE HOUSE VOICE
- `D19_SOURCE_THE_CORNER.md` (2026-09-25) - D19 - Source the corner numbers (Dola, collected S75 2026-09-25)
- `D18_MIC_CORNER_CALLS.md` (2026-09-25) - D18 - Mic corner calls (Dola, collected S75 2026-09-25)
- `G70_PLAN_AND_CORNER.md` (2026-09-24) - G70 - PLAN AND CORNER; COACH LINES THAT LIE
- `G70_BRIEF.md` (2026-09-24) - FIGHTPLAN_DESIGN - PASS 3 (Grok, Research mode) - S66, 2026-09-24
- `Q151_DIGEST.md` (2026-09-23) - Q151 digest
- `K73_REGION_SENTENCES.md` (2026-09-22) - K73_REGION_SENTENCES.md
- `K72_CORNER_CARD.md` (2026-09-22) - K72_CORNER_CARD.md
- `G69_FIGHT_PLAN_SIM_READ.md` (2026-09-22) - G69 — WHAT THE ENGINE ACTUALLY READS OFF A FIGHT PLAN
- `G68_FIGHT_PLAN_DIFFERENTIATION.md` (2026-09-22) - G68 — DO THE 34 FIGHT PLANS ACTUALLY DIFFER?
- `G65_BETWEEN_ROUND.md` (2026-09-22) - G65 — THE BETWEEN-ROUND SURFACE, AT G64 DENSITY
- `C162_DIGEST.md` (2026-09-22) - C162 — CORNER UI
- `C96_ENGINE_CONTRACT_AUDIT.md` (2026-09-12) - C96 — engine input contract audit
- `U37_DIGEST.md` (2026-09-10) - U37 DIGEST — the corner instruction that does nothing
- `U35_INTERVENTION_SURFACE.md` (2026-09-10) - U35 — What RingStagePanel lets the player do to a live fight
- `J16_THE_GYM_FLOOR_PLAN.md` (2026-09-10) - J16 — The Gym Floor Plan: What May We Use, and What Does Geometry Buy a Management Game?
- `G44_WHAT_A_MANAGER_DOES_MID_FIGHT.md` (2026-09-10) - G44 — WHAT DOES A FIGHT MANAGER ACTUALLY DO WHILE THE FIGHT IS ON?
- `C35_DIGEST.md` (2026-09-07) - C35 DIGEST — THE CORNER GETS A SCREEN
- `C32_DIGEST.md` (2026-09-07) - C32 DIGEST — THE CORNER, ONE RULE
- `C31_THE_CORNER.md` (2026-09-07) - C31 — The corner: who is licensed to be there, and what they do
- `C31_DIGEST.md` (2026-09-07) - C31 DIGEST — the corner
- `R31_DIGEST.md` (2026-09-06) - R31 — THE RING (Claude)
- `K19_DIGEST.md` (2026-09-06) - K19 DIGEST — THE LIVE FIGHT SCENE (Kalli)
- `K16_DIGEST.md` (2026-09-05) - A) Shape
- `FIGHT_PLANS_RESEARCH.md` (2026-09-03) - Fight Plans — research and design (2026-09-03)
