# M1 — THE RANGE, THE VISUAL LANGUAGE

Maria Art Director · 2026-09-06 · art only (no `.gd`)
Parallel with Kalli K22 (words). This file owns LOOK.

## The mark: Range Rail

Not a 5-segment progress bar. **One shared current band** plus **two desire ticks**.

| Element | Meaning | Token |
| --- | --- | --- |
| 5 cells OUT→CLINCH | Ladder (`FightRange.BANDS`) | track `TRACK`, edge `LINE_SOFT` |
| CURRENT fill | Where the fight IS | `COOL_LO` / `COOL` / `COOL_HI` |
| ▲ tick above | Where OURS wants it | `GOOD` |
| ▼ tick below | Where THEIRS wants it | `AMBER` |
| Entry toll flash | Crossing into longer man's home | `BAD` (120 ms once) |
| Clinch lock | CLINCH owned / locked | `COOL_HI` outline + LOCK cue |

**Gold is forbidden** on this instrument. Fight-surface gold stays on the loudest board action (continue / primary call), never distance.

### States

1. **Resting** — CURRENT soft cool fill; ticks idle. Default band MID.
2. **Contested** — both ticks live; tug lines; CURRENT outline pulses cool.
3. **Dragged** — CURRENT steps toward winner; cool trail; loser tick dims to `DIM`.
4. **Clinch** — CLINCH cell locks; LOCK cue; ticks may still disagree.
5. **Entry toll** (beat) — crossed cell `BAD` flash + 2px shake once, then settle.

Image: `01_range_rail_states.png`

## Placement (1920×1080)

Fixed slot **600×80**, centered under the round clock, above the stage / under the twin vitals.

- Exchange log scrolls **under** the slot; the slot does not move when the band does.
- Only the CURRENT fill (and ticks' targets) change — layout geometry is constant.

Image: `02_range_placement_fight.png` (composited on `DesignLibrary/screens/ring/02_the_round.png`)

## Motion

| Event | Duration | Easing | Notes |
| --- | --- | --- | --- |
| Band step | 280 ms | ease-out cubic | ≤1 step / exchange (~14s fight-time) |
| Contested pulse | 160 ms loop | sine | outline COOL→COOL_HI while contested |
| Dragged | 320 ms | ease-in-out | trail toward winner home |
| Entry toll | 120 ms | linear | BAD flash + one shake — only hard beat |
| Clinch lock | 200 ms + 400 ms fade | ease-out | LOCK cue; no gold |
| Prefers-reduced-motion | — | — | hard-cut CURRENT only |

Image: `05_range_motion_spec.png`

## Tale of the tape

Same Range Rail geometry pre-fight:

- CURRENT = `DEFAULT_BAND` (MID)
- Ticks = preferred homes from reach/discipline/plan (asymmetric)
- Reach delta chip: `COOL_LO` fill + `COOL_HI` text (`REACH +N`) — not gold

Image: `03_range_tale_of_tape.png`

## Band glyphs (code-drawable)

House pictogram idiom (`TechniqueGlyphs.gd`): thick white strokes, transparent ground, UI tints by state. Masters 64×64; must read at **16px**.

| Band | File | Read |
| --- | --- | --- |
| OUT | `glyph_band_out.png` | two figures far apart |
| LONG | `glyph_band_long.png` | gap still wide |
| MID | `glyph_band_mid.png` | mid gap |
| POCKET | `glyph_band_pocket.png` | close |
| CLINCH | `glyph_band_clinch.png` | overlapped + tie arc |

Sheet: `04_range_band_glyphs.png` (+ `_16.png` companions)

## Token table

| Role | Token | Hex |
| --- | --- | --- |
| Ground / panels | `GROUND`, `GROUND_2`, `PANEL` | `#1c2230`, `#242c3d`, `#2a3347` |
| Track | `TRACK`, `LINE_SOFT` | `#111621`, `#2b3340` |
| Current | `COOL_LO`, `COOL`, `COOL_HI` | `#24486f`, `#3f86cc`, `#8cc4f4` |
| Ours want | `GOOD` | `#4fc46a` |
| Theirs want | `AMBER` | `#f0a020` |
| Toll | `BAD` | `#e5433a` |
| Text | `TEXT`, `TEXT_2`, `MUTED`, `DIM` | from UITokens |

### Proposed token (optional)

If plan-home must read apart from physical want:

| Name | Hex | Role |
| --- | --- | --- |
| `MENTAL` | `#8B7AD8` | mental / tactical information |

Until accepted, plan-home annotations use `LINK` (`#7fb6ee`).

## K22 dependency

K22 owns the words on chips and callouts. This pack leaves copy slots blank or generic (`OURS` / `THEIRS` / `ON THE JAB`). Swap labels when K22 lands — geometry does not change.

## Deliverable paths

- Spec: `research/M1_RANGE_VISUAL.md`
- Images: `DesignLibrary/screens/range/*`

## Operator land

1. Copy images → `DesignLibrary/screens/range/`
2. Copy `M1_RANGE_VISUAL.md` → `research/`
3. Claude: no bitmap import into the live instrument — G1 draws Range Rail in code from this spec; these PNGs are design boards + glyph refs.
4. Do not edit `HANDOFF.md` from Maria — Claude writes the HANDOFF block after land.
