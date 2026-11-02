# S184 UI Tooltips Census 2 (TIPS2)

Read-only second census of hover tooltips in nine Godot 4 GDScript panels under `Godot/scripts/`, measured against master `d88dbd6f`. This pass writes only this file. No `.gd` file, test or other repository file was edited.

## Method and rules

- **Covered** means `UIKit.tip(node, spec)` is applied to the same node, or inside the helper that builds it (for example `G156Wire.icon_button` L75 or `_icon_button` L670). Native `tooltip_text` does **not** count, so such rows are uncovered.
- **Counted** (IN): buttons and button-like cards, number or stat labels (values, %, $, grades, counts), pairs and cells that carry values, chips and badges, bars, gauges and dials, and meaningful icons. A row is one hover target.
- **Not counted** (OUT): section headings and kickers, frame titles, footnotes and prose, empty-state messages, status-only lines, decorative art, containers, and hidden nodes. The full list is in the exclusions section at the end.
- **Child labels**: a label that ignores the mouse is described under the hover target that carries the tip. `TipLayer._resolve` walks up to six ancestors, so such children show the parent's tip at runtime. A child that takes the mouse itself (a button, for example) gets its own row.
- **Glossary caveat**: `TipLayer` also explains a caption whose whole text matches a Glossary alias (`Glossary.match_text`, exact or alias plus a value). That gives a runtime explanation with no `UIKit.tip`. The house rule still counts such rows as uncovered, so the totals are strict.
- **Helper bodies outside the windows**: ShellChrome `_build_back` (L187), `_build_handbook` (L224) and `_date_plate` (L779) are defined outside the L454-741 window. Their call sites are inside it. Their bodies were checked by grep only, and that is stated in the rows.
- **Proposed tip**: at most 12 words, starts with a verb, never repeats the control's own label. Covered rows read `Keep the existing tip.`
- **Line numbers** are from master `d88dbd6f`. The working tree was clean and identical to it when read.

## Totals

| File | Lines read | Controls found | Covered | Uncovered | Coverage |
| :--- | :--- | :---: | :---: | :---: | :---: |
| `AthleteProfileShellScreen.gd` | 1-130 | 1 | 0 | 1 | 0.0% |
| `FightCampPanel.gd` | 1-1715 | 57 | 5 | 52 | 8.8% |
| `FightWeekPanel.gd` | 1-585 | 21 | 2 | 19 | 9.5% |
| `WeekReviewPanel.gd` | 1-1344 | 18 | 17 | 1 | 94.4% |
| `CornerPanel.gd` | 1-301 | 2 | 0 | 2 | 0.0% |
| `FightNightScreen.gd` | 1-1867 | 9 | 2 | 7 | 22.2% |
| `CreationFlowPanel.gd` | 1-675 | 23 | 8 | 15 | 34.8% |
| `TrainingFloorPanel.gd` | 1-1193 | 24 | 5 | 19 | 20.8% |
| `ShellChrome.gd (top bar only)` | 454-741 | 8 | 7 | 1 | 87.5% |
| **TOTAL** | 9 files | **163** | **46** | **117** | **28.2%** |

`Controls found` counts rows, one row per hover target. Dynamic lists (for example `Pin_<id>`, `CutPlan_<plan>`, `Instruction_<i>`, `Week_<n>`) count as one row, so the totals undercount their instances; the rows say what each covers.

## The 10 worst

These are uncovered actions or key readouts that change what the player decides, with no tooltip at the entry point:

1. **`CornerPanel.gd:170` — `Instruction_<i>` buttons ("SAY" options)**: each in-round corner instruction changes the fight and has no tooltip.
2. **`FightWeekPanel.gd:488` — `PhaseStep` ("To the weigh-in →")**: advances fight week to the weigh-in with no explanation of what locks.
3. **`FightCampPanel.gd:411` — `StartCamp` ("START CAMP")**: commits every camp pick and starts the weeks with no tooltip.
4. **`FightCampPanel.gd:575` — `LeaveCamp` ("PULL OUT OF CAMP")**: abandons camp; the quarter-a-week fade is not explained.
5. **`CreationFlowPanel.gd:335` — `GoldAction` ("OPEN GYM")**: opens the gym and starts the career with no tooltip.
6. **`TrainingFloorPanel.gd:941` — `BookSpar` ("BOOK THE SPAR")**: books a spar with a risk tier and no tooltip.
7. **`TrainingFloorPanel.gd:968` — `HirePartner` ("HIRE HIM FOR A DAY · $N")**: spends cash on a sparring partner with no tooltip.
8. **`FightNightScreen.gd:1037` — `SimToResult` ("SIM TO RESULT")**: skips the rest of the bout; the entry point has no tooltip (only the confirm sheet is tipped).
9. **`ShellChrome.gd:810` — `Continue` (inside the date plate)**: advances the calendar day; it has no tip of its own and relies on the parent's tip at L542.
10. **`FightCampPanel.gd:716` — `GradeDial` and `CampGrade` letter (L720)**: the camp's headline grade has no explanation of how it is earned.

## Helper trap map

Every `*_button(` / `*_chip(` helper and the other builder helpers that create hover targets, with call sites in the nine files and whether the helper tips inside.

