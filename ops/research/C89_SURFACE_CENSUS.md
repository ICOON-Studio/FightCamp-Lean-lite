# C89 surface census

## 1. Per-file table

Method: the census is against committed `HEAD`. The raw search was `(block|surface|frame|track|raised_style|modal)[[:space:]]*\\(` across `Godot/scripts/*.gd`, which returned **390** matching lines. The filtered search used only `(UIKit|K)\\.(block|surface|frame|track|raised_style|modal)[[:space:]]*\\(`, plus `UIKit.gd` calls where the factory begins an expression (assignment, return, argument, or parenthesised expression). Factory declarations, comments, suffix names such as `_build_block(`, and other unqualified names were excluded. Filtered count: **309** call sites. Ties below are sorted by script name.

| script | block | surface | frame | track | raised_style | modal | TOTAL |
|---|---:|---:|---:|---:|---:|---:|---:|
| UIKit.gd | 137 | 0 | 0 | 13 | 8 | 0 | 158 |
| ProfileRevampPanel.gd | 23 | 2 | 1 | 0 | 0 | 2 | 28 |
| ScheduleHubPanel.gd | 13 | 0 | 2 | 0 | 0 | 0 | 15 |
| OfficeHubPanel.gd | 14 | 0 | 0 | 0 | 0 | 0 | 14 |
| FightContractScreen.gd | 0 | 0 | 6 | 0 | 6 | 0 | 12 |
| FightCampPanel.gd | 3 | 0 | 6 | 0 | 1 | 0 | 10 |
| FightResultPanel.gd | 10 | 0 | 0 | 0 | 0 | 0 | 10 |
| RankingsHubPanel.gd | 8 | 0 | 0 | 0 | 0 | 0 | 8 |
| ScorecardPanel.gd | 7 | 0 | 0 | 0 | 0 | 0 | 7 |
| DevelopmentPanel.gd | 0 | 0 | 5 | 0 | 0 | 0 | 5 |
| SkillsMovesPanel.gd | 1 | 0 | 4 | 0 | 0 | 0 | 5 |
| TrainingHubPanel.gd | 5 | 0 | 0 | 0 | 0 | 0 | 5 |
| FightWeekPanel.gd | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| GymHubPanel.gd | 3 | 0 | 0 | 0 | 0 | 0 | 3 |
| PromotionsBoard.gd | 3 | 0 | 0 | 0 | 0 | 0 | 3 |
| ScoutingHubPanel.gd | 2 | 0 | 1 | 0 | 0 | 0 | 3 |
| ShellChrome.gd | 3 | 0 | 0 | 0 | 0 | 0 | 3 |
| StaffHubPanel.gd | 3 | 0 | 0 | 0 | 0 | 0 | 3 |
| CreationFlowPanel.gd | 0 | 0 | 0 | 0 | 2 | 0 | 2 |
| DayFeedPanel.gd | 0 | 0 | 2 | 0 | 0 | 0 | 2 |
| FightHudPanel.gd | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| MatchSimulatorPanel.gd | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| FeedbackOverlay.gd | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| RingStagePanel.gd | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| SettingsBoardPanel.gd | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| UIKitGallery.gd | 0 | 0 | 1 | 0 | 0 | 0 | 1 |
| WeighInPanel.gd | 1 | 0 | 0 | 0 | 0 | 0 | 1 |

## 2. Per-call-site table for the top ten files

