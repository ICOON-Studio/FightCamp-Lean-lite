# MGT2 scale study (S288): why its rooms feel bigger and its objects sit better

**Operator S288:** "why mgt2 rooms feel bigger and the objects better inside the rooms ?"
**Rule (S243/S277):** numbers only. Nothing from MGT2 (code, art, text) goes into the repo.

**Method:** the operator's install (`E:\SteamLibrary\steamapps\common\Mad Games Tycoon 2`), UnityPy 1.25.3 on `sharedassets2.assets`.
Each prefab's size = mesh local AABB × the scale of every transform up to its root (MeshFilter). People come from
SkinnedMeshRenderer meshes. Blender export, so the third axis is height. Scripts and dumps are in `E:\FightCamp\tmp\mgt2_scale`
(outside the repo). The game was never launched. **Not measured:** the camera (FOV/ortho, distance). That is the next read.

## MGT2, in its own units (1 floor tile = 1.00 × 1.00)
| Thing | Size (w × d × h) | In person heights (person = 1.29) |
|---|---|---|
| Floor tile | 1.00 × 1.00 | 0.78 |
| Person (all 19 bodies) | T-pose span 1.11-1.13, **height 1.29** | 1.00 |
| Wall / wall edge | height **1.50** | **1.16** |
| Door | 1.00 wide, 1.40 high | 1.09 |
| Work desk (DEV/QA/RES/SUP/GFX) | 1.38-1.56 × 0.59-0.63 × 0.82-1.08 | width 1.07-1.21 |
| Sound desk | 3.02 × 0.81 × 0.86-0.95 | 2.34 |
| Big cabinet (Schrank1) | 1.08 × 0.32 × 1.41 | height 1.09 |
| Bench (Sitzbank) | 1.40 × 0.56 × 0.86 | |
| Plant | 0.36-0.53 wide, 0.46-1.32 high | |
| Rug (Teppich) | 1.2-2.5 × 1.1-3.0 | |
| Smallest room | 3 × 3 tiles (2 × 2 stockroom, 5 × 5 mocap/production) | 2.3 × 2.3 |
| Capacity | 1 person per 3.3 tiles | |

## Ours (metres, person ≈ 1.75-1.80 m)
| Thing | Size | In person heights |
|---|---|---|
| Room wall height (`gym_club.json` room.wall_h) | **3.6 m** | **2.0** |
| Front room depth (all five rooms) | 4.5 m | 2.5 |
| Front room widths | 3.6-7.4 m (16-33 m²) | |
| Items per room | 7-12 (reception 7, office 12, lockers 11) | |
| A real desk (true scale) | ~1.5 m wide | ~0.85 |

## What the numbers say
1. **Our rooms are NOT smaller.** In person heights, MGT2's 3 × 3 minimum is 2.3 × 2.3 and our 4.5 m-deep front rooms are 2.5 deep.
   The difference is how they read on screen, not their area.
2. **MGT2 walls are low: 1.16 person heights, against our 2.0.** A wall that only just clears the people never hides the floor
   behind it, so the whole room is visible from any angle. Ours are 1.7× taller relative to the people.
3. **MGT2 furniture is oversized against its people.** A desk is 1.07-1.21 person heights wide, where a true-scale desk is about
   0.85. Every object is about 1.3-1.4× "real" next to a body, so each piece reads at a glance and fills its tiles.
4. **Every MGT2 object sits on the 1-tile grid** (a desk = 1.5 tiles, a cabinet = 1 tile). Pieces line up, walls and aisles stay
   straight, and the room reads as tidy. Ours are placed freely at true scale.
5. **Most MGT2 room objects are a workplace**: one desk = one worker, with a capacity of 3.3 tiles per person. A room reads as
   busy with purpose. Ours mix 1-2 working pieces with small true-scale dressing (phone, bell, coat stand, notice board),
   which reads as specks at the gym camera's distance.

## Open, for Ludo (D39 LUDO FIRST) - not decided here
- Wall height in the rooms (cutaway or a lower wall), prop scale against bodies, a grid snap for room furniture, and fewer but
  bigger dressing items. Send our reception + locker room stills from the game camera next to these numbers.
- Measure MGT2's camera (cameraMovementScript fields) before any camera change.
