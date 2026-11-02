# Gym floor from REAL boxing gyms - references, rules and the S206 plan (2026-10-11)

Operator S205 on the club floor stills: "wtf is this i do not understand what sources have you used to make this gym ??" -
three bags floating on an empty tan patch with no mount, six first-aid cabinets on poles in the "stretch" zone. Operator
board marks 2026-10-11-01 on the starter floor: (1) the right half of the hall "why is this empty ?", (3) the orange
plyo crates "never seen in a gym", (4) the striped ladder "what is that ?".

Root cause (GYM_ZONE_AUDIT_S200.md): the zoned floor was FILLED by a packer until test quotas passed (every zone 45% full,
east half >= 35% of the kit, >= 6 bags in zones). Nobody designed it. This page replaces that with a floor drawn from
real gyms. Reference only - no image or plan from these sources ships.

## Prior research read
`python Tools/prior_research.py gym floor layout bag line` -> G121_REAL_GYM_FLOOR_PLANS.md (Whitby ABC, Wild Card, Kronk,
UFC PI/Gym plates, England Boxing checklist, Compound Fitness, Monster Rings, Matsuru - each sourced there),
GYM_ZONE_AUDIT_S200.md (zone-by-zone verdict on today's floor), GYM3D1_LAYOUT.md, J16, R66, G88, LUDO_GYM_VIEW_R18.
Layout A of GYMLAYOUT1 (S201, `club_layouts/claude.json`) was the first hand-authored plan; S206 builds on it.

## The references (12)
| # | Gym / source | What it shows | Link |
|---|---|---|---|
| 1 | Wild Card Boxing Club, Hollywood | strip-mall upstairs room; rings in the open floor; heavy bags and speed bags AROUND THE WALLS | latimes.com/archives/la-xpm-2009-apr-29-sp-boxing-manny-pacquiao29-story.html (via G121) |
| 2 | Gleason's Gym, Brooklyn (77 Front St, now 130 Water St) | concrete hall; 4-5 rings as islands; "rows of chains hanging from steel beams" = bags hung from overhead beams; speed bags off the walls; ~8-10 heavy bags | gearpatrol.com/2015/07/09/gleasons-boxing-gym-photo-essay/ ; brooklynrail.org/2004/04/local/gleason ; gleasonsgym.com/gym-history |
| 3 | Gleason's, Manhattan era | 2 training rings, 6 heavy bags, several speed-bag racks; a mezzanine overlooks the floor | gleasonsgym.com/gym-history |
| 4 | Kronk Gym (original basement), Detroit | 1 ring, 2 heavy bags, 1 speed bag, a jump-rope pad, machines on the wall | YouTube "A look back inside the Original KRONK Gym" (via G121) |
| 5 | Mayweather Boxing Club, Las Vegas | 2 regulation rings; 11 bags "clustered in a nook" (a bag bay), standard exercise kit in its own area | sports.inquirer.net/?p=178910 |
| 6 | Whitby ABC (UK amateur club) | ~200 m2 hall; ring at one end; bag/training strips along the LONG walls; changing and meeting rooms off a lobby, not on the floor | northyorks.gov.uk Eastside Community Hub business case (via G121) |
| 7 | England Boxing - New Club Setup Guide (2025) | min 324 sq ft; training ring >= 12 x 12 ft inside the ropes; ring 1 m from any wall (or padded); kit must not block entries/exits | englandboxing.org/wp-content/uploads/2025/07/NewClubSetupGuide.pdf |
| 8 | England Boxing - Gym Inspection Club Checklist (Apr 2025) | inspection items: clearances, exits, equipment safe to use | englandboxing.org/wp-content/uploads/2025/04/Gym-Inspection-Club-Checklist-April-25.pdf |
| 9 | Gymdesk - Boxing Gym Equipment: an owner's specification guide | heavy-bag station 10x10 ft min, 12x12 ft better (5-6 ft movement radius); 1 bag per 2 students; main walkway 4 ft min, 5-6 ft better; 1-2 ft buffer between zones; ring 2 ft clear beyond the ropes; commercial bag 125 lb > a 120 lb joist mount - hang from the structure, not the finish | gymdesk.com/blog/boxing-gym-equipment |
| 10 | Skelcore - outfitting a combat-sports area | a struck bag swings 1 m+ from rest: keep a 3-4 m clear circle; strike zone 3-4 ft in front, 2-3 ft each side, 2 ft behind; wall clearance 1.5 ft min; mount to concrete, steel beam or structural joist, rated 3-4x the bag's static weight | skelcore.com/guides/how-do-outfit-combat-sports-training-area |
| 11 | Compound Fitness (AU) - building a boxing gym 2026 | 1-ring commercial gym 300-450 m2; ring clearance 1.5-2 m all round | compoundfitness.com.au/blogs/news/building-a-boxing-gym-2026-equipment-list-layout-budget-guide-australia (via G121) |
| 12 | Monster Rings / Matsuru / Light In Fitness | zoning: core = ring + bags, S&C beside not across the boxing traffic; the coach sees bags, floor and ring from one spot; a dead-centre ring that kills the bag rows is waste; club of 150-250 m2 = ring + 8-12 bags + open floor | via G121 |

## Rules extracted (what the plan obeys)
1. **Bags hang from the building, in rows, on the walls.** Steel beam or wall-bracketed rail at ceiling height, chain + swivel
   down to each bag (Gleason's beams, Wild Card/Whitby walls, Skelcore/Gymdesk mounting). Never freestanding in a walkway.
   Bag centre ~1.2 m off its wall (ClubLayoutRules R1), ~2-3 m centre to centre (Gymdesk 10-12 ft stations; club rails run
   tighter, ~1.9 m, as at Gleason's).
2. **8-12 heavy bags** for a club this size (Light In Fitness, G121), 1-3 speed bags on wall platforms, a double-end ball or two.
3. **Ring at the back, off the wall**: >= 1 m to any wall (England Boxing), 1.2 m clear all round in our plan; it is the
   centrepiece but does not kill the bag rows.
4. **Open wood floor in front of the bags** for shadow boxing, pads, slip rope and skipping - a wall mirror on a side wall.
5. **Walk lanes kept clear**: a lane in front of the bag line, a cross aisle >= 1.2 m (4 ft) that ends at the fire exit,
   a front aisle past every room door.
6. **Cardio is secondary** in a boxing gym (Kronk: machines on the wall; ropes > machines): 3 machines in one corner.
7. **ONE strength corner on rubber**, beside - not across - the boxing traffic, at the far side from the ring steps.
8. **Recovery/stretch quiet and separate**, next to the physio door, off every walk.
9. **Lockers, office, reception, first aid OFF the floor** (they are rooms in our club; the kit lives in the physio/office).
10. **No filler.** Nothing stands on the floor because a test wanted the area covered: no crates, no first-aid cabinets on
    poles, no plyo boxes as a "bench", no bags or speed bags in the middle of the floor.

## What a 30 x 18 m (540 m2) club holds
Real clubs: 150-250 m2 = ring + 8-12 bags + open floor; 300-450 m2 = one-ring commercial gym with S&C. Our hall (540 m2,
rooms off the front) is a generous one-ring commercial club: ring, 8 heavy bags, 2 speed bags, 2 double-end balls, an
open boxing floor, a cardio corner, a stretch corner, a footwork turf and one strength corner - and still clear aisles.

## The S206 plan (data: `Godot/assets/data/club_layouts/s206.json`, authored in `Tools/gym_layouts/author_s206.py`)
Drawn plan: `previews/s206_floor/s206_floor_plan.png`. Game-camera still: `.../s206_floor/our_floor_reference.png`.
x runs west -> east (0-30), z from the back wall (0) to the room wall (18). Item x,z = top-left of its use area.

```
 z  0 +--------------------------------------------------------------------------------------------+ BACK WALL
      |SB SB  ==beam W 3.5m=========== |                                 | ==beam E=============== |
      |       HB1  HB2  HB3  HB4       |        +------------------+     |    HB        HB         |
 2.7  |  BAG LINE (wood)               |        |                  |     |  BAG LINE (wood)        |
      |..... bag lane (walk) ...........................................................  ...... |
 3.5  |GL+-------+ +----------+        |        |   RING 16 ft     | B  |  ROWER          |b HB    |
      |  | MIRROR| |   PADS   | SLIP   |        |  1.2 m off the   | E  |                 |e       |
      |  | (west | +----------+ ROPE   |        |  wall, 1.2 m     | N  | TREAD   AIR     |a HB    |
      |  |  wall)|   skipping floor DE |        |  clear all round | C  |  MILL   BIKE    |m       |
10.4  |  BOXING FLOOR (wood)           |        +------------------+ H  | CARDIO (rubber) |BAG LINE|
      |............................ cross aisle 1.2 m .................................... FIRE EXIT
11.6  |+--------------+-----------+---------------------+-------------------------------------------|
      ||   DE   DE     | STRETCH   | LADDER  open wood   | PWR RACK  PLATFORM  WEIGHTS  DB RACK      |
      || TIMING (wood)| mats      | FOOTWORK (wood)     | STRENGTH rubber                 BENCH     |
16.4  |+--------------+-----------+---------------------+-------------------------------------------|
      |............................ front aisle ................................................ |
 18   +--LOCKERS-------PHYSIO----------RECEPTION--OFFICE-------------------------STORE------------+
      x 0            6.6  7.2     10.8  11.3  14.1    18.0          22.1      27.3             30
```
NOT MIRRORED (operator S206, verbatim: "the ludo preview uses the same assets like mirrored do not do the same mistake"):
the west half is the BOXING side (wood: bags, mirror, pads, slip rope), the east half the CONDITIONING side (rubber cardio
block + a bag strip on the east wall), the front band runs timing / stretch / footwork / strength - no zone is a copy of another.

| Area | Material | Rect [x0, z0, x1, z1] | What stands there (station place / floor item) |
|---|---|---|---|
| bag_line_west | wood | [0, 0, 11.4, 2.7] | speed bags 1-2 on wall platforms [0.3-2.7, 0.1-1.5]; heavy bags 1-4 (bays [3.0-10.5, 0.2-2.2], bags at x 3.9/5.8/7.7/9.6, z 1.2) |
| beam W | steel | (2.9, 1.2) -> (10.6, 1.2), y 3.5 | I-beam on 5 wall brackets; a chain to each of HB1-4 |
| ring | - | [13.0, 1.2, 20.8, 9.0] | 16 ft ring 1.2 m off the back wall (Ludo r41), platform [14.0-19.8, 2.2-8.0], steps x 14.8 on the front; clearance ring + 1.2 m |
| bench_water | - | [21.0, 3.6, 21.6, 7.6] | ringside bench (Kenney bench, not plyo crates) |
| bag_line_east | wood | [22.1, -0.35, 30.0, 2.7] | heavy bags at (23.7, 1.15) and (26.7, 1.15) on beam E (22.6 -> 28.8, 4 brackets) |
| boxing_floor | wood | [0, 3.5, 11.6, 10.4] | glove pegs [0.1-0.7, 3.7-4.9]; wall mirror [0.2-2.6, 5.6-10.2]; pads [3.0-6.6, 3.7-7.2]; slip rope [7.0-11.4, 3.7-7.2]; skipping floor; double-end ball (10.4, 8.8) |
| cardio | rubber | [22.1, 3.5, 27.2, 10.4] | rower (24.15, 4.55); treadmill [22.4-24.4, 6.8-10.2]; air bike [24.6-26.6, 6.8-10.2] - beside the bags, as at Kronk |
| bag_wall_east | wood | [27.3, 3.5, 30.35, 10.4] | heavy bags at (28.85, 5.0) and (28.85, 8.0) on beam S (x 28.85, 1.15 m brackets off the east wall) |
| timing | wood | [0, 11.6, 6.6, 16.4] | double-end balls (2.2, 13.2) and (5.0, 13.2) by the locker door |
| stretch | mat | [6.8, 11.6, 10.6, 16.4] | stretch mats [7.0-10.4, 12.0-15.4], beside the physio door (x 7.2) |
| footwork | wood | [10.8, 11.6, 17.8, 16.4] | agility ladder [11.0-12.6]; open floor for footwork and skipping (Ludo r41: no turf in a boxing club) |
| strength | rubber | [18.0, 11.6, 30.0, 16.4] | power rack [18.2-20.4], olympic platform [20.8-23.4], weights [23.8-27.0], dumbbell rack + flat bench on the east wall |
| walks | - | bag lane z 2.7-3.5; cross aisle z 10.4-11.6 -> fire exit (30, 11.0); front aisle z 16.4-18 past 5 doors | route graph: lanes x 2.8, 6.7, 10.7, 12.2, 17.9 join them |

Counts: 8 heavy bags (4 + 2 + 2), 2 speed bags, 2 double-end balls, every one hung from a beam or wall platform.
Removed from today's floor: 6 first-aid cabinets, 7 phantom bikes, 5 extra speed bags, 6 freestanding heavy bags,
the plyo crates, the duplicate ladder, the expansion block, slam-ball/kettlebell crates (no real model yet).
Checks run on the plan: ClubLayoutRules R1-R6 = 0 breaks (club_layout_variants_test, s206 must be clean);
my geometry check: no two use areas overlap, nothing on a walk lane, ring clearance or door zone, every station inside
exactly one area, every route node reachable from the reception door.

## Ludo round 41 (verbatim reply: research/LUDO_ROUND41_S206_floor.txt, 18,839 chars; paint-over:
`previews/s206_floor/ludo_r41_paintover.jpg`) and my verdict
Ludo scored the first S206 plan **7.2/10**: rules 1, 2, 4, 5, 6, 8, 9 right; "KEEP YOUR PERIMETER WALL BEAMS".
- TAKEN: ring 1.2 m off the back wall (uniform clearance) -> ring [13.0, 1.2, 20.8, 9.0].
- TAKEN: no artificial turf in a boxing club -> FOOTWORK is wood.
- TAKEN (operator's point on its image): the paint-over is a MIRROR (identical bag frame + rubber pad both sides) and my
  first plan was too (two tan floors flanking the ring) -> the east half became the conditioning side.
- REJECTED: its freestanding bag frames (Ludo itself says keep the wall beams); moving the east-wall bags to beam E (those
  spots are already taken - it would cut us to 6 bags); its smaller strength/cardio rects (they drop the use clearances
  our engine needs); chalk drill grid, trainer table, balance-beam scale, pad caddy (not in the catalogue - asset backlog).
- LATER (asset/art pass, not layout): one scuffed-timber hall floor instead of grey concrete; wall dressing - fight bills
  and club records on the east wall, a big painted club sign behind the ring, a wall clock, a cork board on the room wall,
  hand-wrap hooks, a lit EXIT sign (Ludo section D has positions).

## Assets made for this floor (S206, operator: "download assets if you have too before rendering it, check tripo and ludo")
Checked first: Ludo has no gym 3D assets (its 3D history is the NULLSPACE spaceships; the FightCamp vault holds 7 UI images);
free CC0 gym packs are thin (no complete set found). Generated in Tripo Studio (operator's account, text-to-3D H3.1, 55
credits each, 2,030 -> 1,755), exported GLB with 1K textures, slimmed in Blender (`Tools/gym_layouts/slim_glb.py`: weld,
decimate to ~20k faces, JPEG textures) from ~60 MB to 1.4-2.2 MB each, into `Godot/assets/models/props/gym/`:
| File | Used by | Fit |
|---|---|---|
| power_rack_cage.glb | power_rack station dressing | 2.2 m tall |
| flat_bench.glb (an adjustable incline bench) | strength zone item flat_bench | device h 0.95 m (TrainingFloorLayout) |
| glove_rack_wall.glb | glove_rack dressing, `y` 1.0 m up the west wall | 0.86 m tall |
| ringside_bench.glb (bench, bottles, towel, bucket) | bench_water dressing | 0.6 m tall |
| agility_ladder_mat.glb | NOT used: it came out 1.4 m wide / 27 cm thick at ladder length; the painted ladder got black side straps instead | - |
Reused (no spend): `compact_weights_t3.glb` (earlier Tripo two-tier dumbbell rack) now draws the dumbbell_rack item (alias).
LICENCE: the operator confirmed the Tripo account is a PAID plan (S206) - generated models are ours to ship.

## Operator marks on v2 (Feedback/2026-10-11-02) - fixed in v3 (commit 09833c31)
1. "these seem to be very low" (speed bags) -> wall platforms mounted 2.2 m up (dressing `y` 1.2).
2. "overlapping" (round timer on the club name / a poster) -> timer at x 21, between posters 19.5 and 22.5.
3. "this should be all over the place and bigger" (club name) -> twice the size, posters and lamps kept 4.3 m clear; repeating
   it on other walls waits for the art pass (he: "not important right now").
4. "they look like the hanging from nothing" (double-end balls) -> both on west-wall beam T with floor plates and visible
   cords; the mid-floor one is gone.

## Known limits (after this plan)
- The beams/brackets/chains are drawn from boxes and cylinders (`ClubZoneFloor._add_beams`); a modelled rig (BAGRIG1) can
  replace them later without moving a bag.
- Operator point 4 ("why we cannot have beautiful graphics and assets like 2point hospital?") is an ART question, not a
  layout one: the agility ladder is painted rungs, several machines are primitives. That is GYMART1/EQUIP3's job.
