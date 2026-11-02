# K13 DIGEST — CAREER CREATION study (Kalli)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent.

## A) Shape

**PICK: ONE FLOW WITH STEPS** — single CreationFlow under CreationChrome (COUNTRY → CITY → GYM). Committed trail keeps market + city visible so step 3 is never blind.

- Rejected **three scenes**: separate loads kill memory of prior choices unless every scene rebuilds a summary (the 2026-08 half-blind pattern).
- Rejected **one board swap middle** (alone): without step chrome, "where / how far" is unanswered once ShellChrome is gone. Middle-swap may be the implementation inside the flow — not the product shape.

## B) Chrome vs K7

**Own CreationChrome** — brand + horizontal step strip (1/2/3) + BACK + committed trail + body. Do **not** reuse K7 set-piece frame (way-out / stakes / clock / names = fight gear). Do **not** extend ShellChrome (rail + Continue = career-only).

Step 2 of 3 reads as CITY lit, COUNTRY checked, GYM dim on the step strip — no rail required. Gold ×1 = forward action. Green Continue appears only when ShellChrome locks on the handoff settle frame.

## C) What each decision needs

| Step | On screen (APIs) | Leave out |
|---|---|---|
| COUNTRY | `get_country_combat_profile` + `get_country_data`: economy, talent depth, combat popularity (+ specialty / gym count support) | rivals, orgs, events, coaches, prospects |
| CITY | `get_rival_gyms`, `get_world_organizations`, `get_world_events` | full `get_world_coaches` / `get_world_prospects` (SCOUTING after save); floor editing |
| GYM | name + starter floor (`generate_starter_boxing_floor`) + starter roster take | store / repair / assign (GYM hub day one+) |

## D) Handoff → THE DAY

Draw the seam: OPEN GYM → CreationChrome fold (180) → K7-style shutter (220) → ShellChrome lock on THE DAY (240) → settle (140) = **780 ms**. **K7 language inverted** — creation installs the shell; K7 removes it. Not the K7 frame itself. Green CONTINUE is legal only after shell arrives.

## E) MainMenu (one line)

**Own rebuild stage** — slots / load / settings is boot plumbing, not the country→city→gym decision chain.

## F) Kit gaps (after gym / training / schedule / scouting families)

Reuse first: `pair` (slate), `badge`, `alert_strip`, `filter_strip`, `squad_row` rhythm, `capacity_meter`, `floor_grid` cousin, `illegal_refusal`.

| Instrument | Need |
|---|---|
| `creation_chrome` | Pre-career frame: brand + steps + BACK + trail — no rail / Continue |
| `step_strip` | 1/2/3 done / current / ahead |
| `committed_trail` | Country → city chips so step 3 remembers 1+2 |
| `market_card` | Economy / talent / combat popularity for a country |
| `city_intel` | Rivals + orgs + events for one city |
| `starter_take` | Starter floor tiles + roster silhouettes before OPEN GYM |
| `creation_seam` | CreationChrome fold → shutter → ShellChrome THE DAY (K7 inverted) |

**No drag primitive.** States drawn: nothing chosen / market no detail / empty name / back-out.

## Boards (1920×1080, CreationChrome — not ShellChrome)

1. **THE COUNTRY** — markets with economy / talent / combat popularity; gold CHOOSE MARKET
2. **THE CITY** — rivals, orgs, events; trail shows country; gold ENTER CITY
3. **THE GYM** — name, starter floor + roster take; gold OPEN GYM
4. **THE HANDOFF** — save → THE DAY seam (K7 shutter inverted)
5. **STATES** — nothing chosen / no detail / invalid name / back-out

## Kit rulings obeyed

Bebas / Plex; SIZE_MIN 12; gold ×1 per board; green = Continue only on handoff shell settle; pair = slate; facility is GYM; females never fight males; weight classes match; silhouettes; no ShellChrome on creation boards; invent nothing beyond listed APIs.

## Files

- `CREATION_K13.html`
- `CREATION_K13_country.png` / `_city.png` / `_gym.png` / `_handoff.png` / `_states.png`
- `K13_DIGEST.md` (this file)

## Blockers

None for the study. Build must mint CreationChrome + kit-gap instruments before discarding CountryMap / CityScreen / GymHub. MainMenu stays a separate stage. Do not mount K7 set-piece chrome on this path.
