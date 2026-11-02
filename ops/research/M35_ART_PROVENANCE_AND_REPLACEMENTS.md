# M35 - WHERE EVERY PICTURE CAME FROM, AND WHAT REPLACES THE ONES WE CANNOT SHIP
Claude (taking over Maria's M35 on the operator's word, 2026-09-26: "take over marias work we cant wait for that").
Method: every tracked image under `Godot/assets/` (799 files, `_local/` excluded - it is not exported), grouped by
family; source = the record next to it (SOURCES.md, README, CREDITS, LICENCES, asset_manifest.json, the prompt log)
or the commit that added it. **A source I did not see written down is UNKNOWN - never inferred.**

Classes: **SHIP** (source + terms recorded) · **CHECK** (source recorded, generator terms not written down) ·
**REPLACE** (cannot ship as is) · **UNKNOWN** (no source record) · **DEAD** (no code reads it - drop from the build).

## 1. The ledger
| Family (files) | What it is | Source (as recorded) | Terms | Class |
|---|---|---|---|---|
| `images/title_gym_bg.jpg` (1) | title / HOME key art | Higgsfield gpt_image_2_5, jobs in `images/SOURCES.md` | operator's paid Higgsfield Plus | **SHIP** |
| `images/home_gym_bg.jpg` (1) | HOME picture | Higgsfield, `SOURCES.md` | paid Plus | **SHIP** |
| `images/home_gym_bg_working.jpg`, `_packed.jpg` (2) | HOME occupancy variants | Higgsfield edits, jobs 4f21f72e / 47d728aa (`HIGGSFIELD_PROMPT_LOG.md` rows 51-52) - **missing from SOURCES.md** | paid Plus | **SHIP** (add the two rows) |
| `images/hub_fighters/fights/money_bg.jpg` (3) | area hub pictures | Higgsfield, `SOURCES.md` | paid Plus | **SHIP** |
| `images/fight_bell.jpg` (1) | fight-night bell beat | Higgsfield, `SOURCES.md` | paid Plus | **SHIP** |
| `images/athletes/generated/*` (24) | fighter portraits (12 male / 12 female), read by TaleOfTape | **REPLACED S92:** Higgsfield gpt_image_2_5, every job in `images/SOURCES.md` | paid Plus | **SHIP** |
| `images/athletes/fallback/*` (3) | striker / grappler / mixed silhouettes | **REPLACED S92:** Higgsfield gpt_image_2_5, jobs in `images/SOURCES.md` | paid Plus | **SHIP** |
| `images/splash_fighter.png` (1) | old splash | commit fba1ddef: copied from `ContentSource/transparent1.png`, origin never recorded | none | **UNKNOWN + DEAD** |
| `images/world_political_map.png` (1) | old country map | commit fba1ddef: `T_PoliticalMap.png` reused "as-is", origin never recorded | none | **UNKNOWN + DEAD** |
| `images/office/*` (4) | legacy office art | commit 843c0b3f, no source | none | **UNKNOWN + DEAD** (legacy scenes discarded) |
| `ui/belt_*`, `trophy_*`, `medal_rank` (7) | belts, trophies, medal | Cursor GenerateImage (Maria M2), `ui/README.md` | "operator cleared"; Cursor's image terms not written down | **CHECK** |
| `ui/plate_*` (6) | scene plates | Cursor GenerateImage (M2) | same | **CHECK** |
| `ui/glyph_*`, `discipline_glyphs_sheet` (12) | discipline glyphs | Cursor GenerateImage sheet + Pillow crops (M2) | same | **CHECK** |
| `ui/body_*` (8) | body map + region masks | Cursor GenerateImage + Pillow masks (M2) | same | **CHECK** |
| `ui/icons/disciplines/*` (15), `ui/icons/moves/*` (272) | discipline emblems, move pictograms | Cursor GenerateImage + Pillow (Kalli K2/K5), READMEs | "operator-cleared" | **CHECK** |
| `icons/lucide/*` (78) | function icons | lucide-static 0.468.0 | ISC, LICENSE kept | **SHIP** (credit in the game) |
| `icons/flags/4x3/*` (270) | country flags | flag-icons 7.2.3 | MIT, LICENSE kept | **SHIP** (credit in the game) |
| `venues/iron_parish/textures/*` (8) | brick/concrete PBR, exit sign | ambientCG Bricks085 / Concrete031; exit sign procedural | CC0; project-owned | **SHIP** |
| `venues/mma_arena/*` textures | Marpa arena | Unity Asset Store, bought | Unity EULA, authorised | **SHIP** |
| `models/fighters/*` textures (36) | the twelve fighters' skins | **CORRECTED S92:** Higgsfield MCP `tripo_3d` (paid Plus) + Ludo rig - never a tripo3d.ai free account | Higgsfield s4.4 no ownership claimed, commercial use unrestricted; Ludo EULA commercial licence | **SHIP** (faces weak - quality, not rights) |
| `vendor/polyronin_old_school_gym/*` (1) | placeholder gym props | Unity Asset Store, free | Unity EULA; manifest status `placeholder` | **SHIP-able, but placeholder** (G114 pack replaces) |
| `anim/audition/*` images (63) | textures/sheets beside the audition clips (Cascadeur Cascy, Motifect) | Cascadeur sample (Pro, commercial); Motifect pack (README: commercial OK) | per `asset_manifest.json` | **SHIP** - NOT excludable: the folder also holds clips `FightClipBinding.gd` loads, and these PNGs may be those models' textures |
| `fonts/*` | Oswald (as BebasNeue-Regular.ttf), IBM Plex Mono, Inter | Google Fonts / rsms | SIL OFL 1.1 | **SHIP** (OFL text in credits) |