### UIKit.gd
| script:line | factory | size argument as written | colour argument as written | tier argument if any |
|---|---|---|---|---|
| UIKit.gd:111 | raised_style | — | bg | level |
| UIKit.gd:121 | block | size | bg | level |
| UIKit.gd:209 | block | size | bg | T.RESTING |
| UIKit.gd:241 | block | Vector2(width - value_width, height) | label_bg | T.RESTING |
| UIKit.gd:249 | block | Vector2(value_width, height) | value_bg | T.RESTING |
| UIKit.gd:396 | raised_style | — | bg | T.LIFTED |
| UIKit.gd:560 | block | size | bg | T.RESTING |
| UIKit.gd:615 | block | Vector2(width, 34.0) | bg | T.LIFTED |
| UIKit.gd:642 | raised_style | — | T.PANEL_GLASS | — |
| UIKit.gd:667 | block | Vector2(width - label_width + 6.0, 36.0) | Color(0.0, 0.0, 0.0, 0.25) | — |
| UIKit.gd:692 | block | Vector2(loz_width, 44.0) | T.PANEL_HI | — |
| UIKit.gd:757 | block | Vector2(date_width, height) | ladder["mid"] | — |
| UIKit.gd:798 | block | Vector2(cell_w, 46.0) | T.DAY_TODAY if today else T.DAY | — |
| UIKit.gd:977 | block | size | Color("#12141b") | T.HERO |
| UIKit.gd:1081 | block | size | bg | — |
| UIKit.gd:1094 | block | Vector2(slot_size, slot_size) | T.RING | — |
| UIKit.gd:1128 | block | Vector2(size.x - text_x - 10.0, 4.0) | T.DAY | — |
| UIKit.gd:1132 | block | Vector2(maxf(4.0, track.size.x * clampf(progress, 0.0, 1.0)), 4.0) | T.AMBER | — |
| UIKit.gd:1262 | block | Vector2(size, size) | bg | — |
| UIKit.gd:1285 | block | Vector2(width + 6.0, height + 6.0) | T.EDGE | — |
| UIKit.gd:1322 | block | Vector2(width, 96.0) | T.PANEL | — |
| UIKit.gd:1443 | track | Vector2(track_w, 14.0) | — | — |
| UIKit.gd:1449 | block | Vector2(ceiling_w, 14.0) | Color(T.GOLD.r, T.GOLD.g, T.GOLD.b, 0.2) | — |
| UIKit.gd:1454 | block | Vector2(base_w, 14.0) | T.gym_ladder(gym)["hi"] | — |
| UIKit.gd:1458 | block | Vector2(4.0, 24.0) | T.BAD if below else T.GOOD | — |
| UIKit.gd:1475 | block | Vector2(36.0, 26.0) | T.grade_color(grade) | — |
| UIKit.gd:1677 | track | Vector2(width, height) | — | — |
| UIKit.gd:1688 | block | Vector2(maxf(1.0, w - 1.0), height) | color | — |
| UIKit.gd:1733 | track | Vector2(width, 12.0) | — | — |
| UIKit.gd:1739 | block | Vector2(left_w, 12.0) | ladder["hi"] | — |
| UIKit.gd:1743 | block | Vector2(width - left_w, 12.0) | T.SLATE | — |
| UIKit.gd:1747 | block | Vector2(2.0, 20.0) | T.TEXT | — |
| UIKit.gd:1865 | block | Vector2(width, row_h - 2.0) | bg | — |
| UIKit.gd:1905 | block | Vector2(width, 2.0) | T.LINE_SOFT | — |
| UIKit.gd:1943 | block | Vector2(w, 3.0) | ladder_colors["hi"] | — |
| UIKit.gd:1975 | block | Vector2(4.0, row_h - 6.0) | color | — |
| UIKit.gd:2021 | raised_style | — | T.PANEL | T.HERO |
| UIKit.gd:2102 | block | Vector2(width, h) | T.PANEL_HI if selected else T.PANEL_LO | — |
| UIKit.gd:2109 | block | Vector2(4.0, h - 12.0) | ladder["hi"] | — |
| UIKit.gd:2282 | block | size | Color(color.r, color.g, color.b, 0.2 if not id.is_empty() else 0.0) | — |
| UIKit.gd:2356 | block | Vector2(width, 1.0) | T.LINE_SOFT | — |
| UIKit.gd:2420 | block | size | T.PANEL_HI if selected else T.PANEL | — |
| UIKit.gd:2513 | track | Vector2(cell - 4.0, cell - 4.0) | — | — |
| UIKit.gd:2553 | raised_style | — | T.PANEL | — |
| UIKit.gd:2585 | block | Vector2(width, 1.0) | T.LINE_SOFT | — |
| UIKit.gd:2703 | block | size | bg | — |
| UIKit.gd:2751 | block | Vector2(size.x - 8.0, 2.0) | T.GOLD | — |
| UIKit.gd:2806 | block | Vector2(width, h) | T.PANEL_HI if selected else T.PANEL_LO | — |
| UIKit.gd:2949 | track | Vector2(track_w, 10.0) | — | — |
| UIKit.gd:2955 | block | Vector2(maxf(base_w, 1.0), 8.0) | T.SLATE | — |
| UIKit.gd:2962 | block | Vector2(maxf(span, 2.0), 8.0) | color | — |
| UIKit.gd:2990 | raised_style | — | T.PANEL | — |
| UIKit.gd:3043 | block | Vector2(cell_w, 34.0) | bg | — |
| UIKit.gd:3178 | track | Vector2(width, 17.0) | — | — |
| UIKit.gd:3181 | block | Vector2(3.0, 17.0) | color | — |
| UIKit.gd:3209 | block | size | ground | — |
| UIKit.gd:3344 | block | Vector2(width, height) | T.PANEL_HI if selected else T.PANEL_LO | — |
| UIKit.gd:3352 | block | Vector2(3.0, height) | ladder["hi"] | — |
| UIKit.gd:3442 | block | Vector2(width, height) | T.PANEL_HI if selected else T.PANEL_LO | — |
| UIKit.gd:3450 | block | Vector2(3.0, height) | T.GOLD | — |
| UIKit.gd:3592 | block | size | dress[0] | — |
| UIKit.gd:3677 | block | Vector2(16.0, 10.0) | ladder["mid"] if spent else T.TRACK | — |
| UIKit.gd:3698 | block | Vector2(width, 76.0) | T.PANEL_LO | — |
| UIKit.gd:3700 | block | Vector2(3.0, 76.0) | T.gym_ladder(gym)["mid"] | — |
| UIKit.gd:3731 | block | Vector2(width, 60.0) | Color(T.BAD.r, T.BAD.g, T.BAD.b, 0.16) | — |
| UIKit.gd:3758 | block | Vector2(width, height) | T.PANEL_HI if selected else T.PANEL_LO | — |
| UIKit.gd:3855 | block | Vector2(width, height) | T.PANEL_LO | — |
| UIKit.gd:3868 | track | Vector2(width - 28.0, 84.0) | — | — |
| UIKit.gd:3878 | block | Vector2((width - 28.0) * 0.42, 3.0) | T.GOLD | — |
| UIKit.gd:4026 | block | Vector2(width, h) | T.PANEL_HI if selected else T.PANEL_LO | — |
| UIKit.gd:4034 | block | Vector2(4.0, h - 12.0) | ladder["hi"] | — |
| UIKit.gd:4159 | block | Vector2(width, height) | T.PANEL_LO | — |
| UIKit.gd:4215 | track | Vector2(bar_w, 10.0) | — | — |
| UIKit.gd:4221 | block | Vector2(filled, 10.0) | fill | — |
| UIKit.gd:4235 | block | Vector2(width, height) | T.PANEL_LO | — |
| UIKit.gd:4248 | track | Vector2(track_w, 12.0) | — | — |
| UIKit.gd:4254 | block | Vector2(track_w * clampf(float(floor_value) / top, 0.0, 1.0), 12.0) | Color(T.BAD.r, T.BAD.g, T.BAD.b, 0.3) | — |
| UIKit.gd:4259 | block | Vector2(track_w * clampf(float(offered) / top, 0.0, 1.0), 12.0) | T.gym_ladder(gym)["hi"] | — |
| UIKit.gd:4263 | block | Vector2(3.0, 26.0) | T.AMBER | — |
| UIKit.gd:4314 | raised_style | — | T.PANEL | — |
| UIKit.gd:4386 | block | Vector2(width, h) | T.PANEL | — |
| UIKit.gd:4421 | block | Vector2(380.0, 1.0) | T.LINE_SOFT | — |
| UIKit.gd:4445 | block | Vector2(width - 442.0, 92.0) | T.PANEL_LO | — |
| UIKit.gd:4465 | block | Vector2(width - 442.0, 92.0) | T.PANEL_LO | — |
| UIKit.gd:4499 | block | Vector2(width, h) | T.PANEL_HI if selected else T.PANEL_LO | — |
| UIKit.gd:4559 | block | Vector2(width, h) | T.PANEL_LO | — |
| UIKit.gd:4629 | block | Vector2(width, h) | T.PANEL_HI if selected else T.PANEL_LO | — |
| UIKit.gd:4748 | block | Vector2(width, h) | T.PANEL | — |
| UIKit.gd:4762 | block | Vector2(width - 32.0, 84.0) | T.PANEL_LO | — |
| UIKit.gd:4803 | block | Vector2(width - 32.0, 84.0) | T.PANEL_LO | — |
| UIKit.gd:4878 | block | size | T.PANEL_LO | — |
| UIKit.gd:4880 | block | Vector2(3.0, size.y) | ladder["mid"] | — |
| UIKit.gd:4940 | track | Vector2(width, 94.0) | — | — |
| UIKit.gd:5011 | block | Vector2(size.x, SETPIECE_BAND) | T.GROUND_2 | — |
| UIKit.gd:5028 | block | Vector2(size.x, 2.0) | T.LINE_SOFT | — |
| UIKit.gd:5033 | block | Vector2(size.x, SETPIECE_FOOT) | T.GROUND_2 | — |
| UIKit.gd:5060 | block | Vector2(width, height) | T.PANEL_LO | — |
| UIKit.gd:5098 | block | Vector2(width, height) | T.PANEL | — |
| UIKit.gd:5100 | block | Vector2(3.0, height) | ladder["mid"] | — |
| UIKit.gd:5165 | block | Vector2(width, height) | T.PANEL | — |
| UIKit.gd:5182 | block | Vector2(width - 36.0, 2.0) | ladder["mid"] | — |
| UIKit.gd:5225 | block | Vector2(width, height) | T.PANEL_LO | — |
| UIKit.gd:5233 | block | Vector2(cell, height - 10.0) | ladder["mid"] if left > right else T.SLATE | — |
| UIKit.gd:5240 | block | Vector2(cell, height - 10.0) | ladder["mid"] if right > left else T.SLATE | — |
| UIKit.gd:5266 | block | Vector2(width, height) | T.PANEL | — |
| UIKit.gd:5295 | block | Vector2(width - 36.0, 2.0) | T.LINE_SOFT | — |
| UIKit.gd:5319 | block | size | T.PANEL | — |
| UIKit.gd:5328 | track | plate_size | — | — |
| UIKit.gd:5347 | block | Vector2(plate_size.x * 0.46, 3.0) | T.GOLD | — |
| UIKit.gd:5384 | block | Vector2(150.0, 300.0) | T.PANEL_LO | — |
| UIKit.gd:5407 | block | Vector2(maxf(size.x * travelled, 1.0), size.y) | T.GROUND | — |
| UIKit.gd:5410 | block | Vector2(maxf(size.x * travelled * 0.18, 1.0), 3.0) | T.GOLD | — |
| UIKit.gd:5489 | block | Vector2(size.x, BOOT_BRAND) | T.GROUND_2 | — |
| UIKit.gd:5494 | block | Vector2(54.0, 54.0) | ladder["mid"] | — |
| UIKit.gd:5543 | block | Vector2(size.x, 2.0) | T.LINE_SOFT | — |
| UIKit.gd:5549 | block | Vector2(size.x, BOOT_FOOT) | T.GROUND_2 | — |
| UIKit.gd:5582 | block | Vector2(width, height) | T.PANEL if selected else T.PANEL_LO | — |
| UIKit.gd:5589 | block | Vector2(4.0, height) | ladder["mid"] | — |
| UIKit.gd:5761 | block | Vector2(label_width, 44.0) | T.SLATE | — |
| UIKit.gd:5775 | track | Vector2(track_width, 22.0) | — | — |
| UIKit.gd:5779 | block | Vector2(maxf(track_width * float(value) / 100.0, 2.0), 22.0) | ladder["mid"] | — |
| UIKit.gd:5849 | raised_style | — | T.PANEL | — |
| UIKit.gd:5894 | block | Vector2(maxf(size.x * travelled, 1.0), size.y) | T.GROUND | — |
| UIKit.gd:5897 | block | Vector2(maxf(size.x * travelled * 0.18, 1.0), 3.0) | T.GOLD | — |
| UIKit.gd:5988 | block | Vector2(width, h) | T.PANEL_HI if selected else T.PANEL_LO | — |
| UIKit.gd:6128 | block | Vector2(width, h) | T.PANEL_HI if selected else T.PANEL_LO | — |
| UIKit.gd:6169 | block | Vector2(width, 34.0) | T.PANEL_LO | — |
| UIKit.gd:6248 | block | Vector2(size.x, CREATION_BRAND) | T.GROUND_2 | — |
| UIKit.gd:6253 | block | Vector2(54.0, 54.0) | ladder["mid"] | — |
| UIKit.gd:6303 | block | Vector2(size.x, 2.0) | T.LINE_SOFT | — |
| UIKit.gd:6311 | block | Vector2(size.x, CREATION_STEPS) | T.GROUND | — |
| UIKit.gd:6322 | block | Vector2(size.x, CREATION_FOOT) | T.GROUND_2 | — |
| UIKit.gd:6363 | block | Vector2(26.0, 26.0) | box_bg | — |
| UIKit.gd:6431 | block | Vector2(float(pill_spec.get("width", 0.0)), 30.0) | T.CHIP | — |
| UIKit.gd:6464 | block | Vector2(width, height) | T.PANEL_HI if selected else T.PANEL_LO | — |
| UIKit.gd:6559 | block | Vector2(width, height) | T.PANEL_HI if selected else T.PANEL_LO | — |
| UIKit.gd:6649 | block | Vector2(230.0, 72.0) | T.PANEL_LO | — |
| UIKit.gd:6729 | block | Vector2(width, 50.0) | T.PANEL_LO | — |
| UIKit.gd:6781 | block | size | T.GROUND | — |
| UIKit.gd:6786 | block | Vector2(maxf(96.0 * travelled, 1.0), size.y) | T.GROUND_2 | — |
| UIKit.gd:6789 | block | Vector2(maxf(size.x * travelled, 1.0), 72.0) | T.GROUND_2 | — |
| UIKit.gd:6792 | block | Vector2(maxf(size.x * travelled * 0.18, 1.0), 3.0) | T.GOLD | — |
| UIKit.gd:6848 | block | size | T.GROUND | — |
| UIKit.gd:6896 | block | Vector2(width, h) | T.PANEL_GLASS | — |
| UIKit.gd:6948 | block | Vector2(width, h) | T.PANEL_LO | — |
| UIKit.gd:6978 | block | Vector2(width, h) | T.PANEL_GLASS | — |
| UIKit.gd:6981 | block | Vector2(5.0, h) | T.SLATE if watching else ladder["hi"] | — |
| UIKit.gd:7060 | block | Vector2(width, h) | T.PANEL_HI | — |
| UIKit.gd:7096 | track | Vector2(250.0, 12.0) | — | — |
| UIKit.gd:7100 | block | Vector2(maxf(250.0 * (left / total), 1.0), 12.0) | T.BAD if left <= total * 0.34 else (T.AMBER if left <= total * 0.67 else ladder["hi"]) | — |
| UIKit.gd:7130 | block | Vector2(width, h) | T.PANEL_HI | — |
| UIKit.gd:7217 | block | Vector2(width, height) | T.PANEL | — |
| UIKit.gd:7221 | block | Vector2(4.0, height) | band | — |
| UIKit.gd:7235 | block | Vector2(8.0, 8.0) | ink | — |
| UIKit.gd:7282 | block | Vector2(width, 54.0) | T.PANEL if featured else T.PANEL_LO | — |
| UIKit.gd:7320 | block | Vector2(width, height) | ladder["lo"] | — |
| UIKit.gd:7322 | block | Vector2(width, 3.0) | T.GOLD | — |
| UIKit.gd:7369 | block | Vector2(width, height) | T.PANEL_LO | — |

