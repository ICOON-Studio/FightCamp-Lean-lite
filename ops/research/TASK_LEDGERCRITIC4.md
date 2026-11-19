# TASK LEDGERCRITIC4 - judge the contracts map (LEDGER1_V3) design, fresh critic

Status: DONE (collected; S529 marked) (S528, Claude main). Discipline: boxing. Model: Arena (cloud). Work on FightCamp-Lean-lite main, your own arena/ branch, a PR into main there; never merge. RESEARCH ONLY - no game code changes.

## Your job
You are a fresh, independent critic: a sports management-sim designer. Read the whole brief
`ops/research/DESIGN_LEDGER1_V3_CRITIC_DOLA.md` (the critic pack, then the design map at the end, with Claude's code check at
its top) and do exactly what it asks: score DEPTH and GENERAL DESIGN out of 10 with reasons, say which options are missing or
useless and what each changes, and end with "To reach 10/10" - the concrete changes, most important first, each specific
enough to build. Do NOT read any other critic's answer (no file named *_CRITIC_* other than the brief above) before writing.
You may read the game code under scripts/ to check a claim; say which file you read.

## Deliverable
ONE new file `ops/research/DESIGN_LEDGER1_V3_CRITIC_ARENA.md` (the scores on their own line:
`SCORE depth=<n> general=<n>`). A PR that adds only that file. Do not edit any other file. Do not run Godot.

## Contract
OWNS: ops/research/DESIGN_LEDGER1_V3_CRITIC_ARENA.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no
