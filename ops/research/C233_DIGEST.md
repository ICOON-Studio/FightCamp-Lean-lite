# C233 Digest - K82 Floor and Lobby to Concept

## Training Floor (tier 1)

| K82 Item | Status | Notes |
|----------|--------|-------|
| 1. Warm key light with shadows | **done** | Sun: #FFB561 at 1.4 energy, -25° elevation, -70° azimuth, shadows on. Fill: #8FB4D9 at 0.35. |
| 2. Pull zone rectangles back | **done** | Zone alpha reduced to 0.12. Floor labels: 12px min, white at 70% opacity, outline reduced. |
| 3. Concrete floor | **adapted** | Existing C225 concrete shader already provides worn concrete with stains. K82's stain decals around bags/ring are covered by the existing scuff/tape system. |
| 4. Cinder-block back wall | **done** | New cinder-block shader (#8B8F92 with #6A6E70 mortar lines every 0.4m) on BackWall. Brick shader kept on LeftWall, RightWall, FrontWall. |
| 5. Duct-taped heavy bags | **done** | Two cylinders 0.38m wide × 1.0m high, #7A4B2A, at 1.5m and 2.7m from right wall, 2.0m from back wall. Silver tape band (#B8BCC0) at mid-height. Chains to ceiling. Black rubber mat (#1F1F1F) under first bag. |
| 6. Skipping ropes and poster | **done** | Two thin cylinders 0.02×0.8m, #C62828, on hook 1.6m up, 1.0m from left corner. B&W poster box 0.6×0.9×0.01m, 1.4m up, 0.5m right of ropes. |
| 7. Admin corner | **done** | Folding table 1.2×0.75×0.6m, #EDEDED, in back-right corner 0.3m from each wall. Chair #6C7A89 tucked under. Green crate 0.7×0.4×0.4m #5B6B4A beside. Notebook and water bottle on top. |
| 8. Window light and pendant lamp | **done** | Light patch 1.2×1.2m #FFD9A0 at alpha 0.5 on floor near right edge. Pendant lamp (0.3m cylinder, emissive #FFE6B0) at 2.8m over centre, switched off (energy 0). |

**Keep unchanged:** ring, stationary bike, fighter models, bench with towel and bottle in bottom-right corner, doorway positions. ✓

## Lobby

| K82 Item | Status | Notes |
|----------|--------|-------|
| 1. Turn labels into real objects | **adapted** | Existing lobby already has real objects (trophy shelf, photo wall, desk, bench, merch rack). Floating labels are game-state driven (honours, to-come). Kept as-is. |
| 2. Awards wall behind desk | **done** | New K82AwardsWall: shelving 2.4×0.35×2.2m, #3A3028, against left wall 0.4m from back corner. Three shelves with gold trophy cylinders (#D4AF37) and belts (#1C1C1C with #D4AF37 plates). |
| 3. Reception desk | **done** | Desk counter colour changed to #3B2A1E. White fighter silhouette decal (0.8×0.5m) added to front face. |
| 4. Wall of fame | **done** | New K82WallOfFame: eight portrait frames 0.35×0.45m each, 2×4 grid on back wall, 1.4m up with 0.12m between frames. Fighter silhouettes with record plates (18-4-0 style). |
| 5. Floor and lighting | **done** | Floor tiles 0.8m square in #4A4D52 with 0.02m grout in #35383C. Warm key #FFB561 at 1.4 and cool fill #8FB4D9 at 0.35 (inherited from TrainingFloor3D K82 lighting). |
| 6. Waiting bench with people | **adapted** | Existing bench with prospects already present. K82's bench position (0.5m from back wall, centred under wall of fame) conflicts with existing bench position. Kept existing. |
| 7. Merch shelf and fight board | **done** | New K82MerchAndBoard: wooden shelf 1.2×0.35×1.8m, #A47448, against right wall 0.4m from back corner. Towel, glove, shirt on shelves. Corkboard 1.6×1.0×0.03m, #B08B5A, 1.2m up with 3 poster boxes. |
| 8. Small finishers | **done** | New K82Finishers: planters (0.35m cube, #555B60 with green cone plants) on each side of desk. Trash can and water cooler already present from U199. |

**Keep unchanged:** door labels OUT TO THE CITY and THE TRAINING FLOOR, top status bar and rail, THE DESK hire panel with HIRE A DESK HAND button, sofa and bench figures. ✓

## Tests

- Parse gate: PASS (both TrainingFloor3D.gd and Lobby3D.gd)
- training_floor_3d_test.gd: PASS (0 failures)
- gym_floor_layout_test.gd: PASS (0 failures)
- smoke_test.gd: PASS (0 failures)

## Stills

- `previews/c233/floor.png` - training floor after K82
- `previews/c233/lobby.png` - lobby after K82
