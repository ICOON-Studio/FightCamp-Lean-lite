# J_CLOTHES_S207 - John's reply, verbatim (gbot thread 'John Research', saved S208 2026-10-12)

[send-message t45s380] On it. I'm researching free and cheap clothing sources we can ship commercially and fit to our MPFB and Tripo bodies, and I'll send the full sourced report with the top 3 routes ranked.
[send-message t45s381] The J_CLOTHES_S207 research is underway, and I'll paste the full document here. It weighs two routes: clothing the current MPFB bodies with MakeHuman, Sketchfab and other garments, or switching to stylised modular characters. The Two Point memo leaned toward the second, so the ranking will deal with keeping the style consistent.
[send-message t45s382] J_CLOTHES_S207 is finished. If the gym stays realistic, the best route is the MakeHuman clothes already in our MPFB toolchain: about 380 free CC0/CC-BY items that auto-fit any MPFB body and hide the skin underneath, for about 80–120 h for 5 roles × 6 looks at USD 0. Three catches: the Tripo bodies can't auto-fit, boxing gloves, headgear and hand wraps have to come from elsewhere, and the style has to be picked before any clothing work. The full document is below in four parts, and the file is attached.
[send-message t45s383] 
[send-message t45s384] # J_CLOTHES_S207 - Clothes so everyone looks different

- Date: 2026-10-12 (Asia/Nicosia)
- Owner: John Research
- Project: FightCamp (PC boxing-gym management sim, Godot 4.7.2)
- Scope: research only, no game code.
- Tags: **SOURCED** = backed by the source ID in brackets (full URL, page date and access date are in Section 6; everything was accessed 2026-10-12). **JUDGEMENT** = my own estimate or opinion. **NOT FOUND** = I could not verify it.
- "Measured" = I downloaded the file myself on 2026-10-12 and counted vertices, triangles and texture sizes with a script (source S11).

---

## 0. Answer first

1. **The cheapest, safest win is already in the MPFB toolchain.** The "MakeHuman system assets" pack has 20 CC0 clothing items: 14 outfits or hats and 6 pairs of shoes. The official asset packs add 129 more CC0 clothing items and 231 CC-BY ones, so about **380 items** in total. They are fitted automatically to any MPFB body shape through .mhclo files, which come with delete groups and weight transfer. (SOURCED S1, S2, S8, S10; the counts are my tally of the pack pages.)
2. **Licence:** MakeHuman core and system assets are CC0. The clothes files themselves say they were "explicitly released as CC0 in september 2020". CC-BY packs need an author credit. Community-repository uploads carry their own licences. (SOURCED S3, S4, S11, S5)
3. **The catch:** .mhclo fitting only works on the MPFB/MakeHuman base mesh. The **Tripo-generated bodies cannot use it**. They would need each garment fitted by hand (roughly 2-4 h per garment per body), or they could be rebuilt as MPFB bodies. (JUDGEMENT, based on S8: MHCLO maps clothes vertices onto basemesh vertices.)
4. **The gym-specific gear mostly isn't there.** MakeHuman packs give tank tops, a polo, a hooded sweat jacket, swim shorts and trunks, sneakers, visors and caps, and one set of MMA gloves. I found **no boxing headgear, hand wraps or boxing gloves** in the packs (NOT FOUND). Sketchfab has CC-BY boxing gloves and headgear, but they are **static, unrigged meshes**, attached to a bone (rigid gloves and headgear) or needing to be re-topologised and skinned. (SOURCED S10, S20)
5. **The stylised route (per the J_TPH_LOOK memo):** Quaternius Universal Base Characters (CC0, 6 bodies, about 13k triangles each, 20 hairstyles) plus Modular Outfits come in **fantasy only**. No modern, gym or street clothing is included, so every gym outfit would have to be modelled. Synty Sidekick "Modern Civilians" has 160+ modern parts for USD 199.99, but its tools are Unity/Unreal-first and its EULA bans generative-AI use. (SOURCED S14, S15, S21, S22)
6. **Style consistency is the real decision.** MakeHuman clothes on MPFB bodies look realistic. Quaternius, Synty, Kenney and KayKit are stylised. Mixing them in one gym will look wrong at close-up. **Pick the style first**, with a 1-day test render at the 3/4 camera, and then commit to one clothing route. (JUDGEMENT)
7. **How to get variety in Godot:** use one shared Skeleton3D. Each garment is its own skinned MeshInstance3D bound by bone name ("Use Named Skins"). Rigid gear goes on BoneAttachment3D. Colour comes from `instance uniform` tints, so no material duplication is needed. (SOURCED S40) For example, 4-6 base garments per role x 4-6 palettes x 2-3 logos/decals gives far more than 30 distinct looks. (JUDGEMENT)
8. **Recommendation:** if the realistic look stays, go with Route 1 (MPFB + MakeHuman CC0/CC-BY clothes + a few custom boxing items). It takes about **80-120 h** for 5 roles x 6 looks. If the J_TPH_LOOK stylised look wins, go with Route 2 (Quaternius CC0 bases + self-modelled modern outfits), at about **110-170 h**. Do not ship Sketchfab "GTA/Nike/Goat Simulator" items, which look like rips or brand IP. (JUDGEMENT, plus S20 tags)

---

## 1. Sources table (one row per source)

Licence column: exact licence as stated by the source. "Fit to MPFB" = realistic hours to get one garment working on one MPFB body in Godot (JUDGEMENT unless noted).

