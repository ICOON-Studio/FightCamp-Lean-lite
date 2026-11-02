# G157 — VAT crowd people

One clothed low-poly sitter replaces the box spectators. Each venue builds a single `VenueCrowd` at the end of `VenueRig.build`. Benches and planks stay. The old mass block is still defined and still has no call site, so nothing camera-visible was left as a solid box.

## Mesh and loops

Source is `Godot/assets/models/generator/mpfb_male_pilot.glb`, decimated in Blender 5.2.1 (`C:/Tools/Blender/blender-5.2.1-windows-x64/blender.exe`) to 1874 verts. Clothing is a UV2 id: 0 skin, 1 shirt, 2 trousers, 3 hair, 4 shoe. The shirt and trouser colours are two RGB565 values packed into `INSTANCE_CUSTOM.a`.

The first bake was a straddle. A single-axis search on this MPFB rig abducts the thighs because the bone roll is diagonal, and rotating a pose bone with `rot @ matrix` spins it around the armature origin. The bake now drops the hips with a two-axis solve, aims each bone about its own head, and rejects a sit unless the thighs point forward, the knees stay narrow, and the feet land under the knees. The committed previews are that chair sit: idle hands on the thighs, clap meeting at the chest, cheer standing with both arms overhead, watch leaning toward the ring. Cheer feet stay a little pointed. That reads fine at crowd distance.

VAT is an RGBA half EXR, 1874 columns by 80 rows at 10 fps. RGB is `(position - bounds_min) / bounds_size`. Alpha is `(frame + 0.5) / frames` so the loader can flip a bottom-up image. Clips: idle 0/30 (3 s), clap 30/10 (1 s), cheer 40/20 (2 s), watch 60/20 (2 s). `crowd_person.glb` is 93,828 bytes and `crowd_vat.exr` is 246,903 bytes, 340,731 bytes together.

## Import

Godot 4.7.2 headless `--import` left these settings in place:

- `crowd_person.glb`: `meshes/generate_lods=false`, `meshes/create_shadow_meshes=false`, `meshes/force_disable_compression=true`, `meshes/ensure_tangents=false`, `meshes/light_baking=0` (static lightmaps would overwrite the UV2 clothing id), `animation/import=false`.
- `crowd_vat.exr`: `compress/mode=3` (VRAM uncompressed), `compress/hdr_compression=0`, `mipmaps/generate=false`, `process/fix_alpha_border=false`, `detect_3d/compress_to=0`.

Runtime does not use the imported EXR. `VenueCrowd` loads the file with `Image.load_from_file` and flips Y when the top alpha is higher than the bottom.

## Crowd

`VenueRig` seating sites still create the named empty nodes the tests look for, and they record a seat. `side_bank` keeps the plank and does not seat anyone, because those planks sit on the bleachers. `_finish_crowd` trims to capacity with a scattered drop, then builds one crowd. Fill measured 37/39 (0.949) in paper hall and 2500/2640 (0.947) in limehouse. Chunks split by stand side, and again at 500, so an off-camera bank can cull. Yaw is `atan2(-x, -z)` so local +Z faces the ring. Phase is a golden-ratio offset; neighbours closer than 0.08 get pushed. Speed is 0.85–1.15. Ten shirt colours, and the same shirt is not repeated on the next person.

Headless Godot’s dummy renderer ignores `set_instance_color` and `set_instance_custom_data` and the getters return black. The instance data is written into the MultiMesh buffer (3×4 transform, then colour, then custom data, stride 20), which both the dummy server and Forward+ keep. The test reads that buffer.

## Tests

`python Godot/tools/check_scripts.py` on `VenueCrowd.gd`, `VenueRig.gd`, `venue_crowd_test.gd`, and `g157_render.gd`: `CHECK total=4 fails=0`.

`G157_LOCKSTEP=1` forces every phase to 0 and every speed to 1. That run failed on purpose: `paper hall time offsets are not all equal (1)` and the same line for limehouse, `VENUE_CROWD_TEST fails=2`, exit 1. Colours, the speed range, both excitement bands, and the empty-capacity case still passed, so the failure was the lockstep and not a collapsed crowd.

Without that env var the same test passed: `fails=0`, 10 shirt colours, 37 distinct phases in the club and 2229 in the hall, excitement 0 only idle/watch, excitement 1 only clap/cheer, capacity 0 builds no meshes.

`python Godot/tools/run_tests.py --jobs 2 --only venue,arena,fight_night,smoke`: `SUITE total=10 fails=0`.

## Stills

`pass=before` was not re-run. Those three PNGs are the box crowd and their timestamps are earlier than the after pass. `pass=after` (excitement 0.62, seed 157) wrote the three after stills and a 60-frame silent clip per venue under `previews/g157/`.

Paper hall: the blocks on the benches are now seated people in different shirts. Near-side rows show their backs, which is them facing the ring. Across the clip, one person cheers while the neighbour stays in their lap, and they do not hit the arms-up pose together. Frame-to-frame pixel change on that clip stays in a narrow band (hot pixels about 350–790 on a 4-pixel grid). There is no frame where the mesh jumps to another shape.

Iron Parish: the flat grey heads along the back wall are now rows of people on the benches, mixed colours, some arms up and some down in the same frame. A cheering back row overlaps the rope line from this camera because the body rises off the seat.

Limehouse: the coloured cubes are a seated bowl. The front rows show gaps, different shirts, and only some arms in the air. The same body is obvious up close, and a near-camera cheer fills the foreground with an arm. At the back they read as a crowd, not as one animation.

The bench is 300 `process_frame` calls, so it sits on the display refresh. Printed frame times:

| venue | with crowd | without crowd |
| --- | --- | --- |
| paper_hall | 16.560 ms (60.4 fps) | 16.666 ms (60.0 fps) |
| iron_parish | 16.561 ms (60.4 fps) | 16.666 ms (60.0 fps) |
| limehouse_bowl | 16.584 ms (60.3 fps) | 16.666 ms (60.0 fps) |

2500 people did not push the room off 60 fps on this GPU. The with-crowd number being a tenth of a millisecond under the vsync quantum is timer noise, not a speedup.
