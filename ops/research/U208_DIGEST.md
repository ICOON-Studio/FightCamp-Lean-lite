# U208 digest — animated tale-of-the-tape previews (Cursor)

**Delivered (SEND-BACK 2 fix):** three silent 1920×1080 / 30 fps / ~10 s MP4 layout previews + matching stills + contact sheet under `previews/u208/`. Red **ath_0003** (face `male_03.png`) vs blue **ath_0912** (`male_05.png`) on `mpfb_male_pilot.glb` through `FighterPortrait.build_studio` + portrait ancestry re-skin, `FighterPhysique` stature/girth, procedural boxing gloves (`CCFighterSkin`), guard idle via **`FightStagePlayer.bind(fighter, "boxing")`** (same graft path as the live ring). Cage Desk typography (Bebas Neue, IBM Plex Mono, Inter).

## SEND-BACK 2 — what changed

| Gate | Fix |
|------|-----|
| Pose | `FightStagePlayer.bind` grafts ruleset `idle` (Bouncing Boxing Idle) with correct track paths; per-frame `seek` on loop; `FighterFist` + procedural gloves. |
| Two different men | Distinct athlete ids, portrait ancestry (male_03 vs male_05), height 178 vs 183 cm, girth/scale via `FighterPhysique`. |
| Bars | Per-row `_bar_split` from tape numbers (wins, reach, KO %, rank, last-5 W count, etc.). |
| Data | Welterweight boxing limit **66.7 kg (~147 lb)** on both sides from `WeightCut.limit_for`. |
| Framing v3 | Full-height head band ~14.5% + viewport hosts inset from top (40 px). |
| Shorts | Ring trunks path via `apply_identity` / `FighterTrunks.paint` (no Portrait-only skin pass). |

## Pick list (operator)

| # | Files | Look |
|---|--------|------|
| 1 | `variant_1_dwcs_broadcast.mp4` + `.png` | UFC/DWCS: full-height edge cut-outs, centre stat column, red/blue bars, rows wipe in |
| 2 | `variant_2_faceoff.mp4` + `.png` | Split face-off: big record/rank, lower-third stats |
| 3 | `variant_3_fightcamp_surpass.mp4` + `.png` | Cage Desk brass/ice plates + camp-only rows (weigh-in fitness, camp grade, game plan, last-5 W/L pips) |

Side-by-side still: `u208_contact_sheet.png`.

## Broadcast references (URLs)

1. DWCS Season 9 matchup / tale-of-the-tape graphics roundup: https://oddsmokermma.com/2025/07/26/dwcs-matchup-graphics-for-dana-whites-contender-series-2025/
2. UFC Apex DWCS broadcast context (ESPN+, tape segments): https://www.tapology.com/fightcenter/events/128461-contender-series-2025-week-4
3. Week card with explicit “TALE OF THE TAPE” pairing labels: https://www.valorfights.com/event/dana-white-s-contender-series-season-9-week-5

## Fighter layer (swappable)

Cut-outs render in `Godot/tools/u208_tott_previews.gd` (`_build_fighter_rig` → `FightStagePlayer.bind` + portrait studio). Replacing mesh/animation source is localized there; in-game `RingStagePanel` is untouched.

## Reproduce

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once
powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/u208_tott_previews.gd
python Tools/u208_tott_encode.py
```

Parse: `python Godot/tools/check_scripts.py Godot/tools/u208_tott_previews.gd`  
Tests: `python Godot/tools/run_tests.py --jobs 2 --only portrait,tale_of,fight_night` → SUITE total=4 fails=0.

## Evidence

Opened `u208_contact_sheet.png`, all three stills, per-variant frames at 0–9 s (1 Hz), and watched all three MP4s (silent H.264, guard idle motion, distinct corners, centre stats and asymmetric bars by mid-clip). Frame exports: 300 PNGs per variant in `variant_*_frames/`.
