# VENUES2 - the Marpa "Boxing Arena - Game Level" as the boxing hall

Status: delivered on branch `claude/venues2` (worktree `E:/FightCamp/wt/VENUES2`), NOT merged. Default OFF: boxing
draws the new hall only under the existing `venue_art` switch; MMA (and every other discipline) keeps the C205 cage
hall route exactly; the OFF arm is ArenaRig's own ring, untouched.

## Source

- `%APPDATA%\Unity\Asset Store-5.x\Marpa Studio\3D ModelsEnvironments\Boxing Arena - Game Level.unitypackage`,
  491.4 MB, SHA-256 `7472f679fe57f679e217525837e6c2e1da9ac8abb402e86f71a547a9535ceb5f`. The brief printed this hash
  with its last hex digit missing (63 chars); the file's full hash is the brief's string plus `f`.
- Built-in content only: `Assets/MarpaStudio/HDRP/BoxingArenaHDRP.unitypackage` and
  `Assets/MarpaStudio/URP/BoxingArenaURP.unitypackage` are nested packages, skipped by the extractor's suffix filter.
- Extracted: 40 FBX, 38 materials, 40 prefabs, 179 PNG, one scene (`DemoScene.unity`, the same scene GUID as the MMA
  pack). 1,243 prefab instances + 6 built-in 10 m Plane tiles. Scratch `.venues2_source/` (153 MB, gitignored).

## Pipeline (assets/venues/boxing_arena/build/, adapted from mma_arena/build/)

Same five steps as C205 plus `write_receipt.py` and the read-only `probe_ring.gd`. Three package-forced changes:
1. Nested prefabs: 24 LampTunnel lamps are parented to the two EntranceStage instances through stripped Transforms;
   `decode_unity.py` resolves a stripped Transform to its prefab instance's transform (unknown parents: none).
2. `Floor.mat` names five map GUIDs the package does not ship. Nothing uses that material (the hall floor uses
   `Ground.mat`); the decoder skips absent maps and prints them.
3. Ring pieces go under `Ring`: RingFloor, RingPillarsBase (4 posts), Rope (3), Corner (4 pads), Banner (the
   platform skirt), Hook (12 turnbuckles), Stairs (ring steps) - found by `probe_ring.gd` from world bounds.

Output: 40 meshes, 38 StandardMaterial3D, 109 PortableCompressedTexture2D (lossless, mipmapped; 2K on RingFloor,
Ground, Walls, 1K otherwise), `boxing_arena.tscn`. `receipt.json`: 188 files, 46,465,863 bytes, each with SHA-256.

## Raw geometry (source frame)

Hall floor top -2.230 m. RingFloor slab 7.000 x 7.000 m, top -1.221 m, so the pack's deck is 1.009 m above its floor.
Rope square outer span 6.146 m; three ropes. Posts stand on the floor at the slab corners. Steps on one side.

## Fit (MarpaArena.fit_ring) - measured beside spec

The hall is translated only (floor to ground, rope-square centre to origin; never scaled). The ring is fitted:
rope square outer span = contest, RingFloor = contest + 2 apron, canvas top = `ArenaRig.surface_y`. Deck riders
(canvas, ropes, pads, turnbuckles) keep their heights above the canvas; posts and skirt keep their base on the ground
and stretch to the new deck; steps move out with the apron edge and stretch to the deck.

```
VENUES2 ring fit: rope span=6.705600 x 6.705600 m / spec contest 6.705600; canvas+apron=7.620000 x 7.620000 m /
spec 7.620000; deck=1.270000 / spec surface_y 1.270000; source rope=6.1460 floor=7.0000 deck=1.0092;
rope heights above deck [0.53, 0.928, 1.332] (spec [0.4572, 0.762, 1.0668, 1.3716])
```

Live room (seed 5150, boxing, broadcast): `VENUES2 LIVE hall=boxing_arena deck=1.2700 contest_half=3.3528
engine_half=3.0528` - identical to the OFF run (`hall=c205_or_off deck=1.2700 contest_half=3.3528 engine_half=3.0528`).
The hall does not move the fight: contest, deck and spawns come from the spec (root metadata is the spec's).

Routing: `MarpaArena.build(spec, discipline = "")` - a ring spec with discipline in `BOXING_HALL_DISCIPLINES`
(["boxing"]) takes the boxing hall; all else is the C205 code path unchanged. One line in
`FightWorldLiveScreen.gd` (the existing `venue_art` branch) now passes `_discipline`. WalkoutShot still calls
`build(spec)` (MMA only) and is unaffected.

## Tests

- New `tests/venue_boxing_hall_test.gd` (reads transformed mesh vertices, not the fit's metadata): `checks=45
  failures=0`. Rope walls 0-3 error 0.000000 m; canvas+apron walls error 0.000000 m; canvas top error 0.000000 m;
  posts bottom -0.014, skirt 0.010, steps 0.049 m; hall floor at ground; hall unscaled; no hall piece inside the
  ring footprint; kickboxing / MMA / no-discipline keep the C205 route; a cage spec never takes the boxing hall.
- Mutants (production file restored byte-identical after): `lift := 0.0` -> 3 failures (canvas top, steps, skirt);
  rope ratio x1.03 -> 4 failures (each rope wall).
- Parse gate: MarpaArena, FightWorldLiveScreen, the test, build_arena, probe_ring, capture tool - all `fails=0`.
- `python Godot/tools/run_tests.py --only arena,venue,marpa --jobs 2`: `SUITE total=11 fails=0`
  (includes the untouched `venue_art_test.gd` and `walkout_venue_test.gd`).

## Stills (opened with the file tool; seed 5150, frame 240, 1920x1080, Tools/godot_hidden.ps1)

`previews/venues2/`, tool `assets/venues/boxing_arena/tools/capture_venues2.gd`:
- `boxing_on_broadcast.png` - the broadcast frame inside the pack's ring: fighters in exactly the same place and pose
  as OFF, A's feet on the canvas (no float or sink), ring proportions read right against the fighters. The canvas
  is a plain dark grey, pads black, three white ropes; a pale diamond-plate patch beyond the far apron edge is the
  top of the ring steps. Stands visible over the far ropes.
- `boxing_on_broadcast_wide.png` - fixed wide camera: the fitted ring on its black skirt, posts down to the floor,
  ropes tied to the turnbuckles, fighters on the deck at plausible scale; hall lit (two seat tiers in blue, red
  balconies, light trusses at the ring corners, the entrance stage and lighting rig behind). Lit but grey/dim
  overall, like the C205 hall - not polished arena lighting.
- `boxing_off_broadcast.png` - OFF control: ArenaRig ring (cream canvas, FIGHTCAMP logo, red/white corners), same
  fighters, same pixels for the bodies.
- `boxing_off_broadcast_wide.png` - OFF control, wide: the schematic ring alone on the grey void.

## For the operator (taste, not decided here)

- The pack's ring has THREE ropes (wrestling-style); boxing rules use four (spec rope heights listed above). The fight
  does not read ropes, but it shows.
- ON loses ArenaRig's dressing: no FIGHTCAMP canvas logo, no red/blue corners, no branded skirt.
- Engine pose of fighter B at this seed (odd low stance) is identical in OFF - not the hall.

## Not done

- Walkout (C232) through the new hall: WalkoutShot uses Marpa only for MMA and builds boxing walkouts from VenueRig;
  routing it needs WalkoutShot changes outside this brief's owned files. No walkout still.
- Stills not yet sent to the operator (the merging session does that).
