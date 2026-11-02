# G155 — Camp choices show what they do

Every camp focus shows its camp-total effect before it is committed. The projection opens on the balanced camp. START CAMP stays disabled until a focus and a protocol are both chosen. No camp rule moved. `FightCamp.gd` and `GameState.gd` are untouched.

## Census

`FightCampPanel.gd` was 1,271 lines. The projection already recomputed on every pick (`last_projection`, the setup column). It was empty on the first frame because the panel only painted a projection when `GameState.get_camp_board` said the choices were valid.

`GameState._validate_fight_camp_choices` returns `CHOOSE A CAMP FOCUS` while focus is `""`, and `CHOOSE A PROTOCOL` while protocol is `""`. `_camp_board_setup` fills `setup.projection` only when that validation is ok. The default choices are focus `""`, protocol `""`, partner role `mirror`, cut `moderate`. The panel then drew `ProjectionEmpty` titled `NOTHING TO PROJECT YET`. That is the empty space D66 called "nothing to choose yet".

The math was never missing. `FightCamp.projection` of an empty focus is a real balanced camp: gain defaults to 1, no focus edge is banked, film still accrues, the last week is the taper. `week_effects`, `projection`, `edge_lines`, `track`, `gain_scale`, `document`, and `focus_blocked_reason` are already public, so `FightCamp.gd` did not need a new read.

What each focus actually moves, from `fight_camp.json` through `week_effects` (per week, then a cap; gain scale includes protocol, diet, and the taper):

| Focus | Banks | Also |
| --- | --- | --- |
| The Striking Shark | `strike_success` [0.01, cap 0.03] | `tightness_per_week` 4 |
| The Mat Mechanic | `takedown_mult` [0.05, cap 0.15], `sub_defense` [2, cap 6] | needs ground; locked under boxing |
| The Marathon Man | `stamina_discount` [0.04, cap 0.12], `round_reset` [1.5, cap 4] | `fatigue_relief` 2 |
| The Human Shield | `defense_bonus` [0.015, cap 0.05], `head_damage_taken` [0.07, cap 0.2] | `injury_scale` 0.7 |

`load_scale` is in the JSON and is not read by `week_effects`, so it is not a tile. `injury_scale` only changes injury risk when the protocol's injury base is above 0, so a Human Shield card with no protocol shows no injury tile. `head_damage_taken` is stored as a positive edge (less damage taken). `edge_lines` prints that edge as a negative percent; the card and the projection compare the stored delta, and the tooltip quotes the JSON.

## What a card shows

Icon plus the signed camp total versus no focus, at the same other choices. The tooltip is the FightCamp source line (per week, cap, gain scale, diet, taper, weeks), then the scouting read, then the adjustment. The old per-week detail stays on the card for the existing focus-tip test and is drawn as one ellipsized line. The number on the tile is the camp total, which is what the projection moves by.

| Stat | Icon |
| --- | --- |
| Strike success | `target` |
| Takedown weight | `biceps-flexed` |
| Submission defence, defence bonus | `shield` |
| Stamina discount | `heart-pulse` |
| Round reset | `timer` |
| Head damage taken | `heart` |
| Tightness | `zap` |
| Fatigue on the night | `activity` |
| Injury risk | `triangle-alert` |
| Opponent reads | `eye` |
| Duel drill | `swords` |
| Composure | `user` |

The scouting read is the opponent's plan name and stance, plus that plan's `coach_line`. The adjustment is display-only. It does not change `week_effects`, the JSON, or validation. Grappling emphasis recommends the Mat Mechanic, then the Human Shield. Striking with an aggressive opening recommends the Human Shield, then the Marathon Man. Other striking recommends the Striking Shark. An aggressive opening that is not a striking or grappling plan recommends the Marathon Man. An unread or balanced plan stays on the balanced camp. A track the rules lock is skipped. The recommended card gets a gold `target` named `StyleAdjust`.

On a five-week boxing camp the Striking Shark tile is strike success `+0.03` (the cap) and tightness `+18`. Picking it moved the projection by those exact numbers. START CAMP stayed disabled until Technical Flow was also picked, and then `last_projection.ok` was true.