### ProfileRevampPanel.gd
| script:line | factory | size argument as written | colour argument as written | tier argument if any |
|---|---|---|---|---|
| ProfileRevampPanel.gd:346 | surface | Vector2(WIDTH, HERO_H) | T.PANEL_GLASS | T.HERO |
| ProfileRevampPanel.gd:349 | block | Vector2(6.0, HERO_H) | T.gym_ladder(gym)["hi"] | — |
| ProfileRevampPanel.gd:425 | block | plate_size | T.AVATAR | — |
| ProfileRevampPanel.gd:558 | block | card_size | T.PANEL | T.LIFTED |
| ProfileRevampPanel.gd:645 | block | Vector2(60.0, 44.0) | T.DAY_TODAY if i == today else T.DAY | — |
| ProfileRevampPanel.gd:748 | surface | Vector2(WIDTH, STRIP_H) | T.PANEL_GLASS | T.LIFTED |
| ProfileRevampPanel.gd:751 | block | Vector2(6.0, STRIP_H) | T.gym_ladder(gym)["hi"] | — |
| ProfileRevampPanel.gd:846 | frame | frame_size | gym | — |
| ProfileRevampPanel.gd:954 | block | Vector2(12.0, 12.0) | swatch[0] | — |
| ProfileRevampPanel.gd:1309 | block | Vector2(446.0, plate_h) | T.TRACK | — |
| ProfileRevampPanel.gd:1313 | block | Vector2(3.0, plate_h) | T.LINK | — |
| ProfileRevampPanel.gd:1552 | block | Vector2(cell_w, cells_h) | T.PANEL_LO | — |
| ProfileRevampPanel.gd:1746 | block | Vector2(b.size.x, row_h - 4.0) | T.PANEL_HI if i % 2 == 0 else T.PANEL | — |
| ProfileRevampPanel.gd:1878 | modal | Vector2(760.0, sheet_h) | gym | — |
| ProfileRevampPanel.gd:1881 | block | Vector2(760.0, 72.0) | fill | — |
| ProfileRevampPanel.gd:2204 | modal | Vector2(760.0, 460.0) | gym | — |
| ProfileRevampPanel.gd:2233 | block | Vector2(712.0, 56.0) | T.PANEL_HI if i % 2 == 0 else T.PANEL | — |
| ProfileRevampPanel.gd:2308 | block | badge_size | fill | — |
| ProfileRevampPanel.gd:2582 | block | Vector2(2.0, 18.0) | T.LINK | — |
| ProfileRevampPanel.gd:2609 | block | Vector2(REGION_BAR_W, 5.0) | T.TRACK | — |
| ProfileRevampPanel.gd:2615 | block | Vector2(REGION_BAR_W, 1.0) | T.LINE_SOFT | — |
| ProfileRevampPanel.gd:2619 | block | Vector2(3.0, 4.0) | T.DIM | — |
| ProfileRevampPanel.gd:2644 | block | Vector2(716.0, 48.0) | banner_fill | — |
| ProfileRevampPanel.gd:2827 | block | Vector2(716.0, 40.0) | T.PANEL_HI if i % 2 == 0 else T.PANEL | — |
| ProfileRevampPanel.gd:2909 | block | Vector2(712.0, 40.0) | T.PANEL_HI if i % 2 == 0 else T.PANEL | — |
| ProfileRevampPanel.gd:2960 | block | Vector2(712.0, 44.0) | T.PANEL_HI if shown % 2 == 0 else T.PANEL | — |
| ProfileRevampPanel.gd:3010 | block | Vector2(716.0, 52.0) | T.DAY_TODAY if i == today else (T.PANEL_HI if i % 2 == 0 else T.PANEL) | — |
| ProfileRevampPanel.gd:3124 | block | plate_size | T.PANEL_LO | — |

