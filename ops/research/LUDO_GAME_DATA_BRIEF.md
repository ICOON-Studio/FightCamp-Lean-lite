GAME DATA BRIEF FOR LUDO (generated from our real layout data gym_club.json, 2026-10-10; replaces guesses)

PLATFORM AND GENRE: FightCamp is a PC deep management simulation (Football Manager / Motorsport Manager class). NOT arcade, NOT mobile. Boxing first; the player is gym owner and head coach and never throws punches.

ENGINE: Godot 4.7, GDScript, 3D. The gym is one walkable 3D club seen from a fixed top-down game camera (about 44-48 degrees, field of view 36). Layouts are DATA in metres: x runs left to right (0 = left wall), z runs from the BACK wall (0) toward the street. Every station is a zone rectangle [x0, z0, x1, z1] with a work point where the fighter stands and an approach point on an aisle. Aisles are bands of z. No code change is needed to move or add a station.

CURRENT HALL (after the S195 enlargement): 20 m wide x 18 m deep = 360 square metres, wall height 3.6 m. The front block (locker room, physio, reception, your office) sits behind it at z 18-22.5, the street beyond. Aisles (z bands): bag strip [2.4, 3.0], middle aisle [7.6, 8.4], open strip [10.6, 12.0], front aisle [16.4, 18.0]. Door clear width 1.2 m.

STATIONS TODAY (label | kind | zone x0,z0,x1,z1 in metres | size WxD):
- Heavy bag 1 | station | 3.0,0.2,4.8,2.2 | 1.8 x 2.0
- Heavy bag 2 | station | 4.9,0.2,6.7,2.2 | 1.8 x 2.0
- Heavy bag 3 | station | 6.8,0.2,8.6,2.2 | 1.8 x 2.0
- Heavy bag 4 | station | 8.7,0.2,10.5,2.2 | 1.8 x 2.0
- Speed bag 1 | station | 0.3,0.1,1.5,1.5 | 1.2 x 1.4
- Speed bag 2 | station | 1.5,0.1,2.7,1.5 | 1.2 x 1.4
- Mirror + skipping | station | 0.2,3.0,3.0,6.6 | 2.8 x 3.6
- Pads | station | 3.6,3.2,6.6,6.6 | 3.0 x 3.4
- Slip rope | station | 7.0,3.2,10.2,6.6 | 3.2 x 3.4
- Weights | station | 0.4,12.2,4.6,15.6 | 4.2 x 3.4
- Treadmill | station | 4.1,8.6,6.1,10.2 | 2.0 x 1.6
- Air bike | station | 6.3,8.6,8.1,10.2 | 1.8 x 1.6
- Ring 16 ft | station | 10.6,0.1,18.4,7.9 | 7.8 x 7.8
- Stretch corner | station | 13.6,8.4,19.8,10.3 | 6.2 x 1.9
- Bench + water | decor | 19.0,2.4,19.8,7.6 | 0.8 x 5.2
- Glove rack | decor | 8.6,9.6,9.9,10.2 | 1.3 x 0.6

FREE FLOOR: the strip between the treadmill/bike row (z up to 10.2) and the front aisle (z 16.4-18) is open, about 20 m x 6 m, held for new stations.

HARD RULES: (1) No chairs, sofas, baths, fridges, TVs or whiteboards on the training floor; the ice tub and treatment table live in the PHYSIO room. (2) Gym art is bright and alive, a lived-in working boxing gym, warm light, brick walls, blue accent stripe. (3) Female and male fighters never fight each other. (4) Everything must be buildable from assets with a clear licence; generated 3D models must be under about 25,000 triangles in total for the floor and use PBR materials. (5) Every design is approved by the operator before it is built.

WHAT LUDO SHOULD OUTPUT: (a) layouts as TEXT in this same zone format (metres, [x0,z0,x1,z1]) that we can load directly, never only a picture; (b) concept images for LOOK ONLY and they must obey the layout; (c) individual props as 3D models you can really generate, one prop per request, with real dimensions in metres. Never propose mobile or arcade mechanics.