## Edited ranges in `Godot/scripts/FightCampPanel.gd`

The file is now 1,686 lines.

| Lines | What |
| --- | --- |
| 31 | Preload `FightPlans`. |
| 53–67 | `EFFECT_ICON`. |
| 75, 93 | `_math_cache`, cleared at the start of `_rebuild`. |
| 231–247 | Focus cards are 100 px tall. Each one mounts its effect tiles and, when it is the recommendation, `StyleAdjust`. |
| 250–334 | The left column moves down with the taller cards: protocol 230/250, partner 326/346/382, coach 454/474, counter 546/566, diet 638/658, scale 734, footnote 790. |
| 381–414 | The projection body. A committed board projection is shown when validation passed. Otherwise the balanced `FightCamp.projection` is shown with `ok` forced false. `ProjectionEmpty` is never created. `ProjectionStats` carries the numbers. START CAMP is disabled unless the board projection is ok. |
| 1098–1115 | Leaving a focus card defers the unhover, and aborts it when the pointer is still inside a `FocusCard_*` button, so an effect tile does not wipe the hover. |
| 1220–1686 | Camp-total deltas, tiles, tooltips, scouting read, and the recommendation. Effect tiles are named `EffectTile_<stat>` and forward a left click to the card. Shape tiles in the projection are `ShapeTile_<stat>`. |

`FightCamp.gd` was not edited. Hover still builds `HoverLabel` and `HoverEdges`. Technical Flow still has `FatigueFigure` and `InjuryFigure`. After a focus and a protocol, the projection still has `FatigueOnTheNight` and `InjuryRisk`.

## Proof

Parse gate before the first test, on `FightCampPanel.gd`, `camp_consequences_test.gd`, and `g155_camp_stills.gd`: `CHECK total=3 fails=0`. After the detail line was ellipsized: `CHECK total=1 fails=0` on the panel. Before the final stills: `CHECK total=1 fails=0` on `g155_camp_stills.gd`.

`camp_consequences_test.gd` (headless): `camp_consequences_test: 0 failure(s)`. No `ProjectionEmpty`. Scouting read and adjustment are on screen with no pick. The first frame is the balanced projection and START CAMP is disabled. All four focus cards have at least one effect tile whose tooltip contains `FightCamp`, `Scouting read`, and `Your adjustment`. Picking the Striking Shark moved `edges.strike_success` by `0.03` and `tightness` by `18.0`, matching the tiles. A focus alone left START CAMP disabled. Focus plus Technical Flow armed it on `last_projection.ok`.

Watchdog `2026-10-01 22:12:50` GREEN, then `run_tests.py --jobs 2 --only camp,fight_camp,gf1,smoke,ui_kit`: `SUITE total=12 fails=0`. The twelve were `camp_board_api_test`, `camp_consequences_test`, `fight_camp_panel_test`, `fight_camp_test`, `gf1_body_fatigue_tips_test`, `gf1_card_skills_tips_test`, `gf1_finance_floor_tips_test`, `gf1_offers_camp_tips_test`, `smoke_test`, `ui_kit_book_test`, `ui_kit_shell_test`, `ui_kit_test`.

Watchdog `2026-10-01 22:14:26` GREEN, then windowed stills through `Tools/godot_hidden.ps1` (`tools/g155_camp_stills.gd`). The open-slot opponent was stamped `boxing_pressure` / southpaw (`STAMPED Thiago Park as boxing_pressure southpaw`). The three PNGs were opened after capture.

| File | In frame |
| --- | --- |
| `previews/g155/balanced.png` | Balanced projection (tightness 50, film 3/3 at fight day, injury 0%). Header film is 0. No focus edges. Gold target on The Human Shield. START CAMP disabled, `CHOOSE A CAMP FOCUS`. |
| `previews/g155/striking_shark.png` | Shark selected. Tightness 68. Shape banks `+0.03` strike success. `CHOOSE A PROTOCOL`. |
| `previews/g155/human_shield.png` | Human Shield selected, the recommended card. Defence `+0.05`, head-damage edge `+0.2`. Tightness back to 50. |

This is a Godot desktop panel. It was verified by the scene-tree test, the 12-test suite, and those stills. It was not verified in a browser.
