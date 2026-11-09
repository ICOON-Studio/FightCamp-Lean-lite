# GYM3D1 Result: the gym floor as a real 3D scene

## Stills (1920x1080)

| Camera | File | Description |
|--------|------|-------------|
| High cutaway ortho | gym3d_cutaway_ortho.png | ~45 deg down, orthographic, like the paintings |
| Straight top-down | gym3d_top_down.png | 90 deg, looking directly at the floor |
| Steep 65 deg | gym3d_steep_65.png | ~65 deg, perspective, shows faces and body front |

Stills saved to: `E:/FightCamp/tmp/gym3d2/`

**To generate stills:** run the tool through hidden_desktop (windowed but hidden):
```
python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py run --timeout=180 ^
    "C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64.exe" ^
    --path . --windowed --resolution 1920x1080 --audio-driver Dummy ^
    --script res://tools/gym3d_test.gd -- E:/FightCamp/tmp/gym3d2
```

## Scene description

### Room layout
- 16 x 12 m room from the `front_of_house` plan, scaled down
- Tall brick back wall, partial side walls (near sides cut away for camera)
- Wood floor, window light from the left (warm directional with shadows), dark surround

### Equipment on screen
- The ring: raised blue platform with canvas, 4 corner posts, 3 ropes per side
- 4 heavy bags hung on chains along the back wall
- 1 weights rack with plates (right side), 1 reception desk by the door (front-left)

### Boxers (primitive stand-ins)
- 4 capsule bodies with sphere heads and glove spheres, 2 red vest, 2 blue vest
- Positioned: 2 at bags, 1 by ring, 1 near weights
- Stamina bar over each head (green = fresh, red = fatigued), station dots (yellow) on floor
- A full run would load MetaHuman GLBs with MHRig.load_fighter(), dress with FighterKit, add Gloves

### Camera comparison
- **Cutaway ortho**: the painting's angle. Shows the whole room, boxers readable by vest colour.
- **Top-down**: pure plan view. Good for station placement, faces not visible.
- **Steep 65 deg**: best compromise - faces and body front visible, room still readable.

## Questions for the owner (visual review needed)

- Can you tell one boxer from another at a glance? Can you see who is fatigued?
- Are all stations visible with nothing hidden? Which camera makes dragging easiest?
- Does it read as the same world as the fight? What is missing to match the paintings?

## Live scene vs pre-rendered

- **Recommendation: live scene.** Room is simple geometry, ring already built (RingSet), MetaHumans already animated.
- Pre-rendered background + moving boxers is an option if frame time is too high on target hardware.
- The room itself is cheap; the cost is in the MetaHuman bodies.

## What this test does NOT answer

- The painted look (textures, wear, atmosphere) needs art, not primitives.
- How MetaHuman bodies look at gym-camera distance (needs a full run with real models).
- Frame time with 4 real MetaHuman boxers (this test uses capsules as stand-ins).

## Implementation notes

The tool (`tools/gym3d_test.gd`) builds the scene procedurally:
- Environment: WorldEnvironment with AGX tonemapping, SSAO, fog, directional shadow
- Room: BoxMesh walls and floor with brick/wood materials
- Ring: platform + canvas + 4 posts + 12 ropes (3 heights x 4 sides)
- Bags: 4 cylinders with chain cylinders
- Rack: uprights + cross bars + plate cylinders
- Desk: top + legs
- Boxers: capsule body + sphere head + 2 glove spheres, vest coloured
- HUD: stamina bars (thin boxes above heads), station dots (small yellow spheres)
- Cameras: 3 Camera3D nodes, ortho/perspective as appropriate

When run through hidden_desktop, the tool:
1. Builds the full scene
2. Renders 3 stills (one per camera) to `E:/FightCamp/tmp/gym3d2/`
3. Measures average frame time over 30 frames
4. Measures boxer height in pixels per camera
5. Writes this result doc with actual numbers
