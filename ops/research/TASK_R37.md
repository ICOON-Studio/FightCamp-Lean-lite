# TASK R37 — THE RANGE RAIL (Claude)

**Status: COMPLETE 2026-09-06.** Digest `research/R37_DIGEST.md`.

Model: top tier, effort high, Fast off.

Build the instrument M1 specced and K22 ruled the reading of. R36 shipped a
distance system the player cannot see: the engine writes `range_band`,
`range_owner`, `range_event`, per-action `range_band` and the chain's
`range_walk` every exchange, and the corner menu offers three range calls —
and none of it reaches the screen except through the log. This stage converts
work already paid for into something the player experiences.

## The four decisions M1 and K22 left open — RULED HERE

The review of M1 (HANDOFF, `### MARIA - M1`) listed four things a builder had
to settle first. As lead developer I settle them now, so this stage is not
blocked. Each is a call, not a discovery: say so if you disagree.

1. **Ownership: BOTH survive, on different rows.** K22 ruled the active pip
   carries a `range_owner` surname chip; M1 spends that space on two desire
   ticks. A 120px cell cannot hold a surname. **Ruling:** the LADDER keeps
   M1's geometry (cells + ticks); the OWNER becomes a text row directly under
   the rail — `RUIZ'S FIGHT`, or `AT RANGE` when `range_owner` is empty, or
   the band name alone while `range_event.contested` is true with no winner.
   That satisfies K22's reading (whose fight, by surname, never a number)
   without cramming a chip into a cell.
2. **The corner range call gets the OURS tick.** M1 predates R36, so it has
   no mark for a standing call, and its "where OURS wants it" tick would
   contradict what the fight does. **Ruling:** the OURS tick is drawn at
   `FightRange.intent_band(fighter)`, not at `preferred_band`. When
   `range_intent` is empty the tick is FILLED (`GOOD`) — that is his own
   game. When a call is standing the tick is HOLLOW (outlined `GOOD`, no
   fill) and the owner row appends the call in corner voice — `STAY LONG`,
   `GET INSIDE`, `TIE HIM UP`. Hollow reads as "he is being told", filled as
   "he wants". Do not draw the home band as a second ghost tick; three ticks
   on one 600px rail is noise.
3. **Clinch lock is DROPPED.** No engine state backs it. CLINCH renders as an
   ordinary cell; the only thing true about it is that the ladder cannot step
   past it, which the geometry already says.
4. **Glyphs are NOT used in this stage.** M1's 16px band glyphs fail their own
   legibility bar, and the rail does not need them: cells carry TEXT labels
   (`OUT` / `LONG` / `MID` / `POCKET` / `CLINCH`), exactly as M1's own boards
   draw them. M3 (Maria) is rebuilding the glyph set in parallel and **does
   not block this stage** — when it lands, a glyph can be slotted above each
   label without touching layout.

Also ruled: **the `MENTAL #8B7AD8` token M1 proposes is REJECTED for now.**
Use existing `UITokens.gd` only. If M3 makes the case for a mental/tactical
colour across more than one surface, it can be revisited then.

**Correction to M1's token table:** there are no `COOL_LO` / `COOL` /
`COOL_HI` constants. The three hexes M1 lists are `T.COOL_RAMP[0]`,
`[1]` and `[2]` (`UITokens.gd:78`). Everything else in M1's table is real.

## The instrument

A new pure module `Godot/scripts/RangeRail.gd`, kit-built, code-drawn, no
bitmaps. One public builder plus one update call, in the shape the other kit
instruments use:

```gdscript
static func build(width: float) -> Control
static func update(rail: Control, fight_state: Dictionary, ours_side: String) -> void
```

Fixed slot **600×80**, laid out inside as:

| Row | y | h | Content |
| --- | --- | --- | --- |
| OURS ticks | 0 | 10 | tick at `intent_band(ours)`, filled or hollow per rule 2 |
| Cells | 12 | 40 | five cells, `TRACK` ground, `LINE_SOFT` edge, labels `SIZE_LABEL` `MUTED`; CURRENT cell filled `COOL_RAMP[1]` with `COOL_RAMP[2]` edge and `TEXT` label |
| THEIRS ticks | 54 | 10 | tick at `intent_band(theirs)`, `AMBER`, same fill/hollow rule |
| Owner row | 66 | 14 | `SIZE_LABEL`, `TEXT_2`; surname / `AT RANGE` / call word |

