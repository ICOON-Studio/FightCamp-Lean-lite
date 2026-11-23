# COACHDEEP5 - deep coaches v5: COACHDEEP4 section 5, a catchment ceiling on class members, then the same probe (S541)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -- <files>`) and push them.
Godot only through `python ops/Tools/godot_slot.py run --who COACHDEEP5 -- <cmd>` (headless, Dummy audio), one run at a time,
output to a file, wait on its done line.

## Why
COACHDEEP4 FAILED 6 of 10 (`docs/COACHDEEP4_RESULT.md` section 5): a, g, h, i fail. Its rank bands and the record in the
departure price worked (f2, j pass) - keep them. The class nights that follow the members, with the members following the class
nights, had no ceiling but the room: both clubs grew to ~130-150 members and the club-size question vanished. Owner Q-311 "Bouts
pay by rank" stands; his 24 grilling answers (`ops/research/COACHDEEP_GRILL_S539.md`) stay binding; the stipend stays $250.

## Do
1. `ops/research/DESIGN_COACHDEEP5.md`: v4 + COACHDEEP4 section 5 items 1-3 in order:
   - A CATCHMENT CEILING: the class pull on the members target is capped at the club size's catchment (the town's natural
     members + the size's add + at most one full class night's worth, 12), so a small club stays ~40-45 and a big one ~85-95.
     Give the real-world reason (a boxing club draws from a few miles; the room is a coaching limit, not demand).
   - Chemistry sweep below 0.25 (0.15 / 0.10) ONLY as a written change to bar g's size list in this map, before any run, used
     only if CHEM is still best in more than 5 of 10 at 0.25.
   - Ties printed: a cell where SMART and CHEM tie is reported as "CHEM = SMART".
2. The same ten bars as COACHDEEP4, written BEFORE the run, never loosened. Probe `tools/coachdeep5.gd` (+ `_rules.gd`), based on
   tools/coachdeep4*. Result `docs/COACHDEEP5_RESULT.md`.
3. PASS -> `ops/research/CRITIC_COACHDEEP5_BRIEF.md` (built like CRITIC_COACHDEEP1_BRIEF.md, opening with CRITIC_PACK.md) queued
   for kalli and dola (`python ops/Tools/seat_queue.py add --seat <seat> --brief research/CRITIC_COACHDEEP5_BRIEF.md`).
   FAIL -> what to change, and whether the mechanic can reach 8 at all (if not, say so plainly: it becomes the owner's
   cut-or-keep question), stop.

## Feedback loops
- Class nights -> members target -> members -> class nights wanted: THE loop v4 left open. Cap: the catchment ceiling above
  (members from classes never exceed catchment). Check in the trial: members at week 104 stay within catchment + 5 in every arm.
- Members -> dues -> cash -> coach hires -> coach evenings -> class nights: bounded by the same ceiling (fewer members = bounded
  dues); print cash at week 104 per arm to show it does not run away.
- Rank bands: wins -> rank -> purse -> keeps the boxer -> more wins. Cap: the band top ($1,500 at number 1) and the ladder's
  fixed size; the boxer leaves only by the departure price.
- Chemistry -> line gain -> wins -> rank: one-way (chemistry is not raised by wins in this model); say so if the code differs.
- ONE-REP TRIAL FIRST: run mode=full reps=1 (and the 10-rep class diagnostic) before the full 30-rep run. If the members in
  any arm leave the catchment band, or every cell converges to the same best arm, stop and fix the map before the full run.

## Prior research
COACHDEEP1-4 results and designs, GymBills.gd, BoutRules.gd, StaffRoles.gd.

## What would a human do?
A club fills its class nights from the streets around it; a fifth class night does not invent new people in town.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_COACHDEEP5.md, tools/coachdeep5.gd, tools/coachdeep5_rules.gd, docs/COACHDEEP5_RESULT.md, ops/research/CRITIC_COACHDEEP5_BRIEF.md
RED_TEST: tools/coachdeep5.gd
REGRESSION: none
VISUAL: none
