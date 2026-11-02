# S285 - drawn rooms get MGT2 walls and a door step

Operator S285 (on a reception he drew and finished): "this is such a abad design"; "i do not have option to put door , how mgt2 do the walls, do the same".
Ludo (lead designer, fresh chat, still uploaded): `research/ludo_rx/LUDO_S285_WALLS_raw.txt` (4,044 chars, text only). Ask: `ludo_rx/ask_s285_walls.txt`.

## What the stills showed before (game camera, `tools/s285_room_walls_stills.gd -- as_game`)
- `docs/previews/s285_walls_before/12_yaw225.jpg`: hall-facing wall cut to the stub, door frame + leaf standing full height in front of it, leaf swung OUT into the aisle.
- `10_yaw45.jpg`: orange brick wainscot (the old fixed reception's skin) inside a white drawn room; posters/signs of the old rooms at fixed world spots.
- At the normal floor zoom every drawn room's floor, door and furniture was HIDDEN (the old "front block" cull of the data front rooms) - only its walls stood.
- The draft pre-placed a door silently; the DOOR row sat at the bottom of the list.

## Causes found in code
- `ClubRoomBase.build_room`: the old rooms' door hacks (reception `scale.z = -1` + hinge -180) ran on drawn rooms and flipped the leaf outward; `RoomDoor.build` opens every leaf ~100 deg.
- Doors are children of the room, not of the wall: the wall cut never reached them.
- Room modules (`ClubRoomReception/Office/Physio/EquipmentStore._build_shell`) skinned walls and hung dressing at the OLD rooms' world coordinates for any room of that type.
- The iso cut dropped room walls by hall sightline (`_iso_walls_hiding`): it cut a room's BACK wall at yaw 45 (door gone with it) and left a piece over the door floating at 225.
- `_collect_front_block` / `_mark_front_block_walls` treated the shell's street strip as the legacy front block.

## Verdict built (Ludo's numbers inside the MGT2 rules)
- Partitions (shell walls that are not the building's outer wall): 2.60 m, 0.15 m, #ECE7DC both faces, cap 0.06 m #2A2D32 0.015 m proud each side, skirting 0.10 m #1E2024 0.01 m proud. One wall colour for every room type; rooms differ by floor (each module keeps its floor shader only).
- Door: 1.00 m clear for every drawn room, frame 2.20 m outer / 2.10 m opening, 0.17 m deep, #22252A; leaf #C49A6C, handle plate #B0B5BA, CLOSED at rest; the partition continues above the frame; threshold strip 1.00 x 0.17 m #3A352F; door mat 1.0 x 0.6 m #18191B inside; floor edge trim 0.02 m #33373D.
- Cut wall: door frame and leaf hide fully with their wall, the threshold and mat stay (`ClubRoomBase._sync_drawn_doors`); the street sign hides with the cut street wall.
- MGT2 cut rule for partitions: a partition drops exactly when its room's face on that line points at the camera (`partition_faces_camera`); neighbours share one wall line (no duplicate pieces).
- Draft: opens with NO door and the door in hand; free wall edges lit green; the ghost is the door snapped onto the edge (green) or red off it; FINISH says "Place a door" first; the BUILD list starts "1 DOOR", then "2 <ROOM> - FURNITURE".
- The shell has no front block: drawn rooms show at every floor zoom.
- The old "enter room" bronze disc moves onto the door mat for drawn rooms and draws nothing of its own (clicks and the "!" badge stay).

## Not built (follow-ups)
- Ludo: the leaf swings inward 85 deg while a person walks through and springs shut - doors stay closed now (people pass a closed leaf).
- Windows / wall decor items as wall-mounted pieces on free wall segments (MGT2 windows) - no window item exists yet.
- The old fixed rooms (non-shell careers) keep their old doors and skins (control arm).

## Evidence
- Test `Godot/tests/room_walls_mgt2_test.gd`: red on master (17 FAIL + hang), green plain and `-- as_game` (`ROOM_WALLS_MGT2 failures=0`).
- After stills: `docs/previews/s285_walls_after/` (4 yaws + draft + floor zoom).
