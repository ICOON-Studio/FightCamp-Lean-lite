# BODYLOOK1 - the bodies look stitched (his S490 play notes)

Operator, after the S490 build: corner coach "terrible neck blending"; fighters "their shoulders look weird and their
walking too"; "sometimes you can see through them (they seem like arts poorly stitched together)".

Every picture here is from the game's own cameras on the never-shown desktop (`tools/corner_film.gd short seed=7`,
`tools/fight3d_play.gd seed=7`), the before arm from the same build with `nobodylook nowalkpure`. `stills/bench_*` are
workbench close-ups (rest pose and a 30 degree head lean), used to tune the collar. Numbers: `probes.txt`, `walk.txt`,
`walk_after.txt`, `walk_layers.txt` (printed by `tools/bodylook_*.gd`).

## 1. Coach: neck and torn collars - mesh layer (the mesh, and how the tee is skinned)

| | as exported | in the game now |
|---|---|---|
| head-mesh vertices lying under the tee (coach) | 704 | 277 (the ring tucked inside the collar) |
| ... of those within 3 mm of the shirt | 42 | 1 |
| body-skin vertices under tee and shorts (coach) | 262 | 104 |
| collar band on the tee | none | a rib round the shirt's rim |
| weight of the tee's collar band on the head and neck joints | 0.00 | 0.30 (the neck skin inside it: 0.32) |

Three causes, each measured:
- the MetaHuman head mesh runs down the neck onto the collarbones, so on a staff body it lies inside the Creator tee
  (42 vertices within 3 mm of it) and pokes through the collar in patches when he moves;
- the tee has no collar band, so neck meets shirt in one bare line;
- the tee's collar band carries NO head or neck weight (`tools/bodylook_skin.gd`: spine_04 0.40, shoulders and
  clavicles the rest) while the neck skin inside it carries Head 0.32 - when the corner's "look at her" turns his neck
  (CornerIK, up to 65 degrees shared down the spine) the neck leaves the collar and crosses the shirt.
Material flags were not a cause (cull, transparency and depth draw per surface are in `probe_before.txt`: skin and
shirts are opaque, back faces culled).

Fix (`scripts/fight3d/ClothMask.gd`, `StaffCollar.gd`, called once in `MHRig.load_fighter`): skin triangles wholly
under the outfit are dropped, the ring that stays drawn sits 1 cm inside the collar, a rib is built round the shirt's
rim wearing its material (every shirt recolour paints it), and the shirt within 6 cm of the rim takes the weights of
the skin it sits round (all meshes of a body share one Skin), so collar and neck move together.

Stills: `stills/pair_collars_c02.jpg` (torn collars -> clean, with a rib), `stills/pair_corner_wide_c08.jpg`,
`stills/bench_coach_lean30_exported_top_fixed_bottom.jpg`, `stills/pair_coach_neck_reverse.jpg`.

PARTLY fixed: `stills/pair_coach_neck_reverse.jpg`, his own close-up hunched over the rope. The bare hard line is now a
collar band - but the band shows one break at the front and a sliver of skin under it. Clean at rest and under a head
lean on the bench. To finish it: the staff bodies re-exported from the Creator in a tee with a real collar.

## 2. Fighters: "stitched" singlet, weird shoulders - mesh layer

| | as exported | in the game now |
|---|---|---|
| singlet/skin border, mean distance off a straight line (Lucy) | 7.0 mm | 3.1 mm |
| worst tooth (Lucy / Priya) | 22 / 34 mm | 12 / 13 mm |
| the men (body 01) | 4.5 mm | 0.9 mm |

Cause: the kit is the body's own triangles painted another colour, so the border between skin and singlet runs along
triangle edges - a staircase round each arm hole. Fix (`ClothMask._smooth_edges`): the border's vertices slide onto a
smooth line (Taubin smoothing, every copy of a vertex alike, no triangle folds; a vertex ON the kit's open rim - the
body's neck hole under the head's arc - stays put, or the hole shows as a dark line at the strap's top).

Not a cause (checked, 148 of 148 on Lucy): the kit's vertices sit exactly on their skin twins with the same bone
weights. Ziva's probe read "48 of 108 weighted differently" because it compared the singlet with the HEAD mesh, whose
bottom ring lies on the singlet by design (the head's arc is the neckline; the 48 sit at 1.32-1.37 m, the head's rim).

Stills: `stills/pair_lucy_singlet_c075.jpg`, `stills/pair_round1_open.jpg`, `stills/pair_corner_wide_c08.jpg`.
Left: teeth at the very top of each strap (`stills/pair_strap_top_c06.jpg`, the same before and after): there the edge
is the HEAD mesh's ragged rim crossing the strap, not the kit border. The shoulder's own shape under a raised arm was not touched (MetaHuman corrective
joints are not driven here; that is a rig job, not a mesh fix).

## 3. "You can see through them" - mesh layer

Cause: bodies mh_boxer_14 (Priya Nair) and mh_boxer_23 carry islands of 2-6 skin triangles inside the trunks at the
hips: a skin-coloured hole in the shorts, seen in every round. No other body has one (`islands_before.txt`); no holes,
no flipped faces (`wind_before.txt`: 4-35 creased triangles a body, in folds). Fix (`ClothMask._fill_islands`): a small
skin island that borders cloth becomes that cloth.

Stills: `stills/pair_round1_open.jpg` (round 1 opens, both in guard), `stills/pair_round2_mid.jpg` (mid exchange).

## 4. "Their walking" - motion layer

The corner-to-centre walk is the captured `ow_walk` clip (CMU 07_01), in a scene (FloorStand and FootLock let go there).

| the walk as the scenes play it | before | now | a person |
|---|---|---|---|
| steps a minute | 68 | 96 | 100-115 |
| speed | 0.95 m/s | 1.34 m/s | 1.3-1.4 |
| knees folding in, worst | 3.4 cm | 1.4 cm | ~0 |
| standing foot over the canvas | 2.5-9 cm | 1.8-5 cm (the take's own heel lift) | heel lift only |

(`walk_layers.txt` is the same walk OUTSIDE a scene, one leg layer off at a time: there FloorStand drops her hips 4.8 cm
and FootLock adds 10 degrees of knee bend - a walk must never be played outside a scene with those two on.)

Causes: (a) the clip was played at 0.6x, a slow-motion walk (`CornerCrew.OW_WALK_RATE` -> 0.85); (b) FootPlant, built
for a planted fighting stance, stayed on under a captured walk and folded her knees in (`WalkPure.gd`: it fades out
while the walk clip plays, as RkPure does for the rk_ takes). Feet never crossed (ankles 6-9 cm apart throughout).

Left, both in the baked clip itself: the trunk leans 3-4 degrees BACK (a person leans 2-6 forward) and the standing
foot never comes closer than ~2 cm to the canvas. Both need the clip re-baked from its take (tools/walk_cycle.gd).
A still cannot show pace: `stills/pair_walk_in_i04.jpg` is the same film second, the boxers further on.

## Tests
`tests/body_look_test.gd` (new, 18 checks, its own rulers on both arms) and golden_path, male_bodies, glove_cut,
art_toon_paint, corner_warm, corner_lens, foot_plant, fight_polish, intro_style: all 0 failures (`tests_summary.txt`).
`corner_film` fails one check in BOTH arms and at the old pace too - "the gloves touch in the intro" (0.20 m apart,
needs < 0.12): it predates this change.
