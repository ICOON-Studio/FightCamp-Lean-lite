# K12 DIGEST — OFFICE + STAFF hub study (Kalli)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent (COMPLETE).

## A) What is OFFICE now — does STAFF stay on the rail?

**PICK (1): OFFICE = gym business hub + STAFF stays its own rail item.**

- OFFICE tabs: **THE DESK** / **THE BOOKS** — cash, payroll both ways, upkeep, one-week projection, purse on the books, contracts, weekly objectives + CLAIM.
- **STAFF** remains a rail destination: coaches, capacity, assignment, wages, **rapport** (first visibility).
- Rejected **(2)** one OFFICE holding all six as tabs (staff buried under desk noise; people-work ≠ paperwork).
- Rejected **(3)** dissolve — contracts + objectives still need one business surface; scattering them recreates the orphan K8 erased for GYM; money-only rail is too thin.

Why (K8–K11 parallel): GYM holds who is in the building, TRAINING what the week is, SCHEDULE what happens on which date, SCOUTING who can be brought in. OFFICE answers *what the gym owes and is owed*; STAFF answers *who develops the fighters after hire*. Claude decides in the build; this is the study pick.

## B) SCOUTING ÷ STAFF (one line)

**SCOUTING signs a coach onto the gym; STAFF assigns them, tracks capacity / wages / rapport / corner afterwards — neither restates the other's list.**

## C) WEIGHT CLASS (one line)

**Action off a fighter** (GYM row / fighter profile action) — not a drawer destination and not an OFFICE place; drawn once on THE BOOKS board as the placement call, with refusal states on STATES.

## D) PHONE & RELATIONSHIPS

**Leave out of OFFICE.** Attention items are real but relationship tracking is unfinished — do not dress it as a working feature. If attention needs a home later, it belongs on THE DAY, not a fake phone module on the desk.

## Boards (1920×1080, ShellChrome)

1. **THE DESK** — OFFICE home: cash, athlete payroll, staff payroll, upkeep, purse on books, projection one week out; gold ×1 OPEN BOOKS.
2. **THE STAFF** — STAFF rail: coaches, capacity meter, ratings, assignment, **rapport fighter×coach actionable** (click-arm-click, no drag); gold ×1 ASSIGN FIGHTER.
3. **THE BOOKS** — contracts + purse/bonus + weekly objectives; gold ×1 CLAIM; weight-class action drawn once (not a tab).
4. **STATES** — no coaches / over capacity / expiring contract / can't cover payroll / all objectives claimed / fighter no coach / weight-class refuse with reason.

## E) Kit gaps (after trying gym + training family)

Reuse first: `squad_row`, `action_flag`, `filter_strip`, `sort_header`, `affordability_reason`, `capacity_meter`, `session_panel`, `illegal_refusal`. Also profile: `alert_strip`, `tab_bar`, `pair` (slate), `badge`.

| Instrument | Need |
|---|---|
| `desk_ledger` | Cash / payroll both ways / upkeep / purse / one-week projection |
| `rapport_pair` | Actionable fighter×coach reading (score + assign/corner) — not a matrix |
| `contract_term_row` | Athlete/staff term left + wage + expiring flag |
| `objective_claim` | Weekly objective track + gold CLAIM (cash + fame) |
| `assign_arm` | Click-arm-click coach→fighter states (idle / armed / assigned) |
| `weight_move_action` | Fighter-off action: from→to + weeks body work + belt/points consequence |

**No drag primitive.** Assignment stays click-arm-click (R21/R22). Do not mint drag unless states are drawn separately.

## Kit rulings obeyed

Bebas / Plex; SIZE_MIN 12; gold ×1 per board; green = CONTINUE only; pair = slate; facility is GYM; females never fight males; weight classes must match; money only from task list; silhouettes; ShellChrome rail + top + CONTINUE; body ~210 rhythm; OfficeHub.gd discarded not migrated; CityScreen / CountryMap / K7 set-piece left alone.

## Files

- `OFFICE_HUB_K12.html` — full study
- `OFFICE_K12_desk.png` / `_staff.png` / `_books.png` / `_states.png`
- `K12_DIGEST.md` (this file)

## Blockers

None for the study. Build must mint the kit-gap instruments above before OFFICE / STAFF rebuild in Godot. Legacy `OfficeHub` discarded, not migrated. NAV keeps OFFICE + STAFF as separate rail items under pick (1).
