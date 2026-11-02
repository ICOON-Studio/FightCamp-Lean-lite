# K82 - training floor (tier 1) and lobby to concept (Kalli, collected S137 2026-10-01)

RAW CAPTURE of the Grok Bot chat (grokbots read). Brief: TASK_K82_THE_FLOOR_AND_LOBBY_TO_CONCEPT.md. Consumer: the room build task that implements it (S137_LOOP_PLAN wave 4).

K82: training floor (tier 1) and lobby

I have no room dimensions, so every position is in metres from a named corner. I assumed the training floor is about 10 x 8 m and the lobby about 8 x 6 m. If the real rooms differ, scale the numbers and keep the relationships. Kenney names are the closest fit and unchecked against the kit, so use a box if one is missing.

Training floor, tier 1

Biggest reason it reads worse than the concept: the render is lit evenly and drawn as a data diagram. Flat colour rectangles and floating text sit on a clean floor. The concept has one warm light pool, long shadows and worn, lived-in surfaces.

Eight changes, ranked by gain per effort:

Warm key light with shadows. A directional light from the right at about 25° above horizontal, colour #FFB561, energy 1.4, shadows on. Add a cool fill #8FB4D9 at 0.35 from the opposite side, no shadows. This is the biggest gain for the least work.
Pull the zone rectangles back. Drop their alpha to about 0.12 and show them only on hover or when a pin is selected. Floor labels go to 12 px minimum, white at 70% opacity. Show the floating fighter text only for the fighter under the cursor.
Concrete floor. Replace the flat floor with a box 10 x 0.05 x 8 m, base #6E6A66, slightly rough. Add 6 to 8 stain decals (boxes 0.8 x 0.01 x 0.5 m, #4F4B48, alpha 0.5, random rotation) around the heavy bags and ring.
Cinder-block back wall. Swap the brick on the back wall for grey block #8B8F92, 10 m wide by 3 m high, with 0.03 m mortar lines in #6A6E70 every 0.4 m. Keep brick on the side walls.
Duct-taped heavy bags. Two cylinders 0.38 m wide by 1.0 m high, #7A4B2A, hung on chains from 3.2 m. Place them 1.5 m and 2.7 m from the right wall, 2.0 m from the back wall. Add a 0.12 m band cylinder at mid-height in #B8BCC0 (silver tape). Put a 0.9 x 0.04 x 0.9 m black rubber mat #1F1F1F under one bag.
Skipping ropes and a poster on the back wall. Two thin cylinders 0.02 x 0.8 m, #C62828, on a hook 1.6 m up and 1.0 m from the left corner. A black-and-white poster box 0.6 x 0.9 x 0.01 m, 1.4 m up and 0.5 m right of the ropes.
Admin corner. A folding table (Kenney table, or a box 1.2 x 0.75 x 0.6 m, #EDEDED) in the back-right corner, 0.3 m from each wall. Add a chair (Kenney chairCushion, #6C7A89) tucked under it and a green crate box 0.7 x 0.4 x 0.4 m #5B6B4A beside it. A notebook box and a water bottle cylinder go on top.
Window light and pendant lamp. A 1.2 x 1.2 m light patch #FFD9A0, alpha 0.5, on the floor near the right edge. Add a pendant lamp (Kenney lampRoundFloor raised, or a 0.3 m cylinder with emissive #FFE6B0) at 2.8 m over the centre, switched off as in the concept.

Keep unchanged: the ring, the stationary bike, the fighter models, the bench with towel and bottle in the bottom-right corner, and the doorway positions (OFFICE and FRONT DESK STREET on the left wall).

Lobby

Biggest reason it reads worse than the concept: the render is a nearly empty box with floating text labels. The concept packs the walls with real objects (belts, portraits, trophy case, merch rack, fight board) and shows people at work.

Eight changes, ranked by gain per effort:

Turn labels into real objects. Replace each floating label with the prop it names. Keep a 12 px tag on hover only. This closes the most gap for the least work.
Awards wall behind the desk. A shelving box 2.4 x 0.35 x 2.2 m, #3A3028, against the left wall, 0.4 m from the back corner. Fill three shelves with gold cylinders (#D4AF37, 0.12 x 0.25 m) and 3 belts as boxes 0.5 x 0.12 x 0.02 m in #1C1C1C with #D4AF37 plates. Kenney bookcaseOpen can be the base if it fits.
Reception desk. A box 2.0 x 0.55 x 1.0 m, #3B2A1E, placed 1.0 m in front of the awards wall. Add a white fighter silhouette decal 0.8 x 0.5 m on the front, a monitor (Kenney computerScreen) and a pen cup on top. The desk hire character sits behind it, as now.
Wall of fame. Eight portrait frames, 0.35 x 0.45 m each, in a 2 x 4 grid on the back wall, 1.4 m up with 0.5 m between frames. Put a 12 px record under each (18-4-0 style). Use roster portraits, or the silhouette placeholder if none exists.
Floor and lighting. Floor tiles 0.8 m square in #4A4D52 with 0.02 m grout in #35383C. Use the same warm key #FFB561 at 1.2 and cool fill #8FB4D9 at 0.3. The room must read bright.
Waiting bench with people. Kenney bench, or a box 1.6 x 0.45 x 0.45 m #A47448, 0.5 m from the back wall and centred under the wall of fame. Seat two fighters, with a gym bag at each pair of feet (boxes 0.5 x 0.25 x 0.25 m, #2C4A7C and #222222).
Merch shelf and fight board. A wooden shelf box 1.2 x 0.35 x 1.8 m, #A47448, against the right wall, 0.4 m from the back corner, with towel, glove and shirt boxes on it. Beside it a corkboard 1.6 x 1.0 x 0.03 m, #B08B5A, 1.2 m up, with 3 poster boxes 0.4 x 0.55 m. Dates and venues must come from the real booked bouts, never fixed text.
Small finishers. A planter on each side of the desk (Kenney pottedPlant, or a box 0.4 x 0.4 x 0.4 m #555B60 with a green cone). A trash can (Kenney trashcan) and a water cooler (box 0.35 x 0.35 x 1.1 m, #E6EAED, with a #4FA3D9 jug) by the training-floor door.

Keep unchanged: the door labels OUT TO THE CITY and THE TRAINING FLOOR, the top status bar and rail, the THE DESK hire panel with its HIRE A DESK HAND button, and the sofa and bench figures.

Flags
Words: the zone names FRONT DESK STREET and OUT TO THE CITY should read the same across both rooms. "Gym" stays the building, and "fight camp" is only the preparation.
NOT COMPUTED: the real room dimensions, the scale of the fighters and the exact Kenney piece names. Before placing anything, check sizes against one fighter standing next to the desk.
6:04 PM
1 new message




Kalli replied