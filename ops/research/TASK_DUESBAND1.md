# TASK DUESBAND1 - QWEN (qwen3-coder) - dues bands: what kind of club you run (pure rules + a 5-year sim test)

Status: OPEN (S424, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: the operator on the board, Q-S294-176 (11-10): "Yes, but change something" - "ok for the mechanism but the design
needs better presentation". The mechanism is approved; the screen is redrawn separately (not this task).
Design: ops/research/DUES_DESIGN_MAP_S423.md (read it whole, 60 lines). Numbers and sources: ops/research/DUES_CHOICE_S422.md.

## The fault today
Premium ($45) always earns the most and Cheap ($25) never wins: one right answer, two wrong ones. The missing half is the
youth section: today every band gives a junior the same trial chance (scripts/state/HomeJuniors.gd INTAKE_CHANCE 0.35).

## Contract
OWNS: scripts/rules/Membership.gd, tests/dues_bands_sim_test.gd
RED_TEST: tests/dues_bands_sim_test.gd -> DUES_BANDS checks=N failures=0
REGRESSION: membership_test, membership_why_test
VISUAL: none.

## The job
1. scripts/rules/Membership.gd (100 lines): add an "intake" number to each DUES band - cheap 0.50, standard 0.35,
   premium 0.20 (the chance a junior who turns 18 asks for a trial and passes, each January and September intake) - and
   `static func intake_chance(band: String) -> float` (unknown band = standard). Change nothing else in the file.
2. tests/dues_bands_sim_test.gd (new, extends SceneTree, same shape as tests/membership_test.gd): a 5-year sim for each band,
   pure, no RNG (expected values):
   - weekly: `Membership.settle_week(members, reputation, cap, band)` from 40 members; add its "dues" to money.
   - two intakes a year (10 in 5 years): expected boxers += intake_chance(band).
   - a home-grown boxer's value = HOME_GROWN_VALUE 6500 (half the stipend for a year, design map) added to the band's total.
   - cases: reputation 10, 40, 80 x cap 40, 60, 120 (9 cases). Print one line per case: the three bands' money, boxers,
     total, and the winner.
   Checks:
   a) premium earns the most dues money in every case where the cap is not binding (the band still does what it says);
   b) cheap grows the most boxers in every case (5.0 vs 3.5 vs 2.0 over 5 years);
   c) THE BAR: no band has the top total in all 9 cases (each band's club exists);
   d) the control that can read worse: the same sim with intake fixed at 0.35 for all bands (today's game) must show premium
      on top in all 9 cases - print it. If (d) does not hold, say so in the PR body: the bar is then not proving anything.
   Last line: `DUES_BANDS checks=%d failures=%d`, quit 1 on any failure.
3. If (c) fails with the design's numbers, do NOT tune a number to pass. Print the table and say in the PR body which band
   wins everywhere and by how much; Claude decides.

## Prior research
ops/research/DUES_DESIGN_MAP_S423.md, ops/research/DUES_CHOICE_S422.md, scripts/rules/Membership.gd, scripts/state/HomeJuniors.gd
(how the intake roll works today; do NOT edit it - Claude wires it after the merge), ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A club owner works out on paper what each price earns over five years and how many of the kids stay on to box.

## Prefab check
None: our own rules.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`.
No file over 500 lines. Never "he" or "she" in text. Write no check that can only pass: (d) is the proof the bar can go red.

## Result lines (PR body)
RESULT: tests/dues_bands_sim_test.gd -> DUES_BANDS checks=N failures=0
RESULT: tests/membership_test.gd -> MEMBERSHIP checks=N failures=0
