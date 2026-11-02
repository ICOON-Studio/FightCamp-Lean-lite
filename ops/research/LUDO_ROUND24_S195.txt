# LUDO ROUND 24 (S195, 2026-10-10) - Ludo given our REAL game data (operator: "doesn't ludo have access to our game data ... use assets it can actually generate" -> "Go and show me the picture")
Setup: a generated GAME DATA BRIEF (research/LUDO_GAME_DATA_BRIEF.md, built from gym_club.json) was APPENDED to the Ludo project document, section "Godot 4 and 3D Visuals" (original text untouched; undo via the doc history).
It states: PC deep sim not mobile/arcade, the engine and zone format, the real 20 x 18 m hall, every station's zone, the free strip, hard rules, and what Ludo must output (text layout in our zone format; images for look only;
single props as 3D it can generate). Asked: six new stations in the free strip (existing stations untouched, ONE bag area) + one concept image.

## Ludo's answer
1. A concept IMAGE (3D cutaway of a long bright gym: bag wall at the back, ring in the corner, deadlift platform, half-rack, treadmill/cardio, agility ladder, blue mat, yellow expansion square; brick + blue stripe + black rubber).
   It is look-only. Ludo's own follow-up suggestions admit it has extra cardio equipment and needs "exactly one heavy-bag area".
2. A mapping + loadable JSON for six stations (zone [x0,z0,x1,z1] | work | approach | aisle band):
   agility ladder [5.8,12.2,7.2,15.8] | [6.5,14.0] | [6.5,16.6] front aisle
   Olympic deadlift platform [8.4,12.2,11.0,15.2] | [9.7,13.7] | [9.7,16.6] front aisle
   power half-rack [12.2,12.2,14.4,14.8] | [13.3,13.5] | [13.3,11.4] open strip
   mobility/recovery mat [15.6,12.4,17.6,15.4] | [16.6,13.9] | [16.6,16.6] front aisle
   tactical film console [18.2,10.8,19.8,12.8] | [19.0,11.8] | [17.5,11.4] open strip
   reserved expansion bay (decor) [18.2,13.6,19.8,16.0] | [19.0,14.8] | [19.0,16.6] front aisle
   Graph nodes at z 16.6 (front aisle: x 6.5, 9.7, 16.6-19.0) and z 11.4 (open strip: x 13.3, 17.5).

## Claude's numeric check (script against the real gym_club.json)
No overlaps; all inside the 20 x 18 hall; every work point inside its zone; every approach point on the stated aisle band and outside every zone. BUT Ludo's own clearance table is wrong in two places:
mobility mat <-> expansion bay gap is 0.60 m (Ludo: 1.20), tactical film console <-> our stretch corner gap is 0.50 m (Ludo: 1.40). It also called our weights approach [2.5,16.6]; it is [2.5,11.4] (the brief did not list approach points).
## Conflicts with our settled rules
- Film console: GYM4 5 "NEVER ON THE FLOOR" - no TV / whiteboard / monitor on the hall floor; film study lives in the OFFICE (tape TV). Exclude it.
- Mobility mat: duplicates our existing Stretch corner. Exclude it.
## Claude's recommendation (operator decides on the board)
Build 4 of the 6 as data: agility ladder, Olympic platform, power half-rack, reserved expansion bay (an empty marked square, no model needed). Needs models: ladder = floor decal (greybox, easy); platform and rack have no model in
assets/models/props/gym yet - generate ONE prop per request in Ludo 3D (licence + scale check) or greybox first. Connect them with the aisle nodes Ludo listed, fix gaps >= 1.2 m, rerun the gym_/club_ tests.
Station TYPES: these are new station ids; they need a training effect (what the player gets for sending a boxer there) - a design question for Ludo/operator before they appear in the day planner.
