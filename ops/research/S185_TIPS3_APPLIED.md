# S185 UI Tooltips 3 Applied (TIPS3)

Applies every row marked **uncovered** in `S184_TIPS_AUDIT2.md` (census of master `d88dbd6f`) as one
`UIKit.tip(<node>, "<the row's proposed tip>")` line, in the file and near the line the row names.
This pass edits only the nine in-scope scripts under `Godot/scripts/` plus this file. No logic,
layout, node name or test was changed; no native `tooltip_text` was set anywhere (existing native
`tooltip_text` lines are untouched - TipLayer wipes them at runtime anyway).

## Rules followed

- `UIKit.tip` is used exactly as each file already uses it (`const UIKit := preload("res://scripts/UIKit.gd")`
  at the top of all nine files; `static func tip(node: Control, spec: Variant)` at UIKit.gd L206).
- Tips are the census rows' proposed tips, verbatim: at most 12 words, starting with a verb.
- Helper-built nodes take the tip inside the helper from a new optional parameter, so every call
  site gets one: `FightCampPanel._choice_card` (L948, `tip_text: String = ""`, tip at L953),
  `FightCampPanel._lines_label` (L917, tip at L925), `FightCampPanel._plan_button` (L843, tip at
  L846 - one tip covers both `PlanSetupOpen` call sites L412 and L577),
  `CreationFlowPanel._action` (L540, `tip_text: String = ""`, tip at L552) and
  `CreationFlowPanel._tip_buttons` (L372, `tips: Dictionary = STORY_TIPS`, tip at L374).
- Dynamic rows (`Instruction_<i>`, `Day_<n>`, `Pair_*`, `Tale_*`, `Plan_<id>`, `Counter_<id>`,
  `Week_<n>`, `ShapeTile_<stat>`, `PickA`/`PickB`, `Tab_*`, `Silhouette<i>`, the 1X/2X/4X speed
  buttons, the report fact pairs and the projection figure pairs) get a tip per instance, built
  from that instance's own data (its row entry in the `pairs`/`rows`/`facts`/`DRAWER_TABS` arrays,
  or its loop variable).
- Nodes whose builder lives in `UIKit.gd` (out of scope for this task) are tipped from the call
  site in the in-scope file, by node name: the market/city cards' `Hit` buttons
  (`CreationFlowPanel._cards` L499) and the starter take's `Cash`/`Space`/`Upkeep` units and
  `Silhouette<i>` roster cards (`CreationFlowPanel._draw_take` L428/L430).
- `ProtocolCard_technical_flow` keeps its existing tip: the `_choice_card` call passes `""` for
  that protocol, so `_attach_technical_flow_tips` (L1178) still owns it.
- `FightWeekPanel.gd` has shifted about +4 lines since `d88dbd6f`; every node was found by its
  name, not its census line number. Census line numbers below are the `d88dbd6f` ones; the
  "applied at" column gives the line in the edited working tree.

## Totals

| | rows | applied | kept (already covered) |
| :--- | ---: | ---: | ---: |
| Uncovered rows applied | **117** | **117 (100%)** | - |
| Covered rows (kept) | 46 | - | 46 |
| **All census rows** | **163** | **117** | **46** |

Acceptance target was at least 100 of the 117 uncovered rows; all 117 are applied, none is `no`.

## Per-file rows

### `AthleteProfileShellScreen.gd` (1 row: 0 covered, 1 uncovered)

| census row | node | covered | applied | applied at |
| ---: | :--- | :---: | :---: | :--- |
| 96 | `Back` button "← BACK" | no | **yes** | `UIKit.tip(back, ...)` at AthleteProfileShellScreen.gd:98 |

### `FightCampPanel.gd` (57 rows: 5 covered, 52 uncovered)

