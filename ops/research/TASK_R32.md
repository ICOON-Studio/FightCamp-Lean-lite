# TASK R32 — CLAUDE — THE DAY

Model: Opus, high effort, Fast off (the home screen, the rail's order, and
a kit family; every career session opens on this surface).

## Spec

THE DAY is the game's clock surface and its home: `CareerRoot.DEFAULT_ROUTE`
is `day_feed`, so it is where a career boots and where every CONTINUE
returns. It is not a workplace — the seven other rail items do the work. Its
whole job is to answer, in the seconds before the player presses CONTINUE:
what changed, what wants me today, and where does the day go.

It does not do that today. `DayFeedPanel.gd` (R17, 2026-09-04) drifted into a
mini-dashboard: it draws a SECOND Continue inside an action card, dumps the
whole week's calendar arrivals, and runs an alerts column that restates rail
badges. Kalli K18 (`TASK_K18.md`, `K18_DIGEST.md`, `d9dd4a9`) picks
**BRIEFING SURFACE** and locks three rejects — body Continue, hub badge dump,
full-week calendar. Codex C16 (`d05fa2e`, `C16_DIGEST.md`) closed the one read
it needed. This is a straight build: no new GameState work.

### The order, top to bottom (K18 §B)

1. **Attention strip** — ONLY when `get_day_relationship_attention()` has
   items. Chips carry tone · headline · drill. **COLD / SIMMERING never
   show** (C16 already filters heat < 30).
2. **Briefing hero** — the top headline from `get_news`.
3. **Thin ticker** — the next headlines; a quiet state is honest and fine.
4. **Today's dated events** — `continue_day_events(week)[career_day]` ONLY,
   plus offers dated today. Never the week. That dump is Reject 3.
5. **Must-answer context** — `get_open_requests()` already feeds the shell's
   Continue subtitle (`N MUST ANSWER FIRST`, `ShellChrome.gd:253`). The body
   may list the open asks as drill-ins and **MUST NOT** draw a Continue.

### Four boards, one panel differently dressed (K18 §C, §G)

- **DAY** — ordinary morning. Strip hidden. Gold ×1 on the featured TODAY
  event's OPEN.
- **ATTENTION** — the strip is loud and stacks above the hero. Gold ×1 on the
  worst chip's drill (VIEW FIGHTER / VIEW RIVAL).
- **FIGHT WEEK** — a bout is booked this week, so the day is about the
  set-piece path. Hero and stakes turn fight-week; gold ×1 on **ENTER FIGHT
  WEEK**, which routes `fight_week` (`SceneRouter.gd:119`) into SetpieceRoot.
  It is not a second SCHEDULE.
- **STATES** — first-career quiet, result morning, empty inbox, week
  boundary. Honest empties, never a fake populated board.

**Green is the shell's CONTINUE and appears nowhere in this body.** Gold is
×1 per board.

### Booked-this-week: derive it, do not add an API

K18 named a missing "bout booked this week" flag. There is no need for one.
For each roster athlete with a non-empty `booked_fight`,
`get_fight_week_card(athlete_id)` (`GameState.gd:11792`) returns `weeks_out`
and `days_out` off the real offer; `weeks_out == 0` IS fight week, and the
card already carries `opponent_name`, `event`, `venue`, `stakes` (TITLE BOUT /
RANKING FIGHT / FEATURE BOUT) for the banner. Read-only, no GameState edit.

### The rail's order (user decision, 2026-09-06)

`NAV_ITEMS` (`ManagementChrome.gd:39`) reads
`OFFICE · THE DAY · GYM · STAFF · TRAINING · SCHEDULE · SCOUTING · RANKINGS`.
That order is an accident, not a decision: `78fa4fc` (R17) spliced THE DAY in
**after** whatever was already first, and OFFICE held slot 1 only because the
legacy painted `OfficeHub` desk scene was the pre-kit "shared entry point".
R26 turned OFFICE into an ordinary hub; the menu never followed. Reorder to:

```
THE DAY · GYM · STAFF · TRAINING · SCHEDULE · SCOUTING · RANKINGS · OFFICE
```

Home first, then the workplaces, paperwork at the tail. Verified safe: no
script or test indexes `NAV_ITEMS` by position — every consumer iterates it or
checks membership, and `ManagementChrome.gd:730` walks children against
`NAV_ITEMS` in the same order, so both sides move together.

## Kit

