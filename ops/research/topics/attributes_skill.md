# Attributes, stats, skill, technique catalogue and progression

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **Seven 0-100 attributes** (grapple added as the seventh) - `C43_DIGEST.md`, one voice for them `C44_DIGEST.md`; the seven
  stats are fully wired but none had a definition - `R134_THE_SEVEN_STATS_HAVE_NO_DEFINITION.md`; attribute ledger and gaps -
  `R147_ATTRIBUTES_AND_GAPS.md`; census - `Q117_THE_ATTRIBUTE_CENSUS.md`; stat floor - `Q119_THE_STAT_FLOOR.md`; what shipped
  games do - `K66_ATTRIBUTE_SYSTEMS_IN_SHIPPED_GAMES.md`.
- **Skill narrows, not only raises** - `C61_DIGEST.md`; can the engine tell a better striker - `Q41_SKILL_AND_OUTPUT.md`;
  the training record must reach the live fighter (it did not until S58) - `Q142_DIGEST.md`, `Q145_DIGEST.md`.
- **The technique catalogue:** 272 -> 696 nodes (S1 merge) - `S1_CATALOGUE_MERGE.md`, `R129_CATALOGUE_MERGE_IMPACT.md`;
  its contract - `TECHNIQUE_CATALOGUE_CONTRACT.md`; one vocabulary - `S1C_VOCABULARY_RULING.md`; the move palette with
  typed CIs - `J21_THE_MOVE_PALETTE.md`, fields - `S4H_CATALOGUE_FIELDS.md`; can the engine perform every skill -
  `S4E_TECHNIQUE_COVERAGE.md`; discipline vocabularies - `U60_JUDO_BJJ_TECHNIQUES.md`, `Q65_MUAY_THAI_TECHNIQUES.md`,
  `C95_KARATE_TECHNIQUES.md`. 162 of 696 nodes are passive skills that never need a clip.
- **Mastery:** drill mastery ~6% of quality sessions (consolidation after sleep) - `G115_DRILL_MASTERY_RATES.md`; skill band
  words coaches use - `G101_SKILL_BAND_WORDS.md`, `D23_SKILL_BAND_WORDS.md`.
- **Skill on the ground** scales every hazard by a per-20-point gap - `G144_GROUND_SKILL_GAPS.md` (see `ground.md`).

## Open
- Balance and speed as attributes - `R149_BALANCE_SPEED_AND_THE_UNCALLED.md` (balance built as a STATE instead).

## Engine
`AthleteStatModel.gd`, `StatWords.gd`, `FightMoves.gd`, `assets/data/technique_catalog.json`, `GameState` technique_progress.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (46, newest first, generated)

