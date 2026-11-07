# CLIP LICENCE LIST S392 — every animation, sound and model source we ship (Goose, 2026-11-06)

Task LICENCE1 for docs/STEAM_RELEASE_PLAN.md section 2. Read-only research: one new document, nothing else.
This is a list for the operator to check, not legal advice.

## Flags — things the operator must read before shipping

1. **MetaHuman (models + 4 authored clips):** the licence page (metahuman.com/license) needs an Epic login; the clause
   was not read first-hand. cgchannel (2025-06) reports MetaHuman characters "are classed as non-engine products" under
   the standard UE EULA, free under $1M revenue a year. **Confirm the clause before release.**
   Evidence: `ops/research/MH1_DIGEST.md` line 116; `ops/research/J_CLOTHES_S207.md` line 57.
2. **Ludo.ai SFX (all 27 audio files):** commercial EULA on a paid plan. The operator's account generated every file;
   the EULA text was not captured in this pass. **Read the current Ludo EULA before release.**
   Evidence: `assets/audio/sounds.json` (every file's `"source": "ludo audio sfx"` or `"ludo audio loop"`).
3. **CMU mocap (6 clips):** may NOT be resold directly, even converted. Shipping embedded in a game is allowed; selling
   the clip files as a pack is not. Credit line required: NSF EIA-0196217.
   Evidence: `ops/research/OWNED_MOCAP_S381.md` lines 18-20; `ops/research/C75_ANIMATION_SOURCES.md` line 12.

No source in this list is non-commercial. No source requires the operator to sign in at runtime.

---

## ANIMATION CLIPS

### 1. Adobe Mixamo — 167 clips

| Field | Value |
|---|---|
| What we use | 165 fight clips (`mc_Box1_M3_*` 145 files, `mc_Punch_M3_*` 20 files) + 2 entry clips (`entry_entering_ring.res`, `entry_entering_from_ring_corner.res`) |
| How many files | 167 `.res` in `assets/anim/baked/` and `assets/anim/entry/` |
| Licence as published | Free with an Adobe ID; no Creative Cloud subscription required. "royalty free for personal, commercial, and non-profit projects" including video games |
| May we ship in a paid game? | Yes |
| Credit needed | No attribution required by the licence |
| Evidence | `ops/research/C75_ANIMATION_SOURCES.md` line 12 (Adobe FAQ read 2026-09-10); `assets/anim/baked/CREDITS_actionforge.md` line 1 (Mixamo-to-MetaHuman bake); git commit `8dbb3920` (entry clips from Mixamo) |

### 2. ActionForge / Quaternius Universal Animation Library — 15 clips

| Field | Value |
|---|---|
| What we use | 15 ambient/gym clips (`af_idle`, `af_walk`, `af_sit_idle`, `af_talk`, `af_crouch_idle`, etc.) for the corner minute and gym scenes |
| How many files | 15 `.res` in `assets/anim/baked/` |
| Licence as published | CC0 public domain: "use them anywhere, commercially, with no attribution required" |
| May we ship in a paid game? | Yes |
| Credit needed | No (CC0), but credited anyway in `CREDITS_actionforge.md` |
| Evidence | `assets/anim/baked/CREDITS_actionforge.md` lines 1-4 (Quaternius, CC0, exported 2026-10-17) |

### 3. CMU Graphics Lab Motion Capture Database — 6 clips

| Field | Value |
|---|---|
| What we use | 6 long boxing takes retargeted onto our MetaHuman: `cmu_13_17`, `cmu_13_18`, `cmu_14_01`, `cmu_14_02` (kept), plus 2 more in the owned folder |
| How many files | 6 `.res` in `assets/anim/baked/owned/` |
| Licence as published | "free for all uses"; "You may include this data in commercially-sold products, but you may not resell this data directly" (including converted form) |
| May we ship in a paid game? | Yes (embedded in the game); NO (may not resell the clip files as a pack) |
| Credit needed | Yes — credit line "NSF EIA-0196217" in the game credits |
| Evidence | `ops/research/OWNED_MOCAP_S381.md` lines 18-20 (licence quote); `ops/research/C75_ANIMATION_SOURCES.md` line 12 (CMU database read 2026-09-10) |

### 4. Rokoko free combat pack — 3 clips

| Field | Value |
|---|---|
| What we use | 3 long boxing takes: `rk_shadowboxing_a` (11.9 s), `rk_shadowboxing_b` (5.8 s), `rk_boxing` (15.5 s) — Smartsuit Pro II capture, Mixamo-rig FBX retargeted to MetaHuman |
| How many files | 3 `.res` in `assets/anim/baked/owned/` |
| Licence as published | Rokoko free-pack pages: usable "in any animation, VFX, game ... from passion project to commercial use" |
| May we ship in a paid game? | Yes |
| Credit needed | Not found in the free-pack terms (no attribution clause located) |
| Evidence | `ops/research/OWNED_MOCAP_S381.md` lines 15-16 (licence quote from Rokoko free-pack pages) |

### 5. RamsterZ Hand to Hand Set (Unity Asset Store) — 17 clips

| Field | Value |
|---|---|
| What we use | 17 fight clips: `boxing_body_hook`, `boxing_pull`, `boxing_rear_uppercut`, `boxing_slip`, `clinch_att`, `clinch_vic`, `ow_bounce_idle`, `ow_side_lean`, `react_body`, `react_head`, `react_leg`, `idle`, `loc_advance`, `loc_retreat`, `loc_strafe_left`, `loc_strafe_right`, plus the `mc_Box1_M3_Idle` guard pose used as a reference |
| How many files | 17 `.res` in `assets/anim/baked/` |
| Licence as published | Unity Asset Store EULA §2.2.1: buyer may "reproduce, publicly display, publicly perform, transmit, and distribute" an asset embedded in a Licensed Product |
| May we ship in a paid game? | Yes (embedded in the game) |
| Credit needed | Not required by Unity EULA for embedded assets |
| Evidence | `ops/research/R107_HAND_TO_HAND_SET.md` lines 21-59 (clip-to-source mapping); `ops/research/R107_HAND_TO_HAND_SET.md` line 101 (EUR 36.79, Unity Asset Store purchase); `ops/research/C75_ANIMATION_SOURCES.md` line 12 (Unity EULA §2.2.1 quote) |

### 6. MetaHuman authored clips (old repo) — 4 clips

| Field | Value |
|---|---|
| What we use | 4 fight clips authored on the MetaHuman skeleton: `mh_jab`, `mh_cross`, `mh_lead_hook`, `mh_guard_pose` (20 frames at 30 fps each) |
| How many files | 4 `.glb` in `assets/anim/metahuman/` |
| Licence as published | Authored in-house on the MetaHuman skeleton (OFFBAKE1C, S229). The MetaHuman mesh licence applies to the skeleton (see Models section 1 below) |
| May we ship in a paid game? | Yes, under the same MetaHuman terms as the meshes (see flag 1 above) |
| Credit needed | Same as MetaHuman meshes |
| Evidence | `assets/models/metahuman/CREDITS.md` lines 7-8 (clips authored in old repo, OFFBAKE1C, S229) |

---

## 3D MODELS

### 1. Epic MetaHuman Creator — 23+ characters

| Field | Value |
|---|---|
| What we use | 23 MetaHuman characters: 19 boxers (`mh_boxer_01` through `mh_boxer_23`), 4 corner staff (`mh_staff_coach`, `mh_staff_coach_2`, `mh_staff_cutman_1`, `mh_staff_trainer`), plus textures (albedo, normal, brow cards, hair cards, eye textures) |
| How many files | 23 `.glb` + ~160 texture files in `assets/models/metahuman/` |
| Licence as published | Epic MetaHuman Creator, UE EULA. Since June 2025: MetaHuman characters "are classed as non-engine products" under the standard UE EULA, free under $1M revenue a year. The primary licence page (metahuman.com/license) needs an Epic login and was not read first-hand |
| May we ship in a paid game? | Yes, free under $1M revenue; royalty terms above that threshold not confirmed |
| Credit needed | Not found in the publicly available text (licence page requires Epic login) |
| Evidence | `ops/research/MH1_DIGEST.md` line 116 (cgchannel 2025-06 quote); `ops/research/J_CLOTHES_S207.md` line 57 (MetaHuman licence terms); `assets/models/metahuman/CREDITS.md` lines 1-12 (character list) |

### 2. Boxing glove — Incg5764 (Sketchfab, CC BY 4.0)

| Field | Value |
|---|---|
| What we use | `boxing_glove.glb` — rescaled to 10 oz envelope, decimated to ~1,950 triangles, textures removed, cuff band as vertex colour |
| How many files | 1 `.glb` in `assets/models/gloves/` |
| Licence as published | Creative Commons Attribution 4.0 (CC BY 4.0) — commercial use allowed, author must be credited. Sketchfab "NoAI" tag: may not be used in generative AI datasets (it is used here only as a game mesh) |
| May we ship in a paid game? | Yes |
| Credit needed | **Yes** — "Boxing Glove" by Incg5764 (@incg5764), Sketchfab, CC BY 4.0 |
| Evidence | `assets/models/gloves/CREDITS.md` lines 1-14 (full licence quote and source URL) |

### 3. Boxing boot — Higgsfield tripo_3d

| Field | Value |
|---|---|
| What we use | `boxing_boot.glb` + Color / NormalGL / ORM textures — generated with Higgsfield tripo_3d (job c5591bc5, 5 credits), fitted to each MetaHuman foot by `FighterKit.gd` |
| How many files | 1 `.glb` + 3 textures in `assets/models/kit/` |
| Licence as published | Higgsfield terms s4.4: commercial use unrestricted, no ownership claimed by Higgsfield |
| May we ship in a paid game? | Yes |
| Credit needed | Not required by Higgsfield terms |
| Evidence | `assets/models/kit/CREDITS.md` lines 1-5 (Higgsfield job ID, terms s4.4) |

### 4. MetaHuman skin shader + micro normal — original work

| Field | Value |
|---|---|
| What we use | `mh_skin.gdshader` (SSS skin shader) + `mh_skin_micro_normal.png` (pore detail) |
| How many files | 2 files in `assets/models/metahuman/` |
| Licence as published | Original work for FightCamp, no third-party content |
| May we ship in a paid game? | Yes (we own it) |
| Credit needed | None |
| Evidence | `assets/models/metahuman/CREDITS.md` line 5 ("mh_skin.gdshader and mh_skin_micro_normal.png are ours") |

---

## AUDIO

### 1. Ludo.ai SFX — 27 files

| Field | Value |
|---|---|
| What we use | All fight SFX (punch jab/power/body/blocked/miss/big, bells, crowd loop, crowd roar, knockdown fall, footwork canvas) and UI clicks — every file in `assets/audio/fight/`, `assets/audio/crowd/`, `assets/audio/ui/` |
| How many files | 27 `.ogg` files (13 fight, 2 crowd, 4 UI, plus raw `.wav` sources in `assets/audio/raw/`) |
| Licence as published | Ludo.ai commercial EULA (paid plan, credits purchased). The EULA text was not captured in this pass |
| May we ship in a paid game? | Yes (commercial EULA on paid plan) |
| Credit needed | Not found in the publicly available text (EULA not read) |
| Evidence | `assets/audio/sounds.json` (every file's `"source": "ludo audio sfx"` or `"ludo audio loop"`, `"credits": 2` per file); `ops/research/S92_FREE_SOUND_AND_MUSIC.md` line 14 (Ludo commercial EULA noted) |

---

## Summary table

| Source | Type | Files | Licence | Commercial OK? | Credit? | Flag? |
|---|---|---|---|---|---|---|
| Adobe Mixamo | anim | 167 | Royalty-free (Adobe FAQ) | Yes | No | - |
| ActionForge / Quaternius | anim | 15 | CC0 public domain | Yes | No (credited anyway) | - |
| CMU Graphics Lab Mocap | anim | 6 | Free, no direct resale | Yes (embedded) | Yes (NSF grant) | #3 |
| Rokoko free combat pack | anim | 3 | Free-pack commercial OK | Yes | Not found | - |
| RamsterZ (Unity Asset Store) | anim | 17 | Unity EULA §2.2.1 | Yes (embedded) | No | - |
| MetaHuman authored clips | anim | 4 | MetaHuman / UE EULA | Yes (< $1M) | Not found | #1 |
| Epic MetaHuman Creator | model | 23+ chars | UE EULA non-engine products | Yes (< $1M) | Not found | #1 |
| Incg5764 boxing glove | model | 1 | CC BY 4.0 | Yes | **Yes** | - |
| Higgsfield tripo_3d boot | model | 1 + textures | Higgsfield s4.4 | Yes | No | - |
| FightCamp skin shader | model | 2 | Original work | Yes (owned) | None | - |
| Ludo.ai SFX | audio | 27 | Ludo commercial EULA | Yes (paid plan) | Not found | #2 |

**Total files shipped:** ~262 animation clips, ~200 model files, 27 audio files.

---

## What is not on record

- **MetaHuman licence page** (metahuman.com/license): requires Epic login, clause not read first-hand.
- **Ludo.ai EULA**: commercial terms confirmed by the paid-plan purchase, but the licence text was not captured.
- **Rokoko free-pack attribution**: no attribution clause located in the free-pack terms.
- **Entry clips provenance**: git log confirms Mixamo source (commit `8dbb3920`), but no CREDITS file documents them.

## What this list is not

This is not legal advice. The operator should read the flagged items (MetaHuman licence page, Ludo EULA, CMU resale ban)
before shipping on Steam.

## S396 corrections (Claude, from git history)
- **clinch_att / clinch_vic are not RamsterZ.** Commit ef451852 (S317) baked them from Cascadeur's two-person sample clinch
  (`Cascy_CageClinch`) with tools/pair_bake.gd. The licence of Cascadeur's sample content was never read. **Flag #4: read the
  Cascadeur terms for shipping its sample animations, or replace the clinch before release.**
- **ow_walk** (S395) is CMU subject 07 trial 01, retargeted by tools/walk_cycle.gd: covered by the CMU credit line (now in the
  in-game Credits, assets/data/credits.json).
- RamsterZ therefore ships 15 clips, not 17. The in-game Credits list every source that asks for a credit (credits_test).
- Flag #4 checked on the web (S396): Cascadeur's current Free plan is non-commercial; Indie covers commercial use under $100k a
  year; no public page states terms for its bundled sample animations (cascadeur.com/plans). Our Cascadeur seat ended
  2026-10-27. **Safest: replace the two clinch clips with a licensed source before launch**, or get Nekki's answer in writing.
