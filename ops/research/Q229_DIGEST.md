# Q229 DIGEST - mat room + staff room + physio, pass 2 (Qwen, room designer)

Branch `qwen/q229-rooms-pass2`. Renders + review sheets: `previews/q229/`
(`mat/staff/physio_before.png`, `_after.png`, `review_*_before/after.png` - every sheet opened
and scored below; `_wip.png` are working stills, not committed). Harness: `Godot/tools/q229_render.gd`
(career "Nicosia Ironworks" - a render never paints its task id on the wall).

## Rubric (Tools/room_review.py --rubric), before -> after, one line of evidence each

MAT ROOM (concept: the MAT ROOM zone of `gym_tier34_team_hq.jpg` - the room has no concept of its own)
- SILHOUETTE 3 -> 4: tatami field with the red border, pad band to shoulder height, kit wall and
  door corridor in the concept's arrangement; reads as the mat zone at thumbnail size.
- LIGHT 1 -> 4: AgX + a warm shadowed sun through a new clerestory, contact shadows under every
  body and the bench; pass 1 was one flat ambient wash.
- MATERIAL 1 -> 4: our tatami rubber (grain + laid seams) tinted per tile, leatherette wall pads,
  Bricks085 brick back wall, Concrete031 surround - world-scale triplanar, no flat colour left.
- LIFE 2 -> 4: a pad pair on their feet, a ground pair (one down, one working), two stretchers
  facing the coach; towels, bottles, leaning shields, pad stack, dummy, spare mats by the door.
- CLARITY 2 -> 4: the dues figure moved ONTO the board, the coach's floating tag and the airborne
  club blade are gone - the blade is a fascia over the door, the words are painted banners.
- BAR 1 -> 3: reads as a management-game room screenshot; greybox-ish kit props still cap it.

STAFF ROOM (concept `room_staff.jpg`)
- SILHOUETTE 3 -> 4: lockers left, rota board back-centre, table on a rug mid-room, leather sofa
  and coffee table right, kitchenette back-right, candidate at the door - the concept's plan.
- LIGHT 1 -> 4: a visible pendant with a warm pool and shadow on the table, daylight from the
  left window onto the polished floor; pass 1's right wall was blown out white.
- MATERIAL 1 -> 4: our polished concrete (sheen + slab joints), painted plaster, cork board,
  leather sofa, wood table/counter tops, dark steel lockers and sink.
- LIFE 2 -> 4: the coach sits ON his chair over a clipboard, a coach on the sofa with his mug,
  the candidate with his CV, jackets on the rack, bags on the lockers, magazines, kit shelf.
- CLARITY 2 -> 4: the floating coach cards and HIRE A COACH tag are gone - a coach's status lives
  on his locker plate, COACH WANTED on the noticeboard, ROTA BOARD inside a header band on the
  board (pass 1's header floated above the wall and under the page plate).
- BAR 1 -> 3.

PHYSIO (concept `room_recovery_suite.jpg`)
- SILHOUETTE 2 -> 4: treatment table, cold plunge, compression recliner, chart wall, roller rack
  and bands where the concept puts them; pass 1 was an empty white box with one table.
- LIGHT 1 -> 4: cool clinical key with a shadowed treatment light over the table, window daylight,
  contact shadow under every station; AgX.
- MATERIAL 1 -> 4: vinyl tile with grout, rubber station mats, slate chart boards, steel plunge,
  leather pads and boots, wood table frame and plunge step.
- LIFE 2 -> 4: the held fighter on the table with the physio at his head, a bather in the plunge,
  a fighter in the recliner's boots, towels, tape, bottles, rollers, bands, plants, bench.
- CLARITY 2 -> 4: each chart's region/hold line sits ON its board (flat, no billboard), the
  patient's floating tag is gone, the club blade moved to the right wall clear of the door sign.
- BAR 1 -> 3.

Two lowest rows per room were MATERIAL and LIGHT (both 1); both are 4 now. No row went down.

## Kept contracts / deliberate deviations
- Test contracts kept verbatim: node names (Shell, Mats, Class/Member<n>, Objects/dues,
  Objects/coach, Staff/<id> + status meta, Objects/board + hidden Lines, Objects/hiring,
  Objects/coach_<id>, Charts/<id> + Tag rule, Table, Patient + athlete_id, Physio, Doors/floor),
  the click AABBs in `layout_for`, `coach_status`, board/dues/chart positions.
- `CHART_PITCH` 1.15 -> 1.0 (start x 1.6): six charts at the old pitch ran past the 8 m wall.
  Layout and build move together, so the click boxes move with the boards.
- Q225 is NOT merged on master (the task file says it is): the base `TrainingFloor3D.gd` /
  `Office3D.gd` here are pass-1, so the triplanar/PBR helper and the AgX light pass live in each
  of my three room scripts, and the repo's CC0 maps load with their own `_Color/_Roughness/_NormalGL`
  suffixes. Nothing outside my owned paths was touched.
- The worktree had no `.godot` cache: one `--headless --path Godot --import` built it (it rewrote
  ~2.7k unrelated `.import` files; only my own paths are staged).
- `q229_render.gd` sets one fighter sore + held and assigns fighters to coaches (the same calls the
  room tests make) so the stills show each room's story; the game's own reads are untouched.
- Seated/lying clips carry their own offsets: seated mounts stay at 0.0 (pass 1 sank every sitter),
  the mat room's grappler mounts at -0.74 because the lying clip carries C219's table offset.
- The house `RoomFx` light shaft is re-aimed at a real window in each room (mat clerestory, staff
  and physio left-wall windows); with no window it read as a floating translucent slab.
- Wood/cork/leather/concrete/plaster/vinyl/rubber/tatami/photo maps are OURS
  (`Tools/blender_rooms/{mat,staff,physio}_textures.py`, PIL, seeded, colour+rough+GL normal);
  the physio walls reuse the staff plaster with a cool tint. No downloads.

## Gates
- Parse: `check_scripts.py` on MatRoom3D.gd (394 lines), StaffRoom3D.gd (822), PhysioRoom3D.gd (532),
  q229_render.gd (100) - 0 fails. Panels untouched (117/91/83).
- Tests: `run_tests.py --jobs 2 --only mat_room,staff,physio,smoke` - SUITE total=5 fails=0
  (watchdog GREEN before the render and before the suite).
