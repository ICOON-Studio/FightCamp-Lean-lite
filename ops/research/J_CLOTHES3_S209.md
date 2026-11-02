# J_CLOTHES3_S209 - John Research (gbot thread "John Research"), saved verbatim by Claude S210

Operator Q-S208-1: "we donot spend money on this , check for free packs".

John's summary: J_CLOTHES3_S209 is finished. I estimate about **19 of the 30 looks can be dressed today for $0** from free Fab items, nearly all of them MetaHuman outfits that resize to any body. The other 11 still cost nothing but need some Blender work. The gap is boxing kit: I found no free MetaHuman-ready trunks, hand wraps, boxing boots or focus mitts. The Marvelous Designer free trial can't fill those gaps, because its terms exclude commercial use.

On the operator's question, the Fab item is Epic's **MetaHuman Clothing Construction Presets, Set of 4**. It's free, and we don't need it to put outfits on people. It's only useful if we make our own trunks, wraps or tracksuit top, but it costs nothing, so I'd claim it now. Three other items are free only on Fab's Personal tier, which is open while revenue is under $100k: the boxing glove, the sweatpants and the crew-neck tee. Those should be claimed now too.

The cost of going free is time: about 125–210 hours in total, roughly 70–120 more than the paid route. The full document follows in three parts, and the file is attached.

**Part 1 of 3**

# J_CLOTHES3_S209 - Free-only clothing for FightCamp MetaHumans

Date: 2026-10-12 (Asia/Nicosia). Owner: John Research. Follows J_CLOTHES2_S208 and J_CLOTHES_S207, and does not repeat them.
Operator ruling (verbatim): "we donot spend money on this , check for free packs".
Tags: **SOURCED [Sn]** (URL in section 7, accessed 2026-10-12), **JUDGEMENT** (my opinion or estimate), **NOT FOUND** (I looked and could not confirm it).
Fab prices and licence tiers below come from Fab's public JSON (`/i/listings/search` and `/i/listings/<uid>`). "$0/$0" means both the Personal and Professional tiers cost $0. "$0/$X" means Personal is free and Professional costs $X.

---

## 0. Answer first

1. **We can dress most of the 30 looks for $0. Boxing gear is the gap.** Free Fab items cover tees, long-sleeve shirts, tanks, crop tops, blouses, sweatpants, cargo, carpenter and jeans, and nine shoe types. Most are parametric MetaHuman "OutfitClothing" that resizes to any body in MetaHuman Creator. SOURCED [S2][S3][S4][S5][S6]. My estimate: about **19 of 30 looks** can be done at $0 with no new garments, **about 6 more** need one Blender-authored garment, and **about 5 boxer looks** need two to three home-made pieces each. See section 5. JUDGEMENT.
2. **Licence: free Fab items use the same Fab Standard License as paid ones.** Commercial use in a Godot game is allowed: "Use the assets with any compatible tools (usage is not limited to Unreal Engine)". SOURCED [S8]. Each listing's JSON shows `"group":"standard"` with Personal and Professional tiers. SOURCED [S1][S5][S6][S7]. Some free Fab items are **CC-BY** instead. Those need a credit line. SOURCED [S2][S3][S4]. **None of the free Fab items I found is marked "UE-Only" or NC.** SOURCED [S2-S7] (field check). The Epic items and the glove are **NoAI** (`isAiForbidden: true`). SOURCED [S1][S5][S6][S7].
3. **The operator's "do we need this" item (Fab 3c0c4df1) is "MetaHuman Clothing Construction Presets, Set of 4" by Epic. It costs $0/$0 and is NOT required to wear outfits.** It contains 4 body presets (.mhpkg) plus FBX files of those bodies "ready for use in garment creation in your DCC of choice". It only matters if we **make our own parametric garments** (trunks, hand wraps, tracksuit top). In that case it is the recommended set of base bodies, so claim it now (it's free). SOURCED [S1]; recommendation = JUDGEMENT.
4. **The three items named in the brief are all free and usable.** MetaHuman T Shirt Variants: 5 sleeve types, parametric, 4 LODs, $0/$0. Tucked T Shirt Variants: the same 5 sleeves, tucked, $0/$0. Pedro Perin's Boxing Glove: static OBJ, **Personal $0 / Professional $2.99**. SOURCED [S5][S6][S7]. The glove is free only on the Personal tier. Claim it while we are under the $100k revenue limit. SOURCED [S9]; advice = JUDGEMENT.
5. **No free MetaHuman-ready boxing trunks, hand wraps, boxing boots, focus mitts, or male tracksuit top / hoodie were found on Fab.** NOT FOUND [S2][S3][S4][S24]. Sketchfab **CC-BY** has static or unrigged boxing headgear, gloves, boots, shorts, polos and hoodies that can be refitted in Blender. SOURCED [S12].
6. **The no-money fallback is Blender plus the S207 tint/decal system.** Blender is free and "What you create with Blender is your sole property". SOURCED [S20]. The **Marvelous Designer / CLO free trial cannot be used**: its "Trial Purpose ... specifically excludes ... commercial, professional, or other for-profit purposes". SOURCED [S19]. The fallback work totals **about 70-120 h** of garment authoring and refitting, plus **about 45-75 h** of per-look UE assembly and export (the same assembly cost as S208). JUDGEMENT.
7. **CGTrader's free MetaHuman clothing could not be checked directly.** The page is behind a JS bot check. SOURCED [S15] (blocked fetch). Search snippets show Paradoox "Streetwear Parametric Outfit 01/12" on `/free-3d-models/` URLs, but CGTrader's category page lists them at $99.99 / $12. **Free status is contradictory, so re-check on download day.** SOURCED [S13][S14][S15]. Licence: "Royalty Free License (no AI)". In a game the asset must be "contained inside a proprietary format". Godot's packed .pck plus imported .scn/.res resources probably satisfy this. JUDGEMENT. Clause SOURCED [S17][S18].

---

## 1. Operator question: Fab 3c0c4df1 - do we need it?

