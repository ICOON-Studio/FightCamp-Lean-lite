# TASK K40 — KALLI — WHICH FREE UNITY TOOLS COULD FIX OUR RETARGETING AND ANIMATION, AND STILL LAND IN GODOT?

Model: Grok Bot (Kalli), research. Owner: kalli. Stage: S4a (watchability) - the operator's own ask, 2026-09-13.

**Research only.** No code, no downloads, no purchases. Prose, numbers, links. One pass. Reply in this chat.

## Why this exists

Our game is **Godot 4.7.2**. Our fighters are single-mesh Tripo-generated humanoids. Our fight animations are bought
mocap clips (RamsterZ H2H packs, Fighting Motions Vol.1 - all Unity Asset Store FBX) that we RETARGET onto those
fighters with our own GDScript code. The operator watched the 3D fight and judged it "painful to watch": sliding feet,
head, torso and feet facing different ways, unnatural arms, stiff joins between clips. **Retarget quality is our
bottleneck.** The operator asked us to check the **FREE** tools on the Unity Asset Store, and Unity's own free
packages, for handling 3D models and animation: retargeting, root motion, IK and animation rigging.

**The one constraint that decides everything:** we ship in Godot, not Unity. A Unity tool helps us ONLY if it can
BAKE its result into a file Godot imports (FBX or glTF with the animation baked onto the skeleton). A tool that only
works at runtime inside a Unity scene is useless to us, however good it is. Say which kind each tool is.

## What we already hold - do NOT re-research

- The Unity Asset Store standard EULA lets us use store assets in a Godot game. It FORBIDS feeding them to AI or
  generators (clause 2.2.1.1(g)).
- The paid packs we hold or have shortlisted (RamsterZ, Mixall, Sidekick Boxing). Do not list paid packs.
- Motion matching, text-to-motion and paid foot-IK systems are RULED OUT. Do not propose them.

## What to find - one table row per tool

For each FREE tool (price verified as free on its own page today):
exact name, publisher, link, the Unity versions it supports, last update date, and what it does in one sentence.
Then:
- **BAKE?** Can its result be exported as FBX or glTF with the motion baked onto bones? Name the export path, for
  example Unity's FBX Exporter package, or the Recorder package's Animation Clip recorder followed by FBX Exporter.
  Answer YES / NO / ONLY WITH <other tool>.
- **Retarget quality evidence**: any documented comparison, known artefacts (foot sliding, twisted wrists or
  spines, lost root motion), and whether Unity's Humanoid (Mecanim) retargeting is what it uses underneath.
- **Licence** for our use: store EULA, MIT, Unity Companion License, and so on.

Cover at least:
1. **Unity's own free packages** (Package Manager, not the store): Humanoid/Mecanim retargeting with its
   Avatar Muscle settings, Animation Rigging, FBX Exporter, Recorder (Animation Clip / FBX recording), Timeline.
   Also any Unity-made sample that bakes Humanoid clips onto a Generic skeleton.
2. **Free Asset Store tools** for: retargeting and bone mapping; root-motion extraction and editing; foot locking or
   foot IK that can be BAKED; animation cleanup, mirroring, trimming and compression; and clip-to-clip transition or
   blending authoring that bakes. Include **Animancer Lite** (Kybernetik, free): the operator asked about Animancer
   Pro v8 (store id 293522, EUR 82.80, a runtime playback library). Say in one row whether any part of Animancer can
   produce a baked file, or whether it only plays clips inside Unity.
   **And UMotion Pro - Animation Editor** (Soxware, store id 95991, EUR 64.40 - paid, but the operator asked, so it gets
   a full row): does its FBX export (Windows) carry a clip that UMotion applied to a DIFFERENT humanoid skeleton, with
   IK Pinning (planted feet) and override layers baked in? Does it have any scripting or batch API, or is every clip a
   hands-on edit? Any documented UMotion FBX export imported into Godot, Blender or Unreal, and what broke? Is UMotion
   Community (free) able to test the export or the IK, or are both Pro-only?
   **And AnimFuse** (store id 393674, EUR 18.39, Unity 6000.4 only - the operator asked): it bakes body-part blends of
   two Humanoid clips into Unity `.anim` files, not FBX. Is there a documented way to get such a Humanoid `.anim` onto a
   skeleton and out as FBX (FBX Exporter, Recorder) that keeps its quality? One row.
3. **The round trip, end to end:** has anyone documented FBX in -> Unity Humanoid retarget -> baked FBX out -> Godot
   (or Blender, or Unreal) in? What broke: scale, bone rolls, root motion, twist bones? Cite forum threads or
   articles with links and dates.
4. **For comparison only, one short row each:** the free non-Unity routes to the same result. Blender add-ons
   (Rokoko Retargeting plugin, Auto-Rig Pro's free parts if any, Expy Kit) and Godot 4's own retargeting
   (BoneMap, SkeletonProfileHumanoid, and any retarget or IK modifiers in Godot 4.4 or later).

## Your answer's first section: `## DECISIONS`

At most eight lines. The one to three tools most likely to raise our retarget quality THROUGH A BAKED FILE, each
with its export path and its biggest known risk. Say plainly if the honest answer is that no free Unity tool beats
a Blender or Godot route.

Labels on every row: DOCUMENTED (read on the tool's own page or docs) / SECONDARY (forum or article) / NOT FOUND.

Claude collects as: `research/K40_FREE_UNITY_ANIMATION_TOOLS.md`
