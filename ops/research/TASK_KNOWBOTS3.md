# TASK KNOWBOTS3 - the Knowledge bots test, with a truth that drives results and an ORACLE arm (probe, no screen)

Status: OPEN (S463, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.
Mechanic: PROGRESSIVE KNOWLEDGE (ops/research/KNOWLEDGE_S411.md). Step 1 built (scripts/rules/Knowledge.gd).

## Why KNOWBOTS2 was VOID (Claude's code read, S463) - not a verdict on Knowledge
KNOWBOTS2 (PR 265, docs/KNOWBOTS2_RESULT.md on qwen/knowbots2) gave READER 54 vs BLIND 57 top-10s, and the control failed:
BAD SIGNER (signs the LOWEST shown prospect) scored 67, the most. Three defects in tools/knowbots_probe.gd made it unable to read:
1. The "truth" the bots read was `b["shape"]` - AttrGen's CENTRED shape (deviations around 0, AttrGen.generate lines 124-133),
   not attribute levels. Every prospect's read truth sat near 0 whatever its rating.
2. Results came from `b["rating"]` (MM.fight / WorldSim), which WorldGen._make_boxer rolls INDEPENDENTLY of the shape
   (`_roll_rating`). So nothing a bot read was linked to what decided its boxer's career.
3. Flops compared the shown centre (shape scale, ~0-10) with true_rating (~45-70): never >= 5, so 0 flops for every bot.
A probe whose worst bot beats its blind bot cannot read Knowledge either way (S450: a probe reading the same in both arms is void).

## What changes from KNOWBOTS2 (start from tools/knowbots_probe.gd on the qwen/knowbots2 branch: `git show origin/qwen/knowbots2:tools/knowbots_probe.gd`)
1. TRUTH = the boxer's real attribute LEVELS: `AttrGen.attrs_of(b)` (level = rating + shape + age wear; scripts/rules/AttrGen.gd
   line 188). The shown range per attribute is Knowledge's range around THAT value. Print, over all prospects, the correlation of
   the truth's attribute mean with b["rating"]: it must be above 0.5, else stop and print why.
2. POTENTIAL stays the probe's own formula (rating + (25 - age) x 3, clamped), hidden from every bot; the read covers attributes only.
3. Add an ORACLE bot: signs the prospect with the highest TRUE rating, pays nothing. It is the instrument's ceiling.
4. FLOP: the signed boxer's TRUE attribute mean is 5+ under the shown centre at signing (same scale now). Print per bot.
5. Everything else as KNOWBOTS2: 60 worlds (7000-7059), 4 years, 6 prospects a signing by seeded draw (never by rating), hype
   uniform 0-1 independent of truth (print the hype-truth correlation, within +-0.1), BLIND / READER / BAD SIGNER / ORACLE, reads
   charged at their prices, the sensitivity row (start half-ranges doubled in the probe only), the 90-minute cap and the pilot.

## Pass lines
INSTRUMENT (must hold or the run is VOID, print `VOID` and why): ORACLE - BLIND >= 8 top-10s per 60 worlds AND BAD SIGNER < BLIND.
DESIGN (only if the instrument holds): READER - BLIND >= 5 top-10s per 60 worlds, after what it paid. Print per bot: top-10
appearances, titles, paid for reads, flops; then the sensitivity row; then the share of the ORACLE gap READER closes
((READER - BLIND) / (ORACLE - BLIND)).

## Contract
OWNS: tools/knowbots_probe.gd, docs/KNOWBOTS3_RESULT.md
RED_TEST: tools/knowbots_probe.gd -> KNOWBOTS3 done
REGRESSION: knowledge_test, world_years_test
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ (read-only).
The result page is WRITTEN BY THE PROBE (its own _write_result_doc from the run's numbers) - never typed by hand. Claude reruns it
on the same seeds before reading a word of it. PR body: `RESULT: tools/knowbots_probe.gd -> instrument=<ok|VOID> oracle_minus_blind=<n>
reader_minus_blind=<n> pass=<yes|no> sensitivity=<n>`.
(Under 500 lines; tools/knowbots_pool.gd for the pool if needed. Runs only through
`python ops/Tools/godot_slot.py run --who knowbots3 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/knowbots_probe.gd`.)

## Prior research
KNOWLEDGE_S411.md; docs/KNOWBOTS1_RESULT.md; KNOWBOTS2 result on qwen/knowbots2; scripts/world/WorldGen.gd _make_boxer;
scripts/rules/AttrGen.gd attrs_of; tests/world_years_test.gd.

## What would a human do?
Before trusting a scouting report, check that the best possible scout (one who knows the truth) beats a coin flip. If even he
cannot, the test is broken, not the scouting.

## Prefab check
None: the probe reuses the game's world and Knowledge.gd.

## The one trap
Reading a field that does not decide results. Print, for 5 sample prospects: rating, AttrGen.attrs_of mean, shown centre, hype.
