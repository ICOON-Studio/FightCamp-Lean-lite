# UICARDS1 digest (S227)

## Step 0 — UIBIBLE1 tokens in UIKit (Ludo r70 PART B)

**Changed**
- `UIKit.gd`: Gleason colour tokens (`COLOR_*`), spacing/radii/motion constants, and helpers (`bible_top_bar_style`, `bible_left_rail_style`, `bible_panel_style`, `bible_tab_*`, `bible_speed_button_style`, `bible_fluid_bar_color`, `bible_tween_tab_indicator`, `bible_tween_speed_pip`).
- `ui_kit_manifest.json`: bible helpers listed as deliberate non-instruments.
- `ProfileTabHost.gd`: header/tab chrome re-pointed at bible tokens and tab tween (`TRANS_QUAD`, 160 ms).
- New `tests/ui_kit_bible_test.gd`.

**Gate (red lines before fix — branch without STEP 0)**
- Profile header/tab colours were local hex (`C_GOLD`, `C_STEEL`, …), not r70 bible tokens.
- No automated check for r70 motion tokens (160 ms tab / 80 ms speed pip).

**Gate (after step 0)**
- `python3 Godot/tools/check_scripts.py Godot/scripts/UIKit.gd Godot/scripts/ui/ProfileTabHost.gd` → `CHECK total=2 fails=0`
- `tests/ui_kit_bible_test.gd` → `UI_KIT_BIBLE total=9 fails=0`
- `tests/profile_tab_host_uicards1_test.gd` → `PROFILE_TAB_HOST_UICARDS1 total=16 fails=0`

## Step A — Top HUD transom + left nav rail (Ludo r70 PART D stage 1)

**Changed**
- `ShellChrome.gd`: `LeftNavRail` (`64×1080`, `BG_VOID` + `SURF_BORDER` seam); top `Strip` uses `bible_top_bar_style()` (`SURF_BASE`).
- `TimelineBar.gd`: bible speed buttons, gold `SpeedPip` with `80 ms` tween on speed change; date plate uses bible panel surface (no floating yellow pill).
- New `tests/shell_chrome_bible_test.gd` (gate 1.1 colour + pip timing).

**Hidden when absent**
- Unchanged from gameplay data rules (no new profile fields).

**Gate (after step A)**
- `tests/shell_chrome_bible_test.gd` → `SHELL_CHROME_BIBLE total=9 fails=0`
- `python3 Godot/tools/run_tests.py --jobs 2 --only profile,quick_look,ui_kit` → 20/21 pass on cloud (`profile_stage_test.gd` needs LFS meshes).

## Step 1 — ProfileTabHost (header + tab bar + 160 ms gold indicator) — prior commit `b5368a89`

**Changed**
- Renamed the old techniques/camp tab body script to `ProfileTabContent.gd` (was misnamed `ProfileTabHost.gd`).
- New `ProfileTabHost.gd` (`class_name ProfileTabHost`): Ludo r68 header strip at (40,24)×1840, tab bar, gold `TabIndicator` tween (`TAB_INDICATOR_DURATION_S = 0.16`), `tab_changed` / `back_requested`.
- `ProfileOverview.gd` mounts `ProfileTabHost` instead of inline `top_bar` / `banner` / `TabBar` builders (legacy panels kept, hidden).
- Tests updated for nested `TabBar`; `tests/profile_tab_host_uicards1_test.gd`.

**Hidden when absent (step 1)**
- Nickname + record subtitle line (empty fresh career).
- Vitals chips: age, division, reach, stance (each hidden if field missing).
- Morale meter (no `morale` field).
- Composure meter (no `composure` on athlete and no `stats.composure`).
- Medical tab `[!]` badge only when `body_read.regions` has active injuries.

## Step 2 — QuickLookCard (Ludo r68 gym-floor dossier + r70 bible)

**Changed**
- `QuickLookCard.gd`: width `380px`, screen margin `20px`, `UIKit.bible_panel_style` / `COLOR_*` tokens, `10px` stamina (gold) and wear (oxblood) bars, chamfered gold CTA `OPEN FULL PROFILE (SPACE)`, brass `Anchor/Needle` + `Reticle`, `KEY_SPACE` opens profile.
- `QuickLook.gd`: `WIDTH` constant `380` (layout parity).
- `tests/quick_look_card_test.gd`, `tests/profile_drawer_test.gd`: width/margin expectations.
- New `tests/quick_look_card_uicards1_test.gd` (bible fill, needle nodes, 1920×1080 + 1280×720 label fit, `20px` placement).

