# PLACEMENT1 - placement like Two Point games: Claude's verdict for the operator's OK (S243)

Operator S243, verbatim: "i also want the placement to be similar to 2point games and similar games".
Sources: Ask Ludo r109 (26,315 chars) + r110 (26,059 chars, continuation + Part C), raw in research/ludo_rx/LUDO_R109_raw.txt and
LUDO_R110_raw.txt (uploaded the S242 no-walls iso still with the ask); measured Two Point Museum values in
TWOPOINT_MUSEUM_STUDY_S243.md (read from the shipped game's data: numbers only). Discipline: BOXING (demo).

## What the game does today
The player places nothing. Stations are auto-placed into fixed zones (bag line, cardio, strength, stretch, ring, footwork, timing) with
slot counts per gym tier (scripts/club_capacity/EquipSlots.gd, scripts/club_zones/ClubZones.gd); the front rooms (office, reception,
physio, equipment store, locker room) are fixed.

## The verdict (what gets built, in order)
1. DEMO - a build mode on the iso camera (key B / a hammer button): pick up, move and turn the training stations already on the floor,
   and buy more from the existing station catalogue. 0.5 m grid (Two Point Museum: 87% of its 1,600 items snap 0.5 m). Stations turn
   in 90-degree steps, decor in 45. A ghost of the item follows the cursor, green = fits, red = blocked, with the reason on the cursor
   ("No aisle path", "Too close to the ring", "Can't afford") as Two Point does. Each station keeps a clearance ring (heavy bag 1 m x 1 m
   + 0.5 m all round, ring apron 1 m, treadmill 0.5 m behind) and a walkway check: a path of at least 1 m must still reach every
   station from the door, or the placement is refused. 100% refund while you are still in build mode; 65% once the station has been
   used. Rooms stay fixed in the demo. The game is paused while in build mode.
2. EARLY ACCESS - Two Point room drawing for the support rooms only (office, physio, locker room, staff room): drag a rectangle with a
   minimum size (physio 3 x 3 m, office 3 x 2.5 m, locker room 4 x 3 m, staff room 3 x 2 m), a door and the room's required items
   (physio: treatment table + ice tub) before it opens; pick up and move a whole room; prestige per item capped per floor cell so
   cramming trophies into a cupboard does not inflate the gym rating (Two Point Museum caps 30-48 per cell).
3. 1.0 - templates/copy of rooms, the custom ring builder, blueprint sharing.

What layout earns the player: coach walking time between stations (a clear central aisle is faster), members queueing at a busy
station, and the gym's look rating that prospects check before signing - all already in the game; placement makes them the player's.

## Not taken from Ludo
- Ludo r110 C1 proposes a perspective camera at FOV 24. Not taken: the orthographic iso camera is the operator's settled ruling
  (Q-S239-1) and nothing new reopens it.
- Free camera rotation stays out of live play (90-degree steps, ISOWALL1); Ludo's "free turn only inside build mode" waits for the
  build mode itself.

## What it changes
Replaces the zone auto-placement of stations with the player's own layout (the zones become the starting layout). New mechanic =
operator approval first (D39 LUDO FIRST); the queue is at its 14-row focus cap, so one row leaves when this enters.
