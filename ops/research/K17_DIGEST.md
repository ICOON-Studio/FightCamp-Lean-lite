# K17 DIGEST — THE PHONE / RELATIONSHIPS (Kalli)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent.
No HANDOFF.md edits from this study.

## A) Locked verdict

**DISSOLVE PHONE** as a destination / rail item / OfficeHub module.

"PHONE" was a legacy OfficeHub placeholder label. Do **not** invent a phone UI,
a dialer, or a third people-surface next to STAFF.

What actually exists (verified in code — invent nothing):

| Pillar | Module / storage | Home |
|---|---|---|
| **1. Coach rapport** | `CoachRapport.gd` · `athlete["coach_rapport"]` map | **STAFF** (R26 already surfaces on assignment) |
| **2. Loyalty** | `GameState.get_athlete_loyalty(athlete_id)` via `Retention` | **Fighter profile CONTRACT tab** |
| **3. Fighter rivalries** | `Rivalries.gd` · `career["rivalries"]` · Stage R2 | **Fighter profile Fight Record** (RIVALRIES shelf) + **THE DAY** attention |

Rivalries are fighter↔fighter. `get_rival_gyms` is a separate world list — not this shelf.

## B) Rejects

- **Own rail PHONE or RELATIONSHIPS** — third people-surface next to STAFF; duplicates; phone metaphor is fiction.
- **STAFF tab for rivalries** — coach work ≠ grudges.
- **Locker-room friendship / teammate opinion matrix** — no save state; invent nothing.

## C) Where rivalries live

- **Heat list + band** on the **fighter profile Fight Record** tab as a small **RIVALRIES shelf** (not a new tab destination; not STAFF).
- **Attention** (new callout, grudge offer ready, heat spiked) on **THE DAY** — matches K12_DIGEST D: *"If attention needs a home later, it belongs on THE DAY"*.
- **Booking a grudge** stays through existing offer / request flows (**SCHEDULE / asks**), not a phone dialer.

## D) "Who is unhappy and why" — one place, no new screen

**THE DAY attention strip** aggregating three existing reads (call directly — do **not** invent a unified relationships API):

1. **Loyalty red/amber alerts** — `GameState.get_athlete_loyalty(athlete_id)` (score, band, parts, `striking`, contract weeks, pay vs market). Profile alert paths already emit ON STRIKE (red) and strained-band amber lines.
2. **Active rivalry heat bands** for roster fighters — `get_athlete_rivalries(athlete_id)` / `get_rivalries()` (heat 0–100, band, source, grudge_match flag).
3. **Open rematch / grudge offers** — `get_rivalry_fight_offers()` / `get_rivalry_fight_offer(athlete_id, rival_id)` (label, purse, rivalry_heat, band).

## E) Optional Codex/Claude polish gap (not required to dissolve PHONE)

`get_day_relationship_attention()` aggregating the three reads above — optional later polish only. THE DAY can call the three reads directly today.

## F) GameState / module reads named

| Read | Shape / notes |
|---|---|
| `CoachRapport.get_rapport` / athlete map | 0–100 per coach_id; bands toxic→excellent |
| `get_athlete_loyalty(athlete_id)` | score, band, parts, market_salary, weekly_salary, contract_remaining_weeks, striking |
| `get_rivalries()` | raw `career["rivalries"]` array |
| `get_athlete_rivalries(athlete_id)` | hottest-first; rival_name, heat, band, wins/losses/draws, grudge_match, weeks_since_contact, source |
| `get_rivalry_fight_offer` / `get_rivalry_fight_offers` | grudge when heat ≥ 30 + same class/sex; label `GRUDGE MATCH · BAND`; purse × heat |
| `get_rival_gyms` | **separate** world gym list — not fighter rivalry shelf |

Bands (rivalries.json): COLD 0 · SIMMERING 1–29 · HEATED 30–59 · BAD BLOOD 60–84 · BLOOD FEUD 85–100. Grudge min heat = 30.

## G) Kit gaps

Reuse first: `alert_strip`, `tab_bar`, `pair` (slate), `badge`, `squad_row` rhythm, silhouettes, profile CONTRACT instruments, STAFF `rapport_pair` (K12).

| Instrument | Need |
|---|---|
| `rivalry_row` | silhouette · rival name · heat · band · source · grudge chip |
| `heat_band` | compact 0–100 bar + band chip (COLD→BLOOD FEUD) |
| `day_attention_chip` | red/amber/pip row on THE DAY strip (loyalty / heat / grudge) |

**No drag primitive. No phone chrome.**

## Boards (1920×1080, ShellChrome)

1. **VERDICT** — dissolve map: three pillars → homes; PHONE crossed out on rail; gold ×1 OPEN THE DAY
2. **RIVALRIES** — Kian Sterling Fight Record shelf; heat rows from get_athlete_rivalries shape; gold ×1 GRUDGE OFFER
3. **ATTENTION** — THE DAY strip: loyalty strike + heat spike + grudge pip; calm feed below; gold ×1 VIEW RIVAL

## Kit rulings obeyed

Bebas / Plex; SIZE_MIN 12; gold ×1 per board; green = CONTINUE only; pair = slate; facility is GYM; silhouettes; invent nothing beyond plausible sample labels consistent with prior Kian Sterling studies; ShellChrome rail + top + CONTINUE.

## Files

- `PHONE_K17.html`
- `PHONE_K17_verdict.png` / `_rivalries.png` / `_attention.png`
- `K17_DIGEST.md` (this file)

## Blockers

Study unblocked. No build required to dissolve PHONE — homes already exist. Optional aggregator is polish-only. Parent owns any HANDOFF note.
