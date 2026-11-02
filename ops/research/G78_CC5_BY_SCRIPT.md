# G78 - Character Creator 5 by script, and into Godot (Grok, Expert), verbatim

Source: grok.com/c/21bd9c2f-3aa6-48f9-ac5b-b75887a4b98d, collected 2026-09-23 (S60). Task: TASK_G78_CC5_BY_SCRIPT.md. NOTE: S60 already did the export in practice (Tools/cc_bridge/, one export spent) - read this against what worked there.

---

I'll gather official CC5 docs, forum threads, and trial/EULA facts first, then answer each question with citations.Pulling official manuals, EULA pages, the CC5 MCP plugin source, and trial-limit threads next.# TASK_G78 — CC5.13 → Blender → glTF → Godot

Facts only. **JUDGEMENT** marked. **NOT FOUND** where the public record is empty.

---

## 1. CC5 Python (RLPy)

**Surface.** CC5 and iClone 8 share one API. Official wiki is the **iClone 8** wiki and lags; staff say the live surface is `C:\Program Files\Reallusion\Character Creator 5\Bin64\RLPy.py`.

**Python version.** Still embedded CPython 3.x + `import RLPy`. Exact 3.x minor **NOT FOUND**. Plugins still declare `rl_plugin_info = {"ap": "iClone", "ap_version": "8.0"}` in CC5 samples.

**CC4 → CC5.** Same `RLPy.RScene` / `RFileIO`. Documented additions: `RExportFbxSetting` object (wiki still shows the old 3-enum `ExportFbxFile`), `EnableBakeSubdivision`, `RGlobal.Get/SetObjectSubdivisionSetting`, `GetAvatarShapingComponent`. CC5 GUI also gained one-shot mesh+motion FBX and UE5 skeleton / extra bind poses.

### Load project / avatar

```python
import RLPy
RLPy.RFileIO.LoadFile(r"C:\path\file.ccProject")   # wiki example is .iProject
avatar = RLPy.RFileIO.LoadObject(r"C:\path\HD_Aaron.iAvatar")  # RIAvatar
avatars = RLPy.RScene.GetAvatars()
```

`.ccProject` / `.ccAvatar` accepted by `LoadFile` — **NOT FOUND** in the wiki (examples are `.iProject` / `.iAvatar`). **JUDGEMENT:** same loader; confirm on `RLPy.py`.

### Content Manager by script

No “apply item N from the CM UI” call. Browse then load:

```python
key = RLPy.ETemplateRootFolder_Character
root = RLPy.RApplication.GetDefaultContentFolder(key)  # e.g. $/Actor/Character
subs = RLPy.RApplication.GetContentFoldersInFolder(root)
files = RLPy.RApplication.GetContentFilesInFolder(some_sub)  # real disk paths
RLPy.RFileIO.LoadFile(files[0])
```

Tags/collections: staff — **not scriptable**.

### Morph sliders

Staff sample (CC5, Nov 2025):

```python
sc = avatar.GetAvatarShapingComponent()
cats = sc.GetShapingMorphCatergoryNames()          # list categories
ids  = sc.GetShapingMorphIDs("Actor/Body/Full Body/Character")
names = sc.GetShapingMorphDisplayNames("Actor/Body/Full Body/Character")
sc.SetShapingMorphWeight(id_string, 1.0)            # typically -1..1
RLPy.RGlobal.ObjectModified(avatar,
    RLPy.EObjectModifiedType_Attribute | RLPy.EObjectModifiedType_Transform)
```

Public IDs for height / mass / muscle / shoulder / arm / leg length: **NOT FOUND**. UI height control is **Character Scale A** under Full Body. List IDs from the calls above; do not hard-code guessed names. Third-party MCP examples (`Nose_Size`, body presets `athletic`/`muscular`) are **not** official IDs.

### Clothing

```python
RLPy.RFileIO.LoadObject(r"C:\path\shorts.iCloth")  # or .iClothes
clothes = avatar.GetClothes()
```

Dedicated `AttachCloth` / swap-by-slot: **NOT FOUND**. MCP wraps this as `load_asset` + `remove_scene_item`.

### Export FBX with settings (not a named UI preset file)

```python
s = RLPy.RExportFbxSetting()
s.EnableBakeSubdivision(True)   # documented Jun 2026
RLPy.RFileIO.ExportFbxFile(avatar, r"D:\Out.fbx", s)
```

Named Target Tool Preset string (`"UE5"`, `"Blender"`) on `RExportFbxSetting`: **NOT FOUND** in official wiki. Third-party MCP maps `target_tool="UE5"` etc. Confirm setters in `RLPy.py`. Older wiki still documents the 3-flag `ExportFbxFile(avatar, path, opt, opt2, opt3, texSize, fmt, motionPath)` including `EExportFbxOptions2_UnrealPreset`.

