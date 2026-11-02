# K11 DIGEST — SCOUTING hub study (Kalli)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent (COMPLETE).

## A) How one hub holds fighters + staff + offers — recommendation

**TWO TABS: FIGHTERS / STAFF — CONTRACT OFFER is a drawer off the selected row.**

- Home tabs split the two list schemas (fighter stats/record/division vs staff salary/teach/tactical).
- **OFFER** opens as a drawer (K8 `store_drawer` / K9 `session_panel` pattern), never a rail tab and never a third hub destination.
- Rejected **three tabs** (FIGHTERS / STAFF / OFFERS): an offer is always about a person already on a row; putting negotiation on the tab strip recreates a destination orphan.
- Rejected **one list + kind filter**: shared columns fight each other (record vs teach rating), and density collapses.

Why (K8/K9/K10 parallel): one rail item answers *who can we bring in*, the same way GYM answers *who is in the building*, TRAINING answers *what the week is*, and SCHEDULE answers *what happens on which date*. Claude decides in the build; this is the study pick.

## B) Shortlist (one line)

**Pin a world-ref candidate to a gym-save SHORTLIST (filter chip + row star) so the manager can return interested-but-not-ready without opening an offer — the game currently remembers nothing.**

## Boards (1920×1080, ShellChrome)

1. **THE PROSPECTS** — dense FIGHTERS list (STAFF soft tab); filters/sort; affordability flags; shortlist star; MAKE OFFER gold ×1.
2. **THE CANDIDATE** — one opened: stats, gym gap in LW men vs Kian Sterling, honest downside, fit pairs; world ref until signed.
3. **THE OFFER** — drawer: money axis offered vs wanted, refusal in their words, wage-forever affordability; SEND OFFER gold ×1.
4. **STATES** — empty filter / cannot afford / offer refused / shortlist one name / empty world.

## C) Kit gaps (after trying gym + training family)

Reuse first: `squad_row`, `action_flag`, `filter_strip`, `sort_header`, `store_drawer`, `catalog_row`, `affordability_reason`, `session_panel`, `illegal_refusal`. Also profile: `alert_strip`, `tab_bar`, `pair` (slate), `badge`.

| Instrument | Need |
|---|---|
| `prospect_row` | Dual-schema list row (fighter columns vs staff columns) sharing hub rhythm |
| `offer_axis` | Money negotiation rail: offered vs wanted markers + forever wage callout |
| `shortlist_pin` | Persist interested-but-not-ready world ref (star + SHORTLIST chip) |
| `gym_gap_compare` | Candidate vs what gym already holds in that division / coaching slot |
| `offer_drawer` | Contract negotiation surface — `store_drawer` / `session_panel` cousin |

**No drag primitive.** List select / open / offer stay click-arm-click. Do not mint drag unless states are drawn separately.

## Kit rulings obeyed

Bebas / Plex; SIZE_MIN 12; gold ×1 per board; green = CONTINUE only; pair = slate; facility is GYM; females never fight males; weight classes must match; candidates are world refs until signed; no instant sign; cash/wage real; silhouettes; ShellChrome rail + top + CONTINUE; body ~210 rhythm.

## Files

- `SCOUTING_HUB_K11.html` — full study
- `SCOUTING_K11_prospects.png` / `_candidate.png` / `_offer.png` / `_states.png`
- `K11_DIGEST.md` (this file)

## Blockers

None for the study. Build must mint the kit-gap instruments above before SCOUTING rebuilds in Godot. Legacy `RecruitmentScreen` discarded, not migrated. CityScreen / CountryMap left alone (career creation).