| census row | node | covered | applied | applied at |
| ---: | :--- | :---: | :---: | :--- |
| 219 | `LockedCagePlate` | no | **yes** | FightCampPanel.gd:220 |
| 246 | `FocusCard_<focus>` | no | **yes** | tip arg at :247, applied inside `_choice_card` :953 |
| 266 | `ProtocolCard_<protocol>` (non-technical) | no | **yes** | tip arg at :267 (`""` for `technical_flow`), applied :953 |
| 266 | `ProtocolCard_technical_flow` | yes | kept | existing tip via `_attach_technical_flow_tips` :1178 |
| 280 | `PartnerRole_<role>` | no | **yes** | tip arg at :281, applied :953 |
| 284 | `PartnerNone` | no | **yes** | tip arg at :285, applied :953 |
| 301 | `Partner_<candidate>` | no | **yes** | tip arg at :302, applied :953 |
| 309 | `CoachNone` | no | **yes** | tip arg at :310, applied :953 |
| 315 | `Coach_<coach>` | no | **yes** | tip arg at :316, applied :953 |
| 327 | `CounterCard_<counter>` (camp setup) | no | **yes** | tip arg at :328, applied :953 |
| 339 | `CutPlanCard_<plan>` | no | **yes** | tip arg at :340, applied :953 |
| 353 | `SetupScale` | no | **yes** | FightCampPanel.gd:356 |
| 358 | scale readout "%.1f KG · LIMIT %.1f KG" | no | **yes** | tip arg at :360, applied inside `_lines_label` :925 |
| 410 | `PlanSetupOpen` "FIGHT PLAN SETUP" (call 1 of 2) | no | **yes** | tip inside `_plan_button` :846 (call site :412) |
| 411 | `StartCamp` "START CAMP" | no | **yes** | FightCampPanel.gd:415 |
| 490 | `Week_<n>` cell | no | **yes** | FightCampPanel.gd:495 |
| 567 | `CounterCard_<counter>` (camp progress) | no | **yes** | tip arg at :571, applied :953 |
| 573 | `PlanSetupOpen` "FIGHT PLAN SETUP" (call 2 of 2) | no | **yes** | tip inside `_plan_button` :846 (call site :577) |
| 575 | `LeaveCamp` "PULL OUT OF CAMP" | no | **yes** | FightCampPanel.gd:581 |
| 598 | built-so-far edge lines (`_lines_label` in `_fill_shape`) | no | **yes** | tip arg at :603, applied :925 |
| 604 | projected edge lines (`_lines_label` in `_fill_shape`) | no | **yes** | tip arg at :609, applied :925 |
| 605 | `SPENT` pair | no | **yes** | FightCampPanel.gd:611 |
| 613 | `FilmDepth` gauge | no | **yes** | FightCampPanel.gd:621 |
| 617 | film depth readout "%d OF %d" | no | **yes** | FightCampPanel.gd:625 |
| 646 | body region life gauge | no | **yes** | FightCampPanel.gd:655 |
| 656 | fatigue gauge | no | **yes** | FightCampPanel.gd:666 |
| 662 | injury line "NO INJURIES IN CAMP" / "N INJURY IN CAMP" | no | **yes** | FightCampPanel.gd:673 |
| 716 | `GradeDial` | no | **yes** | FightCampPanel.gd:729 |
| 720 | `CampGrade` letter | no | **yes** | FightCampPanel.gd:734 |
| 727 | "WEEKS RUN" pair | no | **yes** | `UIKit.tip(unit, str(fact[3]))` :748 (facts entry :740) |
| 728 | "FILM DEPTH" pair | no | **yes** | :748 (facts entry :741) |
| 729 | "FATIGUE" pair | no | **yes** | :748 (facts entry :742) |
| 730 | "INJURIES" pair | no | **yes** | :748 (facts entry :743) |
| 737 | banked summary "N% OF THE PROJECTED SHAPE WAS BANKED" | no | **yes** | tip arg at :751, applied :925 |
| 753 | built-edge line | no | **yes** | FightCampPanel.gd:768 |
| 759 | built-edge bar | no | **yes** | FightCampPanel.gd:775 |
| 762 | built-edge percent "N%" | no | **yes** | FightCampPanel.gd:779 |
| 783 | injury "WEEK n · REGION" line | no | **yes** | FightCampPanel.gd:801 |
| 788 | injury "DOWN n, READINESS n AFTER" line | no | **yes** | FightCampPanel.gd:807 |
| 881 | head subline `Line` (`_build_head`) | no | **yes** | FightCampPanel.gd:903 |
| 888 | `CampWeekRail` | no | **yes** | FightCampPanel.gd:910 |
| 1282 | `StyleLine` | no | **yes** | FightCampPanel.gd:1310 |
| 1290 | `AdjustLine` | no | **yes** | FightCampPanel.gd:1319 |
| 1299 | `WatchFilm` flat Button | no | **yes** | FightCampPanel.gd:1329 |
| 1331 | `HoverEdges` | no | **yes** | FightCampPanel.gd:1362 |
| 1362 | TIGHTNESS pair | no | **yes** | `UIKit.tip(unit, str(row[3]))` :1405 (rows entry :1392) |
| 1364 | FILM DEPTH pair | no | **yes** | :1405 (rows entry :1394) |
| 1365 | CAMP COST pair | no | **yes** | :1405 (rows entry :1395) |
| 1366 | FIGHT IQ pair | no | **yes** | :1405 (rows entry :1396) |
| 1373 | `FatigueOnTheNight` pair | yes | kept | existing tip :1403 |
| 1384 | `InjuryRisk` bar | yes | kept | existing tip :1416 |
| 1389 | `InjuryRiskRead` "N% OVER THE CAMP" label | yes | kept | existing tip :1421 |
| 1406 | delta line "LABEL from → to" | no | **yes** | FightCampPanel.gd:1439 |
| 1431 | diet weight line | no | **yes** | FightCampPanel.gd:1465 |
| 1452 | `ShapeTile_<stat>` | no | **yes** | FightCampPanel.gd:1487 |
| 1499 | `StyleAdjust` icon (`_mark_recommended`) | no | **yes** | FightCampPanel.gd:1536 |
| 1530 | `EffectTile_<stat>` | yes | kept | existing tip :1566 |

