# TASK TURNCRITIC3G - judge the turning pro map (TURNPRO1_V3) design, fresh critic

Kind: research
Status: OPEN (S529, Claude main). Discipline: boxing. Model: Goose (cloud), default. One PR into main. RESEARCH ONLY - no game code changes.

## Your job
You are a fresh, independent critic: a sports management-sim designer. Read the whole brief
`ops/research/DESIGN_TURNPRO1_V3_CRITIC_DOLA.md` (the critic pack, then the design map at the end) and do exactly what it
asks: score DEPTH and GENERAL DESIGN out of 10 with reasons, say which options are missing or useless and what each changes,
and end with "To reach 10/10" - the concrete changes, most important first, each specific enough to build. The map answers
a measured probe (docs/TURNPROBE2_RESULT.md: 8 of 9 pass lines failed on v2, which is built - scripts/state/ProOfferWire.gd,
scripts/rules/ProCall.gd); judge whether v3's changes would move those lines, and check its numbers against that code.
Do NOT read any other critic's answer (no file named *_CRITIC_* other than the brief above) before writing.
Say which code files you read.

## Deliverable
ONE new file `ops/research/DESIGN_TURNPRO1_V3_CRITIC_GOOSE.md` (the scores on their own line:
`SCORE depth=<n> general=<n>`). A PR that adds only that file. Do not edit any other file. Do not run Godot.

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V3_CRITIC_GOOSE.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
docs/TURNPROBE2_RESULT.md, ops/research/DESIGN_TURNPRO1_V2_CRITIC_DOLA_DOLA.md is NOT to be read (another critic).
## What would a human do?
A manager weighs a promoter's first offer against the boxer's job, age and ticket pull, and asks for the one thing that matters.
## Prefab check
None: a design review.
