# U126 screen census (generated)

**Regenerate:** `python Godot/tools/u126_screen_census.py`

## Summary

| Metric | Count |
|--------|------:|
| `*Screen.gd` + `*Panel.gd` discovered | 30 |
| Builds UI (extends Control / nodes) | 30 |
| **LIVE** (player routing or mount chain) | 26 |
| **DEV** (debug routes / lab scenes) | 2 |
| **TEST-ONLY** (tests/tools, not routed) | 2 |
| **DEAD** (no route, no prod ref) | 0 |
| Hard-coded literal sites (`.gd` only) | 3427 |

### Known gap: `.tscn` layout

This tool scans **`Godot/scripts/*.gd` only**. It does **not** read `scenes/*.tscn` for offsets, theme overrides, or embedded numeric layout. Counts below are **not complete** for scene-authored layout (notably `FightNight.tscn` is script-only; set-piece bodies that are pure `.tscn` would be under-counted).

### UIKit contract surface

`UIKit.gd` exposes **164** public `static func` helpers (sample: raised_style, light_overlay, gradient_texture, block, surface, track_style, track, circle, label, caps, display, value_cell, …). Screens should read `UITokens.gd` for colour/type; hand-rolled `Color("#…")` and per-screen font sizes are the usual drift.

## Ranked build order (LIVE only, worst first)

| Screen | LIVE | built-from | literals | UIKit calls | hand `.new` | worst disagreement |
|--------|------|------------|----------|-------------|-------------|-------------------|
| ProfileRevampPanel | LIVE | mixed | 918 | 230 | 5 | fonts 0–80px (Δmode 80) |
| ScheduleHubPanel | LIVE | mixed | 351 | 130 | 5 | fonts 0–26px (Δmode 26) |
| OfficeHubPanel | LIVE | mixed | 344 | 123 | 3 | fonts 0–15px (Δmode 15) |
| RankingsHubPanel | LIVE | UIKit | 148 | 39 | 0 | fonts 15–20px (Δmode 20) |
| TrainingHubPanel | LIVE | mixed | 147 | 49 | 2 | fonts 24–26px (Δmode 26) |
| FightResultPanel | LIVE | UIKit | 146 | 46 | 0 | fonts 21–34px (Δmode 34) |
| ScoutingHubPanel | LIVE | UIKit | 146 | 53 | 0 | fonts 0–20px (Δmode 20) |
| FightCampPanel | LIVE | mixed | 144 | 55 | 1 | fonts 0–60px (Δmode 60) |
| FightContractScreen | LIVE | mixed | 115 | 41 | 6 | fonts 18–40px (Δmode 40) |
| SkillsMovesPanel | LIVE | mixed | 114 | 49 | 3 | fonts 0–22px (Δmode 22) |
| DevelopmentPanel | LIVE | mixed | 109 | 45 | 1 | fonts 20–26px (Δmode 26) |
| GymHubPanel | LIVE | mixed | 96 | 34 | 2 | fonts 22–24px (Δmode 24) |
| RingStagePanel | LIVE | mixed | 84 | 14 | 2 | fonts 22–22px (Δmode 22) |
| StaffHubPanel | LIVE | UIKit | 80 | 35 | 0 | low spread |
| FightWeekPanel | LIVE | UIKit | 77 | 25 | 0 | low spread |
| CreationFlowPanel | LIVE | mixed | 55 | 16 | 2 | fonts 22–34px (Δmode 34) |
| MatchSimulatorPanel | LIVE | UIKit | 47 | 12 | 0 | low spread |
| WeighInPanel | LIVE | UIKit | 33 | 10 | 0 | low spread |
| TitleBoardPanel | LIVE | UIKit | 28 | 6 | 0 | fonts 92–92px (Δmode 92) |
| FightNightScreen | LIVE | mixed | 27 | 3 | 1 | low spread |
| SettingsBoardPanel | LIVE | UIKit | 18 | 5 | 0 | fonts 24–24px (Δmode 24) |
| DayFeedPanel | LIVE | UIKit | 17 | 11 | 0 | low spread |
| CrowningPanel | LIVE | UIKit | 14 | 4 | 0 | low spread |
| SlotsBoardPanel | LIVE | UIKit | 13 | 5 | 0 | fonts 30–30px (Δmode 30) |
| AthleteProfileShellScreen | LIVE | UIKit | 9 | 2 | 0 | low spread |
| DayFeedScreen | LIVE | hand | 3 | 0 | 0 | hand-built (0 raw nodes) |

## DEAD / TEST-ONLY / DEV (not in build order)