### ScheduleHubPanel.gd
| script:line | factory | size argument as written | colour argument as written | tier argument if any |
|---|---|---|---|---|
| ScheduleHubPanel.gd:437 | block | Vector2(739.0, 170.0) | T.PANEL | — |
| ScheduleHubPanel.gd:482 | block | pill_size | T.PANEL_HI | — |
| ScheduleHubPanel.gd:580 | block | Vector2(list_w, minf(240.0, height)) | T.PANEL_LO | — |
| ScheduleHubPanel.gd:588 | block | Vector2(72.0, 96.0) | T.AVATAR | — |
| ScheduleHubPanel.gd:660 | frame | Vector2(SIDE_W, side_h) | gym_color | — |
| ScheduleHubPanel.gd:699 | block | Vector2(SIDE_W - 28.0, 54.0) | T.PANEL_LO | — |
| ScheduleHubPanel.gd:785 | block | Vector2(table_w, 220.0) | T.PANEL_LO | — |
| ScheduleHubPanel.gd:806 | block | Vector2(table_w, 54.0) | T.PANEL | — |
| ScheduleHubPanel.gd:1057 | block | Vector2(width, 66.0) | T.PANEL_HI if selected else T.PANEL_LO | — |
| ScheduleHubPanel.gd:1187 | block | Vector2(table_w, 54.0) | T.PANEL | — |
| ScheduleHubPanel.gd:1462 | frame | Vector2(SIDE_W, tape_h) | gym_color | — |
| ScheduleHubPanel.gd:1654 | block | Vector2(SIDE_W, 200.0) | T.PANEL | — |
| ScheduleHubPanel.gd:1893 | block | Vector2(width, 66.0) | T.PANEL_HI if selected else T.PANEL_LO | — |
| ScheduleHubPanel.gd:1948 | block | Vector2(width, 78.0) | T.PANEL_HI if selected else T.PANEL_LO | — |
| ScheduleHubPanel.gd:2020 | block | Vector2(table_w, 54.0) | T.PANEL | — |

