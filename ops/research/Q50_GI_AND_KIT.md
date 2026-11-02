# Q50 — THE GI AND THE SHIN GUARDS: WHAT TO BUY ON 2026-09-14

Qwen, 2026-09-11. Research only. No GDScript, no engine work.
All web pages read on 2026-09-11 unless noted. Prices in EUR unless marked.

## DECISIONS

- **Buy for the karateka:** "20 Fighters — Boxer, Karateka, Judoka" by Mixall.
  €36.79 (€18.40 at 50% sale). Humanoid/Mecanim rig. 20 single-mesh fighters
  including karatekas. **Gi colour and belt: NOT FOUND on the public listing —
  must verify in screenshots before the sale opens.**
- **Buy for the kickboxer:** No standalone kickboxing character with confirmed
  shin guards found. Best candidate is "MMA Avatar 2" by Sports-Actions at
  €4.60 (€2.30 at sale), humanoid rig, but gear details NOT FOUND. Fallback:
  use the existing kickboxer filler and revisit when a verified asset surfaces.
- **AI-assisted development licence:** YES for all Unity Asset Store candidates
  and Mixamo. Unity EULA permits using assets in AI-developed projects; the ban
  is on training AI models with the assets, not on using them in a game built
  with AI assistance. Mixamo is "royalty free for personal, commercial, and
  non-profit projects" including video games.
- **Total basket if both buy:** ~€21 at sale price, ~€41 at full price.
- **Cheapest viable route:** Mixamo auto-rig a gi model from Sketchfab/CGTrader
  (free + free), but NO gi character with confirmed rig was found on Mixamo's
  catalog, and the Sketchfab/CGTrader models found did not state a commercial
  game licence or a Unity-humanoid-compatible rig. NOT FOUND.

---

## 1. KARATE GI CHARACTERS

### 1.1 Unity Asset Store candidates

