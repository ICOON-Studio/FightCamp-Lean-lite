# GYMBUILD - the gym as a Mad Games Tycoon 2 / Two Point game (S276 plan)

Operator S276, verbatim (in order):
- "i want to be able to select where i put the items at the start of the gym and in that way the gym floor will be build ... design how the player can design the zones in the gym"
- "for the other rooms make it 1 item (eg 1 locker) , office (eg only the pc for now rest things can be purchased to be unlocked) , physio (eg 1 bed) and sort items that can be bought by room"
- "if text becomes too heavy replace it with an icon and a toolip"
- "strip the whole gym and i will place the items like in 2 point ... can you make a pallette of the gym and a sidebar menu with all the assets and i can start building the gym myself , i can draw the rooms like in mad games"
- "can you visualize it the gym played in as a 2point/mad games game , the way you build everything the people walking in and training"
- "basiacally you start with nothing and buy/build the necesarry things to start operating the gym"
- "find assets for decals and things you can decorate a gym also ? jus tlike how those 2 games build their rooms"
- "the starting gym should be an emptu building , no room no nothing, player draws the limmits of each room"
- Mad Games Tycoon 2 screenshots: a walled plot (outer walls + door) on grass beside a street; "Build a Room" menu of room types, most
  locked (unlocked by research / time); bottom toolbar of icons (build, shop, staff, finance); "this ihow i want hte gym and the surrounding"

## What exists (S276, master 29e313e3)
- BUILD MODE (B / top-bar BUILD, club_rooms/BuildMode.gd): day pauses; SHOP of zones priced from equipment_catalog.json purchase_cost;
  buy -> carry -> click to place; drag / swap / R turn / Delete store / Ctrl+Z; green-red ghost + reason chip; stations, kit, beams
  follow their zone (GymClubLayout canonical membership + refresh_station_props, no day restart). Probe: tools/s276_build_probe.gd.
- stripped_start: a new career's hall is empty but the ring; nothing owned. The SIDE ROOMS (office, reception, physio, locker, equipment
  store) are still the fixed data rooms - NOT yet drawable.

## The target (decided - the operator's design)
1. THE PLOT: the gym building is an empty walled shell on its own lot (grass, pavement, trees, street, neighbours - MGT2 style), one
   front door. No rooms, no ring, nothing inside at the start. Starting cash buys the first things.
2. DRAW A ROOM (MGT2): "Build a Room" menu of room types with locks: TRAINING FLOOR, OFFICE, RECEPTION, LOCKER ROOM, PHYSIO open at the
   start; SPARRING ROOM, STRENGTH ROOM, CARDIO ROOM, FILM ROOM, LOUNGE, TOILETS, STORAGE unlock with gym level / reputation. Drag a
   rectangle on the plot -> walls + a door are generated; min size per type (PLACEMENT_VERDICT_S243: physio 3x3, office 3x2.5,
   locker 4x3); a room works only once its KEY ITEM is in it (office: the PC; physio: one bed; locker: one locker; reception: a desk).
3. ITEM PALETTE (Two Point): sidebar of every asset sorted BY ROOM, then by type, icon + price + tooltip (no heavy text): 95 priced
   catalogue items exist (equipment_catalog.json) + decor (to find). Place on the 0.5 m grid (PlacementRules: inside, clearance,
   aisle, cash), R turns (stations 90, decor 45), move, sell (100% refund this session, 65% used). A placed station IS a training
   place (walk-to point generated from its footprint; walking on a grid path, not the fixed node graph).
4. PEOPLE: members and fighters walk in the front door and use what was built; the coach and staff work in their rooms.
5. DECOR: posters, floor decals, flags, plants, benches, wall art - by room (asset search queued: GYMDECOR1, free licences only).

## The bar: way better than Gym Empire (operator S277)
"our game must be way better than this" (Gym Empire - Idle Gym Tycoon Management, Steam 756300). The full benchmark and the table
every step is judged against: S277_GYM_EMPIRE_BENCHMARK.md. In short: no step may ship a progress blocker, a "Windows Paint" menu,
or a per-person chore (fees cancelled one by one, injuries clicked client by client); every step must show the gym feeding the
boxer we watch fight - the thing Gym Empire does not have.

## Order of work
A. Empty shell + plot surroundings (the street side as MGT2) - visual, game camera stills, the operator's OK.
B. Room drawing for the support rooms (walls/door generation, room types menu with locks, key item rule).
C. Item-level placement with the catalogue palette (replaces zone kits on new careers), stations generated from placed items,
   grid pathing for walkers.
D. Decor palette from the GYMDECOR1 results.
Each step: the real-route probe + game-camera stills, the .exe for the operator.