### OfficeHubPanel.gd
| script:line | factory | size argument as written | colour argument as written | tier argument if any |
|---|---|---|---|---|
| OfficeHubPanel.gd:327 | block | Vector2(LIST_W, GYM_WEEK_H) | T.PANEL_LO | — |
| OfficeHubPanel.gd:362 | block | Vector2(LIST_W - 32.0, 1.0) | T.LINE_SOFT | — |
| OfficeHubPanel.gd:400 | block | Vector2(LIST_W, 72.0) | T.PANEL_LO | — |
| OfficeHubPanel.gd:436 | block | Vector2(SIDE_W, PURSE_H) | T.PANEL | — |
| OfficeHubPanel.gd:460 | block | Vector2(SIDE_W - 32.0, 1.0) | T.LINE_SOFT | — |
| OfficeHubPanel.gd:574 | block | size | T.PANEL_HI | — |
| OfficeHubPanel.gd:668 | block | Vector2(LIST_W, 132.0) | T.PANEL_LO | — |
| OfficeHubPanel.gd:710 | block | Vector2(LIST_W, 150.0) | T.PANEL_LO | — |
| OfficeHubPanel.gd:799 | block | Vector2(SIDE_W, height) | T.PANEL | — |
| OfficeHubPanel.gd:915 | block | Vector2(LIST_W, 220.0 if not bool(_week_ledger.get("empty", true)) else 96.0) | T.PANEL_LO | — |
| OfficeHubPanel.gd:979 | block | Vector2(SIDE_W, 300.0) | T.PANEL | — |
| OfficeHubPanel.gd:1004 | block | Vector2(SIDE_W, 150.0) | T.PANEL | — |
| OfficeHubPanel.gd:1125 | block | Vector2(SIDE_W, 200.0) | T.PANEL | — |
| OfficeHubPanel.gd:1276 | block | Vector2(LIST_W - 16.0, 112.0) | T.PANEL | — |

