# M4 — THE POST-FIGHT READ, THE VISUAL LANGUAGE

Maria Art Director · 2026-09-06 · art only (no `.gd` / `.tscn` / `HANDOFF.md`)

Dresses the screen a bout ends on: round cards, decision stamp, and the M3
range card slotted into one surface. Binds the fields Codex C23 is aggregating
(`cards` / `totals` / `decision` / `range`). AAA profile pack is REFERENCE
only — not extended, not cited as spec.

## What this dresses (engine-true)

1. **Round-by-round card grid** — one row per round, both fighters.
   Three scoring shapes, **one visual family** (shared chrome / row rhythm /
   column headers / J1 gutter):
   - `ten_point_must` → 10-9 / 10-8 / 10-10 + KD marks
   - `points` → raw +N per round + running totals (TKD / karate / wrestling / BJJ / sambo)
   - `ippon` → raw points; decisive end mid-card; unfought rounds honest-empty
2. **Decision stamp family** — UNANIMOUS / SPLIT / MAJORITY DECISION + draw
   types (including ones the engine cannot emit yet). Gold ×1 = verdict line
   ONLY on this surface.
3. **Range card** — M3 §D slotted into the screen (per-round dominant band +
   whole-bout owner), not floating alone. On the composed surface, ownership
   copy uses CONDITION / COOL_RAMP — not gold.
4. **Honest empties** — KO R1 almost no card; round with no standing exchanges
   = no dominant band; incomplete read says why; never fakes a value.

## What this does NOT do

- No judges as characters (names / portraits / per-judge cards / bias).
  Leave a **J1 gutter** on the card chrome — empty — so a future named-official
  card does not fight the layout.
- No screen IA beyond this surface, no rail changes.
- No `.gd` / `.tscn` / `HANDOFF.md` edits.
- No AAA profile extension.
- Doctor stoppage = BAD, never gold. IPPON / TECHNICAL SUPERIORITY = gym tone,
  never knockout treatment (`UIKit.RING_STAMPS`).

## Token map (Cage Desk boards ↔ UITokens)

Boards paint the Cage Desk presentation hexes. Runtime reads **UITokens only**
— no new tokens.

| Role on this surface | Board hex | UITokens | Notes |
| --- | --- | --- | --- |
| Ground | `#0B1220` | `GROUND` / `TRACK` family | Deep cage desk |
| Panel | `#162033` | `PANEL` / `PANEL_LO` | Card / stamp chrome |
| Panel edge | `#24324A` | `LINE` / `LINE_SOFT` | 1–2px |
| Text | `#E8EEF8` | `TEXT` | Primary |
| Muted | `#8B97AD` | `MUTED` / `TEXT_2` | Labels, empty why-copy |
| Verdict gold | `#E8B84A` | `GOLD` | **×1 = verdict word line only** |
| CONTINUE | `#2ECC71` | `GO` | Only green on this surface |
| Range / condition | `#3DB8D4` | `LINK` / cool language | Band labels, ownership on composed |
| Select | `#3A6FD8` | `GYM_DEFAULT` ladder | Reserved, not primary here |
| Warn / KD | `#E89A3C` | `AMBER` | Knockdown marks, empty-band why |
| Danger | `#E24B4B` | `BAD` | Doctor stoppage |
| CURRENT / cool | `#24486f` / `#3f86cc` / `#8cc4f4` | `COOL_RAMP[0..2]` | Range CURRENT language |
| IPPON / TECHNICAL | gym ladder hi | `gym_ladder(hi)` | Not gold, not BAD |

**Gold ×1 rule (this surface):** the decision / draw **verdict word** (and its
stamp border). Scores, KD marks, range ownership, and CONTINUE never take gold.
Finish stamps keep `RING_STAMPS` tones: KO may be gold as a *finish* stamp;
doctor = BAD; IPPON / TECHNICAL = gym.

## Card family (three shapes)

Shared chrome on every style:

- Header: `SCORECARD` · `{A} vs {B}` · `style = …`
- Columns: RND · A · B · MARKS
- Alternating `PANEL` / alt rows
- Totals strip (not gold)
- Right **J1 gutter** — empty vertical rail, labeled only as reserved

### ten_point_must
- Cells: 10 / 9 / 8 integers
- 10-8 margin called out in CONDITION on the wide winner
- KD: AMBER diamonds + `KD×N` (never fake zeros)