| Helper (defined in) | Tips inside? | Call sites (line) | Effect on coverage |
| :--- | :---: | :--- | :--- |
| `FightCampPanel._choice_card` (L924, returns Button) | no | L246, L266, L280, L284, L301, L309, L315, L327, L339, L567 | All uncovered except `technical_flow`, tipped after the call at L269 by `_attach_technical_flow_tips` (L1147). Native tooltip_text only at L247, L267, L281, L329, L569. |
| `FightCampPanel._plan_button` (L824) | no | L410, L573 | Uncovered. |
| `FightCampPanel._effect_tile` (L1510) | yes (L1530) | from `_mount_focus_effects` (L1469) | Covered. |
| `FightCampPanel._add_projection_figures` (L1340) | yes (L1373, L1384, L1389) | from the projection block | Partly covered: the fatigue and injury rows only; TIGHTNESS, FILM DEPTH, CAMP COST, FIGHT IQ and the delta lines are not. |
| `FightCampPanel._mark_recommended` (L1498) | no | L250 | Uncovered (StyleAdjust icon). |
| `WeekReviewPanel._chip` (L673) | no | L758, L785, L788, L825, L840, L931, L944, L996, L1002, L1102 | Each call site tips its chip (L761, L787, L790, L828, L843, L935, L947, L998, L1004). Countdown (L1102) inherits the card tip (L1090). |
| `WeekReviewPanel._text` (L635), `_icon` (L655), `_box` (L625) | no | many | Labels, icons and panels ignore the mouse; parents carry the tips. |
| `WeekReviewPanel._stat_block` (L1021) | yes (L1037) | L1013 | Covered. |
| `WeekReviewPanel._hook_card` (L1083) | yes (L1090) | L1077 | Covered. |
| `WeekReviewPanel._fighter_row` (L972) | yes (L993, L998, L1004) | L968 | Name, Programme and More covered; the portrait is not (L980). |
| `FightWeekPanel` `Kit.tile` (FightHypeKit L70), `Kit.text` (L26), `Kit.brass` (L36), `Kit.plate` (L51) | no | tile: L196, L282, L363, L402, L436; text and brass: many | Uncovered at every call site, because the Kit helpers never tip. |
| `FightHypeKit.gold_button` (L171) | no | FightWeekPanel L488 | Uncovered (PhaseStep). |
| `FightHypeKit.split_card` (L100), `versus` (L212) | no | FightWeekPanel L162, L164 | Uncovered (Announcement). |
| `G156Wire.icon_button` (G156Wire L60) | yes (G156Wire L75) | FightWeekPanel L512; CreationFlowPanel L135 | Covered at every call site (cut plans, abandon career). |
| `CreationFlowPanel._action` (L511) → `UIKit.button` | no | L221, L254, L335 | Uncovered (three GoldAction buttons). |
| `CreationFlowPanel._cards` (L445) → `UIKit.market_card` / `UIKit.city_intel` | no | L209, L241 | Uncovered (card hit buttons). |
| `CreationFlowPanel._tip_buttons` (L364) | yes (L366) | L325 | Covers the three StoryMode buttons by label text. |
| `CreationFlowPanel._fill_readout` (L542) | no | L518, L539 | Uncovered (Readout). |
| `CreationFlowPanel._draw_take` (L392) → `UIKit.starter_take` | partly (UIKit L7994, L8012) | L333, L381 | FloorCap and PeopleCap covered; figure units and silhouettes not (UIKit L8063 `_creation_silhouette` has no tip). |
| `TrainingFloorPanel._build_pin` (L163) | yes (L188) | L134 | Covered. |
| `TrainingFloorPanel._build_side_drawer` (L596) → `UIKit.button` tabs | no | L303, L319, L584 | Uncovered (four tabs). |
| `TrainingFloorPanel._build_event_card` (L816) | no | L582 | Uncovered (EventChoice buttons). |
| `TrainingFloorPanel._build_spar_card` (L868) | native only (L888) | L583 | Uncovered; OpenNight has only native tooltip_text. |
| `TrainingFloorPanel._build_station_legibility` (L646) | yes (L689, L698, L711, L735) | L88 | Covered. |
| `TrainingFloorPanel._label` (L1116) | no | many | Mouse-ignoring labels; the parent rows carry the tips. |
| `UIKit.station_tile` (UIKit L3387) | no | TrainingFloorPanel L725 | Covered only through the `StationTip_<id>` hit overlay (L735). |
| `ShellChrome._icon_button` (L657) | yes (L670) | L650 | Covered (Nav buttons). |
| `ShellChrome._build_options` (L708) | yes (L723) | L614 | Covered (Options gear). |
| `ShellChrome._build_back` (L187, outside window), `_build_handbook` (L224, outside window) | yes (L210, L240) | L522, L523 | Covered; bodies checked by grep only. |
| `ShellChrome._date_plate` (L779, outside window) | no inside; tip at call site L542 | L541 | The unit is covered; its Continue button (L810) is not. |
| `AthleteProfileShellScreen._build_back` (L95) → `UIKit.button` | no | L86 | Uncovered (Back). |
| `CornerPanel._rebuild_options` (L151) → `UIKit.button` | no | L134 | Uncovered (Instruction buttons). |
| `FightNightScreen._build_empty` (L745), `_build_arena_speed` (L1026), `_build_spar_result` (L1438) | no | L724, L1012, L1435 | Uncovered: Back, speed buttons, SimToResult, SparResult, BackToGym. |
| `FightNightScreen._show_sim_confirm` (L1064) → `UIKit.confirm_sheet` | yes (L1082, L1083) | L1059 | SKIP and KEEP WATCHING covered. |
| `UIKit.button` (L1256), `chip` (L1391), `label` (L190), `caps` (L240), `display` (L244), `pair` (L282), `gauge_bar` (L324), `icon_plate` (L2112), `art_plate` (L2150), `block` (L119), `frame` (L1501), `grade_dial` (L1728), `weigh_bar` (L1798), `camp_week_rail` (L4048), `badge` (L1214), `stat_row` (L377), `quiet_empty_state` (L8706) | no | all nine files | Checked: none applies a tip inside. Every call site must tip the node it returns. |
| `UIKit.floor_grid` (L3463) | partly (L3498, L3512, L3519) | CreationFlowPanel L405 (via starter_take) | Covered inside the helper; individual cells not re-checked. |
| `UIKit.filter_strip` (L3268) | no (Buttons created at L3288) | CreationFlowPanel L205, L321 | Sort buttons uncovered; StoryMode covered by `_tip_buttons`. |