**Hidden when absent**
- Coach line on assignment strip (game does not feed supervising coach on hall live read).
- Nationality flag chip (no stable flag field on athlete dict).
- Morale accent strip tint only when `morale` present; activity / stamina / wear / focus / bout rows unchanged from `QuickLook.view()` rules.
- Ludo “CHANGE ACTIVE DRILL” secondary CTA (no drill-picker route on this card).

**Gate (after step 2)**
- `python3 Godot/tools/check_scripts.py Godot/scripts/ui/QuickLookCard.gd Godot/tests/quick_look_card_uicards1_test.gd` → `CHECK total=2 fails=0`
- `tests/quick_look_card_test.gd` → `QUICKLOOK total=… fails=0`
- `tests/quick_look_card_uicards1_test.gd` → `QUICK_LOOK_CARD_UICARDS1 total=… fails=0`
- `python3 Godot/tools/run_tests.py --jobs 2 --only profile,quick_look,ui_kit` → 21/22 pass on cloud (`profile_stage_test.gd` needs LFS meshes).

## Step 3 — ProfileOverview (pillars, AttributeTile, anatomy wireframe)

**Changed**
- `AttributeTile.gd`: bible panel, 10-segment gold/oxblood gauge, grade stamp (S/A/B/C/D).
- `ProfileLayout.gd`: pillar row headers + FM tile key order (Physical / Technical / Mental); body + radar panel extended to ≤40 px bottom margin; `body_region_callout_rect`; block-man silhouette rects removed.
- `ProfileOverview.gd`: `_Body` / `BodyDiagram` deleted; `_AnatomySilhouette` brass wireframe + wear callouts; attributes use `AttributeTile` + pillar titles; portrait viewport uses `ProfileStage.build` (plinth stage when models load); bible backdrop/panels.
- `tests/profile_layout_test.gd`, `tests/profile_overview_test.gd`: pillar layout + anatomy gates.
- New `tests/profile_overview_uicards1_test.gd` (no block-man, clipping 1920×1080 + 1280×720, bottom gap).

**Hidden when absent**
- Anatomy region callout rows when region wear is 0 (fresh career shows wireframe only).
- Portrait 3D viewport when `load_models` is false (name label only).
- Month-ago delta on tiles when `month_ago` ctx empty.

**Gate (after step 3)**
- `python3 Godot/tools/check_scripts.py` on touched `.gd` → `CHECK total=6 fails=0`
- `tests/profile_layout_test.gd` → `PROFILELAYOUT total=9 fails=0`
- `tests/profile_overview_test.gd` → `PROFILE_OVERVIEW checks=125 fails=0`
- `tests/profile_overview_uicards1_test.gd` → `PROFILE_OVERVIEW_UICARDS1 checks=32 fails=0`
- `python3 Godot/tools/run_tests.py --jobs 2 --only profile,quick_look,ui_kit` → 22/23 on cloud (`profile_stage_test.gd` needs LFS meshes).

## Step 4 — Techniques (arsenal tree, dojo stage, move inspector)

**Changed**
- `ProfileTabContent.gd`: r68 three-column layout (520 / 760 / 500 px); left arsenal tree with search, bible filter chips, category header, 5-star mastery + prerequisite sublines (raw state pills removed); center dojo viewport + transport (`LOOP`, `SLOW-MO`, `REPLAY`, `ScrubSlider`); right move inspector (tier, match effects, prerequisite chain, camp assign when available). Deleted left-column attribute dump / `RAW SIMULATION ATTRIBUTES`.
- `ProfileStage.gd`: `seek_normalized()` for scrub control.
- New `tests/profile_techniques_uicards1_test.gd`.

**Hidden when absent**
- Move combat telemetry lines when `match.effects` empty on catalog node.
- `ASSIGN TO NEXT CAMP` when move is locked or already mastered-only (shown for `available` / `learning`).
- Training camp cost line (no stable camp-cost field on athlete dict).

**Gate (after step 4)**
- `python3 Godot/tools/check_scripts.py Godot/scripts/ui/ProfileTabContent.gd Godot/scripts/ui/ProfileStage.gd Godot/tests/profile_techniques_uicards1_test.gd` → `CHECK total=3 fails=0`
- `tests/profile_techniques_uicards1_test.gd` → `PROFILE_TECHNIQUES_UICARDS1 total=12 fails=0`
- `tests/profile_tabs_test.gd` → `PROFILE_TABS total=1258 fails=0`
- `tests/profile_stage_test.gd` → `PROFILE_STAGE total=266 fails=0` (host/scrub path; full suite still skips LFS mesh load on cloud)
- `python3 Godot/tools/run_tests.py --jobs 2 --only profile,quick_look,ui_kit` → 23/24 pass (`profile_stage_test.gd` engine-error on LFS glTF stub)

## Step 5 — Performance & Camp (progression graph + 3-column console)