### FightContractScreen.gd
| script:line | factory | size argument as written | colour argument as written | tier argument if any |
|---|---|---|---|---|
| FightContractScreen.gd:253 | frame | Vector2(LEFT_W, LEFT_H) | gym_color | — |
| FightContractScreen.gd:306 | frame | Vector2(RIGHT_W, 286.0) | gym_color | — |
| FightContractScreen.gd:367 | frame | Vector2(RIGHT_W, 180.0) | gym_color | — |
| FightContractScreen.gd:400 | frame | Vector2(RIGHT_W, 254.0) | gym_color | — |
| FightContractScreen.gd:440 | frame | Vector2(RIGHT_W, 150.0) | gym_color | — |
| FightContractScreen.gd:602 | frame | Vector2(1400.0, 880.0) | gym_color | — |
| FightContractScreen.gd:905 | raised_style | — | T.CONTROL | — |
| FightContractScreen.gd:906 | raised_style | — | T.CONTROL_HI | — |
| FightContractScreen.gd:936 | raised_style | — | fill | — |
| FightContractScreen.gd:937 | raised_style | — | hover | — |
| FightContractScreen.gd:938 | raised_style | — | fill.darkened(0.12) | — |
| FightContractScreen.gd:945 | raised_style | — | T.PANEL_LO | — |

