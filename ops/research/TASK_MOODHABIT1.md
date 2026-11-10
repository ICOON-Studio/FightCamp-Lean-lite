# TASK MOODHABIT1 - QWEN (qwen3-coder) - what a boxer's mood and each habit are worth in wins. Measure only

Status: OPEN (S427, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: the week design (ops/research/WEEK_DESIGN_V3_S427.md, section 5 gate table) gives Reid's evenings to "the other
boxer" (so he is not Flat for his next bout) and to "a habit of the boxer's own". Both are INVENTED as worth doing until
measured: "Flat against Steady in the same bout: under 2 points = the claim is a label"; "a habit on and off, 300
bouts: under 2 for all = decoration". This task measures both in the game as it is. It changes no game file.

## Contract
OWNS: tools/mood_habit_probe.gd, docs/MOODHABIT1_RESULT.md
RED_TEST: tools/mood_habit_probe.gd -> MOODHABIT1 cells=<n> bouts_per_cell=400 (measure only)
REGRESSION: golden_path_test
VISUAL: no

## The job
1. Read tools/fire_level_probe.gd (on main since S427) for the harness: how it builds Lucy and the opponent, plays 400
   paired bouts a cell headless and prints a win share. Reuse it; the control cell must reproduce its 41.3% within 1 point
   (say what you got; if it does not, stop and say why before measuring anything else).
2. MOOD. Find in the code how the boxer's mood band changes a bout (grep CornerTrust, FighterProfile.trust, "uptake",
   morale bands 105 / 100 / 85 / 70; say which functions you read and what exactly the band multiplies). Cells, same
   plan, same opponent, same seeds: Fired up, Steady, Flat, Low. Twice: with the corner calling (the harness's default
   caller) and with the corner silent (Say nothing every exchange). Report wins in 100 per cell and each band's gap to
   Steady.
3. HABITS. List every habit the game can give a boxer (grep HabitFix, fight_habits.json, habit_name). For each: the
   same boxer with the habit and without it, 400 bouts a cell, against (a) an opponent whose file punishes that habit if
   the game has such a link (say where), and (b) one that does not. Report wins in 100 with / without and the gap.
4. Print one line per cell: `CELL kind=<mood|habit> name=<x> corner=<calls|silent> opp=<name> wins=<x.x>`.
5. docs/MOODHABIT1_RESULT.md: the control line; the two tables; which functions carry each effect; then five sentences:
   is keeping a boxer out of Flat worth an evening of Reid's hands (2 points or more against Steady)? which habits are
   worth four evenings (2 or more) and which are decoration? does the corner's silence change either answer? what could
   you not measure? Bend no threshold; a cell that cannot be built is reported as "the game has no <x>".

## Prior research
tools/fire_level_probe.gd and docs/FIRELEVEL1_RESULT.md (the harness and its control), docs/READBACK1_RESULT.md (400
paired bouts a cell), ops/research/WEEK_DESIGN_V3_S427.md section 5, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A coach knows a flat boxer listens less and a bad habit gets punished by the right opponent; the question for the game
is only how much, so the week's choices can be priced honestly.

## Prefab check
The harness exists (tools/fire_level_probe.gd). No asset or library applies.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver
Dummy --path . --script res://tools/mood_habit_probe.gd` (the plain win64 exe, never the console one).
RESULT lines for the PR body: `RESULT: tools/mood_habit_probe.gd -> MOODHABIT1 cells=<n> flat_gap=<x.x> best_habit_gap=<x.x>`.
