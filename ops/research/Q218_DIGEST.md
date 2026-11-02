# Q218 Digest - Staff Room dressed to concept art

## What changed
- `Godot/scripts/StaffRoom3D.gd` - Complete visual overhaul to match `room_staff.jpg` concept art.
  - **Rota board** (replaces whiteboard): Large cork board with "ROTA BOARD" header, COACHES section (left, photo grid with name labels), FIGHTERS section (right, photo grid), red strings connecting coaches to fighters, divider line, unassigned fighters section.
  - **Coach lockers** (new): Row of 4 grey lockers along left wall with name plates (DAVE COACH, SARAH COACH, MIKE CORNER, JASON CORNER), ventilation slots, sports bags on top.
  - **Kitchenette** (expanded): Counter with sink, coffee machine, microwave (box-built), small fridge, mugs, kettle, trash bin.
  - **Meeting table** (rectangular, replaces round): Wooden table ~1.8m x 1.0m with clipboard, papers, mugs, water bottle, rug underneath, desk chairs.
  - **Sofa area** (new): Brown leather sofa with resting coach, coffee table with magazines and water bottle, gym bag on floor.
  - **Candidate at door** (replaces hiring noticeboard): Person on chair holding CV sheet, "COACH WANTED" notice board with week's roster.
  - **Motivational posters** (new): "BETTER COACHES BUILD STRONGER FIGHTERS" and "DISCIPLINE RESPECT EFFORT RESULTS" on right wall.
  - **Window to gym** (new): Left wall window looking onto training floor.
  - **Lighting**: Warm pendant over table, kitchen light, sofa lamp (via `_practicals()`).

## Sources
- Kenney Furniture Kit (CC0): loungeSofa, tableCoffee, kitchenCabinet, kitchenCabinetUpper, kitchenCoffeeMachine, kitchenFridgeSmall, bathroomSink, pottedPlant, coatRackStanding, chairDesk, chair, trashcan
- Blender-made: none (microwave built from boxes)
- Box-built: rota board, lockers, sofa, coffee table, microwave, posters, window, CV sheet, sports bags

## What still differs from concept
- Photos on rota board are colored rectangles (no real images - project rule: never use web images or real people)
- Coach at table appears slightly above chair seat (Kenney chair scale vs rig lift_m mismatch)
- Locker name plates small but readable
- Room is bright but concept shows more dramatic lighting contrast
- Only 1 coach in test data (concept shows 2 at table)

## Tests
- `staff_room_test.gd` - PASS
- `staff_hub_panel_test.gd` - PASS
- Parse gate - PASS (0 fails)

## Render
- `previews/q218/final.png` - game camera view

Co-Authored-By: Qwen Code <noreply@qwen.ai>
