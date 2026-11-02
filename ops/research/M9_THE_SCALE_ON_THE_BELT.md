# M9 — THE SCALE ON THE BELT

Maria Art Director · 2026-09-07 · art only (no `.gd` / `.tscn` / `HANDOFF.md` / assets/data)

Dresses the third bout fact R42 shipped after K23's two-state kit: a stamped
title fight where the belt **could not follow the result** because a
contestant missed the contracted limit (`title_blocked_by_weight` in
`{winner_missed, both_missed}`), plus the division vacancy that reason
creates. Extends Cage Desk / M5–M8 chrome. Gym desk (schedule / rankings /
division) — never a "camp".

## Call: a belt that could not move ≠ a belt nobody was fighting for

K23 gave TITLE BOUT (stamped) and PENDING (not stamped). R42 added a third
fact with no mark. Without one, a build either flattens it to "not a title
bout" (K23 and C26 both reject) or dresses it as failure. It is neither.
**It is a rule working** — the same argument M8 won for the AUTHORED chip on
authored money.

Four marks, one schedule row and one division row, no footnote wall:

1. **TITLE BOUT** — stamped and live. M7 SELECT chrome (cite; do not redraw).
2. **PENDING** — not stamped yet. MUTED. K23 §5: `stamped == false` reads
   PENDING, never NO.
3. **BELT NOT ON THE LINE** (new) — title fight; belt cannot follow. Rule
   holding, not error / warning.
4. **VACANT ON THE SCALE** (new) — vacant because the champion missed the
   limit ≠ R7 vacant-after-move-up. Same word, different reason.

## Engine-true (invent nothing)

**Blocked title:** bout was stamped `is_title_bout`; settlement found
`title_blocked_by_weight` ∈ `{winner_missed, both_missed}`. Result stands;
belt does not move with it.

**Vacant on the scale:** division `title_status=vacant` because the recognised
champion missed contracted limit. Distinct story from R7 vacancy (champ moved
up / gave the belt away).

**Not in scope:** weigh-in surface, dual-champion UI, new belt rail, stripping
ceremony, tribunal. R42 shipped a state change, not a press cycle.

## Token map (Cage Desk boards ↔ UITokens)

Verified against `Godot/scripts/UITokens.gd` (R9 kit) + Cage Desk style guide +
M5/M6/M7/M8 spend.

| Role | Board hex | UITokens | Notes |
| --- | --- | --- | --- |
| Ground | `#0B1220` | `GROUND` / `TRACK` | Cage desk |
| Panel | `#162033` | `PANEL` / `PANEL_LO` | Cards |
| Panel edge | `#24324A` | `LINE` / `LINE_SOFT` | 1–2px |
| Text | `#E8EEF8` | `TEXT` | Primary |
| Muted | `#8B97AD` | `MUTED` / `TEXT_2` | Labels · **PENDING** · ordinary **VACANT** |
| Dim | `#5C6A82` | `DIM` | Empties · why-copy quiet |
| Title-bout flag | `#3A6FD8` | **`SELECT`** | M7 cite — stamped live TITLE BOUT |
| Champion metal | `#F2C14E` | SODIUM (Cage Desk) | **Unused here as bout mark** — M7 champion only |
| Interim cool | `#5EC8E0` | ICE (Cage Desk) | **Unused for blocked belt** — M7 interim only |
| **Blocked belt / scale candour** | `#7FB6EE` | **`LINK`** | BELT NOT ON THE LINE · VACANT ON THE SCALE reason |
| Verdict gold | `#E8B84A` | `GOLD` | **Unused — M5 verdict word** |
| Hold | `#E24B4B` | `BAD` | **Unused — M6 medical hold** |
| CONTINUE | `#2ECC71` | `GO` | **Unused** |
| Semantic ready | `#4FC46A` | `GOOD` | **Unused** — blocked ≠ ok |
| Recoverable warn | `#E89A3C` | `AMBER` | **Unused** — rule working ≠ warn |

`SELECT`, `LINK`, `MUTED`, `TEXT`, `DIM`, `GOLD`, `BAD`, `GOOD`, `AMBER`,
`GO`, `PANEL` are first-class `UITokens.gd` constants. SODIUM / ICE remain
Cage Desk conceptual (M7 spend) — verified not borrowed for blocked-belt or
scale-vacancy chrome.

### TITLE BOUT = SELECT (cite M7) — written reason

M7 already spent **SELECT** (`#3A6FD8`) on the booking-time `is_title_bout`
chip. This pack **does not redraw** that mark. SODIUM stays champion metal on
the division entry; SELECT stays the schedule flag. Task language "M7's
SODIUM" names the belt family's authority continuity — the live title bout
still points at a SODIUM champion — but the **bout mark itself** remains
SELECT. Re-spending SODIUM on the bout chip would put champion metal on a
cell the belt may later refuse to follow.

### PENDING = MUTED — written reason

K23 §5: unstamped reads PENDING, never NO. MUTED outline pill, no left-bar
alarm, no AMBER "waiting" chrome. Absence of a stamp is not a warning.

### BELT NOT ON THE LINE = LINK — written reason (USE M8 LINK candour)

A stamped title fight where the belt could not follow is **a rule holding**.
It is not an injury (BAD = M6 hold), not a recoverable warning (AMBER), not a
verdict (GOLD = M5), not a champion claim (SODIUM = M7), not an interim
(ICE = M7).

**M8 solved the nearest problem** one pack ago: candour without alarm at
ledger-row size, spent on **LINK** for the AUTHORED chip. This pack **uses
M8's LINK candour** — same argument, new domain — rather than inventing a
fourth cool or borrowing ICE (which would teach "blocked title = interim").

