# R37 THE RANGE RAIL — digest

**COMPLETE 2026-09-06.** The distance system reaches the screen. R35 gave the
standing fight ONE contested band and R36 gave the combination a walk along
it; until now the player could only read either in the log. R37 is the
instrument, the words on it, and the log voice that matches.

## What shipped

- **`Godot/scripts/RangeRail.gd` (new, pure module, kit-built, code-drawn).**
  `build(width) -> Control` and `update(rail, fight_state, ours_side) -> void`,
  plus `owner_line()` and `band_phrase()` for the callout. M1's fixed 600×80
  slot: OURS ticks (y0 h10), five band cells (y12 h40, `TRACK` / `LINE_SOFT`,
  CURRENT filled `COOL_RAMP[1]` with `COOL_RAMP[2]` edge), THEIRS ticks
  (y54 h10, `AMBER`), owner row (y66 h14, `SIZE_LABEL` / `TEXT_2`). No gold
  anywhere — the test asserts it by walking the tree.
- **Four states, all off `fight_state`, no new sim behaviour.** Resting;
  contested (CURRENT edge pulses `COOL_RAMP[1]`↔`[2]`, 160 ms loop); dragged
  (fill steps 320 ms, the loser's tick goes `DIM` for the beat); entry toll
  (the crossed cell flashes `BAD` 120 ms — the only hard beat). A band step
  with no mover — an action's own `range_delta` — is the 280 ms ease-out.
- **`RingStagePanel.gd` mounts it**: `_range_host` built in `_ensure_built`,
  positioned in `_layout` centred horizontally at stage y=20 (between the two
  392-wide condition rails, above the figures), refreshed from `refresh()` via
  `_refresh_range()`, and **hidden whenever `phase != "STANDING"`** — K22 line
  15: on the mat, range is off and band language must not appear.
- **The log voice** in `_say_event`: an action that carries a `range_band`
  names it in K22's words (`KIAN STERLING LANDS THE CROSS IN MID`), the detail
  row says the entry toll when `entered_range` is set, and a chain says the
  walk it took (`LONG TO POCKET`). The callout keeps its one-line shape.
- **`Godot/tests/range_rail_test.gd` (new): 43/43.** Geometry and fixed
  layout, the no-gold sweep, the four states, tick placement at intent, the
  hollow/filled rule, the owner row's three readings, K22's band phrases, a
  live 40-exchange fight the rail tracks, the panel mount and the log voice.

## The four calls R37 made (M1/K22 left them open)

1. **Ownership: both survive, on different rows.** The ladder keeps M1's cells
   and ticks; the OWNER is a text row under the rail — `PARK'S FIGHT`, or
   `AT RANGE` when nobody has it, or the band name alone while the argument is
   open with no winner. A 120px cell cannot hold a surname.
2. **The corner call takes the OURS tick.** It is drawn at
   `FightRange.intent_band`, not `preferred_band`. FILLED = his own game;
   HOLLOW = a standing call, and the owner row appends it in corner voice
   (`STAY LONG` / `GET INSIDE` / `TIE HIM UP`). No third ghost tick.
3. **Clinch lock dropped** — no engine state backs it.
4. **No glyphs this stage** — TEXT labels, as M1's own boards draw them. M3
   can slot a glyph above each label later without touching layout.

Also: M1's proposed `MENTAL #8B7AD8` token was **not** added; existing
`UITokens.gd` only. M1's `COOL_LO/COOL/COOL_HI` are `T.COOL_RAMP[0..2]`.

## Notes for whoever picks this up

- **There is no prefers-reduced-motion facility in the project.** Nothing was
  invented: `grep` over `scripts/` and `tests/` finds no accessibility
  setting to read. When one is added, the hard-cut belongs on the CURRENT
  cell only (`RangeRail._animate`), and the pulse/drag/toll tweens are the
  three that must stop.
- A tick is a **bar, not a triangle**: the kit draws with styleboxes and no
  bitmaps, and an 18×10 bar reads at this size where an arrowhead does not.
- `set_meta(key, null)` REMOVES the key and `get_meta(key, null)` errors
  rather than returning the default — the rail's tween handles are read
  behind `has_meta` and cleared with `remove_meta`. Worth knowing kit-wide.
- The entry-toll cell is the **loser's intent band** (the longer man's home
  the winner had to walk through), falling back to `range_event.from`.

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/range_rail_test.gd
```