### `FightWeekPanel.gd` (21 rows: 2 covered, 19 uncovered)

| census row | node | covered | applied | applied at |
| ---: | :--- | :---: | :---: | :--- |
| 196 | `Day_<MON..SAT>` day cell | no | **yes** | FightWeekPanel.gd:203 |
| 162 | `Announcement` split card | no | **yes** | FightWeekPanel.gd:168 |
| 282 | `Pair_WEIGHT_TODAY` tile | no | **yes** | `UIKit.tip(pair, str(entry[2]))` :290 (pairs entry :268) |
| 282 | `Pair_LIMIT` tile | no | **yes** | :290 (pairs entry :269) |
| 282 | `Pair_TO_LOSE` tile | no | **yes** | :290 (pairs entry :270) |
| 282 | `Pair_CAMP_WEEKS` tile | no | **yes** | :290 (pairs entry :276) |
| 282 | `Pair_CAMP_BUILT` tile | no | **yes** | :290 (pairs entry :284) |
| 311 | `CampCard` line | no | **yes** | FightWeekPanel.gd:320 |
| 364 | `Plan_<id>` tiles | no | **yes** | FightWeekPanel.gd:377 |
| 373 | `CampSlots` line | no | **yes** | FightWeekPanel.gd:388 |
| 403 | `Tale_OPPONENT` tile | no | **yes** | `UIKit.tip(tale, str(row[3]))` :418 (rows entry :403) |
| 403 | `Tale_RECORD` tile | no | **yes** | :418 (rows entry :404) |
| 403 | `Tale_STANCE` tile | no | **yes** | :418 (rows entry :405) |
| 403 | `Tale_STYLE` tile | no | **yes** | :418 (rows entry :406) |
| 403 | `Tale_DIVISION` tile | no | **yes** | :418 (rows entry :407) |
| 403 | `Tale_OUT` tile | no | **yes** | :418 (rows entry :408) |
| 403 | `Tale_VENUE` tile | no | **yes** | :418 (rows entry :409) |
| 423 | `Tale_BOUT` tile | yes | kept | existing tip :438 |
| 437 | `Counter_<id>` tile | no | **yes** | FightWeekPanel.gd:453 |
| 488 | `PhaseStep` "To the weigh-in →" | no | **yes** | FightWeekPanel.gd:506 |
| 512 | `CutPlan_<plan>` buttons | yes | kept | `G156.icon_button` tips inside (G156Wire.gd) |

