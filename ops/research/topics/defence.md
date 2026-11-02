# Defence: block, slip, evade, counter

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **What defence is, measurably** (landed/attempted by target; defences per minute) - `G54_WHAT_IS_DEFENCE.md`; elite
  amateurs ~2.5-3.6 defences / min (Davis 2015/2017, in `G86_FEINTS.md`).
- **How a defender defends** (block / evade / range management - the third family dominates among amateur winners; styles:
  peek-a-boo, shoulder roll; reading the jab hand) - `J50_HOW_A_DEFENDER_DEFENDS.md`.
- **The defence model** (perceive -> choose -> execute -> consequence) is built behind `defence_model`, default OFF:
  slice 1 - `U172_DIGEST.md`; slice 2 anticipate + counter - `U173_DIGEST.md`.
- **Earlier engine defects, fixed:** a shrimp escape blocked a jab (phase-blind defence) - `Q73_PHASE_BLIND_DEFENCE.md`;
  defence cap -> diminishing-returns curve - `U80_DEFENCE_CURVE.md`, `U73_DEFENCE_CAP.md`; which incoming action and which
  region each defence answers - `U72_DEFENCE_ANSWERS.md`, `U76_DEFENCE_BY_REGION.md`; boxing can slip - `Q71_BOXING_EVASION.md`;
  counter tags vs roles reconciled - `C97_COUNTER_RECONCILIATION.md`, `R135_THE_TAGS_AND_THE_ROLE_DISAGREE.md`;
  `counter_open` is a benefit, not a cost - `S19_BALANCE_REACHES_THE_FIGHT.md`; defence as a movement decision -
  `S4E_DEFENCE_MOVEMENT.md`.
- A sharp edge raises the clean-landed share 55.7% -> 60.4% (MMA, 40 seeds) - `Q189_DIGEST.md`.
- **GUARD STYLES (S119, operator: 'dont make all fighters hold their guard the same way', 'guard and defence
  connected'):** 8 guards with pose numbers (classic, high, peek-a-boo, Philly shell, long, Mexican, cross-arm,
  low-hands); games make style the identity, the defence rating clamp how far it degrades and fatigue blend it toward
  an exhausted guard; elbows flare before hands drop - `D64_GUARD_STYLES.md` (prevalence PROXY, formula authored).
  Build: one guard idle + additive per-style pose layer.

## Open
- Whether `defence_model` goes ON by default: needs a census that shows it does not distort J20 D1-D3 (the pace miss
  U172/U173 saw, D1 5.79/min, was already on master).

## Engine
`FightDefenceModel.gd` (behind `defence_model`), `FightMoves.gd` (`answering_guards`, `GUARD_HEIGHT_*`),
`FightRealtime.gd`. Tests: `fight_defence_model_test`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (38, newest first, generated)

