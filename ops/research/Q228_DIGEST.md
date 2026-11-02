# Q228 DIGEST - THE FILM ROOM (K47 spec, room-designer seat)

Built the film room end to end: `Godot/scripts/FilmRoom3D.gd` (K47's 7 x 5 m
cut-away room, every prop in the spec table, coach + two note-takers, three
downlights + window key, screen the brightest object), `FilmRoomPanel.gd`
(one read of the game per rebuild: next booked opponent's name, record, style,
stance, the coach line and the recommended camp focus - the same read
FightCampPanel's scouting line is built from), the `film_room` route, and the
WATCH FILM icon button beside the camp's scouting read (words in the tooltip).
The board, the screen and the laptop lid wear live render textures, so every
word on them is real data; hover draws K47's twelve-edge brass outline plus a
label of at most fourteen characters. The whiteboard stand is the one Blender
prop (`Tools/blender_rooms/film_whiteboard.py` -> `assets/models/rooms/film/`).

Gates: parse gate on all six touched scripts; `tests/film_room_test.gd` green
(two booked fighters on world events 4-8 weeks out with chosen plans/stances,
control arm unbooked, click rays, hover, routes, the camp's WATCH FILM button);
slice `run_tests.py --jobs 2 --only film_room,fight_camp,scene_router,smoke`
= SUITE total=5 fails=0. Mutation check: hard-coding the board's STYLE line to
the wrong plan made the test fail exactly once ("the board carries his style"),
then reverted.

Review loop against `concepts/room_film_k47_a.png`
(`docs/previews/q228/review_before.png` / `review_after.png`, both opened):
SILHOUETTE 3->4, LIGHT 3->4, MATERIAL 3->4, LIFE 3->4, CLARITY 4->4, BAR 2->3.
No row down; the two lowest (BAR, then LIGHT/LIFE) up by 1. Before: the screen
and window blew to white, the sofa read grey, the note-takers sank to heads and
the shelf fell out of frame. After: the lit screen frame is the key, black
leather, walnut, slate carpet, both torsos over notebooks, the laser dot on the
paused footage.

Findings for whoever tunes it next:
- Board offers (`local_*` / `regional_*` / `featured_*`) carry no due week, so
  `get_booked_fight_due_week` returns the current week and the camp read says
  "THE FIGHT IS THIS WEEK" - a camp-shaped booking only exists through
  `event|`, `amateur|` or `gp|` ids. The test and the render therefore use
  fight_camp_test's fixture (a world event 4-8 weeks out). The room degrades
  honestly either way: name, record and stance still print, style says
  "STILL TO BE READ".
- A generated opponent's natural plan can be `balanced`, which has no
  archetype and therefore no coach line; the board then says the file is thin.
- The coach wears the house bare-hand rig (no tracksuit mesh exists); the cap
  and the laser are dressing on top of it. The screen's two fighters are
  colour rects, not painted men - that is what holds BAR at 3.
- `tests/scene_router_test.gd` holds the route registry as an explicit contract
  (43 ids); adding `film_room` makes it 44, so the contract line grew by one.
  That is the only file I touched outside the task's owned list.
