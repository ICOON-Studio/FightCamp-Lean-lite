# K15 DIGEST — THE RANKINGS (Kalli)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent.

## A) Placement

**PICK: OWN RAIL ITEM — RANKINGS.** Add `["RANKINGS", "rankings"]` to `ManagementChrome.NAV_ITEMS`. The route already exists (`SceneRouter` nav id); the rail forgot it — that is a **bug**, not a verdict that rankings do not matter. The question *who stands where in the world* is distinct from SCOUTING (*who can we sign*), SCHEDULE (*what happens when*), and GYM (*who is in the building*).

- Rejected **WORLD hub** (rankings + orgs + world events): organisations and world-event surfaces already lean on SCHEDULE / OFFICE; bundling three thin surfaces into a new destination delays the one board that already has real APIs.
- Rejected **SCOUTING tab**: ranked ≠ available. Mixing world order with recruitment confuses the seam (E) and recreates a destination orphan inside SCOUTING.
- Rejected **dissolve into division asks**: no home when the player is not mid-ask; first-career empty still needs a place to learn the world.
- "Keep it unreachable" is not an option — earn a way in or go. This study earns the rail.

## B) Default open

**Open on THE DIVISION for the focused fighter’s discipline × weight × sex.** Sex is **locked to that ladder** (females never fight males — separate lists). Player **asks for**: other weight, other discipline, P4P tab, CHAMPIONS tab. Do **not** force discipline × weight × sex × tab before a name.

## C) Ranking row

**Carry:** `#` · silhouette · name · record (W-L-D) · movement since last week (↑↓—) · belt chip if champ · vs-ours (AHEAD / BEHIND / OUR) · gym/world mark.

**Leave off:** bookable, wage, full stats, scouting affordability, city minutiae. Ranked order is not a booking desk and not a recruitment list.

## D) Where WE are

**OUR chip + gold edge wash + auto-scroll into view** on FIND OURS / default land. Honest first-career (nobody ranked): calm strip *"Nobody from [gym] is ranked yet"* above the still-visible world ladder; FIND OURS disabled — **not BAD**, not generated fiction.

## E) Seam out

| Row | Press |
|---|---|
| Ours (gym) | Fighter card / profile |
| World ranked | Read-only world peek / scouting candidate **VIEW only** |
| No card | Nothing |

**Never MAKE OFFER from rankings.** Ranked ≠ available. SCOUTING still owns signing.

## F) Champions

**Part of this board as CHAMPIONS tab** (not own board, not strip-only). Lists `get_championships()` holders and vacancies; `get_champion_superfight_offers` as a secondary note under the selected belt. **K7 owns CROWNING** — do not restate the ceremony. Vacant stays VACANT; invent nothing.

## G) Kit gaps (after scouting / gym / schedule / office)

Reuse first: `tab_bar`, `filter_strip`, `sort_header`, `squad_row` rhythm, `alert_strip`, `pair` (slate), `badge`, silhouettes.

| Instrument | Need |
|---|---|
| `ranking_row` | # / silhouette / name / record / move / belt / vs-ours / gym mark |
| `ladder_scope` | Compact division identity (discipline + weight + sex-locked) — not four free pickers |
| `our_in_ladder` | OUR chip + gold edge + scroll-to target |
| `belt_holder_row` | Belt · holder · vacant state |
| `vacant_belt_state` | Honest empty holder — no invented champ |
| `empty_gym_ranked` | Calm first-career strip when gym has nobody ranked |

**No drag primitive.**

## Boards (1920×1080, ShellChrome)

1. **THE DIVISION** — LW men ladder, default on Kian Sterling #8; gold ×1 FIND OURS
2. **P4P** — cross-division same-sex list; asked-for; gold ×1 FIND OURS
3. **CHAMPIONS** — belts tab; vacant FW; K7 note; gold ×1 OPEN HOLDER
4. **STATES** — nobody ranked / vacant belt / ours visible / nothing generated

## GameState reads the build needs that may not exist yet

Existing (TASK): `get_division_rankings` · `get_p4p_rankings` · `get_championships` · `get_champion_superfight_offers`.

**Gaps to confirm before build:**
- **Movement delta** / prior-week snapshot for ↑↓— (not named in TASK APIs)
- **is_ours / gym membership** on ranking entries for OUR highlight
- **Focused-fighter division helper** (discipline × weight × sex) for default open

## Kit rulings obeyed

Bebas / Plex; SIZE_MIN 12; gold ×1 per board; green = CONTINUE only; pair = slate; facility is GYM; ♀≠♂ separate ladders; silhouettes; invent nothing; ShellChrome rail + top + CONTINUE; body ~210.

## Files

- `RANKINGS_K15.html`
- `RANKINGS_K15_division.png` / `_p4p.png` / `_champions.png` / `_states.png`
- `K15_DIGEST.md` (this file)

## Blockers

Study unblocked. Build needs NAV_ITEMS + kit-gap instruments above; confirm movement / is_ours / focused-division reads. Legacy `RankingsBoard.gd` discarded in rebuild, not migrated (Claude owns build; this study did not open it).
