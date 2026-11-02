# MH1 - the MetaHuman pilot (D29), 2026-10-01

Operator ruling D29 (verbatim): "hybrid, start the metahuman pilot and assign codex to constantly work on animations
(blender or cascadeur) and someone working on missing gated items". The pilot proves ONE MetaHuman fighter end to end
before a library is built. Branch `claude/mh1-metahuman-pilot` (worktree E:/FightCamp/wt/MH1). Raw work on
E:/FightCamp/metahuman_pilot (UE project, FBX exports, DDC, frames) - nothing on D: (failing drive).

## Verdict in one paragraph

**UPDATE 2026-10-02: the operator installed Core Data; see "Core Data pass" below - the look now reads as a real
man (preset face, synthesized skin, brush-cut hair cards, brows). The paragraph here is the first pass.**


The PIPELINE passes: a MetaHuman Creator character made by script in UE 5.8.2, exported, cut to 47.7k triangles,
imported into Godot, plays our certified boxing jab through the PRODUCTION player (FightStagePlayer, same
grafts, same retarget) in the ring with gloves and trunks, and two of them cost 5.0 ms a frame at 1920x1080
(199 fps uncapped; the MPFB control arm: 4.6 ms). The LOOK is blocked: this PC's UE install lacks the
"MetaHuman Creator Core Data" option, so the Creator has NO skin texture synthesis, NO presets and NO hair/brows.
The face geometry is real MetaHuman; the skin on it is a placeholder tone I generated. Next to today's MPFB man
(portrait_vs_mpfb.png) the MetaHuman reads as a smooth mannequin with a fine face, not yet as a photoreal boxer.
One launcher checkbox (below) unblocks it; every script here re-runs unchanged afterwards.

## What the operator must do (one action)

Epic Games Launcher -> Unreal Engine -> Library -> the UE 5.8 tile -> the down-arrow -> **Options** -> tick
**"MetaHuman Creator Core Data"** -> Apply. (It downloads to the engine folder on C:.) Evidence it is missing, from
the UE log of every run: `LogMetaHumanCharacterEditor: Warning: MetaHuman Optional Content folder not found.
MetaHuman Creator plugin initialized with limited features.` and `Texture synthesis data directory
.../MetaHumanCharacter/Content/Optional/TextureSynthesis/TS-1.3-F_UE_res-1024_nchr-153 does not contain valid data`
-> `skin editing will be disabled`. The synthesized face textures came back 128 px placeholders.
Not needed for the game and NOT done (needs his Epic sign-in, cloud services): Auto-Rig (facial rig) and
"Download Texture Sources" (high-res 2K-8K skin). Core Data alone gives local 1K face synthesis, presets and grooms.

## Deliverables