| # | Source | Licence (exact) | Price | Contents (clothing) | Format | Rig / Godot humanoid retarget | Polycount | Fit to MPFB |
|---|---|---|---|---|---|---|---|---|
| A1 | MakeHuman system assets pack [S2,S11] | CC0 (SOURCED S2; mhclo header "released as CC0 in september 2020" S11) | Free | 20 clothes: fedora01, fedora_cocked, female_casualsuit01/02, female_elegantsuit01, female_sportsuit01, male_casualsuit01-06, male_elegantsuit01, male_worksuit01, shoes01-06; plus 10 hair, 12 eyebrows, 4 eyelashes, 23 skins, 7 proxies (SOURCED S2) | .mhclo + .obj + .mhmat + PNG (measured S11); pack 267 MB (S2) | Fitted and weighted by MPFB onto any MPFB rig; "GameEngine" rig (53 bones, UE-style names like pelvis, spine_01, thigh_l) maps to Godot's humanoid profile through the BoneMap (SOURCED S6, S9; mapping quality JUDGEMENT) | Outfits 3,240-16,672 tris; shoes 3,064-4,128 tris (measured S11) | 0.25-0.5 h (auto-fit) (JUDGEMENT) |
| A2 | MakeHuman CC0 asset packs (dress01, gloves01, hats01-02, pants01, shirts01, shoes01, skirts01, suits01-02, underwear01, underwear04) [S1,S10] | CC0 (SOURCED S1) | Free | 129 clothing items, e.g. namuhekam_male_polo_shirt, toigo_basic_tucked_t-shirt, elvs_crude_t-shirt_male, cortu_jeans_shorts, cortu_cargo_pants, learning_mma_fighting_gloves, jujube_newsboy_cap (SOURCED S10) | Same as A1 | Same as A1 | Not measured for these packs (NOT FOUND) | 0.25-0.5 h (JUDGEMENT) |
| A3 | MakeHuman CC-BY asset packs (dress02-03, hats03-04, pants02-03, shirts02-03, shoes02-03, skirts02, suits03, underwear02-03) [S1,S10] | CC-BY, credit the author (SOURCED S1, S5); the mhclo headers say "license CC-BY"/"CCBY" without a version (measured S11) | Free | 231 items, e.g. elvs_hooded_sweat_jacket1, elvs_male_tankshirt1, elvs_male_muscle_shirt1, mindfront_tank_top_01, elvs_male_swim_shorts1, mindfront_male_swimming_trunks_01-03, elvs_male_trouser_short_1/2, punkduck_running_shoes_01, culturalibre_sneakers, punkduck_sun_visor_sports_visor, mindfront_patrol_cap, elvs_emt_uniform_* (SOURCED S10) | Same | Same | shirts03: 1,288-112,004 tris; pants03: 728-28,815 tris (measured S11) | 0.25-0.5 h; heavy items need decimation (+0.5-1 h) (JUDGEMENT) |
| A4 | MakeHuman community asset repository [S12,S13] | Per asset ("not created, nor endorsed, by the MakeHuman crew", S13) | Free | "a few thousand assets" in total (S12); exact clothes count NOT FOUND (the site would not load from my box; the web page shows no total) | .mhclo | Same as A1 | NOT FOUND | Same as A1, plus licence checking per item |
| B1 | Quaternius Universal Base Characters (Aug 2025) [S14,S16] | CC0 (SOURCED S14, S16) | Free Standard version; Source version USD 19.99 (S16) | 6 bodies (Superhero, Regular, Teen; male and female), 20 hairstyles; no clothing list given (NOT FOUND) | FBX, glTF (S14) | "Humanoid rig compatible with retargeting in any engine"; Godot 4.3 project included (S14) | "Average 13k triangle count" (S14) | Not applicable (replaces MPFB bodies) |
| B2 | Quaternius Modular Character Outfits - Fantasy (Nov 2025, v2.1 5/7/2026) [S15] | CC0 (S15) | Free; Source USD 20 (S15) | 12 outfits, 62 parts, 3 colour textures each; **fantasy** (peasant, noble, wizard, knight) (S15) | FBX, glTF | Humanoid rig, fits Universal Base Characters (S15) | NOT FOUND | Not applicable; wrong theme for a gym (JUDGEMENT) |
| B3 | Quaternius Ultimate Modular Men / Women (Feb 2022) [S17] | CC0 (S17) | Free | 11 men / 10 women, each split into 4 swappable parts; 24 animations; Women has a humanoid-rig version (S17); garment list NOT FOUND | FBX, OBJ, glTF, Blend | Women: humanoid rig included; Men: NOT FOUND | NOT FOUND | Not applicable |
| B4 | Kenney Mini Characters, Blocky Characters, Animated Characters (1-3, Survivors, Protagonists) [S18] | CC0 (S18) | Free | Mini: 12 characters, 32 animations incl. wheelchair; Blocky: 18 skins, 27 animations; Animated Characters 3: 4 skins (S18). Variety comes from texture skins, not garments | glTF, FBX, OBJ (S18) | Own rig; retarget through BoneMap (JUDGEMENT) | "low poly" (no number) | Not applicable; too toy-like for close-ups (JUDGEMENT) |
| B5 | KayKit Character Pack: Adventurers [S19] | CC0, plus a request: "don't resell unmodified copies" (S19) | Free; EXTRA USD 7.95; Source USD 11.95 (S19) | 5 (+3 EXTRA) fantasy adventurers, 25+ weapons and accessories (S19) | FBX, glTF | Rig_Medium/Rig_Large; the KayKit Godot video maps to SkeletonProfileHumanoid (S19) | NOT FOUND; 1024 px gradient atlas (S19) | Not applicable |
| C1 | Sketchfab CC-BY garments (see Section 2.C) [S20] | "CC Attribution" (Sketchfab label) | Free (account needed to download) | Boxing gloves, headgear, boxer shorts, polo, hoodie, caps (Section 2.C) | Sketchfab source / glTF | All listed garments have animationCount 0, i.e. **not rigged** (S20) | 1,704-73,736 faces (S20) | 3-8 h each (retopo, UV/texture cleanup, skin to body); rigid gloves/headgear 1-2 h (JUDGEMENT) |
| D1 | Synty Sidekick Modern Civilians (published 2025-10-23) [S22] | Synty One-Time Purchase EULA: any engine; generative-AI uses banned; source files may not be shared outside the team (S21) | USD 199.99 (S22) | "160+ modular, rigged Modern Civilian parts (clothing, hair and more)", "90+ base parts" (S22) | Unity/Unreal packages + source (S22; exact source formats NOT FOUND) | "Fully rigged to the Unity Humanoid skeleton"; character tool is Unity/UE only (S22); retargets to Godot humanoid through BoneMap (JUDGEMENT) | NOT FOUND | Not applicable (Synty bodies) |
| D2 | Synty POLYGON City Characters Pack [S22] | Same EULA (S21) | USD 29.99 (S22) | 19 characters (biker, jock, tourist, shop keeper, hipster, ...), x4 colours, 3 skin tones (S22) | Unity, Unreal, FBX source (S22) | Mecanim humanoid (S22) | NOT FOUND | Not applicable |
| D3 | Synty POLYGON Office Pack [S22] | Same (S21) | USD 49.99 (S22) | 18 characters (office workers, cleaners, security, boss) + 626 props (S22) | Unity, Unreal, source (S22) | Mecanim (S22) | NOT FOUND | Not applicable |
| D4 | Unity Asset Store "Character Pack - Boxers Low Poly" (EMD Assets, Jun 6 2022) [S24] | Standard Unity Asset Store EULA (S24); other engines allowed (S23) | EUR 7.35 on the Asset Store; itch version min USD 6.99 with .blend (S24) | 7 rigged boxers + 2 moustaches (S24) | unitypackage; itch adds .blend (S24) | "compatible with any humanoid animations" (S24) | Max 2,200 polys (S24) | Not applicable (stylised low-poly) |
| D5 | Unity Asset Store "Boxing Fighters Pack" (Carthage Studio, Sep 26 2025) [S25] | Standard Unity Asset Store EULA (S25) | EUR 27.59 (S25) | 2 boxers, separate body / gloves / shorts meshes (S25) | FBX + PNG (S25) | Unity humanoid (S25) | about 6,330 verts (about 11k tris) each (S25) | Gloves/shorts onto MPFB: 2-4 h each (JUDGEMENT) |
| E1 | Mixamo [S27] | Adobe FAQ: royalty-free in games; you may not distribute "character or animation raw files"; no ML training (S27) | Free | Stock characters (list not checked: NOT FOUND) | FBX | Mixamo rig; MPFB has "mixamo" rigs (S9) | NOT FOUND | Not applicable |
| E2 | Ready Player Me [S28] | Not applicable: services wound down 2026-01-31 after the Netflix acquisition (S28) | - | - | - | - | - | Not applicable |
| E3 | Reallusion Character Creator 5 [S29] | Standard licence lets you export to any engine and use in games; CC Components used on game characters need an **Extended** licence; AI training only under Enterprise (S29) | CC5 price NOT FOUND (page price is loaded by JavaScript) | Paid content store | FBX/OBJ/USD (not opened: NOT FOUND) | CC rig; retargetable (JUDGEMENT) | NOT FOUND | Not applicable |
| E4 | VRoid Studio [S30] | Commercial use of models allowed except items with special terms; some samples are CC0, others have their own conditions; **you may not build an app that generates or outputs models from combined VRoid meshes** without a separate pixiv licence (S30) | Free | Anime-style preset clothing | VRM | VRM humanoid | NOT FOUND | Not applicable (anime style) |
| E5 | Daz 3D [S31] | Games need an Interactive Licence per product, including the base figure; some products don't offer one (S31) | About USD 50 per licence ("normal $50 each", forum post Feb 2025, S31) | Large store | DUF/FBX | Genesis rig | NOT FOUND | Not applicable (cost) |
| E6 | MetaHuman (UE 5.6+) [S32] | Since June 2025, characters and clothing can be used in any engine incl. Godot, under the UE EULA; no AI training; seats needed above USD 1M revenue (S32) | Free under USD 1M (S32) | Outfit Asset system (S32) | Exported from UE (JUDGEMENT) | MetaHuman rig | NOT FOUND (heavy, JUDGEMENT) | Not applicable (realistic AAA, too heavy for a crowd sim, JUDGEMENT) |
| E7 | CharMorph [S33] | Code GPL-3 (SOURCED S33); assets are reported as mixed: Antonia/Reom CC-BY, Vitruvian CC0, MB-Lab bases AGPL-3 (from a search summary of the CharMorph docs, not opened: treat as unverified) | Free | Few clothes (NOT FOUND) | Blender | Rigify (NOT FOUND) | NOT FOUND | Not applicable |
| E8 | Human Generator Ultimate [S34] | Commercial licence: use in games allowed "provided that the Product cannot be extracted and re-used by the end-users"; single user (S34) | USD 68 personal, **USD 128 commercial** (S34) | Clothing included; one user review calls garment quality "mediocre at best" (S34) | Blender | Rigify (S34 review) | NOT FOUND | Not applicable |
| F1 | Simply Cloth Studio 2 (Blender) [S35] | Listed as "Mit" on Superhive; 5-seat studio licence USD 270 (S35) | USD 36; with 200+ Cut & Sew patterns USD 66 (S35) | Cloth sim + pattern library | Blender add-on | Not applicable | Not applicable | Tool: 3-6 h per new garment (JUDGEMENT) |
| F2 | GarmentCode / pygarment (ETH) [S36] | MIT (GitHub API, S36) | Free | Parametric sewing patterns | Python | Not applicable | Not applicable | Research tool; needs a sim/drape step plus game retopo (JUDGEMENT) |
| F3 | Style3D Studio [S37] | Free tier is evaluation/non-commercial; commercial export needs a paid licence (S37) | Paid price NOT FOUND | Garment CAD | GLB/FBX/OBJ (S37) | Not applicable | Not applicable | Not applicable |
| F4 | AI garment research (DressCode, GarmentDreamer, Garment3DGen, ChatGarment, GarmentCrafter) [S38] | DressCode: no licence detected; GarmentDreamer: CC BY-NC 4.0; Garment3DGen: CC BY-NC 4.0; ChatGarment: Apache-2.0; GarmentCrafter: none detected (S38). ClothCombo: NOT FOUND | Free | Research code | Various | None | Not applicable | Not practical for shipping (JUDGEMENT) |
| F5 | Tripo (text/image-to-3D for garments) [S39] | Paid plans: full commercial rights; free plan: Tripo keeps all rights (S39) | Paid plan needed (price not checked: NOT FOUND) | Generated meshes | GLB etc. | Garments come out unrigged, fused and messy (JUDGEMENT) | Varies | 4-8 h per garment cleanup (JUDGEMENT) |
[send-message t45s385] ## 2. Per-source detail notes

