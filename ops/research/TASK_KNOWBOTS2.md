# TASK KNOWBOTS2 - the Knowledge bots test on a FAIR prospect pool (probe, no screen)

Status: OPEN (S462, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.
Mechanic: PROGRESSIVE KNOWLEDGE (ops/research/KNOWLEDGE_S411.md, "First, prove it"). Step 1 built (scripts/rules/Knowledge.gd).
KNOWBOTS1 (docs/KNOWBOTS1_RESULT.md, read it) FAILED on Claude's rerun: READER 103 vs BLIND 104 top-10 appearances, but its
prospects were four hand-built archetypes per year (gem / hype flop / solid / raw) with hype tied to the archetype. This task
measures the same three bots on a pool the probe does not design.

## What changes from KNOWBOTS1 (start from tools/knowbots_probe.gd on main; it parses and runs)
1. PROSPECTS: each signing year, the pool is the world's own young boxers from WorldGen.generate(seed) / the running world
   (age 18-22, not top 30), 6 per signing, picked by a seeded draw - never by rating, type or potential. Their truth is
   whatever the world made.
2. HYPE: drawn per prospect from a seeded uniform 0.0-1.0, INDEPENDENT of truth (print the correlation of hype and truth over all
   prospects: it must be within +-0.1).
3. Everything else as KNOWBOTS1: 60 worlds (7000-7059), 4 years, BLIND / READER / BAD SIGNER, reads charged at their prices, the bout
   reads the truth. Keep the 90-minute cap and the pilot.
4. A SENSITIVITY row: the same 60 worlds with Knowledge's start half-ranges doubled IN THE PROBE ONLY (pass a dict of overrides into
   your own copy of the range call; never edit scripts/): does READER pull ahead when the day-one view is wider?

## Pass line (the design's)
READER's boxers reach the world top 10 at least 5 more times per 60 worlds than BLIND's, after what it paid. Print per bot:
top-10 appearances, titles, paid for reads, flops (truth >= 5 under the shown centre at signing), and the sensitivity row.

## Contract
OWNS: tools/knowbots_probe.gd, docs/KNOWBOTS2_RESULT.md
RED_TEST: tools/knowbots_probe.gd -> KNOWBOTS2 done (a probe; docs/KNOWBOTS2_RESULT.md is the deliverable)
REGRESSION: knowledge_test, world_years_test
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ (read-only).
The result page is WRITTEN BY THE PROBE (its own _write_result_doc from the run's numbers) - never typed by hand. Claude reruns it
on the same seeds before reading a word of it. PR body: `RESULT: tools/knowbots_probe.gd -> reader_minus_blind=<n> per 60 worlds
pass=<yes|no> sensitivity=<n>`.
(knowbots_probe.gd under 500 lines; a second file tools/knowbots_pool.gd for the pool if needed. Runs only through
`python ops/Tools/godot_slot.py run --who knowbots2 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/knowbots_probe.gd`.)

## Prior research
KNOWLEDGE_S411.md; docs/KNOWBOTS1_RESULT.md; tests/world_years_test.gd and tests/matchmaking_bots_test.gd (how a world is run).

## What would a human do?
A club coach picks from the local kids he has heard of; some are talked up, some are not, and the talk has little to do with the
truth. Trialling one for a month is how he finds out. Measure whether the game pays him for it.

## Prefab check
None: the probe reuses the game's world and Knowledge.gd.

## The one trap
Do not build the pool so that the answer is decided before the run (KNOWBOTS1's archetypes did). Hype independent of truth; draw by
seed, not by rating.
