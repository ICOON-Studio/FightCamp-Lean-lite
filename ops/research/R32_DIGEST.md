# R32 DIGEST — THE DAY (Claude)

Task file `research/TASK_R32.md`. Built on Kalli K18 (`d9dd4a9`) and
Codex C16 (`d05fa2e`). No GameState work: every read already existed.

## What shipped

THE DAY is the game's home and its clock — `CareerRoot.DEFAULT_ROUTE`, where a
career boots and where every CONTINUE returns. R17 built it as a mini-dashboard;
R32 rebuilds it as the **briefing surface** K18 picked, and kills the three
things that made it a second-rate hub:

| Gone | Why |
|---|---|
| Body `continue_unit` inside an `action_card` | The shell owns the ONE advance, in the top bar, with its own `N MUST ANSWER FIRST`. Two advances is a grammar break. |
| The whole week's calendar arrivals | Today only. The week is SCHEDULE. |
| The alerts column of hub counts | The rail already wears those badges. |

Order, top to bottom: fight-week banner (only in fight week) → attention strip
(only when C16 has items) → briefing hero → thin ticker → TODAY → the open asks
as drill-ins beside them.

**Gold is ONE per board and the loudest thing takes it**: ENTER FIGHT WEEK, else
the worst attention drill, else the featured TODAY row. Green never appears in
the body. On the honest-quiet board there is no gold at all, which is correct —
a morning with nothing to act on has no act, and the way on is CONTINUE.

## The rail's order (user decision, 2026-09-06)

Was `OFFICE · THE DAY · GYM · STAFF · TRAINING · SCHEDULE · SCOUTING · RANKINGS`.
Now:

```
THE DAY · GYM · STAFF · TRAINING · SCHEDULE · SCOUTING · RANKINGS · OFFICE
```

The old order was never decided. `78fa4fc` (R17) spliced THE DAY in *after*
whatever was already first, and OFFICE held slot 1 only because the legacy
painted `OfficeHub` desk scene was the pre-kit "shared entry point for the
management game". R26 turned OFFICE into an ordinary hub and the menu never
followed, so the home screen was sitting behind a hub in its own rail. No script
or test indexes `NAV_ITEMS` by position — every consumer iterates it or checks
membership — so this was a one-line change with no test repointing.

## Fight week is derived, not a new API

K18 asked for a "bout booked this week" flag. None was needed:
`get_fight_week_card(athlete_id)` (`GameState.gd:11792`) already returns
`weeks_out`, `days_out`, `opponent_name`, `event`, `venue` and `stakes` off the
real offer. `weeks_out == 0` IS fight week. Read-only, no GameState edit.

## Kit

New family **`day`**, 4 factories / 9 variants. Book is **284 variants across 23
families**, re-rendered and re-built green.

| Factory | What it is |
|---|---|
| `day_attention_strip` | C16 items as rows: tone band, who, headline, detail, drill. Takes a `gold` flag so it can surrender the board's gold to a fight-week banner. |
| `day_event_row` | One today-only event or open ask + its OPEN/ANSWER. `featured` marks the row carrying the gold. |
| `fight_week_banner` | Booked-bout banner → ENTER FIGHT WEEK |
| `quiet_empty_state` | The honest empty |

`alerts_column`, `action_card` and `continue_unit` leave this surface but stay in
the kit — the book and `ui_kit_shell_test` still exercise them.

## Two defects the renders caught

Both were invisible to the tests and only showed in the pictures:

1. **The right column was drawn over the full-width attention strip.** The strip
   spans the whole 1494 body; the MUST ANSWER column started at y=0 and covered
   the strip's detail text and every drill button — including the board's only
   gold. Both columns now start below the banner/strip.
2. **The banner's stakes chip sat on its own event line.** `TITLE BOUT` at
   `y = height - 42` and the line at `y = 86` overlapped, burying the event name.
   The chip now leads the bottom row and the line follows it.

## Files

- `Godot/scripts/DayFeedPanel.gd` — rewritten (255 → 380 lines)
- `Godot/scripts/UIKit.gd` — the four `day` factories appended
- `Godot/assets/data/ui_kit_manifest.json` — the `day` family
- `Godot/scripts/ManagementChrome.gd` — `NAV_ITEMS` reordered (one line)
- `Godot/tests/day_feed_screen_test.gd` — rewritten, 35 checks
- `Godot/tools/render_day.gd` — NEW, four boards
- `DesignLibrary/screens/day/{day,attention,fight_week,quiet}.png`
- `DesignLibrary/kit/` — renders + index re-built

`ShellChrome.gd`, `GameState.gd`, `CareerRoot.gd` and every other hub panel are
untouched.

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/day_feed_screen_test.gd
```

35/35. Full suite green.
