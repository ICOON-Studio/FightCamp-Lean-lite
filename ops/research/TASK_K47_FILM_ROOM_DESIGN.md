# TASK K47 - Design the gym's FILM ROOM (scouting) as a buildable spec + concept images (Kalli, design)

Self-contained design brief for a browser agent (Grok). No repo access needed. Deliver a written spec and images.

## Context
FightCamp is a boxing (later MMA) gym-management game with 3D rooms seen from a fixed three-quarter room camera (like a
cut-away dollhouse view). Existing rooms: office, locker room, lobby, mat room, staff room, physio, all bright and warm
("bright and alive" - dark or empty reads as abandoned). The FILM ROOM is not built. In the game it is where the manager
SCOUTS an opponent before booking or in fight camp: watches his fights, reads his habits, and picks a game plan.

## Reference
The painted mood target for this room is attached (repo: `previews/concepts/room_film.jpg`). Keep its mood;
your job is to turn it into a room that can be BUILT: measured, listed, and clickable.

## Design the room so a 3D artist can build it without guessing
1. FLOOR PLAN in metres: room width x depth (keep it about 7 x 5 m, wall height 3 m), where the door is, and the
   position (x, z in metres from the back-left corner) and size of every object.
2. PROP LIST: every object, its real size, material/colour, and whether it can be built from simple furniture (a
   desk, chairs, a sofa, shelves, a TV, a whiteboard, a projector screen, a laptop, rugs, plants, lamps, cardboard
   boxes). Say which props need custom modelling.
3. PEOPLE: who is in the room and what they do (e.g. the coach pausing a fight on the screen, a fighter taking notes).
4. CLICKABLE OBJECTS (3-5): each object the player can click and the screen it opens, e.g. the big screen -> the
   opponent's fight footage; the whiteboard -> his tendencies (jab share, favourite punch, stamina fade); a folder ->
   his record; a laptop -> the game plan.
5. LIGHTING and mood: daytime-bright but with a glowing screen; colour palette (3-5 hex colours).
6. TWO CONCEPT IMAGES from that three-quarter cut-away camera: the room in use, and a close view of the whiteboard/screen.
   No real people's likenesses, no real logos or brand names; fighters are fictional.

## Deliverable
Title "K47 - The film room, buildable spec". A plain-text spec under 900 words (sections 1-5 above, a table for the
props) and the two images.
