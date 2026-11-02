# U199 - the lobby, dressed to its concept art

Owned file: `Godot/scripts/Lobby3D.gd`. Compared every render against
`lobby_target_concept.jpg` (docs/previews/u199/pass1..4.png, final.png).

**What changed** (all procedural Godot meshes - "ours", CC0-clean, no
downloads/web images): a TROPHY SHELF under the honours wall - two wood
shelves, warm under-shelf glow strips, gold/silver/bronze cup cylinders and
flat championship-belt cases (the game's own trophy_cabinet/belt_case idiom,
scaled down and repeated) - always dressed, not tied to earned state. A
PHOTO WALL on the left wall (3x2 framed bust silhouettes + fake fight
records, between the two doors). Two seated PROSPECTS on the bench (gym bag,
one with a towel) - always there, distinct from the game-state `WalkIn`.
Desk gets a mug and notebook (D55's ask). Merch rack gets a folded-shirt
stack and a glove box (Kenney `cardboardBoxClosed` CC0, with a procedural
fallback). Waiting area gets a trash can (Kenney `trashcan` CC0) and a
procedural water cooler by the street door. Lighting pass: two new warm
practicals (TrophyLamp, PhotoLamp).

**A defect found and fixed mid-task**: the trophy shelf's first height band
(0.35/0.95/1.55 m) sat inside the to-come captions' text band and can sit
inside an EARNED plaque's band too - lowered to two shelves at 0.15/0.50 m.
The desk's hanging TRIALS & MEMBERSHIP sign still crosses the shelf's
rightmost slice from this camera (perspective, not world overlap) - the
shelf now stops at x=4.9 instead of running the honours' full width, which
clears all but that edge.

**Not fully matched**: no large "UPCOMING FIGHTS" poster board (concept's
right wall) - the room's RightWall is a 1 m cutaway, too short to hang one
without floating above it. Photo-wall portraits are procedural bust
silhouettes, not rendered fighter stills (a Godot render tool for that is
outside the owned-files list this task grants). Blender was not used - the
game's own low-poly cup/belt idiom (TrainingFloor3D's decor pieces) already
reads at this camera distance, so it stays consistent instead.

Gate: `check_scripts.py` clean every pass. `run_tests.py --only front_door`:
0 failures.
