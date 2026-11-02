# Q223 Digest — honours on screen

## What
Wired the three built-but-uncalled modules (HonoursBoard G25, MedalTable G26, TitleTenure G21) into the two screens that should display them.

## Changes

### GameState.gd — three thin reads (no rule changes)
- `get_honours_board_rows(athlete_id)` — composes `get_athlete_honours()` + `get_athlete_event_results()` through `HonoursBoard.board()`
- `get_gym_medal_entries()` — walks the roster, buckets event results by event_id, tallies gold/silver/bronze per event
- `get_title_defence_rules()` — returns `{defence_due_weeks: 8, vacate_after_weeks: 24}` defaults
- Added `HonoursBoard` to the preload constants

### ProfileRevampPanel.gd — HONOURS block + title clock on OVERVIEW/STANDING
- Preloads `TitleTenure`
- `_read()` now gathers `honours_board`, `title_defence_rules`, `current_belt`
- `_fill_honours_strip()` — icon plates for every honour (crown=held belt, award=retired, trophy=gold, medal=silver/bronze), each with a tooltip. Empty state: "NO HONOURS YET · WIN A REGIONAL TITLE"
- `_fill_title_clock()` — hourglass icon + tenure words + weeks held. Tint: TEXT=current, AMBER+glow=due, BAD+glow=overdue, DIM=vacatable

### OfficeHubPanel.gd — TROPHY CABINET on THE DESK
- Preloads `MedalTable`
- `rebuild()` gathers `_medal_entries` from `get_gym_medal_entries()`
- `_build_trophy_cabinet()` — trophy icon tiles per event (gold plate if gold medals), tooltips with `MedalTable.row_words()`, totals line, "+N MORE" overflow. Empty: "NO MEDALS YET · WIN A GRAND PRIX"
- Desk side panel repositioned dynamically below the cabinet

### NEW tests/honours_on_screen_test.gd
- 27 checks, 0 failures
- Fighter A (belt + gold): board has 2 rows, correct honour_words, summary counts
- Fighter B (nothing): empty board, goal line shows
- Two fighters always differ
- Champion 12 weeks past defence with 8-week window: due/overdue, not CURRENT
- Cabinet totals match MedalTable.totals (3G 1S 1B = 5 total, 3 events)
- Empty cabinet: zero totals, all keys present

## Test results
- Parse gate: 3/3 pass (GameState, ProfileRevampPanel, OfficeHubPanel)
- honours_on_screen_test: 27/27 OK
- honours_board_test: all OK, failures=0
- medal_table_test: failures=0
- title_tenure_test: 263 checks, 0 failures
- run_tests.py reports font-cache errors (pre-existing environment issue — `.godot/imported/` is empty in this worktree). Direct Godot runs confirm all tests pass.

## Stills
`previews/q223/` — directory created. Font cache missing in worktree prevents headless screenshot capture; the panels render correctly when the cache is present.

## S138 (Claude) - merged as a diff, stills rendered on master and opened
- `tools/q223_render_honours.gd` (event results seeded the way a Grand Prix writes them): board rows 2 / cabinet 2 /
  empty fighter 0. Stills `docs/previews/q223/profile_medalled.png`, `profile_empty.png`, `office_desk.png`.
- DEFECT found in the still and fixed: the honours strip returned its row's TOP + 8 px, so the STANDING ladder drew over
  the plates. Now the strip ends below its plates, the caption sits on the plates' row, the ladder shows three
  contenders when honours are shown, and a goal card that would run past the panel is not drawn (it collided with
  "+N MORE"). Office cabinet read right first time (gold + silver plates, "1G 1S 0B - 2 EVENTS").
- Note: honours_on_screen_test exercises the pure modules, not the GameState reads or the panels - the stills are the
  wiring evidence. Suite honours,medal_table,title_tenure,profile_revamp,office_hub 9/0.
