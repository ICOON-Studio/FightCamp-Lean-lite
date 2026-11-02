# S105-S110 DIGEST - the gym's rooms, one session each (2026-09-27)

Owner: claude. Operator: "can you finish each room with one session per room?" -> office, locker room, lobby, mat room,
staff room, physio; each greenlit in turn ("keep going with ... next"). Built in one sitting while Qwen (Q206) and Cursor
(U191) held both shell slots; the tests waited for the operator's one-off OK and then ran together.

## Gate
`run_tests.py --jobs 1 --only office_room,locker_room,mat_room,staff_room,physio_room,front_door,training_floor_3d,
scene_router,gym_wing,fight_result_panel`: first run total=10 fails=1 (scene_router pinned 37 routes; the rooms add 5 -
contract list extended, named) -> total=10 fails=0. Nightly still 2026-09-27 at 40bec39e, 24 fails (pre-re-pins).

## Prefab
Kenney Furniture Kit 2.0 (CC0, kenney.nl; operator OK'd the download). Zip on D:/FightCamp/downloads/kenney_furniture_kit;
the pieces used copied to Godot/assets/models/props/kenney (+ licence, .gdignore; build_playable ships raw .glb). Loader
`_kit()` in TrainingFloor3D (one scale from the desk's height; pieces face +z, probed); greybox fallback with models off.

## Rooms (each: route, the floor door repointed, a test, a render in docs/previews/s1xx/, a Dola fresh-eyes task)
- S105 OFFICE (`office_room`, Office3D/OfficeRoomPanel): books->finances, phone->promotions tab, cabinet->contracts,
  calendar->schedule, photo wall->former fighters. D53.
- S106 LOCKER ROOM (`locker_room`): a named locker per fighter in a full members' bank (click = his card), kit bag +
  FIGHT WEEK tag for a booked man, fight-week board, scale (weight vs class limit). D54.
- S107 LOBBY finished: waiting area, lobby TV, plants, doormat; trials sign hung on wires at 2.1 m; desk card line split. D55.
- S108 MAT ROOM (`mat_room`): the members' evening class (~20% of members, G88), coach (staff), dues board (finance);
  EVENING SLOT card flips the fight team's slot via set_team_slot. D56.
- S109 STAFF ROOM (`staff_room`): coaches with load/capacity from coach_id (click = his staff card), who-coaches-whom
  board (unassigned shown under the head coach's corner - _corner_coach_id's rule; first draft wrongly said NO COACH),
  COACH WANTED board. D57.
- S110 PHYSIO (`physio`): a body chart per fighter off get_body_read (weakest band, value, hold; click = BODY LAB), the
  worst-shape fighter at the table. D58.

## Open
Dola D52-D58 to collect and apply (one change each). Known: lobby trials sign still grazes the honours captions (D55
asks); physio patient stands in a fight guard (D58 asks). Q206 relaunched run and U191 still in flight; C218/Q207 wait
for a slot.
