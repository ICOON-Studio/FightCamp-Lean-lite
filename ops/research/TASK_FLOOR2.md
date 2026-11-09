# TASK FLOOR2 - QWEN (qwen3-coder) - the four gym layouts each hold about the same number of people

Status: OPEN (S412, Claude main). Discipline: boxing. Model: qwen3-coder.

## Contract
OWNS: assets/data/gym_plans.json, scripts/rules/GymPlaces.gd, tests/gym_places_test.gd
RED_TEST: tests/gym_places_test.gd -> GYM_PLACES failures=0
REGRESSION: gym_plan_test, gym_people_test, gym_hub_test, gym_bonus_test
VISUAL: no

## Prior research
ops/research/FLOOR_PLACES_S411.md is the design: read it first. Today GymPlaces.places totals 39 to 55 across the four plans in assets/data/gym_plans.json, so tests/gym_places_test.gd's bar was loosened to 47 +/- 10. ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Walk each of the four layouts and move a bag or a rack until each room holds about the same number of people, while each still feels like its own gym.

## Prefab check
GymPlan already loads plans and validates items. Nothing to find.

## The job
1. Change the item counts inside the four plans so each one's total places is 47 +/- 3. Keep each plan's character (ops/research/FLOOR_PLACES_S411.md rule 5): the bag wall has the most bag places, the conditioning floor the most mat places, two full rings keeps two rings, front of house keeps its big reception. Do not change PLACES_OF unless there is no other way; if you do, say why.
2. Every item must still fit inside its zone and pass GymPlan's validation.
3. In tests/gym_places_test.gd put the bar back: each plan within 3 of 47, with the check's words saying so. Print each plan's total per kind in the test's output.

## Rules
Do not add the small-unit or club-building plans: that waits for the owner's call on the main screen. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`, headless, --audio-driver Dummy, never the console build. No fixed he or she in any text.

## The one trap
A plan can reach 47 by piling a dozen benches into a corner. The test passes and the gym looks wrong. Spread changes over the kinds, and list before and after per plan in the PR body so Claude can see it.

## Result lines (PR body)
RESULT: tests/gym_places_test.gd -> GYM_PLACES failures=0
