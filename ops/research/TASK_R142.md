# TASK R142 - CLAUDE - THE UNITY SALE SHORTLIST: WHAT TO BUY, WHAT TO COMBINE, AND WHAT EXACTLY WE WOULD USE

Model: Opus, **medium effort**, Fast OFF. Owner: claude. Research session - store pages, the
records below and three free downloads. No engine work.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GATE AT ALL.** `git status -s` before staging is the
whole check.

**Deadline: the Unity Asset Store sale opens 2026-09-14.** The buy list must exist before the
operator decides what to buy in it.

## The operator's request (2026-09-13, in chat)

Evaluate 25 Unity Asset Store packages: **should we buy them, or combine some, and keep a
record of the search - what exactly we might need from each package when we build the
animation, the gym, the equipment and so on, if anything.** Three are free, already added to
the operator's Unity account, and the operator asked for them to be downloaded.

## Owned files

- `research/R142_ASSET_STORE_SHORTLIST.md` - NEW: the verdict table, then one section per package.
- `research/R142_asset_shortlist.json` - NEW: the machine-readable record, one row per package.
- The three free `.unitypackage` files, extracted WITHOUT importing, under the session scratchpad
  until `research/C45_ASSET_IMPORT_POLICY.md` says where a licensed asset may live.

## READ THE RECORD FIRST - several of these are already bought, evaluated or ruled on

Grep before calling anything unevaluated (`grep -rn -i '<package id or name>' research HANDOFF.md HANDOFF_ARCHIVE.md AgentComms/roadmap.json`).

| package | on record |
|---|---|
| Full Mount Attacks (227372) | **OWNED** - bought on Unity, EUR 10.11, 32 paired grappling clips, audited in R106 |
| Martial Arts Master (311647) | **EVALUATED** - `R105_MARTIAL_ARTS_MASTER.md`: RamsterZ, EUR 45.99, 212 clips, UE4 Mannequin rig |
| MMA Fight Actions (271650) | auditioned - `U46_MOTIFECT_AUDITION.md`, `C75_ANIMATION_SOURCES.md`; roadmap: "the ~US$60 MMA pack (auditioned, passed over)" - confirm it is this one |
| Boxing Actions (271834) | mentioned in `HANDOFF_ARCHIVE.md` - read it |
| Combat Animations - Karate (206861), Kung Fu pack (291335) | mentioned in `Q50_GI_AND_KIT.md` / `C75_ANIMATION_SOURCES.md` |
| Muay Thai AnimSet Pro (107262) | `TASK_J23.md` (John, muay thai pack pricing) was SENT AND NEVER ANSWERED - check it names this pack; this task answers it |
| 20 Fighters (not in this list) | the one body pack the roadmap already calls worth buying - it closes R111's gi gap |

**Standing rulings - do not re-ask them** (`AgentComms/roadmap.json` handover: `purchased_assets`,
`animation_purchases_ON_HOLD`, `judo_pack_decision`):

- **ANIMATION PURCHASES ARE ON HOLD.** The operator watched the retargeted RamsterZ clips and said they
  look "pretty bad". Hold every animation purchase until S4a diagnoses WHY - more clips through the
  same retarget buy the same problem. An animation pack can still be recommended, but only as "buy at
  the sale price IF S4a clears the retarget", with the saving stated; bodies, props, environments and
  UI are not under the hold.
- **Buy on Unity, never direct or on FAB**: the Standard Unity Asset Store EULA has no AI clause; the
  RamsterZ direct EULA and FAB ("Allows usage with AI: No") do. Never pass a RamsterZ clip to any
  generator.
