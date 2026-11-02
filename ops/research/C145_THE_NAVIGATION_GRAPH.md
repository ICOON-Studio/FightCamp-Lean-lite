# C145 — The navigation graph

Headline: **29 REACHABLE, 0 ORPHANED, 2 TEST-ONLY** (31 surfaces).

Boot entry: `Godot/scripts/BootRoot.gd`. The scan excludes each defining file, `*.uid`, and `Godot/tests/` from mounters. `Godot/tests/` is listed as test evidence only and is never treated as a player path.

## Surface table

| Surface | Lines | Role | Mounters | Parent | Children | Status | Path |
|---|---:|---|---|---|---|---|---|
| `AthleteProfileShellScreen` | 128 | ROOT | `Godot/scripts/CareerRoot.gd:36`, `Godot/scripts/SceneRouter.gd:72`, `Godot/scenes/AthleteProfileShellScreen.tscn:3` | CareerRoot | ProfileRevampPanel | **REACHABLE** | Boot → CareerRoot → AthleteProfileShellScreen |
| `CreationFlowPanel` | 562 | ROOT | `Godot/scripts/CreationRoot.gd:38` | CreationRoot | — | **REACHABLE** | Boot → CreationRoot → CreationFlowPanel |
| `CrowningPanel` | 182 | ROOT | `Godot/scripts/SetpieceRoot.gd:44` | SetpieceRoot | — | **REACHABLE** | Boot → SetpieceRoot → CrowningPanel |
| `DayFeedPanel` | 388 | CHILD | `Godot/scripts/DayFeedScreen.gd:15` | DayFeedScreen | — | **REACHABLE** | Boot → DayFeedScreen → DayFeedPanel |
| `DayFeedScreen` | 55 | ROOT | `Godot/scripts/CareerRoot.gd:35`, `Godot/scripts/CareerRoot.gd:52`, `Godot/scripts/SceneRouter.gd:65`, `Godot/scripts/SceneRouter.gd:105`, `Godot/scenes/DayFeedScreen.tscn:3` | CareerRoot | DayFeedPanel | **REACHABLE** | Boot → CareerRoot → DayFeedScreen |
| `DevelopmentPanel` | 583 | CHILD | `Godot/scripts/ProfileRevampPanel.gd:144` | ProfileRevampPanel | — | **REACHABLE** | Boot → AthleteProfileShellScreen → ProfileRevampPanel → DevelopmentPanel |
| `FightAnimLabScreen` | 253 | ROOT | `Godot/scenes/FightAnimLab.tscn:15` | — | — | **REACHABLE** | Boot → FightAnimLabScreen |
| `FightCampPanel` | 1026 | CHILD | `Godot/scripts/ProfileRevampPanel.gd:3047` | ProfileRevampPanel | — | **REACHABLE** | Boot → AthleteProfileShellScreen → ProfileRevampPanel → FightCampPanel |
| `FightContractScreen` | 958 | ROOT | `Godot/scenes/FightContractScreen.tscn:3` | — | — | **REACHABLE** | Boot → FightContractScreen |
| `FightHudPanel` | 533 | ROOT | `Godot/scripts/FightStageDirector.gd:6` | — | — | **REACHABLE** | Boot → FightWorldLiveScreen → FightHudPanel |
| `FightNightScreen` | 1048 | ROOT | `Godot/scripts/MatchSimulatorPanel.gd:205`, `Godot/scenes/FightNight.tscn:3` | MatchSimulatorPanel | FightResultPanel, RingStagePanel | **REACHABLE** | Boot → FightNightScreen |
| `FightResultPanel` | 1035 | CHILD | `Godot/scripts/SetpieceRoot.gd:43` | FightNightScreen, SetpieceRoot | — | **REACHABLE** | Boot → SetpieceRoot → FightResultPanel |
| `FightWeekPanel` | 454 | ROOT | `Godot/scripts/SetpieceRoot.gd:40` | SetpieceRoot | — | **REACHABLE** | Boot → SetpieceRoot → FightWeekPanel |
| `FightWorldLiveScreen` | 2228 | ROOT | `Godot/scenes/FightWorldLive.tscn:11` | — | — | **REACHABLE** | Boot → FightWorldLiveScreen |
| `GymHubPanel` | 821 | ROOT | `Godot/scripts/CareerRoot.gd:37`, `Godot/scripts/CareerRoot.gd:38`, `Godot/scripts/CareerRoot.gd:39`, `Godot/scripts/SceneRouter.gd:69`, `Godot/scripts/SceneRouter.gd:70`, `Godot/scripts/SceneRouter.gd:71` | CareerRoot | — | **REACHABLE** | Boot → CareerRoot → GymHubPanel |
| `JudgePanel` | 175 | ROOT | — | — | — | **TEST-ONLY** | — |
| `MatchSimulatorPanel` | 230 | ROOT | `Godot/scripts/CareerRoot.gd:53`, `Godot/scripts/SceneRouter.gd:111` | CareerRoot | FightNightScreen | **REACHABLE** | Boot → CareerRoot → MatchSimulatorPanel |
| `OfficeHubPanel` | 1669 | ROOT | `Godot/scripts/CareerRoot.gd:46`, `Godot/scripts/CareerRoot.gd:47`, `Godot/scripts/CareerRoot.gd:48`, `Godot/scripts/CareerRoot.gd:49`, `Godot/scripts/CareerRoot.gd:50`, `Godot/scripts/SceneRouter.gd:99`, `Godot/scripts/SceneRouter.gd:101`, `Godot/scripts/SceneRouter.gd:102`, `Godot/scripts/SceneRouter.gd:103`, `Godot/scripts/SceneRouter.gd:104` | CareerRoot | — | **REACHABLE** | Boot → CareerRoot → OfficeHubPanel |
| `ProfileRevampPanel` | 3399 | CHILD | `Godot/scripts/AthleteProfileShellScreen.gd:19` | AthleteProfileShellScreen | DevelopmentPanel, FightCampPanel, SkillsMovesPanel | **REACHABLE** | Boot → AthleteProfileShellScreen → ProfileRevampPanel |
| `RankingsHubPanel` | 1260 | ROOT | `Godot/scripts/CareerRoot.gd:45`, `Godot/scripts/SceneRouter.gd:88` | CareerRoot | — | **REACHABLE** | Boot → CareerRoot → RankingsHubPanel |
| `RingStagePanel` | 1414 | CHILD | `Godot/scripts/FightNightScreen.gd:378` | FightNightScreen | — | **REACHABLE** | Boot → FightNightScreen → RingStagePanel |
| `ScheduleHubPanel` | 2536 | ROOT | `Godot/scripts/CareerRoot.gd:41`, `Godot/scripts/CareerRoot.gd:42`, `Godot/scripts/CareerRoot.gd:43`, `Godot/scripts/SceneRouter.gd:78`, `Godot/scripts/SceneRouter.gd:79`, `Godot/scripts/SceneRouter.gd:80` | CareerRoot | — | **REACHABLE** | Boot → CareerRoot → ScheduleHubPanel |
| `ScorecardPanel` | 408 | ROOT | — | — | — | **TEST-ONLY** | — |
| `ScoutingHubPanel` | 1105 | ROOT | `Godot/scripts/CareerRoot.gd:44`, `Godot/scripts/SceneRouter.gd:84` | CareerRoot | — | **REACHABLE** | Boot → CareerRoot → ScoutingHubPanel |
| `SettingsBoardPanel` | 282 | ROOT | `Godot/scripts/BootRoot.gd:44` | BootRoot | — | **REACHABLE** | Boot → SettingsBoardPanel |
| `SkillsMovesPanel` | 596 | CHILD | `Godot/scripts/ProfileRevampPanel.gd:142` | ProfileRevampPanel | — | **REACHABLE** | Boot → AthleteProfileShellScreen → ProfileRevampPanel → SkillsMovesPanel |
| `SlotsBoardPanel` | 314 | ROOT | `Godot/scripts/BootRoot.gd:43` | BootRoot | — | **REACHABLE** | Boot → SlotsBoardPanel |
| `StaffHubPanel` | 590 | ROOT | `Godot/scripts/CareerRoot.gd:51`, `Godot/scripts/SceneRouter.gd:100` | CareerRoot | — | **REACHABLE** | Boot → CareerRoot → StaffHubPanel |
| `TitleBoardPanel` | 223 | ROOT | `Godot/scripts/BootRoot.gd:42` | BootRoot | — | **REACHABLE** | Boot → TitleBoardPanel |
| `TrainingHubPanel` | 986 | ROOT | `Godot/scripts/CareerRoot.gd:40`, `Godot/scripts/SceneRouter.gd:73` | CareerRoot | — | **REACHABLE** | Boot → CareerRoot → TrainingHubPanel |
| `WeighInPanel` | 226 | ROOT | `Godot/scripts/SetpieceRoot.gd:41` | SetpieceRoot | — | **REACHABLE** | Boot → SetpieceRoot → WeighInPanel |

