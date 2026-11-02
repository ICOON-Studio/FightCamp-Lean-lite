# ULTRATEX_S270 - can UltraTex give us better textures? (operator link, S270, 2026-10-20)

Source: PixelArtistry, "FINALLY Good AI Texturing Locally on 6GB VRAM (Free)", 2026-10-18,
https://www.youtube.com/watch?v=4QAgeKYfBnU (description + linked repos read; video not watched frame by frame).

## What it is
UltraTex (SIGGRAPH Asia 2026, github.com/yiboz2001/UltraTex) textures an EXISTING 3D mesh from one reference
image: it renders 6 or 10 views, generates them with a FLUX LoRA, and bakes them onto the UVs. It outputs albedo
plus metallic/roughness (PBR). It runs in ComfyUI (nodes: visualbruno/ComfyUI-UltraTex MIT; GGUF low-VRAM nodes:
Mstafa-awad/UltraTex-ComfyUI-nodes GPL-3.0). It claims better reference fidelity than Trellis 2, including text
and faces.

## Checks (read 2026-10-20)
| Check | Finding | Effect |
| --- | --- | --- |
| Code licence | UltraTex MIT; ComfyUI nodes MIT / GPL-3.0 (tools only, nothing ships) | OK |
| Model licence | The LoRAs need FLUX.1-dev or FLUX.2-Klein **9B**. Both use the FLUX **Non-Commercial** licence (HF tag `flux-non-commercial-license`). Klein 4B is Apache 2.0, but UltraTex ships no 4B LoRA | Using it to make assets for a paid Steam game needs a BFL commercial licence, or a 4B LoRA that does not exist yet |
| Our GPU | AMD Radeon RX 6800 XT, 16 GB. UltraTex's rasteriser stack targets NVIDIA CUDA | Not a one-click install here. It also means a 20-min GPU job against the 84 C cap |
| Where it would help | Gym props and room models (Ludo / Hunyuan / Tripo / Sketchfab meshes) whose textures are blurry or don't match | Real use: one material look across props from many sources (J65 style risk) |
| Where it would not help | MetaHuman boxers: Epic's scanned skin textures are already better than any AI bake; our open MH faults (scalp band, shoulder lines) are UV seams, which a bake can't fix | No use on fighters |

## Verdict (Claude)
Worth a trial on gym props only, not on boxers. Run it on a rented NVIDIA cloud GPU (about $1/hour), not on this PC.
Ship nothing it makes until the FLUX licence is settled. A paid BFL licence costs money, so that is the operator's call.
Trial: re-texture three blurry gym props from one reference photo each, then compare stills on the game camera.
