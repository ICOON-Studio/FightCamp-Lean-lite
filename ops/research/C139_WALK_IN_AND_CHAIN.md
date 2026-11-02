# C139 — walk-in and chained transforms

## Result

The C139 harness is parse-clean and contains the requested motion grammar:

- each fighter starts on the existing room spawn side;
- both use the bound `loc_advance` walk at the measured 1.736 m/s;
- the opening gap is derived as 1.087 m from the two fighters' reach-aware preferred ranges;
- the bow is a procedural hinge on `Spine` and `Chest`, 22 degrees forward, AUTHORED;
- `Head` is not counter-rotated, so it follows the torso hinge;
- the six paired beats carry the previous beat's live root transforms;
- camera cuts remain one-at-a-time inside the existing 180-degree grammar;
- a named two-second quad-replay cut is reserved to beat 4 only and cannot span a join.

## Join measurements

| join | before (m) | after (m) | gate |
|---|---:|---:|---|
| 1 → 2 | 1.5624 | 0.0000* | < 0.20 m |
| 2 → 3 | 0.3195 | 0.0000* | < 0.30 m |
| 3 → 4 | 0.3224 | 0.0000* | < 0.30 m |
| 4 → 5 | 0.1513 | 0.0000* | < 0.30 m |
| 5 → 6 | 0.9458 | 0.0000* | < 0.30 m |

\* Expected from the carry-root implementation and alignment correction; the host did not complete the live movie run, so these after values are not claimed as captured evidence.

The before table is the delivered C138 evidence. The duplicate 1.5624 m / 1.5731 m displacement is the transform reset plus the next film's travel.

## Authored versus measured

Measured: 1.736 m/s `loc_advance` stride speed; 1.087 m opening gap; C138 source/live travel, pair clock, and before joins.

AUTHORED: the 22-degree `Spine` + `Chest` hinge and its 1.2-second bow timing. No contact pose was re-authored. The glove-touch seam is the existing `FightContactSolve` / `FightLegIK` world-target path.

## Capture limitation

`check_scripts.py` passes for the new harness. The available Godot headless host assembled the room but did not advance the SceneTree capture callback, and the movie writer could not produce MP4. Therefore no recording hash or visual pass is asserted; this is the remaining operator-visible gap.
