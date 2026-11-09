# TASK FLOOR1 - QWEN (qwen3-coder) - places free: the pure rule

Status: OPEN (S411, Claude main). Discipline: boxing. Model: qwen3-coder.

## Contract
OWNS: scripts/rules/GymPlaces.gd, tests/gym_places_test.gd
RED_TEST: tests/gym_places_test.gd -> GYM_PLACES failures=0
REGRESSION: gym_plan_test, gym_people_test
VISUAL: no

## Prior research
ops/research/FLOOR_PLACES_S411.md is the design: read it first. scripts/rules/GymPlan.gd and assets/data/gym_plans.json (plans, zones, items), scripts/rules/GymPeople.gd (who is in), scripts/rules/GymUpgrades.gd (PREMISES, room), scripts/state/GymSpend.gd member_cap.

## What would a human do?
Walk the floor at the busy hour and count how many people each bag, ring and rack can take, then see who is on them.

## Prefab check
GymPlan already loads plans and lists items by kind. Use it. Nothing new to find.

## The job
A pure module with zero game-state writes, static functions only:
- `PLACES_OF`: places per item kind: ring, bag, rack, bench, mat (the only kinds that hold people training; desk, sofa, lockers, office_desk and treatment hold none). Choose the numbers so each of the four plans now in gym_plans.json comes to 47 places, plus or minus 3 (they are the middle premises tier), and write the reasoning in a comment: a ring takes a few pairs, a bag one or two.
- `MEMBERS_PER_PLACE := 3`.
- `places(plan) -> {zone_or_kind: {places: int}, "total": int}`.
- `busy(members: int) -> int`: members in at the busy hour (members / 3, rounded up).
- `fill(plan, members: int, fighters: Array) -> {kind: {places: int, taken: int}}`, fighters being `[{id, station_kind}]`. Fighters take a place first, at their station; members then spread by each kind's share of the places, largest remainder first; `taken` never exceeds `places`; anyone over the total is reported as `"waiting": n`.
- `free(fill_result) -> int`.

## Do
tests/gym_places_test.gd first, printing `GYM_PLACES failures=<n>`. Population named in its output. Cover: each of the four plans within 47 +/- 3; 140 members fills the floor, within 3; 30 members leaves most free; a fighter at the bags takes a bag place before any member; taken never above places for members 0 to 400; the taken total plus waiting equals busy + fighters; a plan with no training items returns total 0 without error.

## Rules
Do not edit gym_plans.json, GymSpend, or anything outside OWNS. No file over 500 lines. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`, headless, --audio-driver Dummy. Parse check first. Read ops/research/GDSCRIPT_TRAPS.md.

## The one trap
Rounding: spreading by share and rounding each station can lose or invent a person. The test on totals is there for that.

## Result lines (PR body)
RESULT: tests/gym_places_test.gd -> GYM_PLACES failures=0