New family **`day`**, four factories, appended to `UIKit.gd` in the tail
style of the `ring` family and registered in
`assets/data/ui_kit_manifest.json` with a family `rule` paragraph:

| Factory | What it is |
|---|---|
| `day_attention_strip` | C16 items as chips: tone band · headline · detail · drill |
| `day_event_row` | One today-only event or open ask + OPEN |
| `fight_week_banner` | Booked-bout banner → ENTER FIGHT WEEK |
| `quiet_empty_state` | Honest empty (no news / no attention / nothing today) |

Reuse first and do not re-mint: `briefing_hero` (`UIKit.gd:1307`),
`ticker_row` (`:1311`), `alert_strip` (`:1884`), `chip` (`:466`), `badge`
(`:297`), `frame` (`:560`), `button` (`:332`). **Remove this surface's use of
`action_card` + `continue_unit`.** `alerts_column` (`:1319`) leaves THE DAY —
check whether any other screen still calls it before touching it.

Book must re-render green: the manifest is at 275 variants across 22
families; `day` takes it to 26 families' worth of ids — the count in the
digest must be the number `ui_kit_book_test.gd` actually reports, not a guess.

## Reads relied on (all existing)

| Read | Use |
|---|---|
| `get_news(limit)` | hero + ticker |
| `get_day_relationship_attention()` | strip; `items[{kind,athlete_name,headline,detail,tone,urgency,route,route_args}]`, `counts`, `worst_tone` (`GameState.gd:6690`) |
| `get_open_requests()` | shell subtitle + ask drill-ins |
| `get_fight_offers()` | today-dated offers (`GameState.gd:5146`) |
| `ManagementChrome.continue_day_events(week)` | today's row only, key `career_day` (`ManagementChrome.gd:274`) |
| `get_fight_week_card(athlete_id)` | fight-week dress (`GameState.gd:11792`) |

Attention chips drill through `route` / `route_args` — C16 emits
`fighter_card` (with `athlete_id`) and `calendar` (with `offer_id`), both
live routes. Route through the existing chrome/router seam, never a new one.

## Owned files

- `Godot/scripts/DayFeedPanel.gd` — rewritten (255 lines today)
- `Godot/scripts/UIKit.gd` — APPEND the four `day` factories only
- `Godot/assets/data/ui_kit_manifest.json` — the `day` family
- `Godot/scripts/ManagementChrome.gd` — the `NAV_ITEMS` line ONLY (`:39`)
- `Godot/tests/day_feed_screen_test.gd` — rewritten for the briefing
- `Godot/tools/render_day.gd` — NEW, four boards
- `DesignLibrary/screens/day/` — the four renders
- `research/R32_DIGEST.md` — NEW

Do NOT touch: `ShellChrome.gd` (it already owns the one Continue and the
subtitle), `GameState.gd`, `CareerRoot.gd`, `SetpieceRoot.gd`, any other
hub panel.

## Anchors

- `Godot/scripts/DayFeedPanel.gd:144` — the body `continue_unit` to delete
- `Godot/scripts/DayFeedPanel.gd:194-223` — the week dump to delete
- `Godot/scripts/DayFeedPanel.gd:224-249` — the alerts column to delete
- `Godot/scripts/ShellChrome.gd:250-257` — the shell's Continue, left alone
- `Godot/scripts/ManagementChrome.gd:39` — `NAV_ITEMS`
- `Godot/scripts/CareerRoot.gd:32` — `DEFAULT_ROUTE := "day_feed"`
- `Godot/scripts/SceneRouter.gd:119` — the `fight_week` route
- `Godot/scripts/GameState.gd:6690` — C16's attention read

## Gotchas

- `DayFeedScreen.gd` is a SCENE script: it fetches GameState by path
  (`get_node_or_null("/root/GameState")`) and the panel is handed the node.
  Never name the autoload in either file.
- Hosted vs standalone: `CareerRoot.gd:155-156` sets `host_shell` /
  `host_continue`, and the panel must keep working both ways.
- `HANDOFF.md` and several tests carry MIXED line endings — patch by line
  index, never by anchor string.
- A `Label` outside a Container will not autowrap; break with `\n`.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/DayFeedPanel.gd Godot/scripts/UIKit.gd Godot/scripts/ManagementChrome.gd Godot/tests/day_feed_screen_test.gd Godot/tools/render_day.gd
```

## Test command

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/day_feed_screen_test.gd
```

Then `ui_kit_book_test.gd`, `scene_router_test.gd`, `smoke_test.gd`, and the
full suite ONCE in the background before the commit.