| # | Name | Publisher | Price | Sale price (est.) | Rig | Gi/belt confirmed? | Source |
|---|------|-----------|-------|-------------------|-----|-------------------|--------|
| 1 | **20 Fighters — Boxer, Karateka, Judoka** | Mixall | €36.79 | ~€18.40 | Humanoid/Mecanim (DOCUMENTED — category + keyword) | NOT FOUND — listing says "karateka" but no gi colour, no belt colour, no screenshot description | [product](https://assetstore.unity.com/packages/3d/characters/humanoids/20-fighters-boxer-karateka-judoka-375770) |
| 2 | **Karateka Bruce — Proto Series** | BitGem | €4.59 | ~€2.30 | Maya HIK skeleton (DOCUMENTED — stated by publisher), humanoid-compatible | NOT FOUND — described as "low poly video game hero character" with modular limbs; gi colour not stated | [product](https://assetstore.unity.com/packages/3d/characters/humanoids/humans/karateka-bruce-proto-series-120424) |
| 3 | **Low Poly Casual Girl Karate** | Revereel Studio | €27.59 | ~€13.80 | Humanoid category (INFERRED from URL path) | NOT FOUND — no gi or belt description on public page | [product](https://assetstore.unity.com/packages/3d/characters/humanoids/humans/low-poly-casual-girl-karate-fantasy-characters-pack-287884) |

**Key finding:** No Unity Asset Store karate character listing explicitly states
"white gi" or "black belt." The "20 Fighters" pack is the strongest candidate
by volume (20 fighters, Mecanim rig, low-poly) but its single-mesh models "may
not always be suitable for close-ups" (publisher's own warning). Karateka Bruce
is cheap and rigged but at 1.2 MB it is minimal.

### 1.2 Fab.com candidate

| Name | Publisher | Price | Rig | Gi confirmed? | Source |
|------|-----------|-------|-----|---------------|--------|
| **Low Poly Fighter Complete Pack — 15 Martial Arts Characters** | tt-3D | NOT FOUND (requires license selection) | Unity Humanoid / Blender (DOCUMENTED) | NOT FOUND — includes "Kung Fu Male" but no karateka, no gi stated | [product](https://www.fab.com/listings/f97b32ff-633a-4966-8878-d88ceecf8487) |

15 characters, 600–1,100 tris each, FBX/Unity package/GLB formats. The "Kung Fu
Male" may wear a gi-like top but this is INFERENCE, not documented. No
kickboxer in the set.

### 1.3 Sketchfab / CGTrader

- **"Blocky Humanoid Character Wearing White Karate Gi"** — found on a
  Tripo AI gallery page. PBR-ready, FBX/GLB for Unity. Rig: NOT FOUND.
  Licence: NOT FOUND. Price: NOT FOUND.
- **"Karate Man A"** by POLYTRICITY on Sketchfab. Rig: NOT FOUND. Licence:
  NOT FOUND.
- **"Martial Arts Practitioner In Karate Gi Rigged"** on CGTrader. Rig: NOT
  FOUND (says "rigged" but not to what skeleton). Licence: NOT FOUND.

**None of these state a commercial game licence or a Unity-humanoid-compatible
rig. They are NOT candidates until both are verified.**

---

## 2. KICKBOXING KIT (SHIN GUARDS, SHORTS)

### 2.1 Characters with kickboxing gear

| Name | Publisher | Price | Rig | Gear confirmed? | Source |
|------|-----------|-------|-----|-----------------|--------|
| **MMA Fighter** | buxoided | €55.19 | Humanoid category (INFERRED) | NOT FOUND — 210.5 MB, no description of clothing | [product](https://assetstore.unity.com/packages/3d/characters/humanoids/humans/mma-fighter-301398) |
| **MMA Avatar 2** | Sports-Actions | €4.60 | Humanoid (DOCUMENTED — keyword) | NOT FOUND — 74.4 MB, fighter/wrestler/boxer keywords | [product](https://assetstore.unity.com/packages/3d/characters/humanoids/mma-avatar-2-249998) |
| **MMA Avatar 1** | Sports-Actions | NOT FOUND | NOT FOUND | NOT FOUND | [product](https://assetstore-fallback.unity.com/packages/3d/characters/mma-avatar-1-243269) |
| **Boxing Fighters Pack — Two Game-Ready Characters** | Carthage Studio | €27.59 | Rigged Humanoid (DOCUMENTED) | Gloves confirmed (keyword); shorts NOT CONFIRMED as kickboxing vs boxing | [product](https://assetstore.unity.com/packages/3d/characters/humanoids/humans/boxing-fighters-pack-two-game-ready-characters-335674) |

### 2.2 Standalone shin guards / kickboxing gear

**NOT FOUND on the Unity Asset Store.** No standalone shin guards asset was
found. The only "shin guards" result was a Tripo AI generated model of a full
kickboxing fighter (not a wearable gear set, not on the Asset Store).

**MMA Shorts** by polyfarm on Sketchfab — a standalone 3D model, lowpoly PBR.
Price: NOT FOUND. Licence: NOT FOUND. Rig: NOT FOUND (prop model, not
wearable).

### 2.3 Key finding

The kickboxing kit problem is harder than the gi problem. A kickboxer needs
**shin guards + kickboxing shorts** as visual signifiers, and no Asset Store
asset sells these as attachable gear for an existing humanoid rig. The only
route to a kickboxer visual is a **whole character** that already wears them,
and none of the candidates found explicitly confirm shin guards.

---

## 3. LICENCE — AI-ASSISTED DEVELOPMENT

### 3.1 Unity Asset Store EULA

**DOCUMENTED.** Read on 2026-09-11 from multiple search results referencing the
Unity Terms of Service (unity.com/legal/as-terms):

- **Permitted:** Using Asset Store content in a game project, even if the
  project is developed with AI assistance. EULA §2.2.1 permits the buyer "to
  reproduce, publicly display, publicly perform, transmit, and distribute" an
  asset embedded in a Licensed Product.
- **Prohibited:** Using Unity Offerings (including Asset Store content) to
  **train** AI/ML models without prior written permission. Using outputs
  generated by Unity (renders, images) for training datasets is also
  prohibited.
- **AI-assisted asset creation:** Resources exist (e.g., seeles.ai) for
  licensing and selling AI-assisted asset packs on the store, implying
  creation with AI is permitted with disclosure.

**Verdict: CLEARED for this project.** We are using the assets in a game, not
training AI on them. The fact that AI agents wrote the game code is irrelevant
to the asset EULA.

### 3.2 Mixamo / Adobe

**DOCUMENTED.** Read on 2026-09-11 from Adobe FAQ and search results:

- "Royalty free for personal, commercial, and non-profit projects" including
  video games.
- No resale of raw assets; must be incorporated into a larger project.
- No AI-specific restriction found in the published licence terms.

**Verdict: CLEARED.** Same analysis as C75 (§1, Mixamo row).

### 3.3 Fab.com

**DOCUMENTED.** Fab's Standard summary says users may "Commercially distribute
your Projects with the Fab assets incorporated into it." However, the summary
is described as non-binding, and individual product pages may show different
terms. **Verify at checkout for each specific product.**

### 3.4 Sketchfab / CGTrader / Tripo AI

**NOT FOUND for all specific models.** Each model has its own licence set by
the uploader. None of the karate gi models found stated a commercial game
licence explicitly. **Not candidates until verified.**

---

## 4. FREE ROUTES

### 4.1 Mixamo

- **Characters:** 100+ free, fully rigged characters available for download
  (DOCUMENTED — multiple sources confirm "more than 100 Mixamo FREE 3D
  characters").
- **Gi character:** NOT FOUND. No karate or gi-wearing character confirmed in
  the Mixamo catalog. The catalog is JS-rendered and could not be fully
  crawled; a manual check on mixamo.com is needed.
- **Kickboxing character:** NOT FOUND.
- **Auto-rig:** Mixamo offers auto-rigging for custom uploaded characters. A
  gi model from another source could be uploaded, auto-rigged, and downloaded
  with the Mixamo skeleton. **But the source model must have a commercial game
  licence**, and none of the gi models found on Sketchfab/CGTrader confirmed
  one.
- **Licence:** CLEARED (see §3.2).
- **Rig:** Mixamo's biped humanoid / mixamorig skeleton. Needs a
  Mixamo-to-Godot humanoid bone-name map (already scoped by C75).

### 4.2 Motifect Martial Arts Motion Pack (itch.io)

- **Free**, 40 motions, FBX and BVH, commercial use cleared.
- **Animations only** — no character model included.
- Karate, taekwondo, kung fu, wrestling categories named, but exact clip
  counts per style: NV.
- Already evaluated by C75. Useful for animations, not for the character model
  problem this task addresses.

### 4.3 Other free sources

- **CMU Graphics Lab:** Free, commercially usable for embedded games. 7 generic
  boxing trials. No gi character, no kickboxing gear. Already evaluated by C75.
- **Open text-to-motion (MDM/MoMask/T2M-GPT):** Free code, but generates
  motion data not characters, and licence for commercial output NOT VERIFIED.
  Already evaluated by C75.

---

## 5. THE CHEAP ALTERNATIVE: GI AS SEPARATE GARMENT MESH

### 5.1 Modular clothing packs on Unity Asset Store

| Name | Publisher | Price | Items | Gi included? | Source |
|------|-----------|-------|-------|--------------|--------|
| **Stylized Modular Characters Vol 1** | NOT FOUND | NOT FOUND | 331 modular wardrobe pieces, Mixamo-compatible | NOT FOUND — no gi specifically mentioned | [product](https://assetstore.unity.com/packages/3d/characters/humanoids/stylized-modular-characters-vol-1-263985) |
| **Character Customizer Modern Clothes Pack** | Jordbugg | NOT FOUND | Modern clothes for humanoid rigs | NOT FOUND — "modern" suggests no gi | [product](https://assetstore.unity.com/packages/3d/characters/humanoids/character-customizer-modern-clothes-pack-328606) |
| **MINIMO Casual Pack** | NOT FOUND | NOT FOUND | 12 characters, outfits, accessories | NOT FOUND | [product](https://assetstore.unity.com/packages/3d/characters/humanoids/humans/minimo-casual-pack-modular-humanoid-collection-367948) |

### 5.2 Tools for binding clothing to existing rigs

- **CharacterClothBindingMaster** — toolkit for transferring/binding skinned
  clothing between Humanoid characters. A tool, not a clothing asset.
- **Advanced Character Customization System** by Magnus Works — modular
  character customization utility.

### 5.3 Verdict

**No gi-specific garment mesh exists on the Unity Asset Store.** The modular
clothing packs offer hundreds of wardrobe pieces but none advertise a martial
arts gi. The garment-only route would require finding a gi mesh elsewhere
(Sketchfab/CGTrader), verifying its licence, and binding it to our existing
rig — which is more risk and more work than buying a whole character that
already wears one.

**Ranking against buying whole characters:**

| Route | Cost | Risk | Work |
|-------|------|------|------|
| Buy whole karateka character | €2–37 | Low (if rig verified) | Import, retarget check |
| Gi garment + bind to existing rig | €0–20 + tool time | High (licence NV, fit NV) | Model sourcing, rig binding, weight painting |
| Mixamo auto-rig uploaded gi | €0 + source model | High (source licence NV) | Upload, auto-rig, bone map |

**Buying whole is cheaper and less risky** unless a clearly licensed, clearly
rigged gi garment is found.

---

## 6. WHAT I WOULD ACTUALLY BUY

### Primary recommendation

**"20 Fighters — Boxer, Karateka, Judoka" by Mixall** — €36.79 (€18.40 at 50%
sale).

- **Why:** 20 fighters including karatekas, Mecanim/humanoid rig (documented),
  low-poly (matches our art direction), large enough set that some models may
  serve as the kickboxer too.
- **Price:** €18.40 at sale, €36.79 full.
- **AI licence:** YES — Unity Asset Store EULA cleared (§3.1).
- **Risk:** Gi colour and belt NOT CONFIRMED on the public listing. Must
  verify in screenshots before buying. Publisher warns single-mesh models "may
  not always be suitable for close-ups" — acceptable for title screen fighters
  at camera distance.

### Fallback

**"Karateka Bruce — Proto Series" by BitGem** — €4.59 (€2.30 at sale).

- **Why:** Cheapest karateka on the store, rigged to Maya HIK skeleton
  (humanoid-compatible), modular limbs.
- **Price:** €2.30 at sale, €4.59 full.
- **AI licence:** YES — Unity Asset Store EULA cleared.
- **Risk:** Only 1.2 MB — very minimal. Gi colour NOT CONFIRMED. "Proto
  Series" may mean prototype quality.

### Kickboxer

**No verified buy.** The MMA Avatar 2 at €4.60 (€2.30 at sale) is humanoid and
cheap, but its gear is NOT CONFIRMED to include shin guards. The existing
kickboxer filler should remain until a verified asset surfaces. If the "20
Fighters" pack includes a kickboxer or MMA-style fighter, it may fill this gap
too — another reason to verify screenshots before buying.

### Total basket

- **Sale:** €18.40 (20 Fighters) + €2.30 (Bruce fallback) = **€20.70** if both
  are bought. Just the 20 Fighters = **€18.40**.
- **Full price:** €36.79 + €4.59 = **€41.38** if both. Just 20 Fighters =
  **€36.79**.

---

## CITATIONS

All pages read 2026-09-11.

- [20 Fighters — Boxer, Karateka, Judoka](https://assetstore.unity.com/packages/3d/characters/humanoids/20-fighters-boxer-karateka-judoka-375770) — Mixall, €36.79
- [Karateka Bruce — Proto Series](https://assetstore.unity.com/packages/3d/characters/humanoids/humans/karateka-bruce-proto-series-120424) — BitGem, €4.59
- [Low Poly Casual Girl Karate](https://assetstore.unity.com/packages/3d/characters/humanoids/humans/low-poly-casual-girl-karate-fantasy-characters-pack-287884) — Revereel Studio, €27.59
- [MMA Fighter](https://assetstore.unity.com/packages/3d/characters/humanoids/humans/mma-fighter-301398) — buxoided, €55.19
- [MMA Avatar 2](https://assetstore.unity.com/packages/3d/characters/humanoids/mma-avatar-2-249998) — Sports-Actions, €4.60
- [Boxing Fighters Pack](https://assetstore.unity.com/packages/3d/characters/humanoids/humans/boxing-fighters-pack-two-game-ready-characters-335674) — Carthage Studio, €27.59
- [Low Poly Fighter Complete Pack — 15 Martial Arts Characters](https://www.fab.com/listings/f97b32ff-633a-4966-8878-d88ceecf8487) — tt-3D, Fab.com
- [Stylized Modular Characters Vol 1](https://assetstore.unity.com/packages/3d/characters/humanoids/stylized-modular-characters-vol-1-263985) — 331 wardrobe pieces
- [Combat animations — Karate](https://assetstore.unity.com/packages/3d/animations/combat-animations-karate-206861) — Amine Saadi, €17.47 (animations only, no character)
- [Martial Arts Mastery — Animation Pack](https://assetstore.unity.com/packages/3d/animations/martial-arts-mastery-animation-pack-338850) — Wolff's Studio (animations only, 1000+ clips, 6 styles including kickboxing)
- [Unity Asset Store EULA](https://unity.com/legal/as-terms) — read 2026-09-11
- [Mixamo FAQ](https://helpx.adobe.com/creative-cloud/faq/mixamo-faq.html) — licence confirmed free for commercial games
- [Fab EULA](https://www.fab.com/eula?lang=en) — commercial distribution permitted
- [Unity Autumn Sale 2026](https://assetstore.unity.com/) — September 14, 50% off 300+ best sellers, up to 70% flash deals