| Field | Value | Tag |
|---|---|---|
| Name | MetaHuman Clothing Construction Presets, Set of 4 | SOURCED [S1] |
| Seller | Epic Games | SOURCED [S1] |
| Price | Personal $0 / Professional $0 | SOURCED [S1] |
| Licence | Fab Standard (`"group":"standard"`), NoAI (`isAiForbidden: true`) | SOURCED [S1] |
| Category | Characters & Creatures > Humans (not clothing) | SOURCED [S1] |
| Contents | "four body presets which can be used to create parametric clothing on ... If you want to create a parametric garment with four "sizes," these four bodies are recommended". It also "contains FBX files of the four presets with bodies and heads combined, ready for use in garment creation in your DCC of choice". The full set is in the zip under additional content: "The main mhkpg file associated with this listing is only a single preset body as opposed to all, due to current limitations." | SOURCED [S1] (verbatim) |
| First published / updated | 2025-06-03 / 2025-11-12 | SOURCED [S1] |
| **Required to wear outfits?** | **No.** Parametric garments resize in Creator on their own. The Epic T-shirt listings say they "fit onto any body shape in MetaHumanCreator" with no mention of this pack. | SOURCED [S5]; conclusion JUDGEMENT |
| **Useful to us?** | **Yes, if we author trunks, hand wraps or a tracksuit top ourselves.** Model and sim in Blender on these 4 FBX bodies, then build a 4-size parametric outfit in UE. It also gives us 4 reference bodies for refitting the Sketchfab CC-BY items. | JUDGEMENT |
| Verdict | Claim it (it's $0). It is not needed for buying/claiming-only looks. It is needed for the custom-garment fallback in section 5. | JUDGEMENT |

---

## 2. Licences that apply to the free items

**Fab Standard License (summary page)**. Commercial use in a Godot game: **YES**. SOURCED [S8]:
> "You may: Use the assets commercially or privately; Modify and adjust the assets in order to incorporate them into your Projects; Commercially distribute your Projects with the Fab assets incorporated into it; Use the assets with any compatible tools (usage is not limited to Unreal Engine); Share the asset (directly, via a private repository or in the Project) with your collaborators that are working on the Project with you. You may not: Resell or redistribute the asset for free on a standalone basis or allow others to do the same."

**Fab Personal-tier eligibility** (applies to "$0 Personal / paid Professional" items). Quote from Epic forum staff, re-used from S208. SOURCED [S9]:
> "You are only eligible for a Personal - Reference Only tier or Personal tier if, at the time of the Transaction you, together with any controlling entity and other entities under common control with you, have not generated more than $100,000 USD in gross revenue from your commercial activity in the digital content industry in the last 12 months."

What this means for us: claim every "$0/$X" item **now**, while under $100k. A licence claimed while eligible should remain ours. JUDGEMENT. Whether a later claim after crossing $100k would need the Pro tier is answered by the clause above ("at the time of the Transaction").

**Fab CC-BY items.** The listing JSON reports `"name":"CC-BY"` (with an odd `isCc0:true` flag). SOURCED [S2][S3][S4]. Commercial use: **YES, with attribution**. I did not open Fab's own CC-BY wording. NOT FOUND. I treat these as standard Creative Commons Attribution: credit the author in the game credits. JUDGEMENT.

**NoAI.** Epic's items and Pedro Perin's glove carry `isAiForbidden: true`. SOURCED [S1][S5][S6][S7]. This does not limit use in the game. It does mean no use as generative-AI input or training data (S208 section 1, Epic Content Licence s.17). Practical rule: never put these meshes or renders into Tripo, Higgsfield or any similar generator. JUDGEMENT.

**MetaHuman outputs in Godot.** Unchanged from S208: "Non-Engine Products", no royalty, seat licence only above $1M. SOURCED [S10][S11].

**CGTrader Royalty Free** (CGTrader help page). Commercial game use: **YES, with conditions**. SOURCED [S17]:
> "as purchased by a game's creators as part of a game if the Product is contained inside a proprietary format and displays inside the game during play, but not for users to re-package as goods distributed or sold inside a virtual world;"
> "If you use any Product in software products (such as video games, simulations, or VR-worlds) you must take all reasonable measures to prevent the end user from gaining access to the Product. Methods of safeguarding the Product include but are not limited to: ... using a proprietary Product format; using a proprietary and/or password protected database or resource file that stores the Product data; encrypting the Product data."

The current Terms (s.21A.3) say "all **commercially** reasonable measures". SOURCED [S18]. Godot export with a .pck and optional PCK encryption is a reasonable measure. JUDGEMENT. Do not ship the raw GLB/FBX loose in the game folder. JUDGEMENT.

**Sketchfab CC Attribution.** Commercial use: YES, credit required. CC BY-NC / SA / ND were filtered out and are excluded. SOURCED [S12] (API `license=by` / `license=cc0` filter).

**Marvelous Designer / CLO trial.** Commercial use: **NO**. SOURCED [S19]:
> "'Trial Purpose' means purposes of initial evaluation and demonstration of the capabilities of the Software but specifically excludes: i) competitive analysis, commercial, professional, or other for-profit purposes"

It also says "Upon expiration of a Personal (or Student) Trial, you shall be automatically subject to either a Personal or Student License to which the Fee under Monthly Subscription ... shall be charged". So the trial converts to a paid plan. SOURCED [S19]. **There is no free commercial tier of MD.** A free CLO-SET/MD tier allowing commercial use: NOT FOUND [S19][S23].

**Blender.** Commercial use: **YES**. SOURCED [S20]:
> "Your Artwork What you create with Blender is your sole property. ... That means that Blender can be used commercially by artists, by studios ... by game artists to work on commercial games"

**Part 2 of 3**

## 3. Census of free items usable by us

Format key: **P** = MetaHuman OutfitClothing (parametric, resizes in Creator, UE 5.x listed). **R** = rigged skeletal (fixed body). **S** = static mesh or rig NOT FOUND (needs Blender skinning to the MH skeleton). "Commercial in Godot" is YES for every row under the licences in section 2.

Look codes: TR = boxer trunks, BB = boxing boots, GL = gloves, HW = hand wraps, HG = headgear, GT = gym tee/tank, GS = gym shorts, TS = tracksuit / sweats, CP = coach polo/jacket, ST = staff, MC = members' casual, SH = shoes, CU = customers' street wear.

### 3a. The three named items (asked for explicitly)

| # | Item | URL | Seller | Price (Pers/Pro) | Licence | Format | Covers | Polycount | Tag |
|---|---|---|---|---|---|---|---|---|---|
| N1 | MetaHuman T Shirt Variants | https://www.fab.com/listings/1b1009ae-4327-4c9d-9567-9314d88e7a86 | Epic Games | $0/$0 | Fab Standard, NoAI | **P** (.mhpkg). 5 variants: short, 3/4, long, long cuffed, pushed-up cuff. "All Include 4 body LODS". Colours editable in Creator | GT, ST, MC, CU, CP (with logo decal) | NOT FOUND | SOURCED [S5] |
| N2 | MetaHuman Tucked T Shirt Variants | https://www.fab.com/listings/839b9239-5ea4-40a0-90b3-076e0d9959f7 | Epic Games | $0/$0 | Fab Standard, NoAI | **P**. The same 5 sleeve variants, tucked. 4 LODs | ST (front desk with logo), CP, MC, CU | NOT FOUND | SOURCED [S6] |
| N3 | Boxing Glove | https://www.fab.com/listings/b9bc411a-193b-4965-bb8b-535882bb4614 | Pedro Perin | **$0 / $2.99** | Fab Standard, NoAI | **S** (OBJ + zip). "real-time model optimized for game engines" | GL (BoneAttachment3D, S207) | "3k triangles" per seller (from S208); not in JSON | SOURCED [S7]; tris from S208 |

Notes. N1 and N2 say "Some Body shapes may occasionally cause suboptimal resizing results ... try selecting a different size with the 'Source Size Override' dropdown". SOURCED [S5][S6]. Budget about 10-15 min per extreme body. JUDGEMENT. Both belong to Epic's "MHC Web App to Parametric Clothing Set", so they mix and match with other garments from that set. SOURCED [S5].

### 3b. Fab "Shirts", free filter (first page only: the API returned a `next` cursor, so the category is NOT fully censused)

| # | Item (uid) | Seller | Price | Licence | Format | Covers | Polycount (as listed) | Tag |
|---|---|---|---|---|---|---|---|---|
| F1 | Shirt V-neck with rolled sleeves (c4079e06-cef5-440c-8963-e05fd9462828) | Nyanpasinka | $0/$0 | Fab Standard | **P** (UE 5.6/5.7) + UE asset pack + OBJ/FBX. "Rigged to ... MetaHumans Skeleton: Yes, to UE5 skel" | MC, CU, ST | "Vertex Count: 7170" | SOURCED [S2] |
| F2 | Shirt longsleeve with pockets (0829223f-a793-42bf-9575-b26f420adfb7) | Nyanpasinka | $0/$0 | Fab Standard | **P** (5.6/5.7) + OBJ/FBX | ST, CP (casual coach), CU | "Vertex Count: 9706 each size, male and female" | SOURCED [S2] |
| F3 | MetaHuman Crop Top Variants (39bcebb4-cbc7-4c5e-9cd6-d6dd6b5ed9ff) | Epic Games | $0/$0 | Fab Standard | **P** (5.7) | GT (female boxer / member), MC | NOT FOUND | SOURCED [S2] |
| F4 | Tank top - 001 - mhpkg (a82e3edc-1cb3-4db1-bd7c-d395901c0aac) | Vivi_Studio | $0/$0 | Fab Standard | **P** (5.8 only) | GT (boxer training tank) | NOT FOUND | SOURCED [S2] |
| F5 | Tank Top for MetaHumans - Parametric Outfit (f510aa01-1898-40bb-9a6b-4d66ab0605cb) | QuingKhaos | $0/$0 | Fab Standard | **P** (5.6/5.7). Tags: female, lowpoly | GT (female) | NOT FOUND | SOURCED [S2] |
| F6 | The Marilla Top for MetaHumans (dc6a2e50-8097-4ae0-b743-05bcd8559ad3) | QuingKhaos | $0/$0 | Fab Standard | **P** (5.7). "Number of LODs: 4". Chaos cloth setup | GT / MC (female sleeveless) | "Vertex Count: 7937" | SOURCED [S2] |
| F7 | The Altena Blouse for MetaHumans (f5fb23d7-2ad1-4fc4-af7a-12b259c9eb4e) | QuingKhaos | $0/$0 | Fab Standard | **P** (5.7) | ST (female front desk), CU | NOT FOUND | SOURCED [S2] |
| F8 | Crew Neck T-Shirt for MetaHuman & UE5 Manny (25ae26c3-8192-4390-9596-00745c6d555e) | Sasikumar | **$0 / $4.99** | Fab Standard | **P** (5.8). Tags: lowpoly, modular, epicskeleton | GT, MC, CU | NOT FOUND | SOURCED [S2] |
| F9 | 3D Male Raglan Tshirt (0322f83f-54a1-4cae-8749-0d3226c263d1) | canerhalavurt | $0 | **CC-BY** | **S**? FBX/Blend/OBJ/GLB. Tagged "MetaHuman" but rig NOT FOUND | MC, GT (sporty raglan) | NOT FOUND | SOURCED [S2] |
| F10 | Polo Shirt (83199593-d165-48fa-b9cc-0c94e200e858) | dimension Dazzle | $0 | **CC-BY** | **S** (FBX/OBJ/Blend/Maya). Tags: sportswear, uniform, polo, gameready | **CP (coach club polo)**, ST | NOT FOUND | SOURCED [S2] |
| F11 | 3D Bodysuit Free (ed0fcf88-6648-4b15-8fa1-c0dae30d263d) | canerhalavurt | $0/$0 | Fab Standard | **S** (Blend/OBJ/FBX). Tags: swimsuit, sportswear | Marginal (female base layer) | NOT FOUND | SOURCED [S2] |

### 3c. Fab "Pants", free filter (complete: 14 results, `next: null`)

| # | Item (uid) | Seller | Price | Licence | Format | Covers | Polycount | Tag |
|---|---|---|---|---|---|---|---|---|
| F12 | MetaHuman Cargo Pants (586d2fd4-9ae9-4d91-9e61-2a362008d052) | Epic Games | $0/$0 | Fab Standard | **P** (5.7) | CP, ST, CU | NOT FOUND | SOURCED [S3] |
| F13 | Basic Sweatpants - Parametric Clothing (bc90695b-485c-4c2c-b61c-e2692cfca65b) | Kurmanin Tailor | **$0 / $5.99** | Fab Standard | **P** (5.7) + "Blender file with models" + 4K textures | **TS** (boxer roadwork, coach, member). The Blender file is the base for home-made gym shorts | NOT FOUND | SOURCED [S3] |
| F14 | METAHUMAN BODY CLOTHING (12ce86b8-7e0a-497c-9f41-d48035a45ecf) | HIGH_RES_STUDIO | $0/$0 | Fab Standard | **R**? GLB only (0.67 MB). Tags: skinned, sweatpants, shirt, ladieswear, MetaHuman | TS / MC (female). Quality unverified | NOT FOUND | SOURCED [S3] |
| F15 | Denim Mom Jean (89485173-2a07-4815-9e40-02a3cc4a3f30) | Paradoox | $0/$0 | Fab Standard | **S** (FBX). Tags: retopology, gameready, lowpoly | CU, ST (female) | NOT FOUND | SOURCED [S3] |
| F16 | The Clarkston Carpenter Pants for MetaHumans (c362085e-28df-4570-a477-4e86c1a991c6) | QuingKhaos | $0/$0 | Fab Standard | **P** (5.7). Tags: female, trouser | ST, CU | NOT FOUND | SOURCED [S3] |
| F17 | The Eucalyptus Shorts for MetaHumans (37a20834-3c13-4262-b643-387a8f69a97b) | QuingKhaos | $0/$0 | Fab Standard | **P** (5.7). Tags: female, short | GS (female member / boxer) | NOT FOUND | SOURCED [S3] |
| F18 | Underpants - 006 - mhpkg (fe54011f-f784-4137-a102-3816230d00d3) | Vivi_Studio | $0/$0 | Fab Standard | **P** (5.8) | Under-layer. A possible starting shape for trunks (JUDGEMENT) | NOT FOUND | SOURCED [S3] |
| F19 | Pocolov Bottoms Pants 02 (d5ccd35d-55f9-41b3-aa26-36b87525ff06) | Pocolov | $0 | CC-BY | **S** (FBX). Odd tags ("bottle") | CU (female). Low confidence | NOT FOUND | SOURCED [S3] |

### 3d. Fab "Shoes", free filter (complete: 22 results, `next: null`)

| # | Item (uid) | Seller | Price | Licence | Format | Covers | Polycount | Tag |
|---|---|---|---|---|---|---|---|---|
| F20 | MetaHuman Running Shoes (c79be75e-b5bb-461c-9c2b-72272254daea) | Epic | $0/$0 | Fab Standard | **P** (5.7) | SH: boxers in training, members, coaches | NOT FOUND | SOURCED [S4] |
| F21 | MetaHuman Hightops (0bdf37d3-8ebf-4ec1-905d-65737b1c2809) | Epic | $0/$0 | Fab Standard | **P** (5.7) | SH. **Boxing-boot stand-in** when tinted (JUDGEMENT) | NOT FOUND | SOURCED [S4] |
| F22 | MetaHuman Casual Sneakers (7e58d5c5-5666-4ab2-9c4e-011eeaba3c07) | Epic | $0/$0 | Fab Standard | **P** (5.7) | SH: members, staff, customers | NOT FOUND | SOURCED [S4] |
| F23 | MetaHuman Boots (c6596c37-e34f-46d4-a44e-fc360cc079c4) | Epic | $0/$0 | Fab Standard | **P** (5.7) | SH: customers | NOT FOUND | SOURCED [S4] |
| F24 | MetaHuman Chelsea Boots (b910abee-3189-4396-9bd2-d8ce57b7bb88) | Epic | $0/$0 | Fab Standard | **P** (5.7) | SH: customers, staff | NOT FOUND | SOURCED [S4] |
| F25 | MetaHuman Loafers (2f631109-17ab-4c87-a78c-5148927de957) | Epic | $0/$0 | Fab Standard | **P** (5.7) | SH: staff, customers | NOT FOUND | SOURCED [S4] |
| F26 | MetaHuman Oxfords (25b79aec-45c7-4f9a-88eb-5c3220d975bd) | Epic | $0/$0 | Fab Standard | **P** (5.7) | SH: customers (smart) | NOT FOUND | SOURCED [S4] |
| F27 | MetaHuman Flats (735c8256-e1b2-4157-b411-9e53ed6f34f2) | Epic | $0/$0 | Fab Standard | **P** (5.7) | SH: staff, customers | NOT FOUND | SOURCED [S4] |
| F28 | MetaHuman FlipFlops (73272acc-25fe-43ee-a97f-d82a0888d46c) | Epic | $0/$0 | Fab Standard | **P** (5.7) | SH: showers / changing area flavour | NOT FOUND | SOURCED [S4] |
| F29 | Performance Runner Sneaker Shoes - MetaHuman Ready (70fca8bf-dad6-4b36-8c33-370bedc07738) | ShortGenie 3D | $0/$0 | Fab Standard | **P** (5.7) + FBX. Tags: activewear, epicskeleton | SH: boxers, members | NOT FOUND (API shows a 7-8 range bucket, not a real count) | SOURCED [S4] |
| F30 | Male Shoes Free (00011a56-e8ff-4ba2-a136-9aee6a2274bb) | lightyeager3d | $0 | CC-BY | **S** (FBX). Tags: lowpoly, sneaker | SH (backup) | NOT FOUND | SOURCED [S4] |
| F31 | Low Poly Game Ready Female Shoes (2109f859-fb66-44dd-b2d2-e539eb959c1f) | lightyeager3d | $0 | CC-BY | **S** (FBX) | SH (backup) | NOT FOUND | SOURCED [S4] |
| F32 | Leather Boots (eaed8681-d419-4f71-b6e4-720d435dc403) | Ika | $0 | CC-BY | **S** (FBX) | SH: customers | NOT FOUND | SOURCED [S4] |
| F33 | Realistic Women's Boots 2 / Boots 14 (63be0ebd..., 00e20174...) | Evsed | $0 | CC-BY | **S** (GLB) | SH: female customers | NOT FOUND | SOURCED [S4] |
| F34 | Shoe / Cyberpunk Sneaker (02bf46e3..., 01a9f584...) | Kamilla Kraus | $0 | CC-BY | **S** (FBX/GLB) | SH (backup) | NOT FOUND | SOURCED [S4] |

### 3e. Other free Fab finds from the keyword sweep (snippets only)

| # | Item | URL | Licence / price | Format | Covers | Polycount | Tag |
|---|---|---|---|---|---|---|---|
| F35 | 【FREE】 Men's Boxer Briefs - Low Poly | https://www.fab.com/listings/57498a65-da61-47e7-83ca-bcdf3acc767f | Free. The seller's text says "Commercial use: Allowed ... Redistribution: Not allowed". Fab tier JSON not opened | **S** (FBX). "Rig: Not included" | Under-layer only, not trunks | "Vertices: 365 Polygons: 660" | SOURCED [S21] |

Sweep result for 'metahuman' hoodie / tracksuit / polo / jacket / headgear / hand wrap / boxing **as free Fab items**: none found apart from the glove (N3) and polo F10 (CC-BY, static). The "Urban Casual Outfit" hoodie (663af53d) and Husky Studio "Shorts - 2" (9e160eaa) appeared in the sweep. Shorts-2 is a paid listing. Urban Casual's price is NOT FOUND. Neither is counted. SOURCED [S24]; "none free" = NOT FOUND within the snippet sweep (I did not run per-keyword `is_free` API queries for every term, see section 6).

### 3f. Sketchfab, downloadable, CC0 / CC-BY only (gap fillers)

All are **CC Attribution** (no CC0 clothing hits). Commercial in Godot: YES, with credit. Format **S** unless noted. SOURCED [S12].

| # | Item | URL | Author / date | Covers | Faces (API `faceCount`) |
|---|---|---|---|---|---|
| K1 | Boxing Headgear Helmet (Low Poly) | https://sketchfab.com/3d-models/498387769b0347f292ab1bdbddbfe719 | artel_3D, 2026-01-26 | **HG** | 13,070 |
| K2 | Boxing headgear fbx | https://sketchfab.com/3d-models/9a43d1767d9e4296bdd0e8b51f80d20a | chillax12, 2024-06-10 | HG (backup) | 18,740 |
| K3 | Boxing Glove | https://sketchfab.com/3d-models/5b464201104949e09f77f2d1cf8b60c3 | incg5764, 2023-02-23 | GL (alt colourway) | 4,064 |
| K4 | boxing gloves | https://sketchfab.com/3d-models/9d244a5bfaf84ea398cff99154e99eab | rxf10240, 2024-04-11 | GL (alt) | 5,264 |
| K5 | Boxing gloves (3 animations listed) | https://sketchfab.com/3d-models/c1572e87f6f2467caf1ece6cf39d10e6 | Nixak, 2024-07-19 | GL close-up only | 49,352 |
| K6 | Boxer - Boots | https://sketchfab.com/3d-models/e843e3e83750425db83a92ea77f900b7 | suttonj94, 2026-05-31 | **BB** (needs skinning to the MH foot) | 4,612 |
| K7 | Shorts Boxer | https://sketchfab.com/3d-models/4029542180bd4bb68a039fc00a200b3c | suttonj94, 2026-05-31 | **TR** reference (too dense to ship as-is; retopo) | 73,736 |
| K8 | Female sweatshirt for Metahuman | https://sketchfab.com/3d-models/3b58e05f01e1476a9205dcd4f0fd31fa | kurmanin, 2023-03-31 | TS / MC (female). Made for MetaHuman, but for the pre-5.6 body, so refit needed (JUDGEMENT) | 3,990 |
| K9 | Polo_Shirt | https://sketchfab.com/3d-models/c78b9c725db44324b3246cc59af1947e | WatsonAndrew, 2021-03-15 | CP (polo alt) | 11,500 |
| K10 | Hoodie | https://sketchfab.com/3d-models/6dca9cd855a8441881f0b324236cf325 | Badboy17Aiden, 2016-11-21 | TS hoodie (male) | 25,946 |
| K11 | Hoodie and Jeans | https://sketchfab.com/3d-models/4fc7bc06a5b94568b1923268f4a6e825 | lizhiqiang89, 2021-06-17 | TS / CU | 10,542 |
| K12 | Floyd Tracksuit | https://sketchfab.com/3d-models/a6bb200b0a7e4788a4d2a3c97a1fab49 | marcosacevez57, 2026-04-02 | TS / CP tracksuit. **Name may refer to a real boxer: check for logos or likeness before use** (JUDGEMENT) | 16,977 |

Rejected on polycount (JUDGEMENT; all CC-BY [S12]): hoodies of 134k-1.34M faces, tracksuits of 567k-758k, polos of 54k-829k. They are too dense to retopologise cheaply.

### 3g. CGTrader and off-marketplace free (unverified)

| # | Item | URL | Licence | Free? | Format | Covers | Polycount | Tag |
|---|---|---|---|---|---|---|---|---|
| C1 | Streetwear Parametric Outfit 01 (Paradoox) | https://www.cgtrader.com/free-3d-models/character/clothing/streetwear-parametric-outfit-01-fully-rigged-to-metahuman | "Royalty Free License (no AI)" | **Contradictory**: free URL, but the category page shows $99.99 | **P** (.mhpkg) + FBX/OBJ/Maya avatars. "Rigged to Epic or Metahuman Skeleton: Yes" | CU street wear | "Vertex Count: 52307 (Outfit)" | SOURCED [S13][S15] |
| C2 | Streetwear Parametric Outfit 12 (Paradoox) | https://www.cgtrader.com/free-3d-models/character/clothing/streetwear-parametric-outfit-12-fully-rigged-to-metahuman | Royalty Free (no AI) | **Contradictory**: free URL, but the category page shows $12 | **P** | CU | NOT FOUND | SOURCED [S14][S15] |
| C3 | Soccer Outfit Kit 01 (Paradoox) | https://www.cgtrader.com/free-3d-models/character/clothing/soccer-outfit-kit-01 | Royalty Free (no AI) | Free per search | Rig to MH: NOT FOUND | GT + GS sports kit (retexture as a club kit) | NOT FOUND | SOURCED [S16] |
| C4 | OF Studio "10 royalty-free .mhpkg outfits" | https://3d-clothes-metahuman-outfit.com/ | Site says "royalty-free ... without restrictions". **No formal licence text found** | Free (Dropbox) | **P/R** .mhpkg | Unknown mix (site mentions tactical gear, period dresses) | NOT FOUND | SOURCED [S22]. **Do not use until a written licence is obtained** (JUDGEMENT) |

The full list of free items in CGTrader's `metahuman?free=1&suggested_keywords=clothing` view is **NOT FOUND**. The page returned "JavaScript is disabled ... verify that you're not a robot" to both WebFetch and curl. SOURCED [S15].

---

## 4. Excluded or flagged (short list)

| Item | Source | Reason |
|---|---|---|
| Ryan Gosling Style Scorpion Jacket (ae532bd4, CC-BY) | Fab [S2] | Celebrity name and film-costume replica: right-of-publicity / trademark risk. JUDGEMENT |
| Shiny Bustier, Sporty Thong (QuingKhaos) | Fab [S2][S3] | Free and parametric, but off-theme for a gym sim. JUDGEMENT |
| Medieval Shirt Lace Up, Women Sleeve Blouse Medieval (Clothcraft) | Fab [S2] | Period costume. JUDGEMENT |
| Poncho, 20 women Dress Collection (rating 1.0), Suit (seller "Natural Ai", $0/$1.99) | Fab [S2] | Off-theme / low quality / possibly AI-made. JUDGEMENT |
| Button Shirt, Plaid Shorts "Laundry Messy Hanging" (Weitagon, $0/$19.99) | Fab [S2][S3] | Photoscans of hanging laundry: props, not wearable clothing. SOURCED (titles) |
| "two pieces suit white color silk satin" | Fab [S3] | Personal tier $5.99 (Pro $0): not free on our tier. SOURCED [S3] |
| Stylized Ruched Mini Dress, Stylized Cartoon Sneakers | Fab [S3][S4] | Stylised, which clashes with realistic MetaHumans (J65). JUDGEMENT |
| Emerald Velvet Court Shoe, Evsed high heels | Fab [S4] | Off-theme for a boxing gym (optional for walk-ins). JUDGEMENT |
| Sketchfab hand-wrap search hits | Sketchfab [S12] | Swords and statues only, not hand wraps |
| MMA Shorts (rigmodels.com) | [S25] | Says "Royalty Free" with no licence text. Site provenance unclear. JUDGEMENT |
| Marvelous Designer / CLO trial | [S19] | Trial excludes commercial use |
| Any CC BY-NC / SA / ND | Sketchfab | Not pulled (filtered out) |

**Part 3 of 3**

## 5. Free-only plan for 30 looks

Assumptions. M_WARDROBE_S207 was not available, so these 6 looks per role are my working list. JUDGEMENT. Every look uses the S207 sec 3 system (shared Skeleton3D, skinned garments, BoneAttachment3D for rigid items, per-instance tint with RGB masks, logo decal slot). Each look is assembled in UE 5.7/5.8 Creator on one of 6-8 body archetypes and exported (S208 sec 4). Tint plus decal turns one free garment into several distinct looks: e.g. N1 short-sleeve tee in club red with logo, grey plain, or black with a sponsor patch. JUDGEMENT.

Status key: **$0-ready** = existing free items only. **$0+B** = needs a Blender-made or refitted piece (still $0). **GAP** = no free item exists; the fallback is listed.

### Boxers in training

| Look | Garments | Status |
|---|---|---|
| BX1 Bag work, tank | F4 tank (male) + **trunks (GAP)** + F21 Hightops tinted as boots + N3 gloves | $0+B (trunks) |
| BX2 Skipping, tee | N1 short-sleeve tee + **trunks** + **hand wraps (GAP)** + F20 Running Shoes | $0+B (trunks, wraps) |
| BX3 Roadwork | K10/K11 hoodie refit, or N1 long-sleeve tee + F13 Sweatpants + F29 runners | $0-ready with the long-sleeve tee; $0+B with the hoodie |
| BX4 Sparring | F4 tank + **trunks** + K1 headgear + N3/K3 gloves + K6 boots refit | $0+B (trunks, boots skin) |
| BX5 Pads, shirtless | Bare torso + **trunks** + **hand wraps** + F21 | $0+B |
| BX6 Female boxer | F3 Crop Top or F5 Tank + F17 Eucalyptus Shorts (tint) + **wraps** + F20 | $0+B (wraps only) |

### Coaches in club uniform

| Look | Garments | Status |
|---|---|---|
| CO1 Club tee | N2 tucked tee, club colour + logo decal + F12 Cargo Pants + F20 | **$0-ready** |
| CO2 Club polo | F10 Polo (CC-BY) refit + F12 + F22 | $0+B (polo skinning) |
| CO3 Tracksuit | **zip top (GAP)** + F13 Sweatpants + F20 | $0+B (zip top: K12 refit or Blender) |
| CO4 Long-sleeve | N1 long-cuffed tee + F13 + F29 | **$0-ready** |
| CO5 Pad holder | CO1 + **focus mitts (GAP, static)** | $0+B (mitts) |
| CO6 Female coach | F2 longsleeve with pockets (logo) + F16 Carpenter Pants + F22 | **$0-ready** |

### Front-desk staff

| Look | Garments | Status |
|---|---|---|
| ST1 | N2 tucked tee + logo + F12 + F22 | **$0-ready** |
| ST2 | F1 V-neck + F15 Mom Jean (refit) or F12 + F25 Loafers | $0-ready with F12 |
| ST3 | F2 longsleeve with pockets + F12 + F24 Chelsea | **$0-ready** |
| ST4 Female | F7 Altena Blouse + F16 + F27 Flats | **$0-ready** |
| ST5 | N2 3/4-sleeve tucked + F16 + F22 | **$0-ready** |
| ST6 | N1 pushed-up-cuff tee + F12 + F21 | **$0-ready** |

### Gym members

| Look | Garments | Status |
|---|---|---|
| ME1 | N1 tee + F13 Sweatpants + F20 | **$0-ready** |
| ME2 | F4/F5 tank + **male gym shorts (GAP)** + F29 | $0+B (shorts from the F13 Blender file) |
| ME3 Female | F3 Crop Top + F17 Shorts + F20 | **$0-ready** |
| ME4 Female | F6 Marilla Top + F13 + F22 | **$0-ready** |
| ME5 | F8 Crew Neck tee (Personal tier) + male shorts + F22 | $0+B |
| ME6 | F9 Raglan (CC-BY, refit) + F13 + F28 FlipFlops (changing room) | $0+B (raglan skinning), or swap F9 for N1 = $0-ready |

### Walk-in customers

| Look | Garments | Status |
|---|---|---|
| CU1 | N1 long-sleeve tee + F12 + F23 Boots | **$0-ready** |
| CU2 | F1 V-neck + F15/F12 + F26 Oxfords | **$0-ready** (with F12) |
| CU3 Female | F7 Blouse + F16 + F24 | **$0-ready** |
| CU4 Female | F6 top + F14 or F16 + F27 | **$0-ready** |
| CU5 Jacket | **outer jacket (GAP)**: C1/C2 if confirmed free, else K11 hoodie refit + F12 + F21 | $0+B, or $0-ready if C1/C2 are free on the day |
| CU6 | N2 tucked long-sleeve + F12 + F25 | **$0-ready** |

**Tally (JUDGEMENT): about 19 looks $0-ready, about 11 $0+B, 0 needing money.** Every gap has a no-money fallback, but realism of the boxing kit depends on our own Blender work.

### Gaps, cheapest no-money fallback, and hours (all JUDGEMENT)

| Gap | Fallback | Hours |
|---|---|---|
| **Boxer trunks** (BX1, BX2, BX4, BX5) | Model in Blender on the 4 Construction-Preset FBX bodies [S1]. Start from F18 Underpants / F13 waist shape, or retopo K7 (CC-BY) as a reference. Wide leg, waistband. Then make it a 4-size parametric outfit in UE (Chaos Cloth Panel Editor / Dataflow, Beta/Experimental per S208). Tint mask: body / waistband / side stripe. Logo decal on the leg. | 12-18 h first pair; recolours are free via the S207 tint |
| **Hand wraps** | A thin shell offset (about 2 mm) from the MH hand/wrist mesh, weights copied from the body (Blender Data Transfer), tileable cloth-tape texture. Or the cheapest version: a hand-skin texture overlay / decal on the body hand material (no new mesh). | 6-10 h shell; 2-3 h texture-only |
| **Boxing boots** | Short term: F21 Hightops tinted. Better: skin K6 (CC-BY, 4,612 faces) to the MH foot/calf bones. | 0 h (tint) / 4-6 h (K6) |
| **Gloves** | N3 (Personal $0) as a BoneAttachment3D on hand_l/hand_r (mirror for the left). K3/K4 for variety. | 1-2 h each |
| **Headgear** | K1 as a BoneAttachment3D on head. Hide hair cards under it. Decimate to about 6-8k faces. | 2-3 h |
| **Male gym shorts** | Cut F13 Sweatpants at mid-thigh in its supplied Blender file (modifying is allowed under the Fab Standard summary [S8]), hem, re-UV. Use as rigged FBX, or rebuild as parametric. | 4-6 h |
| **Tracksuit / zip top** | Refit K12 (CC-BY, 16,977 faces), after checking for logos. Or model on the N1 long-sleeve topology plus a zip and collar. Tint mask: body / sleeve stripe / zip. | 10-16 h |
| **Hoodie** (BX3, CU5 option) | K10 or K11 refit (25,946 / 10,542 faces), weight transfer to the MH body, hood as a rigid-ish part. | 8-12 h |
| **Coach polo** | F10 (CC-BY) refit and skin. Or the N2 tucked tee plus a collar mesh added in Blender. | 6-10 h |
| **Focus mitts** | Simple static mesh (lofted pad + strap) in Blender, BoneAttachment3D. | 3-5 h |
| **Outer jacket (CU5)** | C1/C2 if CGTrader shows $0 on the day. Else the hoodie fallback. | 0-12 h |
| Blender cloth sim (optional) | Blender's free cloth sim can bake drape for static rest shapes, e.g. trunks folds, before sculpting. It is not runtime. | +2-4 h per garment |

Totals (all JUDGEMENT):
- New or refitted garments: about **52-98 h** (trunks 12-18, wraps 6-10, boots 4-6, gloves 2-4, headgear 2-3, shorts 4-6, zip top 10-16, hoodie 8-12, polo 6-10, mitts 3-5, plus 0-8 for sim/fixes). Round to **70-120 h with QA and parametric conversion**.
- Per-look assembly / export / Godot setup: **30 x 1.5-2.5 h = 45-75 h** (unchanged from S208).
- Pipeline proof (corrective bones, hair cards, body masking): **8-16 h** (from S208).
- **Grand total: about 125-210 h. Cash: $0.** The trade-off is about 70-120 extra hours versus the paid S208 route.

Rules for staying at $0 (JUDGEMENT):
1. Claim every "$0/$X" Fab item now under the Personal tier: F8, F13, N3. Personal is only allowed under $100k at the time of claim [S9].
2. Keep a `CREDITS_CC_BY.md` listing the author, title and URL of every CC-BY item (F9, F10, F19, F30-F34, K1-K12).
3. Ship CGTrader items only inside the Godot .pck (encrypted if possible) [S17][S18].
4. Never feed NoAI items, or renders of them, to AI tools [S1][S5-S7].
5. Do not use the MD trial for shipped garments [S19].

---

## 6. Limits

- Fab "Shirts" free was read **one page only**. The API returned `cursors.next = "bz0yNA=="` and the response was cut off after about 20 items. More free shirts likely exist. NOT FOUND beyond page 1. Pants and Shoes free were complete (`next: null`).
- I did **not** run per-keyword `is_free=1` Fab API queries for hoodie / tracksuit / polo / jacket / headgear / hand wrap / boxing. These came from a web-search sweep plus the category pages. A dedicated API pass could find more. NOT FOUND, not proven absent.
- Per-item polycounts are mostly NOT FOUND. Fab's `polygonsCountRange` is a bucket (e.g. 0-1), not a count. Only seller text (F1, F2, F6, C1, F35) and Sketchfab `faceCount` give numbers.
- Whether each item ships with a body occlusion mask is NOT FOUND for most items.
- Per-listing `isAiForbidden` was checked only for 3c0c4df1, N1, N2 and N3. Others: NOT FOUND (the search API does not expose it).
- Fab's own CC-BY licence wording was not opened. NOT FOUND. Treated as standard CC BY.
- CGTrader pages are bot-blocked. Free status of C1/C2 is contradictory and C3's rig is unknown.
- OF Studio's licence has no formal text. Excluded until clarified.
- Free-item prices and free status can change at any time. Re-check on claim day.
- Quality was judged from titles, tags and seller specs. Nothing was downloaded or test-fitted. The fit hours are estimates.

---

## 7. Sources (all accessed 2026-10-12)

- [S1] Fab listing JSON, "MetaHuman Clothing Construction Presets, Set of 4": https://www.fab.com/i/listings/3c0c4df1-ce96-44cf-8a30-c47d744d2a0c (page: https://www.fab.com/listings/3c0c4df1-ce96-44cf-8a30-c47d744d2a0c). First published 2025-06-03, updated 2025-11-12.
- [S2] Fab search API, Shirts, free: https://www.fab.com/i/listings/search?categories=clothing-accessories--clothing--shirts&is_free=1&count=30&listing_types=3d-model (category page: https://www.fab.com/category/3d-model/clothing-accessories--clothing--shirts?is_free=1)
- [S3] Fab search API, Pants, free: https://www.fab.com/i/listings/search?categories=clothing-accessories--clothing--pants&is_free=1&count=24&listing_types=3d-model (category page: https://www.fab.com/category/3d-model/clothing-accessories--clothing--pants?is_free=1)
- [S4] Fab search API, Shoes, free: https://www.fab.com/i/listings/search?categories=clothing-accessories--clothing--shoes&is_free=1&count=24&listing_types=3d-model (category page: https://www.fab.com/category/3d-model/clothing-accessories--clothing--shoes?is_free=1)
- [S5] Fab listing JSON, MetaHuman T Shirt Variants: https://www.fab.com/i/listings/1b1009ae-4327-4c9d-9567-9314d88e7a86. Published 2026-04-07.
- [S6] Fab listing JSON, MetaHuman Tucked T Shirt Variants: https://www.fab.com/i/listings/839b9239-5ea4-40a0-90b3-076e0d9959f7. Published 2026-04-07.
- [S7] Fab listing JSON, Boxing Glove (Pedro Perin): https://www.fab.com/i/listings/b9bc411a-193b-4965-bb8b-535882bb4614. Published 2024-10-27.
- [S8] Fab Standard License summary: https://www.fab.com/eula (quoted via J_CLOTHES2_S208 [S4]). Page date not shown.
- [S9] Fab Personal-tier clause, quoted by Epic staff on the Unreal Engine forums (thread id 2656575, via J_CLOTHES2_S208 [S5]): https://forums.unrealengine.com/t/2656575
- [S10] MetaHuman licence + FAQ: https://www.metahuman.com/license (via S208 [S1])
- [S11] Unreal Engine EULA: https://www.unrealengine.com/en-US/eula/unreal (via S208 [S2])
- [S12] Sketchfab Data API v3 search, `downloadable=true`, `license=cc0|by`, queries: boxing headgear, boxing gloves, hand wraps, boxing shorts, boxing trunks, boxing shoes, tracksuit, hoodie, polo shirt, focus mitts, metahuman clothing: https://api.sketchfab.com/v3/search?type=models&downloadable=true&license=by&q=...
- [S13] CGTrader, Streetwear Parametric Outfit 01 (search snippet; page bot-blocked): https://www.cgtrader.com/free-3d-models/character/clothing/streetwear-parametric-outfit-01-fully-rigged-to-metahuman
- [S14] CGTrader, Streetwear Parametric Outfit 12 (search snippet): https://www.cgtrader.com/free-3d-models/character/clothing/streetwear-parametric-outfit-12-fully-rigged-to-metahuman
- [S15] CGTrader MetaHuman category (snippet with prices; the requested free + clothing view returned a JS bot wall): https://www.cgtrader.com/3d-models/metahuman and https://www.cgtrader.com/3d-models/metahuman?free=1&suggested_keywords=clothing
- [S16] CGTrader, Soccer Outfit Kit 01 (search snippet): https://www.cgtrader.com/free-3d-models/character/clothing/soccer-outfit-kit-01
- [S17] CGTrader Help Center, Royalty Free License: https://help.cgtrader.com/hc/en-us/articles/360015124437-Royalty-Free-License
- [S18] CGTrader General Terms and Conditions, s.21A: https://www.cgtrader.com/pages/terms-and-conditions
- [S19] CLO / Marvelous Designer additional terms (trial clauses): https://legal.clo-set.com/additional-md
- [S20] Blender licence page: https://www.blender.org/about/license/
- [S21] Fab, 【FREE】 Men's Boxer Briefs - Low Poly (search snippet): https://www.fab.com/listings/57498a65-da61-47e7-83ca-bcdf3acc767f. Published 2026-01-22.
- [S22] OF Studio free MetaHuman clothes: https://3d-clothes-metahuman-outfit.com/
- [S23] Marvelous Designer support, Personal vs Enterprise (search summary): https://support.marvelousdesigner.com/hc/en-us/articles/47358297616153-What-is-the-difference-between-Personal-and-Enterprise-License
- [S24] Fab search snippets: Urban Casual Outfit https://www.fab.com/listings/663af53d-de96-4af1-99b4-378acc7662a3 ; Shorts - 2 (Husky Studio) https://www.fab.com/listings/9e160eaa-cd5e-4a54-a9fe-7d7ad76e68be
- [S25] rigmodels.com MMA Shorts: https://rigmodels.com/model.php?view=MMA_Shorts-3d-model__32fed96f86554da08c75b67009f0b630
- Internal: J_CLOTHES_S207 (sec 3, Godot swapping/tint/decal), J_CLOTHES2_S208 (licence, pipeline, LOD, skeleton), /workspace/jclothes2/J_CLOTHES2_S208.md

---
John's closing note: That's the whole J_CLOTHES3_S209 document, ready for Claude to save as `research/J_CLOTHES3_S209.md`. One thing I couldn't settle: CGTrader's free MetaHuman list was behind a bot check. Its two Paradoox streetwear outfits show up on free links but at paid prices elsewhere, so someone needs to look at them on the day before downloading.
