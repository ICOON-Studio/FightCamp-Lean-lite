# M3 — THE RANGE RAIL, PASS TWO

Maria Art Director · 2026-09-06 · art only (no `.gd` / `.tscn` / `HANDOFF.md`)

Closes the four M1 review gaps and draws K22 §5's unclaimed post-fight reading.
R37 builds the live instrument from M1 geometry + the rulings below; this pack
slots glyphs and dressed states in afterwards.

## Rulings dressed (do not re-open)

1. **Owner = 14px text row under the rail** — `RUIZ'S FIGHT` / `AT RANGE`,
   token `TEXT_2`, no gold. Ladder keeps the ticks.
2. **Corner range call rides the OURS tick** — HOLLOW outlined `GOOD` = being
   told; FILLED `GOOD` = wants. Owner row appends corner voice:
   `STAY LONG` / `GET INSIDE` / `TIE HIM UP`.
3. **Clinch lock DROPPED** — CLINCH is an ordinary cell (no LOCK cue).
4. **`MENTAL #8B7AD8` rejected** — `UITokens.gd` only.
5. **Rail geometry unchanged** — 600×80, 5 cells OUT→CLINCH. R37 builds from M1.
6. **AAA profile pack parked** — not extended here.

## COOL_RAMP name fix

M1's token table used `COOL_LO` / `COOL` / `COOL_HI`. Those constants do not
exist. The three hexes are correct and live as:

| Index | Name | Hex | Role on rail |
| --- | --- | --- | --- |
| `COOL_RAMP[0]` | (was COOL_LO) | `#24486f` | CURRENT fill resting / contested base |
| `COOL_RAMP[1]` | (was COOL) | `#3f86cc` | CURRENT outline / mid cool |
| `COOL_RAMP[2]` | (was COOL_HI) | `#8cc4f4` | CURRENT highlight / trail |

See `UITokens.gd:78`. Use the array names in all new copy.

## A. Band glyphs — silhouette language

M1 failed its own 16px bar: OUT / LONG / MID differed only by gap between two
identical stick figures. Pass two rebuilds so each band is told apart by
**silhouette shape**, not spacing.

House idiom stands: thick white strokes, transparent ground, TechniqueGlyphs
family, tinted by state at runtime. Gold never on glyphs.

| Band | Silhouette | Why it reads at 16 |
| --- | --- | --- |
| OUT | One figure + three discrete distance pips + far tip | Broken horizontal (pips), not a bar |
| LONG | One figure + solid jab-reach stroke + fist tip | Continuous horizontal from body |
| MID | Two figures + thick connecting mid-bar | H-bridge silhouette |
| POCKET | Close double-head + filled overlapping torso blob | Dense vertical mass |
| CLINCH | Two heads + X-clinch knot + ground | X mark is unique among the five |

**Files** (prefix `m3_` — do not overwrite M1):

- Masters: `m3_glyph_band_{out,long,mid,pocket,clinch}.png` (64×64 RGBA)
- Proofs: `m3_glyph_band_{out,long,mid,pocket,clinch}_16.png` (16×16 RGBA)
- Board: `m3_01_glyphs_sheet.png` — 64 + 16 (+ ×4 nearest) with names
- Board: `m3_01_glyphs_16px_row.png` — unlabeled 16px proof row on `PANEL`;
  key only in a separate strip below (the naming test)

## B. Corner range call

Board: `m3_02_corner_call.png`

- FILLED vs HOLLOW comparison on the same call target (GET INSIDE → POCKET).
- Critical case drawn three times: call standing, CURRENT still at MID, hollow
  OURS tick at the called band (LONG / POCKET / CLINCH). That gap is the point
  of a range call.
- Owner row under each: `RUIZ'S FIGHT · {CALL}`.
- THEIRS tick stays AMBER for opponent want.

Call → band map (from R36 / K22): STAY LONG→LONG, GET INSIDE→POCKET,
TIE HIM UP→CLINCH. No HOLD MID.

## C. Owner row

Board: `m3_03_owner_row.png`

| State | Copy | When |
| --- | --- | --- |
| Surname | `RUIZ'S FIGHT` | `range_owner` set |
| Neutral | `AT RANGE` | owner empty / both prefer same band |
| Contested | `AT RANGE` (surname dropped) | `range_event.contested` until settles |

14px · `TEXT_2` · no gold. Contested pulse stays on CURRENT cell (`COOL_RAMP`),
not on the owner row.

## D. Post-fight range card

Board: `m3_04_postfight_card.png`

Report surface (not live instrument). Comfortable glyph size OK.

- **Per-round** dominant band rows: "Round N fought mostly in {BAND}"
- **Whole-bout** line: "Fought at {BAND}" + "Range belonged to {name}"
- **Gold ×1:** whole-bout ownership line only (`Range belonged to Ruiz`).
  That is the single loudest element on the card. Per-round rows stay cool/slate.
  Rail itself never gold.

### Engine gap (name it; do not invent aggregation)

Engine today knows per-exchange `range_band` / `range_owner` / `range_event`.
It does **not** yet aggregate:

1. per-round dominant `range_band` (mode / time-weighted across exchanges)
2. whole-bout dominant band + owner tallies for the report line

Design is ready; the card needs those two aggregates before it can bind.
See K22 §5 and R36 shipped surface for live call plumbing (orthogonal).

## What this pack does NOT do

- No rail geometry change (R37 owns build from M1 numbers).
- No `.gd` / `.tscn` / `HANDOFF.md` edits.
- No MENTAL token.
- No clinch LOCK treatment.
- No AAA profile extension.
- Does not overwrite M1 files in `DesignLibrary/screens/range/`.

## File list

### Spec
- `research/M3_RANGE_RAIL_PASS2.md` (this file)

### Images → `DesignLibrary/screens/range/`
- `m3_01_glyphs_sheet.png`
- `m3_01_glyphs_16px_row.png`
- `m3_02_corner_call.png`
- `m3_03_owner_row.png`
- `m3_04_postfight_card.png`
- `m3_glyph_band_out.png` / `_16.png`
- `m3_glyph_band_long.png` / `_16.png`
- `m3_glyph_band_mid.png` / `_16.png`
- `m3_glyph_band_pocket.png` / `_16.png`
- `m3_glyph_band_clinch.png` / `_16.png`

### Staging
- `_maria_delivery/M3_RANGE_RAIL_PASS2.zip`
- `_maria_delivery/CLAUDE_LAND_NOTE_M3.md`
- `research/CLAUDE_LAND_NOTE_M3.md`

## Operator / Claude land

1. Extract zip or copy images → `DesignLibrary/screens/range/` (m3_* only).
2. Copy spec → `research/M3_RANGE_RAIL_PASS2.md`.
3. Live rail stays code-drawn (R37). Glyph PNGs are design refs for
   TechniqueGlyphs-style pictograms — do not import boards as runtime HUD.
4. Claude writes Maria HANDOFF block; Maria does not edit HANDOFF.