- **FightAnimLabScreen** — DEV: SceneRouter/dev scene (dev). built=hand, literals=8
- **FightHudPanel** — TEST-ONLY: refs: tests=1 tools=1 (no router/mount chain). built=UIKit, literals=71
- **FightWorldLiveScreen** — DEV: SceneRouter/dev scene (dev). built=hand, literals=6
- **ScorecardPanel** — TEST-ONLY: refs: tests=1 tools=1 (no router/mount chain). built=UIKit, literals=59

## Per-screen detail

### AthleteProfileShellScreen

- **Lines:** 129
- **Routing:** LIVE — routed (career)
- **Built-from:** UIKit (UIKit calls=2, hand nodes=0)
- **Literal ranges:** size_or_position n=5; vector2_component 18–700 (n=4)

### CreationFlowPanel

- **Lines:** 563
- **Routing:** LIVE — routed (creation)
- **Built-from:** mixed (UIKit calls=16, hand nodes=2)
- **Literal ranges:** button_height 62–62 (n=1); custom_minimum_size n=2; font_size_override 26–26 (n=1); size_or_position n=25; uikit_font_arg 22–34 (n=2); vector2_component 16–1920 (n=24)

### CrowningPanel

- **Lines:** 183
- **Routing:** LIVE — routed (setpiece)
- **Built-from:** UIKit (UIKit calls=4, hand nodes=0)
- **Literal ranges:** size_or_position n=8; vector2_component 20–1920 (n=6)

### DayFeedPanel

- **Lines:** 389
- **Routing:** LIVE — mount chain from routed DayFeedScreen
- **Built-from:** UIKit (UIKit calls=11, hand nodes=0)
- **Literal ranges:** size_or_position n=11; vector2_component 10–1494 (n=6)

### DayFeedScreen

- **Lines:** 56
- **Routing:** LIVE — routed (career)
- **Built-from:** hand (UIKit calls=0, hand nodes=0)
- **Literal ranges:** size_or_position n=1; vector2_component 210–402 (n=2)

### DevelopmentPanel

- **Lines:** 584
- **Routing:** LIVE — mount chain from routed AthleteProfileShellScreen
- **Built-from:** mixed (UIKit calls=45, hand nodes=1)
- **Literal ranges:** button_height 0–36 (n=2); custom_minimum_size n=2; size_or_position n=66; theme_constant:h_separation n=1; theme_constant:separation n=1; theme_constant:v_separation n=1; uikit_font_arg 20–26 (n=2); vector2_component 0–1494 (n=34)

### FightAnimLabScreen

- **Lines:** 254
- **Routing:** DEV — SceneRouter/dev scene (dev)
- **Built-from:** hand (UIKit calls=0, hand nodes=5)
- **Literal ranges:** color_rgb n=3; custom_minimum_size n=1; size_or_position n=2; vector2_component 8–8 (n=2)
- **UIKit could replace:** UIKit.button, UIKit.label/caps/display

### FightCampPanel

- **Lines:** 1027
- **Routing:** LIVE — mount chain from routed AthleteProfileShellScreen
- **Built-from:** mixed (UIKit calls=55, hand nodes=1)
- **Literal ranges:** button_height 44–46 (n=2); custom_minimum_size n=1; size_or_position n=86; uikit_font_arg 0–60 (n=7); vector2_component 4–1160 (n=48)
- **UIKit could replace:** UIKit.button

### FightContractScreen

- **Lines:** 959
- **Routing:** LIVE — ScheduleHub opens FightContractScreen.tscn
- **Built-from:** mixed (UIKit calls=41, hand nodes=6)
- **Literal ranges:** button_height 44–66 (n=4); custom_minimum_size n=7; font_size_override 18–18 (n=2); size_or_position n=42; theme_constant:separation n=5; uikit_font_arg 18–40 (n=3); vector2_component 0–1920 (n=52)

### FightHudPanel

- **Lines:** 534
- **Routing:** TEST-ONLY — refs: tests=1 tools=1 (no router/mount chain)
- **Built-from:** UIKit (UIKit calls=18, hand nodes=0)
- **Literal ranges:** size_or_position n=42; uikit_font_arg 42–42 (n=1); vector2_component 0–1920 (n=28)

### FightNightScreen

- **Lines:** 1049
- **Routing:** LIVE — routed (setpiece)
- **Built-from:** mixed (UIKit calls=3, hand nodes=1)
- **Literal ranges:** button_height 40–40 (n=1); size_or_position n=12; vector2_component 24–1920 (n=14)
- **UIKit could replace:** UIKit.frame / block

### FightResultPanel

- **Lines:** 1036
- **Routing:** LIVE — routed (setpiece)
- **Built-from:** UIKit (UIKit calls=46, hand nodes=0)
- **Literal ranges:** size_or_position n=78; uikit_font_arg 21–34 (n=4); vector2_component 0–1920 (n=64)

