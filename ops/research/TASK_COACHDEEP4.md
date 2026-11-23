# COACHDEEP4 - deep coaches v4: COACHDEEP3 section 5, then the same probe (S541)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -- <files>`) and push them.
Godot only through `python ops/Tools/godot_slot.py run --who COACHDEEP4 -- <cmd>` (headless, Dummy audio), one run at a time,
output to a file, wait on its done line.

## Why
COACHDEEP3 FAILED 7 of 10 (`docs/COACHDEEP3_RESULT.md` section 5): f2, h, j fail. Owner Q-311 "Bouts pay by rank" stands; his 24
grilling answers (`ops/research/COACHDEEP_GRILL_S539.md`) stay binding; the stipend stays $250.

## Do
1. `ops/research/DESIGN_COACHDEEP4.md`: COACHDEEP3 section 5 items 1-3 in order - rank bands (unranked $450, 4th or lower
   $1,000, 2nd-3rd $1,200, number 1 $1,500, each with its real-world reason), the departure price that counts the wins she takes
   with her, class nights that follow the members (one full night per 12 members, then a half, then nothing).
2. Same ten bars as COACHDEEP3, written BEFORE the run, never loosened; the 10-rep class diagnostic target from item 3.
   Probe `tools/coachdeep4.gd` (+ `_rules.gd`), based on tools/coachdeep3*. Result `docs/COACHDEEP4_RESULT.md`.
3. PASS -> `ops/research/CRITIC_COACHDEEP4_BRIEF.md` (built like CRITIC_COACHDEEP1_BRIEF.md, opening with CRITIC_PACK.md) queued
   for kalli and dola (`python ops/Tools/seat_queue.py add --seat <seat> --brief research/CRITIC_COACHDEEP4_BRIEF.md`).
   FAIL -> what to change, stop.

## Prior research
COACHDEEP1-3 results and designs, GymBills.gd, BoutRules.gd.

## What would a human do?
A club pays to keep the kid who wins medals; it does not let her walk to save a stipend if she takes the wins with her.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_COACHDEEP4.md, tools/coachdeep4.gd, tools/coachdeep4_rules.gd, docs/COACHDEEP4_RESULT.md, ops/research/CRITIC_COACHDEEP4_BRIEF.md
RED_TEST: tools/coachdeep4.gd
REGRESSION: none
VISUAL: none
