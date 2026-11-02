# FANS1 - "some fans flying in the air" (procedural venues)

Operator 2026-10-03, walking the VenueRig halls with `tools/arena_walk.gd -- venue=<id>`: "some fans flying in the air".
Branch `claude/fans1` (worktree E:/FightCamp/wt/FANS1). Not merged to master.

## Is it arena_walk only, or the game too?
The game too. `FightWorldLiveScreen.setup` (l.1081-1103) adds `VenueRig.build(venue_spec, arena_meta)` and
`ArenaRig.build(spec)` under `Shell`. `Shell` is the instanced `FightWorldPreview.tscn` root (`FightWorld`, no
transform), and `arena_meta` carries the same contest / total / surface_y / kind as `arena_walk.gd` builds. Same
transforms, same geometry, so every defect below was in `VenueRig.gd` and showed in the fight room for every
procedural venue (Northlight only in arena_walk: in the game `venue_halls` sends grand arenas to the Marpa hall).
`arena_walk.gd` needed no fix (it only got a `snap=` option for stills).

## Cause (measured, then read in the code)
Five separate placement bugs in `scripts/VenueRig.gd`, all invisible to `venue_crowd_test` because it builds with
`surface_y = 0` and never checks what a person rests on:
1. **The Cut Glass**: the ten banquet tables (chairs + 60 guests) were placed at `y = surface_y`, the ring CANVAS
   height (1.27 m for the boxing ring), so they hovered round the ring. The real "flying fans".
2. **Iron Parish**: the bleacher rake was inverted (the highest bench nearest the ring, the lowest against the wall)
   and every bench had 0.36 m legs whatever its height, so the three upper benches hung in the air in front of the
   ones below; the "back wall crowd" was four benches 12 cm apart stacked up the wall to 2 m (each row's feet in
   the laps of the row below). Side benches also put their legs `span/2` out along X, off the plank.
3. **Limehouse / Northlight / The Quarry / Cut Glass rear rake**: every row was a 0.12-0.14 m slab in the air with a
   0.14 m gap to the next; the seated person's soles are 0.43-0.49 m below the seat point, so the legs went through
   the slab and the feet dangled under it. The end stands also ran the full depth, crossing the side stands' rows in
   every corner (seats inside seats).
4. **North Dock**: the retractable bleachers were 0.16 m slabs in the air; same dangling feet.
5. **Paper Hall**: the three scorers sat 0.46 m above the bare floor (no chairs).

## Fix (VenueRig.gd)
- `FOOT_DROP_M = 0.46`, `FOOT_FROM_M = 0.12` (measured from the crowd VAT: lowest sole per frame -0.43..-0.49 m below
  the seat point, sole points 0.21-0.27 m in front of it). New `_row_block`: a solid block of a seat row.
- Bowl rows (`_add_limehouse_row`, used by Limehouse, Northlight, The Quarry) and the Cut Glass rear rake: the slab
  becomes a seat ledge down to the floor plus a foot tread 0.46 m below the seat, reaching the next row down.
  Seat positions unchanged.
- End stands (W/E) run between the side stands' front steps (`side_half`) - no more corner crossings.
- North Dock: each deck row = seat ledge + foot tread on the floor (shaded as before).
- Iron Parish: rake climbs away from the ring (same z/length per row, heights swapped), legs reach the floor and sit
  under their own plank, raised benches get a footboard; side rows stop short of the end rows; the stacked
  back-wall shelf crowd is removed (no room for a real rake between the wall and the top bleacher). Crowd stays at
  its 250 cap -> 237 people, same as before.
- Cut Glass tables at y = 0. Paper Hall scorers get chairs.

## Probe numbers (`tools/fans1_probe.gd`, headless, boxing ring, each venue's own crowd seed)
Floating = the figure's lowest sole points (VAT shoe region, most generous frame 44, through its MultiMesh
transform) more than 5 cm above the venue surface under them; seat = the seat point more than 5 cm above a surface.

| venue | figures before -> after | feet floating before -> after | worst foot gap before -> after | seat floating before -> after |
|---|---|---|---|---|
| iron_parish | 237 -> 237 | 130 -> 0 | 1.180 -> -0.009 m | 0 -> 0 |
| limehouse_bowl | 2500 -> 1856 | 2452 -> 0 | 4.754 -> -0.009 m | 0 -> 0 |
| paper_hall | 37 -> 37 | 0 -> 0 | 0.037 -> 0.037 m | 3 (0.460 m) -> 0 |
| the_cut_glass | 165 -> 165 | 145 -> 0 | 1.820 -> 0.021 m | 0 -> 0 |
| northlight | 3821 -> 2799 | 3762 -> 0 | 6.213 -> -0.009 m | 0 -> 0 |
| north_dock_leisure | 454 -> 454 | 330 -> 0 | 1.608 -> -0.010 m | 0 -> 0 |
| the_quarry | 3450 -> 2447 | 3381 -> 0 | 4.755 -> -0.009 m | 0 -> 0 |

The bowl head-counts drop because the removed corner seats were double-booked (inside the side stands' rows).
Residual, information only: in Iron Parish (6) and North Dock (15) the front-row bench is 0.38 m high, so in the
lowest-sole frame a whole foot sits up to 10.7 cm into the floor (pre-existing; 4-5 cm in the other frames).
Not touched: Iron Parish's nine "phone speck" spheres still float at 1.1-2.6 m (glow dots, not people).

## Test
`tests/venue_crowd_grounded_test.gd` (headless): builds all 7 halls exactly as arena_walk.gd / the fight room do and
asserts per venue: has figures, no feet > 5 cm above support, no seat point > 5 cm above a seat.
- Fixed tree: `VENUE_CROWD_GROUNDED_TEST fails=0` / `PASS` (22 checks).
- Mutant (every seat lifted 0.2 m in `_finish_crowd`): `fails=14`, `FAIL` (all 7 venues, both checks); VenueRig.gd
  restored byte-identical (sha1 e55e66b7 before and after the mutant).
- Control (unfixed VenueRig.gd from origin/master): `fails=7`, `FAIL` (6 feet checks + paper hall seats).
- `python Godot/tools/run_tests.py --only venue,walkout,arena --jobs 2`: `SUITE total=13 fails=0`.

## Stills (`tools/arena_walk.gd -- venue=<id> snap=<png> cam=x,y,z look=x,y,z`, via Tools/godot_hidden.ps1; saved as JPG q85)
- `docs/previews/fans1/cut_glass_before.jpg` / `cut_glass_after.jpg` - before: tables, chairs and guests float at
  canvas height round the ring; after: they stand on the ballroom floor below the ring apron.
- `docs/previews/fans1/iron_parish_before.jpg` / `iron_parish_after.jpg` - before: people at random heights on
  floating rails with dangling legs, a stack against the back wall; after: the side stand climbs away from the ring,
  the back-wall stack is gone (stand structure is dark and hard to read in this light; one phone-speck dot still
  floats).
- `docs/previews/fans1/north_dock_before.jpg` / `north_dock_after.jpg` - before: thin planks with floor visible
  between them and legs hanging; after: a solid stepped deck, feet on the treads.
- `docs/previews/fans1/limehouse_before.jpg` / `limehouse_after.jpg` - the dark
  unshaded steps barely change this view; the change is under the rows (solid instead of slabs).