### A. MPFB2 / MakeHuman

**Licence (SOURCED)**
- "All core assets are shared under Creative Commons, CC0 ... You do not need to pay anything, include any copyright notices nor give attribution." MPFB code is GPL; MakeHuman code is AGPL. (S3)
- MakeHuman's LICENSE.md lists base mesh, proxies, textures, "Clothes (any MHCLO-based asset)" and poses as CC0 1.0 Universal. It also says output from MakeHuman "contains no trace of program logic", so the GPL/AGPL code licence does not reach your exported characters. (S4)
- Third-party repository assets are "your own responsibility" to check. (S4)
- The system clothes .mhclo header I downloaded says: "This asset was explicitly released as CC0 in september 2020" (copyright holders Data Collection AB, Joel Palmius, Jonas Hauquier). This confirms the "CC0 since 2020" question. (SOURCED S11)
- The asset-pack page splits the packs into "shared under CC0" and "shared under CC-BY". CC-BY needs credit to the author (S1, S5). The CC-BY version number is not stated in the pack headers (measured S11), so it is NOT FOUND. JUDGEMENT: credit as "CC BY" with the author name from the pack page, and put a credits screen in the game.

**Counts (SOURCED S2, S10; tally of the pack-page tables)**
- System assets: 20 clothes, 10 hair, 12 eyebrows, 4 eyelashes, 11 eyes, 23 skins, 7 proxies, 6 teeth, 1 tongue.
- CC0 clothing packs: dress01 13, gloves01 9, hats01 6, hats02 6, pants01 4, shirts01 10, shoes01 23, skirts01 6, suits01 8, suits02 21, underwear01 19, underwear04 4. That makes **129**.
- CC-BY clothing packs: dress02 24, dress03 19, hats03 19, hats04 8, pants02 13, pants03 8, shirts02 13, shirts03 19, shoes02 24, shoes03 12, skirts02 14, suits03 19, underwear02 28, underwear03 11. That makes **231**.
- Hair: hair01 25 (CC0), hair02 21 and hair03 14 (CC-BY). Eyebrows: eyebrows01 14 (CC0). Glasses: glasses01 10 / glasses02 5. Masks: 9 / 4.
- Community repository total: "a few thousand assets" (S12). Exact clothes count: NOT FOUND.

**Gym-relevant items found by name (SOURCED S10)**
- Staff and coaches:
  - polo: namuhekam_male_polo_shirt (CC0)
  - tees: toigo_basic_tucked_t-shirt, elvs_crude_t-shirt_male, joepal_crude_t-shirt_female (CC0); elvs_male_logo_tshirt1, drednicolson_short-tail_camo_tee (CC-BY)
  - uniforms: elvs_emt_uniform_jacket/pants, elvs_male_coveralls_1 (CC-BY)
  - other: male_worksuit01 (CC0)