Treatment: LINK outline pill · left LINK bar · dashed top hairline (candour
cue, same habit as M8 AUTHORED) · label **BELT NOT ON THE LINE**. Geometry
stays the M7/M8 pill family so four marks share one row without a footnote
wall. Survives at schedule-row ~28–36 px beside TITLE BOUT and PENDING.

**Why not beat with ICE?** ICE is M7 interim — provisional claim on a living
belt. A blocked title is the opposite story: the bout was title, the belt
stayed put. Reusing ICE would collapse two truths. **LINK keeps candour;
ICE keeps interim.**

### VACANT ON THE SCALE = MUTED plate + LINK reason — written reason

Ordinary R7 / M7 vacancy is MUTED empty plate (**VACANT**). Scale vacancy
must read the same status word and a different reason at a glance.

Compound mark: MUTED VACANT plate (absence still ≠ error) + LINK sub-chip
**ON THE SCALE** (candour about *why*). Never BAD / AMBER / STRIPPED. Never
a red tribunal banner — R42 shipped no stripping ceremony. The division
overview shows both vacancies side by side without layout jump.

## Mark family (primary deliverable)

One pill geometry, four fills, readable at schedule / rankings row ~28–36 px.

| Mark | Fill | Meaning |
| --- | --- | --- |
| **TITLE BOUT** | SELECT outline + left bar (M7 cite) | Stamped live title fight |
| **PENDING** | MUTED outline | Not stamped yet |
| **BELT NOT ON THE LINE** | LINK outline + dashed hairline | Title fight; belt held by weight rule |
| **VACANT** | MUTED empty plate (M7 cite) | No holder — move-up / seed / vacated |
| **VACANT ON THE SCALE** | MUTED plate + LINK **ON THE SCALE** | Vacant because champ missed limit |

## Schedule row — four states, one skeleton

Same cell slots:

1. Bout pair names
2. Division / card meta
3. Bout-state mark (one of TITLE BOUT / PENDING / BELT NOT ON THE LINE)
4. Optional result quiet (DIM) — never GOLD verdict chrome on the blocked cell

PENDING never reads NO. BELT NOT ON THE LINE never reads STRIPPED.

## Division overview — two vacancies

Same header skeleton as M7 board 02:

- Ordinary VACANT (MUTED) — "moved up · belt given away" (R7 story)
- VACANT ON THE SCALE (MUTED + LINK) — "missed contracted limit"

Holder band stays 70 px. No second champion column. No red fill.

## Drill-in — why the belt did not move

Instrument card, not a paragraph wall:

- Contracted limit (named class)
- Made / missed (each corner) — MUTED / LINK
- `title_blocked_by_weight` reason chip in LINK
- Result stands (TEXT) · belt stays (LINK candour)

No doctor language. No commission hearing. No STRIPPED stamp.

## Rejected anti-patterns (kept deliberately)

1. **BAD / red hold plate on blocked belt** — teaches injury or bug. BAD is M6
   medical hold only.
2. **AMBER warning chrome** — teaches recoverable mistake. A rule that worked
   is not a warning.
3. **SODIUM / GOLD on the blocked bout** — teaches the belt followed / a
   verdict was the belt. Opposite of what happened.
4. **ICE on blocked belt** — collapses into M7 interim.
5. **"STRIPPED" / tribunal / press-cycle banner** — invents a ceremony R42
   did not ship.
6. **Flatten to "not a title bout"** — the lie K23 and C26 reject.

## What this does NOT do

- No `.gd` / `.tscn` / `HANDOFF.md` / `Godot/assets/data/` edits.
- No runtime bitmap import of these boards.
- No redraw of M7 TITLE BOUT / CHAMPION / INTERIM / VACANT geometry.
- No new belt rail, dual-champion UI, or weigh-in screen.
- No BAD / AMBER / GOLD / SODIUM / ICE on the new marks.
- Facility is a **gym**, never a "camp".

## Boards → `DesignLibrary/screens/belt_scale/`

| File | Content |
| --- | --- |
| `m9_01_mark_family.png` | Four marks at row size + rejects strip |
| `m9_02_schedule_row_states.png` | Schedule carrying each of the four bout states |
| `m9_03_vacant_vs_vacant_on_scale.png` | Division overview: R7 vacant beside scale vacant |
| `m9_04_drill_in_why.png` | Why the belt did not move — instrument, no paragraph wall |
| `m9_05_rejects.png` | Refused treatments + what they would teach |
| `m9_06_composed.png` | Optional gym-desk compose (schedule + division) |

All boards 1920×1080. Code-drawable from UITokens + championship / booking reads.

## Engine anchors

- R42 — `title_blocked_by_weight` ∈ `{winner_missed, both_missed}`
- K23 — TITLE BOUT / PENDING kit; RANKINGS · CHAMPIONS placement; no new rail
- R7 — vacancy after weight-class move (ordinary VACANT story)
- M7 — SELECT title flag · SODIUM champion · ICE interim · MUTED vacant
- M8 — LINK candour (AUTHORED); nearest precedent — **used, not beaten**
- M6 — BAD = medical hold only
- M5 — GOLD = verdict word only
- `UITokens.gd` — SELECT / LINK / MUTED / TEXT / DIM verified
- `STYLE_GUIDE_CAGE_DESK.md` — desk grammar

## Staging

- `_maria_delivery/M9_THE_SCALE_ON_THE_BELT.zip`
- `_maria_delivery/CLAUDE_LAND_NOTE_M9.md`
- `research/M9_THE_SCALE_ON_THE_BELT.md`
- `research/CLAUDE_LAND_NOTE_M9.md`