| # | What | Result | File |
|---|------|--------|------|
| 1 | Male athletic MetaHuman by script, exported, ~30-60k tris, PBR | PARTIAL: body/face/eyes/teeth/lashes yes, 47,664 tris, 341 joints; skin = placeholder (Core Data), no hair, no brows | `Godot/assets/models/metahuman/mh_pilot_01.glb` (2.5 MB) |
| 2 | Imported into Godot, SSS skin, eyes + hair correct | PASS for skin shader (sss_mode_skin + tiled MetaHuman pore normal) and eyes (MetaHuman sclera + iris, clearcoat); hair: none (shaved; grooms need Core Data) | `scripts/MetaHumanRig.gd`, `assets/models/metahuman/mh_skin.gdshader` |
| 3 | Portrait 105 mm 3/4 + side by side with MPFB | PASS technically (FighterPortrait's own studio); LOOK FAIL - untextured skin, no brows, face reads androgynous (default archetype face, no presets) | `docs/previews/mh1/portrait.png`, `portrait_vs_mpfb.png` |
| 4 | MetaHuman plays a certified clip in the ring, game camera, silent MP4 | PASS: guard idle + `boxing_jab` twice, broadcast camera yaw 35, MPFB opponent at RANGE_M.MID, gloves + trunks, 1280x720 30 fps, no audio stream | `docs/previews/mh1/jab.mp4` (5.1 s) |
| 5 | Frame time, two MetaHumans, venue, 1920x1080, 10 s | PASS: avg 5.02 ms, worst 29.2 ms, p99 24.2 ms, GPU avg 3.74 ms (RX 6800 XT, Forward+, Iron Parish via VenueRig, MSAA 4x + FXAA, uncapped). Control arm 2x MPFB: avg 4.56, worst 27.7, p99 23.3. With the project's 60 fps cap: 16.67 avg, 20.8 worst | `docs/previews/mh1/perf.json`, `perf_control_mpfb.json`, `perf_frame*.png` |
| 6 | This digest | - | - |

The p99/worst spikes (~24-29 ms) are the same in both arms (clip starts every 35 frames); they are not MetaHuman cost.
D29's reopen test ("runs under 60 fps with two MetaHumans in a dressed venue") is NOT met: 199 fps.

## The steps, with the exact commands

UE side (scripts in `Tools/metahuman/`, UE project template in `Tools/metahuman/ue_project/`; the live project is
E:/FightCamp/metahuman_pilot/MHPilot with plugins PythonScript, EditorScriptingUtilities, MetaHumanCharacter,
MetaHumanSDK, GLTFExporter, HairStrands, RigLogic):

1. `bash Tools/metahuman/run_ue.sh <abs path>/mh_build_pilot.py build` - runs
   `UnrealEditor-Cmd.exe MHPilot.uproject -run=pythonscript -script=... -AllowCommandletRendering -unattended -nosplash`
   with `UE-LocalDataCachePath` on E: (the first run compiles ~2 GB of MetaHuman shaders; C: untouched). ~70 s warm.
   The script creates `/Game/MH/MH_Pilot01` (MetaHumanCharacterFactoryNew), sets the parametric body (height 183,
   muscularity +1.4, fat -1.3, masculine -1.6, waist 80, chest 106, neck 40, bicep 36, across-shoulder 41 cm),
   commits a skin tone, spawns the editor actor and exports its Body and Face skeletal meshes (all LODs) to FBX.
2. `python Tools/metahuman/make_textures.py <out>` - placeholder skin from BUNDLED data only (head AO from
   T_MH_BentNormal_AO, lips from the UV region guide), the eye from the bundled sclera + iris, the pore normal.
   When Core Data exists, the UE script exports the synthesized `face_basecolor.tga` and this uses it instead.
3. `blender --background --python Tools/metahuman/bl_build_glb.py -- <export> <textures> <out.glb>` - body LOD1
   (15,196 tris) + face LOD1 (32,468 tris: head, teeth, eyes, lashes; saliva/eye shell/eye edge/cartilage dropped),
   ONE skeleton (the body's 341 UE5 joints; 500 face-only joints folded into `head` - no facial animation in game),
   trunks slot by bind-pose region, metres, Y-up GLB.

Godot side (`Godot/tools/mh1_pilot.gd`, windowed modes via `Tools/godot_hidden.ps1`):

- `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/mh1_pilot.gd -- mode=probe`
- `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/mh1_pilot.gd -- mode=portrait`
- `... -- mode=video` then `python Tools/metahuman/mh1_encode.py` (frames land in docs/previews/mh1/jab_frames -
  67 MB, NOT committed; moved to E:/FightCamp/metahuman_pilot/jab_frames)
- `... --resolution 1920x1080 ... -- mode=perf fighters=mh` and `fighters=mpfb` (control arm)

## The bone mapping (one map, both rigs)

`MetaHumanRig.UE5_TO_OURS` renames 22 MetaHuman joints to our names IN THE glTF STATE before the scene is built, so
skeleton and skin agree by construction (binds are index-based, checked: 341 binds, 0 named): pelvis->Hips,
spine_01->Spine, spine_03->Chest, spine_05->UpperChest, neck_01->Neck, head->Head, clavicle/upperarm/lowerarm/hand,
thigh/calf/foot/ball -> Left/Right... (+30 finger joints for the glove palm frame and FighterFist). The clip side is
untouched: the same `FightClipRetarget.UE4_TO_OURS` feeds both the MPFB man and the MetaHuman.

THE ONE TRAP, and its fix: `RestFixer.pose_frame` writes each bone's local rotation relative to its nearest MAPPED
parent. On our rigs that is the skeleton parent; on a MetaHuman spine_02, spine_04 and neck_02 sit between mapped
joints, so their rest rotation was silently double-counted. `MetaHumanRig.fold_intermediate_rests` premultiplies
every retargeted key by the inverse rest of the unmapped chain (485 tracks over the 162-clip library).
Measured on boxing_jab, trunk pitch (Hips->Neck vs vertical) per frame against the MPFB control on the same clip:

| | peak lean | max per-frame gap to MPFB |
|---|---|---|
| MPFB control | 29.9 deg | - |
| MetaHuman, folded | 27.5 deg | 10.7 deg |
| MetaHuman, fold OFF (mutant) | 26.3 deg | 13.5 deg |

The probe fails if the peak gap exceeds 5 deg or if the mutant is not worse (it is: the instrument can see the fold).
Residual: the MetaHuman stands ~8 deg more upright IN GUARD (2-3 deg vs MPFB 11-12 deg). Cause: the two rigs' rest
spines differ and UpperChest->Neck is deliberately not a silhouette segment (FightClipRetarget's note). Which of the
two is closer to the source clip is not measured here - next instrument if the library goes ahead.

## What failed or was worked around

- `MetaHumanCharacterExportBlueprintLibrary.export_geometry` CRASHES the commandlet (Slate assert in
  `SyncBrowserToAssets`, no Slate in `-run=pythonscript`). Worked around: export the spawned actor's meshes with
  `AssetExportTask` (FBX). The DCC export (`export_dcc`) needs a rigged character (cloud) + high-res textures (cloud).
- `build_meta_human` refuses: "Character is not rigged" (Auto-Rig = cloud = Epic sign-in). Not needed for the game.
- Normal-map / BakedGroom textures have no TGA exporter (BC5/G8); only colour textures exported.
- FighterPortrait.build_studio runs FighterLook.apply_skin, which overrides EVERY mesh with the MPFB CC0 skin (wrong
  UVs for a MetaHuman); mh1_pilot clears the override and re-dresses. A library would need FighterLook to skip MH.
- Godot's project stretch keeps the root viewport 16:9; the 4:5 portrait renders in its own SubViewport.
- CCFighterSkin is RefCounted: a glove object that goes out of scope disconnects and its gloves freeze at rest.
- FighterPortrait frames on the Head joint; the MetaHuman's head joint sits lower, so the crown is cropped.

## Licence

MetaHuman in Godot: Epic's June 2025 change; cgchannel (2025-06) reports MetaHuman characters "are classed as
'non-engine products'" under the standard Unreal Engine EULA, free under $1M revenue a year. The primary page
(metahuman.com/license) needs an Epic login, so the clause was not read first-hand - confirm before release.
No MatMADNESS shader code was copied (StandardMaterial3D / Godot's own sss_mode_skin), so no attribution is owed yet.

## Next (if the operator ticks Core Data) - DONE 2026-10-02, see "Core Data pass"

Re-run steps 1-3 (+ a preset face via `/MetaHumanCharacter/Optional/Presets`, a short groom's cards LOD for hair and
brows), re-render portrait.png and judge it against portrait_mpfb.png. Library work waits for that verdict.

## Core Data pass (2026-10-02)

Core Data present (Engine/Plugins/MetaHuman 9.7 GB). Evidence from the commandlet (`Tools/metahuman/mh_probe_core.py`,
`mh_probe_core2.py`): face texture synthesis now returns **1024 px** for BASECOLOR/NORMAL/CAVITY (was 128 px
placeholders); 29 presets under `/MetaHumanCharacter/Optional/Presets` (Ada ... Zuri); 38 hair, 18 brow, 16 beard
wardrobe items under `/MetaHumanCharacter/Optional/Grooms/Bindings/*`; groom assets carry `CardsMesh_Group0_LOD0-4`
static meshes + `CardsAtlas_Attribute/Tangent` + `*_baked` textures. Trap: the commandlet's asset registry is empty
until `scan_paths_synchronous(["/MetaHumanCharacter/Optional"])`.

**What changed** (new files only; pass 1 scripts untouched and still re-run):
1. `mh_build_pilot02.py` (UE): duplicates preset **Victor** (his own groom: `Hair_S_BrushCut`, `Eyebrows_M_Dense`)
   to `/Game/MH/MH_Pilot02`, applies pass 1's athletic body constraints (183 cm, chest 106, waist 80 ...), re-commits
   the preset skin (u 0.33 v 0.41) so the synthesizer runs, exports Body/Face FBX, body textures, the cards meshes
   and atlases, the binding info. The synthesized textures are TRANSIENT: TGA and PNG exporters ASSERT fatally
   (EditorFactories.cpp:4610, ImageCoreUtils.cpp:110), DDS fails - they are drawn onto a canvas render target and
   exported with RenderTargetExporterPNG (basecolor) / EXR (normal, cavity). Asset textures go out as uncompressed
   BGRA8 DDS (`MH1_TEXFMT`). `mh_export_groom_heads.py` exports the cards' reference heads alone.
2. `bl_exr2npy.py` + `make_textures02.py`: head albedo = synthesized skin + Victor's baked brush-cut and baked brows
   (face UV, UE's own far-LOD textures); head normal (DirectX -> OpenGL green flip); body albedo = the Creator's
   neutral body detail map tinted to the face skin and **gain-matched at the neck seam** from 65 head-boundary/body UV
   sample pairs the Blender build writes (`seam_uv.json`; gain 0.93; body UVs live in tile u 1..2); card RGBA atlases
   (coverage = Attribute.R, seed = Attribute.B, root->tip = Tangent.A; hair 1024, brows 512, posterized for size).
3. `bl_build_glb02.py` (Blender 5.2.1 at C:/Tools/Blender): pass 1's body/face build + the CARDS. The cards are
   authored on the groom's reference head (bindings: hair on `MH_Groom_Head`, brows on `SKM_Groom_Head_Legacy02`),
   which sits ~23 cm (hair) / ~10 cm (brows) away from this face and is smaller. Refit = UV-paired head vertices
   (24,414 of 24,414 paired) and an inverse-distance displacement field of the 16 nearest; then push-out to 1.5 mm.
   Instrument, control = the unfitted cards on the same face: hair verts inside the face >1 mm **70.1% unfitted ->
   0.04% fitted (9 of 24,444, pushed out)**; brows **34.4% -> 0.0%**. Cards are rigid on `head`.
4. Godot: `MetaHumanRig.dress` gives `MH_Hair*`/`MH_Brows*` an alpha-scissor + alpha-to-coverage, two-sided material and
   passes the glTF normal to the skin shader; `mh_skin.gdshader` blends the synthesized normal with the tiled pores
   (whiteout). `mh1_pilot.gd` defaults to mh_pilot_02 (`glb=mh_pilot_01.glb` for pass 1).

**Numbers.** `Godot/assets/models/metahuman/mh_pilot_02.glb` **5.21 MB (4.97 MiB), 61,698 tris** (body LOD1 15,196 +
face LOD1 32,468 + hair cards LOD2 12,230 + brow cards LOD2 1,804), **341 joints** (500 face joints folded), images:
head albedo/normal 1K JPEG, body albedo/normal 1K JPEG, hair 1K PNG (678 KB), brows 512 PNG. Headless probe passes on
02 (341 bones, 0 missing, 485 folded tracks, jab peak-lean gap to MPFB 2.3 deg, mutant worse: 13.4 vs 10.6 deg).
Frame time NOT re-measured: the PC was busy (another Godot job 4.7 GB, CPU 50-70%) - perf.json is still pass 1's
47.7k-tri number; +14k card tris and alpha-to-coverage are the delta to measure on an idle PC.

**Look, honest.** `docs/previews/mh1/portrait_vs_mpfb.png` (left MetaHuman, right MPFB control, same 105 mm studio,
the MPFB card re-rendered byte-identical): the MetaHuman now reads as a specific, photographed-looking man - real
skin variation and stubble shadow, a proper brush cut with a believable hairline, groomed brows, wet eyes - and
beats the MPFB man (smooth, painted, generic) clearly at portrait range. In the ring (`jab.mp4`, 1280x720 30 fps,
152 frames, no audio stream) the hair and face hold up at the broadcast camera. Remaining gaps: (1) a faint
head/body seam ring on the upper chest and a short crease at the back of the shoulder (tone is matched; the two
normal maps/pore scales still differ); (2) no facial animation (face joints folded - a rigid face); (3) the crown is
cut by FighterPortrait's head-joint framing (same for both cards); (4) hair colour is a fixed dark brown (Victor's
melanin parameter is unreadable: "Collection is not built" in the commandlet); (5) Victor is the only identity -
a library needs a preset/blend per fighter and the default-garment trap below handled; (6) 1K face skin (the 2K-8K
"Download Texture Sources" needs his Epic sign-in).

**What failed / traps this pass.** The PC FROZE on the 2026-10-02 build: the preset carries Outfits =
WI_DefaultGarment and `spawn_meta_human_actor` builds its 4K/8K clothing textures ("AssetCompile memory estimate
... 4289 MiB" over the limit). The exports had already been written; the missing brow head came from
`mh_export_groom_heads.py` (no spawn). Re-run the full build only with RAM headroom or after clearing the Outfits slot.

Commands (worktree root): `bash Tools/metahuman/run_ue.sh <abs>/Tools/metahuman/mh_build_pilot02.py build02`;
`blender --background --python Tools/metahuman/bl_exr2npy.py`; `python Tools/metahuman/make_textures02.py`;
`blender --background --python Tools/metahuman/bl_build_glb02.py -- E:/FightCamp/metahuman_pilot/export02
E:/FightCamp/metahuman_pilot/work02/game <out.glb>` (run it, then make_textures02 again, then it again - the second
pass uses the seam samples); Godot modes as above (frames moved to E:/FightCamp/metahuman_pilot/jab_frames02).

## Prior research / prefab check

`python Tools/prior_research.py metahuman`: S138_AAA_VISUAL_GAP (licence, MatMADNESS, ibrews/MetaHumanGodot),
DECISION_LEDGER D29. Prefab: ibrews/MetaHumanGodot publishes only the Godot loader, not the UE->Godot automation;
this pilot is that automation.
