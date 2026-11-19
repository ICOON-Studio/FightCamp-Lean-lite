# TASK KNOWREV3 - write the knowledge stakes map v3 (KNOW_STAKES1_V3) from the code

Status: OPEN (S530, Claude main). Discipline: boxing. Model: Goose (cloud), default. RESEARCH ONLY - no game code changes.

## Why
KNOW_STAKES1 asks: what does knowing a boxer's hidden habits change? v1 (Dola) invented new flaws that already exist; v2
(Dola, `ops/research/DESIGN_KNOW_STAKES1_V2.md`) moved to the real habits but put invented prices and costs on systems the
code already has. Read Claude's CODE CHECK at the top of that file first. Chat seats write without the repo; this round is
written from the code (as LEDGER1 v3 and TURNPRO1 v4 were).

## Your job
Write `ops/research/DESIGN_KNOW_STAKES1_V3.md`. Every row is tagged CODE (quote file + function) or ESTIMATE (a target a
probe must check) or CUT. READ:
- `assets/data/fight_habits.json` (all 20 habits), `scripts/rules/HabitFix.gd` (HABIT_COST 6, the punish map from
  Exchanges.MODES, the corner's one fix, the coach's notebook at the bell), `scripts/rules/HabitBeats.gd`.
- `scripts/rules/Knowledge.gd` (ranges, groups, stale, hype) and `scripts/rules/KnowReads.gd` (the reads and their prices),
  `scripts/state/` files that call them (grep `KnowReads.`, `Knowledge.`), `scripts/rules/Recruit.gd` (the signing focus
  "Fix the habit"), `scripts/rules/ModeTells.gd`, `scripts/rules/TellWorth.gd` (the opponent's tells on film).
Then:
1. State what the game ALREADY does with a habit: when it is hidden, how it is learned today (reads, the notebook, film
   nights, a bout), what it costs, how it is fixed (corner fix, signing focus). One table.
2. The STAKE: the decisions that change because a habit is KNOWN - signing (pay a read or sign blind), the bout offer (a
   risk line when the opponent's style punishes a known habit: name the existing pairing in HabitFix), the game plan (the
   answering line), the week (an existing training lever only - no new mitigation numbers). Each with its menu and wire.
3. Keep from v2 (sound): "once revealed, shown everywhere"; the wire table (every menu, what it shows, what it opens - owner
   S425); the BLIND / READ-FIRST / ORACLE probe with pass lines, 150+ worlds, the population named.
4. CUT what has no lever: per-habit costs other than HABIT_COST, invented reveal chances, "emerging habits".
Plain game words, names only in headers (owner S448), no earlier critic scores in the map. End with "Changed from v2".

## Deliverable
ONE new file `ops/research/DESIGN_KNOW_STAKES1_V3.md`. A PR that adds only that file. Do not edit any other file. Do not run
Godot. Under 400 lines.

## Contract
OWNS: ops/research/DESIGN_KNOW_STAKES1_V3.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
DESIGN_KNOW_STAKES1_V2.md (code check on top), DESIGN_KNOW_STAKES1_DOLA_DOLA.md (v1), CRITIC_PACK.md, KNOWBOTS probes
(`python ops/Tools/prior_research.py knowbots`).
## What would a human do?
A manager pays for a closer look at a prospect only when the answer would change the signing or the first opponent.
## Prefab check
None: a design document on our own code.