## Per-file tables

### `AthleteProfileShellScreen.gd`

Controls found: 1 · covered: 0 · uncovered: 1

| line | what it is (node name or text) | covered yes/no | proposed tip |
| ---: | :--- | :---: | :--- |
| 96 | `Back` button "← BACK" (`UIKit.button`, built in `_build_back` L95) | no | Leave this fighter profile for the screen you came from. |

### `FightCampPanel.gd`

Controls found: 57 · covered: 5 · uncovered: 52

| line | what it is (node name or text) | covered yes/no | proposed tip |
| ---: | :--- | :---: | :--- |
| 219 | `LockedCagePlate` (UIKit.art_plate lock art, shown while camp is blocked) | no | Book a bout at least a week out to unlock camp. |
| 246 | `FocusCard_<focus>` (`_choice_card`; native tooltip_text at L247 only) | no | Pick this focus to bank its edges for this bout only. |
| 266 | `ProtocolCard_<protocol>` (`_choice_card`, non-technical protocols; native tooltip_text at L267 only) | no | Set how hard the camp pushes: gains, fatigue, injury, cash. |
| 266 | `ProtocolCard_technical_flow` (tip attached by `_attach_technical_flow_tips`, call at L269) | yes | Keep the existing tip. |
| 280 | `PartnerRole_<role>` (`_choice_card`; native tooltip_text at L281 only) | no | Cast a sparring partner to play this role in camp. |
| 284 | `PartnerNone` ("No partner", `_choice_card`) | no | Train in camp with no outside fighter sparring you. |
| 301 | `Partner_<candidate>` (`_choice_card`, candidate partner) | no | Hire this partner for camp; the card shows the weekly fee. |
| 309 | `CoachNone` ("No visiting coach", `_choice_card`) | no | Run camp with your own staff and no outside teacher. |
| 315 | `Coach_<coach>` (`_choice_card`, visiting coach) | no | Bring this coach in: teaching lifts gains, tactical speeds film. |
| 327 | `CounterCard_<counter>` (camp setup, `_choice_card`; native tooltip_text at L329 only) | no | Pick this style counter; it commits only at film depth 3. |
| 339 | `CutPlanCard_<plan>` (`_choice_card`, weight-cut plan) | no | Choose how hard the diet cuts weight over the camp weeks. |
| 353 | `SetupScale` (`UIKit.weigh_bar`; no tip inside the helper) | no | Compare today's weight with the class limit and walk-around weight. |
| 358 | scale readout "%.1f KG · LIMIT %.1f KG" (`_lines_label`) | no | Compare today's kilograms with the division's maximum. |
| 410 | `PlanSetupOpen` "FIGHT PLAN SETUP" (`_plan_button`, defined L824; call 1 of 2) | no | Review the build against your booked opponent's style. |
| 411 | `StartCamp` "START CAMP" (`UIKit.button`, primary) | no | Begin the weeks with these picks; the calendar advances each week. |
| 490 | `Week_<n>` cell (`UIKit.block`; title, state and detail labels sit inside) | no | Read what this week did, its fatigue and injury risk. |
| 567 | `CounterCard_<counter>` (camp progress, `_choice_card`; native tooltip_text at L569 only) | no | Set this style counter; it opens once film reaches depth 3. |
| 573 | `PlanSetupOpen` "FIGHT PLAN SETUP" (`_plan_button`, call 2 of 2) | no | Review the build against your booked opponent's style. |
| 575 | `LeaveCamp` "PULL OUT OF CAMP" (`UIKit.button`) | no | Quit early: what it built stays but fades a quarter a week. |
| 598 | built-so-far edge lines (`_lines_label` in `_fill_shape`, up to 5) | no | Read the edges banked so far for this bout. |
| 604 | projected edge lines (`_lines_label` in `_fill_shape`, up to 4) | no | Read the edges the camp was projected to bank. |
| 605 | `SPENT` pair (`UIKit.pair`, quiet) | no | Read the cash this camp has cost so far. |
| 613 | `FilmDepth` gauge (`UIKit.gauge_bar`, cool) | no | Track film study depth; style counters open at depth 3. |
| 617 | film depth readout "%d OF %d" (`UIKit.caps`) | no | Compare the depth reached with three, the unlock level. |
| 646 | body region life gauge (`UIKit.gauge_bar`, one per body region) | no | Check the health left in this body region after camp wear. |
| 656 | fatigue gauge (`UIKit.gauge_bar`, heat) | no | Watch fatigue from 0 to 100; above the cap, bouts are refused. |
| 662 | injury line "NO INJURIES IN CAMP" / "N INJURY IN CAMP" (`UIKit.caps`) | no | Note any knocks taken while training; medicals decide on fight day. |
| 716 | `GradeDial` (`UIKit.grade_dial`, caption "CAMP GRADE") | no | Read how much of the projected shape was banked. |
| 720 | `CampGrade` letter (`UIKit.display`, grade letter) | no | Read the letter awarded; each camp injury docks a quarter. |
| 727 | "WEEKS RUN" pair (`UIKit.pair`, one of four facts in loop) | no | Count the camp's elapsed time against its full length. |
| 728 | "FILM DEPTH" pair (same loop) | no | Check how far study went; reaching three unlocks counters. |
| 729 | "FATIGUE" pair (same loop) | no | Check the strain left on the fighter, from 0 to 100. |
| 730 | "INJURIES" pair (same loop) | no | Count the knocks taken in camp; each docks a quarter. |
| 737 | banked summary "N% OF THE PROJECTED SHAPE WAS BANKED" (`_lines_label`) | no | Read the share kept; it sets the camp grade. |
| 753 | built-edge line (`UIKit.caps`, one per projected edge) | no | Read the projected edge the camp aimed to bank. |
| 759 | built-edge bar (`UIKit.gauge_bar`, one per projected edge) | no | Compare the banked share of this projected edge. |
| 762 | built-edge percent "N%" (`UIKit.caps`, green at 90 or more) | no | Check the share banked; green means ninety percent or more. |
| 783 | injury "WEEK n · REGION" line (one per injury) | no | Find when and where this camp injury happened. |
| 788 | injury "DOWN n, READINESS n AFTER" line (one per injury) | no | Check the severity and the condition left behind. |
| 881 | head subline `Line` (`UIKit.caps` in `_build_head`, L861; called at L233, L474, L709) | no | Scan the opponent, style, weeks and cash for this camp. |
| 888 | `CampWeekRail` (`UIKit.camp_week_rail`; no tip inside the helper) | no | Scan the weeks so far; the gold cell marks fight week. |
| 1282 | `StyleLine` (`_add_style_block`, scouting read) | no | Read how the opponent fights and what answers it. |
| 1290 | `AdjustLine` (`_add_style_block`, recommended adjustment) | no | Check the focus this read recommends and the edges it adds. |
| 1299 | `WatchFilm` flat Button (native tooltip_text at L1304 only) | no | Open the room with this opponent's footage and the coach's read. |
| 1331 | `HoverEdges` (`_add_hover_block`, per-week edges of the hovered focus) | no | Check the per-week gains this focus banks and their caps. |
| 1362 | TIGHTNESS pair (`_add_projection_figures` row loop, L1361-1376) | no | Read the combo tightness expected on fight night, 0 to 100. |
| 1364 | FILM DEPTH pair (same loop) | no | Check how far study goes; three unlocks the counters. |
| 1365 | CAMP COST pair (same loop; red when not affordable) | no | Read the total cash spent; red means the gym cannot pay. |
| 1366 | FIGHT IQ pair (same loop; dash when zero) | no | Read the permanent IQ gain; a dash means none. |
| 1373 | `FatigueOnTheNight` pair | yes | Keep the existing tip. |
| 1384 | `InjuryRisk` bar (`UIKit.gauge_bar`) | yes | Keep the existing tip. |
| 1389 | `InjuryRiskRead` "N% OVER THE CAMP" label | yes | Keep the existing tip. |
| 1406 | delta line "LABEL from → to" (`_add_projection_figures`, up to four) | no | Read how the last pick moved this figure; green is better. |
| 1431 | diet weight line (`weight.lines`, up to two) | no | Read the diet's weight-cut plan for this camp, week by week. |
| 1452 | `ShapeTile_<stat>` (icon_plate plus value; mouse ignored) | no | Read which stat the camp shape banks and by how much. |
| 1499 | `StyleAdjust` icon (`_mark_recommended`, gold target; call at L250) | no | Mark the focus that best answers this opponent's plan. |
| 1530 | `EffectTile_<stat>` (`_effect_tile`, tiles inside focus cards) | yes | Keep the existing tip. |