- `U189_DIGEST.md` (2026-09-27) - U189 Digest — Kickboxing leg kicks that land
- `Q203_DIGEST.md` (2026-09-27) - Q203 DIGEST — Three realism reds that are not pins
- `Q189_DIGEST.md` (2026-09-26) - Q189 DIGEST - SHARP EDGE IN THE FIGHT ENGINE
- `U173_DIGEST.md` (2026-09-25) - U173 digest — defender model slice 2 (anticipate + counter)
- `U172_DIGEST.md` (2026-09-25) - U172 digest — defence_model slice 1 (pass 2 gate)
- `J50_HOW_A_DEFENDER_DEFENDS.md` (2026-09-25) - J50 — How a Defender Defends (block, evade, and everything in between)
- `U135_DIGEST.md` (2026-09-22) - U135 digest — fight causation bullets
- `U134_DIGEST.md` (2026-09-22) - U134 digest — wire post-fight result block into FightResultPanel
- `U130_DIGEST.md` (2026-09-22) - U130 digest — post-fight result block + causation box
- `C146_THE_BLIND_SPLIT_CONTRACT.md` (2026-09-21) - C146 — Blind grapple offence/defence contract
- `K63_RING_POSITION_AND_STANCE_STATS.md` (2026-09-20) - K63 — RING AND CAGE POSITION, STANCE AND DEFENCE: THE STATISTICS THAT ACTUALLY EXIST
- `C133_ENGINE_POSITION_STANCE_DEFENCE.md` (2026-09-20) - C133 - what the engine has for position, stance, defence, feints and the gaps
- `S19_BALANCE_REACHES_THE_FIGHT.md` (2026-09-19) - S19 — BALANCE REACHES THE FIGHT (R150 stages 0 and 1)
- `S14_SUBSTITUTE_COLUMN.md` (2026-09-18) - S14 — THE SUBSTITUTE COLUMN: A MISLABEL CORRECTED, AND A COUNTER THE CLOCK CANNOT AFFORD
- `S4E_DEFENCE_MOVEMENT.md` (2026-09-15) - S4e (2) — DEFENCE AS A MOVEMENT DECISION: WHAT THE ENGINE DID, WHAT IT DOES NOW, AND WHAT IS STILL WRONG
- `K60_WATCH_LIST_5.md` (2026-09-14) - K60 - Watch list 5: the man who gets hit
- `U80_DEFENCE_CURVE.md` (2026-09-13) - U80 — Defence cap replaced with diminishing-returns curve
- `U76_DEFENCE_BY_REGION.md` (2026-09-13) - U76 — Which regions each striking defence answers
- `U73_DEFENCE_CAP.md` (2026-09-13) - U73 — Defence bonus saturation in the generated-opponent population
- `U72_DEFENCE_ANSWERS.md` (2026-09-13) - U72 — Which incoming action each defence answers
- `Q83_DROPPED_POSITION_TRACKS.md` (2026-09-13) - DECISIONS: THE POSITION TRACKS WE DROP
- `Q78_JUDO_SAMBO_ESCAPES.md` (2026-09-13) - Q78 — Judo and Sambo Escapes and Defences That Do Not Exist
- `Q75_WHAT_RESISTS_A_STAND_UP.md` (2026-09-13) - Q75 — What resists a stand-up
- `J27_FREQUENCIES_AND_THROW_DEFENCE.md` (2026-09-13) - J27 — Frequencies and throw defence
- `U71_DIGEST.md` (2026-09-12) - U71 digest
- `U65_ROLE_KIND_CENSUS.md` (2026-09-12) - 1. The remap blast radius
- `R135_THE_TAGS_AND_THE_ROLE_DISAGREE.md` (2026-09-12) - R135 — THE COUNTER MECHANIC IS HALF-BUILT ALREADY, AND THE TAGS DISAGREE WITH IT
- `Q73_PHASE_BLIND_DEFENCE.md` (2026-09-12) - Q73 — A SHRIMP ESCAPE BLOCKS A JAB: THE PHASE-BLIND DEFENCE BONUS
- `Q71_BOXING_EVASION.md` (2026-09-12) - Q71 — Boxing can slip now: which nodes, and what the test should derive
- `C97_COUNTER_RECONCILIATION.md` (2026-09-12) - C97 — Counter Reconciliation
- `U59_THE_UNREAD_EFFECTS.md` (2026-09-11) - U59 — The unread effects
- `G54_WHAT_IS_DEFENCE.md` (2026-09-11) - G54 — WHAT IS DEFENCE, MEASURABLY?
- `C92_STRIKING_CONTENT.md` (2026-09-11) - C92 — Striking clip content windows
- `R94_ANIMATION_SPIKE.md` (2026-09-10) - R94 — THE ANIMATION SPIKE: CAN WE GET A FIGHT'S WORTH OF CLIPS, AND AT WHAT COST
- `C75_ANIMATION_SOURCES.md` (2026-09-10) - C75 — Animation sources beyond Ludo
- `R83_DIGEST.md` (2026-09-09) - R83 DIGEST — R82 stage 2: the core reads the fighter, and the fight hurts
- `U17_DIGEST.md` (2026-09-08) - U17 digest — THE GRAND PRIX BLOCK THAT EATS THE FIGHT LOG (cursor)
- `C29_DIGEST.md` (2026-09-07) - C29 DIGEST — THE BLOCKED BELT READ