### `WeekReviewPanel.gd` (18 rows: 17 covered, 1 uncovered)

| census row | node | covered | applied | applied at |
| ---: | :--- | :---: | :---: | :--- |
| 758 | `DatePill` | yes | kept | existing tip :761 |
| 770 | `BillLine` monthly-bill strip | yes | kept | existing tip :779 |
| 785 | `upkeep` chip | yes | kept | existing tip :787 |
| 788 | `wages` chip | yes | kept | existing tip :790 |
| 814 | `NetPlate` | yes | kept | existing tip :821 |
| 825 | `StateChip` | yes | kept | existing tip :828 |
| 840 | `DeltaChip` | yes | kept | existing tip :843 |
| 844 | `Sparkline` | yes | kept | existing tip :854 |
| 875 | `Tile_income` and `Tile_costs` money tiles | yes | kept | existing tip :880 |
| 931 | `WorldChip` | yes | kept | existing tip :935 |
| 944 | `FightChip` per bout result | yes | kept | existing tip :947 |
| 990 | fighter `Name` label | yes | kept | existing tip :994 |
| 996 | `Programme` chip | yes | kept | existing tip :999 |
| 1002 | `More` chip | yes | kept | existing tip :1005 |
| 1031 | `Stat_<stat>` block | yes | kept | existing tip :1038 |
| 1086 | `Hook_<kind>` card | yes | kept | existing tip :1091 |
| 1111 | `NextWeek` button | yes | kept | existing tip :1137 |
| 980 | fighter portrait `face` | no | **yes** | WeekReviewPanel.gd:987 |

### `CornerPanel.gd` (2 rows: 0 covered, 2 uncovered)

| census row | node | covered | applied | applied at |
| ---: | :--- | :---: | :---: | :--- |
| 105 | `Skip` button "SKIP STOOL" | no | **yes** | CornerPanel.gd:107 |
| 170 | `Instruction_<i>` buttons | no | **yes** | CornerPanel.gd:172 (per instance, in `_rebuild_options`) |

### `FightNightScreen.gd` (9 rows: 2 covered, 7 uncovered)

| census row | node | covered | applied | applied at |
| ---: | :--- | :---: | :---: | :--- |
| 762 | `Back` button "←  BACK" (empty state) | no | **yes** | FightNightScreen.gd:764 |
| 1031 | `1X` speed button | no | **yes** | FightNightScreen.gd:1034 (per instance: "normal") |
| 1031 | `2X` speed button | no | **yes** | FightNightScreen.gd:1034 (per instance: "double") |
| 1031 | `4X` speed button | no | **yes** | FightNightScreen.gd:1034 (per instance: "quadruple") |
| 1037 | `SimToResult` button "SIM TO RESULT" | no | **yes** | FightNightScreen.gd:1041 |
| 1082 | `SimConfirm` skip button "SKIP" | yes | kept | existing tip :1085 |
| 1083 | `SimConfirm` keep button "KEEP WATCHING" | yes | kept | existing tip :1086 |
| 1444 | `SparResult` card | no | **yes** | FightNightScreen.gd:1448 |
| 1467 | `BackToGym` button "BACK TO THE GYM" | no | **yes** | FightNightScreen.gd:1473 |

### `CreationFlowPanel.gd` (23 rows: 8 covered, 15 uncovered)

