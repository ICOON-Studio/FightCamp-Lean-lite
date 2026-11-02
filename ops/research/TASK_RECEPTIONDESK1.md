# TASK RECEPTIONDESK1 - the operator's reception desk as our own model, placed in the club's reception (S207)
Model: Cursor. Worktree E:\FightCamp\wt\RECEPTIONDESK1, branch cursor/receptiondesk1. Operator S207: "build the reception desk from
my picture" / "delegate it". Reference picture (you cannot see images - the numbers below ARE the picture):
research/refs/reception_desk_operator_S206.png.

## The desk (from the picture)
A long counter, ~2.8 m x 0.70 m. Front = dark horizontal slats (#2b2826 body, #4a4440 slats, ~3 cm pitch). The wood top
(#7a4a32) is STEPPED: a low run on the left (1.00 m), a short slope, a raised run on the right (1.12 m), 3.5 cm front overhang.
A grey band (#5c5f63) runs the full length at 0.36-0.56 m with italic white "RECEPTION" lettering right of centre and a thin white
pinstripe under it. Staff side: a lower work surface at 0.75 m. Flat colours only (gym style sheet: no photo textures).

## CHANGED S207 (operator: "fuck the reception desk just download another one ready from sketch fab")
Do NOT build in Blender. The desk is downloaded and committed: `Godot/assets/models/props/reception/reception_counter.glb`
("Reception Couter" by saqib24, CC BY 4.0, CREDITS.txt beside it; ~2.7 m x 0.3-0.8 m, wood veneer + marble, Sketchfab FBX root).
Ignore the "picture" numbers above except the size/clearance rules; the acceptance length becomes 2.4-3.0 m, height 0.95-1.25 m.

## Spec
2. Place it in the club: `Godot/assets/data/gym_club.json` room "reception" (rect x 6.4-13.6, z 18.0-22.5; street door at (11.3, 22.5),
   gym door at (11.3, 18.0)). Replace the furniture entry id "desk" (kit "desk") with `"glb": "res://assets/models/props/reception/reception_counter.glb"`,
   height 1.12, placed so the FRONT (lettering) faces the customers coming in from the street door and the staff side faces the back
   wall, the whole 2.8 m inside the room with >= 0.9 m walking room in front, and update the room's "desk" rect to the new footprint.
   Keep the "bell" (on: 0) sitting on the counter.
3. The walk-in's stop at the desk and the staff spot behind it must still be valid (grep `walk_in_path`/`desk` in GymClub3D.gd,
   GymClubLayout.gd - read only grep-found windows; GymClub3D.gd is big).

## Owned files
- `Godot/assets/data/gym_club.json` (only the reception room entry)
- `Godot/tests/reception_desk_test.gd` (NEW)

## Acceptance (tier: data + new test)
- NEW `Godot/tests/reception_desk_test.gd`: builds the club (copy how gym_club_3d_test.gd builds it), finds Rooms/reception F_desk:
  its AABB is 2.4-3.0 m long, 0.25-0.9 m deep, 0.95-1.25 m high, fully inside the reception rect, >= 0.9 m clear in front of its
  lettered side, not overlapping any other prop, the bell's base within 2 cm of the counter top. Red on master first (old kit desk is 1.1 m).
- `python Godot/tools/run_tests.py --jobs 1 --only reception_desk,gym_club,club_layout,walk_in,lobby,club_rooms` - nothing green goes red.
- Parse every touched .gd. Godot: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe"` (never _console). No windows, image viewers, browsers.
- Commit + push the branch; print tris, the test lines, and the desk's final position/yaw. Claude takes the game-camera still.

## Prior research
topics/gym_rooms_art.md, M_STYLE_SHEET_S206.md (Maria's palette/rules), LUDO_ROUND42_S207_reply1.txt A2 (the check-in camera frames this desk).
## What would a human do?
A prop artist blocks the desk from the reference in Blender with flat materials, exports glTF, drops it in the room and walks the path.
## Prefab check
Searched ~400 Sketchfab desks + Free3D/CGTrader/TurboSquid in S207 - the operator's desk was not found; building our own.
## The one trap
glTF export flips Blender +Y (front) to Godot -Z: check which way the lettering faces in Godot before choosing the yaw.
