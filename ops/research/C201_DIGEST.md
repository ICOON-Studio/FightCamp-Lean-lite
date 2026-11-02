# C201 digest ? one rig definition, per-body proportions

A studio shares one skeleton definition/asset: names, hierarchy, joint axes and units. In Blender each body keeps its own joint positions/lengths and inverse bind matrices; in Unreal compatible skeletons/IK retargeting preserve target proportions and scale translation/hip motion. It does not force every body onto the reference man's limbs. Q125_UNREAL_PROPORTION_RETARGET.md documents the target-length and pelvis-height translation policies from Unreal source. C201 therefore locks orientation + names + units, while retaining each body's proportions.

## Delivered and corrected finding

C200's ?differs on 22 bones? was an exact Transform3D comparison, including translations. Independent raw-GLB inspection of all 22 joints on all twelve originals proves that their local orientations were ALREADY identity. The original claim did not demonstrate eleven axis mismatches. Nine non-reference bodies therefore pass the new convention already; f06/f08 need metre scaling. The new exports are explicit, reproducible Blender 5.2.1 exports, not a claim of a visual axis repair where none was necessary.

- Amended C200 spec and importer: STRICT names/parents, identity local bases within 0.5 degrees, unit scale, metre stature and geometric axis/origin checks; PER-BODY translations/lengths and stature 1.55?2.05 m. f01 SHA256 lock unchanged.
- All prior contract mutants retained. Added correct-length forearm with 30-degree rotated rest basis (REFUSED) and positive per-body length witness (ADMIT).
- Eleven new `<original_stem>_v1.glb` assets. Original live GLBs, live bindings and FightClipRetarget.gd unchanged.
- f06/f08 use the authorized 1.75 m fallback. FightWorldLiveScreen.gd:career_mesh chooses reusable bodies by sex/ruleset/weight; no fixed athlete identity/stature is bound to these assets.

## Admission table (raw GLB through Godot)

| Name | Stature m | Max basis error degrees | Admission |
|---|---:|---:|---|
| f01_m_box_welter_rigged.glb | 1.850000 | 0.000000 | ADMIT |
| f02_m_box_heavy_rigged_v1.glb | 1.850000 | 0.000000 | ADMIT |
| f03_f_box_fly_rigged_v1.glb | 1.750000 | 0.000000 | ADMIT |
| f04_f_box_middle_rigged_v1.glb | 1.750000 | 0.000000 | ADMIT |
| f05_m_mma_light_rigged_v1.glb | 1.850000 | 0.000000 | ADMIT |
| f06_m_mma_lhw_rigged_v1.glb | 1.750000 | 0.000000 | ADMIT |
| f07_f_mma_straw_rigged_v1.glb | 1.750000 | 0.000000 | ADMIT |
| f08_f_mma_bantam_rigged_v1.glb | 1.750000 | 0.000000 | ADMIT |
| f09_m_bare_welter_rigged_v1.glb | 1.850000 | 0.000000 | ADMIT |
| f10_m_bare_heavy_rigged_v1.glb | 1.850000 | 0.000000 | ADMIT |
| f11_f_bare_feather_rigged_v1.glb | 1.750000 | 0.000000 | ADMIT |
| f12_f_bare_welter_rigged_v1.glb | 1.750000 | 0.000000 | ADMIT |

## Skin and bind proof

Blender reconstructs each bone's global orientation, keeps its original joint head and bone length (both scaled by 1.75 for f06/f08), clears pose offsets, and exports inverse binds for the new rests. Children are positioned from saved global joint heads, not inherited stale local offsets. Mesh world positions and weights are verified before export.

The exporter pruned tiny influences (measured maximum weight error 0.000191 on f02), so c201_preserve_weights.py restores the original float weights and their named joint assignments in the Blender-exported GLB. No topology/material changes are introduced by that pass. c201_skin_verify.py then independently re-imports each source and output, clears imported animation poses and excludes bone-display helper meshes. It compares evaluated skin geometry bidirectionally and weights by joint name at matching vertices.

Final eleven-body re-import verification: maximum world vertex discrepancy **3.58867482e-07 m**, maximum skin-weight difference **0.0**. Exported vertex counts match for every body. Maximum world joint position discrepancy **2.14462663e-07 m**; maximum component error in global-rest ? inverse-bind identity **2.33561483e-07**.

## Moving-picture evidence

[854?480 old versus v1 MP4](_captures/watch_loop/c201_f03_old_vs_v1.mp4): 90 frames at 30 fps, 3 seconds. First 15 frames show rest; the RamsterZ `H2H_HitReaction01.FBX` react_head window 2.47?3.03 s follows in slow playback, using the unchanged live silhouette retarget/hip-carry path independently for each body. Rendered through Tools/godot_hidden.ps1; no --position. Inspected rest, mid-reaction and late reaction PNGs and a decoded frame from the final MP4.

