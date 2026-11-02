# K10 DIGEST — SCHEDULE & EVENTS hub study (Kalli)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent (COMPLETE).

## A) One rail vs two — recommendation

**ONE rail item: SCHEDULE** — fold today's separate EVENTS into it.

- Tabs: **MY MONTH** / **THE CARDS**.
- **EVENT** is a drill-in off a cards row (SESSION-drawer pattern from K9), not a rail tab and not a third hub destination.
- Rail line **EVENTS** disappears; its badge moves onto **SCHEDULE**.

Why: both answer the same question — *what happens on which date*. K9 moved fight camp to TRAINING, so SCHEDULE lost the tenant that once justified a split. Keeping two rail entries into the same dated-facts problem recreates the orphan K8 erased for GYM. A filter-fold of world cards into the month grid was considered and rejected: scanning fourteen world rows is a different surface from a dense gym month, so two tabs stay; one rail is enough. Claude decides in the build; this is the study pick.

## B) DAY ÷ SCHEDULE (one line)

**THE DAY tells what today holds; SCHEDULE shows dated obligations across the month and the world's cards — SCHEDULE never restates today's briefing.**

## Boards (1920×1080, ShellChrome)

1. **THE MONTH** — Mon–Sun gym obligations (FIGHT / MEDICAL / RECOVERY / WORLD + deadlines / weigh-ins / contracts); light month vs heavy day with three stacked chips + side list.
2. **THE CARDS** — six-column world table; filters (mine / division / org / bookable); booking bar + Match Sim on the selected row (not a second screen).
3. **THE EVENT** — bout list, my slot, tale of the tape, purse / win bonus; **seam into K7 set-piece frame** drawn, frame not redrawn; gold on ENTER FIGHT WEEK.
4. **STATES** — empty month / event with no roster fighter / past results / weight-class refusal with reason / empty cards board.

## C) Kit gaps (after trying R21 gym family)

Reuse first: `filter_strip`, `sort_header`, `action_flag`, `affordability_reason` (weight-class / ♀≠♂ refusal), `alert_strip`, `tab_bar`, `pair` (slate), `badge`, `squad_row` rhythm for event/bout density. Skip kit/index this pass — gym family listed in TASK covers the filtered table.

| Instrument | Need |
|---|---|
| `month_grid` | Mon–Sun calendar of gym dated facts (**known kit gap**) |
| `day_cell` | One date cell: number + stacked obligation chips + today/sel/heavy |
| `obligation_chip` | FIGHT / MEDICAL / RECOVERY / WORLD / DEADLINE / WEIGH-IN / CONTRACT token |
| `event_row` | Cards table row: day/date/org/discipline/name/location + relevance flag |
| `bout_row` | Event bout line: corners, purse, result, my-slot highlight |
| `setpiece_seam` | Handoff strip into K7 frame (shutter cue + ENTER FIGHT WEEK) — not the frame itself |

**No drag primitive.** Month and cards stay click-select / click-open. Do not mint drag unless states are drawn separately.

## Kit rulings obeyed

Bebas / Plex; SIZE_MIN 12; gold ×1 per board; green = CONTINUE only; pair = slate; facility is GYM; **no fight camp on these boards**; females never fight males; weight classes must match; silhouettes; ShellChrome rail + top + CONTINUE; body ~210 rhythm.

## Files

- `SCHEDULE_HUB_K10.html` — full study
- `SCHEDULE_K10_month.png` / `_cards.png` / `_event.png` / `_states.png`
- `K10_DIGEST.md` (this file)

## Blockers

None for the study. Build must mint `month_grid` (+ cousins above) before SCHEDULE rebuilds in Godot. NAV_ITEMS still lists SCHEDULE + EVENTS until the one-rail pick lands. Legacy `ScheduleBoard` / `EventsBoard` / `EventDetailScreen` discarded, not migrated.