**Counts (image files):** SHIP 427 · CHECK 320 · REPLACE 36 (Tripo skins) + 9 portraits · DEAD 6 (all UNKNOWN)
· UNKNOWN still read by the game: **9 portraits**.

## 2. What to do per class
- **DEAD (6): DONE 2026-09-26** - excluded from the export (`export_presets.cfg`: `assets/images/office/*`,
  `assets/images/splash_fighter.png`, `assets/images/world_political_map.png`; grep found no script or scene reading
  them). An unknown picture that never ships needs no replacement.
- **CHECK (320):** one fact to record, not new art: Cursor's terms for GenerateImage output (and which image model it
  called), read on cursor.com and quoted into `ui/README.md` - NOT READ YET, so not assumed either way. If the quote
  withholds commercial rights, these families become REPLACE with the briefs below.
- **REPLACE - Tripo skins (36):** comes free with the Tripo Pro regeneration already planned.
- **REPLACE - portraits (9):** the one art job that is genuinely needed. Brief below.
- **SOURCES.md: DONE 2026-09-26** - the two S82 HOME variant rows added.

## 3. Replacement briefs (Higgsfield gpt_image_2_5, what we have: ~0.25 credit an image)
Direction: the shipped front end follows **M34 A (brass)**, the operator's pick - warm dusty brass, leather, sodium light.
Per-direction deltas kept one line each in case art is ever re-pointed: B poster = flat ink, halftone, two colours;
C arena = cold arena light, black, blue rim; D six a.m. = cool dawn window light, grey-green.
- **Fighter portraits (9 now, plan 24):** head-and-shoulders, 3/4 view, plain dark-brass background, no text or logos,
  no recognisable real person, mixed ages/ethnicities, both sexes, gym-worn (tape, sweat, a towel), soft sodium key
  light from the left. Each portrait generated from the MATCHING regenerated Tripo fighter's front render as the
  reference, so the card and the 3D body are the same man. 2K, then crop 512x640. Budget 24 x 2 tries = ~12 credits.
- **Fallback portraits (3):** silhouettes, not faces - striker / grappler / mixed in the plate style of
  `ui/plate_fighter_identity.png`, so a missing portrait never shows a stranger's face. ~2 credits.
- Every job id goes into `HIGGSFIELD_PROMPT_LOG.md` and `images/SOURCES.md` the day it is made; each image checked at
  full size for text, logos and borrowed compositions (the S80 walkout lesson).

## 4. The five images that matter most in the first 10 minutes
1. **Title key art** (`title_gym_bg.jpg`) - the first frame; SHIP.
2. **HOME picture + its two variants** - seen every day; SHIP (fix SOURCES.md).
3. **Fighter card portrait** - the first fighter the player signs; **UNKNOWN today -> the portrait brief is the
   priority art job.**
4. **Weigh-in / tale of the tape** - the same portraits face to face; fixed by 3.
5. **Fight night** - the 3D fighters' skins; fixed by the Tripo Pro regeneration.

So two jobs clear the first ten minutes: **regenerate the fighters on Tripo Pro**, then **make the portraits from
those renders**. Everything else is SHIP, a line of paperwork, or an export exclude.

## 5. S92 update
Both first-ten-minutes jobs are closed: the portraits are replaced (24 + 3, all sourced, a test now refuses an unsourced one), and the fighter skins turned out to be SHIP all along - the S90 'Tripo free plan' premise was wrong (see the corrected row). UNKNOWN images the game can show: **0**.