| census row | node | covered | applied | applied at |
| ---: | :--- | :---: | :---: | :--- |
| 135 | `AbandonCareer` icon button | yes | kept | `G156.icon_button` tips inside (G156Wire.gd) |
| 205 | `Sort` "A-Z" button | no | **yes** | `SORT_TIPS` const :86-91, applied via `_tip_buttons(strip, SORT_TIPS)` :215 (tip call :374) |
| 205 | `Sort` "ECONOMY" button | no | **yes** | same :215/:374 |
| 205 | `Sort` "TALENT" button | no | **yes** | same :215/:374 |
| 205 | `Sort` "COMBAT" button | no | **yes** | same :215/:374 |
| 466 | `CountryCard_<market>` ("hit" button) | no | **yes** | CreationFlowPanel.gd:499 (in `_cards`) |
| 468 | `CityCard_<city>` ("hit" button) | no | **yes** | CreationFlowPanel.gd:499 (in `_cards`) |
| 518 | `Readout` panel | no | **yes** | CreationFlowPanel.gd:543 (in `_action`) |
| 221 | `GoldAction` "CHOOSE MARKET" | no | **yes** | tip arg at :228, applied inside `_action` :552 |
| 254 | `GoldAction` "ENTER CITY" | no | **yes** | tip arg at :261, applied :552 |
| 275 | `NameField` LineEdit | no | **yes** | CreationFlowPanel.gd:284 |
| 298 | `PlayerField` LineEdit | yes | kept | existing tip :320 |
| 321 | `StoryMode` "STORY ON" button | yes | kept | `_tip_buttons` :372 (STORY_TIPS) |
| 321 | `StoryMode` "BESIDE" button | yes | kept | `_tip_buttons` :372 (STORY_TIPS) |
| 321 | `StoryMode` "OFF" button | yes | kept | `_tip_buttons` :372 (STORY_TIPS) |
| 335 | `GoldAction` "OPEN GYM" | no | **yes** | tip arg at :343, applied :552 |
| 405 | `Take` "Cash" unit | no | **yes** | CreationFlowPanel.gd:428 (`take_unit_tips` :418-422, in `_draw_take`) |
| 405 | `Take` "Space" unit | no | **yes** | CreationFlowPanel.gd:428 |
| 405 | `Take` "Upkeep" unit | no | **yes** | CreationFlowPanel.gd:428 |
| 405 | `Take` "FloorCap" caption | yes | kept | tipped inside `UIKit.starter_take` (UIKit.gd, out of scope) |
| 405 | `Take` "Floor" grid | yes | kept | tipped inside `UIKit.floor_grid` (UIKit.gd, out of scope) |
| 405 | `Take` "PeopleCap" caption | yes | kept | tipped inside `UIKit.starter_take` (UIKit.gd, out of scope) |
| 405 | `Take` roster "Silhouette<i>" cards | no | **yes** | CreationFlowPanel.gd:430 (per instance, in `_draw_take`) |

### `TrainingFloorPanel.gd` (24 rows: 5 covered, 19 uncovered)

