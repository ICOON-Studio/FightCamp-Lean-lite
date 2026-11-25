# KICKART1 - where the kick, knee and elbow animations come from (S559, research only)

Brief: `ops/research/TASK_KICKART1.md`. Owner S559: "should we already start thinking on adding elbows and kicks ? but it has
to be done properly by art". Nothing was downloaded, signed into, bought or run in Godot. File names below were read from
directory listings only (Downloads, E:\FightCamp, E:\FightCamp_backup_D) and from the old repo's git tree
(`gh api repos/ICOON-Studio/FightCamp/git/trees/master?recursive=1`, 24,949 entries, not truncated).

## What we hold today (the short answer)
- **Lean repo: no kick, knee or elbow take** (`assets/anim/{baked,metahuman,rokoko_combat,af_retarget,entry}` listed; only
  punches, blocks, hits, locomotion, `clinch_att/clinch_vic.res`). Confirms the brief.
- **Mixamo kicks, knees and elbows are ALREADY DOWNLOADED** in `C:\Users\user\Downloads` (1,031 files; Mixamo's
  `Name__Description.fbx` export naming). The Lean game already plays Mixamo-skeleton FBX on the MetaHuman:
  `assets/anim/rokoko_combat/CREDITS.md` + `scripts/fight3d/RkRetarget.gd` / `RkClips.gd` ("builds each on the boxer's own
  MetaHuman skeleton at fight start"). So a Mixamo kick has a proven retarget path with no new tool.
- **Rokoko's free kicks** `Combat/RoundHouseKick_mixamo.fbx` and `Combat/BigFrontKick_mixamo.fbx` sit in
  `C:\Users\user\Downloads\Combat.zip` (unzip -l), same Mixamo skeleton, same licence as the five boxing takes we ship
  ("free to use in any ... game", CREDITS.md). They were left out in S399 only because they were "not boxing".
- **Old repo (archived):** RamsterZ Hand to Hand Set (bought, 124 FBX, UE4 mannequin rig, EUR 36.79 - `R107_HAND_TO_HAND_SET.md`)
  in `Godot/assets/anim/audition/ramsterz_h2h/` incl. `H2H_RoundhouseKick_InPlace`, `H2H_LowSideKick_InPlace`,
  `H2H_LeftCutKick_*`, `H2H_RightCutKick_*`, `H2H_KneeStrike_Forward`, `H2H_SpinningElbow_Forward`,
  `H2H_LegBlockStart/Idle/Loop/End` (real blobs, 0.6-0.9 MB). Motifect free pack (`.../motifect/unpacked/Motifect_martial_arts_v1_0/`
  FBX/GLB/BVH): `muay_thai_teep`, `muay_thai_roundhouse`, `muay_thai_body_kick`, `muay_thai_knee_clinch`, `muay_thai_elbow_cut`,
  `muay_thai_push_kick_defense`, `muay_thai_guard_stance` - stored as Git LFS (131-byte pointers in the tree; the contents API
  gives a media.githubusercontent.com URL, so the files are still retrievable). Fighting Motions Vol.1 (Unity 76699, free) is
  an LFS pointer at `AssetLibrary/unity/magicpot/fighting_motions_vol1_76699.unitypackage`. Cascadeur `Cascy_CageClinch_Att/Vic.glb` (LFS).
- **Known defect on record:** our RamsterZ kicks "all fly" (R111, quoted in `R142_ASSET_STORE_SHORTLIST.md` l.148/309) -
  they leave the ground. `H2H_LegBlockIdle` was measured as a "check-low posture, foot barely lifts" (`Q86_STANCE_TAKES.md` l.10).
  Motifect needs a 13-bone name map (`U46_MOTIFECT_AUDITION.md` s3: 9/22 bones by name).
- E:\FightCamp_backup_D: kick-related only `sources/meshy/206_Spartan_Kick.glb` (a Meshy generated body - not usable, MetaHuman
  rule) and Higgsfield videos `v09/v10_check_hook_*.mp4` (a punch "check hook", not a shin check). E:\FightCamp\packs: punch packs only.

## The table

| action | have it? | best source | licence | cost | retarget path | verdict |
|---|---|---|---|---|---|---|
| **Teep (lead leg)** | YES, downloaded: `Kicking__Male_Thrust_Kick_With_The_Lead_Foot.fbx` (Mixamo); also `Rokoko BigFrontKick_mixamo.fbx`, Motifect `muay_thai_teep` (old repo LFS) | Mixamo thrust kick, lead foot | Mixamo: royalty-free for commercial games, no redistribution of raw files ([Adobe Mixamo FAQ](https://helpx.adobe.com/creative-cloud/faq/mixamo-faq.html); [Adobe community FAQ](https://community.adobe.com/t5/mixamo-discussions/mixamo-faq-licensing-royalties-ownership-eula-and-tos/td-p/13234775)) | $0 | Mixamo skeleton -> RkRetarget.gd (as the 5 Rokoko boxing takes) | **TAKE FIRST.** Fallback: author it (a straight leg push, see below) |
| **Low kick (rear leg)** | YES: `Mma_Kick__Mma_Low_Kick.fbx`, `Transition__Low_Kick_To_Idle_Transition.fbx` (Mixamo) | Mixamo MMA low kick + its return | Mixamo (as above) | $0 | RkRetarget.gd | **TAKE FIRST**; check it stays grounded on a side still (R111 flying-kick defect) |
| **Body kick (rear leg)** | YES: `Mma_Kick__Mma_Medium_Kick.fbx`, `Mma_Kick__Mma_Roundhouse_Kick.fbx`, `Kicking__Roundhouse_Kick_With_The_Rear_Foot.fbx`, `Roundhouse_Kick__A_Roundhouse_Kick_To_The_Side_Of_An_Opponent.fbx` (Mixamo); Rokoko `RoundHouseKick_mixamo.fbx` | Rokoko RoundHouseKick (real mocap) or Mixamo Medium Kick - pick on stills | Rokoko free incl. commercial (CREDITS.md, [rokoko.com](https://www.rokoko.com/resources/rokoko-mocap-13-free-fight-animations)) / Mixamo | $0 | RkRetarget.gd | second slice; A/B the two on the side camera |
| **Head kick (rear leg)** | YES: `Mma_Kick__Mma_High_Kick.fbx`, `Mma_Kick.fbx` (Mixamo) | Mixamo MMA high kick | Mixamo | $0 | RkRetarget.gd | second slice |
| **Shin check** | NO clean take. RamsterZ `H2H_LegBlockIdle/Start/End` (old repo, UE4 rig) = check-low posture, foot barely lifts (Q86) | **Author it** (bake tool) | ours | $0 | none: baked on the MetaHuman | **AUTHOR** - a knee lift on the guard; RamsterZ LegBlock as the reference only |
| **Kick caught - catcher** | NO anywhere (old repo, disk, Mixamo names, packs searched). Rapa Motion "Melee Combat Counters" has counter-kicks, no catch ([itch](https://rapamotion.itch.io/meleecounters)) | **Author** as a hold (arm wraps the shin) | ours | $0 | baked | AUTHOR, after the first slice |
| **Kick caught - kicker** | NO | **Author**: kicker on one leg, kicking leg held at the catcher's contact point | ours | $0 | baked, keyed to the catcher's contact | AUTHOR together with the catcher (one shared contact point, the HOLDTAKES1 method) |
| Knee (later) | YES: `Illegal_Knee__Muay_Thai_Illegal_Knee.fbx`, `Knee_Kick_Lead__Kicking_With_Lead_Foot.fbx`, `Knee_Jabs_To_Uppercut__Triple_Knee_Jabs_To_Uppercut_Combo.fbx` (Mixamo); RamsterZ `H2H_KneeStrike_Forward`; Motifect `muay_thai_knee_clinch` | Mixamo Muay Thai knee | Mixamo | $0 | RkRetarget.gd | take when knees enter the rules |
| Elbow (later) | YES: `Elbow_Punching__Male_Elbow_Punch.fbx`, `Illegal_Elbow_Punch__Illegal_Cross_Elbow.fbx`, `...Illegal_Elbow_To_The_Head.fbx`, `...Illegal_Elbow_Uppercut.fbx`, `Jab_To_Elbow_Punch__Jab_To_Elbow_Combo.fbx` (Mixamo); Motifect `muay_thai_elbow_cut` | Mixamo elbows (horizontal, uppercut) | Mixamo | $0 | RkRetarget.gd | take when elbows enter the rules |
| Thai clinch (later) | PARTLY: Lean `clinch_att/clinch_vic.res` (boxing tie-up, `scripts/fight3d/Clinch.gd`); Motifect `muay_thai_knee_clinch` (one body); old `Cascy_CageClinch_Att/Vic` (MMA cage) | Martial Arts Master (Unity 311647): "30 paired pairs incl. plum knees" (R142 l.34) | Unity Asset Store EULA | EUR 45.99 (R142, list price 2026-09-13) | UE4-mannequin rig = the RamsterZ BoneMap (R142 "same rig as what we own") | BUY ONLY when the clinch is in the rules; paired takes are the one thing we cannot author cheaply |

## The other routes, checked
- **Ludo.ai.** Griffin / Ignis are **2D Sprite Generator** models (memory `reference_ludo_griffin_ignis_s555`) - they draw sprites,
  not bones on our skeleton. Ludo's 3D side auto-rigs and animates a model *it* holds (600+ clip library + text-to-motion,
  exports GLB/FBX/USDZ - [ludo.ai/compare/ludo-vs-meshy](https://ludo.ai/compare/ludo-vs-meshy), [docs](https://new.ludo.ai/docs/3d-generator)).
  Its skeleton naming is not documented; a take would come on Ludo's body and need a retarget. **Verdict: reference or a gap filler
  only**, not before the free Mixamo takes fail.
- **Tripo.** Auto-rig API with bone naming `mixamo` / `unreal` / `unity` and FBX out
  ([Alibaba Model Studio Tripo rig API](https://help.aliyun.com/en/model-studio/tripo-auto-rig-api-reference)); its presets
  play on a Tripo-generated mesh. With Mixamo naming the motion would enter RkRetarget.gd, but the body it is made on is generated
  (never shown: MetaHuman rule) and its presets have no Muay Thai set found. **Verdict: not needed** - Mixamo already has the moves.
- **Higgsfield.** Makes video, not skeleton data: its own help content says it does not extract motion for rigged 3D models and
  points to DeepMotion / Plask ([geo.higgsfield.ai](https://geo.higgsfield.ai/blog/affordable-ai-alternatives-to-mocap-suits)).
  Kimodo text-to-motion via Higgsfield gives one skeleton-only body, and 47 boxing takes were all rejected (`topics/clips_sources.md`,
  C207/C221). **Verdict: reference video only** (e.g. a side-view teep or catch to author from).
- **Marketplace packs** (none needed for the first slice):
  - Muay Thai AnimSet Pro (Unity 107262): 145 clips, grounded round kicks, teeps, elbows, kick blocks, graded leg hits, **no knees**;
    $35 under the standard Unity Asset Store EULA ([store](https://assetstore.unity.com/packages/3d/animations/muay-thai-animset-pro-107262),
    [dev post](https://discussions.unity.com/t/muay-thai-animset-pro/685768); contents read in R142 l.121-131). 65-bone humanoid -> a new map.
    **Best paid fallback** if the Mixamo kicks fail on stills - it also has the leg-hit reactions Mixamo lacks.
  - MuayThai AnimSet (Unity 262994): $59.99, 91+ clips, knees/clinch not confirmed ([store](https://assetstore.unity.com/packages/3d/animations/muaythai-animset-262994)).
  - Combat animations - Kickboxing and Muay Thai V2 (Unity 203212 / Fab): $18.99, 22 clips, UE mannequin
    ([store](https://assetstore.unity.com/packages/3d/animations/combat-animations-kickboxing-and-muay-thai-v2-203212)); no clip list found.
  - Kickboxing Animation Essentials (PAKPROD, Fab/UE): 340 clips incl. **check-kicks for left and right legs** and parries
    ([listing](https://docs.unrealengine.com/marketplace/ko/product/kickboxing-animation-essentials)); price NOT FOUND (Fab page shows none
    in search). The only pack seen that names a shin check.
  - Reallusion / ActorCore "Martial Arts - Muay Thai": 18 motions, $55 ($38.50 on sale)
    ([store](https://www.reallusion.com/ContentStore/Pack/martial-arts-muay-thai)); the content EULA sends game use to a separate
    "Licensing FAQ for Game Developers" appendix I could not read ([EULA](https://www.reallusion.com/Content/EULA/EULA.htm)) - **NOT FOUND**, check before buying.
  - Rokoko Motion Library: $3-6 per asset, no Muay Thai pack found ([zippyframes](https://www.zippyframes.com/news/production/rokoko-opens-up-mocap-marketplace-to-the-public)).
  - MoCap Online: punch/boxing packs only; no kickboxing pack found ([mocaponline.com](https://mocaponline.com/pages/animlist-boxing-pro)).
  - Past rulings that still stand: buy on Unity, not Fab or direct (R142 l.21); buying is held until our playback matches vendor reels
    (`topics/clips_sources.md`).

## Authoring with our bake tools (`tools/pics2d_hold_bake.gd`, `tools/pics2d_bodycross_bake.gd`)
These bake a take in its own keys from the guard's first picture: a two-bone solve per key, one limb moved to a target written from a
landmark of the same body, everything else held (HOLDTAKES1 / BODYCROSS2 headers). The same method has two-bone LEG solves already
(bodycross: "a two-bone leg solve per key, knees over the toes").
- **Easy to author (no capture):** the **shin check** (lead knee up to hip height, shin turned out ~45 deg, foot off the floor,
  guard kept - one leg moved, the rest held: exactly the hold method); the **caught kick** both sides as two holds sharing one
  contact point (catcher: rear arm wraps under the calf; kicker: standing leg planted, kicking leg held at that point);
  a **teep** (lead knee chambers, hip pushes forward, sole extends to belly height, return) if the Mixamo thrust kick fails.
- **Needs real motion:** the **round kicks** (low, body, head): the power comes from the pivot on the standing foot and the hip
  turning through, a whole-body chain a key-by-key solve will look wooden on (memory `feedback_anim_from_research_clips_s537`:
  "the power does not come from twisting the knee"). Use mocap (Mixamo / Rokoko), never authored.

## Recommended route (first slice: teep, low kick, check)
1. **Teep:** retarget the already-downloaded Mixamo `Kicking__Male_Thrust_Kick_With_The_Lead_Foot.fbx` through `RkRetarget.gd` (copy one file into the repo, add a CREDITS line). No download, no cost.
2. **Low kick:** same route with `Mma_Kick__Mma_Low_Kick.fbx` + `Transition__Low_Kick_To_Idle_Transition.fbx`; gate both on a side-camera still that the standing foot stays planted and the shin, not the foot, lands (R111 flying-kick defect).
3. **Check:** author it with a new leg variant of `pics2d_hold_bake.gd` (guard held, lead knee up, shin out); RamsterZ `H2H_LegBlockIdle` (old repo) only as the shape reference.
4. **Next slice:** body and head kick from Rokoko `RoundHouseKick_mixamo.fbx` (in `Downloads\Combat.zip`) vs Mixamo `Mma_Medium/High_Kick`, picked on stills; the caught kick authored as two holds on one contact point.
5. **Buy nothing now.** Paid fallback if the Mixamo/Rokoko kicks fail on stills: Muay Thai AnimSet Pro ($35, grounded kicks + leg hits); Martial Arts Master (EUR 45.99) only when the Thai clinch enters the rules.
