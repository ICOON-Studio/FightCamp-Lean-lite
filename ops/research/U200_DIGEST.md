# U200 DIGEST - the locker room dressed to its concept (Cursor)

Compared every pass against `docs/previews/locker_target/locker_target_concept.jpg`. 6 render passes
in `docs/previews/u200/pass1..6.png`, `final.png` = pass6. Only `Godot/scripts/LockerRoom3D.gd` touched.

## What changed
- Weigh-in pair at the scale (a fighter + `COACH_MODEL` coach with a clipboard, `CALM_IDLE_CLIP`), a
  hand-wrap pair on the bench (fighter + cornerman, `SEATED_IDLE_CLIP` - reused D62's "zero the standing
  lift" fix or they floated above the seat). Big glowing LED-style kg readout now lives on the scale
  itself, not just on its floating tag.
- Two glove racks (own primitives: rail/pole + boxing-glove cuff+fist), a laundry bin, loose kit bags at
  the bench, a slatted (not solid) bench seat, a free-standing towel stand by the shower, a plain-
  typography WEIGHT CLASSES poster over the wash mirror, a small TRAIN HARD poster by the door. All
  built from primitives (`_box`/`_cyl`/`_sphere`) like the room's existing scale/board - no GLBs, no
  Blender, no downloads.
- 3 brighter cool-white practicals (locker bank / bench / wash) for the concept's fluorescent-bright
  wet room. Camera widened (fov 50->58, pulled back) - the old frame cropped the shower/rack corner.

## Sources
Every new prop is hand-built GDScript primitives (ours, CC0-equivalent, no asset files added).
No Kenney/Tripo models added or changed; `Wash/Shower`, `Wash/SpareKit` kits reused, just relocated.

## Fixes mid-pass (read the render, not just the code)
- Weight-classes poster/mirror were hidden behind the door's open-swing arc at z~3.5-4.9 - moved to
  z=1.3. The scale readout was hidden behind the weigher's head - raised the column and panel above it.
  A second glove stand kept landing behind people's silhouettes from this camera's diagonal - moved
  twice, finally to (6.35,0,3.75), clear of the bench/scale/weigher boxes.

## Still unlike the concept
Single locker row (concept's two); mirror reads as a plain pale panel, not clearly reflective; the
coach's clipboard is small enough to nearly disappear at this render's distance; towel stand is
partly behind the shower from this angle. `locker_room_test` 0 failures, parse clean, no SCRIPT ERROR.