`CheckExportFbxHasLicense(obj)` exists (experimental / internal).

### GUI-only / weakly scriptable

- Content Manager tags/collections.
- Saved Export-dialog *presets as named files* — **NOT FOUND**.
- Clothing/hair Smooth Mesh was GUI-only until a mid-2026 API (`Get/SetObjectSubdivisionSetting`). Older 5.13 trial may lack it.
- ActorMIXER one-click random / pack apply — plugin, not core RLPy.
- InstaLOD tick in the FBX panel — script equivalent **NOT FOUND**.

---

## 2. Export settings for Godot + UE4-like retarget

**Presets in CC5:** Unreal (UE4 Skeleton), Unreal (UE5 Skeleton), Blender, Unity, Mixamo, Maya, Marmoset, Custom. Advanced fields follow the preset.

**Bones.** Native CC skeleton uses `CC_Base_*` (`CC_Base_Hip`, …), ~100–108 bones on CC3+/HD. UE4 preset remaps structure/names toward the UE4 Mannequin (3 spine bones). UE5 preset adds ~10 spine/hand bones and UE5 names. Mixamo preset → Mixamo names.

**JUDGEMENT for your retargeter (UE4/Mannequin-like):** export **Unreal (UE4 Skeleton)** + **A-Pose for UE4 Skeleton** if the mapper wants Mannequin names. Export **Blender** preset if you will run CC/iC Blender Tools (keeps `CC_Base_*` and the JSON the addon expects). Do not use UE5/MetaHuman preset unless the Godot mapper knows those extra bones.

**Units / axis.** CC height and FBX are **centimetres**. Godot 4.3+ **ufbx** converts cm→m into mesh data (not a 0.01 node scale). Blender defaults to metres and often shows a 0.01 armature until you apply/convert. Y-up vs Z-up is preset-driven (Blender/Unity Y-up; Unreal Z-up). Exact per-preset axis table in the CC5 manual page: **NOT FOUND** beyond “Advanced Settings change with preset.”

**Textures.** Embed Textures is a checkbox. PBR maps still commonly land in a sibling `textures/` folder plus a JSON map file; Multi Level Normal exports extra normals per SubD.

**SubD / LOD.** HD export levels **0 / 1 / 2**. InstaLOD is a separate tick (must be off to pick SubD). Official rec for engines: **SubD 1**. Fight-game mesh: **SubD 0** or Convert to Game Base.

**HD mesh / textures** (official base-mesh table, not “Aaron” specifically):

| | CC3+ / HD SubD0 | HD SubD1 | HD SubD2 | Game Base |
|---|---|---|---|---|
| Total body (all elements) | 17,683 | 70,732 | 282,928 | 8,723 |
| Bones | ~100 | ~100 | ~100 | 72 |

Textures: 2K / 4K / 8K on head/body/arm/leg. Embedded skins often stored at 2K; HD skins go to 4K/8K. ~400 morphs on HD. Aaron-specific measured poly/tex at export: **NOT FOUND** (Aaron is the stock CC5 HD male; treat as HD row above).

**Trial watermark on FBX textures.** Software trial: video/image **watermarked**; FBX/OBJ/USD allowed 30 times. Store **trial content** cannot be exported at all. Watermark baked into exported FBX maps of *embedded* Aaron: **NOT FOUND**.

---

## 3. Blender step

**Blender 5.x.** CC/iC Blender Tools **2.3.3** is the Blender 5.0 fix (5.0 bone-select API broke 2.3.2). Later **2.4.x** targets 4.5+ and 5.1. Official Reallusion notes: “Support Blender 5.0.”

**glTF / Godot path.** Addon rebuilds Digital Human as Eevee/Cycles nodes and has a **Baked GLTF export** button. Skeleton is kept. Bake addon (`cc_blender_bake`) has an explicit Godot target. Skin *as CC Digital Human* does **not** survive as that shader in Godot — it becomes baked PBR.

**Known failures.** 2.3.2 + Blender 5.0: wrong materials until rebuild, colliders visible, motion send broken. Round-trip: “Go iC” grey after SubD 1; Digital Human shader type dropped on some reimports; physics weight-paint / ARKit CSV bugs on 5.0 (fixed in later notes).

**Skip Blender?** Godot 4.3+ **ufbx** imports FBX (skin, morphs, embedded textures, units). No official CC→Godot validation. **JUDGEMENT:** skeleton can go FBX→Godot; Blender is still the only documented way to bake CC skin to glTF PBR and strip junk. If the retargeter only needs mesh+`CC_Base_*`/`UE4` bones, a single clean FBX may suffice.

