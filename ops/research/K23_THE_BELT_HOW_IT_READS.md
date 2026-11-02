# K23 — THE BELT, HOW IT READS (Kalli)

Study only. No `.gd` / `.tscn`. Deliverable: this file under `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent. No HANDOFF.md edits.
Cite C26 reads + M7 tokens; invent no art, no GameState writes, no belt-on-scale (R42).

---

**Claude acts on this:** Belts stay under RANKINGS · **CHAMPIONS** (no new rail). Overview rows from `get_championships_read()` dressed with M7 SODIUM / ICE / MUTED marks; interim name secondary in drill-in only (overview: recognised champ + small INTERIM chip). Schedule/event rows: SELECT **TITLE BOUT** when `get_bout_title_stakes.stamped && is_title_bout`; `stamped==false` reads **PENDING**, never NO. Reign: defenses primary in drill-in. Ranked build order + kit gaps below.

---

## Ranked build order (top = first stage)

1. Wire `RankingsHubPanel` CHAMPIONS to `get_championships_read` + `belt_overview_row` + M7 marks
2. Drill-in panel: interim secondary + reign + contenders
3. Schedule/event TITLE BOUT + PENDING from `get_bout_title_stakes`
4. Fighter card title marks via `get_athlete_titles` dressed M7
5. Fight-night header chip when stamped title
6. Light DIVISION tab belt mark polish

---

## 1. WHERE IT LIVES

**PICK: tab under RANKINGS (CHAMPIONS), not a new rail item.**

K15 already put RANKINGS on the rail with tabs THE DIVISION / P4P / CHAMPIONS. Belts and the ladder are the same subject (world order). Cost of a new BELTS rail: one more item to learn, splits the glance the player already uses for "who stands where". Cost of drill-in-only off a division with no CHAMPIONS home: belts stay orphaned when you are not mid-ask.

- KEEP the CHAMPIONS tab; REPLACE its raw `get_championships()` row with C26 `get_championships_read()` + M7 marks.
- **REJECT** own rail.
- **REJECT** dissolve into division-only.

## 2. LIST vs DRILL-IN

**Overview row** (per belt from `get_championships_read`):

- belt mark (M7 SODIUM / ICE / MUTED) · `division_label` (or weight when scoped by discipline) · holder name OR VACANT · `is_ours` tint · optional SELECT title-bout-soon chip if a stamped title bout exists for that key (calendar join — if too heavy, omit on overview).

**Drill-in** (select row / open division belt panel):

- full holder card + interim secondary line when `is_interim` · reign strip · top five from `contenders[]` · `champion_unavailable_weeks` / M6 HELD next to recognised champ if held · `vacated_by` note if any · OPEN HOLDER (gold×1) when holder exists.

Contenders belong in drill-in, **NOT** on every overview row (18 orgs × classes = too long).

## 3. INTERIM BESIDE CHAMPION

Follow M7 exactly:

- one belt mark (**ICE** while interim)
- recognised name **SODIUM** (+ optional HELD)
- standing-in name **ICE** secondary inside same holder band
- never two champion chips

Overview row: show recognised champ name + small INTERIM chip (or ICE mark only) — do **NOT** print interim name on the overview (avoids two-champ glance). Interim name only in drill-in.

Copy: "standing in" / "provisional" — never "co-champ".

## 4. TITLE BOUT BEFORE FOUGHT

Where:

- (a) Schedule hub / event card / bout row — SELECT **TITLE BOUT** chip when `get_bout_title_stakes.stamped && is_title_bout`
- (b) fight-week / fight-night frame header — same chip
- (c) fighter card — only if that bout is theirs and stamped title

Ordinary bout with champion in it: **NO** title chip, **NO** belt mark on the cell (M7 calendar rule).

Unification: same TITLE BOUT + `for_interim` / `unification` flags may add ICE "UNIFY" sublabel — stakes board not ceremony.

## 5. stamped honest field

UI vocabulary from C26 `get_bout_title_stakes`:

| stamped | is_title_bout | UI |
|---------|---------------|-----|
| false | (any) | **PENDING** / "Title TBD" / muted dash — NEVER "not a title bout", NEVER hard NO |
| true | false | silent ordinary bout |
| true | true | TITLE BOUT SELECT |

Announced open slot with no second name: PENDING, not vacant-belt chrome.

## 6. REIGN

Earns space in drill-in only (CONDITION / LINK instruments per M7):

1. **defenses** — primary
2. **since_week** — second
3. `last_defended_week` — tertiary / optional

Overview: no reign numbers (too dense). Interim "standing since" in ICE under provisional name in drill-in only — never as champ defenses.

## 7. WHAT CHANGES ON EXISTING SURFACES

| Surface | Change | Worth it |
|---------|--------|----------|
| `RankingsHubPanel.gd` CHAMPIONS `_build_champions` (~392+) | YES — swap to `get_championships_read` + M7 row/mark; drill-in panel | **Yes** — this is the home |
| `ManagementChrome.gd` NAV_ITEMS | NO new rail item | — |
| `ScheduleHubPanel.gd` bout/event rows | YES — `get_bout_title_stakes` for TITLE BOUT / PENDING | **Yes** — booking-time flag is useless if calendar mute |
| Fighter / athlete card (title strip via `get_athlete_titles`) | YES — dress with M7 champion/interim marks | **Yes** — small |
| Fight-night frame header | YES if bout stamped title — one SELECT chip | **Yes** |
| Ranking DIVISION tab champion strip | light — M7 mark + status if belt exists; do not duplicate full CHAMPIONS | Worth a small pass |
| GameState reads | Do NOT change (C26 done) | — |
| belt-on-scale | Do NOT invent (R42) | — |

## 8. KIT GAPS

Instruments build needs; M7 owns fills.

| Instrument | Need |
|------------|------|
| `belt_status_mark` | Three fills SODIUM / ICE-outline / MUTED — M7 geometry |
| `belt_overview_row` | mark + label + holder/VACANT + `is_ours` + optional INTERIM chip |
| `belt_drill_panel` | holder band (champ + interim secondary) + reign + contenders |
| `interim_secondary_line` | ICE "standing in" under champ; never second SODIUM |
| `title_bout_chip` | SELECT TITLE BOUT when stamped+flag |
| `title_pending_chip` | MUTED PENDING when `stamped==false` |
| `reign_strip` | defenses / since_week CONDITION instruments |

**Reuse:** Rankings `tab_bar`, `belt_holder_row` (upgrade), OPEN HOLDER gold, silhouettes, filter/scope from K15.

---

## Rejects

- New BELTS rail
- Dual-champion UI
- Mapping statuses to GOOD / AMBER / BAD
- GOLD on belt (M7 lost that argument — SODIUM)
- Flattening `stamped` to false
- Belt-on-scale (R42)
- Art proposals beyond citing M7

---

## C26 / M7 anchors (cite, do not re-derive)

- Reads: `get_championship_read`, `get_championships_read`, `get_bout_title_stakes`, `get_athlete_titles`
- Tokens: champion **SODIUM** · interim **ICE** · vacant **MUTED** · title flag **SELECT** · reign **CONDITION/LINK** · hold body **M6 HELD/BAD** (recognised champ only)
