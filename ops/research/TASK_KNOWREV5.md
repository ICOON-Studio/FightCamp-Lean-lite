# TASK KNOWREV5 - write the knowledge stakes map v5 FROM THE CODE

Kind: research (design map)
Status: OPEN (S531, Claude main). Discipline: boxing. Model: Arena (cloud). Work on FightCamp-Lean-lite main, your own
arena/ branch, a PR into main there; never merge. RESEARCH ONLY - no game code changes. Do not run Godot.

## Your job
Write `ops/research/DESIGN_KNOW_STAKES1_V5.md`, the next version of the knowledge stakes design map (what knowing a
boxer's or an opponent's hidden habits CHANGES in the game). Inputs:
- the current map `ops/research/DESIGN_KNOW_STAKES1_V4.md`;
- its critic `ops/research/DESIGN_KNOW_STAKES1_V4_CRITIC_ARENA.md` (4/5, with a CODE CHECK listing 10 false CODE claims);
- the v3 critic `ops/research/DESIGN_KNOW_STAKES1_V3_CRITIC_DOLA_DOLA.md` (its 'To reach 10/10' list near the end);
- the game pack `ops/research/CRITIC_PACK.md`.
RULES (owner S530 METHOD: "each next version is written from the code"):
1. Section 1 "what the game does today" is written ONLY from code you opened: every line tagged CODE names file + function
   (+ line) and is TRUE today. Anything not in the code is tagged ESTIMATE (a proposal) or CUT. No exceptions.
2. Answer every point of the v4 critic's 'To reach 10/10' list and its missing/useless options (do it, or one line why not).
3. Keep every rule the owner agreed (quoted in v4); keep the table of every menu the mechanic appears on and what each is
   wired to - with a column CODE TODAY vs TO BUILD.
4. Depth target 7+: at least three real choices with trade-offs (what knowing costs: coach hours, sparring, film, money),
   no dominant pick, and each choice changes a number the fight or the week already uses (name it).
5. Plain words; names only in headers; numbers that are not in code say ESTIMATE.

## Deliverable
ONE new file `ops/research/DESIGN_KNOW_STAKES1_V5.md` and in the PR body: the list of code files you opened. A PR that adds
only that file.

## Contract
OWNS: ops/research/DESIGN_KNOW_STAKES1_V5.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
v3/v4 maps and critics above; KNOWLEDGE1 (roadmap): knowledge v3 rules collected + step 2 wired (KnowWire, S524).
## What would a human do?
A head coach writes the scouting playbook from what the gym actually tracks, then asks what each note changes on fight night.
## Prefab check
None (a design map).
