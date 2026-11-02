# LUDO ROUND 54 VERDICT (S219) - gym hub art review on the round-6 still

Ask `LUDO_ROUND54_ASK_S219.txt` + after_01_overview.png (r6b); reply verbatim `LUDO_ROUND54_REPLY_S219.txt` (19,667 chars).
Ludo: "YES WITH FIXES", 5.8/10 (real gyms 4.5, Two Point 6.5, Punch Club 2 6.5): "reads like a CAD floorplan ... sanitized,
clinical, and empty".

## TAKEN -> GYMLOOK3B (after GYMLOOK3A merges; one round, stills on the game camera, Ludo's 10-item checklist as the gate)
1. Back wall: a round timer above the ring (1.2 x 0.6 m, dark case #1A1D24, red LED digits, cycles 3:00 round / 1:00 rest) + 4-6
   fight posters (0.9 x 1.2 m) around it - we already have poster textures (look3a_posters).
2. Ring steps: the 4-step block -> a compact 2-step club stair (<= 0.85 m wide, height = apron); two red corner stools and a
   galvanised spit bucket UNDER the apron corners - real CC0 models (Kenney Furniture / Quaternius), never coloured boxes.
3. Trim strips (0.08 m, #22252A) on every floor-material boundary + a soft contact darkening where floors meet the walls.
4. Bag-line floor: faded footwork drill markings (2.5 m squares, #F4E8C1 at 65%) + a ball/rope rack; agility ladder to real size
   (rungs 0.45 m wide, 0.40 m apart); speed-bag posts 75 mm steel + a 0.60 m rebound drum.
5. Roof beams: raised out of the camera's view or thinner open truss, steel grey #3E444C, cast_shadow OFF.
6. Lights: continuous linear strip lights (4200 K, #F5EEDB) instead of round spot pools; ambient fill so no wall zone goes dark;
   ring keyed from 4 corners (5000 K).
7. Materials: rubber roughness 0.88-0.90, ring canvas 0.94 (no plastic gloss).
8. SSAO on (radius 1.2, intensity 2.0) + contact shadows under rack/bench/treadmill feet.
9. Life (cheapest 2 only now): the timer ticking (item 1) + a slow sway on 2 heavy bags (sin, 0.75 deg).
10. Gear: one bench on the east wall with 2 real water bottles + a pair of gloves; a chalk stand by the platform (real models).

## NOT TAKEN / CORRECTED
- "DEV JUMP 303" is the player's own gym name (the test save's), not debug text: the club-name sign the operator approved in round 5
  stays; Ludo's check 1 is replaced by "no dev text other than the club's own name".
- Ceiling fan, boombox, gym cat: backlog (nice, not needed for the demo look); the bell sound waits for the audio pass.
- Light values in "lux" are Ludo's units; Godot light energy is tuned on the stills, judged by check 9 (no dark zones).
