# U179 — Station prop census (equipment catalogue ↔ 3D)

**Population:** all 25 rows in `Godot/assets/data/equipment_catalog.json` (1 m floor cells).  
**Pack measured:** `Godot/assets/vendor/polyronin_old_school_gym/old-school-gym-equipment-1.fbx` (27 mesh nodes, strength-room set only — no bags, bikes, mats, or recovery props).  
**Ring:** `Godot/assets/venues/mma_arena/` (approved; not in the polyronin FBX).  
**Instrument:** `Godot/tools/u179_prop_census.gd` via `FBXDocument` (`FightClipRetarget._load_fbx`), headless list + `docs/previews/u179/contact_sheet.png` on a 1 m grid.

## Unit check

FBX import is **metre-scale** (longest pack extent 2.87 m on `DumbbellsRack`; a 2.2 m bar length is plausible). No centimetre rescale applied. Wrong-thing proxies (e.g. bench as physio table) are **NO MATCH**, not FITS.

## Pack mesh inventory (metres)

| Mesh | Size X×Y×Z | Footprint X×Z |
|------|------------|---------------|
| Bar1 | 0.09×0.09×2.20 | 0.09×2.20 |
| Bar2 | 0.08×0.08×1.20 | 0.08×1.20 |
| Bench | 0.41×0.48×1.82 | 0.41×1.82 |
| BenchPress | 1.34×1.46×1.99 | 1.34×1.99 |
| Dumbbell1–10 | 0.10–0.19 m wide | small loose props |
| DumbbellsRack | 2.87×0.90×0.65 | 2.87×0.65 |
| Kettlebell1–3 | ~0.15–0.21 m footprint | — |
| LegPress | 1.89×1.33×2.76 | 1.89×2.76 |
| Plate1–5 | plates | — |
| PlatesRack | 0.76×1.22×0.54 | 0.76×0.54 |
| PullUp-Dips-Abs | 1.49×2.30×1.35 | 1.49×1.35 |
| SquatRack | 1.74×2.30×1.15 | 1.74×1.15 |

## Catalogue pairing

| id | Footprint (cells) | Matched mesh | Mesh footprint (m) | Verdict | Tier variant in pack |
|----|-------------------|--------------|--------------------|---------|----------------------|
| club_ring | 4×4 | **mma_arena** scene | ring/cage authored | **FITS** | — |
| heavy_bag | 1×2 | NONE | — | NO MATCH | — |
| speed_bag | 1×1 | NONE | — | NO MATCH | — |
| focus_mitts_locker | 1×1 | NONE | — | NO MATCH | — |
| compact_weights | 2×2 | DumbbellsRack | 2.87×0.65 | **RESCALE** | SquatRack (tier 2), PlatesRack + plates (tier 1 clutter) |
| cardio_floor | 2×2 | NONE | — | NO MATCH | — |
| first_aid | 1×1 | NONE | — | NO MATCH | — |
| double_end_bag | 1×1 | NONE | — | NO MATCH | — |
| exercise_bike | 1×2 | NONE | — | NO MATCH | — |
| physio_table | 2×1 | NONE | — | NO MATCH | — |
| mobility_stretch_station | 2×1 | NONE | — | NO MATCH | — |
| air_bike | 1×2 | NONE | — | NO MATCH | — |
| cold_water_tub | 2×2 | NONE | — | NO MATCH | — |
| rowing_ergometer | 1×2 | NONE | — | NO MATCH | — |
| rehabilitation_pool | 4×3 | NONE | — | NO MATCH | — |
| sports_medicine_room | 3×2 | NONE | — | NO MATCH | — |
| modular_combat_mat | 2×2 | NONE | — | NO MATCH | — |
| judo_tatami_area | 2×2 | NONE | — | NO MATCH | — |
| grappling_dummy | 1×1 | NONE | — | NO MATCH | — |
| striking_safety_locker | 1×1 | NONE | — | NO MATCH | — |
| capoeira_roda_kit | 2×2 | NONE | — | NO MATCH | — |
| arnis_safety_kit | 2×1 | NONE | — | NO MATCH | — |
| footwork_ladder_set | 2×1 | NONE | — | NO MATCH | — |
| plyometric_step_rig | 2×2 | NONE | — | NO MATCH | — |
| reaction_footwork_grid | 3×3 | NONE | — | NO MATCH | — |

**Summary:** **FITS 1** · **RESCALE 1** · **NO MATCH 23**

Contact sheet (`docs/previews/u179/contact_sheet.png`): `compact_weights` → `DumbbellsRack` rescaled into its 2×2 cell outline on a 1 m grid. Ring uses the arena scene, not the polyronin palette.

## CC0 / free sources (NO MATCH only — links, not downloaded)

| Station | Suggested source |
|---------|------------------|
| heavy_bag, speed_bag, double_end_bag | [Kenney — Sports pack](https://kenney.nl/assets/sports-pack) (CC0); [Quaternius — Ultimate Animated Animals](https://quaternius.com/) has no bags — prefer [Poly Haven models search “punching bag”](https://polyhaven.com/models) |
| focus_mitts_locker, striking_safety_locker | [Kenney — Sports pack](https://kenney.nl/assets/sports-pack) shields; [ambientCG — Storage](https://ambientcg.com/list?type=Model&category=Tools) lockers |
| exercise_bike, air_bike, rowing_ergometer | [Kenney — Sports pack](https://kenney.nl/assets/sports-pack) bike; [ambientCG — Bicycle](https://ambientcg.com/view?id=Bicycle001) |
| cardio_floor, footwork_ladder_set, reaction_footwork_grid | [Kenney — Sports pack](https://kenney.nl/assets/sports-pack) cones/lanes; floor decals via [ambientCG — Tiles](https://ambientcg.com/list?type=Material&category=Tiles) |
| plyometric_step_rig | [Kenney — Platformer kit](https://kenney.nl/assets/platformer-kit) boxes (CC0) |
| first_aid | [Kenney — Hospital kit](https://kenney.nl/assets/hospital-kit) cabinet (CC0) |
| physio_table, mobility_stretch_station, sports_medicine_room | [Poly Haven — Bed](https://polyhaven.com/a/bed_01); [ambientCG — HospitalBed](https://ambientcg.com/view?id=HospitalBed001) |
| cold_water_tub | [ambientCG — Bathtub](https://ambientcg.com/view?id=Bathtub001) (ice tub stand-in) |
| rehabilitation_pool | [Poly Haven — Pool](https://polyhaven.com/models?q=pool) |
| modular_combat_mat, judo_tatami_area, capoeira_roda_kit | [Kenney — Sports pack](https://kenney.nl/assets/sports-pack) mats; [ambientCG — Carpet](https://ambientcg.com/list?type=Material&category=Carpet) for tatami colour |
| grappling_dummy | [Quaternius — Ultimate Animated Characters](https://quaternius.com/) mannequin; [Poly Haven](https://polyhaven.com/models?q=dummy) search |
| arnis_safety_kit | [Kenney — Weapon pack](https://kenney.nl/assets/weapon-pack) padded trainers (CC0) |

## Reproduce

```text
python Godot/tools/check_scripts.py Godot/tools/u179_prop_census.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/u179_prop_census.gd
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/u179_prop_census.gd -- render=1
```
