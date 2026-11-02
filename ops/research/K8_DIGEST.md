# K8 DIGEST — GYM hub study (Kalli)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.
Do not treat this as shipping UI.

## Rail recommendation

**ONE rail item: GYM** — replace both `MY GYM` and `FIGHTERS`.

Hub tabs: **ROSTER** / **FLOOR**. **STORE** is a drawer (or tertiary tab) off FLOOR, never its own rail destination or screen.

Why: the GYM is the daily home (who is in the building + the floor they train on). Two rail entries into the same hub fight the single-active-rail pattern and keep the legacy split the rebuild is meant to erase. Profile stays one click from a selected roster row (R18 already exists).

Claude decides in R21; this is the study pick.

## Boards (1920×1080, ShellChrome)

1. **ROSTER** — FM-like dense squad table: identity (name, age, sex, discipline, division), record, condition, morale, weight vs limit, week plan, next bout, ONE action flag. Sort/filter chips. One selected row.
2. **FLOOR** — equipment grid picture, capacity meter, who trains where, selected station with REPAIR / ROTATE / MOVE.
3. **STORE** — drawer off FLOOR: category filters, price, footprint, affordability / why not.
4. **STATES** — contact sheet: day one / medical hold / fight week / floor full.

## Kit gaps (book lacks; build first)

| Instrument | Need |
|---|---|
| `squad_row` | Dense FM-like roster row (identity stack + metrics + flag) |
| `action_flag` | ONE glyph/chip from profile action set |
| `filter_strip` | State / division / next-bout chips |
| `sort_header` | Clickable column sort on table head |
| `floor_grid` | Buildable tile grid with footprints |
| `station_tile` | Equipment cell: name, condition, occupant |
| `occupancy_chip` | Who trains at a station this week |
| `capacity_meter` | Used / capacity / expand cost |
| `store_drawer` | Slide-over catalog off FLOOR |
| `catalog_row` | Price + footprint + affordability |
| `affordability_reason` | NO CASH / NO SPACE (not a silent disable) |

Reuse from profile where they fit: `alert_strip`, `tab_bar`, `pair` (slate), `badge`.

## Kit rulings obeyed

Bebas / Plex; SIZE_MIN 12; gold ×1 per board; green = CONTINUE only; pair = slate; GYM not camp; age in fighter headers; silhouette avatars only; ShellChrome rail + top + CONTINUE.

## Files

- `GYM_HUB_K8.html` — full study
- `GYM_K8_roster.png` / `_floor.png` / `_store.png` / `_states.png`
- `K8_DIGEST.md` (this file)

## Blockers

None for the study. R21 must mint the kit-gap instruments before the hub is rebuilt in Godot. NAV_ITEMS still lists MY GYM + FIGHTERS until rail lands.
