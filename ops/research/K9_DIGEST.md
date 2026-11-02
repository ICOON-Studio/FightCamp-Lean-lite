# K9 DIGEST — TRAINING hub study (Kalli)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent (COMPLETE).

## A) Rail / mode recommendation

**YES — TRAINING holds ordinary week + fight camp on ONE rail item.**

- Home tab: **THE WEEK** (all fighters' 7-day bands).
- **SESSION** is a day-opened editor panel (STORE-drawer pattern off THE WEEK), not a rail tab.
- **FIGHT CAMP** is a **mode** the hub enters when the selected fighter is booked — surfaced as a soft tab that hardens when someone is in camp.

Why (K8 one-rail parallel): ordinary week and fight camp are the same act at two intensities. A second rail destination (or leaving camp under SCHEDULE) recreates the orphan K8 erased for GYM. Claude decides in R22; this is the study pick.

## B) FLOOR ÷ TRAINING (one line)

**FLOOR shows who occupies stations; TRAINING shows what each fighter does with their week — TRAINING never restates station occupancy.**

## Boards (1920×1080, ShellChrome)

1. **THE WEEK** — dense bands: focus chips (STR/CAR/REC/FIGHT/OFF), load, event-night underline, sort/filter, one selected; click day → session.
2. **THE SESSION** — focus, owned equipment, illegal-for-discipline refusal, six regions + fatigue before/after graphic, PASTE / CLEAR; click-arm-click copy (no drag).
3. **FIGHT CAMP** — opponent, weeks-out rail, same-sex sparring only, visiting coach, film, fatigue/injury, pull out; how hub differs from ordinary week.
4. **STATES** — nobody booked / overtrained-injured / camp wk1 vs fight week / unsafe equipment / empty gym.

## Kit gaps (after reusing R21 gym family)

Reuse first: `squad_row`, `action_flag`, `filter_strip`, `sort_header`, `capacity_meter`, `station_tile`, `occupancy_chip`, `floor_grid`, `store_drawer`, `catalog_row`, `affordability_reason`. Also profile: `alert_strip`, `tab_bar`, `pair` (slate), `badge`.

| Instrument | Need |
|---|---|
| `week_band` | Fighter row of seven focus day chips + load + flag |
| `focus_chip` | STRENGTH / CARDIO / RECOVERY / FIGHT / OFF day token |
| `body_delta` | Six regions + fatigue before/after graphic (not table) |
| `session_panel` | Day editor surface (focus + equipment + body + paste/clear) |
| `camp_week_rail` | Eight-week pre-bout strip (base → fight week) |
| `illegal_refusal` | Named discipline/equipment refusal (affordability_reason cousin) |

**No drag primitive.** Copy/paste and any day move stay **click-arm-click** (same ruling as FLOOR MOVE). Do not mint a drag primitive unless states are drawn separately.

## Kit rulings obeyed

Bebas / Plex; SIZE_MIN 12; gold ×1 per board; green = CONTINUE only; pair = slate; facility is GYM (camp word only on board 3); same-sex sparring; silhouettes; ShellChrome rail + top + CONTINUE; body ~210 rhythm.

## Files

- `TRAINING_HUB_K9.html` — full study
- `TRAINING_K9_week.png` / `_session.png` / `_fight_camp.png` / `_states.png`
- `K9_DIGEST.md` (this file)

## Blockers

None for the study. R22 must mint the kit-gap instruments before TRAINING rebuilds in Godot. Fight camp panel under SCHEDULE stays until the mode lands. Legacy `TrainingScreen` discarded, not migrated.