| census row | node | covered | applied | applied at |
| ---: | :--- | :---: | :---: | :--- |
| 168 | `Pin_<instance_id>` station pin | yes | kept | existing tip :188 |
| 618 | `Tab_STATIONS` side-drawer tab | no | **yes** | `UIKit.tip(tab, str((tab_value as Array)[2]))` :620 (tip text in `DRAWER_TABS` :592) |
| 618 | `Tab_SparCard` side-drawer tab | no | **yes** | :620 (per instance) |
| 618 | `Tab_EventCard` side-drawer tab | no | **yes** | :620 (per instance) |
| 618 | `Tab_StationMovePicker` side-drawer tab | no | **yes** | :620 (per instance) |
| 684 | `SpaceUsed` caps | yes | kept | existing tip :690 |
| 693 | `FloorLoad` label | yes | kept | existing tip :699 |
| 701 | `ExpandReadout` button | yes | kept | existing tip :712 |
| 725 | `StationTile_<instance>` cards | yes | kept | existing tip :736 |
| 849 | Event answer buttons (one per choice) | no | **yes** | TrainingFloorPanel.gd:852 (per instance, in `_build_event_card`) |
| 885 | `OpenNight` button | no | **yes** | TrainingFloorPanel.gd:889 |
| 900 | `WatchSpar` button "WATCH THE SPAR" | no | **yes** | TrainingFloorPanel.gd:905 |
| 907 | `CancelSpar` button "CALL IT OFF" | no | **yes** | TrainingFloorPanel.gd:913 |
| 914 | `SparContext` booking line | no | **yes** | TrainingFloorPanel.gd:921 |
| 925 | `PickA` OptionButton | no | **yes** | TrainingFloorPanel.gd:933 (per instance: "first") |
| 925 | `PickB` OptionButton | no | **yes** | TrainingFloorPanel.gd:933 (per instance: "second") |
| 933 | `PickIntensity` OptionButton | no | **yes** | TrainingFloorPanel.gd:943 |
| 941 | `BookSpar` button "BOOK THE SPAR" | no | **yes** | TrainingFloorPanel.gd:952 |
| 953 | `SparContext` picker line | no | **yes** | TrainingFloorPanel.gd:965 |
| 967 | `HireWho` line | no | **yes** | TrainingFloorPanel.gd:980 |
| 968 | `HirePartner` button "HIRE HIM FOR A DAY · $N" | no | **yes** | TrainingFloorPanel.gd:983 |
| 984 | `WatchAgain` button "WATCH IT AGAIN" | no | **yes** | TrainingFloorPanel.gd:1000 |
| 1001 | `VisitorResult` line | no | **yes** | TrainingFloorPanel.gd:1018 |
| 1009 | `SparDetail` line | no | **yes** | TrainingFloorPanel.gd:1028 |

### `ShellChrome.gd` (top bar, 8 rows: 7 covered, 1 uncovered)

| census row | node | covered | applied | applied at |
| ---: | :--- | :---: | :---: | :--- |
| 522 | `Back` button "← BACK" | yes | kept | existing tip :212 |
| 523 | `Handbook` button | yes | kept | existing tip :242 |
| 659 | `Nav_<module>` icon buttons | yes | kept | existing tips :405/:407/:672 |
| 554 | `Cash` chip | yes | kept | existing tips :574/:594 |
| 541 | `ContinueUnit` date plate | yes | kept | existing tip :544 |
| 810 | `Continue` button inside ContinueUnit | no | **yes** | ShellChrome.gd:814 (in `_date_plate`) |
| 594 | `Bell` news button | yes | kept | existing tip :601 |
| 709 | `Options` gear button | yes | kept | existing tip :725 |

## Checks run

- Every one of the 117 uncovered census rows has a `UIKit.tip` call on the row's node (or inside
  the helper that builds it), carrying the row's proposed tip verbatim: 117/117 applied, 0 `no`.
- Every applied tip is at most 12 words and starts with a verb (the census rows' proposed tips;
  the two built from a loop variable - the 1X/2X/4X speed buttons and `PickA`/`PickB` - render to
  the census rows' exact proposed tips).
- No native `tooltip_text` was set or removed anywhere (`git diff` adds no `tooltip_text` line).
- No node name, signal connection, position, size, logic or test file changed; the only structural
  edits are the optional helper parameters listed above and turning four chained
  `_label(...).name = "X"` one-liners into a named variable plus the same `.name` assignment plus
  the tip line (same node, same name, same creation order).
- Parse gate: all nine changed `.gd` files pass a GDScript grammar parse (the CI gate is
  `godot --headless --check-only` via `Godot/tools/check_scripts.py` on every changed `.gd` in
  `.github/workflows/ci.yml`; no Godot binary is reachable from this sandbox, so the gate was
  run with the gdtoolkit GDScript grammar parser, which passes all nine files before and after
  the change).
- `git diff` touches only the nine in-scope scripts plus this file.
