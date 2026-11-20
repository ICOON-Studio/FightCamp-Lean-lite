# TASK KNOWCRITIC4A - judge the knowledge stakes map (KNOW_STAKES1_V4) design, fresh critic

Kind: research
Status: OPEN (S531, Claude main). Discipline: boxing. Model: Arena (cloud). Work on FightCamp-Lean-lite main, your own
arena/ branch, a PR into main there; never merge. RESEARCH ONLY - no game code changes. Do not run Godot.

## Your job
You are a fresh, independent critic: a sports management-sim designer. Read the whole brief
`ops/research/DESIGN_KNOW_STAKES1_V4_CRITIC_DOLA.md` (the critic pack, then the design map at the end) and do exactly what
it asks: score DEPTH and GENERAL DESIGN out of 10 with reasons, say which options are missing or useless and what each
changes, and end with "To reach 10/10" - the concrete changes, most important first, each specific enough to build.
CODE CHECK (required): every line the map tags CODE names a file or a number - open it and say for each whether the code
really does that (scripts/rules/*Know*, scripts/state/KnowWire.gd, assets/data/fight_habits.json, scripts/state/BoutRead*,
anything else it names). List each CODE claim that is wrong. Do NOT read any other critic's answer (no file named
*_CRITIC_* other than the brief above) before writing. Say which code files you read.

## Deliverable
ONE new file `ops/research/DESIGN_KNOW_STAKES1_V4_CRITIC_ARENA.md` (the scores on their own line:
`SCORE depth=<n> general=<n>`). A PR that adds only that file.

## Contract
OWNS: ops/research/DESIGN_KNOW_STAKES1_V4_CRITIC_ARENA.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
CRITIC_PACK.md (inside the brief); v3 critics are NOT to be read.
## What would a human do?
A head coach asks of every scouting note: did knowing this change what we did on the night, and did it pay?
## Prefab check
None (a design review).
