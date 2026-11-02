# CLAUDE LAND — Maria packs M1 + M2 (2026-09-06)

Maria Art Director has finished two art packs. Please land them. Do not wait on Maria for more files.

### M2 — Cage Desk asset replace (ready)
- Staging zip: `_maria_delivery/M2_CAGE_DESK_DELIVERY.zip`
- Manifest: `_maria_delivery/M2_CAGE_DESK_MANIFEST.md` (also in zip)
- Unzip → place 32 PNGs into `Godot/assets/ui/` keeping K2 filenames where replacing.
- NEW plates (no prior K2 consumer): `plate_gym_floor`, `plate_fighter_identity`, `plate_ring_dual_sil`, `plate_fight_week`
- Contact sheet: `DesignLibrary/screens/cage_desk/cage_desk_pack_contact.png`
- DO NOT touch `icons/moves/` (or disciplines).
- Soft note: mild neon rim on `plate_ring_dual_sil` — acceptable ship; optional later polish.
- After land: run `technique_glyphs_test` + `smoke_test`; update `Godot/assets/ui/README.md` licence table; write Maria HANDOFF block for M2 COMPLETE; mark TASK_M2 done / claim closed; push.

### M1 — Range visual language (ready)
- Spec already at: `research/M1_RANGE_VISUAL.md`
- Boards + glyphs already at: `DesignLibrary/screens/range/` (15 PNGs)
- Staging zip: `_maria_delivery/M1_RANGE_VISUAL_DELIVERY.zip`
- Manifest: `_maria_delivery/M1_RANGE_MANIFEST.md`
- Instrument name: **Range Rail** — 5-cell ladder OUT→CLINCH, NOT a progress bar.
- CURRENT = COOL_*; OURS want tick above = GOOD; THEIRS want tick below = AMBER; entry toll = BAD flash 120ms; gold FORBIDDEN on this mark.
- Live instrument: **code-drawn** from the spec (G1 or whoever owns fight chrome). Do NOT import the board PNGs as runtime bitmaps for the indicator. Glyph PNGs are design refs for TechniqueGlyphs-style pictograms (64 master / 16 read).
- Parallel: K22 (Kalli) owns the words — swap labels when K22 lands; geometry stays.
- After acknowledge: write Maria HANDOFF block for M1 COMPLETE; mark TASK_M1 done; no need to implement Range Rail in this land unless that claim is yours — art deliverables are the boards + M1_RANGE_VISUAL.md.

### Out of scope for this land
- HANDOFF edits by Maria already avoided — Claude writes the HANDOFF blocks.
- AAA profile redesign is Maria's next art beat (not in this land).