## Hub audit

| Hub | Children mounted | Count | Status |
|---|---|---:|---|
| `GymHubPanel` | none | 0 | REACHABLE |
| `OfficeHubPanel` | none | 0 | REACHABLE |
| `RankingsHubPanel` | none | 0 | REACHABLE |
| `ScheduleHubPanel` | none | 0 | REACHABLE |
| `ScoutingHubPanel` | none | 0 | REACHABLE |
| `StaffHubPanel` | none | 0 | REACHABLE |
| `TrainingHubPanel` | none | 0 | REACHABLE |

## Presentation accounting

Surface-level presentation is **24 full-screen/root mounts, 0 modal or overlay mounts, and 7 inline child mounts** (31 total). This is based on actual root-host versus surface-child mounting evidence. The permitted C89 census reports 309 UIKit factory call sites; its table shows `UIKit.modal(` call sites only in ProfileRevampPanel.gd (2), but neither is a surface mount. Therefore C89's modal-factory count is **2** while this surface modal count is **0**; the measures answer different questions.

## Method and exclusions

Mounters are whole-repository `Godot` source references to the exact surface name, excluding the defining file, `*.uid`, and `Godot/tests/`. A surface edge is a construction/load reference in another surface file; comments and data-module calls are excluded. Reachability is the transitive closure of surface edges from route/root mount declarations reachable from BootRoot.gd; no test caller counts as player reachability. `FightHudPanel` is a sanity check: its production mounting reference is retained at `FightStageDirector.gd:6` and it is classified REACHABLE.
