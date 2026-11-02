# G114_GYM_PROP_SOURCES (Grok, collected by Claude S84, 2026-09-26)
Source: grok.com chat "Gym Prop Sources for FightCamp" (Expert, 129 sources). Transcribed from Grok's reply with its
tags. Brief: TASK_G114_GYM_PROP_SOURCES.md.

## What would a human do?
A small indie technical artist buys ONE combat-gym pack in an exchange format (FBX/glTF) and greyboxes the primitives
(mats, tubs, ladders, grids). Kit-bashing 20 separate Sketchfab/CGTrader files never matches one style; modelling all 23
in-house is weeks. JUDGEMENT.

## U179's links, opened 2026-09-26 - most do not exist as 3D props
- Kenney Sports Pack: exists, but 2D tiles (CC0), not 3D gym props. SOURCED kenney.nl/assets/sports-pack
- Poly Haven: no heavy/speed/double-end bag models. SOURCED
- ambientCG Bicycle001 / HospitalBed001 / Bathtub001: do not exist as models (ambientCG is PBR materials). SOURCED
- Quaternius: CC0 packs exist, no gym/boxing pack. SOURCED

## 1. One live model per missing item
| Item | Source | Licence | Price | Format | Polys | Rig |
|---|---|---|---|---|---|---|
| Heavy bag | sketchfab.com/3d-models/punching-bagboxing-bag-6b195883ada144d0a5d92f7ddcdfaf05 | CC-BY | free | glTF | 54.8k | no |
| Speed bag | fab.com seller PixelPress "Boxing Speed Bag" | Fab Standard | from $4.99 | UE; Cubebrush FBX/OBJ twin PROXY | ~12k | no |
| Double-end bag | NOT FOUND | | | | | |
| Focus-mitts locker | sketchfab.com/3d-models/metal-gymboxing-locker-975fe97634ad4812bc3b7450e7de6efb (proxy locker) | CC-BY | free | glTF | 6k | no |
| Cardio floor | NOT FOUND (a zone, not a mesh) | | | | | |
| First-aid cabinet | NOT FOUND (use a generic cabinet) | | | | | |
| Exercise bike | sketchfab.com/3d-models/stationary-bike-299d993f9eb94d6684562de7dca3514c | CC-BY | free | glTF | 150k | no |
| Physio table, stretching station, air bike, cold-water tub, rehab pool, sports-med room | NOT FOUND | | | | | |
| Combat mat / judo tatami | PixelPress "Exercise Martial Art Puzzle Mat" (Fab) | Fab Standard | from $5.99 | UE; FBX/OBJ twin PROXY | n/s | no |
| Grappling dummy | turbosquid.com/3d-models/leather-grappling-dummy-stand-3d-model-1648005 | TurboSquid Standard | $89 | FBX/OBJ/glTF | 22.6k | no |
| Safety locker | same CC-BY locker as the mitts locker | CC-BY | free | glTF | 6k | no |
| Capoeira kit, arnis kit, footwork ladder, reaction grid | NOT FOUND | | | | | |
| Plyo boxes | cgtrader.com/3d-models/various/various-models/plyo-box-set | RF | ~$5 a box | glTF/FBX/OBJ | n/s | no |

Also: an animated heavy + speed bag with frame, Sketchfab Store RF, 14.3k tris, rigged + animated (price not public):
sketchfab.com/3d-models/animated-punching-bag-and-speed-bag-08882d0768734d65b512463e34760868. CGTrader "Boxing Gym
Equipment Pack" $16 RF, FBX/GLB/BLEND, ~50k tris a mesh: bags, standing bag, punch dummy, treadmills, gloves; no
double-end, mats or ice bath. SOURCED

## 2. One pack
**PixelPress MMA and Boxing Gym Equipment** - Fab listing a7cc0691-7487-4689-9619-80c423385d15 (UE 5.1-5.7 package; price
"from $24.99" in one locale, "$134.65" in another - confirm at checkout). The same pack on Cubebrush,
cubebrush.co/pixelpress3d/products/rzzwyq/mma-boxing-gym-pack-vol-1: **$25, FBX + OBJ**, 28 unique meshes / 56 assets,
4K PBR, LODs. Full item list not published; speed bag, puzzle mats, wrestling dummy and ring confirmed via sister SKUs,
heavy bags implied (PROXY). Runner-up: the CGTrader $16 pack (glTF-native, thinner). Synty/Kenney/Quaternius have no
combat-gym set; Unity "Boxing and Gym Equipment" $14.99 (item list behind login).

## 3. Licences
- Unity Asset Store (non-restricted assets) may be used in another engine under the Asset Store EULA - no standalone
  redistribution. SOURCED support.unity.com article 34387186019988 (2025-07-02).
- Fab Standard License: "usage is not limited to Unreal Engine"; no standalone resale; Reference-Only and some Epic-owned
  content stay UE-only. SOURCED fab.com/eula (2026-09-26).

## 4. Recommendation (Grok)
Buy one pack and greybox the rest: PixelPress via Cubebrush $25 (FBX/OBJ), or CGTrader $16 if glTF-native matters more
than coverage. Free CC-BY fillers: the heavy bag, locker and bike above (credit authors). Skip the $89 dummy. Greybox:
mats, tatami, ladder, plyo boxes, reaction grid, cold tub, pool rim, first-aid cabinet, stretching rails, capoeira/arnis
racks; "cardio floor" and "sports-med room" are floor material + prop clusters. Cash: $16-25. A shared palette/roughness
pass is still needed to match the Polyronin pack. JUDGEMENT.

## Claude's note (S84)
S84 greyboxed every item already (TrainingFloor3D.gd), so nothing waits on a purchase. The $25 PixelPress/Cubebrush pack is
raised to the operator as a purchase (buy nothing without them); the CC-BY fillers need an author credit in CREDITS.md
before they ship. A real model replaces a greybox by catalogue id, sized to the G113 device box the layout already uses.
