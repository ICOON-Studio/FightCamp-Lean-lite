# TASK LEDGERREV6 - write the contracts map v6 FROM THE CODE

Kind: research (design map)
Status: OPEN (S531, Claude main). Discipline: boxing. Model: Arena (cloud). Work on FightCamp-Lean-lite main, your own
arena/ branch, a PR into main there; never merge. RESEARCH ONLY - no game code changes. Do not run Godot.

## Your job
Write `ops/research/DESIGN_LEDGER1_V6.md`, the next version of the contracts design map (the Contract tab: what each boxer has been
worth to the club, money in and out per boxer, release fee, stipend, the talks). Inputs:
- the current map `ops/research/DESIGN_LEDGER1_V5.md`;
- its critic `ops/research/DESIGN_LEDGER1_V5_CRITIC_ARENA.md` (7/5);
- the v3 critic `ops/research/DESIGN_LEDGER1_V5_CRITIC_DOLA_DOLA.md` (8/8; its 'To reach 10/10' list);
- the game pack `ops/research/CRITIC_PACK.md`.
RULES (owner S530 METHOD: "each next version is written from the code"):
1. Section 1 "what the game does today" is written ONLY from code you opened: every line tagged CODE names file + function
   (+ line) and is TRUE today. Anything not in the code is tagged ESTIMATE (a proposal) or CUT. No exceptions.
2. Answer every point of the v4 critic's 'To reach 10/10' list and its missing/useless options (do it, or one line why not).
3. Keep every rule the owner agreed (quoted in v4); keep the table of every menu the mechanic appears on and what each is
   wired to - with a column CODE TODAY vs TO BUILD.
4. Depth target 7+: at least three real choices with trade-offs (keep, release, renegotiate; what each costs the club),
   no dominant pick, and each choice changes a number the fight or the week already uses (name it).
5. Plain words; names only in headers; numbers that are not in code say ESTIMATE.

## Deliverable
ONE new file `ops/research/DESIGN_LEDGER1_V6.md` and in the PR body: the list of code files you opened. A PR that adds
only that file.

## Contract
OWNS: ops/research/DESIGN_LEDGER1_V6.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
LEDGER1 (roadmap): v1-v5 maps + critics (v5: Dola 8/8, Arena 7/5).
## What would a human do?
A club secretary keeps one sheet per boxer of real money in and out, and lays the options side by side before the hard talk.
## Prefab check
None (a design map).
