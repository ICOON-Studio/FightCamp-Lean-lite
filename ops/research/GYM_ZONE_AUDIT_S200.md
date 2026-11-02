# Gym floor audit - every zone, what belongs there, what does not (S200, 2026-10-11)
Operator S200: "scan all zones check what items should be there and why check for that item how is it placed on real gyms then
check what items have no place in the gym and report".
Sources: our data `Godot/assets/data/gym_club.json` (11 floor zones, 20 places, 3 wall places) + `equipment_catalog.json`;
real gyms = `research/G121_REAL_GYM_FLOOR_PLANS.md` (Whitby ABC, Wild Card, Kronk, England Boxing checklist,
Compound Fitness, Monster Rings, UFC Gym plates - each SOURCED there).

## Why the floor looks like junk (root cause)
The 11 "floor zones" are filled by a capacity PACKER to pass test quotas - every zone >= 45% covered, >= 6 heavy bags,
east half as full as the west half. When the right item does not fit, it puts whatever fits. Nobody designed it. That is
where the 6 first-aid cabinets, the bag in the weights, the 7 speed bags and the mirrored "east" copies of every zone come from.

## How real boxing gyms place things (G121, sourced)
- Ring at the back, centre or off-centre; >= 1 m clear to the wall (commercial 1.5-2 m all round).
- Heavy bags HUNG along a LONG WALL, >= 1.5 m apart, never freestanding in a walkway. A 150-250 m2 club has 8-12 bags.
- Speed bags on wall platforms (1-3 in a club; Kronk had 1). Double-end ball near the bags.
- Strength on rubber, at the back/side, never across the boxing traffic. Cardio is secondary in a boxing gym (ropes > machines).
- Recovery/stretch quiet and separate. Lockers, showers, office and reception OFF the floor (we have them as rooms - correct).
- The coach sees bags, ring and open floor from one spot. Exits and walk routes clear of kit.

## Zone by zone (our hall 30 x 18 m; x west->east, z back wall->street)
| Zone | What is there now | Belongs? | Real-gym rule | Verdict |
|---|---|---|---|---|
| heavy_bag_1-4 (stations) | 4 heavy bags along the BACK wall, x 3-10.5 | YES | bags on a long wall | KEEP - this is right; hang them from the wall rig (BAGRIG1) |
| speed_bag_1-2 (stations) | 2 speed bags, back-west corner | YES | 1-3 on wall platforms | KEEP |
| bag_row (decor) | 5 MORE speed bags on the back wall, 3 of them BEHIND heavy bags 1-4 | NO | 1-3 speed bags total; nothing behind a bag | REMOVE all 5 (7 speed bags is absurd; the ones behind the bags are unusable) |
| bag_line (decor) | 2 heavy bags + 2 speed bags standing mid-floor at z 3-5, ON TOP of the mirror / pads / slip-rope stations | NO | bags hung on a wall, never freestanding; speed bags are wall-mounted | REMOVE; this space IS the shadow-boxing / pads / slip-rope floor |
| mirror_strip, pads, defence_drill (stations) | open floor for shadow boxing, mitts, slip rope | YES | open floor by the bags | KEEP - but the mirror has no wall mirror drawn |
| ring (station) | ring back-centre x 10.6-18.4 | YES | ring at the back | KEEP |
| bench_water (decor) | labelled "bench + water", drawn as PLYO STEP BOXES (the orange boxes) | bench: YES / boxes: NO | corner bench, buckets, stools by the ring | REPLACE the model with a ringside bench + water |
| bag_east (decor) | 3 heavy bags freestanding mid-floor, 3 m from the back wall, beside the ring | NO (as placed) | bags hang on a long wall | MOVE to a wall (east wall or back wall) - BAGRIG1 |
| stretch (decor) | 6 FIRST-AID CABINETS in a row on posts | NO | ONE first-aid kit on a wall near the ring/office | REMOVE 5 (1 on a wall). The strip is only 1.4 m deep (ring clearance above it) - stretch mats belong in a real recovery corner |
| recovery (station) | stretch mats x 13.6-19.8, z 8.4-10.3 | YES, wrong place | recovery quiet and separate | MOVE out of the middle aisle to a quiet corner |
| cardio + cardio_east (decor) | 7 "cardio_floor" = defined as "jump ropes + floor markings" but DRAWN AS BIKES, in the middle aisle band | NO (as drawn) | ropes + open floor; machines secondary | REPLACE with a jump-rope area (floor markings); keep the 2 real machines |
| treadmill, bike (stations) | 1 treadmill + 1 bike, middle-west | YES | cardio secondary, out of the boxing traffic | KEEP, move to the front/side |
| weights (station) | compact rack + PLYO STEP BOXES dressing | rack YES / boxes NO | strength on rubber at the side | KEEP rack, drop the step boxes |
| weights_west, strength_racks, strength_east (decor) | 3 strength zones: racks, bench, dumbbells, kettlebells, med balls - AND A HEAVY BAG in strength_east | strength YES / bag NO | one strength corner on rubber | MERGE into ONE strength area; the bag goes |
| olympic_platform, power_rack (stations) | platform + rack | YES (fight-camp S&C) | strength corner | KEEP, in the one strength area |
| agility_ladder (station) + turf_ladder (decor) | the ladder TWICE (station + a decor ladder set on top of it) | once | footwork floor | KEEP the station, drop the duplicate |
| sled_lane (decor) | turf lane x 20-22 running z 10-18 INTO the front walkway; only a slam-ball set on it | lane: maybe / placement NO | walk routes clear | MOVE the lane off the walkway, put an actual sled on it |
| glove_rack (decor) | labelled glove rack, drawn as a MITTS LOCKER | rack YES / locker NO | gloves on wall pegs | REPLACE the model with a wall glove rack |
| expansion_bay (decor) | an empty placeholder bay (grey block) | NO (in a shipped look) | - | HIDE until the player buys into it |

## Items with NO place in the hall (remove)
1. 6 first-aid cabinets in a row (keep 1, on a wall).
2. 5 extra speed bags on the back wall (3 of them behind heavy bags).
3. 2 freestanding speed bags in the middle of the floor.
4. 6 freestanding heavy bags mid-floor (bag_line 2, bag_east 3, strength_east 1) - they move to walls, not deleted (we keep the count).
5. Plyo step boxes used as a "water bench" and as weights dressing.
6. A mitts locker used as a "glove rack".
7. 7 phantom bikes (cardio_floor drawn as a bike).
8. The duplicate ladder set; the empty expansion bay block.

## Missing that real boxing gyms all have
Wall mirror at the shadow-boxing strip; ringside stools, buckets and a water bench; a jump-rope area (marked floor); one
double-end ball; a weigh scale; wall glove/wrap pegs; a coach's spot that sees bags + ring + floor.

## What I recommend (decision for the operator)
Stop packing the floor. AUTHOR one layout by hand from these rules (8-12 bags all on walls, 2 speed bags, 1 double-end,
ring back-centre with 1.5 m clear, ONE strength corner on rubber, ONE quiet recovery corner, a rope/footwork floor, a clear
walk from the street door). The quota tests are rewritten to check those RULES (bags on walls, nothing in the walk, nothing
behind a bag, no item outside its kind) instead of "45% full". Ludo reviews the authored plan before it is built; the
operator approves it on the board.
