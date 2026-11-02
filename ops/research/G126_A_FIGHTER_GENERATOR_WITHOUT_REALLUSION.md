# G126 - A FIGHTER GENERATOR IN THE GAME WITHOUT PAYING REALLUSION
Grok (Expert), delivered 2026-09-26 in grok.com/c/fe3243a9-912e-4bc0-ae4d-43c58a2efadf, 114 sources. Collected by
Claude, S92. Citations render as site names only (help.ea, github, static.makehumancommunity, blendercharacterproject,
help.humgen3d, github.khronos, forum.godotengine, docs.godotengine, app.cinevva).

**Answer: yes. An offline create-a-fighter from CC0 morphs + textures, no Reallusion.**
Studios: one topology, a morph library, texture/hair slots, seed -> weights. EA UFC CAF is sliders on face/body/hair/
tattoos; its licensed roster is scans, not a generator. SOURCED (help.ea)

## 1. Licences
- **MakeHuman / MPFB (pick this).** Code: MH AGPL, MPFB GPLv3. Bundled assets (base mesh, targets/modifiers,
  textures, clothes, poses, rigs) **CC0 1.0**. Exports are the user's data - closed-source commercial game, no fee, no
  attribution. Third-party assets keep their own licence. SOURCED (github makehuman LICENSE.md). MH FAQ: "You can copy,
  modify, distribute and perform the work, even for commercial purposes... The exported models end up being licensed
  CC0." Do not ship MPFB/MH program logic; assets + baked characters yes. SOURCED
- hm08 body ~ verts 0-13379, helpers to 19157; hundreds of .target files behind ~100 modifiers. SOURCED
- **CharMorph:** code GPL; Vitruvian base CC0, Antonia/Reom CC-BY, **MB-Lab AGPL - infects exported models, do not
  use.** SOURCED
- **Human Generator:** assets not free, $128/user commercial; game use allowed if not extractable. SOURCED
- **UMA:** MIT but Unity-only. Not a Godot path. SOURCED

## 2. Many faces in Godot 4.7
- One (or few) meshes + N blend shapes, not N baked bodies; seed -> weight vector.
- glTF morph targets import; `MeshInstance3D.set_blend_shape_value(idx, w)` at runtime. SOURCED (khronos, godot docs)
- **Cost:** VRAM scales with verts x targets - 237 shapes on one mesh measured ~97 MB in Godot vs ~11 MB in Unity.
  Hundreds of live shapes on a fight roster is the wrong design. SOURCED (forum.godotengine)
- Pattern: heavy morph mesh on the create screen; `bake_mesh_from_current_blend_shape_mix()` for the fight instance,
  at load, never per frame. SOURCED
- Practical N: 15-40 body + 20-40 face shapes on the shipped mesh, driven from a seeded hash (age, sex, ethnicity axes
  + noise). Keep the current height/girth scale on top. JUDGEMENT
- glTF export: Armature -> Export Deformation Bones Only, or morph normals shade wrong. SOURCED

## 3. Our 22-bone SkeletonProfileHumanoid
- MPFB **GameEngine** rig is the export rig ("100% mapping for Unity Mecanim"): pelvis, spine_01/02/03, neck_01,
  head, clavicle, upperarm, lowerarm, hand, thigh, calf, foot. BoneMap GameEngine -> Humanoid; drop fingers. SOURCED
- Bones are placed from mesh joint cubes, so a heavy morph moves bone rests. Retargeted clips still work if BoneMap +
  rest are rebuilt; extreme limb/heel morphs need scale_base_bone / foot fixes or they skate. No per-body clip authoring
  while topology + bone names stay fixed - only a rest-pose refresh. SOURCED
- MPFB weights will not land on our twelve AI meshes: either retarget MH onto our skeleton, or replace the twelve with MH
  GameEngine exports scaled in game as now.

## 4. Skin / hair / ethnicity / age, no likeness
- MH bundled skins + community packs (e.g. Toigo skins02) are CC0, on the MH UV, no real person. Tint + roughness/age
  overlays give ethnicity/age without a scan. SOURCED
- Hair: a small slot set of cards/strips (CC0 or owned). No photogrammetry of a living person.

## 5. JUDGEMENT
Pipeline: MPFB male + female -> GameEngine rig -> helpers off -> glTF with a curated shape-key set + CC0 skins ->
Godot BoneMap to SkeletonProfileHumanoid (22-bone subset) -> `FighterLook.gd`: seed -> clamped weights + skin tint +
hair id -> create screen live shapes, fight pawn baked mix -> height/girth stay the existing scale.
**Licence in one line:** MPFB/MH assets and exports are CC0 and may ship in a paid closed Godot game; do not ship the
GPL/AGPL add-on, do not use AGPL MB-Lab or unlicensed Human Generator / Reallusion.
**Cost:** ~8-15 person-days. **ONE trap:** live morph VRAM plus bone-rest drift after body morphs - bake the body,
keep the 22-bone names, refresh rest; never dump the full MH target bank into the fight scene.

## Claude's reading (S92)
Adopted as the route. It is a real stage: a pilot is one MPFB male exported on the GameEngine rig, retargeting the
existing clips (the fight/floor/retarget subsets must stay green) with 10 face + 10 body shapes driven by a seed.
Blender 5.2.1 is on the PC (reference_pc_animation_tools). **CC0 VERIFIED by Claude (S92)** at github.com/makehumancommunity/makehuman/blob/master/LICENSE.md s C-D: bundled assets (base mesh, proxies, targets and modifiers, textures, clothes, poses) "released under CC0 1.0 Universal"; output (exports, MPFB import, renders, saved models) "we regard these things as your data". Third-party assets from the community repositories carry their OWN licence - check each one (e.g. community skin packs).