**Gold is forbidden on this instrument** — fight-surface gold stays on the
loudest board action. The band-change accent is `COOL_RAMP[2]`; the entry toll
is the only `BAD` on the rail.

States, all from `fight_state` (invent no new sim behaviour):

- **Resting** — nothing contested, ticks idle.
- **Contested** — `range_event.contested` true: CURRENT cell edge pulses
  between `COOL_RAMP[1]` and `COOL_RAMP[2]`.
- **Dragged** — `range_event.mover` non-empty: CURRENT steps one cell toward
  the mover; the loser's tick dims to `DIM` for the beat.
- **Entry toll** — `range_event.entered` non-empty: the crossed cell flashes
  `BAD` once, 120 ms, then settles. This is the only hard beat.

Motion per M1's table (band step 280 ms ease-out, contested pulse 160 ms loop,
dragged 320 ms, toll 120 ms linear). Honour `prefers-reduced-motion` by
hard-cutting the CURRENT cell only — the project reads this through the same
accessibility check the rest of the kit uses; if none exists, add nothing and
say so in the digest rather than inventing a setting.

## Mounting it

`RingStagePanel.gd` owns the fight surface. Add a `_range_host` alongside the
existing hosts, positioned in stage space **centred horizontally, under the
round clock and above the stage figures** — M1's placement board
(`DesignLibrary/screens/range/02_range_placement_fight.png`) is the reference.

- Build it in `_ensure_built` next to `_build_callout` (`:241`) and
  `_build_speed` (`:258`).
- Position it in `_layout` (`:280`) beside `_speed_host` / `_mode_chip_host`.
  The layout is FIXED: only the fill and the ticks move when the band does.
- Refresh it from `refresh(fight_state)` (`:418`), where `_refresh_rails()`
  already runs.
- Hide it whenever `fight_state.phase != "STANDING"` — K22 line 15: on the
  mat, range is off, and band language must not appear.

## The log voice

K22 section 3 asked for band-aware lines and R36 already put the vocabulary
into `FightRange.describe`. Finish the job in `_say_event` (`RingStagePanel.gd:392`):
the callout names the band when an action carries one, and says the entry toll
when `entered_range` is set. Keep it to the callout's existing one-line shape;
do not rebuild the callout.

## Owned files

- `Godot/scripts/RangeRail.gd` (new)
- `Godot/scripts/RingStagePanel.gd` (mount, layout, refresh, `_say_event`)
- `Godot/tests/range_rail_test.gd` (new)

## Do not touch

`Godot/scripts/FightRange.gd`, `Godot/scripts/FightSimulation.gd`,
`Godot/assets/data/technique_catalog.json` and
`Godot/tests/fight_combo_range_test.gd` — the catalog and that test belong to
C22, which is running in parallel. `DesignLibrary/screens/range/` is Maria's.

## Anchors

- Engine fields: `fight_state.range_band` / `range_owner` / `range_event`
  (`FightSimulation.gd:346-348`), written by `_contest_range` (`:1069`);
  `FightRange.intent_band` and `call_band`; the chain's `range_walk`.
- Ladder and bands: `FightRange.BANDS` (`:44`).
- Kit: `UIKit.gd` / `UITokens.gd`; `T.COOL_RAMP` (`UITokens.gd:78`),
  `T.TRACK` (`:30`), `T.LINE_SOFT` (`:33`), `T.GOOD` (`:67`), `T.AMBER`
  (`:68`), `T.BAD` (`:69`), `T.DIM` (`:39`), `T.SIZE_LABEL` (`:83`).
- Panel structure: `RingStagePanel.gd` `_ensure_built` (`:146`),
  `_build_callout` (`:241`), `_layout` (`:280`), `refresh` (`:418`),
  `_say_event` (`:392`).
- Art: `research/M1_RANGE_VISUAL.md`; boards
  `DesignLibrary/screens/range/`.
- Words: `research/K22_RANGE_READ.md` sections 1-3.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/RangeRail.gd Godot/scripts/RingStagePanel.gd Godot/tests/range_rail_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/range_rail_test.gd
```

Then the systems it touches — `fight_range_test.gd`, `fight_combo_range_test.gd`,
`ring_stage_test.gd` if one exists, and `smoke_test.gd` — and the full suite
once before the commit.
