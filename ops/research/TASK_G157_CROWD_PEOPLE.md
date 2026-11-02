# TASK G157 - V2 CROWD: people in the seats, not boxes (Grok CLI)
Model: Grok CLI default. Owner: Grok (G156 seat, re-tasked S139). Worktree E:/FightCamp/wt/G157, branch
grok/g157-crowd-people (from master).
Operator 2026-10-01 (S138, verbatim): "none of what i saw so far is even close to AAA ... i still see a grey ring".
The audit (`research/S138_AAA_VISUAL_GAP.md`) names the crowd: "crowd = boxes/silhouettes (VenueRig
_crowd_row/_crowd_mass_block)". Route V2: "vertex-animated low-poly people via MultiMesh instead of boxes; DOF on the house."

## What to build
1. A crowd person: ONE low-poly seated human (900-2,500 verts) made from OUR body - the MPFB generator male/female
   (`Godot/assets/models/generator/`, MEN = MPFB, `project_fighter_bodies_in_game`), decimated in Blender 5.2.1
   (`Tools/blender_crowd/*.py`, run headless: `blender -b -P <script>`). Clothing as vertex colour / material slots:
   a shirt band and trousers band so per-instance colour can tint them (no nude crowd).
2. Motion with NO download: in the same Blender script, key 3-4 short loops on the rig yourself (seated idle sway
   2-4 s; clap 1 s; stand-and-cheer arms up 2 s; lean-forward watching), then bake them to a VERTEX ANIMATION TEXTURE
   (positions per frame into an RGBA float/half EXR or PNG16 + bounds; normals optional). Commit the baked texture(s)
   and the mesh as .glb/.res under `Godot/assets/models/crowd/` (keep it light: textures <= 2 MB total).
3. `Godot/assets/shaders/crowd_vat.gdshader`: reads the VAT in vertex(); per instance (INSTANCE_CUSTOM): clip index,
   time offset, speed 0.85-1.15, shirt colour, trouser colour. No two neighbours in lockstep.
4. `Godot/scripts/VenueCrowd.gd` (static, no GameState): `build(seats: PackedVector3Array, yaws, rng_seed, excitement)`
   -> MultiMeshInstance3D chunks (split per stand side so they cull). Excitement 0..1 shifts the clip mix from
   idle/watch toward clap/cheer (expose `set_excitement(node, x)` so the fight can raise it on a knockdown later).
5. Wire it: in `Godot/scripts/VenueRig.gd` (1,699 lines - `sed -n` windows only) every place that seats people today
   calls `_add_seated_silhouette` (5 call sites; `grep -n "_add_seated_silhouette(" Godot/scripts/VenueRig.gd`) and
   `_crowd_row` (line ~1020). Collect the seat positions instead of building box people, then build ONE VenueCrowd per
   venue at the end. Benches/planks stay. `_crowd_mass_block` far blocks: replace with crowd too where a camera can see
   them, else leave. Keep every node name a test reads (grep tests/ for VenueRig node names before renaming anything).
6. Fill: seats in the venue's capacity band, but leave 5-15% empty seats scattered (a real club hall is never full).

## Owned files
New: `Tools/blender_crowd/*`, `Godot/assets/models/crowd/*`, `Godot/assets/shaders/crowd_vat.gdshader`,
`Godot/scripts/VenueCrowd.gd`, `Godot/tests/venue_crowd_test.gd`, `Godot/tools/g157_render.gd`,
`previews/g157/*`, `research/G157_DIGEST.md`.
Edited: `Godot/scripts/VenueRig.gd` (the seating call sites only). NOT ArenaRig.gd (Claude is editing the ring).

## Prior research
`python Tools/prior_research.py crowd vertex animation multimesh`: G107_CROWD_SOURCES.md (the TA recipe: near rows
mid-poly, mid stands GPU-instanced VAT, far rows cards; 4-6 cycles; colour via instance data; chunk for culling;
"identical clones in lockstep is the expensive failure"), topics/camera_broadcast.md, S138_AAA_VISUAL_GAP.md.
The Godot primitive: MultiMesh + INSTANCE_CUSTOM ("Animating thousands of fish" in the Godot docs).

## What would a human do?
A technical artist: one seated mesh, a handful of baked loops, thousands of instances with random phase and colour,
split into chunks, checked from the broadcast camera - then fix whatever reads as clones first.

## Prefab check
G107 lists MIT VAT plugins (antzGames). Downloads need the operator's yes, so do NOT download: the VAT shader is ~40
lines and the Blender bake is one script - write both. Body = our MPFB generator (shippable, ours).

## Test (tier: new scripts + one edit)
1. `python Godot/tools/check_scripts.py <every touched .gd>` first (a parse error hangs a headless test).
2. NEW `Godot/tests/venue_crowd_test.gd`: build two venues (a small club and a large hall - different seat counts);
   assert MultiMeshInstance3D count > 0, instance count within 85-95% of the seats, instance colours not all equal,
   time offsets not all equal; control arm: a venue spec with zero seats builds no crowd. Break one (e.g. all offsets 0)
   and see it fail - say so in the digest.
3. `python Godot/tools/run_tests.py --jobs 2 --only venue,arena,fight_night,smoke`.
4. Stills + a 6 s silent clip from the broadcast camera of 3 venues via
   `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/g157_render.gd`
   -> `previews/g157/` (before/after per venue). OPEN every still; watch the clip frame by frame for
   lockstep and popping. Report fps of the live room with and without the crowd (frame time over 300 frames).
Watchdog before every heavy run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`.

## The one trap
A new .glb/.exr/.png needs `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --import` before a test can
load it. And MultiMesh has no per-instance culling: an unchunked bowl draws every person every frame.

## Finish
git add by explicit path, commit, git push -u origin grok/g157-crowd-people. Never edit HANDOFF.md. Do not stop at written.
