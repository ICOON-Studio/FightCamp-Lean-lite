# M7 — THE BELT: CHAMPION, INTERIM, VACANT

Maria Art Director · 2026-09-06 · art only (no `.gd` / `.tscn` / `HANDOFF.md` / assets/data)

Dresses the championship state R41 now tracks: `title_status ∈ {vacant, champion, interim}`
and `is_title_bout` written at **booking**. Extends Cage Desk / M4–M6 chrome.
Gym desk (rankings / division / calendar), not fight-night ceremony.

## Call: a state a *division* is in — not a body hold, not a verdict

Until R41 a title bout was discovered after the fight (whoever happened to be
the champion). Now the engine writes the flag when the bout is booked, and
every belt carries one of three statuses. M6 dressed the medical hold — the
only honest reason an interim can exist. This pack dresses what that hold
does to a **division**.

Interim is never a second keepable belt (J3 Q3). Art must not imply two
champions.

## Engine-true (invent nothing)

**Belt key:** `discipline|weight_class|sex`. One holder per key.

**Statuses:** `title_status ∈ {vacant, champion, interim}`.

**Interim rule** (`championship_rules.json`, GAME rule not a federation's):

- Window: `interim_hold_weeks = 8` over `BodyReadiness.medical_hold_until_week`.
- Created only while the recognised champion is held out past that window.
- Consumed by unification the moment the champion fights for the belt again
  (`_consume_interim`). Elevated if the interim holder wins; ended if not.
- Never a second keepable belt.

**Booking flag:** `is_title_bout` written when booked, read at settlement.
`apply_title_logic` runs only if flagged **and** both made contracted class.
An ordinary bout with the champion in it is **not** a title bout. A Grand Prix
quarter-final does not steal the belt unless flagged (R41 / J3 Q1–Q2).

**Reign fields:** `defenses`, `since_week`, `last_defended_week`. Defenses
increment only on a real title defence.

**No-belt seed:** engine refuses to seed a belt with fewer than three fighters.

**Reads:** `get_championships()`, `get_athlete_titles()`.

## Token map (Cage Desk boards ↔ UITokens)

Verified against `UITokens.gd` (R9 kit) + Cage Desk style guide + M5/M6 spend.

| Role | Board hex | UITokens | Notes |
| --- | --- | --- | --- |
| Ground | `#0B1220` | `GROUND` / `TRACK` | Cage desk |
| Panel | `#162033` | `PANEL` / `PANEL_LO` | Cards |
| Panel edge | `#24324A` | `LINE` / `LINE_SOFT` | 1–2px |
| Text | `#E8EEF8` | `TEXT` | Primary |
| Muted | `#8B97AD` | `MUTED` / `TEXT_2` | Labels · **VACANT** |
| Dim | `#5C6A82` | `DIM` | Empties why-copy |
| **Champion** | `#F2C14E` | **`sodium`** (Cage Desk) | Recognised holder — desk metal |
| **Interim** | `#5EC8E0` | **`ice`** (Cage Desk) | Provisional claim — cool rim |
| Title-bout flag | `#3A6FD8` | **`select`** / `SELECT` | Booking-time `is_title_bout` |
| Reign instruments | `#3DB8D4` | **`LINK` / CONDITION** | defenses / since / last_defended |
| Hold (body, M6) | `#E24B4B` | **`BAD`** | Champion *body* only — never interim |
| Hold-cleared cue | `#3DB8D4` | **`LINK` / CONDITION** | Week-zero warmth (M6 continuity) |
| Verdict gold | `#E8B84A` | `GOLD` | **Unused — spent on M5 verdict word** |
| CONTINUE | `#2ECC71` | `GO` | **Unused in this pack** |
| Semantic ready | `#4FC46A` | `GOOD` | **Unused** — belt statuses ≠ ok |
| Recoverable warn | `#E89A3C` | `AMBER` | **Unused** — belt statuses ≠ warn |

`sodium`, `ice`, `select`, `condition` exist conceptually from prior packs:
Cage Desk style guide (`STYLE_GUIDE_CAGE_DESK.md`), M2 plates, profile
revamp boards, M5 `SELECT` / `CONDITION` / `LINK`, M6 CONDITION lift warmth.
`GOLD`, `BAD`, `GOOD`, `AMBER`, `GO`, `MUTED`, `TEXT`, `PANEL` are first-class
`UITokens.gd` constants.

### Champion = SODIUM (not GOLD) — written reason

`UITokens.gd` originally spent GOLD on "the one primary action **and the
belt**." M5 re-spent that gold exclusively on the **verdict word**. This pack
**loses the argument for reclaiming GOLD.** A belt is a division state that
lives on rankings, calendar, and gym desk all week. If the belt wore GOLD,
every rankings glance would spend the token M5 reserved for the one word
after the fight. That teaches "championship = verdict," which is a lie: an
ordinary champ bout is not a title, and a vacant belt is not a result.

**Losing is fine.** Champion chrome uses **SODIUM** (`#F2C14E`) — the Cage
Desk world-key / desk-metal warm already on plates. Close to gold, different
role and hex. SODIUM is authority metal on the desk; GOLD remains the
verdict stamp.

### Interim = ICE (not BAD, not AMBER) — written reason

M6 reserved `BAD` for the medical hold (doctor-stop second home). The
interim exists **because** of that hold, but it is a state a *division* is
in, not a state a *body* is in. Reusing the HELD badge would teach the
player that a held champion has been stripped. **Do not reuse M6 hold
badge for interim.**

Amber is M6's recoverable competition gap. Interim is not a warning and
not an error. ICE (`#5EC8E0`) is Cage Desk's cool rim — provisional,
instrument-adjacent, visually opposite SODIUM. Outline + dashed ring, never
solid fill. Visual weight stays below the recognised champion name.

### Vacant = MUTED outline (not BAD) — written reason

Absence is not an error (same rule as M5 R1-KO empty scorecard and M6
empties). MUTED empty plate + optional DIM why-copy. Never invent a
champion. Never BAD chrome for "no belt yet" or "vacated, no successor."

### Statuses ≠ error / warning / ok

Do **not** map CHAMPION / INTERIM / VACANT onto GOOD / AMBER / BAD.
Those three tokens are medical / recovery / ready (M6). A vacant belt is
not broken. An interim is not a caution light. A champion is not "cleared."

### Title-bout flag = SELECT

`SELECT` (`#3A6FD8`) already means "this row is the active instrument
choice" on Cage Desk / profile boards. A booking-time title flag is a
calendar selection, not a verdict and not belt metal. SELECT chip
**TITLE BOUT** on the scheduled cell. Ordinary champ-on-card bouts stay
mute.

### Reign numbers = CONDITION / LINK

Same instrument cool M6 used for cage-threshold ticks. Countable, earned,
not ceremonial. No gold digits.

## Badge / mark family (primary deliverable)

One belt geometry, three fills, readable at a rankings row ~28 px and
legible at hero size without a second asset.

| Mark | Fill | Meaning |
| --- | --- | --- |
| **CHAMPION** | Solid SODIUM plate | Recognised holder on the belt entry |
| **INTERIM** | ICE outline + dashed ring | Provisional claim; same entry, `title_status=interim` |
| **VACANT** | MUTED empty plate | No holder — seed / vacated / unknown |

Left severity bar on the status chip carries the token colour (same pill
habit as M6, different tokens). Champion name weight > interim name weight.
One belt mark on the division entry — never two solid CHAMPION chips.

**M6 HELD** may sit **next to the recognised champion name** as body chrome
(the reason an interim can exist). HELD stays BAD. INTERIM stays ICE.

## Division header — no layout jump

Same slots, three fills:

1. Belt mark slot (64×64 fixed)
2. Division title (discipline · class · sex)
3. Status chip
4. Holder band (70 px fixed) — vacant copy / champ name / champ name +
   interim secondary line **inside the same band**
5. Optional reign strip (board 06)

Interim never opens a second champion column.

## Interim beside champion (hardest call)

- One belt mark (ICE while `title_status=interim`).
- Recognised name in SODIUM + optional M6 HELD body chip.
- Standing-in name in ICE + INTERIM chip only.
- Copy: "standing in" / "provisional" — never "also champion" / "co-champ."
- Engine cannot hold two champions; the surface must not imply one.

## Unification

Stakes board, not ceremony. Champion is back (hold cleared = CONDITION
warmth, not HELD). Bout is `is_title_bout`. Settlement consumes interim
either way. No podium, no confetti, no "UNDISPUTED" alphabet language,
no dual straps raised.

## Calendar

`TITLE BOUT` SELECT chrome only when `is_title_bout=true`. Champion present
on an ordinary card = no title chip, no belt mark on the cell. GP bouts
never auto-title.

## Reign numbers

`defenses` / `since_week` / `last_defended_week` as CONDITION instruments
under the SODIUM name. Defenses do **not** increment on ordinary champ
wins, GP wins, or interim standing-in wins. Vacant-title win starts
defenses at 0. Interim may show "standing since week N" in ICE — do not
present those as champion defences. Champ defenses stay on the recognised
row even while held.

## Honest empties

| Case | Visual |
| --- | --- |
| No belt (`< 3` fighters) | VACANT mark + DIM "Belt seeds at 3 fighters." Never invent #1. |
| Vacated, no successor | VACANT chip. Do not keep the old name greyed as champ. |
| Interim, name pending | ICE status on the entry · holder slot em-dash · DIM "awaiting bout." |

Empty ≠ error.

## Rejected anti-pattern (kept deliberately, as M6 kept the medical chart)

Two lies, one board (`m7_07` + labeled panel on `m7_08`):

1. **Dual champion** — two solid SODIUM CHAMPION chips / two "C" ranks.
   Teaches two keepable belts. Engine: structurally impossible (J3 Q3).
2. **Real federation belt likeness** — green-strap-and-orb (WBC-shaped),
   IBF blue plate, UFC hexagonal photo, alphabet wordmarks. Catalog belts
   are house inventions (J1 §4.1). Likeness invites trademark and teaches
   alphabet theory this game does not play.

## What this does NOT do

- No `.gd` / `.tscn` / `HANDOFF.md` / `Godot/assets/data/` edits.
- No runtime bitmap import of these boards.
- No WBC / IBF / UFC / alphabet strap or wordmark.
- No gold. No GO. No GOOD/AMBER/BAD mapping for the three statuses.
- No reuse of M6 HELD for interim.
- No ceremony / undisputed collage / dual-belt trophy case.
- Facility is a **gym**, never a "camp."

## Boards → `DesignLibrary/screens/championship/`

| File | Content |
| --- | --- |
| `m7_01_belt_status_family.png` | CHAMPION / INTERIM / VACANT · hero + ~28px rankings |
| `m7_02_division_header.png` | Vacant / champ-held+interim / active champ — same skeleton |
| `m7_03_interim_beside_champion.png` | Both names · one belt · reject dual-champ |
| `m7_04_unification.png` | Consume-interim stakes card · not ceremony |
| `m7_05_title_bout_on_calendar.png` | `is_title_bout` vs ordinary champ-on-card |
| `m7_06_reign_numbers.png` | defenses · since_week · last_defended_week |
| `m7_07_empties.png` | Three honest empties + REJECTED dual-champ / federation |
| `m7_08_composed.png` | Rankings/division surface + labeled anti-pattern panel |

All boards 1920×1080. Code-drawable from UITokens + `get_championships()`.

## Engine anchors

- `WorldPopulation.gd` — `TITLE_STATUS_*`, `apply_title_logic`,
  `may_crown_interim`, `_consume_interim`, `vacate_title`
- `championship_rules.json` — `interim_hold_weeks = 8` (GAME rule)
- `GameState.gd` — `get_championships()`, `get_athlete_titles()`
- `DesignLibrary/screens/rankings_hub/` (K15)
- `DesignLibrary/screens/medical/` (M6 hold)
- `DesignLibrary/screens/profile_revamp/` (R18)
- `J3_THE_DECISION_QUEUE.md` — D1, D2, Q1/Q2/Q3
- `M5_SCORECARD_THREE_JUDGES.md` — gold / GO / BAD continuity
- `M6_THE_HOLD.md` — hold badge family (do not reuse for interim)
- J1 §4.1 — no real org likeness

## Staging

- `_maria_delivery/M7_THE_BELT.zip`
- `_maria_delivery/CLAUDE_LAND_NOTE_M7.md`
- `research/M7_THE_BELT.md`
- `research/CLAUDE_LAND_NOTE_M7.md`
