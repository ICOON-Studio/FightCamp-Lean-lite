# TASK APPROACH2 - a blind contract test for the rival club's approach (R58), with mutants

Status: OPEN (S487, Claude main). Discipline: boxing. Model: Arena (cloud). Seat: Arena (no Godot in the sandbox: write
the test, parse it with gdtoolkit, Claude runs it on the PC).

## Why
S487 wired the approach into the club week (scripts/state/ApproachWire.gd, scripts/ui/ApproachCard.gd). Claude's own test
(tests/approach_wire_test.gd) was written beside the code. A blind test written from the CONTRACT alone catches what the
author's test shares with the author's bugs.

## The contract (write the test from THIS and from ops/research/R58_MAP_S439.md section 4 M4 + M5 - do not read
ApproachWire.gd's function bodies; its header comment is part of the contract and may be read)
- A Monday (Sim.step_day reaching day % 7 == 0) opens an approach for a boxer when ALL hold: loyalty under 35; potential
  80+ or regional top 5 or professional; no approach to that boxer in the last 84 days. f["approach"] is then a Dictionary
  with day, group, line, ends (= day + 7), talk ("") and holder (a fighter id or "").
- group is "keep" only when the boxer is on a day job; the holder is set only for "keep" and is the most loyal team-mate on
  the club stipend (not a pro, no day job, weekly_salary > 0).
- Needs.blockers(c) holds an entry with act "approach" while it is open; Needs.flags(c) holds "APPROACHED".
- ApproachWire.answer(c, fid, id) returns "" when taken, else the reason. After any answer the approach is closed.
  match ("keep"): the boxer on the stipend ($250, no day job), loyalty +12, GymSpend.set_stipend(c, f, false) refused
  ("held to ...") until day + 84. half: both on $125, both train at 92.5% (GymSpend.gain ratio), boxer +6 (+10 after a
  landed talk), holder -4. move: the holder on a day job ($0), holder -12; the boxer on $250, +12. promise: $3,500 paid, a
  show booked (c.show.day > today), one open "show_top" row in c.promises; while it is open, no bout offer passes
  cost loyalty; on the night a fit boxer's row is "kept" (+10). let_go: the boxer is in c.fighters until the next
  Monday, then gone and in c.rivals with club "Eastside ABC".
- No answer: on the Monday at or after ends the boxer is gone (c.fighter_by_id(fid) == {}).
- ApproachWire.talk(c, fid): ok once; a second call is refused; f["approach"]["talk"] becomes "landed" or "failed".
- A boxer at loyalty 40, or with potential 70 and unranked, never gets an approach.

## What to do
1. tests/approach_contract_test.gd (extends SceneTree; under 400 lines): set up a club the way tests/leaving_test.gd does
   (Career.quick_start(), Data.lucy(), Roster.sign_fighter(c, Data.PROSPECTS[0], [])), then check every bullet above.
   Print `ok  <what>` / `FAIL <what>` per check and `APPROACH_CONTRACT PASS fails=0` or `FAIL fails=<n>`, quit(0|1).
2. Five mutants in the PR body: for each, the one-line change to ApproachWire.gd that your test must catch and the check
   that catches it (e.g. HOLDER_MOVE sign, the 84-day lock off by a week, unanswered never leaves, holder picked for a
   "bout" group, the talk allowed twice). Claude applies each on the PC and confirms the test goes red.
3. Parse the file with gdtoolkit (gdparse) before the PR.

## Pass lines
RESULT: tests/approach_contract_test.gd -> APPROACH_CONTRACT PASS fails=0 (Claude runs it)
RESULT: mutants -> 5 of 5 caught (Claude runs them)

## Contract
OWNS: tests/approach_contract_test.gd
RED_TEST: tests/approach_contract_test.gd -> APPROACH_CONTRACT PASS fails=0 (no such file on main)
REGRESSION: tests/approach_wire_test.gd, tests/approach_test.gd
VISUAL: no
NOT YOURS: every other file.

## Prior research
ops/research/R58_MAP_S439.md (sections 4, 7, 8); tests/leaving_test.gd (setup); tests/approach_test.gd (the pure rules).

## What would a human do?
A QA tester reads the design sheet, not the code, and tries each answer once.

## Prefab check
None: our own rules.