- Members and boxers:
  - all-in-one sportswear: female_sportsuit01 (CC0)
  - tank tops: elvs_male_tankshirt1, elvs_male_muscle_shirt1, mindfront_tank_top_01, punkduck_sleeveless_shirt, elvs_male_athletic_tank1 (CC-BY)
  - shorts and trunks: elvs_male_swim_shorts1, mindfront_male_swimming_trunks_01-03, elvs_male_trouser_short_1/2 (CC-BY); cortu_jeans_shorts (CC0)
  - tracksuits and suits: elvs_hooded_sweat_jacket1, elvs_sporty_tracksuit_hoodie_dress1, punkduck_triathlon_suit_female (CC-BY)
  - gloves: learning_mma_fighting_gloves (CC0)
  - shoes: punkduck_running_shoes_01, punkduck_tennis_shoes, punkduck_comfortable_sneakers, culturalibre_sneakers (CC-BY)
  - headwear: punkduck_sun_visor_sports_visor, elvs_slouchy_beanie1, mindfront_patrol_cap (CC-BY); jujube_newsboy_cap (CC0)
- Customers (street clothes): male_casualsuit01-06, female_casualsuit01/02 (CC0); jeans and trousers in pants02 (CC-BY).
- **Missing:** boxing headgear, hand wraps, boxing gloves, a proper tracksuit with full-length pants, and a baseball cap. NOT FOUND in the pack lists.
- **Avoid (IP/brand risk, JUDGEMENT):** slayer227_spider-gwen, green_tomato_rei_ayanami, punkduck_deathnote_t-shirt, toigo_maga_hat. (Names from S10.)

**Measured quality (SOURCED S11, my measurement)**
- System outfits: 3,240-7,168 tris for most. male_casualsuit01 is 16,672 and male_elegantsuit01 is 14,956. Shoes: 3,064-4,128.
- Textures: system outfits usually have 3 maps (diffuse, normal, ao, e.g. female_sportsuit01) at 2048-4096 px. Shoes are 1024 px.
- CC-BY shirts03 items range from 1,288 to 112,004 tris. elvs_male_athletic_tank1 at 112,004 and elvs_ladies_tank1 at 62,624 need decimation.
- Swim shorts and trunks are light: 728-1,248 tris.
- Most items contain a delete-vertex section. A few don't (elvs_male_athletic_tank1, elvs_male_trouser_short_1/2), which means skin can poke through.
- JUDGEMENT: the textures are good enough for a 3/4 management camera. At close-up, the system "casualsuit" textures look dated (baked folds, low-frequency detail). Downsize to 1024-2048 for a crowd.

**How fitting works (SOURCED S8, S5)**
- Each .mhclo maps every clothes vertex onto basemesh vertices (barycentric weights + offset), so the garment follows any MPFB body shape.
- ClothesService creates "delete" vertex groups with MASK modifiers to hide skin under clothes.
- When a rig is present, bone weights are interpolated from the basemesh to the clothes. Optional sub-rigs and weight overrides come from sidecar files.
- `create_mhclo_from_clothes_matching` can make new MHCLO data from any clothes mesh (the MakeClothes workflow).
- The FAQ warns that assets made for one body type may not fit others; "skin might peek through" when the delete group is missing.

**Export to Godot (SOURCED S6, S7, S9)**
- Use the "GameEngine" material, which is texture-based PBR and "most likely to translate".
- Use the "GameEngine" rig ("100% mapping for Unity's Mechanim"). The rig files are rig.game_engine.json (53 bones: Root, pelvis, spine_01-03, neck_01, head, clavicle/upperarm/lowerarm/hand, thigh/calf/foot/ball, fingers 01-03), plus game_engine_with_breast, mixamo, mixamo_unity, default, cmu_mb and openpose.
- "Export Copy" bakes shape keys, deletes helpers, and lets you **Bake** the mask modifiers (that is, permanently delete hidden skin).
- If you use a proxy, delete the basemesh before export.
- The MPFB docs show FBX export settings. glTF/GLB export from Blender is the usual Godot path (JUDGEMENT).
- In Godot's importer, map the skeleton with a BoneMap on SkeletonProfileHumanoid and use Bone Renamer to get Hips / Spine / LeftUpperArm names (SOURCED S40). This is the same names the existing bodies use.
- Release state: MPFB2 latest GitHub release is v2.0.18, published 2026-10-11 (UTC) (SOURCED S9).

**Tripo bodies (JUDGEMENT)**
- There is no basemesh correspondence, so MHCLO can't fit to them.
- Options:
  - (a) rebuild those characters as MPFB bodies, about 1-2 h each;
  - (b) fit each garment by hand in Blender (Shrinkwrap/Surface Deform + Data Transfer weights), about 2-4 h per garment per body;
  - (c) give Tripo bodies only "baked" outfits, so they never swap clothes.

### B. Stylised modular sets

**Quaternius Universal Base Characters (Aug 2025)**
- 6 base models, 20 hairstyles, "Humanoid Rig compatible with retargeting in any engine", average 13k triangles, CC0, FBX and glTF, Godot 4.3 engine project (S14).
- Free Standard version; Source USD 19.99 (S16).
- Compatible outfits exist only as **Modular Character Outfits - Fantasy**: 12 outfits / 62 parts / 3 textures each, CC0, v2.0 (29/1/2026) improved "a lot less clipping", v2.1 (5/7/2026) (S15).
- I found no modern, sport or casual outfit pack on quaternius.com (pack list checked 2026-10-12, S14). A "modern outfits" pack is NOT FOUND.
- JUDGEMENT: the bases fit a Two-Point-like look, but you'd model about 12-20 gym/street garments yourself.

