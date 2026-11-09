# TASK GYMFIGURES1 - CURSOR (Grok 4.7 High) - boxers working on the floor of the owner's gym picture

Status: OPEN (S416, Claude main). Discipline: boxing. Model: grok-4.7-high. Mockup: none, the picture is the screen.
Source: S415 handover: "Boxers on the floor last", and Claude's answer to the operator: "fighters yes". The gym picture became Home in S414 and the walking figures were hidden then, because they walk the old drawn floor.
Do not read or change the fighter model files. FIGHTERMODEL4I is merging beside this.

## Contract
OWNS: scripts/rules/GymFloorSpots.gd, scripts/ui/GymFloorPeople.gd, scripts/ui/GymHub.gd, tests/gym_floor_people_test.gd
RED_TEST: tests/gym_hub_test.gd -> GYM_HUB failures=0
REGRESSION: gym_hub_test, gym_people_test, gym_slots_test, home_look_test, golden_path_test
VISUAL: no

## Prior research
scripts/ui/GymHub.gd (PICTURE_SIZE 1672x941, how `_lay` turns a picture point into a screen point: corner + point * k), scripts/ui/GymEquip.gd (how owned pieces are drawn over the picture: use the same transform), scripts/rules/GymSlots.gd (`owned(rows, day)`, `item(id)`), assets/data/gym_slots.json (each piece's kind and its rect x, y, w, h in picture pixels), scripts/rules/GymPeople.gd (`crowd(members, stems)`, `JOB`), scripts/ui/HubFigures.gd (how a sprite strip is loaded and played: reuse FW, FH, FEET, FPS, FRAMES). ops/research/MENU_BUILD_RULES.md, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Put one person at each piece of kit the club owns: hitting the bag, lifting at the rack, on the treadmill. The room looks used, and it looks busier as the club grows.

## Prefab check
HubFigures and the 19 baked boxers in assets/ui/art/hub_sprites already exist. No new art.

## The job
1. scripts/rules/GymFloorSpots.gd, pure, no nodes. `spots(rows, day) -> Array` of {id, kind, at: Vector2 (picture pixels, where the feet stand), job}. One spot per owned piece of kind bag, mat, rack, bench or cardio. `at` is the middle of the piece's rect in x and 6 px below its bottom edge in y, clamped inside the picture with a margin of 20 px. Sort by y, so nearer figures draw last. Job: bag -> "jab_back"; every other kind -> "stand", except mat -> "idle".
2. scripts/ui/GymFloorPeople.gd, a Control over the picture that takes no clicks. It places `mini(crowd size, spots)` people from `GymPeople.crowd(c.members, stems)`, the club's own fighters first, each on one spot. Picks are seeded (a hash of the first owned ids), so a redraw does not reshuffle them. Plays the strip for the job. Every 8 to 16 seconds one person fades out over 0.3 s and fades in on a free spot over 0.3 s. Nobody crosses the floor in this task: nothing tells a walker where the kit is. Figure height: 20% of the picture's height on the screen at the bottom edge, 15% at y = 40% of the picture, linear in y, the same for every figure on one row. When `MenuFx.instant` is true, draw once and do not process (stills and tests).
3. GymHub.gd: add it above the pieces and below the pins. Leave the hidden IsoGym and HubFigures exactly as they are: gym_hub_test and GymPlan read them.
4. Buying a piece: the page already re-renders, so a new spot just appears once the fitters are done. Check this in the test.
5. tests/gym_floor_people_test.gd prints `GYM_FLOOR_PEOPLE failures=<n>`: a spot for each owned piece of those kinds and none for scales, timer or ring; every spot inside the picture; sorted by y; unfitted pieces give no spot; the page shows at least 2 people on quick start; no two people on one spot; a bought piece gives a new spot after 7 days; the node ignores the mouse, so pins still click (MOUSE_FILTER_IGNORE).

## Rules
Windowed runs only through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`. New features ship ON: no switch. No file over 500 lines. No he or she in any text. Claude renders the page and opens the still: you cannot see images, so report positions as numbers.

## The one trap
`GymSlots.owned(rows, day)` with empty rows means an old save: everything stands. That must still work and must not make a crowd bigger than `GymPeople.crowd` allows. And c.day moves, so read the day from the career at build time, never cache it.

## Result lines (PR body)
RESULT: tests/gym_hub_test.gd -> GYM_HUB failures=0
RESULT: tests/gym_floor_people_test.gd -> GYM_FLOOR_PEOPLE failures=0
