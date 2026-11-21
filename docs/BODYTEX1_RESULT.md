# BODYTEX1 - athletic body skin, phase 1 (boxer 01) - S535

STATUS: maps built and wired, NOT yet seen in a render. The before/after stills were queued behind 20 Godot jobs on a RED
PC and were stopped for low memory before they ran. Nothing below about the look is proven until the stills exist.

## Why the bodies are flat
- The S299 build exported the character's default `body_textures` from MetaHuman Creator. That is the detail set
  `T_Chr0005`, the flattest of the nine sets UE 5.8 ships (normal spread about 4 of 255; the others 7 to 10).
- `mh2_textures.py` then halved it to 1024 and saved a JPEG. The albedo is one skin tone times a neutral detail map: no cavity.
- The premise "the real maps carry the muscles" is only partly true. Epic's sets are SURFACE DETAIL (navel, creases,
  knuckles, pores), all 2048, none 4K-8K on disk. Only two carry muscle lines: `Chr0023` (abdominal wall, serratus, chest
  line) and `Chr0035` (chest and belly lines). Most of an athlete's definition in MetaHuman comes from the body SHAPE.

## Where the real maps live
`C:/Program Files/Epic Games/UE_5.8/Engine/Plugins/MetaHuman/MetaHumanCharacter/Content/Optional/BodyTextures`:
`SurfaceDetail/T_Chr<id>_Body_N` (normal), `_Body_Ca` (cavity pack), `_Chest_N/_Ca` (the head and neck sheet, despite the
name), and `T_Skin_V1/V2_Body_BC` (neutral base colour detail). Ids: 0005 0011 0012 0013 0015 0018 0021 0023 0035.

## How they were exported (48 s, nothing on a monitor)
`UnrealEditor-Cmd.exe <project> -run=pythonscript -script=export_body.py -unattended -nullrhi` with a script that scans
`/MetaHumanCharacter/Optional/BodyTextures` and writes each texture with `TextureExporterDDS` (uncompressed BGRA8).
Then `python ops/Tools/metahuman/bodytex1_make.py <dds dir> mh_boxer_01 0023`: green flipped to OpenGL, pores blurred out
(the game's tiled micro normal draws them), blue rebuilt; albedo = the body's own 1K tone + 2K skin detail + a cavity pass
from the normal's curvature.

## What boxer 01 has now
- `mh_boxer_01_mh02_body_normal_2k.png` 1.8 MB, `mh_boxer_01_mh02_body_albedo_2k.png` 3.6 MB.
- `MHRig.dress` puts them on `MH_Skin_Body` when they sit beside the .glb; `-- nobodytex` is the before arm.
- `tools/export.sh` copies them beside the exe (they are read raw, like the micro normal).

## Size for all 12 bodies
PNG as built: about 5.4 MB a body, 65 MB in all. As JPEG quality 92: about 1.2 MB a body, 15 MB in all (recommended for
phase 2; MHRig then needs a JPEG loader beside `_png`).

## Shape (brief step 3)
Boxer 01 was requested at muscularity 1.4, fat -1.3, chest 106, waist 80. If the stills still show no abdominal relief the
shape is the rest of the answer: raise muscularity toward the slider's top, keep fat low, and re-export the mesh. Not done
in phase 1.

## Licence - the owner's call
Not read first-hand. unrealengine.com/eula/unreal, /eula/mhc and the FAQ answer 403 to automated fetches;
metahuman.com/license redirects to an Epic sign-in. A search summary of press coverage (CGChannel and Digital Production,
June 2025) says that from UE 5.6 MetaHumans fall under the Unreal Engine EULA and may be used in other engines such as
Godot. These maps are the same kind of asset as the 1K MetaHuman body maps the game already ships. Someone signed in
should read the page before release.

## Phase 2 would take
Stills first. Then: pick a detail set per body (0023 or 0035 for men, a lean one for the women), run the builder for the
other 11, switch to JPEG, re-export shapes where the stills ask for it, and one before|after sheet per body.