**Ultimate Modular Men / Women (Feb 2022)**
- 11 / 10 characters, each split into 4 swappable parts, 24 animations, CC0, FBX/OBJ/glTF/Blend. Women "humanoid rig version also included" (S17).
- Garment themes: NOT FOUND (page text doesn't list them).

**Kenney**
- All CC0, "Credit ... not mandatory" (S18).
- Mini Characters (2024): 12 characters, 32 animations incl. wheelchair use.
- Blocky Characters 2.0: 18 PNG skins, 27 animations.
- Animated Characters 3: 4 skins, 3 animations.
- Variety comes from swapping textures on one mesh, which is a useful trick (Section 3). JUDGEMENT: far too simple for a management-sim close-up.

**KayKit Adventurers**
- CC0, 5 (+3 EXTRA) characters, 1024 px gradient atlas, FBX/glTF, Rig_Medium/Rig_Large (S19).
- The KayKit Godot video maps the rig to SkeletonProfileHumanoid (S19).
- Fantasy only. JUDGEMENT: wrong theme.

### C. Sketchfab CC-BY / CC0 checks (SOURCED S20, all checked via `/v3/models/<uid>` on 2026-10-12)

- Searching with `downloadable=true&license=cc0` for tracksuit, hoodie, t-shirt, sneakers, boxing and outfit+rigged returned **no CC0 clothing**. Only CC Attribution (CC-BY) results came back.
- Every item below has `isAgeRestricted: false` and `isDownloadable: true`.
- Credit format required by CC-BY: author + title + link + licence (JUDGEMENT on format).

| UID | Name | Author | Licence | faceCount | animationCount | Published | Use? |
|---|---|---|---|---|---|---|---|
| 498387769b0347f292ab1bdbddbfe719 | Boxing Headgear Helmet (Low Poly) | artel_3D | CC Attribution | 13,070 | 0 | 2026-01-26 | Yes: rigid on Head bone |
| 9a43d1767d9e4296bdd0e8b51f80d20a | Boxing headgear fbx | chillax12 | CC Attribution | 18,740 | 0 | 2024-06-10 | Backup |
| 58b8fd62214043149ec65c2e7436c2d0 | Boxing Glove | Just_som | CC Attribution | 2,226 | 0 | 2024-11-02 | Yes: light, rigid on Hand bone |
| 5b464201104949e09f77f2d1cf8b60c3 | Boxing Glove (tag "noai") | incg5764 | CC Attribution | 4,064 | 0 | 2023-02-23 | Yes, but don't feed it to AI tools |
| c1572e87f6f2467caf1ece6cf39d10e6 | Boxing gloves | Nixak | CC Attribution | 49,352 | 3 | 2024-07-19 | Too heavy |
| 4029542180bd4bb68a039fc00a200b3c | Shorts Boxer (Marvelous Designer, "gameready" tag) | suttonj94 | CC Attribution | 73,736 | 0 | 2026-05-31 | Retopo needed |
| c78b9c725db44324b3246cc59af1947e | Polo_Shirt | WatsonAndrew | CC Attribution | 11,500 | 0 | 2021-03-15 | Maybe (static) |
| f72f208b242a415c84d0087a790faa5f | Male sweatpants and sweatshirt (anorak) | kurmanin | CC Attribution | 14,890 | 0 | 2024-07-02 | Maybe: tracksuit stand-in |
| 4fc7bc06a5b94568b1923268f4a6e825 | Hoodie and Jeans | lizhiqiang89 | CC Attribution | 10,542 | 0 | 2021-06-17 | Maybe |
| 2cf897e60140403ba8368ea9e83c1e56 | Hoodie Version 2 (tag "rig") | DreamNoms | CC Attribution | 5,512 | 1 | 2020-10-06 | Maybe: winter coat, not a hoodie |
| 53effc8d26434c6da8bf1a9a921e1e52 | Baseball Cap | flokapokaa | CC Attribution | 1,704 | 0 | 2023-07-11 | Yes: rigid on Head |
| 437565ba5304406f96a58c32eb60fb15 | Baseball Cap Pack | secludo | CC Attribution | 9,678 | 0 | 2024-08-10 | Yes |
| 4b656eb1ee984a9eb1dedd8ebaafe3ed | Female boxer (tag "rigged") | taquitosdecarnita0 | CC Attribution | 21,374 | 0 | 2026-08-26 | Reference only (different body) |

**Avoid (JUDGEMENT, based on S20 tags/names)**
- a6bb200b0a7e4788a4d2a3c97a1fab49 "Floyd Tracksuit" (tag "gtav", likely a game rip).
- "Goat Simulator Mobile ... Tracksuit" entries (c812449137b645e089643a60fdefde73, 4ce88d746dfb45ea953f79937932550f, 7c6aad17768d48af92e3dd5c9ff866e9): game-asset rips are likely despite the CC label.
- a9022683c61a4db7bdc24d8afc7671c5 "Women Sportswear" (tag "nike").
- 51edfec934004084b0ec3ec13e0b87bc (CC BY-SA, share-alike).
- b71acb2dcaf244909f8cfb8f11346d89 (Sketchfab "Free Standard", not CC).

**Hand wraps:** no relevant downloadable model found (NOT FOUND). JUDGEMENT: model them as a thin skinned sleeve made from the hand/forearm mesh (duplicate the faces, push them out 2 mm, add a tape texture), about 2-3 h. Or make them an .mhclo through MakeClothes so they auto-fit every MPFB body.

### D. Paid stores (cheap, engine-agnostic only)

**Synty (S21, S22)**
- The One-Time Purchase Licence (as at 9 July 2026) "is not limited by game engine, OS, platform or device".
- Prohibited: use in "Generative AI Programs" datasets or development, and "Generation of 3D models utilising Generative AI Programs". Also: "You may not upload source files or models to third party services for the purpose of 3D model gene[ration]". Source files must not be shared outside your team.
- JUDGEMENT: never run Synty meshes through Tripo or similar tools; keep the Synty and Tripo pipelines separate.
- Prices (S22):

| Pack | Price | Contents |
|---|---|---|
| POLYGON City Characters | USD 29.99 | 19 characters |
| POLYGON Office | USD 49.99 | 18 characters + 626 props |
| SIMPLE Citizens | USD 19.99 | 16 cube-style characters, about 300 tris each, includes "Runner" and "Football Player" |
| Sidekick Free Starter | USD 0 | 50+ sci-fi/fantasy parts |
| Sidekick Modern Civilians | USD 199.99 | 160+ modern parts |

- Sidekick is "Fully rigged to the Unity Humanoid skeleton" and the creator tool is Unity/UE (S22). Third-party Godot Sidekick tools exist per a search summary (jgillich "Sidekick Creator" on itch), but I did not verify them (NOT FOUND/unverified).

**Unity Asset Store (S23-S25)**
- Unity support says assets "are not restricted to Unity projects". The limits: no standalone redistribution, no extractable raw files, no monetising them inside user-generated content, and no "primary purpose" of giving others the asset (S23).
- Concrete cheap packs:
  - "Character Pack - Boxers Low Poly": EUR 7.35, 7 rigged boxers, max 2,200 polys, 1 texture (S24).
  - "Boxing Fighters Pack": EUR 27.59, 2 boxers, about 6,330 verts each, separate gloves/shorts meshes, 4K/2K PBR, Unity humanoid, no animations (S25).
- JUDGEMENT: the Boxing Fighters gloves and shorts are the most "drop-in" realistic boxing gear found, but they are skinned to their own body and need refitting (2-4 h each).

**Fab (S26)**
- Standard License: "Use the assets with any compatible tools (usage is not limited to Unreal Engine)". No standalone resale or redistribution. No credit required.
- A NoAI tag restriction is reported by a third-party summary (search result), not verified on fab.com: unverified.
- Concrete Fab clothing packs with prices: NOT FOUND (the listings render with JavaScript; I did not get prices).

### E. Other character systems

- **Mixamo (S27):** the Adobe staff FAQ (2022-09-29) has "YES" for video games and DLC. "NO" covers asset packages or templates that "redistribute character or animation raw files", and "Any type of free distribution of character or animation raw files". Machine-learning training is excluded. No credit is required. JUDGEMENT: shipping them inside the game's packed resources is fine; don't ship loose FBX files in a mod kit.
- **Ready Player Me (S28):** Netflix acquired it (TechCrunch, 2025-12-19), and it is "winding down its services on January 31, 2026, including ... PlayerZero". It is dead for us.
- **Reallusion CC5 (S29):**
  - Licence update 2025.8.1: the Standard licence allows export "to any external software or game engine" and use in games.
  - The FAQ also says CC Components (ccCloth, ccShoes, ...) on characters "in games ... for mass distribution" need an **Extended** licence.
  - AI training and "character creation system" uses need an Enterprise licence.
  - Price not verified (NOT FOUND).
- **VRoid (S30):** commercial use is allowed, but you "cannot create an application that can generate or output 3D models, avatars, or items consisting of deformed or combined meshes and textures that were created in VRoid Studio" without a pixiv licence. JUDGEMENT: FightCamp's random-character generator could fall under that clause, so avoid VRoid. The anime style also doesn't fit.
- **Daz (S31):** an "Interactive License is required when using or distributing 3D content ... in video games". You also need one for the base figure. A forum user cites "the normal $50 each". JUDGEMENT: too expensive per garment.
- **MetaHuman (S32):** CG Channel (2025-06-04) reports MetaHuman characters and clothing "can now be ... used in commercial projects created with other DCC apps or game engines", Godot included. There is no 5% royalty because they are "non-engine products". AI training is not allowed. So the brief's assumption "UE-only, cannot ship in Godot" is **outdated**. JUDGEMENT: the meshes are still too heavy and too realistic for a 30-person gym sim.
- **CharMorph (S33):** code GPL-3. Asset licences are mixed per base, and MB-Lab-derived bases are reportedly AGPL (from a search summary; treat as unverified).
- **Human Generator (S34):** USD 128 commercial. Games are OK only if assets can't be extracted and re-used by end users. Single-user licence. One review calls the clothing "mediocre at best".

### F. Garment-making tools and AI

- **Simply Cloth Studio 2:**
  - USD 36, or USD 66 with 200+ Cut & Sew patterns; studio 5-seat licence USD 270; supports Blender 4.0-5.2 (S35).
  - The page also has leftover v1.5 text quoting USD 170 / 3 seats, which is inconsistent. Use the current variant list (USD 270 / 5 seats).
- **GarmentCode:** MIT, last push 2025-06-29 (S36). Parametric sewing patterns. You still need draping (their sim or Blender), then game retopo. JUDGEMENT: interesting, but more work than MakeClothes for 5 roles.
- **Style3D Studio:** the free trial can't be used for monetised projects (S37). Paid price NOT FOUND.
- **AI garment research code** (S38) is mostly non-commercial (CC BY-NC) or unlicensed. ChatGarment is Apache-2.0 but is a research model. JUDGEMENT: not a shipping pipeline in 2026.
- **Tripo for garments:** paid plans give "full rights to use, modify, distribute, and commercially exploit". Free-plan outputs belong to Tripo (S39). JUDGEMENT: the generated clothes come out as one closed, fused shell with no inside, no clean topology and no weights. That is fine for a rigid prop like a glove or headgear (after decimation), but poor for anything that bends at elbows and knees.
[send-message t45s386] ## 3. Godot: outfit swapping and variety tricks

**How outfit swapping works (SOURCED S40)**
- A skinned MeshInstance3D has three things: a `skeleton` NodePath, a `mesh`, and a `skin`. The Skin stores bind poses and either bone **names** ("Use Named Skins") or bone indices.
- MeshInstance3Ds can share binds (typical from Blender) or have separate Skins.
- Practical recipe (JUDGEMENT built on S40):
  - Import each garment GLB with the **same BoneMap/Bone Renamer** as the bodies, so the bone names are identical (Hips, Spine, LeftUpperArm ...).
  - Keep "Use Named Skins" on.
  - At runtime, move the garment's MeshInstance3D under the character's Skeleton3D, or set its `skeleton` path to it, then free the old garment node.
- BoneAttachment3D "dynamically copies or overrides the 3D transform of a bone". Use it for **rigid** items: boxing gloves on LeftHand/RightHand, headgear and caps on Head, whistle/clipboard for coaches.
- SkeletonProfileHumanoid has 56 bones in 4 groups (Body, Face, LeftHand, RightHand), root "Root", scale base "Hips" (S40).
- Retarget options: Bone Map, Remove Tracks, Bone Renamer, Rest Fixer. "Fix Silhouette" should be enabled for A-pose models (S40).

**Hiding skin under clothes**
- Preferred: bake MPFB delete groups per look before export (S7), giving one body mesh per outfit "class" (e.g. "body_for_tanktop", "body_for_longsleeve").
- Alternative (JUDGEMENT): split the body mesh into regions (torso, upper arms, forearms, thighs, shins, feet) as separate surfaces. Each garment declares which regions it covers, and the code hides those surfaces. The cost is visible seams and a slightly higher draw-call count. It gives true runtime mixing without rebaking.
- Another option: per-region visibility as shape keys that collapse hidden skin, or an alpha-mask texture plus discard in the body shader. Cheap, but there is a small overdraw cost (JUDGEMENT).

**Cheap variety (SOURCED mechanism S40; numbers JUDGEMENT)**
- `instance uniform vec3 tint_a, tint_b, tint_c;` in one shared garment ShaderMaterial, set via `set_instance_shader_parameter()`. One material serves every character, each with different colours.
- Per-instance uniforms "do not support textures or arrays". For logos, pass a texture array as a normal uniform plus an instance `int` index (S40).
- Author each garment with a **mask texture**: R = primary colour, G = secondary/trim, B = logo area, A = untinted. Multiply the greyscale albedo by the chosen palette.
- `material_override` / `material_overlay` exist on GeometryInstance3D for whole-mesh swaps (S40). Kenney-style **texture-skin swapping** is a second axis (S18).
- Variety maths, as an example:
  - Coach: 2 garments (tracksuit, polo) x 6 palettes x 3 club logos = 36 looks.
  - Member: 4 tops x 3 bottoms x 6 palettes = 72 looks.
  - Add hair (10 system + 25 CC0 MakeHuman hair, S2/S10), skin tones (23 system skins, S2), and body shapes from the 23 bodies.
- Performance (JUDGEMENT): about 4-6 skinned meshes per person x 30 people = 120-180 skinned draws. That is fine on desktop PC at 2-5k tris per garment. Use LODs and turn off shadows on small items (S40 lists shadow-casting settings).

---

## 4. Top-3 ranking

Scores are 1-5, higher is better. All scores are JUDGEMENT, based on the facts above.

| Rank | Route | Quality at 3/4 camera | Close-up | Cost | Fit effort | Licence safety | Total /25 | Reasons |
|---|---|---|---|---|---|---|---|---|
| 1 | **MPFB2 bodies + MakeHuman CC0/CC-BY clothes + 3-5 custom/Sketchfab boxing items** | 4 | 3 | 5 | 4 | 5 | **21** | Keeps the 23 bodies (MPFB ones auto-fit). About 380 pack items, 20 CC0 system clothes (S1, S2). The mhclo files themselves say CC0. Weak spots: dated textures, no boxing gear, Tripo bodies need manual fits. |
| 2 | **Swap to Quaternius Universal Base Characters (CC0) + self-made modern outfits** | 4 | 4 | 4 | 2 | 5 | **19** | Matches the J_TPH_LOOK Two-Point direction and gives a consistent, readable silhouette. 13k tris and the humanoid rig retarget easily (S14). But there are **no modern outfits** (only fantasy, S15), so 12-20 garments must be modelled, and the existing bodies are thrown away. |
| 3 | **Synty POLYGON City / Office characters (+ optional Sidekick Modern Civilians)** | 3 | 2 | 3 | 4 | 3 | **15** | Ready-made modern people at USD 29.99-49.99, or 199.99 for Sidekick (S22), and any engine is allowed (S21). But the faceted low-poly look clashes with both other routes. The tools are Unity-first. The EULA's generative-AI clauses sit awkwardly with a Tripo-based studio. No boxing gear. |

Not ranked:
- Sketchfab-only: everything is unrigged, CC-BY, high-poly, with mixed provenance.
- VRoid: generator clause.
- Daz: about USD 50 per product licence.
- MetaHuman: too heavy.
- RPM: shut down.
- AI garments: non-commercial or immature.

**Style consistency flag (JUDGEMENT)**
- Route 1 and Route 2 can't share garments. MHCLO clothes need the MPFB basemesh, and Quaternius outfits are built for Quaternius bodies.
- Mixing MPFB realistic people with Quaternius or Synty stylised people in one gym will look like two games. Kenney and KayKit are even further apart.
- Choose the style before buying or making clothes.
- A middle path exists: MPFB can make chunkier, less realistic proportions, and a toon/flat shader can unify MakeHuman clothes with the Two-Point look. This is cheaper than Route 2, but it will never fully match Quaternius.

---

## 5. Recommended pipeline and hours (5 roles x 6 looks = 30 looks)

**Step 0: style gate (4-6 h, JUDGEMENT)**
- Render one MPFB body in a MakeHuman tank top and swim shorts, next to one Quaternius base, at the game's 3/4 camera and at close-up, under the game's lighting and toon shader.
- The operator picks. If MPFB wins, follow Route 1 below. Otherwise go to Route 2.

**Route 1 pipeline (all hours JUDGEMENT)**

| Step | Work | Hours |
|---|---|---|
| 1 | Install the MPFB2 v2.0.18 add-on and download: system assets, shirts01-03, pants01-03, shoes01-02, gloves01, hats01/03, suits03, hair01 (S1, S9). Note each CC-BY author for credits. | 3-4 |
| 2 | Shortlist about 20 garments for 5 roles (below). Reject IP items and items without delete groups or over 15k tris, or decimate them. | 3-4 |
| 3 | Make 4 missing items: hand wraps and boxing shorts as new .mhclo via MakeClothes (S8); gloves and headgear as rigid Sketchfab CC-BY props (S20: gloves 58b8fd62..., headgear 498387769b...) on BoneAttachment3D. Cleanup, retexture, decimate. | 12-18 |
| 4 | Texture pass: convert every chosen garment to a greyscale albedo plus RGB tint mask, downsize to 1024-2048 px, and add a club-logo decal slot. | 12-20 |
| 5 | Batch script in Blender (MPFB Python services, e.g. ClothesService, S8): for each MPFB body x each allowed garment, equip it, Export Copy (bake masks), and export the garment mesh plus a matching masked body variant to GLB. Clothes inherit interpolated weights (S8). | 10-16 |
| 6 | Tripo bodies: either remake them as MPFB bodies (1-2 h each) or give them 1-2 fixed baked outfits each (2-4 h per garment). Assume 6 Tripo bodies x 1 outfit. | 12-24 |
| 7 | Godot: import preset (BoneMap → SkeletonProfileHumanoid, Bone Renamer, Use Named Skins); an `Outfit` resource (garment scenes, covered regions, palette slots); runtime swap helper; tint shader with instance uniforms; palette tables per role. | 10-14 |
| 8 | QA: walk/punch/sit animations at 3/4 and close-up; fix poke-through (delete-group tweaks, push garment out 1-2 mm); LOD/shadow settings. | 10-16 |
| 9 | Credits file for CC-BY authors (MakeHuman CC-BY packs and Sketchfab items). | 1-2 |

**Total Route 1: about 75-120 h**, which matches the 80-120 h headline. Cash cost USD 0 (or EUR 27.59 if you take the Unity Boxing Fighters gloves/shorts instead of Sketchfab).

**Role kit (garment names from S2/S10; selection JUDGEMENT)**

| Role | Base garments | Looks from palettes and logos |
|---|---|---|
| Coach | Tracksuit: elvs_hooded_sweat_jacket1 + pants02 trousers in a tinted track colour; polo: namuhekam_male_polo_shirt; cap: Sketchfab 53effc8d...; sneakers | 2 tops x 3 palettes = 6 |
| Staff | Polo (staff colours), basic tucked tee, work trousers (male_worksuit01 trousers or pants02) | 6 via palette and name-badge decal |
| Member | female_sportsuit01, tank tops (mindfront_tank_top_01, elvs_male_tankshirt1), crude tees, swim shorts as gym shorts, running shoes, visor/beanie | 6 or more |
| Customer | male_casualsuit01-06, female_casualsuit01/02, jeans, newsboy cap | 6 from the CC0 system outfits alone |
| Boxer | Tank/muscle shirt or bare torso + new boxing shorts .mhclo + hand wraps .mhclo + rigid gloves + rigid headgear (sparring only) | 6 via shorts/glove colours and trim |

**Route 2 hours, if the stylised look wins (JUDGEMENT)**
- Quaternius UBC import and Godot retarget: 4-6 h.
- Model, UV and skin about 15 modern garments to the UBC bodies: 15 x 4-6 h = 60-90 h.
- Boxing gear: 10-15 h.
- Tint-mask textures: 10-15 h.
- Godot swap and shader: 10-14 h.
- QA: 10-15 h.
- **Total about 105-155 h**, plus re-doing the 23 existing characters as UBC bodies (8-15 h). That is the 110-170 h headline.
- Alternative: buy Synty Sidekick Modern Civilians (USD 199.99) to cut the garment modelling, but this is Route 3 style, with Unity-humanoid parts and EULA AI limits.
[send-message t45s387] ## 6. Sources list with dates

All accessed 2026-10-12. "No date" means the page shows no date.

- **S1** https://static.makehumancommunity.org/assets/assetpacks.html (release notes, latest "Release 2026-02-07")
- **S2** https://static.makehumancommunity.org/assets/assetpacks/makehuman_system_assets.html (no date; 267 MB pack)
- **S3** https://static.makehumancommunity.org/about/license.html (no date)
- **S4** https://github.com/makehumancommunity/makehuman/blob/master/LICENSE.md and LICENSE.ASSETS.md (no date shown)
- **S5** https://static.makehumancommunity.org/assets/assetpacks/faq.html (no date)
- **S6** https://static.makehumancommunity.org/mpfb/docs/exporting/index.html (no date)
- **S7** https://static.makehumancommunity.org/mpfb/docs/exporting/export_copy.html (no date)
- **S8** https://github.com/makehumancommunity/mpfb2/blob/master/docs/services/clothesservice.md (no date)
- **S9** https://github.com/makehumancommunity/mpfb2 : rigs directory `src/mpfb/data/rigs/standard`, rig.game_engine.json, latest release v2.0.18 published 2026-10-11T12:49Z (= 15:49 Asia/Nicosia)
- **S10** https://static.makehumancommunity.org/assets/assetpacks/<pack>.html for shirts01-03, pants01-03, shoes01-03, gloves01, hats01-04, dress01-03, skirts01-02, suits01-03, underwear01-04, hair01-03, eyebrows01, glasses01-02, masks01-02 (no dates)
- **S11** Own measurement of downloaded `makehuman_system_assets_cc0.zip`, `shirts03_ccby.zip`, `pants03_ccby.zip` from files.makehumancommunity.org (2026-10-12): vertex/tri counts from .obj, texture sizes from PNGs, licence lines from .mhclo headers
- **S12** https://static.makehumancommunity.org/mpfb/faq/other_assets.html (no date)
- **S13** http://www.makehumancommunity.org/clothes.html (no date)
- **S14** https://quaternius.com/packs/universalbasecharacters.html (pack dated August 2025); pack list from https://quaternius.com/
- **S15** https://quaternius.com/packs/modularcharacteroutfitsfantasy.html (November 2025); https://quaternius.itch.io/modular-character-outfits-fantasy (changelog v2.0 29/1/2026, v2.1 5/7/2026) and /purchase
- **S16** https://quaternius.itch.io/universal-base-characters and /purchase ("Updated 25 days ago")
- **S17** https://quaternius.com/packs/ultimatemodularcharacters.html and https://quaternius.com/packs/ultimatemodularwomen.html (February 2022)
- **S18** https://www.kenney.nl/assets/mini-characters (released 2024); https://opengameart.org/content/mini-character-1 (2024-07-17); https://www.kenney.nl/assets/blocky-characters and https://opengameart.org/content/blocky-characters (2025-06-10); https://kenney-assets.itch.io/animated-characters-3; https://kenney.nl/assets/animated-characters-survivors
- **S19** https://kaylousberg.itch.io/kaykit-adventurers and /purchase ("Updated 25 days ago"); https://godotengine.org/asset-library/asset/2129 (2024-04-26); https://www.youtube.com/watch?v=4p7QaOd8SHE
- **S20** Sketchfab API: https://api.sketchfab.com/v3/search?type=models&q=<q>&downloadable=true (and &license=cc0), plus https://api.sketchfab.com/v3/models/<uid> for each UID in Section 2.C (publish dates per row)
- **S21** https://syntystore.com/pages/one-time-purchase-licence ("As at 9 July 2026")
- **S22** https://syntystore.com/products.json and product pages: modern-civilians-sidekick-modular-characters (published 2025-10-23), sidekick-modular-characters-starter-pack (2025-10-01), polygon-city-characters-pack (2018-08-08), polygon-office-pack (2020-01-09), simple-citizens-cartoon-characters (2023-01-19)
- **S23** https://support.unity.com/hc/en-us/articles/34387186019988-Can-I-use-assets-from-the-Asset-Store-with-other-engines ("1 year ago Updated"; the brief cites 2025-07-02, which I could not confirm)
- **S24** https://assetstore.unity.com/packages/3d/characters/humanoids/character-pack-boxers-low-poly-223271 (release Jun 6, 2022); https://elvismd.itch.io/character-pack-boxers
- **S25** https://marketplace.unity.com/packages/3d/characters/humanoids/humans/boxing-fighters-pack-two-game-ready-characters-335674 (release Sep 26, 2025)
- **S26** https://www.fab.com/eula (no date)
- **S27** https://community.adobe.com/questions-696/mixamo-faq-licensing-royalties-ownership-eula-and-tos-589400 (September 29, 2022)
- **S28** https://techcrunch.com/2025/12/19/netflix-acquires-gaming-avatar-maker-ready-player-me/ (December 19, 2025)
- **S29** https://www.reallusion.com/license/content.html ("License Update (2025.8.1)")
- **S30** https://vroid.pixiv.help/hc/en-us/articles/4405813333657 and https://vroid.pixiv.help/hc/en-us/articles/4402614652569 (no date)
- **S31** https://www.daz3d.com/interactive-license-info (no date); https://www.daz3d.com/forums/discussion/721771 (February 2025)
- **S32** https://www.cgchannel.com/2025/06/you-can-now-sell-metahumans-or-use-them-in-unity-or-godot/ (June 4, 2025)
- **S33** https://github.com/Upliner/CharMorph/blob/master/license.txt (no date; repo last push 2025-05-29); asset-licence detail from a search summary of https://charmorph-docs.readthedocs.io (not opened)
- **S34** https://humgen3d.com/pricing and https://humgen3d.com/docs/faq/human-generator-asset-license (no date)
- **S35** https://superhivemarket.com/products/simply-cloth (no date; v2.0.7 variants)
- **S36** https://github.com/maria-korosteleva/GarmentCode (MIT per GitHub API, last push 2025-06-29); pygarment v2.0.2 on PyPI (from search, not opened)
- **S37** https://www.style3d.com/blog/who-owns-the-3d-models-i-create-with-style3d/ (May 2026)
- **S38** GitHub API: IHe-KaiI/DressCode (push 2024-10-07, no licence), boqian-li/GarmentDreamer (CC BY-NC 4.0, push 2025-10-02), nsarafianos/Garment3DGen (CC BY-NC 4.0, push 2024-07-09), biansy000/ChatGarment (Apache-2.0, push 2025-08-07), humansensinglab/garment-crafter (no licence, push 2026-07-28)
- **S39** https://www.tripo3d.ai/help/privacy-policy/how-to-use-tripo-models-commercially (no date)
- **S40** Godot 4.7 docs: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/retargeting_3d_skeletons.html ; /classes/class_skeletonprofilehumanoid.html ; /classes/class_meshinstance3d.html ; /classes/class_geometryinstance3d.html ; /classes/class_boneattachment3d.html ; /tutorials/shaders/shader_reference/shading_language.html (per-instance uniforms) ; /tutorials/assets_pipeline/importing_3d_scenes/import_configuration.html (Use Named Skins) (no dates; docs labelled 4.7)
- **S41** J_TPH_LOOK memo, 2026-10-11 (cited from the brief; not re-read)

---

## 7. Limits

- **Not counted:**
  - Total clothes in the MakeHuman community repository: NOT FOUND. My box couldn't reach www.makehumancommunity.org, and the page shows no total. S12 says only "a few thousand assets" overall.
  - Polycounts were measured for 3 packs only (system, shirts03, pants03). The other packs are NOT FOUND for polycount.
- **Not verified:**
  - Character Creator 5 price, Fab clothing pack prices, Tripo plan prices, Style3D paid price.
  - CharMorph per-asset licences and the Fab NoAI clause (both from search summaries only).
  - Third-party Godot Sidekick tools.
  - The Mixamo current stock-character list.
  - The Unity support article date of 2025-07-02 (the page says "1 year ago").
- **Not tested:**
  - No garment was actually exported from MPFB to Godot here. The import, retarget and swap recipe in Section 3 is based on the docs.
  - How cleanly MPFB's GameEngine rig maps to SkeletonProfileHumanoid is JUDGEMENT. Spot-check fingers and toes ("ball_l/r").
- **Licences:**
  - CC-BY version numbers for the MakeHuman packs aren't stated ("CC-BY"/"CCBY" in the headers).
  - Sketchfab's "CC Attribution" label is taken as CC BY; I did not re-check the exact version.
  - Sketchfab models can mislabel licences. "Avoid" picks are based on tags and names, not on legal checks.
- **Hours** are JUDGEMENT for one Blender/Godot-competent developer. They exclude new animations and any re-rigging of the Tripo bodies beyond what is listed.
- **Style:** J_TPH_LOOK was not re-read. The style recommendation depends on the operator's choice at Step 0.

---

That's the whole document. A copy is on my computer at `/workspace/jclothes/J_CLOTHES_S207.md`, so Claude can land it as `research/J_CLOTHES_S207.md`.

Two corrections to the brief came out of this: MetaHuman can now be used in Godot (since June 2025), though it's still too heavy for us, and Ready Player Me shut down on 2026-01-31. About 400 MB of downloaded test packs are in `/workspace/jclothes/dl/` and can be deleted.
