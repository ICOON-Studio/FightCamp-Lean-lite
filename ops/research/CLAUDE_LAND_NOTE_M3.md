# CLAUDE LAND — Maria M3 Range Rail Pass Two (2026-09-06)

Maria Art Director finished **TASK M3 — THE RANGE RAIL, PASS TWO**. Art only.
Please land. Do not wait on Maria for more files. Do **not** expect Maria to
edit `HANDOFF.md` — write the Maria HANDOFF block yourself after land.

## What landed

- Spec: `research/M3_RANGE_RAIL_PASS2.md`
- Boards + glyphs: `DesignLibrary/screens/range/m3_*` (15 PNGs, prefix `m3_` —
  **do not overwrite** M1 `glyph_band_*` / `0*_range_*.png`)
- Staging zip: `_maria_delivery/M3_RANGE_RAIL_PASS2.zip`
- This note: `_maria_delivery/CLAUDE_LAND_NOTE_M3.md` and
  `research/CLAUDE_LAND_NOTE_M3.md`

## What it is / is not

- **Is:** silhouette glyph rebuild (the real job), corner-call board (hollow vs
  filled OURS tick), owner-row board (14px TEXT_2), post-fight range card
  design, COOL_RAMP name correction, engine-gap note for post-fight aggregation.
- **Is not:** `.gd` / `.tscn` / geometry re-spec. R37 builds the live rail from
  M1 + the settled rulings. Glyph PNGs are design refs for TechniqueGlyphs-style
  pictograms — do not import board PNGs as runtime HUD bitmaps.

## Rulings already settled (dressed, not reopened)

1. Owner = text row under rail (`RUIZ'S FIGHT` / `AT RANGE`), TEXT_2, no gold.
2. Corner call rides OURS tick: hollow GOOD = told; filled GOOD = wants;
   owner appends `STAY LONG` / `GET INSIDE` / `TIE HIM UP`.
3. Clinch lock dropped — CLINCH ordinary cell.
4. MENTAL rejected — UITokens only; CURRENT uses `COOL_RAMP[0..2]` names.
5. Rail geometry unchanged (600×80, 5 cells).
6. AAA profile parked — not this land.

## Gold

Forbidden on rail/glyphs. Post-fight card uses gold **×1** on the whole-bout
ownership line only (`Range belonged to {name}`).

## Engine gap to name in HANDOFF if useful

Post-fight card needs per-round dominant `range_band` + whole-bout owner/band
tallies. Not built yet — design is ready when aggregation exists (K22 §5).

## Pending reminder

If M1/M2 art packs are still awaiting extract/land, finish those too; M3 images
sit alongside M1 in `DesignLibrary/screens/range/` under the `m3_` prefix.
