# TASK TURNREV7 - write the turning-pro map v7 FROM THE CODE

Kind: research (design map)
Status: OPEN (S531, Claude main). Discipline: boxing. Model: Arena (cloud). Work on FightCamp-Lean-lite main, your own
arena/ branch, a PR into main there; never merge. RESEARCH ONLY - no game code changes. Do not run Godot.

## Your job
Write `ops/research/DESIGN_TURNPRO1_V7.md`, the next version of the turning-pro design map (the pro offer: two promoters'
houses side by side, the debut opponent gap, purse / ticket / costs asks, decline and lapse). Inputs:
- the current map `ops/research/DESIGN_TURNPRO1_V6.md`;
- its critic `ops/research/DESIGN_TURNPRO1_V6_CRITIC_ARENA.md` (5/4, with a CODE CHECK listing the wrong CODE claims);
- the v3 critic `ops/research/DESIGN_TURNPRO1_V5_CRITIC_DOLA_DOLA.md` (its 'To reach 10/10' list) and the measured debut curve `docs/TURNGAP1_RESULT.md`;
- the game pack `ops/research/CRITIC_PACK.md`.
RULES (owner S530 METHOD: "each next version is written from the code"):
1. Section 1 "what the game does today" is written ONLY from code you opened: every line tagged CODE names file + function
   (+ line) and is TRUE today. Anything not in the code is tagged ESTIMATE (a proposal) or CUT. No exceptions.
2. Answer every point of the v4 critic's 'To reach 10/10' list and its missing/useless options (do it, or one line why not).
3. Keep every rule the owner agreed (quoted in v4); keep the table of every menu the mechanic appears on and what each is
   wired to - with a column CODE TODAY vs TO BUILD.
4. Depth target 7+: at least three real choices with trade-offs (which house, when to turn, what to ask for),
   no dominant pick, and each choice changes a number the fight or the week already uses (name it).
5. Plain words; names only in headers; numbers that are not in code say ESTIMATE.

## Deliverable
ONE new file `ops/research/DESIGN_TURNPRO1_V7.md` and in the PR body: the list of code files you opened. A PR that adds
only that file.

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V7.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
TURNPRO1 (roadmap): v2 wired S523; v3-v6 maps + critics; TURNGAP1 curve (gap -4 35.5% .. 0..+2 ~79% .. +8 96.5%).
## What would a human do?
A manager reads both contracts line by line against what the promoters really pay before advising the boxer.
## Prefab check
None (a design map).