**Changed**
- `ProfileTabContent.gd`: `_build_performance_camp` — top `CampProgressionGraph` (conditioning / fatigue / weight-cut curves, 8 weeks); columns `CampSparringColumn`, `CampScheduleColumn`, `CampLogColumn` on bible panels; real camp `projected.per_week`, `week_program`, `tabs_b` fight week / weight status.
- New `tests/profile_performance_camp_uicards1_test.gd`.

**Hidden when absent**
- Sparring partner cards when no `fight_camp.choices`.
- Camp log rows when no completed camp weeks / history.
- Opponent / readiness lines when `tabs_b` fight week empty.
- Cut trajectory footer when `weight_status` empty.

**Gate (after step 5)**
- `check_scripts.py` on touched `.gd` → `CHECK total=6 fails=0`
- `tests/profile_performance_camp_uicards1_test.gd` → `PROFILE_PERFORMANCE_CAMP_UICARDS1 total=95 fails=0`
- `run_tests.py --jobs 2 --only profile,quick_look,ui_kit` → 26/27 on cloud (`profile_stage_test.gd` LFS)

## Step 6 — Medical & Bio (dossier + clinical ward)

**Changed**
- `ProfileMedical.gd`: bible columns; `BioDossierPanel` (name, age, height, reach/ape, record, stress traits); `ClinicalWardColumn` injury ledger with `InjuryRehabBar*`; treatment `CONFIRM` on bible gold buttons.
- New `tests/profile_medical_bio_uicards1_test.gd`.

**Hidden when absent**
- Hometown, amateur record, personality traits, ape index (no height/reach).
- Injury rehab cards when no active injuries (cleared copy instead).

**Gate (after step 6)**
- `tests/profile_medical_bio_uicards1_test.gd` → `PROFILE_MEDICAL_BIO_UICARDS1 total=36 fails=0`
- `tests/profile_medical_bio_test.gd` still green in subset above.

## Step 7 — Career & Contract (trophy desk + bout ledger)

**Changed**
- `ProfileTabContent.gd`: `_build_career_contract` bible `CareerTrophyColumn` / `CareerDeskColumn`, optional `TitleBeltPlaque`.
- `ProfileTabsB.gd`: contract/camp actions use `UIKit.bible_speed_button_style` (neon `#22C55E` fills removed).
- New `tests/profile_career_contract_uicards1_test.gd`.

**Hidden when absent**
- `TitleBeltPlaque` when no title-fight stats.
- Purse / belt lines when `record_stats` / `fight_log` empty (empty-state copy from ProfileTabsB).

**Gate (after step 7)**
- `tests/profile_career_contract_uicards1_test.gd` → `PROFILE_CAREER_CONTRACT_UICARDS1 total=24 fails=0`
- `run_tests.py --jobs 2 --only profile,quick_look,ui_kit` → 26/27 on cloud (`profile_stage_test.gd` LFS)

## ROUND 4 (S235, operator C91/C93) — body silhouettes, schedule panel, debut card

**Changed**
- `ProfileBodyWear.gd` (new): front + back athletic silhouettes using `body_detailed_front.png` + six `body_region_*.png` fills tinted by wear; female width scale via `sex`.
- `ProfileOverview.gd`: body panel uses `ProfileBodyWear`; 0-0-0 pro record shows **DEBUT PENDING** + amateur ledger copy; camp panel shows next 3 `week_program` days + weight-cut + camp/coach lines; camp panel hidden when none (bout column grows); `_camp_panel_active` survives tab chrome.
- `ProfileForm.gd`: `schedule_preview_lines`, `weight_cut_line`, `debut_card_subline`, `amateur_record_line`, `pro_record_is_empty`.
- `ProfileLayout.gd`: dual figure geometry rects, `right_column_bout_rect`, wear callouts under figures.
- `tests/profile_overview_round4_uicards1_test.gd` (new); `profile_overview_test.gd` / `profile_overview_uicards1_test.gd` updated for new nodes.

**Hidden when absent**
- Camp / schedule panel when no `week_program` (7 days), weight ctx, camp summary, or coach name.
- Amateur ledger line on debut card when no `amateur_record` dict or turned pro with empty amateur bouts.
- Wear region callout rows when region wear is 0 (unchanged).

**Gate (ROUND 4)**
- `check_scripts.py` on touched `.gd` → `CHECK total=7 fails=0`
- `tests/profile_overview_round4_uicards1_test.gd` → `PROFILE_OVERVIEW_ROUND4_UICARDS1 checks=11 fails=0`
- `tests/profile_overview_test.gd` → `PROFILE_OVERVIEW checks=118 fails=0`
- `run_tests.py --jobs 2 --only profile,quick_look,ui_kit` → 27/28 on cloud (`profile_stage_test.gd` LFS glTF stub)
