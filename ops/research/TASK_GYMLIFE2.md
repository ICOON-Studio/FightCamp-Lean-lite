# TASK GYMLIFE2 - CURSOR (Grok 4.7 High) - the gym picture's three leftover faults: the shadow strip pops, walks cut corners, a person stands under a button

Status: OPEN (S435, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: GYMLIFE1's own result file (docs/GYMLIFE1_RESULT.md, "What could not be done") and Claude's read of its three
stills (docs/mockups/s429/gymlife1/gym_0.png: the person on the open floor stands half under the "Fighters" button).
The operator asked for the gym to look alive (S429: "can you write scripts and animations for the fighters/customers
that work out on the gym"); these are the faults a player sees in the first minute. You cannot see pictures: work from
the numbers below, and print the numbers asked for.

## Contract
OWNS: scripts/ui/GymFloorPeople.gd, scripts/rules/GymWorkouts.gd, scripts/rules/GymFloorSpots.gd, tools/bake_hub_sprites.gd, assets/ui/art/hub_sprites, tests/gym_life2_test.gd, tests/gym_workouts_test.gd, docs/GYMLIFE2_RESULT.md, docs/mockups/s435/gymlife2
RED_TEST: tests/gym_life2_test.gd -> GYM_LIFE2 failures=0
REGRESSION: gym_workouts_test, gym_people_test, gym_floor_people_test, gym_hub_test, gym_places_test, file_limits_test, no_pronoun_test
VISUAL: yes
NOT YOURS: scripts/rules/GymPeople.gd (read it; do not edit), the hub buttons' own script and positions, any other screen.

## What exists (read these first)
- scripts/ui/GymFloorPeople.gd (294 lines): `_begin`, `_step_walk`, `_route_px(from_id, to_id)`, `_tile`, `_blit`.
  A walk today is ONE straight line between the two spots' pixels, through whatever is between them.
- scripts/rules/GymPeople.gd: `route(plan, a, b)` returns the tiles of the way round the kit, bends included.
- scripts/rules/GymWorkouts.gd: CLIPS, REST, `pick`. The "shadow" strip is three pieces (slip frames 0-4, pull 5-9,
  jab 10-15); frame 15 (the jab's guard) does not meet frame 0 (the slip's lower guard): a visible pop every loop.
- tools/bake_hub_sprites.gd: bakes the strips (16 frames, 96 x 128, feet at 48,107) on the hidden desktop.
- The hub buttons (Reception, Club office, World, Fights, Fighters, Playbook, Equip the gym) are drawn over the
  picture. Find where their rectangles are laid out (grep "Equip the gym" and "Playbook" under scripts/ui) and READ the
  rectangles from that code; do not copy numbers by hand.

## The job
1. THE SHADOW STRIP CLOSES. Re-bake `shadow` so the loop has no pop: order and cut the three pieces so that each join
   (piece to piece, and the last frame back to frame 0) is the pair of poses with the smallest pose gap you can find
   inside the clips we own, and where a join's gap is still over 0.10 put the guard pose both pieces share between
   them (a real frame from a clip, never an invented blend of two poses). Print for every join: the two source clips and
   times, and the pose gap before and after. The bar: every join in the strip, the wrap included, has a pose gap at or
   under 0.10 (the same pose-gap measure GYMLIFE1's table used; say in the result file exactly how it is computed).
   The other seven strips keep their bytes (do not re-bake what you do not change).
2. A WALK FOLLOWS THE ROUTE. `_route_px` returns one pixel point per route tile from `GymPeople.route` (start spot,
   every bend, end spot), and `_step_walk` walks them in order at the same speed as today, facing the direction of the
   current leg (walk or walk_back by the leg's direction, as the existing code decides for a whole walk). A spot with
   no plan tile (cardio) keeps the fade. At most 2 walkers, as today.
3. NOBODY STANDS UNDER A BUTTON. A person's drawn rectangle (the frame at its drawn scale, around the feet point) must
   not overlap any hub button's rectangle (icon plus label) by more than 10 percent of the person's area. Do it in the
   spot choice (a spot that fails is not used while the button is shown), not by moving buttons. If the open floor has
   no free spot that passes, that person is not placed.
4. tests/gym_life2_test.gd, headless, on the REAL scene path (build the same node the home screen builds, with the same
   `setup` and `lay` calls the game makes; no private copy of the maths):
   a. shadow: read the baked strip's join data that the baker writes beside the strip (a small .json you add: per join
      the gap), every gap <= 0.10; and the strip file's frame count is still 16 at 96 x 128. Red on main.
   b. walk: for 40 seeded pairs of spots that have a route with at least one bend, step the walk to its end with a
      fixed dt and record the positions: every recorded position lies within 6 px of the polyline through the route's
      tile points, and the walker reaches the end spot. Red on main (the straight line leaves the polyline).
      Control arm: a pair with no bend passes on main and after.
   c. buttons: over 200 seeds of `_place`, no placed person's rectangle overlaps a button's rectangle by more than 10
      percent. Print the worst overlap found. Red on main (prove it: print main's worst overlap in the result file).
   Each bar must be able to fail: say in the result file the number each one read on main before your change.
5. STILLS (you render, Claude reads): through `python ops/Tools/godot_slot.py run --who cursor -- python
   tools/hidden_desktop.py run ...` (never on a monitor; the plain win64 exe, never _console). Three stills of the gym
   picture 5 seconds apart into docs/mockups/s435/gymlife2/, with one of them taken while somebody walks a bend, and for
   each person print: id, spot, clip, frame, drawn rectangle. docs/GYMLIFE2_RESULT.md: the join table, main's numbers
   and yours for the three bars, the pass lines, what you could not do.

## Prior research
docs/GYMLIFE1_RESULT.md (the clip table and the list of what was left), ops/research/TWOPOINT_ALIGNMENT.md (people walk
between stations along the floor, never through kit), scripts/rules/GymPeople.gd header (S409: spots and routes).

## What would a human do?
Watch one member for a minute: the shadow boxer flows from slip to pull to jab and back with the hands returning to
the same guard; someone crossing the gym walks round the ring, not through it; and nobody stands behind a sign.

## Prefab check
The baker, the bodies, the clips and the route function exist. No new motion is made here: joins use frames we own.

Rules: no script over 500 lines (GymFloorPeople.gd stays under 300); no he / she in any script text; parse before
testing (`python tools/check_scripts.py <files>` if present, else a headless load of each file); new features ship ON;
keep the sprite files light; never loosen or delete an existing test to pass; a test that cannot go red is not a test.
Commit on your branch and PUSH it.
RESULT lines for the PR body: `RESULT: tests/gym_life2_test.gd -> GYM_LIFE2 failures=0` and one per regression test.
