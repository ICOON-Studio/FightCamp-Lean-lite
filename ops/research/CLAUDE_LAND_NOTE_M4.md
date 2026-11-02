# CLAUDE LAND — Maria M4 Post-Fight Read (2026-09-06)

Maria Art Director finished **TASK M4 — THE POST-FIGHT READ, THE VISUAL LANGUAGE**.
Art only. Please land. Do not wait on Maria for more files. Do **not** expect
Maria to edit `HANDOFF.md` — write the Maria HANDOFF block yourself after land.

## What landed

- Spec: `research/M4_POST_FIGHT_READ.md`
- Boards: `DesignLibrary/screens/post_fight/m4_*` (6 PNGs, new folder)
- Staging zip: `_maria_delivery/M4_POST_FIGHT_READ.zip`
- This note: `_maria_delivery/CLAUDE_LAND_NOTE_M4.md` and
  `research/CLAUDE_LAND_NOTE_M4.md`

## What it is / is not

- **Is:** three-shape scorecard family (ten-point / points / ippon), decision
  stamp family (UD/SD/MD + draws + finish tones), range card slotted into the
  composed screen (M3 §D), honest empties/unknowns, token map, motion note,
  engine gaps named for C23 / J1.
- **Is not:** `.gd` / `.tscn` / HANDOFF edits. No judges-as-characters. No
  rail changes. No AAA profile extension (REFERENCE only). No glyph rework
  (POCKET/CLINCH 16px soft note left for a cheap later pass).

## Gold / green / tones

- Gold ×1 on this surface = **verdict word line only** (decision/draw stamps).
- On composed screen, range ownership uses CONDITION / COOL_RAMP — not gold.
- CONTINUE = `GO` green only.
- Doctor stoppage = BAD. IPPON / TECHNICAL = gym tone ≠ KO treatment.

## Engine gaps to name in HANDOFF if useful

1. C23 `PostFightRead` aggregation binds this design (`cards`/`totals`/`decision`/`range`).
2. SD / MD / majority-split draws designed ahead of multi-judge emit.
3. J1 gutter reserved empty — no judge art until J1 rules the model.

## Land steps

1. Extract `_maria_delivery/M4_POST_FIGHT_READ.zip` (or copy boards) →
   `DesignLibrary/screens/post_fight/`.
2. Spec → `research/M4_POST_FIGHT_READ.md`.
3. Do not import board PNGs as runtime bitmaps — code-draw from UITokens + C23.
4. Write Maria HANDOFF block; mark TASK_M4 done when acknowledged.