What differs: Blender export serialization and tiny floating-point mesh/rest differences; no visible change to f03's proportions, stance or reaction motion, and no folded skin. This is expected because its original axes were already canonical. The video is evidence of intact skin during motion, not a claimed animation-quality improvement or live-game swap.

MP4 MD5: `411ed6130314e9f9d108d4486be3d2ee` (243800 bytes).

f03_v1's canonical-f01 correction table is **0.000000 degrees for all 22 bones**, as is f03 old. Source UE4 silhouette corrections are a different table and are NOT near identity: e.g. Hips 127.491724?, LeftHand 179.358664?, RightHand 6.739299?. Keeping them is necessary to interpret the source rig. c201_validate_render.gd prints both tables, bone by bone.

## Gates and environment

- Parse: all 3 touched/new .gd scripts, CHECK total=3 fails=0.
- Exact requested gate: `python Godot/tools/run_tests.py --only rig_convention,clip_retarget,cascy,fight_clip,fight_world_live` ? SUITE total=12 fails=0.
- Contract: 39 checks / 0 failures. The bound RamsterZ pose SHA256 remains `83f6a766b4dc398d3abda6526f58692f3c4925f680fc4fbe0300654c7289f9ea`.
- Admission: 12/12 ADMIT. Export and re-import skin/bind checks: 11/11.
- Ran the prescribed headless --import ONCE before tests. It exited 1 because Godot's headless Blender import path was unset; font imports were therefore incomplete. Recovered by copying the existing checkout's generated .godot/imported cache into this worktree. Class registration had completed. This environmental failure is not counted as a test result; the subsequent exact gate passes. Import-generated font sidecars and unrelated UIDs are excluded from the commit.

## Reproduce

From the worktree root, with Blender 5.2.1 and Godot 4.7.2:

```powershell
# Refuses existing _v1 destinations; use a clean worktree to regenerate.
& 'C:/Program Files/Blender Foundation/Blender 5.2/blender.exe' --background --factory-startup --python Tools/blender/c201_rebind.py
python Tools/blender/c201_verify.py
& 'C:/Program Files/Blender Foundation/Blender 5.2/blender.exe' --background --factory-startup --python Tools/blender/c201_skin_verify.py
python Godot/tools/check_scripts.py tools/import_fighter_clip.gd tests/rig_convention_contract_test.gd tools/c201_validate_render.gd
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/c201_validate_render.gd
# Encode .godot/c201_frames/%04d.png at 30 fps using libx264, CRF 18,
# yuv420p and +faststart into the delivered MP4.
```

Task-specific fresh worktree and no-HANDOFF rules superseded generic shared-master startup/HANDOFF rules. No HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md reads/edits. No prohibited body-model tooling. No live switch: S76/operator review owns that decision.

## Final export SHA256 receipts

| Asset | SHA256 |
|---|---|
| f02_m_box_heavy_rigged_v1.glb | `28d0d65ea72c0cddd1efa1b2679e7ce01688e87d131c0839db55e8b3d4c65387` |
| f03_f_box_fly_rigged_v1.glb | `a8e35db8daa0ee65f94357dc5d43c44214196bd09f9da77110d9e65d4290212f` |
| f04_f_box_middle_rigged_v1.glb | `f22372363d966eb79bd2d43eae8c8fe41354c98390db80083f476f7f7fa243f7` |
| f05_m_mma_light_rigged_v1.glb | `5e51071f9a52b9c94036cff0d91602a321f942819166b0b9f13d8e17294cd07b` |
| f06_m_mma_lhw_rigged_v1.glb | `d1910199d29f75644e59b6722819f10926881c018481833306194972d8f2b22f` |
| f07_f_mma_straw_rigged_v1.glb | `218c4f32c243289e1faad834857438da5a80028fb95b5f930e957dedd34858ef` |
| f08_f_mma_bantam_rigged_v1.glb | `8f9fede8f29b18b9b9040b756f88a00f94f638da94e7134e1928ba8239d7d3af` |
| f09_m_bare_welter_rigged_v1.glb | `876c449b2a868586e2ac9f65b9e8f5d979a6f421b56f21a083de58598c7fed60` |
| f10_m_bare_heavy_rigged_v1.glb | `0d073bc0936dc32b9eb0631488917dc029253c0cb92c2afa414b5f1015724f2b` |
| f11_f_bare_feather_rigged_v1.glb | `692cc4a73aba495776b4130021b809de5b9bda543223afad0d4fac3ec1e8ffc1` |
| f12_f_bare_welter_rigged_v1.glb | `855b51b01246d858d4f36aaca8e9a8a7ef1a0f00033c1e3c8c493ccb8df149fb` |