- Ruled out: motion matching, an IK foot-plant system, text-to-motion (G58), the Dodge/Evade pack.
- Unity is needed ONLY to FETCH a package: install/open the Editor, download from My Assets in the
  Package Manager, take the `.unitypackage` from `%APPDATA%\Unity\Asset Store-5.x\<publisher>\`, and read
  it as the gzipped tar it is (HANDOFF R105/R106). Unity Hub and Editor 6000.6.0f1 are installed.

## The packages (25 - the operator listed Fighting Motions Vol. 1 twice)

**Animation**
1. Muay Thai AnimSet Pro - https://assetstore.unity.com/packages/3d/animations/muay-thai-animset-pro-107262
2. Taido Style Fight Animations - https://assetstore.unity.com/packages/3d/animations/taido-style-fight-animations-388942
3. Kung Fu Martial Arts Fighting Style Pack - https://assetstore.unity.com/packages/3d/animations/kung-fu-martial-arts-fighting-style-pack-291335
4. Acrobatic Kick Animations Part 1 - https://assetstore.unity.com/packages/3d/animations/acrobatic-kick-animations-part-1-329672
5. Martial Arts Master - https://assetstore.unity.com/packages/3d/animations/martial-arts-master-311647 (R105)
6. **FREE, in the operator's account:** Fighting Motions Vol. 1 - https://assetstore.unity.com/packages/3d/animations/fighting-motions-vol-1-76699
7. Martial Arts Karate Sidekick Motion Product - https://assetstore.unity.com/packages/3d/characters/humanoids/humans/martial-arts-karate-sidekick-motion-product-266149
8. Martial Arts Wing Chun Sidekick Motion Product - https://assetstore.unity.com/packages/3d/animations/martial-arts-wing-chun-sidekick-motion-product-276036
9. Combat Animations - Karate - https://assetstore.unity.com/packages/3d/animations/combat-animations-karate-206861
10. Full Mount Attacks - https://assetstore.unity.com/packages/3d/animations/full-mount-attacks-227372 (OWNED)
11. MMA Fight Actions - https://assetstore.unity.com/packages/3d/animations/mma-fight-actions-271650
12. Boxing Actions - https://assetstore.unity.com/packages/3d/animations/boxing-actions-271834

**Arenas, dojo and fighters**
13. Combat Arenas & Fighter Characters Pack - https://assetstore.unity.com/packages/3d/environments/combat-arenas-fighter-characters-pack-396548
14. Octagon Fighting Ring and Show Arena - https://assetstore.unity.com/packages/3d/environments/octagon-fighting-ring-and-show-arena-209412
15. Boxing Arena Fighting Show - https://assetstore.unity.com/packages/3d/environments/boxing-arena-fighting-show-213484
16. Martial Arts Dojo - https://assetstore.unity.com/packages/3d/props/interior/martial-arts-dojo-283861

**The gym and its equipment**
17. Fitness Hall Interior and Props - https://assetstore.unity.com/packages/3d/props/interior/fitness-hall-interior-and-props-142273
18. Fitness Hall Sports Equipment - https://assetstore.unity.com/packages/3d/props/interior/fitness-hall-sports-equipment-127334
19. **FREE, in the operator's account:** Low Poly Old School Gym Equipment - https://assetstore.unity.com/packages/3d/props/interior/low-poly-old-school-gym-equipment-313032
20. VIP Gym Bundle (160 rigged models, complete scene) - https://assetstore.unity.com/packages/3d/environments/vip-gym-bundle-160-rigged-models-complete-scene-298461
21. HQ Gym Interior - https://assetstore.unity.com/packages/3d/environments/hq-gym-interior-302207
22. Package 303410 (the URL carries no name - find it) - https://assetstore.unity.com/packages/package/303410
23. Gym Fitness Club 3D Environment Realistic Interior Pack - https://assetstore.unity.com/packages/3d/environments/gym-fitness-club-3d-environment-realistic-interior-pack-for-unit-330607

**UI**
24. **FREE, in the operator's account:** 3D Modern Menu UI - https://assetstore.unity.com/packages/tools/gui/3d-modern-menu-ui-116144
25. Modern Menus (Synty Interface GUI) - https://assetstore.unity.com/packages/2d/gui/modern-menus-synty-interface-gui-371178

## For every package, record

- **Identity and price:** publisher, list price in EUR and the sale price if announced, size, Unity
  version, render pipeline (Built-in / URP / HDRP), last update.
- **Licence:** Standard Unity Asset Store EULA or extra terms; any AI clause; seats.
- **What is in it, from the package's own file list** (the store's "Package content" tab), not the
  marketing copy - clip names and counts, rig (Humanoid / Generic / UE4 Mannequin / Mixamo), root
  motion, paired or solo; mesh counts, polycounts, texture sizes, LODs.
- **What exactly WE would use, named:** clips against our catalogue technique ids and receiver roles
  (react_head, react_body, react_leg, block, slip, knockdown, idle), locomotion (C94), paired grappling,
  grounded kicks (every H2H kick we own is a FLYING kick - R111); gym rooms and equipment for the gym
  screens and the title room (`BootStage3D`); arenas per ruleset (`arena_profile` in
  `combat_rulesets.json`: ring, cage, tatami, dojo); a gi, belts and kit (R111, Q50); menu art against
  `UIKit` - the R18 profile renders are the only approved visual bar and legacy scenes are rebuilt
  from the kit, so a menu pack is reference or parts, not a replacement.
- **What it costs to bring into Godot 4.7 (Forward+):** FBX meshes and textures carry over; Unity
  `.mat`, `.prefab`, `.unity` scenes, URP/HDRP shaders and baked lighting do NOT. Count the rebuild.
- **Overlaps:** with what we own (RamsterZ Hand to Hand Set and Full Mount Attacks, the boot-stage
  fighters) and with the other 24.
- **Verdict:** BUY AT SALE / BUY AT SALE IF S4a CLEARS THE RETARGET / COMBINE WITH <id> / SKIP /
  OWNED / FREE - DOWNLOADED - with the reason, the saving and what it would replace.

Then the combinations: **one arena set, one gym interior, one equipment set** rather than three of
each - say which pairs share a style, scale and pipeline well enough to sit in one scene.

JSON row: `{"id": 107262, "name": "...", "url": "...", "category": "animation|arena|gym|equipment|ui|characters",
"publisher": "...", "price_eur": 0.0, "sale_price_eur": null, "licence": "...", "pipeline": "...",
"rig": "...", "contents": "...", "we_would_use": ["..."], "godot_cost": "...", "overlaps": [..ids..],
"on_record": "...", "verdict": "...", "reason": "..."}`

## The three free downloads

The operator asked for them in chat on 2026-09-13 (in the session before this one). A download is
still a download: confirm the three (name, publisher, size) with the operator in THIS session before
fetching, then fetch through the Editor's Package Manager (My Assets). If the session cannot drive
the Editor, ask the operator to press Download on the three - the files land in
`%APPDATA%\Unity\Asset Store-5.x\`. Extract without importing, list what is inside, and put the real
contents - not the store copy - into their rows.

## Method

Store pages render with JavaScript; if a fetch returns an empty shell, use the in-app browser
(`mcp__Claude_Browser__*`) on the "Package content" tab. Decline non-essential cookies. Enter no
credentials. Record every figure with where it was read. Spend no grokbot credits (John, Kalli,
Maria) without the operator's say-so; Grok's weekly Expert query resets 2026-09-14 13:42.

## Done

- Both files committed with their paths on the commit line; HANDOFF block (max 8 lines) above
  `## Direction notes`; `agent_comms.py tasks --write`; push.
- The report to the operator is the buy list: package, sale price, verdict, one line of why -
  animation rows marked against the hold.
- Then S2 (`AgentComms/roadmap.json` next).