### FightCampPanel.gd
| script:line | factory | size argument as written | colour argument as written | tier argument if any |
|---|---|---|---|---|
| FightCampPanel.gd:323 | frame | Vector2(RIGHT_W, 730.0) | gym | — |
| FightCampPanel.gd:494 | block | Vector2(week_w, 116.0) | T.PANEL if passed else T.PANEL_LO | — |
| FightCampPanel.gd:540 | frame | Vector2(470.0, frame_h) | gym | — |
| FightCampPanel.gd:547 | frame | Vector2(490.0, frame_h) | gym | — |
| FightCampPanel.gd:554 | frame | Vector2(470.0, frame_h) | gym | — |
| FightCampPanel.gd:743 | frame | Vector2(800.0, card_h) | gym | — |
| FightCampPanel.gd:773 | frame | Vector2(326.0, card_h) | gym | — |
| FightCampPanel.gd:826 | block | Vector2(WIDTH, HEAD_H) | T.PANEL_GLASS | — |
| FightCampPanel.gd:831 | block | Vector2(6.0, HEAD_H) | head_edge | — |
| FightCampPanel.gd:892 | raised_style | — | T.PANEL_HI if picked else T.PANEL | — |

### FightResultPanel.gd
| script:line | factory | size argument as written | colour argument as written | tier argument if any |
|---|---|---|---|---|
| FightResultPanel.gd:232 | block | Vector2(VERDICT_W, 60.0) | T.PANEL_LO | — |
| FightResultPanel.gd:392 | block | Vector2(VERDICT_W, row_h) | warm if is_swing else quiet | — |
| FightResultPanel.gd:442 | block | Vector2(VERDICT_W, 34.0) | T.PANEL | — |
| FightResultPanel.gd:480 | block | Vector2(CELL_W, row_h - 8.0) | ladder["mid"] if won else T.SLATE | — |
| FightResultPanel.gd:523 | block | Vector2(SIDE_W, 86.0) | T.PANEL_LO | — |
| FightResultPanel.gd:564 | block | Vector2(SIDE_W, height) | T.PANEL | — |
| FightResultPanel.gd:661 | block | Vector2(SIDE_W, height) | T.PANEL | — |
| FightResultPanel.gd:760 | block | Vector2(SIDE_W, 40.0) | T.PANEL_LO | — |
| FightResultPanel.gd:784 | block | Vector2(minf(8.0, width - x), 1.0) | Color(tint.r, tint.g, tint.b, 0.55) | — |
| FightResultPanel.gd:792 | block | Vector2(180.0, 440.0) | T.PANEL_LO | — |

