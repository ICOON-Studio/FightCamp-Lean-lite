# J_CLOTHES2_S208 - John Research (gbot thread 'John Research', parts 1-3 saved verbatim by Claude S209)

**Part 1 of 3**

# J_CLOTHES2_S208 - Dressing MetaHumans for FightCamp

- Date: 2026-10-12 (Asia/Nicosia)
- Owner: John Research
- Scope: research only, no game code. Godot 4.7.2, commercial PC release, tiny budget. Every person is an Epic MetaHuman body exported to glTF with the MetaHuman skeleton (operator ruling S207). Target: 5 roles x 6 looks = 30 looks (Maria's M_WARDROBE_S207 T1-T6 codes are the target list; that file was not available to me).
- Builds on J_CLOTHES_S207 (2026-10-12). Its Godot outfit-swap mechanics (shared Skeleton3D, skinned garments with 'Use Named Skins', BoneAttachment3D for rigid items, masked body variants / region-split body, per-instance tint uniforms with RGB masks, logo decal slot via texture array + instance int) are **referenced, not redone**.
- Tags: **SOURCED [Sn]** = see section 6 for the URL, the page date (if one was shown) and access date 2026-10-12. **JUDGEMENT** = my opinion or estimate. **NOT FOUND** = I could not check it.
- Style note: J_TPH_LOOK recommended a stylised Two Point look. The operator has now chosen realistic MetaHumans. Props and the gym set should therefore move toward the J65 semi-real direction so characters and set match. JUDGEMENT. (I am noting this, not arguing it.)

---

## 0. Answer first

1. **Licence verdict: green, with conditions.** Epic's own MetaHuman licence page now says "MetaHumans can be used with any engine or creative software". Its FAQ classes MetaHuman characters and animation as "Non-Engine Products", so a Godot game owes **no royalty**. A UE seat licence is only needed once annual gross revenue is above **$1M USD**. SOURCED [S1][S2]. This confirms, from Epic's own pages, the CG Channel 2025-06-04 report cited in J_CLOTHES_S207. SOURCED [S1], [S25].
2. **Hard condition: only use MetaHumans made in UE 5.6+ (in-engine MetaHuman Creator).** Older "MetaHuman Content" from the old web Creator / Bridge is still covered by the Epic Content License, and that licence says it "may only be used and shared as UE-Only Content". SOURCED [S3]. Re-make or migrate any legacy MetaHuman in UE 5.6+ before export. JUDGEMENT.
3. **The only real licence trap is AI.** Do not use MetaHumans, or renders of them, to "build or enhance any database or train or test" AI. Do not feed Licensed Technology into a generative AI that trains on its input. SOURCED [S2][S1]. Practical rule: never upload MetaHuman screenshots or exports to Tripo, Higgsfield or other generators. JUDGEMENT.
4. **Clothing: Fab is the main source, and much of it is "parametric".** Many Fab listings now ship as MetaHuman "OutfitClothing" assets for UE 5.6-5.8 that resize to any parametric body inside MetaHuman Creator. These include free Epic T-shirt variants, sportswear packs from $7.99, and boxing kits (shorts, a modular boxing bundle, gloves, headgear). SOURCED [S14-S17]. The Fab Standard License allows use "with any compatible tools (usage is not limited to Unreal Engine)". SOURCED [S4].
5. **Resizing happens in UE, not in Godot.** Auto-conform runs inside UE's Outfit Asset / Chaos Cloth "Sized Outfit Source" pipeline. SOURCED [S8]. So each body + outfit pair must be assembled and exported from UE. A garment fitted to body A will not fit body B in Godot unless you also export a copy for B. JUDGEMENT.
6. **Pipeline:** UE 5.7/5.8 Creator → assemble at an *Optimized* quality → force hair cards → export (FBX/DCC export → Blender → GLB, the route the MetaHumanGodot project uses) → Godot import with a BoneMap to SkeletonProfileHumanoid. Corrective and twist bones stay unmapped. Then apply S207 sec 3 for tints, logos and body masking. SOURCED [S9][S12][S13] plus JUDGEMENT. Strand grooms do not go to Godot. Use cards. SOURCED [S8][S21].
7. **Recommendation:** #1 Fab parametric outfits assembled in UE. That costs about **$294-$364 (Personal tier)** and roughly **95-140 h** for 30 looks. #2 is a cheaper refit route (~$45, ~160-240 h). #3 is bespoke Marvelous Designer authoring. JUDGEMENT (all prices are SOURCED Fab listing prices, see section 5).
8. **Biggest unknowns:** I could not open Epic's dev docs on export or glTF, or the polycounts per listing (Cloudflare blocks). The credits / attribution wording for a non-UE game is unclear. NOT FOUND, see section 7.

---

## 1. Licence

### 1.1 Key clauses, verbatim

**MetaHuman licence page and FAQ** (metahuman.com/license). SOURCED [S1]:

> "MetaHuman is included as part of your standard Unreal Engine license, meaning it's free to use for anyone making under $1 million USD in revenue and Unreal Engine standard terms apply above that threshold. MetaHumans can be used with any engine or creative software."

> Q "Can I use MetaHuman characters and animation outside of Unreal Engine?" A "Yes. The Unreal Engine EULA provides for MetaHuman characters and animation to be used across all engines and creative software, subject to applicable terms."

> Q "Do I have to pay royalties if I use MetaHuman characters and animation outside of Unreal Engine?" A "No. MetaHuman characters and animation are classed as Non-Engine Products under the Unreal Engine EULA, so neither their use as linear media output or at runtime in games (or other interactive applications) using engines other than Unreal Engine triggers royalty obligations."

> Q "Do I need to buy an Unreal Engine seat license if I use MetaHuman characters and animation outside of Unreal Engine?" A "If you make over $1 million USD in annual gross revenue and render MetaHuman characters and animation outside of Unreal Engine, you'll need an Unreal Engine seat license; below that threshold, Unreal Engine is free to use."

> Q "I have a license for Unreal Engine; do I need an additional license to use MetaHuman?" A "No. From Unreal Engine 5.6, your use of MetaHuman is included under the terms of your existing Unreal Engine license."

> "The MetaHuman-related technology and tools provided within Unreal Engine are Licensed Technology under the Unreal Engine license."

> Q AI: "You can use MetaHuman characters and animation in workflows that incorporate artificial intelligence technology. However, you may not use MetaHuman characters or animation curves to build or enhance any database or train or test artificial intelligence, machine learning, deep learning, neural networks, or similar technologies (as further detailed in the Unreal Engine EULA). This includes the use of rendered output from MetaHuman digital characters and animation curves, if created to replicate the functionality of MetaHuman."

**Unreal Engine EULA** (unrealengine.com/en-US/eula/unreal). SOURCED [S2]:

> 4(a)(i) "Non-Engine Products (e.g., Rendered Video Files) You will not be obligated to pay us any royalty payments for Distributing Products that (i) do not include any Engine Code, (ii) do not require any Engine Code to run and (iii) do not include Starter Content in source format ("Non-Engine Products") to any person or entity. ... asset files, such as character models and animations, other than Starter Content, that you developed using Engine Code. Such asset files remain Non-Engine Products even if included in Products that use or rely on other video game engines. Please note that certain assets that we make available under separate agreements are available for use only with Unreal Engine."

> 1 "Licensed Technology does not include any items, assets, content, or other materials that we may make available to you in other ways (the "Content"), even if that Content can be used with Unreal Engine. For example, assets you may download from an Epic-operated online marketplace (including, but not limited to, Fab) are not Licensed Technology and are not licensed to you under the terms of this Agreement."

> 6(b)(i) "Personal and indie exception. During any period that you, together with any entities in your corporate group, have generated less than $1,000,000 USD in gross revenue over the last 12 months, the Seat subscription requirement will not apply to your Users. ... revenue includes any advances received or other funds raised."

> 6(e) "...result in using the Licensed Technology as a training input to any Generative AI Program or as prompt-based input where the Generative AI Program trains on input data. ... or use, or permit others to use, MetaHuman digital characters and animation curves (or any rendered output thereof if crafted to replicate the functionality of MetaHuman) to build or enhance any database or training or testing any artificial intelligence, machine learning, deep learning, neural networks, or similar technologies."

> 6(c) "...you may not combine the Licensed Technology with code or content that is licensed under any of the following licenses: GNU General Public License (GPL), Lesser GPL (LGPL) (unless you are merely dynamically linking a shared library), or Creative Commons Attribution-ShareAlike License."

> 7(a) "If a Product you develop under this Agreement has credits, you must place the following notices in the credits (replacing xxxx with the current year): "[Product name] uses Unreal® Engine. Unreal® is a trademark or registered trademark of Epic Games, Inc. in the United States of America and elsewhere." "Unreal® Engine, Copyright 1998 – xxxx, Epic Games, Inc. All rights reserved."" and "No other license or right is granted ... including the Unreal Engine and MetaHuman names and logos".

> 8(b) "...this Agreement supersedes any prior ... MetaHuman Creator End User License Agreement you may have. Those agreements will continue to survive only to the extent that you continue to have rights and obligations under them related to Content."

**Epic Content License Agreement, MetaHuman Content Addendum** (covers legacy downloaded MetaHumans). SOURCED [S3]:

> "This MetaHuman Content Addendum governs your use of digital human characters made available through MetaHuman Creator that you download ("MetaHuman Content"). ... 1. UE-Only Content: MetaHuman Content that you acquire may only be used and shared as UE-Only Content."

> 5(a) ""UE-Only Content" means Licensed Content that is designated as only permitted for use in conjunction with Unreal Engine and Unreal Engine-based products as designated by Epic, such as Twinmotion."

> 17 "You shall not collect, aggregate, mine, scrape, or otherwise use NoAI Content (i) in datasets utilized by Generative AI Programs; (ii) in the development of Generative AI Programs; or (iii) as inputs to Generative AI Programs."

**Fab Standard License, summary page** (fab.com/eula). SOURCED [S4]:

> "You may: Use the assets commercially or privately; Modify and adjust the assets in order to incorporate them into your Projects; Commercially distribute your Projects with the Fab assets incorporated into it; Use the assets with any compatible tools (usage is not limited to Unreal Engine); Share the asset (directly, via a private repository or in the Project) with your collaborators that are working on the Project with you. You may not: Resell or redistribute the asset for free on a standalone basis or allow others to do the same."

> "Both pricing tiers (Personal and Professional) grant you the same scope of rights. ... There is no need for upgrading from Personal to Professional tier if you cross the revenue threshold after the purchase ... You are not required to give credit to the publisher you acquired the Fab asset from."

(Fab's own page notes that this summary is not legally binding and that the full EULA is.) SOURCED [S4].

**Fab EULA, tier clause**, as quoted by Epic community staff on the forum (I could not open the full EULA text because of Cloudflare). SOURCED [S5]:

> "You are only eligible for a Personal - Reference Only tier or Personal tier if, at the time of the Transaction you, together with any controlling entity and other entities under common control with you, have not generated more than $100,000 USD in gross revenue from your commercial activity in the digital content industry in the last 12 months. For purposes of this calculation, revenue includes any advances received or other funds raised."

### 1.2 What is covered (summary)

| Item | Status for a Godot game | Tag |
|---|---|---|
| MetaHuman bodies and faces made in UE 5.6+ Creator, exported as meshes | Allowed. "Non-Engine Products", no royalty. Seat licence only above $1M annual gross revenue. | SOURCED [S1][S2] |
| Legacy MetaHumans (old web Creator / Quixel Bridge downloads) | UE-Only Content. Do not ship them in Godot. Recreate them in 5.6+. | SOURCED [S3]; recreate step = JUDGEMENT |
| Creator clothing / grooms / textures made by Epic and output through Creator | Treated as part of the MetaHuman character output, so the same Non-Engine rule applies. Epic does not list each component separately. | JUDGEMENT (based on [S1][S2] "character models"; no per-component clause found) |
| Epic-published free Fab items (e.g. "MetaHuman T Shirt Variants") | They are sold on Fab with Personal/Professional tiers at $0, which indicates the Fab Standard License. I could not open the listing page to read the licence label. | SOURCED [S17] for price/tiers; licence label NOT FOUND |
| Third-party Fab "MetaHuman-ready" outfits | Fab Standard License. Any tool, commercial use OK, no standalone redistribution. | SOURCED [S4] |
| Fab items tagged NoAI | Must not be used in, for, or as input to generative AI. Whether specific listings carry NoAI is NOT FOUND (the search API did not expose it). | SOURCED [S3] (clause); per-listing NOT FOUND |
| Strand grooms | No licence issue. The issue is technical: they will not render in Godot. Use cards. | JUDGEMENT + [S8] |
| Must the game be built with UE? | No. The FAQ explicitly covers "engines other than Unreal Engine". | SOURCED [S1] |
| Attribution | Fab: not required [S4]. Epic EULA 7(a): the credits notice applies to Products "made using any Licensed Technology", so it may arguably apply even to a Godot game. Its wording ("uses Unreal® Engine") reads oddly for a Godot game. Ask Epic or a lawyer. Until then, a conservative credit line is safest. | Clause SOURCED [S2]; applicability = JUDGEMENT / NOT FOUND |
| Personal vs Professional Fab tier | Same rights. Personal only if under $100k digital-content revenue in the last 12 months at purchase. | SOURCED [S4][S5] |
| CC BY-SA content (e.g. some Sketchfab items) | Avoid. The UE EULA bans combining Licensed Technology with CC BY-SA. The exported MetaHuman meshes are Non-Engine Products, but the safe choice is to keep BY-SA out entirely. | Clause SOURCED [S2]; avoid = JUDGEMENT |
| CC BY (Sketchfab) | Commercial use OK, credit required. | SOURCED [S20] (summary of Sketchfab licence filter) |
| CC BY-NC | Not usable commercially. | SOURCED [S20] |

**Part 2 of 3**

## 2. Clothing sources

The "Tris" column gives triangles only where the seller published them. Sketchfab numbers are the API's `faceCount`. Fab "Vertex Count" figures are seller text, copied as given. "Fit hours" is my estimate per garment for **one body archetype**, including export and import QA. JUDGEMENT.

| # | Source / item | Licence | Price (Personal / Pro, USD) | Contents | Format | Fits MetaHuman skeleton? | Auto-conforms across body types? | Tris | Fit hours |
|---|---|---|---|---|---|---|---|---|---|
| C1 | Fab, Epic Games, "MetaHuman T Shirt Variants" and "MetaHuman Tucked T Shirt Variants" (pub. 2026-04-07) | Fab listing (Standard tiers shown) | $0 / $0 | T-shirt variants | MetaHuman OutfitClothing, UE 5.7 | Yes (MH format) | Yes, "Parametric" tag | NOT FOUND | 1-2 (JUDGEMENT) |
| C2 | Fab, Epic Games, "MetaHuman Techwear Outfit" | Fab | NOT FOUND | Top, pants, shoes in one asset, "4 body LODS", "fits onto any body shape in MetaHumanCreator" | MetaHuman | Yes | Yes | NOT FOUND | 1-2 (J) |
| C3 | Fab, Bagira, "Metahuman Sportswear Outfit" (2026-07-18) | Fab Standard | $19.99 / $59.99 | Modular sportswear + shoe | OutfitClothing UE 5.6-5.8 | Yes | Yes (Parametric tag) | NOT FOUND | 1-2 (J) |
| C4 | Fab, Metahuman SP, "Women's sportswear, Parametric Outfit" (2026-02-13) | Fab Standard | $7.99 / $26.99 | Outfit + MD garment files + FBX + body FBX + textures | OutfitClothing UE 5.7 + extras | Yes | Yes | NOT FOUND | 1-2 (J) |
| C5 | Fab, Job Done, "Cyberpunk Sportswear Leggings" (2026-09-09) | Fab Standard | $14.99 / $24.99 | Training leggings | OutfitClothing UE 5.8 + .blend + FBX | Yes | Yes (Parametric) | LOD0 7,032; LOD1 4,218; LOD2 2,460; LOD3 1,054 (seller) | 1 (J) |
| C6 | Fab, Quantum Assets, "Casual Clothing Bundle - Metahuman" (2026-07-03, discounted) | Fab Standard | $149.99 / $199.99 | Bundle: jackets, hoodies, jeans, boots, caps, sweaters, sportswear tags | OutfitClothing UE 5.6-5.8 | Yes | Yes (parametric) | NOT FOUND | 1-2 each (J) |
| C7 | Fab, Quantum Assets, "Shirt Casual Outfit - Metahuman" (2026-07-03) | Fab Standard | $19.99 / $19.99 | Plaid shirt, jeans, boots | OutfitClothing 5.6-5.8 + FBX | Yes | Yes | NOT FOUND | 1-2 (J) |
| C8 | Fab, pypx.archive, "Bomber Jacket - Resizable" / "Mesh Tee Top - Resizable" | Fab Standard | $29.99 / $60.99 and $19.99 / $49.99 | Single garments | OutfitClothing 5.6 + FBX | Yes | Yes ("Resizable") | NOT FOUND | 1-2 (J) |
| C9 | Fab, Mesh Atelier, "MetaHuman Sportswear Outfit Pack" (2026-08-20) | Fab Standard | $24.99 / $39.99 | 20 meshes: puffer, longsleeve, cropped shirt, skirt, sweater, pants, overalls... | UE asset pack | Yes: "rigged to the Metahuman skeleton (Female Tall Normalweight - Male Tall Normalweight)" | **No.** Fixed to two body presets | "Vertex Count: 10K – 20K per mesh"; no LODs | 3-5 per body archetype (J) |
| C10 | Fab, Cinematography Database, "Workbrand - Activewear Clothing" (2024-10-07) | Fab Standard | $19.99 / $49.99 | 17 meshes, MH Male/Female Tall Normalweight, colour + **logo** material styles | UE 5.0-5.4 asset pack | Yes (fixed body) | No | "8K - 40K" verts; no LODs | 3-5 (J) |
| C11 | Fab, CGTailor, "Pack Modular Womens Sportswear" (2025-07-31) | Fab Standard | $49.99 / $79.99 | Hoodie, sweatshirt, sweatpants etc. (female tall normal weight) | UE 5.2-5.5 | Yes (fixed body) | No | 651-11,373 verts | 3-5 (J) |
| C12 | Fab, Epic Games, "MetaHuman Fashion Starter Kit" (2026-04-21) | Fab | $0 | Fashion MH preset, 60 s mocap, lighting scene: a **garment-authoring kit, not clothes** | UE 5.7 project | n/a | n/a | n/a | n/a |
| C13 | Sketchfab, kurmanin: "Female sweatpants for Metahuman", "Female sweatshirt for Metahuman", "Male sweatpants and sweatshirt (anorak)", "Male basic T-shirt", "Male Cargo pants" | CC Attribution | Free | Single garments | Sketchfab download (glTF/source) | Named "for Metahuman". Rig/weights NOT FOUND | No | 6,688 / 3,990 / 14,890 / 10,350 / 10,016 faces | 3-6 (J) |
| C14 | Sketchfab, fdgasd7: "Basic T-Shirt And Pants", "Bomber Jacket" | CC Attribution | Free | Garments | Sketchfab | NOT FOUND | No | 3,586 / 14,060 faces | 4-6 (J) |
| C15 | Sketchfab, "T-Shirt (Metahuman Compatible)" (kosteapaladii) and the MrRohanGupta404 outfits | **CC BY-NC**: not usable | - | - | - | - | - | 132,764 faces etc. | Excluded |
| C16 | CGTrader, "Gloves NN - All MH Bodies - UE5 Skeletons - Rigged" series | CGTrader Royalty Free (by default) | NOT FOUND (page blocked) | Generic gloves, not boxing | NOT FOUND | Title claims all MH bodies | NOT FOUND | NOT FOUND | 2-3 (J) |
| C17 | CLO-SET CONNECT marketplace | **Item-specific**. Some sellers reserve commercial game use for the "Extended" price | Basic / Extended per item; Extended can be "1–8 times the Basic price" | Native ZPRJ/ZPAC plus FBX/glTF on some items | Varies | Not MH-rigged by default | No | Examples cited: 3.6M and 299.2k tris (simulation meshes) | 6-15 incl. retopo (J) |
| C18 | Marvelous Designer 2025.2 / CLO, own authoring | Your own work | Subscription price NOT FOUND | Pattern-made garments | Native → USD/FBX | MD 2025.2 can "Import MetaHumans in DNA as Avatars" | Via UE Outfit Asset resize | Your choice | 8-20 per garment (J) |
| C19 | Reallusion CC4 | Not checked in depth | NOT FOUND | - | - | One secondary source claims "MetaHuman-compatible export". Not verified. | - | - | Skipped |
| C20 | Mixamo / Quaternius / Kenney | Various free | Free | Stylised low-poly characters, or animations only | FBX/glTF | No: different proportions and skeletons | No | - | Not suitable |

Sources for the rows: C1 [S17]; C2 [S10]; C3, C9, C10, C11, C4, C5 [S15]; C6, C7 [S17]; C8, C12 [S14]; C13-C15 [S18]; C16 [S23]; C17 [S20]; C18 [S7][S8]; C19 [S8]; C20 JUDGEMENT. Fab prices are the listing's `startingPrice` (Personal) and the Professional `priceTier`, read via Fab's public listing-search API. SOURCED [S14-S17]. Prices change, and the Quantum bundle was flagged "discounted" on the access date.

**Notes**
- **Two kinds of Fab "MetaHuman clothing".** (a) **OutfitClothing / parametric** (the "MetaHuman" format, UE 5.6+). These resize to any parametric body inside Creator. (b) **Legacy skeletal clothing** rigged to fixed bodies such as "Tall Normalweight". These do *not* auto-conform. SOURCED [S14][S15]; the meaning of the distinction is SOURCED [S8]. Buy (a) whenever possible. JUDGEMENT.
- **How auto-conform works.** The UE 5.6 Outfit Asset "auto-resizes against the parametric body via a Sized Outfit Source node in the Chaos Cloth Panel Editor (Beta) and the Unified Dataflow Editor (Experimental). Outfits convert into Wardrobe Items (WI_*), consumed by the Creator's Outfit Clothing slot". SOURCED [S8] (secondary source, 2026-05-10). Because Chaos Cloth Panel Editor is Beta and Dataflow is Experimental, expect rough edges. JUDGEMENT.
- **Library depth.** At 5.6 launch "only one parametric outfit shipped, and the previous default wardrobe was removed". SOURCED [S8]. A UE 5.7 user complained on 2025-11-23 that there was "only 1 free clothe". SOURCED [S11]. By 2026-10-12, Fab search returns many OutfitClothing items, including free Epic T-shirt variants (2026-04-07). SOURCED [S14-S17].
- **Polycounts are mostly unpublished.** Sellers give vertex ranges or nothing. Several fixed-body packs list 50K-400K+ verts (e.g. Meta Clothes Designer packs: "Vertex Count: 400K", "100K to 700k"), which is too heavy for a crowd sim. SOURCED [S14][S15]; "too heavy" = JUDGEMENT. Check tris in UE after purchase.
- **Sketchfab "for Metahuman" items are a fallback only.** None of them say they are weighted to the current MH skeleton. Most predate UE 5.6 (2023-2024). SOURCED [S18]; implication = JUDGEMENT.
- **CGTrader licence.** It covers use "as purchased by a game's creators as part of a game if the Product is contained inside a proprietary format", and you "must take all reasonable measures to prevent the end user from gaining access to the Product". SOURCED [S19]. Godot's .pck packing is the usual answer here. Whether .pck counts as a "proprietary format" is a JUDGEMENT. Encrypting the .pck would be safer. JUDGEMENT.

---

## 3. Boxing gear

| # | Item | Source | Licence | Price (Personal / Pro, USD) | Format | Rigged / static | MH fit | Tris | Use in Godot |
|---|---|---|---|---|---|---|---|---|---|
| B1 | "Modular Boxing Outfit Bundle – MetaHuman Compatible Customisable Boxer Clothing" (2AwesomeWork, 2026-09-17) | Fab [S16] | Fab Standard | $80.99 / $274.99 | OutfitClothing UE 5.7/5.8 + FBX | Rigged (tags: rigged, parametric; robe, short, shoe) | Parametric | NOT FOUND | Trunks, robe, boxing shoes as skinned meshes (S207 sec 3). Exact contents NOT FOUND beyond tags |
| B2 | "Parametric Boxing Shorts – MetaHuman Compatible" (2AwesomeWork, 2026-09-17) | Fab [S16] | Fab Standard | $17.99 / $42.99 | OutfitClothing UE 5.7/5.8 + FBX | Rigged | Parametric | NOT FOUND | Cheap trunks-only option |
| B3 | "Boxer - Boxing Gloves - Metahuman outfit" (ggggahong, 2026-08-15) | Fab [S16] | Fab Standard | $69.99 / $169.99 | OutfitClothing UE 5.6 | Rigged (outfit), "Parametric" tag | Parametric | NOT FOUND | Either skinned, or split off and used as a BoneAttachment3D on hand_l/hand_r (JUDGEMENT) |
| B4 | "boxing wear - clothyfic outfit" (tixelzz, 2026-02-28) | Fab [S16] | Fab Standard | $19.99 / $29.99 | OutfitClothing UE 5.6 + **GLB**/FBX/OBJ/.blend | Rigged ("rigged", "epicskeleton"); tags include **headgear** | Parametric | NOT FOUND | Headgear and kit. The GLB is handy for Godot tests |
| B5 | "Boxing Glove" (Pedro Perin, 2024-10-27) | Fab [S16] | Fab Standard | **$0** / $2.99 | OBJ + extras | Static | n/a | "low poly ... (3k triangles)" (seller) | BoneAttachment3D on hand bones (S207). Best budget glove |
| B6 | "Boxing Glove" (Just_som) / "Boxing Gloves" (BigBuzzle) / "Boxing Glove" (incg5764) | Sketchfab [S18] | CC Attribution | Free | Sketchfab | Static | n/a | 2,226 / 2,672 / 4,064 faces | BoneAttachment3D. Credit the author |
| B7 | "Boxing gloves" (Nixak) | Sketchfab [S18] | CC Attribution | Free | Sketchfab | 3 animations listed. Rig type NOT FOUND | n/a | 49,352 faces | Too heavy for a crowd (JUDGEMENT) |
| B8 | "Boxing Headgear Helmet (Low Poly)" (artel_3D, 2026-01-26) / "Boxing headgear fbx" (chillax12) | Sketchfab [S18] | CC Attribution | Free | Sketchfab | Static | n/a | 13,070 / 18,740 faces | BoneAttachment3D on head |
| B9 | "Boxer - Boots" / "Shorts Boxer" (suttonj94, 2026-05-31) | Sketchfab [S18] | CC Attribution | Free | Sketchfab | NOT FOUND | No | 4,612 / 73,736 faces | Boots need re-skinning to the MH foot. Shorts too dense (JUDGEMENT) |
| B10 | "boxing glove props" (dengxiart) | Sketchfab [S18] | "Free Standard" | Free | Sketchfab | Static | n/a | 9,426 faces | Read the Sketchfab Free Standard terms first (NOT FOUND this session) |
| B11 | Focus mitts / punch mitts | CGTrader "Boxing practice focus pads punch mitts" (FBX/OBJ/GLB, "low-poly") [S23]; Cults3D ZPRJ+FBX+OBJ focus mitt [S23] | CGTrader Royalty Free [S19]; Cults: NOT FOUND | NOT FOUND (pages blocked) | FBX/GLB | Static | n/a | NOT FOUND | BoneAttachment3D on the coach's hands. Sketchfab and Fab searches returned 0 / none [S18][S16] |
| B12 | Hand wraps | - | - | **NOT FOUND** (the only Sketchfab hit is CC BY-NC-SA) [S18] | - | - | - | - | Make in-house: a thin shell offset from the MH hand mesh, skinned with copied weights, or a hand-skin texture overlay (JUDGEMENT, ~6-10 h) |
| B13 | CGTrader "Boxing Gloves 3D model rigged" | CGTrader [S23] | Royalty Free (default) | $59.40 (discounted from $99.00) per search snippet; page not opened | NOT FOUND | Rigged (to what is NOT FOUND) | NOT FOUND | NOT FOUND | Not needed if B3/B5 are used |
| B14 | Unity Asset Store "Boxing Fighters Pack" (Carthage Studio) | Unity [S24] | Standard Unity Asset Store EULA (any engine allowed per Unity's summary; asset page not opened) | EUR 27.59 (from brief; not re-verified) | Unity package / FBX | Rigged to their own character | No: refit gloves/shorts to the MH body | NOT FOUND | Refit candidate only. B1/B2/B5 make it largely unnecessary (JUDGEMENT) |
| B15 | Unity "Boxing equipment - helmet and gloves" | Unity [S24] | Unity EULA | $14.99 per search snippet | Unity | Static | n/a | "low-poly" claimed | Backup headgear |

**Notes**
- Rigid gear (gloves, headgear, mitts) works best as **static meshes on BoneAttachment3D**, as already designed in S207 sec 3. That avoids weight-painting across body types. JUDGEMENT. MetaHuman hand bone names to attach to are `hand_l` / `hand_r`; MetaHuman reuses UE naming. NOT FOUND for an Epic doc this session; check on the first export.
- Fab boxing outfits B1-B4 are **parametric**, so trunks, robes and shoes conform per body in UE. SOURCED [S16]. Gloves from B3 are inside an outfit asset. Whether they come out as a separate mesh you can split off is NOT FOUND.
- Props should match the realistic MetaHumans (J65 semi-real). Avoid "stylized" listings such as Fab "Stylized Boxing Club" [S16] for characters' gear. JUDGEMENT.

**Part 3 of 3**

## 4. Godot pipeline, MetaHuman-specific

Swapping, tinting and the logo decal follow **J_CLOTHES_S207 sec 3** and are not repeated here.

1. **Author in UE 5.7 or 5.8 (MetaHuman Creator plugin).** 5.8 is current and adds MetaHuman Collections / Crowds (Experimental), "scalable normal maps" for faces, unbaked texture export, and Mesh to MetaHuman for full bodies. SOURCED [S6]. Use 5.7 or 5.8 because many Fab outfits target 5.7/5.8. SOURCED [S14-S17]; choice = JUDGEMENT.
2. **Bodies.** Use the parametric body in Creator (5.6+). SOURCED [S8]. Pick a small set of **body archetypes**, e.g. 6-8 (lean boxer, heavy boxer, coach, average member x2, customer x2). Everyone else differs by face, hair, skin tint and garment tint. This keeps "garment x body" exports manageable. JUDGEMENT.
3. **Dress in Creator.** Put OutfitClothing items into the Outfit Clothing slot. Parametric items resize to the body. SOURCED [S8][S10]. For fixed-body legacy packs (C9-C11), pick the matching preset body or plan a Blender refit. JUDGEMENT.
4. **Hair.** Choose "Always Use Hair Cards" in Creator, or generate a card asset in the Groom Asset Editor and export that static mesh as FBX. Convert-to-Static-Mesh may drop strands. SOURCED [S21] (search summaries of a UE 5.6 tutorial and forum threads; pages not opened). Strands are normally used at LOD0-2 and cards at LOD3+. SOURCED [S8]. MetaHumanGodot ships "groom cards" (beard/brows) and propagates face shapes onto them. SOURCED [S12].
5. **Assembly quality / LOD.** Epic staff: "If you're using Optimized High, that would give you about 600 bones in LOD 0 and 41 bones in LOD 3. LOD 3 of Optimized High corresponds to LOD 7 of Cine though, and only has 356 polys". In cinematic quality "each body LOD has two corresponding face LODs where the neck seam will match perfectly". SOURCED [S9] (2026-01-13 / 2026-01-05). For a 3/4 management camera, export **one mid LOD as Godot LOD0** (an Optimized Medium/High mid-level), plus one low LOD for crowds or Godot auto-LOD. JUDGEMENT. Exact body LOD0 tris: **NOT FOUND** from Epic. A secondary source gives "~24K–60K triangles for the head, around 700–800 joints" at baseline LOD0. SOURCED [S8].
6. **Export.** Since 5.6 there is a "DCC Export assembly target" that also produces a body DNA file. SOURCED [S8]. MetaHumanGodot documents the working route as **UE → Blender → Godot** into a single `character.glb`. It notes that "Blender's glTF export shuffles material names", so its tool wires surfaces by index. SOURCED [S12]. A direct UE glTF/Interchange exporter path for MetaHuman skeletal meshes is **NOT FOUND** (Epic dev docs blocked). Plan on FBX → Blender → GLB. JUDGEMENT.
7. **Face.** "Modern (Mutable / MetaHumanCharacter) MetaHumans ship no ARKit morph targets — the face is RigLogic/bone-driven." ARKit shapes must be baked (Sequencer pass → FBX → Blender shape keys). SOURCED [S12]. RigLogic is now open-source (MIT) as OpenRigLogic / MetaHuman Devkit. SOURCED [S6]. For FightCamp's camera: bake a few expressions, or skip facial animation and keep eyes/blink. JUDGEMENT.
8. **Skeleton and mapping.** All MetaHumans share one body skeleton (`metahuman_base_skel`). It has "5 spine bones rather than 3, plus extra twist bones, corrective bones, and roll bones". SOURCED [S8]. Count reported in a search summary of Epic's optimisation guide: 342 body bones, 875 face. SOURCED [S22] (page not opened, treat as unverified). Godot's SkeletonProfileHumanoid has **56 bones** in 4 groups (Body, Face, LeftHand, RightHand). SOURCED [S13]. Suggested BoneMap (JUDGEMENT; check on the first import): `root`→Root, `pelvis`→Hips, `spine_01`→Spine, `spine_03`→Chest, `spine_05`→UpperChest, `neck_01`→Neck, `head`→Head, `clavicle_l/r`→Left/RightShoulder, `upperarm_*`→UpperArm, `lowerarm_*`→LowerArm, `hand_*`→Hand, `thigh_*`→UpperLeg, `calf_*`→LowerLeg, `foot_*`→Foot, `ball_*`→Toes, `thumb_01..03_*`→Thumb Metacarpal/Proximal/Distal, `index/middle/ring/pinky_01..03_*`→finger Proximal/Intermediate/Distal. Leave spine_02/04, neck_02, twist/corrective/roll bones unmapped. They stay in the Skeleton3D and keep their skin weights.
9. **Correctives risk.** In UE, corrective/twist joints are driven by rig logic and pose drivers. In Godot they will not move unless your animation keys them, so elbows, shoulders and knees may "candy-wrap". JUDGEMENT. A UE 5.7 user reported clothing losing "animation on elbows" after LOD changes. SOURCED [S11]. Options: bake correctives into exported animations (retarget in UE, export FBX with all joints), or add simple twist constraints in Godot. JUDGEMENT. Budget 8-16 h to prove this.
10. **Body under clothes.** Use the S207 sec 3 masked-body or region-split approach, generated per body archetype. Whether Creator's outfit system already removes hidden body faces on export: NOT FOUND. Test on the first export. JUDGEMENT.
11. **Materials.** MetaHuman materials are UE shader graphs. Expect baked textures: MetaHumanGodot's export uses head/body BaseColor, Normal, SRMF, Scatter, eye iris/sclera and groom coverage atlases. SOURCED [S12]. 5.8 can export unbaked textures for external editing. SOURCED [S6]. Rebuild a Godot skin / cloth / hair-card shader and add the S207 tint masks. JUDGEMENT.
12. **Crowds.** UE 5.8 MetaHuman Collections move characters to Instanced Skinned Meshes at distance. SOURCED [S6]. That system is UE-only, and there is no Godot equivalent out of the box. In Godot, rely on low LOD meshes plus shared materials. JUDGEMENT.

---

## 5. Top-3 ranking

Scores are 1 (poor) to 5 (best). All scores, hours and verdicts are JUDGEMENT. Prices are SOURCED from the Fab listings in sections 2-3 [S14-S17].

| Rank | Route | Quality 3/4 cam | Close-up | Cost | Fit effort | Licence safety | Hours for 30 looks | USD (Personal tier) |
|---|---|---|---|---|---|---|---|---|
| **1** | **Fab parametric OutfitClothing, assembled and exported from UE 5.7/5.8.** Kit: C1 Epic T-shirts (coach/staff base + S207 logo decal), C3 Bagira sportswear, C4 women's sportswear, C5 leggings, C6 Quantum casual bundle (customers/members), B1 boxing bundle, B4 headgear kit, B5 free gloves (or B3 skinned gloves) | 5 | 4 | 3 | 4 (UE does the resizing) | 5 (Fab Standard + Epic Non-Engine) | **95-140 h**: 16-24 pipeline proof, 2-3 per look x 30 (assemble, export, import, QA), 8-12 gear attach, 10-16 body masking | **$293.94** with B5 free gloves; **$363.93** with B3 skinned gloves. Pro tier would be $619.93-$786.93 |
| 2 | **Fixed-body Fab MH packs + Sketchfab CC-BY, refit in Blender.** C9 Mesh Atelier, C10 Workbrand (has logo materials), C13/C14 kurmanin and fdgasd7 garments, B5/B6/B8 static gear | 4 | 3 | 5 | 2 (manual shrinkwrap + weight transfer per garment x archetype) | 4 (CC-BY needs credits; check each Sketchfab item for BY-SA/NC) | **160-240 h** | **~$44.98** (C9 + C10; Sketchfab and B5 free) |
| 3 | **Bespoke garments in Marvelous Designer 2025.2 with MetaHuman DNA import → UE Outfit Asset → export** (club uniform, coach polo, staff shirt) | 5 | 5 | 2 (subscription price NOT FOUND) | 1 (author, retopo, UV, resize setup) | 5 (own IP) | **250-400 h** | MD subscription (NOT FOUND) + $0 assets |

**Recommendation:** Route 1. Fill gaps with Route 3 only for the **club uniform** (coaches): one bespoke polo or tracksuit authored once, then made parametric. Or simply use the Epic T-shirt variants with S207 tint plus logo decal. JUDGEMENT.

How Route 1 covers 30 looks. This is indicative only; Maria's T1-T6 list was not available. JUDGEMENT.
- Boxers in training (6): B1/B2 trunks + C3/C5 tops/leggings + B5 gloves + B4 headgear + hand wraps (B12, in-house), varied by tint.
- Coaches in club uniform (6): C1 T-shirt / tucked tee + C6 joggers or jeans + logo decal + B11 mitts on 2-3 of them.
- Front-desk staff (6): C1 tucked tee / C7 shirt + C6 trousers, with a club logo.
- Gym members (6): C3, C4, C5 + C6 hoodies/sweaters.
- Walk-in customers (6): C6 jackets, jeans, boots, caps + C8 bomber.

---

## 6. Sources

All accessed 2026-10-12 (Asia/Nicosia). "Page date" is given only when the page showed one.

- [S1] MetaHuman, "Licence" page + FAQ: https://www.metahuman.com/license (also FAQ https://www.metahuman.com/faq). Page date not shown.
- [S2] Unreal Engine End User License Agreement: https://www.unrealengine.com/en-US/eula/unreal. Page date not shown in the fetch.
- [S3] Epic Content License Agreement (incl. MetaHuman Content Addendum, s.5, s.17): https://www.unrealengine.com/en-US/eula/content. Page date not shown.
- [S4] Fab Standard License summary: https://www.fab.com/eula. Page date not shown. The full EULA text was behind Cloudflare.
- [S5] Epic Developer Community Forums, "fab and lisences, what if I start out under 100k..." (staff reply quoting the Fab EULA, 2025-09-19): https://forums.unrealengine.com/t/2656575
- [S6] MetaHuman, "MetaHuman 5.8 is now available": https://www.metahuman.com/en-US/news/metahuman-5-8-is-now-available. Page date not shown in the fetch.
- [S7] Unreal Engine news, "Tailoring for MetaHumans: CLO and Marvelous Designer to Unreal Engine demo", 2026-04-24: https://www.unrealengine.com/news/tailoring-for-metahumans-clo-and-marvelous-designer-to-unreal-engine-demo
- [S8] James Roha, "Inside the MetaHuman: An Intermediate Pipeline for Unreal 5.6 and 5.7", 2026-05-10 (secondary source): https://jamesroha.substack.com/p/inside-the-metahuman-an-intermediate
- [S9] EDC Forums, "Metahuman - Assembly quality presets" (Epic staff HenryFalconerEG, 2026-01-05 / 2026-01-13): https://forums.unrealengine.com/t/2699854
- [S10] EDC Forums, "Epic Games - MetaHuman Techwear Outfit" (2025-06-03): https://forums.unrealengine.com/t/2538914
- [S11] EDC Forums, "MetaHuman 5.7 Released!" (user post 2025-11-23): https://forums.unrealengine.com/t/2672724
- [S12] ibrews/MetaHumanGodot README (GitHub): https://github.com/ibrews/MetaHumanGodot (raw: https://raw.githubusercontent.com/ibrews/MetaHumanGodot/main/README.md). Page date not shown.
- [S13] Godot 4.7 docs, SkeletonProfileHumanoid: https://docs.godotengine.org/en/stable/classes/class_skeletonprofilehumanoid.html
- [S14] Fab listing-search API, q="metahuman clothing": https://www.fab.com/i/listings/search?q=metahuman%20clothing&count=24. Individual listings at https://www.fab.com/listings/<uid>, e.g. Bomber Jacket 54f78611-bcce-4097-9a4a-b3b126dabe73; Fashion Starter Kit 32809841-5170-4c32-85ac-ea441b33bafd; Mesh Tee d0822c14-5330-4730-a527-00781a0cd21f.
- [S15] Fab search q="metahuman sportswear": https://www.fab.com/i/listings/search?q=metahuman%20sportswear&count=8. Listings: Mesh Atelier c708eb85-b42d-4c88-b56e-f62d4eea7cbc; Bagira 497f9c4f-b235-4759-903f-18e1d07cb2a5; CGTailor cf80c24e-7b0b-43f1-8c74-38d14799f820; Workbrand 7c3143c4-0d9e-40ad-b1b8-b0e9d40afa1a; Metahuman SP 76bcceb2-b35d-4d7a-84d0-a36969e80050; Job Done 7b0103c8-ed10-4a94-9098-711448ac7586.
- [S16] Fab search q="boxing metahuman": https://www.fab.com/i/listings/search?q=boxing%20metahuman&count=10. Listings: Boxing Bundle 01764608-dda6-4375-8ed5-2325bdcfc5e3; Boxing Shorts e3085145-d38f-4a4d-8e38-16dbe54c310c; Boxing Gloves outfit fca4a341-1c9a-4096-901f-9fe733b40f62; boxing wear fc7a0aaa-a2f4-4412-8b78-8d7614bfa670; Boxing Glove (free) b9bc411a-193b-4965-bb8b-535882bb4614.
- [S17] Fab search q="MetaHuman T Shirt Variants": https://www.fab.com/i/listings/search?q=MetaHuman%20T%20Shirt%20Variants&count=4. Listings: Epic T Shirt 1b1009ae-4327-4c9d-9567-9314d88e7a86; Epic Tucked T Shirt 839b9239-5ea4-40a0-90b3-076e0d9959f7; Quantum Shirt Casual 477c950d-437e-43f0-86c1-52ef30c7c910; Quantum Casual Bundle 9f61ffb8-f653-4fe9-9216-2dfa74444031.
- [S18] Sketchfab Data API v3 search (downloadable=true), queries: metahuman t-shirt / shorts / hoodie / tracksuit / shoes / sneakers / pants / sportswear / polo, boxing gloves / hand wraps / headgear / shorts / boots / shoes / trunks, focus mitts, punch mitts. Base: https://api.sketchfab.com/v3/search?type=models&downloadable=true&q=... Model pages: https://sketchfab.com/models/<uid>, e.g. 2c2bd2f956df4db29ecfe93d250ad31e, 3b58e05f01e1476a9205dcd4f0fd31fa, f72f208b242a415c84d0087a790faa5f, 8702e036c18048819216648add9d76a7, 3b54687837684dfea0552291c0ab88bc, 58b8fd62214043149ec65c2e7436c2d0, 498387769b0347f292ab1bdbddbfe719, e843e3e83750425db83a92ea77f900b7.
- [S19] CGTrader Help Center, "Royalty Free License", page date 2020-11-05: https://help.cgtrader.com/hc/en-us/articles/360015124437-Royalty-Free-License
- [S20] CLO-SET CONNECT guide, "Sourcing Commercial 3D Clothing Assets..." (datePublished 2026-09-10, dateModified 2026-10-05): https://connect.clo-set.com/explore/guides/sourcing-commercial-3d-clothing-assets-indie-games
- [S21] Web-search summaries (pages not opened): yoshikawastudio UE 5.6 MetaHuman tutorial https://yoshikawastudio.com/metahuman01-en/; EDC forum "BP convert to Static Mesh - Missing Hair" https://forums.unrealengine.com/t/bp-convert-to-static-mesh-missing-hair/2652996; "Can't make MetaHuman Static Mesh (grooms disappear)?" https://forums.unrealengine.com/t/cant-make-metahuman-static-mesh-grooms-disappear-or-how-do-i-export-a-hair-card-with-pbr-materials-in-it/2668973
- [S22] Web-search summary of Epic tutorial "Skeletal Mesh Optimization Guide" (page not opened): https://dev.epicgames.com/community/learning/tutorials/2JVl/unreal-engine-metahuman-skeletal-mesh-optimization-guide
- [S23] Web-search summaries (pages blocked): CGTrader "Boxing Gloves 3D model rigged" https://www.cgtrader.com/3d-models/sports/equipment/boxing-gloves-36829b09-051f-4f38-9616-6e539fb82644; "Gloves 41 - All MH Bodies - UE5 Skeletons - Rigged" https://www.cgtrader.com/3d-models/character/clothing/gloves-41-all-mh-bodies-ue5-skeletons-rigged; "Boxing practice focus pads punch mitts" https://www.cgtrader.com/3d-models/sports/equipment/boxing-practice-focus-pads-punch-mitts; Cults3D focus mitt https://cults3d.com/en/3d-model/game/boxing-training-pad-focus-mitt-premium-3d-model-zprj-fbx-obj
- [S24] Web-search summaries: Unity Asset Store Terms/EULA https://unity.com/legal/as-terms; Unity "Boxing equipment - helmet and gloves" https://assetstore.unity.com/packages/3d/props/weapons/boxing-equipment-helmet-and-gloves-127631; "Boxing Fighters Pack" page https://assetstore.unity.com/packages/3d/characters/humanoids/boxing-fighters-pack-185413 (fetch timed out).
- [S25] CG Channel, 2025-06-04, as cited in J_CLOTHES_S207 (not re-fetched this session; superseded by [S1][S2]).

---

## 7. Limits

- **Epic dev docs were not readable.** dev.epicgames.com returned Cloudflare challenges. That covered "Using MetaHumans outside Unreal Engine", the DCC export, Outfit Asset and Chaos Outfit docs, and the glTF exporter. Export and resize details therefore rest on a secondary source [S8], Epic staff forum posts [S9][S10], and the MetaHumanGodot README [S12]. NOT FOUND: Epic's official step list, the direct UE glTF export of MetaHuman skeletal meshes, and body LOD0 triangle counts.
- **I could not read the full Fab EULA.** Only the summary [S4] and the forum-quoted tier clause [S5]. I could not check whether specific listings are tagged NoAI or use a non-standard licence. Open each listing page and read its licence box before buying. JUDGEMENT.
- **Fab listing pages were not opened.** Contents, polycounts and LODs come from the search API's seller-entered "technicalDetails". Several are blank, or are placeholder polygon ranges (e.g. "0-1"), which I ignored.
- **CGTrader, TurboSquid and the Unity Asset Store were bot-blocked or timed out.** Their prices are search-snippet values or NOT FOUND. TurboSquid prices: NOT FOUND.
- **Attribution for a non-UE game.** EULA 7(a) credits wording vs a Godot product is unresolved. Ask Epic (licensing contact via [S1] "custom licensing terms") or a lawyer. NOT FOUND.
- **Hours and route scores are estimates.** They are not measured. The first end-to-end export (one dressed MetaHuman into Godot 4.7.2 with BoneMap, hair cards and a masked body) should be timed before committing. JUDGEMENT.
- **Maria's M_WARDROBE_S207 (T1-T6 codes) was not available.** Section 5's look mapping is indicative only.
- **Mesh to MetaHuman.** 5.8 can convert "meshes generated with tools like Meshy or Tripo" into MetaHumans [S6]. Noted for completeness only. The operator ruled Tripo bodies out, and this memo assumes Creator-made bodies.
- **Bone counts.** The 342 body / 875 face figure is from an unopened search summary [S22]. Verify in Godot's Skeleton3D on the first import.
