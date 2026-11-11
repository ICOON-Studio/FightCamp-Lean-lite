# Licence check: Fab "Boxing Animation Pack" and Unity "Punch Perfect" (S434)

Read 2026-11-11. Sources read directly (primary text, not summaries):
- Fab listing data: `https://www.fab.com/i/listings/6cc14b2c-2383-45bf-a8f4-6f890b76487d` (the JSON the listing page
  https://www.fab.com/listings/6cc14b2c-2383-45bf-a8f4-6f890b76487d renders its licence selector from).
- Fab licence summary: https://www.fab.com/eula (top of page).
- Fab EULA full binding text: `https://www.fab.com/i/eula/fab_eula` (the body https://www.fab.com/eula loads; "Last updated:
  October 1st, 2024", version 1).
- Fab licence list: `https://www.fab.com/i/taxonomy/licenses`.
- Epic docs: https://dev.epicgames.com/documentation/en-us/fab/licenses-and-pricing-in-fab
- Unity Asset Store page: https://assetstore.unity.com/packages/tools/game-toolkits/punch-perfect-boxing-animations-tools-311942
  (linked from https://thenewgamestudio.com/asset/punch-perfect).
- Unity Asset Store Terms + EULA (Appendix 1): https://unity.com/legal/as-terms ("Last updated: December 4, 2024").
- Unity support: https://support.unity.com/hc/en-us/articles/34387186019988-Can-I-use-assets-from-the-Asset-Store-with-other-engines
- Unity EULA FAQ: https://assetstore.unity.com/browse/eula-faq

This is a plain reading of the contract text for the owner, not legal advice.

## Short answer

| Question | Fab "Boxing Animation Pack" (animo-mocap) | Unity "Punch Perfect" (New Game Studio) |
|---|---|---|
| Licence offered | Fab **Standard License**, tiers **Personal EUR 58.18** / **Professional EUR 76.09** (no CC, not the legacy UE Marketplace licence) | **Standard Unity Asset Store EULA**, licence type **Extension Asset**, EUR 55.16 per seat |
| Use in a Godot game sold on Steam | **Yes** | **Yes** |
| "Unreal only" limit | **None** in the current Fab EULA; the summary says the opposite. The old "UE-Only Content" flag belonged to the legacy UE Marketplace licence, which this listing does not use | No engine limit; Unity's own support page says so |
| Retarget / modify | **Yes** (3(a) "modify") | **Yes** (2.2.1(e), section 6) |
| Seats | **None** for content (seats apply only to code plugins, 2(e)) | **Yes: one seat = one person, max 2 computers** (2.3.2); build/CI machines exempt; a contractor needs its own seat |
| Personal vs Professional | Same rights; Personal only if the buyer + controlling/sister companies made <= $100,000 in the digital content industry in the last 12 months, **advances and funds raised count** | n/a (single-entity vs multi-entity tiers only) |
| Shipped game files | Only incorporated in the game, in object code, and **end users must be restricted from extracting** the clips | Only "incorporated and embedded" in the game; no standalone sharing |
| AI | Listing is tagged **NoAI** (`isAiForbidden: true`): never as training/dataset input to generative AI | Never for AI/ML training or as model input without consent (2.2.1.1(g)) |

Both are legally usable for FightCamp. The main risks are about how we handle the files, not the engine: never put them in a
public repo (the Arena mirror ICOON-Studio/FightCamp-lite is PUBLIC), keep them inside the exported .pck (no loose FBX in
the build), and never feed them to a generative or motion-AI model.

## 1. Fab listing: which licences it offers

Listing JSON (`/i/listings/6cc14b2c-...`): title "Boxing Animation Pack", seller `animo-mocap`, `listingType: "animation"`,
first published 2022-10-21, `isAiForbidden: true`, `isAiGenerated: false`. Licences:
- `"name": "Personal"`, `"group": "standard"`, price EUR 58.18, uid `eec3bdd5-...-67462b9630f6`
- `"name": "Professional"`, `"group": "standard"`, price EUR 76.09, uid `eec3bdd5-...-67462b9630f9`

Fab's licence list (`/i/taxonomy/licenses`) maps those two uids to **"Standard License"** (url `/eula`). The other licences
Fab has, "UE Marketplace License" (`legacy-uem`), "UEFN - Reference only" and "CC-BY", are **not** offered on this listing.
Formats: `unreal-engine`, `fbx`, `converted-files` (gltf, glb, usdz), `unity` (unitypackage). The FBX is the source we would
import into Godot.

Content (description): 67 mocap clips, humanoid: guards (basic, high, Philly shell...), footwork and walk/run in 4
directions, jab/cross/hooks/uppercuts head and body, stepping punches, 8 combos, parries, slips, pull back, bob and weave,
push back. **No hit reactions, knockdowns or clinch** in the list, so it does not cover our weakest area (reactions/contact)
on its own.

## 2. Fab EULA: the exact lines

### Engine: no Unreal-only limit
- Summary, https://www.fab.com/eula: "Use the assets with any compatible tools (usage is not limited to Unreal Engine)".
  The page notes the summary "is not legally binding" and the full EULA is.
- Full EULA (`/i/eula/fab_eula`, 2024-10-01): the words "UE-Only" do not appear. Unreal is named only for **code plugins**,
  5(b): "for Unreal Engine Plugins any Projects you incorporate Plugins into may only be Distributed as Engine Tools under the
  Unreal Engine Agreement." An animation pack is Content, not a Plugin, so that line does not apply.
- 2(d) on formats: "Source assets are files that contain full copies of the Content in Unreal Engine format and possibly
  other formats (as listed), which can be modified and incorporated into your projects." This listing lists FBX, glTF/GLB,
  Unity.
- Background: the "UE-Only Content" flag (content allowed only with Unreal Engine) was part of the older Epic / UE
  Marketplace content licence. Fab still lists a "UE Marketplace License (legacy-uem)" for some old products. This listing
  is sold under the Standard License, so that flag does not apply. (Community sources only for the old clause; Epic's old
  page https://www.unrealengine.com/en-US/eula/content returned 403 to us.)

### Personal vs Professional, seats
- 2(a): "You are only eligible for a Personal - Reference Only tier or Personal tier if, at the time of the Transaction you,
  together with any controlling entity and other entities under common control with you, have not generated more than
  $100,000 USD in gross revenue from your commercial activity in the digital content industry in the last 12 months. For
  purposes of this calculation, revenue includes any advances received or other funds raised."
- 2(a): "If you complete a Transaction for a License Tier you were not eligible for at the time of purchase, you must, upon
  request, pay Epic the remainder of what you would have owed..."
- Summary: "Both pricing tiers (Personal and Professional) grant you the same scope of rights." and "There is no need for
  upgrading from Personal to Professional tier if you cross the revenue threshold after the purchase".
- Seats: only 2(e): "Code plugins ... ("Plugins"), are offered to you on a per-seat basis and may only be used by the number
  of users that you have purchased licenses for." Content (animations) has **no seat limit**.

Owner's call (money): Personal fits a tiny studio, but "advances received or other funds raised" count toward the $100,000,
and so does any controlling company. If unsure, Professional costs EUR 17.91 more and removes the question.

### Modify and retarget
- 3(a): "A "Standard License" grants you a non-exclusive and non-transferable license to privately use, reproduce, display,
  perform, and modify the Content in accordance with the terms of this Agreement."
- Summary: "Modify and adjust the assets in order to incorporate them into your Projects".
- Retargeting onto MetaHuman, trimming, blending, re-timing are modifications: allowed.
- 6(b)(i) forbids trying to "reverse engineer, decompile, translate, disassemble, or derive source code or data from the
  Content". Importing the supplied FBX into Godot is ordinary use of a format the seller supplies, not reverse engineering.

### Shipping it inside the game (Steam)
- 4(c): "you may Distribute a Project that incorporates Content as an included dependency to end users. When you make such a
  Distribution, you may, however, only authorize end users to make use of Content solely as incorporated in the Project in
  object code and you must restrict end users from extracting or otherwise using Content outside of the Project." and "This
  means, for example, you may Distribute software applications (such as video games) that include Content to the general
  public, whether directly by you or through a distributor or publisher."
- 6(b)(ii): no selling "on a "stand-alone basis" (this means, for example, Projects you Distribute must reasonably add value
  beyond the value of the Content and the Content must be merely a component of the Project and not the primary focus of the
  Project)". A gym management game clears this.
- 6(b)(iii): may not "allow any third party to incorporate Content into their own products ... (this means, for example,
  that you may not make Content available in world- or level-editing tools or templates or other modeling tools that allow
  works to be exported)". Matters only if FightCamp ever ships mod or export tools.
- 4(c) also allows the clips in trailers and Steam store videos ("use the Content as incorporated into the Project in
  promotional materials featuring the Project"); 4(b) lets rendered video and images be shared freely.
- No credit required (summary: "You are not required to give credit to the publisher").

What "restrict end users from extracting" means for Godot (developer decision, my reading): ship only the imported Godot
animation resources inside the exported .pck (never the raw FBX/GLB as loose files), and put an "no extracting game assets"
line in the game's EULA / Steam terms. Godot's optional .pck encryption (custom export templates with an encryption key) is
a stronger step if the owner wants it; it is not named in the EULA.

### Sharing with the team and agents
- 5(a): "you may not Distribute Content on a standalone basis to third parties except to your collaborators (either directly
  or through a third-party repository) who are utilizing the Content in good faith to develop a Project with you or on your
  behalf. This means, for example, that you may share Content with your employees, affiliates, and contractors in a private
  online repository while you work on a Project together."
- So: the PRIVATE repo ICOON-Studio/FightCamp-Lean is fine. The PUBLIC mirror ICOON-Studio/FightCamp-lite (Arena) and any
  public GitHub, Miro, review page or chat upload of the raw files is **not**. Clips must stay out of the lite mirror push.

### Incompatible licences
- 6(a): no combining with content under a licence that would force the Content under other terms, "for example ... GNU
  General Public License (GPL), Lesser GPL (LGPL) (unless you are merely dynamically linking a shared library), or Creative
  Commons Attribution-ShareAlike License." Godot itself is MIT: no conflict. Check before mixing in any CC-BY-SA mocap.

### AI
- Listing: `isAiForbidden: true` = "NoAI Content".
- 6(b)(vii) and 16(l)(i): "you may not use NoAI Content (a) in datasets utilized by Generative AI Programs, (b) in the
  development of Generative AI Programs, or (c) as training inputs to Generative AI Programs." Exempt are programs that
  "(a) solely operate on the original content; (b) generate tags to classify visual input content; or (c) generate
  instructions to arrange existing content, without creating new content."
- For us: retargeting, blending and having a judge watch our rendered fight are fine. Feeding the raw clips to a motion
  generator or to train/fine-tune any model is not.

### Later EULA changes
- 7(a): "Any Content you acquired (whether free or paid) prior to the modified terms will remain governed by the license terms
  applicable at the time when you acquired the Content." Keep a copy of the purchase receipt and the date.

## 3. Unity Asset Store: "Punch Perfect: Boxing Animations & Tools"

Store page (https://assetstore.unity.com/packages/tools/game-toolkits/punch-perfect-boxing-animations-tools-311942):
publisher New Game Studio, EUR 55.16, "Seats", "License agreement: Standard Unity Asset Store EULA", "License type:
Extension Asset", 404.1 MB, version 1.1.0 (Sep 7, 2026), category Tools / Game Toolkits. It ships Unity scripts
(controller, targeting, behaviour tree) beside the animations; only the animation files would be of use to us, and the
clip list and formats were not readable without the page's scripts (not checked).

### Outside Unity: yes
- Unity support, https://support.unity.com/hc/en-us/articles/34387186019988-Can-I-use-assets-from-the-Asset-Store-with-other-engines
  (updated July 02, 2025): "Unity Asset Store assets are not restricted to Unity projects." and "You can use them with other
  engines provided you follow the EULA guidelines."
- EULA Appendix 1, 2.2.1(a), https://unity.com/legal/as-terms: the grant is "to incorporate the Asset, together with
  substantial, original content not obtained through the Unity Asset Store, into an electronic application or digital media
  that has a purpose, features, and functions beyond the display, performance, distribution, or use of Assets ("Licensed
  Product") as an embedded component of that Licensed Product, such that the Asset does not comprise a substantial portion of
  the Licensed Product". No engine named.

### Modify: yes
- 2.2.1(e): "modify the Assets in connection with (a), (b), (c), and (d)." Section 6: "END-USER may modify Assets."

### Seats: this one has them
- 2.3.2: "END-USER is granted a single seat license to install and use any Asset categorized in the Asset Store as an "Editor
  Extension" "Scripting", or "Services" (collectively, "Extension Asset") only on a maximum of 2 computers. For the avoidance
  of doubt, Extension Assets are licensed on a per seat basis and may not be shared or used concurrently on more than 2
  different computers. As an exception, build farm servers and virtual machine instances used only for running, testing, or
  building projects with Extension Assets do not require separate seat license(s)..."
- 2.4: "any Contractor working on a project for an END-USER must have license(s) to its own to the Asset".
- EULA FAQ: "you should buy and assign a seat for each person in your project where this asset is installed."
- For us: one seat covers the owner's PC (and one more computer). GitHub CI runners count as build machines. An outside
  contractor would need a seat. Because this is a per-seat licence, putting the files in a repo other people can clone is
  riskier than with Fab.

### Shipping and limits
- 2.2.1(b): "to reproduce, publicly display, publicly perform, transmit, and distribute the Asset as incorporated and embedded
  in that Licensed Product".
- 2.2.1.1(b): may not "enable a customer or user of a Licensed Product to sell, transfer, distribute, lease, or lend the
  Assets for commercial gain or commercialize Assets within a Licensed Product".
- 2.2.1.1(g): may not "use the Unity Asset Store or Assets for purposes such as training an artificial intelligence or
  machine learning model without the express consent from the Provider and/or Unity ... or as inputs for artificial
  intelligence or machine learning model programs". "As inputs" is wider than Fab's wording: do not pass these files
  through any AI or ML tool at all without written consent.
- 2.2.1.1(e): an SDK may not be modified or shipped at runtime without the publisher's permission. Punch Perfect's scripts are
  Unity C#; we would not use them.

## 4. What this means for the build

1. Both packs may be bought, retargeted onto our MetaHumans in Godot, and shipped in a Steam game. No Unreal or Unity
   engine lock.
2. Fab pack: Personal tier, unless the studio or its owner company made more than $100k in the last 12 months (advances and
   funds raised count). No seats. It does not include hit reactions or knockdowns.
3. Punch Perfect: one seat per person, max 2 computers; be careful with any per-seat file in shared clones; no AI tools on
   these files at all.
4. Handling rules for any bought clip: private repo only (never the FightCamp-lite mirror, never public pages); only
   imported resources inside the .pck in builds; a no-extraction line in the game's EULA; the raw clip files never go to Gemini, Ludo or any
   generator as input; keep the receipt and the date of purchase. Gemini judging a rendered video of our own fight is fine
   for the Fab pack (16(l) exempts tools that only look at content and create nothing new). For Punch Perfect, Unity's "as
   inputs" wording is wide enough that even that is unclear: ask the publisher in writing first, or keep its clips out of
   the AI-judged videos.
5. Buying is the owner's money decision. Nothing was bought, signed into or accepted for this check.