### RankingsHubPanel.gd
| script:line | factory | size argument as written | colour argument as written | tier argument if any |
|---|---|---|---|---|
| RankingsHubPanel.gd:745 | block | Vector2(LIST_W, BELT_ENTRY_H) | T.PANEL_HI if selected else T.PANEL_LO | — |
| RankingsHubPanel.gd:752 | block | Vector2(3.0, BELT_ENTRY_H) | gym_color | — |
| RankingsHubPanel.gd:818 | block | Vector2(12.0, 8.0) | strap_tone | — |
| RankingsHubPanel.gd:823 | block | Vector2(12.0, 8.0) | strap_tone | — |
| RankingsHubPanel.gd:833 | block | Vector2(28.0, 28.0) | plate_fill | — |
| RankingsHubPanel.gd:849 | block | Vector2(3.0, 3.0) | tone | — |
| RankingsHubPanel.gd:863 | block | Vector2(150.0, 22.0) | T.TRACK | — |
| RankingsHubPanel.gd:868 | block | Vector2(3.0, 22.0) | tone | — |

### ScorecardPanel.gd
| script:line | factory | size argument as written | colour argument as written | tier argument if any |
|---|---|---|---|---|
| ScorecardPanel.gd:143 | block | Vector2(grid_w, HEAD_H) | T.PANEL_LO | — |
| ScorecardPanel.gd:165 | block | Vector2(CELL_W - 12.0, 2.0) | T.AMBER | — |
| ScorecardPanel.gd:206 | block | Vector2(grid_w, ROW_H) | quiet | — |
| ScorecardPanel.gd:222 | block | Vector2(CELL_W - 4.0, ROW_H - 6.0) | T.SLATE | — |
| ScorecardPanel.gd:249 | block | Vector2(CELL_W - 4.0, RULE_H) | _corner_color(side) | — |
| ScorecardPanel.gd:268 | block | Vector2(TOTAL_W - 8.0, ROW_H - 8.0) | fill | — |
| ScorecardPanel.gd:287 | block | Vector2(host_body_size.x - PAD * 2.0, BANNER_H - 8.0) | T.PANEL | — |

### DevelopmentPanel.gd
| script:line | factory | size argument as written | colour argument as written | tier argument if any |
|---|---|---|---|---|
| DevelopmentPanel.gd:157 | frame | Vector2(LEFT_W, ARC_H) | gym | — |
| DevelopmentPanel.gd:161 | frame | Vector2(LEFT_W, DISC_H) | gym | — |
| DevelopmentPanel.gd:166 | frame | Vector2(right_w, GROWTH_H) | gym | — |
| DevelopmentPanel.gd:170 | frame | Vector2(right_w, TRAITS_H) | gym | — |
| DevelopmentPanel.gd:174 | frame | Vector2(right_w, SIZE.y - GROWTH_H - TRAITS_H - 2.0 * GAP) | gym | — |

## 3. Counts

- Total surface call sites: **309**.
- Call sites passing an explicit level/tier argument: **13** (8 `block`, 2 `surface`, 3 `raised_style`).
- Call sites passing an explicit `light` value: **246**.
