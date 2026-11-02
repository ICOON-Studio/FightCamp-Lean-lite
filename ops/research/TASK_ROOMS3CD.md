# TASK ROOMS3CD (S234) - finish the OFFICE and the PHYSIO room to the store's standard (ROOMS3, rooms 3 + 4 of 4)

Operator S234 (verbatim): "assign both rooms to codex and nothing else" (after "The rooms need changes"). Codex holds THIS task only.
Model: Codex gpt-6-astra, reasoning high. PC seat (GPU for stills). Worktree E:/FightCamp/wt/ROOMS3CD (seeded), branch codex/rooms3cd
from origin/master. Never master. New features ship ON (CLAUDE.md s10). Credits APPROVED (Q-S225-4 "Yes, build all 4 rooms (26 models,
about 104 Ludo credits)"); this run may spend at most LUDO_MAX_CREDITS=25 on regenerating a prop that fails the D rules.

## What is already there (S234, master c945879d) - start from it, do not redo it
- 13 Ludo models generated from r65's C prompts: `Godot/assets/models/club/office/` (manager desk, swivel chair, coaching desk, TV tape
  cart, credenza, safe, filing cabinet) and `Godot/assets/models/club/physio/` (treatment table, infrared lamp, skeleton on stand -
  regenerated once, stool + bin, ice tub, supply cabinet), each with provenance.json.
- Placed in `Godot/assets/data/gym_club.json` rooms.office (rect x 0..6.4, z 18..22.5; hall door x 5.9 on z 18; corridor door on the
  west wall x 0, z 18.2..19.2; hall window x 0.4..5.2) and rooms.physio (rect x 13.6..17.2, z 18..22.5; hall door x 15.4).
  Three models face backwards out of image-to-3D: filing_cabinet, safe, first_aid carry yaw 180 to show their fronts.
- `Godot/scripts/club_rooms/ClubRoomOffice.gd` / `ClubRoomPhysio.gd`: click targets (office desk/safe -> finances, filing cabinet ->
  contracts, tape cart -> film_room, coaching desk -> staff; physio table/tub/lamp -> physio) + ONE omni light + a reflection probe
  each. This is the bare minimum - the store (`ClubRoomEquipmentStore.gd`) and reception (`ClubRoomReception.gd`) are the bar.
- `Godot/tests/rooms_office_physio_test.gd` (104 checks: real meshes, inside walls, no overlaps, 0.9 m door path, camera frames every
  prop, click routes) - keep it green and EXTEND it.
- Today's stills: `previews/s234_rooms/office/02_office.jpg`, `.../physio/02_physio.jpg` - OPEN THEM FIRST.

## Do (one change per commit, push every commit)
1. READ Ludo's whole room spec for both rooms: `research/LUDO_ROUND65_REPLY_S226.txt` (office: A props, B layout, C prompts, D
   rejection rules, E shell/lights/signs) and `LUDO_ROUND65B_REPLY_S226.txt` (physio A-E), plus the verdict
   `LUDO_ROUND65_VERDICT_S226.md` (wins over Ludo: door positions, 1.2x clearances, nothing on the z=18 hall wall, existing routes only).
2. SHELL per Ludo E, the store/reception way: inside wall finishes (skin only the inside faces, never the hall wall), floor material,
   the signs/plaques Ludo names, Ludo's light count / colour temperature / placement (pendants or the banker lamp glow in the office,
   cool clinical light in the physio), each bounded to its room (own light layer: office 1<<16, physio 1<<19 - reception uses 18,
   store 17), no bleed through the office's hall window onto the floor, the visitor-lighting refresh the store has.
3. LAYOUT polish against Ludo B at 1.2x on the LOADED meshes: the room should read as Ludo's room from the game's room camera - the
   manager's desk the hero, nothing hidden behind another prop, the room's floor name tag not under furniture, wall-mounted frames/belts
   per Ludo. Keep every rooms_office_physio_test check green.
4. Any prop that fails Ludo's D rules on the room camera: regenerate it ONCE with the ludo CLI (image create 3d -> model create prop,
   1024 pbr, ~6000 faces) into E:/FightCamp/tmp/rooms3cd/, update its provenance.json (rejected_attempts). The infrared lamp's bulb came
   out cream instead of ruby red - tint its material in-engine or regenerate.
5. The room-view HUD notes from the verdict item 6 if still open (info text backing plate, back chevron over the name).

## Gate
- Parse: `python Godot/tools/check_scripts.py <touched .gd>`.
- RED first: add checks to rooms_office_physio_test.gd for what step 2 adds (lights bounded to the room layer, signs present, no prop
  inside another on the loaded meshes) and paste them red on master.
- `python Godot/tools/run_tests.py --jobs 2 --only rooms_office_physio,club_rooms_split,gym_club_3d,gym_club_layout,office_room,reception_desk,equipment_store,locker_room`
  (`--jobs 1` unless the watchdog is GREEN). NEVER a bare `--only room` - it also catches the long fight_room_* tests.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md, room form)
Stills ONLY via `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --resolution 1920x1080
--script tools/club_room_still.gd -- as_game gym3d_main gym4_club room=office|physio out=docs/previews/rooms3cd/<before|after>_<room>`.
Before (master) and after for both rooms; per still write: what is in frame, any prop clipping a wall / another prop / floating, the
walking path from the door, dark zones, the HUD block. Post with `python Tools/review_add.py --stage S234 ...`. Never call it accepted:
Claude opens every still, the operator closes it.

## Rules
godot_hidden.ps1 only, watchdog (`Tools\pc_watchdog.ps1 -Once`) before every Godot run (RED = wait), explicit `git add -- <files>`, no
*.import churn, never open an image or a window on screen. Fetch master before each commit touching gym_club.json or club scripts
(Claude may commit floor work on master meanwhile) and keep both sides. End: `research/ROOMS3CD_DIGEST.md` + an
AgentComms/messages note to Claude.

## Prior research
LUDO_ROUND65_* (spec, B/C replies, verdict), TASK_ROOMS3A/3B.md, ROOMS3A/3B_DIGEST.md, LOCKER1B_DIGEST.md, M_STYLE_SHEET_S206.md.

## What would a human do?
Stand in the doorway with the player's camera, compare the room to Ludo's description line by line, light it like the store, then fix
what the camera shows.

## Prefab check
The props ARE the prefabs (Ludo, approved style and credits); nothing to buy.

## The one trap
The office has a WINDOW onto the hall (x 0.4..5.2 on z 18): its lights must not spill onto the gym floor, and nothing tall may block
the window line from the floor camera. Measure on loaded meshes, never on Ludo's table.
