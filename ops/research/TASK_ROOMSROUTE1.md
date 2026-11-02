# TASK ROOMSROUTE1 (S227) - every room route opens the CLUB room Codex built, not the old standalone room panel

Operator (S227, on the UI census stills): "these are not what codex designed so far , the changg room where is it ? the reception ??"

## The defect (read in SceneRouter.gd ~83-96)
The routes `lobby` (THE FRONT DESK), `office_room`, `locker_room`, `staff_room`, `physio`, `film_room`, `mat_room` each open an OLD
standalone panel (LobbyPanel.gd, OfficeRoomPanel.gd, LockerRoomPanel.gd, StaffRoomPanel.gd, PhysioRoomPanel.gd, FilmRoomPanel.gd,
MatRoomPanel.gd). The rooms Codex built and the operator approved - the RECEPTION (ROOMS3A, 9764600f), the LOCKER/changing room
(LOCKER1B), the equipment store (ROOMS3B, landing) - live INSIDE the club (GymClub3D + club_rooms/ClubRoom*.gd) and show only in the
club's room view (`GymClub3D._enter_room(id)`, stills via `tools/club_room_still.gd -- as_game ... room=<id>`). So the menu, the HUD
icons and every route into a room show the old rooms; the new ones are reachable only by clicking a door on the floor.

## Do
1. When the club is on (`GameState.is_gym4_club_on()`, ON in the game), a route to a room that the club has (`gym_club.json` rooms:
   reception, office, physio, equipment_store, locker_room) opens the gym hall WITH that room open (GymHallPanel + hall `_enter_room`),
   mapping lobby->reception, office_room->office, locker_room->locker_room, physio->physio. A room the club does not have yet
   (staff_room, film_room, mat_room) keeps its old panel until the club builds it - list them.
2. The room view's back/door returns where the route came from (router back), not always to the floor.
3. Fix the census capture: `tools/ui_census_stills.gd` captures the club rooms through the same route, so the census shows Codex's rooms.

## Gate
Parse; RED first: a test that routes `lobby` with the club on and asserts the open view is the club's reception (GymClub3D open_room_id
== "reception"), likewise locker_room - red on master today. Focused `run_tests.py --jobs 2 --only club,room,lobby,route`.
Stills: ui_census_stills (lobby, locker_room, office_room, physio) on the PC, opened by Claude; operator OK.

## Owner
Gym floor / rooms owner (cloud Cursor after Codex leaves rotation) - or Claude directly (a router change + one test).

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
(S230: this brief is a screen/room look, not a fight clip - steps 2-3 read as: captures of the game's own screen at 1920x1080
and 1280x720, the defect named in the brief before and after, no fighter bodies other than the MetaHuman cast.)
