# TASK_G78 - Character Creator 5 by script, and into Godot (Grok, research)

Model: Grok Expert, Research mode (NEVER Build). Owner: grok. Assigned S60, 2026-09-23.

## Owned files
- `research/G78_CC5_BY_SCRIPT.md` - Claude saves your answer here verbatim.

## Context
A Godot 4.7 fight game. We have Reallusion **Character Creator 5.13 (trial) and iClone 8.75** on Windows,
plus the free CC5 pack's **"HD Aaron"** male character. The trial allows **only 30 FBX exports in total**,
so every export must be right the first time. We want ONE realistic MMA fighter: athletic body built to
given numbers (height in metres, weight, shoulder/limb proportions), MMA shorts, no logos, then
FBX -> Blender -> glTF -> Godot, where our retargeter maps a UE4/Mannequin-like skeleton onto our rig.

## Questions - answer each with version-specific facts, cite the doc/forum page, label JUDGEMENT
1. **CC5 Python (RLPy) surface.** Exact calls to: load a character/project (.ccProject / .ccAvatar) from
   a path; apply a character from the Content Manager by script; set body MORPH sliders by name (height,
   body mass, muscle definition, shoulder width, arm/leg length) - how to list the slider IDs; apply or
   swap clothing; export FBX with a named preset. Give a minimal working script shape for each. Is
   anything here GUI-only in CC5 (not scriptable)? Does CC5 still use Python 3.x and `RLPy.RScene` /
   `RLPy.RFileIO.ExportFbxFile`? What changed from CC4.
2. **Export settings for a game engine.** Which FBX target preset (Unity / Unreal / Blender / "Mixamo")
   gives the cleanest skeleton for Godot + retarget? Bone naming on each (`CC_Base_*` vs UE4 names), unit
   scale (cm vs m) and axis, whether to embed textures, LOD/subdivision, the "HD" character's texture
   sizes and polycount at export, and whether the trial watermarks or restricts textures.
3. **Blender step.** Reallusion's "CC/iC Blender Tools" (Blender Auto Setup) - does it support Blender
   5.x, and does its glTF/"export to Godot" path preserve the skin shader and the skeleton? Known
   failures. Is the Blender step needed at all, or does Godot 4's FBX import (ufbx) take a CC FBX
   directly and correctly?
4. **Height in metres.** How to read or set the character's exact height in CC5 (a readout, a script
   call, or measuring the bounding box), so the export lands at a known metres height.
5. **The 30-export count.** What exactly counts as one export in the trial (each FBX? each preview?
   Blender Pipeline "send"?). Does "Send to Blender" via the Pipeline plugin bypass or consume it?
6. **Licence.** What the trial EULA and the paid CC5 licence allow for a commercial game: shipping a
   CC-built character mesh at runtime, the need for the "Export" licence, and whether HD Aaron from the
   free pack is licensed for shipping.

## Rules
- Measured/documented facts only; say "NOT FOUND" when you could not find one.
- End with **ARGUE AGAINST YOURSELF**: the strongest case that this CC5 route is the wrong one for us.
- Do not write code for Godot; this is research.
