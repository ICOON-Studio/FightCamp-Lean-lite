# TASK LEDGERCRITIC5A - judge the contracts map (LEDGER1_V4) design, fresh critic

Kind: research
Status: OPEN (S530, Claude main). Discipline: boxing. Model: Arena (cloud). Work on FightCamp-Lean-lite main, your own arena/ branch, a PR into main there; never merge. RESEARCH ONLY - no game code changes.

## Your job
You are a fresh, independent critic: a sports management-sim designer. Read the whole brief
`ops/research/DESIGN_LEDGER1_V4_CRITIC_DOLA.md` (the critic pack, then the design map at the end) and do exactly what it
asks: score DEPTH and GENERAL DESIGN out of 10 with reasons, say which options are missing or useless and what each changes,
and end with "To reach 10/10" - the concrete changes, most important first, each specific enough to build. Check its numbers against the code it quotes: scripts/state/Career.gd (pay, ledger), scripts/state/GameMoney.gd,
scripts/state/BoutFinish.gd, scripts/state/Leaving.gd, scripts/state/ApproachWire.gd, scripts/state/RivalOfferWire.gd,
scripts/state/GymDeals.gd, scripts/rules/StarDeal.gd, scripts/state/CashForecast.gd.
Do NOT read any other critic's answer (no file named *_CRITIC_* other than the brief above) before writing.
Say which code files you read.

## Deliverable
ONE new file `ops/research/DESIGN_LEDGER1_V4_CRITIC_ARENA.md` (the scores on their own line:
`SCORE depth=<n> general=<n>`). A PR that adds only that file. Do not edit any other file. Do not run Godot.

## Contract
OWNS: ops/research/DESIGN_LEDGER1_V4_CRITIC_ARENA.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
CRITIC_PACK.md (inside the brief). No earlier critic file is to be read.
## What would a human do?
A club secretary keeps one sheet per boxer of real money in and out, and lays the options side by side before the hard talk.
## Prefab check
None: a design review.
