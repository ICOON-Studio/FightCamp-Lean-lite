# Two Point Museum - how it configures camera, walls and placement (S243 study)

Operator S243: "there is 2point museum installed if you want to reverse engineer things and use in our game", then "there are tools to
help you decompile , we are not copying anything do it". Read from the operator's own install (E:\SteamLibrary\steamapps\common\Two
Point Museum, Unity 6000.0.63f1 IL2CPP) with UnityPy 1.25.3 (already on the PC): identifier names from il2cpp global-metadata.dat and
the typetrees of the shipped config ScriptableObjects (StreamingAssets/aa/.../configs_assets_all.bundle). NUMBERS AND RULES ONLY:
no model, texture, sound, text or code of theirs enters the repo; the raw dumps stay outside it in E:\FightCamp\tmp\tpm_study.
Every FightCamp implementation is written by us from these facts.

## Camera (Config_CameraLogic)
- Perspective, FOV 17 deg (a telephoto near-orthographic look), near 5 / far 500.
- Pitch clamped 35..90 deg down; pitch auto-offset by zoom (curve ~ +21 deg at the near end to 0 at the far end).
- Initial yaw 235; FREE yaw (keys 90 deg/s, mouse drag 4.0/2.0 speed); smoothing 0.03-0.1 s.
- Height 20 m (nearest) to 280 m (furthest; consoles cap 146 m); pan 15 m/s scaled 0.5x..4x by zoom.

## Walls (identifiers in the IL2CPP metadata)
- `ShowBackfaceWallsOnly`, `RequiresBackfaceWallUp/Down` - far walls drawn by their back face (the inside we see).
- `SetWallShaderToTransparentMode` - camera-facing walls go transparent (we keep a stub instead - Ludo r109/r110).
- `WallHeightForItemPlacement` / `WallHeightForSelection` separate from the visual height - a cut wall still takes wall items at
  their real height. `Config_CeilingOccludersManager` occludes ceilings separately. `Config_BuildLogic.CeilingHeight` = 6 m.
- Blueprint walls come in 1 m and 2 m segments (PF_Build_Blueprint_*_1m_Int/Ext, *_2m_*).

## Items (1,600 item definitions, Item_*.asset)
| Field | Distribution |
|---|---|
| GridSnap | 0.5 m on 1,394 (87%), 1.0 m on 83, 0.25 m on 43, 0.1 m on 35, 16 m on 32 (big plots), 2.0 m on 10 |
| RotationSnap | 45 deg on 1,179 (74%), 90 deg on 363 (23%), 10 deg on 34, 22.5 deg on 24 |
| AllowFreePlacement | 1,599 of 1,600 (Tab toggles grid/free while holding an item) |
| WallType | 0 (floor) on 1,576; wall-hung types 4/6/7 on 24 |
Each item also carries Cost, Prestige (e.g. 0.6), CanBeSold, SinglePlaceOnly, AffectsNavigation, RemoveWalls, a list of
validators, nav-obstacle size overrides and SideOffsetForDoorReachability.

## Rooms (29 Room_*.asset)
- Minimum size in cells: bathroom 2x1; marketing, research 2x2; staff room, camera room, staff training 3x2; plot 3x3; cafe, gift
  shop, aquarium 4x3; analysis, lecture, studio, vet, workshop 4x4; habitat, building 5x5.
- RequiredItems list per room (room not valid until each is placed and reachable), BaseCapacity, CapacityPerCell.
- MaxPrestigePerCell 30-48 (0 = none), PrestigePerExtraCell (plot 0.75).
- Cost 5,000 flat or CostPerCell (aquarium 75, +75 past 40 cells; building 100/cell), RefundMultiplier default 1.0 (100%).
- Flags: AllowMainAreaMove (pick up and move a room), AllowRenovations (add/remove tiles), AllowCustomisation, AllowAnyWindows,
  DisallowCopying/Templating (rooms copy and save as templates), AllowRoomClosure.

## Build flow (Config_BuildLogic)
- Rooms are dragged out as blueprints with a size measurer; 1-tile gap around buildings; construction over time (walls grow
  20% -> 95% scale over 2 s, a construction effect 2 s).
- Invalid reasons are shown on the cursor: "Invalid position for {ITEM}", "Unaffordable", "{ROOM} must be placed in a building",
  "Can't build across different plots", "Can't build on a plot you don't own".
- Sellable items fade to alpha 0.35; blocking items flash 0.75-3 s; reachability checks capped (80 per frame).

## Used where
- ISOWALL1 (S243): cutaway on 90-degree steps (TPM is free-yaw + transparent; Ludo r110 C1 keeps steps + stub for live play, free
  yaw only in build mode).
- PLACEMENT1 verdict (research/PLACEMENT_VERDICT_S243.md): 0.5 m grid, 90/45-degree snaps, room minimums, prestige cap per cell,
  100% refund while building.