---

## 4. Height in metres

- Viewport: **Preferences → Display → Info** shows selected-object height in **cm**.
- Slider: **Character Scale A** (Full Body). HD scale-down readout stuck at ~180 cm in 5.01; **fixed in 5.02/5.03**. You are on 5.13.
- Script height-in-metres call: **NOT FOUND**.
- Bounds:

```python
mx, c, mn = RLPy.RVector3(), RLPy.RVector3(), RLPy.RVector3()
avatar.GetBounds(mx, c, mn)   # centimetres; height ≈ mx.y - mn.y (pose-dependent)
```

Convert `/100` for metres. Hair/shorts inflate the box. **JUDGEMENT:** set Scale A, read Info cm, divide by 100; do not trust bounds with clothes.

---

## 5. The 30-export count

Official trial table: **Export FBX, OBJ, and USD — 30 times.** Dialog: “You have 30 times remaining on your current license.” Save project = unlimited. Video = 30 s + watermark; image = 800×600 + watermark. Limit cannot be raised; staff point at the 14-day paid refund instead.

What counts as 1: each completed FBX **or** OBJ **or** USD write. Scripted `ExportFbxFile` / `ExportObjFile`: **NOT FOUND** stated, **JUDGEMENT:** yes, same exporter.

Previews: **NOT FOUND**.

**Send to Blender / DataLink:** **NOT FOUND**. DataLink writes an FBX then pushes it. **JUDGEMENT:** treat every Send as one of the 30 until you measure.

GoZ / Sketchfab / Transformer: listed separately on the trial table (blank checks in the scrape) — do not assume they are free.

---

## 6. Licence

**Software EULA (purchased perpetual / active sub):** export models into games/apps; you may ship the mesh *embedded in the game*. Forbidden: in-game **character generation system**, AI training, selling the CC base model as a marketplace asset.

**Content policy (1 Aug 2025):** Extended folded into **Standard**. Standard: export to UE/Unity/Blender/Maya; deploy 2D/3D assets in games/XR; CC Components on unlimited commercial characters. Enterprise still required for: embed-the-tool into an app/service, AI training, mass 3D-print for sale, special cases. “In-app purchase of RL content” restricted.

**Extra export licence:** not required for one baked fighter in a commercial Godot game under Standard. Required if players generate/customize with CC morphs/clothes at runtime (Enterprise).

**HD Aaron (free/embedded CC5 pack):** staff: embedded CC content is usable in commercial games without buying store packs. Aaron is the default CC5 male. Do not ship unmodified Aaron as a *store asset*. Do not put CC sliders in an in-game creator.

**Trial EULA vs ship:** trial page ticks “Commercial Use” + EULA link, but grant language is for purchased licence; trial FBX is a capped eval. **NOT FOUND:** “a trial-exported FBX may ship in a paid game.” **JUDGEMENT:** buy CC5 before shipping.

---

## Practical one-shot (JUDGEMENT)

1. Load embedded HD Aaron. Save `.ccProject` (free).
2. Script-list Full Body morph IDs; set Scale A to target cm; verify Info readout.
3. Apply owned/embedded shorts only (no store-trial clothes).
4. Export **once**: Target **Unreal (UE4 Skeleton)** if the Godot retargeter wants Mannequin names, else **Blender** + SubD **0**, Mesh only, embed textures, no InstaLOD.
5. Blender Tools 2.3.3+ → bake glTF for materials; or test ufbx first and spend the next export only if skin/scale is wrong.

---

## ARGUE AGAINST YOURSELF

This route is the wrong one for FightCamp.

The 30-export cap makes “script it perfect first” a fantasy: RLPy for CC5 is the iClone 8 wiki plus `RLPy.py`, morph IDs are undiscoverable without burning a live session, and DataLink may silently eat counts. HD Aaron at SubD 0 is still a Digital Human, multi-material, 4-body-UVs character; Godot will not run that shader. You already have a UE4/Mannequin retargeter — CC’s value is the *skin and face*, which die on the way to glTF unless you maintain Soupday’s addon across Blender 5.x breaks. Licence text still splits “deploy in games” (Standard) from “embed in an application” (Enterprise); a fighter-select screen is probably fine, a future in-game creator is not. One realistic male in MMA shorts is cheaper and safer from Mixamo / a bought UE mannequin / a sculpted Game Base than spending the trial and then $299 to discover the Godot materials are flat. Buy CC5 only if you need the HD face and accept Blender bake as a permanent step — not because the Python surface will save exports.