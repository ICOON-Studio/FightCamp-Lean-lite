# TASK KNOWCRITIC3A - judge the knowledge stakes map (KNOW_STAKES1_V3) design, fresh critic

Kind: research
Status: OPEN (S530, Claude main). Discipline: boxing. Model: Arena (cloud). Work on FightCamp-Lean-lite main, your own arena/ branch, a PR into main there; never merge. RESEARCH ONLY - no game code changes.

## Your job
You are a fresh, independent critic: a sports management-sim designer. Read the whole brief
`ops/research/DESIGN_KNOW_STAKES1_V3_CRITIC_DOLA.md` (the critic pack, then the design map at the end) and do exactly what it
asks: score DEPTH and GENERAL DESIGN out of 10 with reasons, say which options are missing or useless and what each changes,
and end with "To reach 10/10" - the concrete changes, most important first, each specific enough to build. Check its numbers against the code it quotes: assets/data/fight_habits.json, scripts/rules/HabitFix.gd,
scripts/rules/KnowReads.gd, scripts/rules/Knowledge.gd, scripts/rules/CoachNotes.gd, scripts/rules/Recruit.gd,
scripts/rules/ModeTells.gd, scripts/rules/TellWorth.gd.
Do NOT read any other critic's answer (no file named *_CRITIC_* other than the brief above) before writing.
Say which code files you read.

## Deliverable
ONE new file `ops/research/DESIGN_KNOW_STAKES1_V3_CRITIC_ARENA.md` (the scores on their own line:
`SCORE depth=<n> general=<n>`). A PR that adds only that file. Do not edit any other file. Do not run Godot.

## Contract
OWNS: ops/research/DESIGN_KNOW_STAKES1_V3_CRITIC_ARENA.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
CRITIC_PACK.md (inside the brief). No earlier critic file is to be read.
## What would a human do?
A manager pays for a closer look at a prospect only when the answer would change the signing or the first opponent.
## Prefab check
None: a design review.
