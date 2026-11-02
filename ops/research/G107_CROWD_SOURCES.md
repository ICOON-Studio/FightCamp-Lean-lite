<!-- Grok (grok.com, Expert, in-app browser), collected verbatim by Claude S81 2026-09-26 from
https://grok.com/c/cb18989d-18f0-4ef3-9e69-df6adb1706c9 ("113 sources"). Brief: TASK_G107_CROWD_SOURCES.md.
Tables re-set as markdown; wording unchanged. Licences are Grok's reading - re-read each licence page before any
download or purchase (both are the operator's yes). -->

# G107_CROWD_SOURCES

**What a human TA would ship.** Near camera: a few dozen hero or mid-poly seated meshes. Mid stands: GPU-instanced low-poly with VAT (or palette-skinned instancing). Far rows: camera-facing cards / octahedral impostors. Colour via instance data. 4–6 cycles (sit-idle, fidget, clap, cheer, stand-cheer). Chunk instances so the whole bowl is not one uncullable draw. That stack is industry-standard, not a Godot quirk. SOURCED GPU Pro stadium chapter (instancing + deferred + impostors) https://www.taylorfrancis.com/chapters/edit/10.1201/b22483-9/optimized-stadium-crowd-rendering-alan-chambers 2018-04-17. SOURCED MoCap Online sports-anim guide (ISM + VAT past row ~2–3; 50–100 skeletal near) https://mocaponline.com/blogs/mocap-news/sports-animation-games-guide 2026-03-17. SOURCED Pelechano/survey: FIFA 15 "up to 120,000 animated virtual spectators… seated… no navigation" https://www.cs.upc.edu/~npelechano/abstract_prePrintCGF2015Survey.pdf 2015-09-24. JUDGEMENT FightCamp's 6-row walkout is a near problem, not a 120k stadium problem. Fill seats first; fidelity second.

## 1. Shipped sports games
| Title | Public method | Numbers | Tag |
|---|---|---|---|
| FIFA 14–15 | Full 3D seated crowd (left 2D stand cards behind) | FIFA 15 cited at 120k seated animated | SOURCED GamesRadar https://www.gamesradar.com/best-crowds-in-games/ 2013-12-12; Pelechano 2015 above |
| NBA 2K14 | Per-seat 3D spectators, lit, stand/wave | Court is small; Visual Concepts treated as gold standard | SOURCED GamesRadar 2013-12-12 |
| Stadium tech (GPU Pro) | Instancing + deferred + impostors; atlas of character+seat; colour stream | Designed for huge bowls | SOURCED Chambers 2018-04-17 |
| AC Unity (sandbox, same survey) | Hybrid LOD | 12,000 on screen, 120 high-res | SOURCED Pelechano 2015 |
| UE boxing-stadium VAT case | HISM + VAT, GPU deform, colour groups | 6,072 agents; draw calls 21,369→276; GPU 32→17.5 ms | SOURCED https://80.lv/articles/6-000-agents-on-one-game-thread-novel-high-performance-framework-for-gpu-driven-crowd-systems 2026-06-10 |
| Trakonius (UE 5.6 gladiator) | VAT + foliage place + 3 LODs | 18,000; 1–2 fps loss on RTX 2060; static light | SOURCED https://www.creativebloq.com/3d/video-game-design/you-wont-believe-how-many-characters-are-real-time-rendered-in-this-unreal-engine-5-gladiator-game 2025-09-05 |
| Pro Baseball Spirits | Many unique bone-weight models | 189 variants; 7–8k verts each | SOURCED Unreal Fest Tokyo 2025 talk https://www.youtube.com/watch?v=d3JZ0RHGDZA 2025-12-19 |
| EA UFC 5 | Fighter scan/hair detail public; no crowd pipeline disclosed | — | PROXY fighter tech only https://www.ufc.com/news/ufc-5-brings-gamers-closer-action-ever 2024-04-26 |
| Undisputed | Broadcast look, many venues; reviews say crowd under-reacts | No public LOD numbers | SOURCED https://insider-gaming.com/reviews/undisputed-review-redefining-the-boxing-game-experience/ 2024-10-07 |

Pattern (JUDGEMENT from the above): AAA sports never run 1,200 full skeletons at walkout distance. They instance a handful of meshes, bake motion off CPU, and flip far rows to images. Empty seats are the cheap failure mode; identical clones in lockstep is the expensive one.

## 2. Godot 4.7 / Forward+
**Engine primitive.** MultiMesh / MultiMeshInstance3D = one draw for thousands–millions. No per-instance frustum/LOD. Split by section. Drive motion in the vertex shader via INSTANCE_ID / INSTANCE_CUSTOM or a float texture. Official path: "Animating thousands of fish." SOURCED https://docs.godotengine.org/en/latest/tutorials/performance/using_multimesh.html 2026-09-07; fish tutorial https://docs.godotengine.org/cs/4.x/tutorials/performance/vertex_animation/animating_thousands_of_fish.html 2026-08-20.

**VAT add-ons (ship-legal MIT):**
| Addon | Licence | Last public | Notes / numbers |
|---|---|---|---|
| antzGames/Godot_Vertex_Animation_Textures_Plugin | MIT | Active 2025–26; Godot 4.5+; Blender 4.x baker | Demo 2,000 inst Forward+ 349 fps shadows / 506 off; 5,000 = 165 / 244 fps. Test box: Ryzen 5500 + RX 9060 XT, 1080p, Godot 4.7.1 debug. Cap 8192 verts. SOURCED repo README |
| shadecoredev/AnimatedMultimeshInstance3D | (repo; shader public on godotshaders.com) | Shader page 2025-06-21 | Unique clip + blend per instance. Author: <500 verts → ~50k @ 100 fps on RTX 2070 Super; 3986-vert demo struggles at 5k+. No per-instance LOD/cull. SOURCED https://godotshaders.com/shader/vertex-animation-with-instancing/ 2025-06-21 |
| antzGames/OpenVAT-for-Godot | Plugin MIT; OpenVAT toolkit GPL-3 | Author now steers to the first plugin; OpenVAT Blender broken on Blender 5.x | JUDGEMENT skip OpenVAT baker; use the MIT VAT plugin |

**Impostors:**
| Addon | Licence | Last public | Notes |
|---|---|---|---|
| zhangjt93/godot-imposter | (fork of wojtekpil shaders) | Verified Godot 4.5.beta5 | Octahedral impostors for 4.x. Bake from GeometryInstance3D. |
| wojtekpil/Godot-Octahedral-Impostors | plugin (Godot 3) | Godot 3 only | Do not drop into 4.7 as-is. |

No first-party crowd pack. GodotCrowdControl on AssetLib is a Twitch-effects plugin — ignore. SOURCED https://godotengine.org/asset-library/asset/3229.

6800 XT + Forward+ read-across (PROXY): antz 2k-inst Forward+ numbers are on a newer mid AMD GPU. A 6800 XT is in the same class. 150–400 VAT instances at 200–500 verts, shadows off, should sit well under 1 ms if chunked. Cost explodes if each spectator is a Skeleton3D node or if the whole bowl is one MultiMesh that never culls.

## 3. Assets that can ship
UNUSABLE if NC / Editorial / "no redistribute as files but also no game" / share-alike that infects the binary. CC-BY-NC and Sketchfab/CGTrader Editorial = do not ship. Mixamo raw files must not be redistributed as an asset pack; baked into the .pck is allowed.

| Asset | Link | Licence | Price | Poly / format | Anims | Verdict |
|---|---|---|---|---|---|---|
| MoCap Online Stadium Crowd | https://mocaponline.com/products/crowd | Standard: commercial to 1M users / $1M rev | $34.99 | Anims only, FBX (Unity/UE packs exist) | 108+: 45 sit, 54 stand, 9 move; cheer/clap/fidget/stand-up | USABLE for VAT bake onto your mesh. Cap the revenue clause. SOURCED product page + itch $34.99 2024-07-08 |
| Mixamo clips (Cheering, Clapping, Sitting, Idle) | https://www.mixamo.com | Free commercial in a game; no raw-file redistribution | $0 | FBX | Many sit/cheer | USABLE baked. SOURCED Adobe Mixamo FAQ 2022-09-29 https://community.adobe.com/t5/mixamo-discussions/mixamo-faq-licensing-royalties-ownership-eula-and-tos/td-p/13234775 |
| Quaternius Universal Animation Library | https://quaternius.com (UAL page Mar 2025) | CC0 | $0 | Humanoid, FBX/GLB/Blend; Godot-tested export | 120+ incl. sit / loco | USABLE best free bake source. SOURCED pack page CC0 |
| Kenney Animated / Mini / Blocky Characters | https://kenney.nl | CC0 | $0 | Very low poly, GLB/FBX | 17–32 clips | USABLE legally, UNUSABLE visually for a real hall. SOURCED kenney.itch.io CC0 |
| Polygonal Mind 100 Avatars R1+R2 | via Cinevva guide | CC0, Mixamo-compatible | $0 | 167 humanoids, FBX/glTF | none bundled; retarget Mixamo/UAL | USABLE body pool. SOURCED https://app.cinevva.com/guides/free-rigged-3d-character-models 2026-09-05 |
| TurboSquid/CGTrader "Cheering Crowd Pack" | https://www.turbosquid.com/3d-models/cheering-crowd-pack-animated-and-rigged-3d-model-2046140 | Royalty-free Standard | $40 | 5 chars, BLEND/FBX/GLB/OBJ | 6 cheer variants | USABLE if Standard RF (confirm cart licence). Published 2023-03-23 |
| CGTrader "Audience Unity Ready" | https://www.cgtrader.com/free-3d-models/character/man/audience-unity-ready | Editorial | $0 | Low poly, FBX/OBJ | Idle, applause, celebration | UNUSABLE Editorial = non-commercial. |
| Random Sketchfab "crowd" CC-BY-NC / ND | Sketchfab CC filter | NC / ND / Editorial | $0 | varies | varies | UNUSABLE |

No CC0 pack of realistic seated hall spectators at 200–500 tris with cheer cycles turned up. JUDGEMENT build 3–6 body variants (or 100 Avatars decimated), retarget UAL + Mixamo sit/clap/cheer, bake VAT.

## 4. One route + fallback
**Ship route — "VAT MultiMesh, three bands, six rows."**
- Author 3 male / 3 female seated bases, 200–500 tris, one material, shirt/skin as vertex-colour or INSTANCE_CUSTOM. Decimate 100 Avatars or the $40 pack.
- Bake 4 loops (sit-idle, fidget, clap, cheer) + 1 one-shot stand-cheer from UAL/Mixamo/MoCap Online into the antzGames MIT VAT plugin. Stagger phase in INSTANCE_CUSTOM.
- Place from the existing seat transforms. Row 1 (walkout): own MultiMesh, maybe 1 LOD higher. Rows 2–4: main VAT MultiMesh. Rows 5–6: same mesh, cheaper atlas or octahedral impostor (godot-imposter) if the camera never dollies in.
- One MultiMesh per bowl sector so empty/off-camera banks cull. visible_instance_count for gated shows (150 vs 1,200).
- Crowd casts no shadows (or contact-only). Lights already hot on 6800 XT.
- Trigger bands: idle default; clap on intro; cheer on walkout beat / knockdown. No per-agent AI.

Scale 150 → 1,200: instance count only. At ~400 keep VAT. Past ~800 flip rows 4–6 to cards. Keep hero count ≤ ~24.

Frame cost (JUDGEMENT, anchored on antz 2k-inst Forward+ ~2–3 ms class):
- 200 VAT @ 400 verts, no shadows, 2–4 chunks: ~0.3–0.8 ms GPU on 6800 XT.
- 1,200 VAT same mesh: ~1–2 ms if culled; 2–4 ms if one giant MultiMesh + shadows.
- 1,200 full Skeleton3D: do not.

**Fallback:** static coloured MultiMesh cards (quad or 80-tri torso) in every seat + 8–12 real animated meshes in row 1 only. Ships in a day; reads as a full hall at walkout distance; zero VAT risk. Upgrade cards → VAT without reseating.

**Do not:** one Skeleton3D per fan; Mixamo files in an extras folder; Editorial/NC Sketchfab; OpenVAT GPL baker; shadows on 1,200 bodies.
