# TASK GYMLIFE1 - CURSOR (Grok 4.7 High) - the gym picture comes alive: real workouts at each piece of kit, and the club's fighters at the session they have today

Status: OPEN (S429, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator, S429, on a still of the gym picture (six people standing at the bags, one walking): "can you write
scripts and animations for the fighters/customers that work out on the gym or this is work for later ?"
Decision (Claude): now, in one small step, on what exists. You cannot see pictures: work from the lists below.

## Contract
OWNS: scripts/rules/GymPeople.gd, scripts/rules/GymWorkouts.gd, scripts/ui/GymFloorPeople.gd, tools/bake_hub_sprites.gd, assets/ui/art/hub_sprites, tests/gym_workouts_test.gd, tests/gym_people_test.gd, tests/gym_floor_people_test.gd, docs/GYMLIFE1_RESULT.md
RED_TEST: tests/gym_workouts_test.gd -> GYM_WORKOUTS failures=0
REGRESSION: gym_people_test, gym_floor_people_test, gym_hub_test, gym_places_test, file_limits_test, no_pronoun_test
VISUAL: yes

## What exists (read these first)
- scripts/ui/GymFloorPeople.gd (228 lines): the people on the gym picture. Each person is a sprite strip
  `assets/ui/art/hub_sprites/<body>_<clip>.png` (frames 96 x 128, feet at 48,107). Clips today: idle, idle_back, jab,
  jab_back, stand, walk, walk_back. Every 8 to 16 s one person fades out and in on a free spot. "Nobody walks."
- scripts/rules/GymPeople.gd: `spots(plan)`, `route(plan, a, b)`, `crowd(members, fighter_stems, premises)`, and
  `JOB`: kit kind -> clip. Only the bag has a workout (`jab_back`); every other kit is `stand` or `idle`.
- tools/bake_hub_sprites.gd: renders those strips from the 3D boxer bodies and the baked clips in assets/anim/baked
  (windowed, GPU). Clips we own there include: boxing_body_hook, boxing_rear_uppercut, boxing_slip, boxing_pull,
  mc_Box1_M3_Combo_Punch, mc_Box1_M3_Combo_LH_RU, mc_Box1_M3_Body_Shot, mc_Box1_M3_Block_Loop, mc_Box1_M3_Back_Weave,
  loc_advance, loc_retreat, af_idle, af_drink, af_talk, af_sit_idle, af_crouch_idle, af_walk (list the folder).

## The job
1. NEW CLIPS (bake them for every body the hub uses, front and back views as the existing clips have, same frame size and
   feet point, a loop that closes: last frame flows into the first):
   bag_combo (jab-cross-hook from the combo clips), bag_body (body hook), bag_upper (rear uppercut), shadow (slip, pull and
   a punch, facing the room), guard_move (block loop with small steps), rest_drink (af_drink), rest_talk (af_talk),
   stretch (af_crouch_idle or the nearest we own). If a clip does not loop cleanly, cut it at the closest matching pose
   and say the frame numbers. Do not invent motion we do not own: a workout with no clip (skipping rope, speed bag hands)
   goes in the result file as MISSING with what it needs.
2. NEW PURE RULE scripts/rules/GymWorkouts.gd (no nodes, no art, zero UI preloads):
   - `clips_for(kind) -> Array`: kit kind -> the clips a person cycles through there (bag: jab_back, bag_combo, bag_body,
     bag_upper; mat or free floor: shadow, guard_move, stretch; bench, sofa: rest_drink, rest_talk; desk kinds: stand).
   - `pick(kind, person_id, minute) -> String`: which clip now. Deterministic from the person's id and a 20 to 40 second
     block (so one person works a combination for half a minute, rests, changes), never the same clip three blocks running,
     and a rest clip about one block in five.
   - `station_for(session) -> String`: a fighter's morning session id (WeekPhase.SESSIONS: roadwork, intervals, heavy_bag,
     strength, speed_bag, slip_rope, shadow, neck) -> the kit kind that fighter stands at today ("" = out of the gym:
     roadwork and intervals), and the evening night (pads, sparring, film, rest) the same way.
   - `fighters_today(fighters, day) -> Array of {id, stem, kind, clip}`: the club's own fighters at the kit their real
     session uses today, so the picture shows the week the player planned. A fighter out on roadwork is not on the floor.
3. WIRE IT in GymFloorPeople.gd: the club's fighters are placed first from `fighters_today`; members fill the other
   spots; each person's clip comes from `GymWorkouts.pick`. A person who changes spot WALKS there along
   `GymPeople.route` with the walk / walk_back strips (the fade stays only when there is no route). At most 2 people
   walking at once. Keep the file under 300 lines; no clicks taken, as today.
4. tests/gym_workouts_test.gd (pure, red on main because the module does not exist): every kit kind returns only clips
   whose strip file exists for every hub body; pick() is deterministic, changes over time, never repeats three blocks,
   rests about one block in five (bound 10 to 30 percent over 500 blocks, for 5 different person ids); station_for
   covers every WeekPhase.SESSIONS id; fighters_today puts a heavy_bag fighter at a bag and leaves a roadwork fighter out;
   two different fighters never get the same spot.
5. STILLS AND A FILM (you render, Claude reads): through `python ops/Tools/godot_slot.py run --who cursor -- python
   tools/hidden_desktop.py run ...` (never on a monitor; the plain win64 exe). Three stills of the gym picture 5 seconds
   apart into docs/mockups/s429/gymlife1/, and print for each person: id, spot, clip, frame. docs/GYMLIFE1_RESULT.md: the
   clip table (clip, source clip, frames, loop cut), MISSING workouts, the pass lines, what you could not do.

## Prior research
ops/research/TWOPOINT_ALIGNMENT.md (how Two Point shows people at work: short loops, walk between stations, the room
shows what is happening), scripts/rules/GymPeople.gd header (S409), memory: the gym floor is a training floor (no chairs
or boards on it), gym art is bright and alive.

## What would a human do?
Stand in a boxing gym for a minute: one hits the bag in bursts and rests, one shadow boxes, two talk by the bench, one
walks to the water. Nobody repeats one punch forever and nobody stands still facing a bag.

## Prefab check
The sprite baker, the bodies and the clips exist. Missing motions (skipping rope, speed bag) are listed, not made here.

Rules: no script over 500 lines; no he / she in any script text; parse before testing; new features ship ON; keep the
sprite files light (the same size and colour depth as the existing strips).
RESULT lines for the PR body: `RESULT: tests/gym_workouts_test.gd -> GYM_WORKOUTS failures=0` and one per regression test.