### FightWeekPanel

- **Lines:** 455
- **Routing:** LIVE — routed (setpiece)
- **Built-from:** UIKit (UIKit calls=25, hand nodes=0)
- **Literal ranges:** button_height 48–48 (n=1); color_rgb n=1; size_or_position n=42; uikit_font_arg 0–0 (n=1); vector2_component 0–1920 (n=32)

### FightWorldLiveScreen

- **Lines:** 2518
- **Routing:** DEV — SceneRouter/dev scene (dev)
- **Built-from:** hand (UIKit calls=0, hand nodes=1)
- **Literal ranges:** size_or_position n=6
- **UIKit could replace:** UIKit.label/caps/display

### GymHubPanel

- **Lines:** 822
- **Routing:** LIVE — routed (career)
- **Built-from:** mixed (UIKit calls=34, hand nodes=2)
- **Literal ranges:** button_height 40–40 (n=2); custom_minimum_size n=3; size_or_position n=54; theme_constant:separation n=1; uikit_font_arg 22–24 (n=2); vector2_component 0–700 (n=34)

### MatchSimulatorPanel

- **Lines:** 231
- **Routing:** LIVE — routed (career)
- **Built-from:** UIKit (UIKit calls=12, hand nodes=0)
- **Literal ranges:** button_height 42–42 (n=1); size_or_position n=22; vector2_component 0–600 (n=24)

### OfficeHubPanel

- **Lines:** 1670
- **Routing:** LIVE — routed (career)
- **Built-from:** mixed (UIKit calls=123, hand nodes=3)
- **Literal ranges:** button_height 28–38 (n=6); custom_minimum_size n=3; size_or_position n=175; theme_constant:separation n=2; uikit_font_arg 0–15 (n=4); vector2_component 0–560 (n=154)
- **UIKit could replace:** UIKit.button

### ProfileRevampPanel

- **Lines:** 3413
- **Routing:** LIVE — mount chain from routed AthleteProfileShellScreen
- **Built-from:** mixed (UIKit calls=230, hand nodes=5)
- **Literal ranges:** button_height 26–44 (n=7); color_rgb n=3; size_or_position n=387; uikit_font_arg 0–80 (n=17); vector2_component 0–1920 (n=504)
- **UIKit could replace:** UIKit.button

### RankingsHubPanel

- **Lines:** 1266
- **Routing:** LIVE — routed (career)
- **Built-from:** UIKit (UIKit calls=39, hand nodes=0)
- **Literal ranges:** button_height 34–34 (n=3); color_rgb n=2; size_or_position n=67; uikit_font_arg 15–20 (n=4); vector2_component 0–600 (n=72)

### RingStagePanel

- **Lines:** 1415
- **Routing:** LIVE — mount chain from routed FightNightScreen
- **Built-from:** mixed (UIKit calls=14, hand nodes=2)
- **Literal ranges:** button_height 34–34 (n=1); color_rgb n=7; custom_minimum_size n=2; size_or_position n=51; uikit_font_arg 22–22 (n=1); vector2_component 0.5–1920 (n=22)

### ScheduleHubPanel

- **Lines:** 2537
- **Routing:** LIVE — routed (career)
- **Built-from:** mixed (UIKit calls=130, hand nodes=5)
- **Literal ranges:** button_height 30–78 (n=11); custom_minimum_size n=8; size_or_position n=206; theme_constant:separation n=5; uikit_font_arg 0–26 (n=7); vector2_component 0–800 (n=114)

### ScorecardPanel

- **Lines:** 409
- **Routing:** TEST-ONLY — refs: tests=1 tools=1 (no router/mount chain)
- **Built-from:** UIKit (UIKit calls=16, hand nodes=0)
- **Literal ranges:** custom_minimum_size n=1; size_or_position n=36; uikit_font_arg 21–28 (n=4); vector2_component 0–1920 (n=18)

### ScoutingHubPanel

- **Lines:** 1106
- **Routing:** LIVE — routed (career)
- **Built-from:** UIKit (UIKit calls=53, hand nodes=0)
- **Literal ranges:** button_height 28–42 (n=7); size_or_position n=77; uikit_font_arg 0–20 (n=4); vector2_component 0–748 (n=58)

### SettingsBoardPanel

- **Lines:** 283
- **Routing:** LIVE — routed (boot)
- **Built-from:** UIKit (UIKit calls=5, hand nodes=0)
- **Literal ranges:** size_or_position n=9; uikit_font_arg 24–24 (n=1); vector2_component 18–1920 (n=8)

### SkillsMovesPanel