### `FightWeekPanel.gd`

Controls found: 21 · covered: 2 · uncovered: 19

| line | what it is (node name or text) | covered yes/no | proposed tip |
| ---: | :--- | :---: | :--- |
| 196 | `Day_<MON..SAT>` day cell (`Kit.tile`, work and note labels inside; `Kit.tile` has no tip) | no | Read this day's scheduled work and its note before the bout. |
| 162 | `Announcement` split card (`Kit.split_card`: both names and W-L-D records) | no | Compare both fighters' records and corners before the bout. |
| 282 | `Pair_WEIGHT_TODAY` tile (`_build_condition` pairs loop, `Kit.tile`) | no | Read your weight right now against the class limit. |
| 282 | `Pair_LIMIT` tile (same loop) | no | Read the division's weight limit for this bout. |
| 282 | `Pair_TO_LOSE` tile (same loop, weight minus limit in kg) | no | Count the kilograms you must lose to make the limit. |
| 282 | `Pair_CAMP_WEEKS` tile (same loop, only when the camp has weeks) | no | Count the camp weeks already banked for this bout. |
| 282 | `Pair_CAMP_BUILT` tile (same loop, "OVR before → now") | no | Read the change in overall rating across this camp. |
| 311 | `CampCard` line (built and missed camp gains, the third note line) | no | Read what this camp built and what it missed. |
| 364 | `Plan_<id>` tiles (focus and protocol entries, up to two each) | no | Review the camp focus or protocol and the edge it gives. |
| 373 | `CampSlots` line ("N camp slots · film depth N") | no | Review the specialist places available and the study level. |
| 403 | `Tale_OPPONENT` tile (row loop L398-407; our name left, opponent right) | no | Compare our fighter on the left with the opponent on the right. |
| 403 | `Tale_RECORD` tile (same loop; our W-L-D left, opponent's right) | no | Compare the two pro records, ours on the left. |
| 403 | `Tale_STANCE` tile (same loop) | no | Compare the two stances, ours on the left. |
| 403 | `Tale_STYLE` tile (same loop; discipline left, opponent's style right) | no | Compare the discipline and the opponent's style. |
| 403 | `Tale_DIVISION` tile (same loop; weight class left, limit right) | no | Check the weight class and the limit for this bout. |
| 403 | `Tale_OUT` tile (same loop; weeks left, days left) | no | Count the weeks and days left before the bout. |
| 403 | `Tale_VENUE` tile (same loop; event left, venue right) | no | Read the event and venue where this bout is fought. |
| 423 | `Tale_BOUT` tile (bout captions) | yes | Keep the existing tip. |
| 437 | `Counter_<id>` tile (up to two style counters; dimmed when locked) | no | Read this style counter's effect; a dimmed tile shows why it's locked. |
| 488 | `PhaseStep` "To the weigh-in →" (`Kit.gold_button`) | no | Advance the fight week and move on to the scale. |
| 512 | `CutPlan_<plan>` buttons (`G156.icon_button`; tip from `G156.cut_tip`) | yes | Keep the existing tip. |

### `WeekReviewPanel.gd`

Controls found: 18 · covered: 17 · uncovered: 1

| line | what it is (node name or text) | covered yes/no | proposed tip |
| ---: | :--- | :---: | :--- |
| 758 | `DatePill` (`_chip`, "THIS WEEK" date label) | yes | Keep the existing tip. |
| 770 | `BillLine` monthly-bill strip (`_draw_bill_strip`; bill text, due line and pips inside) | yes | Keep the existing tip. |
| 785 | `upkeep` chip "Upkeep $X" (`_draw_bill_strip`) | yes | Keep the existing tip. |
| 788 | `wages` chip "Wages $X" (`_draw_bill_strip`) | yes | Keep the existing tip. |
| 814 | `NetPlate` (`_draw_net_plate`; NET label, big amount and balance inside) | yes | Keep the existing tip. |
| 825 | `StateChip` "Profit week" / "Loss week" | yes | Keep the existing tip. |
| 840 | `DeltaChip` "vs last week ±$" | yes | Keep the existing tip. |
| 844 | `Sparkline` (NetSpark, last four weeks of net) | yes | Keep the existing tip. |
| 875 | `Tile_income` and `Tile_costs` money tiles (`_draw_tiles`; amount, source words and ScaleBar inside) | yes | Keep the existing tip. |
| 931 | `WorldChip` "N results" (`_draw_fighters`) | yes | Keep the existing tip. |
| 944 | `FightChip` per bout result (`_draw_fighters`) | yes | Keep the existing tip. |
| 990 | fighter `Name` label (`_fighter_row`) | yes | Keep the existing tip. |
| 996 | `Programme` chip, what the fighter trained | yes | Keep the existing tip. |
| 1002 | `More` chip "+N more" | yes | Keep the existing tip. |
| 1031 | `Stat_<stat>` block (`_stat_block`; before → after, GainBar and pill inside) | yes | Keep the existing tip. |
| 1086 | `Hook_<kind>` card (`_hook_card`; countdown chip inside) | yes | Keep the existing tip. |
| 1111 | `NextWeek` button "Next week" | yes | Keep the existing tip. |
| 980 | fighter portrait `face` (TextureRect in `_fighter_row`; mouse ignored, so nothing hovers) | no | Identify the fighter; hover the name for this week's details. |

### `CornerPanel.gd`

Controls found: 2 · covered: 0 · uncovered: 2

| line | what it is (node name or text) | covered yes/no | proposed tip |
| ---: | :--- | :---: | :--- |
| 105 | `Skip` button "SKIP STOOL" (`UIKit.button`, built in `_build`) | no | Drop this corner advice and let the round run unchanged. |
| 170 | `Instruction_<i>` buttons, one per corner option (`_rebuild_options`; "SAY:" advice label inside) | no | Tell the corner this instruction; the SAY line shows the wording. |

### `FightNightScreen.gd`

Controls found: 9 · covered: 2 · uncovered: 7

| line | what it is (node name or text) | covered yes/no | proposed tip |
| ---: | :--- | :---: | :--- |
| 762 | `Back` button "←  BACK" (empty-state frame, `_build_empty`) | no | Leave this fight-night screen for the screen you came from. |
| 1031 | `1X` speed button (`_build_arena_speed` loop; mouse on the arena bar) | no | Play the bout at normal speed. |
| 1031 | `2X` speed button (same loop) | no | Play the bout at double speed. |
| 1031 | `4X` speed button (same loop) | no | Play the bout at quadruple speed. |
| 1037 | `SimToResult` button "SIM TO RESULT" (`_build_arena_speed`) | no | Skip the rest of the bout; the engine decides the outcome. |
| 1082 | `SimConfirm` skip button "SKIP" (`_show_sim_confirm`, from `UIKit.confirm_sheet`) | yes | Keep the existing tip. |
| 1083 | `SimConfirm` keep button "KEEP WATCHING" (`_show_sim_confirm`) | yes | Keep the existing tip. |
| 1444 | `SparResult` card (`_build_spar_result`; title, "A vs B" line, "Landed N - N" and marks lines) | no | Read who had the better of the sparring and the landed counts. |
| 1467 | `BackToGym` button "BACK TO THE GYM" (`_build_spar_result`) | no | Leave this sparring result and return to the previous screen. |

### `CreationFlowPanel.gd`

Controls found: 23 · covered: 8 · uncovered: 15

| line | what it is (node name or text) | covered yes/no | proposed tip |
| ---: | :--- | :---: | :--- |
| 135 | `AbandonCareer` icon button "x" (`G156.icon_button`; shown only while a new career is pending) | yes | Keep the existing tip. |
| 205 | `Sort` "A-Z" button (`UIKit.filter_strip` in `_build_country`; no tip inside the helper) | no | Sort the markets alphabetically, first to last. |
| 205 | `Sort` "ECONOMY" button (same strip) | no | Rank markets by their money strength, strongest first. |
| 205 | `Sort` "TALENT" button (same strip) | no | Rank markets by how deep their fighter pool runs. |
| 205 | `Sort` "COMBAT" button (same strip) | no | Rank markets by how much the public follows fights. |
| 466 | `CountryCard_<market>` (`UIKit.market_card` in `_cards`; its "hit" button has no tip) | no | Select this market to read its economy and talent numbers. |
| 468 | `CityCard_<city>` (`UIKit.city_intel` in `_cards`; its "hit" button has no tip) | no | Select this city to see its rivals, promotions and events. |
| 518 | `Readout` panel (`_fill_readout` via `_action`; economy, talent, depth or rival lines; every step) | no | Read the current choice's numbers before you commit to it. |
| 221 | `GoldAction` "CHOOSE MARKET" (`_action` → `UIKit.button`, gold, disabled until a market is chosen) | no | Lock in this choice and move on to the city list. |
| 254 | `GoldAction` "ENTER CITY" (`_action` → `UIKit.button`) | no | Lock in this choice and move on to naming the gym. |
| 275 | `NameField` LineEdit (gym name, `_build_gym`; no tip) | no | Type the gym's name; the preview below shows what gets saved. |
| 298 | `PlayerField` LineEdit (player name, placeholder "Coach") | yes | Keep the existing tip. |
| 321 | `StoryMode` "STORY ON" button (`UIKit.filter_strip`; tip via `_tip_buttons`) | yes | Keep the existing tip. |
| 321 | `StoryMode` "BESIDE" button (same strip) | yes | Keep the existing tip. |
| 321 | `StoryMode` "OFF" button (same strip) | yes | Keep the existing tip. |
| 335 | `GoldAction` "OPEN GYM" (`_action` → `UIKit.button`, opens the career) | no | Start your career here with this name and starter roster. |
| 405 | `Take` "Cash" unit (`UIKit.starter_take`, STARTING CASH value; UIKit.gd L7967-7971) | no | Count the starting money before any spending. |
| 405 | `Take` "Space" unit (`UIKit.starter_take`, FLOOR SPACE used/total) | no | Read how much of the floor the starter kit uses. |
| 405 | `Take` "Upkeep" unit (`UIKit.starter_take`, UPKEEP per week) | no | Read the weekly running bill the gym pays to stay open. |
| 405 | `Take` "FloorCap" caption "STARTER FLOOR" (`UIKit.starter_take`) | yes | Keep the existing tip. |
| 405 | `Take` "Floor" grid (`UIKit.floor_grid`, tips inside at UIKit.gd L3498/3512/3519) | yes | Keep the existing tip. |
| 405 | `Take` "PeopleCap" caption "STARTER ROSTER · N" (`UIKit.starter_take`) | yes | Keep the existing tip. |
| 405 | `Take` roster "Silhouette<i>" cards (`UIKit._creation_silhouette`, UIKit.gd L8063; avatar, name, line) | no | Read this starting fighter's name and summary line. |

### `TrainingFloorPanel.gd`

Controls found: 24 · covered: 5 · uncovered: 19

| line | what it is (node name or text) | covered yes/no | proposed tip |
| ---: | :--- | :---: | :--- |
| 168 | `Pin_<instance_id>` station pin (`_build_pin`, Button with Icon and "Booked" tag inside) | yes | Keep the existing tip. |
| 618 | `Tab_STATIONS` side-drawer tab "STATIONS" (`_build_side_drawer` → `UIKit.button`) | no | Open the rail of equipment and who is using each piece. |
| 618 | `Tab_SparCard` side-drawer tab "SPARRING" (same builder) | no | Open the bookings and partner offers for today's training. |
| 618 | `Tab_EventCard` side-drawer tab "EVENT" (same builder) | no | Open today's floor happening and what it does to training. |
| 618 | `Tab_StationMovePicker` side-drawer tab "MOVES" (same builder) | no | Choose which technique a fighter drills at the chosen station. |
| 684 | `SpaceUsed` caps "SPACE n / n USED" (`_build_station_legibility`, rail) | yes | Keep the existing tip. |
| 693 | `FloorLoad` label "Nx load · team trains at N%" (`UIKit.label`) | yes | Keep the existing tip. |
| 701 | `ExpandReadout` button (`UIKit.button`, expand or wing cost label) | yes | Keep the existing tip. |
| 725 | `StationTile_<instance>` cards (`UIKit.station_tile` with a `StationTip_<instance>` hit overlay) | yes | Keep the existing tip. |
| 849 | Event answer buttons, one per floor-event choice (`_build_event_card`) | no | Choose this answer to the floor event and apply its effect. |
| 885 | `OpenNight` button "OPEN NIGHT FRIDAYS: ON/OFF" (native tooltip_text at L888 only) | no | Let outside fighters spar with your men for a fee. |
| 900 | `WatchSpar` button "WATCH THE SPAR" (`_build_spar_card`, booked spar) | no | Open the live viewer for today's booked session. |
| 907 | `CancelSpar` button "CALL IT OFF" (`_build_spar_card`, booked spar) | no | Cancel this fighter's booking for today's session. |
| 914 | `SparContext` booking line (pairing names, kg, records, OVR, risk tier) | no | Read both fighters' weight, record and rating, plus the risk tier. |
| 925 | `PickA` OptionButton (first fighter in the spar picker; loop L923-932) | no | Choose the first fighter for the next spar booking. |
| 925 | `PickB` OptionButton (second fighter; same loop) | no | Choose the second fighter for the next spar booking. |
| 933 | `PickIntensity` OptionButton (Technical, Light, Hard) | no | Set how hard the spar runs; higher levels raise its risk. |
| 941 | `BookSpar` button "BOOK THE SPAR" (`_build_spar_card`) | no | Lock in this pairing at the chosen intensity for today. |
| 953 | `SparContext` picker line (updates as picks change, L1016-1017) | no | Read the pairing's weight, record and rating as you pick. |
| 967 | `HireWho` line (partner, level, stance, height against his, L965-967) | no | Compare the partner's height and level with the opponent's. |
| 968 | `HirePartner` button "HIRE HIM FOR A DAY · $N" (`_build_spar_card`) | no | Pay the listed cost to bring this partner in for one day. |
| 984 | `WatchAgain` button "WATCH IT AGAIN" (`_build_spar_card`, last result) | no | Replay the last spar in the fight viewer without changing results. |
| 1001 | `VisitorResult` line (visitor cash and reputation change, L994-1001) | no | Read the visitor's cash, reputation change and reputation now. |
| 1009 | `SparDetail` line ("Landed N - N", stopped flag, marks) | no | Read the hit count and marks from the last spar. |

### `ShellChrome.gd (top bar only)`

Controls found: 8 · covered: 7 · uncovered: 1

| line | what it is (node name or text) | covered yes/no | proposed tip |
| ---: | :--- | :---: | :--- |
| 522 | `Back` button "← BACK" (`_build_back` call; helper body at L187-215, outside the window) | yes | Keep the existing tip. |
| 523 | `Handbook` button (`_build_handbook` call; helper body at L224-247, outside the window) | yes | Keep the existing tip. |
| 659 | `Nav_<module>` icon buttons, one per bar item (`_icon_button`, L657; badge counts on Nav_gym and Nav_calendar) | yes | Keep the existing tip. |
| 554 | `Cash` chip (Panel with banknote icon and amount label inside, L554-569) | yes | Keep the existing tip. |
| 541 | `ContinueUnit` date plate (`_date_plate` call; Date, Week and Sub labels inside) | yes | Keep the existing tip. |
| 810 | `Continue` button inside ContinueUnit (`_date_plate`, L810-831; no tip of its own) | no | Advance the calendar to the next day. |
| 594 | `Bell` news button (L594-613; badge dot child when news exists) | yes | Keep the existing tip. |
| 709 | `Options` gear button (`_build_options`, L708-725) | yes | Keep the existing tip. |

## Exclusions (not counted)

- **Headings, kickers and frame titles**: e.g. `Title`, `Head`, `BoardTitle`, `PlanTitle`, `TapeTitle`, `CountersTitle`, `SparTitle`, `ask` (WHAT DO YOU SAY?), `Title` (FightNightScreen empty frame), `title_slot` facts line (OfficeRoomPanel, TrainingFloorPanel L581), `SparResult` result sentence in TrainingFloorPanel (L993, status text; the FightNightScreen SparResult card is counted, see its row).
- **Captions and prose**: `CampBlocked`, `CampNote`, `HoverLabel`, `ProjectionCaption`, `BalancedShape`, `risk_note`, `footnotes`, film log lines, region name captions, `FATIGUE` caption, `FirstCornerCaption`, `RoundRead` (a read sentence with values, excluded as prose), `Note_<y>` lines, `HireAbout`, `SparRivalry`, `SparNotice`, `Outcome`, `Refusal`, `NoTake`, `Empty`.
- **Empty and status states**: `FightWeekEmptyPlate` and `Empty` (FightWeekPanel L110, L113), `EmptyRoster`, `PlanRefusal`, `Nobody trained this week` line, `Nothing booked yet` line, `EmptyFrame` reason line (FightNightScreen L757).
- **Decorative art and containers**: `WeekPlate`, `TapePlate`, `GreenRingBackdrop`, `Silhouette` (dead code, see below), `Ring`, `Shade`, `Strip`, `Sep`, `Path`, `Tint`, `Backdrop`, `GymBlur`, `Ground`, `CornerCard`, `Card`, `Fighters` scroll, `StationRail`, `SideTabs`, `Column`, `Cards`, `Line%d` rows.
- **Header icons**: calendar-days (WeekReviewPanel L753), users (L926) and arrow-right (L1067) sit beside headings and are treated as decoration.
- **Hidden nodes**: `Roster` chip (ShellChrome L578-590, `visible = false`), `Breadcrumb` (L515-520, hidden). Crest and Club (gym monogram and name, L497-510) are brand identity, not stats, and are excluded.
- **Outside the nine files**: `RingStagePanel` (the fight-night view that hosts the command bar and corner buttons), `RoomClickMarks` (its own HoverTip for doors), the 3D floor (`TrainingFloor3D`), `TimelineBar` (replaces the date plate when on), and `ProfileRevampPanel` (the Athlete profile body).
- **Dead code**: `FightWeekPanel._build_figure` returns at L474 before creating `Silhouette` and its FIGURE caption, so neither is drawn.

## Scan of `.name = "` lines

Every `.name = ` assignment in the nine files was scanned by script. The list below is generated from the source, so it covers every node name, including container, plate and caption names, which are not counted as controls. ShellChrome is limited to the top-bar window L454-741.

**`AthleteProfileShellScreen.gd`** (3): L89 `ProfileRevampPanel`, L97 `Back`, L103 `Crumb`.

**`FightCampPanel.gd`** (49): L202 `CampSetup`, L212 `CampBlocked`, L219 `LockedCagePlate`, L292 `PartnerEmpty`, L354 `SetupScale`, L368 `Projection`, L381 `Projection`, L405 `ProjectionStats`, L412 `StartCamp`, L420 `CampNote`, L456 `CampProgress`, L491 `Week_%d`, L538 `CampShape`, L545 `CampFilm`, L552 `CampBody`, L576 `LeaveCamp`, L582 `CampNote`, L614 `FilmDepth`, L693 `CampReport`, L717 `GradeDial`, L721 `CampGrade`, L742 `CampBuilt`, L772 `CampInjuries`, L826 `PlanSetupOpen`, L843 `PlanSetupDim`, L849 `PlanSetup`, L866 `FilmRoomBackdrop`, L869 `CampHead`, L876 `Title`, L882 `Line`, L927 `node_name`, L952 `Title`, L965 `Detail`, L1154 `FatigueFigure`, L1160 `InjuryFigure`, L1283 `StyleLine`, L1291 `AdjustLine`, L1300 `WatchFilm`, L1326 `HoverLabel`, L1332 `HoverEdges`, L1349 `ProjectionCaption`, L1372 `FatigueOnTheNight`, L1382 `InjuryRisk`, L1387 `InjuryRiskRead`, L1418 `BalancedShape`, L1452 `ShapeTile_%s`, L1500 `StyleAdjust`, L1513 `EffectTile_%s`, L1524 `Value`.

**`FightWeekPanel.gd`** (25): L101 `FightWeekBody`, L110 `FightWeekEmptyPlate`, L114 `Empty`, L120 `WeekPlate`, L121 `TapePlate`, L138 `GreenRingBackdrop`, L163 `Announcement`, L190 `BoardTitle`, L197 `Day_%s`, L204 `Work`, L283 `Pair_%s`, L311 `CampCard`, L350 `PlanRefusal`, L353 `PlanTitle`, L364 `Plan_%s`, L374 `CampSlots`, L383 `TapeTitle`, L403 `Tale_%s`, L415 `Tale_BOUT`, L418 `BoutLine`, L429 `CountersTitle`, L437 `Counter_%s`, L476 `Silhouette`, L489 `PhaseStep`, L497 `CutPlans`.

**`WeekReviewPanel.gd`** (38): L530 `WeekReviewBody`, L709 `Backdrop`, L714 `GymBlur`, L722 `Tint`, L733 `Card`, L756 `Title`, L760 `DatePill`, L770 `BillLine`, L797 `BillDue`, L805 `Pip%d`, L815 `NetPlate`, L822 `Tint`, L827 `StateChip`, L830 `Amount`, L836 `Balance`, L842 `DeltaChip`, L845 `Sparkline`, L876 `Tile_%s`, L886 `SourceWords`, L890 `Amount`, L893 `ScaleBar`, L932 `WorldChip`, L946 `FightChip`, L950 `Fighters`, L974 `Fighter_%s`, L988 `Ring`, L991 `Name`, L997 `Programme`, L1003 `More`, L1031 `Stat_%s`, L1043 `Best`, L1045 `GainBar`, L1058 `Pill`, L1066 `NextWeekHooks`, L1080 `Path`, L1086 `Hook_%s`, L1104 `Countdown`, L1112 `NextWeek`.

**`CornerPanel.gd`** (8): L74 `CornerCard`, L78 `Title`, L83 `FirstCornerCaption`, L90 `RoundRead`, L100 `Outcome`, L106 `Skip`, L170 `Instruction_%d`, L181 `Advice_%d`.

**`FightNightScreen.gd`** (16): L699 `Ground`, L705 `RingStagePanel`, L719 `FightTimer`, L747 `EmptyFrame`, L753 `Title`, L758 `Reason`, L763 `Back`, L978 `ArenaHost`, L983 `ArenaViewport`, L1005 `ArenaFrameClock`, L1028 `ArenaSpeed`, L1038 `SimToResult`, L1075 `SimConfirm`, L1444 `SparResult`, L1459 `Line%d`, L1468 `BackToGym`.

**`CreationFlowPanel.gd`** (20): L115 `FlowBody`, L206 `Sort`, L271 `NameCap`, L276 `NameField`, L294 `PlayerCap`, L299 `PlayerField`, L317 `StoryCap`, L322 `StoryMode`, L328 `TakeHost`, L338 `Refusal`, L401 `NoTake`, L406 `Take`, L434 `Head`, L447 `Cards`, L453 `Column`, L460 `Line%d`, L513 `Readout`, L520 `GoldAction`, L547 `Line%d`, L569 `Empty`.

**`TrainingFloorPanel.gd`** (43): L68 `FloorView`, L76 `Viewport`, L83 `TrainingFloor3D`, L118 `StationPins`, L168 `Pin_%s`, L183 `Icon`, L191 `Booked`, L294 `StationMovePicker`, L604 `SideTabs`, L619 `Tab_`, L670 `StationRail`, L685 `SpaceUsed`, L694 `FloorLoad`, L702 `ExpandReadout`, L714 `StationTiles`, L720 `Column`, L727 `StationTile_%s`, L730 `StationTip_%s`, L821 `EventCard`, L831 `EventTitle`, L842 `Choices`, L850 `str(choice.get("id", ""))`, L872 `SparCard`, L882 `SparTitle`, L886 `OpenNight`, L897 `SparBooked`, L901 `WatchSpar`, L908 `CancelSpar`, L914 `SparContext`, L919 `SparPick`, L925 `Pick`, L934 `PickIntensity`, L942 `BookSpar`, L950 `SparNotice`, L954 `SparContext`, L962 `HireAbout`, L967 `HireWho`, L969 `HirePartner`, L985 `WatchAgain`, L993 `SparResult`, L1001 `VisitorResult`, L1009 `SparDetail`, L1011 `SparRivalry`.

**`ShellChrome.gd (top bar only)`** (20): L456 `TopBar`, L463 `Shade`, L478 `Strip`, L498 `Crest`, L506 `Club`, L516 `Breadcrumb`, L548 `Pills`, L555 `Cash`, L566 `Cash`, L579 `Roster`, L588 `Line`, L595 `Bell`, L605 `Badge`, L624 `NavIcons`, L639 `Sep`, L659 `Nav_`, L675 `Icon`, L681 `ActiveBar`, L689 `Badge`, L710 `Options`.

## Checks run

- Every row was checked for: a line number in the cited file (rough check that the node name or text appears within six lines), a proposed tip of at most 12 words, a verb as the first word, and no repeated label word from the control's quoted label.
- Line-number notes: the check flagged only helper-built names, where the cited line is the call site, the tip line, or the name line of a loop-built node. Each was reviewed and is correct.
- No `UIKit.tip` was found in these UIKit helpers: `button`, `chip`, `label`, `caps`, `display`, `pair`, `gauge_bar`, `icon_plate`, `art_plate`, `block`, `frame`, `grade_dial`, `weigh_bar`, `camp_week_rail`, `badge`, `stat_row`, `quiet_empty_state`.