- `K81_COACHES_WHO_MATTER_IN_MANAGEMENT_GAMES.md` (2026-09-27) - K81 HOW MANAGEMENT GAMES MAKE A COACH MATTER
- `G144_GROUND_SKILL_GAPS.md` (2026-09-27) - G144 - How a grappling skill gap moves the ground (Grok, collected S114)
- `U179_PROP_CENSUS.md` (2026-09-26) - U179 — Station prop census (equipment catalogue ↔ 3D)
- `Q187_DIGEST.md` (2026-09-26) - Q187_DIGEST — blind contract test for DrillMastery + FloorEvents
- `G115_DRILL_MASTERY_RATES.md` (2026-09-26) - G115_DRILL_MASTERY_RATES (Grok, collected by Claude S84, 2026-09-26)
- `D30_FRESH_EYES_MASTERY_PIPS.md` (2026-09-26) - D30_FRESH_EYES_MASTERY_PIPS (Dola, collected by Claude S85, 2026-09-26)
- `D23_SKILL_BAND_WORDS.md` (2026-09-26) - MEMO — D23: Skill Band Words & Fighter Level Terminology
- `U131_DIGEST.md` (2026-09-22) - U131 digest (cursor)
- `K75_PHASE_FIRST_SKILL_TREE_WORDS.md` (2026-09-22) - K75_PHASE_FIRST_SKILL_TREE_WORDS.md
- `K74_TECHNIQUE_MODAL_STATES.md` (2026-09-22) - K74_TECHNIQUE_MODAL_STATES.md
- `EVAL_SKILLS_IN_3D_DOLA.md` (2026-09-22) - SKILLS IN 3D — DOLA'S EVALUATION
- `R144_LINES1_2_THE_CATALOGUE_AND_THE_STORE.md` (2026-09-21) - R144 lines 1 and 2 — what can actually be BOUGHT for paired grappling
- `Q119_THE_STAT_FLOOR.md` (2026-09-21) - Q119 — The Stat Floor
- `Q117_THE_ATTRIBUTE_CENSUS.md` (2026-09-21) - Q117 — The Attribute Census
- `K66_ATTRIBUTE_SYSTEMS_IN_SHIPPED_GAMES.md` (2026-09-21) - K66 — Attribute systems in shipped games
- `R149_BALANCE_SPEED_AND_THE_UNCALLED.md` (2026-09-19) - R149 — BALANCE, SPEED, AND THE 2,707 LINES NOBODY CALLS
- `R147_ATTRIBUTES_AND_GAPS.md` (2026-09-19) - R147 — THE ATTRIBUTE LEDGER: what we have, what is unmapped, what is missing
- `S4H_CATALOGUE_FIELDS.md` (2026-09-17) - S4h — THE `usage` FIELD, AND WHAT ELSE A MOVE NEEDS TO BE EXECUTABLE
- `S4E_TECHNIQUE_COVERAGE.md` (2026-09-16) - CAN THE ENGINE PERFORM ALL THE SKILLS IT HAS? MEASURED
- `U69_IPPON_LINE.md` (2026-09-12) - U69 — THE IPPON LINE STAYED WHERE IT WAS WHEN THE CATALOGUE MOVED
- `U64_DIGEST.md` (2026-09-12) - U64 DIGEST — blind catalogue contract test
- `U62_WHY_IT_KEEPS_HAPPENING.md` (2026-09-12) - U62 — WHY IT KEEPS HAPPENING, AND WHAT TO CHANGE
- `U60_JUDO_BJJ_TECHNIQUES.md` (2026-09-12) - U60 / U60B — Judo & Brazilian Jiu-Jitsu: the real vocabulary
- `U60_INPUT_BJJ_BELT_CHECKLIST.md` (2026-09-12) - INPUT FOR U60 — the operator's BJJ belt progression checklist, and what it misses
- `TECHNIQUE_CATALOGUE_CONTRACT.md` (2026-09-12) - THE TECHNIQUE CATALOGUE CONTRACT — how a discipline gets researched and added
- `S1_CATALOGUE_MERGE.md` (2026-09-12) - S1 — THE CATALOGUE MERGE: 272 NODES TO 696
- `S1C_VOCABULARY_RULING.md` (2026-09-12) - S1c — ONE VOCABULARY: THE CONTRACT WAS THE THING THAT WAS WRONG
- `R134_THE_SEVEN_STATS_HAVE_NO_DEFINITION.md` (2026-09-12) - R134 — THE SEVEN STATS ARE FULLY WIRED AND NONE OF THEM IS DEFINED
- `R129_CATALOGUE_MERGE_IMPACT.md` (2026-09-12) - 1. THE MERGE, MEASURED
- `Q65_MUAY_THAI_TECHNIQUES.md` (2026-09-12) - Q65 — MUAY THAI: THE FULL TECHNIQUE VOCABULARY
- `C95_KARATE_TECHNIQUES.md` (2026-09-12) - C95 — Karate technique vocabulary and grading map
- `Q56_THE_VOCABULARY_GAP.md` (2026-09-11) - Q56 — THE VOCABULARY GAP
- `R101_DIGEST.md` (2026-09-10) - R101 — THE FIGHT READS THE CATALOGUE
- `R101_DESIGN_NOTES.md` (2026-09-10) - R101 — DESIGN NOTES BEFORE A LINE IS WRITTEN
- `Q41_SKILL_AND_OUTPUT.md` (2026-09-10) - Q41 — Skill and Output: Can the Engine Distinguish a Better Striker?
- `Q40_DIGEST.md` (2026-09-10) - Q40 Digest
- `J21_THE_MOVE_PALETTE.md` (2026-09-10) - J21 — THE MOVE PALETTE
- `R81_DIGEST.md` (2026-09-09) - R81 digest — The camp under the burst, and the hand skill steadies
- `C61_DIGEST.md` (2026-09-09) - C61 — The skill that narrows, not only raises
- `R66_CELL_SIZE_RULING.md` (2026-09-08) - R66 — THE CELL IS A REAL SIZE
- `R61_SCHEMATIC_CATALOGUE.md` (2026-09-08) - R61 — THE SCHEMATIC CATALOGUE: WHAT A REAL GYM MEASURES
- `R61_DIGEST.md` (2026-09-08) - R61 DIGEST — THE SCHEMATIC CATALOGUE
- `C44_DIGEST.md` (2026-09-08) - C44 digest — one voice for the seven attributes
- `C43_DIGEST.md` (2026-09-08) - C43 digest — GRAPPLE, the seventh attribute
- `TECHNIQUE_CATALOG_AUDIT.md` (2026-08-30) - Technique Catalog Audit
- `PROGRESSION_AND_FIGHT_EXECUTION_AUDIT.md` (2026-08-30) - Progression and Fight-Execution Audit