- **Lines:** 597
- **Routing:** LIVE — mount chain from routed AthleteProfileShellScreen
- **Built-from:** mixed (UIKit calls=49, hand nodes=3)
- **Literal ranges:** button_height 36–36 (n=1); color_rgb n=1; custom_minimum_size n=3; size_or_position n=54; theme_constant:h_separation n=4; theme_constant:separation n=2; theme_constant:v_separation n=4; uikit_font_arg 0–22 (n=3); vector2_component 0–1494 (n=42)
- **UIKit could replace:** UIKit.button, UIKit.raised_style / block / surface

### SlotsBoardPanel

- **Lines:** 315
- **Routing:** LIVE — routed (boot)
- **Built-from:** UIKit (UIKit calls=5, hand nodes=0)
- **Literal ranges:** size_or_position n=8; uikit_font_arg 30–30 (n=1); vector2_component 38–1920 (n=4)

### StaffHubPanel

- **Lines:** 591
- **Routing:** LIVE — routed (career)
- **Built-from:** UIKit (UIKit calls=35, hand nodes=0)
- **Literal ranges:** size_or_position n=49; uikit_font_arg 0–0 (n=3); vector2_component 0–540 (n=28)

### TitleBoardPanel

- **Lines:** 224
- **Routing:** LIVE — routed (boot)
- **Built-from:** UIKit (UIKit calls=6, hand nodes=0)
- **Literal ranges:** button_height 52–62 (n=3); size_or_position n=12; uikit_font_arg 92–92 (n=1); vector2_component 24–1920 (n=12)

### TrainingHubPanel

- **Lines:** 987
- **Routing:** LIVE — routed (career)
- **Built-from:** mixed (UIKit calls=49, hand nodes=2)
- **Literal ranges:** button_height 38–40 (n=4); custom_minimum_size n=2; size_or_position n=84; uikit_font_arg 24–26 (n=3); vector2_component 0–700 (n=54)
- **UIKit could replace:** UIKit.button, UIKit.raised_style / block / surface

### WeighInPanel

- **Lines:** 227
- **Routing:** LIVE — routed (setpiece)
- **Built-from:** UIKit (UIKit calls=10, hand nodes=0)
- **Literal ranges:** button_height 48–48 (n=1); size_or_position n=18; vector2_component 0–1920 (n=14)

## Cross-screen disagreements

- **Font sizes (UIKit args + theme overrides)** live screens use 23 distinct values (0–92 px). Examples: 0px on FightCampPanel, FightWeekPanel, OfficeHubPanel, 22px on CreationFlowPanel, FightContractScreen, GymHubPanel, 24px on GymHubPanel, ProfileRevampPanel, ProfileRevampPanel
- **Button heights (UIKit.button)** disagree: 26px → ProfileRevampPanel, ProfileRevampPanel; 28px → OfficeHubPanel, OfficeHubPanel, OfficeHubPanel, ScoutingHubPanel; 30px → ScheduleHubPanel, ScheduleHubPanel, ScheduleHubPanel, ScoutingHubPanel, ScoutingHubPanel; 32px → OfficeHubPanel, ScoutingHubPanel; 34px → RankingsHubPanel, RankingsHubPanel, RankingsHubPanel, RingStagePanel, ScheduleHubPanel, ScheduleHubPanel, ScheduleHubPanel, ScheduleHubPanel; 36px → DevelopmentPanel, OfficeHubPanel, SkillsMovesPanel; 38px → OfficeHubPanel, ScheduleHubPanel, TrainingHubPanel, TrainingHubPanel, TrainingHubPanel; 40px → FightNightScreen, GymHubPanel, GymHubPanel, ProfileRevampPanel, ProfileRevampPanel, ProfileRevampPanel, ProfileRevampPanel, ScoutingHubPanel, ScoutingHubPanel, TrainingHubPanel; 42px → MatchSimulatorPanel, ScoutingHubPanel; 44px → FightCampPanel, FightContractScreen, ProfileRevampPanel; 46px → FightCampPanel; 48px → FightWeekPanel, WeighInPanel; 50px → FightContractScreen; 52px → TitleBoardPanel, TitleBoardPanel; 56px → FightContractScreen; 62px → CreationFlowPanel, TitleBoardPanel; 66px → FightContractScreen, ScheduleHubPanel, ScheduleHubPanel; 78px → ScheduleHubPanel
- **Theme separation/margin constants** (hand screens): 0px on GymHubPanel; 4px on DevelopmentPanel, FightContractScreen, SkillsMovesPanel; 6px on DevelopmentPanel, OfficeHubPanel, ScheduleHubPanel, SkillsMovesPanel; 8px on SkillsMovesPanel
