# C41 — UIKit dead-factory audit

Date: 2026-09-08. Scope: the 35 names reported by the task's deliberately narrow grep. No runtime or UI file was changed.

## Count and method

The task's command reproduces exactly: **161** public-name matches and **35** names with no literal `UIKit.<name>(` caller outside `UIKit.gd`. That is not the same as 35 dead factories. The list contains internal primitives, wrappers already displaced by later screen-specific factories, and dynamic calls the grep cannot see. It also contains one regex artefact: `[a-z_]*` truncates the live `combo_alert_8s` name to `combo_alert_`.

Tests below mean a test directly calls the named factory, unless marked **indirect**. “No direct test” means no literal occurrence of that name was found under `Godot/tests/`; it does not claim that a parent screen never constructs it.

| Factory and line | What it renders | Tested? | Bucket | Evidence for bucket |
|---|---|---|---|---|
| `action_card` — `UIKit.gd:1315` | A titled action panel with eyebrow, subtitle and an optional inner well. | Yes — `ui_kit_shell_test.gd:43`. | **SUPERSEDED** — `continue_affordance` plus the shell's single advance. | `DayFeedPanel.gd:10-12` explicitly removes the body action card because the shell owns the one advance. |
| `action_flag` — `UIKit.gd:2191` | A compact, severity-dressed chip for one row flag, or a quiet dash. | No direct test. | **PRIMITIVE** — composed by `squad_row`, `week_band` and `prospect_row`. | Internal calls are at `UIKit.gd:2179`, `UIKit.gd:2830` and `UIKit.gd:4043`. |
| `alerts_column` — `UIKit.gd:1319` | A vertical set of titled alert sections with counts and an empty state. | Yes — `ui_kit_shell_test.gd:47`. | **SUPERSEDED** — `day_attention_strip` and rail badges. | `DayFeedPanel.gd:14-15` says the alerts column is gone because the rail already carries those badges; the current strip is mounted at `DayFeedPanel.gd:221`. |
| `belt_holder_row` — `UIKit.gd:6054` | A selectable belt row showing its label and holder or honest vacancy. | No direct test. | **SUPERSEDED** — the championship plate and `_holder_band`. | `RankingsHubPanel.gd:37` explicitly says this factory is no longer called; the current holder treatment is `_holder_band` at `RankingsHubPanel.gd:621`. |
| `boot_body_rect` — `UIKit.gd:5387` | The body rectangle between the boot brand and foot bands. | Indirect — `boot_root_test.gd:131` checks the resulting body contract. | **PRIMITIVE** — composed by `boot_chrome`. | `boot_chrome` calls it at `UIKit.gd:5408`. |
| `boot_seam` — `UIKit.gd:5817` | A full-screen shutter naming the destination during a boot handoff. | No direct test; root tests disable transitions. | **UNKNOWN** — it is live, but the four-bucket taxonomy has no LIVE/DYNAMIC bucket. | `BootRoot.gd:258` invokes it through `script.call("boot_seam", ...)`, which the literal-call audit misses. |
| `combo_alert_` — no such factory; grep truncates `combo_alert_8s` at `UIKit.gd:6985` | The real `combo_alert_8s` renders the eight-second incoming-combination alert, links, read and clock. | Indirect — `ring_stage_panel_test.gd:83-92` arms and checks it. | **UNKNOWN** — this row is a regex artefact, not a dead symbol. | The live call is `RingStagePanel.gd:1122`; the declaration is `combo_alert_8s`, not `combo_alert_`. |
| `command_list` — `UIKit.gd:1295` | A vertical menu of named command rows with icons, kinds and chevrons. | Yes — `ui_kit_shell_test.gd:19`. | **SUPERSEDED** — `continue_affordance` plus individually owned `button` actions. | The current title builds Continue at `TitleBoardPanel.gd:123` and its three distinct actions in `_build_actions` at `TitleBoardPanel.gd:129`. |
| `creation_body_rect` — `UIKit.gd:6148` | The body rectangle between creation's brand, step strip and foot. | Indirect — `creation_root_test.gd:154` checks the resulting body contract. | **PRIMITIVE** — composed by `creation_chrome`. | `creation_chrome` calls it at `UIKit.gd:6169`. |
| `creation_seam` — `UIKit.gd:6704` | A full-screen handoff showing the career shell rail and top band arriving. | No direct test; root tests disable transitions. | **UNKNOWN** — it is live, but reached dynamically. | `CreationRoot.gd:322` invokes it through `script.call("creation_seam", ...)`. |
| `day_cell` — `UIKit.gd:3130` | One calendar date with stacked obligation chips, today/selection treatment and overflow count. | No direct test. | **PRIMITIVE** — composed by `month_grid`. | `month_grid` calls it at `UIKit.gd:3224`. |
| `desk_ledger` — `UIKit.gd:4312` | A single office block combining cash, weekly outgoings, purse owed and the coming bill. | No direct test. | **SUPERSEDED** — the R46 two-wallet desk (`_build_gym_week`, `_build_purse`). | `OfficeHubPanel.gd:290-294` rules that gym and fighter money are never totalled; the replacement builders begin at `OfficeHubPanel.gd:326` and `OfficeHubPanel.gd:435`. |
| `division_switcher` — `UIKit.gd:1339` | A segmented selector for division labels. | Yes — `ui_kit_shell_test.gd:72`. | **SUPERSEDED** — `segmented` for tabs and `ladder_scope` for ranking scope. | Rankings uses `segmented` at `RankingsHubPanel.gd:261` and the purpose-built `ladder_scope` at `RankingsHubPanel.gd:266`. |
| `fighter_slab` — `UIKit.gd:4893` | A fighter name and secondary line aligned as one side of set-piece chrome. | No direct test. | **PRIMITIVE** — composed by `setpiece_chrome`. | `setpiece_chrome` calls it at `UIKit.gd:4952`. |
| `focus_chip` — `UIKit.gd:2623` | One day of a fighter's training week, showing focus, station and fight lock. | No direct test. | **PRIMITIVE** — composed by `week_band`. | `week_band` calls it at `UIKit.gd:2793`. |
| `gate_estimate_pair` — `UIKit.gd:3563` | A compact gate estimate, optionally with the cash value of negotiated points. | No direct test. | **PRIMITIVE** — composed by `booking_offer_row`. | `booking_offer_row` calls it at `UIKit.gd:3753`. |
| `gradient_texture` — `UIKit.gd:63` | A horizontal or vertical two/three-stop gradient texture for measured fills. | Indirect — `ui_kit_test.gd:54` constructs a gradient-backed gauge. | **PRIMITIVE** — composed by gauge fills. | Internal uses are at `UIKit.gd:230` and `UIKit.gd:874`. |
| `ledger_row` — `UIKit.gd:1299` | An icon/value/caption row with a fixed number of lit and unlit pips. | Yes — `ui_kit_shell_test.gd:28`. | **UNKNOWN** — no present screen lacks this exact bundle, and no newer factory has the same pips contract. | The only implementation edge is the wrapper to `Shell.ledger_row` at `UIKit.gd:1300`; no production caller was found. |
| `light_overlay` — `UIKit.gd:42` | A mouse-transparent white-to-clear top-light texture over a surface. | Indirect — `ui_kit_test.gd:117` constructs a lit `block`. | **PRIMITIVE** — composed by `block`. | `block` adds it at `UIKit.gd:85`. |
| `moment_row` — `UIKit.gd:1327` | A quiet or BAD-edged play-by-play moment row. | Yes — `ui_kit_shell_test.gd:60-61`. | **SUPERSEDED** — RingStagePanel's one-line `_build_callout`. | `RingStagePanel.gd:249-251` says the old play-by-play panel was dropped; `_build_callout` begins at `RingStagePanel.gd:251`. |
| `obligation_color` — `UIKit.gd:3049` | Maps a schedule obligation kind to its established semantic colour. | No direct test. | **PRIMITIVE** — composed by `obligation_chip`. | `obligation_chip` calls it at `UIKit.gd:3105`. |
| `obligation_text` — `UIKit.gd:3077` | Compresses an obligation to initials plus kind, or a trimmed world-event title. | No direct test. | **PRIMITIVE** — composed by `obligation_chip`. | `obligation_chip` calls it at `UIKit.gd:3114`. |
| `obligation_word` — `UIKit.gd:3070` | Maps a schedule kind to its approved short word. | No direct test. | **PRIMITIVE** — composed by `obligation_text`. | `obligation_text` calls it at `UIKit.gd:3080`. |
| `occupancy_chip` — `UIKit.gd:2401` | A station's current trainee names, or a quiet OPEN marker. | No direct test. | **PRIMITIVE** — composed by `station_tile`. | `station_tile` calls it at `UIKit.gd:2372`. |
| `phase_clock` — `UIKit.gd:4867` | The live set-piece clock cell with caption, large value and optional subline. | No direct test. | **PRIMITIVE** — composed by `setpiece_chrome`. | `setpiece_chrome` calls it at `UIKit.gd:4948`. |
| `phase_shutter` — `UIKit.gd:5328` | The full-screen set-piece gear-change shutter and travelling gold line. | No direct test; root tests disable transitions. | **UNKNOWN** — it is live, but reached dynamically. | `SetpieceRoot.gd:306` invokes it through `script.call("phase_shutter", ...)`. |
| `record_cell` — `UIKit.gd:1335` | A two-line overall and organization record cell. | Yes — `ui_kit_shell_test.gd:68`. | **SUPERSEDED** — the current `ranking_row` record cell. | `ranking_row` formats and mounts its record at `UIKit.gd:5965-5966`, and Rankings uses that row at `RankingsHubPanel.gd:354`. |
| `result_card` — `UIKit.gd:1323` | A trophy result card with winner, result line, stars and a green Next action. | Yes — `ui_kit_shell_test.gd:55`. | **SUPERSEDED** — `verdict_block` plus `settlement_ledger`. | FightResultPanel mounts those purpose-built factories at `FightResultPanel.gd:157` and `FightResultPanel.gd:164`. |
| `scorecard_row` — `UIKit.gd:5147` | One judge's name and two totals, tinting the winning total. | No direct test. | **SUPERSEDED** — FightResultPanel's multi-round, multi-judge card grid. | The current grid starts in `_build_cards` at `FightResultPanel.gd:298` and is mounted at `FightResultPanel.gd:163`. |
| `setpiece_body_rect` — `UIKit.gd:4797` | The body rectangle between set-piece header and foot bands. | Indirect — `setpiece_root_test.gd:152` checks the resulting body contract. | **PRIMITIVE** — composed by `setpiece_chrome`. | `setpiece_chrome` calls it at `UIKit.gd:4931`. |
| `shortlist_pin` — `UIKit.gd:3921` | A hollow or amber star button that toggles a scouting shortlist entry. | No direct test. | **PRIMITIVE** — composed by `prospect_row`. | `prospect_row` calls it at `UIKit.gd:4053`. |
| `stakes_tag` — `UIKit.gd:4842` | The set-piece eyebrow and large title, optionally owning the frame's gold. | No direct test. | **PRIMITIVE** — composed by `setpiece_chrome`. | `setpiece_chrome` calls it at `UIKit.gd:4944`. |
| `station_tile` — `UIKit.gd:2345` | One gym-floor equipment tile with condition, footprint and occupants. | No direct test. | **PRIMITIVE** — composed by `floor_grid`. | `floor_grid` calls it at `UIKit.gd:2458`. |
| `tree_node` — `UIKit.gd:979` | One skill-tree node with icon, state, caption and optional training bar. | Yes — `skill_tree_test.gd:75-82`. | **PRIMITIVE** — composed by `skill_tree`. | `skill_tree` calls it at `UIKit.gd:1079`. |
| `way_out_strip` — `UIKit.gd:4804` | The always-visible, optionally armed set-piece exit strip. | No direct test. | **PRIMITIVE** — composed by `setpiece_chrome`. | `setpiece_chrome` calls it at `UIKit.gd:4942`. |

## Bucket counts

- **SPEND: 0**
- **SUPERSEDED: 10**
- **PRIMITIVE: 20**
- **UNKNOWN: 5**

## Priority ruling

There are **no five SPEND rows to rank**. Assigning five anyway would contradict the audit's evidence and the task's instruction that an honest UNKNOWN beats an invented recommendation.

The useful next action is not a screen task: make the dead-factory detector callable-aware. It should admit digits in declarations (`[a-z0-9_]*`), count internal UIKit composition separately, and detect the three `script.call("...")` transition edges. After those corrections, the only unresolved production candidate in this slice is `ledger_row`; it needs a product decision about whether any current screen genuinely needs its pips contract before it can become SPEND.
