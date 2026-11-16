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

(FINISHED in round 3, section 5.) After round 2 only PARTLY fixed: `stills/pair_coach_neck_reverse.jpg`, his own close-up hunched over the rope. The bare hard line is now a
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
(FIXED in round 3, section 5 - and the cause named here was wrong: the head's rim is a smooth line.) After round 2,
teeth were left at the very top of each strap (`stills/pair_strap_top_c06.jpg`, the same before and after). The shoulder's own shape under a raised arm was not touched (MetaHuman corrective
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

## 5. Round 3 (S495, his "fix the skin sliver and dark slit at the front of the coach's collar, and the small steps at the singlet strap tips")

Before = main after PR 320, after = this change; the same film (`corner_film short seed=7`), the same second.

### The coach's collar in his close-up - how the shirt, the rib and the neck skin are weighted

The close-up costs six minutes a look and the workbench could not reproduce its pose, so the film now writes the pose
it showed (`corner_film posedump=<file>`, `tools/bodylook_pose.gd`: every bone after the modifiers ran, and the lens) and
the workbench puts one body in it (`tools/bodylook_still.gd pose=<file>`, the pose kept in `coach_c07_pose.json`): the
fault showed there at once, from six sides, in under a minute (`stills/r3_bench_closeup_pose_before_top_after_bottom.jpg`).

What it showed, three causes:
- THE TORN RIM AND THE DARK SLIT: round 2 gave each shirt vertex near the rim the weights of the skin vertex nearest
  it. Two shirt neighbours took theirs from skin at different heights, and the rib had a third, eased set. In his
  twisted pose the rim tore off the rib in flat shards; the slit was the gap under one of them.
- THE NECK OVER THE RIB: with the rim made whole, the neck skin 2-3 cm above the line (more of the head's weight)
  rolled out over the rib all round the front.
- THE SLIVER OF SKIN: the covered skin that stays drawn under the shirt sat 1 cm inside it; 3-4 cm under the collar the
  shirt and the skin part by more than that in this pose.

Fix (`StaffCollar._field`, `_follow`, `_settle`, `_rib_weights`; `ClothMask.TUCK_DEEPER_M`):
- the skin's weights round the collar are read as a FIELD - one set per slice of angle round the neck (64) and per
  1.5 cm band down the shirt, eased round the ring - and the shirt takes the field, not single vertices;
- the rib takes the field on the rim itself: the very set the rim's own vertices carry;
- the neck's own skin within 8 cm of the line fades into that set too (wholly within 6 mm), so nothing beside the
  collar moves against it - the neck turns higher up, as in a real crew neck;
- the tucked skin goes in like a funnel: each triangle ring 8 mm deeper than the one above.

| the coach, `tests/body_look_test.gd` | now |
|---|---|
| rib against the shirt's rim under it, worst difference on any joint | 0.006 |
| rib against the neck skin beside it | 0.043 |
| head vertices still drawn under the tee | 225 (was 277; 704 as exported) |

Stills: `stills/r3_pair_coach_closeup_c07.jpg` (his close-up: the break, the slit and the sliver -> one whole collar),
`stills/r3_pair_coach_wide_c08.jpg` (the wide shot: a collar that broke at the front -> whole),
`stills/r3_pair_second_wide_c08.jpg` (the second: unchanged, clean).
What you see now and may not like: in that hunched pose the collar's front stands a finger off his neck (it rides
forward with the neck base) - a loose collar, not a tear.

### The steps at the strap tips - mesh

The head mesh's rim is NOT ragged (`tools/bodylook_rim.gd`, `rim.txt`: its vertices sit 0.5 mm off a straight line) - round
2 named the wrong cause. The rim is the kit's own open edge, and on it stand kit triangles; beside each strap some of
them are joined to the singlet by a CORNER only (both other edges on skin): a row of lone teeth.

| lone kit triangles on the neckline | as exported | in the game now |
|---|---|---|
| Lucy (mh_boxer_11) | 6 (3 a shoulder) | 0 |
| Priya (mh_boxer_14) | 2 | 0 |
| Lucy's kit border off a straight line (mean) | 7.0 mm | 2.4 mm (3.1 after round 2) |

Fix (`ClothMask._trim_teeth`): a kit triangle standing on the kit's open rim with both other edges on skin becomes skin.
Stills: `stills/r3_pair_strap_tips_c07.jpg`, `stills/r3_pair_strap_left_zoom_c07.jpg`.
Left: the OUTER edge of a strap, seen edge-on at the shoulder's silhouette, still shows one kink (the same before and
after, in the zoom): the kit border there turns a corner the slide is not allowed to fold.

Also seen, not from this change: the film log prints "Signal 'process_frame' is already connected to ... _settle" 664
times in BOTH arms (scripts/ui/TextScale.gd) - a follow-up.

## Tests
`tests/body_look_test.gd` (22 checks since round 3, its own rulers on both arms) and golden_path, male_bodies, glove_cut,
art_toon_paint, corner_warm, corner_lens, foot_plant, fight_polish, intro_style: all 0 failures (`tests_summary.txt`).
`corner_film` fails one check in BOTH arms and at the old pace too - "the gloves touch in the intro" (0.20 m apart,
needs < 0.12): it predates this change.