### points
- Cells: `+N` per round + running A/B
- `gap_win` may end on TECHNICAL SUPERIORITY (gym stamp, ≠ KO)

### ippon
- Cells: raw / IPPON marker
- Bout may end mid-card — remaining rounds: empty rows with reason
  (`empty — bout already ended by IPPON in R3`)

## Decision stamp family

From `ProfileRevampPanel.METHOD_WORDS` + `UIKit.RING_STAMPS`:

| Stamp | Tone | Emit today? |
| --- | --- | --- |
| UNANIMOUS DECISION | gold (verdict) | yes (omniscient judge → UD-shaped) |
| SPLIT DECISION | gold (verdict) | **engine gap** (needs J1 multi-judge) |
| MAJORITY DECISION | gold (verdict) | **engine gap** |
| DRAW | gold (verdict) | yes |
| MAJORITY DRAW | gold (verdict) | **engine gap** |
| SPLIT DRAW | gold (verdict) | **engine gap** |
| KNOCKOUT | gold (finish) | yes |
| TECHNICAL SUPERIORITY | gym | yes (points gap_win) |
| IPPON | gym | yes |
| DOCTOR STOPPAGE | bad | yes |
| ON THE CARDS | quiet | yes (generic decision shell) |
| NO CONTEST | amber | rare / designed |

## Range card (slotted)

From M3 §D / K22 §5 / C23 `range` block:

- Per-round: glyph + `Round N fought mostly in {BAND}` + optional share
- Whole-bout: `Fought at {BAND}` + `Range belonged to {name}`
- On **composed** screen: ownership line uses CONDITION, not gold
  (gold spent on verdict)
- Empty band: `""` + share `0.0` + why-copy — never a guessed band
- No owner: `Range owner unsettled` / `AT RANGE` — never a fake surname

## Honest empties

| Case | Visual |
| --- | --- |
| KO R1 | One scored row + empty rows with reason + KO finish stamp |
| No standing exchanges | `NO DOMINANT BAND` + why (ground / no banded action) |
| Incomplete read | `complete: false` → "Fight data incomplete", not a fake 10-10 grid |
| Contested owner | Band OK, owner copy unsettled |

## Motion (if any)

| Element | Motion |
| --- | --- |
| Verdict stamp | Border + word fade-in ~180ms |
| CONTINUE | Idle / press only (`GO`) |
| Card rows | No score ticker, no fake fill anim |
| Range rows | Static on report; no live rail pulse |

## Soft note (Claude / M3)

POCKET / CLINCH still closest at true 16px. **Not opened here** — optional
tiny POCKET tweak only if cheap later; this pack does not expand into glyph
rework.

## Engine gaps (name them; do not invent)

1. **C23 `PostFightRead.build`** — aggregation for `cards` / `totals` /
   `decision` / `range` (running in parallel). Design binds those keys.
2. **Split / majority / draw variants** — engine has one omniscient judge
   today; SD / MD / majority-split draws designed so nothing redraws when
   J1 multi-judge lands.
3. **Judges as people** — J1 study owns the model. Art leaves gutter only.
4. **Range aggregation** — same as M3 gap; C23 is the intended fill.

## File list

### Spec
- `research/M4_POST_FIGHT_READ.md` (this file)

### Boards → `DesignLibrary/screens/post_fight/`
- `m4_01_card_ten_point.png`
- `m4_02_card_points.png`
- `m4_03_card_ippon.png`
- `m4_04_decision_stamps.png`
- `m4_05_screen_composed.png`
- `m4_06_empties_unknowns.png`

### Staging
- `_maria_delivery/M4_POST_FIGHT_READ.zip`
- `_maria_delivery/CLAUDE_LAND_NOTE_M4.md`
- `research/CLAUDE_LAND_NOTE_M4.md`

## Operator / Claude land

1. Extract zip → `DesignLibrary/screens/post_fight/` (`m4_*` only; new folder).
2. Copy spec → `research/M4_POST_FIGHT_READ.md`.
3. Boards are design refs — runtime is code-drawn from UITokens + C23 read.
   Do not import board PNGs as runtime HUD bitmaps.
4. Claude writes Maria HANDOFF block; Maria does not edit HANDOFF.
5. AAA profile stays parked REFERENCE — do not pull it into this land.
