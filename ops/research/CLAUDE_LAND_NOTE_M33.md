# Land note: M33 (icons + type + tooltip restyle) for Claude / S79

From Maria (art direction), 2026-09-25. ART ONLY: nothing here edits .gd/.tscn/HANDOFF, and nothing was committed or pushed.

## Staging on the repo machine
- `_maria_delivery/M33/` gets everything in this folder except `_src/` and `.venv/`.
- `research/m33/` gets `M33_ICONS_AND_TYPE.md` and the four PNGs (research copy for agents).
- Runtime assets (S79 decides and lands them; they are not staged in `Godot/assets` by me):
  - `Godot/assets/fonts/InterVariable.ttf` comes from Inter-4.1.zip (rsms/inter v4.1, 879,708 B, "Version 4.001"). Add `Godot/assets/fonts/Inter-OFL.txt` (the release LICENSE.txt, copy at `_src/Inter-LICENSE.txt`).
  - `Godot/assets/icons/lucide/*.svg` gets the 24 files in `icons/`, plus `LICENSE-lucide.txt` (ISC + Feather MIT, verbatim).

## What S79 should do (in order)
1. **Fonts.** Add Inter and a UITokens FontVariation per role (M33 §2.5): `variation_opentype` sets `wght` and `opsz`; `opentype_features` sets `tnum`/`case` as the table says; label gets `spacing_glyph` +1.
2. **TipLayer + Glossary.tip_bbcode.** Swap to Inter. Surface: PANEL + 12 % rim + lifted shadow, width 360, padding 16/14. Name in sentence case at 18/600 (drop `to_upper()`), with the area glyph at 20 px and the area word. Replace the hard-coded `#f0c233` "Now:" and `#94a1b8` "Why:" with token MUTED. Value gets tnum. NOT LINKED becomes a hairline + `unlink` glyph + label + TEXT_2 reason. Keep `SHOW_DELAY 0.5`.
3. **Rail (ShellChrome).** Glyphs per M33 §1.1 at 20 px. The active bar becomes gym-hi, not GOLD. Disabled shows `lock` + a word.
4. **Handbook screen.** Area glyphs per §1.2 on 56 px plates, glyph colour TEXT.
5. **State pills** per §1.3 (glyph + word; NOT LINKED in BAD_TEXT, and TEXT on PANEL_HI).
6. **No mono for players.** CoachMarks count and buttons, `UIKit.caps()`: move them to the Inter label role.
7. **Width pass.** Inter at M32 sizes is about 1.2–1.5× wider than the live Plex 12 caps for body, rows, titles and the rail (§2.3). Re-check fixed containers.
8. **SVG import.** Replace `currentColor` with `#ffffff`, then tint via modulate. Import scale = size/24. Pre-bake `stroke-width = 48/size` per size bucket.
9. **Credits.** Add Inter (OFL 1.1), Lucide (ISC) + Feather (MIT, Cole Bemis), and correct the display-face entry: the file `BebasNeue-Regular.ttf` is **Oswald Bold 4.103**. Rename it or state that plainly.
10. **Work Sans** can be removed once nothing references it (S79's call).

## Words (for Kalli, not for S79 to invent)
- Pill words (NEEDS YOU, BOOKED, INJURED, SUSPENDED, ON WEIGHT, OFF WEIGHT), "Locked", and the sentence-case NOT LINKED reason are EXAMPLE.
- Naming clash: the Handbook area "Condition" (the body) vs the term `condition` (equipment wear).

## Open verification items
- [ ] `opentype_features` tnum/case and `variation_opentype` wght/opsz render correctly in a real 4.7.2 build (and whether opsz is automatic). NOT VERIFIED.
- [ ] ThorVG: `currentColor`, round caps, and the 2 px optical stroke at 16/20 px. NOT VERIFIED.
- [ ] Why the live `[b]` tooltip name renders regular weight in `05_tut_04_gym.png`.
- [ ] Greek/Cyrillic fighter names in Inter against real Cyprus name data.
- [ ] Player read-test of the weak glyphs: sunrise, biceps-flexed, hourglass, weight, bandage (16 px).
- [ ] Code facts were read at f5a7e14. Master is now db5cd6c; re-check TipLayer/CoachMarks/ShellChrome before editing.
